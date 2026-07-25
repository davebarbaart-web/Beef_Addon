# Mechanics: CreateFrame, virtual templates, inheritance

**Track:** 35 · **Last updated:** 2026-07-25

## Two construction paths

| Path | Role |
|------|------|
| **XML (FrameXML schema)** | Declares widget trees, layers, anchors, and **virtual templates** before/at load. Validated against `UI.xsd` from the extracted Interface kit. |
| **Lua (`CreateFrame` + Widget API)** | Creates widgets at runtime, sets size/points/scripts, and can **inherit** existing virtual templates by name. |

Until patch **1.10**, addon UI was XML+Lua only. `CreateFrame` (1.10) and template inheritance via `CreateFrame`’s fourth argument (1.11; comma-lists in 2.0.1) made Lua-primary UIs normal ([XML user interface](https://warcraft.wiki.gg/wiki/XML_user_interface); [CreateFrame patch notes](https://wowpedia.fandom.com/wiki/API_CreateFrame)).

Blizzard’s own default UI still ships large FrameXML trees; addons may use either approach or mix them.

## `CreateFrame` signature (relevant bits)

```text
frame = CreateFrame(frameType [, name, parent, template, id])
```

| Arg | Meaning for Beef |
|-----|------------------|
| `frameType` | `"Frame"`, `"Button"`, `"ScrollFrame"`, … (XML tag names / UI.xsd types) |
| `name` | Optional global name; prefer `nil` + locals / table keys to avoid `_G` pollution |
| `parent` | Frame object (not a string); usually `UIParent` or your main frame |
| `template` | Comma-delimited **virtual** template names to inherit at creation |
| `id` | Optional numeric ID |

Details that bite implementers ([CreateFrame — Wowpedia](https://wowpedia.fandom.com/wiki/API_CreateFrame); [AddOn Studio notes](https://addonstudio.org/wiki/WoW:API_CreateFrame)):

- Inherited template **`OnLoad` runs during `CreateFrame`**. Scripts you attach *after* `CreateFrame` with `SetScript("OnLoad", …)` will **not** re-fire — put init code immediately after creation instead.
- Frames **cannot be deleted/GC’d** — pool and reuse ladder/officer rows.
- The `template` list must name templates defined in XML with `virtual="true"` (Blizzard FrameXML or your addon’s `.xml`). You cannot pass a frame you built earlier with `CreateFrame` as a template.

## Virtual templates

A **virtual** node is a deferred template: not placed on screen, not living in `_G` as a normal frame, but available for inheritance ([Virtual XML template](https://warcraft.wiki.gg/wiki/Virtual_XML_template)).

```xml
<Frame name="MyFrameTemplate" virtual="true" />
<!-- later -->
<Frame inherits="MyFrameTemplate" />
```

```lua
CreateFrame("Frame", nil, parent, "MyFrameTemplate")
```

Rules of thumb ([XML user interface — Templates](https://warcraft.wiki.gg/wiki/XML_user_interface); [AddOn Studio XML tutorial](https://addonstudio.org/wiki/WoW:UI_XML_tutorial)):

- Templates sit at the **document root**, `virtual="true"`, unique name (no `$parent` on the template itself).
- Children that need unique globals use **`$parent`** so instances expand to `MyButton1Text`, etc.
- Inheritors may override attributes (e.g. template `movable="true"`, instance `movable="false"`).
- Templates may inherit other templates (chains).
- Duplicate virtual names warn / error (stronger checks since 8.0.1 on retail; still avoid collisions).
- Runtime inheritance via `CreateFrame` has existed since **1.11** (relevant to all Classic flavors).

Useful Blizzard template catalogs for research (verify names exist on **Anniversary/TBC Classic** FrameXML before shipping):

- [Ketho Templates.lua](https://github.com/Ketho/BlizzardInterfaceResources/blob/mainline/Resources/Templates.lua) (mainline-oriented list — filter for Classic)
- [SharedUIPanelTemplates (Townlong-Yak)](https://www.townlong-yak.com/framexml/live/SharedUIPanelTemplates.xml)

Classic-confirmed starting points from Gello (Classic + modern) ([forum thread](https://us.forums.blizzard.com/en/wow/t/creating-a-simple-gui-element-with-xml/1488298)):

| Template | Typical use |
|----------|-------------|
| `BasicFrameTemplate` | Title bar + close affordance shell |
| `UIPanelButtonTemplate` | Standard panel buttons |
| `UIPanelCloseButton` / close variants | Corner close |
| `DialogBorderTemplate` / `DialogHeaderTemplate` | Dialog chrome |
| `InsetFrameTemplate` | Inset content well |

Retail-leaning templates such as `DefaultPanelTemplate` may **not** be the Classic look — prefer Classic-verified names when targeting Anniversary.

## `parentKey` vs global `name`

| Mechanism | Effect |
|-----------|--------|
| `name="Foo"` / `CreateFrame(..., "Foo", ...)` | Global `_G.Foo` |
| `parentKey="CloseButton"` | Sets `parent.CloseButton = child` at load (no global required) |
| `parentArray="…"` | Appends children into a parent array (handy for bulk refs) |

`parentKey` / `parentArray` inheritance is **additive** in subtle ways (same key on template + instance, or multiple children sharing a template key → last wins / arrays grow). Documented on LayoutFrame-style attribute pages ([Wowpedia LayoutFrame parentKey discussion in search corpus](https://wowpedia.fandom.com/wiki/XML/LayoutFrame)). Prefer explicit Lua `parent.closeBtn = CreateFrame(...)` in a Lua-primary addon — same readability, fewer XML inheritance surprises.

## Mixing XML and Lua

Canonical hybrid:

1. `.xml` defines shells / virtual row templates / Include chains.
2. `.lua` (via TOC or `<Script file="…"/>`) wires events, fills lists, talks to Core.

Or invert:

1. Pure Lua creates everything with `CreateFrame(..., "BlizzardTemplate")`.
2. Optional tiny `.xml` only when you need a **Beef-owned** virtual template.

TOC lists both `.lua` and `.xml` in load order; malformed XML fails at login/reload ([XML user interface](https://warcraft.wiki.gg/wiki/XML_user_interface)).

## Secure templates (pointer only)

Secure action / unit templates are an XML-heavy domain and interact with taint. Church of Beef V1 is **ordinary insecure social UI** (ladder, officer queue, toasts) — do not pull secure templates. See track [29](../29-taint-secure-ui/) if that ever changes.
