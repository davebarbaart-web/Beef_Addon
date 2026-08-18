# V-stock — TBC Anniversary (20506) stock paths

Read-only FrameXML/`search_source` on flavor `classic_anniversary` (build **2.5.6.68575**). Always `pcall` `SetTexture` / `SetFont`; on miss, **WHITE8X8 fill** + `GameFont*`. No addon Lua. No commit.

## 1. Quest / stationery parchment — SAFE

| Path | Evidence |
|------|----------|
| `Interface\QuestFrame\QuestBG` | TBC `QuestScrollFrameAndPanelTemplates.xml` (`file=` on `$parentBg`) |
| `Interface/Stationery/stationerytest1` | Classic `MailFrame.lua` `SendStationeryBackgroundLeft:SetTexture` |
| `Interface/Stationery/stationerytest2` | same file, `SendStationeryBackgroundRight` |

Prefer **QuestBG** as a single fill. Stationery is a L/R pair (mail). `QuestPortrait` is portrait art, not a page fill.

## 2. Gold / iron edges — SAFE

| Path | Use | Evidence |
|------|-----|----------|
| `Interface\DialogFrame\UI-DialogBox-Border` | gold-ish 32px edge | Classic `LootFrame.lua` `SetBackdrop` |
| `Interface\DialogFrame\UI-DialogBox-Background` | dialog fill | same |
| `Interface\Tooltips\UI-Tooltip-Border` | thinner iron edge | `Blizzard_SharedXML/Backdrop.lua` `BACKDROP_TUTORIAL_16_16` |
| `Interface\Tooltips\UI-Tooltip-Background` | tooltip fill | same file |

**`Interface\Buttons\WHITE8X8`:** FrameXML `search_source` = **UNCONFIRMED**. Wiki (`UIOBJECT VertexColor`, resizable-frames) cites `WHITE8X8` / `White8x8`. **Prefer as 1px gold/iron rules** (`SetVertexColor`); `pcall` then vertex-color a blank texture.

`UI-DialogBox-Gold-Border`: **UNCONFIRMED** — do not use.

## 3. Seal / ring — not faction

| Path | Evidence |
|------|----------|
| `Interface\Buttons\UI-EmptySlot-White` | Classic `MailFrame.xml` attachment slot |
| `Interface\Minimap\MiniMap-TrackingBorder` | `Blizzard_WorldMapTemplates.xml` |

Tint gold. **UNCONFIRMED:** `UI-Quickslot2` (only Wrath `WatchFrame.xml` in this checkout) — skip; use EmptySlot / TrackingBorder / WHITE8X8 disc.

**FORBID (faction):** `Interface\TargetingFrame\UI-PVP-Alliance` / `UI-PVP-Horde` (Wrath `QuestInfo.lua`); `Quest-Alliance-WaxSeal` / `QuestBG-Alliance` atlases; `Interface\PVPFrame\…` crests; `PlusManz-Horde` / `PlusManz-Alliance`.

## 4. Title fonts — exist as client fonts

Roman members in **FrameXML** (not the Retail wiki font table, which is Patch 11.2):

| File | Role | Evidence |
|------|------|----------|
| `Fonts\FRIZQT__.TTF` | UI body | `Blizzard_Fonts_Shared/Classic/Fonts.xml`, `Classic/GameFonts.xml`; PTR `SetFont` |
| `Fonts\MORPHEUS.ttf` | fancy / quest title | Classic `Fonts.xml` `QuestFont_Larger`; Shared `GameFonts.xml` `QuestFont_Shadow_Small` |
| `Fonts\skurri.ttf` | huge outlined **numbers** | Shared `GameFonts.xml` `NumberFont_Outline_Huge` |

`SetFont` exists on 20506 (`SimpleFontStringAPI`). Match FrameXML casing (`MORPHEUS.ttf`, `skurri.ttf`). Titles: **MORPHEUS**, then FRIZQT, then `GameFontNormalHuge`. SKURRI is combat-number voice, not ecclesiastical.

## 5. StatusBar (HUD)

`Interface\TargetingFrame\UI-StatusBar` — already `Hud.lua` `STOCK_BAR`. Confirmed: Classic `PlayerFrame.xml` `fillTexture`; Classic `CastingBarFrame.xml` `<BarTexture>`. `SetStatusBarTexture` exists on 20506.

## 6. Retail / WotLK — FORBID

| Path / family | Why |
|---------------|-----|
| `Interface\AchievementFrame\UI-Achievement-Parchment-Horizontal` | `Blizzard_AchievementUI/Classic` XML. TOC `## Interface: 30001`, not 20506 |
| Other `Interface\AchievementFrame\…` | same addon; not TBC art |
| Wrath quest wax-seal / faction atlases | `Wrath/QuestInfo.lua` |
| Atlas inherits (`!UI-Frame-…`) | not `SetTexture` file paths |

Missing path → **UNCONFIRMED** → WHITE8X8 fill. Do not add `Media\` requirements.
