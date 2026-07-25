# Popular Classic Skins, Fonts, and Statusbars

**Last updated:** 2026-07-25  
**Related:** [01-masque.md](01-masque.md), [02-libsharedmedia.md](02-libsharedmedia.md), [../03-visual-language-reference.md](../03-visual-language-reference.md).

---

## 1. Two aesthetic poles (Classic communities)

| Pole | Visual cues | Typical stack |
|------|-------------|---------------|
| **Classic-native / ornate** | Stone/dialog borders, gold trim, parchment, Friz/Morpheus, thicker chrome | Default UI + Questie + small helpers; ornate Masque skins |
| **Clean modern Classic** | 1px borders, flat fills, Expressway-class fonts, LSM statusbars, square minimap | ElvUI / Toxi-like profiles, Plater, WeakAuras, Details |

Sources for the ElvUI/clean side: [Tukui/ElvUI](https://tukui.org/elvui), [ElvUI media registration example](https://github.com/ElvUI-TBC/ElvUI/blob/master/ElvUI/media/sharedmedia.lua). Ornate Masque examples: [Caith](https://www.wowace.com/projects/masque-caith), [Onyx / Serenity / Entropy family](https://www.wowace.com/addons/action-bars).

Church of Beef brand (gothic cathedral / Scarlet / absurd holy steak — design spec §3.3) leans **theatrical Classic-native** for later art, while **V1 explicitly allows plain Classic frames** (spec §10).

---

## 2. Button skins people actually install

| Pack | Aesthetic | Why it matters |
|------|-----------|----------------|
| [Masque: Caith](https://www.wowace.com/projects/masque-caith) | Soft, larger Apathy-inspired | High-download StormFX skin; Classic-tagged repo ([GitHub](https://github.com/SFX-WoW/Masque_Caith)) |
| [Masque: Apathy](https://www.wowace.com/projects/masque-apathy) | Minimal recessed | Default “clean” taste for many bar setups |
| [Masque: Serenity / Onyx / Cirque / Entropy](https://www.wowace.com/addons/action-bars) | Varied polish | Same ecosystem; users swap without touching consumer addons |
| Suite-bundled looks | Match ElvUI / custom profiles | Often “flat square” bars rather than StormFX skins |

Masque’s wiki [Skin List](https://github.com/SFX-WoW/Masque/wiki/Skin-List) categorizes Compatible / Outdated / Incompatible — useful when recommending skins, not when shipping Beef.

---

## 3. Font packs and community favorites

| Source | What it provides | Link |
|--------|------------------|------|
| **LSM built-ins** | Friz Quadrata TT, Arial Narrow, Morpheus, Skurri | [API predefined fonts](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation) |
| **ElvUI Media** | Expressway / clean UI faces + textures registered into LSM | [ElvUI-TBC sharedmedia.lua](https://github.com/ElvUI-TBC/ElvUI/blob/master/ElvUI/media/sharedmedia.lua); [tukui-org/ElvUI](https://github.com/tukui-org/ElvUI) |
| **SharedMedia ClassicalFonts** | Classical-world style fonts into LSM | [CurseForge SharedMedia ClassicalFonts](https://www.curseforge.com/wow/addons/sharedmedia-classicalfonts/files/7206300) |
| **SharedMedia Extended / forks** | Large dumps of backgrounds, borders, fonts, statusbars, sounds | [SharedMediax](https://www.curseforge.com/wow/addons/sharedmediax) (Classic TBC flavor listed) |
| **Community lore** | Expressway called out as a long-time UI favorite | [WoWInterface “Calling all Fonts” thread](https://cdn.wowinterface.com/forums/showthread.php?t=33694) |

**Design takeaway:** Stream-readable Beef UI should prefer **high-contrast, large title type**. Morpheus reads “fantasy title”; Friz is the Classic body default; Expressway-class faces read “modern clean UI.” For V1, stay on Blizzard fonts. For V2 brand pass, a single distinctive display face (embedded + optional LSM register) beats a 100-font SharedMedia dependency.

---

## 4. Statusbar texture culture

Statusbars are how Classic UIs telegraph “modernized” health/power/cast strips:

- LSM built-in: `Blizzard`, skills bar ([API docs](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation)).
- ElvUI and SharedMedia packs add Smooth / Glaze / Melli-style bars (commonly referenced in ElvUI media trees and SharedMedia dumps — see [deep research dump](.raw/deep-masque-sharedmedia.md) §3).
- Players expect a **dropdown of statusbar keys** in any meter-like options panel.

Church of Beef should **not** dress the ladder as fake health bars (see [visual language](../03-visual-language-reference.md) — avoid Cell/VuhDo metaphors). If V2 adds a theatrical “standing / favor” strip, one embedded statusbar texture + LSM optional override is enough.

---

## 5. What not to depend on

| Dependency | Risk |
|------------|------|
| Full ElvUI install for media | Huge surface; Beef must work for default-UI players |
| Giant SharedMedia packs | License clutter, download size, locale font issues |
| Retail-only Masque profile features | Per-spec profiles called out as Retail-only ([Masque WowAce](https://www.wowace.com/projects/masque)) |
| Assuming Expressway is present | Only true if ElvUI or a font pack is installed |

---

## 6. Sources

- [Masque: Caith — WowAce](https://www.wowace.com/projects/masque-caith)
- [LibSharedMedia API — predefined media](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation)
- [SharedMedia ClassicalFonts — CurseForge](https://www.curseforge.com/wow/addons/sharedmedia-classicalfonts/files/7206300)
- [SharedMedia Extended — CurseForge](https://www.curseforge.com/wow/addons/sharedmediax)
- [ElvUI-TBC sharedmedia.lua](https://github.com/ElvUI-TBC/ElvUI/blob/master/ElvUI/media/sharedmedia.lua)
- [WoWInterface fonts discussion](https://cdn.wowinterface.com/forums/showthread.php?t=33694)
- [Masque Skin List](https://github.com/SFX-WoW/Masque/wiki/Skin-List)
