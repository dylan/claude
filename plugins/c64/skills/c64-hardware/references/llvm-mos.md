# llvm-mos and zig-mos on the C64

llvm-mos is LLVM with a 6502 backend. Its SDK supplies a C and C++ toolchain, a C library and platform support for the C64. zig-mos runs Zig on the same backend. This file covers what the compiler does with registers, zero page and stack frames, how a C64 program starts, what compiles badly, and what has gone wrong in real projects. Facts about the compiler and SDK come from their sources (llvm-mos main and llvm-mos-sdk main, checked 23 September 2026; latest SDK release v23.2.0). Practical findings come from building a C64 game in Zig on zig-mos.

## Contents

1. Drivers, targets and CPU models
2. Imaginary registers and zero page
3. Static stack, soft stack and reentrancy
4. The calling convention
5. Interrupt handlers
6. Inline and hand-written assembly
7. Start-up, exit and restart on the C64
8. Memory layout and linker scripts
9. What compiles badly, and what to write instead
10. Optimiser surprises, and proving code reaches the backend
11. Inspecting the output
12. zig-mos
13. Rebuilding the SDK libraries

## 1. Drivers, targets and CPU models

- The C64 drivers are `mos-c64-clang` and `mos-c64-clang++`. Build with `-Os -flto`; the platform configs set only `-flto`, so pass `-Os` yourself.
- `-mcpu` selects the CPU: `mos6502` (the default), `mos6502x`, `mos65c02`, `mosw65816`, `mos45gs02` and others. The C64's 6510 is `mos6502`. A 65C02 opcode compiles and links cleanly under the wrong CPU setting, then misbehaves at run time, so pin the CPU explicitly.
- `mos6502x` lets the assembler accept the undocumented opcodes (SLO, RLA, SRE, RRA, SAX, LAX, DCP, ISC, ALR, ARR, ANC, SBX, the unstable ones and multi-byte NOPs) and defines `__mos6502x__`. The code generator itself uses only DCP, in multi-byte decrements.

## 2. Imaginary registers and zero page

The compiler treats zero page as extra registers: 32 one-byte "imaginary registers" `__rc0`–`__rc31`, paired into 16 two-byte registers `__rs0`–`__rs15` (rsN is rc2N low and rc2N+1 high).

| Registers | Role |
| --- | --- |
| RS0 (`__rc0`/`__rc1`) | Soft stack pointer; callee-saved |
| RS1–RS9 (`__rc2`–`__rc19`) | Caller-saved, with A, X, Y and the C, N, V, Z flags |
| RS8 (`__rc16`/`__rc17`) | Also reserved as scratch for the register scavenger |
| RS10–RS15 (`__rc20`–`__rc31`) | Callee-saved |
| RS15 (`__rc30`/`__rc31`) | Frame pointer, when one is needed |

On the C64 the linker script sets `__rc0` = `$02`, so the imaginary registers occupy `$02`–`$21`. Under LTO, the compiler also allocates zero page for the whole program: `-mlto-zp=<bytes>` sets the budget, and `-mreserve-zp=<bytes>` holds some back. The C64 config passes `-mlto-zp=110`, the region `$22`–`$8F`. The allocator can put globals, static-stack slots and callee-saved registers there. It overwrites BASIC's zero page (`$02`–`$8F`) freely and leaves the KERNAL's (`$90`–`$FF`) alone.

`__zp` (or `__zeropage`) places a variable in zero page explicitly, and a pointer to it is 1 byte. The compiler promotes hot globals by itself, so marking everything `__zp` is not recommended. The compiler emits `.zp.data`, `.zp.bss` and `.zp.noinit` sections, and the linker script also accepts `.zp.*` and `.zeropage*`.

## 3. Static stack, soft stack and reentrancy

The 6502's hardware stack is 256 bytes, so compiled code keeps its locals elsewhere. Under LTO, llvm-mos reads the whole call graph, marks every function that can't recurse as non-reentrant, and gives those functions fixed frames in one global block, `static_stack`. Functions that never run at the same time share the same bytes. Only what can't be proved non-reentrant uses the soft stack, a stack in RAM addressed through RS0, which is slower. The compiler may also use up to 4 bytes of the hardware stack for register spills.

