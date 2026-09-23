# CIA 6526 / 8521

The C64 has two Complex Interface Adapters. CIA 1 at `$DC00` drives the IRQ line and reads the keyboard and joysticks. CIA 2 at `$DD00` drives the NMI line, the serial bus, the user port and the VIC-II bank bits. Each chip's 16 registers repeat every 16 bytes through `$DCFF` and `$DDFF`.

## Contents

1. Register map
2. Interrupt control
3. Timers
4. Time-of-day clock
5. CIA 1 ports: keyboard, joysticks, paddles
6. CIA 2 ports: VIC-II bank, serial bus, user port
7. The 6526 against the 8521
8. How the KERNAL uses the CIAs

## 1. Register map

| Offset | CIA 1 (`$DC0x`) | CIA 2 (`$DD0x`) |
| --- | --- | --- |
| `$0` | Port A: keyboard columns (write), joystick 2 | Port A: VIC-II bank, serial bus, RS-232 out |
| `$1` | Port B: keyboard rows (read), joystick 1 | Port B: user port, RS-232 |
| `$2` | Port A direction (1 = output); default `$FF` | Port A direction; default `$3F` |
| `$3` | Port B direction; default `$00` | Port B direction; default `$00` |
| `$4`, `$5` | Timer A low, high | Timer A low, high |
| `$6`, `$7` | Timer B low, high | Timer B low, high |
| `$8` | TOD tenths (BCD, bits 3–0) | same |
| `$9` | TOD seconds (BCD) | same |
| `$A` | TOD minutes (BCD) | same |
| `$B` | TOD hours (BCD, bit 7 = PM) | same |
| `$C` | Serial shift register | same |
| `$D` | Interrupt control and status (IRQ) | Interrupt control and status (NMI) |
| `$E` | Control register A | same |
| `$F` | Control register B | same |

## 2. Interrupt control (`$DC0D`, `$DD0D`)

| Bit | Read: source that fired | Write: mask bit |
| --- | --- | --- |
| 7 | 1 = at least one enabled source fired | 1 = set the mask bits written as 1; 0 = clear them |
| 4 | FLAG pin (cassette read or serial SRQ on CIA 1; user port on CIA 2) | enable FLAG |
| 3 | Serial shift register full or empty | enable serial |
| 2 | TOD alarm | enable alarm |
| 1 | Timer B underflow | enable timer B |
| 0 | Timer A underflow | enable timer A |

- Reading returns the flags and clears them all, which also acknowledges the interrupt. A second read returns 0, so read once and keep the value.
- Writing `$7F` disables every source. Writing `$81` enables timer A alone and leaves the other mask bits as they were.
- CIA 1's line is the IRQ, which the I flag masks. CIA 2's line is the NMI, which nothing masks. The NMI is edge-triggered, so CIA 2 cannot raise a second NMI until its flags are read. A program that fires one CIA 2 NMI and never reads `$DD0D` thereby blocks every later NMI, including the one from RUN/STOP+RESTORE.

## 3. Timers

Each timer is a 16-bit down-counter with a 16-bit latch. Writing the low and high bytes writes the latch; writing the high byte while the timer is stopped also loads the counter. Reading returns the counter as it runs. In continuous mode the timer reloads from the latch on underflow, so its period is latch + 1 cycles.

Control register A (`$xE`):

| Bit | Meaning |
| --- | --- |
| 7 | TOD input frequency: 1 = 50 Hz, 0 = 60 Hz |
| 6 | Serial port direction: 1 = output |
| 5 | Timer A counts: 0 = system clock, 1 = CNT pin |
| 4 | 1 = force-load the latch into timer A (strobe; always reads 0) |
| 3 | 1 = one-shot, 0 = continuous |
| 2 | Timer output on PB6: 1 = toggle, 0 = pulse |
| 1 | 1 = timer A output on PB6 |
| 0 | 1 = start, 0 = stop |

Control register B (`$xF`) is the same except for these bits:

| Bit | Meaning |
| --- | --- |
| 7 | Writes to the TOD registers set: 1 = alarm, 0 = clock |
| 6–5 | Timer B counts: `00` system clock, `01` CNT pin, `10` timer A underflows, `11` timer A underflows while CNT is high |
| 2–1 | Output goes to PB7 instead of PB6 |

Timer B counting timer A underflows chains the two into a 32-bit timer.

**Timer-based raster sync.** A continuous timer whose period equals the line length stays locked to the raster: latch 62 (`$003E`) on PAL, 64 on the NTSC 6567R8 and 63 on the 6567R56A. Started once from a stable raster position, it reads out the cycle position within the line, which is how a handler measures its own jitter. The same timer can fire an interrupt at any chosen cycle, where a raster interrupt always fires at the start of a line.

## 4. Time-of-day clock

The TOD clock counts tenths, seconds, minutes and hours in BCD from the mains frequency. Set CRA bit 7 to match the local mains: 50 Hz in PAL countries, 60 Hz in NTSC countries. With the wrong setting, the clock runs 20% fast or slow.

Reading the hours register latches all four registers until the tenths register is read, so read hours first and tenths last. Writing the hours register stops the clock until the tenths register is written, so write hours first and tenths last. TOD is too coarse for frame timing but can measure how long something takes in real seconds.

