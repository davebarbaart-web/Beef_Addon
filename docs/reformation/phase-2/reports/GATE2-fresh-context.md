# GATE2 — Fresh-context data-layer test

**Agent:** fresh (no prior conversation).  
**Job:** try to refute that Phase 2 (Re-Found the Data Layer) succeeded — account-level Pope store + Archive + Recognition + persist — without rebuilding the points-ladder demo or inventing Phase 3–4 product.  
**Read:** `docs/design/Game_Design_Bible_v1.1.1.md` (§12, §13.1, §13.5, §10.9, §15, §16; Laws), `docs/reformation/phase-0/TEN_LAWS.md`, and live shipped code listed below.  
**Did not read as product law:** `docs/archive/**`, Reformation briefs/reports, archived specs.  
**Did not invent** Phase 3–4 product (Director Console, Decree, ceremony runtime, BeefNet v2, registered-Pope file).  
**Did not edit** addon Lua, TOC, tests, or `OPEN_QUESTIONS.md`.

**Shipped load list** (`addon/ChurchOfBeef/ChurchOfBeef.toc`):

```
Data\Ranks.lua
Core\Common.lua
Core\Store.lua
Core\Archive.lua
Core\Recognition.lua
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

**TOC packaging:** `## Interface: 20506`. `## SavedVariables: ChurchOfBeefDB` (account-level). No `SavedVariablesPerCharacter`. Every TOC path exists on disk.

---

## Verdict: GATE2_PASS

The refute fails. Live Lua implements an **account-level Pope store**, a **Sacred Archive codec**, a **Rite of Recognition session**, and **SV persist** of that store. It does not implement a points-ladder demo. It does not ship Director Console, Decree, ceremony runtime, BeefNet v2, or a registered-Pope file.

No **Criticals**. Residuals (unused toast engine, unused co-play sensor, leftover `Gora:Challenge` notes, leftover `UI:RefreshLadder` / `ui.announce` names, no writer-role gate on Store) are documented below. They are revive risks or later-phase gaps, not a running demo and not invented Phase 3–4 product.

---

## 1. What product does the shipped code implement now?

**Quiet shell + data layer.** Not a points ladder. Not the Bible MVP.

| Layer | What ships | What does not |
|---|---|---|
| Presentation | Hideable minimap presence (`COB.Minimap`). Player-opened empty `/beef` frame (`COB.UI`). Roster/guild status chip while the frame is open (`COB.UI.Status`). Slash `/beef` and `/beef minimap`. | Decree, Director Console, Records Book, Event theater, Standing / Ladder / Officer tabs |
| Identity / records | In-memory Pope store: humans (rank, council, honorifics, history, linked character ids), characters (name/class/level/professions, Gora record), ceremony log, marked moments (`COB.Store`) | Profile UI, aggregation view, Curtain, Notebook |
| Linking | Rite of Recognition session: Pope or Council confirmer + logged-in character id → `Store:LinkCharacter` (`COB.Recognition`) | Self-service link widget, same-account / BattleNet auto-bind |
| Archive | String export / integrity check / import that Restores the store (`COB.Archive`) | Pope-console one-click, weekly reminder, Council cold mirror |
| Persist | Schema 5 `{ version, ui, store }`. `DB:Init` Restores a Snapshot-shaped `store`. `DB:Save` writes `Store:Snapshot()`. `PLAYER_LOGOUT` flushes (`COB:OnLogout`) | Mid-session flush; leftover demo-key import |
| Net | Transport + `HELLO` presence/version discovery. Retired `SUGGESTION` / `RANK_COMMIT` / `SYNC_*` discarded | State broadcast, snapshot, registered-Pope sender gate |
| Authority | `Officer:IsOfficerIndex` / `IsOfficerName` / `LocalIsOfficer` always `false` | Ritual verbs, Officer+ gates |
| Gora | Pair-key challenge notes only (`Gora:Challenge`). Results live on the character via `Store:RecordGoraResult` | Sanction loop, typed `RecordResult`, GrantGora, HUD |
| Ranks | Six titles, ids 1–6. `ChurchRankIdForGuildIndex` is a nil stub | Prophet, thresholds, roster→rank map |

This is **not** Bible MVP (§18 / §20 / §22): no console, no Quiet Decree, no ceremony machine, no sanctioned Gora presentation. Phase 2 claimed a data layer under the Quiet shell. That is what the load list implements.

---

## 2. Does any live Lua still implement a banned engine?

**No.** Searched the TOC-loaded tree for Grant / standing / suggestion / Prophet / Officer+ rituals / activity leaderboards / per-character “alts start fresh.”

