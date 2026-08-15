# GATE1 — Fresh-context excision test

**Agent:** fresh (no prior conversation).  
**Job:** try to refute that Phase 1 (The Excision) succeeded — that the shipped addon is a Quiet shell, not the points-ladder demo.  
**Read:** `docs/design/Game_Design_Bible_v1.1.1.md` (Laws / banned product), `docs/reformation/phase-0/TEN_LAWS.md`, and live shipped code listed below.  
**Did not read as product law:** `docs/archive/pre-reformation/**`, archived specs/plans, Reformation briefs/reports.  
**Did not invent** Phase 2–4 product (Director Console, Decree, sanctioned Gora, BeefNet v2, Pope store).  
**Did not edit** addon Lua, TOC, tests, or `OPEN_QUESTIONS.md`.

**Shipped load list** (`addon/ChurchOfBeef/ChurchOfBeef.toc`):

```
Data\Ranks.lua
Core\Common.lua
Core\Officer.lua
Core\Roster.lua
Core\Gora.lua
Core\DB.lua
Net\BeefNet.lua
UI\MainFrame.lua
UI\Status.lua
UI\Minimap.lua
UI\Toasts.lua
ChurchOfBeef.lua
```

**On-disk Core/UI (this checkout):** those TOC files only. `Core/Ceremony.lua`, `Core/Scoring.lua`, `Core/Ladder.lua` are gone. No Standing / Officer / Ladder tabs. No `Announce.lua` / `Sync.lua`.

---

## Verdict: GATE1_PASS

The refute fails. Live Lua does not implement a points economy, standing ladder, Grant / suggestion machinery, Beef Prophet, Officer+ rituals, or activity leaderboards. What ships is a **Quiet shell**: hideable minimap presence plus a player-opened empty `/beef` frame. Ranks are six titles with a nil guild-index map. Officer authority is always false. BeefNet is transport plus `HELLO`. Gora is pair-key challenge notes. DB defaults are `{ version, ui }`.

No **Criticals**. Residuals (tombstone names, unused toast engine, unused co-play sensor, per-character SV packaging) are documented below. They are revive risks, not a running demo.

---

## 1. What product does the shipped code implement right now?

**Quiet shell — not the points-ladder demo, and not the Bible MVP.**

A Tuesday login, from this code:

1. `ADDON_LOADED` → `COB.DB:Init()` (`ChurchOfBeef.lua` `COB:OnLoad`).
2. `PLAYER_LOGIN` → `COB.UI:Init()` then `COB.Net:Init()` (`COB:OnLogin`).
3. Minimap button (`COB.Minimap:Init` from `UI:Init`): presence icon, left-click toggles `/beef`, drag around the ring. No grant pip, no petition cue (`Minimap.lua` `fillTooltip` / `Refresh`).
4. `/beef` opens an insecure `BasicFrameTemplate` named `ChurchOfBeefFrame` with an **empty content host** — no tabs, no ladder, no officer desk (`MainFrame.lua` `buildFrame`, `UI:Init`). Footer/status chip is guild/roster/version only and hides when ready (`Status.lua` `CHIP` / `Present`).
5. Guild addon `HELLO` for version/presence discovery (`BeefNet.lua` `Net:SendHello` / `HandleHello`). Retired demo types are discarded (`RETIRED_TYPES`).
6. No Decree, no ceremony runtime, no Pope store, no Records Book, no sanctioned Gora loop. TOC `## Notes` still name that Bible product; the load list does not implement it.

**Not the points-ladder demo:** no Scoring, no Ladder, no Grant, no standing table, no suggestion fanout, no ceremony attendance ledger.

**Not Bible MVP (§22):** those surfaces are later phases. This review does not invent them.

Expected Phase 1 shape vs live:

