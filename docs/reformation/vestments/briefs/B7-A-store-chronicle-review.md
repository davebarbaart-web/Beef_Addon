Spec PASS

# B7-A — Store Canonize + Famous Upset flag (review)

**Quality:** Approved-with-nits

**Lane:** B7-A Store Canonize + Famous Upset flag
**Brief:** `docs/reformation/vestments/briefs/B7-A-store-chronicle.md`
**Writer report:** `docs/reformation/vestments/briefs/B7-A-store-chronicle-report.md`
**Diff:** `docs/reformation/vestments/briefs/B7-A-store-chronicle.diff`
**Exclusive files:** `addon/ChurchOfBeef/Core/Store.lua`, `tests/test_store.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, `Core/Store.lua`, and `tests/test_store.lua`; then ran `lua tests/test_store.lua` (**416 passed, 0 failed**, exit 0, Lua 5.1.5). Did not mutate `Store.lua` or the suite. Did not commit. Did not edit Gora, Console, Archive, RecordsBook, TOC, or `run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| CANONIZE is Pope-authored text; software never writes scripture (§16) | **Pass.** `CanonizeMoment` stores trimmed caller text on an existing marked-moment row. `FlagMoment` still writes `{ id, at, location? }` only. Source has no scripture generator, `on this day`, `ordained`, or flavor template. Ceremony log still has no `scripture`. |
| Famous Upsets are Pope-flagged, never computed (§10.9) | **Pass.** `FlagFamousUpset` walks `gora.results` from the end and sets `famousUpset = true` on the latest `opponentId` + `won == true` row. It does not read `level`, wins, streak, or rank. `notableVictims` is untouched. Loss / void / no pairing refuse. Gora.lua was not edited; `Gora.FamousUpsets` stays nil. |
| Law 7 — moments / results are never deleted | **Pass.** Canonize overwrites `scripture` on the same row. Unknown / empty / newline refuse do not append, wipe, or drop the moment. Flag refuses do not delete results. Source has no `SweepDeparted`, `Prune`, or `Delete*`. |
| Isolation wrap / Snapshot Restore keep scripture + `famousUpset` | **Pass.** See dedicated section. Wrap is **12** nil-module pins under `if standalone then`. Snapshot / Restore keep both fields; no Restore schema change. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Gora / Console / Archive / RecordsBook; no commit; no generated scripture | **Pass.** Provided diff is two `diff --git` hunks: `Core/Store.lua` and `tests/test_store.lua`. |
| `Store:CanonizeMoment(momentId, text)` | **Pass.** `momentId` is a marked-moment integer. Unknown / non-id refuse. Empty / missing / non-string / whitespace-only refuse. Embedded `"\n"` refuse. Text is trimmed. Sets `scripture`. Returns a copy. Does not invent `location`, `narration`, or `canon`. |
| `Store:FlagFamousUpset(characterId, opponentId)` | **Pass.** Latest matching victory only. No match → refuse. Does not compute an upset. Does not set `notable`. |
| Replace `Store.Canonize == nil` | **Pass.** Pin is now `type(Store.CanonizeMoment) == "function"`. `Store.Canonize` stays nil (unpinned; see leftover). |
| Snapshot / Restore keep `scripture` and the flagged result | **Pass.** Dedicated latest-win flag snap + Archive-shape snap both survive `reset` / `Restore`. `ensureCharacter` does not strip `results[].famousUpset`. `markedMoments` is a raw deepcopy. |
| Tests: FlagMoment → CanonizeMoment paints; newline refuse; FlagFamousUpset after a victor; latest of two wins; loss / void refuse; isolation wrap stays | **Pass.** All present. Isolation is gated. Extra pins (unknown id, blank, missing / non-string text, win-then-loss, name-string ids, copy isolation) are in scope. |
| `lua tests/test_store.lua` exit 0 | **Pass. Verified.** 416 passed, 0 failed. Writer-reported count matches. |

Bible §16 (MARK is live; CANONIZE is cold Pope text; software supplies the seal, never the scripture), §10.9 (Famous Upsets are Pope-flagged, never computed), Law 4 (software never narrates), and Law 7 (history is never deleted) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Isolation wrap is new (suite previously isolated by load list only) | **Not a miss.** Brief said the wrap stays. Adding **12** gated pins is the wrap. Shared-body remainder still runs under `tests/run.lua`. |
| Recanonize overwrites `scripture` | **Matches the brief.** Set, not refuse-if-present. The moment row is not deleted. |
| Sequential flags can leave more than one row `famousUpset == true` | **Not a miss.** Brief said find the latest and set true. It did not say unflag earlier rows. See leftover. |
| Non-string scripture uses `scripture text required` | **Not a miss.** Brief named refuse, not the exact string. |
| Opponent existence is not a separate check | **Not a miss.** Unused integer with no matching win is `no matching victory`. Name string is `opponent must be a character id`. |
| No client smoke / full harness | **Expected.** Memory-only Core. B7-B / B7-C own Console and Records Book paint. |

