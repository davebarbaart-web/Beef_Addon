# Events vs OnUpdate and Throttling

**Last updated:** 2026-07-25  
**Primary sources:** [Handling events](https://warcraft.wiki.gg/wiki/Handling_events), [UIHANDLER OnUpdate](https://warcraft.wiki.gg/wiki/UIHANDLER_OnUpdate), [API C_Timer.NewTicker](https://warcraft.wiki.gg/wiki/API_C_Timer.NewTicker)

---

## 1. Prefer events for game-state logic

Events are discrete notifications (`PLAYER_ENTERING_WORLD`, `PLAYER_REGEN_DISABLED`, `GROUP_ROSTER_UPDATE`, `CHAT_MSG_ADDON`, guild roster events, etc.).

Pattern (conceptual):

- Create a frame (Lua or XML).
- `RegisterEvent("EVENT_NAME")` for each needed event.
- Handle in `OnEvent`; unregister when idle.

Wiki also documents handler tables keyed by event name to avoid long if-chains.

**For Church of Beef:** scoring triggers (instance state, ceremony close, Gora result, guild roster for officer checks) should be **event-driven**, not polled every frame.

---

## 2. What OnUpdate actually costs

From [UIHANDLER OnUpdate](https://warcraft.wiki.gg/wiki/UIHANDLER_OnUpdate):

- Fires when the UI is drawn — **many times per second**, scaling with FPS (dozens to hundreds of Hz on modern hardware).
- Payload: `(self, elapsed)` where `elapsed` is seconds since last OnUpdate for that widget.
- **Blocked when the frame (or a parent) is hidden** — hide unused updater frames.
- Wiki guidance: OnUpdate is resource intensive; prefer `C_Timer.After` / `C_Timer.NewTicker`, or Animations for widget motion; otherwise **throttle** work inside OnUpdate.

Community / deep-research consensus (2024–2026): treat unthrottled OnUpdate as a primary FPS footgun. Combat-heavy addons (WeakAuras, nameplates, boss mods) dominate profiler time; social addons should stay near-zero in combat.

---

## 3. When each tool is appropriate

| Mechanism | Use for | Avoid for |
|-----------|---------|-----------|
| `RegisterEvent` / `OnEvent` | Discrete state changes | Continuous interpolation |
| Throttled `OnUpdate` | Smooth UI motion tied to frames; rare “until condition” watches | Scoring, networking, SV writes |
| `C_Timer.NewTicker` / `After` | Fixed-interval work independent of FPS | Sub-frame visual polish |
| Animation objects | Alpha/position easing | Business logic |

---

## 4. Throttling patterns (descriptive)

### Accumulator inside OnUpdate

Wiki example: accumulate `elapsed` until a threshold (e.g. 0.05s ≈ 20 Hz), then do work and reset. Common social-UI choice: **0.1–0.5 s** for ladder refresh / toast coalescing.

### Disable the script when idle

`frame:SetScript("OnUpdate", nil)` (or hide the frame) when no smooth animation is running. A permanently registered empty OnUpdate still has dispatch cost.

### Timers instead of OnUpdate

For “every N seconds check X,” timers avoid coupling work rate to FPS. Cancel tickers on disable / logout.

### Coalesce UI updates

If many BeefNet messages arrive, dirty-flag the ladder and refresh once per short interval rather than rebuilding the full list per message.

---

## 5. Messaging throttle (cross-cutting)

Design spec §8 already requires ChatThrottleLib-style pacing for `SendAddonMessage`. That is **orthogonal** to OnUpdate but part of the same performance story:

- Prefer commits / coarse events over high-frequency spam.
- Guild channel broadcasts for promotions: **one throttled line from the approving officer** (spec §10).
- Login `SYNC_REQUEST` / `SYNC_STATE`: random delay + suppression to avoid reply storms (spec §8.3).

---

## 6. Hot-path hygiene

- Localize frequently used globals at file/function scope.
- Avoid allocating large tables every tick.
- Do not parse guild roster or rebuild the full ladder UI from OnUpdate.
- Instance “time buckets” for standing (spec §7): drive from events + a **low-rate** ticker or throttled check, not per-frame combat scanning.

---

## 7. Church of Beef defaults (research recommendation)

| Area | Recommendation |
|------|----------------|
| Core scoring | Events only |
| Officer roster validation | On demand + roster events; cache |
| Ladder UI rebuild | Dirty flag + ≤10 Hz coalesce when open |
| Toasts | Event → show; no OnUpdate unless animating |
| Minimap button | Library / click handlers; no spin loops |
| Permanent OnUpdate | **None** in V1 unless a specific animation needs it |
