# W-B — Gora favor tally + FreeRuling (rereview)

**Lane:** W-B Gora favor tally + FreeRuling, plus the expire-path fix that closed the first review's Important
**Brief:** `docs/reformation/wire/briefs/W-B-gora-favor.md` (still binding)
**First review:** `docs/reformation/wire/briefs/W-B-gora-favor-review.md` (Spec FAIL on event-scope expire)
**Writer reports (unverified):** `docs/reformation/wire/briefs/W-B-gora-favor-report.md`, `docs/reformation/wire/briefs/W-B-gora-favor-fix-report.md`
**Diffs:** `docs/reformation/wire/briefs/W-B-gora-favor.diff` (original), `docs/reformation/wire/briefs/W-B-gora-favor-fix.diff` (original uncommitted W-B plus expire-path hunks)
**Exclusive files:** `addon/ChurchOfBeef/Core/Gora.lua`, `tests/test_gora.lua`

**Spec:** PASS
**Quality:** Approved

Task-scoped gate only. Reviewer read the brief, the first review, both writer reports, and both provided diffs; then one focused look at `liveEventId` / `_Expire` / `favorEventId` tagging and Runtime `StartEvent` id assignment. FreeRuling hunks were complete, so Store was not opened. Did not mutate the working tree, index, HEAD, or branch (this file excepted). Did not re-run the harness. Did not treat writer counts as verified. Do not treat this as a lane sign-off — the controller signs.

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Store / Codec / Net / UI / TOC / bootstrap / `run.lua` / OPEN_QUESTIONS / REFORMATION_LOG / Data/Popes.lua / commit | **Pass.** Both diffs touch only the two exclusive files. |
| Memory-only favor; never SV / Store / Archive | **Pass.** File-local `favorPicks` + `favorEventId`. Not fields on `Gora`. `wipeFavor` replaces both. Purity block after the new verbs still asserts `ChurchOfBeefDB` unchanged. |
| API names: `RecordFavor` / `GetFavor` / `GetFavorSplit` only; no public Favor economy table | **Pass.** Methods only. Leftover `assert_eq(Gora.Favor, nil)` removed. No `Gora.HUD`, ELO, accuracy, or history table. |
| `characterId` / `pickId` are store integers ≥ 1 | **Pass.** Shared `isId`. Suite refuses `0` and a name string. |
| `RecordFavor` requires a live sanctioned pair; pick must be fighter A or B; else error string | **Pass.** No pair / outsider / bad ids return `nil` plus a string. Refused outsider does not replace the standing pick. |
| One standing pick per member; latest replaces; no list of past picks | **Pass.** Map write. Replace test: standing count is 1, not 2. |
| `GetFavor` / `GetFavorSplit` return copies | **Pass.** Fresh tables. Suite mutates both returns; live map and split stay put. |
| `GetFavorSplit` is `{ a = n, b = n }` for the live pair; zeros if none | **Pass.** No pair → zeros (including after a verdict). Three members → `{ a = 2, b = 1 }`. |
| Successful `Sanction` writes the pair, then clears; failed `Sanction` does not | **Pass.** `wipeFavor()` sits after the last refuse. Busy different-pair refuse leaves the map. Same-pair re-sanction empties the bout. |
| `ResetForTests` clears picks; out-of-harness Reset refuses and must not wipe | **Pass.** Both covered. Out-of-harness path plants a pick and asserts it survives. |
| Verdicts may leave the tally; next successful Sanction clears | **Pass.** `clearLive` still pair + proposal only. Suite: Void leaves the pick; next Sanction drops it. |
| **Expire-path Important (this gate):** leftover picks may stay for the same event’s consequence beat; they must not survive into the next event. `_Expire` clears when `liveEventId()` is missing **or different**. Do **not** clear merely because `sanctioned` is nil. Pin: pick → verdict → `EndEvent` → `StartEvent` (no Gora call in QUIET) → first `GetFavor` is empty; same-event Void still leaves the pick | **Pass.** Closed. See below. |
| No favor history, streaks, accuracy, economy, wagering, HUD, ELO | **Pass.** No new product objects. Free ruling still does not touch W/L. |
| `writeBoth`: `ruling == "free"` does not set `won`; non-empty trimmed `text` on both sides | **Pass.** Gate is `ruling ~= "void" and ruling ~= "free"`. `text ~= nil` copies onto both field tables. |
| `FreeRuling`: sanctioned pair required; non-string errors before Store; trim; empty → nil; no `won`; `AppendCeremony("free", { a, b }, now, line)` after both writes; `clearLive` as today; return `{ ruling = "free", text = line }` | **Pass.** Hunks are complete (no Store open). Ceremony call is 4-arg and sits after both Store writes. |
| Named tests (favor record/replace/outsider/no-sanction, Sanction clears, split `{2,1}`, copies, FreeRuling no W/L, Reset clears) | **Pass.** All present, plus the required StartEvent leak pin. Isolation stays under `if standalone then`. |
| Do not invent Pope names | **Pass.** Fixture names are Fan / Crowd / Brisket / NextEventFan. |

