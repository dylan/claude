# VIC-II video chip

## Contents

1. Chip models and frame timing
2. Register map
3. How the VIC-II addresses memory
4. Display modes and colour sources
5. Screen geometry
6. Cycle timing of a raster line
7. Badlines
8. Sprites and multiplexing
9. Border opening, FLD, FLI and VSP
10. Colours

## 1. Chip models and frame timing

| Chip | Standard | Lines | Cycles/line | Cycles/frame | Frames/s | Clock (Hz) | Visible lines | Highest raster line |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 6569, 8565 | PAL-B | 312 | 63 | 19,656 | 50.125 | 985,248 | 284 | 311 (`$137`) |
| 6567R8, 8562 | NTSC-M | 263 | 65 | 17,095 | 59.826 | 1,022,727 | 235 | 262 (`$106`) |
| 6567R56A | NTSC-M (early) | 262 | 64 | 16,768 | about 61.0 | 1,022,727 | 234 | 261 (`$105`) |
| 6572 | PAL-N (Argentina) | 312 | 65 | 20,280 | about 50.5 | about 1,023,440 | | 311 |
| 6573 | PAL-M (Brazil) | 263 | 65 | 17,095 | about 59.8 | about 1,022,000 | | 262 |

The 6567R56A shipped only in the earliest NTSC machines. The 6572 and 6573 are rare, and their figures are less certain than the others. The 8565 (PAL) and 8562 (NTSC) are the HMOS-II chips of the C64C. They keep their predecessors' timing, but a write to a colour register (`$D020`–`$D02E`) can flash a grey dot at the pixel being drawn, which the older chips don't do. The first PAL revision, the 6569R1, has fewer luminance levels than later chips (about 5 against 9), so colours that differ only in luminance can merge on it.

Vertical blanking lies between lines 300 and 15 on PAL, and between lines 13 and 40 on NTSC.

## 2. Register map

The registers repeat every 64 bytes through `$D3FF`. `$D02F`–`$D03F` read `$FF` on a C64. Unused bits read as 1, so reading a colour register gives `$F0` OR the colour: mask with `and #$0F` before comparing.

| Address | Name | Bits and notes |
| --- | --- | --- |
| `$D000`–`$D00F` | Sprite 0–7 X, Y | Even addresses hold X bits 7–0 and odd addresses hold Y. |
| `$D010` | Sprite X bit 8 | Bit n is bit 8 of sprite n's X. |
| `$D011` | Control 1 | 7: bit 8 of the raster (read) or of the compare value (write). 6: ECM. 5: BMM (bitmap). 4: DEN (0 blanks the screen to the border colour). 3: RSEL (1 = 25 rows, 0 = 24). 2–0: YSCROLL. The KERNAL writes `$1B`. |
| `$D012` | Raster | Read: raster line bits 7–0. Write: compare line bits 7–0, with bit 8 in `$D011` bit 7. |
| `$D013`, `$D014` | Light pen X, Y | |
| `$D015` | Sprite enable | Bit n enables sprite n. |
| `$D016` | Control 2 | 7–5: unused. 4: MCM (multicolour). 3: CSEL (1 = 40 columns, 0 = 38). 2–0: XSCROLL. The KERNAL writes `$08`, which reads back as `$C8`. |
| `$D017` | Sprite Y expand | Bit n doubles sprite n's height. |
| `$D018` | Memory pointers | 7–4: screen at bank + n × `$0400`. 3–1: character set at bank + n × `$0800`. In bitmap mode, bit 3 alone places the bitmap at bank + `$0000` or bank + `$2000`. 0: unused. Reads `$15` after reset (uppercase set); `$17` selects the lowercase set. |
| `$D019` | Interrupt flags | 7: any enabled source fired. 3: light pen. 2: sprite–sprite collision. 1: sprite–background collision. 0: raster. Write 1 to a bit to clear it; the chip never clears them itself. Bits 6–4 read 1. |
| `$D01A` | Interrupt enable | Same bit layout as bits 3–0 of `$D019`. Bits 7–4 read 1. |
| `$D01B` | Sprite priority | Bit n = 1 puts sprite n behind foreground pixels (`1` in hires, `10` and `11` in multicolour) and in front of background pixels. |
| `$D01C` | Sprite multicolour | Bit n puts sprite n in multicolour mode. |
| `$D01D` | Sprite X expand | Bit n doubles sprite n's width. |
| `$D01E` | Sprite–sprite collision | Bits of the colliding sprites. Reading clears it. |
| `$D01F` | Sprite–background collision | Bits of the colliding sprites. Reading clears it. |
| `$D020` | Border colour | |
| `$D021`–`$D024` | Background colours 0–3 | `$D022` and `$D023` also serve multicolour text and bitmap modes; `$D022`–`$D024` serve ECM. |
| `$D025`, `$D026` | Sprite multicolour 0, 1 | Shared by all sprites. |
| `$D027`–`$D02E` | Sprite 0–7 colour | |

