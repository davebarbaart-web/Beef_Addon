# Nights board (Decree rework)

**Date:** 2026-09-14  
**Status:** Design approved by David in conversation. **Not an implementation license** until the Bible / Quiet contract / Open Questions notes below are amended. On conflict with an unamended Bible, the Bible still wins.  
**Authority:** David (Design Lead). This spec reopens Bible §14.1 and Open Question #28. It does not reopen #20 (no numbered Gora table, no Elo, no win %).  
**Supersedes:** the single-row Decree (`COB.Decree` line + flavor) as the Quiet meetup notice.

---

## 1. What this is

Replace the one active Decree with a **Nights board**: upcoming Church nights and Discord raid/PvP notices on the same board.

- **Church nights** (Gathering, Knighting night, Gora night) are Pope-posted, usually a weekly series the Pope can skip or move for a given week. Congregation may tap **Going**. Everyone sees a count; names only on the Pope desk. Tapping Going does not start a ceremony.
- **Discord notices** (Raid, PvP) appear as stubs: title, when/where, and the clerical cue **Sign up on Discord**. No in-addon Going. Designated Council may post and edit these even when the Pope is offline.

The login parchment goes away. `/beef` shows this week’s nights. A click-through shows four weeks. The minimap glows only when the board changed since the player last opened the card; the glow stops when they view it.

The calendar is a **notice**. The Pope still starts ASSEMBLY from the Director Console as today.

---

## 2. Product contract

### 2.1 Church nights

| Field | Rule |
|---|---|
| Kinds (closed) | `gathering`, `knighting`, `gora` |
| Author | Registered Pope only. No deputy. |
| Shape | A **series**: weekday + `timeLine` + `place` + optional `flavor` |
| Default cadence | Weekly |
| Exceptions | **Skip this week** or **move this week** (place/time for that occurrence only). Series continues. |
| Withdraw | No future occurrences. Past occurrences remain (Law 7). |
| Going | One binary tap on a Church **occurrence**. Informational. Not attendance, not a score, not a rank gate. |
| Going visibility | Public **count**. **Names** on the Pope desk only. |
| Runtime | Notice only. No auto-start. No “Begin this night” in this spec. |

Display header comes from the kind (Gathering / Knighting night / Gora night). There is no free-text kind and no extra title field on Church nights.

### 2.2 Discord stubs

| Field | Rule |
|---|---|
| Kinds (closed) | `raid`, `pvp` |
| Author | Registered Pope **or** designated Council (see §4) |
| Shape | One-shot: required `title` (e.g. “Kara Thursday”), `timeLine`, `place` |
| Cue | Fixed copy: **Sign up on Discord**. No Going. No URL. No Discord API. |
| Edit | Pope or designated Council may change times/title/place or withdraw |
| Recurrence | None. Each raid/PvP night is a new stub. |

Two stubs with similar titles are two rows. The software does not merge by name.

### 2.3 Quiet Mode

- **Unbidden chrome:** hideable minimap only. No login banner. No toasts. No reminders. No standing list on the world.
- **Player-opened:** `/beef` week strip (next 7 local days, including today). Click-through **Nights** parchment: 28 local days from today.
- **Licensed glow (Law 6 exception):** faint pulse on the minimap icon when `boardRevision` is greater than this client’s `nightsSeenRevision`. Opening the player card **or** the Nights parchment sets seen = revision and stops the glow. Going taps do **not** bump `boardRevision`.
- If it would glow whenever any night exists, it is wrong. The glow means “the board changed since you last looked.”

### 2.4 Law this spec reopens (David)

| Law | Change |
|---|---|
| §14.1 / OQ #28 | One proclamation → a board of nights + informational Going + weekly Church series + Discord stubs |
| Law 6 / §19.1 | Drop the login Decree banner. License the unseen-change minimap glow only |
| OQ #5 | Church nights: Pope only (no Decree deputy). Discord stubs: designated Council (workspace list) |
| OQ #8 (slice) | `Data/Council.lua` + `ChurchOfBeefDB.ui.councilOverrides` for **stub senders only**. Same pattern as `Data/Popes.lua`. No settings panel. Rest of #8 stays open |

### 2.5 Law this spec does not touch

