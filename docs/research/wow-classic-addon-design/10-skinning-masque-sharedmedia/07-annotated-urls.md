# Annotated URLs — Skinning / Masque / SharedMedia

**Last updated:** 2026-07-25  
**Track:** [10-skinning-masque-sharedmedia](README.md)  
**Usage:** Prefer these primaries over “best UI packs” listicles. Steal/adapt notes are for Church of Beef skinning strategy — see [06-church-of-beef-adopt-vs-invent.md](06-church-of-beef-adopt-vs-invent.md).

**Not listed here on purpose:** BLP/TGA/SetTexture packaging ([44](../44-custom-textures-media-packaging/)); brand hex tokens ([23](../23-color-brand-tokens/)); sound registration detail ([20](../20-sound-sfx-feedback/)); soft-dep TOC/pkgmeta mechanics ([42](../42-soft-deps-embeds/)).

---

## Masque (engine)

| URL | Annotation | Steal / adapt |
|-----|------------|---------------|
| https://www.wowace.com/projects/masque | Canonical project page: library-based button skinning, `/msq`, mirrors. | Mental model: Beef is a *consumer* later, never a fork of the engine. |
| https://www.curseforge.com/wow/addons/masque | Install flavors including **Classic TBC**; download scale. | Confirm Classic TBC flavor exists for Anniversary guildies who already use Masque. |
| https://www.curseforge.com/wow/addons/masque/files/all | Flavor filter (Classic, Classic TBC, MoP, Retail, Titan Reforged). | At ship time, verify Interface stamp near Beef’s `20506` (drift is normal). |
| https://github.com/SFX-WoW/Masque | Source, changelog, Classic topic tags. | Read release notes before adding soft hooks. |
| https://github.com/SFX-WoW/Masque/wiki | Docs hub (wiki incomplete in places). | Start here; treat gaps as “verify in source.” |
| https://github.com/SFX-WoW/Masque/wiki/Skin-List | Compatible vs outdated vs incompatible skins. | User-support pointer; not a Beef packing list. |
| https://github.com/SFX-WoW/Masque/wiki/API_VERSION | Soft `LibStub("Masque", true)` + skin `API_VERSION` field. | **V2 pattern:** optional LibStub; never hard-dep. |
| https://www.wowinterface.com/downloads/info12097-Masque.html | Alternate mirror; release notes (e.g. TBC Interface 20505 in 12.0.5). | Cross-check Classic TBC Interface history. |
| https://addons.wago.io/addons/masque | Wago distribution mirror. | Same product; different host for streamer installs. |
| https://legacy-wow.com/mop-addons/masque/ | Explicit: Masque does **not** skin default UI alone — needs a consumer. | V1 implication: plain Blizzard frames need no Masque. |
| https://github.com/bkader/Masque-WoTLK | Historical 3.3.5 backport. | History only — **not** Anniversary packaging. |

### Masque skins (taste references)

| URL | Annotation | Steal / adapt |
|-----|------------|---------------|
| https://www.wowace.com/projects/masque-caith | Caith — popular larger/soft skin; Classic-capable. | User taste reference; do **not** ship inside Beef. |
| https://github.com/SFX-WoW/Masque_Caith | Caith source; `wow-classic` topic. | Skin-table structure if a vanity `Masque_ChurchOfBeef` appears in V2+. |
| https://www.wowace.com/projects/masque-apathy | Apathy — minimal recessed look. | Opposite pole from ornate Scarlet chrome. |
| https://www.wowace.com/addons/action-bars | Catalog listing Serenity / Onyx / Cirque / Entropy beside Masque. | Ecosystem map of skin names players already know. |
| https://github.com/SFX-WoW | StormFX org — other official skins. | Prefer maintained skins when linking users. |

---

## LibSharedMedia & media packs

| URL | Annotation | Steal / adapt |
|-----|------------|---------------|
| https://www.wowace.com/projects/libsharedmedia-3-0 | LSM hub; Classic TBC files on CurseForge mirror. | Soft peer only; V1 never requires it. |
| https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation | **Must-read:** Register/Fetch, types, predefined Blizzard media, naming rules. | Adopt type vocabulary + Fetch fallbacks; see [02](02-libsharedmedia.md). |
| https://www.curseforge.com/wow/addons/libsharedmedia-3-0 | Flavors + current builds (active 2026). | Confirm Classic TBC file before documenting OptionalDeps. |
| https://www.curseforge.com/wow/addons/sharedmediax | SharedMedia Extended — large Classic/TBC media dump example. | Proof packs exist; **skip** as hard dep. |
| https://www.curseforge.com/wow/addons/sharedmedia-classicalfonts/files/7206300 | Classical-style fonts into LSM — brand-adjacent reference. | Mood for V2 display faces; not a runtime requirement. |
| https://github.com/NoM0Re/SharedMedia | Example SharedMedia pack repo layout. | Layout reference if splitting `ChurchOfBeef_Media`. |
| https://www.wowace.com/addons/ace-gui-3-0-shared-media-widgets | AceGUI widgets for LSM dropdowns. | Only if Ace options land (track 03 / 42); not V1. |

---

## ElvUI / clean UI media patterns

