# B30-A — Decree ensureFrame remounts a missing OnHide

**Exclusive:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

**Do not edit** Toasts, Records, glue. Do not commit. No deputy (#5). No custom media. No sound. Quiet Mode stays silent. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. No Clear Decree chrome.

## Law

B29 leftover: `ensureFrame` early-return only `rememberSpecial`s. A remount that dropped OnHide stays idle until rebuild.

When the banner frame already exists, `ensureFrame` calls `wireDecreeOnHide(frame)` after `rememberSpecial`. Do **not** replace an existing script. Create-path / `buildFrame` stay. Do not Show from OnHide. Hide / Refresh / empty Show wipe stay.

## Tests

Nest `runB30A()` after `runB29B()`. Nil the OnHide, call `ensureFrame` via Show/Refresh/Init (frame already exists): script restored. Third call with the script already set: identity stays. Existing widget-Hide-after-Clear wipe / Refresh / Hide wipe / empty Show stay. Isolation wrap stays.

`lua tests/test_decree_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B30-A-decree-remount-report.md` + diff.
