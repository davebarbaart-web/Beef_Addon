# Visual Language: Classic-Native vs Retail-Modern

**Last updated:** 2026-07-25  
**Sources:** [Tukui/ElvUI](https://tukui.org/elvui), Anniversary addon guides, Blizzard Watch Classic UI modernization (Jul 2026).

---

## 1. Two aesthetic poles in Classic communities

| Pole | Look | Typical stack |
|------|------|----------------|
| **Classic-native / nostalgia** | Stone borders, gold trim, parchment, thicker art, default fonts closer to 2006–07 | Default UI + Questie + DBM + small helpers; “default looks better” camp |
| **Clean modern Classic** | Flat panels, thin borders, statusbar textures (LibSharedMedia), pixel fonts, square minimap, hidden blizzard art | ElvUI / Toxi-like profiles, Plater, WeakAuras, Details |

Neither is wrong. Church of Beef brand (gothic cathedral / Scarlet / absurd holy steak) leans **theatrical Classic-native chrome**, but V1 explicitly allows **plain Classic frames** with theatrical pass later (spec §10).

---

## 2. What top overhauls “feel like”

### ElvUI (Tukui)

- **Role:** Full UI replacement — unit frames, bars, bags, chat, nameplates, datatexts under one style.
- **Visual DNA:** Consistent backdrop/border/statusbar; installer layouts including **Anniversary layout** (ElvUI 14.00, Sep 2025); ClassicTheme tank/healer screenshots on Tukui.
- **Classic maintenance:** Active Classic-variant fixes (castbars, dual-spec profiles on Anniversary, role icons, etc. per Tukui changelog).
- **Why players love it:** One settings language; importable profiles; replaces many small addons.
- **Why players hate it:** Setup overwhelm; “everything looks like ElvUI”; performance blame (sometimes unfair).

**Adapt for Beef:** Unified backdrop/border tokens later; installer wizard is overkill for V1; optional “simple / ornate” skin flag is a V2 idea.

### Bartender4 / Dominos

- Action-bar specialists. Feel Classic when they keep button art; feel modern when bars are borderless icon strips.
- **Adapt:** N/A for combat bars; mobility/fade patterns irrelevant.

### Plater

- Nameplate scripting + profile sharing. High information density, modern flat plates.
- **Adapt:** Avoid nameplate-like density in social UI.

### WeakAuras

- Custom overlays; Wago import culture; “your screen is a dashboard.”
- **Adapt for V2+:** Ceremony spotlight / toast choreography — short-lived, center-weighted, then gone.

### Details!

- Meter windows: dense tables, opaque panels, combat-log driven.
- **Adapt:** Officer standing breakdown can be a **simple event list**, not a meter.

### Questie

- Map/minimap pins, tooltips, Classic fantasy readability.
- **Adapt:** Clarity of icons/pins > ornament for functional V1.

### AtlasLoot Classic / Auctionator

- Windowed browsers with tabs, search, dense rows.
- **Adapt:** Ladder + officer queue = lightweight version of “tabbed tool window,” not auction spreadsheet.

### Cell / VuhDo

- Healer frames: compact grids, debuff icons, click targets.
- **Adapt:** Do not make the ladder look like raid frames (no fake health bars for “standing”).

---

## 3. Signals of “Classic-native” vs “retail HUD”

| Signal | Classic-native | Retail-modern |
|--------|----------------|---------------|
| Borders | Blizzard dialog / stone | 1px black border + solid fill |
| Fonts | Friz Quadrata / default | Pixel/expressway via LSM |
| Windows | `UIPanel` style, close craft | Floating frameless panels |
| Color | Faction gold/brown, class sparingly | Neon class colors everywhere |
| Motion | Rare | Constant WA pulses |
| Edit Mode | Optional | Expected on modern Classic clients |

**Beef guidance:** V1 = default fonts + simple frames (spec: fallback if media missing). V2 theatrical pass = Scarlet/cathedral textures **without** requiring LibSharedMedia. Never depend on retail Edit Mode APIs for core UX.

---

## 4. Stream / spectacle readability

Church of Beef is streamer-event adjacent (spec §1). Visual lessons from clean-UI and raid-HUD culture:

- High contrast text for on-stream readability.
- Large enough title/rank type for Twitch 720p.
- Avoid translucent gray-on-gray panels.
- Prefer **one toast** over stacked WA-like spam.
- Guild chat announcement remains the cheapest spectacle (spec §10).

---

## 5. ElvUI coexistence

Many Beef players will run ElvUI. Design for peaceful coexistence:

- Do not skin Blizzard frames globally.
- Use a unique frame name / strata; save position.
- Avoid assuming default chat frame indices.
- Minimap button should work with button collectors.
- Don’t fight ElvUI’s bag/chat modules.

---

## Sources

- [ElvUI — Tukui](https://tukui.org/elvui) (incl. Anniversary layout / Classic changelog notes)
- [Overgear TBC Anniversary addons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)
- [Blizzard Watch — Classic UI modernization](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)
