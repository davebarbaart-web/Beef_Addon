# 03 — Taint, combat lockdown, and UX for Church of Beef

**Audience:** Coding agents polishing social / UI “juice” (toasts, ceremony chrome, officer confirms, slash, guild announce).  
**Authority:** Product law in `docs/superpowers/specs/2026-07-25-church-of-beef-design.md`; hard constraints in `.cursor/rules/wow-ui-taint-lockdown.mdc` (and related lifecycle / layers rules).  
**Depth tracks (do not fork policy here):** [`29-taint-secure-ui/`](../wow-classic-addon-design/29-taint-secure-ui/), [`58-staticpopup-confirms/`](../wow-classic-addon-design/58-staticpopup-confirms/), [`72-guild-chat-announce-api/`](../wow-classic-addon-design/72-guild-chat-announce-api/).  
**Client:** TBC Classic Anniversary (`## Interface: 20506`) — modern secure/taint model, not Vanilla automation.

---

## 1. Two problems — never conflate them

| Problem | What breaks | When | Fix style |
|---------|-------------|------|-----------|
| **Combat lockdown** | Programmatic Show/Hide / SetAttribute / SetPoint / SetParent on **protected** frames; macros/bindings | While `InCombatLockdown()` is true | Keep Beef frames **insecure**, or queue protected-touching work until `PLAYER_REGEN_ENABLED` |
| **Taint pollution** | Blizzard UI later fails (“Interface action failed…”) — bags, options, menus — even **out of combat** | After sticky values enter FrameXML paths; lasts until `/reload` or relog | Own frames/tables; `hooksecurefunc` / `HookScript`; never overwrite FrameXML handlers |

Beef can hit **both** in a dungeon: officer opens `/beef` mid-trash (lockdown) *and* a tainted dropdown later breaks the default UI (taint). Design and QA for each separately.

**Lockdown timing:** enter combat → `PLAYER_REGEN_DISABLED` → then lockdown true; leave combat → lockdown clears → then `PLAYER_REGEN_ENABLED`. Drain deferred work on `PLAYER_REGEN_ENABLED`.

---

## 2. Mental model (enough to ship juice safely)

- Third-party addon code and its SavedVariables start **tainted**.
- Reading a tainted value taints the current execution path; writing from that path taints new values (“honey”).
- **Protected functions** refuse insecure paths; **protected frames** refuse combat mutations from tainted code.
- `hooksecurefunc` / `HookScript` exist so addons can observe secure work **after** it runs without replacing handlers.
- Diagnostics: `/console taintlog 1` (then 2/11) → `Logs/taint.log`; `issecurevariable` on suspects. Blame in `ADDON_ACTION_BLOCKED` names *a* sticky addon, not always the first touch.

**Product truth:** Church of Beef is display + coordination (ladder, titles, announce, officer Commit). It must never cast, target, bind, or automate gameplay. That aligns with Classic’s secure model and V1 hard bans.

---

## 3. How social / UI juice accidentally taints

Polish features fail when they “borrow” Blizzard chrome or overwrite shared paths. High-frequency footguns for Beef-shaped work:

| Juice temptation | Failure mode | Prefer |
|------------------|--------------|--------|
| Stock context menus for officer actions | `UIDropDownMenu_*` / `EasyMenu` share protected globals → later Blizzard menus / options break | AceGUI / custom frames / LibUIDropDownMenu — never raw EasyMenu |
| Blizzard confirm for demote / Prophet | `StaticPopup_Show` slot collision + shared FrameXML | Own insecure confirm **or** `StaticPopupDialogs["COB_*"]` with `preferredIndex = 3` (or `STATICPOPUP_NUMDIALOGS`) |
| “Open like a real panel” | `ShowUIPanel` / `HideUIPanel` protected in combat lineage | Own frame under `UIParent` (or Beef root); `:Show()` / `:Hide()` |
| Secure button “just to open the window” | `SecureActionButtonTemplate` infects parent / anchor chain → whole window lockdowns | Fully insecure `CreateFrame`; never Secure* for panels |
| Fancy chat restyle / guild filter | Replacing `ChatFrame*.AddMessage` or `SetScript` on FrameXML | `ChatFrame_AddMessageEventFilter`, `hooksecurefunc`, `HookScript` only |
| Parent toast under raid/map/action bar | Secure infection + hit-test pollution | Beef-owned root; no children of `CompactRaidFrame…`, action bars, `WorldMapFrame` |
| Mid-combat spawn of “smart” widgets | Secure headers / SetAttribute blocked | Precreate insecure toasts; never create secure-template frames in combat |
| Open guild roster as side effect of Commit | Touches Blizzard panels from tainted OnAccept | Commit → Core/SV/BeefNet/announce only; no `ShowUIPanel(GuildFrame)` |
| Hardware-event “fix” (TargetUnit / RunMacroText from event) | Spec + ToS violation **and** lockdown/taint fail | Officer actions = data + messaging + display only |

