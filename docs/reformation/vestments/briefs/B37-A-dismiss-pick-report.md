# B37-A — successful Dismiss drops leftover character pick (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 leftover highlight; B36-B EndEvent nils `selectedCharacterId`; live `Dismiss` still resolved `id = characterId or self.selectedCharacterId` and never niled the pick, so one-click CallForward / DeclareVictor still resolved the dismissed petitioner; brief `docs/reformation/vestments/briefs/B37-A-dismiss-pick.md`. Successful `Dismiss` (`ok` true, including Confession-only) nils `selectedCharacterId` **before** Refresh. Failed Dismiss keeps. Does **not** nil `selectedHumanId`. End / Start / Refresh keeps stay. `SaveNote` stays nil. No SUMMON. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 2573 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB37A()` inside `runB8E()` after `runB36B()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB37A()` inside `runB8E()` after `runB36B()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pins: Dismiss success block nils `selectedCharacterId` before Refresh and does not nil `selectedHumanId`; Start / End / Refresh keep strings stay. Behavioral: pick + Refresh + Start keep; failed Dismiss (no petition) keeps both ids; successful Gora Dismiss nils character and keeps human; leftover CallForward / DeclareVictor without an explicit id do not fire on the leftover; Confession-only success also nils the character pick. B32-B Dismiss Refresh source pin updated to the new success block. SaveNote / SUMMON / parchment / tabs / isolation wrap stay. |
| `addon/ChurchOfBeef/UI/Console.lua` | Successful `Dismiss` (`ok` true) nils `selectedCharacterId` before Refresh. Failed Dismiss unchanged. Does not nil `selectedHumanId`. Header notes the pick lifetime. No new file locals. |
| `docs/reformation/vestments/briefs/B37-A-dismiss-pick-report.md` | This file |
| `docs/reformation/vestments/briefs/B37-A-dismiss-pick.diff` | B37-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit glue, Gora, Confession, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add parchment, tabs, or SUMMON. Did not define `SaveNote`. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B37-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Console:Dismiss` | On `ok` true (Gora or Confession-only), `selectedCharacterId = nil` then `Refresh()`. Failed Dismiss keeps the pick. Does not nil `selectedHumanId`. Fallback `characterId or self.selectedCharacterId` stays. |
| `Console:StartEvent` | Unchanged. Does not nil human / character. |
| `Console:EndEvent` | Unchanged. Still nils human / character on success (B36-B). |
| `Console:Refresh` | Unchanged. Does not nil the pick. |
| CallForward / DeclareVictor | Unchanged fallbacks (`id or selectedCharacterId`). After a successful Dismiss they resolve nil and refuse or no-op. |
| `SaveNote` | Stays nil. |

### Unchanged

- B36-B EndEvent pick-clear. Start / Refresh keeps.
- B32-B Dismiss still reaches Confession when present (same resolved id). Isolated Gora-only Dismiss stays when Confession is nil.
- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- No new file locals in `Console.lua`.

## TDD

1. Extended `tests/test_console.lua` first (`runB37A()` nested in `runB8E()` after `runB36B()`: Dismiss source nils character before Refresh and does not nil human; Start / End / Refresh keeps stay; pick + Refresh + Start keep; failed Dismiss keeps; successful Dismiss nils character and keeps human; leftover CallForward / DeclareVictor without an explicit id refuse or no-op; Confession-only success also nils; SaveNote / SUMMON / isolation). Isolation wrap untouched except the new nested pin block.
2. Red: `lua tests/test_console.lua` — **2567 passed, 6 failed** (Dismiss source missing character nil; successful Gora Dismiss and Confession-only left `selectedCharacterId` 1; stub CallForward / wrapped DeclareVictor fired on the leftover). Failed Dismiss keep / human keep / Start / Refresh keep / isolation CallForward refuse / SaveNote / isolation stayed green.
3. `Dismiss` sets `selectedCharacterId = nil` when `ok` is true, before `Refresh()`. Does not nil `selectedHumanId`. Start / End / Refresh kept.
4. After the Console patch, the B32-B exact Refresh source string failed until updated so Refresh still pins inside the same success block after the character nil.
5. Green: `lua tests/test_console.lua` — **2573 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 2573 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **2573 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 2573 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged. `runB37A()` re-pins 4 of them plus `COB.Popes`.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Glue / Gora / Confession / TOC not edited.
- Successful Dismiss nils character before Refresh. Confession-only success too. Failed Dismiss keeps. Does not nil `selectedHumanId`.
- End / Start / Refresh keeps stay.
- Leftover CallForward / DeclareVictor without an explicit id do not fire on the leftover.
- `runB37A()` is nested inside `runB8E()` after `runB36B()`. No new main-chunk locals.
- Isolation wrap stays. `SaveNote` nil. No SUMMON.

## Leftovers

- **DeclareVictor leftover is wrap-only.** Without a sanctioned pair, leftover would still refuse `no sanctioned gora`. The wrap proves the resolved id is nil.
- **Other selected-id fallbacks were not named.** CowardiceRecorded / FlagFamousUpset / Recognition also read `selectedCharacterId`. After Dismiss they also resolve nil. Not separately pinned.
- **Presence highlight after Dismiss** is Refresh with a nil pick. Not a separate click-highlight paint pin.
- **Explicit-id Dismiss of a different character** also nils the pick (unconditional on `ok`). Not pinned as "only when the dismissed id matches the pick."
- **No client smoke.** Live desk after Dismiss (no leftover highlight / no leftover CallForward) is unproven on Anniversary.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Confession.lua was not loaded.** Isolated CallForward refuse is the nil-module path; leftover-id no-op and Confession-only success are stubs.

## Status

**DONE_WITH_CONCERNS.** Isolated **2573 / 0**. Isolation wrap **17**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
