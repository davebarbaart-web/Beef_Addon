# B21-A — Presence fail-opens until Roster is complete (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.2 (present-and-alive pool); B19-A leftover (`presentCharacterIds` fail-opens Store ids while Roster is ready but not complete; `GetPresence` still listed seed members only); brief `docs/reformation/vestments/briefs/B21-A-presence-seed.md`. Complete detection mirrors petitions: `IsComplete() == true` if the method exists, else `Roster.complete == true`. Ready-but-not-complete keeps the member walk (`here = true`), then appends Store snapshot characters whose name key is not already in the rows (`here = false`). Missing / not-ready / non-table members stay `{}`. Complete keeps members only. `SaveNote` stays nil. No `UnitIsDead`. No new empty-state copy. No "DEMANDED". Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 1585 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB21A()` inside `runB8E()` after `runB20A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Flipped the two B19-A asserts that said GetPresence was not fail-open (incomplete seed: Beefina + Chuckroast; Chuckroast `here == false` and carries `characterId`). Nested `runB21A()` inside `runB8E()` after `runB20A()` (Lua 5.1 200-local cap; no new main-chunk locals). Missing / not-ready / non-table members → `GetPresence` `{}`. Complete / `IsComplete` true stay one member. Incomplete and ready-without-complete list both; Store-only copies Store human rank. Clicking the fail-open Store `PresenceRows` button selects that `characterId`. Source pins: `here = false`, complete detection, empty copy stays, `"  names  "` parked, no `UnitIsDead` / SaveNote / SUMMON / parchment / tabs. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Console.lua` | `GetPresence`: after the existing member walk, detect complete the same way `presentCharacterIds` does. Not complete → append Store snapshot characters whose name key is not already in the rows. Appended rows use `here = false` and copy Store human rank the same way the member walk does. Complete path unchanged. `presentCharacterIds` not rewritten. Empty copy `"No one on the roster yet."` unchanged. |
| `docs/reformation/vestments/briefs/B21-A-presence-seed-report.md` | This file |
| `docs/reformation/vestments/briefs/B21-A-presence-seed.diff` | B21-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Roster, Gora, Confession.lua, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not invent "DEMANDED". Did not define `SaveNote`. Did not add a second Dismiss. Did not add `UnitIsDead`. Did not rewrite `presentCharacterIds`. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B21-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `GetPresence` | Missing / `ready ~= true` / `members` not a table → `{}`. Complete → current member walk (`here = true`, unlinked roster names stay). Ready but not complete → that walk, then append Store snapshot characters whose name key is not already in the rows (`here = false`). |
| Complete detection | `type(Roster.IsComplete) == "function"` and `Roster:IsComplete() == true`, else `Roster.complete == true`. |
| Store-only row | `here = false`. Copy Store human rank the same way the member walk does. Do not invent they are in the room. No invented guild rank. |
| `presentCharacterIds` | Unchanged. |
| Empty copy | `"No one on the roster yet."` stays. |
| Recommend `"  names  "` | Stays parked. |
| `SaveNote` | Stays nil. |

### Unchanged

- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- No `UnitIsDead`. No alive scrape.
- One Dismiss plate.

## TDD

1. Extended `tests/test_console.lua` first (flipped the two B19-A GetPresence-not-fail-open asserts; nested `runB21A()` in `runB8E()` after `runB20A()`: not-ready `{}`; complete / `IsComplete` stay one member; incomplete seed lists Chuckroast `here == false` with `characterId` and Store rank; click `PresenceRows` selects that id; source / SaveNote / isolation). Isolation wrap untouched except the new nested pin block.
2. Red: `lua tests/test_console.lua` — **1566 passed, 19 failed** (fail-open still listed Beefina only; `here = false` source pin missing; click did not select the Store-only id). Complete / not-ready / missing `{}` already green.
3. `GetPresence` appends Store-only rows while ready but not complete. Member walk and `presentCharacterIds` kept.
4. Green: `lua tests/test_console.lua` — **1585 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 1585 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **1585 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 1585 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Roster / Gora / glue / TOC not edited.
- Ready-but-not-complete appends Store snapshot characters not already named in the member walk. Complete keeps members only. Not-ready stays `{}`.
- Appended rows use `here = false`. Store human rank is copied. No invented presence.
- `presentCharacterIds` was not rewritten. Empty copy stays. `SaveNote` nil. No `UnitIsDead`.
- `runB21A()` is nested inside `runB8E()` after `runB20A()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **Recommend `"  names  "` stays parked.** Named-opponent Recommend paint is a later Console batch. This lane did not touch it.
- **Desk `after()` double cue** stays parked (Batch 21 overview).
- **No client smoke.** Login seed vs `GUILD_ROSTER_UPDATE` complete flip is unproven on Anniversary. Harness `OnClick` is a stub fire.
- **Fail-open is not an alive scrape.** Store-only rows can appear with `here = false` during the seed window even if the character is dead or not in the room. No `UnitIsDead`.
- **Empty Store snapshot still yields members only.** Append walks `snap.characters`; it does not invent ids.
- **Isolation does not load `Roster.lua`.** Complete detection is stubbed (`complete` field or `IsComplete` method).

## Status

**DONE_WITH_CONCERNS.** Not signed. No Gate / **POLISH:PASS** claim.
