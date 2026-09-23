# Memory map, banking and the KERNAL

## Contents

1. Address map
2. Processor port and banking
3. Vectors
4. KERNAL interrupt entry and exit
5. Zero page and low memory
6. Detecting PAL or NTSC
7. Starting a program: BASIC line and cartridge autostart
8. What decrunchers overwrite

## 1. Address map

| Range | Default contents | Notes |
| --- | --- | --- |
| `$0000`–`$0001` | 6510 processor port | Direction register and data register; see section 2. |
| `$0002`–`$00FF` | Zero page | BASIC and KERNAL workspace; see section 5. |
| `$0100`–`$01FF` | Hardware stack | The KERNAL starts it at `$FF` and uses the bottom for tape and conversion buffers. |
| `$0200`–`$03FF` | BASIC and KERNAL workspace, vectors | Vectors at `$0300`–`$0333`; tape buffer at `$033C`–`$03FB`. |
| `$0400`–`$07FF` | Screen memory | Sprite pointers at `$07F8`–`$07FF`. |
| `$0800`–`$9FFF` | BASIC program area | Programs start at `$0801`. |
| `$A000`–`$BFFF` | BASIC ROM | RAM underneath. |
| `$C000`–`$CFFF` | RAM | Free; BASIC doesn't use it. |
| `$D000`–`$D3FF` | VIC-II | Or character ROM, or RAM. |
| `$D400`–`$D7FF` | SID | |
| `$D800`–`$DBFF` | Colour RAM | 1,024 nybbles. |
| `$DC00`–`$DCFF` | CIA 1 | |
| `$DD00`–`$DDFF` | CIA 2 | |
| `$DE00`–`$DEFF` | I/O 1 | Cartridge area. |
| `$DF00`–`$DFFF` | I/O 2 | Cartridge area; a REU sits here. |
| `$E000`–`$FFFF` | KERNAL ROM | RAM underneath; hardware vectors at `$FFFA`–`$FFFF`. |

## 2. Processor port and banking

`$00` is the direction register (1 = output); the KERNAL sets it to `$2F`. `$01` is the data register; the KERNAL sets it to `$37`. Bits 2–0 of `$01` select what the CPU sees, and bits 5–3 run the cassette: bit 5 is the motor (0 = on), bit 4 reads 1 while a cassette button is pressed, bit 3 is the write line.

| `$01` bits 2–0 | Typical `$01` | `$A000`–`$BFFF` | `$D000`–`$DFFF` | `$E000`–`$FFFF` |
| --- | --- | --- | --- | --- |
| `%111` | `$37` | BASIC ROM | I/O | KERNAL ROM |
| `%110` | `$36` | RAM | I/O | KERNAL ROM |
| `%101` | `$35` | RAM | I/O | RAM |
| `%100` | `$34` | RAM | RAM | RAM |
| `%011` | `$33` | BASIC ROM | Character ROM | KERNAL ROM |
| `%010` | `$32` | RAM | Character ROM | KERNAL ROM |
| `%001` | `$31` | RAM | Character ROM | RAM |
| `%000` | `$30` | RAM | RAM | RAM |

- BASIC can't be banked in without the KERNAL: bit 1 (HIRAM) must be set for BASIC to appear. Banking out BASIC also disables a cartridge ROM at `$8000`.
- A cartridge's GAME and EXROM lines change this table. It assumes no cartridge.
- Writes to a ROM area always land in the RAM underneath, so code can fill the RAM under BASIC, the KERNAL or the character ROM without banking them out. Only reads need the RAM banked in. The I/O area is the exception: while I/O is in, writes to `$D000`–`$DFFF` go to the chips.
- `$35` is the usual choice for demos and games that own the machine: all RAM plus I/O, with the vectors at `$FFFA`–`$FFFF` in RAM.
- An interrupt can arrive while the main code has banked I/O out. A handler that saves `$01`, sets its own value (usually `$35`) and restores `$01` on exit works whatever the main code banked in. Otherwise the main code must mask IRQs while I/O is out, and the NMI still fires.

## 3. Vectors

RAM vectors, used while the KERNAL is banked in:

| Address | Vector | Default |
| --- | --- | --- |
| `$0314`/`$0315` | IRQ | `$EA31` |
| `$0316`/`$0317` | BRK | `$FE66` |
| `$0318`/`$0319` | NMI | `$FE47` |
| `$031A` | OPEN | `$F34A` |
| `$0326` | CHROUT | `$F1CA` |
| `$0328` | STOP | `$F6ED` |
| `$0330` | LOAD | `$F4A5` |
| `$0332` | SAVE | `$F5ED` |

The block `$031A`–`$0333` holds the other KERNAL I/O vectors (CLOSE, CHKIN, CHKOUT, CLRCHN, CHRIN, GETIN, CLALL and a user vector) in the same way. Fast loaders and freezer cartridges hook the LOAD and SAVE vectors.

Hardware vectors, read by the CPU from whatever `$FFFA`–`$FFFF` currently holds:

| Address | Vector | KERNAL ROM value |
| --- | --- | --- |
| `$FFFA`/`$FFFB` | NMI | `$FE43` |
| `$FFFC`/`$FFFD` | Reset | `$FCE2` |
| `$FFFE`/`$FFFF` | IRQ and BRK | `$FF48` |

