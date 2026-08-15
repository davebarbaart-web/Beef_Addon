# GATE4 — Fresh-context Beef Gora + Director Console + Knighting skeleton test

**Agent:** fresh (no prior conversation).  
**Job:** try to refute that Phase 4 (Beef Gora + Director Console + Knighting) succeeded as a centerpiece skeleton — without rebuilding the points-ladder demo or inventing unanswered product.  
**Read:** `docs/design/Game_Design_Bible_v1.1.1.md` (§10, §18, §8, §10.9, §14.2, §20, §13.1, §13.4, Ten Laws), `docs/reformation/phase-0/TEN_LAWS.md`, and every Lua file listed in `addon/ChurchOfBeef/ChurchOfBeef.toc` (and the TOC).  
**Did not read as product law:** `docs/archive/**`, `docs/reformation/phase-4/briefs/**`, `docs/reformation/phase-4/reports/**` (except this file).  
**Did not invent:** `Data/Popes.lua` (#8), a live INPUT channel, favor, live HUD health (Appendix A #1), Decree deputy, tournament engine, defense increment.  
**Did not edit** addon Lua, TOC, tests, or `docs/design/OPEN_QUESTIONS.md`.

**Shipped load list** (`addon/ChurchOfBeef/ChurchOfBeef.toc`):

```
Data\Ranks.lua
Core\Common.lua
Core\Runtime.lua
Core\Store.lua
Core\Archive.lua
Core\Recognition.lua
Core\Knighting.lua
Core\Officer.lua
Core\Sender.lua
Core\Roster.lua
Core\Gora.lua
Core\DB.lua
Net\Codec.lua
Net\Snapshot.lua
Net\BeefNet.lua
UI\MainFrame.lua
UI\Console.lua
UI\Hud.lua
UI\RecordsBook.lua
UI\Status.lua
UI\Minimap.lua
UI\Toasts.lua
ChurchOfBeef.lua
```

**TOC packaging:** `## Interface: 20506`. `## SavedVariables: ChurchOfBeefDB` (account-level). No `SavedVariablesPerCharacter`. Every TOC path exists on disk. No `Data/Popes.lua` on the load list or on disk.

---

## Verdict: GATE4_PASS

The refute fails. Live Lua implements a **centerpiece skeleton**: sanctioned Gora verbs that write the Pope store, `KnightThisBeef` / `ElevateToLord` Church-record verbs, a Director Console module, an Event-Mode Fight HUD module, and a player-opened Records Book module. It does not implement a points-ladder demo. It does not implement Bible MVP (a live Gathering with hosted Console / HUD / favor / sanctioned night).

No **Criticals**. Leftovers are real and named below: **Console / HUD / Records are unhosted** (bootstrap never `Init`s them; `/beef` opens the empty Quiet shell), **OPEN_QUESTIONS #8 is uncoded** (`Sender:IsRegisteredPope` is always `false`, so Console rituals and BeefNet STATE / SNAPSHOT stay fail-closed), **no favor**, **no slash** for Console / HUD / Records. Those gaps are skeleton leftovers. They are not a missing host invented here, and they are not a Pope list.

This is not a Bible §22.3 Gathering. Do not claim V1 / MVP complete.

---

## 1. What product does the shipped load list implement now?

**Quiet shell + account-level Pope store + ceremony runtime + sanctioned-Gora / Knighting Core + unhosted Console / HUD / Records + fail-closed BeefNet v2.** Not a points ladder. Not the Bible MVP.

| Layer | What ships | What does not |
|---|---|---|
| Presentation | Hideable minimap presence (`COB.Minimap`). Player-opened empty `/beef` frame (`COB.UI`). Roster/guild status chip while the frame is open (`COB.UI.Status`). Slash `/beef` and `/beef minimap`. | Hosted Director Console, hosted Fight HUD, hosted Records Book, Decree UI, favor, sound, Standing / Ladder / Officer tabs |
| Console (module) | `COB.Console`: Event-Mode stock desk. Runtime verbs, Presence list, Knighting / Gora buttons, MARK THIS MOMENT. Rituals refuse unless `Sender:IsRegisteredPope(local)`. Toggle / Show / Hide only. | Slash, `/beef` wiring, `PLAYER_LOGIN` Init, GuildPromote, Notebook persist, favor, INPUT, Decree |
| Fight HUD (module) | `COB.Hud`: Event Mode. Shows only when Runtime ≠ QUIET **and** `Gora:GetSanctioned()` is a live pair. Mute cards: name, class color, level, title, W–L, head-to-head. `health = nil`, `favor = nil`. | Live health, favor split, defense count, bootstrap Init |
| Records Book (module) | `COB.RecordsBook`: Quiet, player-opened parchment pages for the nine §10.9 titles. Superlatives (`maxHolders`), not a sortable ladder. Famous Upsets = rows with `famousUpset == true`. Defenses and Tournament Champions pages stay empty. | Slash, `/beef` / minimap wiring, ranked table, computed-upset math, tournament engine |
| Ceremony machine | `COB.Runtime`: QUIET → ASSEMBLY → RITE (typed) → CONSEQUENCE. Pope-owned verbs. `awaitingPope` is a flag, not a sixth state. Schema 6 persists `event` via `Runtime:Snapshot` / `Restore`. | Auto-advance, narration, hosted start button |
| Gora | Petition (event-scoped) → Recommend (levels / H2H / named callout) → `Sanction` → `Propose` (does not write) → `DeclareVictor` / `CowardiceRecorded` / `Void` / `FreeRuling` → `Store:RecordGoraResult` on both characters | Auto-declare, GrantGora, typed `RecordResult`, ELO, favor, live INPUT, defense increment |
| Knighting | `COB.Knighting:KnightThisBeef` → store rank 3. `ElevateToLord` → store rank 4. Console buttons call these only when registered-Pope. | Guild-rank promote from Core, queue / targeting / raid markers, auto-elevate after a win |
| Identity / records | Pope store: humans (rank, council, honorifics, history), characters (Gora W/L/streak/H2H/rulings/results), ceremony log, marked moments | Profile UI, Curtain, Notebook body |
| Linking | Rite of Recognition session → `Store:LinkCharacter` (`COB.Recognition`) | Self-service link widget |
| Archive | String export / check / import (`COB.Archive`) | Console one-click, weekly reminder, Council cold mirror |
| Persist | Schema 6 `{ version, ui, store, event }`. `DB:Init` Restores Snapshot-shaped `store` and string-state `event`. `PLAYER_LOGOUT` flushes | Leftover demo keys imported into store |
| Codecs | STATE, SNAPSHOT (request / response), INPUT (petition / favor / confession) encode/decode | Live INPUT on the wire |
| Transport | Prefix `COB`, GUILD + WHISPER. HELLO presence. `SendState` / `SendSnapshot` and inbound STATE / SNAPSHOT **only if** registered-Pope Accept / `_LocalPope`. Retired `SUGGESTION` / `RANK_COMMIT` / `SYNC_*` discarded. | INPUT channel, congregation theater, a Pope who can actually send |
| Sender | `IsRegisteredPope` always `false`. `Accept` is true only for INPUT with a non-empty sender. STATE / SNAPSHOT never Accept. | Registered-Pope list / `Data/Popes.lua` |
| Authority | `Officer:IsOfficerIndex` / `IsOfficerName` / `LocalIsOfficer` always `false` | Officer+ ritual gates |
| Ranks | Six titles, ids 1–6. `ChurchRankIdForGuildIndex` is a nil stub | Prophet, thresholds, roster→rank map |

This is **not** Bible MVP (§22.1 / §22.3): no hosted console, no Quiet Decree, no Gathering theater, no favor, no sound, no human-run night. Phase 4 claimed a Gora + Console + Knighting **skeleton**. That is what the load list implements.

---

## 2. Is it a points-ladder demo?

**No.**

Searched the TOC-loaded tree for Grant / standing / suggestion / Prophet / Officer+ rituals / activity leaderboards / per-character “alts start fresh.”

| Banned engine | Live result |
|---|---|
| **Grant / points / standing** | No `Grant`, `GrantGora`, `GrantCeremony`, points wallet, or standing table. `Archive.isGrantShaped` and `Codec.hasBannedKey` **reject** keys named `points`, `standing`, or `grant*`. `DB:applyDefaults` does not import leftover ladder / scoring / suggestion keys into `store`. |
| **Suggestion** | No suggestion module. `Net.RETIRED_TYPES.SUGGESTION` is discarded unread. |
| **Beef Prophet** | Absent from `COB.Ranks.List`. |
| **Officer+ rituals** | `Officer` officer predicates return `false`. Console rituals gate on registered-Pope, not `rankIndex ≤ 1`. |
| **Activity leaderboards** | No hours, combat minutes, contribution scores, or activity boards. `Group.CountGuildmates` has **no caller** in the load list. |
| **Per-character “alts start fresh”** | TOC is account `SavedVariables`. Store is account-wide humans + characters. `Store:RankForCharacter` returns the **human’s** `rankId` or `nil` if unlinked. |
| **Peer authority / SYNC as truth** | `SYNC_REQUEST` / `SYNC_STATE` / `RANK_COMMIT` are retired discards. Catch-up is whisper SNAPSHOT from a Pope client; that path is fail-closed until #8. |
| **Ranked Gora ladder** | Records Book uses superlative holders, not a sortable “#1 rating” table. |

**Not a banned engine (residuals):** `Gora:Challenge` pair-key notes (TTL 1800, leftover social noise, not GrantGora); `UI:RefreshLadder` name (body calls `Minimap:Refresh`); undriven `COB.Toasts` (`system` / `debug` only); unused `ui.announce = true`; `Common.lua` comment that still says “ladder” for name-keying.

---

## 3. Is it Bible MVP (a live Gathering with hosted Console / HUD / favor / sanctioned night)?

**No.**

Bible §22.1 / §22.3 require a hosted Director Console, live Fight HUD (with the no-live-health fallback), congregation favor, Decree, sound, Records Book reachable on a Tuesday, and one complete real Gathering. None of that is hosted or runnable from `/beef`.

What ships toward MVP items 1–6 and 8 is a **skeleton**: Core verbs and unhosted UI modules exist; #8 keeps every ritual and every STATE / SNAPSHOT send/accept closed. Favor is not implemented. Do not treat this report as §22.3 done.

---

## 4. Does SANCTION BEEF GORA exist? Do Pope rulings write Store? Auto-declare?

**Sanction exists. Rulings write Store. Nothing auto-declares.**

`Gora:Sanction(fighterA, fighterB, stipulation)` requires a live Runtime event (`state ≠ QUIET` + `eventId`), two different known character ids, and at most one live pair. Optional one-line stipulation is remembered, not picked from a rules engine. Until sanction, petitions / recommendations are not a Gora.

Pope ruling verbs write both characters via `Store:RecordGoraResult` and then clear the live pair:

| Verb | Store ruling | `won` |
|---|---|---|
| `DeclareVictor(winnerId)` | `victor` | winner true / loser false |
| `CowardiceRecorded(fleerId)` | `cowardice` | fleer false / other true |
| `Void()` | `void` | no `won` |
| `FreeRuling(text)` | `free` | both `false` (OPEN_QUESTIONS #10 leftover; not a fifth outcome) |

`Gora:Propose` stores a proposal only. It does not write the store and does not call a ruling. No `CHAT_MSG_SYSTEM` / duel-parser path exists. No timer declares a victor. Elevation is a separate `Knighting:ElevateToLord` call — `DeclareVictor` does not auto-elevate.

Console wrappers (`Console:Sanction`, `DeclareVictor`, `CowardiceRecorded`, `Void`, `FreeRuling`) call the same Core verbs **only** when `Sender:IsRegisteredPope(local)` is true. Today that is always false.

---

## 5. Do KnightThisBeef / ElevateToLord exist? Guild promote from Core?

**Church-record verbs exist. Core never promotes in the guild.**

`Core/Knighting.lua`:

- `KnightThisBeef(humanId)` → `Store:SetRank(humanId, 3)` (Beef Knight).
- `ElevateToLord(humanId)` → `Store:SetRank(humanId, 4)` (Beef Lord). `SetRank` stamps `elevationAt` once on first Lord write.

Header and body: **Core never calls `GuildPromote` / `SetGuildRank`.** Console comments the same: no GuildPromote. Congregation clients have no promote path. Bible §8’s “guild-rank promotion where the API permits” is **uncoded** — leftover, not a Core promote invented here.

No Knighting queue, targeting assist, or raid markers. Presence can flag “needs Knighting” (human rank nil / 1 / 2) as display only.

---

## 6. Is there a Director Console? Does /beef open it? Are rituals fail-closed?

**A Console module exists. `/beef` does not open it. Rituals are fail-closed.**

`UI/Console.lua` builds `ChurchOfBeefConsoleFrame` (stock `BasicFrameTemplate`, Law 10 functional). Desks: runtime state + Start / Open-rite / Close / Continue / End; Presence; KNIGHT THIS BEEF / ELEVATE TO LORD; petition list; SANCTION BEEF GORA / Dismiss / DECLARE VICTOR / COWARDICE RECORDED / VOID / FREE RULING; MARK THIS MOMENT; a Notebook **header** with no persist.

`Console:Init` / `Show` / `Hide` / `Toggle` exist. **Nothing in the load list calls them.** `ChurchOfBeef.lua` `OnLogin` calls `COB.UI:Init` and `COB.Net:Init` only. `UI:Init` builds the empty Quiet shell and the minimap. Slash `/beef` → `COB.UI:Toggle`. No `/beef console` (or any other Console slash).

Every ritual / runtime verb on the Console returns `nil, "not the registered pope"` unless `Sender:IsRegisteredPope(localSender()) == true`. That predicate is always false (#8). Fail-closed.

---

## 7. Is there a Fight HUD? Live health? Favor? Quiet leak?

**A HUD module exists. No live health. No favor. No Quiet leak from the hosted path.**

`UI/Hud.lua` declares `MODE = "Event"`. `Refresh` shows only when `Runtime:Snapshot().state ~= "QUIET"` **and** `Gora:GetSanctioned()` returns a pair. Otherwise it hides and paints an empty view (`health = nil`, `favor = nil`).

Defined fallback is coded: cards without live health. No `UnitHealth`, nameplate scrape, or combat-log HP. No favor bar (INPUT channel unspecified; do not invent). Defense count is absent (store strips `defenses` / `defenseCount`; do not invent the increment).

`Hud:Init` is never called from bootstrap. The frame is not created on login. Quiet Mode therefore does not grow a HUD. If a later host called `Refresh` in QUIET, the module hides.

Unbidden Quiet chrome remains minimap + empty `/beef`. `Toasts.lua` is still TOC-loaded (`system` / `debug` only) and still undriven. `Net:_WarnVersion` is one chat line plus the status-chip word — the §13.4 notice, not a toast family. Decree is **absent** (not invented).

---

## 8. Is there a Records Book? Ranked ladder? Computed Famous Upsets?

**A Records Book module exists. Not a ranked ladder. Famous Upsets are flag-listed, not computed.**

`UI/RecordsBook.lua` declares `MODE = "QUIET"` (player-opened identity / history, Bible §14.2). Nine page titles match §10.9. Holders of a superlative share the page (`maxHolders`); there is no sort-by-rating table.

| Page | Live fill |
|---|---|
| Most Sanctioned Victories | max `gora.wins` |
| Longest Streak | longest consecutive `won == true` in `gora.results` (fight-record streak, not an economy) |
| Most Successful Defenses | **empty** (no derived defense stat; OPEN_QUESTIONS #9 not coded as an increment) |
| The Iron Chin | max `#gora.results` |
| Greatest Rivalry | most-fought pairing + running score |
| Famous Upsets | results with `famousUpset == true` only |
| The Undefeated | `wins >= 1` and `losses == 0` |
| The Glorious Martyr | max `gora.losses` |
| Tournament Champions | **empty** (no tournament engine) |

`Store:RecordGoraResult` accepts `famousUpset` as a caller flag. Gora ruling verbs do **not** set it. The book does not infer upsets from level, record, or odds. No Console “flag this upset” verb ships — leftover, not computed Famous Upsets.

`RecordsBook:Init` / `Toggle` are never called from bootstrap, slash, or minimap. Unhosted.

---

## 9. Is #8 coded? Is BeefNet still fail-closed for STATE/SNAPSHOT?

**#8 is not coded. STATE / SNAPSHOT are fail-closed.**

OPEN_QUESTIONS #8: registered-Pope / designated-Council configuration is direction only — **do not code this.** There is no `Data/Popes.lua`. `Sender:IsRegisteredPope` ignores its argument and returns `false`. `Officer` officer predicates remain `false`.

BeefNet:

- `SendState` / `SendSnapshot` require `_LocalPope()` → `Sender:IsRegisteredPope(PlayerName())` → **always false** → `"not a registered pope"`.
- Inbound STATE (GUILD) and SNAPSHOT **response** (WHISPER) require `Sender:Accept(sender, kind)`. `Accept` is true only for `kind == "INPUT"`. STATE / SNAPSHOT never Accept.
- SNAPSHOT **request** is answered only if `_LocalPope()` — so nobody answers.
- `_HandleV2` decodes STATE / SNAPSHOT only. INPUT is a codec type, **not** a live channel (`BeefNet.lua` header: “INPUT is not a live channel”).
- Retired `SYNC_*` / `RANK_COMMIT` / `SUGGESTION` still die unread.

HELLO still goes out for presence / version. That is not theater and not authority.

Do not invent the Pope list to “open” the wire.

---

## Law-by-law check (live code)

### Law 1 — No points economy

**Hold.** No points, XP, currencies, dailies, engagement streaks, or thresholds. Six ranks, no threshold fields. Gora `streak` is a fight-record field (Bible §10.9), not an engagement wallet. Codecs and Archive refuse grant-shaped keys.

### Law 2 — Record events, never behavior

**Hold.** Store records ceremony entries, marked moments, Gora results. Runtime records event id / state / rite / subjects / sequence. `Group.CountGuildmates` is unused.

### Law 3 — Pope holds ceremonial sovereignty

**Hold for the skeleton.** Ritual verbs live on Console and Core; they refuse unless registered-Pope. Officers/Council have no ritual UI. Recognition confirmer may be `pope` or `council` (Bible §12.2); `Complete` writes the Pope store.

### Law 4 — Software proposes; the Pope ratifies

**Hold.** `Propose` does not write. Rulings are explicit verbs. No auto-declare, auto-advance, Pope-voice announce, or generated narration. HUD / cards are mute. Archive rejects a `narration` key. `DeclareVictor` does not auto-elevate.

### Law 5 — Pope-authoritative star

**Hold for the skeleton.** One store; one runtime object; Net does not invent ranks or verdicts; UI does not record official outcomes. Catch-up is Pope-shaped SNAPSHOT, fail-closed until #8. Congregation INPUT is codec-only. Do not invent the list.

### Law 6 — Quiet Mode contract

**Hold, with named residuals.** Unbidden chrome is the minimap. `/beef` is an empty player-opened shell. Console / HUD / Records are unhosted (HUD would hide in QUIET if hosted). Toasts undriven. Decree absent (not invented). Version-mismatch chat / chip is the one soft flag.

### Law 7 — Church history is never deleted

**Hold.** No prune, departed sweep, or record expiry. Tombstones only. Account SV. Rank on the human; Gora on the character. Store Restore does not wipe on empty `{}`.

### Law 8 — Combat is WoW's

**Hold.** No addon combat, ELO/MMR, rated matchmaking, combat analytics, or betting. Sanctioned Gora is a store/runtime fact around an unmodified duel. No live-health hack.

### Law 9 — Rank structure

**Hold.** Exactly the six titles. No Prophet. Pope is not a rank. No thresholds. Butcher is display-only in data.

### Law 10 — Hybrid visual law

**Hold for what exists.** Console is stock-template functional. HUD / Records Book use ecclesiastical ink / parchment. Quiet shell stays pragmatic. UI copy does not joke. Custom Records media falls back if missing.

---

## Leftovers (honest; do not invent the fix)

1. **Unhosted Console / HUD / Records.** Modules load. Bootstrap and `/beef` do not show them. No slash.
2. **#8 uncoded.** `IsRegisteredPope` always false. Rituals and STATE / SNAPSHOT never fire. No `Data/Popes.lua`.
3. **No favor.** HUD `favor = nil`. No live INPUT channel.
4. **No live HUD health.** Appendix A #1 fallback only.
5. **No guild promote** from Core on KNIGHT THIS BEEF.
6. **No Decree**, no Decree deputy, no sound cues, no Notebook persist.
7. **No defense increment**; Most Successful Defenses page empty. Tournament Champions empty.
8. **Famous Upsets** have a store flag and a page; no Console flag verb; rulings do not set the flag.
9. **No Knighting queue / targeting / markers.** Presence is a text list.
10. **Residuals:** `Gora:Challenge` pair-key notes; `RefreshLadder` name; undriven Toasts; unused `Group.CountGuildmates`; `FreeRuling` writes two losses (#10).

---

## What would have been GATE4_FAIL

- Rebuilding Grant / standing / suggestion / Prophet / a ranked ladder.
- Auto-declaring a Gora from duel chat or a timer.
- `GuildPromote` / `SetGuildRank` from Core.
- Coding `Data/Popes.lua` or a registered-Pope UX (#8).
- Inventing a live INPUT / favor channel, live-health scrape, Decree deputy, tournament engine, or defense increment.
- Quiet HUD / toast / feed leak from the hosted `/beef` path.
- Computing Famous Upsets from odds or records instead of a Pope flag.

None of those shipped.

---

**GATE4_PASS**
