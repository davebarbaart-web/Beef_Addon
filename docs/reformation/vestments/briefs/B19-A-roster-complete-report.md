# B19-A — Petitions fail-open until Roster is complete (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.2 (present-and-alive pool); `Roster:IsComplete` (login seed is the player name only); brief `docs/reformation/vestments/briefs/B19-A-roster-complete.md`. `presentCharacterIds` keyed on `Roster.ready` plus member-name match, so a seed snapshot hid every petitioner who was not the local player. Ready-but-not-complete now fail-opens every Store snapshot character id. Complete keeps the member-name filter. Missing / not-ready / non-table members stay `{}`. `SaveNote` stays nil. No `UnitIsDead`. No new empty-state copy. No "DEMANDED". Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 1438 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB19A()` inside `runB8E()` after `runB18B()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB19A()` inside `runB8E()` after `runB18B()` (Lua 5.1 200-local cap; no new main-chunk locals). Two Store characters petitioned. Missing / not-ready / non-table members → `GetPetitions` `{}`. `complete = true` (and `IsComplete` → true) with members only Beefina → that one petition. `complete = false` / ready-without-complete, members only the local name → both petitions. `GetPresence` stays member-only. Source pins: `IsComplete` / `complete` field, empty copy stays, no `UnitIsDead` / SaveNote / SUMMON / parchment / tabs. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Console.lua` | `presentCharacterIds`: after the existing ready/members empty return, detect complete (`type(Roster.IsComplete) == "function"` and `Roster:IsComplete() == true`, else `Roster.complete == true`). Not complete → mark every Store snapshot character id and return. Complete → existing member-name filter. `GetPresence` untouched. Empty copy untouched. |
| `docs/reformation/vestments/briefs/B19-A-roster-complete-report.md` | This file |
| `docs/reformation/vestments/briefs/B19-A-roster-complete.diff` | B19-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Roster, Gora, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not invent "DEMANDED". Did not define `SaveNote`. Did not add `UnitIsDead`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B19-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `presentCharacterIds` | Missing / `ready ~= true` / `members` not a table → `{}`. Ready but not complete → every Store snapshot character id. Complete → member-name filter. |
| Complete detection | `type(Roster.IsComplete) == "function"` and `Roster:IsComplete() == true`, else `Roster.complete == true`. |
| `GetPetitions` | `Gora:GetPetitions(presentCharacterIds())`. Unchanged call. |
| `GetPresence` | Unchanged. Still lists roster members. Not fail-open. |
| Empty copy | `"No one on the roster yet."` / `"No petitions."` stay. |
| `SaveNote` | Stays nil. |

### Unchanged

- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- No `UnitIsDead`. No alive scrape.

## TDD

1. Extended `tests/test_console.lua` first (`runB19A()` nested in `runB8E()` after `runB18B()`: not-ready `{}`; complete / `IsComplete` filter to one of two; `complete = false` and ready-without-complete still show the second Store petitioner; `GetPresence` stays member-only; source / SaveNote / isolation). Isolation wrap untouched except the new nested pin block.
2. Red: `lua tests/test_console.lua` — **1431 passed, 7 failed** (fail-open still hid the second petitioner; `IsComplete` / `complete` source pins missing). Complete filter and not-ready `{}` already green.
3. `presentCharacterIds` fail-opens Store ids until complete. Member-name filter kept for the complete path.
4. Green: `lua tests/test_console.lua` — **1438 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 1438 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **1438 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 1438 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Roster / Gora / glue / TOC not edited.
- Ready-but-not-complete fail-opens Store snapshot character ids. Complete keeps the member-name filter. Not-ready stays `{}`.
- `GetPresence` was not rewritten. Empty copy stays. `SaveNote` nil. No `UnitIsDead`.
- `runB19A()` is nested inside `runB8E()` after `runB18B()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **No client smoke.** Login seed vs `GUILD_ROSTER_UPDATE` complete flip is unproven on Anniversary.
- **Fail-open is not an alive scrape.** Every Store snapshot character id is marked present until Roster is complete. Dead petitioners can still show in that window. No `UnitIsDead`.
- **`GetPresence` still member-filters** while incomplete. The seed window can still list only the local name on Presence even as petitions fail-open.
- **Empty Store snapshot still yields `{}`.** Fail-open walks `snap.characters`; it does not invent ids.
- **Isolation does not load `Roster.lua`.** Complete detection is stubbed (`complete` field or `IsComplete` method).

## Status

**DONE_WITH_CONCERNS.** Not signed. No Gate / **POLISH:PASS** claim.
