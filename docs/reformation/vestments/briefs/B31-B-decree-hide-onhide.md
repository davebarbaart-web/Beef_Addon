# B31-B — Decree Hide remounts a missing OnHide

**Exclusive:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

**Do not edit** Toasts, Records, glue. Do not commit. No deputy (#5). No custom media. No sound. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. No Clear Decree chrome.

## Law

B30 leftover: `DecreeBanner:Hide` skips a niled OnHide. ESC last-wipe would drop until ensureFrame.

When the frame exists, `Hide` calls `wireDecreeOnHide(self.frame)` before wipe/Hide. Do **not** replace an existing script. ensureFrame remount stays. Do not Show from OnHide.

## Tests

Nest after `runB30A()`. Nil the OnHide, Hide: script restored. Third Hide with the script already set: identity stays. Existing widget-Hide-after-Clear wipe / Refresh / empty Show / ensureFrame remount stay. Isolation wrap stays.

`lua tests/test_decree_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B31-B-decree-hide-onhide-report.md` + diff.
