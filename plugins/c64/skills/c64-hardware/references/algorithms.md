# Algorithms with measured 6502 costs

This file collects algorithms that suit the C64, most of them newer than the machine's commercial life, with their published sizes and cycle counts. Before writing a multiply, a random number generator, a sort, a cruncher or a sample player, check here for a measured routine. Figures come from the cited sources, collected on 23 September 2026. Different sources measure on different test data, and a few on other 6502-family CPUs, so compare figures within one table row's source rather than across sources. Where an entry says that no implementation "turned up", the research found no C64 or 8-bit version, which makes the item an opportunity; section 11 lists them all.

Link Codebase64 as `codebase.c64.org`: the old `codebase64.org` domain now redirects to an unrelated site.

## Contents

1. Compression
2. Loading from disk
3. Multiply, divide, square root
4. Random numbers
5. Fixed-time code
6. Sorting for sprite multiplexers
7. Graphics prepared on a PC
8. Sample playback
9. Game logic and procedural generation
10. Text and lookup
11. Open opportunities

## 1. Compression

Decrunch speed in 6502 cycles per output byte (c/B):

| Cruncher | Origin | Decoder | Speed | Ratio | Notes |
| --- | --- | --- | --- | --- | --- |
| Exomizer 3 | Magnus Lind, 2018 | code size not published; 156-byte table | 85.6 c/B, or 78.4 with `-M256 -P-32` | 57.8% saved (Pearls for Pigs corpus) | The size baseline. 3.1 (2020) added reuse of the previous offset. |
| TSCrunch 1.3 | Antonio Savona, 2022 | not published | 16.1 c/B | Chopper Command: 46,913 → 12,506 bytes | Byte-aligned LZ+RLE with optimal parsing; `-i` decrunches in place. |
| KabutoCrunch | Antonio Savona, 2026 | 397 bytes | 26.8 c/B over six games | output 2.7% larger than Dali | |
| Dali | Bitbreaker, 2022 | 321 bytes | 34.6 c/B over six games | ZX0-class | Built on Emmanuel Marty's Salvador; decrunches in place without an end overlap. |
| ZX02 | dmsc, 2022 | 108–166 bytes, 8 bytes of zero page | not published | worst-case expansion 1.01% | ZX0 tuned for the 6502. In place needs a 12-byte gap per KB of output. Best for data up to about 16 KB. |
| LZSA2 | Emmanuel Marty, 2019 | 241–256 bytes | about 52 c/B, measured on a HuC6280 | 52.5% of original on a ZX Spectrum and C64 corpus | Decrunches backwards, in place. |
| aPLib (apultra) | Emmanuel Marty, 2019 | 252 bytes | about 75 c/B | 5–7% smaller than appack | |
| upkr | exoticorn, 2021; 6502 by pfusik, 2024 | 218 bytes, plus 319 bytes of probabilities and 15 of zero page | not published; about 50% faster with a 2 KB multiply table | LZ with rANS entropy coding | For size-coded productions. |
| Huffmunch | Brad Smith, 2019 | 330 bytes | 260 c/B | 46.6% of original | Random access to individual strings. |

An older benchmark (2016, codebase.c64.org "compression benchmarks") ranks throughput against size on one corpus:

