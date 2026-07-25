# Scroll patterns: true vs Faux vs Hybrid

**Track:** [57-scrollframe-list-rows](README.md)  
**Last updated:** 2026-07-25

## 1. True ScrollFrame (ScrollChild)

**What it is:** A `ScrollFrame` whose `ScrollChild` is a (often tall) frame. Moving the scrollbar moves the child; widgets are real children of that child.

**Good for:** Long text, EditBoxes, settings pages with mostly static layout ([ScrollFrame archive](https://warcraft.wiki.gg/wiki/UIOBJECT_ScrollFrame/Archive) example with Interface Options panel).

**Bad for:** Dense lists of buttons / multi-column rows. Archive note: many relatively-positioned textures under a ScrollChild can shift a few pixels unpredictably when scrolled (“fidgeting”); text suffers less. Conclusion on that page: use true scroll for large images/blocks of text, **not** large numbers of multi-textured controls.

**Templates:** `UIPanelScrollFrameCodeTemplate` (logic only), `UIPanelScrollFrameTemplate` (bar chrome).

**Beef:** Acceptable for My Standing history if it stays FontString-heavy; **not** the primary pattern for ladder bands or officer suggestion rows with action buttons.

---

## 2. FauxScrollFrame (virtual list)

**What it is:** Inherits scroll-bar chrome from panel templates but **does not** move a giant ScrollChild of all rows. The scrollbar’s range is calculated from `(numItems, numToDisplay, valueStep)`. Your update function reads `FauxScrollFrame_GetOffset` and rebinds a **fixed** set of row widgets ([HOWTO](https://warcraft.wiki.gg/wiki/Making_a_scrollable_list_using_FauxScrollFrameTemplate)).

**Core FrameXML API (conceptual):**

| Call | Role |
|------|------|
| `FauxScrollFrame_OnVerticalScroll(self, offset, rowHeight, updateFunc)` | Wire from `OnVerticalScroll`; must receive the **function**, not `updateFunc()` |
| `FauxScrollFrame_Update(frame, numItems, numToDisplay, valueStep, …)` | Resize thumb / show-hide bar |
| `FauxScrollFrame_GetOffset(frame)` | Integer index into data (0-based offset into the list) |

**Row count:** `numToDisplay` = how many row widgets exist (e.g. 5–12). Data length can be 50 or 500; only `numToDisplay` frames exist.

**Construction options:**

| Approach | Notes |
|----------|-------|
| XML virtual row + N named instances | Classic HOWTO; FriendsFrame-style |
| `CreateFrame("ScrollFrame", …, "FauxScrollFrameTemplate")` + Lua-created row buttons | Proven on WoWInterface ([t=45810](https://www.wowinterface.com/forums/showthread.php?t=45810)) — fits Beef Lua-primary |

**Pitfalls authors hit:**

1. Forgetting the first `Update` on show (initialize once).  
2. Passing `Update(self)` (nil) instead of `Update` into `OnVerticalScroll` — causes “offset one cycle behind” weirdness; fix is pass the function reference ([t=45810 p.2](https://www.wowinterface.com/forums/showthread.php?t=45810&page=2)).  
3. Anchoring the scrollframe’s *display* area vs the bar (bar sits outside the scrollable rect).

**Availability:** Long-lived Classic/Retail FrameXML (`UIPanelTemplates`). Safe default for Anniversary.

---

## 3. HybridScrollFrame (Blizzard virtual list)

**What it is:** FrameXML list helper that **reuses child widgets** by remapping them to different list indices as you scroll ([wiki](https://warcraft.wiki.gg/wiki/HybridScrollFrame); archive one-liner: “Reuses child widgets by passing them a new ID”).

**Typical flow (wiki example):**

1. `CreateFrame("ScrollFrame", name, parent, "HybridScrollFrameTemplate")` (or template name variant `"HybridScrollFrame"` as some Classic addons use).  
2. Attach `HybridScrollBarTemplate` slider.  
3. `HybridScrollFrame_CreateButtons(hsf, "YourItemTemplate", …)` — creates visible buttons from a **virtual XML template**.  
4. Assign `hsf.update = function() … end` that maps `HybridScrollFrame_GetOffset` → button → data.  
5. `HybridScrollFrame_Update(hsf, totalHeight, shownHeight)`.

**XML requirement:** `CreateButtons` takes a `buttonTemplate` string; templates are XML-only ([Lombra, t=52623](https://www.wowinterface.com/forums/showthread.php?t=52623)). Cousin HonorSpy ships `HybridScrollListItemTemplate` in addon XML and calls `HybridScrollFrame_CreateButtons(scroll, "HybridScrollListItemTemplate")` ([HonorSpy classic](https://github.com/kakysha/HonorSpy)).

**Availability on Classic Anniversary:**

| Signal | Implication |
|--------|-------------|
| Anniversary / Era clients share code with contemporary retail (TWW-era mirror called out mid-2026) ([BlizzardWatch](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)) | Hybrid helpers are **plausible / likely** on TBC Anniversary |
| Historical Classic Era addons sometimes vendored Hybrid-related XML or assumed client templates | Do not treat 2019 Era folklore as Anniversary truth |
| Raw probes of old Gethe `classic_era` / `bcc` HybridScrollFrame.lua paths returned 404 in this research pass | Prefer **in-client** check: `/dump HybridScrollFrame_CreateButtons` or FrameXML extract for the shipping Anniversary build |

**Verdict for Beef:** Treat Hybrid as an **optional upgrade** after verification — not the V1 default. Cost: XML row template + Blizzard API surface. Benefit: smoother variable-height / Blizzard-native scroll behavior if Beef ever grows a long flat member list.

---

## 4. Comparison matrix

| Dimension | True ScrollFrame | FauxScrollFrame | HybridScrollFrame |
|-----------|------------------|-----------------|-------------------|
| Off-screen widgets | Yes (all children exist) | No (pool = viewport) | No (pool = viewport) |
| Best content | Text / EditBox | Fixed-height rows | Fixed-height (Blizzard lists) |
| Lua-primary friendly | High | High | Medium (wants XML item template) |
| Classic Anniversary risk | Low | Lowest | Verify template globals |
| Row action buttons | Risky under ScrollChild | Natural on pooled rows | Natural on pooled buttons |
| Complexity | Low for text | Medium | Medium–high |

---

## 5. “No scroll framework” (valid fourth option)

If `numItems ≤ numVisibleSlots` always (Beef V1 ladder = 7 bands; officer queue often &lt; ~8–12), you only need:

- A fixed array of row frames created once.  
- `Show`/`Hide` extras.  
- No scrollbar.

Add Faux/Hybrid when overflow becomes a product reality — not before.
