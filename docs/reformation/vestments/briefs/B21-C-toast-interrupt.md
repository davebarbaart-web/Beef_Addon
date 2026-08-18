# B21-C — interrupt Hide does not pump a queued toast

**Exclusive:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

**Do not edit** Console, Sound, glue. Do not commit. No `PlaySound` on hide / ESC / interrupt. Do not `hideTheater` from the small-toast OnHide. `ChurchOfBeefToast` stays on `UISpecialFrames`. Nest pins in `runB12D()`.

## Law

B20-D leftover: `interruptShowing` nils `showing` then `Hide()`. OnHide sees `showing == nil` and `#pending > 0`, skips the idle guard, and pumps the queued row **before** Push inserts the interrupter.

Change the small-toast OnHide idle guard to `if not self.showing then return`. ESC still advances one (ESC Hide happens while `showing` is set). Empty-pump Hide stays idle. `interruptShowing` still discards the interrupted toast and never re-queues it.

Do not add new kind names. Default `KINDS` stay `interrupt = false`. Push may pass `interrupt = true` and a higher `priority` for the pin. Do not drain pending.

Wiki ESC remains `UISpecialFrames` (named frame).

## Tests

Show one system toast, Show a second (queues), Push `{ kind = "system", text = "interrupt", interrupt = true, priority = 99 }`. Showing text is the interrupter; pending still has the queued row (count 1). B20-D ESC-advance-one pins stay. Isolation wrap stays.

`lua tests/test_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B21-C-toast-interrupt-report.md` + diff.
