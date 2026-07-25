# Church of Beef — Adopt vs Invent (skinning / media)

**Last updated:** 2026-07-25  
**Status:** Track synthesis — closes gap-audit P1 for track 10.  
**Maps to:** [V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §3.3 (brand), §10 (UI), §11 (missing media), §13 (success = spectacle in chat), §14 (phases).  
**Builds on:** [01](01-masque.md) · [02](02-libsharedmedia.md) · [03](03-skins-fonts-statusbars.md) · [04](04-icon-framing.md) · [05](05-brandable-visual-systems.md).  
**Sibling policy:** Soft-dep matrix in [42 beef-v1-dependency-policy](../42-soft-deps-embeds/beef-v1-dependency-policy.md) (Masque/LSM = soft-only / V1 deny as requirement).

**Temperament:** [`.raw/deep-masque-sharedmedia.md`](.raw/deep-masque-sharedmedia.md) invents V2 ceremony metaphors (worship-tier overlays, liturgy calendar, ship-a-Masque-skin-by-default). Those are **research brainstorm**, not V1 product requirements. This note tempers them against the approved spec.

---

## 0. Locked V1 product stance (not README-only)

These are research recommendations aligned with the approved spec. Promote into the design-spec decisions log if implementers want formal lock-in.

| Decision | V1 | Rationale |
|----------|----|-----------|
| **Hard-depend Masque** | **No** | Ladder/toasts are not button grids; solo load is mandatory ([42](../42-soft-deps-embeds/beef-v1-dependency-policy.md)) |
| **Hard-depend LibSharedMedia / SharedMedia packs** | **No** | Spec §10–§11 require missing-media fallbacks; packs are install friction |
| **Plain Classic / Blizzard dialog frames** | **Yes** | Spec §10: “V1 may use plain Classic frames; dark-iron theatrical chrome is a later visual pass” |
| **Spectacle channel** | **Guild-chat + toasts** | Spec §10 / §13 — cheapest stream-friendly spectacle; not stained-glass chrome |
| **Rank presentation** | **Text titles** | Canon ladder §4; icons optional later, never required to read rank |
| **Item-quality colors as rank IDs** | **No** | Ranks are social, not loot rarities ([04](04-icon-framing.md)) |

---

## 1. Decision summary by visual layer

| Layer | V1 | V2 theatrical pass | Never |
|-------|----|--------------------|-------|
| Panel chrome | Plain Classic / Blizzard dialog-like frames | Embedded Scarlet/cathedral textures; optional LSM BACKGROUND/BORDER register | Hard-depend ElvUI; globally skin Blizzard frames |
| Fonts | Default UI / Friz | Optional embedded display face + LSM Register if present | Require SharedMedia / ClassicalFonts packs |
| Statusbars | Avoid fake HP bars for standing (text thresholds OK) | Optional theatrical meter texture for favor/ceremony | Meter-UI density; combat HUD chrome |
| Buttons | Text/XML buttons; **no Masque** | Soft Masque only if icon grids appear | Ship as Masque-only skin; build a second ButtonFacade |
| Iconography | Titles as text; optional simple stock icons | Brand glyphs, cow/steak/holy seals (license-clean) | Remap ranks → Poor…Legendary rainbow |
| Sound | Guild-chat announcement spectacle | Optional LSM SOUND, opt-in | Spam stingers; hard sound-pack dep (see [20](../20-sound-sfx-feedback/)) |

---

## 2. Adopt (battle-tested ecosystem)

Invent brand content. Adopt skinning/media **infrastructure**.

| Adopt | Why | Source / note |
|-------|-----|---------------|
| **Soft LibStub detection** | Standard for optional Masque/LSM | [Masque API_VERSION](https://github.com/SFX-WoW/Masque/wiki/API_VERSION); [02](02-libsharedmedia.md) |
| **LSM media type vocabulary** | FONT / STATUSBAR / BORDER / BACKGROUND / SOUND is the lingua franca | [LSM API](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation) |
| **Blizzard predefined LSM handles** | Zero-asset Classic look (Friz, Dialog borders, UI-StatusBar) | LSM predefined data; V1 default path |
| **Hybrid embed + optional register** | ElvUI/SharedMedia pattern: ship art, expose via LSM when available | [ElvUI-TBC sharedmedia.lua](https://github.com/ElvUI-TBC/ElvUI/blob/master/ElvUI/media/sharedmedia.lua); [05](05-brandable-visual-systems.md) |
| **Missing-media fallbacks** | Already locked in product spec | Spec §10, §11 |
| **Unique frames + coexistence** | Peaceful life beside ElvUI/Masque | [03-visual-language-reference](../03-visual-language-reference.md); [05](05-brandable-visual-systems.md) §5 |
| **Namespaced Masque groups** (when used) | `ChurchOfBeef` / `LadderIcons` so users theme Beef separately from Bartender | [01](01-masque.md); [05](05-brandable-visual-systems.md) |
| **LibDBIcon for minimap** | Standard button placement when/if used | [42](../42-soft-deps-embeds/beef-v1-dependency-policy.md); not a Masque concern |
| **High-contrast stream typography habits** | Spec is streamer-event adjacent | Spec §1; track [17](../17-stream-overlay-readability/) for capture sizes |
| **Brand color tokens as accents** | Scarlet/gold/parchment without loot-quality mapping | [23-color-brand-tokens](../23-color-brand-tokens/) |
| **TGA/BLP packaging rules** | When Media/ lands | [44-custom-textures-media-packaging](../44-custom-textures-media-packaging/) — not duplicated here |

---

## 3. Invent (no good ecosystem substitute)

| Invent | Phase | Notes |
|--------|-------|-------|
| **Rank title presentation** | V1 | Fresh Beef → Beef Prophet as readable social titles (canon ladder §4) |
| **Promotion toast + guild-chat liturgy line** | V1 | Cheapest spectacle; already in spec §10 |
| **Church accent treatment for ranks** | V1–V2 | Badges / accent chips from brand tokens — **not** `GetItemQualityColor(rank)` |
| **Church icon set** (cow prophets, steak halo, Scarlet-parody seals) | V2 | Layer-5 brand ([05](05-brandable-visual-systems.md)); keep license-clean originals |
| **Cathedral / parchment panel art** | V2 | Embedded backgrounds; optional LSM BACKGROUND registration |
| **Ceremony spotlight choreography** | V2 | WeakAuras-*like timing*, not WA dependency; deferred in spec §3.2 |
| **Gora match theater chrome** | V3 | Per phase map §14 |
| **Optional `Masque_ChurchOfBeef` vanity skin** | V2+ | Fun for collectors; **never** required; separate optional addon preferred if large |

---

## 4. Explicitly do **not** invent / do not adopt as hard deps

| Temptation | Why not | Deep-research correction |
|------------|---------|--------------------------|
| **A second Masque / ButtonFacade** | Engine already exists; maintenance trap | Deep research correctly says “adopt Masque” — adopt as *soft consumer*, not fork |
| **Ship a default Masque-compatible skin in V1** | V1 has no icon-button surface worth Masque; bloats install | Deep research “ship stained-glass Masque skin” → **defer to V2+ vanity** |
| **Hard dependency on Caith/ElvUI fonts** | Breaks default-UI guildies | Packs are *user taste references* only ([03](03-skins-fonts-statusbars.md)) |
| **Worship-tier = GetItemQualityColor(rank)** | Teaches “ranks are loot rarities”; confuses inventory literacy | Deep research floated Tallow→Brimstone quality borders — invent **brand** borders later, not quality enum reuse |
| **Parallel SharedMedia megapack** | License / size / support cost | Register a handful of Beef assets instead; optional `ChurchOfBeef_Media` if art grows ([05](05-brandable-visual-systems.md) §4) |
| **Retail Edit Mode / DF skin APIs** | Out of V1 scope (spec §2) | — |
| **Global Blizzard frame skinning** | Conflicts with ElvUI; Masque itself refuses default-UI scope | [legacy note](https://legacy-wow.com/mop-addons/masque/); [01](01-masque.md) |
| **Liturgy calendar / worship-tier overlay widgets as V1 UI** | Spec centerpiece is the rank ladder; ceremony theater is V2+ | Treat deep-research metaphors as lore brainstorm only |

---

## 5. Phased media roadmap (research recommendation)

```
V1  → Blizzard fonts + plain frames + text ladder + toast + guild announce
      No Masque / LSM code paths required.
      Optional: one custom minimap .tga if art is ready; else stock / LibDBIcon path.
      Every load path survives missing Media/ (spec §11, §13.1 smoke test).

V2  → Embed Media/ (fonts, panel, rank seals) — packaging rules in track 44
      Soft: if LSM then Register Church keys (OptionalDeps, never hard)
      Soft: if Masque and icon buttons exist then GetGroup/AddButton
      Still: every path falls back to V1 look
      Still: ranks readable as text without seals

V3+ → Gora theater textures; optional sound pack (track 20); still no hard deps
```

This matches the hybrid conclusion in [05](05-brandable-visual-systems.md) while respecting approved V1 “plain frames OK / theatrical later” (spec §10, §14).

---

## 6. Adoption triggers (when soft hooks become worth writing)

Do **not** add Masque/LSM “because cousins do.” Add when a trigger fires ([42](../42-soft-deps-embeds/beef-v1-dependency-policy.md) §3 order 4):

| Trigger | Soft hook |
|---------|-----------|
| Icon grid / sealed rank buttons ship and users ask for Masque | `LibStub("Masque", true)` + namespaced group |
| Embedded fonts/statusbars ship and power users want picker dropdowns | LSM Register + AceGUI SharedMedia widgets (if Ace options exist) |
| Brand art grows large enough to hurt core zip size | Split optional `ChurchOfBeef_Media` / `SharedMedia_ChurchOfBeef` |
| ElvUI guildies report “ugly unskinnable panel” | Prefer self-contained backdrop + unique frame names first; Masque only if buttons are the complaint |

---

## 7. Top insights (executive)

1. **Masque is for button consumers, not ladder windows** — only care when Beef grows icon buttons ([01](01-masque.md)).
2. **LSM is a broker, not a brand** — register Church media into it later; never require community packs ([02](02-libsharedmedia.md)).
3. **Classic TBC Masque/LSM builds are first-class** — soft integration is possible without private forks; verify Interface stamp at ship ([01](01-masque.md) §2).
4. **Hybrid embed + soft hook is the ecosystem’s winning pattern** — ElvUI proves it; V1 ships the “embed baseline = Blizzard defaults” end of that spectrum.
5. **Invent iconography and ceremony art; adopt skinning/media APIs** — brand lives in unique seals/toasts, not in rewriting ButtonFacade.
6. **Do not paint ranks with loot colors** — use church accents ([23](../23-color-brand-tokens/)); keep quality colors for items ([04](04-icon-framing.md)).
7. **V1 success is readable ladder + spectacle in chat**, not stained-glass chrome (spec §13).

---

## 8. Sources

- [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)
- [Masque — WowAce / CurseForge](https://www.wowace.com/projects/masque)
- [LibSharedMedia-3.0 API](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation)
- [ItemQuality — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/ItemQuality)
- [ElvUI-TBC sharedmedia.lua](https://github.com/ElvUI-TBC/ElvUI/blob/master/ElvUI/media/sharedmedia.lua)
- [42 beef-v1-dependency-policy](../42-soft-deps-embeds/beef-v1-dependency-policy.md)
- [Deep research raw](.raw/deep-masque-sharedmedia.md)
- Annotated primaries: [07-annotated-urls.md](07-annotated-urls.md)
