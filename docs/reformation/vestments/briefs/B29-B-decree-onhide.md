# B29-B — Decree OnHide blanks leftover paint when the line is gone

**Exclusive:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

**Do not edit** Toasts, Records, glue. Do not commit. No deputy (#5). No custom media. No sound. Quiet Mode stays silent. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. No Clear Decree chrome.

## Law

B28 leftover: widget `frame:Hide()` (ESC via `UISpecialFrames`) bypasses `DecreeBanner:Hide` and leaves Goldshire after Core Clear.

Wire OnHide on the banner: if `getDecree()` is nil, `wipePaint`. Do **not** replace an existing OnHide. Extract `wireDecreeOnHide(frame)` if that keeps SetScript out of Hide/Refresh. `Refresh` / empty `Show` / `Hide()` wipe stay. Do not Show from OnHide.

Anniversary FontString `SetText` accepts `""`.

## Tests

Set, Show, `COB.Decree:Clear()`, widget `frame:Hide()` (not `DecreeBanner:Hide` / Refresh): `IsShown` false; Line/Flavor `""`. Existing Refresh / Hide wipe / empty Show stay. Isolation wrap stays.

`lua tests/test_decree_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B29-B-decree-onhide-report.md` + diff.