**Juice that is usually safe** (on insecure Beef frames): FontString/texture updates, private edge toasts via `:Show()`, sounds (if ever enabled), BeefNet apply + Core table mutations, officer Approve → SV + addon message, slash toggle of the ladder window.

---

## 4. Safe patterns — buttons, slash, guild chat

### 4.1 Buttons (officer + member chrome)

```text
✅ CreateFrame(..., "UIPanelButtonTemplate" / BackdropTemplate / BasicFrameTemplate)
   parented to Beef root or UIParent
✅ OnClick → thin UI → Core validate/commit → Net/announce as designed
✅ Confirm destructive rites (demote, Prophet, Council, standing wipe) with named subject
❌ SecureActionButtonTemplate / SecureUnitButtonTemplate “to open a panel”
❌ Parent under protected Blizzard trees
❌ OnClick that opens Blizzard options / guild / talent panels in combat
```

Approve / Reject need **no** modal (glossary). Nuclear rites need modal + named subject. After Commit: `COB.UI:RefreshLadder()` (or equivalent) — no AceEvent bus in V1.

### 4.2 Slash commands

```text
✅ SLASH_CHURCHOFBEEF1 = "/beef" registered on load
✅ Handler → COB.UI:Toggle() → insecure :Show()/:Hide()
✅ May run in combat if the product window is fully insecure
❌ Route /beef through ShowUIPanel
❌ Slash that EditMacro / SetBinding / touches secure attributes
❌ Verbose /beef debug dumps to guild chat (privacy track 65)
```

`/beef` is the real entry; minimap is optional and hideable. Product frames must exist on load or first `/beef` even if custom media is missing.

### 4.3 Guild chat sends (spectacle)

V1 brand channel is **one** throttled `/g` line from the **approving officer’s** client after a successful local commit — not peer echoes, not drip spam.

```text
✅ After RANK_COMMIT accepted locally
✅ Guards: IsInGuild ∧ announce opt-in ∧ speak rights
✅ CTL-paced SendChatMessage / C_ChatInfo.SendChatMessage on "GUILD", ≤255, plain text
✅ Opt-out skips chat only — commit + private toast still happen
❌ Multi-line liturgy walls / flavor spam (RTT + filter culture)
❌ Peers announcing on wire apply
❌ MessageQueue / HW-event theater for GUILD (not required on Classic for GUILD)
❌ Announce before commit succeeds
```

`GUILD` remains sendable from addon code without an outdoor hardware event on Classic; Approve UI still provides a human click, but do not invent protected combat APIs for chat.

### 4.4 Idiomatic deferral (when something *might* touch protected UI)

1. If `not InCombatLockdown()` → run immediately.  
2. Else push a closure onto a pending list; show soft copy (“Applies when combat ends”).  
3. On `PLAYER_REGEN_ENABLED`, drain the list.  
4. Never busy-loop `OnUpdate` waiting for lockdown.

Use this for options open, geometry/parent/strata changes that might touch protected ancestry — **not** for ordinary insecure ladder Show/Hide or Core scoring.

---

## 5. UX that degrades gracefully in combat

