# Track 28 — Minimap button collectors & Addon Compartment

**Track id:** `28-minimap-addon-compartment`  
**Last updated:** 2026-07-25  
**Sole focus:** How Church of Beef should expose a launcher on Anniversary without fighting collectors, LDB bars, or (where present) Blizzard’s Addon Compartment.  
**Out of scope:** Minimap chrome/shape (square ElvUI, Leatrix), quest/gather pins, packaging, Ace options UX. Surface-level minimap UX already lives in [`01-ux-patterns/minimap.md`](../01-ux-patterns/minimap.md) — this track deepens collectors + compartment only.

## Product truth (from V1 spec)

| Locked default | Value |
|----------------|-------|
| Entry | `/beef` opens main ladder frame |
| Minimap | Button toggles the **same** frame |
| Failure mode to avoid | Slash works but no frame / no discoverable UI |

Source: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10.

## Index

| Note | Covers |
|------|--------|
| [libdbicon-and-ldb.md](libdbicon-and-ldb.md) | LibDBIcon + LibDataBroker contract, hide/show, embed norms |
| [collectors.md](collectors.md) | MBB / HidingBar / MinimapButtonButton / Anniv-specific collectors |
| [addon-compartment.md](addon-compartment.md) | Retail compartment API; Anniversary/Era availability judgment |
| [coexistence-hide-norms.md](coexistence-hide-norms.md) | Hide-button norms, LDB displays, collector coexistence matrix |
| [beef-launcher-recommendations.md](beef-launcher-recommendations.md) | Concrete Beef V1/V2 launcher recommendations |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Anniversary launcher path is still LibDBIcon + LDB, not Addon Compartment.** Compartment is a Dragonflight+ Retail minimap dropdown ([Warcraft Wiki — Addon compartment](https://warcraft.wiki.gg/wiki/Addon_compartment)). Third-party [LibDBCompartment](https://github.com/Meorawr/LibDBCompartment) explicitly no-ops registration on flavors without the frame — treat Anniversary as **collector + LibDBIcon** territory until an in-client smoke test proves otherwise.

2. **Collectors are the real coexistence surface on Classic/Anniv.** Actively maintained: [HidingBar](https://www.curseforge.com/wow/addons/hidingbar) (Classic + Classic TBC; MBB’s stated successor) and [MinimapButtonButton](https://www.curseforge.com/wow/addons/minimapbuttonbutton) (Classic + Classic TBC). Anniv-targeted niche: [MinimapButtonCollector](https://addons.wago.io/addons/minimapbuttoncollector) (Interface `20505`). LibDBIcon buttons are the shape these tools expect.

3. **Hide-minimap-button is a player hygiene norm, not optional polish.** LibDBIcon stores `hide` on a saved table and exposes `Hide`/`Show` ([WowAce LibDBIcon](https://www.wowace.com/projects/libdbicon-1-0)). Community advice when minimaps fill up: turn off buttons and use slash ([r/classicwow](https://www.reddit.com/r/classicwow/comments/ffa99x/any_idea_of_an_addon_i_can_use_to_sort_out_the/)). Slash `/beef` must remain sufficient if the icon is hidden or collected.

4. **LDB `type = "launcher"` is the cleanest social-addon shape.** Tekkub’s LDB guide treats launchers as click → open config/UI ([How to provide a dataobject](https://github.com/tekkub/libdatabroker-1-1/wiki/How-to-provide-a-dataobject)). Bonus: Bazooka / Arcana (ex-ChocolateBar) / Titan users see Beef without a minimap wart.

5. **TOC compartment fields are Retail-first; harmless only if unknown metadata is ignored.** Wiki tags `AddonCompartmentFunc*` as Dragonflight ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format)). Classic Era/Anniv TOC *parser* has absorbed many Modern metadata changes (through 11.2.0 on Era 1.15.8 / Anniv 2.5.5), but that is not evidence the compartment **UI** ships. Do not make compartment the only entry point on Anniversary.

6. **July 2026 Classic UI modernization did not add compartment.** Blizzard’s recent Classic/Anniv UI pass targeted nameplates, raid frames, and Edit Mode options ([Blizzard Watch](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)) — not minimap addon trays.

## Compatibility matrix (summary)

| Approach | Retail | Classic Era / Anniv / TBC Classic | Collector-friendly | Beef V1 |
|----------|--------|-------------------------------------|--------------------|---------|
| LibDBIcon + LDB launcher | Yes | Yes (lib ships Classic + Classic TBC) | Best | **Preferred when embedding** |
| Hand-rolled minimap child | Yes | Yes | Risky (shape / grab fails) | Acceptable if tested |
| TOC Addon Compartment only | Yes (DF+) | **Do not rely on** | N/A | No |
| LibDBIcon + optional compartment TOC / LibDBCompartment | Yes | Icon path works; compartment may no-op | Best | V2 if multi-flavor |
| No button, slash-only | Yes | Yes | Perfect for clean UIs | Incomplete vs spec |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Warcraft Wiki, WowAce/CurseForge project pages, and LibDBCompartment README over listicles for technical claims.