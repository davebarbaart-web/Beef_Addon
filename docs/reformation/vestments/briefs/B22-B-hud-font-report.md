# B22-B — HUD fighter names use FrameXML Morpheus casing (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §19.3 / license 4 stock only; Law 10 (theatrical names). Brief `docs/reformation/vestments/briefs/B22-B-hud-font.md`. Decree / Toasts / Records / FighterCard already use `Fonts\\MORPHEUS.ttf`. B16-C / B17-D / B19-C / B21-B gates stay. Favor W-F intact. Dress stays stock. A01 still NOT RUN.

Theatrical HUD names still mint as `GameFontHighlight`. `NAME_FONT` is `Fonts\\MORPHEUS.ttf`. `applyNameFont` `pcall` `SetFont` size 14 on `nameA` / `nameB` only; fallback `SetFontObject(GameFontHighlight)` when `SetFont` fails. Titles, records, defenses, vs, and favor stay GameFont. No `MORPHEUS_CYR`. `health` stays nil. Exclusive files only. No commit. Lane is not signed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_hud.lua` | TDD first. Nested source pins (no new main-chunk locals): `Fonts\\MORPHEUS.ttf`; refuse `MORPHEUS.TTF` and `MORPHEUS_CYR`; `SetFontObject` fallback; custom-font grep strips the stock path. Existing persist / lastPair / `1-0` / health-nil / Gora-RITE pins stay. Isolation wrap stays. Name templates stay `GameFontHighlight`; titles / records / vs / favor stay GameFont. |
| `addon/ChurchOfBeef/UI/Hud.lua` | `NAME_FONT = "Fonts\\MORPHEUS.ttf"`. `applyNameFont` `pcall` `SetFont` size 14; fallback `GameFontHighlight`. Applied only to `nameA` / `nameB`. `health` nil. No `UnitHealth`. No `UnitIsDead`. |
| `docs/reformation/vestments/briefs/B22-B-hud-font-report.md` | This file |
| `docs/reformation/vestments/briefs/B22-B-hud-font.diff` | B22-B-only unified diff of the exclusive files vs the pre-lane working tree |

Did not edit Gora, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

`git diff` vs HEAD on these two files also includes earlier HUD batches (working tree already dirty). The brief diff is the B22-B-only delta.

## Contract

```lua
local NAME_FONT = "Fonts\\MORPHEUS.ttf"
-- applyNameFont: pcall SetFont(NAME_FONT, 14), else SetFontObject(GameFontHighlight)
```

| Surface | Role |
|---------|------|
| `nameA` / `nameB` | Created as `GameFontHighlight`. Try FrameXML `Fonts\\MORPHEUS.ttf` size 14. Fallback `SetFontObject(GameFontHighlight)` if `SetFont` fails. |
| Titles / records / defenses / vs / favor | `GameFont*` unchanged. |
| Head-to-head | Still arabic `1-0`. |
| Health | `nil`. No `UnitHealth`. No `UnitIsDead`. |
| GlueFonts | No `MORPHEUS_CYR`. |
| Dress | Stock iron/parchment. No custom Media. |

Keep:

- B16-C `pickPair` Gora-RITE gate
- B17-D `livePair` Gora-RITE gate
- B19-C lastPair refuse on non-Gora RITE
- B21-B lastPair refuse on non-Gora CONSEQUENCE
- Favor W-F (Pope live/frozen; congregation broadcast only)
- Isolation wrap (wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Hud)

## TDD

1. Extended `tests/test_hud.lua` first (nested source pins for `Fonts\\MORPHEUS.ttf`; refuse `MORPHEUS.TTF` and `MORPHEUS_CYR`; `SetFontObject` stays; custom-font grep strips the stock path; name templates stay GameFontHighlight). Isolation wrap untouched. No new main-chunk locals.
2. Red: `lua tests/test_hud.lua` — **739 passed, 2 failed** (source missing `Fonts\\MORPHEUS.ttf` and `SetFontObject`).
3. `NAME_FONT` plus `applyNameFont` on `nameA` / `nameB` only. Size 14. Flags omitted. Fallback `GameFontHighlight`.
4. Green: `lua tests/test_hud.lua` — **741 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_hud.lua   # 741 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_hud.lua` standalone | **741 passed, 0 failed.** Lua 5.1.5. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Isolated count

**741 passed, 0 failed.**

Isolation wrap (unchanged, still under `if standalone then`): **13** nil-module pins — Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console.

## Self-review

- Exclusive implementation files only. Gora, glue, TOC not edited.
- `NAME_FONT` is `Fonts\\MORPHEUS.ttf`. No `MORPHEUS.TTF`. No `MORPHEUS_CYR`.
- `applyNameFont` runs only on `nameA` / `nameB`. Titles / records / defenses / vs / favor stay GameFont.
- B16-C / B17-D / B19-C / B21-B gates unchanged. No lastPair clicks.
- Favor W-F paint unchanged. Dress stays stock.
- Source has no `UnitHealth`, `UnitIsDead`, `COMBAT_LOG`, `NamePlate`, `PlaySound`, `Toasts`, `Media\\`, `.tga`, or `.blp`. Custom-font grep allows only the stock Morpheus path.
- `countStatusBars` stays 2. `health` stays nil. `healthReads` stay 0.
- Isolation asserts stay under `if standalone then`. New source pins are nested in a `do` block (no new main-chunk locals).

## Leftovers

- **No client smoke.** Anniversary `SetFont("Fonts\\MORPHEUS.ttf")` at height 14 is not walked in-game this lane.
- **Harness `SetFont` is a no-op.** `wow_ui_stub` ignores `SetFont` / `GetFont`. Names keep the `GameFontHighlight` template in the suite. Soft `GetFont` is not pinned. Real client path is unproven.
- **Success-bool fallback.** `applyNameFont` requires a truthy `SetFont` return. On the harness it always falls through to `SetFontObject(GameFontHighlight)`. A missing file on 20506 also stays GameFontHighlight — intended, but unsmoked.
- **A01 still NOT RUN.** `health` is nil. Mute rails stay textures. No `UnitHealth`. No `UnitIsDead`.
- Full `lua tests/run.lua` was not run.

## Status

**DONE_WITH_CONCERNS.** Isolated **741 / 0**. Isolation wrap **13**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
