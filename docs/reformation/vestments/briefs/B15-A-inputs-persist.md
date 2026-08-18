# B15-A — Inputs drag persist

**Exclusive:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

**Do not edit** Net, Console, glue. Do not commit. Inputs stay **stock** Event chrome. No Pope-name lookup. No SUMMON. No `PlaySound`. Do **not** register Inputs on `UISpecialFrames`. Keep WIDTH 328 HEIGHT 72. B14-B `OnEscapePressed` ClearFocus and `SetMultiLine(true)` stay.

## Law

Congregation Event chrome should remember where the player put it, like the HUD and Director dock. Copy the HUD `savePoint` / `restorePoint` pattern (`UI/Hud.lua`): whitelist `ANCHORS`, write flat `{ point, relativePoint, x, y }` to `ChurchOfBeefDB.ui.inputs`, never store a frame reference. `SetMovable(true)`, `RegisterForDrag("LeftButton")` on the **root** widget, save on `OnDragStop` after `StopMovingOrSizing`. Restore in `build()` before the default `SetPoint`. Invalid / missing saved point falls back to today's default: `BOTTOM`, `UIParent`, `0`, `80`.

Missing `ChurchOfBeefDB` → restore default; save no-ops. `ResetForTests` must not wipe SavedVariables. Quiet hide unchanged. ESC still ClearFocus only.

Anniversary: `StartMoving` / `StopMovingOrSizing` / `GetPoint` already used by HUD. No `OnUpdate`. No `BackdropTemplate` requirement.

## Tests

Mirror `tests/test_hud.lua` drag-persist, firing **root** `OnDragStop`. Pin:

1. After move, `ChurchOfBeefDB.ui.inputs` has point/x/y and **no** `relativeTo`.
2. `dofile` Inputs.lua + `Init` restores the saved point parented to `UIParent`.
3. Invalid saved point (`MIDDLE-OF-NOWHERE`) falls back to `BOTTOM` / x `0` / y `80`.
4. Quiet Init with a saved point still **hides**.
5. Still not on `UISpecialFrames`. ESC ClearFocus still does not Hide. Source still has `SetMultiLine` / `OnEscapePressed`. No custom media / Pope lookup.

`lua tests/test_inputs.lua` exit 0.

Report `docs/reformation/vestments/briefs/B15-A-inputs-persist-report.md` + diff.
