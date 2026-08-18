# B15-C — Quiet shell UISpecialFrames dedupe

**Exclusive:** `addon/ChurchOfBeef/UI/MainFrame.lua`, `tests/test_ui.lua`

**Do not edit** Toasts.lua production logic beyond what you must not touch — Toasts is **not** exclusive; do not change it. Do not commit. Quiet shell stays stock `BasicFrameTemplate`. `/beef` still opens Records Book via `UI:Toggle`. No Ladder / Standing / Officer tabs. No `PlaySound` on ESC / show / hide.

## Law

Wiki: named frame on `UISpecialFrames`. `ChurchOfBeefFrame` already `table.insert`s. Copy Decree `rememberSpecial` (scan then append). Do **not** copy wiki `PlaySound(IG_CHARACTER_INFO_*)`.

Lua 5.1 200-local cap: nest new pins inside `runB12D()` or a `do` block after it. Do **not** add main-chunk locals.

## Tests

After `UI:Init()`, `UISpecialFrames` contains `"ChurchOfBeefFrame"` exactly once. Forced second build (or Reset path that rebuilds) still once. Source has `rememberSpecial` and does **not** `table.insert(UISpecialFrames`. No `IG_CHARACTER_INFO`. Existing Init / Proclaim B12-D pins stay. Isolation wrap stays.

`lua tests/test_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B15-C-shell-special-report.md` + diff.
