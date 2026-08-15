# Phase 4 Lane B — BeefNet v2 wire (STATE + SNAPSHOT only)

**Status:** DONE

**Cited:** Ten Laws 5, 6; Bible §13.1, §13.4, §20.2–20.3; brief `docs/reformation/phase-4/briefs/P4-B-wire.md`; `.cursor/rules/ceremony-runtime.mdc` (Broadcast and catch-up; discard non-Pope; whisper to Pope only); `GATE1_DESIGN_LEAD_DIRECTIVE.md` §4 **#8 do not code**. Phase 3 Codec / Snapshot / Sender / Runtime are signed.

Put the signed codecs on the kept transport. No TOC / bootstrap / `tests/run.lua` / Codec / Snapshot / Runtime / Sender / UI / DB edits. No `Data/Popes.lua`. No live INPUT channel. No holdSeconds. No Director Console. No peer SYNC. No commit. `OPEN_QUESTIONS.md` unchanged.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_net_v2.lua` | Created first. Isolated suite: Common + Runtime + Codec + Snapshot + Sender + BeefNet. |
| `addon/ChurchOfBeef/Net/BeefNet.lua` | STATE on GUILD and SNAPSHOT on WHISPER, behind fail-closed Sender. HELLO unchanged. |
| `docs/reformation/phase-4/reports/P4-B-wire.md` | This file |

`tests/test_net_validate.lua` and `tests/test_net_adversarial.lua` were not edited.

## Wire

HELLO stays the transport presence/version message. Prefix `COB`, channel `GUILD`, outbound burst/refill, inbound per-sender limits, and `_WarnVersion` are unchanged. Transport `TYPES` is still `{ HELLO = true }`.

STATE and SNAPSHOT are **not** added to that set. `OnAddonMessage` asks `Codec:Decode` only after the HELLO/retired doors. A body Codec will not decode (including `Net:Encode("STATE", "QUIET")` and `Net:Encode("SNAPSHOT", "x")`) stays `"unknown message type"`, so the HELLO-only suites stay green.

| Kind | Channel | Gate | Today |
|------|---------|------|-------|
| HELLO | GUILD | presence / version | unchanged |
| STATE | GUILD only | `Sender:Accept(sender, "STATE")` then `Runtime:Restore` of Bible fields only | Accept is false — discard; no Restore; not stored for later paint |
| SNAPSHOT response | WHISPER only | `Accept(sender, "SNAPSHOT")` then `Snapshot:ApplyResponse` | Accept is false — discard; no Apply |
| SNAPSHOT request | WHISPER only | not the theater Accept gate; `BuildResponse` only if `IsRegisteredPope` of the local player | always false — no one else answers; no GUILD fan-out |
| INPUT | any | not a live channel | `"unknown message type"`; no Restore; no inbox |
| SUGGESTION / SYNC_* / RANK_COMMIT | any | retired by name | discarded unread |

Outbound `SendState` / `SendSnapshot` run only if `IsRegisteredPope` of the local player. Always false today — no send. No Pope-name lookup.

Incompatible Codec STATE / SNAPSHOT: `_WarnVersion` + discard (`"protocol mismatch"`). That is the only Quiet notice. No second chat. No toast.

## API

| Method | Role |
|--------|------|
| `SendHello` / `HandleHello` / `PeerCount` | Unchanged transport presence. |
| `SendState(fields)` | Encode + GUILD send only if local `IsRegisteredPope`. Else `false, "not a registered pope"`. |
| `SendSnapshot(fields, target)` | Encode + whisper only if local `IsRegisteredPope`. Else `false, "not a registered pope"`. |
| `OnAddonMessage` | HELLO on GUILD; STATE on GUILD; SNAPSHOT on WHISPER; retired / unknown / mismatch as above. |

Private helpers (`_LocalPope`, `_HandleV2`, `_HandleState`, `_HandleSnapshot`, `_TransmitWhisper`) are the routing. `_TransmitWhisper` is only reachable after the local Pope gate (dead today). It does not look up a Pope name — the target is the given destination.

No RegisterPope, inbox, hold, Grant, SYNC, or Director APIs.

## Verification

- Isolated suite (`Core/Common.lua` + `Core/Runtime.lua` + `Net/Codec.lua` + `Net/Snapshot.lua` + `Core/Sender.lua` + `Net/BeefNet.lua`): **296 passed, 0 failed**.
- Lua 5.1.5. `lua tests/test_net_v2.lua` exits 0.
- HELLO-only suites (not edited): `test_net_validate.lua` **70 passed, 0 failed**; `test_net_adversarial.lua` **35 passed, 0 failed**.
- No `dofile` of Store / UI / DB / Officer / Ranks / Archive / Recognition / `Data/Popes.lua` / TOC / bootstrap / `tests/run.lua`.
- Guild-rank stubs were not called. v2 handlers do not `CreateFrame`.
- Codec, Snapshot, Runtime, Sender, TOC, bootstrap, `tests/run.lua`, UI unread for edits.

## Leftovers (other lanes — not fixed)

- **Integrator:** add `test_net_v2` to `tests/run.lua` when the harness lists isolated Phase 4 suites. TOC / bootstrap already load BeefNet; this lane did not touch them.
- **#8:** workspace registered-Pope list (same pattern as `Ranks.lua`), locally overridable. Until that list exists, no client paints theater from the wire and no client answers a snapshot request — including a real Pope character. That is the brief, not a bug.
- **INPUT:** Codec still encodes INPUT. This lane does not add a live channel or console inbox (channel unspecified — leftover).
- **Whisper throttle:** `_TransmitWhisper` does not share the GUILD outbound token bucket. Unreachable today (`IsRegisteredPope` is false). Do not invent a second queue until a Pope can send.

## Concerns

- Fail-closed Sender means a well-formed STATE / SNAPSHOT from a sender named "Pope" is discarded. Do not stub `IsRegisteredPope` true to "see theater."
- HELLO-only loads (validate / adversarial) never `dofile` Codec. Valid Codec STATE on those suites would still be `"unknown message type"`. That is load isolation, not a second protocol.
- `OPEN_QUESTIONS.md` was not edited. #8 remains uncoded.
- Do not claim V1 / MVP complete. Client smoke and a human Gathering (Bible §22.3) are not this lane.
