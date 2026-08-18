# B25-D — HUD re-applies Morpheus on Refresh (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §19.3 / license 4 stock only; Law 10 (theatrical names). B22-B leftover (`applyNameFont` only in `build()`). Brief `docs/reformation/vestments/briefs/B25-D-hud-font-refresh.md`. When `Refresh` paints a shown pair, `paintShown` calls `applyNameFont` on `nameA` / `nameB` before `frame:Show()`. Hidden Refresh does not re-apply. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. Fallback `GameFontHighlight` stays. No `MORPHEUS_CYR`. `health` stays nil. No `UnitHealth`. B16-C / B17-D / B19-C / B21-B gates stay. Favor W-F intact. Dress stays stock. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 747 passed, 0 failed (`lua tests/test_hud.lua`). Isolation wrap stays under `if standalone then` at file load (**13** nil pins). B25-D source pins nested in the existing B22-B `do` block. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_hud.lua` | TDD first. Nested in the existing B22-B `do` block (Lua 5.1 200-local cap; no new main-chunk locals). Source pin extracts the `paintShown` body and requires `applyNameFont` inside it, not only after `build()`. `build()` still contains `applyNameFont`. Existing persist / lastPair / `1-0` / health-nil / Morpheus path pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Hud.lua` | `applyNameFont` moved above `paintShown` so the local is in scope. `paintShown` calls `applyNameFont(frame.nameA)` and `applyNameFont(frame.nameB)` before `frame:Show()`. `build()` still applies on mint. `NAME_FONT` / fallback / `health = nil` unchanged. No `UnitHealth`. |
| `docs/reformation/vestments/briefs/B25-D-hud-font-refresh-report.md` | This file |
| `docs/reformation/vestments/briefs/B25-D-hud-font-refresh.diff` | B25-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Gora, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not invent UnitHealth / live health. Did not commit.

`git diff HEAD` on these two files also includes earlier HUD batches (working tree already dirty). The brief diff is the B25-D-only delta.

## Contract

| Surface | Role |
|---------|------|
| `paintShown` | On a shown pair, re-apply `applyNameFont` to `nameA` / `nameB` before `Show()`. |
| `paintHidden` / hidden Refresh | Unchanged. Does not re-apply. |
| `build()` | Still calls `applyNameFont` on mint (`nameA` / `nameB` only). |
| `applyNameFont` | Unchanged body. `pcall` `SetFont(NAME_FONT, 14)`; fallback `SetFontObject(GameFontHighlight)`. Moved above `paintShown` so the call is the local, not a global. |
| `NAME_FONT` | Still `Fonts\\MORPHEUS.ttf`. No `MORPHEUS_CYR`. |
| Health | `nil`. No `UnitHealth`. |

### Unchanged

- B16-C `pickPair` Gora-RITE gate
- B17-D `livePair` Gora-RITE gate
- B19-C lastPair refuse on non-Gora RITE
- B21-B lastPair refuse on non-Gora CONSEQUENCE
- Favor W-F (Pope live/frozen; congregation broadcast only)
- Persist / lastPair / `1-0` head-to-head / health-nil pins
- Stock iron/parchment dress. No custom Media.
- Isolation wrap (wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Hud)

## TDD

1. Extended `tests/test_hud.lua` first (B22-B `do` block: extract `paintShown` body and require `applyNameFont` inside it; `build()` still applies; Morpheus path / no `MORPHEUS_CYR` / `SetFontObject` fallback stay). Isolation wrap untouched. No new main-chunk locals.
2. Red: `lua tests/test_hud.lua` — **746 passed, 1 failed** (`paintShown re-applies name font on a shown pair`). `paintShown` / `build` existence pins and the `build()` apply pin stayed green.
3. Moved `applyNameFont` above `paintShown`. `paintShown` calls it on `nameA` / `nameB` before `frame:Show()`. `build()` calls kept.
4. Green: `lua tests/test_hud.lua` — **747 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_hud.lua   # 747 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_hud.lua` standalone | **747 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 747 passed, 0 failed. Isolation wrap stays (13 nil pins at file load). Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Gora / glue / TOC not edited.
- `applyNameFont` runs from `paintShown` when a pair is shown, and still from `build()` on mint.
- Hidden Refresh does not re-apply.
- `NAME_FONT` is `Fonts\\MORPHEUS.ttf`. No `MORPHEUS.TTF`. No `MORPHEUS_CYR`.
- B16-C / B17-D / B19-C / B21-B gates unchanged. No lastPair clicks.
- Favor W-F paint unchanged. Dress stays stock.
- Source has no `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `PlaySound`, `Toasts`, `Media\\`, `.tga`, or `.blp`.
- Isolation asserts stay under `if standalone then`. New source pins are nested in the existing `do` block (no new main-chunk locals).

## Leftovers

- **No client smoke.** Anniversary `SetFont("Fonts\\MORPHEUS.ttf")` after a later Refresh / font reset is not walked in-game this lane.
- **Harness `SetFont` is a no-op.** `wow_ui_stub` ignores `SetFont` / `GetFont`. Names keep the `GameFontHighlight` template in the suite. Soft `GetFont` is not pinned. Real client re-apply is unproven.
- **Success-bool fallback.** `applyNameFont` requires a truthy `SetFont` return. On the harness it always falls through to `SetFontObject(GameFontHighlight)`.
- **A01 still NOT RUN.** `health` is nil. Mute rails stay textures. No `UnitHealth`.
- Full `lua tests/run.lua` was not run.

## Status

**DONE_WITH_CONCERNS.** Isolated **747 / 0**. Isolation wrap **13**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
