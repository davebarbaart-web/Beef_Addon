Spec PASS

# B23-A — Theater owns §19.4 cues when Proclaim exists (review)

**Quality:** Approved-with-nits

**Lane:** B23-A Theater owns §19.4 cues when Proclaim exists
**Brief:** `docs/reformation/vestments/briefs/B23-A-after-cue.md`
**Writer report:** `docs/reformation/vestments/briefs/B23-A-after-cue-report.md`
**Diff:** `docs/reformation/vestments/briefs/B23-A-after-cue.diff` (B23-A-only exclusive-pair packet; live `Console.lua` also carries earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`playCue` before `Sound:Play`, `after()` cue pass-through), and `tests/test_console.lua` (existing Sound stub pins, nested `runB23A()` inside `runB8E()` after `runB22A()`); then ran `lua tests/test_console.lua` (**1693 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §19.4 (five cues; theater owns them); V-INT leftover (Console `after()` `playCue` and `Toasts:Proclaim` → `playTheaterCue` played the same name twice); `playCue` no-ops when `Toasts.Proclaim` exists; existing Sound pins stay; nest `runB8E()`; no Proclaim from Console; `SaveNote` stays nil; no new cue names; no Net. Isolation wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit Toasts, Sound, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `playCue` still `Sound:Play`s when `Toasts.Proclaim` exists (double §19.4 cue) | **Pass. Verified.** After `local Toasts = COB.Toasts`, `type(Toasts) == "table" and type(Toasts.Proclaim) == "function"` returns before `Sound`. Nested pins: KnightThisBeef then Sanction leave `#soundCalls == 0`. Reviewer probes: ElevateToLord / Void / DeclareVictor / CowardiceRecorded / FreeRuling also leave the Sound spy at 0. |
| Isolated Sound pins (Toasts not loaded) broken | **Pass.** Main-chunk Sound stub block is unchanged. `COB.Toasts` is nil there. Pins still name knighting / elevation / sanction / verdict / cowardice. Reviewer probe: Toasts nil still appends those names. Suite **1693 / 0**. |
| Cue arguments removed on Sanction / KnightThisBeef / ElevateToLord / the four rulings | **Pass.** Live `after(...)` still passes `"sanction"`, `"knighting"`, `"elevation"`, `"verdict"` (Void / DeclareVictor / FreeRuling), `"cowardice"`. Source pins keep the first three; reviewer source check keeps the rest. No new cue names. |
| Console calls `Toasts:Proclaim` | **Pass. Verified.** Source has no `Toasts:Proclaim` and no `Toasts.Proclaim(`. Nested spy: `proclaimCalls` stays 0 on StartEvent / KnightThisBeef / Sanction. Reviewer probe: still 0 on ElevateToLord and the four rulings. |
| Console calls Net | **Pass.** `after()` is still Refresh / `playCue` / `refreshHud`. Source has no `COB.Net` / `SendAddonMessage`. Integrator comment stays: do not call Net here. |
| `SaveNote` defined; SUMMON / parchment / tabs | **Pass.** `Console.SaveNote` nil before and after the nested block. Source has no `function Console:SaveNote`, no `SUMMON THE FAITHFUL`, no `Parchment`, no `PanelTabButtonTemplate`. |
| New main-chunk locals / not nested in `runB8E()` | **Pass.** `runB23A()` is a nested `local function` inside `runB8E()` after `runB22A()`. Packet adds no main-chunk `local`. Header comment only at file top. |
| Isolated suite not exit 0 | **Pass. Verified.** 1693 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two `diff --git` hunks (Proclaim guard on `playCue`; header comment + nested `runB23A()`). Sibling dirt in this workspace is other lanes (Toasts, Sound, glue, `run.lua`, earlier Console batches). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Toasts / Sound / glue; no commit | **Pass.** Named-risk check. |
| Isolation wrap stays; suite does not load Toasts | **Pass.** Nine `dofile`s unchanged. Load wrap still **17** nil-module pins under `if standalone then`. `COB.Toasts` is one of them. |
| `playCue` returns without `Sound:Play` when `COB.Toasts` is a table and `type(Toasts.Proclaim) == "function"` | **Pass.** Guard is those two `type` checks, then `return`. Pins and probes. |
| Isolated Sound:Play path stays for harness pins | **Pass.** `pcall(Sound.Play, Sound, name)` stays after the guard. Existing Sound stub pins stay green. |
| Do not remove cue arguments on the verbs | **Pass.** Named-risk check. |
| Do not call `Toasts:Proclaim` from Console | **Pass.** Named-risk check. |
| Do not call Net | **Pass.** Named-risk check. |
| `SaveNote` stays nil; no new cue names | **Pass.** Named-risk check. |
| Nest new pins in `runB8E()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Nested pin: Toasts.Proclaim stub; Sanction and one other cued verb do not append to the Sound spy | **Pass.** KnightThisBeef then Sanction. StartEvent also pinned at 0 (no cue arg). |
| Isolation wrap stays; existing Sound pins stay | **Pass.** Wrap untouched. Sound stub block sits in the main chunk before `runB8E()`. |
| `lua tests/test_console.lua` exit 0 | **Pass.** **1693 / 0.** |

Bible §19.4 holds on the exclusive pair: the five named cues stay on the verbs; the desk does not play them when theater can. V-INT's accepted double cue is closed on Console `playCue` without Console calling Proclaim. Law 4 / Law 6 hold: the desk does not invent a cue name or a Quiet toast.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| `lastRecommendation` lifetime across EndEvent stays parked | **On contract.** Batch 23 overview parks it. Not this exclusive pair. |
| Selected-pair inherit of Core `namedOpponent` stays parked | **On contract.** Same overview park. |
| No client / two-client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| ElevateToLord and the four rulings share `playCue`; nested spies cover KnightThisBeef and Sanction only | **On contract.** Brief asked Sanction and one other cued verb. Source pins keep the other cue arguments. Reviewer probes: those five verbs also leave the Sound spy at 0 and do not Proclaim. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

Live glue (`ChurchOfBeef.lua` `wrapAfter` → `proclaim` → `Toasts:Proclaim` → `playTheaterCue`) was not edited and is not required for B23-INT. On the live client, `Toasts.lua` defines `Proclaim`, so desk `playCue` no-ops and theater owns the name. Isolated suite does not load Toasts or install that wire.

---

## Isolation / playCue / Sound pins

**Isolation wrap — Pass.** Load list is still Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. No `dofile` of Toasts / Sound / UI shell / Net / DB / glue. Standalone wrap is still 17 nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Nested B23-A re-pins Archive / UI / Toasts / Confession / Popes after restore.

**playCue — Pass.** Guard is presence of a function `Toasts.Proclaim`, not a Console call. `after()` still passes the existing names only when `result ~= nil`. StartEvent / EndEvent / OpenRite / CloseRite / Continue still have no cue. Reviewer probes: empty Toasts table, `Proclaim = "nope"`, and a non-table `Toasts` still `Sound:Play` (`knighting`). Function Proclaim no-ops Sound on all seven cued verbs and never increments a Proclaim spy.

**Sound pins — Pass.** Main-chunk stub still plays knighting / elevation / sanction / verdict / cowardice when Toasts is nil. Missing Sound and exploding `Sound.Play` pins stay. Nested block restores `COB.Sound` / `COB.Toasts` and the Pope predicate; `SaveNote` stays nil.

---

## Strengths

- The guard is four lines at the top of `playCue`. Failed path cannot `pcall(Sound.Play, ...)`. Isolated `Sound.Play` path is untouched below it.
- Cue arguments stay on the verbs. Console does not call Proclaim or Net. `SaveNote` stays nil.
- Nested spies use the brief's stub (`COB.Toasts = { Proclaim = function() end }`) and pin both Sound and Proclaim at 0. KnightThisBeef is the extra cued verb.
- Existing Sound stub pins were left in the main chunk. Isolation wrap was not rewritten. `runB23A()` is nested inside `runB8E()` after `runB22A()`.
- Writer-reported **1693 / 0** matched the re-run. Writer-reported red count (**1690 / 3**) matches the three asserts old `playCue` would fail (KnightThisBeef Sound spy, Sanction Sound spy, source `type(Toasts.Proclaim) == "function"`).

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **ElevateToLord and the four rulings are unpinned on the Proclaim-exists path.** Brief scoped the nested spy to Sanction plus one other. Those five verbs share `playCue` and keep their cue arguments. Reviewer probes: Sound spy stays 0; Proclaim spy stays 0. Not a second fixture language.

### Nit

1. **Guard is presence of `Proclaim`, not a successful theater play.** Brief asked for that. A Toasts stub with a no-op `Proclaim` silences the desk even when glue has not called theater. Live `InstallWire` is what actually `Proclaim`s. Isolated suite does not install that wire.

2. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. Nested B23-A re-pins four of them plus Popes after restore. Brief said the wrap stays; it did.

3. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B23-A-only guard + nested pins. `git diff HEAD` on the two files still includes earlier console batches. Report already says this.

4. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **1693 / 0** was re-run here. Pope-desk single cue vs congregation paint is unproven on Anniversary.

5. **Parked Batch 23 Console leftovers** (`lastRecommendation` across EndEvent; selected-pair inherit of Core `namedOpponent`) are other work. Not this exclusive pair.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **1693 passed, 0 failed.** Isolation wrap: **17**.

`playCue` returns without `Sound:Play` when `COB.Toasts` is a table and `Toasts.Proclaim` is a function. Isolated suite does not load Toasts; existing Sound pins still play knighting / elevation / sanction / verdict / cowardice. Cue arguments stay. Console does not call Proclaim or Net. `SaveNote` stays nil. `runB23A()` is nested inside `runB8E()`. Isolated `lua tests/test_console.lua` **1693 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
