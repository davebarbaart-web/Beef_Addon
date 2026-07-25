# Script Errors, BugGrabber, and BugSack

**Last updated:** 2026-07-25  
**Track:** [19-testing-debugging-qa](README.md)

---

## 1. `/console scriptErrors`

Modern clients **do not show Lua errors by default**. The UI options checkbox that once toggled this was removed; the supported switch is a CVar.

| Action | Command |
|--------|---------|
| Show Lua error dialogs | `/console scriptErrors 1` |
| Hide Lua error dialogs | `/console scriptErrors 0` |
| Equivalent from Lua / macros | `SetCVar("scriptErrors", 1)` — `/console` is effectively a SetCVar wrapper |

**Primary facts:**

- Wiki lists `scriptErrors` as an **Account**-scoped Game CVar, default **`0`**, description: “Whether or not the UI shows Lua errors” ([Console variables](https://warcraft.wiki.gg/wiki/Console_variables)).
- Community / author FAQ guidance matches: enable with `1`, disable with `0`; there is often **no confirmation**, and a **reload or relog** may be required if the addon failed during load ([Rarity FAQ — enable/disable script errors](https://www.wowace.com/projects/rarity/pages/faq/how-to-enable-and-disable-script-errors-lua-errors); [Blizzard forums — LUA Error Display](https://us.forums.blizzard.com/en/wow/t/lua-error-display/789150); [EU forums — LUA errors logs](https://eu.forums.blizzard.com/en/wow/t/lua-errors-logs/84307)).

**Developer practice for Beef:**

- Keep `scriptErrors 1` on every author/test account for Anniversary.
- Do **not** ship Church of Beef code that forces `scriptErrors 0` for players — that hides other addons’ faults and makes guild bug reports useless ([WoWInterface — console into addon](https://wowinterface.com/forums/showthread.php?t=59013): fix errors rather than silence them).
- After a `/reload` that fails mid-load, re-check the CVar and BugSack history; silent slash-command disappearance often means a load error with errors hidden.

---

## 2. BugGrabber + BugSack (standard pair)

| Addon | Role |
|-------|------|
| **!BugGrabber** / BugGrabber | Captures Lua errors; exposes `/buggrabber`. Alone, prints to chat — not ideal UX ([WoWInterface BugGrabber](https://www.wowinterface.com/downloads/fileinfo.php?id=23141); [Wago BugGrabber](https://addons.wago.io/addons/buggrabber)). |
| **BugSack** | Display layer: LDB/minimap, session error list, **copy/paste** full stack. **Requires BugGrabber** ([GitHub funkydude/BugSack](https://github.com/funkydude/BugSack); [CurseForge BugSack](https://www.curseforge.com/wow/addons/bugsack); [WoWInterface BugSack](https://www.wowinterface.com/downloads/info5995-BugSack.html)). |

**Compatibility note (2026):** BugSack lists Classic / TBC Classic among supported flavors on CurseForge/WoWInterface — install the **Classic TBC / Anniversary** build into the Anniversary AddOns tree, not Retail’s.

**Slash / UX:**

- BugSack: open via LDB/minimap or `/bugsack` (community mirrors document the same flow).
- Grabber without Sack: `/buggrabber` + chat spam — fine for emergency triage, poor for streamers.

**Reporting hygiene for Beef guild testers:**

1. Install BugGrabber + BugSack on Anniversary client.
2. Reproduce once with `/console scriptErrors 1` if you need the Blizzard dialog too.
3. Copy stack from BugSack; include **addon version**, **client** (`/dump (select(4, GetBuildInfo()))`), and **what you clicked** (`/beef` tab, officer approve, etc.).
4. One error at a time — sack history fills quickly on broken ElvUI stacks; clear after filing.

---

## 3. When to use which tool

| Situation | Prefer |
|-----------|--------|
| Author day-to-day coding | `scriptErrors 1` + BugSack |
| Guild officer playtest / stream | BugSack (errors don’t hard-block the screen as aggressively as raw dialogs for some setups; still capture stacks) |
| Player “something broke” report without Sack | Ask them to enable `scriptErrors 1`, `/reload`, screenshot dialog |
| Bisecting “which addon” | Disable half the AddOns list; keep Beef + BugSack last |

---

## 4. Implications for Church of Beef

- Spec §13.1 already assumes in-game verification — **make BugSack part of the official playtest kit**, same as “two characters.”
- Load-order / TOC mistakes often surface as **missing slash commands with no visible error** if `scriptErrors` is off ([EU forums](https://eu.forums.blizzard.com/en/wow/t/lua-errors-logs/84307)).
- ElvUI and other large UIs keep BugSack in debug workflows; coexistence is expected ([community changelog references in library `.raw`](../.raw/elvui-short.md)) — Beef should not fight BugGrabber’s error hook.
