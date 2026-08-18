# B18-A — Inputs confess box below TitleBar + trim opponent (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §13.1 / §18.5 (congregation input; inputs never trigger public theater); Law 10 / §19.3 (Inputs stay stock); B16-B leftover (confess box ate the lower 4px of the 12px TitleBar); B17-C leftover (whitespace-only / padded `UnitName` still reached `SendPetition`); brief `docs/reformation/vestments/briefs/B18-A-inputs-gap.md`. No Pope-name lookup. No `PlaySound`. Challenge law (B17-C) stays. WIDTH 328 / HEIGHT 72 stay. TitleBar 12px + persist `ui.inputs` stay. ESC ClearFocus and `SetMultiLine(true)` stay. Not on `UISpecialFrames`.

Confess box moved from `TOP` / `-8` to `TOP` / `-14` (fully below the 12px handle). HEIGHT was not grown. Buttons stay `BOTTOM` + 10. `petitionOpponent` trims the target name (`^%s+` / `%s+$`) before `Names.Same`. After trim, empty omits opponent. `"  Chuckroast  "` becomes `"Chuckroast"`. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 599 passed, 0 failed (`lua tests/test_inputs.lua`). **24** isolation pins under the first `if standalone then`; **6** re-pins in `runB14B()`; **6** B15-A re-pins and **6** B16-B re-pins in `runB15A()`; **6** re-pins in `runB17C()`; **6** re-pins in `runB18A()`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_inputs.lua` | TDD first. Nested `runB18A()`. TitleBar height 12. Confess box TOP offset `-14` (and ≤ -12). HEIGHT 72. Buttons BOTTOM + 10. Existing Chuckroast pin stays. Stub `"   "` omits opponent. Stub `"  Chuckroast  "` sends `opponent = "Chuckroast"`. Padded Host / player omit after trim. Quiet / ESC / persist / isolation wrap stay. |
| `addon/ChurchOfBeef/UI/Inputs.lua` | Confess box `SetPoint("TOP", widget, "TOP", 0, -14)`. `petitionOpponent` trims `^%s+` / `%s+$` before `Names.Same`; empty after trim returns nil. |
| `docs/reformation/vestments/briefs/B18-A-inputs-gap-report.md` | This file |
| `docs/reformation/vestments/briefs/B18-A-inputs-gap.diff` | B18-A-only unified diff of the exclusive implementation files vs the pre-lane baseline |

Did not edit Net, Codec, Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not look up a Pope name. Did not add `PlaySound`. Did not register Inputs on `UISpecialFrames`. Did not commit.

## Contract

| Surface | Role |
|---------|------|
| Confess box | `TOP` / `widget` / `TOP` / `0` / `-14`. Height 22. Fully below the 12px TitleBar. |
| TitleBar | Height 12. Persist `ChurchOfBeefDB.ui.inputs`. Unchanged. |
| Root | WIDTH 328 / HEIGHT 72. Buttons `BOTTOM` + 10. |
| `petitionOpponent` | pcall `UnitName("target")` / `UnitName("player")`. Trim `^%s+` / `%s+$`. Empty after trim → nil. Then `Names.Same` vs dest / player. |

| Target name | Fields |
|-------------|--------|
| Stub `UnitName("target")` nil | `{ characterId }` only |
| `"Chuckroast"` vs dest `"Host"` / player `"Beefina"` | `{ characterId, opponent = "Chuckroast" }` |
| `"   "` | `{ characterId }` only |
| `"  Chuckroast  "` | `{ characterId, opponent = "Chuckroast" }` |
| `"  Host  "` / `"  Beefina  "` after trim | `{ characterId }` only |

Keep:

- Whisper dest is still `inputTarget` (injected). No Pope-name lookup.
- WIDTH 328 / HEIGHT 72. TitleBar drag persist `ChurchOfBeefDB.ui.inputs`.
- ESC `ClearFocus` only. Not on `UISpecialFrames`.
- No `TargetUnit`. No `PlaySound`. No `Gora:Petition`.
- Isolation wrap stays (wow_ui_stub + Common + Runtime + Inputs).

## TDD

1. Extended `tests/test_inputs.lua` first (`runB18A()`: box `-14`; TitleBar 12; HEIGHT 72; `"   "` omit; `"  Chuckroast  "` → `"Chuckroast"`; B17-C / ESC / persist / isolation stay). Isolation wrap untouched.
2. Red: `lua tests/test_inputs.lua` — **590 passed, 9 failed** (box still `-8`; whitespace-only still sent; padded name untrimmed; source `-14` / gsub pins missing; one HEIGHT source pin looked for `HEIGHT = 72` instead of `local WIDTH, HEIGHT = 328, 72`).
3. Moved the box to `-14`. Trim before `Names.Same`. Corrected the HEIGHT source pin to the existing constant line.
4. Green: `lua tests/test_inputs.lua` — **599 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_inputs.lua   # 599 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_inputs.lua` standalone | **599 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 24 original isolation asserts stay under `if standalone then`. `runB14B()` / `runB15A()` / `runB17C()` / `runB18A()` re-pin Console / Popes / Sender / Sound / Hud / slash.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Net / Codec / Console / glue / TOC were not edited.
- Box TOP offset is `-14`. TitleBar height stays 12. HEIGHT stays 72. Buttons stay BOTTOM + 10.
- Trim runs before `Names.Same`. Whitespace-only omits. Padded Chuckroast sends `"Chuckroast"`.
- B17-C challenge law stays: dest Host and local player Beefina never become `opponent`.
- Whisper dest stays `inputTarget`. No Pope list. No `TargetUnit`. No `Gora:Petition`. No `PlaySound`.
- ESC ClearFocus. Not on `UISpecialFrames`. Isolation wrap stays.

## Leftovers

- **No client smoke.** Live TitleBar grab vs confess-box hit rect after `/reload` is unproven. Harness `GetPoint` is a stub.
- **No chrome hint.** The stock Petition button still does not say a current target will be named. Functional surface; no copy was added.
- **Internal whitespace is not collapsed.** Only leading / trailing `^%s+` / `%s+$`. `"Chuck roast"` would still send as-is.

## Status

**DONE_WITH_CONCERNS.** Not signed. No Gate / **POLISH:PASS** claim.
