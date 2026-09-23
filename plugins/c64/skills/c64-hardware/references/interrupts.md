# Interrupts, raster timing and owning the machine

This file covers the procedures that span several chips. Register details are in `vic-ii.md` and `cia.md`, and instruction costs in `6510.md`.

## Contents

1. Entry costs
2. Setting up a raster interrupt
3. The handler: saving, acknowledging, arming the next line
4. Chaining and missed lines
5. Owning the NMI and RUN/STOP+RESTORE
6. Polling the raster
7. Jitter and stable rasters
8. Timer-driven interrupts

## 1. Entry costs

The cost counts from the end of the interrupted instruction to the handler's first instruction:

| Path | Cycles | Registers saved |
| --- | --- | --- |
| IRQ through `$FFFE`, KERNAL banked out | 7 | none |
| IRQ through the KERNAL (`$FF48`, then `$0314`) | 36 | A, X, Y |
| NMI through `$FFFA`, KERNAL banked out | 7 | none |
| NMI through the KERNAL (`$FE43`, then `$0318`) | 14 | none |

Saving and restoring A, X and Y costs 13 cycles with `pha`/`txa`/`pha`/`tya`/`pha` and 16 with the matching `pla` sequence. Stores to zero page and loads back cost 9 and 9. So do self-modified restores (`sta ra+1` … `ra: lda #0`), which cost 4 + 2 per register and use no zero page. Neither shortcut survives re-entry: a nested interrupt that uses the same bytes overwrites them.

## 2. Setting up a raster interrupt

With the KERNAL banked out, the usual choice for a program that owns the machine:

```
        sei
        lda #$35        ; RAM everywhere except I/O
        sta $01
        lda #$7f
        sta $dc0d       ; disable every CIA 1 source (the KERNAL's timer IRQ)
        sta $dd0d       ; disable every CIA 2 source
        lda $dc0d       ; clear anything already pending
        lda $dd0d
        lda #<irq
        sta $fffe
        lda #>irq
        sta $ffff
        lda #<nmi
        sta $fffa
        lda #>nmi
        sta $fffb
        lda #$30        ; first compare line, bits 7-0
        sta $d012
        lda $d011
        and #$7f        ; compare bit 8 = 0
        sta $d011
        lda #$01
        sta $d01a       ; enable the raster source only
        sta $d019       ; clear a pending raster flag
        cli
        ...
nmi:    rti
```

With the KERNAL banked in, the vector is `$0314`/`$0315`, and the handler ends with `jmp $EA81` to restore the registers and return, or with `jmp $EA31` to run the KERNAL's own service first. If CIA 1's timer interrupt stays enabled so that the KERNAL keeps scanning the keyboard, two sources share the IRQ. The handler must then read `$D019` bit 0 to tell a raster interrupt from a timer one, and read `$DC0D` to acknowledge the timer.

## 3. The handler: saving, acknowledging, arming the next line

```
irq:    pha
        txa
        pha
        tya
        pha
        lda $01         ; optional: run under a known banking,
        pha             ; whatever the main code had set
        lda #$35
        sta $01
        lda #$ff
        sta $d019       ; acknowledge first
        ...             ; the work
        lda #<next      ; arm the next interrupt
        sta $fffe
        lda #>next
        sta $ffff
        lda #$80
        sta $d012
        pla
        sta $01
        pla
        tay
        pla
        tax
        pla
        rti
```

- **Acknowledge with a store, and do it early.** The VIC-II keeps raising the IRQ until the raster bit in `$D019` is cleared by writing 1 to it. A store works on every CPU. `inc $D019` and `asl $D019` work on the 6510 only because a read-modify-write writes the old value back first, and they fail on a 65816 in native mode, such as a SuperCPU. Acknowledge before arming the next line. An acknowledgement after arming can clear a request for the new line that arrived in between, and the chain then loses that interrupt.
- **Set bit 8 of the compare line.** A compare line above 255 needs `$D011` bit 7 set. Reading `$D011` returns the current raster's bit 8 in bit 7, not the compare bit, so write the whole register with bit 7 chosen explicitly: `lda $d011 : and #$7f : ora #bit8 : sta $d011`.
- **Save `$01` in the handler** when the main code changes banking. The handler then finds I/O whatever the main code banked in, and the main code no longer needs to mask interrupts around its own banking.
- **The decimal flag.** Interrupt entry doesn't clear it. A handler that adds or subtracts while the main code may be in decimal mode needs its own `cld`; `rti` restores the old flag.

## 4. Chaining and missed lines

A raster compare fires only when the raster reaches the compare line. If a handler arms line L after line L has already started, no interrupt comes until line L in the next frame, and the chain stalls for a frame. Leave at least one line between the end of a handler's work and the next compare line. Where the margin is tight, read `$D012` after arming, and if the raster has already reached the line, fall through into the next handler's code instead of returning.

A chain of separate handlers, each arming the next, is the plain form. Writing the whole frame as one routine that arms the next line and returns at each wait point costs the same at run time and is easier to edit; `patterns.md`, section 1, gives the macros.

