# Track 29 — Taint, secure frames, combat lockdown UI

**Track id:** `29-taint-secure-ui`  
**Last updated:** 2026-07-25  
**Sole focus:** Secure execution / taint model, SecureHandlers & templates, what Church of Beef UI can safely do under combat lockdown, and Classic social-addon taint footguns.  
**Out of scope:** Performance norms (OnUpdate budgets, CTL CPS, memory) — that belongs to track `04-toc-api-performance`. Messaging budgets → track 14. Combat HUD UX → track 08. No addon implementation in this folder.

## Product truth (from V1 spec)

| Locked stance | Implication for this track |
|---------------|----------------------------|
| Social guild / streamer-event addon | Prefer **insecure** display UI; do not inherit secure combat templates “just in case” |
| No protected-action circumvention | No cast/target/binding automation; no SecureActionButton for gameplay |
| May announce, track, display, coordinate | FontStrings, textures, custom frames, Ace options, toasts are the main surface |
| Officer+ approval for ranks | Confirmation UI must survive dungeon combat without tainting Blizzard UI |

Source: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §2, §3, §4.

## Index

| Note | Covers |
|------|--------|
| [tainted-execution.md](tainted-execution.md) | Secure vs tainted execution, propagation (“honey”), hooks, diagnostics |
| [secure-handlers-and-templates.md](secure-handlers-and-templates.md) | Protected frames, SecureTemplates, SecureHandlers, RestrictedEnvironment, state drivers |
| [combat-lockdown-beef-ui.md](combat-lockdown-beef-ui.md) | `InCombatLockdown`, what Beef UI may/must not do in combat, queue pattern |
| [social-addon-footguns.md](social-addon-footguns.md) | UIDropDownMenu, StaticPopup, ShowUIPanel, parent/anchor pollution, chat hooks |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Stay insecure on purpose.** Classic uses the modern secure/taint model ([Secure Execution and Tainting](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)). Beef does not need `SecureActionButtonTemplate` or unit headers. The moment you inherit a secure template, parent/anchor lockdown can freeze your whole window during combat ([Blizzard UI forum — Gello](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762)).

2. **Taint is sticky and session-long.** Addon code and its SavedVariables start tainted. Reading tainted values taints the current execution path; writing from that path taints new values. Spreading taint into Blizzard paths breaks protected calls until `/reload` or relog ([wiki](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting); [Townlong Yak](https://web.archive.org/web/20210518120056/https://www.townlong-yak.com/taint.log/about.html)).

3. **Post-hook, never replace.** Use `hooksecurefunc` / `HookScript` so your code runs *after* secure work and does not overwrite Blizzard handlers ([wiki — Securely post-hooking](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)). Replacing `ChatFrame*.AddMessage` or `SetScript` on FrameXML widgets is a social-addon classic footgun.

4. **Combat lockdown ≠ “no UI.”** Lockdown blocks modifying **protected** frames (Show/Hide/attributes/anchors/parents) and macros/bindings ([`InCombatLockdown`](https://warcraft.wiki.gg/wiki/API_InCombatLockdown)). Plain addon frames with FontStrings/textures can still update. Queue *secure-touching* work for `PLAYER_REGEN_ENABLED`.

5. **Dropdowns and popups are the social minefield.** Stock `UIDropDownMenu` / `EasyMenu` share protected globals and historically taint Blizzard menus ([Townlong Yak bug index](https://web.archive.org/web/20200715202710/https://www.townlong-yak.com/bugs/PfF9rr-UIDropDownMenu); [LibUIDropDownMenu](https://www.wowace.com/projects/libuidropdownmenu)). Prefer AceGUI/LibUIDropDownMenu; set `preferredIndex = 3` on custom `StaticPopupDialogs` entries.

6. **SecureHandlers are a last resort for Beef.** Restricted snippets (`_onclick`, `_onstate-*`, etc.) exist for combat-safe show/hide of *protected* UI ([SecureHandlers](https://warcraft.wiki.gg/wiki/SecureHandlers)). Beef should almost never need them — if you do, you probably introduced a secure child you did not need.

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Warcraft Wiki / Townlong Yak / WowAce / Blizzard UI forums over secondary listicles.