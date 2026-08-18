# V-A — Decree parchment dress (stock textures only)

**Exclusive files:**
- `addon/ChurchOfBeef/UI/Decree.lua`
- `tests/test_decree_ui.lua`

**Do not edit** Console, Toasts, Records, HUD, Core, TOC, bootstrap, OPEN_QUESTIONS, REFORMATION_LOG, `Data/Popes.lua`.

**Do not commit.** Do not add files under `Media/`. No custom `.tga` / `.blp` / `.ttf`.

## Law

CONTINUE license 4: **stock Blizzard textures and fonts only**. Bible §14.1, §19.1, §19.3. Batch 2 §B. Law 6: Quiet, no sound.

Missing media must not fail load. Today `Media\\decree-*` and `Media\\DecreeTitle.ttf` **do not exist** — drop those paths or keep them only as a `pcall` that falls through.

## Hierarchy (the miss)

The decree **line** (place/time) is the headline. Church name is small by the seal. `HEADER` (`A GATHERING HAS BEEN DECREED`) stays UI copy for `Banner.HEADER` / `GetView().header` / minimap tooltip — it is **not** the largest line.

- `LineText` — largest (`GameFontNormalHuge` or `Fonts\\FRIZQT__.TTF` / `Fonts\\MORPHEUS.TTF` via `pcall` `SetFont`, then GameFont fallback).
- `FlavorText` — optional under the line (§14.1).
- Church name (`Church of Beef`) — `GameFontHighlightSmall`, next to the seal.
- `HeaderText` — if kept, small clerical, not huge.

No cross glyphs (`✠` or `+` ornaments). No jokes.

## Scale / dress

Quest-tracker object: upper-center, world visible. Target about **300–340 × 130–160** (today 520×188 is too wide). Movable, clamped. Aged parchment: stock `Interface\\QuestFrame\\QuestBG` or `Interface\\Stationery\\StationeryTest1` via `pcall` `SetTexture`; on failure, existing `fill()` aged color (darker/warmer than a printed card — nudge the fill toward 0.62, 0.52, 0.34). Gold rule / iron edge via `WHITE8X8` tints. Seal: stock gold ring or `Interface\\Buttons\\UI-Quickslot2` tinted — **not** Horde/Alliance crests.

Quiet: no `PlaySound`. No Event Mode host.

## Tests

Keep: no empty parchment; Core Get/Set only; GetView copy; no slash; no calendar/RSVP; Init silent without a Decree; flavor hide when omitted.

Update: LineText is the visual headline (you may pin font object / size larger than HeaderText). Source grep: no `✠`, no new `Media\\` paths required to load. Isolation under `if standalone then`.

## Verify

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_decree_ui.lua
```

Must exit 0. Report `docs/reformation/vestments/briefs/V-A-decree-report.md` + `V-A-decree.diff`. **POLISH:CANDIDATE** at most.
