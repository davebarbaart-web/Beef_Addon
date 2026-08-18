# B34-A — HUD re-tints names after applyNameFont (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §19.3 / Law 10 (class color on fighter names). Brief `docs/reformation/vestments/briefs/B34-A-hud-tint.md`. `paintFighter` tints `nameA` / `nameB` (`tint` → `SetTextColor` + `_cobColor`). `paintShown` then calls `applyNameFont`. Live Anniversary `SetFontObject(GameFontHighlight)` applies the font object's white color and wipes class tint. Harness `SetFont` / `SetFontObject` are often no-ops, so `_cobColor` can look fine while the client is white. After `applyNameFont(frame.nameA)` / `nameB` in `paintShown`, restore tint from `fighterA.nameColor or INK` and `fighterB.nameColor or INK` via the existing `tint` helper. `NAME_FONT` / `GameFontHighlight` fallback stay. `build()` mint apply stays before fighters exist — no invented mint tint. Hidden paint stays empty. `health` stays nil. No `UnitHealth`. No roman numerals. No defense `SetWidth`. Exclusive files only. No commit. Lane is not signed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_hud.lua` | TDD first. Nested `runB34A()` after `runB32A()` inside `runB19C()` (no new main-chunk locals). Source pin: `paintShown` body still calls `applyNameFont` then `tint` (or `SetTextColor`) on `nameA` / `nameB`. Wrap `nameA` / `nameB` `SetFontObject` and `SetFont` to wipe `_cobColor` / `SetTextColor(1,1,1)`, then `OpenRite` Gora + `Refresh`; `_cobColor` and view `nameColor` return to Warrior / Mage. Existing class-color pins (~441–459) stay. Isolation wrap stays. `health` nil. |
| `addon/ChurchOfBeef/UI/Hud.lua` | `paintShown` calls `tint(frame.nameA, fighterA.nameColor or INK)` and `tint(frame.nameB, fighterB.nameColor or INK)` after `applyNameFont`. `applyNameFont` body unchanged (`NAME_FONT` then `GameFontHighlight`). `build()` mint apply unchanged. `paintHidden` unchanged. `health` nil. No `UnitHealth`. |
| `docs/reformation/vestments/briefs/B34-A-hud-tint-report.md` | This file |
| `docs/reformation/vestments/briefs/B34-A-hud-tint.diff` | B34-A-only unified diff of the exclusive files vs the pre-lane working tree |

Did not edit FighterCard, Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

`git diff` vs HEAD on these two files also includes earlier HUD batches (working tree already dirty). The brief diff is the B34-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `paintFighter` | Still tints names (`nameColor or INK`) before font apply. |
| `paintShown` | Re-applies `applyNameFont` on `nameA` / `nameB`, then restores `tint(..., nameColor or INK)`. |
| `applyNameFont` | Unchanged. `pcall` `SetFont(NAME_FONT, 14)`; fallback `SetFontObject(GameFontHighlight)`. |
| `build()` | Still applies name font on mint only. No mint tint. |
| `paintHidden` | Unchanged. Names stay empty. |
| Health | `nil`. No `UnitHealth`. |

### Unchanged

- Existing class-color pins (~441–459): names Warrior / Mage; level / title / record not class-colored; mute rails fighter-tinted.
- B16-C `pickPair` and B17-D `livePair` Gora-RITE gates.
- B19-C / B21-B / B32-A leftover hide / forget.
- Favor W-F. Stock iron/parchment dress. Defense integers stay arabic mute.
- Isolation wrap (wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Hud).

## TDD

1. Extended `test_hud.lua` first (source pin `applyNameFont` then `tint` / `SetTextColor` on `nameA` / `nameB` inside `paintShown`; nested `runB34A()` after `runB32A()` inside `runB19C()`: wrap font apply to wipe, live Gora `Refresh`, Warrior / Mage `_cobColor` + view `nameColor`; isolation wrap; `health` nil; existing class-color pins kept).
2. Red: `lua tests/test_hud.lua` — **774 passed, 5 failed** (source pin missing post-font `tint`; wrap wipe left `_cobColor` nil).
3. `paintShown` restores `tint(frame.nameA, fighterA.nameColor or INK)` and `tint(frame.nameB, fighterB.nameColor or INK)` after `applyNameFont`. `build()` / `paintHidden` / `applyNameFont` body unchanged.
4. Green: `lua tests/test_hud.lua` — **779 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_hud.lua   # 779 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_hud.lua` standalone | **779 passed, 0 failed.** Lua 5.1.5. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Isolated count

**779 passed, 0 failed.**

Isolation wrap (unchanged, still under `if standalone then`): **13** nil-module pins — Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console.

## Self-review

- Exclusive implementation files only. FighterCard, Console, glue, TOC not edited.
- `paintShown` still calls `applyNameFont` then `tint` on `nameA` / `nameB`.
- `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. `GameFontHighlight` fallback stays. No `MORPHEUS_CYR`.
- `build()` mint apply stays before fighters exist. No invented mint tint.
- Hidden paint stays empty. B19-C / B21-B / B32-A leftover hide stays.
- Existing class-color pins (~441–459) stay.
- Source has no `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `PlaySound`, `Toasts`, `Media\\`, `.tga`, or `.blp`.
- No roman numerals. No defense `SetWidth`.
- Favor W-F paint unchanged. Dress stays stock. Defense integers stay arabic mute.
- Isolation asserts stay under `if standalone then`. New pins are nested in `runB34A()` after `runB32A()` inside `runB19C()`.

## Leftovers

- **No client smoke.** Live Anniversary `SetFontObject(GameFontHighlight)` wiping class tint, then the post-font `tint` restore, was not walked in-game this lane. The harness wrap simulates the wipe.
- **Harness `SetFont` / `SetFontObject` stay no-ops** unless wrapped. Soft `GetTextColor` after a real font-object apply is not pinned.
- **Unknown-class `INK` fallback after font apply is not a separate runtime pin.** Source uses `nameColor or INK`; the wrap Refresh uses Warrior / Mage.
- **Font wraps stay on the B19-C `hud` instance.** Later V-D height-budget `dofile` + `Init` is idempotent and does not `paintShown`; wraps do not touch those pins.
- **A01 still NOT RUN.** `health` is nil. Mute rails stay textures. No `UnitHealth`.
- Full `lua tests/run.lua` was not run.

## Status

**DONE_WITH_CONCERNS.** Isolated **779 / 0**. Isolation wrap **13**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