## 5. Owning the NMI and RUN/STOP+RESTORE

`sei` masks only the IRQ. The RESTORE key pulls the NMI line, and with the KERNAL in, its handler (`$FE47`) warm-starts BASIC through BASIC's warm-start vector at `$A002` when RUN/STOP is held. Once BASIC ROM is banked out, that vector is program RAM, so the program resets or crashes. There are two fixes:

- Point the NMI vector at a bare `rti`: `$FFFA`/`$FFFB` with the KERNAL out, or `$0318`/`$0319` with it in. With the KERNAL in, `$0318` can point at `$FEC1`, the `rti` that ends the KERNAL's own interrupt exit, so no RAM is needed. The KERNAL's NMI entry at `$FE43` pushes nothing before `jmp ($0318)`, so that `rti` returns cleanly. Every stock KERNAL revision holds `$40` at `$FEC1`; replacement KERNALs such as JiffyDOS are unverified.
- The NMI can arrive between the two writes of a vector update, and nothing masks it. Order the writes so every intermediate value is a valid handler. From the KERNAL's default `$FE47` to `$FEC1`, write the high byte first: the vector then reads `$FE47` or `$FEC1` at every moment.
- Start CIA 2 timer A in one-shot mode with its interrupt enabled, point the NMI vector at an `rti`, and never read `$DD0D`. The NMI line stays low, and because the NMI is edge-triggered, RESTORE can't raise another one.

A running fast loader or an NMI-driven effect may use CIA 2 itself. Check before taking it over.

## 6. Polling the raster

A loop that waits for `$D012` to equal a line misses it whenever something holds the CPU for longer than a line: the KERNAL's IRQ, an NMI, or a long routine. The loop then waits a whole frame. Poll for "at or past" the line instead, or mask interrupts during the poll. `$D012` holds only bits 7–0. On PAL, lines 0–55 share their low byte with lines 256–311, so check `$D011` bit 7 as well, or poll for a line that only occurs once (56–255 on PAL).

To run a main loop once per frame, wait while the raster is on the chosen line, then until it reaches that line again; a loop that finishes early then can't run twice in one frame. Line 251 (`$FB`) is the first line below the display window on both PAL and NTSC, so work done after the wait starts in the lower border, and its low byte alone identifies it, because 251 + 256 exceeds any frame's line count.

## 7. Jitter and stable rasters

A raster interrupt starts after the instruction in progress finishes, so its first cycle varies by up to 7 cycles (8 with the undocumented `(zp,x)` and `(zp),y` read-modify-writes). A badline or sprite DMA can delay it further.

| Needs a stable raster | Works without one |
| --- | --- |
| Colour changes in the middle of a line | Raster bars in the border (the change lands inside the border) |
| Opened side borders | Opened top and bottom borders |
| FLI driven by one interrupt per forced line | FLI that forces every line in one loop (each badline re-syncs the CPU) |
| Cycle-exact effects such as VSP | FLD, sprite multiplexers, scrollers |

Methods, with their costs:

- **Double IRQ.** The first interrupt arms a second one for the next line, then runs a string of `nop`s, so the second interrupt arrives during a 2-cycle instruction and jitters by at most 1 cycle. A final compare of `$D012` and a branch absorb that cycle. It costs about a line of CPU time and needs no extra hardware.
- **Sprite sync.** A read-modify-write instruction that is stalled by a sprite's DMA ends at a fixed cycle after the DMA. It needs a sprite enabled on that line.
- **Badline sync.** Triggering or meeting a badline stalls the CPU until cycle 55, a fixed point. It is simple, but it changes the display on that line.
- **Timer measurement.** A CIA timer locked to the line length (see `cia.md`, section 3) tells the handler how late it is: `lda $dc04 : eor #$0f : sta branch+1 : branch: bpl *` jumps into a run of `nop`s. It costs about 22 cycles per interrupt.
- **Timer as jump address.** Stop timer A with a `JMP` opcode (`$4C`) and a handler's low byte in its registers (`$DC04`, `$DC05`), and point the interrupt vector at `$DC04`. The running timer B's low byte (`$DC06`) then supplies the jump's high byte, so each jitter value lands in its own page of handlers. It costs 6 cycles in the worst case and 8 pages of memory. The handler pages sit at fixed addresses tied to the timer values, so the code can't move without retuning.

Every timer-based method must detect at start-up which CIA it runs on: the 8521 raises its interrupt 1 cycle before the 6526.

## 8. Timer-driven interrupts

A CIA timer can fire at any cycle of any line, where a raster interrupt fires at the start of a line. A handler started by a timer reaches its register write without a run of `nop`s. CIA 2's timers raise NMIs and are free in most programs, which makes them the usual choice for effects that need many interrupts per frame.

Keep boundary checks out of a frequent interrupt. Let a rare interrupt, such as a raster interrupt at the top and bottom of an effect, switch the frequent one on and off by writing the CIA's interrupt mask. The handler that runs dozens of times a frame then tests nothing.
