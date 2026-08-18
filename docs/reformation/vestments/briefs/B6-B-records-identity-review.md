Spec PASS

# B6-B — Records Book identity leaf (review)

**Quality:** Approved

**Lane:** B6-B Records Book identity leaf
**Brief:** `docs/reformation/vestments/briefs/B6-B-records-identity.md`
**Writer report:** `docs/reformation/vestments/briefs/B6-B-records-identity-report.md`
**Diff:** `docs/reformation/vestments/briefs/B6-B-records-identity.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, `UI/RecordsBook.lua`, and `tests/test_records.lua`; checked the provided exclusive-pair diff; then ran `lua tests/test_records.lua` (**331 passed, 0 failed**, exit 0). Did not mutate addon code. Did not commit. Did not edit Console, Store, TOC, bootstrap, or `PAGE_TITLES`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `PAGE_TITLES` still exactly the nine Bible names | **Pass.** Live table is the §10.9 list in Bible order: Most Sanctioned Victories, Longest Streak, Most Successful Defenses, The Iron Chin, Greatest Rivalry, Famous Upsets, The Undefeated, The Glorious Martyr, Tournament Champions. Provided diff does not add, rename, or delete a title. `GetPages` is still `deepcopy(emptyPages())` filled by those nine names. Suite pins `#GetPages() == #BIBLE_TITLES` and each title, including after `FlagMoment` / seeded honorifics. OPEN_QUESTIONS #3 stays parked. |
| Right leaf paints local honorifics + marked-moment locations | **Pass.** `frame.Honorifics` / `frame.Moments` sit on the existing `RightLeaf`. Honorifics resolve `UnitName("player")` → `Names.Key` → first `Snapshot().characters` name match → `humanId` → `GetHuman.honorifics`, copied as given. Moments paint `Store:GetMarkedMoments()` `location` only, store order. Missing name / character / bind → honorifics `""`. Seed `Duke of the Fountain` / `Defender of the Faith` + `Goldshire Inn` appear on the right leaf and not on `Body`. Unlinked local character does not borrow another human's title. |
| No generated prose | **Pass.** Identity paint is `table.concat` of store strings. No `ordained`, `folk hero`, `on this day`, `unrecognized`, date, or `at`. Source greps refuse those plus `AddHonorific` / `FlagMoment`. Honorifics do not go through `toRoman` / `displayCount`. Chrome is still the Bible name and the nine page titles. |
| Isolated green | **Pass.** Re-ran: **331 passed, 0 failed**, exit 0. Isolation (Runtime, Gora, Officer, UI, Net, DB, Sender, Minimap, Toasts, Console, Hud — **11**) stays under `if standalone then`. Wrap was not in the provided hunks. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit `PAGE_TITLES`, Console, Store; no commit | **Pass.** Provided packet is `RecordsBook.lua` + `test_records.lua`. `PAGE_TITLES` hunk is absent. |
| Right-leaf FontStrings (or one body): local honorifics + marked locations | **Pass.** Named-risk check. Two FontStrings, not a tenth `PAGE_TITLE`. |
| Missing bind → blank; no invented `unrecognized` | **Pass.** Unbound `Beefina` after `FlagMoment("Shattrath")` paints honorifics `""` and still paints the location. Source has no `unrecognized`. |
| `GetMarkedMoments()` locations only; no "on this day" narration | **Pass.** `momentLocations` reads `location` when it is a non-empty string. `at` is stored and ignored. |
| Do not change `PAGE_TITLES`; left leaf superlatives stay; no new category (#3) | **Pass.** Nine Bible titles. Left `Body` still paints superlatives. Seeded identity does not rename page 1. |
| Honorifics are titles, not counts: no roman on honorific text | **Pass.** `localHonorifics` copies strings. `toRoman` is still the left-leaf measure helper only. |
| Tests: nine titles; right leaf exists; seed honorific + `FlagMoment` → those strings, not `ordained` / `folk hero`; isolation wrap stays | **Pass.** All present. Extra unlinked-borrow pin is in scope and correct. |
| `lua tests/test_records.lua` exit 0 | **Pass.** Verified 331 / 0. Writer-reported count matches. |
| Theatrical stock only; **POLISH:CANDIDATE** at most | **Pass.** No `Media\\`. Writer claimed the ceiling and no more. |

Bible §12.1 (honorifics live on the human), §14.2 (player-opened Quiet identity/history), §15 (Pope-authored plain text, no mechanical benefits), Law 4 (software never narrates), and Law 10 (theatrical Records Book; UI never tells jokes) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; QuestBG + two FontStrings may read as a quest-log facing page | **Not a miss.** Brief is stock only. **POLISH:CANDIDATE** is the ceiling. |
| Name reuse (§12.4): first `Snapshot` character whose `Names.Key` matches wins | **Not a miss.** Brief named `Names.Key` → character → human. Schema replacement is out of scope. `listCopy` is id-sorted, so the match is deterministic (lowest id). |
| Unbound local character stays blank even when another human holds titles | **Matches the brief.** Recognition is not this leaf. |
| Moment rows with no location are omitted | **Not a miss.** Brief is locations only. `FlagMoment(nil)` still stores a row; there is nothing to paint. |
| Honorific list can grow; wrap may crowd moments | **Not a miss.** Brief forbade a new cap and forbade a tenth page. |
| Chrome title still spans the 720-wide frame (pre-existing V-C) | **Not a miss.** Identity sits on the right leaf only. |
| Integrator glue / `/reload` not run | **Not a miss.** RecordsBook is already TOC-listed. Brief forbade TOC edits. |

---

## Strengths

- Identity is paint, not a page. `PAGE_TITLES` and `GetPages` stay the nine Bible names. `#3` is untouched.
- Honorifics resolve to the human and copy store text. The book does not grant titles, invent `unrecognized`, or roman-numeral a count onto the right leaf.
- Marked moments echo Pope/zone `location` only. `at` is not formatted into a date line. No "on this day."
- Missing bind and unlinked-local paths are real: honorifics stay `""`; Church-wide locations still paint; another human's title is not borrowed.
- Isolation stayed gated. Writer-reported 331 / 0 matched the re-run.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Suite does not pin that moment `at` is omitted.** `FlagMoment("Goldshire Inn", 11002)` would still pass a `find("Goldshire Inn")` if `11002` were concatenated. Live source only reads `location`. Same gap on the `Shattrath` / `10000` path.

2. **Honorific roman pin is a substring check.** `honors:find("II")` proves these two Bible example titles contain no `II`, not that `toRoman` is unreachable. Implementation never calls it on this leaf.

3. **Identity is not re-asserted after a page turn.** `paint()` always rewrites both FontStrings, so ribbons / Previous / Next keep the right leaf. The new block only `Show`s page 1.

4. **Right-leaf top is a magic `-98`.** Honorifics anchor to the frame, not the title rule. Moments have no bottom clamp. Long Law 7 lists can crowd or run off the leaf. Brief forbade inventing a cap.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated suite was re-run here. Stock QuestBG facing-page remains a human look.

---

## Assessment

**Spec PASS. Quality Approved.**

This is the B6-B identity-leaf contract: nine Bible `PAGE_TITLES` unchanged, right leaf paints local-human honorifics as given plus `GetMarkedMoments()` locations, missing bind is blank, no generated prose, isolated suite green (331 / 0, exit 0). Named risks are clean. Minors are unpinned `at` / roman / page-turn leftovers and unsmoked stock chrome — not trust-breakers.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