Design principle: **combat never drops authority or spectacle; it may defer chrome that touches Blizzard or protected trees.**

| Surface | In combat | Degradation / copy |
|---------|-----------|---------------------|
| Live standing / title FontStrings | Update always | — |
| BeefNet receive + Core ladder mutate | Always | — |
| `/beef` / minimap toggle (insecure frame) | Show/Hide OK | If ever blocked, print once: “Church of Beef UI unavailable in combat” — then fix the secure child you accidentally added |
| Private promote toast (own frame) | `:Show()` OK | Prefer edge toast; no center-screen WA pulses; no ShowUIPanel |
| Officer Approve → commit + BeefNet + `/g` | OK (data + chat) | If announce fails (not in guild / muted), local warning only; commit still stands |
| Officer confirm modal (custom insecure) | Prefer OK | If using StaticPopup and `StaticPopup_Show` returns nil → soft toast “could not open confirm — try again”; never treat as Accept |
| Ace / Interface Options | Defer open + defer geometry apply | “Opens when combat ends” |
| Layout / SetParent / strata polish | Queue if any protected ancestry | Same soft note; no error spam |
| Bags / character pane after Beef use | Must still work | If not → taint regression; bisect with taintlog |

**Copy tone:** procedural, short, no blame spam. One line beats a stack of red errors. Dual-encode pending/approve/reject for colorblind readability (UI brief) — color alone is not the combat fallback.

**What players must never experience:**

- Ladder “stuck” because a SecureActionButton was used to open the panel.  
- Promotion committed but silent forever because announce was tied to a failed Blizzard panel open.  
- Demote Accept fired because a popup was overridden / timed out.  
- Guild chat flooded mid-pull by juice lines.

---

## 6. Must-follow agent rules

Extracted from `.cursor/rules/wow-ui-taint-lockdown.mdc`, `toc-lifecycle.mdc`, UI brief, and track 29. Treat as **non-negotiable** when editing `UI/**` or bootstrap slash.

### Non-negotiables

1. Product windows are **fully insecure** `CreateFrame` under `UIParent` (or Beef-owned root).  
2. Toggle with `:Show()` / `:Hide()` — **not** `ShowUIPanel` / `HideUIPanel` in combat.  
3. Tabs are views: read Core, never own ladder tables or grant points.  
4. **Never** inherit `SecureActionButtonTemplate` / secure headers “to open a panel.”  
5. No bots, injection, protected-action bypass, or gameplay automation.  
6. No Retail / Dragonflight-only APIs without Anniversary verify.

### Frame policy (V1)

- Prefer Lua `CreateFrame` over XML; tabs register into `MainFrame`.  
- Do not parent Beef chrome under raid frames, action bars, or other protected trees.  
- Missing fonts/textures → default UI fallbacks; frame must exist on load or first `/beef`.  
- Toasts/Announce **display** outcomes; Scoring owns grants.  
- Confirm destructive actions (demote, Prophet bestowal, Council changes).  
- After Commit: `COB.UI:RefreshLadder()` (or equivalent).

### Taint footguns — avoid / prefer

| Avoid | Prefer |
|-------|--------|
| Stock `UIDropDownMenu_*` / `EasyMenu` | AceGUI / custom frames / LibUIDropDownMenu |
| Blind `StaticPopup_Show` | Own confirm frame, or StaticPopup with `preferredIndex = 3` |
| Replacing `ChatFrame.AddMessage` | `ChatFrame_AddMessageEventFilter` / `hooksecurefunc` / `HookScript` |
| `SetScript` overwriting Blizzard handlers | `HookScript` |

### Combat-safe vs deferred

| OK in combat | Defer / avoid |
|--------------|---------------|
| Update own FontStrings/textures | SetPoint/SetParent on protected widgets |
| Process BeefNet; mutate Core tables | Opening Blizzard options / guild panels |
| Officer approve → SV + addon message | `SetBinding` / `EditMacro` / secure attributes |
| Show insecure `/beef` window | Creating secure-template frames |

### Product UX edges

