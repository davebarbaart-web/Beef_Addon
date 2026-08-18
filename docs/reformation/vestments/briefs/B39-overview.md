# Batch 39 — OpenRite last-pair refuse + card/toast ESC remount + dock Show OnHide

**Cited:** Bible §18.1 leftover highlight; §10.7 last pair is Gora persist, not the next rite; wiki `UISpecialFrames`. License 4 Console stays plain. One Console leftover. `SaveNote` nil. No SUMMON. No dest on Codec. No `UnitIsDead`. No Records remap. No `PlaySound`.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B39-A | `UI/Console.lua`, `tests/test_console.lua` | OpenRite Gora does not fall back to `GetLastSanctioned`. Nest after `runB38A()`. |
| B39-B | `UI/FighterCard.lua`, `tests/test_fighter_card.lua` | Show / Refresh remount `rememberSpecial`. Nest after `runB37C()`. |
| B39-C | `UI/Toasts.lua`, `tests/test_ui.lua` | HideAll remounts toast + proclaim names. Nest inside `runB12D()`. |
| B39-D | `UI/ConsoleDock.lua`, `tests/test_console_dock.lua` | Show remounts missing OnHide. Nest after `runB36C()`. |
| B39-INT | glue + ledger + install | `canCarryLast` also requires `riteType == "Gora"`. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