## 5. CIA 1 ports: keyboard, joysticks, paddles

**Keyboard.** The KERNAL leaves port A as output and port B as input. Write a column mask to `$DC00` with a 0 in the column to scan, then read `$DC01`, where a 0 marks a pressed key in that column.

| Column (value written to `$DC00`) | `$DC01` bit 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Column 0 (`$FE`) | Cursor up/down | F5 | F3 | F1 | F7 | Cursor left/right | Return | Delete |
| Column 1 (`$FD`) | Left Shift | E | S | Z | 4 | A | W | 3 |
| Column 2 (`$FB`) | X | T | F | C | 6 | D | R | 5 |
| Column 3 (`$F7`) | V | U | H | B | 8 | G | Y | 7 |
| Column 4 (`$EF`) | N | O | K | M | 0 | J | I | 9 |
| Column 5 (`$DF`) | , | @ | : | . | - | L | P | + |
| Column 6 (`$BF`) | / | ↑ | = | Right Shift | Home | ; | * | £ |
| Column 7 (`$7F`) | Run/Stop | Q | C= | Space | 2 | Ctrl | ← | 1 |

- Shift Lock latches the left Shift key. RESTORE is not in the matrix: it pulls the NMI line directly.
- Three keys pressed at the corners of a rectangle in the matrix make the fourth corner read as pressed (ghosting).
- Set the directions explicitly on every start, cold or warm: write `$FF` to `$DC00` first, so no column is driven low at the moment the outputs turn on, then `$FF` to `$DC02` and `$00` to `$DC03`.
- Mask interrupts, or stop the KERNAL's interrupt, before scanning: the KERNAL's own keyboard scan rewrites `$DC00`.
- The lines settle slowly. Just after a column is selected, a row that the previous column pulled low can still read low. Scan columns in an order where consecutive columns' keys of interest sit on different rows, or wait a few cycles after each column write.
- Leave every column released (`$DC00` = `$FF`) after a scan, so the next joystick read on port 2 is clean.
- Treat input as edges: pressed = held AND NOT held-last-frame. A control held when the program starts should count only after it has been released once.

**Joysticks.** Bits 0–4 are up, down, left, right and fire, and 0 means active. Joystick port 2 reads at `$DC00`, and port 1 at `$DC01`. Both ports share their lines with the keyboard matrix. A joystick in port 1 pulls row lines low, so a keyboard scan reads it as keys, most visibly 1, ←, Ctrl, 2 and Space. A held key in turn can pull joystick lines and read as movement. Games default to port 2 for this reason, and a keyboard scan that must ignore the joysticks checks for a key with all columns deselected (`$DC00` = `$FF`) first.

**Paddles.** `$DC00` bits 7–6 select which port's paddles feed SID `$D419`/`$D41A`: `01` for port A, `10` for port B. Never select both at once.

## 6. CIA 2 ports: VIC-II bank, serial bus, user port

`$DD00` bits:

| Bit | Function |
| --- | --- |
| 7 | Serial DATA in |
| 6 | Serial CLOCK in |
| 5 | Serial DATA out |
| 4 | Serial CLOCK out |
| 3 | Serial ATN out |
| 2 | RS-232 TXD (user port PA2) |
| 1–0 | VIC-II bank, inverted: `%11` bank 0 … `%00` bank 3 (see `vic-ii.md`) |

The KERNAL sets `$DD02` to `$3F`, making bits 0–5 outputs. The serial outputs drive the bus to the disk drive, so a bank switch must keep bits 2–7 as they were: `lda $DD00 : and #$FC : ora #bank : sta $DD00`. A fast or IRQ loader owns those bits while it runs. Some loaders expect the bank to be changed only through the direction register `$DD02`, which leaves `$DD00` alone; follow the loader's own documentation.

`$DD01` is the user port's 8 data lines (PB0–PB7), also used by RS-232 and by parallel-cable drive speeders.

## 7. The 6526 against the 8521

Early C64s have the 6526 (the "old" CIA); the C64C and late boards have the 8521 or the 6526A (the "new" CIA). The newer chip raises a timer interrupt 1 cycle earlier than the old one. Code that stabilizes the raster with a timer, or that counts cycles from a timer interrupt, must detect which chip it runs on at start-up and adjust by that cycle. Without the adjustment, the code jitters or crashes on the other chip. Codebase64 has a detection routine (codebase.c64.org, page base:detecting_6526_vs_6526a_cia_chips). Emulators model both; VICE calls them the old and new CIA.

## 8. How the KERNAL uses the CIAs

- CIA 1 timer A drives the KERNAL's IRQ, with latch `$4025` on PAL and `$4295` on NTSC. Both give about 60 Hz, because the latch is chosen per clock speed. The KERNAL IRQ is therefore not synced to the frame: a jiffy is not a frame, and on PAL it drifts against the 50 Hz picture.
- CIA 1 timer B serves tape and serial-bus timeouts.
- CIA 2 serves RS-232. Its timers are free in most programs, which makes them the usual choice for NMI-driven effects.
- The KERNAL's NMI handler reads `$DD0D`, checks for a cartridge, and warm-starts BASIC when RUN/STOP is held (see `memory-map.md`).
