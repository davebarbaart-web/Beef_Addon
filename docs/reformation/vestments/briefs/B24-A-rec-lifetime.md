# B24-A — Recommendation clears when the event ends or a new one starts

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Gora, glue. Do not commit. `SaveNote` stays nil. Do not change `"  names  "` paint. Nest new pins in `runB8E()` — Lua 5.1 200-local cap. Do not add main-chunk locals.

## Law

B22-A leftover: `lastRecommendation` is only cleared in `ResetForTests`. After `EndEvent` / a later `StartEvent`, the desk still paints the last suggestion (including `"  names  "`).

On **successful** `StartEvent` and `EndEvent` (`result ~= nil`), set `lastRecommendation = nil` **before** `after()` so Refresh paints empty. Failed Start (already live) / failed End keep the table. `Continue` does not clear. `Recommend` still stores the flag. `SaveNote` stays nil. No “DEMANDED”.

## Tests

Named Recommend paints `"  names  "`. `EndEvent` then Refresh: Recommendation text is `""` (no names). Later `StartEvent`: still empty. A new Recommend paints again. Failed `StartEvent` while live does not clear. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B24-A-rec-lifetime-report.md` + diff.
