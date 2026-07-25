# Beef recommendation: ladder + officer list widgets

**Track:** [57-scrollframe-list-rows](README.md)  
**Last updated:** 2026-07-25  
**Maps to:** Plan Tasks 8–9 (`UI/LadderTab.lua`, `UI/OfficerTab.lua`). Construction policy remains track [35](../35-xml-vs-lua-ui/); this note is **list depth only**.

## Recommendation (V1)

**Fixed Lua row pools with data rebind. No HybridScrollFrame in V1. No true ScrollFrame for action rows. Add `FauxScrollFrameTemplate` only if a list overflows the tab viewport.**

This extends 35’s “pooled anonymous frames” with concrete scroll/pool choices for Anniversary.

### Ladder tab

| Concern | V1 choice |
|---------|-----------|
| Data shape | 7 rank bands from `COB.Ladder:GetLadderView()` (plan Task 8) |
| Widgets | Exactly **7** band rows created once in `LadderTab` (or 7 + optional header) |
| Scroll | **None** unless design later packs bands into a short viewport |
| Paint | Rebind title, occupant string, highlight local player; dirty on ladder revision change |
| Occupant overflow | Truncate + tooltip / click-through to Standing — do not grow unbounded FontStrings inside a ScrollChild |

Optional later: if Beef adds a **flat member roster** (all names sortable), use Faux with ~10–12 visible rows — verify Hybrid only if Faux UX is insufficient and templates exist in-client.

### Officer tab

| Concern | V1 choice |
|---------|-----------|
| Data shape | Pending suggestions list (usually small) |
| Widgets | Fixed pool of **N suggestion rows** (recommend **8–12** visible) each with Approve / Reject inheriting `UIPanelButtonTemplate` |
| Scroll | If pending can exceed N: `FauxScrollFrameTemplate` + same pool (Lua-created rows). If product expects &lt; N always: no scrollbar |
| Paint | Rebind name, standing breakdown summary, suggestion id; clear ids on Hide |
| Other actions | Demote / Appoint / Bestow / correct standing stay **outside** the scrolling pool (static controls below or beside the list) |

### Shared rules

1. **Pools live in UI modules; data lives in Core.** `Refresh()` reads Core snapshots only.  
2. **One dirty flag per tab** (or one shared “ladder dirty” + “queue dirty”). BeefNet handlers set flags; a short timer or next `OnShow` paints.  
3. **Do not CreateFrame per suggestion.** Recycle.  
4. **No AceGUI scroll lists** for these tabs (35 / plan).  
5. **XML escape hatch** (from 35): if Hybrid is verified *and* both tabs need the same complex row, add `UI/Templates.xml` with `virtual` row template — that is the Hybrid trigger, not the V1 default.

## When to introduce which scroll tech

| Trigger | Action |
|---------|--------|
| Always ≤ visible slots | Fixed pool only |
| Officer queue or flat roster regularly overflows | Add **FauxScrollFrame** (Lua rows OK) |
| Need Blizzard Hybrid behavior + willing XML item template + in-client verify | Consider **HybridScrollFrame** |
| Standing history is long FontString log | True **ScrollFrame** + ScrollChild of text only |
| Multi-column action grid inside ScrollChild | Don’t — use Faux/Hybrid pool |

## Classic Anniversary verification (before locking Hybrid)

Run once on the shipping TBC Anniversary client (or that build’s FrameXML extract):

- [ ] `FauxScrollFrameTemplate` / `FauxScrollFrame_Update` exist (expected yes)  
- [ ] `HybridScrollFrameTemplate` or usable `HybridScrollFrame` inherit name exists  
- [ ] `HybridScrollBarTemplate` exists and anchors cleanly  
- [ ] `HybridScrollFrame_CreateButtons` present  
- [ ] No Retail-only atlas/mixin hard dependency on the row template Beef would copy  

Until Hybrid checks pass, implementers should assume **Faux or fixed pool only**.

## Anti-patterns for Beef lists

| Anti-pattern | Prefer |
|--------------|--------|
| ScrollChild containing Approve buttons for every pending | Faux pool of N rows |
| `CreateFrame` on each `SUGGESTION` | Grow-once pool; Hide extras |
| Full ladder rebuild per Net message | Dirty + coalesce ([54](../54-memory-fps-budgets/)) |
| Vendoring a full Blizzard HybridScrollFrame.lua “just in case” | Use client templates or stay on Faux |
| Variable-height rank bands for huge Fresh Beef lists | Truncate + detail surface |
| Passing `Update(self)` into `OnVerticalScroll` | Pass `Update` function reference |

## Module sketch (construction only — not implementation)

```text
UI/LadderTab.lua   → ensureRows(7); Refresh from GetLadderView(); no scroll V1
UI/OfficerTab.lua  → ensureRows(N); optional FauxScrollFrame; Approve/Reject → Core
```

Shell / tabs / ESC / position remain MainFrame concerns ([35](../35-xml-vs-lua-ui/beef-officer-ladder-ui.md)).