| Cruncher | Size (% of original) | Throughput |
| --- | --- | --- |
| Exomizer 2 (mem) | 45.1% | 7.2 kB/s |
| Doynamite | 48.1% | 17.4 kB/s |
| Bitfire 0.6 (Bitnax's predecessor) | 48.4% | 18.4 kB/s |
| TinyCrunch | 61.3% | 30.3 kB/s |

For entropy coding on the machine, ferris's binary rABS (2019) decoded a 4K intro to 3,892 bytes, against about 4,001 with Exomizer. It needs about 4.5 KB of model tables and takes 22.5 s to decode, so it suits size-coding only. No tANS or table-based rANS decoder for the 6502 turned up.

How to choose:

- **Speed first**, for streaming or for decrunching between frames: TSCrunch, TinyCrunch or Bitnax.
- **Size first**, for a one-file release: Exomizer. For a 4K intro: upkr or rABS.
- **Files that share data**, such as tunes or levels: shared dictionaries help. ZX02's `-p` and Dali's `--prefix-from` do this; LZMPiED packed 7 tunes into 11,745 bytes, against 13,088 packed separately.
- Krill's loader notes advise putting the most compressible data first in a file.

Sources: bitbucket.org/magli143/exomizer; github.com/tonysavon/TSCrunch; github.com/tonysavon/kabutocrunch; github.com/bboxy/bitfire; github.com/dmsc/zx02; github.com/emmanuel-marty/lzsa (and issue 37); github.com/emmanuel-marty/apultra; github.com/pfusik/upkr6502; github.com/bbbradsmith/huffmunch; yupferris.github.io/blog/2019/02/11/rANS-on-6502.html; codebase.c64.org, pages base:compression_benchmarks and base:dictionary_compression.

## 2. Loading from disk

A stock 1541 loads about 403 bytes a second. Modern loaders reach 15 to 20 times that. Rates below are after decrunching, with the whole raster time free for the loader (Spindle 3 benchmark, read from its charts to about ±100 bytes/s). Rates fall roughly in proportion to the raster time an effect leaves free.

| Loader | 16 KB of code | 17 KB FLI picture | Notes |
| --- | --- | --- | --- |
| Spindle 3.0 (Linus Åkesson, 2021) | ≈ 6,800 B/s | ≈ 8,100 B/s | The drive reads the next block while the C64 decrunches the current one; the packer stops when a block is full. |
| Sparkle 2.0 (Sparta) | ≈ 6,500 B/s | ≈ 7,700 B/s | Each block is compressed on its own, so blocks load in any order; the next block is prefetched. 124-cycle read-decode-verify loop, tolerant of 272–314 rpm. |
| Krill's loader r184 | ≈ 5,900–6,000 B/s | ≈ 7,200 B/s | Raw up to 7.7 kB/s. Resident part `$1F9` bytes with ZX0 decrunching (r194). Works with 1541, 1570/71, 1581 and CMD FD. |
| Bitfire | ≈ 5,000 B/s | ≈ 6,100 B/s | Computes the sector chain in advance, so blocks need no link bytes. |
| Transwarp (Krill, 2021) | measured 16,056 B/s | | Uses its own disk format: 223 bytes per block, whole tracks. |

The ideas behind these loaders:

- **GCR decoded on the fly** (Linus Åkesson, 2013). A 130-cycle loop decodes 5 GCR bytes as they pass the head, with no buffer. It uses the fact that GCR never has three zeros in a row: masked 5-bit pieces are ORed together and index two page-aligned tables directly.
- **Two-bit transfer** with ATN as the clock, 72 cycles per byte.
- **Loading blocks in the order they arrive** instead of in file order.
- **Decrunching while the drive reads.**

Streaming uses the same machinery. Bad Apple 64 (Onslaught, 2014) plays more than 2,000 frames of about 70 bytes each at 12 frames a second from one disk side. deflestream64 streams compressed SID register writes from disk.

Sources: linusakesson.net/software/spindle/v3.php and /programming/gcr-decoding; github.com/spartaomg/SparkleCPP; csdb.dk/release/?id=189130 and ?id=226124; github.com/bboxy/bitfire; c64-wiki.com/wiki/Transwarp; obliterator918.com (stock speed); csdb.dk/release/?id=131628; github.com/chiptunecafe/deflestream64.

## 3. Multiply, divide, square root

TobyLobster's multiply_test measured more than 120 routines exhaustively, counting cycles including `rts` and excluding `jsr`:

| Routine | Operation | Average cycles | Bytes | Notes |
| --- | --- | --- | --- | --- |
| mult66 (TobyLobster 2023, after Nick Jameson 1994) | 8 × 8 → 16 | 45.49 | 1,580 | fastest 8-bit |
| "Seriously fast" (Jackasser) | 8 × 8 → 16 | 45.99; 27.99 when one factor stays the same | 2,077 | Keep the table pointers set when scaling many values by one factor. |
| mult86 (Repose 2024) | 16 × 16 → 32 | 187.07 | 2,170 | fastest 16-bit |
| shift and add | 8 × 8 → 16 | 162 | 17 | smallest |
| log/exp tables (Elite, 1985) | high byte only | | 768 of tables | error at most 6 |

The fast routines use quarter-square tables, ab = f(a + b) − f(a − b) with f(x) = x²/4. The identity was already used in 1986; the later work refined the routines and measured them exhaustively.

Square roots (sqrt_test, all 65,536 inputs):

| Routine | Bytes | Average | Worst | Notes |
| --- | --- | --- | --- | --- |
| sqrt15 | 512 | 33.7 | 87 | fastest |
| sqrt9 | 847 | 39.8 | 129 | shares square tables with a multiply |
| sqrt7 | 38 | 465 | 465 | constant time |

Division by a constant (Omegamatrix, 2014): routines for divisors 2–32 run in constant time, 24–37 cycles and 14–21 bytes each; divide by 3 takes 30 cycles in 18 bytes.

Sources: github.com/TobyLobster/multiply_test; github.com/TobyLobster/sqrt_test; codebase.c64.org, page base:8bit_divide_by_constant_8bit_result.

## 4. Random numbers

| Generator | Bytes | Cycles | Period and quality |
| --- | --- | --- | --- |
| xorshift798 (16-bit, after Marsaglia 2003) | 21 | 30 | Period 65,535. Tested only lightly (value coverage and a plot). |
| X ABC | 28 | 38 | Uses self-modifying code. |
| Galois LFSR, 16-bit, 8 steps per byte | 19 (loop) / 35 (unrolled) | 137 average / 69 | Period 65,535. |
| sfc16 | 180, plus 10 of zero page | 132 per byte, with `jsr`/`rts` | Passes TestU01 BigCrush and PractRand beyond 1 TB. |
| jsf32 | 337, plus 20 of zero page | 115 per byte | Passes the same suites. |
| chacha20(8) | 2,101, plus 64 of zero page | 277 per byte | Cryptographic strength. |

Generators that EOR a single tap, or four taps, fail every test suite. Use xorshift798 where only appearance matters, such as effects and particles. Use sfc16 or jsf32 where a player could notice patterns, such as procedural levels, game balance and shuffles. The SID's voice-3 noise (see `sid.md`) costs one read but can't be reproduced from a seed.

Sources: codebase.c64.org, pages base:16bit_xorshift_random_generator and base:comparison_of_6502_random_generators; github.com/bbbradsmith/prng_6502; github.com/ivop/random6502.

## 5. Fixed-time code

Raster code with a deadline, and any routine whose cost must not depend on its data, needs the same cycle count on every path. The 6502's timing varies in two places: a taken branch costs 1 cycle more (2 more across a page), and an indexed read costs 1 more when it crosses a page. Branch-free idioms (NesDev wiki, "synthetic instructions"):

| Operation | Code | Cycles |
| --- | --- | --- |
| Sign of A as a `$00`/`$FF` mask | `asl : lda #0 : adc #$ff : eor #$ff` | 8 |
| Pick a or b by mask | `lda a : eor b : and mask : eor b` | 12 in zero page |
| Negate A (carry clear) | `eor #$ff : adc #1` | 4 |
| Arithmetic shift right | `cmp #$80 : ror` | 4 |

Table lookups stay fixed-time only while the tables stay page-aligned. The C64 X25519 port (c64-x25519) lost its alignment when buffers moved: the cycle spread jumped from 0 to 83,342 while every functional test still passed. Assert both alignment and cycle spread in the build (`modern-practice.md`, sections 5 and 8).

Sources: nesdev.org/wiki/Synthetic_instructions; github.com/JC-000/c64-x25519.

## 6. Sorting for sprite multiplexers

| Method | Cost | Notes |
| --- | --- | --- |
| Continuous insertion sort (described by Cadaver) | Near linear while objects move little | Keeps the order array between frames. Cadaver calls it the best overall choice for games, and Green Beret and SWIV used it. Slow when many objects cross at once. |
| Ocean sort | Fast on typical game movement, very slow on extreme patterns | |
| Bucket sort | Stable; about 18% slower than Ocean in a model | |
| Ocean–bucket hybrid | The best compromise in the Codebase64 benchmark with 64 sprites | |
| Field Sort (Linus Åkesson, 2017) | 32 actors in 2,208 cycles worst case, about 2 KB | 220 buckets built from self-modifying `iny` chains and a link table. The previous record, 1,972 cycles, needed more than 32 KB. |

Sorting networks sort in a fixed order of compare-exchange steps, so their cost doesn't depend on the data. Computer searches proved optimal sizes for small inputs: 25 comparators for 9 elements and 29 for 10 (Codish et al., 2014; Bundala and Závodný for depth). On the 6502, each compare-exchange still needs a branch or a table to be fixed-time. No C64 multiplexer that uses one turned up.

Sources: cadaver.github.io/rants/sprite.html; codebase.c64.org, page base:sprite_multiplexer_sorting; linusakesson.net/programming/fieldsort; arxiv.org/abs/1405.5754; arxiv.org/abs/1310.6271.

## 7. Graphics prepared on a PC

- **Palette.** Colodore (Pepto, 2017) models the VIC-II's colours from oscilloscope, vectorscope and frame-grabber measurements, and revises Pepto's 2001 model. Convert in a perceptual colour space such as OKLab (Björn Ottosson, 2020), as png2amiga and RetroConvert do, so that "nearest colour" matches what the eye sees. No published fade table built from OKLab turned up. Ordering the 16 Colodore colours by OKLab lightness and linking nearest neighbours would give one.
- **Dithering.** A blue-noise threshold mask (void-and-cluster, Ulichney 1993; free textures by Christoph Peters, 2016) costs the same as a Bayer matrix at run time, one table of thresholds, and avoids Bayer's visible grid. A dither character set built from an 8×8 mask gives 64 intensity levels. Converters offer blue noise, but no C64 production using it for fades or transparency turned up.
- **Conversion by search.**
  - NUFLIX (Patai Gergely, 2024–25) searches every sprite and bitmap colour combination per block on GPU compute shaders, and emits per-line register-write code.
  - Mufflon, the NUFLI converter, uses brute force for sprite colours.
  - A genetic algorithm (Peter Wendrich) converts hires images by scoring over a million candidates per block.
  - png2prg `-brute-force` tries colour assignments and keeps the one that crunches smallest: 112,946 bytes against 113,328 over 19 test images.
- **Character set reduction.** k-means clustering of 8×8 tiles gave far better results than greedy XOR/popcount culling in cnlohr's Bad Apple work. png2amiga merges the closest pairs by Hamming distance until 256 characters remain.
- **Effects precomputed into tables.** A Python script can build a 256-character set plus a table from a column's top and bottom (y0, y1) to its 3 characters, which draws a filled sine wave with lookups alone (nurpax, 2018). Tunnels can switch between precalculated fonts every 8 lines.
- **Hardware findings that became techniques.**
  - Safe VSP (Linus Åkesson, 2013) traced the VSP crash to DRAM metastability. Only bytes at addresses ending in 7 or F are fragile, so keeping those bytes identical avoids the crash, at the cost of about 12.5% of memory as padding.
  - The sprite-crunch counter rule, published by Linus Åkesson for MISC (2016), lets effects plan crunched sprite heights.
  - NUFLI (2009) and NUFLIX (2024) combine FLI with sprite underlays for 3 colours per 8×2 cell.

Sources: pepto.de/projects/colorvic; colodore.com; bottosson.github.io/posts/oklab; momentsingraphics.de/BlueNoise.html; github.com/tinic/png2amiga; retronick2020.itch.io/retroconvert-the-ultimate-retro-image-converter-for-basic-programmers; cobbpg.github.io/articles/nuflix.html; syntiac.com/tech_ga_c64.html; github.com/staD020/png2prg; github.com/cnlohr/badderapple; nurpax.github.io/posts/2018-06-07-c64-filled-sinewave.html; linusakesson.net/scene/safevsp and /scene/lunatico/misc.php; c64-wiki.de/wiki/NUFLI.

## 8. Sample playback

| Method | Rate | CPU cost | Resolution | Chips |
| --- | --- | --- | --- | --- |
| Mahoney's `$D418` method (2014, "Musik Run/Stop") | 44,784 Hz | 22 cycles per sample, the whole CPU | about 8 bits, through a 256-entry table measured on real chips | 6581 preferred; 8580 works, but quieter |
| Savona's 48 kHz player (2018) | about 48 kHz | about 21 cycles per sample | 4:1 vector quantisation; 1 MB cartridge holds about 90 s | as above |
| Test-bit method (SounDemoN, 2008) | about 8 kHz | several SID writes per sample | about 8 bits | 6581 and 8580 |
| Åkesson's test-bit player (2023) | 7,819 Hz | 60-cycle handler every 126 cycles, about 48% | | compensates up to 6 cycles of interrupt jitter |
| Classic 4-bit `$D418` with voices held at `$49` | 8 kHz is one sample every 123 cycles on PAL | | 4 bits | works on the 8580 too |
| Software mixing (THCM and SounDemoN, 2008) | | | 4 sample channels plus 2 SID voices | |

Mahoney's method sets all three voices to pulse with the test bit on (`$49`), sustain at maximum, cutoff `$FF` and `$D417` = `$03`. The filter stage inverts the signal, and each of the 256 values of `$D418` then gives a different analogue level. A table built from measurements on real chips maps each wanted amplitude to the value to write. 64 KB holds about 1.46 s of audio.

For composing offline, reSID and reSIDfp model the SID from die photographs and from measurements of real chips, including combined waveforms fitted to samplings. GoatTracker and CheeseCutter compose against them.

Sources: livet.se/mahoney/c64-files/Musik_RunStop_Technical_Details_by_Pex_Mahoney_Tufvesson_v2.pdf; brokenbytes.blogspot.com/2018/03/a-48khz-digital-music-player-for.html; codebase.c64.org, page base:vicious_sid_demo_routine_explained; linusakesson.net/music/platform-hopping; github.com/libsidplayfp/combined-waveforms.

## 9. Game logic and procedural generation

- **Dijkstra maps** (from Brogue). Set goal cells to 0 and relax neighbours until nothing changes. One map serves every agent heading for those goals. A flee map is the map multiplied by about −1.2 and relaxed again, and weighted maps can be added together for combined desires. With one byte per cell, the relaxation passes can be spread across frames.
- **Flow fields** (Emerson, *Game AI Pro*, 2013). An 8-bit cost field (255 = wall) is integrated into distances, then turned into a direction per cell (4 bits). The integration can run over several ticks, which fits a per-frame cycle budget.
- **A\*** on the C64 (MagerValp, 2014) uses a heap as its open list and handles rooms up to 21 × 21, with two 441-byte buffers.
- **Jump point search** (Harabor and Grastien, 2011) runs 2–30 times faster than A* on uniform-cost grids, with no preprocessing or extra memory. No 8-bit implementation turned up.
- **Behaviour.**
  - The NES game Super Tilt Bro rejected full behaviour trees for RAM and stack cost. It uses fixed "selector plus action" tables instead: about 6 bytes per action, with the state kept as the current action and a counter.
  - Utility AI scores each possible action and picks among the best. With 8-bit scores from tables, it maps directly onto a table lookup and a maximum. No 8-bit implementation turned up.
- **Cave generation by cellular automaton.** Start with 40% walls. Apply the 4-5 rule (a cell becomes wall if 5 or more of its 3 × 3 neighbourhood are walls) for 4 passes with an extra rule, then 3 plain passes, then flood-fill to remove disconnected areas.
- **Perlin's improved noise** (2002) uses a 256-entry permutation table, which suits byte indexing, and a fade curve that fits a 256-byte table. No 6502 implementation turned up.
- **Wave function collapse** (Gumin, 2016). With 8 or fewer tile types, a cell's remaining possibilities fit in one byte, and propagation becomes an AND with adjacency masks. No 8-bit implementation turned up.

Sources: roguebasin.com, "The Incredible Power of Dijkstra Maps" and "Cellular Automata Method for Generating Random Cave-Like Levels"; gameaipro.com, chapters 9 and 23; magervalp.github.io/2014/05/07/astar-in-asm.html; harablog.wordpress.com/2011/09/07/jump-point-search; sgadrat.itch.io/super-tilt-bro/devlog/6252; mrl.cs.nyu.edu/~perlin/noise; github.com/mxgmn/WaveFunctionCollapse.

## 10. Text and lookup

- **Pair encoding (DTE, recursive byte-pair encoding).** Each string decodes on its own, with no history kept in RAM. The NES game *Full Quiet* stored 128 pairs in a 256-byte dictionary and cut 12,704 bytes of text to 7,822, a 38% saving. Byte-pair encoding was published by Philip Gage in 1994.
- **The Z-machine** packs three 5-bit characters into each 16-bit word, with 96 abbreviations. Ozmoo runs Z-machine games on the C64.
- **Pearson hashing** (1990) hashes a string through a 256-byte permutation table, at an estimated 27 cycles per character. For a fixed set of keywords, the table can be tuned into a perfect hash, which replaces a linear scan such as BASIC's tokenizer, which searches its 76 keywords one by one.

Sources: pineight.com/retrotainment/fq-compression.html; inform-fiction.org/zmachine/standards; github.com/johanberntsson/ozmoo; en.wikipedia.org/wiki/Pearson_hashing; masswerk.at/nowgobang/2019/commodore-basic-tokenizing.

## 11. Open opportunities

The research turned up no C64 implementation of the following, each of which fits the machine:

- Blue-noise dither character sets for fades, transparency and image conversion.
- A fixed-time sprite sort: a sorting network with branch-free compare-exchange steps.
- Fade and blend tables derived from Colodore colours in OKLab.
- Jump point search, utility AI, Perlin noise and small-grid wave function collapse on the machine.
- A table-based ANS (tANS) decruncher.
- A worst-case cycle-bound checker for 6502 raster code.
- Routine use of superoptimisers (DeiMOS, 6502-enumerator) on hot inner loops of 11 bytes or fewer. The tools exist, but few projects use them; see `modern-practice.md`, section 7.
