# B26-C — Empty Decree Show blanks leftover line paint

**Exclusive:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

**Do not edit** Toasts, Records, glue. Do not commit. No deputy (#5). No custom media. No sound. Quiet Mode stays silent. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`.

## Law

B25-B leftover: empty `Show()` `ensureFrame`s then Hide, but leftover `LineText` / `FlavorText` still hold the last Goldshire line on the hidden widget.

Empty `Show()`: `ensureFrame()`, blank `LineText` and `FlavorText` (`SetText("")`; hide flavor), then Hide, return false. Do not Show the banner. Do not invent a line. B25-B ESC remount stays.

## Tests

Set a Decree, Show, Clear, empty Show: `IsShown` false; `LineText` / `FlavorText` are `""`. B25-B wipe + Show-only uniqueness stays. Isolation wrap stays.

`lua tests/test_decree_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B26-C-decree-wipe-report.md` + diff.
