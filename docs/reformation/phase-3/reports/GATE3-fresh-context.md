# GATE3 — Fresh-context ceremony-runtime + BeefNet v2 skeleton test

**Agent:** fresh (no prior conversation).  
**Job:** try to refute that Phase 3 (Ceremony Runtime + BeefNet v2 skeleton) succeeded — four-state Pope-owned machine + STATE / SNAPSHOT / INPUT codecs + star catch-up — without rebuilding the points-ladder demo or inventing Phase 4 product.  
**Read:** `docs/design/Game_Design_Bible_v1.1.1.md` (§20, §13.1, §13.4, §4.11; Laws), `docs/reformation/phase-0/TEN_LAWS.md`, and every Lua file listed in `addon/ChurchOfBeef/ChurchOfBeef.toc` (and the TOC).  
**Did not read as product law:** `docs/archive/**`, `docs/reformation/phase-3/briefs/**`, `docs/reformation/phase-3/reports/**` (except this file), archived specs.  
**Did not invent** Phase 4 product (Director Console, Decree UI, sanctioned Gora loop, Fight HUD, registered-Pope `Data/Popes.lua`, Grant / standing).  
**Did not edit** addon Lua, TOC, tests, or `docs/design/OPEN_QUESTIONS.md`.

**Shipped load list** (`addon/ChurchOfBeef/ChurchOfBeef.toc`):

```
Data\Ranks.lua
Core\Common.lua
Core\Runtime.lua
Core\Store.lua
Core\Archive.lua
Core\Recognition.lua
Core\Officer.lua
Core\Sender.lua
Core\Roster.lua
Core\Gora.lua
Core\DB.lua
Net\Codec.lua
Net\Snapshot.lua
Net\BeefNet.lua
UI\MainFrame.lua
UI\Status.lua
UI\Minimap.lua
UI\Toasts.lua
ChurchOfBeef.lua
```

**TOC packaging:** `## Interface: 20506`. `## SavedVariables: ChurchOfBeefDB` (account-level). No `SavedVariablesPerCharacter`. Every TOC path exists on disk. No `Data/Popes.lua` on the load list.

---

## Verdict: GATE3_PASS

The refute fails. Live Lua implements a **four-state ceremony runtime** (QUIET → ASSEMBLY → RITE → CONSEQUENCE), **STATE / SNAPSHOT / INPUT codecs**, and a **non-peer snapshot apply helper**. It does not implement a points-ladder demo. It does not implement Bible MVP (console + Gathering + sanctioned Gora theater). Catch-up is not peer `SYNC_STATE` / `SYNC_REQUEST`. There is no sixth `AWAITING_POPE` state, no `holdSeconds` timer, and no registered-Pope file.

No **Criticals**. Leftovers are real and named below: **codecs are unwired** (BeefNet still sends and accepts **HELLO only**), the **Runtime event object is not persisted** into `ChurchOfBeefDB`, and **OPEN_QUESTIONS #8 is uncoded** (`Sender:IsRegisteredPope` is always `false`). Those gaps are skeleton leftovers. They are not a missing wire invented here, and they are not a Pope list.

This is not a Bible §22.3 Gathering. Do not claim V1 / MVP complete.

---

## 1. What product does the shipped load list implement now?

**Quiet shell + account-level Pope store + ceremony-runtime / BeefNet v2 skeleton.** Not a points ladder. Not the Bible MVP.

