# Dragging and SetPoint / anchor pitfalls

**Track:** [37-movable-frames-anchors](README.md)

## Drag pipeline (community canon)

Frames become draggable by combining movability with a start/stop move pair ([Making draggable frames](https://warcraft.wiki.gg/wiki/Making_draggable_frames)):

1. `SetMovable(true)`
2. `EnableMouse(true)` (or click-enabled equivalent)
3. Either:
   - **OnDragStart / OnDragStop** + `RegisterForDrag("LeftButton")` — slight drag threshold before move starts (better if the frame also has clickable children), or
   - **OnMouseDown / OnMouseUp** — more responsive; starts immediately
4. Inside start: `StartMoving()`
5. Inside stop: `StopMovingOrSizing()`, then **normalize anchors + save position**

XML `TitleRegion` and Retail-oriented `PanelDragBarTemplate` exist; for Classic Anniversary V1, plain Lua drag handlers on a title bar region are the portable path ([Making draggable frames](https://warcraft.wiki.gg/wiki/Making_draggable_frames); [Making movable and resizable frames](https://warcraft.wiki.gg/wiki/Making_movable_and_resizable_frames) is more modern-template-heavy).

## What `StartMoving` actually does

From [Frame:StartMoving](https://warcraft.wiki.gg/wiki/API_StartMoving):

- Errors if the frame is not movable.
- Flags the widget as **user-positioned** (`UserPlaced`).
- **Clears any existing anchors.**
- On stop (or hide of self/ancestor), the frame is re-anchored to the **nearest corner of the screen**.

Implication for Beef: after a drag, do not assume the frame is still parent-anchored the way you created it. Explicitly re-`SetPoint` to `UIParent` (or keep LibWindow’s restore path) and persist.

Older Studio/wiki notes also warn that `StartMoving` can re-anchor a child away from its logical parent to **screen dimensions** — the original parent offset is not restored by `StopMovingOrSizing` alone ([AddOn Studio StartMoving notes](https://addonstudio.org/wiki/WoW:API_Frame_StartMoving)). Child option panels should either (a) re-anchor to the main frame after parent moves, or (b) be parented such that they move with the parent without becoming independently `UserPlaced` unless intended ([Blizzard forum follow-up](https://us.forums.blizzard.com/en/wow/t/saving-addon-position/1201232)).

## SetPoint pitfalls that actually bite

| Pitfall | Why it hurts | Mitigation |
|---------|--------------|------------|
| Missing `ClearAllPoints` | Multiple points fight; layout becomes under-constrained or corner-pinned oddly | Always clear before a new single-point placement ([SetPoint](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint); [cheat sheet Mistake 9](https://www.better-addons.com/api-cheatsheet)) |
| Passing only one of `ofsx`/`ofsy` | Both must be present for either to apply; a lone number is ignored | Pass both offsets or neither ([archive SetPoint details](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint)) |
| Wrong relative point vs saved coords | `GetTop` is from bottom-left; applying as top-left Y flips / accumulates height | Save/restore with a consistent point pair (see [scale-and-coordinates.md](scale-and-coordinates.md)) |
| Anchoring to `nil` / screen by accident | `relativeTo` omitted → parent; explicit `nil` → **screen dimensions**; mixing UIParent + screen can throw “anchor family” errors | Prefer explicit `UIParent` for Beef windows ([SetPoint](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint)) |
| Edge points alone | `TOP`/`LEFT`/etc. are edges; incomplete edge sets “pull” toward center | Use corners or fully define size + points |
| Secure / restricted relatives | Protected frames may silently ignore some `SetPoint` calls; restricted-frame families limit cross-hierarchy anchors | Keep Beef frames non-secure; never glue onto nameplates / protected unit frames ([SetPoint details](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint)) |

## Clamp to screen (spec-mandated)

`SetClampedToScreen(true)` prevents drag/`SetPoint` from parking the frame partially off-screen; the client adjusts points so the whole frame stays visible ([SetClampedToScreen](https://warcraft.wiki.gg/wiki/API_Frame_SetClampedToScreen); [archive wording](https://wowwiki-archive.fandom.com/wiki/API_Frame_SetClampedToScreen)). Spec §10 requires this for `/beef`. Still provide a **reset position** slash/options action for the rare “I can’t find my window” case after resolution changes ([Talk:Making draggable frames](https://wowpedia.fandom.com/wiki/Talk:Making_draggable_frames) — reset needs `ClearAllPoints` first).

## Drag UX recommendations for `/beef`

- Drag from a **title bar / header**, not from tab contents or scroll areas (avoids fighting buttons).
- Prefer **OnDragStart** on the header if the header also has close/minimap-adjacent clicks.
- Keep **Officer tab buttons** and edit boxes out of the drag hit target.
- After stop: stop → clear → set → write `ChurchOfBeefDB.ui` (or equivalent nest) immediately — do not wait for `PLAYER_LOGOUT` ([Gello](https://us.forums.blizzard.com/en/wow/t/saving-addon-position/1201232)).
