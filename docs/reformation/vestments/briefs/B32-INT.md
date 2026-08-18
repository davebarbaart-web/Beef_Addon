# B32-INT — Batch 32 integrator

`afterRuntime` and `afterEndEvent` call `Hud:Refresh` (skip `_inspecting` / `skipSend`). Does not send extra STATE. Exclusive UI sources unopened after review except this glue + `tests/test_wire_glue.lua`.

Do not claim Gate W / Gate V / POLISH:PASS / V1. Do not tick walk boxes. Do not commit.
