# B35-A — HUD defense labels SetWidth(28) (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.7 mute integer. Anniversary `SetWidth(width)` (SimpleScriptRegionResizingAPI). Brief `docs/reformation/vestments/briefs/B35-A-defense-width.md`. `defenseA` / `defenseB` were unbounded FontStrings (`makeLabel`) anchored LEFT of `recordA` / RIGHT of `recordB`. Two-digit W/L plus a two-digit count can grow into VS / seal.

Cap only those two labels at **28**. Mint in `build()` after the labels exist; `paintDefense` re-asserts `SetWidth(28)`. Existing LEFT/RIGHT anchors stay. MUTED tint, `tostring(n)` paint, Hide-when-zero stay. HUD width stays 420. No `SetWidth` on names / records / VS. No roman numerals. No `UnitHealth`. Exclusive files only. No commit. Lane is not signed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_hud.lua` | TDD first. Nested `runB35A()` after `runB34A()` inside `runB19C()` (no new main-chunk locals). Source pin: `defenseA:SetWidth(28)` / `defenseB:SetWidth(28)`; names / records / VS have no `SetWidth`. After Init, `GetWidth() == 28` on both defense labels. After a nonzero `CountDefenses` paint (existing 3 plus a two-digit 12 stub), `GetWidth() == 28` still. LEFT/RIGHT anchors, MUTED, `tostring`, HUD 420, name/record/VS widths untouched. Isolation wrap stays. `health` nil. |
| `addon/ChurchOfBeef/UI/Hud.lua` | `build()` calls `defenseA:SetWidth(28)` / `defenseB:SetWidth(28)` after the existing LEFT/RIGHT anchors. `paintDefense` re-asserts `fs:SetWidth(28)` before MUTED / `tostring` / Hide-when-zero. Names / records / VS not sized. `WIDTH` stays 420. No `UnitHealth`. No roman. |
| `docs/reformation/vestments/briefs/B35-A-defense-width-report.md` | This file |
| `docs/reformation/vestments/briefs/B35-A-defense-width.diff` | B35-A-only unified diff of the exclusive files vs the pre-lane working tree |

Did not edit FighterCard, Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

`git diff` vs HEAD on these two files also includes earlier HUD batches (working tree already dirty). The brief diff is the B35-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `build()` | After `defenseA` / `defenseB` exist and keep LEFT/RIGHT anchors, `SetWidth(28)` on those two only. Then Hide. |
| `paintDefense` | Re-asserts `SetWidth(28)`. MUTED tint, `tostring(n)`, Show when `n > 0`, Hide-when-zero stay. |
| Names / records / VS | No `SetWidth`. |
| HUD frame | `WIDTH` stays 420. |
| Health | `nil`. No `UnitHealth`. |

### Unchanged

- LEFT of `recordA` / RIGHT of `recordB` anchors and 8px gap.
- MUTED tint. Arabic `tostring(n)`. Hide when zero or missing `CountDefenses`.
- Existing CountDefenses 3 pin (~618–637).
- B16-C `pickPair` and B17-D `livePair` Gora-RITE gates.
- B19-C / B21-B / B32-A leftover hide / forget. B34-A post-font tint.
- Favor W-F. Stock iron/parchment dress.
- Isolation wrap (wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Hud).

## TDD

1. Extended `test_hud.lua` first (source pin `SetWidth(28)` on `defenseA` / `defenseB`; nested `runB35A()` after `runB34A()` inside `runB19C()`: Init `GetWidth() == 28`; nonzero 3 / 12 paint still 28; names / records / VS untouched; anchors / MUTED / HUD 420; isolation wrap; `health` nil).
2. `build()` mints `SetWidth(28)` on the two defense labels. `paintDefense` re-asserts the same cap.
3. Green: `lua tests/test_hud.lua` — **814 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_hud.lua   # 814 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_hud.lua` standalone | **814 passed, 0 failed.** Lua 5.1.5. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Isolated count

**814 passed, 0 failed.**

Isolation wrap (unchanged, still under `if standalone then`): **13** nil-module pins — Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console.

## Self-review

- Exclusive implementation files only. FighterCard, Console, glue, TOC not edited.
- Only `defenseA` / `defenseB` call `SetWidth(28)`. Names / records / VS do not.
- Existing LEFT/RIGHT anchors stay. MUTED, `tostring(n)`, Hide-when-zero stay.
- HUD `WIDTH` stays 420.
- Source has no `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `PlaySound`, `Toasts`, `Media\\`, `.tga`, or `.blp`.
- No roman numerals. Two-digit stub paints `"12"`, not a numeral glyph.
- Favor W-F paint unchanged. Dress stays stock.
- Isolation asserts stay under `if standalone then`. New pins are nested in `runB35A()` after `runB34A()` inside `runB19C()`.

## Leftovers

- **No client smoke.** Live Anniversary `SetWidth(28)` clipping a two-digit defense next to two-digit W/L vs VS / seal was not walked in-game this lane. The harness `GetWidth` is the stub `_width` field, not live FontString layout.
- **`paintDefense` also re-caps.** Mint in `build()` is enough for Init; the paint path repeats `SetWidth(28)` so a later paint cannot drop the cap. Soft: hide-path also re-caps.
- **Two-digit 12 is the nested stub.** The existing main-chunk CountDefenses 3 pin (~618) is unchanged and does not assert width.
- **A01 still NOT RUN.** `health` is nil. Mute rails stay textures. No `UnitHealth`.
- Full `lua tests/run.lua` was not run.

## Status

**DONE_WITH_CONCERNS.** Isolated **814 / 0**. Isolation wrap **13**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
