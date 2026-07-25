# Track 57 — ScrollFrame / HybridScroll / pooled list rows

**Track id:** `57-scrollframe-list-rows`  
**Last updated:** 2026-07-25  
**Sole focus:** Classic Anniversary patterns for **long or variable lists** — true `ScrollFrame` vs `FauxScrollFrame` vs `HybridScrollFrame`; pooled/recycled row widgets; performance; Church of Beef recommendations for ladder + officer suggestion queues.  
**Out of scope (do not duplicate):** FrameXML vs Lua construction philosophy and MainFrame shell ([35](../35-xml-vs-lua-ui/)); general CPU/memory budgets ([54](../54-memory-fps-budgets/)); officer *alert* channels ([49](../49-officer-notifications/)); AceGUI lists. This track goes **list-widget deep** only where 35 stops at “use a pool.” No addon implementation in this folder.

## Product truth (from V1 spec + plan)

| Locked / planned | Value |
|------------------|-------|
| Ladder tab (plan Task 8) | **7 rank bands** (Prophet → Fresh Beef), occupants per band, highlight local player |
| Officer tab (plan Task 9) | Pending suggestion rows + Approve / Reject; demote / appoint / bestow controls |
| Scale | Social guild ladder — not a combat roster HUD; queue usually short |
| Construction stance (35) | Lua-primary `CreateFrame`; XML optional until a shared row template or hybrid scroll earns it |
| Perf stance (54) | Dirty-flag paint; open `/beef` &lt; ~5 ms; no CreateFrame-per-message |

Sources: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §4, §7–§10; [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) Tasks 7–9; [35 — beef-officer-ladder-ui](../35-xml-vs-lua-ui/beef-officer-ladder-ui.md).

## Index

| Note | Covers |
|------|--------|
| [scroll-patterns.md](scroll-patterns.md) | True ScrollFrame vs Faux vs Hybrid; Classic Anniversary availability |
| [pooled-rows-recycle.md](pooled-rows-recycle.md) | Why frames must be pooled; recycle / rebind; paint cadence |
| [beef-ladder-officer-lists.md](beef-ladder-officer-lists.md) | Concrete V1 / later recommendations for Beef lists |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Three scroll models — pick by content type, not fashion.**  
   - **True `ScrollFrame` + `ScrollChild`:** moves a whole child region (text, EditBox, tall static content). Wiki warns multi-textured, relatively-positioned controls can “fidget” under scroll ([ScrollFrame archive](https://warcraft.wiki.gg/wiki/UIOBJECT_ScrollFrame/Archive)).  
   - **`FauxScrollFrame`:** scrollbar only; you keep a **fixed pool of visible rows** and rebind data from `FauxScrollFrame_GetOffset` ([Faux HOWTO](https://warcraft.wiki.gg/wiki/Making_a_scrollable_list_using_FauxScrollFrameTemplate)).  
   - **`HybridScrollFrame`:** FrameXML helper that creates/reuses buttons via `HybridScrollFrame_CreateButtons` + `update` + `HybridScrollFrame_Update` ([HybridScrollFrame](https://warcraft.wiki.gg/wiki/HybridScrollFrame)). Same *idea* as Faux (no off-screen widgets), with Blizzard’s button factory.

2. **Faux is the battle-tested Classic list pattern; Hybrid is available-but-heavier.** Faux lives in `UIPanelTemplates` and is documented end-to-end for addon lists. Hybrid is what modern Blizzard UIs and some Classic cousins (e.g. HonorSpy’s ladder) use. TBC Anniversary shares client code with contemporary retail ([BlizzardWatch 2026-07-22](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)), so Hybrid is *likely* present — still **verify in-client** before depending on `HybridScrollFrameTemplate` / `HybridScrollBarTemplate`.

3. **Hybrid’s CreateButtons path wants an XML `virtual` button template.** Authors cannot invent FrameXML templates in Lua; `HybridScrollFrame_CreateButtons(..., buttonTemplate)` expects a named virtual template ([WoWInterface t=52623](https://www.wowinterface.com/forums/showthread.php?t=52623)). That is the main tension with Beef’s Lua-primary V1 stance (track 35).

4. **Frames cannot be deleted — recycle or leak forever.** `CreateFrame` objects persist for the session; prefer reuse / pools ([CreateFrame](https://warcraft.wiki.gg/wiki/API_CreateFrame); [frame pools thread](https://www.wowinterface.com/forums/showthread.php?t=58069)). List UIs that `CreateFrame` once per guild member will accumulate until `/reload`.

5. **V1 Beef does not need Hybrid for the plan-shaped ladder.** Task 8 is **seven rank rows**, not a 200-name flat roster. A fixed Lua pool of 7 band widgets (plus a small officer suggestion pool) meets product + [54](../54-memory-fps-budgets/) budgets without a scroll framework. Add Faux (or verified Hybrid) only when a viewport is shorter than the data (long occupant lines, large pending queues, or a future flat member list).

6. **Paint is rebind + dirty-flag — never rebuild from every BeefNet message.** Scroll offset → map visible slots → `SetText` / Show / Hide. Coalesce `CHAT_MSG_ADDON` / roster storms into one refresh ([54](../54-memory-fps-budgets/), [04](../04-toc-api-performance/)). Pass the **function** to `FauxScrollFrame_OnVerticalScroll`, not its return value ([WoWInterface t=45810](https://www.wowinterface.com/forums/showthread.php?t=45810)).

## Boundary with sibling tracks

| This track (57) | Sibling |
|-----------------|---------|
| How list rows scroll / pool / rebind | [35](../35-xml-vs-lua-ui/) — shell construction, XML vs Lua policy |
| List paint cost & hitch budgets | [54](../54-memory-fps-budgets/) |
| Who sees Officer tab / queue | [16](../16-guild-roster-officer-edges/), [49](../49-officer-notifications/) |
| Row context menus | [36](../36-tooltips-menus/) |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer warcraft.wiki.gg HOWTOs, WoWInterface author threads, and Classic cousin usage (HonorSpy) over tutorial listicles.
