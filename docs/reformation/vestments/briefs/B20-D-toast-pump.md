# B20-D — ESC on the small toast advances the queue

**Exclusive:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

**Do not edit** Console, Sound, glue. Do not commit. No `PlaySound` on hide / ESC. Do not `hideTheater` from the small-toast OnHide. `ChurchOfBeefToast` stays on `UISpecialFrames`. Nest pins in `runB12D()`.

## Law

B19-B leftover: ESC Hide clears `showing` and leaves `pending` waiting for the next Push. Small-toast `OnHide` should `bumpGen()` (invalidate the hold timer) then `showing = nil` then `pump(self)` so a queued system toast presents. Re-entry: `pump` of empty pending only Hides again — guard so a Hide-from-pump does not loop (if `showing` is already nil and pending is empty, return).

Do not drain pending to empty on ESC (do not discard the rest of the queue). Advance one.

## Tests

Push two system toasts (or Show twice if the second queues). Hide the frame (ESC). `ShowingKind` is the second envelope (or pending count dropped by one and a toast is shown). Isolation wrap stays.

`lua tests/test_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B20-D-toast-pump-report.md` + diff.
