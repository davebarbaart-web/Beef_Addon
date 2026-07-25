# Track 10 — Skinning, Masque, SharedMedia, Fonts, Iconography

**Last updated:** 2026-07-25  
**Scope:** How Classic UI addons brand and theme visuals — button skins, shared media, fonts, statusbars, icon frames.  
**Client focus:** TBC Classic Anniversary (V1).  
**Hard rule:** Design/ecosystem knowledge only. No Church of Beef implementation.  
**Status:** Complete for gap-audit P1 — synthesis in [06](06-church-of-beef-adopt-vs-invent.md) + primaries in [07](07-annotated-urls.md).

**Does not cover:** BLP/TGA packaging ([44](../44-custom-textures-media-packaging/)); brand hex tokens ([23](../23-color-brand-tokens/)); sound packs ([20](../20-sound-sfx-feedback/)); TOC/embed policy ([42](../42-soft-deps-embeds/)).

## Read order

| Doc | Topic |
|-----|--------|
| [01-masque.md](01-masque.md) | Masque engine, Classic flavors, group API, popular skins |
| [02-libsharedmedia.md](02-libsharedmedia.md) | LibSharedMedia-3.0 types, Register/Fetch, built-ins, callbacks |
| [03-skins-fonts-statusbars.md](03-skins-fonts-statusbars.md) | Popular Classic packs, clean vs ornate poles, ElvUI media |
| [04-icon-framing.md](04-icon-framing.md) | Quality borders, overlays, button region conventions |
| [05-brandable-visual-systems.md](05-brandable-visual-systems.md) | Embed vs soft-depend vs hybrid; fallbacks |
| [06-church-of-beef-adopt-vs-invent.md](06-church-of-beef-adopt-vs-invent.md) | Adopt vs invent + locked V1 no-hard-dep stance (mapped to V1/V2) |
| [07-annotated-urls.md](07-annotated-urls.md) | Annotated primary URLs with steal/adapt notes |

## Provenance

| Artifact | Role |
|----------|------|
| [`.raw/deep-masque-sharedmedia.md`](.raw/deep-masque-sharedmedia.md) | Parallel deep-research report (pro-fast) |
| [`.raw/deep-masque-sharedmedia.json`](.raw/deep-masque-sharedmedia.json) | Research metadata / basis |
| [`.raw/search-*.json`](.raw/) | Parallel web-search captures |

Deep research invented some V2 ceremony metaphors (worship-tier overlays, liturgy calendar, ship-a-Masque-skin-by-default). Those are **not** V1 product requirements — see [06](06-church-of-beef-adopt-vs-invent.md) for the tempered mapping against the [approved design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md). Soft-dep alignment: [42 beef-v1-dependency-policy](../42-soft-deps-embeds/beef-v1-dependency-policy.md).

## One-line verdict

**V1:** Blizzard defaults + hard fallbacks; **no hard Masque/LSM dependency** (locked in [06](06-church-of-beef-adopt-vs-invent.md) §0). Spectacle = guild-chat + toasts.  
**V2+ theatrical pass:** Optional soft hooks + a small *embedded* Church media set; invent brand iconography, not a parallel skinning engine.
