# Track 36 — Tooltips, Dropdowns, Context Menus

**Track id:** `36-tooltips-menus`  
**Last updated:** 2026-07-25  
**Sole focus:** Classic `GameTooltip` norms, `UIDropDownMenu` vs `LibUIDropDownMenu-4.0`, right-click / context-menu patterns for officer actions, and how those map to Church of Beef V1 UI.  
**Out of scope:** Full taint model (→ [29-taint-secure-ui](../29-taint-secure-ui/)), AceConfig options chrome (→ [03-ace-libs-options](../03-ace-libs-options/)), slash officer verbs (→ [22-slash-commands-ux](../22-slash-commands-ux/)), roster Officer+ gates (→ [16-guild-roster-officer-edges](../16-guild-roster-officer-edges/)). No addon implementation in this folder.

## Product truth (from V1 spec)

| Locked stance | Implication for this track |
|---------------|----------------------------|
| Ladder / Standing / Officer tabs | Hover copy, filter dropdowns, row actions — not combat HUD tooltips |
| Officer+ approve / reject / demote / appoint | Prefer in-panel buttons + confirm; context menus are optional shortcuts |
| Officer tab hidden for non-officers | Never expose approve verbs via UnitPopup to members; soft-deny if somehow invoked |
| Social / streamer tool | Reuse global `GameTooltip` for chrome; avoid tainting Blizzard menus |

Source: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §6, §10, §11.

## Docs in this track

| File | Contents |
|------|----------|
| [01-gametooltip-norms.md](01-gametooltip-norms.md) | `SetOwner` / `AddLine` / Show-Hide cycle, anchors, scanning tooltips, LibQTip |
| [02-uidropdown-vs-libuidropdown.md](02-uidropdown-vs-libuidropdown.md) | Stock dropdown taint story; LibUIDropDownMenu-4.0 migration; AceGUI alternative |
| [03-context-menus-officer-actions.md](03-context-menus-officer-actions.md) | `MENU` mode, EasyMenu, UnitPopup hooks, officer action inventory |
| [04-beef-ui-relevance.md](04-beef-ui-relevance.md) | Concrete V1 recommendations for Ladder / Standing / Officer surfaces |
| [05-annotated-urls.md](05-annotated-urls.md) | Annotated primary URLs with steal/adapt notes |

## Top takeaways (one screen)

1. **Tooltip ritual is fixed:** `SetOwner` → lines → `Show` on `OnEnter`; `Hide` on `OnLeave`. `AddLine` alone does not show or resize correctly if the tip is already visible — call `Show` after building ([GameTooltip:AddLine](https://warcraft.wiki.gg/wiki/API_GameTooltip_AddLine); [UIOBJECT_GameTooltip](https://warcraft.wiki.gg/wiki/UIOBJECT_GameTooltip)).
2. **Prefer the shared `GameTooltip` for Beef chrome.** Custom multi-column tips (LibQTip) are overkill for V1 ladder rows; save them for dense LDB/minimap summaries if needed ([LibQTip-1.0](https://www.wowace.com/projects/libqtip-1-0)).
3. **Do not call stock `UIDropDownMenu` / `EasyMenu` from Beef.** Shared FrameXML menus historically taint Blizzard UI; embed `LibUIDropDownMenu-4.0` or use AceGUI dropdown widgets ([LibUIDropDownMenu](https://www.wowace.com/projects/libuidropdownmenu); [track 29](../29-taint-secure-ui/)).
4. **Context menus = `displayMode "MENU"` + `ToggleDropDownMenu` / EasyMenu at cursor** — same template as dropdowns, different chrome ([Using UIDropDownMenu](https://warcraft.wiki.gg/wiki/Using_UIDropDownMenu)).
5. **Officer actions belong in the Officer tab first.** Right-click UnitPopup entries are fragile on Classic (grayed buttons, secure paths) and leak authority UX into non-Beef frames — treat as V2 nicety, not V1 path ([Blizzard forum BlackList thread](https://us.forums.blizzard.com/en/wow/t/wow-classic-blacklist-addon/346193)).
6. **Destructive officer verbs need confirm UI**, not a silent menu click — demote / Prophet / standing wipe are first-class content and should use a StaticPopup (or Ace dialog) with `preferredIndex = 3` (see track 29).

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Warcraft Wiki / WowAce / CurseForge / Townlong Yak over secondary listicles.
