# B32-C — Latest confession line clears called

**Exclusive:** `addon/ChurchOfBeef/Core/Confession.lua`, `tests/test_confession.lua`

**Do not edit** Console, Net, glue. Do not commit. No fan-out. No Toasts. No Sound. Empty / whitespace still no-text.

## Law

Header: “Latest line replaces.” Bible §9: software organizes the queue; it does not write the Pope’s response. `Receive` (~79) overwrites `text` / `eventId` and leaves `called`. After Call Forward, a new line still paints mute `"  called"`.

When replacing an existing inbox row, set `called = false` (and keep seq so order does not jump). New rows stay `called = false`. `CallForward` still sets `called = true`. `Dismiss` still removes the row. No theater.

## Tests

Receive, CallForward, Receive same id: `called == false`, text is the new line, seq/order unchanged. Empty / whitespace still refused. Isolation wrap stays.

`lua tests/test_confession.lua` exit 0.

Report `docs/reformation/vestments/briefs/B32-C-called-reset-report.md` + diff.
