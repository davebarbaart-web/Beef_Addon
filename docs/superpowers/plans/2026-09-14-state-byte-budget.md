# STATE byte budget — PROTOCOL 2 packed names + favor

**Date:** 2026-09-14  
**Status:** Measurement only. Codec was not edited. The 240-byte pin was not implemented.  
**Wave 2:** Task 8 (`2026-09-14-church-of-beef-first-night-wave-2.md`); spec items 38 and 114.  
**Law:** Bible §13.1 / §20.2 fields stay ids. Packed **display names** only. No W/L, H2H, title, stipulation, or clerical beat on the wire.

## Verdict

**Worst-case PROTOCOL 2 STATE is 112 bytes** (`#payload` through the live `Codec:EncodeState` path, then one trailing names field). `MAX_BODY` is 240 (`Net/BeefNet.lua`). **240 is not tight** for this pass: 128 bytes of headroom on the fattest codec-legal STATE, 183 on a first-night Gora with 12-letter names and a small favor overlay.

The pin still belongs on `Net:Send` / `_TransmitWhisper` (item 114). Unbounded favor/id **digits** can exceed 240 without any names — that is a separate codec hole, not a reason to skip names.

## How this was measured

Live `Codec.lua` is `PROTOCOL = 1`. `STATE_KEYS` has no `names`. `EncodeState({ names = ... })` returns `nil, "unknown field"`.

`encodeStateWire` emits:

```
version : STATE : eventId : state : riteType : candidate : fighters : sequence [ : favor ]
```

`#` is Lua 5.1 byte length (same as WoW). BeefNet refuses `#payload > 240` before `SendAddonMessage`. Wiki cap on the body is 255 characters (ASCII 1–255, no NULL); prefix `COB` is separate.

PROTOCOL 2 is the same skeleton with `2` instead of `1` (same one digit) plus **one** extra colon field for packed names. This file appends that field to live encode output. It does not invent a second TYPE or extra STATE schema.

Assumed names packing (Task 8; not coded):

- Subjects-mirror, one field: `candidateDisplay,fighterA,fighterB` (empty candidate → leading comma).
- `COB.Names.Display` form (realm suffix stripped). Same-realm Anniversary guilds do not need `Name-Realm` on this bus.
- Fail-closed if a name contains `:`.

Live decode already fail-closes a colon inside that trailing field: `1:STATE:1:RITE:Gora::8,9:3:2,1:Chuck:roast,Beefina` → `"unknown field"` (`#parts > expected + 1`).

## Name length (not 12 bytes as a separate cap)

| Source | What it says |
|--------|----------------|
| In-repo research `docs/research/wow-classic-addon-design/68-beefnet-message-catalog/wire-format-and-field-budgets.md` | Player names budgeted **3–12**; “Long Classic names (12+12)” |
| Classic naming (community / creation rules, not FrameXML) | Character names are **2–12 letters**. Not numbers, spaces, or `:`. |
| `Core/Common.lua` `Names.Display` | Strips `-Realm`. Budget the short form. |

**12 characters, not a 12-byte charset cap.** Latin/ASCII: 12 letters = 12 bytes, so the common “12-byte name” shorthand is true on US/EU Latin realms. Lua `#` and the SendAddonMessage body are bytes. A 12-letter Cyrillic name is 24 UTF-8 bytes; a 12-ideograph CJK name is typically 36. Those still fit (see below). Legal Latin names cannot contain `:`; the codec still refuses `:` so garbage/roster strings cannot inject parts.

## Live encode + PROTOCOL 2 names

All STATE rows used `ChurchOfBeef.Codec:EncodeState` from `addon/ChurchOfBeef/Net/Codec.lua` (2026-09-14 checkout). PROTOCOL 2 column = live wire with version `1`→`2` and the names field appended.

| Case | P1 STATE | P2 STATE | Headroom vs 240 | P2 SNAPSHOT |
|------|----------|----------|-----------------|-------------|
| Typical Gora, no favor (`Beefina`,`Chuckroast`) | 26 | 46 | 194 | 58 |
| Typical Gora + favor `2,1` | 30 | 50 | 190 | 62 |
| Typical Knighting (`Beefina`) | 29 | 37 | 203 | 49 |
| 12-letter Gora, no favor | 26 | 53 | 187 | 65 |
| **12-letter Gora + favor `2,1`** | 30 | **57** | 183 | 69 |
| 12-letter Gora + favor `40,40` | 32 | 59 | 181 | 71 |
| 12-letter Gora + favor `999,999` | 34 | 61 | 179 | 73 |
| 12-letter Gora, 6-digit ids, seq 4-digit, favor `40,40` | 50 | 77 | 163 | 89 |
| ASSEMBLY pair + 12-letter names + favor `2,1` | 30 | 57 | 183 | 69 |
| **Codec-legal fat** (below) | 73 | **112** | 128 | 124 |

