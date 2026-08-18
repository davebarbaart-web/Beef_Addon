# B8-C — Fighter card mute defense count (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.6, §19.3; Law 4, Law 6, Law 10; OPEN_QUESTIONS #9; brief `docs/reformation/vestments/briefs/B8-C-card-defenses.md`. B3-B mute tape, B4-E LEFT / Morpheus, and B6-D honorific pins kept.

Event Mode mute tale of the tape. The card shows; the Pope tells. Each plate paints `Store:CountDefenses(id)` as a **mute integer**. Zero or a missing method hides the line. No "defenses of the realm." Honorific line stays. Painted W–L and H2H stay `1-0`. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

**Isolated count:** 388 passed, 0 failed (`lua tests/test_fighter_card.lua`). **17** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_fighter_card.lua` | TDD first. Zero hides. Linked Lord + post-elevation win (or stub `CountDefenses`) paints the integer. Missing method hides. Honorific stays. Source grep bans `defenses of the realm`. `1-0` rematch / H2H pins kept. Isolation wrap stays. Health stays nil. |
| `addon/ChurchOfBeef/UI/FighterCard.lua` | `defensesFrom` reads `Store:CountDefenses`. Mute `GameFontNormal` integer under the record. Hide when `n < 1` or the method is missing. Honorific re-anchors under the integer when shown. LEFT dock and Morpheus names unchanged. No `UnitHealth`. |
| `docs/reformation/vestments/briefs/B8-C-card-defenses-report.md` | This file |
| `docs/reformation/vestments/briefs/B8-C-card-defenses.diff` | B8-C-only unified diff of the exclusive implementation files vs the pre-lane baseline |

Did not edit Store, HUD, Records, Gora, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not write `gora.defenses`. Did not commit.

## Contract

```lua
FighterCard:Init()
FighterCard:Show()      -- needs a sanctioned pair; else false
FighterCard:Hide()
FighterCard:Refresh()
FighterCard:GetView()   -- copy
FighterCard:ResetForTests()
```

Mode Event. Quiet / no pair still Hide. `health` stays nil.

| Field | Source / form |
|-------|----------------|
| dock | LEFT of UIParent, clamped (B4-E; unchanged) |
| names | `GameFontHighlight` + stock Morpheus (unchanged). Class color on the name only |
| titles / records / H2H / stipulation | `GameFont*`. W–L and H2H paint as `1-0` (arabic) |
| honorific | `Store:GetCharacter(id).humanId` → `Store:GetHuman.honorifics[1]`. Mute `GameFontNormal`. Empty / unlinked → Hide (B6-D; unchanged) |
| defenses | `Store:CountDefenses(id)` as a mute integer on the plate. Hide when the count is 0 or the method is missing. No realm copy |
| health | not on the card. No `UnitHealth` |

No close / star / ✕ chrome. No faction crests. No `Media\` paths. No generated flavor.

## TDD

1. Extended `tests/test_fighter_card.lua` first (hidden zero, Lord + post-elevation win paints `1`, stub paints `2`, missing method hides, honorific stays, `1-0` rematch / H2H pins, isolation wrap).
2. Implemented `defensesFrom` + mute plate line + Hide when 0 / missing.
3. Green: `lua tests/test_fighter_card.lua` — **388 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_fighter_card.lua   # 388 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_fighter_card.lua` standalone | **388 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 17 pins under `if standalone then` (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Sound, Decree, Records Book). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Quiet / no pair still Hide. `health` stays nil. No close button.
- Source has no `UnitHealth`, `defenses of the realm`, `Duke of`, `rubber`, `ordained`, `StatusBar`, `PlaySound`, `PvPFrame`, `Media\\`.
- Painted rematch record and H2H stay `1-0`. LEFT dock and Morpheus names stay.
- Honorific is still Store human text and still shows when the defense line is present or hidden.
- `GetView` is still a copy. Isolation asserts stay under `if standalone then`.
- Card reads `CountDefenses`; it does not write `gora.defenses`.

## Concerns

- **No client smoke.** Extra mute line on the compact 220-high plate is unsmoked on 20506. Honorific + integer may clip on a short plate. **POLISH:CANDIDATE** only.
- **Unlabeled integer.** The line is the number alone (brief: no realm copy). The Pope still tells. A first-time spectator will not know the digit means defenses until he does.
- **B8-A is present in this tree.** The happy path seeds a linked Lord + post-elevation win and reads the real `CountDefenses`. The suite also stubs the method (paint `2`; missing → hide) so the card does not invent a counter if the Store method is absent.
- Integrator still lists the files in the TOC and `run.lua`.

## Status

**DONE_WITH_CONCERNS.** Isolated **388 / 0**. Not signed. **POLISH:CANDIDATE.**
