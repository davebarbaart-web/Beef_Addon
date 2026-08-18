# B14-D — Console UISpecialFrames dedupe

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Store, Gora, glue. Do not commit. Console stays **stock**. `SaveNote` stays nil. No SUMMON. No `PlaySound` on show / hide / ESC. Do not Hide the desk from EditBox ESC (B13-D ClearFocus stays).

## Law

Wiki: *Make frames closable with the Escape key* — named frame on `UISpecialFrames`. The desk already `table.insert(UISpecialFrames, FRAME_NAME)` (`ChurchOfBeefConsoleFrame`). `Init` is idempotent for the widget but a second `build()` (or a naive re-insert) would duplicate the name. Copy Decree's `rememberSpecial` (scan then append). Do **not** copy the wiki's `PlaySound(IG_CHARACTER_INFO_OPEN/CLOSE)` — Quiet/Event sound law: no panel whoosh.

Do not register child scroll frames. Do not register toast names. Lua 5.1 200-local cap: nest new pins inside `runB8E()` / a new nested function (`runB14D`), same as B13-D.

## Tests

Nested `runB14D()` inside `runB8E()`. After `Console:Init()`: `UISpecialFrames` contains `"ChurchOfBeefConsoleFrame"` exactly once. Call `remember` path again (second Init, or a second source-level insert simulation via Init after ResetForTests+Init): still once. Source contains a dedupe loop (or `rememberSpecial`) and `ChurchOfBeefConsoleFrame`. Source does **not** contain `IG_CHARACTER_INFO`, `PlaySound` on show/hide of the desk, `SaveNote` function, SUMMON, parchment, tabs. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B14-D-console-special-report.md` + diff.
