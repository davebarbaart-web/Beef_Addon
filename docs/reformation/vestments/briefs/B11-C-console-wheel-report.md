# B11-C — Console mouse wheel + Open Gora subjects (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 (glanceable Director Console); Law 10 / §19.3 (Director Console stays stock-pragmatic); Bible §20.2 (Open Rite is a Pope console action); CONTINUE 2026-08-18 (no SUMMON; no post-show clipboard; `SaveNote` stays nil; Console stays plain); brief `docs/reformation/vestments/briefs/B11-C-console-wheel.md`.

Director Console stays stock. After `DeskScroll` is created, `EnableMouseWheel(true)` and `SetScript("OnMouseWheel", …)` are type-guarded. The handler type-guards `GetVerticalScroll` / `SetVerticalScroll` / `GetVerticalScrollRange` and steps **36px**. Missing APIs or non-number returns no-op. No permanent `OnUpdate`. `Console:OpenRite("Gora")` still uses `selectedFighterA/B` when both are ids; otherwise it falls back to `Gora:GetSanctioned()` then `Gora:GetLastSanctioned()` (two ids required). Other rite kinds unchanged. `SaveNote` stays nil. No SUMMON. No parchment. No tabs. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB11C()` inside `runB8E()` (Lua 5.1 200-local cap): `DeskScroll` has `OnMouseWheel`; source contains type-guarded `EnableMouseWheel`; `stub.fire(..., "OnMouseWheel", -1)` does not error; no `OnUpdate`; Pope-predicate wrap — `StartEvent` + `Sanction(a,b)` with no selected fighters → Runtime subjects `{a.id, b.id}`; selected pair wins over `GetLastSanctioned`; last-pair-only fallback; SaveNote nil; no SUMMON / parchment / tabs; isolation wrap re-pin. |
| `addon/ChurchOfBeef/UI/Console.lua` | Type-guarded `EnableMouseWheel(true)` + `OnMouseWheel` (36px, missing APIs no-op) after `DeskScroll` create. `OpenRite("Gora")` falls back to live then last sanctioned pair when the selected pair is incomplete. Knighting / Confession / Proclamation unchanged. `SaveNote` untouched. |
| `docs/reformation/vestments/briefs/B11-C-console-wheel-report.md` | This file |
| `docs/reformation/vestments/briefs/B11-C-console-wheel.diff` | B11-C-only unified diff of the exclusive files vs the pre-lane baseline |

Did not edit Store, Gora, TOC, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

`git diff` vs HEAD on these two files also includes Batches 3–10 (working tree already dirty). The brief diff is the B11-C-only delta, same pattern as B10-D.

## Contract

| Surface | Role |
|---------|------|
| `DeskScroll` wheel | If `type(EnableMouseWheel) == "function"`, `EnableMouseWheel(true)`. If `type(SetScript) == "function"`, `OnMouseWheel`. Handler no-ops unless `GetVerticalScroll` / `SetVerticalScroll` / `GetVerticalScrollRange` are functions and return numbers. Step is `current - delta * 36`, clamped to `[0, range]`. |
| Permanent `OnUpdate` | None on the frame or `DeskScroll`. |
| `OpenRite("Gora")` | Selected `fighterA` + `fighterB` (both ids) win. Else live `GetSanctioned` (two ids). Else `GetLastSanctioned` (two ids). Missing Gora / methods / ids → today's empty subjects. |
| Other rites | Unchanged. Knighting still uses `selectedHumanId`. |
| `SaveNote` | nil |

### Desk

- Console stays stock. No custom media. No parchment.
- No SUMMON. No post-show ceremony summary. No CopyCeremonySummary. No tabs.
- Ritual plates unchanged.

## TDD

1. Extended `test_console.lua` first (`OnMouseWheel`, `EnableMouseWheel` source pin, fire does not error, live-pair fallback, selected wins over last, last-pair-only fallback, SaveNote nil, isolation wrap). Isolation stayed under `if standalone then`. B11-C lives in `runB11C()` nested inside `runB8E()`.
2. Implemented `Console.lua`.
3. Green: `lua tests/test_console.lua` — **1175 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 1175 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | 1175 passed, 0 failed. Lua 5.1.5. Exit 0. |

**Isolated count:** 17 unique nil-module pins inside the opening `if standalone then` (Quiet shell, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Six loaded-module pins stay outside the wrap. B11-C re-pins Archive + Quiet shell + Toasts. Standalone suite: **1175 passed**.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Store / Gora / TOC / glue not edited.
- Wheel APIs are type-guarded. Missing methods and non-number scroll reads no-op. `stub.fire` does not error on the harness noops.
- Selected pair still wins when both ids are set. Live `GetSanctioned` then `GetLastSanctioned` fill Runtime `{ fighters = { a, b } }`.
- `Console.SaveNote` remains nil. Source has no `SUMMON THE FAITHFUL`, no `CopyCeremonySummary`, no parchment, no tabs.
- Isolation asserts remain behind `if standalone then`.
- No new locals in the main chunk. New pins are inside `runB11C()` nested in `runB8E()`.

## Concerns

- Client `/reload` smoke was not run. Wheel feel (36px vs the stock `UIPanelScrollFrameTemplate` thumb) is unproven on Anniversary. **POLISH:CANDIDATE** only.
- Harness `GetVerticalScroll` / `GetVerticalScrollRange` are noops that return nil, so the handler no-ops after the type-guard in this suite. Tests pin wiring and “fire does not error,” not a moved offset.
- A one-sided selected pair (only A or only B) falls through to the Gora pair. That matches “both ids.”
- Last-pair fallback after `VOID` still opens from ASSEMBLY (Runtime is independent of Gora). Catch-up overlay of last pair onto STATE remains B11-A / B11-INT.
- Bible §18.1 still wants to minimize scrolling. Wheel makes the 780/1050 desk reachable; it does not flatten desks.

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
