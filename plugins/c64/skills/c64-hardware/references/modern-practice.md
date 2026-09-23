# Modern practice: tools, tests and build checks

C64 developers now have tools that 1980s and 1990s developers didn't: cycle-exact emulators that scripts can drive, CPU simulators for unit tests, whole-program compilers, and network deployment to real hardware. This file lists them with exact commands, and shows how to turn the machine's traps into failing builds and tests. Versions and flags were checked against each project's documentation on 23 September 2026.

**Link warning.** `codebase64.org` now redirects to an unrelated site. The Codebase64 wiki itself is still up at `codebase.c64.org` and `codebase64.net`, so link to one of those.

## Contents

1. Testing on the host with a CPU simulator
2. Testing in VICE without a screen
3. Debuggers
4. Real hardware from the network
5. Build-time checks
6. Compilers that analyse the whole program
7. Timing analysis and superoptimisers
8. What to verify, and how
9. A test harness that drives VICE

## 1. Testing on the host with a CPU simulator

A CPU simulator runs the real 6502 binary on the development machine, far faster than real time. A test can then assert on memory, registers and cycle counts. Without the VIC-II there are no badlines or sprite DMA, so a simulator's cycle count is the routine's own cost, the figure to budget with before adding DMA.

| Tool | What it gives | Commands and details |
| --- | --- | --- |
| sim65 (cc65) | Runs a cc65-built program; the program's exit code becomes sim65's | `-c`/`--cycles` prints the cycle count. `-x <n>` stops after n cycles with exit code 2. `--cpu 6502\|65C02\|6502X` (6502X adds undocumented opcodes); `--trace`. A counter peripheral at `$FFC0`–`$FFC9` latches 64-bit cycle, instruction, IRQ and NMI counts; use a snapshot build, since the last tagged release is V2.19 from 2020. |
| mos-sim (llvm-mos SDK) | Runs a `mos-sim-clang` build | `--cycles`, `--trace`, `--profile` (cycles per PC), `--cmos`. The program can read a 4-byte cycle counter at `$FFF0`. |
| py65 1.2.0 | NMOS 6502 and 65C02 in Python; easy to script | The MPU object keeps a `processorCycles` count; `py65mon` is its monitor. |
| perfect6502 | Transistor-level simulation, exact to the half-cycle | About 1/30 the speed of a real 6502. Use it as ground truth when another emulator's behaviour is in doubt. |

Test frameworks built on these:

- **sim6502**: a test DSL with `assert(cycles < 11541, …)`, `memchk(...)` and `jsr([Sym], stop_on_rts = true)`. It reads KickAssembler `.sym` files, runs with `dotnet Sim6502TestRunner.dll -s <script>`, and exits 0 or 1.
- **6502_test_executor**: JSON tests driven by ca65 debug info. They assert registers, memory, read/write counts, stack, cycle counts and timeouts, support mocks, and write LCOV coverage. Run with `6502_tester -d <dbg> -t <test>`.
- **c64unit** 0.71 runs its tests on the C64 itself or in an emulator, with 64tass, DASM, KickAssembler, ACME, ca65 or xa65. **64spec** does the same for KickAssembler.

## 2. Testing in VICE without a screen

VICE 3.10 (December 2025) is current. `x64sc` is the cycle-exact C64 emulator, and the default one since 3.4. A test run that needs the VIC-II, the CIAs or the SID runs there, without a window:

| Flag | Effect |
| --- | --- |
| `-console` | Runs without the full UI, for test programs. |
| `-default -silent` | Starts from default settings, without sound. |
| `-warp` | Runs as fast as the host allows. |
| `-autostart <file>` with `-autostartprgmode 1` | Injects a PRG straight into RAM and runs it. |
| `-limitcycles <n>` | Exits after n cycles, as a timeout. |
| `-exitscreenshot <file>` | Writes a screenshot on exit, for comparison with a stored reference image. |
| `-debugcart` | Enables the debug cartridge: a program writes a value to `$D7FF`, and VICE exits with it as its exit code. |
| `-jamaction 5` | Quits when the CPU hits a JAM opcode, so a crash fails the test at once. |
| `-moncommands <file>` with `-initbreak <addr>\|reset\|ready` | Runs monitor commands at start-up, such as loading labels (`ll`) and setting breakpoints. |
| `-binarymonitor` | Opens the binary monitor protocol on `ip4://127.0.0.1:6502` (3.5 and later; stable since 3.7). |

VICE's own test suite (VICE-testprogs, `x64sc-hooks.sh`) combines them: `-default -warp -debugcart -jamaction 1 … -limitcycles N -exitscreenshot F`. The test program writes `$00` to `$D7FF` to pass or `$FF` to fail, and a timeout exits with 1.

The **binary monitor protocol** lets another program control VICE: get and set memory and registers, set breakpoints and watchpoints with conditions, step, run until return, feed keys, grab the display, save and restore snapshots, autostart and quit. IDEs and test harnesses use it. Inside the monitor, `stopwatch` prints the CPU cycle counter, and `profile on|flat|graph|func|disass` (3.8 and later) profiles the running program.

