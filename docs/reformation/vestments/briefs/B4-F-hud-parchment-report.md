# B4-F — HUD parchment name fields (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.7, §19.3; Batch 3 HUD-B polish (thin parchment behind name/title); brief `docs/reformation/vestments/briefs/B4-F-hud-parchment.md`; stock note `docs/reformation/vestments/briefs/V-stock-textures.md`. CONTINUE 2026-08-18 license 4 (stock only). A01 still NOT RUN.

Event Mode Fight HUD: thin parchment name fields `nameFieldA` / `nameFieldB` behind name+title. Stock QuestBG via the existing `applyParchment` helper. No extra row. No faction crest. No new StatusBars. `health` stays nil. Favor contract unchanged. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_hud.lua` | TDD first. Pin `nameFieldA` / `nameFieldB` exist, Texture not StatusBar, QuestBG or the existing parchment fill fallback, BORDER/BACKGROUND (behind OVERLAY text). Source names both fields. Rebuild still has both. Isolation stays under `if standalone then`. `countStatusBars` stays 2. `healthReads` stay 0. Favor pins unchanged. |
| `addon/ChurchOfBeef/UI/Hud.lua` | Two BORDER QuestBG textures sized to the name+title block (name top → title bottom, rail width). Same `applyParchment`. Mute rails stay textures. EmptySlot-White center stays. W-F favor / PickFavor / SetFavorTarget / SetLocalCharacterId / `health` nil unchanged. |
| `docs/reformation/vestments/briefs/B4-F-hud-parchment-report.md` | This file |
| `docs/reformation/vestments/briefs/B4-F-hud-parchment.diff` | B4-F-only unified diff vs the V-D baseline of the exclusive files |

Did not edit FighterCard, Console, Toasts, Gora, BeefNet, TOC, bootstrap, `run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

## Contract

### Dress

- Thin parchment field behind name+title only. No extra row. Level/record stay below the field.
- `nameFieldA` / `nameFieldB` are `CreateTexture` on `BORDER` (under OVERLAY name/title). QuestBG via `applyParchment`; fill fallback `0.78, 0.70, 0.52, 0.94`.
- Sized to the name+title block: top of `name*`, bottom of `title*`, outer edge of the mute rail.
- Mute rails stay textures. Center stays `UI-EmptySlot-White`. No faction crest.
- Exactly two StatusBars (favor halves). No third favor widget.

### W-F favor (unchanged)

| Client | Fill |
|--------|------|
| Hidden / no live pair | `favor == nil`, `health == nil` |
| Local Pope | `Gora:GetFavorSplit()` while a pair is live, including zeros |
| Congregation | last `SetBroadcastFavor({ a, b })` only |

`PickFavor` / plate click / GetView copy stay as W-F left them. No `UnitHealth`.

## TDD

1. Extended `test_hud.lua` first (nameField existence, Texture type, QuestBG or fill fallback, draw layer, source names, rebuild pins). Isolation unchanged. Favor / PickFavor / health / `countStatusBars == 2` / `healthReads == 0` kept.
2. Red: `source names nameFieldA` expected true; `name field A sits behind name+title` expected true; suite then aborted indexing `frame.nameFieldA`.
3. Implemented `Hud.lua`.
4. Green: `lua tests/test_hud.lua` — **370 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_hud.lua   # 370 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_hud.lua` standalone | 370 passed, 0 failed. Lua 5.1. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Quiet still hides. Health pins and nameplate-scrape greps stay.
- Source has no `UnitHealth`, `PvPFrame`, `UI-PVP-Horde`, `UI-PVP-Alliance`, `Media\\`, `.tga`, `.blp`, or `.ttf`.
- Pope split still comes from Gora. Congregation still comes from `SetBroadcastFavor`. `PickFavor` and plate clicks are unchanged.
- `countStatusBars` is 2 after Init, after rails paint, and after rebuild. `health` stays nil. `healthReads` stay 0.
- Isolation asserts stay under `if standalone then`.

## Concerns

- **No client smoke.** Stock QuestBG cropped into a thin name strip may read as quest-log chrome, not a Gora plate. Same QuestBG as the full-card parchment — BORDER puts it above the sheet, but the two fills may not separate at stream distance. License 4 forbids custom media. **POLISH:CANDIDATE** only.
- **Horizontal size follows the mute rails** (120 + pad), not live string width. An empty title still occupies a fontstring point, so the vertical span stays name→title.
- **A01 still NOT RUN.** `health` is nil. Mute rails are textures. No `UnitHealth`. Do not read these fields as live HP.
- **`applyTexture` fallback is throw-only.** A silent missing `QuestBG` on 20506 will not fall through to fill. Same edge as V-D.
- Batch 3 HUD-B also named painted portraits and a FAVOR-label sigil. Out of this lane.

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