| Expected | Live |
|----------|------|
| Minimap presence + player-opened empty `/beef` | Yes (`Minimap.lua`, `MainFrame.lua`) |
| Six titles, nil guild-index map | Yes (`Ranks.lua` `LIST`, `churchRankIdForGuildIndex`) |
| Officer authority always false | Yes (`Officer:IsOfficerIndex` / `IsOfficerName` / `LocalIsOfficer`) |
| BeefNet = transport + HELLO | Yes (`TYPES.HELLO`, `RETIRED_TYPES` discarded) |
| Gora = pair-key notes only | Yes (`Gora:Challenge` / `Cancel` / `GetPending`; no `RecordResult` / `GrantGora`) |
| DB = `{ version, ui }` | Yes (`DB.lua` `defaultDb`); leftover `ui.announce` default; unknown SV keys left in place |
| Ceremony.lua gone; Scoring/Ladder gone | Yes (not on disk, not in TOC) |

---

## 2. What is banned, and does any live Lua still implement a banned engine?

Banned (Bible §§4.6, 4.8, 4.9, 5, 6, 10, 12, 13, 17, 19; Ten Laws 1–10):

- Points, XP, currencies-as-wallets, dailies, engagement streaks, thresholds, Grant / standing / suggestion
- Behavior metrics (hours, combat minutes, activity levels) and activity leaderboards
- Officer/Council-performed rituals; auto-declare / auto-advance / generated narration
- Peer self-reported authority; distributed consensus
- Quiet-Mode feeds, dashboards, toasts, pips, sound (except the §13.4 version-mismatch notice)
- History prune / departed sweeps; per-character Church identity as product law
- ELO/MMR, rated matchmaking, combat analytics, betting; typed self-report Gora / `GrantGora`
- Beef Prophet; Pope-as-rank; threshold ranks
- UI that tells jokes; gameplay automation / injection

**No live module implements those engines.**

| Banned engine | Live status |
|---------------|-------------|
| Grant / standing / suggestion | No symbols, no schema required (`DB.lua`). Toast grant kinds gone (`Toasts.lua` header). |
| Scoring / Ladder | Files gone. `UI:RefreshLadder` is a **name only** — body calls `Minimap:Refresh` (`MainFrame.lua`). |
| Prophet | Not in `Ranks.LIST`. |
| Officer+ rituals | Authority predicates return `false` (`Officer.lua`). |
| Activity leaderboards | No ranked list UI. `Roster:GetOccupantCount` is snapshot size. `Net:PeerCount` is unused by UI. |
| Typed-result / `GrantGora` | Not present (`Gora.lua` header + API). |
| `SUGGESTION` / `RANK_COMMIT` / `SYNC_*` | Named only to **discard** (`BeefNet.lua` `RETIRED_TYPES`). Never applied. |
| Ceremony attendance / points | `Ceremony.lua` gone. |

**Residual (not a running engine):**

- `COB.Group.CountGuildmates` (`Common.lua`) — leftover “co-play tracker” sensor; no TOC caller except itself.
- `COB.Toasts` (`Toasts.lua`) — TOC-loaded presenter (`Push` / `Show` / `Celebrate`). No other shipped file calls it. `UI:Init` does not `Toasts:Init`. Frame is created only on first `Push`.
- `ChurchOfBeefDB.ui.announce = true` (`DB.lua` `defaultUi`) — no Announce module reads it.
- Demo keys left in an existing SV (`DB:applyDefaults` never deletes unknown fields). Live code does not read `ladder` / `scoring`.
- Tombstone names: `RefreshLadder`, comment “ladder” / “standing”, `RETIRED_TYPES`.

---

## 3. Would a competent agent rebuild Grant / standing / suggestion / Prophet / Officer+ rituals / activity leaderboards?

**No** — if they read this code **and** the Bible.

The Bible forbids each item (Laws 1, 2, 3, 9; §§4.6, 4.9, 5, 6, 10.9, 17). Live code does not offer a working Grant path, a standing table, a suggestion apply, a seventh rank, an Officer+ ritual gate, or a ranked activity list.

A **careless** agent could mistake tombstones for invitations:

| Temptation | Where | Why it must not be rebuilt |
|------------|-------|----------------------------|
| `UI:RefreshLadder` | `MainFrame.lua` | Name kept; body is minimap-only. Comment claiming BeefNet still invokes it is stale (`BeefNet` calls `NotifyStatus` → `OnStatusChanged`, not `RefreshLadder`). |
| `RETIRED_TYPES.SUGGESTION` / `RANK_COMMIT` / `SYNC_*` | `BeefNet.lua` | Discard list, not a codec to restore. |
| `Group.CountGuildmates` + “co-play bucket” | `Common.lua` | Law 2 sensor leftover. Do not hang an activity score on it. |
| `Toasts:Celebrate` | `Toasts.lua` | Grant-family kinds are gone; do not add them back. |
| `Roster` `churchRankId` / `GetChurchRankId` | `Roster.lua` | Always nil via `Ranks.ChurchRankIdForGuildIndex`. Do not invent a roster→rank map. |
| `Officer:GetRosterLookup` → `rankIndex` | `Officer.lua` | Display/membership sensing. Not a ritual gate. Authority functions are hard-false. |
| Comments that say “standing” / “each guild is its own ladder” | `Common.lua` | Identity-key hygiene comments, not a product ladder. |

Competence = follow the Bible, treat those as excision scars.

---

## 4. Law-by-law check (live code)

### Law 1 — No points economy

**Holds.** No points, XP, wallets, dailies, engagement streaks, or thresholds in live Lua.

- `Ranks.lua`: titles only; `churchRankIdForGuildIndex` returns `nil` — no threshold map.
- `DB.lua` `defaultDb`: `{ version, ui }` only; comments refuse `ladder.records` / `ladder.suggestions` / `scoring`.
- `Toasts.lua`: grant kinds (suggest, credit, demote, excommunicate) absent; `KINDS` = `system` / `debug`.
- `Gora.lua`: no `GrantGora`, no pair-pay.

### Law 2 — Record events, never behavior

**Holds** (unused sensor residue).

- No hours, combat minutes, contribution scores, or activity leaderboards.
- `Roster:GetOccupantCount` — snapshot cardinality, not a score.
- `Net:PeerCount` — HELLO presence count; `Status.lua` does not display it.
- **Residue:** `COB.Group.CountGuildmates` (`Common.lua`) counts guildmates in the current party/raid “for co-play to count.” Nothing else in the TOC load list calls it. Do not grow it into an activity engine.

### Law 3 — Pope holds ceremonial sovereignty

**Holds (vacuous).** No Knighting, sanction, verdict, elevation, or canonization verbs exist. Officers cannot perform rituals because `Officer:IsOfficerIndex`, `IsOfficerName`, and `LocalIsOfficer` all return `false`. `IsGuildRosterName` is membership only. This review does not invent a Director Console.

### Law 4 — Software proposes; the Pope ratifies

**Holds.** No auto-declared outcomes, auto-advanced queues, auto-announce in the Pope’s voice, or generated flavor.

- Slash `/beef` and `/beef minimap` chat lines are player-initiated (`ChurchOfBeef.lua` `SlashCmdList`).
- `Net:_WarnVersion` is the §13.4 mismatch notice (chat, once per session), not Pope voice.
- `Toasts:Push` is undriven.

### Law 5 — Pope-authoritative star

**Holds (transport only).** No peer authority, no applied `SYNC_STATE` / `RANK_COMMIT`, no congregation-originated theater.

- `Net:HandleHello` stores peer version strings; comment: “not authority.”
- Retired types return `"retired message type"` and are not acted on.
- No Pope store in this phase (not invented here).

### Law 6 — Quiet Mode contract

**Holds** for what actually renders.

- **Ambient:** minimap button only (`Minimap.lua`). Tooltip: “Church of Beef” / “Left-click: /beef.”
- **Player-opened:** empty `/beef` shell (`MainFrame.lua`). Status chip inside that frame: “Not in a guild” / “Reading the guild roster…” / “BeefNet version mismatch”; empty and hidden when ready (`Status.lua` `CHIP`, `SOFT_CHIP`, `Present`).
- **Decree:** not present (later phase; not invented).
- **Toasts:** file loads; no call site; no frame until `Push`.
- **Sound:** none in these files (template close-button hook may play Blizzard’s stock close sound — not a Beef cue).
- `ui.shown` restore (`UI:Init`) reopens `/beef` only if the player left it open — not a dashboard.

