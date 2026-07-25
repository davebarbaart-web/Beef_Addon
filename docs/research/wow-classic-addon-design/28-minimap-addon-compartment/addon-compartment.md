# Addon Compartment (depth)

**Last updated:** 2026-07-25  
**Role:** Blizzard’s Retail minimap dropdown for addon click-actions. This is the deep dive deferred from [`01-ux-patterns/minimap.md`](../01-ux-patterns/minimap.md).

---

## What it is

The **addon compartment** is a minimap-attached dropdown listing registered addons. It appears only if at least one entry is registered. Intended as a simple alternative to per-addon minimap buttons (toggle a panel, open options) ([Warcraft Wiki — Addon compartment](https://warcraft.wiki.gg/wiki/Addon_compartment)).

| Milestone | Change |
|-----------|--------|
| Dragonflight **10.0.0** | Feature added |
| Dragonflight **10.1.0** | TOC metadata auto-registration (`AddonCompartmentFunc*`, icons) |

Retail players and authors treat it as Blizzard’s answer to MBB-style clutter ([r/wow May 2023](https://www.reddit.com/r/wow/comments/13a7hwf/addon_developers_please_start_using_the_new/), [MMO-Champion](https://www.mmo-champion.com/threads/2652468-Unwanted-button-on-minimap)). There is no default UI toggle to disable the compartment button itself once entries exist ([MMO-Champion mod note](https://www.mmo-champion.com/threads/2652468-Unwanted-button-on-minimap)); filters like [AddOn Compartment Filter](https://www.townlong-yak.com/addons/acf) exist on Retail.

---

## Integration APIs (Retail)

### Automatic (preferred)

TOC fields ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format), [Addon compartment](https://warcraft.wiki.gg/wiki/Addon_compartment)):

| Field | Required | Purpose |
|-------|----------|---------|
| `## AddonCompartmentFunc` | **Yes** (to appear) | Global function name on click |
| `## AddonCompartmentFuncOnEnter` | No | Tooltip / highlight |
| `## AddonCompartmentFuncOnLeave` | No | Leave handler |
| `## IconTexture` / `## IconAtlas` | No | Icon in list (also used in AddOns list) |

Click handler signature (wiki example):  
`function MyAddOn_OnAddonCompartmentClick(addonName, buttonName)`  
(Enter/Leave receive `addonName`, menu button frame.)

Load-on-demand addons are loaded when a compartment func needs to run.

### Manual (discouraged)

`AddonCompartmentFrame:RegisterAddon({...})` — wiki/Wowpedia warn this **taints** UIDropDownMenu infrastructure; prefer TOC auto-registration.

### Library mirror

[LibDBCompartment](https://github.com/Meorawr/LibDBCompartment) mirrors LibDBIcon’s Register-style API over LDB objects for compartment entries. Critical quote from its README:

> In game flavors that don't support the addon compartment the full API of the library can be used as normal, but the library will **not** attempt to register any button entries into the non-existent compartment dropdown list.

That is the strongest published signal that compartment is **flavor-gated**, not universal.

---

## Availability on Classic Era / Anniversary — judgment

### Evidence for Retail-only UI

1. Wiki pages brand the feature **Dragonflight** and document 10.0 / 10.1 patch lines only ([Addon compartment](https://warcraft.wiki.gg/wiki/Addon_compartment)).
2. LibDBCompartment documents unsupported flavors and no-ops registration ([README](https://github.com/Meorawr/LibDBCompartment)).
3. July 2026 Classic/Anniv UI modernization covered nameplates, raid frames, Edit Mode — **not** addon compartment ([Blizzard Watch](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/), [Blizzard forum UI updates thread](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408)).
4. Classic/Anniv addon hygiene still centers on **collectors** (HidingBar, MinimapButtonButton, Anniv MinimapButtonCollector) — the ecosystem behavior you’d expect if Blizzard’s compartment were not the default tray.

### Evidence that can confuse authors

Warcraft Wiki **TOC format** patch notes say Classic Era **1.15.8** “Includes all Modern changes up to 11.2.0” and Classic Anniversary **2.5.5** includes Era changes through 1.15.8 ([TOC format — Classic Era / Anniversary sections](https://warcraft.wiki.gg/wiki/TOC_format)). That language describes **TOC metadata / loader** backports (multi-flavor TOC, `IconTexture`, conditionals, etc.), **not** a guarantee that every Retail FrameXML widget (including `AddonCompartmentFrame`) is present and wired to the Classic minimap.

**Working conclusion for Beef (Anniversary-first):**

| Claim | Status |
|-------|--------|
| Compartment is a reliable Anniv entry point | **No — do not design V1 around it** |
| TOC `AddonCompartmentFunc` may be ignored or inert on Anniv | **Likely / acceptable risk** if added for future Retail TOC |
| In-client verification still required before relying on it | **Yes** — `/dump AddonCompartmentFrame` (or equivalent) on live Anniv build |
| LibDBIcon remains the Anniv launcher | **Yes** |

If a future Classic patch ports the compartment UI (shared-code drift is real — Blizzard Watch notes Classic sharing retail codebases), TOC fields + LibDBCompartment become cheap wins. Until then, treat compartment as **Retail / multi-flavor bonus**, not Anniv core.

---

## Coexistence with LibDBIcon (Retail pattern)

Common author pattern on Retail:

1. Register LibDBIcon for users who want a classic minimap wart.
2. Also declare TOC compartment funcs (or LibDBCompartment) so clean-UI users never need the wart.
3. Default `minimap.hide = true` when compartment is the preferred entry — **only** where compartment is known to exist; **do not** default-hide on Anniv or slash-only users get a worse first run.

Players who dislike the compartment button itself use compartment filters or ask authors for opt-out ([Blizzard UI forum](https://us.forums.blizzard.com/en/wow/t/addon-compartment/1921072)).

---

## Sources

- [Addon compartment — Warcraft Wiki](https://warcraft.wiki.gg/wiki/Addon_compartment)
- [TOC format — Warcraft Wiki](https://warcraft.wiki.gg/wiki/TOC_format) (compartment fields + Classic Era/Anniv “Modern changes” notes)
- [LibDBCompartment — GitHub](https://github.com/Meorawr/LibDBCompartment)
- [Blizzard Watch — Classic/Anniv UI modernization (Jul 2026)](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)
- [User Interface Updates in Classic — Blizzard forums](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408)
