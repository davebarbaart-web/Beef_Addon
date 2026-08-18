# B11-B — HUD leftover plate clicks

**Exclusive:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

**Do not edit** Gora, FighterCard, glue, Snapshot. Do not commit. No `UnitHealth`. Favor W-F paint intact. Display persist (B9-E / B10-B lastPair) stays.

## Law

`clickPlate` today uses `livePair()`, which is `GetSanctioned` **or** Runtime subjects **or** (via `displayPair`) lastPair. After a ruling the HUD must stay painted (§10.7) but **favor picks close**. `RecordFavor` already refuses without a live pair; the plate must not send.

```lua
-- displayPair / lastPair / Refresh paint: unchanged
-- clickPlate pick pair:
--   Pope (IsRegisteredPope local) → Gora:GetSanctioned() only
--   congregation → Runtime subjects.fighters only (two ids)
--   never lastPair
```

`PickFavor` itself stays a send helper (existing missing-target pins stay). The gate is the plate `OnClick`.

## Tests

Keep the existing Sanctioned plate-click sends (isolated suite has a live `GetSanctioned`, so they still send even if Sender is nil).

Add:

1. `DeclareVictor` → HUD still shown (persist) → plate `OnClick` does **not** `SendFavor`.
2. B10-B path: OpenRite Gora subjects, no Sanction, congregation Sender nil → plate sends (Runtime pair).
3. Same path after `CloseRite` (CONSEQUENCE; subjects may still be present) → plate does **not** send. Display may still show.
4. After `Continue` (empty Runtime, lastPair persist) → plate does **not** send. HUD still shown.
5. Health nil. Isolation wrap stays.

`lua tests/test_hud.lua` exit 0. POLISH:CANDIDATE.

Report `docs/reformation/vestments/briefs/B11-B-hud-picks-report.md` + diff.
