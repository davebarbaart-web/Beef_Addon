# V-D — HUD iron/parchment dress (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** CONTINUE 2026-08-18 license 4 (stock textures/fonts only); Bible §10.7, §19.3; Batch 2 critique §D dress only; brief `docs/reformation/vestments/briefs/V-D-hud.md`; stock note `docs/reformation/vestments/briefs/V-stock-textures.md`.

Event Mode Fight HUD dress on the existing W-F favor card. Iron/parchment via QuestBG `pcall` + WHITE8X8 / tooltip border. Center is a gold-tinted stock ring, not a faction crest. Mute rails are textures tinted with `nameColor`, not live HP. Height ≤ 12% of `UIParent` (100 when parent height is unknown). Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_hud.lua` | TDD first. Source grep (no `PvPFrame` / `PVP-Banner` / `UI-PVP-Horde` / `UI-PVP-Alliance`, no `Media\\`, QuestBG + EmptySlot/TrackingBorder). Height 100 when `UIParent` is unknown; 92 when parent is 768. Parchment / seal / two Texture rails. GetView still a copy. Isolation stays under `if standalone then`. |
| `addon/ChurchOfBeef/UI/Hud.lua` | Stock QuestBG parchment + WHITE8X8 iron/gold + tooltip border. Center `UI-EmptySlot-White`. Mute rails. `hudHeight` = `min(100, 12% of UIParent)`. W-F favor / PickFavor / `health` nil unchanged. |
| `docs/reformation/vestments/briefs/V-D-hud-report.md` | This file |
| `docs/reformation/vestments/briefs/V-D-hud.diff` | V-D-only unified diff vs the unsigned W-F baseline of the exclusive files |

Did not edit Toasts, Console, Decree, Records, Gora, Net, bootstrap, TOC, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

## Contract

### Dress

- Event Mode only. Quiet still hides. No `OnUpdate`. No sound. No custom Media.
- Height: `min(100, floor(UIParent:GetHeight() * 0.12 + 0.5))` when parent height is a positive number; else **100** (current compact card + favor row). Does not grow into a toast. Width stays 420.
- Frame: iron field + inset QuestBG parchment via `pcall` `SetTexture` `Interface\QuestFrame\QuestBG`; WHITE8X8 fill fallback; tooltip border; 1px gold rule.
- Center: gold-tinted `Interface\Buttons\UI-EmptySlot-White`. VS + FAVOR stay. No `Interface\PvPFrame\`, `PVP-Banner`, `UI-PVP-Horde`, or `UI-PVP-Alliance`.
- Mute rails: two `Texture` strips under the names, tinted with that fighter’s `nameColor` (else muted ink). Not StatusBars. No percent health. No `UnitHealth`.
- Favor halves keep `Interface\TargetingFrame\UI-StatusBar`. Exactly two StatusBars.
- Title remains the Church title from Ranks (`Beef Knight`), not “Beef Paladin”. Head-to-head line unchanged.

### W-F favor (unchanged)

| Client | Fill |
|--------|------|
| Hidden / no live pair | `favor == nil`, `health == nil` |
| Local Pope | `Gora:GetFavorSplit()` while a pair is live, including zeros |
| Congregation | last `SetBroadcastFavor({ a, b })` only |

`PickFavor` / plate click / GetView copy stay as W-F left them.

## TDD

1. Extended `test_hud.lua` first (faction greps, QuestBG / stock ring, parchment + seal + rails, height budget, GetView copy). Isolation unchanged. W-F favor / PickFavor / health / nameplate pins kept.
2. Red: `parchment uses stock QuestBG` expected true; `center uses a stock ring` expected true; `iron/parchment dress has a parchment field` expected true; suite then aborted indexing `frame.parchment`.
3. Implemented `Hud.lua`.
4. Green: `lua tests/test_hud.lua` — **358 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_hud.lua   # 358 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_hud.lua` standalone | 358 passed, 0 failed. Lua 5.1. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Quiet still hides. Health pins and nameplate-scrape greps stay.
- Source has no `UnitHealth`, `PvPFrame`, `UI-PVP-Horde`, `UI-PVP-Alliance`, `Media\\`, `.tga`, `.blp`, or `.ttf`.
- Pope split still comes from Gora. Congregation still comes from `SetBroadcastFavor`. `PickFavor` and plate clicks are unchanged.
- `GetView` is still a copy after a rebuild. `health` stays nil.
- Isolation asserts stay under `if standalone then`.

## Concerns

- **No client smoke.** Stock QuestBG plus `UI-EmptySlot-White` may read as quest-log / mail-slot chrome, not a Gora ring. License 4 forbids a custom bull sigil. **POLISH:CANDIDATE** only.
- **Height is sampled once** at first `Init` (idempotent). Later `UIParent` size changes do not resize the card.
- **Mute rails are not stained-glass health.** Appendix A01 stays closed: no `UnitHealth`, no percent health. The rails are 2px textures so they cannot be read as live HP.
- **`WHITE8X8` is UNCONFIRMED** in FrameXML for this checkout. Applied via `pcall` `SetTexture`, then vertex color; `SetColorTexture` is the fallback.

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
