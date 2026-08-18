Spec PASS

# B8-A — Store derived CountDefenses (review)

**Quality:** Approved-with-nits

**Lane:** B8-A Store derived CountDefenses
**Brief:** `docs/reformation/vestments/briefs/B8-A-defenses.md`
**Writer report:** `docs/reformation/vestments/briefs/B8-A-defenses-report.md`
**Diff:** `docs/reformation/vestments/briefs/B8-A-defenses.diff`
**Exclusive files:** `addon/ChurchOfBeef/Core/Store.lua`, `tests/test_store.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, `Store:CountDefenses`, and `tests/test_store.lua`; then ran `lua tests/test_store.lua` (**450 passed, 0 failed**, exit 0). Did not mutate `Store.lua` or the suite. Did not commit. Did not edit Gora, RecordsBook, HUD, FighterCard, TOC, or `run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| OPEN_QUESTIONS #9 — derived Lord victory after `elevationAt`, not a title-defense system | **Pass.** `CountDefenses` is a read. It walks `gora.results` and increments a local `n`. It does not assign `gora.defenses`, `gora.defenseCount`, or any increment field. It does not require current `rankId == 4`. Source has no sit-the-champ, champion obligation, or stored defense counter. |
| Never write `gora.defenses` | **Pass.** The new method has no writes. `RecordGoraResult` and `ensureCharacter` still nil `gora.defenses` and `gora.defenseCount`. Existing create / copy-mutate / victory / cowardice-as-loss / void / Snapshot `== nil` pins remain. New pins after two wins, after counted cowardice, and after Restore stay nil. |
| Voids and free are not defenses | **Pass.** Live `RecordGoraResult` leaves `won == nil` on both. The walk also refuses `ruling == "void"` / `"free"`. Suite records both after elevation and pins the count still 2, plus `won == nil` on those rows. |
| Cowardice on the non-fleer (`won == true`) counts | **Pass.** Post-elevation `ruling = "cowardice", won = true` on the Lord moves the count 2 → 3. The row keeps `ruling` and `won == true`. `gora.defenses` stays nil. `won == false` after elevation does not increment (loss pin). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Gora / RecordsBook / HUD / FighterCard; no commit; do not write `gora.defenses` or `defenseCount` | **Pass.** Provided diff is two `diff --git` hunks: `Core/Store.lua` and `tests/test_store.lua`. |
| `n = Store:CountDefenses(characterId)` | **Pass.** Colon method. Always a number. Unknown / invalid / name / nil / `0` → `0` (brief-preferred cheap paint; not `nil, err`). |
| No linked human, or human has no numeric `elevationAt` → `0` | **Pass.** Unlinked character is 0. Knight win before first Lord write is 0; human `elevationAt` stays nil. After Lord stamp, that pre-elevation win is still 0. |
| Count when `result.at >= elevationAt` and `result.won == true` | **Pass.** Two post-elevation victor rows → 2. `won == false`, `won == nil`, missing numeric `at` do not count. |
| Do not require current `rankId == 4` (Law 7) | **Pass.** Leave Lord keeps `elevationAt` and the derived 3. |
| Do not count void, free, or invent notable / famousUpset coupling | **Pass.** Void / free after elevation leave the count at 2. A Pope-flagged win is still one defense. The unmarked post-elevation win stays `famousUpset == false`. |
| Snapshot / Restore unchanged; `gora.defenses` stays stripped on write | **Pass.** `Snapshot` / `Restore` bodies were not edited. Suite snap still has `defenses == nil` and `elevationAt == 8100`. After `reset` + `Restore`, count is still 3 and `gora.defenses` is still nil. |
| Keep every existing `gora.defenses == nil` pin; add the named cases; isolation wrap stays | **Pass.** Pre-existing create, copy-mutate, victory, cowardice-as-loss, void, and Snapshot pins are intact. New block covers Lord + two wins, pre-elevation, void / free, cowardice `won == true`, unlinked / unknown, leave-Lord keep. Isolation is still **12** nil-module pins under `if standalone then`. |
| `lua tests/test_store.lua` exit 0 | **Pass. Verified.** 450 passed, 0 failed. Writer-reported count matches. |