What forces the soft stack:

- recursion, including any function in a call-graph cycle;
- `optnone`, as in unoptimised builds;
- functions reachable from an `interrupt` handler;
- functions reachable from two different `interrupt_norecurse` handlers, or from one of them and `main`;
- every runtime library call (multiply, divide, shifts), as soon as the program has any interrupt handler.

Calls through function pointers, or into assembly the compiler can't see, are assumed to call anything. `-fnonreentrant` (or `__attribute__((nonreentrant))`) declares code non-reentrant when function pointers would otherwise defeat the analysis. `__attribute__((leaf))` on an assembly routine tells the compiler it calls no C code. `-fno-static-stack` turns the whole mechanism off.

The consequence for program design: a function with a static frame must never run twice at once. An interrupt handler that calls main-loop code corrupts that code's locals. Keep interrupt work to setting flags or counters, and let the main loop call the logic (`patterns.md`, section 5).

## 4. The calling convention

- **Bytes** are assigned left to right to A, then X, then `__rc2`–`__rc15`. A 16-bit argument takes the next two byte slots (A and X for a first argument); a 32-bit one takes four.
- **Pointers** go to RS1–RS7 (`__rc2`/`__rc3` first); RS0 is the stack pointer and is skipped. A `__zp` pointer is one byte and is passed like one.
- **Return values** use the same sequence as a first argument.
- **Structs** of 4 bytes or less are passed and returned directly, split into bytes. Larger ones are passed by pointer, and the callee may write through it. Larger return values go through a hidden pointer passed as the first argument.
- **Overflow** arguments, and all variable arguments, go on the soft stack, so variadic functions must have prototypes.

For example, `__memset(char *ptr, char value, size_t num)` receives the fill byte in A, the pointer in `__rc2`/`__rc3`, and the count's low byte in X and high byte in `__rc4`.

## 5. Interrupt handlers

| Attribute | Behaviour |
| --- | --- |
| `interrupt` | Starts with `cld`, ends with `rti`. Saves what it uses of A, X, Y and `__rc2`–`__rc31`, and a call inside it clobbers A, X, Y and `__rc2`–`__rc19`, so a handler that calls anything saves all of them. Moves the soft stack pointer 256 bytes down and back, in case the interrupted code was half-way through updating it. Everything it can reach uses the soft stack. |
| `interrupt_norecurse` | As `interrupt`, but code reachable only from this handler keeps static frames. |
| `no_isr` | Ends with `rts` and saves nothing: for a C function called from an assembly wrapper that does the saving. |

Calling C code from an interrupt without one of these attributes is undefined behaviour. A manual wrapper must push A, X, Y and `__rc2`–`__rc19`, 21 bytes. The cheapest handler is often a short assembly routine that does the hardware work and sets a flag, with no C at all (`interrupts.md` covers the hardware side).

## 6. Inline and hand-written assembly

- **Constraints:** `a`, `x`, `y`; `R` (any of A, X, Y); `d` (X or Y); `c` and `v` (flags); `r` (an imaginary register, 8- or 16-bit by operand type). `o`, `V`, `<`, `>`, `g` and asm goto are unsupported, and a wrong constraint can crash the compiler.
- **Clobbers:** `a`, `x`, `y`, `c`, `v`, `p`, `rcN`, `rsN` and `memory`. N and Z aren't tracked.
- **Operand modifiers:** `mos8(__rc2)` for zero-page addressing of an imaginary register, and `mos16`, `mos16lo`, `mos16hi` (`sym@mos16hi` in directives).
- **Separate `.s` files** assemble with `mos-clang -c file.s`. The assembler uses GNU syntax and accepts `$` for hex. Compared with ca65: `.section` instead of `.segment`, `.fill` instead of `.res`, C names without an underscore prefix, and numeric local labels (`1f`, `1b`) instead of `:+`.
- **Name the registers, never their addresses.** Hand-written code must refer to `__rc2`, not to `$04`. One project's `__memset` wrote `$02`–`$04`, meaning `__rc2`–`__rc4`, but the linker had put `__rc0` at `$02`. The routine therefore wrote `__rc0`–`__rc2` instead, and the screen stayed black. The linker script decides where the registers live, and it can change.

