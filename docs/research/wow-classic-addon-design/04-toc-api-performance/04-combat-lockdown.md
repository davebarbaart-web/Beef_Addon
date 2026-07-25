# Combat Lockdown, Protected Frames, and Taint

**Last updated:** 2026-07-25  
**Primary sources:** [API InCombatLockdown](https://warcraft.wiki.gg/wiki/API_InCombatLockdown), [Secure Execution and Tainting](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)

---

## 1. Why this exists

Since patch 2.0, the UI API mandates human decision-making in combat. Classic clients use the **modern** secure-execution model: third-party addon code is tainted and cannot freely drive targeting, casting, movement, or arbitrary combat UI mutation.

Church of Beef design spec §2 already forbids protected-action circumvention and “playing the game for anyone.” This document records the **mechanical** constraints that enforce that stance.

---

## 2. `InCombatLockdown()`

```
inLockdown = InCombatLockdown()
```

Returns true while combat lockdown restrictions are active.

**Timing (wiki):**

- Lockdown begins **after** `PLAYER_REGEN_DISABLED`.
- Lockdown ends **before** `PLAYER_REGEN_ENABLED`.

### Restrictions while in lockdown

From the API page (non-exhaustive):

- Programmatic modification of macros or bindings is not allowed.
- On **protected** frames (and parents / frames they are anchored to), addon code generally cannot:
  - `Show` / `Hide`
  - Change attributes used by secure templates
  - Re-point / re-anchor (user-initiated moves may still be allowed)

Attempting forbidden operations fails (errors / no-ops depending on path). The standard response is: **check `InCombatLockdown()`, defer work until `PLAYER_REGEN_ENABLED`.**

---

## 3. Protected frames vs secure templates

- **Protected frame:** locked down in combat; cannot be freely reconfigured by tainted code.
- **Secure templates** (`SecureActionButtonTemplate`, SecureHandlers, etc.): let Blizzard-managed handlers perform limited actions from **attributes** configured **out of combat**.
- Attributes are set with `SetAttribute` **only outside combat**.
- Protection can **propagate** to parents and anchor targets — anchoring a secure button to a normal Church of Beef panel can unexpectedly lockdown that panel’s show/hide/move behavior in combat.

**Product implication:** Church of Beef is a social/ladder UI. It should use **normal (non-secure) frames** for `/beef`, toasts, and minimap. There is no V1 need for secure action buttons. Avoid inheriting secure templates “just in case.”

---

## 4. Taint (short form)

- Addon Lua and addon SavedVariables start **tainted**.
- Touching secure Blizzard state from tainted code can break Blizzard combat UI until `/reload`.
- Safe post-hooks: `hooksecurefunc`, `HookScript` (run after secure work; do not replace secure handlers lightly).
- Spreading taint into unit frames / action bars is a common “my addon breaks combat” failure mode — irrelevant if Church of Beef never hooks those systems.

---

## 5. Patterns for a social addon

| Situation | Correct behavior |
|-----------|------------------|
| Open `/beef` during combat | Prefer allow read-only UI if frames are non-protected; if any show/hide/create path can fail, queue until regen |
| Create frames / set points at login | Do it out of combat (normal load is fine) |
| Officer approves rank in combat | Update **data** immediately; defer any protected widget ops; chat announce is typically fine as non-protected messaging — still throttle |
| Combat starts mid-drag | Rely on non-protected movable frames; do not use secure attribute reconfig |
| “Do this when combat ends” | Register `PLAYER_REGEN_ENABLED`, drain a small queue |

### Run-or-queue (conceptual)

1. If `not InCombatLockdown()` → run immediately.  
2. Else push closure to a queue.  
3. On `PLAYER_REGEN_ENABLED`, flush queue.

Use for any future code that must create frames, reparent, or touch protected widgets — not for ordinary table updates to `ChurchOfBeefDB`.

---

## 6. What Church of Beef must never do

Aligned with design spec §2 and the secure API:

- No automated targeting, movement, spellcast, or decision macros driven by addon logic.
- No secure-template abuse to fake hardware events.
- No combat-assist overlays that execute protected actions.

Allowed: announce, track, display, officer approve, BeefNet sync, ceremony/Gora bookkeeping — all of which can remain on **insecure frames** and **data paths**.

---

## 7. Anti-AFK scoring vs lockdown

Spec §7.2: instance time buckets pay only if the player **entered combat** during the bucket. That is a **read** of combat state / combat events, not a lockdown write. Implement with events (`PLAYER_REGEN_DISABLED` / combat log or equivalent Classic-safe signals), not by calling protected functions.