With the KERNAL banked out, the CPU reads these vectors from RAM, so the program must store its own there before it enables interrupts or banks the KERNAL out.

## 4. KERNAL interrupt entry and exit

**IRQ.** The dispatcher at `$FF48` pushes A, X and Y, checks the pushed B flag, and jumps through `$0316` for BRK or `$0314` for IRQ. It takes 29 cycles after the CPU's 7-cycle entry sequence, so a handler reached through `$0314` starts 36 cycles after the interrupted instruction ends. Pointing `$FFFE` at the handler with the KERNAL banked out saves those 29 cycles, and the handler then saves its own registers. A handler reached through `$0314` exits in one of two ways:

- `jmp $EA31` runs the KERNAL's own service: it updates the jiffy clock, blinks the cursor, handles the cassette motor and scans the keyboard. It then exits through `$EA81`.
- `jmp $EA81` restores Y, X and A and returns with `RTI`.

Both need the KERNAL banked in.

**NMI.** The entry at `$FE43` runs `sei` and `jmp ($0318)`, 7 cycles after the CPU's entry sequence. It saves no registers, so a handler reached through `$0318` must save and restore its own. The default handler at `$FE47` saves A, X and Y and acknowledges CIA 2. It then jumps through `$8002` if a cartridge signature is present, runs the RS-232 NMI code, and warm-starts BASIC if RUN/STOP is held. The shared exit at `$FEBC` restores Y, X and A and returns with `RTI`.

## 5. Zero page and low memory

Free for any program:

- `$02`, and `$FB`–`$FE`. Decrunchers use `$FB`–`$FF` while they run.
- `$C000`–`$CFFF`.
- `$0334`–`$033B` and the tape buffer `$033C`–`$03FB`, when no tape I/O runs.

Compilers claim zero page as well: llvm-mos's C64 target keeps its imaginary registers at `$02`–`$21` and allocates `$22`–`$8F` itself (`llvm-mos.md`, section 2). BASIC owns `$03`–`$8F`. A program that never returns to BASIC and calls no BASIC routines may use it. The KERNAL owns `$90`–`$FF`, `$0200`–`$02FF` and `$0300`–`$0333`, and a program that calls KERNAL routines or keeps the KERNAL IRQ running must leave them alone. The KERNAL IRQ touches these every 1/60 s:

| Address | Use |
| --- | --- |
| `$91` | STOP key flag |
| `$A0`–`$A2` | Jiffy clock, incremented about 60 times a second |
| `$C5`, `$CB` | Last and current key matrix code |
| `$C6` | Number of characters in the keyboard buffer |
| `$CC`–`$CF` | Cursor blink state |
| `$D1`–`$D3`, `$F3`/`$F4` | Cursor line and colour pointers |
| `$F5`/`$F6` | Keyboard decode table pointer |
| `$0277`–`$0280` | Keyboard buffer |
| `$028D` | Shift, C= and Ctrl flags |
| `$028F`/`$0290` | Keyboard decode vector |
| `$0291` | Case-switch lock (`$80` = Shift+C= disabled) |

`$02A6` holds the KERNAL's video standard flag: 1 = PAL, 0 = NTSC.

## 6. Detecting PAL or NTSC

The KERNAL flag at `$02A6` is set at reset, but a program loaded by a fast loader or run from a cartridge may not be able to rely on it. The direct test is the highest raster line: 311 (`$137`) on PAL, 262 (`$106`) on the 6567R8 and 261 (`$105`) on the 6567R56A. Wait for bit 7 of `$D011` to be set, then record the largest `$D012` value seen before it clears. PAL-N (6572) machines report 311, like PAL, but run 65 cycles a line.

## 7. Starting a program

**BASIC start line.** A machine-code program loaded at `$0801` usually begins with a one-line BASIC program, `10 SYS 2061`, which runs the code at `$080D`:

```
$0801: $0B $08 $0A $00 $9E $32 $30 $36 $31 $00 $00 $00
```

The first two bytes link to the next line (`$080B`), `$0A $00` is line number 10, `$9E` is the SYS token, `$32 $30 $36 $31` is the text "2061", and the three zero bytes end the line and the program.

**Cartridge autostart.** At reset the KERNAL checks `$8004`–`$8008` for the signature `$C3 $C2 $CD $38 $30` ("CBM80" with the top bits of the first three letters set). If the signature is there, it jumps through `$8000` for a cold start, and its NMI handler jumps through `$8002`.

## 8. What decrunchers overwrite

A crunched program replaces itself while decrunching, and the decruncher uses memory outside the program as well:

| Decruncher | Zero page | Other memory |
| --- | --- | --- |
| Exomizer 1.x and 2.0 (default decruncher) | `$A7`, `$AE`/`$AF`, `$FB`–`$FF` | Stack page from `$0100` (about 186 bytes of decruncher code), `$0334`–`$03CF` tables. Versions 1.1.x also clobber a safety buffer just below `$0801` when the data starts below about `$0835`, and write `$07E7` to flash the screen. |
| pucrunch | `$2D`/`$2E` (left pointing at the end of the program), `$F7`–`$FF` | `$0100`–`$01E0`, `$0200`–`$0258` |

A program that works uncrunched and fails crunched has usually read a value in one of these areas, or assumed a zero or KERNAL default that the decruncher changed. Later Exomizer versions assemble their decruncher to order, so check the version in use for its exact footprint.