## 7. Start-up, exit and restart on the C64

The output is a PRG. It starts with a 2-byte load address (`$0801`), then a BASIC line (`7773 SYS` followed by the address of `_start`), then the program. The C64 start-up code runs in numbered `.init` sections:

| Order | Step |
| --- | --- |
| `.init.010` | Writes `$2F` to `$00` and `$3E` to `$01`: BASIC ROM out, KERNAL and I/O in. It does not disable interrupts. |
| `.init.100` | Loads the soft stack pointer from `__stack`. |
| `.init.200` | Copies `.zp.data` into zero page, and zeroes `.bss` and `.zp.bss`. |
| `.init.300` | Runs constructors, if any are linked. |
| then | `jsr main`, then `jmp exit`. |

On exit, `.fini.990` writes `$3F` to `$01` to bring BASIC back. The default `_Exit` then loops forever: a program doesn't return to BASIC unless it links `-l:save-basic.o`, which saves and restores `$02`–`$8F` and the stack pointer and returns to READY.

Two consequences for programs that can be run twice, by a second `RUN` or a `SYS` back to the entry point:

- **`.data` is never copied at start-up.** The load puts it in place once, so a re-run starts with whatever the last run left there. A global that must be fresh on every run needs its value assigned at start-up.
- **`.bss` is cleared on every entry**, cold or warm, but only if the start-up library that clears it is linked (section 13). The backend emits an undefined reference to `__do_zero_bss` from any module with `.bss`, and the linker pulls in the clearing code to satisfy it. If that code is missing, the link still succeeds, the reference stays undefined, and `.bss` holds whatever the machine had there. A C64 powers on with a pattern of `$00` and `$FF` blocks, not zeros. Guard against it: fail a check when the ELF has a non-empty `.bss` and `__do_zero_bss` is undefined.

## 8. Memory layout and linker scripts

By default the program's `ram` region runs from `$0801` to `$CFFF`: the BASIC line, code, read-only data, `.data`, `.bss`, `.noinit`, then the heap, with a default limit of 4 KB. The soft stack starts at `$D000` and grows down. The linker always runs with `--gc-sections`, and `KEEP` already protects the start-up and exit sections.

A program that puts VIC-II memory in bank 3 must keep code, data and the soft stack below `$C000`. A wrapper linker script can do that and reuse the SDK's pieces:

```
__basic_zp_start = 0x0002;
__basic_zp_end = 0x0090;
MEMORY { ram (rw) : ORIGIN = 0x0801, LENGTH = 0xB7FF }      /* $0801-$BFFF */
__rc0 = __basic_zp_start;
INCLUDE "imag-regs.ld"
__basic_zp_size = __basic_zp_end - __basic_zp_start;
MEMORY { zp : ORIGIN = __rc31 + 1, LENGTH = __basic_zp_end - (__rc31 + 1) }
REGION_ALIAS("c_readonly", ram)
REGION_ALIAS("c_writeable", ram)
SECTIONS { .basic_header : { *(.basic_header) } INCLUDE "c.ld" }
__stack = 0xC000;
OUTPUT_FORMAT { SHORT(ORIGIN(ram)) TRIM(ram) }
```

- `ASSERT(expr, "message")` works in these scripts, as in the SDK's own.
- `__attribute__((aligned(256)))` aligns globals and statics, but not locals.
- `.noinit` data is neither loaded nor cleared.
- A custom section that nothing references is garbage-collected unless the script `KEEP`s it or the assembly marks it retained (`.section name,"aR"`).

The SDK documents no recipe for placing data at a fixed address. The simplest approach is to compile graphics as ordinary tables and copy them into the VIC-II's bank at start-up, which also lets one table feed several destinations. For sprite frames, the copy can mirror them or change frames. The alternative is a custom section placed by the linker script.

