---
name: c64-hardware
description: Commodore 64 reference with exact numbers: 6510 opcodes and cycle counts, VIC-II registers and raster timing, raster interrupts, CIA, SID, the memory map and KERNAL vectors, llvm-mos and zig-mos, plus code patterns, measured routines (crunchers, loaders, multiply, random numbers, sorting) and modern test and build tools. Use it whenever you write, review, plan or debug C64 or 6502 code in any assembler or compiler, or answer a question about a C64 address, register, cycle count or timing.
---

# Commodore 64 hardware reference

This skill holds the machine's facts (addresses, bit layouts, cycle counts, timing) and the procedures and patterns built on them. Look a number up here before you use it. Models recall C64 details plausibly but not reliably, and on this machine one cycle or one bit decides whether code works.

## How to use it

Find the file for the question in the index, then read the section it names. Each file starts with a table of contents. The files are Markdown tables and short notes, so `grep -n` for an address or mnemonic finds its row. When you cite a number, name the chip or video standard it applies to. PAL and NTSC differ in cycles per line, lines per frame, clock speed and music pitch, and chip revisions differ in timing details.

The files are in `${CLAUDE_SKILL_DIR}/references/`.

## Index

| File | Read it for |
| --- | --- |
| `6510.md` | Cycle rules; all 256 opcodes with cycle counts, grouped by stability; what the undocumented opcodes do; NMOS quirks; delay idioms |
| `vic-ii.md` | Chip models and frame timing; every register bit; banks and memory placement; display modes; screen geometry; the cycle schedule of a raster line; badlines; sprites and multiplexing; border tricks, FLD, FLI, VSP; colours |
| `cia.md` | Registers; interrupt control; timers and raster-locked timers; time-of-day clock; keyboard matrix and joysticks; the serial bus and VIC bank bits; the 6526 against the 8521; KERNAL use |
| `sid.md` | Registers and which can be read; frequency maths for PAL and NTSC; envelope rates; the 6581 against the 8580; hard restart; random numbers; player timing |
| `memory-map.md` | Address map; processor-port banking; vectors; KERNAL interrupt entry and exit costs; zero-page use; PAL/NTSC detection; program start; decruncher footprints |
| `interrupts.md` | Entry costs; setting up raster interrupts; acknowledging and arming; missed lines; owning the NMI and RESTORE; raster polling; stable-raster methods and their costs; timer-driven interrupts |
| `patterns.md` | Raster chains written as one routine; protothreads for timelines across frames; long work inside an interrupt; when structure is worth its cost |
| `algorithms.md` | Measured routines and their costs: crunchers, disk loaders, multiply, square root, division by constants, random number generators, fixed-time idioms, multiplexer sorts, PC-side graphics conversion, sample playback, game logic, text compression; open opportunities |
| `llvm-mos.md` | llvm-mos and zig-mos: imaginary registers and zero page, static stack and reentrancy, calling convention, interrupt attributes, inline assembly, C64 start-up and restart, linker scripts, what compiles badly, optimiser surprises, rebuilding the SDK |
| `modern-practice.md` | Host-side CPU simulators and test frameworks; headless VICE flags and the `$D7FF` test exit; debuggers; Ultimate 64 REST API; build-time assertions per assembler; whole-program compilers; superoptimisers; what to verify and how |

## Conventions

Addresses and opcodes are hexadecimal with a `$` prefix. Cycle counts are CPU cycles at the system clock: 985,248 Hz on PAL and 1,022,727 Hz on NTSC. Raster-line cycles are numbered from 1 (1 to 63 on PAL), as in `vic-ii.md`.

## Sources

Most hardware tables were rewritten from *All About Your 64* (AAY64) by Ninja/The Dreams, https://www.the-dreams.de/aay64/, whose timing charts derive from Marko Mäkelä's PAL timing notes. The opcode tables were generated from AAY64's instruction pages; one AAY64 error is corrected, as `6510.md` notes. Other material comes from Christian Bauer's VIC-II article, Wolfram Sang's 2x2 FLI article, Puterman's introduction to C64 demo programming, Trident's Fjälldata 2025 talk on productivity, and long-standing demoscene practice. `algorithms.md` and `modern-practice.md` cite a source for each figure, as checked on 23 September 2026. Less certain figures are marked where they appear. Link Codebase64 as codebase.c64.org: the old codebase64.org domain now redirects to an unrelated site.
