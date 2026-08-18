# B12-D — Proclaim ESC dismiss

**Exclusive:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

**Do not edit** FighterCard, Sound, glue. Do not commit. Stock only. No new sound names. Clerical copy only.

## Law

The theatrical root is already named `ChurchOfBeefProclaim`. Register it on `UISpecialFrames` (dedupe). ESC Hide()s that root. Hook `OnHide` so `hideTheater` (or equivalent gen bump) runs — a leftover Hide must not leave the next Proclaim stuck.

Do **not** put `ChurchOfBeefToast` (the small system/debug stack) on `UISpecialFrames`. Quiet Mode still does not drive this file. No close ✕ chrome.

Wiki: "Make frames closable with the Escape key". Type-guard a missing table.

## Tests

After a Proclaim (or Init if the root exists then), `UISpecialFrames` contains `ChurchOfBeefProclaim` once. Source contains `UISpecialFrames` and does not register `ChurchOfBeefToast`. Existing clerical copy / Morpheus / no-SendChatMessage pins stay. Isolation wrap stays.

`lua tests/test_ui.lua` exit 0. POLISH:CANDIDATE.

Report `docs/reformation/vestments/briefs/B12-D-toast-esc-report.md` + diff.
