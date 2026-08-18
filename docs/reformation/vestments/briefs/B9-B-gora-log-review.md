Spec PASS

# B9-B — Gora ruling ceremony log (review)

**Quality:** Approved-with-nits

**Lane:** B9-B Gora ruling ceremony log
**Brief:** `docs/reformation/vestments/briefs/B9-B-gora-log.md`
**Writer report:** `docs/reformation/vestments/briefs/B9-B-gora-log-report.md`
**Diff:** `docs/reformation/vestments/briefs/B9-B-gora-log.diff`
**Exclusive files:** `addon/ChurchOfBeef/Core/Gora.lua`, `tests/test_gora.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, `Core/Gora.lua`, and `tests/test_gora.lua`; then ran `lua tests/test_gora.lua` (**432 passed, 0 failed**, exit 0, Lua 5.1.5). Did not mutate `Gora.lua` or the suite. Did not commit. Did not edit Store, Knighting, Console, TOC, or `run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Type-only `AppendCeremony` after successful `writeBoth` on victor / cowardice / void | **Pass.** Each verb returns on `writeBoth` failure. The three-arg append sits after `ok`, before `clearLive`. Tokens are `"victor"` / `"cowardice"` / `"void"`. Ids are `{ winnerId, loserId }`, `{ fleerId, otherId }`, `{ fighterA, fighterB }`. |
| No 4th-arg text; software never narrates (Law 4) | **Pass.** Source calls are three arguments. No `Narrate`, scripture generator, or flavor template. Suite pins `text` and `scripture` nil on all three rows. `Gora.Narrate` stays nil. |
| Famous Upsets stay not computed (§10.9) | **Pass.** `writeBoth` does not pass `famousUpset`. `Gora.FamousUpsets` stays nil. The existing result pin (`famousUpset == false`) remains; the missing-`AppendCeremony` path re-pins it. No `FlagFamousUpset` / level / streak walk. |
| `FreeRuling` unchanged | **Pass.** Packet does not touch `FreeRuling`. Live body is still `AppendCeremony("free", { a, b }, resolveTime(), line)` after `writeBoth(..., "free", nil, nil, line)`. Existing free / omitted-text / whitespace / non-string pins are intact. |
| Missing append is OK; refused verbs do not append; pair still clears | **Pass.** Existence guard skips the log and still writes the bout + `clearLive`. Outsider victor, double victor, outsider fleer, and unsanctioned Void leave the log unchanged. Successful paths pin `GetSanctioned() == nil`. |
| Favor stays memory-only | **Pass.** `favorPicks` is still a local map. `Gora.FavorHistory` / `Accuracy` stay nil. Favor block still asserts picks are not Store state. Packet does not rewrite favor. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Store / Knighting / Console; no commit; Famous Upsets not computed; favor memory-only | **Pass.** Provided diff is two `diff --git` hunks: `Core/Gora.lua` and `tests/test_gora.lua`. Packet adds only the three type-only appends plus suite pins. |
| After successful `writeBoth`: `AppendCeremony("victor"\|"cowardice"\|"void", { id, id }, now)` | **Pass.** Guard is `if COB.Store.AppendCeremony`. Third arg is `resolveTime()`, same clock helper as `FreeRuling`. |
| No 4th-arg text on these three | **Pass.** Source and suite. |
| Missing `AppendCeremony` is OK | **Pass.** DeclareVictor stub `Store.AppendCeremony = nil` still records the bout, clears the pair, leaves the log empty, and does not compute an upset. |
| Refused verbs do not append | **Pass.** Double victor stays at one row. Outsider winner / outsider fleer / unsanctioned Void pin `#GetCeremonyLog() == 0`. |
| Pair still clears | **Pass.** Success and missing-append paths pin `GetSanctioned() == nil`. Refused outsider leaves the pair. |
| `FreeRuling` pins stay | **Pass.** Type `free`, A-then-B ids, Pope line on the row, omitted text stays nil. |
| Famous Upsets not-computed pin stays | **Pass.** Module `Gora.FamousUpsets == nil` and the victor result `famousUpset == false` pin are both still there. |
| Isolation wrap stays | **Pass.** **10** nil-module pins under `if standalone then` at file load (Net, UI, DB, Officer, Archive, Recognition, Popes, Sender, Codec, Snapshot). |
| `lua tests/test_gora.lua` exit 0 | **Pass. Verified.** 432 passed, 0 failed. Writer-reported count matches. |

