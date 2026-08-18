Spec PASS

# B25-A — Selected pair does not inherit the Recommend names token (review)

**Quality:** Approved-with-nits

**Lane:** B25-A Selected pair does not inherit the Recommend names token
**Brief:** `docs/reformation/vestments/briefs/B25-A-rec-selected.md`
**Writer report:** `docs/reformation/vestments/briefs/B25-A-rec-selected-report.md`
**Diff:** `docs/reformation/vestments/briefs/B25-A-rec-selected.diff` (B25-A-only exclusive-pair packet; live `Console.lua` also carries earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`Recommend` / `paintRecommendation` / `recommendPair` / `StartEvent` / `EndEvent` / `SelectFighters`), and `tests/test_console.lua` (isolation wrap, nested `runB25A()` inside `runB8E()` after `runB24A()`, plus the B25-A harness clear inside `runB24A()`); then ran `lua tests/test_console.lua` (**1841 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §10.2 / §18.1 Recommend; B22 leftover (`Gora:Recommend` flags `namedOpponent` from live petitions even when the Pope already selected those two); `hadSelected` from two different selected ids **before** `recommendPair` / `SelectFighters`; store `namedOpponent = (not hadSelected) and result.namedOpponent == true`; still store the pair; petition-path still Core `namedOpponent == true` and paints `"  names  "`; B22-A / B24-A pins stay; nest `runB8E()`. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit Gora, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Selected pair + named petition still paints `"  names  "` (inherit leftover) | **Pass. Verified.** Live `Recommend` computes `hadSelected` from two different `selectedFighterA` / `selectedFighterB` ids, then stores `namedOpponent = (not hadSelected) and result.namedOpponent == true`. Pin: `SelectFighters(a, b)` + named petition + `Recommend` paints both names + `vs` and **no** `"  names  "`. Core return is still `namedOpponent == true`. Reviewer probe matches. |
| `hadSelected` computed **after** `recommendPair` / `SelectFighters` (every successful Recommend looks selected) | **Pass. Verified.** Live order is `hadSelected` then `a, b = fighterA, fighterB` then `recommendPair` then `Gora:Recommend` then `SelectFighters`. Source pins: `hadAt < pairAt` and `hadAt < pickAt`. |
| Petition-path Recommend (no selected pair) drops the token | **Pass. Verified.** Nested B25-A reset + no `SelectFighters` + named petition paints `"  names  "` and both names. B22-A named-Recommend pin still green. Reviewer probe: explicit `Recommend(a, b)` with empty desk slots also paints the token. |
| Paint invents “DEMANDED”; `paintRecommendation` / petition line change | **Pass.** `paintRecommendation` still appends `'  names  '` only when `lastRecommendation.namedOpponent == true`. `petitionLine` is still `left .. "  names  " .. right`. Selected-pair pin: petition list still has the token while Recommendation does not. Source has no `DEMANDED`. |
| Pair not stored when `hadSelected` | **Pass.** Store still writes `fighterA` / `fighterB`. Selected-pair pin and reviewer probe both paint both names. |
| `SaveNote` defined; SUMMON / parchment / tabs | **Pass.** `Console.SaveNote` nil before and after the nested block. Source has no `function Console:SaveNote`, no `SUMMON THE FAITHFUL`, no `Parchment`, no `PanelTabButtonTemplate`. |
| New main-chunk locals / not nested in `runB8E()` | **Pass.** `runB25A()` is a nested `local function` inside `runB8E()` after `runB24A()`. Packet adds no main-chunk `local`. Header comment only at file top. |
| Isolated suite not exit 0 | **Pass. Verified.** 1841 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach (Gora / glue this lane) | **Pass.** Lane packet is two `diff --git` hunks (header gate note + `hadSelected` / gated store; header comment + nested `runB25A()` + three `runB24A()` lines). Live `Gora:Recommend` still flags from petitions only. Workspace Gora / glue dirt vs HEAD is earlier batches, not this packet. |
| Editing `runB24A()` to clear leftover selected fighters weakened B24-A | **Pass. Did not weaken.** See Strengths / leftover. B24-A lifetime pins (empty after End / later Start; failed Start / failed End / Continue keep; clear-before-`after` source) are untouched. The later-Start Recommend keep is still a no-selection petition-path paint. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Gora / glue; no commit | **Pass.** Named-risk check. |
| Isolation wrap stays | **Pass.** Nine `dofile`s unchanged. Load wrap still **17** nil-module pins under `if standalone then`. |
| Before resolving the pair, if `selectedFighterA` and `selectedFighterB` are already two different ids, store `namedOpponent = false` (still store the pair) | **Pass.** Named-risk check. |
| Petition-path Recommend (no selected pair) still stores Core `namedOpponent == true` and paints `"  names  "` | **Pass.** Named-risk check. |
| Selected-pair + named petition paints both names and **no** `"  names  "` | **Pass.** Nested pins + reviewer probe. |
| B22-A / B24-A pins stay | **Pass.** `runB22A()` and `runB24A()` still run inside `runB8E()` before `runB25A()`. Isolated suite **1841 / 0**. |
| No “DEMANDED”; `"  names  "` paint unchanged; petition line stays | **Pass.** Named-risk check. |
| `SaveNote` stays nil | **Pass.** Named-risk check. |
| Nest new pins in `runB8E()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **1841 / 0.** |

Bible §10.2 / §18.1 hold on the exclusive pair: Recommend proposes; the names token marks a discovered named challenge, not a pair the Pope already seated. Law 4 holds: the desk does not invent “DEMANDED” or narrate. `Gora:Recommend` still reports the petition flag; the desk just refuses to inherit it onto `lastRecommendation` when a pair is already selected.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Successful Start / End still do not clear `selectedFighterA` / `selectedFighterB` | **Leftover, not must-fix.** Brief scoped the `namedOpponent` store gate, not a selection wipe. See Important leftover. |
| B24-A later-Start keep now clears leftover selected fighters in-harness | **On contract.** Keeps B24-A a petition-path Recommend after B25-A's gate. Did not weaken B24-A lifetime. |
| No client / two-client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / gate / keep

**Isolation wrap — Pass.** Load list is still Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. No `dofile` of Gora's callers beyond that list, UI shell, Net, DB, or glue. Standalone wrap is still 17 nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Nested B25-A re-pins Archive / UI / Toasts / Confession / Popes after restore.

**Gate-before-resolve — Pass.** `hadSelected` reads the desk slots before `recommendPair` can echo them and before `SelectFighters` writes them. Successful Recommend still calls Core and still stores the pair. `paintRecommendation` is unchanged: it only appends `"  names  "` when the stored flag is true. Reviewer probes: one selected id, or the same id in both slots, does **not** set `hadSelected` and still paints the token.

**Keep — Pass.** Petition-path Recommend (empty slots, or explicit args with empty slots) still stores Core `namedOpponent` and paints `"  names  "`. B22-A named / unnamed pins stay. Petition line copy stays. B24-A still nils `lastRecommendation` on successful Start / End before `after()`. Failed Start (already live) still keeps the names line (reviewer probe).

---

## Strengths

- The store gate is one boolean computed from two different selected ids, then one `and` on the existing Core flag. Paint is untouched. Core is still called.
- B22-A's leftover (desk paints `"  names  "` as if Recommend discovered a pair the Pope already seated) is closed on the same named-petition fixture, not a second paint language.
- Petition-path keep is a fresh reset with empty slots, so a blanket `namedOpponent = false` would fail it. Selected-pair pin asserts Core still returns `true`.
- `hadSelected` before `recommendPair` / `SelectFighters` is source-pinned. `"  names  "` append, petition line, `SaveNote` nil, and no DEMANDED stay source-pinned.
- Isolation wrap was not rewritten. `runB25A()` is nested inside `runB8E()` after `runB24A()`.
- Writer-reported **1841 / 0** matched the re-run. Writer-reported first red (**1834 / 5**) matches selected-pair paint plus the new `hadSelected` / order / gated-store pins. The later **1838 / 1** matches B24-A's leftover-selected later-Start Recommend after the gate landed.

**`runB24A()` harness clear — did not weaken B24-A.** Original B24-A later-Start Recommend had no `SelectFighters(nil, nil)`. After the first Recommend, `SelectFighters` leaves a pair; Start / End still do not wipe it. Under this lane's gate that leftover pair would suppress `"  names  "` and fail B24-A's “paints again” keep. The three new lines force empty slots so that keep stays a **no-selection** Recommend — which is what B24-A was testing (lifetime of `lastRecommendation`, not selected-pair inherit). Empty-paint after End / later Start, failed Start / failed End / Continue, and clear-before-`after` source pins are unchanged. The new asserts only prove the harness wipe, not that StartEvent itself cleared the pair.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Successful `StartEvent` / `EndEvent` still do not clear `selectedFighterA` / `selectedFighterB`.** Reviewer probe: petition-path Recommend → End → later Start leaves both ids; a new named petition + Recommend still paints both names and **suppresses** `"  names  "` until the desk (or harness) clears the pair. Brief did not ask Start / End to wipe selection. `ResetForTests` still does. Overview parks one Console leftover this batch. Not glue.

### Nit

1. **`runB24A()` later-Start keep now calls `SelectFighters(nil, nil)` before the petition-path Recommend.** Required so B24-A stays green after this gate. Assert copy (“later StartEvent has no leftover selected A/B”) describes the harness wipe, not StartEvent. Lifetime pins are intact.

2. **`hadSelected` gates even when `Recommend(a, b)` args differ from the seated pair.** Brief says compute the flag **before** resolving the pair. Reviewer probe: seated A/B + `Recommend(c, d)` on a named petition still stores c/d and still drops the token. On contract. Unpinned.

3. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. Nested B25-A re-pins four of them plus Popes after restore. Brief said the wrap stays; it did.

4. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B25-A-only gate + nested pins + three `runB24A()` lines. `git diff HEAD` on the two files still includes earlier console batches. Report already says this.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **1841 / 0** was re-run here. Live desk paint after SelectFighters + named petition + Recommend is unproven on Anniversary.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **1841 passed, 0 failed.** Isolation wrap: **17**.

`Recommend` computes `hadSelected` before `recommendPair` / `SelectFighters`. A seated pair stores `namedOpponent = false` and still stores both names. Petition-path Recommend still stores Core `namedOpponent` and paints `"  names  "`. Paint / petition line / `SaveNote` / no DEMANDED stay. `runB25A()` is nested inside `runB8E()`. Isolated `lua tests/test_console.lua` **1841 passed, 0 failed**, exit 0. Start / End leftover selected fighters remain parked. The `runB24A()` harness clear did not weaken B24-A lifetime.

Do not claim V1 / MVP complete. This review does not sign the lane.
