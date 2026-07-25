# Brandable Visual Systems in Classic UI

**Last updated:** 2026-07-25  
**Question:** How do Classic addons make a recognizable look without exploding install requirements?

---

## 1. Three strategies

| Strategy | How it works | Pros | Cons |
|----------|--------------|------|------|
| **A. Embedded** | Ship fonts/textures inside the addon folder; hard-code paths | Works offline of ecosystem; consistent brand | Size; users cannot restyle; you maintain assets |
| **B. Dependent** | Require Masque / LSM / SharedMedia packs | Small core; user theming | Fragile installs; blank UI if deps missing |
| **C. Hybrid (ecosystem norm)** | Embedded baseline + optional LibStub hooks | Default looks good; power users theme | Slightly more branches to test |

Evidence for the hybrid norm:

- Masque is opt-in via LibStub; consumers skip it when absent ([API_VERSION optional LibStub](https://github.com/SFX-WoW/Masque/wiki/API_VERSION); [Masque does not skin default UI alone](https://legacy-wow.com/mop-addons/masque/)).
- LSM `Fetch(..., noDefault)` can return nil — callers must carry Blizzard fallbacks ([API docs](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation)).
- ElvUI registers its own media into LSM **from inside** `ElvUI/Media` rather than requiring a separate SharedMedia install ([ElvUI-TBC sharedmedia.lua](https://github.com/ElvUI-TBC/ElvUI/blob/master/ElvUI/media/sharedmedia.lua)).

Mature addons (WeakAuras, Bagnon, bar addons) almost always choose **C**.

---

## 2. What “brandable” means in this ecosystem

Players experience brand through stacked layers:

1. **Panel chrome** — dialog / tooltip / custom backdrop (LSM BACKGROUND + BORDER or Blizzard templates).
2. **Typography** — title vs body faces (LSM FONT or `Fonts\*.TTF`).
3. **Meters / fills** — statusbar textures (LSM STATUSBAR).
4. **Buttons / icons** — Masque skins or Blizzard button borders.
5. **Unique art** — addon-specific icons, toasts, minimap glyph — the only layer competitors cannot theme away.

If layers 1–4 are 100% user-themed and layer 5 is empty, the addon vanishes into ElvUI gray. If layers 1–4 are forced brand chrome that fights ElvUI, users call it “ugly / unskinnable.” Hybrid = own layer 5 always; soft-style 1–4.

---

## 3. Fallback contract (matches Beef spec)

Design spec §10 / §11: missing fonts/textures must fall back; addon still loads; frame always appears.

Operational checklist for any future media work:

| Dependency | Missing behavior |
|------------|------------------|
| Masque | Use Blizzard/normal textures; no error |
| LibSharedMedia | Use `Fonts\FRIZQT__.TTF` / `UI-StatusBar` / dialog borders |
| Custom `.tga` / `.blp` | Skip ornate backdrop; solid or Blizzard dialog background |
| Custom font file | Friz / default UI font objects |

Never gate `/beef` frame creation on media load success.

---

## 4. Soft-dependency TOC culture

Classic packaging commonly lists optional libs as `## OptionalDeps` / `## X-Embeds` rather than hard `## Dependencies` (see library packaging norms in sibling [04-ace3-and-libraries.md](../04-ace3-and-libraries.md)). For visuals:

- **Hard-deps Masque/LSM:** wrong for a social guild addon.
- **OptionalDeps + runtime LibStub:** correct if V2 adds hooks.
- **Separate optional media addon** (`ChurchOfBeef_Media` or `SharedMedia_ChurchOfBeef`): good if brand art grows large — keeps core small, lets streamers skip fat assets.

---

## 5. Coexistence rules (ElvUI / Masque users)

From sibling visual language research and Masque’s non-global mandate:

1. Do not globally skin Blizzard frames.
2. Use unique frame names and strata; save position.
3. Prefer self-contained backdrop over hijacking ElvUI’s look.
4. If offering Masque groups, namespace them (`ChurchOfBeef`, `LadderIcons`) so users can theme Beef separately from Bartender.

---

## 6. Sources

- [Masque — WowAce](https://www.wowace.com/projects/masque)
- [Masque API_VERSION](https://github.com/SFX-WoW/Masque/wiki/API_VERSION)
- [LibSharedMedia API](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation)
- [ElvUI-TBC media registration](https://github.com/ElvUI-TBC/ElvUI/blob/master/ElvUI/media/sharedmedia.lua)
- [Church of Beef design spec §10–11](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)
