Spec PASS

# B22-A — Recommendation paints the named-opponent token (review)

**Quality:** Approved-with-nits

**Lane:** B22-A Recommendation paints the named-opponent token
**Brief:** `docs/reformation/vestments/briefs/B22-A-recommend-names.md`
**Writer report:** `docs/reformation/vestments/briefs/B22-A-recommend-names-report.md`
**Diff:** `docs/reformation/vestments/briefs/B22-A-recommend-names.diff` (B22-A-only exclusive-pair packet; live `Console.lua` also carries earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`paintRecommendation` after `suggestionLabel`, `Console:Recommend` `lastRecommendation` store, `petitionLine` / `suggestionLabel` / `after`), and `tests/test_console.lua` (B21-A grep retarget, `runB22A()` nested inside `runB8E()` after `runB21A()`); then ran `lua tests/test_console.lua` (**1645 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §10.2 / §18.1; mute `"  names  "` on the recommendation when `namedOpponent`; `petitionLine` unchanged; no DEMANDED; nested pins. Isolation stays the console suite. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit Gora, Inputs, Net, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `lastRecommendation` still drops `namedOpponent` | **Pass. Verified.** `Console:Recommend` stores `{ fighterA, fighterB, namedOpponent = result.namedOpponent == true }` after `SelectFighters`, before `after` → `Refresh`. Source pin names that assign. Reviewer probe: named petition + no selected pair returns `namedOpponent == true` and paints `Tendermage vs Chuckroast  names  `. |
| `paintRecommendation` stays `nameA vs nameB` and never appends the token | **Pass. Verified.** After `suggestionLabel`, `rec.namedOpponent == true` appends `"  names  "`. Pin: Recommendation text contains the token and both names. `suggestionLabel` itself has no `names`. Proposed bout stays `Tendermage vs Chuckroast` with no token. |
| `petitionLine` rewritten, or `"DEMANDED"` invented | **Pass.** Live `petitionLine` is still `left .. "  names  " .. right` plus mute H2H. B21-A grep stays (message retargeted to "petition names token stays"). Source has no `DEMANDED` / `SaveNote` / SUMMON / Parchment / tabs. Reviewer probe: petition row buttons still paint the token (5 hits besides Recommendation). |
| Unnamed pair Recommend still paints a leftover token | **Pass. Verified.** After `Dismiss` + `SelectFighters(nil, nil)` + two unnamed petitions, `namedOpponent == false` and Recommendation is `Chuckroast vs Tendermage` with no `"  names  "`. `lastRecommendation` is overwritten, not left sticky. |
| `suggestionLabel` rewritten so the token leaks onto the proposed bout | **Pass.** `suggestionLabel` is still `nameA vs nameB` plus mute H2H. Token lives only in `paintRecommendation`. Probe: `GetProposedBout().label` has no `"  names  "`. |
| B21-A grep of `left .. "  names  " .. right` removed | **Pass.** Grep stays. Message is now "petition names token stays". `runB22A` re-pins the same copy as `petitionLine` copy stays. |
| New main-chunk locals / Lua 5.1 200-local | **Pass.** Packet adds `local function runB22A()` nested inside `runB8E()` after `runB21A()`. No new main-chunk locals. Isolated suite loaded on Lua **5.1.5** with no `too many local variables`. |
| Isolation wrap broken | **Pass.** Load list unchanged: wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. Standalone wrap is still **17** nils at file load. `runB22A` re-pins Archive + Quiet shell + Toasts + Confession + `COB.Popes`. Reviewer probe: those 17 keys are nil at load. |
| Exclusive file breach / Sanction / `SaveNote` / new codec | **Pass.** Provided packet is two `diff --git` files (header comment + B21-A retarget + nested `runB22A`; three-line paint append + `lastRecommendation` flag table). `Gora.lua` / Inputs / Net / glue are not in the packet. `SaveNote` is nil. Recommend does not call `Sanction` (probe: 0). No new codec kind. |
| Isolated suite not exit 0 | **Pass. Verified.** 1645 passed, 0 failed. Writer-reported count matches. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Gora / Inputs / Net / glue; no commit; `SaveNote` stays nil; no `"DEMANDED"`; stock desk; no new codec kind | **Pass.** Named-risk check. |
| Isolation wrap stays | **Pass.** Load list unchanged. Load wrap still **17** nil-module pins under `if standalone then`. |
| When `result.namedOpponent == true`, store the flag on `lastRecommendation` | **Pass.** Store is `result.namedOpponent == true`. Paint reads `rec.namedOpponent == true`. |
| Append mute `"  names  "` to the painted suggestion (`nameA vs nameB` + mute H2H stay) | **Pass.** Named-risk check. H2H probe: `Chuckroast vs Tendermage  1-0  names  `. |
| Do not write `"DEMANDED"`; do not change `petitionLine`; do not Sanction | **Pass.** Named-risk check. |
| Keep the B21-A grep of `left .. "  names  " .. right`; retarget the message (petition token stays) | **Pass.** Named-risk check. |
| After two characters + `Gora:Petition(b, a)` + `Console:Recommend()` (no selected pair): `frame.Recommendation:GetText()` contains `"  names  "` and both names | **Pass.** Pin and probe. |
| Unnamed pair Recommend still has no token | **Pass.** Named-risk check. |
| Nest new pins in `runB8E()`; no new main-chunk locals | **Pass.** `runB22A()` inside `runB8E()` after `runB21A()`. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **1645 / 0.** |

Bible §10.2 / §18.1 hold as the brief scoped them: `Gora:Recommend` already returns `{ namedOpponent = true }` when either petition names the other combatant; the desk now stores that flag and paints the same mute token as petition `left .. "  names  " .. right`. The software does not announce the callout and does not invent `"DEMANDED"`. Law 4 holds. Law 10 holds: stock desk.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Desk `after()` double cue stays parked | **On contract.** Batch 22 overview parks it. `Recommend` still calls `after(self, result, err)` with no cue. This lane did not touch `after`. |
| No client smoke; live Recommend paint vs Refresh after `Gora:Recommend` unproven on Anniversary | **Not a miss.** Brief asked the isolated suite. Reviewer probe: `Refresh` after named Recommend keeps the token. |
| Named token is mechanical, not oratory | **On contract.** Same mute `"  names  "` as the petition line. No `"DEMANDED"`. |
| Selected pair can still inherit the flag | **On contract.** Brief: paint the Core flag. `Gora:Recommend` sets `namedOpponent` from live petitions even when the Pope already selected that pair. Probe: selected A/B + B names A paints the token; selected A/C while B names A does not. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

B22-INT glue is not required. `Console:Recommend` already calls `Gora:Recommend` and `Refresh` via `after`. `petitionLine` was not this lane.

---

## Isolation / store / paint

**Isolation wrap — Pass.** Nine `dofile`s unchanged. Standalone wrap is still 17 nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). `runB22A` assigns `COB.Roster` stubs; `reset()` after `runB8E()` nils Roster again.

