# Position persistence

**Track:** [37-movable-frames-anchors](README.md)  
**Related:** [21-savedvariables-migration](../21-savedvariables-migration/) for SV scope, schema, and wipe recovery.

## Two persistence mechanisms

| Mechanism | Requirements | Pros | Cons for Beef |
|-----------|--------------|------|---------------|
| **Client layout cache** (`UserPlaced`) | Named frame, `SetMovable`, created **before** `PLAYER_LOGIN`, user-placed flag set (auto by `StartMoving`) | Zero SV code if it works | Flaky; anonymous frames ineligible; fights you if you also `SetPoint` on login; not in `ChurchOfBeefDB` export story ([StartMoving](https://warcraft.wiki.gg/wiki/API_StartMoving); [Making draggable frames](https://warcraft.wiki.gg/wiki/Making_draggable_frames); [Fizzlemizz on SetUserPlaced](https://us.forums.blizzard.com/en/wow/t/saving-frame-positionshown/259885)) |
| **Explicit SavedVariables** | Write on drag-stop; restore after `ADDON_LOADED` | Spec-aligned; per-character; exportable with `ui` prefs; deterministic | Must get scale/point math right ([scale-and-coordinates.md](scale-and-coordinates.md)) |

Spec §9 already stores **frame position** in `ChurchOfBeefDB` (`SavedVariablesPerCharacter`). **Treat SV as the source of truth.** Optionally call `SetUserPlaced(false)` after moves if you want to suppress layout-cache surprises ([StartMoving](https://warcraft.wiki.gg/wiki/API_StartMoving)).

## When to write / read

| Moment | Action |
|--------|--------|
| `ADDON_LOADED` for Church of Beef | Defaults merge; if saved `ui.point` exists, restore; else default center/offset |
| `OnDragStop` / mouse-up end | `StopMovingOrSizing` → normalize point → write SV **immediately** ([Gello](https://us.forums.blizzard.com/en/wow/t/saving-addon-position/1201232)) |
| Options “Reset window” | Wipe `ui` position keys; `ClearAllPoints`; apply default; save |
| `PLAYER_LOGOUT` | Optional redundancy only — not the primary write path |
| Hidden at logout | Still fine if last drag-stop already saved; do not require `IsShown` to persist position |

`GetLeft`/`GetTop` are only reliable when layout is valid (historically: after login, and preferably while shown — community lore from GetBottom docs). Prefer reading geometry **right after** `StopMovingOrSizing` while the frame is still shown ([forum](https://us.forums.blizzard.com/en/wow/t/saving-addon-position/1201232)).

## Suggested SV shape (research, not schema lock)

Nest under the UI prefs subtree (track 21 doctrine: separate `ui` from ladder authority):

```text
ChurchOfBeefDB.ui.mainFrame = {
  point = "TOPLEFT",  -- or BOTTOMRIGHT, etc. (quadrant strategy)
  x = 0,
  y = 0,
  -- scale = 1,       -- only if user-scalable window ships
}
```

Toast anchors (if ever user-configurable) should be a **separate** key, e.g. `ui.toast`, never aliased to `mainFrame`.

## Reset and recovery

- Resolution / multi-monitor changes can leave windows feeling “lost” even with clamp ([Talk page](https://wowpedia.fandom.com/wiki/Talk:Making_draggable_frames)).
- Ship `/beef resetui` or an options button: clear points → center on `UIParent` → clear saved offsets.
- Character SV wipe resets position with other UI prefs; that is acceptable V1 (alts are separate flesh — spec §9).

## Do not persist

- Ephemeral toast stack positions
- Open/closed tab index (optional later; not “frame position”)
- Officer-only child dialogs unless they are independently user-placed by design
