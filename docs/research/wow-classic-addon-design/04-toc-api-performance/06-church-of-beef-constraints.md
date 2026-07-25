# Top Technical Constraints for Church of Beef

**Last updated:** 2026-07-25  
**Maps to:** [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)  
**Detail docs:** [01](01-interface-versions-and-toc.md) · [02](02-savedvariables.md) · [03](03-events-onupdate-throttling.md) · [04](04-combat-lockdown.md) · [05](05-performance-norms.md)

---

## Ranked constraints (V1)

1. **Ship `## Interface: 20506` for TBC Classic Anniversary (patch 2.5.6).**  
   Wrong Interface → out-of-date / load friction. Re-verify with `GetBuildInfo` after every Anniversary build. Era/SoD (`115xx`) and Cata/MoP numbers are port concerns only.

2. **Install tree is Anniversary-specific.**  
   Players must place the addon in the Anniversary client’s `Interface/AddOns`, not Classic Era. No shared AddOns/SV migration assumption.

3. **`SavedVariablesPerCharacter: ChurchOfBeefDB` is load-bearing product design.**  
   Alts are Fresh Beef. Do not “helpfully” switch to account-wide AceDB defaults for ladder/standing without an explicit product change.

4. **No Retail-only / Dragonflight-era API dependence.**  
   Shared modern *UI chrome* on Classic ≠ permission to call Retail-only APIs. Stay on Classic-available Lua/XML surfaces (spec §2).

5. **Event-driven core; no permanent OnUpdate.**  
   Scoring, roster, and BeefNet are event/timer based. Throttle any UI coalesce (≤10 Hz when open). Idle when the ladder is closed.

6. **Combat lockdown applies even to “harmless” UI if frames are protected or wrongly anchored.**  
   Use normal frames for `/beef`. Queue show/hide/create that might fail in combat until `PLAYER_REGEN_ENABLED`. Never touch secure templates for V1.

7. **Do not circumvent protected actions.**  
   Mechanical + ToS/design constraint: no targeting, casting, movement, or secure-attribute combat automation. Social announce/track/display only.

8. **Throttle outbound chatter.**  
   ChatThrottleLib-style pacing for BeefNet; one officer-origin guild announce per promotion; sync reply suppression on login (spec §8 / §10).

9. **Keep SavedVariables small and migratable.**  
   Cache official ladder + revisions, not unbounded logs. Login cost and “addon feels heavy” scale with SV size.

10. **Self-reported standing is not authoritative.**  
    SV tampering is trivial; officer `RANK_COMMIT` + revision merge is the trust model. Persistence design should favor reconciliation, not crypto.

11. **Multi-flavor TOC is a later-port tool, not a V1 requirement.**  
    Prefer single TOC now; when porting, use comma-delimited Interface and/or `_TBC` / `_Vanilla` suffixes / `AllowLoadGameType` rather than Retail Interface in the V1 file.

12. **Performance bar: invisible in combat.**  
    In a stack with WA/Details/nameplates, Church of Beef should not show meaningful periodic CPU. Bursty login sync is OK; combat polling is not.

---

## Quick decision table

| Topic | V1 choice |
|-------|-----------|
| Interface | `20506` |
| TOC shape | Single `ChurchOfBeef.toc` |
| SV scope | Per-character `ChurchOfBeefDB` |
| Frames | Non-secure |
| Updates | Events + rare timers |
| Combat | Defer protected widget ops; keep scoring as data |
| Comms | Throttled GUILD addon messages + optional one-line announce |
| Ports | Isolate flavor checks for Classic+ later |

---

## Open verification items (not blockers)

- Confirm live Interface after each 2.5.x hotfix (`/dump select(4, GetBuildInfo())`).
- Confirm whether any Anniversary-only UI options (Edit Mode) affect frame parenting of custom addon frames in practice — smoke-test `/beef` movable frame after 2.5.6-class UI updates.
- If Ace3 is adopted for options/minimap, keep ladder standing out of account-wide profile defaults.
