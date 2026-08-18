# B28-INT — Batch 28 integrator

If B28-B Spec PASS: wrap Core `Decree:Clear` so it always calls `DecreeBanner:Refresh` (Clear returns nil, so `wrapAfter` will not fire — use an always-after wrap). Pin in `tests/test_wire_glue.lua`. Exclusive sources unopened after review otherwise.

Do not claim Gate W / Gate V / POLISH:PASS / V1. Do not tick walk boxes. Do not commit.
