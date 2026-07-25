# Church of Beef — launcher recommendations

**Last updated:** 2026-07-25  
**Audience:** Anniversary-first V1; keep multi-flavor doors open.

---

## V1 (Anniversary) — ship this

| Decision | Recommendation | Why |
|----------|----------------|-----|
| Primary entry | `/beef` always opens/toggles main frame | Spec §10; hide/collector safe |
| Minimap | LibDBIcon + LDB `type = "launcher"` when ready to embed | Collector + square-minimap coexistence ([LibDBIcon](https://www.wowace.com/projects/libdbicon-1-0), [LDB launcher](https://github.com/tekkub/libdatabroker-1-1/wiki/How-to-provide-a-dataobject)) |
| Hand-rolled fallback | Allowed for ultra-minimal V1 **only if** smoke-tested with HidingBar or MinimapButtonButton | Spec already prefers LibDBIcon-compatible behavior ([01 minimap](../01-ux-patterns/minimap.md), [04 Ace/libs](../04-ace3-and-libraries.md)) |
| Hide preference | Ship as soon as options exist; default **shown** for discoverability | Players who hate icons will hide; new guildies need the wart |
| Default hide | Do **not** default-hide on Anniv | No compartment fallback |
| Compartment TOC | Skip for Anniv-only TOC; optional later | See [addon-compartment.md](addon-compartment.md) |
| Tooltip | “Church of Beef” + left-click + `/beef` | Slash discoverability |
| Click | Left = toggle ladder frame (same as slash) | Spec parity |
| Pins | None for ranks | Avoid Questie/GatherMate conflict |

### Minimal embed set (when leaving “no Ace” V1)

`LibStub` → `LibDataBroker-1.1` → `LibDBIcon-1.0`. No Ace required for the button itself; plain SavedVariables table is enough.

### Frame creation rule

Create (or ensure) the main frame on load or first `/beef` — never only inside the minimap `OnClick`. Spec already flags “command works, nothing appears.”

---

## V1.5 — hygiene

1. Options toggle: “Show minimap button” bound to LibDBIcon `hide` + Hide/Show.
2. Confirm collector bag click still works after hide→show cycle.
3. Document for guild installs: “If you use HidingBar / MinimapButtonButton, Beef lives in the bag; or just `/beef`.”

---

## V2 / multi-flavor — additive only

| Flavor | Add |
|--------|-----|
| Retail `_Mainline.toc` | `## AddonCompartmentFunc` (+ enter/leave) pointing at same toggle as `/beef`; `## IconTexture` for list icon |
| Optional | Embed [LibDBCompartment](https://github.com/Meorawr/LibDBCompartment) so LDB drives compartment where supported; no-ops elsewhere |
| Retail UX experiment | Offer “prefer compartment / hide minimap icon” **only** when `AddonCompartmentFrame` exists |
| Never | Compartment-only builds for Classic Anniv |

---

## Explicit non-goals

- Building Beef’s own button collector.
- Competing with Questie/GatherMate pin layers.
- Requiring Bazooka/Titan/HidingBar as dependencies.
- Treating July 2026 Classic UI modernization as compartment arrival ([Blizzard Watch](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)).

---

## Decision one-liner

**Anniversary V1: LibDBIcon launcher + `/beef` + hide toggle; collectors are the player’s problem and LibDBIcon is how you stay compatible. Addon Compartment is a Retail bonus, verified later, never the Anniv sole door.**
