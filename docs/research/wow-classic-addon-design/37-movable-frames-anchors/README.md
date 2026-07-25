# Track 37 — Movable frames, anchors, position persistence

**Track id:** `37-movable-frames-anchors`  
**Last updated:** 2026-07-25  
**Sole focus:** Dragging `/beef` (and related) frames, `SetPoint` / anchor pitfalls, UIParent scale vs saved offsets, SavedVariables position persistence, combat lockdown constraints, and default placement for Beef toasts vs the main panel.  
**Out of scope:** Pixel-perfect UI scale math ([43-ui-scale-pixel-perfection](../43-ui-scale-pixel-perfection/)); SV schema / migration ([21-savedvariables-migration](../21-savedvariables-migration/)); toast *copy* and stream capture safe zones ([32-microcopy-tone-voice](../32-microcopy-tone-voice/), [17-stream-overlay-readability](../17-stream-overlay-readability/)); XML vs Lua construction ([35-xml-vs-lua-ui](../35-xml-vs-lua-ui/)). No addon implementation lives here.

## Product truth (from V1 spec)

| Locked default | Value |
|----------------|-------|
| Main frame | `/beef` opens a real frame — **movable, clamped to screen, saved position** |
| Toggle | Minimap button toggles the same frame |
| Persistence | `ChurchOfBeefDB` via `## SavedVariablesPerCharacter` — includes **UI prefs + frame position** |
| Toasts | Suggestion created · rank approved · Gora/ceremony credit (ephemeral; not the ladder window) |
| Combat | No combat automation; social UI must not fight lockdown / protected Blizzard frames |

Source: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §9–§10, §13.

## Index

| Note | Covers |
|------|--------|
| [dragging-and-anchors.md](dragging-and-anchors.md) | `SetMovable`, drag scripts, `StartMoving` / `StopMovingOrSizing`, `ClearAllPoints` + `SetPoint` pitfalls |
| [scale-and-coordinates.md](scale-and-coordinates.md) | UIParent / effective scale, `GetLeft`/`GetTop` space, LibWindow quadrant strategy |
| [position-persistence.md](position-persistence.md) | Layout-cache `UserPlaced` vs explicit SV; when to save/restore |
| [combat-lockdown.md](combat-lockdown.md) | What lockdown blocks; what Beef can still do |
| [beef-toast-panel-placement.md](beef-toast-panel-placement.md) | Default anchors for main panel vs toasts; stream collisions |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Spec already locks the hard requirements.** Main frame: movable + `SetClampedToScreen(true)` + position in `ChurchOfBeefDB` (per-character). Do not invent a second “profile position” store in V1; nest under `ui` inside the same SV ([track 21](../21-savedvariables-migration/)).

2. **Never `SetPoint` without `ClearAllPoints` when re-anchoring.** Stale anchors stack and produce “jumping” / off-screen / alternating-reload bugs. Canonical rule across wiki and community guides: clear, then set one intentional point family ([SetPoint](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint); [API cheat sheet Mistake 9](https://www.better-addons.com/api-cheatsheet)).

3. **`GetTop()` / `GetLeft()` are bottom-left space, not top-left space.** Offsets from `GetLeft`/`GetTop` are relative to the **bottom-left of the screen/UIParent**, in the region’s effective scale ([GetLeft](https://warcraft.wiki.gg/wiki/API_ScriptRegion_GetLeft); [Blizzard UI forum / Gello](https://us.forums.blizzard.com/en/wow/t/saving-addon-position/1201232)). Saving `Top` and reapplying as `TOPLEFT→TOPLEFT` with a positive Y is a classic off-by-frame-height bug.

4. **Prefer LibWindow’s strategy (or the library itself) over naive `GetLeft * EffectiveScale`.** Save in the **parent’s** scale; pick attach point by **screen quadrant** (closest corner to closest corner). That survives UI scale changes and desktop↔laptop SV copies ([LibWindow-1.1](https://www.wowace.com/projects/libwindow-1-1)).

5. **`StartMoving` destroys your parent anchors.** It clears existing points, flags `UserPlaced`, and on stop re-anchors to the **nearest screen corner** ([StartMoving](https://warcraft.wiki.gg/wiki/API_StartMoving)). After `StopMovingOrSizing`, **normalize** into your own `ClearAllPoints` + `SetPoint(UIParent, …)` and write SV — do not rely on the client layout cache alone for Beef (anonymous frames / late-created frames / reliability).

6. **Layout-cache auto-restore only helps named, movable, user-placed frames created before `PLAYER_LOGIN`.** Even then authors report flaky restores. Spec already wants SV; treat Blizzard layout cache as optional bonus, not the product path ([Making draggable frames](https://warcraft.wiki.gg/wiki/Making_draggable_frames); forum notes on `SetUserPlaced`).

7. **Combat lockdown: do not programmatically re-anchor protected Blizzard frames; Beef’s own non-secure panel is fine.** Lockdown blocks programmatic Show/Hide/attribute/anchor changes on **protected** frames (and parents / frames anchored into that hierarchy). User-initiated moves may still be allowed. Beef V1 should keep the ladder frame **non-secure**, allow open/drag out of combat without drama, and **queue or no-op** any combat-time show/reposition of UI that might become protected later ([InCombatLockdown](https://warcraft.wiki.gg/wiki/API_InCombatLockdown)).

8. **Toasts ≠ main panel.** Persist position only for the `/beef` window. Toasts should use a **fixed default anchor** (edge, title-safe, away from center/WA/DBM), optional later “toast anchor” pref — never inherit the dragged ladder position (stream + combat HUD collisions; [track 17](../17-stream-overlay-readability/)).

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Warcraft Wiki / WowAce LibWindow / Blizzard UI forum answers over generic “addon tutorial” blogs. Deeper scale/pixel topics defer to [43](../43-ui-scale-pixel-perfection/).
