# B13-B — Fighter card OnHide lastView

**Exclusive:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

**Do not edit** Hud, Toasts, glue. Do not commit. No close ✕. No `PlaySound`. No `UnitHealth`. lastPair still until QUIET.

## Law

ESC Hide()s the named widget (B12-C). That does not call `FighterCard:Hide()`, so `lastView.shown` can stay true. Hook `OnHide` to set `lastView` to the hidden view **without** forgetting lastPair. `paintHidden` / `Hide()` must not recurse forever (if OnHide runs Hide again, guard).

## Tests

Show a live card. `stub.fire(frame, "OnHide")` or `frame:Hide()` → `GetView().shown == false`. Refresh while the event is live still paints the remembered pair. QUIET still forgets. Isolation wrap stays.

`lua tests/test_fighter_card.lua` exit 0. POLISH:CANDIDATE.

Report `docs/reformation/vestments/briefs/B13-B-card-onhide-report.md` + diff.
