# GATE4 — Conformance grep (live addon + TOC)

**Squad:** Phase 4 centerpiece close (handoff Phase 4; Ten Laws 1, 3, 4, 5, 6, 8, 10).  
**Scope:** `addon/ChurchOfBeef/**` (Lua + `ChurchOfBeef.toc` only).  
**Ignored:** `docs/archive/**`, `docs/reformation/**`, `attic/**`, `tests/**`.  
**Tells:** `Grant(`, points faucet, Prophet rank, standing store, activity leaderboard, `threshold`, `suggestion`; `SweepDeparted`; `SavedVariablesPerCharacter`; `SYNC_STATE` / `SYNC_REQUEST` as live product; `AWAITING_POPE` sixth state; `holdSeconds` timer; `Data/Popes.lua`; `AutoAdvance` / `Narrate`; ELO / pairing score; computed Famous Upsets.  
**Classification:** BAN / DISCARD / INCIDENTAL / LIVE (same as GATE1).  
**Product files:** not edited this pass. No commit.

---

## Verdict

**Criticals: none.** **Live leftover-product count: 0.**

Phase 1 Quiet shell, Phase 2 data layer, and Phase 3 runtime skeleton remain. Phase 4 added Runtime persist (schema 6 `event`), fail-closed STATE/SNAPSHOT wire, Gora sanction + Pope rulings, Knight/Lord Core verbs, a stock Director Console, an Event Mode Fight HUD (no live health), and a player-opened Records Book. None of those restore Grant, standing, Prophet, peer SYNC as authority, a sixth state, a hold timer, a registered-Pope file, or a ranked ladder.

Bootstrap still does not call Console / Hud / RecordsBook. Ritual verbs stay fail-closed (`IsRegisteredPope` always false). `#8` is uncoded. Those are named leftovers, not a demo rebuild.

Full harness at this write: **5248 passed, 0 failed**.

---

## TOC truth

Listed and present:

`Data/Ranks.lua`, `Core/Common.lua`, `Core/Runtime.lua`, `Core/Store.lua`, `Core/Archive.lua`, `Core/Recognition.lua`, `Core/Knighting.lua`, `Core/Officer.lua`, `Core/Sender.lua`, `Core/Roster.lua`, `Core/Gora.lua`, `Core/DB.lua`, `Net/Codec.lua`, `Net/Snapshot.lua`, `Net/BeefNet.lua`, `UI/MainFrame.lua`, `UI/Console.lua`, `UI/Hud.lua`, `UI/RecordsBook.lua`, `UI/Status.lua`, `UI/Minimap.lua`, `UI/Toasts.lua`, `ChurchOfBeef.lua`.

`## Interface: 20506`. `## SavedVariables: ChurchOfBeefDB` (account-level). No `SavedVariablesPerCharacter`.

Still absent: Scoring, Ladder, Ceremony, Instance, Quest, Standing/Ladder/Officer tabs, Announce, `Data/Popes.lua`.

---

## Critical

None.

## Important

None as live product. Named leftovers (not this grep’s job to wire):

- `ChurchOfBeef.lua` does not call `Console` / `Hud` / `RecordsBook` / `Knighting`. `/beef` is still the Quiet empty shell.
- `IsRegisteredPope` is always false. Console rituals and STATE/SNAPSHOT send do not fire on a live client.
- `#8` registered-Pope list is uncoded. INPUT channel is unspecified. Favor is omitted.
- HUD `Init` / `Refresh` are uncalled from bootstrap.

## Benign hits (waived one by one)

| File | Hit | Class | Waiver |
|------|-----|--------|--------|
| `Data/Ranks.lua:4` | No thresholds. No Beef Prophet. | BAN | Six titles. |
| `Core/Gora.lua:5–7` | RecordResult, GrantGora, ELO | BAN | Header forbids. Product loop is Sanction + Pope rulings. |
| `Net/BeefNet.lua` | `SUGGESTION` / `RANK_COMMIT` / `SYNC_*` | DISCARD | Retired inbound types. |
| `Core/Runtime.lua:6` | `holdSeconds` / sixth state | BAN | Header forbids. |
| `UI/MainFrame.lua:7` | GetLadderView | INCIDENTAL | Comment on leftover tab IA. |
| `ChurchOfBeef.toc:3` | Ceremony | INCIDENTAL | Notes title. |

## Phase 4 shape (present, not a demo rebuild)

| Piece | Live |
|-------|------|
| Persist | Schema 6 `{ version, ui, store, event }` |
| Wire | STATE GUILD + SNAPSHOT whisper; fail-closed |
| Gora | Petition / Sanction / four Pope rulings → Store |
| Knighting | `KnightThisBeef` / `ElevateToLord` on Store only |
| Console | Stock desks; rituals gated on `IsRegisteredPope` |
| HUD | Event Mode + live sanctioned pair; no health; no favor |
| Records Book | Quiet parchment superlatives; Famous Upsets flagged only |

## Tells with zero live hits

`Grant(`, `SweepDeparted`, `SavedVariablesPerCharacter`, `leaderboard`, `elo`/`ELO`/`MMR`, Prophet rank in `Ranks.LIST`, `AWAITING_POPE`, `holdSeconds` as a field, `AutoAdvance`, `Narrate`, `Data/Popes.lua`.

---

## Findings

### Critical

None.

### Important

None as LIVE product. Hosting leftovers are later integrator / `#8`, not a points ladder.

### Nit

1. `UI:RefreshLadder` name remains stale (GATE1 Nit).
2. Bootstrap does not host Console / HUD / Records Book (correct until a slash/host is specified).
3. `#8` remains uncoded (correct — Phase 4 spec, not license to build).
