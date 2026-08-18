# W-E / W-F — WoW API pin (classic_anniversary / 20506)

Read-only pin for Console and HUD reviewers. Flavor **classic_anniversary**, build **2.5.6.68575**, `## Interface: 20506`. Source: `project-0-Beef_Addon-wow-api` (`get_api`, `search_source`, `get_source_file`, `diff_api`, `search_wiki`, `get_wiki_page`). Do not invent product answers. Do not treat this as a license to add Net calls, custom media, or SecureActionButton.

| API / template | classic_anniversary | Where confirmed |
|---|---|---|
| `CreateFrame` | **Exists as FrameXML/Lua global. Not in `get_api`.** | `get_api` / `search_api`: no documented function. FrameXML: `WorldMapMixin:AddOverlayFrame` → `CreateFrame(templateType, nil, self, templateName)` (`Blizzard_WorldMap/Wrath/Blizzard_WorldMap.lua:310`). Wiki `API:CreateFrame`: `CreateFrame(frameType [, name [, parent [, template [, id]]]])` since 1.10; types include Frame, Button, CheckButton, EditBox, StatusBar. |
| `UICheckButtonTemplate` | **Yes** (virtual XML) | `Blizzard_SharedXML/Shared/Button/CheckButtonTemplates.xml:50` `virtual="true"`. Live inherit: TradeSkill `inherits="UICheckButtonTemplate"` (`Blizzard_TradeSkillUI/Wrath/Blizzard_TradeSkillUI.xml:155`) + `self:GetChecked()` on OnClick. |
| `SetChecked` / `GetChecked` | **Yes** | `get_api`: `SimpleCheckboxAPI`. `SetChecked([checked])`, `checked = GetChecked()`. All four flavors. |
| `InputBoxTemplate` | **Yes** | `Blizzard_SharedXML/SecureUIPanelTemplates.xml:69` `EditBox` `virtual="true"`. Console already uses this inherit. |
| `UIPanelButtonTemplate` | **Yes** | `Blizzard_SharedXML/Classic/SharedUIPanelTemplates.xml:348` `virtual="true"`. Console already uses this inherit. |
| `BasicFrameTemplate` | **Yes** | `Blizzard_UIPanelTemplates/Classic/UIPanelTemplates.xml:724` `virtual="true"` (inherits `BaseBasicFrameTemplate`). Console / MainFrame already use this inherit. |
| `BackdropTemplate` | **Yes** | `Blizzard_SharedXML/Backdrop.xml:5` `virtual="true"` + `BackdropTemplateMixin`. HUD already inherits it. |
| `CreateFrame("StatusBar")` + bar mutators | **Yes** | FrameXML: `CreateFrame("StatusBar")` (`Blizzard_Menu/Compositor.lua:191`). `get_api` `SimpleStatusBarAPI`: `SetMinMaxValues(min, max [, interpolation])`, `SetValue(value [, interpolation])`, `SetStatusBarColor(r, g, b [, a])`, `success = SetStatusBarTexture(asset)`. All four flavors. Wiki `UIOBJECT StatusBar`: `CreateFrame("StatusBar")`. |
| Stock bar texture (no custom media) | **`Interface\\TargetingFrame\\UI-StatusBar`** | FrameXML mana bar fallback (`Blizzard_UnitFrame/Classic/UnitFrame.lua:480`). Wiki StatusBar example uses the same path (`Interface/TargetingFrame/UI-StatusBar`). Also already in-tree for chrome (not the bar): `Interface\\Buttons\\WHITE8X8`, `Interface\\Tooltips\\UI-Tooltip-Border`. |
| `C_ChatInfo.SendAddonMessage(prefix, message, chatType, target)` | **Yes** | `get_api` + `ChatInfoDocumentation.lua:358–373`: `result = C_ChatInfo.SendAddonMessage(prefix, message, [chatType], [target])`. `chatType` is optional `cstring` (“ChatType, defaults to SLASH_CMD_PARTY”). `target` “Only applies for targeted channels”. All four flavors. |
| chatType `"WHISPER"` | **Yes (wiki + in-tree)** | Wiki `API:C_ChatInfo.SendAddonMessage` chat-type table: `"WHISPER"` ✔️ Retail and Classic; `target` = player name. Official docs do **not** enumerate the string list. BeefNet already sends `"WHISPER"` (`Net/BeefNet.lua`). Do **not** use `"CHANNEL"` — wiki marks CHANNEL ❌ on Classic; ceremony-runtime already forbids custom CHANNEL. |
| 255-byte body cap | **Wiki + in-tree. Not in official docs.** | Official `ChatInfoDocumentation.lua` does **not** state a byte cap. Wiki: prefix ≤ 16 chars; message ≤ **255** characters (ASCII 1–255, no NULL). BeefNet already comments the 255 cap and uses `MAX_BODY = 240`. Prefix register: `C_ChatInfo.RegisterAddonMessagePrefix` exists (`get_api`, all four flavors). |
| `EnableMouse` | **Yes** (Frame and Button) | `get_api` `SimpleScriptRegionAPI`: `EnableMouse([enable])`. All four flavors. |
| `OnClick` | **Button only** | Wiki `Widget script handlers`: `OnClick` is listed under **Button**, not Frame. Frame mouse scripts are `OnMouseDown` / `OnMouseUp`. `RegisterForClicks` is `SimpleButtonAPI` (`get_api`). Wiki `UIHANDLER OnClick`: handler `self` is a Button; default `"LeftButtonUp"`. |
| Safer plate-click (no SecureActionButton) | **`CreateFrame("Button")` + `EnableMouse` + `OnClick`** | Frame + `EnableMouse` + `OnClick` will not fire (no OnClick on Frame). Overlay a plain `Button` (no template, or `UIPanelButtonTemplate` if chrome is wanted). Do **not** inherit `SecureActionButtonTemplate` (`Blizzard_FrameXML/SecureTemplates.xml:4`) or `InsecureActionButtonTemplate` (same file:13). Product frames stay insecure. |
| `C_Timer.After` | **Yes** | `get_api`: `C_Timer.After(seconds, callback)` — UITimer. `diff_api`: same signature on live / classic / classic_era / classic_anniversary. Also on this flavor: `C_Timer.NewTicker`, `C_Timer.NewTimer`. There is **no** documented `C_Timer()` constructor (`get_api "C_Timer"` misses). Prefer `After` for one-shots. No `OnUpdate`. |

