# W-A — Codec: DECREE + FAVOR pick + optional STATE favor

**Exclusive files (only these):**
- `addon/ChurchOfBeef/Net/Codec.lua`
- `tests/test_net_codec.lua`

**Do not edit:** TOC, `ChurchOfBeef.lua`, `tests/run.lua`, `OPEN_QUESTIONS.md`, `docs/REFORMATION_LOG.md`, any other Lua.

**Do not commit.** TDD. Isolation asserts that would fail under `run.lua` stay `if standalone then`.

## Law

CONTINUE 2026-08-18 licenses 1–2. Bible §13.1, §10.6, §14.1. Encode/decode only. No `SendAddonMessage`. No extra types beyond adding `DECREE` to the closed set. HELLO stays on the transport.

Banned: `side`, favor history/streak/economy, narration, Grant-shaped keys, sixth state, `holdSeconds`.

## 1. TYPE `DECREE`

Add `DECREE` to `Codec.TYPES`. Count becomes 4.

Bible-named stored fields only (match `Core/Decree.lua`): `line` (required trimmed string), `flavor` (optional trimmed string). Header copy is not on the wire.

Wire (colon in the line is legal — “7:00 PM”):

- Encode: `1:DECREE:` + line. If flavor is present, append `"\n"` + flavor to the payload (newline is the only flavor separator).
- Decode: after `version` + `DECREE`, the remainder is the body. Split on the first `"\n"`: before = line, after = flavor (nil if absent). Empty line → error `"line is required"`.

Helpers: `EncodeDecree` / decode via `Encode({ type = "DECREE", line = ..., flavor = ... })` and `Decode`.

Refuse unknown fields, banned keys, empty/whitespace line, non-string flavor.

## 2. INPUT `favor` pick

Keep kind `favor`. Add Bible/license field **`pick`**: store integer character id of the chosen fighter (≥ 1).

Wire: `1:INPUT:favor:<characterId>:<pick>`

- `characterId` = the member who picked (existing).
- `pick` = the fighter they pick (required for favor).
- Encode without `pick` → `"pick required"` (or equivalent string).
- `side` remains unknown / refused.
- Favor still has no `text`.
- Petition unchanged (no extra field).
- Confession unchanged.

Add `pick` to `INPUT_KEYS`. For non-favor kinds, a present `pick` is `"pick not allowed"`.

Update the existing test that encodes favor with only `characterId` — that shape is now invalid.

## 3. Optional STATE / SNAPSHOT-response favor split

License: the split reaches the congregation only via STATE, and only when the Pope toggle is on. Toggle-off = field omitted.

Allow optional field `favor` on STATE and SNAPSHOT **response** only (not request).

Shape: `{ a = <non-negative integer>, b = <non-negative integer> }` — standing pick counts for `subjects.fighters[1]` and `subjects.fighters[2]`.

- Omit `favor` → current 8-field STATE wire (no extra part). Decode `favor == nil`.
- Present → one extra colon field after sequence: `countA,countB` (digits only).
- If `favor` present, `subjects.fighters` must be length 2; else error.
- `a`/`b` must be integers ≥ 0, not NaN/inf.
- SNAPSHOT request unchanged.
- Do not invent latest-wins / sequence gates.

`STATE_KEYS` / `SNAPSHOT_RES_KEYS` may include `favor`. Unknown extra keys still fail.

## Tests (extend `tests/test_net_codec.lua`)

- TYPES count is 4; `DECREE` true; retired kinds still nil.
- Decree encode/decode: line only; line + flavor; line containing `:`; refuse empty line; refuse unknown field.
- Favor encode/decode with `pick`; refuse missing pick; refuse `side`; petition still 4 parts.
- STATE without favor still decodes; STATE with favor round-trips; SNAPSHOT response with favor; request cannot carry favor.
- Existing STATE/SNAPSHOT/INPUT petition/confession tests stay green.

## Verify

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_net_codec.lua   # standalone
lua tests/run.lua              # full harness; only your suite should change
```

Report: files changed, test counts, any concern. No commit.
