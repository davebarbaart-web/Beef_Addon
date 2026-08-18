# B33-D — BeefNet refuses a whitespace whisper dest (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Anniversary `C_ChatInfo.SendAddonMessage(prefix, message, chatType, target)` — target is the whisper dest; License 2 / §13.1 whisper dest; Bible §13.1 (congregation inputs to the Pope client; no Pope-name lookup); brief `docs/reformation/vestments/briefs/B33-D-net-dest.md`. `_TransmitWhisper` / `SendPetition` / `SendConfession` / `RequestSnapshot` / `SendFavor` accepted `" "` because `target ~= ""`. `destName` trims via `Names.Trim` (fallback local `trim` `^%s+` / `%s+$`). Empty after trim is `"no target"` and does not transmit. Existing `""` / nil pins stay. Codec kinds unchanged. No dest on INPUT. No Pope-name lookup. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 632 passed, 0 failed (`lua tests/test_net_v2.lua`). Isolation wrap stays under `if standalone then` at file load (**11** nil pins). Nested dest `do`/`end` re-pins Store / UI / Popes / Gora / Confession (**5**). No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_net_v2.lua` | TDD first. Nested `do`/`end` after RequestSnapshot (Lua 5.1 200-local cap). `"   "` on SendPetition / SendConfession / RequestSnapshot / `_TransmitWhisper` / SendFavor returns false, `"no target"`, no transmit. `" "` same. Existing `""` / nil stay `"no target"`. `"  Host  "` spy target is `"Host"`. INPUT / SNAPSHOT payloads have no dest field. Codec kinds unchanged. Isolation wrap stays. |
| `addon/ChurchOfBeef/Net/BeefNet.lua` | `destName` wraps `Names.Trim` (else local `trim`). `_TransmitWhisper` / SendFavor / SendPetition / SendConfession / RequestSnapshot assign `target = destName(target)` and refuse when nil. Trim happens before `sentCount` / `transmit` / `SendAddonMessage`. |
| `docs/reformation/vestments/briefs/B33-D-net-dest-report.md` | This file |
| `docs/reformation/vestments/briefs/B33-D-net-dest.diff` | B33-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Codec.lua, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add dest to the INPUT payload. Did not look up a Pope name. Did not commit.

`git diff HEAD` on these two files also includes earlier BeefNet batches (working tree already dirty). The brief diff is the B33-D-only delta.

## Contract

```lua
local function destName(target)
  -- Names.Trim when Common is loaded; else trim (^%s+ / %s+$)
  -- empty / non-string → nil
end

function Net:_TransmitWhisper(payload, target)
  -- payload gates unchanged; then target = destName(target)
  -- nil → false, "no target" (before sentCount / transmit)
end

function Net:SendFavor(fields, target, nowSeconds)
  -- target = destName(target); nil → false, "no target"
end

function Net:SendPetition(fields, target, nowSeconds)
  -- same dest gate; body still petition+id (+ opponent name only)
end

function Net:SendConfession(fields, target, nowSeconds)
  -- same dest gate; body still confession+id (+ text)
end

function Net:RequestSnapshot(target, nowSeconds)
  -- same dest gate; body still Snapshot:Request()
end
```

| Gate | SendPetition / SendConfession / RequestSnapshot / SendFavor / `_TransmitWhisper` |
|------|----------------------------------------------------------------------------------|
| `nil` / `""` | `false, "no target"` — no transmit |
| `"   "` / `" "` | `false, "no target"` — no transmit |
| `"  Host  "` | transmit; spy target is `"Host"` |
| INPUT payload | no dest field (`1:INPUT:petition:12` / favor+pick / confession+text) |

Keep:

- Existing `""` / nil `"no target"` pins
- Congregation whisper is not Pope-gated
- No `LookupPope` / `FindPope` / `COB.Popes` read
- Codec kinds / EncodeInput field order unchanged
- `_TransmitWhisper` size cap 240; immediate WHISPER, not the GUILD queue
- SendState / SendSnapshot / SendDecree stay Pope-gated
- Isolation wrap stays (Common + Runtime + Codec + Snapshot + Sender + BeefNet)
- No new main-chunk locals

### Unchanged

- SendPetition without target / empty target still `"no target"`.
- SendConfession newline still `"invalid text"`.
- RequestSnapshot body is still `1:SNAPSHOT:request`.
- B17-B named-opponent petition pins.
- Accept-false STATE / SNAPSHOT / unstubbed DECREE pins.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_net_v2.lua` first (nested dest `do`/`end` after RequestSnapshot: `"   "` / `" "` refuse on SendPetition / SendConfession / RequestSnapshot / `_TransmitWhisper` / SendFavor; existing `""` / nil stay; `"  Host  "` spy target is `"Host"`; no dest on INPUT; Codec kinds unchanged; isolation re-pins). Isolation wrap and existing `""` / nil / B17-B pins untouched.
2. Red: `lua tests/test_net_v2.lua` — **602 passed, 30 failed** (`SendPetition` / `SendConfession` / `RequestSnapshot` / `_TransmitWhisper` / `SendFavor` whitespace dest sent; padded dest spy saw `"  Host  "`). Existing `""` / nil / Codec kind / isolation pins stayed green.
3. `destName` trims via `Names.Trim` (else local `trim`). Early refuse and `_TransmitWhisper` both call it. Empty after trim is `"no target"` before `sentCount` / `transmit`.
4. Green: `lua tests/test_net_v2.lua` — **632 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_net_v2.lua   # 632 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_net_v2.lua` standalone | **632 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 nil pins under `if standalone then` at file load (Store, UI, DB, Popes, Officer, Ranks, Archive, Recognition, Gora, Decree, Confession). Nested dest block re-pins Store / UI / Popes / Gora / Confession. Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Codec / glue / TOC / bootstrap were not edited.
- `destName` is the only new helper. One trim. Early refuse and transmit both refuse `" "`.
- `"   "` / `" "` return `false, "no target"` and do not increment `sent` / `#wire`.
- `"  Host  "` spy target is `"Host"`. INPUT payloads stay kind+id (+ pick / text / opponent name).
- Existing `""` / nil pins stay. `LookupPope` stays nil.
- Isolation wrap stays. No new main-chunk locals.

## Leftovers

- **No client smoke / full harness.** Memory-only. Anniversary `SendAddonMessage(..., "WHISPER", target)` with a trimmed dest is not walked in-game this lane.
- **SendSnapshot** still has no early `destName`. It is Pope-gated first; `_TransmitWhisper` still trims if a stubbed Pope send reaches it.
- **Inbound snapshot reply** now passes `sender` through `destName`. A real CHAT_MSG_ADDON sender is unchanged; a whitespace sender would refuse the reply.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Isolated **632 / 0**. Isolation wrap **11**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
