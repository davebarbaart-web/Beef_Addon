# Combat lockdown — what Beef UI can safely do

**Track:** 29-taint-secure-ui  
**Purpose:** Map `InCombatLockdown` to Church of Beef surfaces. Not a general performance checklist (no OnUpdate/CTL advice here).

## API fact sheet

```text
inLockdown = InCombatLockdown()
```

- Returns true while combat lockdown restrictions are active ([wiki](https://warcraft.wiki.gg/wiki/API_InCombatLockdown)).
- Lockdown begins **after** `PLAYER_REGEN_DISABLED` and ends **before** `PLAYER_REGEN_ENABLED` ([wiki — Details](https://warcraft.wiki.gg/wiki/API_InCombatLockdown)).
- Present since 2.0.1 / Classic 1.13.2 ([wiki](https://warcraft.wiki.gg/wiki/API_InCombatLockdown)).

### Restrictions while locked down

Documented on the wiki page:

- No programmatic modification of **macros** or **bindings**.
- On **protected** frames (and parents / anchored frames): no `Hide`, `Show`, attribute changes, or moving via resetting points/anchors. **User-initiated** moves of movable frames may still be allowed ([wiki](https://warcraft.wiki.gg/wiki/API_InCombatLockdown)).

Secondary synthesis (developer guide): also cannot create new secure frames or call protected functions freely during lockdown ([better-addons security](https://www.better-addons.com/security)).

`ShowUIPanel` / `HideUIPanel` became combat-protected in patch 8.2.0 (Retail lineage; Classic clients that inherited the change show the same “action blocked” behavior) ([Wowpedia ShowUIPanel](https://wowpedia.fandom.com/wiki/API_ShowUIPanel); [QuickQuest issue](https://github.com/p3lim-wow/QuickQuest/issues/36)).

## Two different problems people conflate

| Problem | Symptom | Fix style |
|---------|---------|-----------|
| **Combat lockdown** | Cannot Show/Hide/SetAttribute a *protected* frame right now | Defer to `PLAYER_REGEN_ENABLED`, or use SecureHandler/state driver if the frame must stay protected |
| **Taint pollution** | Blizzard UI later fails (bags, talent, action use) even out of combat | Stop writing tainted values into FrameXML globals; use post-hooks / LibUIDropDownMenu / preferredIndex |

Beef can hit **both** in a dungeon: officer opens `/beef` during trash (lockdown) *and* a tainted dropdown later breaks the default UI (taint). Design for both separately.

## What Beef can safely do in combat

Assume Beef frames are **fully insecure** (no Secure* inheritance, not parented under protected Blizzard panels, not anchoring protected children).

| Action | In combat? | Notes |
|--------|------------|-------|
| Update FontStrings / textures / status bars on own frames | Yes | Pure display |
| Append chat lines / play sounds / show non-panel toast frames | Yes | Avoid `ShowUIPanel` for custom windows |
| Process BeefNet messages, update local ladder tables | Yes | Data path; no secure frames |
| Open AceConfig / Interface Options | Prefer no | Options panels sit in Blizzard chrome; defer |
| CreateFrame for insecure widgets | Usually ok | Creating **secure** frames / SetAttribute is not |
| Show/Hide own insecure ladder window | Yes | Confirmed pattern: insecure-only addon windows ([Gello](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762)) |
| Officer Approve/Reject click → write SavedVariables + send addon message | Yes | Social authority, not protected combat API |
| Re-layout: SetPoint, SetParent, SetFrameStrata on secure/protected | No | Queue |
| SetBinding / EditMacro / secure attribute edits | No | Queue / forbid |

## What Beef must not do (ever, and especially in combat)

Aligned with V1 hard restrictions + secure model:

- Cast, target, use action slots, run macros, jump/autorun automation ([protected function examples](https://www.better-addons.com/security); [wiki philosophy](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)).
- Inherit `SecureActionButtonTemplate` “to open a panel” — that infects the parent chain ([forum](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762)).
- Call `ShowUIPanel` / `HideUIPanel` on Blizzard panels from combat-tainted paths ([ShowUIPanel notes](https://wowpedia.fandom.com/wiki/API_ShowUIPanel)).
- Touch stock `UIDropDownMenu` / `EasyMenu` globals for Beef chrome ([LibUIDropDownMenu rationale](https://www.wowace.com/projects/libuidropdownmenu)).

## Idiomatic queue pattern

When an operation *might* touch protected UI (or when you simply want “apply settings when safe”):

1. If `not InCombatLockdown()` → run immediately.
2. Else push a closure onto a pending list.
3. On `PLAYER_REGEN_ENABLED`, drain the list.

Documented as the standard pattern in [better-addons security — Queue Actions for After Combat](https://www.better-addons.com/security).

**UX for Beef:** if an officer hits “Apply layout” mid-pull, show a short “Applies when combat ends” note rather than error spam. Do not busy-loop OnUpdate waiting for lockdown to clear (performance track owns that antipattern).

### Event ordering reminder

- Enter combat: `PLAYER_REGEN_DISABLED` → then lockdown true.
- Leave combat: lockdown clears → then `PLAYER_REGEN_ENABLED`.

So handlers on `PLAYER_REGEN_ENABLED` run when it is already safe to mutate protected frames ([wiki](https://warcraft.wiki.gg/wiki/API_InCombatLockdown)).

## Surface matrix (V1 product → lockdown stance)

| Surface | Combat policy |
|---------|----------------|
| Minimap button → toggle ladder | OK if frame insecure; no ShowUIPanel |
| `/beef` slash → show ladder | Same |
| Live standing / title refresh | Always OK (text/data) |
| Promotion toast / ceremony banner | Prefer own frame `:Show()`; queue if ever tied to secure chrome |
| Officer approve/reject dialog | Prefer custom insecure confirm **or** StaticPopup with `preferredIndex = 3` (see footguns); never block combat on missing panel |
| Ace options / profiles | Defer open + defer apply of frame geometry |
| Stream overlay readability tweaks | Text/color OK; strata/parent changes → queue if any secure ancestor |

## When SecureHandlers would enter the picture

Only if Beef later adds a **protected** child (e.g. a click-to-target “spotlight unit” button — generally a bad product fit). Then:

- Create/configure out of combat.
- Use `_onclick` / state snippets for Show/Hide of protected parents ([SecureHandlers](https://warcraft.wiki.gg/wiki/SecureHandlers); [forum walkthrough](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762)).
- Keep social data logic in normal addon code, not restricted snippets.

Until that day: **do not introduce secure templates.**

## Contrast with track 04 (performance)

Track 04 covers *when* work runs (OnUpdate throttle, CTL, memory). This track covers *whether the client allows the UI mutation*. A frame update can be cheap and still illegal under lockdown if the frame is protected. Keep the concerns separate in design reviews.