# B7-INT — Batch 7 integrator

All three B7 reviews are Spec PASS. No new TOC files. Do not reopen exclusive sources unless a listed suite goes red.

You may edit:
- `docs/REFORMATION_LOG.md` — Batch 7 verdicts only. Gates W/V stay OPEN.
- `tests/test_wire_glue.lua` — only if compose is red.
- `addon/ChurchOfBeef/ChurchOfBeef.lua` — do **not** Proclaim Canonize or Flag Upset (Law 4). Archive is Pope-local. No new wraps required.

Verify:

```
lua tests/test_store.lua
lua tests/test_console.lua
lua tests/test_records.lua
lua tests/test_archive.lua
lua tests/run.lua
```

All exit 0. Write `docs/reformation/vestments/briefs/B7-INT-report.md`. No POLISH:PASS. No V1. No commit. Do not invent a Pope name.