CONTINUE license 2 (one standing pick, latest replaces, no history, never SV, per-event) and license 3 (free writes no W/L; optional Pope text on the bout and ceremony log) are met, including the per-event expire the first review failed.

### Expire-path (first review Important)

The first review failed because `_Expire` wiped picks only on QUIET or on a still-attached stale `sanctioned` row. Verdicts call `clearLive`, so `sanctioned` is already nil. `EndEvent` does not call Gora. `StartEvent` must come from QUIET. A new event’s first Gora read therefore saw a live `eventId`, dropped stale petitions, left `sanctioned` nil, and **kept last event’s map**.

The fix tags the tally:

- File-local `favorEventId` plus `wipeFavor()` (map and tag together).
- `RecordFavor` stamps `favorEventId = self.sanctioned.eventId` after validation.
- `_Expire`: no live id → `wipeFavor()` and return. Live id → drop stale petitions; drop a stale `sanctioned` row **without** wiping picks; then `if favorEventId ~= eventId then wipeFavor()`. Nil `sanctioned` is not a wipe reason.

Same-event consequence beat: after Void, `favorEventId` still equals `liveEventId()`, so leftovers stand. New event: Runtime `StartEvent` assigns a fresh incrementing id (`nextEventId`, then `+ 1`). First `GetFavor` after `EndEvent` → `StartEvent` (no Gora in the QUIET window) sees `favorEventId ~= eventId` and wipes. Focused Runtime check: `EndEvent` goes QUIET; `liveEventId()` is nil while QUIET (`snap.state == "QUIET"`), so a Gora touch in that window would also wipe — the leak was the path that never touches Gora until the next event is already live.

Required pin is in the suite: pick → Void → leftover asserted → `EndEvent` → `StartEvent` → first `GetFavor` empty; `next(GetFavor())` is nil. Existing same-event Void-leaves-pick pin kept.

---

## Strengths

- Expire is keyed to the event the picks belong to, not to whether a pair is still attached. That is the shape the first review asked for: leftovers for the consequence beat, death on a new event.
- `wipeFavor` keeps the map and the tag on one path (Sanction, Reset, expire). `RecordFavor` is the only writer that stamps.
- Favor stays a file-local map, not a public `Gora.Favor` product object. Getters copy. Writes are one key.
- `writeBoth` / `FreeRuling` remain a small, correct extension: free shares void’s “no `won`” path; optional text only when there is a line; ceremony append after both Store writes; `clearLive` unchanged.
- Suite covers the named brief cases plus the production leak the first review named. Isolation asserts were not pulled out of `if standalone then`.

---

## Issues

### Critical

None.

### Important

None. The first review’s only Important is closed.

### Minor

Unchanged from the first review; none of these reopen the gate.

1. **`RecordFavor` does not use `knownCharacter`.** Petition does. The brief only requires store integers ≥ 1. An unknown id ≥ 1 still tallies. Later lanes should not rely on Gora to reject ghosts.

2. **`AppendCeremony`’s return is ignored.** After both Store writes, a failed append would still `clearLive` and return success. License 3 still wants the ceremony row; pin the error if a later Store change starts refusing.

3. **Whitespace `FreeRuling` is only pinned on the return value.** Omitted-text checks Store + ceremony `text == nil`; `"   "` does not. Cheap to assert the same on the result row.

4. **Leftover-tally after a verdict is only tested via Void.** `clearLive` is shared, so DeclareVictor / Cowardice / FreeRuling are the same path. One extra pin on FreeRuling would match the brief’s full verb list. The new StartEvent pin is also Void-only; that matches the review’s required wording.

---

## Assessment

**Spec PASS. Quality: Approved.**

The standing-pick API, memory-only storage, Sanction/Reset/copy rules, and license-3 FreeRuling call were already the right shape. The expire-path hole is closed: `_Expire` wipes when the live event is missing or different, and does not wipe merely because `sanctioned` is nil. The required pick → Void → `EndEvent` → `StartEvent` pin is present; same-event leftovers still stand.

Writer-reported isolated `test_gora.lua` **401 / 0** (fix) and earlier **394 / 0** / Store **330 / 0** / harness **6134 / 2** were **not** re-run here.

The Minors are not blockers. Do not sign W-B from this file — the controller signs.
