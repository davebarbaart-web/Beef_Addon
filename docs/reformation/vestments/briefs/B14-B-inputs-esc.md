# B14-B — Inputs confess box ESC ClearFocus

**Exclusive:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

**Do not edit** Net, Console, glue. Do not commit. Inputs stay **stock** Event chrome. No Pope-name lookup. No SUMMON. No `PlaySound`. Do **not** register Inputs on `UISpecialFrames` (hide is Runtime Quiet, not ESC dismiss of Event chrome).

## Law

Focused EditBoxes swallow ESC (wiki: *Make frames closable with the Escape key* — `OnEscapePressed`). Type-guard `SetScript("OnEscapePressed", …)` on the confess box that `ClearFocus`es only. Do **not** Hide the Inputs panel from the box.

Anniversary `SimpleEditBoxAPI`: `ClearFocus()` and `SetMultiLine([multiline])` exist on classic_anniversary / 20506. Type-guard `SetMultiLine(true)` after creating the box. Keep current WIDTH/HEIGHT (72) and box height (22) so existing geometry pins stay. Missing methods fail-closed (skip), no throw.

Do not look up a Pope name. Whisper target stays injected via `SetInputTarget`. Quiet hide unchanged.

## Tests

After Init in Event: `editBox()` has `OnEscapePressed`. `stub.fire(box, "OnEscapePressed")` does not error, `HasFocus()` is false, `Inputs:GetView().shown` stays true / frame stays shown. Source contains `OnEscapePressed`, `ClearFocus`, and `SetMultiLine`. Source does not contain `UISpecialFrames`, Pope lookup, `SUMMON`, `PlaySound`, custom `.tga/.blp/.ttf`. Isolation wrap stays.

`lua tests/test_inputs.lua` exit 0.

Report `docs/reformation/vestments/briefs/B14-B-inputs-esc-report.md` + diff.
