# Combat lockdown vs movable UI

**Track:** [37-movable-frames-anchors](README.md)

## What lockdown actually restricts

[`InCombatLockdown()`](https://warcraft.wiki.gg/wiki/API_InCombatLockdown) is true while the secure environment forbids many UI mutations. Documented restrictions include:

- Programmatic macro/binding edits
- On **protected** frames (and their parents / frames anchored into that protected hierarchy):
  - `Show` / `Hide`
  - Attribute changes used by secure templates
  - **Moving by resetting points/anchors**

Explicit carve-out in the wiki wording: **movements initiated by the user** may still be allowed while in combat, even when programmatic re-anchoring is not ([InCombatLockdown](https://warcraft.wiki.gg/wiki/API_InCombatLockdown)).

[`StartMoving`](https://warcraft.wiki.gg/wiki/API_StartMoving) itself is marked **restricted** on secure frames during combat.

## What this means for Church of Beef V1

| Surface | Secure? | Combat guidance |
|---------|---------|-----------------|
| `/beef` ladder / standing / officer panel | Should be a normal (non-secure) `Frame` | Prefer allowing Show/drag anytime; if any child becomes protected later, gate Show/Hide/reposition with `not InCombatLockdown()` and retry on `PLAYER_REGEN_ENABLED` |
| Minimap button (LibDBIcon-style) | Usually non-secure button | Toggle should no-op or queue if a future secure dependency appears; V1 plain toggle is fine |
| Toasts | Non-secure | Safe to show in combat **visually**; still avoid covering WA/DBM (placement, not lockdown) |
| Blizzard unit frames / action bars | Protected | **Never** re-anchor as part of Beef; out of scope |
| SecureActionButton for combat use | N/A | Spec forbids combat automation — do not ship |

Community patterns for Ashran-style movers wrap container `SetShown` in `if not (HasProtectedFrame and InCombatLockdown())` ([WoWInterface movable + buttons thread](https://www.wowinterface.com/forums/showthread.php?p=313021)). Steal the **gate**, not the Ashran logic.

## Taint adjacency

Moving **Blizzard** frames with `SetPoint` + `SetUserPlaced` hacks is a known taint magnet ([TargetFrameToT threads](https://www.wowinterface.com/forums/showthread.php?t=52537)). Beef must not touch those frames. Own frames only.

## Practical V1 policy

1. Keep Beef frames **non-protected**.
2. Do not create secure action children on the ladder chrome.
3. Still write defensive helpers:
   - `CanMutateUI()` → `not InCombatLockdown()` for any future secure surface
   - On combat entry: cancel an in-progress drag (`StopMovingOrSizing`) to avoid odd stop anchors
4. Social spectacle (guild chat announce) is a **chat API** concern, not a frame-anchor concern — see messaging tracks; do not block announces on lockdown.
5. Success criteria §13.10: no combat automation — lockdown discipline supports that product rule.
