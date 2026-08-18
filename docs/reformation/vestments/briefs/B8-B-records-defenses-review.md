Spec PASS

# B8-B — Records Most Successful Defenses (review)

**Quality:** Approved

**Lane:** B8-B Records Most Successful Defenses
**Brief:** `docs/reformation/vestments/briefs/B8-B-records-defenses.md`
**Writer report:** `docs/reformation/vestments/briefs/B8-B-records-defenses-report.md`
**Diff:** `docs/reformation/vestments/briefs/B8-B-records-defenses.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the exclusive-pair diff, `UI/RecordsBook.lua` (`PAGE_TITLES`, `countDefenses` / `deriveDefenses`, `maxHolders`, defenses `put` / `bodyText`), and `tests/test_records.lua`; then ran `lua tests/test_records.lua` (**372 passed, 0 failed**, exit 0). Did not mutate addon code. Did not commit. Did not edit Console, Store, TOC, bootstrap, or `PAGE_TITLES`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `PAGE_TITLES` stays exactly the nine Bible names | **Pass.** Live table is the §10.9 list in Bible order: Most Sanctioned Victories, Longest Streak, Most Successful Defenses, The Iron Chin, Greatest Rivalry, Famous Upsets, The Undefeated, The Glorious Martyr, Tournament Champions. Provided hunks do not add, rename, reorder, or delete a title. `emptyPages` / `put` / `turn` / `jumpToTitle` still key off that table. Suite pins `#GetPages() == #BIBLE_TITLES` on the empty book, at the defenses seed, and `#GetPages() == 9` after the fill. OPEN_QUESTIONS #3 stays parked. |
| `maxHolders` — empty when best < 1; list only the top count | **Pass.** `put("Most Successful Defenses", maxHolders(defenseRows, "defenses"))` uses the existing helper. Empty store stays `entries == 0`. Lordalt at 2 is the only row; Earlyalt (pre-elevation-only) is omitted, not a runner-up. Shared-hold behavior is the same helper already pinned on Victories. |
| No generated prose | **Pass.** Left-leaf paint is `Name —` plus `displayCount` roman, same dash pattern as Victories / Streak / Chin / Martyr. Empty body is still `""`. Source has no `ordained`, `folk hero`, `on this day`, `unrecognized`, `of the realm`, or `PlaySound`. The book does not call `AddHonorific` / `FlagMoment` / `CanonizeMoment`. Chrome is still “The Records Book” plus the nine page titles. |
| No `gora.defenses` write | **Pass.** The only `defenses =` assignment is a local page-row measure. `countDefenses` / `deriveDefenses` are reads. `Show` / `Hide` / `GetPages` do not write Store. Seeded characters still have `gora.defenses == nil` after `GetPages`. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit `PAGE_TITLES`, Store, Console; no commit | **Pass.** Provided packet is `RecordsBook.lua` + `test_records.lua`. `PAGE_TITLES` hunk is absent. |
| Fill **Most Successful Defenses** from `Store:CountDefenses` (or the same derive if inlined; prefer Store when present) | **Pass.** `countDefenses` calls `Store:CountDefenses` when the method exists and returns a number. This checkout has B8-A; the Lord + two post-elevation seed ran that path. Inline fallback is `won == true` and `at >= elevationAt` on the snapshot `gora` plus linked `elevationAt` — the same walk live `RecordGoraResult` can produce (`void` / `free` already force `won = nil`). |
| Replace the old always-empty / “do not derive from elevationAt” pin | **Pass.** Empty-store pin remains empty (best < 1). The omit pin is flipped: Lordalt lists at 2; Earlyalt stays off the page. |
| Do not write `gora.defenses`. Do not invent a tenth page | **Pass.** Named-risk check. Tournament Champions stays empty. |
| Tests: Lord + two post-elevation wins → that name with count 2; pre-elevation-only off the page; `PAGE_TITLES` count 9; isolation wrap stays | **Pass.** `Lordalt` / `defenses == 2` / `characterId`; `hasName(..., "Earlyalt") == false`; nine titles; isolation (Runtime, Gora, Officer, UI, Net, DB, Sender, Minimap, Toasts, Console, Hud — **11**) stays under `if standalone then`. Wrap was not in the provided hunks. |
| `lua tests/test_records.lua` exit 0 | **Pass.** Verified 372 / 0. Writer-reported count matches. |
| Theatrical stock only; **POLISH:CANDIDATE** at most | **Pass.** No `Media\\`. Writer claimed the ceiling and no more. |

