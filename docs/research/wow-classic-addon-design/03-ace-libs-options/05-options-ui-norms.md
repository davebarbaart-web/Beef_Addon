# Options UI Norms (AceConfig and Contemporary Classic)

**Last updated:** 2026-07-25  
**Sources:** [AceConfig-3.0 Options Tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables), [Getting Started — AceConfig / AceDBOptions](https://www.wowace.com/projects/ace3/pages/getting-started), [Ace3 for Dummies — GUI section](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies), [AceDBOptions API](https://www.wowace.com/projects/ace3/pages/api/ace-dboptions-3-0), [LibDBIcon](https://www.wowace.com/projects/libdbicon-1-0).

---

## 1. The dominant pattern

Contemporary Classic utility addons converge on:

1. **Declarative options table** (AceConfig) — nested `type = "group"` trees.
2. **AceConfigDialog** — in-game dialog and/or Blizzard Interface Options via `AddToBlizOptions`.
3. **Slash open** — either AceConfig’s registered slash list or AceConsole handler that opens the dialog.
4. **Profiles subgroup** — AceDBOptions chunk dropped into `args.profiles`.
5. **Minimap** — LibDataBroker data object + LibDBIcon; hide flag lives in `db.profile.minimap` (or equivalent).

Church of Beef V1 uses a custom `/beef` frame (Ladder / My Standing / Officer tabs). That is product UI, not “settings”. Settings (announce opt-out, officer rank-index threshold, toast density) are the AceConfig-shaped surface if/when they grow.

---

## 2. AceConfig widget vocabulary

| Type | Use |
|------|-----|
| `group` | Sections; `inline`, `childGroups = "tab"` / `"tree"` |
| `toggle` | Booleans |
| `range` | Numeric sliders (`min`/`max`/`step`) |
| `input` | Text; optional multiline |
| `select` / `multiselect` | Dropdowns / multi-pick |
| `execute` | Buttons (open URL, run reset, force sync) |
| `color` / `multicolor` | Color pickers |
| `keybinding` | Bindings |
| `description` / `header` | Static copy / section labels |

**Inherited cross-cutting fields** (bubble toward root unless overridden): `get`, `set`, `func`, `confirm`, `validate`, `disabled`, `hidden`.

Width hints (`full`, `double`, `half`, `normal`) control dialog density.

---

## 3. UX conventions players already know

| Convention | Why it matters |
|------------|----------------|
| **Tabs or tree for large trees** | `childGroups = "tab"` keeps officer vs personal settings separable |
| **`confirm` on destructive executes** | Demote, standing wipe, Prophet bestowal, profile reset |
| **`disabled` / `hidden` as functions** | Hide Officer settings when not Officer+; grey out when not in guild |
| **`desc` under every control** | Classic options UIs are terse; tooltips carry the theology/rules |
| **Slash parity** | Serious Ace addons expose the same knobs via `/addon opt value` and GUI |
| **Blizzard options registration** | Escape hatch when custom frames are closed; not required if `/beef` hosts settings |

For CoB, officer-only controls must use the **design-spec gate** (guild roster rank index ≤ configurable threshold), not only Blizzard note-edit helpers. AceConfig `hidden`/`disabled` callbacks are the right *UI* place to apply that gate; validation on BeefNet commits remains mandatory regardless of UI visibility.

---

## 4. Settings vs product chrome

| Surface | Norm | CoB V1 |
|---------|------|--------|
| Main gameplay/social UI | Custom frames, often AceGUI or plain CreateFrame | Custom ladder frame |
| Configuration | AceConfig dialog / Bliz options | Minimal; announce opt-out noted in spec |
| Minimap | LibDBIcon | Spec requires minimap button — LDB+LibDBIcon is the ecosystem-compatible choice when adopting libs |
| Profiles | AceDBOptions page | Not in V1; plan separation of UI prefs vs ladder data |

Do not shove the entire ladder into AceConfig — AceConfig is for **settings**, not for live multiplayer social boards.

---

## 5. Slash-command architecture norms

AceConsole pattern used across tutorials:

- One chat command (`beef`) with subcommands (`config`, `ladder`, …) **or**
- AceConfig-registered slash that opens options directly
- Argument parsing via `GetArgs`
- Permission checks in shared helpers used by slash, GUI, and net handlers

Persistence flag on RegisterChatCommand controls whether the slash survives disable — relevant if officers disable the addon mid-ceremony.

---

## 6. Minimap / broker norms

LibDBIcon expects a LibDataBroker object (`OnClick`, `OnTooltipShow`, icon/text) and a small DB table for position/hide. Collectors (Bazooka, Titan, ChocolateBar) then work for free.

Raw `Minimap` child buttons are still common in tiny addons but fight collectors and theme packs — poor fit for a streamer-facing guild addon long-term.

---

## 7. Density and “clean UI” pressure (2024–2026)

Even Ace-heavy Classic UIs are under pressure to:

- Keep defaults sane without opening config
- Avoid dumping every debug toggle into the first options tab
- Put power-user controls behind Advanced subgroups

CoB should expose few player settings in V1 (announce opt-out, maybe toast mute). Officer threshold and seat counts belong in canon/data or a short Officer settings group — not a retail-style mega-tree.
