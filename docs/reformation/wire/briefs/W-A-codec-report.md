# W-A — Codec: DECREE + FAVOR pick + optional STATE favor (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** CONTINUE 2026-08-18 licenses 1–2; Bible §13.1, §10.6, §14.1; brief `docs/reformation/wire/briefs/W-A-codec.md`.

Encode/decode only. Closed types are STATE, SNAPSHOT, INPUT, DECREE (count 4). HELLO stays on BeefNet. No `SendAddonMessage`. No `side`, favor history/streak/economy, narration, Grant-shaped keys, sixth state, `holdSeconds`, or sequence gate. Exclusive files only. No commit.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_net_codec.lua` | TYPES count 4 + `DECREE`. Favor now requires `pick`. Decree encode/decode (line, flavor, colon-in-line, refuse empty/unknown). STATE/SNAPSHOT-response favor split; request cannot carry favor. Petition still four parts. |
| `addon/ChurchOfBeef/Net/Codec.lua` | `DECREE` type + `EncodeDecree`. INPUT `pick`. Optional STATE / SNAPSHOT-response `favor` `{ a, b }`. |
| `docs/reformation/wire/briefs/W-A-codec-report.md` | This file |

Did not edit TOC, `ChurchOfBeef.lua`, `tests/run.lua`, `OPEN_QUESTIONS.md`, `docs/REFORMATION_LOG.md`, or any other Lua.

## Contract

### TYPE `DECREE`

- `Codec.TYPES.DECREE = true`. Exactly four types.
- Fields: `line` (required trimmed string), `flavor` (optional trimmed string). Header copy is not a field.
- Encode: `1:DECREE:` + line. If flavor is present after trim, append `"\n"` + flavor.
- Decode: after `version` + `DECREE`, remainder is the body (colon in the line is legal). Split on the first `"\n"`: before = line, after = flavor (nil if absent/blank).
- Empty or whitespace line → `"line is required"`.
- Helpers: `EncodeDecree` / `Encode({ type = "DECREE", ... })` and `Decode`. No `DecodeDecree` (brief named encode + unified decode only).
- Refuse unknown fields, banned keys, non-string flavor.

### INPUT `favor` pick

- Wire: `1:INPUT:favor:<characterId>:<pick>`. `pick` is a store integer ≥ 1.
- Encode without `pick` → `"pick required"`. Present but not an id → `"invalid pick"`.
- `side` remains unknown (`"unknown field"`). Favor still has no `text`.
- `pick` is in `INPUT_KEYS`. Non-favor kinds with `pick` → `"pick not allowed"`.
- Petition unchanged (four parts). Confession unchanged (remaining parts still join on `:`).

### Optional STATE / SNAPSHOT-response favor

- Optional `favor = { a, b }` (non-negative integers) on STATE and SNAPSHOT **response** only.
- Omit → current 8-field STATE wire; decode `favor == nil`.
- Present → one extra colon field after sequence: `countA,countB` (digits only). Requires `subjects.fighters` length 2.
- SNAPSHOT request with `favor` → `"unknown field"`.
- A 9th STATE / 10th SNAPSHOT-response part that is not `digits,digits` stays `"unknown field"` (existing extra-field tests).
- No latest-wins / sequence gate in this module.

## TDD

1. Baseline: `lua tests/test_net_codec.lua` — **371 passed, 0 failed**.
2. Extended the suite first (TYPES=4, `EncodeDecree`, favor+`pick`, decree cases, STATE favor). Isolation asserts remain under `if standalone then`.
3. Red (before `Codec.lua`): `EncodeDecree exists` nil; `DECREE` nil; type count 3; favor-without-implementation encode nil (`1:INPUT:favor:8:9` missing). Suite then aborted on `favor` being nil.
4. Implemented `Codec.lua`.
5. Green: `lua tests/test_net_codec.lua` — **437 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_net_codec.lua   # 437 passed, 0 failed
lua tests/run.lua              # 6133 passed, 2 failed (not this suite)
```

| Suite | Result |
|-------|--------|
| `tests/test_net_codec.lua` standalone | 437 passed, 0 failed |
| `lua tests/run.lua` | 6133 passed, 2 failed |

Harness failures are downstream suites still encoding the old favor shape (exclusive-file; not edited):

- `tests/test_net_v2.lua:433` — `EncodeInput({ kind = "favor", characterId = 2 })` now returns nil → whisper sees `"undecodable payload"` instead of `"unknown message type"`.
- `tests/test_ceremony_chaos.lua:470` — same encode; `Decode(nil)` aborts the suite.

W-D owns `test_net_v2.lua` and should add `pick` when favor becomes a live whisper. Chaos needs the same one-field update (integrator or that suite’s owner).

## Self-review

- Exclusive files only. Encode/decode only. No transport, no `side`, no extra types, no hold timer, no sequence gate.
- Decree body is taken from the payload after the second `:`, so `"7:00 PM"` round-trips. Newline is the only flavor separator. Trim matches `Core/Decree.lua` (`line is required`; whitespace flavor omitted).
- Favor `text` is still checked before `pick required`, so `{ kind = "favor", characterId = 1, text = "red" }` stays `"text not allowed"`.
- STATE without `favor` is unchanged on the wire. Decode copies `favor` so callers cannot mutate codec tables.
- `a == 0` / `b == 0` is valid (`isSeq`). NaN/inf/fraction/negative refuse as `"invalid favor"`.

## Concerns

1. **Full harness is red** until `test_net_v2.lua` and `test_ceremony_chaos.lua` pass `pick` on favor encode. Out of W-A file scope.
2. A decree `line` or `flavor` that itself contains `"\n"` is not refused; the first newline still splits. Not required by the brief; not invented as a new error.

No commit.