OPEN_QUESTIONS #9 / GATE1 §4 (derived from character Gora record plus elevation timestamp; draws/voids are not defenses; opponent Cowardice Recorded is a defense; not a title-defense system), Law 7 (leaving Lord does not delete `elevationAt` or history), and OPEN_QUESTIONS #10 (free writes no `won`) hold on the exclusive pair. Rank 4 is Beef Lord (`Data/Ranks.lua`). Store rulings remain `victor` / `cowardice` / `void` / `free` — there is no draw ruling to miscount.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| `>=` vs OPEN_QUESTIONS #9 “after” | **Matches the brief.** Lane walk is `result.at >= elevationAt`. A same-timestamp bout would count. No same-timestamp pin. See leftover. |
| Extra void / free ruling guard; crafted `won == true` unpinned | **Not a miss.** Brief said do not count void or free. Live writes already leave `won` nil. The extra ruling refuse is belt-and-suspenders. |
| Unknown id is `0`, not `nil, err` | **Matches the brief.** Preferred for cheap UI paint. |
| Nested `runCountDefenses` for the Lua 5.1 200-local cap | **Not a miss.** Isolation wrap was not moved. Shared body still runs under `tests/run.lua`. |
| No client smoke / full harness | **Expected.** Memory-only Core. B8-B / B8-C / B8-D own Records Book, Fighter Card, and HUD paint. |

---

## Isolation wrap / Snapshot Restore

**Isolation wrap — Pass.** Load list is still Common + Ranks + Store. Pins (Gora, UI, Net, DB, Console, Archive, RecordsBook, Officer, Recognition, Popes, Sender, Runtime — **12**) sit under `if standalone then` at file load. `lua tests/test_store.lua` re-run here: wrap fires, suite finishes 450 / 0. Pins are not in the shared body.

**Snapshot / Restore — Pass.** `Snapshot` / `Restore` were not rewritten. CountDefenses fixture: snap copies `elevationAt` and a nil `gora.defenses`; after `reset` + `Restore`, `CountDefenses` still returns 3 from restored `results` + `elevationAt`. `ensureCharacter` still nils `gora.defenses` / `gora.defenseCount` on load. `ensureHuman` does not strip `elevationAt`.

---

## Strengths

- The derive is a walk, not a counter. Two post-elevation wins, a flagged win, a void, a free, a loss, and a non-fleer cowardice produce 3 — and `gora.defenses` is still nil on the live copy.
- Cowardice is keyed off `won == true`, which is the non-fleer write. The fleer path (`won == false`) cannot increment this method.
- Leaving Lord is pinned as Law 7, not as “must still be sitting to read the number.”
- Existing `gora.defenses == nil` pins were kept, not replaced. Isolation wrap stayed gated.
- Writer-reported 450 / 0 matched the re-run. Exclusive packet matches the diff.

---

## Issues

### Critical

None.

### Important (must-fix)

None.

### Minor (leftover nits)

1. **Same-timestamp bout is unpinned.** Brief chose `>=`. OPEN_QUESTIONS #9 says “fought after.” The two counted wins sit later (8200 / 8210 vs 8100). Do not invent a strict-`>` rule in this lane.

2. **Crafted Restore `void`/`free` + `won == true` is unpinned.** Live writes cannot produce that row (`void` forces `won = nil`; `free` + `won` is refused). The extra ruling guard would skip it. Fine as defense-in-depth.

3. **Post-elevation cowardice-as-loss is unpinned in the new block.** `won == false` already refuses a victor loss. A fleer cowardice row (`ruling = "cowardice", won = false`) after `elevationAt` would also refuse. The older suite still pins cowardice-as-loss does not store `gora.defenses`.

4. **A win after leaving Lord would still count.** The walk does not reconstruct “sitting at fight time.” The brief’s algorithm is `at >= elevationAt` and `won == true`, and it forbids requiring current `rankId == 4`. The leave-Lord pin only checks that the existing 3 survive. Store results do not carry rank-at-bout.

5. **Nested test function.** New pins live in `runCountDefenses()` because of the Lua 5.1 200-local cap. Isolation wrap was not moved.

6. **Unknown id and “no defenses” are the same `0`.** Brief preferred that. Callers cannot tell them apart.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated suite was re-run here. Paint is B8-B / B8-C / B8-D.

---

## Assessment

**Spec PASS. Quality Approved-with-nits.**

This is the B8-A store contract: `CountDefenses` derives from `elevationAt` + `won == true` and never writes `gora.defenses`; voids and free do not count; cowardice on the non-fleer counts; leaving Lord keeps the number; isolation wrap is **12** gated pins; isolated suite green (450 / 0, exit 0). Named risks are clean. Leftovers are unpinned same-timestamp / crafted void+won / post-demotion win, the nested test function, and unsmoked paint — not trust-breakers.

Must-fix list: **none.**

Do not claim V1 / MVP complete. This review does not sign the lane.
