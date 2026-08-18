# B4-INT — Batch 4 integrator

All seven B4 reviews are Spec PASS. Do not reopen exclusive sources except compose fixes listed below.

You may edit:
- `addon/ChurchOfBeef/ChurchOfBeef.toc` — list only existing files. Interface stays `20506`.
  - `Core\Confession.lua` after `Core\Gora.lua`
  - `UI\Inputs.lua` after Hud (or FighterCard)
  - `UI\ConsoleDock.lua` after Console
- `tests/run.lua` — add `test_confession`, `test_inputs`, `test_console_dock` near peers
- `addon/ChurchOfBeef/ChurchOfBeef.lua` — extend `InstallWire` / slash / `bindLocalCharacter` only
- `addon/ChurchOfBeef/UI/MainFrame.lua` — `UI:Init` should Init FighterCard, Inputs, ConsoleDock when those modules exist (pcall; missing no-op)
- `tests/test_wire_glue.lua` — petition WHISPER is now live: non-Pope → `"not a registered pope"` (same as favor). GUILD petition stays `"unknown message type"`. Pin Inputs/ConsoleDock Refresh spies if you wrap them.
- `docs/phases/two-client-smoke.md` honesty table: petition/confession INPUT are live **whisper-to-Pope** (`SendPetition` / `SendConfession`). Still need a caller-supplied target. Do not invent a Pope name. Do not tick walk boxes. Confession **fan-out** stays leftover (never public theater).
- `docs/REFORMATION_LOG.md` — Batch 4 verdicts only. Do not close Gate W/V.

Do not edit Confession/Gora/BeefNet/Console/Hud/FighterCard/Inputs/ConsoleDock sources unless a compose pin is red.

Do not commit. Do not invent a Pope name.

## Glue contract

1. `bindLocalCharacter` also sets `Inputs:SetLocalCharacterId` when Inputs exists (same Store lookup as Hud).
2. Inbound accepted STATE (existing `_HandleState` wrap) also `Inputs:SetInputTarget(sender)` and `Inputs:Refresh` / `ConsoleDock:Refresh` / hide Inputs+Dock when inspecting.
3. Runtime `StartEvent` / `OpenRite` / `Continue` / `EndEvent` after-success: `ConsoleDock:Refresh`, `Inputs:Refresh`. `EndEvent` also `FighterCard:Hide` if the function exists.
4. Verdict wraps (existing) may `FighterCard:Hide` after Proclaim — optional; Hide on EndEvent is required.
5. Skip all of the above while `_inspecting`.
6. Slash (player-opened, not Quiet chrome):
   - `/beef petition` → if Inputs exists, `SetInputTarget(UnitName("target"))` when target name is a non-empty string, then `Petition()`. Do not look up a Pope from Popes.lua.
   - `/beef confess` → same target bind, then `Inputs:Show()` if Event (Show already Quiet-refuses).
   Keep `/beef`, `/beef console`, `/beef minimap`. Current slash strips spaces — `petition` and `confess` are exact stripped words.

## Verify

```
lua tests/test_confession.lua
lua tests/test_inputs.lua
lua tests/test_console_dock.lua
lua tests/test_wire_glue.lua
lua tests/test_net_v2.lua
lua tests/run.lua
```

All exit 0.

Write `docs/reformation/vestments/briefs/B4-INT-report.md`. Sign Batch 4 in the log. **Gate W stays OPEN. Gate V stays OPEN.** Do not claim POLISH:PASS or V1 complete.