| Banned engine | Live result |
|---|---|
| **Grant / points / standing** | No `Grant`, `GrantGora`, `GrantCeremony`, points wallet, or standing table. `Archive.isGrantShaped` **rejects** keys named `points`, `standing`, or `grant*` on import (`Archive.lua`). `DB:applyDefaults` does not import leftover ladder / scoring / suggestion keys into `store`. |
| **Suggestion** | No suggestion module. `Net.RETIRED_TYPES.SUGGESTION` is discarded unread (`BeefNet.lua`). |
| **Beef Prophet** | Absent from `COB.Ranks.List` (`Ranks.lua`). |
| **Officer+ rituals** | `Officer:IsOfficerIndex`, `Officer:IsOfficerName`, `Officer:LocalIsOfficer` return `false` (`Officer.lua`). No knight / sanction / verdict / elevate / canonize verbs in UI or Net. |
| **Activity leaderboards** | No hours, combat minutes, contribution scores, or activity boards. `Group.CountGuildmates` exists in `Common.lua` and has **no caller** in the load list. |
| **Per-character “alts start fresh”** | TOC is account `SavedVariables`. Store is account-wide humans + characters. `Store:CreateCharacter` does not assign a rank. `Store:RankForCharacter` returns the **human’s** `rankId` or `nil` if unlinked — not Fresh Beef on the alt. |
| **Peer authority / SYNC as truth** | `SYNC_REQUEST` / `SYNC_STATE` / `RANK_COMMIT` are retired discards. Live type is `HELLO` only. |

**Not a banned engine (residuals):**

- `Gora:Challenge` / `GetPending` / `_Prune` — local pair-key notes with a 1800s TTL. Not Grant, not a typed result, not wired to UI or Net. Social noise, not Church history.
- `UI:RefreshLadder` — name only; body calls `Minimap:Refresh` (`MainFrame.lua`).
- `COB.Toasts` — Event-Mode engine (`system` / `debug` only). Nothing in bootstrap, UI, or Net calls `Toasts:Init` / `Push` / `Show` / `Celebrate`.
- `DB` default `ui.announce = true` — no live reader.

---

## 3. Does the data layer match Bible §12 / §13.1 / §13.5?

**Yes, for Phase 2.** Rank lives on the human; Gora lives on the character; history is tombstoned, not deleted; Archive is a codec over the Pope store; SV is account-level; persist Restores and Saves that store. §13.5’s weekly reminder and Council cold mirror are Pope-console / later-phase surfaces — not invented here.

### §12 Player identity

| Bible | Live | Match |
|---|---|---|
| **§12.1 Human owns** rank, Council, honorifics, membership history | `Store:CreateHuman` / `SetRank` / `SetCouncil` / `AddHonorific`; `history` append-only; `ensureHuman` **nils** `row.gora` | Yes |
| **§12.1 Character owns** name, class, level, professions, Gora record | `Store:CreateCharacter`; `emptyGora` / `RecordGoraResult` on the character; `ensureCharacter` **nils** `row.rankId` | Yes |
| **§12.1 Profile aggregates** | `human.characterIds` + per-character `gora`. No profile UI (not invented) | Data yes; view later |
| **§12.2 No self-service linking** | `Recognition:Begin` requires `pope` or `council` plus a store character id. No UnitName widget, no same-account bind. `Complete` writes `Store:LinkCharacter` then `AppendCeremony("Recognition", …)` | Yes |
| **§12.3 Never deleted** | `TombstoneHuman` / `TombstoneCharacter` set `inactive`. No Sweep / Delete / Prune / expiry of humans, characters, ceremony log, or Gora results. `ResetForTests` no-ops unless `COB._IN_TEST` | Yes |
| **§12.4 Identity > name string** | Store ids are integers (`nextHumanId` / `nextCharacterId`). `Names.Key` is spelling-normalize only (roster / wire). Comment in `Common.lua` still says “ladder”; that is comment debt, not a keying law | Yes |
| **§12.5 Aggregation stays simple** | No computed service score. Career totals would be a sum of character Gora rows — not implemented as a ladder | Yes |
| **§12.6 Fallen** | Absent (deferred) | Correct |

`Store:LinkCharacter` remains a silent primitive. The shipped product path is `Recognition:Complete`. That is a store API, not a self-service UI.

### §13.1 Pope-authoritative star

| Bible | Live | Match |
|---|---|---|
| One writer: Pope’s store | `COB.Store` is the only mutator of ranks, records, ceremony log, marked moments. UI does not write store rows. Net does not apply ranks or verdicts | Yes (by absence of other writers) |
| Congregation = display + input | No congregation input opcodes. `HELLO` is presence/version only | Yes |
| One-way sequenced broadcast | Not shipped (BeefNet v2 / Phase 3–4 — not invented) | Correct omission |
| Persist is per-client SV | Account `ChurchOfBeefDB.store` holds `Store:Snapshot()` | Yes |

