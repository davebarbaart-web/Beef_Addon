## Task 13: HUD copy (P1, after names work)

**Files:** `UI/Hud.lua`; `UI/FighterCard.lua`; `UI/Toasts.lua`; `tests/test_hud.lua`; `tests/test_toasts.lua`

**Depends on:** Task 8 (names on HUD).

### Pins

- Hover: “Click to pick this side.” Footer **Pick a side** before the first pick.
- Arabic records optional this slice — do not block Task 14 on Romans.
- `Void.` → “This fight does not count.” Cowardice headline must say fled. Sanction: one plain “sanctioned duel” line under pomp. Free ruling: keep `"Free ruling."` or omit; **no** “The Pope ruled.”
- HUD after a ruling reads as ruled until Continue (#110). Hide favor or stamp the winner name from Pope STATE subjects if a winner id is already knowable **without** a new beat field. If it is not knowable, hide favor and show that the fight is ruled — do not invent a winner string.
- No inbound `Toasts:Proclaim` / Sound (#27).

No commit. `lua tests/run.lua` exit 0.
