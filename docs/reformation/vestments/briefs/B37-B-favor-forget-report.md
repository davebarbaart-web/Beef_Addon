# B37-B — Quiet forget also drops leftover congregation favor (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** License 2 / Bible §10.6 favor is per-event. Brief `docs/reformation/vestments/briefs/B37-B-favor-forget.md`. `forgetPersist` (~303–306) niled `lastPair` / `lastPopeFavor` only. Quiet `Refresh` then `paintHidden`. `broadcastFavor` stayed, so a later live pair painted leftover last-event favor until `SetBroadcastFavor(nil)`.

`forgetPersist` also nils `broadcastFavor`. Does **not** nil `favorTarget` (dest persist). Hidden paint stays empty. No `UnitHealth`. No roman numerals. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 854 passed, 0 failed (`lua tests/test_hud.lua`). Isolation wrap stays under `if standalone then` at file load (**13** nil pins). Nested `runB37B()` inside `runB19C()` after `runB35A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_hud.lua` | TDD first. Nested `runB37B()` after `runB35A()` inside `runB19C()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pin: `forgetPersist` body nils `lastPair`, `lastPopeFavor`, and `broadcastFavor`; it does not name `favorTarget`. Behavioral: congregation `SetBroadcastFavor` a 2/1 split paints; Quiet Refresh → `view.favor` nil, names `""`, favor widgets hidden; a later live pair without a new `SetBroadcastFavor` still has no leftover favor (STATE-off widgets stay hidden; Warrior / Mage class color stays). `SetFavorTarget("Host")` before Quiet still sends on a later plate click. Isolation wrap stays. `health` nil. |
| `addon/ChurchOfBeef/UI/Hud.lua` | `forgetPersist` also sets `broadcastFavor = nil`. Does not nil `favorTarget`. Quiet `Refresh` already called `forgetPersist`. Header notes per-event forget / dest persist. No `UnitHealth`. No roman. |
| `docs/reformation/vestments/briefs/B37-B-favor-forget-report.md` | This file |
| `docs/reformation/vestments/briefs/B37-B-favor-forget.diff` | B37-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit glue, Gora, Console, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

`git diff HEAD` on these two files also includes earlier HUD batches (working tree already dirty). The brief diff is the B37-B-only delta.

## Contract

| Surface | Role |
|---------|------|
| `forgetPersist` | Nils `lastPair`, `lastPopeFavor`, and `broadcastFavor`. Does not nil `favorTarget`. |
| Quiet `Refresh` | Still `forgetPersist()` then `paintHidden`. Hidden names `""`; favor widgets hidden. |
| Later live pair | Without a new `SetBroadcastFavor`, `resolveFavor` is nil (STATE-off). |
| `SetFavorTarget` | Dest persist. Survives Quiet forget. |
| Health | `nil`. No `UnitHealth`. |

### Unchanged

- Pope `lastPopeFavor` freeze while the event is live.
- Congregation fill is still `SetBroadcastFavor` only.
- B16-C `pickPair` and B17-D `livePair` Gora-RITE gates.
- B19-C / B21-B / B32-A leftover hide / forget. B34-A post-font tint. B35-A defense width.
- Existing STATE-off / class-color pins.
- Isolation wrap (wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Hud).

## TDD

1. Extended `tests/test_hud.lua` first (`runB37B()` nested in `runB19C()` after `runB35A()`: `forgetPersist` source nils `broadcastFavor` and does not name `favorTarget`; SetBroadcastFavor 2/1 paints; Quiet Refresh → `view.favor` nil and hidden paint empty; later live pair without a new SetBroadcastFavor has no leftover favor; STATE-off / class-color stay; dest persist still sends; isolation wrap; `health` nil).
2. Red: `lua tests/test_hud.lua` — **849 passed, 5 failed** (source missing `broadcastFavor = nil`; later live pair still painted leftover 2/1; FAVOR / bar A / bar B still shown). Quiet hide / dest persist / class-color / isolation stayed green (`paintHidden` already emptied the Quiet view).
3. `forgetPersist` also sets `broadcastFavor = nil`. `favorTarget` left alone. Quiet `Refresh` unchanged.
4. Green: `lua tests/test_hud.lua` — **854 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_hud.lua   # 854 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_hud.lua` standalone | **854 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 854 passed, 0 failed. Isolation wrap stays (13 nil-module pins at file load). Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Glue / Gora / Console / TOC not edited.
- Quiet forget now drops leftover congregation favor. A later live pair does not inherit last-event 2/1.
- `favorTarget` is not niled. Later plate click still uses `"Host"`.
- Hidden paint stays empty (names `""`, favor widgets hidden).
- `runB37B()` is nested inside `runB19C()` after `runB35A()`. No new main-chunk locals.
- Isolation wrap stays. No `UnitHealth`. No roman numerals.

## Leftovers

- **`ResetForTests` still nils `broadcastFavor` before `forgetPersist()`.** Harmless double-nil. Not collapsed this lane.
- **Non-Gora refuse also calls `forgetPersist`.** Knighting leftover lastPair now drops leftover broadcast favor, not only Quiet Refresh. Brief asked for the helper itself.
- **Quiet path is CloseRite then EndEvent.** EndEvent from RITE still refuses (existing Runtime contract). The forget is the QUIET `Refresh`.
- **Dest persist pin uses a local Net stub.** Isolation wrap still asserts `COB.Net` nil at file load; the stub is cleared before the function returns.
- **No client smoke.** Live congregation HUD after End Event then a new Gora (no leftover favor bar; whisper dest still set) is unproven on Anniversary.
- **A01 still NOT RUN.** `health` is nil. No `UnitHealth`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.

## Status

**DONE_WITH_CONCERNS.** Isolated **854 / 0**. Isolation wrap **13**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