## 3. Debuggers

- **RetroDebugger** (Marcin Skoczylas, formerly C64 65XE NES Debugger) embeds a VICE core; version 1.0.0 (June 2026) is moving it to VICE 3.10. It shows a memory map coloured by access (reads, writes, program counter) and a VIC-II view that records CPU and VIC state for every cycle of a frame. It can rewind frames and set breakpoints on PC, memory, raster line and IRQ, and on the 1541's CPU. It reads VICE and 64tass labels, and KickAssembler's `-debugdump` writes source maps for it.
- **IceBroLite** is an external debugger that talks to VICE through its monitors.
- **VS64** (VS Code) supports ACME, KickAssembler, cc65, llvm-mos, Oscar64 and BASIC, and debugs in its own 6502 simulator or in VICE through the binary monitor.
- **C64 Studio** also debugs through the binary monitor.

## 4. Real hardware from the network

The **Ultimate 64** and the **1541 Ultimate-II/II+** cartridge have a REST API (firmware 3.11 and later; password header from 3.12):

| Request | Effect |
| --- | --- |
| `POST /v1/runners:run_prg` (file attached) | Resets the machine, loads the PRG by DMA and runs it |
| `runners:load_prg`, `runners:run_crt` | Loads without running; starts a cartridge image |
| `GET /v1/machine:readmem?address=…&length=…` | Reads up to 65,536 bytes |
| `PUT /v1/machine:writemem?address=D020&data=0504` | Writes up to 128 bytes |
| `machine:reset`, `reboot`, `pause`, `resume`; `/v1/drives/<drive>:mount` | Machine and drive control |
| `GET`/`PUT /v1/machine:debugreg` (Ultimate 64 only) | Reads or writes `$D7FF`, the same register as VICE's debug cartridge |
| `PUT /v1/streams/debug:start?ip=…` (Ultimate 64 only) | Streams a per-cycle trace of 6510, VIC-II and 1541 bus accesses to UDP port 11002 |

Because `$D7FF` works in both places, one test program can report its result in VICE and on a real Ultimate 64 (VICE-testprogs has `u64-hooks.sh` for this). The debug stream measures timing on real hardware to the cycle.

Other devices:

- **Kung Fu Flash** loads CRT, PRG, D64/D71/D81 and T64 files, and accepts uploads over USB with the EasyFlash 3 protocol. Its disk emulation goes through the KERNAL's vectors, so fast loaders don't work with it.
- **TeensyROM** loads PRGs instantly and emulates cartridges. It takes remote commands over USB serial or TCP port 2112, and its TeensyROM+ model can also read and write C64 memory by DMA.
- **SD2IEC** is not a floppy emulator. It reads and writes disk images and supports some fast-load protocols (JiffyDOS, DreamLoad and others), but it can't run custom drive code, so demo loaders such as Krill's, Spindle or Sparkle need a real drive or an emulation that runs drive code.

## 5. Build-time checks

Most of the machine's traps can become build errors, which fire on every build instead of one review:

| Assembler | Checks |
| --- | --- |
| ca65 / ld65 | `.assert expr, error, "msg"`; the linker evaluates it again after placing segments. Segments take `align = $100`, `start` or `offset`. An overflowing segment fails the link ("Segment `X' overflows memory area `Y' by N bytes"). `--warn-align-waste` reports alignment padding. |
| KickAssembler | `.assert`, `.asserterror`, `.errorif (>*) != (>label), "Page crossed!"`. `.segment X [min=$c000, max=$cfff]` fails when code passes its limits. `.align $100, trailSize` aligns only when needed. `-showmem` prints the memory map; `-vicesymbols` writes VICE labels. |
| 64tass | `-Wbranch-page` warns when a branch crosses a page. `.page`/`.endpage` checks that a block stays on one page. `.cerror`/`.cwarn` fail on a condition. `--vice-labels -l file` writes VICE labels. |
| ACME | `!error`, `!warn`, `!serious`, `!align` |
| Zig (zig-mos) | `comptime` blocks with `@compileError` can check sizes, alignment and table contents in the same language as the code. |

Assertions worth adding to any project:

- An indexed table that must not cross a page, or that must start on one.
- A jump vector that must not sit at `$xxFF`.
- Branches in cycle-exact code that must not cross a page.
- Graphics that must lie inside the VIC-II bank in use, and outside `$1000`–`$1FFF` or `$9000`–`$9FFF` in banks 0 and 2.
- Screen, character set, bitmap and sprite data on their required boundaries.
- Size budgets for routines and segments that must fit a hole in the memory map.

## 6. Compilers that analyse the whole program

These compilers see the whole program at once, which 1980s compilers running on the machine itself couldn't afford:

