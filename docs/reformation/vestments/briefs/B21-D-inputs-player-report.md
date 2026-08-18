# B21-D — Petition omits opponent when the player name read fails (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.2 / §18.5 (a petition may name a desired opponent; congregation input never triggers public theater); Law 5 / §13.1 (whisper dest stays injected `inputTarget`); B17-C / B18-A leftover (`petitionOpponent` still returned a successful target name when `UnitName("player")` threw); brief `docs/reformation/vestments/briefs/B21-D-inputs-player.md`. Anniversary `UnitName(unit)` exists (`classic_anniversary`, 20506) and returns `unitName, unitServer`. No realm compare. No Pope-name lookup. No `TargetUnit`. No `PlaySound`. No `Gora:Petition`. WIDTH 328 / HEIGHT 72 stay. TitleBar 12px + persist `ui.inputs` stay. ESC ClearFocus and `SetMultiLine(true)` stay. Not on `UISpecialFrames`. Challenge law (B17-C) and trim (B18-A) stay.

If the player pcall fails **or** `playerName` is not a string, opponent is omitted (fail-closed). Target still trimmed (`^%s+` / `%s+$`). Dest-same and player-same still omit. Missing `UnitName` stays omit. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 676 passed, 0 failed (`lua tests/test_inputs.lua`). **24** isolation pins under the first `if standalone then`; **6** re-pins in `runB14B()`; **6** B15-A re-pins and **6** B16-B re-pins in `runB15A()`; **6** re-pins in `runB17C()`; **6** re-pins in `runB18A()`; **6** re-pins in `runB21D()` (nested in `runB18A()`).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_inputs.lua` | TDD first. Nested `runB21D()` inside `runB18A()` (Lua 5.1 200-local; no new main-chunk locals). Stub `UnitName("target")` → `"Chuckroast"`, `UnitName("player")` throws, dest `"Host"` → `fields.opponent` omitted. Unpadded Chuckroast + successful player still names opponent. Non-string player omits. Dest-same / player-same / missing `UnitName` omit. Quiet / ESC / TitleBar / isolation wrap stay. |
| `addon/ChurchOfBeef/UI/Inputs.lua` | `petitionOpponent` fail-closes when `not pok` or `type(playerName) ~= "string"`. Dest-same still omits first. Player-same still omits after a successful string read. Trim and missing `UnitName` unchanged. |
| `docs/reformation/vestments/briefs/B21-D-inputs-player-report.md` | This file |
| `docs/reformation/vestments/briefs/B21-D-inputs-player.diff` | B21-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Net, Codec, Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not look up a Pope name. Did not call `TargetUnit`. Did not add `PlaySound`. Did not call `Gora:Petition`. Did not invent a realm compare. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Inputs batches (working tree already dirty). The brief diff is the B21-D-only delta.

## Contract

```lua
local function petitionOpponent()
  -- missing UnitName → nil
  -- pcall UnitName("target") and UnitName("player")
  -- trim target ^%s+ / %s+$; empty after trim → nil
  -- Names.Same vs inputTarget → nil
  -- not pok or playerName not a string → nil (fail-closed)
  -- Names.Same vs playerName → nil
  -- else target name
end
```

| Target / player | Fields |
|-----------------|--------|
| `"Chuckroast"` + player throws | `{ characterId }` only |
| `"Chuckroast"` + player `"Beefina"` | `{ characterId, opponent = "Chuckroast" }` |
| `"Chuckroast"` + player `nil` | `{ characterId }` only |
| Dest-same Host (player throw or success) | `{ characterId }` only |
| Player-same Beefina | `{ characterId }` only |
| Missing `UnitName` | `{ characterId }` only |

Keep:

- Whisper dest is still `inputTarget` (injected). No Pope-name lookup.
- WIDTH 328 / HEIGHT 72. TitleBar 12px + persist `ChurchOfBeefDB.ui.inputs`.
- ESC `ClearFocus` only. `SetMultiLine(true)`. Not on `UISpecialFrames`.
- No `TargetUnit`. No `PlaySound`. No `Gora:Petition`.
- Challenge law (B17-C) and trim (B18-A) stay.
- Isolation wrap stays (wow_ui_stub + Common + Runtime + Inputs). No new main-chunk locals.

## TDD

1. Extended `tests/test_inputs.lua` first (`runB21D()` inside `runB18A()`: player-throw omit; unpadded Chuckroast + successful player still names; non-string player omit; dest-same / player-same / missing `UnitName` omit; Quiet / ESC / TitleBar / isolation stay). Isolation wrap untouched.
2. Red: `lua tests/test_inputs.lua` — **673 passed, 3 failed** (player-throw still named Chuckroast; non-string player still named Chuckroast; fail-closed source pin missing).
3. `petitionOpponent` fail-closes on `not pok` or non-string `playerName`. No chrome change.
4. Green: `lua tests/test_inputs.lua` — **676 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_inputs.lua   # 676 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_inputs.lua` standalone | **676 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 24 original isolation asserts stay under `if standalone then`. `runB14B()` / `runB15A()` / `runB17C()` / `runB18A()` / `runB21D()` re-pin Console / Popes / Sender / Sound / Hud / slash.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Net / Codec / Console / glue / TOC were not edited.
- Player pcall fail or non-string `playerName` omits opponent. A throw no longer returns the target name.
- Dest-same and player-same still omit. Missing `UnitName` stays omit. Target still trimmed.
- Unpadded Chuckroast + successful player read still names opponent.
- Whisper dest stays `inputTarget`. No Pope list. No `TargetUnit`. No `Gora:Petition`. No `PlaySound`. No realm compare.
- HEIGHT 72. TitleBar persist. ESC ClearFocus. Not on `UISpecialFrames`. Isolation wrap stays. No new main-chunk locals.

## Leftovers

- **Parked (later Console batch):** Recommend `namedOpponent` paint (`"  names  "`). Desk `after()` double cue.
- **No client smoke.** Live `UnitName("player")` throw / nil on Anniversary after `/reload` is unproven.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **No chrome hint.** The stock Petition button still does not say a current target will be named.
- **Internal whitespace is not collapsed.** Only leading / trailing `^%s+` / `%s+$` (B18-A leftover).
- **No realm compare.** Anniversary `UnitName` also returns `unitServer`; this lane does not fold it. `Names.Same` still folds dest / player spelling when the player read succeeds.

## Status

**DONE_WITH_CONCERNS.** Isolated **676 / 0**. Not signed. No Gate W / Gate V / **POLISH:PASS** / V1 claim.
