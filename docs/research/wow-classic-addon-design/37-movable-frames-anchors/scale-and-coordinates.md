# UIParent scale and coordinate space

**Track:** [37-movable-frames-anchors](README.md)  
**Related:** [43-ui-scale-pixel-perfection](../43-ui-scale-pixel-perfection/) owns pixel-perfect `uiScale` math; this note only covers **position save/restore** under scale.

## Two coordinate languages

| System | Origin | Max Y (screen units) | Used by |
|--------|--------|----------------------|---------|
| Screen / cursor | Bottom-left (0,0) | Always **768** height units; width varies by aspect | `GetCursorPosition`, some rect helpers ([UI scaling](https://wowpedia.fandom.com/wiki/UI_scaling)) |
| Region layout | Bottom-left of screen/window, in the region’s **effective scale** | Frame edges via `GetLeft` / `GetRight` / `GetBottom` / `GetTop` | Positioning queries ([GetLeft](https://warcraft.wiki.gg/wiki/API_ScriptRegion_GetLeft)) |

`UIParent` covers the screen and is the usual parent so addon frames inherit a common scale ([UI scaling](https://wowpedia.fandom.com/wiki/UI_scaling)). Players change scale via System → Graphics (`useUiScale` / `uiScale`).

**Critical mental model:** `GetTop()` is **not** “distance from the top of the screen.” It is the Y of the top edge measured from the **bottom-left**, same family as `GetBottom` ([Blizzard forum / Gello](https://us.forums.blizzard.com/en/wow/t/saving-addon-position/1201232)). Restoring with:

- saved `Left`,`Top` + `SetPoint("TOPLEFT", UIParent, "TOPLEFT", left, top)` → wrong  
- saved `Left`,`Top` + `SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)` → matches `GetLeft`/`GetTop` space  

(Still inferior to quadrant-relative save; see below.)

`SetPoint` offsets are themselves affected by scale: increasing a region’s scale increases the visual size of those offsets ([SetPoint details](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint)).

## Anti-patterns when saving position

| Approach | Failure mode |
|----------|--------------|
| `x = GetLeft() / GetEffectiveScale()` (frame’s own) | Diverges from parent scale; gaps/overlaps when UI scale changes ([LibWindow](https://www.wowace.com/projects/libwindow-1-1)) |
| Always `TOPLEFT` + raw `GetLeft`/`GetTop` without matching relative point | Off-screen or “increments by frame height” each logout ([forum thread](https://us.forums.blizzard.com/en/wow/t/saving-addon-position/1201232)) |
| Saving only x/y, never `point` | After `StopMovingOrSizing`, client may have glued you to BOTTOMRIGHT etc.; restore with wrong corner clips off-screen ([GetPoint patch note culture](https://wowwiki.fandom.com/wiki/API_Region_GetPoint)) |
| Trusting `GetPoint` *during* a drag | Prefer stop first, then read geometry ([WoWInterface guidance](https://www.wowinterface.com/forums/showthread.php?t=29956)) |

## LibWindow strategy (recommended pattern)

[LibWindow-1.1](https://www.wowace.com/projects/libwindow-1-1) exists because authors get scale wrong. Steal at least the **ideas** even if Beef avoids the dependency in V1:

1. **Save in the parent’s scale**, not the frame’s effective scale.
2. **Choose attach point by quadrant** — if the window lives in the bottom-right, save `BOTTOMRIGHT`→`BOTTOMRIGHT` (etc.), so resolution/scale changes keep it on-screen and keep sibling windows’ relative clustering (bag analogy in LibWindow docs).
3. Persist `{ point, x, y [, scale] }` in config storage (`RegisterConfig` / `SavePosition` / `RestorePosition` / `MakeDraggable` API).

Migration warning from LibWindow: old “global scale” SV numbers need division by `UIParent:GetScale()` once before first LibWindow restore, unless UIParent scale is 1.0 ([WowAce overview](https://www.wowace.com/projects/libwindow-1-1)).

## Beef V1 recommendation

- Parent the main frame to **`UIParent`**.
- Persist under `ChurchOfBeefDB` → `ui` (name TBD) at least: `point`, `x`, `y` (and `scale` only if you expose window scale).
- Implement LibWindow-equivalent quadrant save **or** embed LibWindow via LibStub if Ace/lib stack is already in play ([track 03 Ace libs](../03-ace-libs-options/) when relevant).
- On restore after `ADDON_LOADED` (SV ready): `ClearAllPoints` → `SetPoint` → `SetClampedToScreen(true)`.
- Pixel-snapping / `768/resolution` scale tricks belong in [43](../43-ui-scale-pixel-perfection/), not in position structs.