No Elo, win %, `#1`, or sortable Gora table (#20). No attendance ledger (Law 2). No auto-narration (Law 4). Church series writes stay on the Pope store (Law 5). History is not pruned (Law 7). Combat stays WoW’s (Law 8). Stubs are not Event theater.

---

## 3. Store

New keeper **`COB.Nights`**. It replaces `COB.Decree` as the Quiet meetup object. SavedVariables key `nights` replaces `decree` (schema bump). Getters return copies.

### 3.1 Series (Church)

```
id            integer, Pope-allocated
kind          gathering | knighting | gora
weekday       1–7 (local weekday the occurrence falls on)
timeLine      display string, required (“7:00 PM”)
place         display string, required (“Goldshire Inn”)
flavor        optional string
withdrawn     boolean (no future occurrences)
createdAt     wall clock
```

Exceptions, keyed by occurrence date (`YYYY-MM-DD` local):

```
skip[date]    true
move[date]    { timeLine, place }   -- that week only
```

**Occurrence key:** `seriesId` + `YYYY-MM-DD` of the scheduled local date.

**Generation:** for the card, occurrences whose local date is in `[today, today+6]`. For the parchment, `[today, today+27]`. A withdrawn series emits no date on or after withdraw. A skipped date emits nothing. A moved date keeps the same weekday slot that week and only replaces `timeLine` / `place`. Moving a Church night to a different weekday is a withdraw + new series, not a move exception.

### 3.2 Stubs (Discord notices)

```
id            writer-local, collision-free: Names.Key(sender) + ":" + monotonic seq
kind          raid | pvp
title         required
timeLine      required
place         required
createdBy     sender key
updatedAt     wall clock
```

Tombstones: a list of stub ids. **A tombstone always wins** over a stub with the same id.

Clients persist `stubs[]` + `stubTombstones[]` locally (every client that applied them, not only the Pope).

### 3.3 Going

```
going[occurrenceKey] = { [characterKey] = true, ... }
```

- Church occurrences only. Going on a stub refuses.
- Public API for UI: `CountGoing(occurrenceKey)` → number.
- Pope desk API: `ListGoing(occurrenceKey)` → names. Congregation UI must not call this for paint.
- Stored on the **Pope store**. Congregation sees counts from the last Pope `NIGHTS` apply.
- If the Pope is offline, Going INPUT refuses. The button stays; the count does not fake an increment.

### 3.4 Revision and seen

```
boardRevision          integer, max-merged across writers
ui.nightsSeenRevision  per-client, set when the player card or Nights parchment is shown
```

A night mutation (create/edit/skip/move/withdraw of series or stub) sets `boardRevision = max(known, 0) + 1` on the writer and sends that value. Receivers store `max(local, incoming)` and never lower it when a stale Pope snapshot arrives. Going does not bump revision.

Glow iff `boardRevision > nightsSeenRevision`. Missing revision → no glow. Disable any pulse `OnUpdate` when not glowing.

### 3.5 Migration (Law 7)

If `ChurchOfBeefDB.decree.line` is a non-empty string, import **one Gathering series**: `timeLine` = that line, `place` = that line, `flavor` = old flavor, `weekday` unset → treat as a **one-shot** (generate a single occurrence on the import date, not weekly). Do not delete leftover `decree` keys. Empty `{}` / missing decree → empty nights.

---

## 4. Authority

### 4.1 Church series

One writer: the Pope’s client. `SetSeries`, `SkipWeek`, `MoveWeek`, `WithdrawSeries` refuse unless the local character is a registered Pope (`Data/Popes.lua` + `ui.popeOverrides`). Congregation never writes series.

### 4.2 Discord stubs — operational second writer

This is the licensed carve-out so Council can post when the Pope is offline.

- **Trust list:** `Data/Council.lua` (`COB.Council.List` / `IsListed`) plus `ChurchOfBeefDB.ui.councilOverrides`. No settings panel. Empty list means only the Pope can post stubs until David adds names.
- **Who may SetStub / WithdrawStub:** registered Pope **or** listed Council.
- **Who may apply a stub broadcast:** same trust check on the **server-provided sender**. Discard otherwise. Do not store for later paint.
- **What Council still cannot do:** Church series, Going apply, Runtime, ranks, verdicts, Knighting, Event theater. `Officer.lua` stays fail-closed for ritual gates.

### 4.3 Merge and catch-up

| Situation | Rule |
|---|---|
| Pope `NIGHTS` snapshot | Truth for **series + Going**. **Upsert** stubs from the snapshot. **Do not drop** local stubs the Pope has not listed. Apply tombstones from the snapshot. |
| Stub broadcast (GUILD) | Upsert or tombstone. Pope is a receiver too: he applies, persists, and includes known stubs on his next snapshot. |
| Late join, Pope online | Existing snapshot request to the **Pope only**. Response includes nights (series, Going, stubs the Pope knows, tombstones). |
| Late join, Pope offline | No Council snapshot answer. Listed Council and the Pope **rebroadcast live stubs they persist** on login (throttled). Confused for seconds is acceptable; wiping a stub because the Pope’s old snapshot omitted it is not. |
| Same stub id | Last write wins. Tombstone wins over stub. |
| Pope withdraws a stub | Tombstone + snapshot. Everyone drops it. |

Do not open `SYNC_STATE`. Do not let Council answer ceremony snapshots.

### 4.4 Console

- `/beef console` **Nights** tab (today’s Decrees tab).
- **Pope:** series verbs + Going names + stub compose.
- **Listed Council:** stub compose / edit / withdraw only. Church series verbs hidden and refuse.
- **Anyone else:** refuse, as today.

Council does not get a new slash or a settings panel.

---

## 5. Surfaces

| Surface | Mode | Job |
|---|---|---|
| `/beef` player card week strip | Quiet, player-opened | Next 7 local days: kind (or stub title), when/where, Going count + Going tap on Church rows, “Sign up on Discord” on stubs |
| Nights parchment | Quiet, player-opened | 28 local days. Same rows, more room. Open from the week strip (and minimap right-click) |
| Minimap | Quiet, unbidden | Left-click: player card. Right-click: Nights parchment. Glow: §2.3 |
| Console Nights tab | Pope / listed Council desk | Compose and exceptions. Stock-template (functional). |
| Login Decree banner | — | **Removed.** Rewrite `UI/Decree.lua` as the Nights parchment (same Quiet theatrical surface). Do not keep a once-per-login `Show` in `Init`. |

Empty week copy: **No nights posted this week.** Clerical. No jokes.

Hybrid visual law: card strip and Nights parchment are theatrical (parchment). Console stays stock.

---

## 6. Data flow

Kinds (payloads), not locked opcode strings:

1. **NIGHTS** — Pope → GUILD. Series, Going counts (not name lists), stubs the Pope knows, tombstones, `boardRevision`.
2. **STUB** — Pope or listed Council → GUILD. One stub upsert + revision bump.
3. **STUB_WITHDRAW** — Pope or listed Council → GUILD. Stub id tombstone + revision bump.
4. **INPUT Going** — character → whisper to Pope (existing INPUT addressing, OQ #19). Pope applies and includes new counts on the next NIGHTS.

Congregation never sends NIGHTS. Pew clients never `EnsureCharacterByName` for Going; the Pope keys the INPUT by server sender.

Wire size: counts on the broadcast; name lists stay on the Pope client.

---

## 7. Errors

| Case | Behavior |
|---|---|
| Empty board | Empty copy. No glow. |
| Going, Pope offline | Refuse. Count unchanged. No optimistic increment. |
| Going on a stub | Refuse. |
| Unknown kind / missing required field | Refuse. No partial row. |
| Unlisted sender stub | Discard. Do not persist. |
| Council Church-series verb | Refuse. |
| Version mismatch | Existing Quiet drop. Last persisted board may still show. Do not invent a new Quiet toast. |
| Two Kara Thursdays | Two rows. Human problem. |
| Glow with no revision | Off. |

---

## 8. Testing

Harness (Core/Data/codec; `lua tests/run.lua` exit 0):

- Series create, weekly generate, skip, move, withdraw
- Stub upsert, tombstone wins, snapshot merge does not wipe unknown local stubs
- Authority: Pope / listed Council / pew
- Going count vs names; Going refuses on stub and when no Pope apply
- `boardRevision` ignores Going; seen revision clears glow
- Decree → nights migration
- Schema bump; leftover `decree` keys survive

Client smoke (UI / Net / slash): install, `/reload`, `/beef` week strip, Nights parchment, glow then view, Console Nights. Guild/net: Pope client + congregation; add a listed Council client for Pope-offline stub post and Pope-login merge.

Do not claim `POLISH:PASS`. Agents may claim `POLISH:CANDIDATE` only.

---

## 9. Out of scope

- Discord API, bots, URLs, or sync (later vision)
- Role signup, Accept/Decline, reminders, login banner
- Auto-start or “Begin this night”
- Attendance after the fact, favor/accuracy, points
- Blizzard `C_Calendar` / competing Group Calendar
- Recurring Discord stubs; Confession / Proclamation night types; free-text kinds
- Council settings panel; Council answering snapshots
- Second writer for Church series
- Event theater, toasts, or sound from stubs
- Rest of OQ #8 (designated-Council store field, broadcast shape beyond stub senders)

---

## 10. Before any code

Amend, in one pass, so agents are not illegal against the current Bible:

1. Bible §14.1 — this board, not “one line, no calendar”
2. Bible §19.1 / Law 6 note — login banner removed; unseen-change glow licensed
3. `.cursor/rules/quiet-event-modes.mdc` — same
4. `OPEN_QUESTIONS.md` #28 resolved (this spec); #5 Church nights Pope-only; #8 stub-sender slice
5. Architecture / Decree comments that say “single line, no wire, no deputy”

Until those land, do not implement `COB.Nights`.
