# GATE2 — Conformance grep (live addon + TOC)

**Squad:** Phase 2 data-layer close (handoff Phase 2; Ten Laws 1, 5, 7, 9).  
**Scope:** `addon/ChurchOfBeef/**` (Lua + `ChurchOfBeef.toc` only).  
**Ignored:** `docs/archive/**`, `docs/reformation/**`, `attic/**`, `tests/**`.  
**Tells:** `Grant(`, points faucet, Prophet rank, standing store, activity leaderboard, `threshold`, `suggestion`; `SweepDeparted`; `SavedVariablesPerCharacter`; stored defense counter.  
**Classification:** BAN / DISCARD / INCIDENTAL / LIVE (same as GATE1).  
**Product files:** not edited this pass. No commit.

---

## Verdict

**Criticals: none.** **Live leftover-product count: 0.**

Phase 1 Quiet shell remains. Phase 2 added an in-memory Pope store, Sacred Archive codec, Core Rite of Recognition, account-level SV, and Snapshot persist. None of those restore Grant, standing, suggestion, Prophet, or a points faucet. Archive Import fail-closes on Prophet / points / standing / Grant-shaped keys. Store strips `defenses` / `defenseCount`. TOC is `## SavedVariables: ChurchOfBeefDB`.

Full harness at this write: **1589 passed, 0 failed**.

---

## TOC truth

Listed and present:

`Data/Ranks.lua`, `Core/Common.lua`, `Core/Store.lua`, `Core/Archive.lua`, `Core/Recognition.lua`, `Core/Officer.lua`, `Core/Roster.lua`, `Core/Gora.lua`, `Core/DB.lua`, `Net/BeefNet.lua`, `UI/MainFrame.lua`, `UI/Status.lua`, `UI/Minimap.lua`, `UI/Toasts.lua`, `ChurchOfBeef.lua`.

`## Interface: 20506`. `## SavedVariables: ChurchOfBeefDB` (account-level). No `SavedVariablesPerCharacter`.

Still absent: Scoring, Ladder, Ceremony, Instance, Quest, Standing/Ladder/Officer tabs, Announce.

---

## Critical

None.

## Important

None.

## Benign hits (waived one by one)

| File | Hit | Class | Waiver |
|------|-----|--------|--------|
| `Data/Ranks.lua:4` | No thresholds. No Beef Prophet. | BAN | Six titles; `ChurchRankIdForGuildIndex` nil. |
| `Core/Gora.lua:4` | RecordResult, GrantGora | BAN | Pair-key only. No callers. |
| `Core/Store.lua:180,444` | `gora.defenses = nil` | BAN | Strips a stored defense counter (Design Lead §4: derived later). |
| `Core/Archive.lua` | `isGrantShaped` / points / standing | BAN | Import refuse list. Not a faucet. |
| `Core/DB.lua:39` | leftover ladder / scoring / suggestions | BAN | Root leftovers not imported, not wiped. |
| `Net/BeefNet.lua:8,63` | `SUGGESTION` | DISCARD | Retired inbound type. |
| `UI/Status.lua`, `Minimap.lua`, `MainFrame.lua`, `Toasts.lua`, `Common.lua` | standing / Grant / RefreshLadder | BAN or INCIDENTAL | Same as GATE1. `RefreshLadder` is minimap-only. |
| `ChurchOfBeef.toc:3` | Ceremony | INCIDENTAL | Notes title, not a file. |

## Phase 2 shape (present, not a demo rebuild)

| Piece | Live |
|-------|------|
| Pope store | `Store.lua` — integer ids; rank on human; Gora on character; tombstone; `elevationAt` |
| Archive | `Archive.lua` — Export/Check/Import; fail-closed |
| Recognition | `Recognition.lua` — Begin/Complete/Cancel; `LinkCharacter` |
| Persist | `DB.lua` — Save Snapshot; Init Restores Snapshot-shaped only |
| SV scope | account-level `ChurchOfBeefDB` |

## Tells with zero live hits

`Grant(`, `GetLadderView` (except BAN comment), `SweepDeparted`, `SendSuggestion`, `RecordResult` (except BAN comment), `SavedVariablesPerCharacter`, `leaderboard`, `elo`/`ELO`/`MMR`, Prophet rank in `Ranks.LIST`.

---

## Findings

### Critical

None.

### Important

None.

### Nit

1. `UI:RefreshLadder` name remains stale (GATE1 Nit).
2. `Names.Display` comment still says “each guild is its own ladder.”
3. Congregation-vs-Pope persist policy is `#8` — not coded (correct).
