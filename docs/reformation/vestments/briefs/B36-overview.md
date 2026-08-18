# Batch 36 — SendConfession trim + End selection + dock OnHide + Decree ESC list

**Cited:** Bible §13.4 / §9 optional confession text; §18.1 leftover highlight after End; §14.1 Decree ESC; Event dock dismiss persist. Anniversary `C_ChatInfo.SendAddonMessage` whisper dest; `Names.Trim`; wiki `UISpecialFrames` named frame. License 4 Console stays plain. One Console leftover. `SaveNote` nil. No SUMMON. No fan-out. No dest on Codec. No `PlaySound` on dock / Decree Hide. `FRAME_NAME` Decree is `ChurchOfBeefDecree`.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B36-A | `Net/BeefNet.lua`, `tests/test_net_v2.lua` | Trim `SendConfession` text; empty omits. After B34-D block. |
| B36-B | `UI/Console.lua`, `tests/test_console.lua` | Successful EndEvent nils `selectedHumanId` / `selectedCharacterId`. Nest after `runB34B()`. |
| B36-C | `UI/ConsoleDock.lua`, `tests/test_console_dock.lua` | Existing-frame Hide remounts missing OnHide (dismiss persist). Nest after `runB30D()`. |
| B36-D | `UI/Decree.lua`, `tests/test_decree_ui.lua` | Existing-frame Hide remounts `rememberSpecial`. Nest after `runB31B()`. |
| B36-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
