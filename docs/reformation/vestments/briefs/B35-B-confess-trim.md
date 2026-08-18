# B35-B — Confess trims optional text

**Exclusive:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

**Do not edit** BeefNet, Confession, Codec, glue. Do not commit. No Pope-name lookup. Dest trim stays.

## Law

Bible §13.4 / §9: confession text is optional player-typed free text for the Pope console. `SetInputTarget` already `Names.Trim`s dest (B33-A). `Confess` (~302–318) assigns `fields.text` raw, so `"  forgive me  "` goes on the whisper.

Trim text (`Names.Trim`, fallback `^%s+` / `%s+$`). Empty after trim **omits** `fields.text` and still sends (text is optional — do not refuse). Dest / `readyToSend` stay. Opponent trim stays. No auto snapshot. No fan-out.

## Tests

Nest `runB35B()` after `runB33A()` inside `runB21D()`. `Confess("  forgive me  ")` sends `text = "forgive me"`. `Confess("   ")` / box-only whitespace omits `fields.text` and still sends when dest is set. Existing dest / opponent pins stay. Isolation wrap stays. No new main-chunk locals.

`lua tests/test_inputs.lua` exit 0.

Report `docs/reformation/vestments/briefs/B35-B-confess-trim-report.md` + diff.
