# B4-G — Event congregation petition / confess

**Exclusive:** create `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

**Do not edit** TOC, `run.lua`, `ChurchOfBeef.lua`, BeefNet, Console, Hud. Integrator lists the files after you. Do not commit. Do not invent a Pope name. Stock functional chrome. Event Mode only.

## Law

Bible §13.1, §18.5, §19.1. Congregation clients are display terminals **plus input devices**. Inputs never trigger public theater.

```lua
Inputs:Init()
Inputs:SetInputTarget(name)          -- whisper destination; no Pope lookup
Inputs:SetLocalCharacterId(id)
Inputs:Petition()                    -- Net:SendPetition({ characterId }, target)
Inputs:Confess(text)                 -- Net:SendConfession({ characterId, text }, target)
Inputs:Show() / Hide() / Refresh()
Inputs:GetView()                     -- copy
Inputs:ResetForTests()
```

- `MODE = "Event"`. Runtime QUIET or missing → Show/Petition/Confess return false; frame hidden. No Quiet chrome.
- Missing target → `false, "no target"`. Missing local character id → `false, "no character"`.
- Call Net only. Do not call Gora:Petition locally. Do not Proclaim. Do not PlaySound. Do not SendChatMessage.
- Stock `UIPanelButtonTemplate` labels: `Petition`, `Confess`. Optional stock EditBox for confession text (InputBoxTemplate). No jokes.
- Do not look up `Data/Popes.lua`.

## Tests

Isolated: wow_ui_stub + Common + Runtime + Inputs. Stub `COB.Net.SendPetition` / `SendConfession`. Quiet refuse. StartEvent + target + id → Petition spies Net. Confess spies text. GetView copy. Isolation wrap.

`lua tests/test_inputs.lua` exit 0.

Report `docs/reformation/vestments/briefs/B4-G-congregation-inputs-report.md` + diff.