## 3. How the VIC-II addresses memory

The VIC-II sees a 16 KB bank that CIA 2 selects through `$DD00` bits 1–0, which are inverted:

| `$DD00` bits 1–0 | Bank | Address range | Character ROM image |
| --- | --- | --- | --- |
| `%11` | 0 | `$0000`–`$3FFF` | `$1000`–`$1FFF` |
| `%10` | 1 | `$4000`–`$7FFF` | none |
| `%01` | 2 | `$8000`–`$BFFF` | `$9000`–`$9FFF` |
| `%00` | 3 | `$C000`–`$FFFF` | none |

- The VIC-II always reads RAM, whatever `$01` says, except for the character ROM images in banks 0 and 2, which hide the RAM beneath them. Graphics stored at `$1000`–`$1FFF` or `$9000`–`$9FFF` therefore show the ROM font. In bank 3, graphics can sit under the KERNAL ROM and the I/O area, because the VIC-II sees the RAM there.
- Screen memory starts on a `$0400` boundary, a character set on `$0800` and a bitmap on `$2000`, each an offset within the bank set by `$D018`.
- The sprite pointers are the last 8 bytes of screen memory, screen + `$3F8` to `$3FF`. Pointer value p places the sprite's 63 bytes at bank + p × 64.
- In bank 0, a program without tape I/O can keep up to three sprite blocks in the cassette buffer: blocks 13–15 at `$0340`, `$0380` and `$03C0`. They lie outside the character ROM image and below a program loaded at `$0801`, so no linker changes are needed.
- Colour RAM is 1,024 nybbles at `$D800`–`$DBFF`, fixed whatever the bank, and only visible while I/O is banked in. Reads return random upper nybbles, so mask them with `and #$0F`.
- The VIC-II's idle accesses read the bank's last byte (bank + `$3FFF`). That byte is the pattern drawn in opened borders and FLD gaps. While ECM is set, it reads bank + `$39FF` instead. In bank 3, `$FFFF` is also the high byte of the IRQ vector when the KERNAL is banked out.

## 4. Display modes and colour sources

| ECM | BMM | MCM | Mode | Colour sources |
| --- | --- | --- | --- | --- |
| 0 | 0 | 0 | Standard text | Pixel 0: `$D021`. Pixel 1: colour RAM. |
| 0 | 0 | 1 | Multicolour text | Colour RAM bit 3 = 0: the character shows in hires, in colours 0–7. Bit 3 = 1: `00` `$D021`, `01` `$D022`, `10` `$D023`, `11` colour RAM bits 2–0. |
| 0 | 1 | 0 | Hires bitmap | Pixel 0: screen byte's low nybble. Pixel 1: its high nybble. |
| 0 | 1 | 1 | Multicolour bitmap | `00` `$D021`, `01` screen high nybble, `10` screen low nybble, `11` colour RAM. |
| 1 | 0 | 0 | Extended background colour text | 64 characters; bits 7–6 of the screen code choose the background from `$D021`–`$D024`. |
| 1 | 0 | 1 | Invalid | The screen shows black, but the VIC-II still fetches, and badlines still happen. |
| 1 | 1 | 0 | Invalid | As above. |
| 1 | 1 | 1 | Invalid | As above. |

