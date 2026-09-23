# Code patterns: raster chains, sequencing, long work in interrupts

These patterns make interrupt-driven code readable and easy to change at little or no run-time cost. The first two come from Trident/Fairlight's talk "Two Tricks That Will Make You A Ridiculously Productive C64 Demo Coder" (Fjälldata 2025). The versions here fix two bugs in the talk's code, noted where they occur.

The macros use KickAssembler syntax, as the talk did. Other assemblers can express the same macros: in ca65, use `.macro` with `.local` labels; in ACME, `!macro` with `.`-prefixed local labels. They assume the KERNAL is banked out, with the vectors at `$FFFA`–`$FFFF`.

## Contents

1. Anonymous raster handlers
2. Protothreads for sequencing across frames
3. Long work inside an interrupt
4. Choosing structure
5. A pure core with the hardware at the edges

## 1. Anonymous raster handlers

A chain of named handlers (`irq1`, `irq2`, `irq2b` …) scatters one frame's schedule across many routines, and every change to the schedule edits several of them. With an `irq_wait(line)` macro, the whole frame is one routine. Each wait point arms the next interrupt with the address just after itself, restores the registers and returns. The next interrupt resumes on the following line of code.

```
.macro irq_enter() {
        pha
        txa
        pha
        tya
        pha
        lda $01
        pha
        lda #$35        // known banking, whatever the main code set
        sta $01
        lda #$ff
        sta $d019       // acknowledge first, with a store
}

.macro irq_exit() {
        pla
        sta $01
        pla
        tay
        pla
        tax
        pla
        rti
}

.macro irq_arm(handler, line) {
        lda #<handler
        sta $fffe
        lda #>handler
        sta $ffff
        lda #<line
        sta $d012
        lda $d011
        and #$7f
        ora #((line & $100) >> 1)   // bit 8 of the line into bit 7
        sta $d011
}

.macro irq_wait(line) {
        irq_arm(next, line)
        irq_exit()
next:   irq_enter()
}
```

A frame then reads top to bottom:

```
frame:  irq_enter()
        jsr top_work
        irq_wait($80)
        jsr split_work
        irq_wait($e0)
        jsr bottom_work
        jsr play_music
        irq_arm(frame, $30)     // back to the top for the next frame
        irq_exit()
```

- **Cost.** Each wait point assembles to the same instructions a separately named handler would end and begin with, so the pattern costs nothing extra at run time or in memory.
- **Loops over lines.** A wait inside a loop, with the line taken from a variable (`lda line` in place of `lda #<line`, and the bit-8 logic computed at run time), runs the same work every 8 lines or at moving positions without writing a handler per line.
- **Fix to the talk's version.** The talk acknowledged `$D019` at the end of each handler with `asl $d019`, after arming the next line. That acknowledgement can clear a request for the new line that arrived in between, and `asl` fails on a 65816. `irq_enter` here acknowledges first, with a store.
- **Caveats.** The chain's state is the IRQ vector itself, so code that restarts the effect must re-arm the chain at `frame`. A wait whose line has already begun when it is armed stalls the chain for a frame (see `interrupts.md`, section 4).

## 2. Protothreads for sequencing across frames

A demo part or a game scene often runs a timeline: show the logo after 2 seconds, the text 1 second later, fade out after 10. Flags and frame counters scattered through the code make such a timeline hard to read and hard to change. A protothread makes the timeline straight-line code. It is a stackless coroutine: 2 bytes hold the address to resume at, and one `jmp` through them, called once per frame, continues where the sequence last stopped.

```
pt_logo:        .word logo_sequence     // resume address; keep it off a page's last byte

run_logo:       jmp (pt_logo)           // call once per frame: jsr run_logo

logo_sequence:
        pt_wait(pt_logo, 2 * 50)
        jsr show_logo
        pt_wait(pt_logo, 1 * 50)
        jsr show_text
        pt_wait(pt_logo, 4 * 50)
        jsr start_scroll
        pt_stop(pt_logo)

.macro pt_wait(pt, frames) {            // frames: 0-255
        lda #<wait
        sta pt
        lda #>wait
        sta pt + 1
        lda #frames
        sta count + 1                   // start the countdown on arrival
wait:
count:  lda #0                          // self-modified: frames left
        beq done
        dec count + 1
        rts
done:
}

.macro pt_stop(pt) {
        lda #<stopped
        sta pt
        lda #>stopped
        sta pt + 1
stopped:
        rts
}
```