**Store — Pass.** `lastRecommendation` writes the boolean only when `Gora:Recommend` returns. `SelectFighters` does not `Refresh`. `after` paints after the store. A truthy non-boolean (`"true"`) does not paint (probe). Unnamed overwrite stores `false` and clears the token.

**Paint / petition — Pass.** Token is appended only in `paintRecommendation`. `suggestionLabel` / `petitionLine` / proposed bout are unchanged. Named no-selected-pair path uses pre-existing `recommendPair` (named petition wins). Unnamed pair has no token.

---

## Strengths

- The store is four fields on the existing `lastRecommendation` table. The paint is three lines after `suggestionLabel`. Failed Recommend cannot store or paint. Comparator is `== true` on both sides, so a leftover truthy non-boolean does not invent the token.
- `suggestionLabel` was not rewritten. The token cannot leak onto `GetProposedBout` / proposed-bout paint. `petitionLine` still owns `left .. "  names  " .. right`.
- B21-A's parked-Recommend grep was retargeted in place, then `runB22A` re-pins that copy plus the new store / append sources. Unnamed pair is a real overwrite, not a skipped second Recommend.
- `runB22A()` is nested inside `runB8E()` after `runB21A()` the way the 200-local cap requires. No new main-chunk locals. Isolation wrap and `SaveNote` / SUMMON / parchment / tabs / `DEMANDED` source pins stay.
- Writer-reported **1645 / 0** matched the re-run. Writer-reported red count (**1642 / 3**) matches the three impl-dependent pins (named paint + store source + append source) that old `lastRecommendation = { fighterA, fighterB }` would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Selected pair can still inherit `namedOpponent`.** `Gora:Recommend` flags the pair from live petitions even when the Pope already selected those two. This lane paints that Core flag; it does not change pair selection. Brief scoped the no-selected-pair path. Writer leftover already names it. Probe: selected A/B + named petition paints; selected A/C does not.

### Nit

1. **H2H + names on the recommendation line is unpinned.** Probe: explicit `Recommend(a, b)` after a seeded 1-0 is `Chuckroast vs Tendermage  1-0  names  `. Brief said mute H2H stays; the suite only pins `vs` + the token.

2. **`recNamed.namedOpponent` is Gora's return via `after`, not `lastRecommendation`.** `lastRecommendation` is a file local. Paint + the `result.namedOpponent == true` source pin cover the store. A spy of the table itself is not possible from the suite.

3. **`lastRecommendation` (and now the new flag) is only cleared in `ResetForTests`.** Probe: named Recommend, `EndEvent`, `StartEvent` still paints `Tendermage vs Chuckroast  names  `. Pre-existing lifetime; this lane added a field to that table.

4. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. `runB22A` assigns `COB.Roster` stubs. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B22-A-only store + append + nested pins. `git diff HEAD` on the two files still includes earlier console batches. Report already says this. `Gora.lua` is dirty vs HEAD and is not in the packet.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **1645 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **1645 passed, 0 failed.** Isolation wrap: **17**.

`Console:Recommend` stores `namedOpponent = result.namedOpponent == true` on `lastRecommendation`. `paintRecommendation` appends mute `"  names  "` when that flag is true. `nameA vs nameB` + mute H2H stay. `petitionLine` is unchanged. Unnamed pair Recommend has no token. No `"DEMANDED"`. `SaveNote` stays nil. New pins are nested in `runB8E()`. Isolated `lua tests/test_console.lua` **1645 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