- **llvm-mos** (SDK v23.2.0, September 2026) allocates the frames of non-reentrant functions statically, often removing the need for a soft stack. It also allocates zero page across the whole program and inlines and optimises across the program at link time, SDK libraries included. It has 16 two-byte zero-page "imaginary registers". Build with `mos-c64-clang -Os -o x.prg x.c`, and add `-Wl,--lto-emit-asm` to see the generated assembly.
- **Oscar64** (v1.32) compiles C99 and much of C++ and builds a static stack from the call graph, which fails with recursion or function pointers. `-Oz` places globals in zero page. `-e` runs the program in a built-in emulator, and `-ep` profiles it.
- **Prog8** (12.x) allocates every variable statically and emits 64tass assembly. **KickC** (last release 2022) compiles C to KickAssembler with SSA optimisation. **Millfork** (last release 2021) targets several 8-bit CPUs.
- **rust-mos** and **zig-mos** put Rust and Zig on llvm-mos. Zig's `comptime` can generate tables and specialised routines, and check them, at build time.

## 7. Timing analysis and superoptimisers

No dedicated worst-case execution time tool for 6502 code turned up, and none of the common assemblers totals cycles in its listing. The 64tass language server for VS Code shows each instruction's cycles (with `*` marking page-cross penalties) but doesn't total them. Cycle budgets are checked by measurement: a simulator's cycle counter or profile, VICE's `stopwatch` and `profile`, or a border-colour raster meter.

Superoptimisers search exhaustively for the shortest or fastest code for a small function:

- **DeiMOS** (written in Zig) reports the best trade-offs between bytes and cycles, optionally using undocumented opcodes, and reaches about 11-byte sequences in an hour on an 8-core machine. It found multiply-by-10 in 7 bytes and 14 cycles, for A ≤ 25: `asl : sta $00 : asl : rra $00 : asl`.
- **6502-enumerator** finds peephole replacements and proves them correct with the Z3 solver.

## 8. What to verify, and how

| Property | Method |
| --- | --- |
| A routine gives the right result | Compare it with a reference implementation on the host. For 8-bit inputs, and usually for 16-bit ones, test every input. |
| A routine's cycle cost | Assert the count in a simulator test, so a regression fails the build. |
| Timing that must not vary | Assert the spread between the fastest and slowest inputs. One X25519 port for the C64 (c64-x25519) moved some buffers during a refactor. Tables lost their page alignment, and the cycle spread jumped from 0 to 83,342 while every functional test still passed. Alignment assertions plus cycle regression tests now guard it. |
| Screen output | Headless VICE with `-exitscreenshot`, compared against a stored reference image. |
| Crashes and hangs | `-jamaction 5` and `-limitcycles` in every emulator test. |
| Real-hardware behaviour | The same `$D7FF` test on an Ultimate 64, and its debug stream for cycle-level timing. |

## 9. A test harness that drives VICE

A small harness around VICE's binary monitor can check a program the way a player would see it, and the way it really starts. These practices come from running such a harness across many changes:

- **One long-running emulator.** A daemon starts one VICE, lends it to one test at a time over a local socket, and quits after an idle minute. Tests then share one window and one KERNAL boot instead of starting an emulator each. A test that dies releases the emulator with its socket. The daemon and parsers are tested against a fake `x64sc` that speaks the monitor framing, so those tests never start VICE.
- **Load the way a user would, into a machine that isn't clean.** Power-cycle the machine and inject the PRG into RAM, as a KERNAL load would, leaving uninitialised memory with the pattern a real C64 powers on with: VICE fills RAM with alternating blocks of `$00` and `$FF`, not zeros. The program's own start-up code must then clear what it relies on. To check a warm restart, fill `.bss` and zero-page `.bss` with `$AA`, re-enter the program without reloading it, and read the bytes back.
- **Find variables through debug information.** Keep the ELF unstripped and read each global's address from its DWARF location, not from the symbol table. An optimiser may split a global struct into one object per field (DWARF `DW_OP_piece` entries record where each landed), and may re-encode a field, for example shrinking an enum to a bool with the opposite encoding. The symbol table then describes no object the source declares.
- **Drive scenarios through memory.** Between frames, write the program's state through those addresses (a value, a counter, a flag), advance a frame, and check the result on screen and in memory.
- **Independent expectations.** Compare screen and colour RAM with layouts written by hand in the test, and graphics with the source art. Don't use expectations computed by the program's own layout code, which would repeat its mistakes.
- **Both video standards.** Run every screen check on PAL and NTSC. `-VICIIborders 3` makes a screenshot exactly the 320 × 200 display window on both, so a test needs no per-standard offsets. The CRT filter doesn't affect screenshots.
- **Count frames.** With interrupts off, advancing the emulator by one frame must advance the program's frame counter by exactly one. Assert it, and a missed frame fails the test.
- **Check the build before the emulator.** Reading the ELF first catches broken builds cheaply. One example: with llvm-mos, a program with a non-empty `.bss` must define `__do_zero_bss` (`llvm-mos.md`, section 7).
- **Expected exit codes.** VICE exits with 1 when it reaches `-limitcycles`. A harness that stops it that way treats 1 as success when the screenshot exists.
- **Few emulator runs.** Pure checks, such as parsers, layouts and glyph encodings, run on the host. Only what needs the machine goes to the emulator.
- **macOS.** Homebrew's VICE aborts at start-up with "No GSettings schemas are installed" unless `GSETTINGS_SCHEMA_DIR` points at Homebrew's `share/glib-2.0/schemas`.

