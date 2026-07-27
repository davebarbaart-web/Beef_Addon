# 01b — Classic UI web digest (annotated ≥20)

**Track:** `agent-polish-vision`  
**Date:** 2026-07-26  
**Purpose:** Annotated **web primaries** for Classic / Anniversary FrameXML, CreateFrame, templates, taint/lockdown, lists, fonts, and motion — mapped to **Church of Beef** V1 (`## Interface: 20506`).  
**Authority:** Research only. Spec §10 / §15 + [UI agent briefing](../../superpowers/ui-polished-direction-for-agents.md) win on conflict.  
**Companions:** [01 architecture](01-classic-ui-architecture.md) · [02 Lua vs XML](02-lua-vs-xml-frames.md) · [03 taint](03-taint-lockdown-ux.md) · [04 media](04-media-fonts-textures.md) · [15 procedural motion](15-procedural-ui-animation.md) · [56 AnimationGroup](56-wow-animationgroup-classic.md)  
**Sibling digests:** [00b community](00b-community-threads-digest.md) · [11b juice](11b-juice-sources-digest.md)  
**Raw harvest (gitignored):** `.firecrawl/classic-ui-digest/` · parallel run `trun_91f36069f09644808c10def1e9ff01f2` (ultra-fast; may still be cooking)

> Wiki pages mix Retail and Classic. Prefer Anniversary client smoke over assuming every Retail method exists. Never import Retail-only panel chrome or Secure* ceremony paths for Beef.

---

## Classic / Anniversary constraint filter

| Constraint | Rule for Beef |
|------------|---------------|
| **Interface** | Single TOC `## Interface: 20506`; verify live with `/dump (select(4, GetBuildInfo()))` |
| **Shell** | Insecure `BasicFrameTemplate` (or equivalent Classic shell) under `UIParent`; `:Show()` / `:Hide()` — not `ShowUIPanel` for the main window |
| **Lua-primary** | Prefer `CreateFrame` + stock templates; XML only when defining `virtual` templates you need |
| **No secure ceremony** | Social guest UI stays insecure so combat open/toggle works; no SecureActionButton / SecureHandlers for toasts or panels |
| **Pool frames** | CreateFrame does not GC — fixed row pools for ladder / officer queue |
| **Guest on scale** | Never `UIParent:SetScale` / `uiScale` from addon |
| **Layers** | UI presents Core results only — never awards points or invents ranks |
| **Motion** | Short self-clearing AnimationGroup / `C_Timer`; no permanent juice `OnUpdate` |

---

## Technique → source → Classic / Beef mapping

