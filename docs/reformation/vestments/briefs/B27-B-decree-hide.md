# B27-B — Decree Hide blanks leftover paint when the line is gone

**Exclusive:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

**Do not edit** Toasts, Records, glue. Do not commit. No deputy (#5). No custom media. No sound. Quiet Mode stays silent. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`.

## Law

B26 leftover: wipe is on empty `Show` only. `Decree:Clear()` then `DecreeBanner:Hide()` still leaves Goldshire on the hidden (or still-shown) FontStrings.

`Hide()`: if `getDecree()` is nil and a frame exists, `wipePaint` then Hide. If a Decree is still active, just Hide (next Show paints). Do not invent a line. Do not Show. B26-C empty Show wipe stays. Anniversary `FontString:SetText` accepts `""`.

## Tests

Set a Decree, Show, `COB.Decree:Clear()`, `Hide()` (not Show): `IsShown` false; `LineText` / `FlavorText` are `""`. Hide while a Decree is still set does not require a wipe pin (Show still paints). B26-C uniqueness / empty-Show wipe stay. Isolation wrap stays.

`lua tests/test_decree_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B27-B-decree-hide-report.md` + diff.
