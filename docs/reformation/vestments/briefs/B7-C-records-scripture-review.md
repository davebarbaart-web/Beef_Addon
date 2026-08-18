Spec PASS

# B7-C — Records Book canonized scripture (review)

**Quality:** Approved

**Lane:** B7-C Records Book canonized scripture
**Brief:** `docs/reformation/vestments/briefs/B7-C-records-scripture.md`
**Writer report:** `docs/reformation/vestments/briefs/B7-C-records-scripture-report.md`
**Diff:** `docs/reformation/vestments/briefs/B7-C-records-scripture.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the exclusive-pair diff, `UI/RecordsBook.lua` (right leaf / `momentLines` / `PAGE_TITLES`), and `tests/test_records.lua`; then ran `lua tests/test_records.lua` (**356 passed, 0 failed**, exit 0). Did not mutate addon code. Did not commit. Did not edit Console, Store, TOC, bootstrap, or `PAGE_TITLES`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `PAGE_TITLES` stays exactly the nine Bible names | **Pass.** Live table is the §10.9 list in Bible order: Most Sanctioned Victories, Longest Streak, Most Successful Defenses, The Iron Chin, Greatest Rivalry, Famous Upsets, The Undefeated, The Glorious Martyr, Tournament Champions. Provided hunks do not add, rename, reorder, or delete a title. `emptyPages` / `GetPages` / `turn` / `jumpToTitle` still key off that table. Suite pins `#GetPages() == #BIBLE_TITLES` and each title at the scripture block, including “not a tenth page.” OPEN_QUESTIONS #3 stays parked. |
| Paint `moment.scripture` if present; after the location | **Pass.** `momentLocations` is now `momentLines`: per marked row, non-empty `location`, then non-empty `scripture`, `table.concat` onto `frame.Moments`. No date, no `at`, no prefix. Seed `FlagMoment("Goldshire Inn")` + `"The fountain ran red"` appears on the right leaf with `locAt < scriptureAt`, and not on `Body` or `Honorifics`. |
| No generated prose | **Pass.** Identity paint is store strings only. Source has no `ordained`, `folk hero`, `on this day`, `unrecognized`. The book does not call `FlagMoment` / `CanonizeMoment` / `AddHonorific`. Chrome is still “The Records Book” plus the nine page titles. |
| No PAGE remap | **Pass.** Scripture is a right-leaf line, not a category, ribbon, or `GetPages` entry. Left `Body` stays superlatives. Famous Upsets still require `result.famousUpset == true`; `ComputeFamousUpsets` stays nil. Existing upset pins still pass. |
| Isolated green | **Pass.** Re-ran: **356 passed, 0 failed**, exit 0. Isolation (Runtime, Gora, Officer, UI, Net, DB, Sender, Minimap, Toasts, Console, Hud — **11**) stays under `if standalone then`. Wrap was not in the provided hunks. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit `PAGE_TITLES`, Console, Store; no commit | **Pass.** Provided packet is `RecordsBook.lua` + `test_records.lua`. `PAGE_TITLES` hunk is absent. |
| Right leaf already paints locations; if `scripture` present, paint that string after the location | **Pass.** Named-risk check. Location-only rows (B6-B `Shattrath` / `Goldshire Inn`) still paint. Empty / non-string scripture is omitted. |
| Do not invent “on this day” copy | **Pass.** Source and painted leaf refuse that phrase. §16’s later Decree “on this day” surface was not built here. |
| `PAGE_TITLES` stays the nine Bible names; no PAGE remap | **Pass.** Named-risk check. |
| Famous Upsets still read `famousUpset` unless a pin breaks | **Pass.** That page builder is untouched. Isolated suite still green through the Pope-flag block. |
| Tests: seed FlagMoment + scripture field (or `CanonizeMoment` if Store has it) → right leaf contains that text and not `ordained`; `PAGE_TITLES` count 9; isolation wrap stays | **Pass.** This checkout has `Store:CanonizeMoment`, so `seedScripture` takes that path (brief-legal). Restore fallback is present and unused here. |
| `lua tests/test_records.lua` exit 0 | **Pass.** Verified 356 / 0. Writer-reported count matches. |
| Theatrical stock only; **POLISH:CANDIDATE** at most | **Pass.** No `Media\\`. Writer claimed the ceiling and no more. |

Bible §16 (software supplies the seal, never the scripture — this leaf copies Pope text, it does not write it), §10.9 / #3 (nine named superlatives, no new category), §14.2 (player-opened Quiet identity/history), Law 4 (software never narrates), and Law 10 (theatrical Records Book; UI never tells jokes) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; location + scripture share one `Moments` FontString; long Pope text may wrap under honorifics | **Not a miss.** Brief is stock paint. **POLISH:CANDIDATE** is the ceiling. |
| “B7-A not landed; Store still has no `CanonizeMoment`” | **Stale, not a miss.** `Store:CanonizeMoment` is in this checkout. The suite prefers that API when present, which is what the brief asked. Snapshot/Restore is only the fallback. |
| Locationless + scripture would still paint scripture | **Not a miss.** Brief says paint `scripture` if present. Dropping Pope text because `location` is empty would be the worse reading. Unpinned. |
| Famous Upsets path was not changed | **Matches the brief.** |
| Integrator glue / `/reload` not run | **Not a miss.** RecordsBook is already TOC-listed. Brief forbade TOC edits. |

---

## Strengths

- Scripture is paint, not a page. `PAGE_TITLES` and `GetPages` stay the nine Bible names. #3 is untouched.
- Per-row order is location then Pope string. Missing scripture adds nothing. The book does not mark, canonize, or invent “on this day.”
- Seeded text is unrelated to the location, so the leaf pin cannot be satisfied by echoing `Goldshire Inn`.
- Left leaf and honorifics stay clean of the canon line. Famous Upsets stay Pope-flagged.
- Isolation stayed gated. Writer-reported 356 / 0 matched the re-run.

---

## Must-fix

None.

---

## Leftover

1. **Source `scripture` pin is a substring.** The comment “Pope scripture when present” would satisfy `src:find("scripture")` even if `row.scripture` were removed. The paint pin is the real proof.

2. **Suite does not pin pairing across two marked rows.** One moment cannot distinguish per-row (loc1, scripture1, loc2, scripture2) from all-locations-then-all-scripture. Live `momentLines` is per-row. Locationless + scripture and empty-scripture-omit are also unpinned; B6-B location-only pins still pass.

3. **Suite does not pin that moment `at` is still omitted.** Same B6-B gap: `FlagMoment(..., 13000)` would still pass a `find("Goldshire Inn")` if `13000` were concatenated. Live source only reads `location` and `scripture`.

4. **Right leaf is not re-asserted after a page turn.** `paint()` always rewrites `Moments`, so ribbons / Previous / Next keep the canon line. The new block only `Show`s page 1.

5. **`seedScripture` Restore fallback is dead in this checkout.** B7-A landed; `CanonizeMoment` is the path that ran. The fallback is brief-legal and unexercised.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated suite was re-run here. Shared `Moments` wrap remains a human look.

---

## Assessment

**Spec PASS. Quality Approved.**

This is the B7-C scripture-leaf contract: nine Bible `PAGE_TITLES` unchanged, no page remap, right leaf paints `GetMarkedMoments()` location then Pope `scripture` when present, no generated prose, isolated suite green (356 / 0, exit 0). Named risks are clean. Must-fix is empty. Leftovers are unpinned pairing / `at` / page-turn, a comment-satisfied source grep, a stale B7-A report line, and unsmoked stock chrome — not trust-breakers.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