Bible §18.1 (log is “what just happened,” type + ids), §10.8 (four Pope rulings), §10.9 (Famous Upsets are Pope-flagged, never computed), and Law 4 (software never narrates) hold on the exclusive pair. Congregation desk paint is B9-C.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| `AppendCeremony` return is ignored | **Not a miss.** Same as live `FreeRuling`. Current Store cannot fail these 3-arg calls with two valid character ids. A failed append would still `clearLive` and return the ruling. |
| Participant order is verb-named, not pair-order | **Matches the brief.** Victor is winner then loser; cowardice is fleer then other; void is A then B. B9-C must not assume A-then-B on every row. |
| Missing-append pin is DeclareVictor only | **Not a miss.** Brief licensed one guard. Cowardice / Void share it. Extra stub is belt-and-suspenders, not a hole in the law. |
| `at` is `resolveTime()`, not a verb argument | **Matches `FreeRuling`.** Victor clock stub (2100) is stored on the result and would be on the ceremony row; the row `at` is unpinned. See leftover. |
| Favor-path Void now logs | **Correct.** Shared success path. Brief said Void appends after `writeBoth`. Existing favor tests do not assert the log. |
| No client smoke / full harness | **Expected.** Memory-only Core. B9-C owns the stock ceremony-log desk. |

Uncommitted `Gora.lua` vs HEAD also contains pre-lane favor + `writeBoth` free-text hunks. Those are outside this packet. The B9-B delta is the three type-only appends.

---

## Isolation wrap / FreeRuling

**Isolation wrap — Pass.** Load list is still Common + Ranks + Store + Runtime + Gora. The **10** nil-module pins sit under `if standalone then` at file load. `lua tests/test_gora.lua` re-run here: wrap fires, suite finishes 432 / 0. Pins are not in the shared body.

**FreeRuling — Pass.** Packet does not edit the verb. `writeBoth` still receives `nil, nil, line`. Ceremony append is still four-arg with the Pope line. Suite still pins type `free`, A/B ids, stored line, omitted-text nil, whitespace omit, and non-string refuse (pair left, Store unwritten).

---

## Strengths

- Append is a record of the Pope verb, not a narration. Three arguments, ruling-name tokens, two character ids.
- Refuse paths are real: no pair / outsider do not write Store and do not grow the log. A second DeclareVictor after `clearLive` does not append again.
- Missing `AppendCeremony` still records the bout and clears the pair. The Famous Upset pin is repeated on that path.
- `FreeRuling` remains the only ruling that may carry Pope text. Favor stays a local map.
- Writer-reported 432 / 0 matched the re-run. Exclusive packet matches the live hunks.

---

## Issues

### Critical

None.

### Important (must-fix)

None.

### Minor (leftover nits)

1. **Ceremony `at` is unpinned.** The victor clock stub writes result `at == 2100`. `AppendCeremony` calls `resolveTime()` again after `writeBoth` (Store uses its own `wall`). A later clock would desync the two rows. Same pattern as `FreeRuling`. Do not invent a shared-`now` rewrite in this lane.

2. **Winner-as-B and fleer-as-A are unpinned.** Implementation uses `otherFighter`, so `{ winnerId, loserId }` / `{ fleerId, otherId }` still hold. Suite always names A the victor and B the fleer.

3. **Cowardice / Void missing-`AppendCeremony` is unstubbed.** One shared guard. Only DeclareVictor nils the method.

4. **`#participantIds == 2` and `narration == nil` are unpinned.** Brief asked type + two ids and no text/scripture. Source does not write `narration`. Store ceremony rows have no scripture field.

5. **Cowardice without a sanctioned pair is unpinned.** Double DeclareVictor and unsanctioned Void cover the empty-pair refuse. Cowardice’s `if not self.sanctioned` return is the same shape.

6. **Favor-path / CreateFrame `Void` now append.** Correct. Those blocks do not assert the log. `livePair()` / `reset()` wipe it before later pins.

7. **`writeBoth` is still two Store writes.** If the second `RecordGoraResult` fails, the first fighter already has a row and this lane correctly skips the log. Pre-existing; not introduced here.

8. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated suite was re-run here. Desk paint is B9-C.

---

## Assessment

**Spec PASS. Quality Approved-with-nits.**

This is the B9-B Gora contract: after both Store writes, DeclareVictor / CowardiceRecorded / Void append a type-only ceremony row; no 4th-arg text; Famous Upsets stay uncomputed; `FreeRuling` still passes the Pope line; missing `AppendCeremony` still records and clears; refused verbs do not append; isolation wrap is **10** gated pins; isolated suite green (432 / 0, exit 0). Named risks are clean. Leftovers are unpinned `at` / swapped-seat ids, the single missing-append stub, and unsmoked console paint — not trust-breakers.

Must-fix list: **none.**

Do not claim V1 / MVP complete. This review does not sign the lane.
