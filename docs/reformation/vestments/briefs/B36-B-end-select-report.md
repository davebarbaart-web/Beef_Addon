# B36-B — End Event drops leftover human / character selection (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 leftover highlight; B26-A already nils `selectedFighterA` / `B` on successful Start / End; leftover `selectedHumanId` / `selectedCharacterId` still fed CallForward / Dismiss / KnightThisBeef / Presence highlight after End; brief `docs/reformation/vestments/briefs/B36-B-end-select.md`. Successful `EndEvent` (`result ~= nil`) also nils `selectedHumanId` and `selectedCharacterId` **before** `after()`. Fighter-pair clear stays. Successful `StartEvent` does **not** nil human / character. Refresh does **not** nil selection. Failed End / Continue keep. `SaveNote` stays nil. No SUMMON. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 2490 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB36B()` inside `runB8E()` after `runB34B()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB36B()` inside `runB8E()` after `runB34B()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pins: EndEvent success block nils lastRecommendation, the fighter pair, and human / character before `after()`; StartEvent still nils only lastRecommendation and the pair; Refresh / Continue do not nil the pick. Behavioral: Quiet pick + Refresh + StartEvent keep human / character; OpenRite Knighting still uses the pick; failed End from RITE and Continue keep; successful EndEvent nils human, character, and the pair. CallForward without an id refuses when Confession is nil and, with a stub, is not called with the leftover character. Dismiss / KnightThisBeef without an id do not fire on the leftover (wrap records nil; rank stays Fresh Beef). SaveNote / SUMMON / parchment / tabs / isolation wrap stay. B24-A / B26-A / B27-A / B28-A / B29-A / B31-A EndEvent source strings updated so the pair-clear still pins inside the same success block. |
| `addon/ChurchOfBeef/UI/Console.lua` | Successful `EndEvent` also nils `selectedHumanId` and `selectedCharacterId` after the fighter-pair clear, before `after()`. `StartEvent` unchanged (does not nil human / character). Refresh / Continue / failed End unchanged. Header notes the pick lifetime. No new file locals. |
| `docs/reformation/vestments/briefs/B36-B-end-select-report.md` | This file |
| `docs/reformation/vestments/briefs/B36-B-end-select.diff` | B36-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit glue, Knighting, Confession, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add parchment, tabs, or SUMMON. Did not define `SaveNote`. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B36-B-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Console:EndEvent` | On `result ~= nil`, `lastRecommendation = nil` then fighter pair nil then `selectedHumanId` / `selectedCharacterId` = nil before `after()`. Failed End (not ASSEMBLY / CONSEQUENCE) keeps the pick. |
| `Console:StartEvent` | Unchanged. Nils lastRecommendation and the fighter pair only. Quiet pick then Start keeps human / character. |
| `Console:Refresh` | Unchanged. QUIET / nil Runtime state nils lastRecommendation. Does not nil the pick or the pair. |
| `Console:Continue` | Unchanged. Does not clear the pick. |
| CallForward / Dismiss / KnightThisBeef | Unchanged fallbacks (`id or selected*`). After a successful End they resolve nil and refuse or no-op. |
| `SaveNote` | Stays nil. |

### Unchanged

- B26-A fighter-pair clear on successful Start / End.
- B31-A Quiet Recommend drop. Refresh does not nil the pair.
- B32-B Dismiss still reaches Confession when present (same resolved id).
- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- No new file locals in `Console.lua`.

## TDD

1. Extended `tests/test_console.lua` first (`runB36B()` nested in `runB8E()` after `runB34B()`: EndEvent source nils human / character before `after()`; StartEvent / Refresh / Continue do not; Quiet pick + Start keeps; failed End / Continue keep; EndEvent nils both ids and the pair; leftover CallForward / Dismiss / KnightThisBeef without an explicit id refuse or no-op; SaveNote / SUMMON / isolation). Isolation wrap untouched except the new nested pin block.
2. Red: `lua tests/test_console.lua` — **2479 passed, 12 failed** (EndEvent source missing human / character nils; successful End left selected ids 1/1; stub CallForward / Dismiss / KnightThisBeef fired on the leftover; leftover KnightThisBeef raised rank to Knight). Quiet-pick Start keep / Refresh keep / failed End keep / Continue keep / isolation CallForward refuse / SaveNote / isolation stayed green.
3. `EndEvent` sets `selectedHumanId = nil` and `selectedCharacterId = nil` when `result ~= nil`, after the fighter-pair clear, before `after()`. StartEvent / Refresh / Continue kept.
4. After the Console patch, B24-A / B26-A / B27-A / B28-A / B29-A / B31-A exact EndEvent source strings failed until updated so the pair-clear (and new pick-clear) still pins inside the same success block. One leftover Dismiss petition-survival pin was dropped: `Gora:_Expire` wipes petitions in QUIET, so `#GetPetitions` is 0 after End even when Dismiss is called with nil.
5. Green: `lua tests/test_console.lua` — **2490 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 2490 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **2490 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 2490 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged. `runB36B()` re-pins 4 of them plus `COB.Popes`.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Glue / Knighting / Confession / TOC not edited.
- Successful End nils human / character before Refresh. Successful Start keeps the Quiet pick. Failed End / Continue / Refresh keep.
- Fighter-pair clear stays. `lastRecommendation` clear stays.
- Leftover CallForward / Dismiss / KnightThisBeef without an explicit id do not fire on the leftover.
- `runB36B()` is nested inside `runB8E()` after `runB34B()`. No new main-chunk locals.
- Isolation wrap stays. `SaveNote` nil. No SUMMON.

## Leftovers

- **`Gora:_Expire` wipes petitions in QUIET.** Leftover Dismiss after End cannot be proven by petition survival. The wrap proves the resolved id is nil; `Dismiss()` returns false because there is no live event petition, not only because the pick died.
- **Other selected-id fallbacks were not named.** ElevateToLord / Enqueue / Skip / AddHonorific / Recognition also read `selectedHumanId` / `selectedCharacterId`. After End they also resolve nil. Not separately pinned.
- **Presence highlight after End** is `after()` Refresh with nils. Not a separate click-highlight paint pin.
- **No client smoke.** Live desk after End Event (no leftover highlight / no leftover Knight) is unproven on Anniversary.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Confession.lua was not loaded.** Isolated CallForward refuse is the nil-module path; leftover-id no-op is a stub.

## Status

**DONE_WITH_CONCERNS.** Isolated **2490 / 0**. Isolation wrap **17**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
