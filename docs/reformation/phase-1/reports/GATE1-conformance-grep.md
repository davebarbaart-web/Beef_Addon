# GATE1 — Conformance grep (live addon + TOC)

**Squad:** Phase 1 leftover-sweep close (Design Lead `GATE1_DESIGN_LEAD_DIRECTIVE.md` §5.3).  
**Scope:** `addon/ChurchOfBeef/**` (Lua + `ChurchOfBeef.toc` only).  
**Ignored:** `docs/archive/**`, `docs/reformation/**`, `attic/**`, `tests/**`, `.cursor/rules/**`.  
**Tells:** `Grant(`, points faucet, Prophet rank, standing store, activity leaderboard, `threshold`, `suggestion`; callers into Gora/Ceremony stubs (`RecordResult`, `COB.Ceremony`).  
**Also scanned:** `Scoring`, `Ladder`, `GetLadderView`, `SweepDeparted`, `SendSuggestion`, `elo`/`ELO`/`MMR`, `leaderboard`, `Celebrate(`.  
**Classification:** BAN = the line names the tell in order to forbid it. DISCARD = named so an old wire dies quietly. INCIDENTAL = substring / WoW API / leftover function name with no product path. LIVE = still implements the demo product.  
**Product files:** not edited this pass. No commit.

---

## Verdict

**Criticals: none.** **Live leftover-product count: 0.**

Shipped load list matches existing files (`Interface: 20506`). Scoring, Ladder, Ceremony, Instance, Quest, Standing/Ladder/Officer tabs, and Announce are absent from `addon/` and from the TOC. No `Grant(` call, no Prophet rank, no standing store, no activity leaderboard, no threshold table, no suggestion handler. `RecordResult` and `COB.Ceremony` have zero callers. `SUGGESTION` exists only as a retired inbound discard name.

Full harness at this write: **489 passed, 0 failed** (`lua tests/run.lua` exit 0).

---

## TOC truth

Listed and present:

`Data/Ranks.lua`, `Core/Common.lua`, `Core/Officer.lua`, `Core/Roster.lua`, `Core/Gora.lua`, `Core/DB.lua`, `Net/BeefNet.lua`, `UI/MainFrame.lua`, `UI/Status.lua`, `UI/Minimap.lua`, `UI/Toasts.lua`, `ChurchOfBeef.lua`.

`SavedVariablesPerCharacter: ChurchOfBeefDB` stays until Phase 2 (Design Lead §3d).

Absent from disk and TOC: `Core/Scoring.lua`, `Core/Ladder.lua`, `Core/Ceremony.lua`, `Core/Instance.lua`, `Core/Quest.lua`, `UI/StandingTab.lua`, `UI/LadderTab.lua`, `UI/OfficerTab.lua`, `UI/Announce.lua`.

---

## Critical

None.

## Important

None.

## Benign hits (waived one by one)

| File | Hit | Class | Waiver |
|------|-----|--------|--------|
| `Data/Ranks.lua:4` | `No thresholds. No Beef Prophet.` | BAN | Header forbids the tell. Six titles, ids 1–6. `ChurchRankIdForGuildIndex` always `nil`. |
| `Core/Gora.lua:4` | `RecordResult, GrantGora` | BAN | Header names excised APIs. No `function Gora:RecordResult`. Zero callers of `RecordResult` / `GrantGora` in `addon/`. Pair-key only. |
| `Core/DB.lua:4–5, 31, 57` | Standing / suggestion / Scoring / Ladder | BAN | Init requires `{ version, ui }` only. Leftover SV keys survive (Law 7). No standing store created. |
| `Core/Common.lua:16` | `standing quietly becomes three records` | INCIDENTAL | Identity-key warning. No standing table. |
| `Core/Common.lua:29` | `Each guild is its own ladder` | INCIDENTAL | Realm-strip rationale (guild isolation). Not a standing engine. Stale metaphor only. |
| `UI/Status.lua:5` | `standing, points, or grants` | BAN | Chip forbids those reads. Version-mismatch word is the §13.4 Quiet notice. |
| `UI/Minimap.lua:5, 70` | `no standing glance` / `Not a standing glance` | BAN | Presence only. |
| `UI/MainFrame.lua:6–7` | `Standing / Ladder / … GetLadderView` | BAN | Documents excised IA. No tab registry, no `ClassColorCode`. |
| `UI/MainFrame.lua:296, 301, 504, 564–566` | `RefreshLadder` | INCIDENTAL | Name leftover. Body is optional `Minimap:Refresh` only. BeefNet no longer calls it (stale comment; Lane J Nit). Not a ladder paint. |
| `UI/Toasts.lua:5, 523–527` | Grant kinds / `Celebrate` | BAN + keep | Grant / promote / rite kinds gone. `KINDS` is `system` / `debug`. `Celebrate` is engine back-compat; no live `addon/` caller. |
| `Net/BeefNet.lua:8, 63` | `SUGGESTION` | DISCARD | Header + `RETIRED_TYPES`. Inbound returns `"retired message type"` before any handler. No `SendSuggestion` / `HandleSuggestion`. GATE1 §3c / Lane J review: named discard, not a live codec. Must stay so an older build’s petition dies by name. |
| `ChurchOfBeef.toc:3` | `Ceremony` | INCIDENTAL | Product title in `## Notes`. Not a file listing. |
| `Core/Officer.lua:9, 77–80, 94` | `rankIndex` | INCIDENTAL | WoW guild rank index. Authority APIs always `false`. Cache is membership/display sensing (Bible §5 display/drift). |
| `Core/Roster.lua` | `rankIndex` / `guildRankIndex` | INCIDENTAL | Same: public guild display, `churchRankId` always nil. No `GetLadderView` / `SweepDeparted`. |
| `Data/Ranks.lua:21` | `_rankIndex` | INCIDENTAL | Unused guild-index arg on the nil stub. |

## Stub callers (§3b)

| Stub | Callers in `addon/` |
|------|---------------------|
| `RecordResult` | **none** (comment only in `Gora.lua`) |
| `GrantGora` / `Grant(` | **none** |
| `COB.Ceremony` / `Ceremony:` | **none** (`Ceremony.lua` deleted) |
| `SendSuggestion` / `HandleSuggestion` / `OnLocalSuggestion` | **none** |
| `GetLadderView` / `SweepDeparted` | **none** (comment only) |
| `COB.Scoring` / `COB.Ladder` | **none** |

## Tells with zero hits in live `addon/`

`Grant(`, `Prophet` (except BAN header), `leaderboard`, `elo`, `ELO`, `MMR`, `GetLadderView` (except BAN comment), `SweepDeparted`, `SendSuggestion`, `HandleSuggestion`, `MaybeSuggest`, `OfficerRankIndexMax`, `Eternal Grazing`.

`score` hits only as `uiScale` / comment fragments — none are a points faucet.

---

## Findings

### Critical

None.

### Important

None.

### Nit

1. `UI:RefreshLadder` name and “BeefNet still invokes” comment are stale after Lane J. Body is minimap-only. Rename is Phase 2+ polish, not a Spec miss.
2. `Names.Display` comment still says “each guild is its own ladder.” Identity law is correct; the word is leftover demo diction.