Sprites: in hires, pixel 1 takes the sprite's own colour. In multicolour, `01` takes `$D025`, `10` the sprite's colour and `11` `$D026`. Pixel 0 or `00` is transparent.

## 5. Screen geometry

Raster lines count from the top of the frame. Horizontal positions are sprite X coordinates. All ranges are inclusive.

| Area | 25 rows / 40 columns | 24 rows / 38 columns |
| --- | --- | --- |
| Display window, lines | `$33`–`$FA` (51–250) | `$37`–`$F6` (55–246) |
| Display window, X | `$18`–`$157` (24–343) | `$1F`–`$14E` (31–334) |

A sprite with Y coordinate y shows its first line on raster line y + 1. A sprite at X = 24, Y = 50 sits in the top-left corner of the 40×25 area. On PAL the visible picture spans about lines 16–299, and horizontally from X = 480 (`$1E0`), wrapping past `$1F7` to 0, up to X = 380 (`$17C`).

## 6. Cycle timing of a raster line

These timings are for a PAL line (6569), with cycles numbered 1–63. The NTSC 6567R8 inserts 2 extra idle cycles after cycle 56, and the 6567R56A inserts 1.

| Cycles | VIC-II activity | CPU cost |
| --- | --- | --- |
| 1–10 | Sprite 3–7 pointer fetches, and data fetches for sprites shown on this line | 2 cycles per active sprite, plus the 3-cycle handover |
| 11–15 | DRAM refresh | none |
| 12–14 | Badline only: bus request (BA low) | The CPU finishes any writes and stops at its next read. |
| 15–54 | Badline only: character pointer and colour fetches | 40 cycles |
| 16–55 | Graphics fetches, in the half-cycle the CPU doesn't use | none |
| 58–63 | Sprite 0–2 pointer fetches, and data fetches for sprites shown on the next line | 2 cycles per active sprite, plus the handover |

- **Sprite fetch cycles.** Sprite n uses cycles 58 + 2n and 59 + 2n for n = 0–2, and cycles 2n − 5 and 2n − 4 for n = 3–7. It takes the CPU's half of both cycles.
- **The bus handover.** BA goes low 3 cycles before the VIC-II first takes the bus. During those 3 cycles the CPU can finish write cycles but stops at its first read. A 6510 never performs more than 3 writes in a row, so the handover costs 0–3 cycles, depending on the instruction running.
- **Gaps between sprites.** Consecutive sprites share one handover. When two enabled sprites are one number apart, the 2-cycle slot of the sprite between them is shorter than the handover, so the CPU loses it as well: sprites 1 and 3 cost as much as 1, 2 and 3. A gap of two sprite numbers returns 1 cycle to the CPU, and three return 3.
- **Budget.** A badline costs 40–43 cycles, and 8 sprites cost about 19 cycles on each line they cover. A PAL frame has 19,656 cycles, and 25 badlines take roughly 1,000–1,075 of them, leaving about 18,600 with no sprites. An NTSC frame has 17,095 and leaves about 16,000.
- **Raster interrupt.** The raster compare fires at the start of its line, 1 cycle later for line 0. The CPU then finishes its instruction and spends 7 cycles entering the handler.

## 7. Badlines

A line is a badline when all three conditions hold:

1. the raster line is between `$30` and `$F7`;
2. the raster's low 3 bits equal YSCROLL (`$D011` bits 2–0);
3. DEN (`$D011` bit 4) was set during some cycle of line `$30` in this frame.

The VIC-II evaluates condition 2 continuously during the line, so a write to YSCROLL can create a badline or cancel one. Clearing DEN before line `$30` and keeping it clear through that line cancels every badline in the frame and returns about 1,000 cycles. The screen then shows only the border colour, which is why decrunchers and loaders blank the screen.

