# B34-D — SendSnapshot destName before encode (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Anniversary `C_ChatInfo.SendAddonMessage(prefix, message, chatType, target)` — target is the whisper dest; License 2 / §13.1 whisper dest; Bible §13.1 (Pope client is the snapshot writer; no Pope-name lookup); brief `docs/reformation/vestments/briefs/B34-D-snapshot-dest.md`. `SendFavor` / `SendPetition` / `SendConfession` / `RequestSnapshot` already `destName` before encode. `SendSnapshot` Pope-gated then `EncodeSnapshot` then `_TransmitWhisper`, so whitespace dest still encoded. `_LocalPope()` stays first (existing non-pope pins stay `"not a registered pope"`). Then `destName(target)`; empty after trim is `"no target"` and does not `EncodeSnapshot`. Then encode + `_TransmitWhisper`. `_TransmitWhisper` still trims. No dest on SNAPSHOT body. No Pope-name lookup. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 682 passed, 0 failed (`lua tests/test_net_v2.lua`). Isolation wrap stays under `if standalone then` at file load (**11** nil pins). Nested B33-D dest `do`/`end` re-pins Store / UI / Popes / Gora / Confession (**5**). Nested B34-D snapshot dest `do`/`end` re-pins the same five. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_net_v2.lua` | TDD first. Nested `do`/`end` after B33-D. Unstubbed `SendSnapshot` whitespace / `""` / nil / `"  Host  "` stay `"not a registered pope"`; spy `EncodeSnapshot` count 0; no whisper. Stub `IsRegisteredPope` (same pattern as the later decree stub): `"   "` / `" "` / `""` / nil is `"no target"`, encode count 0, no whisper. `"  Host  "` with `{ role = "request" }` encodes once and whispers target `"Host"`; payload stays `1:SNAPSHOT:request` (no dest). Restore `EncodeSnapshot` and `IsRegisteredPope`. Isolation wrap stays. |
| `addon/ChurchOfBeef/Net/BeefNet.lua` | `SendSnapshot` keeps `_LocalPope()` first. Then `target = destName(target)`; nil is `"no target"` before the codec check / `EncodeSnapshot`. Then encode + `_TransmitWhisper`. Existing `destName` (~86). No dest on SNAPSHOT body. No Pope-name lookup. |
| `docs/reformation/vestments/briefs/B34-D-snapshot-dest-report.md` | This file |
| `docs/reformation/vestments/briefs/B34-D-snapshot-dest.diff` | B34-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Codec.lua, Snapshot.lua, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add dest to the SNAPSHOT payload. Did not look up a Pope name. Did not invent a Pope name in `Data/Popes.lua`. Did not commit.

`git diff HEAD` on these two files also includes earlier BeefNet batches (working tree already dirty). The brief diff is the B34-D-only delta.

## Contract

```lua
function Net:SendSnapshot(fields, target)
  -- _LocalPope() first → false, "not a registered pope"
  -- target = destName(target); nil → false, "no target" (no EncodeSnapshot)
  -- EncodeSnapshot(fields); then _TransmitWhisper(payload, target)
end
```

| Gate | `SendSnapshot` |
|------|----------------|
| Unlisted Pope (any dest, including `"   "` / `""` / nil / `"  Host  "`) | `false, "not a registered pope"` — no encode, no whisper |
| Stubbed Pope + `nil` / `""` / `"   "` / `" "` | `false, "no target"` — no encode, no whisper |
| Stubbed Pope + `"  Host  "` + `{ role = "request" }` | transmit; spy target is `"Host"`; body `1:SNAPSHOT:request` |

Keep:

- Existing non-pope `SendSnapshot` pins (`"not a registered pope"`)
- `_LocalPope()` before dest trim
- `_TransmitWhisper` still trims
- No dest field on SNAPSHOT
- No `LookupPope` / `FindPope` / `COB.Popes` read
- Isolation wrap stays (Common + Runtime + Codec + Snapshot + Sender + BeefNet)
- No new main-chunk locals
- `IsRegisteredPope` restored after the stub

### Unchanged

- Congregation `SendFavor` / `SendPetition` / `SendConfession` / `RequestSnapshot` dest pins (B33-D).
- `_TransmitWhisper` whitespace / empty / nil `"no target"`.
- SendState / SendDecree stay Pope-gated and GUILD.
- RequestSnapshot stays not Pope-gated.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_net_v2.lua` first (nested snapshot dest `do`/`end` after B33-D: unstubbed SendSnapshot dest pins stay `"not a registered pope"`; stubbed Pope whitespace / `""` / nil is `"no target"` with `EncodeSnapshot` count 0; `"  Host  "` spy target is `"Host"`; no dest on SNAPSHOT; restore the Pope stub; isolation re-pins). Isolation wrap and existing non-pope / B33-D pins untouched.
2. Red: `lua tests/test_net_v2.lua` — **681 passed, 1 failed** (`empty dest does not EncodeSnapshot` expected 0 got 4). Non-pope `"not a registered pope"` pins and the padded-dest transmit pin stayed green (`_TransmitWhisper` already trims).
3. `SendSnapshot` assigns `target = destName(target)` after `_LocalPope()` and before `EncodeSnapshot`. Empty after trim is `"no target"`.
4. Green: `lua tests/test_net_v2.lua` — **682 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_net_v2.lua   # 682 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_net_v2.lua` standalone | **682 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 nil pins under `if standalone then` at file load (Store, UI, DB, Popes, Officer, Ranks, Archive, Recognition, Gora, Decree, Confession). Nested B33-D and B34-D blocks each re-pin Store / UI / Popes / Gora / Confession. Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Codec / Snapshot / glue / TOC / bootstrap were not edited.
- `_LocalPope()` stays first. destName is the existing helper. Empty dest does not encode.
- Unstubbed dest pins stay `"not a registered pope"`.
- Stubbed `"   "` / `" "` / `""` / nil return `false, "no target"` and do not increment encode / `sent` / `#wire`.
- `"  Host  "` spy target is `"Host"`. SNAPSHOT payload stays `1:SNAPSHOT:request`.
- `IsRegisteredPope` and `EncodeSnapshot` are restored. `LookupPope` stays nil.
- Isolation wrap stays. No new main-chunk locals.

## Leftovers

- **No client smoke / full harness.** Memory-only. Anniversary `SendAddonMessage(..., "WHISPER", target)` with a trimmed SendSnapshot dest is not walked in-game this lane.
- **Double trim on the happy path.** `SendSnapshot` destName then `_TransmitWhisper` destName again. Required: `_TransmitWhisper` still trims.
- **`{ role = "request" }` is a test body.** Brief allowed it so encode/transmit can be pinned without inventing a snapshot schema or a Pope name.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Isolated **682 / 0**. Isolation wrap **11**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
