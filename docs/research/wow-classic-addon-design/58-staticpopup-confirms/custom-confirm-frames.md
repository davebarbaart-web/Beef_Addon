# Custom confirm frames vs StaticPopup

**Track:** 58-staticpopup-confirms  
**Purpose:** Decision guide for when Beef should own the modal. Construction details (Lua-primary, templates) → [35](../35-xml-vs-lua-ui/beef-officer-ladder-ui.md). Menu entry points → [36](../36-tooltips-menus/) (do not duplicate menu taxonomy here).

---

## 1. Two valid V1 paths

| Path | Pros | Cons |
|------|------|------|
| **A. StaticPopup** | Native look/sound/ESC; tiny code; players already know the chrome | 4-slot pool; limited layout; edit box UX is basic; shared FrameXML surface |
| **B. Custom insecure modal** | Full control (reason UX, heraldry, announce preview); no slot fight; taint isolation | Must implement ESC, strata, focus, click-outside policy, a11y yourself |

Track 29’s Beef stance: **best for taint isolation = custom insecure confirm**; StaticPopup with `preferredIndex` is acceptable alternative ([footguns](../29-taint-secure-ui/social-addon-footguns.md)). Track 35 already names demote/Prophet friction as “small dialog frame … or modal child in Lua.”

**Recommendation for Church of Beef V1:**

1. **Ship one shared confirm helper** (API design, not code here): `COB:Confirm({ title, body, severity, requireReason, onAccept })`.
2. **Implement helper with StaticPopup first** for speed *if* reason is a single optional/required edit box and copy fits two `%s` args.
3. **Promote the helper’s backend to a custom frame** when any of the triggers in §3 fire — callers stay the same.

---

## 2. AceConfig `confirm` is a cousin, not the officer modal

Ace options tables support ([WowAce options tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables)):

| Value | Behavior |
|-------|----------|
| `confirm = true` | Prompt using `confirmText`, else `"name - desc"` |
| `confirm = function(info, …)` | Return string (prompt), `true` (default text), or `false` (skip) |
| `confirm = false` | Opt out of inherited parent confirm |

AceConfigDialog implements that prompt via **StaticPopup** (`ACECONFIGDIALOG30_CONFIRM_DIALOG`, high `preferredIndex`, strata bump). Forum advice for standalone Ace apps: use StaticPopup or AceGUI Frame widgets — options tables alone are not a message-box API ([EU forums thread](https://eu.forums.blizzard.com/en/wow/t/dialog-box-by-ace3/18170)).

**Beef:** Use Ace `confirm` for **settings** destructives (profile wipe, “reset UI prefs”). Do **not** make Prophet bestowal an AceConfig execute buried in Interface Options — keep it on the Officer tab with the shared confirm helper.

---

## 3. Triggers to leave StaticPopup

Switch (or start) with a custom modal when you need any of:

| Trigger | Why StaticPopup hurts |
|---------|----------------------|
| Required reason + enum chips / templates | One edit box + Accept is awkward |
| Before → after rank visualization | No room for seals / color tokens |
| “Guild announce will say: …” preview | Multi-line body + wrapping fights popup layout |
| Multiple fields (target rank picker + reason) | Needs real layout |
| Frequent nil from `StaticPopup_Show` in raiding | Pool exhaustion mid-ceremony |
| Want confirm parented/modal to Officer tab | StaticPopup is global center-screen |
| Brand ceremony chrome (Prophet anoint) | Stock alert icon ≠ church rite |

Custom frame rules (from 29/35, restated as confirm constraints only):

- Insecure root under `UIParent` (or Beef main); **no** secure templates.
- `:Show()` / `:Hide()`, not `ShowUIPanel`.
- ESC → cancel (match `hideOnEscape`).
- Strata above Officer tab (`DIALOG` / `FULLSCREEN_DIALOG`); don’t permanently steal `"TOOLTIP"` unless Ace-style temporary bump.
- Precreate at load; don’t `CreateFrame` a new confirm tree every click in combat (insecure is OK; still cheaper to reuse).

---

## 4. Cousin UX: loot confirm friction

Gargul’s award flow documents an explicit **confirm dialogue** before award ([Gargul wiki — Awarding Items](https://github.com/papa-smurf/Gargul/wiki/Awarding-Items)) — authority action + named item + confirm. Steal the *shape* (name the object of the action; block one-click), not the loot chrome. RCLootCouncil opens session UI rather than spamming StaticPopup for every click — awareness via frame presence (track 49). Beef’s nuclear actions are closer to Gargul award confirm than to RCL voting panels.

---

## 5. Decision matrix (quick)

| Action | Default chrome |
|--------|----------------|
| Approve / Reject suggestion | No modal |
| Standing ± correction | StaticPopup or inline confirm |
| Demote / excommunicate | StaticPopup **or** custom if reason UX grows |
| Council appoint | StaticPopup (+ seat count in body) |
| Prophet bestow / replace | Prefer **custom** if ceremony copy/preview matters; StaticPopup acceptable for V1 MVP |
| Standing wipe / Lent reset | Custom or StaticPopup with `showAlert`; never Ace-only |
| Settings: reset UI profile | AceConfig `confirm` |

---

## See also

- [beef-demote-prophet-confirms.md](beef-demote-prophet-confirms.md)
- [35 — beef-officer-ladder-ui](../35-xml-vs-lua-ui/beef-officer-ladder-ui.md)
- [03 — options UI norms](../03-ace-libs-options/05-options-ui-norms.md)
