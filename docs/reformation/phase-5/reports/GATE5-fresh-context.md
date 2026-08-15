# GATE5 — Fresh-context everyday-layer skeleton test

**Agent:** fresh (no prior conversation).  
**Job:** try to refute that Phase 5 (everyday layer) succeeded as a skeleton — without rebuilding the points-ladder demo or inventing unanswered product.  
**Read:** `docs/design/Game_Design_Bible_v1.1.1.md` (§14.1, §14.2, §19.4, §19.5, §7, §5, Ten Laws, §13.1, §13.4, §20), `docs/reformation/phase-0/TEN_LAWS.md`, and every Lua file listed in `addon/ChurchOfBeef/ChurchOfBeef.toc` (and the TOC).  
**Did not read as product law:** `docs/archive/**`, `docs/reformation/phase-5/briefs/**`, `docs/reformation/phase-5/reports/**` (except this file).  
**Did not invent:** `Data/Popes.lua` (#8), Decree deputy UX (#5), SUMMON protocol, INPUT / Confession channel, post-show clipboard schema, onboarding config wall, guild-rank map, calendar / RSVP, favor, live HUD health, Console slash.  
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
Core\Decree.lua
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
UI\Decree.lua
UI\Toasts.lua
UI\Sound.lua
ChurchOfBeef.lua
```

**TOC packaging:** `## Interface: 20506`. `## SavedVariables: ChurchOfBeefDB` (account-level). No `SavedVariablesPerCharacter`. Every TOC path exists on disk. No `Data/Popes.lua` on the load list or on disk. `Core/Instance.lua` and `Core/Quest.lua` exist on disk and are **not** on the load list.

---

## Verdict: GATE5_PASS

The refute fails. Live Lua implements an **everyday-layer skeleton**: one active Decree that persists in schema 7, a Quiet parchment banner shown once per login and replayed from the minimap, and an Event-Mode Sound verb that refuses QUIET. It does not implement a points-ladder demo. It does not implement Bible MVP (a live Gathering).

No **Criticals**. Leftovers are real and named below: **#8 uncoded**, **Console has no Post Decree**, **Records / HUD / Console stay unhosted**, **Sound callers are not wired**. SUMMON, Confession channel, clipboard, onboarding wall, and guild-rank map were scoped out — they are leftovers, not invented product.

This is not a Bible §22.3 Gathering. Do not claim V1 / MVP complete.

---

## 1. What is this product now?

**Quiet shell + account-level Pope store + ceremony runtime + sanctioned-Gora / Knighting Core + unhosted Console / HUD / Records + fail-closed BeefNet v2 + a single persisted Decree with login banner and minimap replay + an unwired Event-Mode Sound verb.** Not a points ladder. Not the Bible MVP.

`PLAYER_LOGIN` still only `Init`s `COB.UI` and `COB.Net`. `UI:Init` builds the empty `/beef` shell and the minimap. `Minimap:Init` calls `DecreeBanner:Init`, which reveals the parchment once if a Decree is already in memory (restored from SV). `/beef` still toggles the empty Quiet frame. Slash is still `/beef` and `/beef minimap` only.

| Layer | What ships | What does not |
|---|---|---|
| Presentation | Hideable minimap presence. Empty `/beef` shell. Roster/guild status chip while the frame is open. Decree parchment (once per login; minimap replay). | Hosted Director Console, hosted Fight HUD, hosted Records Book, favor, calendar, RSVP, onboarding wall |
| Decree (Core) | `COB.Decree`: one `{ line, flavor }` row. `Set` / `Get` / `Clear` / `Snapshot` / `Restore`. Header copy is UI-only. | Deputy, expiry, wire, Pope-list gate, scheduling fields |
| Decree (UI) | `COB.DecreeBanner` (`MODE = "QUIET"`). Header **A GATHERING HAS BEEN DECREED**. Theatrical parchment. No sound. | Console Post, attendance reply, reminders |
| Sound | `COB.Sound` (`MODE = "Event"`). Allow-list: `sanction`, `verdict`, `elevation`, `knighting`, `cowardice`. Refuses QUIET. | Callers, custom media, Canonization seal, ambient / UI whoosh |
| Console (module) | Event-Mode stock desk. Runtime / Knighting / Gora verbs fail-closed on registered-Pope. | Slash, bootstrap Init, Post Decree, GuildPromote, Notebook persist, favor, INPUT |
| Fight HUD (module) | Event Mode. Shows only when Runtime ≠ QUIET **and** a live sanctioned pair. `health = nil`, `favor = nil`. | Live health, favor split, bootstrap Init |
| Records Book (module) | Quiet, player-opened parchment pages for the nine §10.9 titles. Superlatives, not a sortable ladder. | Slash, `/beef` / minimap wiring |
| Ceremony machine | `COB.Runtime`: QUIET → ASSEMBLY → RITE (typed) → CONSEQUENCE. Pope-owned verbs. | Auto-advance, narration, hosted start button, SUMMON |
| Gora / Knighting | Sanction → Pope rulings write Store. `KnightThisBeef` / `ElevateToLord` are Church-record verbs. | Auto-declare, ELO, Core `GuildPromote` |
| Persist | Schema 7 `{ version, ui, store, event, decree }`. `DB:Init` Restores Snapshot-shaped `store`, string-state `event`, and line-shaped `decree`. `PLAYER_LOGOUT` flushes. | Leftover demo keys imported into store / decree |
| Transport | Prefix `COB`, GUILD + WHISPER. HELLO presence. STATE / SNAPSHOT fail-closed until #8. INPUT codec-only. | Live INPUT, SUMMON, congregation theater |
| Sender | `IsRegisteredPope` always `false`. | Registered-Pope list / `Data/Popes.lua` |
| Ranks | Six titles, ids 1–6. `ChurchRankIdForGuildIndex` is a nil stub. | Prophet, thresholds, roster→rank map |

This is **not** Bible MVP (§22.1 / §22.3): no hosted console, no live Gathering theater, no favor, no wired bells, no human-run night. Phase 5 claimed a Decree-persist + banner + Sound-verb **skeleton**. That is what the load list implements.

---

## 2. Is it a points-ladder demo?

**No.**

Searched the TOC-loaded tree for Grant / standing / suggestion / Prophet / Officer+ rituals / activity leaderboards / per-character “alts start fresh.”

| Banned engine | Live result |
|---|---|
| **Grant / points / standing** | No `Grant`, `GrantGora`, `GrantCeremony`, points wallet, or standing table. `Archive.isGrantShaped` and `Codec.hasBannedKey` **reject** keys named `points`, `standing`, or `grant*`. `DB:applyDefaults` does not import leftover ladder / scoring / suggestion keys into `store` or `decree`. |
| **Suggestion** | No suggestion module. `Net.RETIRED_TYPES.SUGGESTION` is discarded unread. |
| **Beef Prophet** | Absent from `COB.Ranks.List`. |
| **Officer+ rituals** | `Officer` officer predicates return `false`. Console rituals gate on registered-Pope, not `rankIndex ≤ 1`. |
| **Activity leaderboards** | No hours, combat minutes, contribution scores, or activity boards. `Group.CountGuildmates` has **no caller** in the load list. |
| **Per-character “alts start fresh”** | TOC is account `SavedVariables`. Store is account-wide humans + characters. `Store:RankForCharacter` returns the **human’s** `rankId` or `nil` if unlinked. |
| **Peer authority / SYNC as truth** | `SYNC_REQUEST` / `SYNC_STATE` / `RANK_COMMIT` are retired discards. Catch-up is whisper SNAPSHOT from a Pope client; that path is fail-closed until #8. |
| **Ranked Gora ladder** | Records Book uses superlative holders, not a sortable “#1 rating” table. |

**Not a banned engine (residuals):** `Gora:Challenge` pair-key notes (TTL 1800, leftover social noise); `UI:RefreshLadder` name (body calls `Minimap:Refresh`); undriven `COB.Toasts` (`system` / `debug` only); unused `ui.announce = true`; `Common.lua` comment that still says “ladder” for name-keying.

---

## 3. Is it Bible MVP / a live Gathering?

**No.**

Bible §7’s Gathering is human staging (assembly, chaos, order, procession, Knighting, Gora). Software’s named contributions are the Decree, one **SUMMON THE FAITHFUL**, runtime theater, and a hosted console. §22.3 requires one complete real Gathering on stream.

What ships: Core verbs, an unhosted Console / HUD / Records, a local Decree banner, and an unwired Sound verb. No SUMMON. No favor. No hosted night. `#8` keeps every ritual and every STATE / SNAPSHOT send/accept closed. Do not treat this report as §22.3 done.

---

## 4. The Decree

**A single active proclamation persists. Login banner + minimap replay are the entire Quiet feature beyond presence. No calendar / RSVP.**

`Core/Decree.lua` holds one in-memory row: required `line`, optional `flavor`. `Set` replaces that row. `Clear` empties it. Header **A GATHERING HAS BEEN DECREED** is UI copy, not a stored field. No date object, recurrence, RSVP, reminder, attendance, deputy, expiry, or wire.

Schema 7 persists it. `DB:Save` writes `Decree:Snapshot()` into `ChurchOfBeefDB.decree`. `DB:Init` Restores only when `decree.line` is a string. Empty `{}` / missing does not Restore (does not wipe a live row). Leftover demo keys stay at the SV root.

`UI/Decree.lua` (`MODE = "QUIET"`): parchment banner, no sound. `DecreeBanner:Init` (from `Minimap:Init` on `UI:Init` / `PLAYER_LOGIN`) shows **once** if a Decree is already active (`loginRevealDone`). Thereafter `Minimap` left-click calls `DecreeBanner:Show` when a Decree is active; otherwise it toggles `/beef`. Tooltip may name the header and line. That is the entire Quiet feature beyond presence (§14.1 / §14.2).

No calendar. No RSVP. No reminders. No recurring events. No attendance tracking.

---

## 5. Sound

**Event Mode allow-list only. Quiet is silent. Callers are not wired.**

`UI/Sound.lua` (`MODE = "Event"`). `Play(name)` accepts only `sanction`, `verdict`, `elevation`, `knighting`, `cowardice`. Unknown names return `"unknown cue"`. If `Runtime:Snapshot().state` is not `ASSEMBLY` / `RITE` / `CONSEQUENCE`, it returns `"quiet"` and does not call `PlaySound`. No loop, no load-time play, no addon media, no Canonization seal.

No TOC-loaded file calls `COB.Sound:Play`. Gora rulings, Knighting verbs, Console buttons, and the Decree banner do not ring. The verb exists. The bells do not.

Quiet surfaces (minimap, Decree banner, empty `/beef`) do not play sound.

---

## 6. #8 / Console Post / Records host / HUD Init

**All leftover. None coded as a host.**

| Item | Live result |
|---|---|
| **#8** | No `Data/Popes.lua`. `Sender:IsRegisteredPope` ignores its argument and returns `false`. `Officer` officer predicates remain `false`. STATE / SNAPSHOT send and Accept stay fail-closed. Do not invent the list. |
| **Console Post** | `UI/Console.lua` header: no Decree. No Post / Set-Decree verb. Console rituals still refuse unless registered-Pope (always false). `Console:Init` / `Show` / `Toggle` are never called from bootstrap or slash. |
| **Records host** | `RecordsBook:Init` / `Toggle` exist. Nothing in the load list calls them. `/beef` and minimap do not open the book. |
| **HUD Init** | `Hud:Init` exists. Bootstrap never calls it. The frame is not created on login. `Refresh` would hide in QUIET if a later host called it. |

---

## Law-by-law check (live code)

### Law 1 — No points economy

**Hold.** No points, XP, currencies, dailies, engagement streaks, or thresholds. Six ranks, no threshold fields. Gora `streak` is a fight-record field (Bible §10.9), not an engagement wallet. Codecs and Archive refuse grant-shaped keys.

### Law 2 — Record events, never behavior

**Hold.** Store records ceremony entries, marked moments, Gora results. Runtime records event id / state / rite / subjects / sequence. Decree records a proclamation line. `Group.CountGuildmates` is unused.

### Law 3 — Pope holds ceremonial sovereignty

**Hold for the skeleton.** Ritual verbs live on Console and Core; they refuse unless registered-Pope. Officers/Council have no ritual UI. Recognition confirmer may be `pope` or `council` (Bible §12.2); `Complete` writes the Pope store. Decree `Set` is a Core write with no deputy UX and no Console Post.

### Law 4 — Software proposes; the Pope ratifies

**Hold.** `Propose` does not write. Rulings are explicit verbs. No auto-declare, auto-advance, Pope-voice announce, or generated narration. HUD / cards are mute. Archive rejects a `narration` key. `DeclareVictor` does not auto-elevate. Sound does not invent flavor text.

### Law 5 — Pope-authoritative star

**Hold for the skeleton.** One store; one runtime object; one Decree row; Net does not invent ranks or verdicts; UI does not record official outcomes. Catch-up is Pope-shaped SNAPSHOT, fail-closed until #8. Congregation INPUT is codec-only. Decree is local persist, not a peer broadcast. Do not invent the list.

### Law 6 — Quiet Mode contract

**Hold.** Unbidden chrome is the minimap plus the active Decree banner (once per login). `/beef` is an empty player-opened shell. Console / HUD / Records are unhosted (HUD would hide in QUIET if hosted). Toasts undriven. Sound refuses QUIET. Version-mismatch chat / chip is the one soft flag (§13.4). No calendar, RSVP, feed, or pip.

### Law 7 — Church history is never deleted

**Hold.** No prune, departed sweep, or record expiry. Tombstones only. Account SV. Rank on the human; Gora on the character. Store / event / decree Restore do not wipe on empty `{}`.

### Law 8 — Combat is WoW's

**Hold.** No addon combat, ELO/MMR, rated matchmaking, combat analytics, or betting. Sanctioned Gora is a store/runtime fact around an unmodified duel. No live-health hack.

### Law 9 — Rank structure

**Hold.** Exactly the six titles. No Prophet. Pope is not a rank. No thresholds. Butcher is display-only in data. `ChurchRankIdForGuildIndex` is a nil stub.

### Law 10 — Hybrid visual law

**Hold for what exists.** Console is stock-template functional. HUD / Records Book / Decree banner use ecclesiastical ink / parchment. Quiet shell stays pragmatic. UI copy does not joke. Custom Decree / Records media falls back if missing.

---

## Leftovers (honest; do not invent the fix)

1. **#8 uncoded.** `IsRegisteredPope` always false. Rituals and STATE / SNAPSHOT never fire. No `Data/Popes.lua`.
2. **Console Post leftover.** No Post Decree verb. Console remains unhosted; no slash.
3. **Records host leftover.** Module loads. Bootstrap, `/beef`, and minimap do not show it.
4. **HUD Init leftover.** Module loads. Bootstrap never `Init`s it.
5. **Sound callers not wired.** Allow-list verb exists; nothing plays a cue.
6. **No favor.** HUD `favor = nil`. No live INPUT channel.
7. **No live HUD health.** Appendix A #1 fallback only.
8. **No guild promote** from Core on KNIGHT THIS BEEF. Guild-rank map is a nil stub.
9. **Scoped out (named only):** SUMMON THE FAITHFUL, Confession INPUT channel, post-show clipboard, onboarding welcome / config wall, Decree deputy.
10. **Residuals:** `Gora:Challenge` pair-key notes; `RefreshLadder` name; undriven Toasts; unused `Group.CountGuildmates`; unused `ui.announce`; `FreeRuling` writes two losses (#10); `Core/Instance.lua` and `Core/Quest.lua` on disk but not TOC-loaded.

---

## What would have been GATE5_FAIL

- Rebuilding Grant / standing / suggestion / Prophet / a ranked ladder.
- Calendar, RSVP, reminders, recurring events, or attendance on the Decree.
- Coding `Data/Popes.lua` or a registered-Pope UX (#8).
- Inventing SUMMON, a live INPUT / Confession channel, clipboard schema, onboarding config wall, guild-rank map, favor, live-health scrape, or Decree deputy.
- Quiet HUD / toast / feed / sound leak from the hosted `/beef` or login path.
- Sound playing in QUIET, or ambient / UI-whoosh cues.

None of those shipped.

---

**GATE5_PASS**