There is **no registered-Pope gate** on `Store:SetRank` / `RecordGoraResult` / `Archive:Import`. Any client that called those APIs could write locally. Phase 4 owns that file. Lack of a gate is not a second writer in the shipped UI/Net paths.

### §13.5 Sacred Archive

| Bible | Live | Match |
|---|---|---|
| One-action export (file/string), restorable import | `Archive:Export` stamps `Store:Snapshot()` as `COBARCH1` + digest + body. `Archive:Import` Restores only after `Check` / schema / banned-key walk | Codec yes; no console button (not invented) |
| Integrity | `Archive:Check` / `unstamp` digest; reject missing, empty, foreign, truncated, grant-shaped, `narration` | Yes |
| Bad archive is not a wipe | Failed `open` does not call `Store:Restore`. `DB:restoreFromSv` skips non-Snapshot `store` (including the empty `{}` hook) | Yes |
| Weekly reminder (cold only) | Absent | Correct omission |
| Council cold mirror (read-only) | Absent | Correct omission |

### §10.9 / §15 / §16 (data only — no invented surfaces)

- **§10.9** Character Gora: wins, losses, **narrative W/L `streak`**, head-to-heads, notable victims, rulings, results, `famousUpset` as a **flag** (not computed). `ensureCharacter` **strips** `defenses` / `defenseCount` (comment: Design Lead). That is a story-field gap vs §10.9, not a points engine. No damage meters, duration stats, per-class rates, or `#1 rating` ladder.
- **§15** `Store:AddHonorific` appends cosmetic text on the human. No mechanical benefit. No collapsed contribution number.
- **§16** `Store:FlagMoment` + `GetMarkedMoments` (flag hot). No `Canonize`, no generated scripture (`Archive` rejects `narration`). `ceremonyLog` is an append-only event list, not an activity feed UI.

### Persist (`DB.lua` + bootstrap)

- Schema 5: `{ version, ui, store }`.
- `isSnapshot` requires `humans` + `characters` tables. Empty `{}` is not Restored.
- `DB:Save` → `store = Store:Snapshot()` (table, not an Archive stamp). Leftover root keys stay at the SV root and are not copied into `store`.
- `COB:OnLoad` → `DB:Init`. `COB:OnLogout` → `DB:Save`.

---

## 4. Law-by-law check (live code)

### Law 1 — No points economy

**Hold.** No points, XP, currencies, dailies, engagement streaks, or thresholds.

- `Ranks.List` — six titles, no threshold fields (`Ranks.lua`).
- `Store:RecordGoraResult` — fight-record W/L and narrative `streak` only (Law 1’s fight-record exception; Bible §10.9).
- `Store:SetRank` — writes a rank id; does not score toward it. Lord `elevationAt` is a timestamp when rank 4 is set, not a threshold unlock.
- `Archive.walkBanned` / `isGrantShaped` — import refuse.

### Law 2 — Record events, never behavior

**Hold.** Store records ceremony entries, marked moments, Gora **results** (ruling + opponent + won). No hours, combat minutes, activity levels, or activity leaderboards.

- Residual: `Group.CountGuildmates` (`Common.lua`) — live group count, unused, not persisted.

### Law 3 — Pope holds ceremonial sovereignty

**Hold for this phase.** No Officer/Council ritual verbs in the shell.

- `Officer:IsOfficerIndex` / `IsOfficerName` / `LocalIsOfficer` — always `false`.
- `Recognition:Begin` allows confirmer `pope` or `council` (Bible §12.2). `Complete` writes the Pope store (`Store:LinkCharacter`), not a Council store.
- `Store:SetRank` / `RecordGoraResult` / `FlagMoment` are data APIs with no Director Console (not invented).

### Law 4 — Software proposes; the Pope ratifies

**Hold.** Nothing auto-declares, auto-advances, auto-announces in the Pope’s voice, or generates narration.

- `Store:RecordGoraResult` requires a caller-supplied `ruling` (`victor` / `cowardice` / `void` / `free`). No duel parser.
- `Store:SetRank` does not fire on a Gora win.
- `Archive` rejects a `narration` key.
- Toasts are not driven.

### Law 5 — Pope-authoritative star

**Hold for Phase 2.** One store; Net does not invent ranks or verdicts; UI does not record official outcomes.

