# LibDBIcon + LibDataBroker

**Last updated:** 2026-07-25  
**Role:** De facto Classic/Retail minimap-button standard for addon launchers.

---

## What LibDBIcon is

[LibDBIcon-1.0](https://www.wowace.com/projects/libdbicon-1-0) creates a lightweight minimap icon from a [LibDataBroker-1.1](https://github.com/tekkub/libdatabroker-1-1) data object. It is embeddable via LibStub; Ace3 is optional (examples use AceDB for the saved table).

Still actively released (v12.0.3, Jul 2026) with flavors including **Retail, Classic (1.15.x), Classic TBC (2.5.x)**, MoP Classic, and Titan Reforged ([CurseForge LibDBIcon](https://www.curseforge.com/wow/addons/libdbicon-1-0), [WowAce file notes](https://www.wowace.com/projects/libdbicon-1-0/files/8448436)).

---

## Contract (author-facing)

From the official overview ([WowAce](https://www.wowace.com/projects/libdbicon-1-0)):

1. Create an LDB object (`NewDataObject`).
2. `local icon = LibStub("LibDBIcon-1.0")`.
3. After SavedVariables exist: `icon:Register("UniqueName", ldbObject, savedVarTable)`.
4. Library persists position/radius-ish data on `savedVarTable`.
5. Visibility: `savedVarTable.hide == true` auto-hides; runtime `icon:Hide("UniqueName")` / `icon:Show("UniqueName")`.

Author community guidance: prefer LDB + optional LibDBIcon over hand-rolled minimap children so square minimaps and LDB displays interoperate ([WoWInterface thread](https://www.wowinterface.com/forums/showthread.php?t=54315) — Phanx).

---

## LDB object shape for a guild/social launcher

Tekkub’s canonical **launcher** ([How to provide a dataobject](https://github.com/tekkub/libdatabroker-1-1/wiki/How-to-provide-a-dataobject)):

| Field | Recommendation for Beef |
|-------|-------------------------|
| `type` | `"launcher"` (click-to-open; not a live data feed) |
| `icon` | Distinct Church texture or a clear stock icon path |
| `OnClick` | Left → toggle same frame as `/beef`; reserve right for options later |
| `OnTooltipShow` | Short: “Church of Beef — left-click open; `/beef`” |
| Name | Stable unique string matching Register name (folder-like uniqueness) |

WowAce’s sample uses `type = "data source"` with static text — that works for LibDBIcon but is the wrong semantic for a panel toggle. Prefer `launcher` for Beef so LDB bars treat it as a button, not a ticker.

---

## SavedVariables pattern

Canonical AceDB profile chunk:

```lua
profile = {
  minimap = {
    hide = false,
    -- LibDBIcon writes angle/position keys into this table
  },
}
```

Plain-SV V1 equivalent: a single table (e.g. `ChurchOfBeefDB.minimap`) initialized on `ADDON_LOADED`, passed to `Register`. Toggle hide in options by flipping `.hide` then `Hide`/`Show`.

Register only after SavedVariables are ready (same rule as AceDB: not in the main chunk).

---

## Embed layout (no hard dependency)

Typical order in `embeds.xml`:

1. LibStub  
2. CallbackHandler-1.0 (if required by other embeds)  
3. LibDataBroker-1.1  
4. LibDBIcon-1.0  

Use `## OptionalDeps: LibDBIcon-1.0` so a standalone LibDBIcon addon can win, but **embed** so Beef loads alone ([WoWInterface example patterns](https://www.wowinterface.com/forums/showthread.php?t=59832)).

---

## Behaviors collectors care about

From common LibDBIcon implementations (public mirrors of the library):

- Button created as a named/minimap-adjacent frame with `OnClick` / drag scripts.
- Initial show deferred to `PLAYER_LOGIN` so `GetMinimapShape` addons settle.
- Lazy create when registered with `hide = true` until first `Show`.

Collectors that scan minimap children or LDB objects interact best with this shape; anonymous hand-rolled buttons often break square-minimap math or evade grab lists ([WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=54315)).

---

## What LibDBIcon is not

- Not the Retail Addon Compartment (separate Blizzard UI; see [addon-compartment.md](addon-compartment.md)).
- Not a pin/layer system (do not use for rank markers on the map).
- Not a substitute for slash — hide and collectors both remove the visual affordance.

---

## Sources

- [LibDBIcon-1.0 — WowAce](https://www.wowace.com/projects/libdbicon-1-0)
- [LibDBIcon-1.0 — CurseForge](https://www.curseforge.com/wow/addons/libdbicon-1-0)
- [LibDataBroker — How to provide a dataobject](https://github.com/tekkub/libdatabroker-1-1/wiki/How-to-provide-a-dataobject)
- [How to add a Minimap Button? — WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=54315)
