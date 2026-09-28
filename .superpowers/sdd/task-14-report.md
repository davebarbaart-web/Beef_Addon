# Task 14 Report — Pope desk (Thedave can run the night)

**Status:** DONE  
**Date:** 2026-09-14  
**Checkout:** `/Volumes/AI_Design_Drive/Beef_Addon`  
**Schema:** 7. **Interface:** 20506.  
**No commit. No phase ticks. No POLISH:PASS / MVP / §22.3.**

## What landed

- `UI/PlayerCard.lua` — listed-Pope card grows **THE DESK**, which calls `Console:Show()`. Congregation card does not show the door; `OpenDesk()` refuses and never Shows. Bare `/beef` stays the card.
- `UI/Console.lua` — `PHASE_HINT` names the next click (Quiet → start the gathering; Assembly → open a rite / end; Rite → close this rite; Consequence → continue / end). No sixth state. No rite-state poetry.
- `after()` paints refuse strings on `GateStatus`. End-during-RITE (`event ends from assembly or consequence`) is visible. Success still Refresh and clears the line. No toasts.
- Petition row fills the next empty Fighter A/B when a `characterId` exists. Both slots full → row reads “use this petitioner.” No auto-sanction. Unsigned Task 6 name-key rows still paint; click selects/paints only and does not mint Store.
- Pair name buttons select the subject only. `DECLARE VICTOR` is the commit.

`ChurchOfBeef.lua` was not edited. Task 3 `Show` / `Toggle` Pope gate stays. Congregation `/beef console` stays hidden.

## Files edited

| File | Change |
|------|--------|
| `addon/ChurchOfBeef/UI/Console.lua` | Next-verb hints; `after()` refuse paint; `UsePetitioner`; pair names select |
| `addon/ChurchOfBeef/UI/PlayerCard.lua` | Listed-Pope `THE DESK` door + `OpenDesk` |
| `tests/test_console.lua` | Inverted PairVictor / PHASE_HINT pins; End-during-RITE; petition fill; unsigned click |
| `tests/test_player_card.lua` | Congregation has no door; listed-Pope door Shows console |

Not edited: `ChurchOfBeef.lua`, `UI/Hud.lua`, `UI/Inputs.lua`, `UI/Toasts.lua`, `Core/DB.lua`, `Net/Codec.lua`, `Core/Gora.lua`.

## Pins

| Pin | Result |
|-----|--------|
| Listed-Pope card door → `Console:Show()` | Pass |
| Congregation card has no desk door | Pass |
| `Console:Show` / `Toggle` still refuse non-Popes | Untouched |
| Congregation `/beef console` stays hidden | Untouched (`test_wire_glue.lua`) |
| Bare `/beef` stays the card | Pass |
| `PHASE_HINT` next-verb copy | Pass |
| `after()` paints End-during-RITE | Pass |
| Petition fills next empty slot, no Sanction | Pass |
| Pair names select; `DECLARE VICTOR` commits | Pass |
| Unsigned Zipfresh still paints; click does not mint | Pass |

## Harness

| Suite | Result |
|-------|--------|
| `lua tests/test_console.lua` | **2689 passed, 0 failed**, exit 0 |
| `lua tests/test_player_card.lua` | **348 passed, 0 failed**, exit 0 |
| `lua tests/run.lua` | **17028 passed, 0 failed**, exit 0 |

```
Tests finished: 2689 passed, 0 failed
Tests finished: 348 passed, 0 failed
Tests finished: 17028 passed, 0 failed
```

## Concerns

- The desk door is card-only. Slash help still says `The desk is /beef console.` `ChurchOfBeef.lua` was left alone so Tasks 8–11 keep the login / persist / stash files.
- End-during-RITE is painted when `EndEvent` is called. The End button stays hidden during RITE (existing phase chrome). The refuse is visible on `GateStatus` if that verb is invoked.
- Petition fill writes `selectedFighterA` / `B` directly and does not go through `SetFighterA` / `EnsureCharacterByName`. Unsigned click still must not mint; a later Pope verb on a name-only subject can still recognise-on-verb. That is existing desk law, not this slice.
- In-game `/reload` smoke for the door and End-during-RITE paint was not walked. Harness only. **POLISH:CANDIDATE** is not claimed.
