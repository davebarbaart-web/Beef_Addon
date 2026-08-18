# B14-INT — STATE Knighting candidate overlay

**Exclusive (integrator only):** `addon/ChurchOfBeef/ChurchOfBeef.lua`, `tests/test_wire_glue.lua`

Writers must not edit these files.

## Law

Mirror B14-A onto outbound STATE in `stateFields()`:

- When Runtime subjects lack a numeric `candidate`, overlay `Knighting:GetLine()[1].humanId`.
- Carry on `ASSEMBLY`, and on `RITE` only when `riteType == "Knighting"`.
- Do **not** overlay onto Gora / other rites, CONSEQUENCE, or QUIET.
- Do **not** replace an existing numeric Runtime candidate.
- Preserve fighters when writing the candidate (existing live/last pair overlay stays).
- Do **not** add a new `sendState()` trigger on `Enqueue`. Overlay rides existing SendState calls (Start/Open/Close/Continue/End, Sanction, rulings, favor toggle).
- Last pair still stays off post-Continue ASSEMBLY.

`pcall` `GetLine`. Missing Knighting → today's STATE.

## Tests

Append after `runB10()`. Isolation wrap of `test_wire_glue.lua` stays (FighterCard / Inputs / ConsoleDock / Markers remain spies). Pin:

1. `StartEvent` + `Knighting:Enqueue(human)` + `Console:SetCongregationFavorVisible(true)` (forces SendState) → last STATE `subjects.candidate` is that human. Runtime snapshot candidate still nil (overlay is encode-only).
2. Then `OpenRite("Gora", { fighters = {a,b} })` → Gora RITE STATE has **no** candidate overlay.
3. `OpenRite("Knighting", { candidate = id })` → STATE keeps that candidate.
4. Existing B12 live-pair ASSEMBLY overlay and post-Continue empty last-pair pins still pass.

Full harness `lua tests/run.lua` exit 0. Do not tick walk boxes. Do not claim Gate W / Gate V / POLISH:PASS.
