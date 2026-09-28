# Task 13 report — HUD copy + toast gloss

**Checkout:** `/Volumes/AI_Design_Drive/Beef_Addon`  
**Date:** 2026-09-14  
**Status:** landed (harness green). No commit. Schema 7. Interface 20506. PROTOCOL 2.  
**Not claimed:** POLISH:PASS, POLISH:CANDIDATE, MVP, Bible §22.3.

## What changed

| File | Edit |
|------|------|
| `addon/ChurchOfBeef/UI/Hud.lua` | Hover `Click to pick this side.` Footer **Pick a side** at 0/0. After a ruling: hide favor, footer **Ruled**, no winner string, until Continue. |
| `addon/ChurchOfBeef/UI/Toasts.lua` | Pope-local `clericalCopy` only. Void / fled / sanctioned duel. Free ruling stays `"Free ruling."` |
| `tests/test_hud.lua` | Inverted FAVOR pre-pick + frozen-favor persist. Pinned hover, Pick a side, ruled, no winner. |
| `tests/test_toasts.lua` | Inverted Void / cowardice / sanction. Pinned fled, this fight does not count, sanctioned duel, no The Pope ruled, no inbound STATE. |

**Not edited:** `ChurchOfBeef.lua`, `UI/FighterCard.lua`, `UI/Console.lua`, `UI/Inputs.lua`, `Core/DB.lua`, `Net/Codec.lua`. Task 8 ASSEMBLY pair, stash names, and #111 dismissed flag on the inbound wrap were left in place.

## Pins (locked)

1. **Hover.** `pickA` / `pickB` `OnEnter` → GameTooltip `Click to pick this side.` Only while `pickPair()` is live. After a ruling the tip does not offer a pick.
2. **Footer.** `favorLabel == "Pick a side"` at a 0/0 split (inverted `"FAVOR"`). After the first pick the rubric may stay `FAVOR`.
3. **Void.** Headline / chat: `This fight does not count.`
4. **Cowardice.** Headline contains **fled**: `Cowardice recorded: <name> fled. So ruled by the Beef Pope.`
5. **Sanction.** Pomp headline kept (`A Beef Gora is Sanctioned`). Body starts with `A sanctioned duel.`
6. **Free ruling.** `"Free ruling."` or the Pope’s text. Source has no `The Pope ruled.`
7. **#110.** After a pickable fight ends, HUD `view.ruled == true`, favor hidden, footer `Ruled`, until Continue (CONSEQUENCE → ASSEMBLY). `view.verdict` stays nil. No invented winner — STATE subjects have no winner id without a beat field.
8. **#27.** Toasts still has no `_HandleState` / `HandleState` / `SendState`. HUD source has no `Proclaim`. No inbound theater added.

## Harness

| Suite | Result |
|-------|--------|
| `lua tests/test_hud.lua` | **1039 passed, 0 failed**, exit 0 |
| `lua tests/test_toasts.lua` | **508 passed, 0 failed**, exit 0 |
| `lua tests/run.lua` | **16967 passed, 0 failed**, exit 0 |

Client `/reload` smoke was not walked this slice.

## Concerns

1. **Winner name is not stamped.** Pope STATE subjects are still `candidate` + `fighters` only. A winner id is not knowable without a new beat field. Footer is `Ruled`; `view.winner` stays nil.
2. **Congregation leftover RITE + fighters.** If Runtime still names two fighters after a Pope ruling, congregation `pickPair()` stays live. That client cannot tell sanctioned-in-progress from already-ruled tape (#27). Ruled chrome lands when `pickPair()` is gone (Pope `GetSanctioned` cleared, or lastPair-only persist).
3. **CloseRite without a local ruling.** Congregation OpenRite → CloseRite also paints `Ruled`, because the pickable pair vanished. That is inferred from persist, not from a clerical beat.
4. **Arabic records** were left as optional Romans. Do not block Task 14 on that.
5. **Fighter card** was not touched. #111 still depends on the bootstrap dismissed flag. Do not unwrap `ChurchOfBeef.lua`.
