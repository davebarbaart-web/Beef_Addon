# Classic taint footguns for social addons

**Track:** 29-taint-secure-ui  
**Purpose:** High-frequency ways guild/social/loot/streamer addons break Blizzard UI — mapped to Beef risk.

Social addons rarely *want* secure combat widgets. They still cause `ADDON_ACTION_BLOCKED` / “Interface action failed” by polluting shared FrameXML state ([Townlong Yak — most errors are unintended propagation](https://web.archive.org/web/20210518120056/https://www.townlong-yak.com/taint.log/about.html)).

## 1. Stock UIDropDownMenu / EasyMenu

**Failure mode:** Addon uses Blizzard `UIDropDownMenu_*` / `EasyMenu`. Those paths use shared globals and historically touch protected list frames. Later, Blizzard Communities / Interface Options / other menus fail under taint ([Townlong Yak — UIDropDownMenu issues](https://web.archive.org/web/20200715202710/https://www.townlong-yak.com/bugs/PfF9rr-UIDropDownMenu); [LibUIDropDownMenu](https://www.wowace.com/projects/libuidropdownmenu)).

Known issue themes from Townlong Yak’s index (status as of that write-up):

- Some init-path bugs fixed in 8.1.0; others **not fixed** (displayMode, SetSelectedValue/Refresh, Refresh on uninitialized buttons affecting CUF profiles / options).
- Replacing *only* your addon’s menus is incomplete if you still interact with FrameXML pieces that use stock dropdowns ([Townlong Yak — Common remarks](https://web.archive.org/web/20200715202710/https://www.townlong-yak.com/bugs/PfF9rr-UIDropDownMenu)).

**Mitigation used widely in Classic:** embed [LibUIDropDownMenu](https://www.curseforge.com/wow/addons/libuidropdownmenu) (namespaced `L_*` copies of EasyMenu/UIDropDownMenu) — ships Classic / TBC Classic builds. Or avoid dropdown widgets entirely (AceGUI dropdowns, custom frames).

**Beef:** Prefer AceConfig/AceGUI for officer menus. If a context menu is required, LibUIDropDownMenu — never raw `EasyMenu` on Blizzard lists.

## 2. StaticPopup_Show and popup slot collision

**Failure mode:** Custom `StaticPopupDialogs["MY_KEY"]` + `StaticPopup_Show` can collide with Blizzard’s limited popup frames and contribute to UI taint. Community guidance: set `preferredIndex = 3` on the dialog table to prefer a safer slot ([AddOn Studio — Creating simple pop-up dialog boxes](https://addonstudio.org/wiki/WoW:Creating_simple_pop-up_dialog_boxes), citing WowAce “how to avoid some UI taint”).

`!NoTaint` commentary also lists `StaticPopup_Show()` among known taint triggers alongside things like `ToggleTalentFrame()` ([!NoTaint project notes](https://www.wowace.com/projects/notaint?page=2)).

**Beef:** Officer approve/reject can use:

1. **Best for taint isolation:** custom insecure confirm frame owned by Beef, or  
2. StaticPopup with `preferredIndex = 3`, `whileDead = true`, `hideOnEscape = true`, unique dialog key.

Do not open Blizzard guild/talent/character panels as a side effect of Beef confirmations.

## 3. ShowUIPanel / HideUIPanel in combat

**Failure mode:** Since 8.2.0 lineage, `ShowUIPanel` is protected in combat — blocked with an action-blocked message ([Wowpedia](https://wowpedia.fandom.com/wiki/API_ShowUIPanel)). Quest/social helpers that open default panels mid-pull break ([QuickQuest #36](https://github.com/p3lim-wow/QuickQuest/issues/36)).

**Beef:** Ladder/ceremony UI should be a normal frame under `UIParent` (or similar), toggled with `:Show()` / `:Hide()`, not registered as a UIPanel unless there is a strong reason — and never forced open via `ShowUIPanel` during combat.

## 4. Parent / anchor pollution (secure infection)

**Failure mode:** Adding *one* `SecureActionButtonTemplate` (or other protected child) makes parents and anchor targets protected; insecure `:Show()` then fails in combat ([Gello walkthrough](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762)).

Related: parenting custom options into Blizzard Interface Options / attaching to protected default UI can pull Beef chrome into lockdown rules (same thread — OP suspicion after migrating options into stock panel).

**Beef:**

- Keep product windows on an insecure root.
- Do not parent interactive Beef chrome under `CompactRaidFrame…`, action bars, or other secure trees.
- Ace options: use Blizzard options *integration* carefully; defer opening options in combat; avoid putting secure children in the options tree.

## 5. Replacing FrameXML functions / SetScript overwrite

**Failure mode:** Assigning over `ChatFrameN.AddMessage` or other Blizzard methods to “just tweak text” can taint paths that later hit Edit Mode / protected UI ([WoWInterface advice — Kanegasi](https://www.wowinterface.com/forums/showthread.php?t=60069)). Same class of bug: `frame:SetScript("OnEvent", ...)` replacing Blizzard’s handler instead of `HookScript`.

**Beef:** Chat spectacle / filters → `ChatFrame_AddMessageEventFilter` or `hooksecurefunc` / `HookScript` only. Never replace `AddMessage`.

## 6. CreateFrame during combat (secure / group headers)

**Failure mode:** Raid-style addons creating children while locked down produce blocked `CreateFrame` stacks tied to `SecureGroupHeaders` when roster changes mid-combat ([WoWInterface archive reports](https://www.wowinterface.com/forums/showthread.php?t=55900) — pattern cited in lockdown search dumps).

**Beef:** V1 has no raid headers. Still: do not dynamically spawn secure-template frames in combat; precreate or defer. Insecure toast frames are fine if kept insecure.

## 7. Global name / mouse-enabled pollution on Blizzard canvases

**Failure mode (Retail-leaning but instructive):** Named, mouse-enabled addon frames parented to map canvases can propagate taint into Blizzard pin/tooltip code ([security guide / map canvas notes in lockdown search corpus](https://www.better-addons.com/security) — treat as “don’t stick sticky frames into Blizzard hit-test trees”).

**Beef:** Stream overlays and ceremony art should live on Beef-owned roots, not as children of `WorldMapFrame` / secure HUD roots.

## 8. Hardware-event vs combat confusion

Some protected APIs require a **hardware event** (real click/key) even out of combat; all are blocked under lockdown ([better-addons — Hardware Event Requirements](https://www.better-addons.com/security)). Social authors sometimes “fix” a missing click by calling `TargetUnit` / `RunMacroText` from an event handler — that is both a ToS/spec violation for Beef and a taint/lockdown fail.

**Beef:** Officer actions are data + messaging + display. Never route through protected combat APIs.

## 9. Blame is not root cause

`ADDON_ACTION_BLOCKED` names *a* tainted addon flavor at the blocked call, not necessarily the first sticky touch ([honey analogy](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting); [Townlong Yak](https://web.archive.org/web/20210518120056/https://www.townlong-yak.com/taint.log/about.html)). Bisect with `/console taintlog 1` (then 2/11), binary-disable, and `issecurevariable` on suspects.

## Quick checklist before shipping a Beef UI feature

- [ ] No `Secure*Template` inheritance on product frames  
- [ ] No stock `UIDropDownMenu` / `EasyMenu`  
- [ ] Popups: custom frame or `preferredIndex = 3`  
- [ ] No `ShowUIPanel` for Beef windows  
- [ ] Hooks via `hooksecurefunc` / `HookScript` only  
- [ ] Layout/options apply queued on `PLAYER_REGEN_ENABLED` when touching any protected ancestry  
- [ ] Combat test: open ladder, approve a promotion, open dropdown — mid-trash — then use bags/character pane after  

## See also

- [tainted-execution.md](tainted-execution.md) — model + taint.log  
- [combat-lockdown-beef-ui.md](combat-lockdown-beef-ui.md) — allowed in-combat matrix  
- [annotated-urls.md](annotated-urls.md) — primary links  
