# Combat Lockdown — Testing Limits

**Last updated:** 2026-07-25  
**Track:** [19-testing-debugging-qa](README.md)  
**Primary references:** [Secure Execution and Tainting](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting), [API InCombatLockdown](https://wowpedia.fandom.com/wiki/API_InCombatLockdown)

---

## 1. What lockdown is

`InCombatLockdown()` returns true while combat restrictions are active ([InCombatLockdown](https://wowpedia.fandom.com/wiki/API_InCombatLockdown)). During lockdown, protected frames and protected APIs refuse insecure (addon) manipulation — part of the post-2.0 security model that Classic still uses ([Secure Execution and Tainting](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)).

**Addon code is always tainted.** It cannot cast, target, or drive protected actions in combat. Spec §2 already forbids automation; lockdown testing is about **UI survival**, not combat helpers.

---

## 2. What you generally cannot do in combat (secure path)

From wiki + developer guides ([Secure Execution](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting); [better-addons security model](https://www.better-addons.com/security)):

- Call **protected** functions (cast, target, UseAction, etc.)
- Create / reconfigure **secure** frames and attributes (`SetAttribute` on secure templates)
- Show/hide/move **protected** frames
- Rely on `ShowUIPanel` / similar protected panel APIs during lockdown (forum reports — [Showing Elements in Combat Lockdown](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762))

**Ordinary** `CreateFrame` UI (no secure templates) is the V1 Beef path — still verify Show/Hide and layout during combat; loot-council authors report combat as a constant concern for social UIs ([same forum thread](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762)).

---

## 3. What QA *can* still prove for Beef

| Test while `InCombatLockdown()` | Expected for V1 plain frames |
|---------------------------------|------------------------------|
| `/beef` opens main frame | Should work if frames are non-secure |
| Switch Ladder / My Standing tabs | Should work |
| Toast / print standing update | Prefer deferred if any secure touch; plain text OK |
| Officer approve mid-combat | Prefer allow **or** queue until `PLAYER_REGEN_ENABLED` — pick one and test; do not crash |
| Minimap button toggle | Should work for ordinary button |
| BeefNet receive + apply commit | Data path OK; UI refresh must not taint secure UI |
| Instance scoring (combat-in-bucket) | Must work **in** combat by design (anti-AFK) |

Idiom for deferred secure work: register `PLAYER_REGEN_ENABLED` and flush a queue ([WoWAddonDevGuide advanced techniques](https://github.com/Amadeus-/WoWAddonDevGuide/blob/master/10_Advanced_Techniques.md); [better-addons combat lockdown](https://www.better-addons.com/security)).

---

## 4. Testing limits (honest constraints)

1. **PTR/Retail Midnight restriction APIs** (`C_RestrictedActions`, encounter/PvP restriction enums) are **not** the V1 Anniversary mental model — Classic QA sticks to `InCombatLockdown()` ([dev guide contrast](https://github.com/Amadeus-/WoWAddonDevGuide/blob/master/10_Advanced_Techniques.md)).
2. You **cannot** fully unit-test lockdown outside the client; combat must be entered (duel, dungeon trash, training dummy where available).
3. **Taint attribution** in error text can blame the wrong addon after honey-spread ([wiki honey analogy](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)) — reproduce with only Beef + BugSack enabled.
4. Secure template complexity is a **fail** for Beef V1 scope — if lockdown tests force SecureActionButton workarounds, the UI is overbuilt.
5. Automation of combat for CI is **out of bounds** (spec §2). Human or scripted **keypress** only; no bots.

---

## 5. Minimal combat QA script for Beef

1. Enter a low-stakes combat (duel or dungeon pull).
2. Confirm `InCombatLockdown()` is true (`/dump InCombatLockdown()`).
3. Open `/beef`, change tabs, move frame (if movable), click minimap toggle.
4. If second client available: officer approves a pending suggestion mid-combat; both clients stay error-free in BugSack.
5. Leave combat; confirm any queued UI flush runs once.
6. Repeat with ElvUI present (coexistence smoke) — still not a combat HUD.

**Pass:** zero BugSack errors; no ADDON_ACTION_BLOCKED / taint spam attributable to Church of Beef; scoring still observes combat for instance buckets.
