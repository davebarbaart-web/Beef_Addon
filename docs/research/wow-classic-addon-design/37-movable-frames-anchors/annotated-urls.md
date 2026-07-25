# Annotated URLs — movable frames / anchors / persistence

Primary sources for track 37. Prefer these over generic “first addon” blogs when deciding Beef drag/save behavior.

## Drag and widget APIs

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/Making_draggable_frames | Canonical HOWTO: `SetMovable` + `StartMoving`/`StopMovingOrSizing`; OnDrag vs OnMouseDown; layout-cache caveats for named pre-login frames. |
| https://wowpedia.fandom.com/wiki/Making_draggable_frames | Mirror of the HOWTO. |
| https://warcraft.wiki.gg/wiki/API_StartMoving | Restricted on secure frames; sets UserPlaced; **clears anchors**; stop re-anchors to nearest screen corner. |
| https://wowpedia.fandom.com/wiki/API_Frame_StartMoving | Mirror + Classic version links. |
| https://addonstudio.org/wiki/WoW:API_Frame_StartMoving | Explicit warning: StartMoving re-anchors away from parent to screen coords; parent offset not restored. |
| https://wowwiki-archive.fandom.com/wiki/API_Frame_RegisterForDrag | RegisterForDrag overrides; need Left+Right explicitly if both; pairs with EnableMouse. |
| https://warcraft.wiki.gg/wiki/Making_movable_and_resizable_frames | Modern template drag/resize (PanelDragBar); useful contrast — prefer simple Classic-safe path for V1. |

## SetPoint / geometry

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint | Current SetPoint signature; nil→screen; offset pairing; scale note; restricted anchor families. |
| https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint | Classic-era details: ClearAllPoints when repositioning; ofsx/ofsy both-or-neither. |
| https://warcraft.wiki.gg/wiki/API_ScriptRegion_GetLeft | GetLeft/Right/Bottom/Top — offsets from bottom-left in effective scale. |
| https://wowpedia.fandom.com/wiki/API_ScriptRegion_GetLeft | Mirror. |
| https://wowwiki.fandom.com/wiki/API_Region_GetPoint | Reminder to save `relativePoint` with offsets (post-2.2 closest-edge behavior lore). |
| https://warcraft.wiki.gg/wiki/API_Frame_SetClampedToScreen | Spec-mandated clamp; applies to SetPoint + drag + sizing. |
| https://wowwiki-archive.fandom.com/wiki/API_Frame_SetClampedToScreen | Archive examples of clamp overriding off-screen SetPoint. |
| https://www.better-addons.com/api-cheatsheet | Mistake 9: forgetting ClearAllPoints — high-signal for AI/codegen footguns. |

## Scale

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://wowpedia.fandom.com/wiki/UI_scaling | Screen units (Y max 768), UIParent, effective scale, cursor conversion examples. |
| https://wowpedia.fandom.com/wiki/API_Region_SetScale | Points to LibWindow for window-style position save. |
| https://www.wowace.com/projects/libwindow-1-1 | **Gold standard:** parent-scale save, quadrant attach, MakeDraggable / SavePosition / RestorePosition. |
| https://www.curseforge.com/wow/addons/libwindow-1-1 | Distribution + diagram (“how scaling and positioning works”). |
| https://addonswow.com/libwindow-11 | Mirrors LibWindow “old global-scale SV incompatible” warning. |

## Persistence / community fixes

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://us.forums.blizzard.com/en/wow/t/saving-addon-position/1201232 | Gello: `GetTop` is from BOTTOMLEFT; save on StopMovingOrSizing; UserPlaced layout cache tradeoffs. |
| https://us.forums.blizzard.com/en/wow/t/saving-frame-positionshown/259885 | SetUserPlaced only for frames created before PLAYER_LOGIN; named frames required for layout cache. |
| https://www.wowinterface.com/forums/showthread.php?t=29956 | Stop before reading coords; ClearAllPoints before re-SetPoint after drag. |
| https://www.wowinterface.com/forums/showthread.php?t=48862 | Long-form scale + anchor intuition (0,0 bottom-left); resize/drag interaction hazards. |
| https://wowpedia.fandom.com/wiki/Talk:Making_draggable_frames | Lost-offscreen frames → reset needs ClearAllPoints then SetPoint. |

## Combat lockdown / taint

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/API_InCombatLockdown | Protected Show/Hide/attributes/programmatic re-anchor blocked; user moves may still work. |
| https://www.wowinterface.com/forums/showthread.php?p=313021 | Pattern: gate SetShown when container has protected children + InCombatLockdown. |
| https://www.wowinterface.com/forums/showthread.php?t=52537 | Why **not** to SetPoint Blizzard unit frames — taint / combat stories. |

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §9–§10 | Movable + clamped + saved position; toast events; SV name/scope. |
| [`../21-savedvariables-migration/`](../21-savedvariables-migration/) | Where `ui` / frame position lives on disk; wipe semantics. |
| [`../17-stream-overlay-readability/`](../17-stream-overlay-readability/) | Toast safe zones vs panel chrome. |
| [`../43-ui-scale-pixel-perfection/`](../43-ui-scale-pixel-perfection/) | Pixel-perfect scale (not position structs). |

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-movable-frames.json`](.raw/search-movable-frames.json) | LibWindow, save-position forum, RegisterForDrag |
| [`.raw/search-anchors-scale.json`](.raw/search-anchors-scale.json) | SetPoint, ClearAllPoints, GetPoint, cheat sheet |
| [`.raw/search-lockdown-clamp.json`](.raw/search-lockdown-clamp.json) | StartMoving, InCombatLockdown, taint / movable+buttons |
| [`.raw/search-getleft-clamp.json`](.raw/search-getleft-clamp.json) | GetLeft, SetClampedToScreen, SetUserPlaced |
| [`.raw/search-draggable-howto.json`](.raw/search-draggable-howto.json) | Making draggable frames HOWTO excerpts |
| [`.raw/extract-setpoint.json`](.raw/extract-setpoint.json) | Warcraft Wiki SetPoint extract |
| [`.raw/extract-libwindow.json`](.raw/extract-libwindow.json) | WowAce LibWindow extract |
| [`.raw/extract-ui-scaling.json`](.raw/extract-ui-scaling.json) | UI scaling extract |
| [`.raw/extract-startmoving.json`](.raw/extract-startmoving.json) | StartMoving extract |
| [`.raw/extract-startmoving-wowpedia.json`](.raw/extract-startmoving-wowpedia.json) | Wowpedia StartMoving extract |
| [`.raw/extract-incombatlockdown.json`](.raw/extract-incombatlockdown.json) | InCombatLockdown extract |
| [`.raw/extract-blizzard-save-position.json`](.raw/extract-blizzard-save-position.json) | Gello/Carnacki forum extract |