| Layer | What ships | What does not |
|---|---|---|
| Presentation | Hideable minimap presence (`COB.Minimap`). Player-opened empty `/beef` frame (`COB.UI`). Roster/guild status chip while the frame is open (`COB.UI.Status`). Slash `/beef` and `/beef minimap`. | Decree UI, Director Console, Records Book, Event theater, Standing / Ladder / Officer tabs, Fight HUD |
| Ceremony machine | In-memory `COB.Runtime`: QUIET / ASSEMBLY / RITE / CONSEQUENCE. Verbs: `StartEvent`, `OpenRite`, `CloseRite`, `Continue`, `EndEvent`. Closed rite types: Knighting, Gora, Confession, Proclamation. `awaitingPope` is a flag, not a state. | Console buttons, auto-advance, narration, SV persist of the event object |
| Identity / records | In-memory Pope store: humans (rank, council, honorifics, history, linked character ids), characters (name/class/level/professions, Gora record), ceremony log, marked moments (`COB.Store`) | Profile UI, aggregation view, Curtain, Notebook |
| Linking | Rite of Recognition session: Pope or Council confirmer + logged-in character id → `Store:LinkCharacter` (`COB.Recognition`) | Self-service link widget |
| Archive | String export / integrity check / import that Restores the store (`COB.Archive`) | Pope-console one-click, weekly reminder, Council cold mirror |
| Persist | Schema 5 `{ version, ui, store }`. `DB:Init` Restores a Snapshot-shaped `store`. `DB:Save` writes `Store:Snapshot()`. `PLAYER_LOGOUT` flushes (`COB:OnLogout`) | Runtime event object in SV |
| Codecs | `COB.Codec` encode/decode for STATE, SNAPSHOT (request / response), INPUT (petition / favor / confession). Protocol field `1`. Bible-named STATE fields only. | Wire send/recv of those types |
| Catch-up helper | `COB.Snapshot`: `Request()`, `BuildResponse()` from `Runtime:Snapshot()`, `ApplyResponse()` → `Runtime:Restore`. Encodes and Restores only. | Whisper send, GUILD fan-out, peer SYNC |
| Transport | `COB.Net`: prefix `COB`, channel `GUILD`, throttle, inbound rate limits, protocol version, `HELLO` presence/version. Retired `SUGGESTION` / `RANK_COMMIT` / `SYNC_*` discarded unread. | STATE / SNAPSHOT / INPUT on the wire |
| Sender | `COB.Sender:IsRegisteredPope` always `false`. `Accept` is true only for INPUT with a non-empty sender string. Theater / STATE / SNAPSHOT never Accept. | Registered-Pope list / `Data/Popes.lua` |
| Authority | `Officer:IsOfficerIndex` / `IsOfficerName` / `LocalIsOfficer` always `false` | Ritual verbs, Officer+ gates |
| Gora | Pair-key challenge notes only (`Gora:Challenge`). Results live on the character via `Store:RecordGoraResult` | Sanction loop, typed `RecordResult`, GrantGora, HUD |
| Ranks | Six titles, ids 1–6. `ChurchRankIdForGuildIndex` is a nil stub | Prophet, thresholds, roster→rank map |

This is **not** Bible MVP (§18 / §20 in full / §22): no console, no Quiet Decree, no Gathering theater, no sanctioned Gora presentation. Phase 3 claimed a runtime + v2 **skeleton** under the Quiet shell. That is what the load list implements.

---

## 2. Is it a points-ladder demo?

**No.**

Searched the TOC-loaded tree for Grant / standing / suggestion / Prophet / Officer+ rituals / activity leaderboards / per-character “alts start fresh.”

| Banned engine | Live result |
|---|---|
| **Grant / points / standing** | No `Grant`, `GrantGora`, `GrantCeremony`, points wallet, or standing table. `Archive.isGrantShaped` and `Codec.hasBannedKey` **reject** keys named `points`, `standing`, or `grant*`. `DB:applyDefaults` does not import leftover ladder / scoring / suggestion keys into `store`. |
| **Suggestion** | No suggestion module. `Net.RETIRED_TYPES.SUGGESTION` is discarded unread (`BeefNet.lua`). |
| **Beef Prophet** | Absent from `COB.Ranks.List` (`Ranks.lua`). |
| **Officer+ rituals** | `Officer:IsOfficerIndex`, `Officer:IsOfficerName`, `Officer:LocalIsOfficer` return `false` (`Officer.lua`). No knight / sanction / verdict / elevate / canonize verbs in UI or Net. |
| **Activity leaderboards** | No hours, combat minutes, contribution scores, or activity boards. `Group.CountGuildmates` exists in `Common.lua` and has **no caller** in the load list. |
| **Per-character “alts start fresh”** | TOC is account `SavedVariables`. Store is account-wide humans + characters. `Store:RankForCharacter` returns the **human’s** `rankId` or `nil` if unlinked. |
| **Peer authority / SYNC as truth** | `SYNC_REQUEST` / `SYNC_STATE` / `RANK_COMMIT` are retired discards. Live wire type is `HELLO` only. |

**Not a banned engine (residuals):** `Gora:Challenge` pair-key notes; `UI:RefreshLadder` name (body calls `Minimap:Refresh`); undriven `COB.Toasts` (`system` / `debug` only); unused `ui.announce = true`.

