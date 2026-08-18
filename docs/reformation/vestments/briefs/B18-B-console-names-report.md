# B18-B — Console petition challenge line is pinned (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.2 / §18.1; brief `docs/reformation/vestments/briefs/B18-B-console-names.md`. B17 lands named opponents on `Gora:Petition`. This lane pins the desk path: `petitionLine` already paints `left .. "  names  " .. right` plus mute H2H when `namedOpponentId` is set; click already `SelectFighters` both ids. Copy stays. No "DEMANDED" / narration. `SaveNote` stays nil. Stock desk. No new codec kind. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 1388 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB18B()` inside `runB8E()` after `runB14D()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB18B()` inside `runB8E()` after `runB14D()` (Lua 5.1 200-local cap; no new main-chunk locals). After StartEvent + two known characters + `Gora:Petition(a, b)` and present roster, `GetPetitions` keeps both ids; `PetitionsList` FontString and the row button contain `"  names  "`. Clicking the row `SelectFighters` both ids. Source pin: `left .. "  names  " .. right` and `SelectFighters(row.characterId, row.namedOpponentId)`. No DEMANDED / demanded / odds / meeting. SaveNote / SUMMON / parchment / tabs / isolation wrap stay. |
| `addon/ChurchOfBeef/UI/Console.lua` | Unchanged. `petitionLine` and `onPetitionClick` already wired. Refresh already `SetText`s `PetitionsList` via `petitionLine` before hiding the FontString when rows exist. No new prose. |
| `docs/reformation/vestments/briefs/B18-B-console-names-report.md` | This file |
| `docs/reformation/vestments/briefs/B18-B-console-names.diff` | B18-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Gora, Inputs, Net, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not invent "DEMANDED". Did not define `SaveNote`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B18-B-only delta.

## Contract

| Surface | Role |
|---------|------|
| `petitionLine` | `left .. "  names  " .. right` when `namedOpponentId` is set. Mute numeric H2H only when Store has history. Copy stays. |
| `paintPetitions` | FontString `SetText` via `petitionLine`. Row buttons use the same `petitionLine`. |
| `onPetitionClick` | `SelectCharacter` the petitioner. When `namedOpponentId` is set, `SelectFighters` both ids. Then Refresh. |
| `GetPetitions` | Present-and-alive copies from `Gora:GetPetitions`. Named row keeps `namedOpponentId`. Not a painted string. |
| `SaveNote` | Stays nil. |

### Unchanged

- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- `petitionLine` wording. No DEMANDED / flavor.

## TDD

1. Extended `tests/test_console.lua` first (`runB18B()` nested in `runB8E()` after `runB14D()`: StartEvent, two characters, `Gora:Petition(a, b)`, GetPetitions ids, FontString `"  names  "`, row button `"  names  "`, click SelectFighters both ids, source copy pin, SaveNote / SUMMON / parchment / tabs / isolation). Isolation wrap untouched except the new nested pin block.
2. Red: no new fail. Existing `petitionLine` / `onPetitionClick` already satisfied the pins on first run.
3. `Console.lua` not edited. Refresh paint path already calls `petitionLine` for the list FontString.
4. Green: `lua tests/test_console.lua` — **1388 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 1388 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **1388 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 1388 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Gora / Inputs / Net / glue / TOC not edited.
- Named petition paints `"  names  "` on `PetitionsList` and the row button. Click `SelectFighters` both ids.
- `petitionLine` copy stays. No DEMANDED. `SaveNote` nil.
- `runB18B()` is nested inside `runB8E()` after `runB14D()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **No client smoke.** Live petition-row click vs `SelectFighters` vs Refresh `"> "` prefix is unproven on Anniversary. Harness `OnClick` is a stub fire.
- **`GetPetitions` is data, not the painted string.** The `"  names  "` token lives on `PetitionsList` / the row button. Rows keep `namedOpponentId`.
- **`PetitionsList` is Hidden when rows exist.** `SetText` still runs via `petitionLine` before Hide. Visible paint is the row button.
- **Unnamed petition click is not this pin.** `onPetitionClick` still `SelectCharacter` only when `namedOpponentId` is nil.
- **Presence filter stays.** GetPetitions still needs `Roster.ready` and name-key members, same as the existing desk.

## Status

**DONE_WITH_CONCERNS.** Not signed. No Gate / **POLISH:PASS** claim.
