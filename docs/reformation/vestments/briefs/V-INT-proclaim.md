# V-INT — Proclaim glue (after V-B)

**You may edit:**
- `addon/ChurchOfBeef/ChurchOfBeef.lua` only (extend `InstallWire`)
- `tests/test_wire_glue.lua` (add Proclaim spies)
- `docs/REFORMATION_LOG.md` (verdict only)

**Do not edit** Toasts.lua, Gora.lua, Console.lua, Store. Do not commit.

## Glue

After successful (non-nil) returns, bootstrap wraps call `Toasts:Proclaim` when that function exists:

| Verb | Kind | Fields |
|------|------|--------|
| `Gora:Sanction` | `sanction` | fighter names from Store `GetCharacter`; optional `stipulation` from the result if present |
| `Gora:DeclareVictor` | `verdict` | `ruling = "victor"`, winner name |
| `Gora:Void` | `verdict` | `ruling = "void"` |
| `Gora:FreeRuling` | `verdict` | `ruling = "free"`, `text` from the result |
| `Gora:CowardiceRecorded` | `cowardice` | fleer name |

Skip while `COB._inspecting`. Missing Toasts/Proclaim → no-op (do not throw). Do not `SendChatMessage`. Do not invent names if Store has no character — omit that name field.

Console `after()` may still `Sound:Play` the same cue Proclaim plays. Accept the double cue; do not edit Console or Sound.

## Tests

Stub Pope + Toasts.Proclaim. Sanction a pair → Proclaim called with `sanction` and both names. Cowardice → clerical kind. InspectProgress does not Proclaim.

`lua tests/test_wire_glue.lua` and `lua tests/run.lua` exit 0.

Report `docs/reformation/vestments/briefs/V-INT-proclaim-report.md`. Do not claim Gate V or POLISH:PASS.