---

## 3. Is it Bible MVP (console + Gathering + sanctioned Gora theater)?

**No.**

Bible §22.1 / §22.3 require Director Console, Decree, Gathering theater, sanctioned Gora + Fight HUD + favor, Records Book, sound, and a human-run Gathering. None of those surfaces ship.

What ships toward MVP items 5–6 is a **skeleton**: the §20.1 state set and verbs exist in Core; §13.1 kinds exist as codecs; the transport still speaks HELLO. §20.3 late-join whisper, Pope-disconnect hold-then-degrade on the wire, and SV resume of the event object are **not** live. Do not treat this report as §22.3 done.

---

## 4. Does a four-state ceremony runtime exist? Who owns transitions? Any auto-advance / narration?

**Yes. Pope-owned verbs only. No auto-advance. No narration.**

`Core/Runtime.lua` names exactly four states: `QUIET`, `ASSEMBLY`, `RITE`, `CONSEQUENCE`.

| Verb | From | To | Notes |
|---|---|---|---|
| `StartEvent` | QUIET | ASSEMBLY | Allocates `eventId`. Zero fields — Tuesday floor (§4.11). |
| `OpenRite(kind, subjects)` | ASSEMBLY | RITE | Closed kinds only. Subjects: `candidate` / `fighters` (store ids). |
| `CloseRite` | RITE | CONSEQUENCE | Keeps rite type and subjects. |
| `Continue` | CONSEQUENCE | ASSEMBLY | Clears rite type and subjects. |
| `EndEvent` | ASSEMBLY or CONSEQUENCE | QUIET | Refuses RITE (must close first). |

Sequence increments on every successful verb. `Snapshot()` returns a copy. `Restore` accepts the same four states and Bible fields; it does not invent a fifth.

