# B3-B — Mute fighter cards

**Exclusive:** create `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

**Do not edit** TOC, `run.lua`, Console, Hud, Toasts, Store. Integrator lists the files after you. Do not commit. No custom media. No generated flavor (“rubber match”, “one apiece”).

## Law

Bible §10.6: tale of the tape. **The card is mute.** It shows; the Pope tells.

```lua
FighterCard:Init()
FighterCard:Show()      -- needs a sanctioned pair; else false
FighterCard:Hide()
FighterCard:Refresh()
FighterCard:GetView()   -- copy
FighterCard:ResetForTests()
```

Mode Event. Hidden in Quiet / no pair. Stock QuestBG + WHITE8X8. Center-third or two facing plates; not a full-screen toast.

Each plate (from Store + Ranks, same helpers as HUD):

- name (class color on the **name** only)
- level if present
- Church title (`Ranks.Title`) — never Squire/Paladin-as-title
- W–L from Store gora
- head-to-head as numbers (`1-0`) when history exists — no prose
- stipulation from `Gora:GetSanctioned().stipulation` if any (Pope-authored)
- defenses: **omit** if Store has no defense field (Core nils `defenses` today — do not invent a counter)

`health` is not on this card. No `UnitHealth`. No jokes. No sound.

## Tests

Isolated: wow_ui_stub + Common + Ranks + Store + Runtime + Gora + FighterCard.

Quiet → Show false. Sanction pair → Show paints both names, titles, W–L. GetView copy. No `rubber` / `ordained` in source. Isolation under `if standalone then`.

`lua tests/test_fighter_card.lua` exit 0.

Report `docs/reformation/vestments/briefs/B3-B-fightercard-report.md` + diff. POLISH:CANDIDATE.
