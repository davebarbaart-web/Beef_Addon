# Phase 1 Lane M — Gora / Ceremony stub containment

**Status:** DONE

**Cited:** Ten Laws 4, 5, 8; Bible §10, §20; Audit V4, V5; Gate 1 §3b; brief `docs/reformation/phase-1/briefs/P1-M-stubs.md`.

No sanctioned-Gora rebuild (Phase 4). No §20 ceremony-runtime rebuild (Phase 3). No petitions, sanction, HUD, or theater invented. TOC / bootstrap / `tests/run.lua` not edited. No commit. `OPEN_QUESTIONS.md` unchanged.

## Caller grep (before the cut)

Live `addon/` only. Docs and archive ignored.

| Symbol | UI | Slash | Net | Other live Lua | Tests |
|--------|----|-------|-----|----------------|-------|
| `Gora:RecordResult` | none | none | none | definition only (`Core/Gora.lua`) | none (`test_gora_ceremony.lua` never called it) |
| `Ceremony:Start` / `Close` / `Cancel` / `IsActive` / `GetActive` | none | none | none | definition only (`Core/Ceremony.lua`) | none |
| `COB.Ceremony` / `COB.Gora` as a callee | none | none | none | each module assigns itself | Gora pair-key suite only |

`/beef` is minimap-toggle or `UI:Toggle`. Bootstrap (`ChurchOfBeef.lua`) never names Gora or Ceremony. Toasts' `Celebrate` comment is UI-owned copy, not a Core call.

Gate 1 §3b: inert leftovers may remain only with zero callers; if severing is trivial, prefer sever. Both stubs had zero callers. Both were severed.

## Files changed

| Action | Path |
|--------|------|
| Edited | `addon/ChurchOfBeef/Core/Gora.lua` — `RecordResult` removed. Pair-key notes kept. |
| Deleted | `addon/ChurchOfBeef/Core/Ceremony.lua` — unused session flags; file gone. |
| Unchanged | `tests/test_gora_ceremony.lua` — pair-key only; still loads `Gora.lua` only. |
| Written | `docs/reformation/phase-1/reports/P1-M-stubs.md` (this file) |

## What remains (Audit salvage)

`Gora.lua` is pair-key challenge notes only:

- `Challenge` / `Cancel` / `IsChallenged` / `GetPending` / `_Prune` / `ResetForTests`
- One note per pair (direction, case, and realm fold)
- TTL + pending cap so trash talk cannot grow without bound

No typed winner/loser path. No points, Grant, Ladder, pay-cooldown, or `goraLordWin`. Sanctioned Gora is Phase 4.

Ceremony session flags are gone with the file. That is not a §20 runtime and must not be rebuilt here.

## Verification

Isolated pair-key suite (Common + `tests/test_gora_ceremony.lua`): **17 passed, 0 failed**.

```text
Isolated pair-key: 17 passed, 0 failed
```

Post-cut grep on live `addon/`: no `function Gora:RecordResult`, no `function Ceremony:`, no UI/Net/slash callers into either stub. The only remaining `RecordResult` token in `addon/` is the excision comment in `Gora.lua`.

`lua tests/run.lua` was not repaired. Runner / TOC leftovers belong to the integrator.

## Integrator: TOC leftover

**Do not treat this as a product file.** `ChurchOfBeef.toc` still lists `Core\Ceremony.lua` after the delete. This lane was forbidden to edit the TOC. Client load will fail on that line until the integrator drops it.

`Core\Gora.lua` stays on the TOC. Pair-key notes still load.

## Concerns

1. **TOC still lists deleted `Core\Ceremony.lua`.** Integrator-owned. Same class of leftover as Lane C / Lane F missing files.
2. **Pair-key notes have no UI/Net/slash callers either.** Kept because the brief names them as Audit salvage and requires the isolated suite. They are not a Gora, not a petition pool, and not sanction. Phase 4 must not grow them into typed results.
3. **Challenge TTL (1800) and `PENDING_MAX` (20) are pre-existing demo numbers.** Not invented here. Not a petition freshness window. Do not treat them as Bible defaults.
4. **In-game `/reload` smoke was not run.** TOC is already unloadable from this delete plus parallel Phase 1 cuts. Owner: David (Gate 1 §3e).
