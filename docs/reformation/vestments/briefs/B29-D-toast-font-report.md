# B29-D — Proclaim re-applies Morpheus on the headline (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §19.3 / license 4 stock only; Law 10 (theatrical Proclaim headlines). B22 leftover pattern (`applyHeadlineFont` only in `InitTheater` build). Brief `docs/reformation/vestments/briefs/B29-D-toast-font.md`. When `Proclaim` paints a shown beat, it calls `applyHeadlineFont` on `theater.headline` after `headline:SetText`. Hidden / refused Proclaim does not re-apply. `HEADLINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Fallback `GameFontNormalLarge` stays. No `MORPHEUS_CYR`. No new cue names. No `PlaySound`. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 558 passed, 0 failed (`lua tests/test_ui.lua`). Isolation wrap stays under `if standalone then` at file load (**11** nil pins). **4** re-pins in `runB12D()`. Nested B29-D source pins inside `runB12D()` after B27-C. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Nested in `runB12D()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pin extracts the `Proclaim` body and requires `applyHeadlineFont` inside it, not only after `InitTheater`. `InitTheater` still contains `applyHeadlineFont`. `HEADLINE_FONT` / no `MORPHEUS_CYR` / `GameFontNormalLarge` / no `PlaySound` pins stay. Existing clerical copy / ESC / B26-B OnHide / B27-C shell pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Toasts.lua` | Shown-beat `Proclaim` calls `applyHeadlineFont(theater.headline)` after `headline:SetText`. `InitTheater` still applies on mint. `HEADLINE_FONT` / fallback / `applyHeadlineFont` body unchanged. No `MORPHEUS_CYR`. No new cue names. No `PlaySound`. |
| `docs/reformation/vestments/briefs/B29-D-toast-font-report.md` | This file |
| `docs/reformation/vestments/briefs/B29-D-toast-font.diff` | B29-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit MainFrame, Decree, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not invent cue names. Did not add `PlaySound`. Did not commit.

`git diff HEAD` on these two files also includes earlier toast / Quiet-shell batches (working tree already dirty). The brief diff is the B29-D-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Toasts:Proclaim` | On a shown beat, re-apply `applyHeadlineFont` to `theater.headline` after `SetText`. |
| Hidden / refused Proclaim | Unchanged. Quiet / missing Runtime / invalid kind / empty copy return before paint. Do not re-apply. |
| `InitTheater` | Still calls `applyHeadlineFont` on mint. |
| `applyHeadlineFont` | Unchanged body. `pcall` `SetFont(HEADLINE_FONT, 18)`; fallback `SetFontObject(GameFontNormalLarge)`. |
| `HEADLINE_FONT` | Still `Fonts\\MORPHEUS.ttf`. No `MORPHEUS_CYR`. |
| Sound | Cue remains `Sound:Play(kind)` from Proclaim only. No `PlaySound`. No new kind names. |

### Unchanged

- Clerical copy builders (sanction / verdict / cowardice / knighting / elevation).
- B12-D Proclaim ESC / `UISpecialFrames` uniqueness.
- B15-C Quiet-shell `rememberSpecial`.
- B18-C HideAll / `theaterGen`.
- B19-B / B20-D / B21-C small-toast ESC / pump / interrupt.
- B23-C / B26-B Init early-return `rememberSpecial` + missing OnHide restore.
- B24-C / B27-C Quiet-shell early-return `rememberSpecial` + missing OnHide restore.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_ui.lua` first (`runB12D()` after B27-C: extract `Proclaim` body and require `applyHeadlineFont` inside it; `InitTheater` still applies; Morpheus path / no `MORPHEUS_CYR` / `GameFontNormalLarge` / no `PlaySound` stay). Isolation wrap untouched. No new main-chunk locals.
2. Red: `lua tests/test_ui.lua` — **557 passed, 1 failed** (`Proclaim re-applies headline font on a shown beat`). `InitTheater` apply pin, `HEADLINE_FONT` / fallback / no-`PlaySound` pins, and clerical / ESC / B26-B / B27-C pins stayed green.
3. `Proclaim` calls `applyHeadlineFont(theater.headline)` after `headline:SetText`. `InitTheater` call kept.
4. Green: `lua tests/test_ui.lua` — **558 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 558 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **558 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 558 passed, 0 failed. Isolation wrap stays (11 nil pins at file load). `runB12D()` re-pins Console / Hud / Records Book / Gora. Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. MainFrame / Decree / glue / TOC not edited.
- `applyHeadlineFont` runs from `Proclaim` when a beat is shown, and still from `InitTheater` on mint.
- Hidden / refused Proclaim does not re-apply.
- `HEADLINE_FONT` is `Fonts\\MORPHEUS.ttf`. No `MORPHEUS.TTF`. No `MORPHEUS_CYR`.
- Fallback `GameFontNormalLarge` stays. Body stays `GameFontNormal`. System toast stays `GameFont*`.
- No new cue names. No `PlaySound`.
- Isolation asserts stay under `if standalone then`. New source pins are nested in `runB12D()` (no new main-chunk locals).

## Leftovers

- **No client smoke.** Anniversary `SetFont("Fonts\\MORPHEUS.ttf")` after a later Proclaim / font reset is not walked in-game this lane.
- **Harness `SetFont` is a no-op.** `wow_ui_stub` ignores `SetFont` / `GetFont`. Headlines keep the `GameFontNormalLarge` template in the suite. Soft `GetFont` is not pinned. Real client re-apply is unproven.
- **Success-bool fallback.** `applyHeadlineFont` requires a truthy `SetFont` return. On the harness it always falls through to `SetFontObject(GameFontNormalLarge)`.
- Full `lua tests/run.lua` was not run.

## Status

**DONE_WITH_CONCERNS.** Isolated **558 / 0**. Isolation wrap **11**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
