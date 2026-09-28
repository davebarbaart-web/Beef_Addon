## Task 9: Latest-wins without dropping favor

**Files:** `Core/Runtime.lua`; `Net/BeefNet.lua` or glue; `tests/test_ceremony_chaos.lua`

**Depends on:** Task 7 (skew drop). May share BeefNet with Task 7 — do not start until Task 7 is done if Task 7 still owns BeefNet.

### Pins

- Ceremony fields apply only if `sequence` is **greater**.
- Favor overlay applies when `eventId` matches and `sequence >= current`.
- Different `eventId` still applies.
- Equal sequence must not fire theater (theater inbound is off this slice anyway).
- Invert the chaos rewind pin. Snapshot apply uses the same rule.

`lua tests/run.lua` must exit 0. No commit. No #27 Proclaim.
