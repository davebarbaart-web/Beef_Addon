# B6-D — Mute fighter-card honorifics (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.6, §15, §19.3; Law 4, Law 6, Law 10; brief `docs/reformation/vestments/briefs/B6-D-card-honorific.md`. B3-B mute tape and B4-E LEFT / Morpheus pins kept.

Event Mode mute tale of the tape. The card shows; the Pope tells. Honorifics are Pope-authored Store text on the human (`GetCharacter.humanId` → `GetHuman.honorifics`). First honorific paints as a mute line per plate. Empty / unlinked → widget hidden. Never invent "Duke of …". Painted W–L and H2H stay `1-0`. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_fighter_card.lua` | Empty honorific hides. Seed `AddHonorific` "Defender of the Faith" paints exactly that string. Unlinked stays hidden. Source grep bans `Duke of`. `1-0` rematch pins kept and re-pinned after honorific paint. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/FighterCard.lua` | `honorificFrom` reads Store human. Mute `GameFontNormal` line under the record. Show first honorific only. Hide when empty. LEFT dock and Morpheus names unchanged. No `UnitHealth`. |
| `docs/reformation/vestments/briefs/B6-D-card-honorific-report.md` | This file |
| `docs/reformation/vestments/briefs/B6-D-card-honorific.diff` | B6-D-only unified diff of the exclusive files vs the pre-lane baseline |

Did not edit Hud, Toasts, Console, Store, Gora, TOC, `run.lua`, bootstrap, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not invent a title. Did not commit.

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
| honorific | `Store:GetCharacter(id).humanId` → `Store:GetHuman.honorifics[1]`. Mute `GameFontNormal`. Empty / unlinked → Hide. No generated "Duke of …" |
| defenses | omitted (Store still nils the field) |
| health | not on the card. No `UnitHealth` |

No close / star / ✕ chrome. No faction crests. No `Media\` paths. No generated flavor.

## TDD

1. Extended `tests/test_fighter_card.lua` first (hidden empty, exact Pope seed, unlinked hide, `Duke of` source ban, `1-0` rematch pins, isolation wrap).
2. Implemented `honorificFrom` + mute plate line + Hide when empty.
3. Green: `lua tests/test_fighter_card.lua` — **329 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_fighter_card.lua   # 329 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_fighter_card.lua` standalone | **329 passed, 0 failed.** Lua 5.1. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Isolated count

**329 passed, 0 failed.**

## Self-review

- Exclusive implementation files only. Quiet / no pair still Hide. `health` stays nil. No close button.
- Source has no `UnitHealth`, `Duke of`, `rubber`, `ordained`, `StatusBar`, `PlaySound`, `PvPFrame`, `Media\\`.
- Painted rematch record and H2H stay `1-0`. LEFT dock and Morpheus names stay.
- Honorific is Store human text, not a Church rank and not class-colored.
- `GetView` is still a copy. Isolation asserts stay under `if standalone then`.

## Concerns

- **No client smoke.** Extra mute line on the compact 220-high plate is unsmoked on 20506. Long Pope text may clip. **POLISH:CANDIDATE** only.
- **First honorific only.** Brief allowed a ` · ` join of at most two. This lane paints `honorifics[1]` and leaves the rest on the human unpublished.
- **Defenses stay omitted** until Store stops nilling the field. Do not invent a counter.
- Integrator still lists the files in the TOC and `run.lua`.

## Status

**DONE_WITH_CONCERNS.** Isolated **329 / 0**. Not signed. **POLISH:CANDIDATE.**
