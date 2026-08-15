# GATE3 — Conformance grep (live addon + TOC)

**Squad:** Phase 3 ceremony-runtime close (handoff Phase 3; Ten Laws 4, 5, 6).  
**Scope:** `addon/ChurchOfBeef/**` (Lua + `ChurchOfBeef.toc` only).  
**Ignored:** `docs/archive/**`, `docs/reformation/**`, `attic/**`, `tests/**`.  
**Tells:** `Grant(`, points faucet, Prophet rank, standing store, activity leaderboard, `threshold`, `suggestion`; `SweepDeparted`; `SavedVariablesPerCharacter`; `SYNC_STATE` / `SYNC_REQUEST` as live product; `AWAITING_POPE` sixth state; `holdSeconds` timer; `Data/Popes.lua`; `AutoAdvance` / `Narrate`.  
**Classification:** BAN / DISCARD / INCIDENTAL / LIVE (same as GATE1).  
**Product files:** not edited this pass. No commit.

---

## Verdict

**Criticals: none.** **Live leftover-product count: 0.**

Phase 1 Quiet shell and Phase 2 data layer remain. Phase 3 added a Pope-owned four-state Runtime, STATE / SNAPSHOT / INPUT codecs, snapshot apply/build, a fail-closed sender stub, and an `awaitingPope` degrade flag. None of those restore Grant, standing, suggestion, Prophet, peer SYNC as authority, a sixth state, a hold timer, or a registered-Pope file.

BeefNet on the wire is still **HELLO only**. Codec / Snapshot / Sender / Runtime are loaded and unused by bootstrap. Event object is not persisted into `ChurchOfBeefDB`. Those are named leftovers, not a demo rebuild.

Full harness at this write: **3727 passed, 0 failed**.

---

## TOC truth

Listed and present:

`Data/Ranks.lua`, `Core/Common.lua`, `Core/Runtime.lua`, `Core/Store.lua`, `Core/Archive.lua`, `Core/Recognition.lua`, `Core/Officer.lua`, `Core/Sender.lua`, `Core/Roster.lua`, `Core/Gora.lua`, `Core/DB.lua`, `Net/Codec.lua`, `Net/Snapshot.lua`, `Net/BeefNet.lua`, `UI/MainFrame.lua`, `UI/Status.lua`, `UI/Minimap.lua`, `UI/Toasts.lua`, `ChurchOfBeef.lua`.

`## Interface: 20506`. `## SavedVariables: ChurchOfBeefDB` (account-level). No `SavedVariablesPerCharacter`.

Still absent: Scoring, Ladder, Ceremony, Instance, Quest, Standing/Ladder/Officer tabs, Announce, `Data/Popes.lua`.

---

## Critical

None.

## Important

None as live product. Named leftovers (not this grep’s job to wire):

- BeefNet send/recv is HELLO only. No `Codec` / `Snapshot` / `Sender` / `Runtime` token in `BeefNet.lua` or `ChurchOfBeef.lua`.
- `DB.lua` persists `Store:Snapshot()` only. Runtime event object is not in SV.
- `#8` registered-Pope list is uncoded. `IsRegisteredPope` is always false.

## Benign hits (waived one by one)

| File | Hit | Class | Waiver |
|------|-----|--------|--------|
| `Data/Ranks.lua:4` | No thresholds. No Beef Prophet. | BAN | Six titles; `ChurchRankIdForGuildIndex` nil. |
| `Core/Gora.lua:4` | RecordResult, GrantGora | BAN | Pair-key only. No callers. |
| `Core/Archive.lua` | `isGrantShaped` / points / standing | BAN | Import refuse list. Not a faucet. |
| `Net/Codec.lua` | `isGrantShaped` / points / standing | BAN | Encode refuse list. Not a faucet. |
| `Net/BeefNet.lua:8,60–63` | `SUGGESTION` / `RANK_COMMIT` / `SYNC_*` | DISCARD | Retired inbound types. Live vocabulary is HELLO. |
| `Core/Runtime.lua:6` | `holdSeconds` / sixth state | BAN | Header forbids both. Flag is `awaitingPope`. |
| `Core/Sender.lua:5` | `#8` / `IsRegisteredPope` | BAN | Always false. No `Data/Popes.lua`. |
| `UI/Toasts.lua:6` | Promote | BAN | Header: those KINDS are gone. |
| `UI/Status.lua`, `Minimap.lua`, `MainFrame.lua`, `Common.lua` | standing / GetLadderView | BAN or INCIDENTAL | Same as GATE1/2. |
| `ChurchOfBeef.toc:3` | Ceremony | INCIDENTAL | Notes title, not a file. |

## Phase 3 shape (present, not a demo rebuild)

| Piece | Live |
|-------|------|
| Runtime | `Runtime.lua` — QUIET → ASSEMBLY → RITE → CONSEQUENCE; Pope verbs; `MarkPopeLost` / `ClearPopeLost` |
| Codec | `Codec.lua` — encode/decode STATE / SNAPSHOT / INPUT only |
| Snapshot | `Snapshot.lua` — Request / BuildResponse / ApplyResponse; Bible fields; no send |
| Sender | `Sender.lua` — `IsRegisteredPope` always false; `Accept` INPUT-only |
| Degrade | `awaitingPope` on the event object; not `AWAITING_POPE`; not a wire field |
| Transport | `BeefNet.lua` — HELLO + version discard; v2 codecs not sent |

## Tells with zero live hits

`Grant(`, `GetLadderView` (except BAN comment), `SweepDeparted`, `SendSuggestion`, `RecordResult` (except BAN comment), `SavedVariablesPerCharacter`, `leaderboard`, `elo`/`ELO`/`MMR`, Prophet rank in `Ranks.LIST`, `AWAITING_POPE`, `holdSeconds` as a field, `AutoAdvance`, `Narrate`, `Data/Popes.lua`, Core `CreateFrame`.

---

## Findings

### Critical

None.

### Important

None as LIVE product. Wire and persist leftovers are later Net / persist, not a points ladder.

### Nit

1. `UI:RefreshLadder` name remains stale (GATE1 Nit).
2. Bootstrap does not call Runtime / Codec / Snapshot / Sender (correct until wire).
3. `#8` remains uncoded (correct).
