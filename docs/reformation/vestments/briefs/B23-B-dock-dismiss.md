# B23-B — ESC on the Event dock stays hidden until Show or QUIET

**Exclusive:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

**Do not edit** Console.lua, Hud, glue. Do not commit. Title stays `DIRECTOR CONSOLE`. CloseButton stays hidden. Persist stays. `UISpecialFrames` stays. No `PlaySound` / `IG_CHARACTER_INFO_*`. Hide is not EndEvent.

## Law

B22-D leftover: ESC `Hide()`s the widget. `GetView().shown` stays true; next `Refresh` re-shows because `mayShow` is still true (glue `refreshEventFurniture`).

OnHide (after create-time Hide, same guard as Toasts): if the event is live, remember dismiss; set `lastView.shown = false`. `Refresh`: if not `mayShow`, clear dismiss and paint hidden. If dismiss is set, paint hidden and keep dismiss. `Show()` clears dismiss then paints if `mayShow`. `ResetForTests` clears dismiss.

Wiki ESC is `UISpecialFrames` + named frame. Do **not** PlaySound on hide (Law 6 / hybrid law). No dismiss-cooldown number.

## Tests

StartEvent + Pope: shown. Widget `Hide()`: `IsShown` false, `GetView().shown == false`, Runtime still ASSEMBLY. `Refresh`: still hidden. `Show()`: shown again. EndEvent / Quiet Refresh: hidden and a later StartEvent + Refresh shows. Isolation wrap stays.

`lua tests/test_console_dock.lua` exit 0.

Report `docs/reformation/vestments/briefs/B23-B-dock-dismiss-report.md` + diff.