---

## Isolation wrap / Snapshot Restore

**Isolation wrap — Pass.** Load list is still Common + Ranks + Store. New pins (Gora, UI, Net, DB, Console, Archive, RecordsBook, Officer, Recognition, Popes, Sender, Runtime — **12**) sit under `if standalone then` at file load, before any Store write. `lua tests/test_store.lua` re-run here: wrap fires, suite finishes 416 / 0. Pins are not in the shared body, so a later `tests/run.lua` pass will not false-fail when those modules are already loaded.

**Snapshot / Restore scripture — Pass.** Archive-shape fixture: `FlagMoment("Shattrath")` then `CanonizeMoment(..., "The fountain held.")`. Snapshot copies `markedMoments[1].scripture`. After `reset` + `Restore`, `GetMarkedMoments()[1].scripture` is still that string. Restore assigns `deepcopy(snap.markedMoments)` with no field strip.

**Snapshot / Restore `famousUpset` — Pass.** Dedicated fixture: two victories, one `FlagFamousUpset`. Snapshot keeps result 1 false and result 2 true. After `reset` + `Restore`, the same pair returns. Archive-shape fixture still seeds `RecordGoraResult(..., famousUpset = true)` and pins Snapshot of that flag. `ensureCharacter` fills missing gora tables only; it does not coerce or drop `results[].famousUpset`.

---

## Strengths

- CANONIZE is a store of Pope text, not a writer of Church voice. Trim, newline refuse, unknown-id refuse, and copy-out are real. `FlagMoment` stays flag-hot.
- Famous Upset is a walk of existing victories. Level 60 vs 70 is not consulted. `notableVictims` stays empty unless a prior `RecordGoraResult(..., notable = true)` already wrote it.
- Latest-win and win-then-loss are both pinned: one call after two wins flags only the last; a later loss does not hide the last matching win.
- Law 7 holds on the refuse paths: empty / newline / unknown do not wipe scripture or append a ghost moment.
- Isolation stayed gated. Writer-reported 416 / 0 matched the re-run. Exclusive packet matches the diff.

---

## Issues

### Critical

None.

### Important (must-fix)

None.

### Minor (leftover nits)

1. **`RecordGoraResult` still accepts `fields.famousUpset == true` at write time.** That is the pre-existing Phase 2 seed path (Archive / Records / DB fixtures still use it). It is a Pope flag, not a computation, so it is not a §10.9 miss. B7-B should call `FlagFamousUpset`, not rely on the result-field shortcut.

2. **Sequential flags leave earlier rows true.** Flag after win 1, rematch, flag again → both rows stay `famousUpset == true`. One call after two wins still flags only the latest (pinned). The verb does not unflag. Do not invent a clear-earlier rule in this lane.

3. **Recanonize overwrite is unpinned.** A second `CanonizeMoment` on the same id replaces `scripture`. Brief allowed set. Prior text is gone; the moment row remains.

4. **Free-ruling refuse is claimed, not asserted.** `won == nil` cannot match `won == true`, so free / void-shaped rows refuse. Suite pins loss and void only.

5. **`Store.Canonize == nil` is no longer pinned.** Implementation stays nil. The Phase 2 pin was replaced by `CanonizeMoment`.

6. **Carriage-return-only scripture is accepted.** Brief banned `"\n"` only. `"foo\rbar"` would store.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated suite was re-run here. Console / Records Book paint are B7-B / B7-C.

---

## Assessment

**Spec PASS. Quality Approved-with-nits.**

This is the B7-A store contract: `CanonizeMoment` paints trimmed Pope scripture on a marked moment and refuses empty / newline / unknown; `FlagFamousUpset` flags the latest matching victory and never computes an upset; Snapshot / Restore keep `scripture` and the flagged latest win; isolation wrap is **12** gated pins; isolated suite green (416 / 0, exit 0). Named risks are clean. Leftovers are the pre-existing `RecordGoraResult` flag field, sequential double-flag, unpinned recanonize / free refuse, and unsmoked Archive paint — not trust-breakers.

Must-fix list: **none.**

Do not claim V1 / MVP complete. This review does not sign the lane.
