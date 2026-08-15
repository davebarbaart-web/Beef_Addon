# Phase 1 Lane J — BeefNet message cut

**Status:** DONE

**Cited:** Ten Laws 1, 5, 6; Bible §13.1, §13.4, §21.3; GATE1_DESIGN_LEAD_DIRECTIVE.md §3c (HELLO stays); brief `docs/reformation/phase-1/briefs/P1-J-beefnet.md`.

Transport skeleton kept. HELLO kept (version/presence; survives into v2). SUGGESTION and standing / threshold / petition / promote-toast paths deleted. Retired types discarded, never acted on. No BeefNet v2 codecs, snapshots, or Pope broadcasts. No TOC / bootstrap / `tests/run.lua` / Core / UI edits. No commit. `OPEN_QUESTIONS.md` unchanged.

## Files written

| Path | What changed |
|------|----------------|
| `addon/ChurchOfBeef/Net/BeefNet.lua` | Message cut. Live type is HELLO only. |
| `tests/test_net_validate.lua` | Rewrite. No `dofile` of Ladder/Scoring. |
| `tests/test_net_adversarial.lua` | Rewrite. No `dofile` of Ladder/Scoring. |
| `docs/reformation/phase-1/reports/P1-J-beefnet.md` | This file |

## What was kept

- Prefix `COB`, explicit `GUILD` channel, `PROTOCOL = 1`
- Encode / Decode framing (`VERSION:TYPE:fields...`), 240-byte body cap
- Outbound token bucket (burst 10, refill 1/s, queue cap 60)
- Inbound per-sender token bucket (burst 5, 0.2/s, sender-table cap)
- Protocol-version discard + one Quiet version-mismatch chat (`_WarnVersion`)
- `HELLO` send / handle / `PeerCount` (presence, not authority)
- API guards, server-provided sender as identity (`IsSelf` / `Names.Key`)
- Roster request / retry / `OnRosterUpdate` sensing (no hold-and-replay)
- `Init` prefix register, `CHAT_MSG_ADDON` + roster events, `SendHello`

## What was deleted

- `SendSuggestion`, `OnLocalSuggestion`, `HandleSuggestion`
- Promote / eligible toasts (`toastCelebrate`, `COB.Toasts`)
- Petition hold (`MaxHeld`, `_Hold`, `ReleaseHeld`, `held`)
- Ladder paint coalesce (`RefreshLadder`, `paintPending`)
- `RosterLookup` / `RosterReady` (officer-lookup helpers for petitions)

`SUGGESTION` joined `RANK_COMMIT` / `SYNC_REQUEST` / `SYNC_STATE` in `RETIRED_TYPES`. Named so an older build's petition dies quietly and is never acted on.

## Verification

Isolated `tests/test_net_validate.lua`: **70 passed, 0 failed**.

Isolated `tests/test_net_adversarial.lua`: **35 passed, 0 failed**.

Neither suite `dofile`s `Core/Ladder.lua` or `Core/Scoring.lua`. They load `Core/Common.lua` (name law) and `Net/BeefNet.lua` only.

`lua tests/run.lua` is still red on this branch from integrator-owned leftovers (missing suites, other lanes). Out of this lane to repair `tests/run.lua`.

## Leftover callers (not fixed)

| File | What remains |
|------|----------------|
| `ChurchOfBeef.lua` | `Net:Init()` / public `Net:Send` — transport, kept |
| `UI/MainFrame.lua` | `Net:RequestRoster` — sensing, kept |
| `UI/Status.lua` | reads `Net.warnedVersion` — §13.4 chip, kept |
| `Core/Officer.lua` | roster cache still exists; this lane no longer calls `GetRosterLookup` / `LocalIsOfficer`. `OnRosterUpdate` still falls back to `RefreshRosterCache` if Roster is absent |

## Concerns

1. **`SUGGESTION` still appears as a retired-type name** in `RETIRED_TYPES`. That is a discard table, not a live codec. Waive as a benign comment/table hit: the string must stay so old wires are recognized and dropped.
2. **No v2 invented.** `SNAPSHOT` / `STATE` / `SCORE_EVENT` decode as `unknown message type`.
3. **In-game `/reload` smoke was not run.** TOC on this branch still lists files deleted by other lanes, so a client install would not prove HELLO. Two-client guild-net smoke and Gate 1 §3e client smoke remain **owner: David**.
4. Roster request/retry stays in `Init` because Presence still needs a snapshot. That is sensing, not a petition queue.