**Ownership.** The comment and the API match Bible §20.2: only these verbs mutate the machine. UI does not call them. Net does not call them. Bootstrap does not call them. Congregation apply is `Snapshot:ApplyResponse` → `Runtime:Restore` (copy of Pope-shaped fields), not a local `StartEvent`. There is still **no writer-role gate** on the verbs themselves (`Sender` / #8 uncoded). That is a leftover, not a second client writing over the wire.

**No auto-advance.** No timer in `Runtime`. No `C_Timer` that walks QUIET → ASSEMBLY → RITE → CONSEQUENCE. `MarkPopeLost` / `ClearPopeLost` flip `awaitingPope` only; they do not change `state`. Recognition `duration` is linking-session metadata, not this machine.

**No narration.** Runtime emits no flavor text. `Archive` rejects a `narration` key. Toasts are not driven. No Pope-voice announce path.

---

## 5. Are STATE / SNAPSHOT / INPUT codecs present? Is catch-up peer SYNC_STATE / SYNC_REQUEST?

**Codecs are present. Catch-up is not peer SYNC.**

`Net/Codec.lua` closed types: `STATE`, `SNAPSHOT`, `INPUT`. HELLO stays on the transport (`BeefNet.lua`).

| Kind | Shape | Direction in the helper (not on the wire) |
|---|---|---|
| STATE | `version`, `eventId`, `state`, `riteType`, `subjects` (candidate / fighters), `sequence` | Encode/decode only |
| SNAPSHOT request | `version`, `role=request` | `Snapshot:Request()` encodes; does not send |
| SNAPSHOT response | same Bible fields as STATE + `role=response` | `Snapshot:BuildResponse()` encodes a live Runtime snapshot when state ≠ QUIET; `ApplyResponse` Restores |
| INPUT | `kind` ∈ {petition, favor, confession}, `characterId`, optional confession `text` | Encode/decode only |

`Snapshot.lua` states the catch-up law in code: congregation `Request()`; only a Pope client `BuildResponse()`; this file does not send, whisper, or route. BeefNet names `SYNC_REQUEST` / `SYNC_STATE` only as **retired discards** — they are never acted on and are not the catch-up path.

Leftover: nothing in `BeefNet:OnAddonMessage` or `Net:Init` calls `Codec` or `Snapshot`. A STATE / SNAPSHOT / INPUT body that reached the transport today would be **unknown message type** (`Net.TYPES` is `{ HELLO = true }`). That is unwired codecs, not a peer-SYNC rebuild.

---

## 6. Is there a sixth AWAITING_POPE state, a holdSeconds timer, or a registered-Pope file?

**No. No. No.**

- `Runtime.STATES` has four names. There is no `AWAITING_POPE` state. `awaitingPope` is a boolean on a non-QUIET event (`MarkPopeLost`). Codec STATE keys do not include it. `Snapshot` bible fields do not copy it. It is local Event-Mode-degraded presentation, not a sixth state and not a wire opcode.
- No `holdSeconds` symbol, no disconnect hold timer, no coded “five seconds / thirty seconds” constant. Bible §20.4’s five / thirty is a chaos-test quality bar, not a timer in this load list.
- No `Data/Popes.lua`. `Sender:IsRegisteredPope` always returns `false`. `Officer` comments that Phase 4 owns registered-Pope / Council and that #8 is direction only. Do not invent that module.

---

## 7. Is BeefNet sending v2 STATE / SNAPSHOT / INPUT on the wire, or still HELLO-only?

**HELLO-only.**

`Net:Init` registers prefix `COB`, listens on `CHAT_MSG_ADDON`, and calls `SendHello()` (`VERSION:HELLO:<addon version>`). `OnAddonMessage` accepts `HELLO` or discards retired / unknown / version-mismatch. `Net:Encode` is the transport framer for HELLO, not `COB.Codec`.

Comments in `BeefNet.lua` are accurate: “The live vocabulary is HELLO… No snapshot, no Pope broadcast, no v2 codec lives here.”

Do not invent the missing wire. The leftover is: codecs exist as modules; the transport has not grown `TYPES` or a send path for them.

---

## 8. Is the Runtime event object persisted into ChurchOfBeefDB?

**No.**

`DB.lua` schema 5 is `{ version, ui, store }`. `DB:Save` writes `Store:Snapshot()` (humans / characters / ceremony log / marked moments). `DB:Init` Restores only a Snapshot-shaped `store`. There is no `runtime` key, no `event` key, and no call to `Runtime:Snapshot` / `Runtime:Restore` from DB or bootstrap.

`Runtime.lua` header: “No auto-advance, no narration, no SV persist.” Bible §20.3’s “event object persists in his SavedVariables” is therefore **uncoded**. Name it. Do not invent a persist schema here.

Pope reconnect cannot resume the machine from SV today. That is a leftover, not a Critical against a skeleton that refused to invent the write.

---

## 9. Quiet Mode: is the live UI still minimap + empty /beef shell?

**Yes.**

- Unbidden chrome: minimap button (`Minimap.lua`). Left-click toggles `/beef`. Tooltip is “Church of Beef” / “Left-click: /beef”. No grant pip, no petition cue, no StatusBar.
- Player-opened: empty `BasicFrameTemplate` content host. No tab registry. Footer text forced empty. Status chip is guild / roster-wait / §13.4 version-mismatch word, then hides (`Status.lua`).
- Decree is **absent** (not invented).
- `Toasts.lua` remains TOC-loaded (`system` / `debug` only). Nothing in bootstrap, UI, or Net calls `Toasts:Init` / `Push` / `Show` / `Celebrate`.
- `Net:_WarnVersion` — one chat line on protocol mismatch. That is the §13.4 gentle notice, not a toast family.

Quiet Mode is still minimap + empty `/beef`. Event Mode theater does not hang on the runtime yet because no surface reads `Runtime:Snapshot()`.

---

## Law-by-law check (live code)

### Law 1 — No points economy

**Hold.** No points, XP, currencies, dailies, engagement streaks, or thresholds. Six ranks, no threshold fields. Gora `streak` is a fight-record field on the character (Bible §10.9), not an engagement wallet. Codecs and Archive refuse grant-shaped keys.

### Law 2 — Record events, never behavior

**Hold.** Store records ceremony entries, marked moments, Gora results. Runtime records event id / state / rite / subjects / sequence — not hours or activity. `Group.CountGuildmates` is unused.

### Law 3 — Pope holds ceremonial sovereignty

**Hold for this phase.** Runtime verbs exist; no Officer/Council ritual UI. `Officer` fail-closed. Recognition confirmer may be `pope` or `council` (Bible §12.2); `Complete` writes the Pope store.

### Law 4 — Software proposes; the Pope ratifies

**Hold.** No auto-declare, auto-advance, Pope-voice announce, or generated narration. `CloseRite` / `Continue` / `EndEvent` are explicit. `Store:RecordGoraResult` still requires a caller-supplied ruling.

### Law 5 — Pope-authoritative star

**Hold for the skeleton.** One store; one runtime object; Net does not invent ranks or verdicts; UI does not record official outcomes. Catch-up helper is Pope-shaped Restore, not peer SYNC. `Sender` fail-closed for theater. #8 uncoded: no registered-Pope list, so even a future STATE send would not Accept today. Do not invent the list.

### Law 6 — Quiet Mode contract

**Hold, with the same shell residuals as the data-layer gate.** Unbidden chrome is the minimap. No driven toasts. No Event theater. Decree absent (not invented). Version-mismatch chat / chip is the one soft flag.

### Law 7 — Church history is never deleted

**Hold.** Tombstones only. No departed sweep. `Gora:_Prune` expires challenge notes, not Gora records. Rank on the human; Gora on the character. Account SV.

### Law 8 — Combat is WoW’s

**Hold.** No ELO/MMR, rated matchmaking, combat analytics, or betting. `Gora:Challenge` does not start a duel. Sanctioned Gora loop is not shipped (not invented).

### Law 9 — Rank structure

**Hold.** Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher, Beef Council. No Prophet. Pope is not a rank.

### Law 10 — Hybrid visual law; UI never tells jokes

**Hold for the Quiet shell.** Functional `BasicFrameTemplate`. No theatrical surfaces shipped. Footer empty. Minimap tooltip is instructional.

### Hard safety

Lua/XML only. `## Interface: 20506`. Core Runtime / Store / Codec / Snapshot / Sender have no `CreateFrame` and no `SendAddonMessage`. Net/UI API reads are `type()`-guarded. No injection or protected-action bypass in the load list.

---

## What would have been a Critical (none found)

A **GATE3_FAIL** would have required one or more of:

1. A live Grant / standing / suggestion / Prophet / Officer+ ritual / activity-leaderboard engine in TOC-loaded Lua.
2. No four-state machine, or a sixth coded `AWAITING_POPE` state, or a `holdSeconds` timer, or a shipped `Data/Popes.lua`.
3. Auto-advance of QUIET → ASSEMBLY → RITE → CONSEQUENCE, or generated narration / Pope-voice announce.
4. Catch-up implemented as peer `SYNC_STATE` / `SYNC_REQUEST` (gossip or authority).
5. Shipped Director Console / Decree UI / sanctioned Gora theater / Fight HUD / Grant (invented Phase 4).
6. A points-ladder demo still driving `/beef`.

None of those are in the load list.

Unwired codecs, no SV persist of Runtime, and #8 uncoded would be Criticals only if this phase had claimed a live star wire or a Pope list. It claimed a skeleton. The leftovers match that claim.

---

## Leftovers (not Criticals)

1. **Unwired codecs.** `COB.Codec` and `COB.Snapshot` are TOC-loaded. `BeefNet` never encodes, sends, or handles STATE / SNAPSHOT / INPUT. Inbound v2 types would be unknown. Do not invent the wire in this report.
2. **No SV persist of Runtime.** `ChurchOfBeefDB` holds `ui` + `store` only. Pope reconnect cannot resume the event object from SV. Do not invent a persist schema here.
3. **#8 uncoded.** `Sender:IsRegisteredPope` is always `false`. Theater / STATE / SNAPSHOT never Accept. No `Data/Popes.lua`. Do not invent a Pope list.
4. **`Gora:Challenge`** — leftover demo challenge book. Unused by UI/Net. Do not grow a typed-result path here.
5. **`Group.CountGuildmates`** — leftover co-play sensor. Unused. Do not persist it.
6. **`COB.Toasts`** — undriven Event-Mode engine still TOC-loaded.
7. **`UI:RefreshLadder`** and **`ui.announce`** — tombstone names / unused default.
8. **`Names` comment** (“each guild is its own ladder”) — comment debt in `Common.lua`.
9. **No Store / Runtime writer-role gate** — expected until registered-Pope (do not invent that file).
10. **§13.5 weekly reminder / cold mirror / Decree / console** — correctly absent. Do not invent chrome.

---

## Scope note

This review is conformance of **shipped Lua** against Bible §20 / §13.1 / §13.4 / §4.11 and the Ten Laws. It is not a Bible §22.3 Gathering, not a two-client net smoke, and not a claim that MVP is done.