| URL | Annotation | Steal / adapt |
|-----|------------|---------------|
| https://tukui.org/elvui | ElvUI distribution; Anniversary layouts exist in broader ecosystem. | Coexistence target — never a dependency. |
| https://github.com/tukui-org/ElvUI | Upstream media/module structure. | How large UIs keep Media/ in-tree. |
| https://github.com/ElvUI-TBC/ElvUI/blob/master/ElvUI/media/sharedmedia.lua | **Pattern to copy conceptually:** register blank/glow media from inside addon. | V2 hybrid: embed Church art → optional LSM Register. |
| https://cdn.wowinterface.com/forums/showthread.php?t=33694 | Community font lore (Expressway favorite callout). | Clean-UI pole; Friz remains V1 default. |

---

## Icon framing & quality colors

| URL | Annotation | Steal / adapt |
|-----|------------|---------------|
| https://warcraft.wiki.gg/wiki/ItemQuality | Quality enum / color language players already know. | Use for **items**; do not ID ranks 1:1 ([04](04-icon-framing.md), [06](06-church-of-beef-adopt-vs-invent.md)). |
| https://warcraft.wiki.gg/wiki/API_TYPE_ItemQuality | API typing for quality colors. | Runtime tinting reference if showing loot-like widgets. |
| https://github.com/WeakAuras/WeakAuras2/issues/2243 | Desire for action-button border framing on icons. | Players expect Blizzard-style borders on non-action icons. |
| https://www.wowinterface.com/downloads/info25064-CleanIcons-MechagnomeEdition.html | Global clean-icon packs change icon mats. | Don’t assume default icon padding in custom seals. |
| https://www.reddit.com/r/WowUI/comments/zcpsvs/help_how_do_i_apply_default_actionbar_borders_to/ | Masque + Blizzard bars coexistence anecdotes. | Soft-hook QA: Beef must not break bar skins. |
| https://us.forums.blizzard.com/en/wow/t/drawing-rectangles-for-borders/1189042 | DIY panel border approaches (backdrop vs textures). | V1 zero-`Media/` chrome bridge (detail in [44](../44-custom-textures-media-packaging/)). |

---

## Product truth (repo)

| Path | Why |
|------|-----|
| [V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §3.3, §10–§11, §13–§14 | Brand tone, plain V1 UI, media fallbacks, phase map. |
| [06-church-of-beef-adopt-vs-invent.md](06-church-of-beef-adopt-vs-invent.md) | Locked V1 no-hard-dep stance + phased roadmap. |
| [03-visual-language-reference.md](../03-visual-language-reference.md) | Classic-native vs clean modern poles; ElvUI coexistence. |
| [04-ace3-and-libraries.md](../04-ace3-and-libraries.md) | Historical LSM soft-dep note; depth now in 02 + 42. |
| [42 beef-v1-dependency-policy](../42-soft-deps-embeds/beef-v1-dependency-policy.md) | Masque/LSM = soft-only / V1 deny as requirement. |
| [23-color-brand-tokens](../23-color-brand-tokens/) | Scarlet/gold/parchment accents under any chrome. |
| [44-custom-textures-media-packaging](../44-custom-textures-media-packaging/) | How to ship `.tga`/`.blp` when Media/ lands. |
| [20-sound-sfx-feedback](../20-sound-sfx-feedback/) | SOUND type packaging; not visual skinning. |

---

## Steal / skip cheat sheet

| Steal | Skip |
|-------|------|
| LSM type names + Fetch fallbacks | Hard SharedMedia pack dependency |
| Optional Masque group pattern (`LibStub(..., true)`) | Building a skinning engine; V1 Masque code |
| ElvUI “register own media” habit | Requiring ElvUI |
| Blizzard Friz/Dialog defaults for V1 | Item-quality colors as rank IDs |
| Caith/Apathy as *user* taste references | Shipping those skins inside Beef |
| Unique frame names + self-contained backdrop | Globally skinning Blizzard UI |
| Guild-chat + toast spectacle (spec §10) | Ceremony chrome as V1 success criteria |

---

## Deliberately not primary here

| Topic | Better track |
|-------|--------------|
| BLP/TGA/PoT, SetTexture, minimap path strings | **44** |
| Brand hex / class / faction / a11y contrast | **23** |
| `.ogg` registration and overused SFX | **20** |
| TOC OptionalDeps / embeds / pkgmeta | **42** |
| AceConfig options trees | **03** |
| Stream safe-zones / toast duration | **17** |

---

## Provenance dumps

Raw Parallel search/extract under [`.raw/`](.raw/):

| File | Contents |
|------|----------|
| [`.raw/deep-masque-sharedmedia.md`](.raw/deep-masque-sharedmedia.md) | Parallel deep-research dump (temper V2 invent ideas via [06](06-church-of-beef-adopt-vs-invent.md)) |
| [`.raw/deep-masque-sharedmedia.json`](.raw/deep-masque-sharedmedia.json) | Research metadata / basis |
| [`.raw/search-masque.json`](.raw/search-masque.json) | Masque project / Classic flavor search |
| [`.raw/search-masque-api.json`](.raw/search-masque-api.json) | Masque API / LibStub search |
| [`.raw/search-libsharedmedia.json`](.raw/search-libsharedmedia.json) | LSM API / packs search |
| [`.raw/search-skins-fonts.json`](.raw/search-skins-fonts.json) | Skins / fonts / statusbars search |
| [`.raw/search-icon-framing.json`](.raw/search-icon-framing.json) | Quality borders / icon framing search |
