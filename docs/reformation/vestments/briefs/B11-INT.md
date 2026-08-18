# B11-INT — Batch 11 integrator

**Owns:** `ChurchOfBeef.lua` `stateFields`, `tests/test_wire_glue.lua`, ledger, install.

Runtime:Restore refuses `subjects.fighters` in ASSEMBLY / QUIET. Overlay live / last pair onto STATE only when `state` is **RITE** or **CONSEQUENCE**. Last pair may overlay in those states after a ruling. Never overlay on ASSEMBLY (including post-Continue) or QUIET.

Favor still toggle-gated. Two fighters required by Codec. Live → `GetFavorSplit`; last → `GetLastFavorSplit`.

ASSEMBLY + Sanction without OpenRite: STATE has no fighters and no favor (Restore-safe). B11-C Open Gora copies the pair into Runtime before RITE.

Do not claim Gate W / Gate V / POLISH:PASS / V1. Do not tick walk boxes. Do not commit.