- Writer: `COB.Store` only.
- `Net:OnAddonMessage` — `HELLO` or discard.
- `UI:OnStatusChanged` / `Status:Refresh` — guild/roster/version chip only.
- No registered-Pope sender check (Phase 4 — not invented). No second Archive writer: `Import` Restores the same store after checks.

### Law 6 — Quiet Mode contract

**Hold, with shell residuals.** Unbidden chrome is the minimap. No feeds, grant pips, or driven toasts.

- `MinimapButton:Init` — presence; left-click toggles `/beef`; tooltip is “Church of Beef” / “Left-click: /beef” (`Minimap.lua`).
- `UI:Init` — empty content host; no tabs (`MainFrame.lua`).
- `Status:Present` — chip hides when `ready` unless `Net.warnedVersion` (`Status.lua`). Version word is the §13.4 soft flag.
- `Net:_WarnVersion` — one chat line on protocol mismatch (`BeefNet.lua`).
- Decree is **absent** (not invented).
- Residuals: `Toasts.lua` still in TOC (undriven); `ui.shown` restore reopens the empty frame if it was left open (`UI:Init`); `ui.announce = true` unused.

### Law 7 — Church history is never deleted

**Hold.**

- Tombstones only: `Store:TombstoneHuman`, `Store:TombstoneCharacter`.
- No departed sweep, no record expiry, no prune of store rows.
- `Gora:_Prune` expires **challenge notes**, not Gora records.
- `Toasts.pruneRecent` is toast dedupe, not Church history.
- Rank on the human; Gora on the character (`Store:RankForCharacter`, `ensureCharacter` / `ensureHuman`).
- Account SV (`ChurchOfBeef.toc`).

### Law 8 — Combat is WoW’s

**Hold.** No ELO/MMR, rated matchmaking, combat analytics, or betting.

- `Gora:Challenge` does not start a duel or record an outcome.
- `Store:RecordGoraResult` stores a Pope ruling, not meters.

### Law 9 — Rank structure

**Hold.**

- `COB.Ranks.List`: Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher, Beef Council (`Ranks.lua`).
- Butcher comment: raid-team role, display-only this phase.
- No Prophet. Pope is not a rank. `ChurchRankIdForGuildIndex` returns `nil`.

### Law 10 — Hybrid visual law; UI never tells jokes

**Hold for the Quiet shell.**

- Functional: `BasicFrameTemplate`, stock fonts, stock grabber (`MainFrame.lua`). Footer text forced empty (`Status:Present`).
- No theatrical surfaces shipped (Records Book / Decree / seals not invented).
- Minimap tooltip is instructional, not a joke.
- Unused palette keys (`IdleTab`, `Gold`) are leftovers, not meme chrome.

### Hard safety

Lua/XML only. `## Interface: 20506`. Core has no `CreateFrame`. Net/UI API reads are `type()`-guarded. No injection or protected-action bypass in the load list.

---

## 5. What would have been a Critical (none found)

A **GATE2_FAIL** would have required one or more of:

1. A live Grant / standing / suggestion / Prophet / Officer+ ritual / activity-leaderboard / per-character-fresh-alts engine in TOC-loaded Lua.
2. Rank stored on the character row as truth, or unlinked alts defaulted to Fresh Beef.
3. History deletion (sweep, expiry, prune of Church records).
4. Per-character SV as the product store.
5. Archive missing, or import that wipes on a bad blob, or persist that does not Restore/Save the Pope store.
6. Shipped Director Console / Decree / ceremony runtime / BeefNet v2 / registered-Pope configuration (invented Phase 3–4).

None of those are in the load list.

---

## Residuals (not Criticals)

1. **`Gora:Challenge`** — leftover demo challenge book. Unused by UI/Net. Do not grow a typed-result path here.
2. **`Group.CountGuildmates`** — leftover co-play sensor. Unused. Do not persist it.
3. **`COB.Toasts`** — undriven Event-Mode engine still TOC-loaded.
4. **`UI:RefreshLadder`** and **`ui.announce`** — tombstone names / unused default.
5. **`Names` comment** (“each guild is its own ladder”) — comment debt in `Common.lua`.
6. **No Store writer-role gate** — expected until registered-Pope (do not invent that file).
7. **§10.9 `defenses`** — stripped on character Gora rows. Story field, not an economy. Do not invent the increment rule.
8. **§13.5 weekly reminder / cold mirror** — correctly absent. Do not invent console chrome.
9. **`Store:LinkCharacter` without a rite** — primitive exists; shipped session is `Recognition`. Do not add a silent Link button.

---

## Scope note

This review is conformance of **shipped Lua** against Bible identity/data law and the Ten Laws. It is not a Bible §22.3 Gathering, not a two-client net smoke, and not a claim that MVP is done.
