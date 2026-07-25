# When to use XML vs pure Lua

**Track:** 35 · **Last updated:** 2026-07-25

## Decision matrix

| Situation | Prefer | Why |
|-----------|--------|-----|
| Small–medium addon; few panels; dynamic lists | **Lua `CreateFrame`** | Faster iteration; stack traces point at Lua; matches most modern Classic guild tools |
| Want Blizzard chrome (panel button, basic frame) | **Lua + inherit FrameXML templates** | No need to author XML just to look native ([CreateFrame + UIPanelButtonTemplate](https://wowpedia.fandom.com/wiki/API_CreateFrame)) |
| Need a **new reusable template** used many times | **XML `virtual="true"`** then inherit from Lua or XML | Creating templates requires XML ([WoWInterface consensus](https://www.wowinterface.com/forums/showthread.php?t=51507)) |
| Large static widget tree, careful layering | **XML** (or hybrid) | Structure mirrors hierarchy; tags like `useParentLevel` / `textureSubLevel` / `forceAlpha` are awkward in Lua (Gello via WoWInterface) |
| Hybrid scrollframe / some Blizzard-coupled constructs | **Some XML** | Authors report certain patterns are XML-required or far easier in XML |
| Secure/action-button UI | **XML templates + care** | Out of Beef V1 scope (track 29) |
| AceConfig / AceGUI options | **Library UI** | Separate from FrameXML debate; Beef V1 plan avoids Ace |

## Community consensus (author forums)

From [Frames: XML vs LUA? — WoWInterface (2015)](https://www.wowinterface.com/forums/showthread.php?t=51507), still cited as the practical tradeoff set:

1. **XML is required to *create* templates**; Lua can *use* them.
2. **Lua-only addons are acceptable**; debugging is generally easier in Lua.
3. **XML can be more optimized for load-time creation** of heavy trees and exposes some attributes that are cumbersome in Lua — but once loaded, runtime efficiency is not a meaningful differentiator for typical addon UIs.
4. Authors self-select: small projects → Lua; large UI-heavy projects → XML preference.
5. XML inheritance chains in Blizzard’s own UI sometimes require child templates to re-call parent `OnLoad` logic — a maintainability wart if you mirror complex FrameXML patterns.

Stack Overflow–era folklore that “most addons bootstrap in XML then build in Lua” is directionally true for older large UIs, but **not** a rule for new Classic social tools ([Lua vs XML discussion](https://stackoverflow.com/questions/1972722/lua-vs-xml-for-data-storage)).

## Maintainability dimensions

| Dimension | XML | Pure Lua |
|-----------|-----|----------|
| Visual hierarchy readability | Strong (nested tags ≈ tree) | Weaker unless you invent helpers |
| Diff / code review | Verbose; merge conflicts on large trees | Familiar to Lua-only contributors |
| Dynamic content (lists, queues) | Painful | Natural loops + pools |
| Shared look across many instances | Virtual templates excel | Factory functions / “pseudo-templates” |
| Debugging load errors | Malformed XML → login/reload fail | Lua errors with file:line |
| Dependency on Blizzard template renames | Same risk if you inherit either way | Same |
| Testability offline | Hard (needs client) | Still hard for widgets; Core stays testable if UI is thin |

**Practical rule:** Put **structure that never changes** where it is cheapest to express; put **data-driven widgets** in Lua. For Beef that means: one main shell + tab buttons via Lua factories; ladder/officer rows via pooled Lua frames.

## Load order and TOC

- List `.xml` / `.lua` explicitly in the `.toc` (or nest via `<Include>` / `<Script file>` inside XML).
- Template definitions must load **before** any `CreateFrame(..., "YourTemplate")` or XML `inherits="YourTemplate"`.
- Prefer not to scatter OnClick Lua *inside* XML for non-trivial logic — keep handlers in named Lua functions (wiki guidance: short inline OK, long logic in `.lua`) ([XML user interface — Scripts](https://warcraft.wiki.gg/wiki/XML_user_interface)).

## Antipatterns

| Antipattern | Prefer instead |
|-------------|----------------|
| Recreating Blizzard button art by hand in Lua | `CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")` |
| One giant XML file mirroring the whole addon | Lua modules per tab (`LadderTab.lua`, …) as in the V1 plan |
| Custom XML templates for a one-off frame | Inline `CreateFrame` |
| Shipping Retail-only panel templates on Anniversary | Verify on TBC Classic FrameXML / in-game |
| AceGUI “for free Classic look” in V1 | Plain frames + Blizzard templates (plan already says no Ace unless options explode) |
| New global name per ladder row | Anonymous frames + `parent.rows[i]` pool |

## Mapping to cousin guild tools (construction only)

Cousin tear-downs (track 13) show officer/loot/attune UIs as **list + action** surfaces. Those are almost always Lua-driven lists even when the shell inherits a Blizzard template. Steal the *interaction* pattern (pending queue, confirm friction), not a specific XML file layout.