- Officer tab visible only when local Officer+ is known.  
- Movable, clamped-to-screen; save position in `ChurchOfBeefDB.ui`.  
- One hideable minimap button; `/beef` is the real entry — no Retail Addon Compartment.  
- No ads, tip jars, or donation CTAs in the game UI.

### Shipping checklist (before claiming a juice feature done)

- [ ] No `Secure*Template` on product frames  
- [ ] No stock `UIDropDownMenu` / `EasyMenu`  
- [ ] Popups: custom frame or `preferredIndex = 3` (+ nil-safe show)  
- [ ] No `ShowUIPanel` for Beef windows  
- [ ] Hooks via `hooksecurefunc` / `HookScript` only  
- [ ] Protected-touching layout/options queued on `PLAYER_REGEN_ENABLED`  
- [ ] In-client combat smoke: open ladder, approve (or mock path), use dropdown/confirm mid-trash → then bags/character pane still work  
- [ ] Offline: `lua tests/run.lua` exit 0 when Core/Data/harness touched  

---

## 7. Where to deepen (do not duplicate)

| Need | Path |
|------|------|
| Taint model + taint.log | [`29-taint-secure-ui/tainted-execution.md`](../wow-classic-addon-design/29-taint-secure-ui/tainted-execution.md) |
| In-combat matrix + queue | [`29-taint-secure-ui/combat-lockdown-beef-ui.md`](../wow-classic-addon-design/29-taint-secure-ui/combat-lockdown-beef-ui.md) |
| Social footguns | [`29-taint-secure-ui/social-addon-footguns.md`](../wow-classic-addon-design/29-taint-secure-ui/social-addon-footguns.md) |
| Why not SecureHandlers | [`29-taint-secure-ui/secure-handlers-and-templates.md`](../wow-classic-addon-design/29-taint-secure-ui/secure-handlers-and-templates.md) |
| StaticPopup slots | [`58-staticpopup-confirms/preferredindex-and-slots.md`](../wow-classic-addon-design/58-staticpopup-confirms/preferredindex-and-slots.md) |
| `/g` announce pipeline | [`72-guild-chat-announce-api/`](../wow-classic-addon-design/72-guild-chat-announce-api/) |
| Cursor rule (globs UI + bootstrap) | [`.cursor/rules/wow-ui-taint-lockdown.mdc`](../../../.cursor/rules/wow-ui-taint-lockdown.mdc) |
| UI art / CreateFrame briefing | [`docs/superpowers/ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) |

---

## 8. One-line doctrine for polish agents

*Keep Church of Beef sticky honey on Beef frames only; keep the window insecure so combat can still open it; put spectacle in guild chat and private toasts, never in SecureActionButtons or Blizzard panel APIs.*

---

## 9. Deepen pass — primary-sourced taint & lockdown (2026-07-26)

> **CoB constraints preserved:** `## Interface: 20506`; no bots, injection, protected-action bypass, or gameplay automation; insecure product frames only; UI displays Core outcomes and never awards points; Net never invents ranks. This section cites primaries — it does **not** fork product law away from the design spec or `wow-ui-taint-lockdown.mdc`.

### Canonical model (what “honey” means)

Blizzard’s secure model treats addon code and its SavedVariables as **tainted**. Reading a tainted value taints the execution path; writing from that path taints new values. Protected functions refuse insecure paths; protected frames refuse combat mutations from tainted code ([Secure Execution and Tainting — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting); [Wowpedia mirror](https://wowpedia.fandom.com/wiki/Secure_Execution_and_Tainting); readable restatement [AddOn Studio](https://addonstudio.org/wiki/WoW:Secure_Execution_and_Tainting)).

`hooksecurefunc` exists so addons can observe secure work **after** it runs without replacing handlers — replace ≠ hook ([function-hooking notes](https://github.com/NeticSoul/wow-335a-addon-wiki/blob/main/sources/ch19-function-hooking.md); [avoid taint — WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=59335)).

### Combat lockdown vs taint (two clocks)

[`InCombatLockdown()`](https://warcraft.wiki.gg/wiki/API_InCombatLockdown) answers “are protected mutations blocked right now?” Timing vs regen events matters: enter combat → `PLAYER_REGEN_DISABLED` → lockdown true; leave → lockdown clears → `PLAYER_REGEN_ENABLED`. Drain deferred chrome on the latter.

Practical forum guidance: **insecure** frames can still `:Show()` / `:Hide()` in combat; a secure child can infect the parent tree and make the whole window fail ([Showing Elements in Combat Lockdown — US forums](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762)). Real addon breakage from `ShowUIPanel` in combat is documented in the wild ([QuickQuest #36](https://github.com/p3lim-wow/QuickQuest/issues/36); [`ShowUIPanel` combat protection notes](https://wowpedia.fandom.com/wiki/API_ShowUIPanel)).

**CoB mapping:** `/beef` must stay fully insecure under `UIParent` (or Beef root). Never `SecureActionButtonTemplate` “just to open a panel.” Never `ShowUIPanel` for the ladder.

### Diagnostics agents should actually run

| Tool | Primary | When |
|------|---------|------|
| `/console taintlog 1` (then 2/11) → `Logs/taint.log` | [Townlong Yak — Taint about (archive)](https://web.archive.org/web/20210518120056/https://www.townlong-yak.com/taint.log/about.html) | Mysterious “Interface action failed…” after using Beef |
| `issecurevariable` | [API issecurevariable — wiki.gg](https://warcraft.wiki.gg/wiki/API_issecurevariable) | Inspect which addon last wrote a sticky global |
| `ADDON_ACTION_BLOCKED` | [Wowpedia event](https://wowpedia.fandom.com/wiki/ADDON_ACTION_BLOCKED) | Optional internal telemetry — never spam users |
| FrameXML peek | [Townlong Yak FrameXML](https://www.townlong-yak.com/framexml/live) / community mirrors when TY drifts ([forum thread](https://us.forums.blizzard.com/en/wow/t/now-that-townlong-yak-is-apparently-gone-where-do-we-get-framexml-from/1262702)) | Verify protected API lineage — rare |

Blame in `ADDON_ACTION_BLOCKED` names *a* sticky addon, not always the first touch — bisect with taintlog, don’t guess from the toast that was on screen.

### Social footguns with citations

| Footgun | Evidence | CoB prefer |
|---------|----------|------------|
| Stock `UIDropDownMenu_*` / `EasyMenu` | [Townlong Yak — UIDropDownMenu issues (archive)](https://web.archive.org/web/20200715202710/https://www.townlong-yak.com/bugs/PfF9rr-UIDropDownMenu) | Custom frames or [LibUIDropDownMenu — WowAce](https://www.wowace.com/projects/libuidropdownmenu) / [CurseForge](https://www.curseforge.com/wow/addons/libuidropdownmenu) |
| Blind `StaticPopup_Show` | [AddOn Studio — popup dialogs](https://addonstudio.org/wiki/WoW:Creating_simple_pop-up_dialog_boxes) (`preferredIndex = 3`) | Own insecure confirm **or** named `COB_*` dialog + preferredIndex |
| Replacing chat `AddMessage` | [WoWInterface — don’t replace AddMessage](https://www.wowinterface.com/forums/showthread.php?t=60069) | Filters / `hooksecurefunc` / `HookScript` only |
| Secure templates for panels | [SecureActionButtonTemplate](https://warcraft.wiki.gg/wiki/SecureActionButtonTemplate); [SecureTemplates overview](https://warcraft.wiki.gg/wiki/SecureTemplates) | Fully insecure `CreateFrame` — Beef is not a cast/target tool |
| Hardware-event theater for announce | Spec + ToS; secure model exists for **gameplay** actions | Officer Approve = data + messaging + display; `GUILD` chat from Classic addon code does not need outdoor HW-event theater |

Readable secondary overview of lockdown queues / hardware events: [better-addons — Security Model](https://www.better-addons.com/security) (onboarding aid; wiki remains primary).

### UX recipes tied to primaries

1. **Promote mid-trash:** Core commit + BeefNet + optional `/g` + private insecure toast — all OK if frames are insecure ([forum combat show guidance](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762)).  
2. **Options / geometry that might touch protected ancestry:** if `InCombatLockdown()` then queue; drain on `PLAYER_REGEN_ENABLED`; soft copy “Opens when combat ends.”  
3. **Demote confirm:** never treat a nil/failed `StaticPopup_Show` as Accept; prefer Beef-owned modal.  
4. **Post-session bags/character pane:** must still work — if not, treat as taint regression, not “player error.”

### What polish agents must never “fix” with secure widgets

Church of Beef is announce / track / sync. Using SecureHandlers, SecureStateDriver, or SecureActionButton to “make the toast work in combat” is the wrong genre ([SecureHandlers](https://warcraft.wiki.gg/wiki/SecureHandlers); [Iriel Field Guide PDF](http://www.iriel.org/wow/docs/SecureHeadersGuide-4.0-r1.pdf) — read before any experiment, then still prefer insecure). V1 does not need attribute-driven protected widgets for a guild ladder.

### Combat smoke matrix (cite-backed)

| Step | Expect | If fail |
|------|--------|---------|
| Open `/beef` mid-pull | Insecure Show OK | You added a secure child — remove it |
| Approve / mock commit mid-pull | SV + net + announce path runs | Do not gate commit on Blizzard panel open |
| Open dropdown/confirm mid-pull | Custom or LibUIDropDownMenu; bags still work after | Stock EasyMenu taint — replace |
| Leave combat | Deferred options/layout drain once | Backlog must not rebuild guild N× |

---

## External sources

Annotated primaries for this deepen pass (≥8). Prefer wiki + forum + library docs over SEO “fix taint” blogs.

1. [Secure Execution and Tainting — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting) — canonical taint + protected-frame model.  
2. [Secure Execution and Tainting — Wowpedia](https://wowpedia.fandom.com/wiki/Secure_Execution_and_Tainting) — mirror.  
3. [AddOn Studio — Secure Execution and Tainting](https://addonstudio.org/wiki/WoW:Secure_Execution_and_Tainting) — clear hooksecurefunc wording.  
4. [API InCombatLockdown — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_InCombatLockdown) — lockdown timing vs regen events.  
5. [API issecurevariable — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_issecurevariable) — inspect sticky globals.  
6. [ADDON_ACTION_BLOCKED — Wowpedia](https://wowpedia.fandom.com/wiki/ADDON_ACTION_BLOCKED) — blocked protected call event.  
7. [API ShowUIPanel — Wowpedia](https://wowpedia.fandom.com/wiki/API_ShowUIPanel) — combat protection since 8.2.0 lineage.  
8. [Showing Elements in Combat Lockdown — Blizzard US forums](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762) — Gello: insecure Show OK; secure child infects parents.  
9. [Townlong Yak — Taint about (archive)](https://web.archive.org/web/20210518120056/https://www.townlong-yak.com/taint.log/about.html) — taint.log levels / what is not logged.  
10. [Townlong Yak — UIDropDownMenu issues (archive)](https://web.archive.org/web/20200715202710/https://www.townlong-yak.com/bugs/PfF9rr-UIDropDownMenu) — dropdown taint catalog.  
11. [LibUIDropDownMenu — WowAce](https://www.wowace.com/projects/libuidropdownmenu) — namespaced dropdown clone.  
12. [LibUIDropDownMenu — CurseForge](https://www.curseforge.com/wow/addons/libuidropdownmenu) — Classic/TBC channels.  
13. [AddOn Studio — Creating simple pop-up dialog boxes](https://addonstudio.org/wiki/WoW:Creating_simple_pop-up_dialog_boxes) — `preferredIndex = 3`.  
14. [WoWInterface — don’t replace AddMessage](https://www.wowinterface.com/forums/showthread.php?t=60069) — chat hook hygiene.  
15. [SecureActionButtonTemplate — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/SecureActionButtonTemplate) — protected action exposure (do not use for Beef panels).  
16. [SecureTemplates — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/SecureTemplates) — family overview.  
17. [QuickQuest #36 — panel open in combat](https://github.com/p3lim-wow/QuickQuest/issues/36) — real `ShowUIPanel` breakage.  
18. [better-addons — Security Model](https://www.better-addons.com/security) — readable secondary overview.  
19. [avoid taint — WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=59335) — community taint avoidance discussion.  
20. [Iriel — Field Guide to Secure Handlers (PDF)](http://www.iriel.org/wow/docs/SecureHeadersGuide-4.0-r1.pdf) — deep SecureHandlers reference (last resort).  

**Sister depth (repo):** [29 annotated-urls](../wow-classic-addon-design/29-taint-secure-ui/annotated-urls.md) · [58 StaticPopup](../wow-classic-addon-design/58-staticpopup-confirms/) · [72 guild announce](../wow-classic-addon-design/72-guild-chat-announce-api/).

---

## 10. Web-harvest gotchas (2026-07-26 deepen)

Additional Classic / community primaries from the [01b](01b-classic-ui-web-digest.md) harvest. Do not fork product law — these sharpen failure modes agents keep rediscovering.

### 10.1 Interface Options + stock dropdowns (Classic case study)

[Classic taint resolution — Blizzard UI #522359](https://us.forums.blizzard.com/en/wow/t/classic-taint-resolution-resourcesassistance/522359): an author saw `UIDROPDOWNMENU_MENU_LEVEL` tainted by their addon **only after** moving options from a private frame into the shared Interface Options panel. Stock `UIDropDownMenu` globals are a shared FrameXML surface; Ace/Lib encapsulation or a private options frame keeps Beef sticky honey off Blizzard menus.

**CoB:** V1 has no Interface Options tab requirement. If agents add settings chrome later, prefer Beef-owned frames or LibUIDropDownMenu — never raw EasyMenu inside Blizzard’s options tree.

### 10.2 BackdropTemplate is not “just SetBackdrop”

From [BackdropTemplate — wiki.gg](https://warcraft.wiki.gg/wiki/BackdropTemplate) + [Blizzard BackdropTemplate issues](https://us.forums.blizzard.com/en/wow/t/backdroptemplate-issues/1125674) + [WoWI #59730](https://www.wowinterface.com/forums/showthread.php?t=59730):

| Gotcha | Failure | Prefer |
|--------|---------|--------|
| Inherit missing | `SetBackdropColor` is nil | `CreateFrame(..., "BackdropTemplate")` or multi-inherit `"BackdropTemplate,…"` |
| Mutate then `SetBackdrop(sameTable)` | **Silent no-op** | Pass a **new** `backdropInfo` table (or `ClearBackdrop` + reapply) |
| Dual `SetPoint` without `SetSize` | Frame exists, backdrop may not draw | Explicit size, or anchors that imply width/height |
| Tooltip template alone | Post-9.0 tooltips may not inherit Backdrop | Multi-inherit BackdropTemplate when coloring tooltips |

Anniversary has BackdropTemplate ([Wowpedia Classic backport note](https://wowpedia.fandom.com/wiki/BackdropTemplate)). V1 still prefers `BasicFrameTemplate` shell before custom fills.

### 10.3 Hook doctrine reminder

[Hooking functions — wiki.gg](https://warcraft.wiki.gg/wiki/Hooking_functions) / [`hooksecurefunc`](https://warcraft.wiki.gg/wiki/API_hooksecurefunc): post-hooks only. Replacing `SetScript` on FrameXML or chat `AddMessage` for “polish” is how bags break after a guild night.

### 10.4 FrameXML peeks when Townlong Yak drifts

[Forum: where do we get FrameXML?](https://us.forums.blizzard.com/en/wow/t/now-that-townlong-yak-is-apparently-gone-where-do-we-get-framexml-from/1262702) · [Gethe/wow-ui-source](https://github.com/Gethe/wow-ui-source) · [Ketho Templates.lua](https://github.com/Ketho/BlizzardInterfaceResources/blob/live/Resources/Templates.lua). Use for template-name verification — not as a license to copy Secure* ceremony paths into Beef.