Bible §10.9 (named superlative, not a ladder), §14.2 (player-opened Quiet identity/history), OPEN_QUESTIONS #9 (derived sitting-Lord victories after `elevationAt`, not a stored increment), Law 4 (software never narrates), Law 7 (no defense field to wipe), and Law 10 (theatrical Records Book; UI never tells jokes) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| “B8-A not landed; `Store:CountDefenses` is absent” | **Stale, not a miss.** `Store:CountDefenses` is in this checkout. The suite prefers that API when present, which is what the brief asked. The inline walk is only the fallback. |
| Fallback could diverge if B8-A later filters beyond `won == true` | **Not a miss on this checkout.** Live path is Store. Live writes already nil `won` on void / free, so `won == true` matches #9. Store also refuses those rulings; that extra guard is unused while the method exists. |
| No client smoke; roman II wrap not eyeballed | **Not a miss.** Brief is stock paint. **POLISH:CANDIDATE** is the ceiling. |
| No Defenses ribbon; Prev/Next still reach the titled page | **Matches the brief.** Ribbons were not asked. The suite hops Next onto the leaf. |
| Cowardice-as-defense unpinned here | **Not a miss.** B8-A owns that pin. This brief named Lord + two post-elevation wins and pre-elevation-only omit. |
| Integrator glue / `/reload` not run | **Not a miss.** RecordsBook is already TOC-listed. Brief forbade TOC edits. |

---

## Strengths

- The titled page is a superlative, not a new category. `PAGE_TITLES` and `GetPages` stay the nine Bible names. #3 is untouched.
- Fill prefers `Store:CountDefenses`. The book does not increment, store, or restore a defense field.
- `maxHolders` keeps the page empty below 1 and lists only the top count. Pre-elevation wins do not sneak on as a lesser row.
- Painted copy is the holder name plus the same roman measure the other count pages already use. No realm sermon.
- Isolation stayed gated. Writer-reported 372 / 0 matched the re-run.

---

## Must-fix

None.

---

## Leftover

1. **Writer report’s “B8-A absent” line is stale.** This tree has `Store:CountDefenses`. The required seed exercised that method, not `deriveDefenses`.

2. **Fallback is unexercised here.** The suite never stubs `CountDefenses` away. Inline walk skips Store’s `ruling ~= "void"` / `ruling ~= "free"` guards. On live `RecordGoraResult` those rulings already have `won == nil`, so the required pins would still pass. Crafted Restore rows with `won == true` plus void/free could diverge only if the method were missing.

3. **Source `CountDefenses` pin is a substring.** The “Prefer Store” comment would satisfy `src:find("CountDefenses")` even if the call were removed. The live call and the Lordalt count pin are the real proof.

4. **Shared hold and cowardice are unpinned on this page.** `maxHolders` would list two names at the same top count (already proven on Victories). Cowardice-on-Lord (`won == true`) is a B8-A store pin, not a book pin.

5. **Painted-`2` refusal is name-fragile.** `defBody:find("2")` would fail if a holder name contained a digit. Live body is `Lordalt — II`.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated suite was re-run here. Long name + roman wrap remains a human look.

---

## Assessment

**Spec PASS. Quality Approved.**

This is the B8-B defenses-page contract: nine Bible `PAGE_TITLES` unchanged, `maxHolders` on a derived `defenses` measure, no generated prose, no `gora.defenses` write, isolated suite green (372 / 0, exit 0). Named risks are clean. Must-fix is empty. Leftovers are a stale B8-A report line, an unexercised fallback, a comment-satisfied source grep, unpinned tie / cowardice, a digit-fragile paint pin, and unsmoked stock chrome — not trust-breakers.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