### Law 7 — Church history is never deleted; account-level identity

**Holds for records; packaging leftover on SV scope.**

- No Church rank/record store yet, so nothing to prune. `DB:applyDefaults` does not delete unknown keys.
- `Gora:_Prune` expires **challenge notes** (`CHALLENGE_TTL = 1800`) — social noise, not Church history (`Gora.lua` header).
- **Packaging leftover (not a Critical):** TOC ships `## SavedVariablesPerCharacter: ChurchOfBeefDB`. Bible §12.1 / Law 7 want account-level identity (rank on the human). Phase 1 persists only `{ version, ui }` (window, minimap angle/hide). Alts do not lose Church history because none is stored. This is demo SV scope, not a points engine. Do not treat per-character SV as product law.

### Law 8 — Combat is WoW’s

**Holds.** `Gora.lua` is pair-key notes (`Challenge` / `Cancel` / `IsChallenged` / `GetPending`). No ELO/MMR, matchmaking, analytics, betting, typed win/loss, or `goraLordWin`. No combat API use in these files.

### Law 9 — Exact rank structure

**Holds.**

```lua
-- Data/Ranks.lua LIST
Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher, Beef Council
```

Ids 1–6. No thresholds. No Beef Prophet. Pope is not a rank. `ChurchRankIdForGuildIndex` is a nil stub. Roster may store `churchRankId` but it is always `nil` from that stub (`Roster.lua` `buildFromApi` / `seedLocalPlayer`).

### Law 10 — Hybrid visual law; UI never tells jokes

**Holds** for this shell.

- Functional `BasicFrameTemplate`; empty host; no theatrical surfaces (none should exist yet).
- Footer forced empty: “no joke chrome” (`MainFrame.lua` `FooterText`, `Status:Present`).
- Minimap tooltip is operational, not a joke.
- Unused palette tokens (`IdleTab`, `Seat`, `Gold` in `UI.Palette`) are leftovers, not tab IA.

### Hard safety

`## Interface: 20506`. Lua only. No bots, injection, or protected-action bypass in these files. Core modules do not `CreateFrame`. Product frame is insecure under `UIParent`.

---

## 5. Attempted refutes (why they are not Criticals)

These were the strongest attacks on “excision succeeded.” None restore a banned engine.

| Attack | Finding | Severity |
|--------|---------|----------|
| `Toasts.lua` still TOC-loaded | Engine exists; grant kinds gone; zero live callers; no Init from bootstrap | Major residue |
| `Group.CountGuildmates` | Co-play sensor still compiled; unused | Major residue |
| `## SavedVariablesPerCharacter` | Law 7 packaging leftover; Phase 1 store is UI-only | Major leftover |
| `UI:RefreshLadder` | Tombstone name; minimap refresh only | Minor |
| `ui.announce = true` | Dead default; no Announce module | Minor |
| Status chip in `/beef` | Player-opened guild/roster/version; hides when ready; §13.4 mismatch is allowed | Not a fail |
| `Gora:Challenge` still exists | Expected pair-key notes; no result/Grant path; no UI/Net caller | Expected |
| Orphan demo keys in old SV | `applyDefaults` leaves unknown keys; nothing reads them | Revive risk only |
| TOC Notes name ceremony / sanctioned Gora | Title copy; load list does not implement MVP | Note |

---

## Criticals

**None.**

---

## What a later agent must not do

- Do not restore Grant, standing, suggestion, Scoring, Ladder, Prophet, or Officer+ ritual gates from tombstone names.
- Do not hang points or activity scores on `CountGuildmates`, `PeerCount`, or `GetOccupantCount`.
- Do not add Quiet-Mode toast kinds or drive `Toasts:Push` outside Event Mode (and do not invent Event Mode here).
- Do not treat `SavedVariablesPerCharacter` or `Names.Key` as Church identity law.
- Do not invent Director Console, Decree, sanctioned Gora, BeefNet v2, or the Pope store in this checkout’s Phase 1 shape.
