# W-B — Gora favor tally + FreeRuling (review)

**Lane:** W-B Gora favor tally + FreeRuling (licenses 2–3)
**Brief:** `docs/reformation/wire/briefs/W-B-gora-favor.md`
**Writer report (unverified):** `docs/reformation/wire/briefs/W-B-gora-favor-report.md`
**Diff:** `docs/reformation/wire/briefs/W-B-gora-favor.diff`
**Exclusive files:** `addon/ChurchOfBeef/Core/Gora.lua`, `tests/test_gora.lua`

**Spec:** FAIL
**Quality:** Changes required

Task-scoped gate only. Reviewer read the brief, the writer report, and the provided diff; then checked `Gora.lua` helpers (`isId`, `trimLine`, `_Expire`, `writeBoth`, `clearLive`, `ResetForTests`) and one focused Store contract check (`RecordGoraResult` free arm, `AppendCeremony` 4th arg). Did not mutate the working tree, did not re-run the harness, and did not treat writer counts as verified.

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Store / Codec / Net / UI / TOC / bootstrap / `run.lua` / OPEN_QUESTIONS / REFORMATION_LOG / commit | **Pass.** Provided diff touches only the two exclusive files. |
| Memory-only favor; never SV / Store / Archive | **Pass.** File-local `favorPicks`. Not a field on `Gora`. `ResetForTests` / `_Expire` / `Sanction` replace the table. Purity block after the new verbs still asserts `ChurchOfBeefDB` unchanged. |
| API names: `RecordFavor` / `GetFavor` / `GetFavorSplit` only; no public Favor economy table | **Pass.** Methods only. Leftover `assert_eq(Gora.Favor, nil)` removed as the brief required. No `Gora.HUD`, ELO, accuracy, or history table. |
| `characterId` / `pickId` are store integers ≥ 1 | **Pass.** Shared `isId` (`number`, integer, `>= 1`). Suite refuses `0` and a name string. |
| `RecordFavor` requires a live sanctioned pair; pick must be fighter A or B; else error string | **Pass.** No pair / outsider pick / bad ids return `nil` plus a string. Refused outsider does not replace the standing pick. |
| One standing pick per member; latest replaces; no list of past picks | **Pass.** Map write. Replace test: A → B → standing count is 1, not 2. |
| `GetFavor` / `GetFavorSplit` return copies | **Pass.** Fresh tables each call. Suite mutates both returns; live map and live split stay put. Integers only, so a shallow copy is enough. |
| `GetFavorSplit` is `{ a = n, b = n }` for the live pair; zeros if none | **Pass.** No pair → zeros (including after a verdict). Three members → `{ a = 2, b = 1 }`. |
| Successful `Sanction` writes the pair, then clears; failed `Sanction` does not | **Pass.** `favorPicks = {}` sits after the last refuse. Busy different-pair refuse leaves the map. Same-pair re-sanction is success and empties the bout, as the brief’s “new bout starts empty” line requires. |
| `ResetForTests` clears picks; out-of-harness Reset refuses and must not wipe | **Pass.** Both covered. Out-of-harness path now also plants a pick and asserts it survives. |
| Verdicts may leave the tally; next successful Sanction clears | **Pass.** `clearLive` is unchanged (pair + proposal only). Suite: Void leaves the pick; next Sanction drops it. |
| `_Expire` (event ended) clears the tally; if it already drops sanctioned / petitions, also drop picks | **Fail.** QUIET (`not eventId`) and stale-`sanctioned.eventId` both wipe picks. After a verdict, `sanctioned` is already nil. A later `StartEvent` with no Gora call while QUIET then hits the live-event branch: stale petitions are dropped, `sanctioned` is nil, **picks are not**. Favor is therefore not event-scoped. See Important. |
| No favor history, streaks, accuracy, economy, wagering, HUD, ELO | **Pass.** No new product objects. Existing nil asserts kept; `FavorHistory` / `Accuracy` added. Free ruling still does not touch W/L. |
| `writeBoth`: `ruling == "free"` does not set `won` (same as void); non-empty trimmed `text` on both sides | **Pass.** Gate is `ruling ~= "void" and ruling ~= "free"`. `text ~= nil` copies onto both field tables. `FreeRuling` passes `nil, nil, line`. |
| `FreeRuling`: sanctioned pair required; non-string errors before Store; trim; empty → nil; no `won`; `AppendCeremony("free", { a, b }, now, line)` after both writes; `clearLive` as today; return `{ ruling = "free", text = line }` | **Pass.** Matches the Store free arm (W-C): omitted / nil `won` accepted; boolean `won` would be refused — this lane never sends one. `Names.Trim` already maps whitespace to nil, so `line` is nil and `writeBoth` omits `fields.text`. Ceremony call is 4-arg and sits after both Store writes. |
| Named tests (favor record/replace/outsider/no-sanction, Sanction clears, split `{2,1}`, copies, FreeRuling no W/L, Reset clears) | **Pass.** All present, plus whitespace, non-string, ceremony-log text, failed Sanction, EndEvent-via-QUIET, Void leftovers, and purity after the new verbs. Isolation stays under `if standalone then`. |
| Do not edit Store; isolated Gora+Store may depend on W-C | **Pass.** No Store edit. Focused check: current `RecordGoraResult` / `AppendCeremony` already accept this call shape. Writer’s “W-C already landed” note is consistent with the tree; counts were not re-run. |

