# B5-E — Congregation snapshot catch-up control

**Exclusive:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

**Do not edit** TOC, run.lua, BeefNet, ChurchOfBeef.lua. Do not commit. Do not invent a Pope name.

## Law

Bible §20.3. `Net:RequestSnapshot(target)` is already live. Congregation needs an Event-mode control that uses the **injected** whisper target (same as Petition).

```lua
Inputs:Catchup()
```

- Event only. Quiet → false.
- Missing target → `false, "no target"`.
- Calls `Net:RequestSnapshot(inputTarget)` only. Do not look up Popes.lua.
- Stock button label `Catch up`.
- No Sound, no Proclaim, no Gora.

## Tests

Stub `Net.RequestSnapshot`. Quiet refuse. StartEvent + target → Catchup spies the target. Isolation wrap stays.

`lua tests/test_inputs.lua` exit 0.

Report `docs/reformation/vestments/briefs/B5-E-catchup-report.md` + diff.
