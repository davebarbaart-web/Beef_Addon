# B3-A — Knighting / elevation proclamation

**Exclusive:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

**Do not edit** Console, Knighting Core, Sound.lua, HUD. Do not commit. No custom media. No new sound cue **names**.

## Law

Bible §8, §19.2–19.4. Batch 3 R7. Law 4: mute card / no oratory. Fixed clerical headlines only.

Extend `Toasts:Proclaim`:

| kind | Headline | Fields |
|------|----------|--------|
| `knighting` | `RISE, BEEF KNIGHT` | `name` (human/character display name) |
| `elevation` | `RISE, BEEF LORD` | `name` |

Same overlay contract as sanction: Quiet/missing Runtime refuse; center third; dim ≤ 0.5; `C_Timer.After`; no close button; no `SendChatMessage`. Call `Sound:Play("knighting")` / `Sound:Play("elevation")` when Sound exists. Do not invent a sixth cue name.

Do not wire Console/Knighting here. Tests Proclaim directly.

Keep sanction/verdict/cowardice and system/debug green.

## Verify

`lua tests/test_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B3-A-knighting-report.md` + diff. POLISH:CANDIDATE.
