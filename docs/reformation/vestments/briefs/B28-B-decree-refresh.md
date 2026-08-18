# B28-B — Decree Refresh hides leftover paint when the line is gone

**Exclusive:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

**Do not edit** Toasts, Records, glue. Do not commit. No deputy (#5). No custom media. No sound. Quiet Mode stays silent. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. No Clear Decree chrome.

## Law

B27 leftover: Core `Decree:Clear()` leaves a **visible** banner until Hide or empty Show.

Add `DecreeBanner:Refresh()`:
- `ensureFrame` if needed.
- If `getDecree()` is nil: `wipePaint` then Hide, return false.
- If a Decree exists and the banner is already shown: `paint`, stay shown, return true.
- Do **not** Show a hidden banner (Quiet hidden-until-Set / minimap replay). Empty `Show()` / `Hide()` wipe stay.

## Tests

Set, Show, `COB.Decree:Clear()`, `Refresh()` (not Hide/Show): `IsShown` false; Line/Flavor `""`. Hidden + Set + Refresh does **not** Show. B27-B Hide wipe / B26-C empty Show stay. Isolation wrap stays.

`lua tests/test_decree_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B28-B-decree-refresh-report.md` + diff.
