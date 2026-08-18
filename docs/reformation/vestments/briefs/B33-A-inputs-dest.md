# B33-A — SetInputTarget trims the whisper dest

**Exclusive:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

**Do not edit** BeefNet, glue. Do not commit. No Pope-name lookup. Opponent trim stays.

## Law

License 2 / §13.1: favor / petition / confess / catchup whisper to the injected dest. `SetInputTarget` (~218) stores any non-empty string, including `" "`. `Names.Same("Host", " ")` is false, so dest-same omit fails. `Names.Trim` already exists (`Common.lua`).

`SetInputTarget`: `Names.Trim(name)` (fallback `^%s+` / `%s+$`). Empty after trim is nil (no target). `readyToSend` / Petition / Catchup / Confess keep. Opponent trim stays. No auto snapshot. No realm compare invent.

## Tests

Nest after `runB23D()`. `SetInputTarget("  Host  ")` stores `"Host"`. `SetInputTarget("   ")` is no target; Petition / Catchup / Confess return `"no target"` and do not send. Existing opponent / player trim pins stay. Isolation wrap stays.

`lua tests/test_inputs.lua` exit 0.

Report `docs/reformation/vestments/briefs/B33-A-inputs-dest-report.md` + diff.
