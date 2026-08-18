# V-A — Decree parchment dress (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** CONTINUE 2026-08-18 license 4; Bible §14.1, §19.1, §19.3; Law 6; Batch 2 §B; brief `docs/reformation/vestments/briefs/V-A-decree.md`.

Quiet Mode parchment now uses stock Blizzard textures and fonts only. The decree **line** is the visual headline. Church name is small by the seal. `HEADER` stays `Banner.HEADER` / `GetView().header` / tooltip copy and is no longer the largest line. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_decree_ui.lua` | TDD first. Quest-tracker scale, LineText as `GameFontNormalHuge`, HeaderText small clerical, Church name by the seal, gold rule, source greps (no `✠`, no `Media\\`, no faction crests, stock QuestBG, aged fill). Isolation stays under `if standalone then`. |
| `addon/ChurchOfBeef/UI/Decree.lua` | Dropped required `Media\\decree-*` / `DecreeTitle.ttf`. Stock `QuestBG` + `UI-Quickslot2` via `pcall` `SetTexture`; fill fallback `0.62, 0.52, 0.34`. Frame `320×148`. Line headline, church name by seal, gold rule. |
| `docs/reformation/vestments/briefs/V-A-decree-report.md` | This file |
| `docs/reformation/vestments/briefs/V-A-decree.diff` | `git diff -- addon/ChurchOfBeef/UI/Decree.lua tests/test_decree_ui.lua` |

Did not edit Console, Toasts, Records, HUD, Core, TOC, bootstrap, Minimap, OPEN_QUESTIONS, REFORMATION_LOG, `Data/Popes.lua`, or `tests/run.lua`. Did not add `Media/` files. Did not invent a Pope name.

## Contract

### Hierarchy

| Surface | Role |
|---------|------|
| `LineText` | Visual headline. `GameFontNormalHuge`; `pcall` `SetFont` `Fonts\\MORPHEUS.TTF` then GameFont fallback. Paints `Get().line`. |
| `FlavorText` | Optional under the gold rule. Hidden when omitted. |
| `ChurchName` | `Church of Beef`, `GameFontHighlightSmall`, anchored to the seal. |
| `HeaderText` | Small clerical (`GameFontNormalSmall`). Still the fixed `A GATHERING HAS BEEN DECREED` copy for `Banner.HEADER` / `GetView().header`. Not the largest line. |

No cross glyphs. No Horde/Alliance/PVP crests. Quiet: no `PlaySound`.

### Scale / dress

- `320×148` (quest-tracker band: 300–340 × 130–160). Upper-center default. Movable, clamped.
- Iron field + gold `WHITE8X8` edge + gold rule under the line.
- Parchment: `Interface\\QuestFrame\\QuestBG` via `pcall` `SetTexture`. On failure, `fill()` `0.62, 0.52, 0.34`.
- Seal: `Interface\\Buttons\\UI-Quickslot2` tinted gold. Fill fallback if `SetTexture` throws.

Kept: no empty parchment; Core Get/Set only; GetView copy; no slash; no calendar/RSVP; Init silent without a Decree.

## TDD

1. Baseline: `lua tests/test_decree_ui.lua` — **218 passed, 0 failed**.
2. Extended the suite first (scale, headline template, church-by-seal, Media/cross/crest greps, aged fill). Isolation unchanged.
3. Red: **224 passed, 14 failed** — Media paths still present; width 520; LineText `GameFontNormalLarge`; HeaderText still Huge; no `ChurchName` / `GoldRule`.
4. Implemented `Decree.lua`.
5. Green: `lua tests/test_decree_ui.lua` — **241 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_decree_ui.lua   # 241 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_decree_ui.lua` standalone | 241 passed, 0 failed. Lua 5.1. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive files only. Quiet still silent. Header copy unchanged for GetView / tooltip.
- `applyFont` still requires a truthy `SetFont` return before keeping a custom face, then GameFont fallback.
- Church name is the institution string, not a Pope character.
- No `Media\\` paths remain in `UI/Decree.lua`.

## Concerns

- **No client smoke.** 148px with `GameFontNormalHuge` plus optional flavor plus the seal row is tight; a long place/time line may wrap or clip. Not smoked after `/reload`.
- **`SetTexture` rarely errors.** The aged fill runs only when `pcall` fails. A silent missing texture will not fall through to `fill()`.
- **`QuestBG` is a full quest-log sheet** stretched into a tracker-sized rect. It may look cropped. `StationeryTest1` was the brief's other option; not tried in-game.
- **`UI-Quickslot2` is a bag-slot ring**, not a wax bull. Licensed stock stand-in only. Custom seal media is a later wave.

## Status

**DONE_WITH_CONCERNS.** **POLISH:CANDIDATE.** Not signed.
