# SID 6581 / 8580

The SID sits at `$D400`–`$D41C`, and its registers repeat every 32 bytes through `$D7FF`.

## Contents

1. Register map
2. Reading SID registers
3. Frequency and pulse width
4. Envelope rates
5. Voice interconnection
6. The 6581 against the 8580
7. Practical notes: hard restart, random numbers, player timing

## 1. Register map

Voice 1 uses `$D400`–`$D406`, voice 2 `$D407`–`$D40D` and voice 3 `$D40E`–`$D414`, all with the same layout:

| Offset | Register | Notes |
| --- | --- | --- |
| +0, +1 | Frequency low, high | 16-bit value |
| +2, +3 | Pulse width low, high | 12-bit value; the high register uses bits 3–0 |
| +4 | Control | 7 noise, 6 pulse, 5 sawtooth, 4 triangle, 3 test (holds the oscillator at 0), 2 ring modulation, 1 sync, 0 gate (1 starts attack, decay and sustain; 0 starts release) |
| +5 | Attack / decay | Bits 7–4 attack rate, bits 3–0 decay rate |
| +6 | Sustain / release | Bits 7–4 sustain level, bits 3–0 release rate |

Shared registers:

| Address | Register | Notes |
| --- | --- | --- |
| `$D415` | Filter cutoff low | Bits 2–0 |
| `$D416` | Filter cutoff high | 11-bit cutoff in total |
| `$D417` | Resonance and routing | Bits 7–4 resonance; bit 3 filters the external input, bits 2–0 filter voices 3, 2, 1 |
| `$D418` | Mode and volume | 7 turns voice 3's output off, 6 high-pass, 5 band-pass, 4 low-pass, 3–0 master volume |
| `$D419` | Paddle X | Read-only |
| `$D41A` | Paddle Y | Read-only |
| `$D41B` | Oscillator 3 output | Read-only; the upper 8 bits of voice 3's waveform |
| `$D41C` | Envelope 3 output | Read-only |

## 2. Reading SID registers

Every register below `$D419` is write-only. A read returns stale data from the chip's bus, not the register's contents. Code that changes one bit at a time, such as toggling a gate bit, keeps a copy of the register in RAM and writes the whole copy. `inc` or `ora` applied to a SID register writes garbage.

## 3. Frequency and pulse width

Output frequency in Hz = register value × clock ÷ 16,777,216.

| Standard | Clock (Hz) | Hz per step | Value for A4 (440 Hz) |
| --- | --- | --- | --- |
| PAL | 985,248 | 0.0587 | 7493 (`$1D45`) |
| NTSC | 1,022,727 | 0.0610 | 7218 (`$1C32`) |

A frequency table computed for one clock plays out of tune on the other: a PAL table on NTSC plays 3.8% sharp, about two-thirds of a semitone. A program that runs on both standards needs one table per clock, or a table it scales at start-up.

Pulse duty cycle in percent = pulse-width value ÷ 40.95. A value of `$800` gives a square wave.

## 4. Envelope rates

| Value | Attack | Decay / release |
| --- | --- | --- |
| 0 | 2 ms | 6 ms |
| 1 | 8 ms | 24 ms |
| 2 | 16 ms | 48 ms |
| 3 | 24 ms | 72 ms |
| 4 | 38 ms | 114 ms |
| 5 | 56 ms | 168 ms |
| 6 | 68 ms | 204 ms |
| 7 | 80 ms | 240 ms |
| 8 | 100 ms | 300 ms |
| 9 | 250 ms | 750 ms |
| 10 | 500 ms | 1.5 s |
| 11 | 800 ms | 2.4 s |
| 12 | 1 s | 3 s |
| 13 | 3 s | 9 s |
| 14 | 5 s | 15 s |
| 15 | 8 s | 24 s |

The times are nominal, at a 1 MHz clock. Sustain is a level (0–15), not a time.

## 5. Voice interconnection

Sync and ring modulation take a second voice as their source: voice 1 uses voice 3, voice 2 uses voice 1, and voice 3 uses voice 2. Ring modulation works only with the triangle waveform selected on the modulated voice.

## 6. The 6581 against the 8580

The C64 shipped with the 6581 (NMOS) until about 1986 and the 8580 (HMOS-II) in the C64C. The two differ audibly:

- The 6581's filter varies from chip to chip and distorts; the 8580's filter is cleaner and more consistent. A tune mixed for one sounds different on the other.
- Combined waveforms, such as pulse with sawtooth, sound different on each chip.
- Writing the volume nybble of `$D418` plays 4-bit samples loudly on the 6581, because of a DC offset in its output. On the 8580, that trick is nearly silent without extra measures.

Emulators let the user choose the model. Code that relies on the filter or on volume samples should say which chip it targets.

## 7. Practical notes

- **Hard restart.** The envelope generator can delay a new note by up to about 33 ms when its rate counter has to wrap first (the "ADSR bug"). Music players avoid it with a hard restart: they clear the gate and set fast envelope rates a frame or two before the next note.
- **Random numbers.** Set voice 3 to the noise waveform at a high frequency, set `$D418` bit 7 to keep it silent, and read `$D41B` for a fresh random byte. Consecutive reads within a few cycles can return the same value.
- **Player timing.** A music player called once per frame runs at 50 Hz on PAL and about 60 Hz on NTSC, so a PAL tune plays 20% fast on NTSC unless the caller skips every sixth call or the player scales its speed. Tunes made for "multispeed" playback need several calls per frame at even intervals.
