# B23-D — Empty player name omits petition opponent (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.2 / §18.5 (a petition may name a desired opponent; congregation input never triggers public theater); Law 5 / §13.1 (whisper dest stays injected `inputTarget`); B21-D leftover (`""` and `"   "` from `UnitName("player")` are strings, so fail-closed does not run; `Names.Same` is false and the target is named as opponent); brief `docs/reformation/vestments/briefs/B23-D-inputs-empty-player.md`. Anniversary `UnitName(unit)` exists (`classic_anniversary`, 20506). No realm compare. No Pope-name lookup. No `TargetUnit`. No `PlaySound`. No `Gora:Petition`. WIDTH 328 / HEIGHT 72 stay. TitleBar persist stays. ESC ClearFocus and `SetMultiLine(true)` stay. Not on `UISpecialFrames`. Challenge law (B17-C) and player-pcall fail-closed (B21-D) stay.

Trim the player name (`^%s+` / `%s+$`) like the target. After trim, empty or non-string → omit opponent. pcall fail still omits. Successful `"Beefina"` + `"Chuckroast"` still names opponent. Dest-same still omits. Missing `UnitName` stays omit. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 756 passed, 0 failed (`lua tests/test_inputs.lua`). **24** isolation pins under the first `if standalone then`; **6** re-pins in `runB14B()`; **6** B15-A re-pins and **6** B16-B re-pins in `runB15A()`; **6** re-pins in `runB17C()`; **6** re-pins in `runB18A()`; **6** re-pins in `runB21D()`; **6** re-pins in `runB23D()` (nested in `runB21D()` / `runB18A()`).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_inputs.lua` | TDD first. Nested `runB23D()` inside `runB21D()` / `runB18A()` (Lua 5.1 200-local; no new main-chunk locals). Stub target `"Chuckroast"`, player `""` or `"   "`, dest `"Host"` → `fields.opponent` omitted. Unpadded Chuckroast + successful player still names opponent. pcall fail / dest-same / missing `UnitName` omit. Quiet / ESC / TitleBar / isolation wrap stay. |
| `addon/ChurchOfBeef/UI/Inputs.lua` | `petitionOpponent` trims `playerName` (`^%s+` / `%s+$`) like the target. After trim, empty or non-string omits. Fail-closed `not pok` / non-string stays. Dest-same and player-same still omit. |
| `docs/reformation/vestments/briefs/B23-D-inputs-empty-player-report.md` | This file |
| `docs/reformation/vestments/briefs/B23-D-inputs-empty-player.diff` | B23-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Net, Codec, Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not look up a Pope name. Did not call `TargetUnit`. Did not add `PlaySound`. Did not call `Gora:Petition`. Did not invent a realm compare. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Inputs batches (working tree already dirty / exclusive files still untracked). The brief diff is the B23-D-only delta.

## Contract

```lua
local function petitionOpponent()
  -- missing UnitName → nil
  -- pcall UnitName("target") and UnitName("player")
  -- trim target ^%s+ / %s+$; empty after trim → nil
  -- Names.Same vs inputTarget → nil
  -- not pok or playerName not a string → nil (fail-closed)
  -- trim player ^%s+ / %s+$; empty or non-string after trim → nil
  -- Names.Same vs playerName → nil
  -- else target name
end
```

| Target / player | Fields |
|-----------------|--------|
| `"Chuckroast"` + player `""` | `{ characterId }` only |
| `"Chuckroast"` + player `"   "` | `{ characterId }` only |
| `"Chuckroast"` + player `"Beefina"` | `{ characterId, opponent = "Chuckroast" }` |
| `"Chuckroast"` + player throws | `{ characterId }` only |
| Dest-same Host + successful player | `{ characterId }` only |
| Missing `UnitName` | `{ characterId }` only |

Keep:

- Whisper dest is still `inputTarget` (injected). No Pope-name lookup.
- WIDTH 328 / HEIGHT 72. TitleBar 12px + persist `ChurchOfBeefDB.ui.inputs`.
- ESC `ClearFocus` only. `SetMultiLine(true)`. Not on `UISpecialFrames`.
- No `TargetUnit`. No `PlaySound`. No `Gora:Petition`.
- Challenge law (B17-C) and player-pcall fail-closed (B21-D) stay.
- Isolation wrap stays (wow_ui_stub + Common + Runtime + Inputs). No new main-chunk locals.

## TDD

1. Extended `tests/test_inputs.lua` first (`runB23D()` inside `runB21D()` / `runB18A()`: empty player omit; whitespace player omit; unpadded Chuckroast + successful player still names; pcall fail / dest-same / missing `UnitName` omit; Quiet / ESC / TitleBar / isolation stay). Isolation wrap untouched.
2. Red: `lua tests/test_inputs.lua` — **753 passed, 4 failed** (empty player still named Chuckroast; whitespace player still named Chuckroast; player-trim source pins missing).
3. `petitionOpponent` trims `playerName` like the target; empty or non-string after trim omits. No chrome change.
4. Green: `lua tests/test_inputs.lua` — **756 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_inputs.lua   # 756 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_inputs.lua` standalone | **756 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 24 original isolation asserts stay under `if standalone then`. `runB14B()` / `runB15A()` / `runB17C()` / `runB18A()` / `runB21D()` / `runB23D()` re-pin Console / Popes / Sender / Sound / Hud / slash.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Net / Codec / Console / glue / TOC were not edited.
- Empty `""` and whitespace `"   "` player names omit opponent after trim. They no longer skip fail-closed and name Chuckroast.
- pcall fail still omits. Dest-same still omits. Missing `UnitName` stays omit.
- Unpadded Chuckroast + successful `"Beefina"` still names opponent.
- Whisper dest stays `inputTarget`. No Pope list. No `TargetUnit`. No `Gora:Petition`. No `PlaySound`. No realm compare.
- HEIGHT 72. TitleBar persist. ESC ClearFocus. Not on `UISpecialFrames`. Isolation wrap stays. No new main-chunk locals.

## Leftovers

- **Parked (later Console batch):** `lastRecommendation` lifetime across EndEvent; selected-pair inherit of Core `namedOpponent`.
- **No client smoke.** Live `UnitName("player")` empty / whitespace on Anniversary after `/reload` is unproven.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Internal whitespace is not collapsed.** Only leading / trailing `^%s+` / `%s+$`.
- **No realm compare.** Anniversary `UnitName` also returns `unitServer`; this lane does not fold it.
- **Non-string player pin is still `nil` only** (B21-D leftover). `false` / `123` / `{}` are not newly pinned here.
- **Click + empty player is unpinned.** Petition button still calls `Inputs:Petition`.

## Status

**DONE_WITH_CONCERNS.** Isolated **756 / 0**. Not signed. No Gate W / Gate V / **POLISH:PASS** / V1 claim.