## Must not use (Retail-missing or product-forbidden)

These are the ones W-E / W-F will trip on. Some **exist** on 20506 and are still forbidden.

| Name | On classic_anniversary? | Why W-E/W-F must not |
|---|---|---|
| `C_TooltipInfo.*` | **No** (`diff_api` live only) | Will error. |
| `CreateFramePool` | **No** (not in any flavor’s `get_api`) | Will error. |
| `GetMouseFocus` | **No** in docs | Use nothing here; HUD plates do not need mouse-focus polling. (`GetMouseFoci` *does* exist — still do not scrape.) |
| `Settings.RegisterAddOnSetting` | Not in `get_api` any flavor | No settings panel (W-E law). |
| `SecureActionButtonTemplate` / `InsecureActionButtonTemplate` | **Yes** (FrameXML) | Taint / protected actions. Insecure `Button` only. |
| `UnitHealth` / `C_NamePlate.GetNamePlateForUnit` | **Yes** (`get_api`) | Product: HUD `health` stays nil. No nameplate scrape. Existence ≠ license. |
| `C_Sound.PlaySound` | **Yes** (`get_api`; classic_era ✗) | W-F: no `PlaySound`. Quiet/HUD stay silent. |
| `OnUpdate` | Handler exists (wiki Frame) | Both briefs: no `OnUpdate`. Use `C_Timer.After`. |
| `"CHANNEL"` addon chat | Wiki: Classic ❌ | Forbidden on this project. Favor whisper is `"WHISPER"`. |
| Custom `.tga` / `.blp` / `.ttf` | n/a | Stock paths only. StatusBar: `Interface\\TargetingFrame\\UI-StatusBar`. |
| `UIParent:SetScale` | n/a | W-E / juice law. |

`WowStyle1DropdownTemplate`, `GenerateClosure`, `PixelUtil`, `MenuUtil.lua`, and `TooltipDataProcessor` appear in Anniversary FrameXML. That does **not** mean W-E/W-F should adopt them. Stick to the stock templates above.

## Safe vs forbidden (six lines)

1. **Safe frames:** `CreateFrame` (Lua global; not in `get_api`) with `CheckButton`+`UICheckButtonTemplate`, `EditBox`+`InputBoxTemplate`, `Button`+`UIPanelButtonTemplate`, `Frame`+`BasicFrameTemplate` / `BackdropTemplate`.
2. **Safe checkbox:** `SetChecked` / `GetChecked` (`SimpleCheckboxAPI`).
3. **Safe favor bar:** `CreateFrame("StatusBar")` + `SetMinMaxValues` / `SetValue` / `SetStatusBarColor` / `SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")`.
4. **Safe whisper:** `C_ChatInfo.SendAddonMessage(prefix, message, "WHISPER", target)`; body ≤ 255 (wiki; BeefNet uses 240); prefix ≤ 16; register prefix first.
5. **Safe plate click:** insecure `CreateFrame("Button")` + `EnableMouse(true)` + `SetScript("OnClick", …)`. Not Frame+OnClick. Not SecureActionButton.
6. **Forbidden:** `C_TooltipInfo`, `CreateFramePool`, Secure/InsecureActionButton, `UnitHealth` / nameplates, `C_Sound.PlaySound`, `OnUpdate`, `"CHANNEL"`, custom media, `UIParent:SetScale`. `C_Timer.After` is known-good.
