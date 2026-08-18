# B3-B — Mute fighter cards (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.6, §19.3, Law 4, Law 6, Law 10; brief `docs/reformation/vestments/briefs/B3-B-fightercard.md`; stock note `docs/reformation/vestments/briefs/V-stock-textures.md`.

Event Mode mute tale of the tape. The card shows; the Pope tells. Hidden in Quiet / no pair. Stock QuestBG + WHITE8X8. Center-third, two facing plates. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_fighter_card.lua` | Isolated suite. wow_ui_stub + Common + Ranks + Store + Runtime + Gora + FighterCard. Quiet Show false. Sanction Show paints names, Church titles, W–L. GetView copy. Source grep (no `rubber` / `ordained` / `UnitHealth` / StatusBar / sound / custom Media). Isolation under `if standalone then`. |
| `addon/ChurchOfBeef/UI/FighterCard.lua` | `COB.FighterCard`. Init / Show / Hide / Refresh / GetView / ResetForTests. Two facing plates. Stipulation from `Gora:GetSanctioned()`. Head-to-head as `1-0`. Defenses omitted. `health` nil. |
| `docs/reformation/vestments/briefs/B3-B-fightercard-report.md` | This file |
| `docs/reformation/vestments/briefs/B3-B-fightercard.diff` | B3-B-only unified diff of the exclusive files |

Did not edit TOC, `run.lua`, Console, Hud, Toasts, Store, Gora, Runtime, bootstrap, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

## Contract

```lua
FighterCard:Init()
FighterCard:Show()      -- needs a sanctioned pair; else false
FighterCard:Hide()
FighterCard:Refresh()
FighterCard:GetView()   -- copy
FighterCard:ResetForTests()
```

Mode Event. `Show()` returns false in Quiet and when `Gora:GetSanctioned()` is not a live pair.

| Field | Source |
|-------|--------|
| name | Store character; class color on the name only |
| level | Store, painted only when present |
| title | `Store:RankForCharacter` → `Ranks.Title`. Unlinked = empty. No Squire / Paladin-as-title |
| W–L | Store gora wins/losses (`0-0`, `1-0`) |
| head-to-head | Store history as numbers (`1-0`) when fights > 0; hidden otherwise |
| stipulation | `Gora:GetSanctioned().stipulation` if the Pope attached one |
| defenses | omitted (Store nils `defenses` / `defenseCount`) |
| health | not on the card. No `UnitHealth` |

Dress: iron field + inset QuestBG via `pcall` `SetTexture`; WHITE8X8 fill fallback; tooltip border; gold-tinted `UI-EmptySlot-White`. Center of `UIParent`. Width = 1/3 of parent, or **420** if unknown. Height = `min(220, 1/3 of parent)`, or **220** if unknown. Not a full-screen toast. No StatusBar. No sound. No close button. No `OnUpdate`.

## TDD

1. Wrote `tests/test_fighter_card.lua` first (API, isolation, source grep, Quiet refuse, sanction paint, titles, W–L, stipulation, `1-0` rematch, GetView copy, center-third rebuild).
2. Implemented `FighterCard.lua`.
3. Green: `lua tests/test_fighter_card.lua` — **263 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_fighter_card.lua   # 263 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_fighter_card.lua` standalone | 263 passed, 0 failed. Lua 5.1. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Quiet Show is false. Health pins and nameplate-scrape greps stay.
- Source has no `UnitHealth`, `rubber`, `ordained`, `StatusBar`, `PlaySound`, `PvPFrame`, `Media\\`, `.tga`, `.blp`, or `.ttf`.
- Titles come from Ranks. Head-to-head is `1-0`, not prose. Stipulation is the Pope line.
- `GetView` is a copy. `health` stays nil. Defenses are not invented.
- Isolation asserts stay under `if standalone then`.

## Concerns

- **No client smoke.** Stock QuestBG plus `UI-EmptySlot-White` may read as quest-log / mail-slot chrome. License 4 forbids a custom bull seal. **POLISH:CANDIDATE** only.
- **Size is sampled once** at first `Init` (idempotent). Later `UIParent` size changes do not resize the card.
- **Defenses stay omitted** until Store stops nilling the field. Do not invent a counter.
- **`WHITE8X8` is UNCONFIRMED** in FrameXML for this checkout. Applied via `pcall` `SetTexture`, then vertex color; `SetColorTexture` is the fallback.
- Integrator still lists the files in the TOC and `run.lua`.

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
