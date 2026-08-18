# B37-D — Quiet Hide blanks leftover confess text

**Exclusive:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

**Do not edit** BeefNet, Confession, glue. Do not commit. Dest persist stays. No Pope lookup.

## Law

Bible §13.4 / §9 leftover player-typed text. Anniversary `EditBox:SetText(text)`. `paintHidden` (~80–83) only `frame:Hide()`. `Confess` still reads `confessBox:GetText()`. Only `ResetForTests` blanks the box. Quiet Hide then a new Event `Show` + `Confess()` would send leftover text.

`paintHidden` blanks `confessBox` (`SetText("")` if present). Dest / `inputTarget` persist. Width / ESC ClearFocus stay. No fan-out.

## Tests

Nest `runB37D()` after `runB35B()` inside `runB21D()`. Type leftover text, Quiet Hide (or `paintHidden` via Hide), box `GetText()` is `""`. New Event Show + `Confess()` without a new arg does not send the leftover line (omits text or empty). Dest stays. Isolation wrap stays. No new main-chunk locals.

`lua tests/test_inputs.lua` exit 0.

Report `docs/reformation/vestments/briefs/B37-D-confess-wipe-report.md` + diff.