## 8. Sprites and multiplexing

- A sprite is 24 × 21 pixels (12 × 21 in multicolour, with double-width pixels), stored as 63 bytes in a 64-byte block. X expansion doubles the width to 48 pixels, and Y expansion doubles the height to 42 lines.
- X runs 0–511, with bit 8 in `$D010`. Sprites with lower numbers appear in front of higher ones.
- The VIC-II reads each active sprite's pointer on every line the sprite shows, so a pointer written while the sprite is on screen changes its shape from the next line on. Colour and X changes take effect the same way, as the beam reaches them.
- A sprite starts to show when the raster reaches its Y coordinate, with its first line on raster line Y + 1 (section 5), and then runs its 21 (or 42) lines to the end. A new Y written while it shows takes effect only after that. A Y for a line the raster has already passed shows nothing until the next frame.
- **Multiplexing.** To show more than 8 objects, a program sorts them by Y and reuses each hardware sprite further down the screen. It rewrites a sprite's Y, X, pointer and colour in a raster interrupt placed after the sprite's previous use has started and before the raster reaches the new Y. The new Y must be at least 21 lines (42 if Y-expanded) below the old one, and no more than 8 objects can share a line. Multiplexers drop or flicker the objects beyond that.
- The collision registers `$D01E` and `$D01F` record overlaps of non-transparent pixels, including off-screen and in the border, and clear when read. A multiplexer's reuse of sprites makes their bits ambiguous.

## 9. Border opening, FLD, FLI and VSP

- **Top and bottom border.** The border starts at line `$FB` in 25-row mode and `$F7` in 24-row mode. Switch RSEL to 24 rows during lines `$F8`–`$FA`, after the 24-row check has passed and before the 25-row one. The VIC-II then never turns the border on. Restore RSEL later in the frame. No stable raster is needed. Sprites show in the opened area, and the background there shows the idle byte.
- **Side border.** Clearing CSEL at the exact cycle the right border would start keeps the border off for that line. The switch must be repeated on every line and needs a stable raster. Badlines and sprites make the timing harder.
- **FLD (flexible line distance).** Setting YSCROLL so that it never matches the raster's low 3 bits postpones the next badline, which pushes the rest of the screen down. The gap shows the idle byte.
- **FLI (flexible line interpretation).** Forcing a badline on every line (or every other line), and pointing `$D018` at a different screen each time, gives each pixel row its own colours. The VIC-II starts fetching 3 characters late on a forced badline, so the leftmost 3 character columns show garbage colours (the "FLI bug"); the colours come from the byte on the bus after the `$D011` write. A loop that forces every line keeps itself in sync, because each badline releases the CPU at the same cycle. Interrupt-driven FLI that forces only some lines needs a stable raster in each handler.
- **VSP (variable screen position, "DMA delay").** Triggering a badline in the middle of a line shifts the whole screen sideways, which lets an effect scroll a bitmap without copying it. On some machines VSP corrupts RAM, the "VSP bug", because of how the trick interacts with the DRAM. Treat plain VSP as unsafe for release unless it uses a variant known to avoid the corruption.

## 10. Colours

| Value | Colour | Value | Colour |
| --- | --- | --- | --- |
| 0 | Black | 8 | Orange |
| 1 | White | 9 | Brown |
| 2 | Red | 10 | Light red |
| 3 | Cyan | 11 | Dark grey |
| 4 | Purple | 12 | Grey |
| 5 | Green | 13 | Light green |
| 6 | Blue | 14 | Light blue |
| 7 | Yellow | 15 | Light grey |

Luminance from brightest to darkest, with the colours on each line of about equal luminance (on chips with 9 levels):

1. White
2. Yellow, light green
3. Cyan, light grey
4. Green, light red
5. Grey, light blue
6. Purple, orange
7. Red, dark grey
8. Blue, brown
9. Black

Equal-luminance pairs blend well in dithering, colour fades and anti-aliasing.