**Codec-legal fat** (largest closed-set STATE the live encoder will emit, then three 12-letter names):

```
2:STATE:123456:CONSEQUENCE:Proclamation:123456:234567,345678:1234:999,999:CCCCCCCCCCCC,AAAAAAAAAAAA,BBBBBBBBBBBB
```

112 bytes. Candidate + two fighters is legal today (`test_net_codec.lua`). Favor requires exactly two fighters. Longest tokens: `CONSEQUENCE` (11), `Proclamation` (12). Ids/seq/favor digits are a never-delete / large-guild ceiling, not a first Tuesday.

**Product first-night Gora** (two 12-letter Displays, small ids, favor overlay):

```
2:STATE:1:RITE:Gora::8,9:3:2,1:,AAAAAAAAAAAA,BBBBBBBBBBBB
```

**57 bytes.**

SNAPSHOT response of the same body is **+12 bytes** (`SNAPSHOT:response` vs `STATE`). Task 8 pins both GUILD `Send` and whisper `_TransmitWhisper`. Fat SNAPSHOT is **124**; still 116 under 240.

### Packing variants on the typical+favor skeleton (30-byte P1)

| Names field | P2 STATE |
|-------------|----------|
| `AAAAAAAAAAAA,BBBBBBBBBBBB` (fighters only) | 56 |
| `,AAAAAAAAAAAA,BBBBBBBBBBBB` (empty candidate slot) | 57 |
| `CCCCCCCCCCCC,AAAAAAAAAAAA,BBBBBBBBBBBB` (cand + pair) | 69 |

Use the subjects-mirror form (empty candidate → leading comma) so slots stay positional.

## Field anatomy (fat 112)

| Part | Bytes |
|------|------:|
| `2` + `STATE` + 9 colons | 1+5+9 = 15 |
| `eventId` `123456` | 6 |
| `CONSEQUENCE` | 11 |
| `Proclamation` | 12 |
| candidate id `123456` | 6 |
| fighters `234567,345678` | 13 |
| sequence `1234` | 4 |
| favor `999,999` | 7 |
| names `C…,A…,B…` (12+1+12+1+12) | 38 |
| **Total** | **112** |

Favor overlay vs names: names dominate. Going from no favor to `2,1` adds 4 bytes (`:2,1`). Going from typical names to two 12-letter names adds 7–11 bytes. Three 12-letter names add 38.

## UTF-8 and `Name-Realm` (not the Task 8 budget)

| Variant | P2 STATE | vs 240 |
|---------|----------|--------|
| Fat + three 12-letter 2-byte names (24 bytes each) | 148 | 92 free |
| First-night Gora + two `Twelvechars-Whitemane` (forgot `Names.Display`) | 77 | 163 free |

Still not tight. Task 8 should still pack `Names.Display` only.

## Colon-in-name fail-closed

A `:` in a display name splits the colon grammar. Live `decodeStateFields` treats the extra part as `"unknown field"`. Task 8 keeps that fail-closed: do not escape, do not take the prefix, do not send.

Legal Classic Latin names cannot contain `:`. The check is for adversarial and mis-copied roster strings.

Nine-part ambiguity (favor omitted, names look like `12,8`): `parseFavorField` requires `^%d+,%d+$`. Classic letter names never match. Safer Task 8 shape: always emit the names field (empty when no subjects) so part counts stay 9 = names, 10 = favor + names.

## Is 240 tight?

**No** for packed fighter/candidate display names + favor.

| What | Bytes | Tight? |
|------|------:|--------|
| First-night 12-letter Gora + favor | 57 | No (183 free) |
| Never-delete 6-digit ids + 12-letter pair + favor | 77 | No |
| Codec-legal fat STATE | 112 | No (128 free) |
| Same as SNAPSHOT response | 124 | No |
| Mute-card replica (class, level, title, W/L, defenses, H2H, stipulation) | not measured | **Would be.** Wave 2 forbids it. |
| Unbounded `favor.a` / `favor.b` / ids (`isSeq` has no digit cap) | live encode of `1e15,1e15` is already 60 on P1 Gora | **Yes, if abused.** Not a names problem. |

Do not spend this headroom on W/L, H2H, or stipulation. OPEN_QUESTIONS **#27** beat, if ever licensed, must re-run this table.

## Task 8 pin (do not implement here)

When names land:

1. Allowlist one packed names field. Invert “STATE extra wire field” only for that field.
2. Refuse encode if any display name contains `:` or `\n`.
3. Harness: 12-letter pair + favor through `Net:Send` and `_TransmitWhisper`; `#payload <= 240`. Codec round-trip alone is not enough (item 114).
4. Do not add W/L, H2H, title, stipulation, or a clerical beat.

## Return

**112** (worst-case PROTOCOL 2 STATE, 12-letter Latin Displays, candidate + two fighters, favor on).  
First-night Gora pin target: **57**.
