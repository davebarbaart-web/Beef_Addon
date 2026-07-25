# Beef toast and panel placement

**Track:** [37-movable-frames-anchors](README.md)  
**Complements:** [17-stream-overlay-readability](../17-stream-overlay-readability/) (capture safe zones), [32-microcopy-tone-voice](../32-microcopy-tone-voice/) (toast length), [08-combat-hud-alerts](../08-combat-hud-alerts/) (do not become a combat HUD).

## Two surfaces, two rules

| Surface | Movable? | Persist position? | Default anchor idea |
|---------|----------|-------------------|---------------------|
| **Main `/beef` panel** | Yes (spec) | Yes (`ChurchOfBeefDB` ui) | Centered or slight upper-center on first run; then user-placed + clamped |
| **Toasts** (suggestion / rank / Gora credit) | No in V1 (optional later) | No in V1 | Fixed edge stack; independent of panel |

Do **not** parent toasts to the main panel in a way that makes them jump when the ladder is dragged mid-toast. Parent toasts to `UIParent` (or a dedicated non-movable anchor frame).

## Main panel defaults

- First launch: `CENTER` on `UIParent` (or `TOP` with a modest negative Y) so the “command works, nothing appears” failure mode is impossible to miss (spec §10).
- After first drag: restore saved quadrant-relative point ([scale-and-coordinates.md](scale-and-coordinates.md)).
- Always `SetClampedToScreen(true)`.
- Strata: high enough to clear world frame, but below Blizzard modal dialogs (`DIALOG` / `FULLSCREEN_DIALOG` as needed — pick one and stay consistent).
- Size: large enough for seven ranks + tabs; resizing is **out of scope for V1** unless cheap — prefer fixed size over `StartSizing` complexity.

## Toast placement (V1)

Goals: readable on stream, non-blocking in combat footage, not competing with guild chat’s spectacle role ([track 17 verdict](../17-stream-overlay-readability/README.md)).

**Recommended default:** top-center or upper-third stack, **inside title-safe (~80%)**, with an opaque/scrimmed backing — not bottom-right (streamer alert kit), not center fovea (WA/DBM), not on top of the minimap button cluster ([capture-safe-zones](../17-stream-overlay-readability/capture-safe-zones.md)).

| Avoid | Why |
|-------|-----|
| Center / center-lower | Combat HUD / character / WA |
| Bottom-right | Webcam + Streamlabs/SE alerts |
| Bottom-left | Chat overlay |
| Top-right hugging minimap | LibDBIcon / buff clutter |
| Same point as saved `/beef` frame | Dragging the panel should not redefine toast choreography |

Stack policy: one toast at a time (or a short queue with replace), auto-dismiss in a few seconds — copy budgets in [32](../32-microcopy-tone-voice/); timing in [17 duration notes](../17-stream-overlay-readability/).

## Optional V2 knobs (do not build yet)

- “Toast anchor” preset: Top / Bottom / Left / Right
- “Unlock toast anchor” drag handle (then LibWindow the toast host only)
- Streamer profile: toasts on, SFX off ([20-sound](../20-sound-sfx-feedback/))

## Interaction with minimap toggle

Minimap button toggles **visibility** of the same main frame; it must not reset anchors. If the frame was user-placed, toggle Show/Hide only. Creating a new frame instance on each `/beef` is the historical “nothing appears” / position-loss footgun — create once, show/hide thereafter (spec §10).
