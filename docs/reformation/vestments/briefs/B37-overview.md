# Batch 37 — Dismiss pick + Quiet favor forget + card ESC list + confess box wipe

**Cited:** Bible §18.1 leftover highlight; License 2 / §10.6 favor is per-event; wiki `UISpecialFrames`; §13.4 / §9 leftover confess text. Anniversary `EditBox:SetText`, `C_ChatInfo.SendAddonMessage`. License 4 Console stays plain. One Console leftover. `SaveNote` nil. No SUMMON. No `UnitHealth`. No dest on Codec. No `PlaySound`. `FRAME_NAME` card is `ChurchOfBeefFighterCard`.

SendPetition opponent trim is **not** a lane: Codec already `trim`s opponent on encode.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B37-A | `UI/Console.lua`, `tests/test_console.lua` | Successful Dismiss nils `selectedCharacterId`. Nest after `runB36B()`. |
| B37-B | `UI/Hud.lua`, `tests/test_hud.lua` | Quiet `forgetPersist` also nils `broadcastFavor`. Nest after `runB35A()`. |
| B37-C | `UI/FighterCard.lua`, `tests/test_fighter_card.lua` | Existing-frame Hide remounts `rememberSpecial`. Nest after `runB30B()`. |
| B37-D | `UI/Inputs.lua`, `tests/test_inputs.lua` | Quiet Hide blanks `confessBox`. Nest after `runB35B()`. |
| B37-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