## 9. What compiles badly, and what to write instead

| Construct | What happens | Instead |
| --- | --- | --- |
| Multiply, divide, modulo, and shifts or rotates by a variable amount | Library calls (`__mulhi3`, `__udivhi3` …); a variable shift becomes a bit-at-a-time loop | Tables: a mask table instead of `1 << n`, repeated subtraction or shift-subtract steps instead of division (`algorithms.md`, section 3) |
| An unrolled run of constant subtractions | LLVM recognises it as division and emits `__udivhi3` plus `__mulhi3` | Loop over a run-time table of the constants |
| Whole-struct assignment | A `memcpy` call, about 45 cycles per byte | Copy the fields that changed |
| Comparing arrays with a library function | About 700 cycles for three 16-bit values (Zig's `std.mem.eql`) | Compare the fields directly |
| Saturating multiply (Zig `*\|`) | The backend fails: `unable to legalize instruction: G_UMULFIXSAT` | A comparison: return the maximum when `b > max / a` |
| A `const` array local to a function | Copied onto the stack on every call | Make it `static` or global |
| Array of structs indexed by a variable | 16-bit address arithmetic per access | A struct of arrays, indexed by one byte |
| Indexes of 256 or more | 16-bit index arithmetic | Keep indexes below 256 |
| Locals turned into globals by hand, or temporaries reused by hand | Defeats the static-stack and zero-page allocators | Leave allocation to the compiler |
| Wide results used only in part | Full-width arithmetic | Narrow the types to what is used |

Two cautions about `volatile` and I/O. On NMOS CPUs an indexed access can make a dummy read one page lower, and the compiler doesn't count that as a volatile access; it can touch an I/O register with read side effects. The compiler also avoids read-modify-write instructions on volatile objects, so compiled code acknowledges `$D019` with a load and a store. An infinite loop with no side effects, and non-volatile accesses, may be optimised away.

## 10. Optimiser surprises, and proving code reaches the backend

- **Globals change shape.** Under LTO, the optimiser may split a global struct into one object per field, and re-encode fields: an enum became a bool with the opposite encoding, and because its initial value was now false it moved from `.data` to `.bss`. With `.bss` uncleared, the program's starting direction depended on memory layout. It showed up in one optimisation mode and one build variant but not in others, while every host test passed. Assign state explicitly at start-up, and find variables through DWARF, not the symbol table (`modern-practice.md`, section 9).
- **Host tests don't test the backend.** A 24-bit packed optional type in Zig made the 6502 build draw nothing while every host test passed. Unusual integer widths and packed layouts are where backend bugs hide; run such code on the target.
- **Uncalled code is never compiled.** LTO and `--gc-sections` strip what nothing calls before the backend sees it, so a green build proves nothing about a function the program doesn't call yet. Taking a function's address in a compile-time block reaches only the front end. To force full code generation, compile a separate target object that exports a wrapper for every public function (`export fn` in Zig, non-static functions in C) as part of the default build, and never install it. Building it is the check, and a construct the backend can't legalise then fails the build.
- **Measure the build that ships.** Unoptimised builds are larger and use the soft stack everywhere (`optnone`), and on some toolchain versions they crash the backend or miscompile where release builds don't. Make the size-optimised build the default, and measure and test that one.

## 11. Inspecting the output

- `-Wl,--lto-emit-asm` writes the generated assembly to the `-o` file.
- A PRG link also writes `<output>.elf` (`-o game.prg` gives `game.prg.elf`), with symbols and DWARF. Disassemble it with `llvm-objdump -d --print-imm-hex`, and list symbols with `llvm-nm`.
- `-Wl,-Map,game.map` writes a map file.
- `-fpost-link-tool=<tool>` runs a tool on the ELF after each link.
- Keep the ELF unstripped for any harness that looks variables up. Debug information also shifts a few of LLVM's choices, so the PRG's size moves slightly with it.

## 12. zig-mos

zig-mos is a Zig fork on llvm-mos (Zig 0.17.0-dev on LLVM 22 as of 2026). The examples repository, kassane/zig-mos-examples, has the canonical build wiring.

- **Target.** `.{ .cpu_arch = .mos, .os_tag = .c64 }`, with `cpu_model` set explicitly to `mos6502`. The architecture is `mos`, never `mos6502`.
- **Build settings for the C64 executable.** `lto = .full`, `bundle_compiler_rt = false`, `stack_protector = false` and `error_tracing = false`. A stack guard or an error-return trace uses intrinsics the backend can't lower. Keep both enabled for host tests. Link the SDK's `basic-header.S`, `unmap-basic.S`, libcrt, libcrt0 and libc, and translate `c64.h` to get the register definitions.
- **Entry and panics.** The entry point is `export fn main() void`, called by the SDK's crt0. The root module needs a panic handler that halts in a loop, because `@trap` lowers to `abort`, which doesn't exist on bare metal; provide `abort` too.
- **Types.** `usize` is `u16`, so a slice costs 4 bytes, and standard-library code that assumes a 32-bit `usize` fails to compile or overflows. Use fixed-width integers in logic.
- **Zero page.** `addrspace(.zp)` places a variable in zero page, with 1-byte pointers. `translate-c` drops `__address_space__(1)` from C headers, so zero-page variables declared in C lose it in Zig. The examples pass no `-mlto-zp`, so check whether automatic zero-page allocation is active before relying on it.
- **Interrupts.** `callconv(.mos_interrupt)` produces an `interrupt` handler. No `interrupt_norecurse` equivalent was found, so everything such a handler reaches uses the soft stack.
- **Assembly.** Clobbers are a struct, such as `.{ .a, .x, .y, .c, .memory, .rc2 }`. `.incbin` paths resolve relative to the build cache, so generate the `.s` file from `build.zig` with an absolute path. `@embedFile` refuses paths outside the module's directory.
- **Compile-time work.** `comptime` can parse text art and tables and validate them with `@compileError`; large parses need `@setEvalBranchQuota`. It can also generate derived tables and assert sizes, layouts and alignment.
- **The fork lags upstream Zig.** Some syntax and standard-library shapes differ. The 0.17 fork, for example, has no `**` array-repeat operator (use `@splat`), and `@typeInfo` returns struct fields in a different shape. When standard code fails to compile, read the fork's bundled `lib/std` before assuming the code is wrong.
- **No stack traces.** DWARF call-frame information isn't emitted, so debug with the emulator's monitor, or read variables out of the running machine.

## 13. Rebuilding the SDK libraries

zig-mos builds, and any toolchain whose LLVM differs from the SDK's, must build the SDK's platform libraries from source. Prebuilt archives contain bitcode from the SDK's LLVM, and an older linker can't read it: the failure shows up as `undefined symbol: __rc2`. The CMake build encodes rules that a hand-written build must reproduce:

- **Section-only objects must be linked as objects, not archive members.** `crt0.S` contributes a `.call_main` section (`jsr main`) with no exported symbol, and `save-basic.S` contributes only `.init` and `.fini` pieces. A linker extracts archive members only to resolve symbols, so inside an archive these are never linked: `main` never runs, or zero page isn't saved.
- **Link the zero-fill code.** The Commodore start-up library merges `zero-bss.c` and `zero-zp-bss.c`. A rebuilt library without them links cleanly and leaves `.bss` uncleared (section 7). An unresolved `__do_copy_data` can hide the same way.
- **Overrides must beat weak definitions.** The C library defines some routines weakly (`__memset` in `mem.c`). A strong replacement placed in an archive may never be extracted, because the weak definition already satisfied the symbol. Link replacements as plain objects.
- **Some C++ code can't go through LTO.** The SDK's `printf.cc` and `varint.cc` crash the 6502 LTO code generator as bitcode. Compile them to machine code (LTO off).
- **Test the libraries on the target.** One compiler version (`zig cc`, clang 21) turned the SDK's C `__memset` into a recursive stub; an assembly replacement fixed it. A routine that every program uses can be wrong without any build error.
- The first build compiles the libraries, about 30 seconds; a build cache makes later builds take seconds.