CONTINUE license 2 (one standing pick, latest replaces, no history, never SV) and license 3 (free writes no W/L; optional Pope text on the bout and ceremony log) are met **except** license 2 / brief “per-event” expire: leftover picks can survive into the next event.

---

## Strengths

- Favor is a file-local map, not a public `Gora.Favor` product object. Getters copy. Writes are one key. That is the brief’s API, not an economy table.
- `writeBoth` is a small, correct extension: free shares void’s “no `won`” path; optional `text` is attached only when the caller actually has a line. Victor / Cowardice / Void keep their existing 5-arg calls.
- `FreeRuling` matches the landed Store contract without editing Store: omits `won`, passes trimmed `text`, appends ceremony only after both rows succeed, then `clearLive` as before. Whitespace and non-string are handled before any write.
- Sanction clear sits after the last refuse, so a busy pair cannot wipe the tally. Reset still no-ops out of harness and now keeps leftover picks.
- Suite work is TDD-shaped and covers the named cases plus the copies / failed-Sanction / out-of-harness / purity pins this module already uses. Isolation asserts were not pulled out of `if standalone then`.

---

## Issues

### Critical

None.

### Important

1. **Favor is not event-scoped after a verdict.** `_Expire` wipes `favorPicks` only when there is no live event, or when a still-attached `sanctioned` row has a stale `eventId`. Verdicts call `clearLive`, so `sanctioned` is already nil. Runtime `EndEvent` does not call Gora. `StartEvent` must come from QUIET, but nothing forces a Gora touch in that QUIET window.

   Production path: sanction → pick → Void/FreeRuling/DeclareVictor → `EndEvent` → `StartEvent` → `GetFavor` / `Petition`. Live `eventId` exists, stale petitions are dropped, `sanctioned` is nil, **last event’s picks are still in the map**. `GetFavorSplit` is zeros (no pair), so the leak is `GetFavor`. The next successful Sanction does clear — too late for a Pope console that reads the map during the new ASSEMBLY.

   The brief is explicit: the tally is event-scoped, and “If `_Expire` already drops sanctioned/petitions, also drop picks.” The petition-drop arm does not touch `favorPicks`. The suite never hits this: `EndEvent` is always followed by a Gora getter while still QUIET, which takes the first branch and hides the hole.

   Fix that keeps the “verdicts leave the tally” rule: tag the tally with `eventId` (or remember the event the picks belong to) and clear when `liveEventId()` is missing or different. Do **not** clear merely because `sanctioned` is nil — that would wipe leftovers during the same event’s consequence beat. Add a test: pick → verdict → `EndEvent` → `StartEvent` (no Gora call in between) → `GetFavor` is empty, and a same-event Void still leaves the pick.

### Minor

1. **`RecordFavor` does not use `knownCharacter`.** Petition does. The brief only requires store integers ≥ 1, so this is not a miss. An unknown id ≥ 1 still tallies. W-D / W-E should not rely on Gora to reject ghosts.

2. **`AppendCeremony`’s return is ignored.** After both Store writes, a failed append would still `clearLive` and return success. With `"free"`, `{ a, b }`, and a trimmed or nil line, current Store cannot fail that call. License 3 still wants the ceremony row; pin the error if a later Store change starts refusing.

3. **Whitespace `FreeRuling` is only pinned on the return value.** Omitted-text checks Store + ceremony `text == nil`; `"   "` does not. `Names.Trim` already maps empty to nil, so `writeBoth` omits the field. Cheap to assert the same on the result row.

4. **Leftover-tally after a verdict is only tested via Void.** `clearLive` is shared, so DeclareVictor / Cowardice / FreeRuling are the same path. One extra pin on FreeRuling would match the brief’s full verb list.

---

## Assessment

**Spec FAIL. Quality: Changes required. Gate FAIL.**

The standing-pick API, memory-only storage, Sanction/Reset/copy rules, and license-3 FreeRuling call are the right shape and stay inside the exclusive files. Do not treat that as a sign-off. The tally is supposed to die with the event. After a verdict it is keyed to nothing, so a new event that never touches Gora during QUIET inherits last event’s `GetFavor` map. That is a per-event miss, and it will show up on the W-E Pope pane.

Writer-reported isolated `test_gora.lua` **394 / 0**, `test_store.lua` **330 / 0**, and full harness **6134 / 2** were **not** re-run here. The W-C dependency note is consistent with the Store file in tree; this lane did not edit Store.

Do not sign W-B until the Important expire path is closed and tested. The Minors are not blockers. Later HUD/console lanes should keep using `GetFavorSplit` only while a pair is live (zeros after a verdict are what this brief asked for); that is not a W-B defect.