| Technique | Primary sources | Classic / Beef mapping | V1 |
|-----------|-----------------|------------------------|----|
| TOC load order & Interface | [TOC format — wiki.gg](https://warcraft.wiki.gg/wiki/TOC_format) | Data→Core→Net+UI→bootstrap last; `SavedVariablesPerCharacter` | always |
| CreateFrame inherit | [CreateFrame — wiki.gg](https://warcraft.wiki.gg/wiki/API_CreateFrame) · [Wowpedia](https://wowpedia.fandom.com/wiki/API_CreateFrame) | Named main frame + anonymous children; templates from XML | always |
| Virtual templates | [Virtual XML template](https://warcraft.wiki.gg/wiki/Virtual_XML_template) · [XML UI](https://warcraft.wiki.gg/wiki/XML_user_interface) | Lua cannot invent new FrameXML templates | as needed |
| Classic panel chrome | [Gello — simple GUI / XML](https://us.forums.blizzard.com/en/wow/t/creating-a-simple-gui-element-with-xml/1488298) | Prefer `BasicFrameTemplate` over DF “modern panel” | always |
| Backdrop mixin | [BackdropTemplate — wiki.gg](https://warcraft.wiki.gg/wiki/BackdropTemplate) · [forum issues](https://us.forums.blizzard.com/en/wow/t/backdroptemplate-issues/1125674) | Multi-inherit `"BackdropTemplate,…"` when painting chrome | as needed |
| Taint / secure model | [Secure Execution and Tainting](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting) | Ordinary insecure frames for ladder/toast/officer | always |
| Combat show/hide | [Gello — combat lockdown show](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762) | Insecure Show OK; secure child infects parent tree | always |
| Lockdown API | [InCombatLockdown](https://warcraft.wiki.gg/wiki/API_InCombatLockdown) | Defer protected mutations; Beef rarely needs them | always |
| FontString / Texture | [CreateFontString](https://wowpedia.fandom.com/wiki/API_Frame_CreateFontString) · [CreateTexture](https://wowpedia.fandom.com/wiki/API_Frame_CreateTexture) | `GameFont*` + stock textures; no custom `Media/` in V1 | always |
| Scroll lists | [FauxScrollFrame HOWTO](https://warcraft.wiki.gg/wiki/Making_a_scrollable_list_using_FauxScrollFrameTemplate) | Fixed pool first; Faux when viewport < data | later if needed |
| AnimationGroup | [AnimationGroup](https://warcraft.wiki.gg/wiki/UIOBJECT_AnimationGroup) · [CreateAnimationGroup](https://warcraft.wiki.gg/wiki/API_AnimatableObject_CreateAnimationGroup) | Toast enter/exit Alpha/Translation; `NONE` loop; Stop on hide | spectacle |
| OnUpdate hygiene | [UIHANDLER OnUpdate](https://warcraft.wiki.gg/wiki/UIHANDLER_OnUpdate) | Never permanent juice/scoring/net updaters | always (anti) |
| Dropdown taint | [LibUIDropDownMenu](https://www.wowinterface.com/downloads/info24408-LibUIDropDownMenu.html) · [TY archive](https://web.archive.org/web/20200715202710/https://www.townlong-yak.com/bugs/PfF9rr-UIDropDownMenu) | Avoid stock `UIDropDownMenu_*` / `EasyMenu` | if menus |
| Lua vs XML craft | [WoWI — Frames: XML vs LUA?](https://www.wowinterface.com/forums/showthread.php?t=51507) | Lua-first for Beef-sized UI; XML for virtual templates | always |
| FrameXML peeks | [Townlong Yak FrameXML](https://www.townlong-yak.com/framexml/live) | Rare verify of protected lineage / template names | rare |

---

## Annotated sources (≥20)

Numbered for citation from [01](01-classic-ui-architecture.md) / [02](02-lua-vs-xml-frames.md) / [03](03-taint-lockdown-ux.md). Prefer wiki.gg over stale mirrors when they disagree; still list Wowpedia / forums where Classic authors converge.

### A. TOC, packaging, load order

| # | Source | Why it matters for CoB |
|---|--------|------------------------|
| 1 | [TOC format — Warcraft Wiki](https://warcraft.wiki.gg/wiki/TOC_format) | Interface version tables, SavedVariables directives, client-specific TOC suffixes, load order. V1: single `20506` TOC; only list existing files. |
| 2 | [TOC format — Wowpedia](https://wowpedia.fandom.com/wiki/TOC_format) | Mirror for Packaging / SavedVariables wording when wiki.gg drifts. Same Beef rules. |
| 3 | [WelcomeHome: Your first Ace3 Addon — wiki.gg](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon) | Lifecycle timing analogue even without Ace: do not touch SV before named `ADDON_LOADED`. |

### B. Frames, templates, Lua vs XML

| # | Source | Why it matters for CoB |
|---|--------|------------------------|
| 4 | [API CreateFrame — Warcraft Wiki](https://warcraft.wiki.gg/wiki/API_CreateFrame) | Frame types, inherit lists, “frames are not GC’d,” OnLoad timing. Ground truth for pool-or-leak. |
| 5 | [API CreateFrame — Wowpedia](https://wowpedia.fandom.com/wiki/API_CreateFrame) | Classic-friendly examples of template inheritance (`"Button", nil, parent, "UIPanelButtonTemplate"`). |
| 6 | [CreateFrame — AddOn Studio](https://addonstudio.org/wiki/WoW:API_CreateFrame) | Readable restatement: cannot delete frames; virtual inherit; construction order pitfalls. |
| 7 | [Virtual XML template — Warcraft Wiki](https://warcraft.wiki.gg/wiki/Virtual_XML_template) | Lua cannot invent new FrameXML templates; `virtual="true"` is XML-only. |
| 8 | [XML user interface — Warcraft Wiki](https://warcraft.wiki.gg/wiki/XML_user_interface) | FrameXML grammar / when XML trees pay off. Beef stays Lua-primary. |
| 9 | [Frames: XML vs LUA? — WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=51507) | Author consensus: Lua-first fine for small/medium addons; XML for reusable templates. |
| 10 | [Creating a simple GUI element with XML — Blizzard UI (Gello)](https://us.forums.blizzard.com/en/wow/t/creating-a-simple-gui-element-with-xml/1488298) | Classic template guidance: `BasicFrameTemplate` shell; treat modern Retail panels as a different look path. |
| 11 | [BackdropTemplate — Warcraft Wiki](https://warcraft.wiki.gg/wiki/BackdropTemplate) | Mixin availability on modern Classic lineages; prefer template-native chrome before brand fills. |
| 12 | [BackdropTemplate — Wowpedia](https://wowpedia.fandom.com/wiki/BackdropTemplate) | Notes Classic backport (1.14.0 lineage) — Anniversary has BackdropTemplate. |
| 13 | [BackdropTemplate issues — Blizzard UI](https://us.forums.blizzard.com/en/wow/t/backdroptemplate-issues/1125674) | Multi-inherit pattern (`"BackdropTemplate,GameTooltipTemplate"`) and common failure modes. |
| 14 | [Widget API — Warcraft Wiki](https://warcraft.wiki.gg/wiki/Widget_API) | Index of frame methods (Show/Hide, SetPoint, strata) for insecure guest chrome. |

### C. Fonts, textures, regions

| # | Source | Why it matters for CoB |
|---|--------|------------------------|
| 15 | [Frame:CreateFontString — Wowpedia](https://wowpedia.fandom.com/wiki/API_Frame_CreateFontString) | Region factory; inherit `GameFontNormal` / `GameFontHighlight` family — V1 no custom fonts. |
| 16 | [UIOBJECT FontString — Warcraft Wiki](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) | SetText / SetTextColor / wrapping; dual-encode status in copy + color. |
| 17 | [Frame:CreateTexture — Wowpedia](https://wowpedia.fandom.com/wiki/API_Frame_CreateTexture) | Stock UI textures only in V1; no custom `Media/` TGA pack. |

### D. Taint, lockdown, secure model

| # | Source | Why it matters for CoB |
|---|--------|------------------------|
| 18 | [Secure Execution and Tainting — Warcraft Wiki](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting) | Canonical taint + protected-frame model. Ceremony chrome must stay insecure. |
| 19 | [Secure Execution and Tainting — Wowpedia](https://wowpedia.fandom.com/wiki/Secure_Execution_and_Tainting) | Mirror; use when wiki.gg is offline. |
| 20 | [Secure Execution — AddOn Studio](https://addonstudio.org/wiki/WoW:Secure_Execution_and_Tainting) | Clear `hooksecurefunc` wording (observe after secure work; do not replace). |
| 21 | [API InCombatLockdown — Warcraft Wiki](https://warcraft.wiki.gg/wiki/API_InCombatLockdown) | Lockdown timing vs `PLAYER_REGEN_*`; drain deferred work after combat. |
| 22 | [Showing Elements in Combat Lockdown — Blizzard UI (Gello)](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762) | Insecure Show/Hide OK in combat; a secure child can freeze the whole parent tree. |
| 23 | [API ShowUIPanel — Wowpedia](https://wowpedia.fandom.com/wiki/API_ShowUIPanel) | Combat protection lineage — prefer direct `:Show()` on Beef’s insecure main frame. |
| 24 | [API issecurevariable — Warcraft Wiki](https://warcraft.wiki.gg/wiki/API_issecurevariable) | Debug sticky globals after mysterious “Interface action failed…”. |
| 25 | [Townlong Yak — Taint about (archive)](https://web.archive.org/web/20210518120056/https://www.townlong-yak.com/taint.log/about.html) | `/console taintlog` levels and what is *not* logged. |
| 26 | [Townlong Yak — UIDropDownMenu issues (archive)](https://web.archive.org/web/20200715202710/https://www.townlong-yak.com/bugs/PfF9rr-UIDropDownMenu) | Why stock dropdowns are a known taint vector. |
| 27 | [LibUIDropDownMenu — WoWInterface](https://www.wowinterface.com/downloads/info24408-LibUIDropDownMenu.html) | Namespaced dropdown clone if Beef ever needs menus. |
| 28 | [SecureActionButtonTemplate — Warcraft Wiki](https://warcraft.wiki.gg/wiki/SecureActionButtonTemplate) | Protected action exposure — **do not** use for Beef panels/toasts. |
| 29 | [SecureTemplates overview — Warcraft Wiki](https://warcraft.wiki.gg/wiki/SecureTemplates) | Family map; reinforces “social guest UI ≠ secure templates.” |
| 30 | [better-addons — Security Model](https://www.better-addons.com/security) | Readable secondary overview of lockdown queues (wiki remains primary). |

### E. Lists, popups, FrameXML peeks

| # | Source | Why it matters for CoB |
|---|--------|------------------------|
| 31 | [FauxScrollFrame HOWTO — Warcraft Wiki](https://warcraft.wiki.gg/wiki/Making_a_scrollable_list_using_FauxScrollFrameTemplate) | Offset → rebind visible rows; default mental model if ladder outgrows fixed pool. |
| 32 | [FauxScroll in pure Lua — WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=45810) | CreateFrame + Faux without XML — fits Lua-primary Officer/Ladder. |
| 33 | [Creating simple pop-up dialog boxes — AddOn Studio](https://addonstudio.org/wiki/WoW:Creating_simple_pop-up_dialog_boxes) | `StaticPopupDialogs` + `preferredIndex = 3` pattern for demote/Prophet confirms. |
| 34 | [Townlong Yak FrameXML (live)](https://www.townlong-yak.com/framexml/live) | Peek Blizzard FrameXML when template names / protected lineage are unclear. |
| 35 | [QuickQuest #36 — panel open in combat](https://github.com/p3lim-wow/QuickQuest/issues/36) | Real-world `ShowUIPanel` combat breakage — cautionary for panel APIs. |

### F. Motion (Classic-friendly)

| # | Source | Why it matters for CoB |
|---|--------|------------------------|
| 36 | [UIOBJECT AnimationGroup — Warcraft Wiki](https://warcraft.wiki.gg/wiki/UIOBJECT_AnimationGroup) | Preferred short Alpha/Translation/Scale on insecure toast chrome. |
| 37 | [AnimatableObject:CreateAnimationGroup — Warcraft Wiki](https://warcraft.wiki.gg/wiki/API_AnimatableObject_CreateAnimationGroup) | Factory signature; works on Lua-created frames/regions. |
| 38 | [UIHANDLER OnUpdate — Warcraft Wiki](https://warcraft.wiki.gg/wiki/UIHANDLER_OnUpdate) | Why permanent OnUpdate for juice is banned; clear script on complete. |

### G. Classic ecosystem context (UI, not combat)

| # | Source | Why it matters for CoB |
|---|--------|------------------------|
| 39 | [Blizzard Watch — Classic/Anniversary UI modernization (2026-07-22)](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/) | Default Classic UI is drifting modern — “plain Classic frames” ≠ frozen 2007 pixels, still avoid Retail-only APIs. |
| 40 | [Overgear — TBC Anniversary top addons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/) | Players stack combat HUD center-mass; Beef must stay edge social (minimap / chat / guest panel). |

### H. Harvest deepen (2026-07-26 web pass) — gotchas + mirrors

| # | Source | Why it matters for CoB |
|---|--------|------------------------|
| 41 | [Classic taint resolution resources — Blizzard UI](https://us.forums.blizzard.com/en/wow/t/classic-taint-resolution-resourcesassistance/522359) | Real Classic case: `UIDROPDOWNMENU_MENU_LEVEL` tainted after moving options into the shared Interface Options panel; LibUIDropDownMenu / own frame fixes. |
| 42 | [Hooking functions — Warcraft Wiki](https://warcraft.wiki.gg/wiki/Hooking_functions) | `hooksecurefunc` / `HookScript` doctrine — post-hook only; never replace FrameXML handlers for polish. |
| 43 | [API hooksecurefunc — Warcraft Wiki](https://warcraft.wiki.gg/wiki/API_hooksecurefunc) | Signature + secure post-hook semantics. |
| 44 | [API C_Timer.After — Warcraft Wiki](https://warcraft.wiki.gg/wiki/API_C_Timer.After) | Preferred one-shot for toast hold / coalesce; no UI object required. |
| 45 | [Function timing — WoWInterface (Phanx / SDPhantom)](https://www.wowinterface.com/forums/showthread.php?t=49566) | OnUpdate countdown vs AnimationGroup delay vs `C_Timer.After`; NewTicker creates more overhead than bare `After`. |
| 46 | [WoWInterface — Animation roundup (zork era)](https://www.wowinterface.com/forums/showthread.php?t=35104) | Canonical community AnimationGroup cookbook + “out of body” hit-test warning (visual ≠ mouse rect until Stop). |
| 47 | [AnimationGroups and lua/xml — WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=49891) | Mixing Lua-created groups with XML `<Animations>` — prefer one style per frame. |
| 48 | [BackdropTemplate issue — WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=59730) | Dual-anchor without explicit `SetSize` → backdrop may not draw; size/layout before paint. |
| 49 | [FrameXML mirrors after Townlong Yak — Blizzard UI](https://us.forums.blizzard.com/en/wow/t/now-that-townlong-yak-is-apparently-gone-where-do-we-get-framexml-from/1262702) | When TY drifts: dump current client FrameXML / use community mirrors. |
| 50 | [Gethe/wow-ui-source — Backdrop.xml](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_SharedXML/Backdrop.xml) | Live FrameXML source mirror (wiki links here); verify BackdropTemplate lineage. |
| 51 | [Ketho — BlizzardInterfaceResources Templates.lua](https://github.com/Ketho/BlizzardInterfaceResources/blob/live/Resources/Templates.lua) | Complete FrameXML template name list referenced from CreateFrame docs. |
| 52 | [Widget script handlers — Warcraft Wiki](https://warcraft.wiki.gg/wiki/Widget_script_handlers) | OnLoad / OnUpdate / OnShow inventory for insecure guest chrome. |
| 53 | [UIHANDLER OnUpdate — Wowpedia](https://wowpedia.fandom.com/wiki/UIHANDLER_OnUpdate) | Cost scales with FPS; hidden frames skip OnUpdate — detach scripts when idle. |
| 54 | [Addon performance tracking misconceptions — r/wow (Numy)](https://www.reddit.com/r/wow/comments/1j1pxxj/about_the_new_addon_performance_tracking_common/) | Blizzard % is relative; high-FPS makes every-frame addons look worse; prefer average ms / peaks. Classic Era / Cataclysm Classic got related APIs — verify Anniversary before trusting microbutton % for Beef. |
| 55 | [Numy AddonProfiler — CurseForge](https://www.curseforge.com/wow/addons/numy-addon-profiler) | Peak / average / over-X-ms spike view — better smoke than a single %. |
| 56 | [ElvUI Classic FAQ — tukui-org wiki](https://github.com/tukui-org/ElvUI/wiki/classic-faq) | Pattern cite only (license-aware): Classic forks still fight strata / bags / taint — Beef stays guest chrome, not a UI replacement. |
| 57 | [tukui-org/ElvUI — GitHub](https://github.com/tukui-org/ElvUI) | Open Classic-capable UI replacement — study *patterns* (pools, strata), do not copy wholesale. |
| 58 | [WoW: UI beginner's guide — AddOn Studio](https://addonstudio.org/wiki/WoW:UI_beginner%27s_guide) | Onboarding for CreateFrame / events / slash — useful for agent orientation. |
| 59 | [r/wowaddondev](https://www.reddit.com/r/wowaddondev/) | Active author community for Classic/Retail addon questions. |
| 60 | [r/WowUI](https://www.reddit.com/r/WowUI/) | Player UI pack culture — Beef must not compete with combat HUD center-mass. |
| 61 | [NoTaint UIDropDownMenu — CurseForge (historical)](https://www.curseforge.com/wow/addons/notaint-uidropdownmenu) | Earlier dropdown clone lineage; prefer maintained LibUIDropDownMenu for any CoB menus. |
| 62 | [wowprogramming — CreateAnimationGroup (archive)](http://wowprogramming.com/docs/widgets/Region/CreateAnimationGroup) | Pre-wiki.gg widget docs still linked from community roundups. |
| 63 | [YouTube — How to create a simple WoW UI Addon](https://www.youtube.com/watch?v=RbgYCqWX_rE) | Entry-level CreateFrame pedagogy (ecosystem pointer; verify APIs against wiki). |
| 64 | [YouTube — CLEAN CLASSIC WoW UI Interface Tutorial](https://www.youtube.com/watch?v=4isKO1PACkE) | Classic shell taste reference — under-animated process chrome. |
| 65 | [martinjlowm/AnimationGroup (1.12)](https://github.com/martinjlowm/AnimationGroup) | Vanilla backport curiosity only — **not** for Anniversary `20506`. |

**Critical discoveries from this pass (agent TL;DR):**

1. **Animation hit-test ≠ visual:** Translation/Scale paint offset; mouse still hits the pre-animation anchor until `Stop` / SetPoint side-effect ([#46](#h-harvest-deepen-2026-07-26-web-pass--gotchas--mirrors)). Do not put clickable Approve/Reject on a sliding toast.  
2. **BackdropTemplate silent fails:** `SetBackdrop(sameTable)` after mutating fields does nothing — pass a **new** table; dual-anchor without size can draw nothing ([#11](#b-frames-templates-lua-vs-xml), [#48](#h-harvest-deepen-2026-07-26-web-pass--gotchas--mirrors)).  
3. **Dropdown taint on Classic is real:** Shared `UIDropDownMenu` globals + Interface Options = sticky taint until `/reload` ([#41](#h-harvest-deepen-2026-07-26-web-pass--gotchas--mirrors)).  
4. **FrameXML peeks:** Prefer Gethe / Ketho / client dump when Townlong Yak is stale ([#49](#h-harvest-deepen-2026-07-26-web-pass--gotchas--mirrors)–[#51](#h-harvest-deepen-2026-07-26-web-pass--gotchas--mirrors)).  
5. **Perf % traps:** Single Blizzard addon CPU % misleads at high FPS; measure average ms + spikes ([#54](#h-harvest-deepen-2026-07-26-web-pass--gotchas--mirrors)).

---

## So what for Church of Beef (agent checklist)

1. **Shell:** Named insecure `BasicFrameTemplate` under `UIParent`; toggle with `:Show()` / `:Hide()`.  
2. **TOC:** `20506` only; Data→Core→Net+UI→`ChurchOfBeef.lua` last; SV only after `ADDON_LOADED` name match.  
3. **Construction:** Lua-primary CreateFrame + stock button/font templates; pool ladder/officer rows.  
4. **Combat:** Never attach Secure* children to ceremony chrome; officers must open `/beef` mid-trash.  
5. **Juice motion:** AnimationGroup / short `C_Timer` on Beef-owned regions only; idle = no updater.  
6. **Avoid:** Retail DefaultPanel / Addon Compartment as sole entry; stock EasyMenu; `UIParent` scale; custom Media in V1.  
7. **Verify:** `/console scriptErrors 1` + `/reload` smoke; use taintlog only when “Interface action failed…” appears.

---

## Cross-links

| Need more depth | Go to |
|-----------------|-------|
| Architecture / pools / strata | [01](01-classic-ui-architecture.md) |
| CreateFrame recipes vs XML | [02](02-lua-vs-xml-frames.md) |
| Taint UX for officers | [03](03-taint-lockdown-ux.md) |
| Fonts / textures / no Media | [04](04-media-fonts-textures.md) |
| AnimationGroup cookbook | [56](56-wow-animationgroup-classic.md) |
| Procedural motion → API map | [15](15-procedural-ui-animation.md) |
| Perf budgets | [09](09-performance-budgets.md) · [51](51-adversarial-performance-vs-juice.md) |
| Broader Classic design lane | `docs/research/wow-classic-addon-design/06-annotated-master-reference-list.md` |

---

## Counts

| Metric | Value |
|--------|------:|
| Annotated web sources in this digest | **65** (≥20 required) |
| Focus client | Anniversary / Classic lineage (`20506`) |
| Product law? | **No** — research digest only |
| Harvest folder | `.firecrawl/classic-ui-digest/` (gitignored scrapes) |