- **Cost.** Each call costs 27 cycles while the thread waits: `jsr` 6, `jmp ()` 5, then `lda #` 2, `beq` 2, `dec abs` 6 and `rts` 6. The thread needs 2 bytes of state.
- **Timing.** The code after `pt_wait(pt, n)` runs on the n-th call after the call that reached the wait. At 50 calls a second on PAL, `2 * 50` is 2 seconds; on NTSC the same count is 1.67 seconds.
- **Fix to the talk's version.** The talk's counter (`count: lda #0 : inc count+1 : cmp #ticks`) was set only by the assembler. A sequence that plays a second time, in a looping part or after a restart, finds the counter left at ticks + 1 and waits about 255 frames longer. Its first wait also lasts ticks + 1 frames. This version loads the counter each time the wait begins.
- **Limits.** A thread can only wait at its own top level, not inside a subroutine it calls, because it has no stack of its own. A sub-sequence that must wait gets its own protothread, which the parent calls each frame until it finishes. Only one caller may run a given thread.
- **Other languages.** Adam Dunkels's protothreads for C (`PT_BEGIN`, `PT_WAIT_UNTIL`, `PT_END`) build the same thing from a `switch` on a stored line number, and they work with cc65 and llvm-mos. Local variables don't survive a wait, so keep the thread's state in statics. In any compiled language, a stored resume state and a `switch` give the same structure.

## 3. Long work inside an interrupt

Code that runs inside a raster handler blocks every later split until it returns, because the I flag stays set. To run a long job, such as music, decrunching or a scroller update, from an interrupt without delaying the splits below it, let later interrupts nest on top of it:

```
        // inside a handler, after acknowledging and arming the next interrupt:
        lda busy
        bne skip                // the job is still running from an earlier frame
        inc busy
        cli                     // later raster interrupts may now run on top
        jsr long_job
        sei
        dec busy
skip:   irq_exit()
```

- Every handler that can nest must save registers on the stack, not in fixed zero-page bytes or self-modified code, because a nested handler would overwrite them.
- Each nesting level uses stack space: at least 3 bytes for the interrupt, plus whatever the handler pushes.
- The `busy` flag stops a job that overruns a frame from starting again on top of itself.

## 4. Choosing structure

Structure that assembles to the code you would write by hand, such as the macros in section 1, costs nothing. Structure that costs a few cycles a frame, such as a protothread, is cheap next to a frame's 19,656 cycles, and it makes timelines and raster schedules readable and editable. Save cycle-level hand-tuning for the code that runs many times a frame.

## 5. A pure core with the hardware at the edges

A program written in a compiled language, or in assembly with a host-side simulator, can keep most of its code testable on the development machine. The C64-specific part then shrinks to a thin layer that the tests don't need.

- **Rules in a pure module.** Game or program rules live in one module that touches no hardware register and no mutable global, and that also builds for the host. The host tests can then run it exhaustively. Rules mutate the state through a pointer; they don't copy the state each frame.
- **Hardware modules as thin wrappers over pure parts.** A graphics or input module splits into pure functions and the few stores that touch the chips. The pure functions cover coordinate splitting (X into a low byte and bit 8), sprite-block layout, mirroring and decoding. The host tests cover those functions and never call a wrapper, because a store to a C64 address would crash the host. The wrappers declare their own volatile pointers at fixed addresses, so the module still builds for the host.
- **Shadows and changed-only drawing.** Each wrapper keeps a shadow of what it last wrote, and a call that changes nothing writes nothing. Screen fields redraw only when their value changes. An idle frame then costs almost nothing, and a frame's work scales with what changed.
- **Interrupts set flags; the main loop does the work.** Compilers that give functions static frames, such as llvm-mos (see `llvm-mos.md`), can't re-enter a function. An interrupt handler that calls the main code corrupts that code's locals. Let the handler set a flag or advance a counter, and let the main loop act on it.
- **Determinism.** Keep the random generator's state inside the program state, seeded explicitly, and never take randomness from the SID's noise channel or from raster timing. The same inputs then produce the same state, so a recorded input log replays exactly, and a test can reproduce any run. When seeding a small generator, replace a zero seed with a fixed constant and step it several times, so that nearby seeds diverge.
- **Input as edges.** Compute presses as held AND NOT held-last-frame, and ignore a control held at start-up until it is released.
- **Time from the frame counter.** Derive cyclic animation from a frame counter instead of separate timers. Frame-counted timing runs 20% faster on NTSC; decide explicitly whether that is acceptable, or scale by the video standard.
- **Data as text, compiled at build time.** Keep art and tables as diffable text in the repository, and parse them at compile time: Zig's `comptime`, KickAssembler scripts or a build step. The parser rejects malformed rows, duplicates and missing entries with a compile error that names the item. Derived tables, such as a 256-byte bit-reversal table for mirroring sprites, are generated the same way, instead of storing mirrored copies of the data.
- **State with a fixed layout.** Saveable state is a fixed-layout record (an `extern struct` in Zig, a plain `struct` in C), with compile-time checks on its size and on the absence of padding. Its bytes are then identical on the host and on the C64, and tests can compare records byte for byte.
- **Compile-time composition.** Compose with compile-time generics or macros rather than function pointers. Indirect calls hide the call graph that static stack allocation depends on (`llvm-mos.md`, section 3).
- **Tables as arguments.** Rules that take their tuning table as an argument, instead of reading a global, can be tested with tables that differ from the shipped one.
- **Long catch-up work.** A computation that replays thousands of ticks, such as catching up after a long pause, takes seconds on a 1 MHz CPU. Budget for it, and show the player a message while it runs.

