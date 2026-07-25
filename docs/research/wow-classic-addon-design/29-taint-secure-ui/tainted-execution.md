# Tainted execution

**Track:** 29-taint-secure-ui  
**Purpose:** Mental model for secure vs tainted execution — how taint spreads, how it fails, how to observe it. Not a performance guide.

## Why this exists

Since patch 2.0, the UI API forces human decision-making for combat-sensitive actions by refusing **protected** calls from **tainted** execution paths ([Secure Execution and Tainting](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)). Classic ships this modern model; Vanilla-era automation is impossible ([same page — Impact on gameplay](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)).

Official intent (Tyren / slouken, 2006): addons must not make combat-sensitive decisions; casting/targeting still work only with **user interaction**, not addon logic picking spells/targets ([wiki — Official statements](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)).

## Starting state at UI load

| Source | Initial taint |
|--------|----------------|
| Blizzard-signed FrameXML + Blizzard addons (+ their SavedVariables) | Secure |
| Third-party addons (+ their SavedVariables) | Tainted |

([wiki — Taint](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting))

Execution begins secure. It becomes tainted when it reads tainted data or runs addon code. Anything written while tainted becomes tainted. Protected functions refuse insecure paths ([wiki](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting); [Townlong Yak — Taint in WoW](https://web.archive.org/web/20210518120056/https://www.townlong-yak.com/taint.log/about.html)).

**Persistence:** taint on important globals/paths lasts until **relog or `/reload`**, not until combat ends ([wiki](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)).

## What can carry taint

All Lua values/references: locals, globals, table keys/values, function closures, widget script slots ([wiki — What can be tainted?](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting); [Townlong Yak](https://web.archive.org/web/20210518120056/https://www.townlong-yak.com/taint.log/about.html)).

Propagation rules (wiki summary):

- New values inherit the current execution path’s taint.
- Accessing a **secure** value from a **tainted** path yields a tainted *result*; the original store stays clean.
- Accessing a **tainted** value taints the execution path.
- Setting a global stamps the path’s taint onto that global.
- Running a tainted closure applies its taint to the environment.

### Honey analogy (useful for debugging)

Addon code is sticky. Anything it touches becomes sticky. If Blizzard later touches sticky data, Blizzard’s hands become sticky — and a protected call then fails. The error handler “taste-tests” which addon’s honey is to blame ([wiki — Honey analogy](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)).

Most player-facing failures are **unintended propagation**, not deliberate automation ([Townlong Yak](https://web.archive.org/web/20210518120056/https://www.townlong-yak.com/taint.log/about.html)).

## Terminology (do not mix these up)

| Term | Meaning |
|------|---------|
| Secure | Without taint (clean) |
| Secure code | Untainted execution or untainted function |
| Protected **function** | Callable only from a secure execution state (combat-sensitive APIs) |
| Protected **frame** | Locked down during combat (Show/Hide/attributes/anchors restricted) |
| Protected **method** | Widget method blocked on protected frames from tainted paths in combat |
| Secure **templates** | XML templates that install secure script handlers (usually create protected frames) |

([wiki — Terminology](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting))

## Safe post-hooks (anti-taint tools)

Two APIs exist specifically so addons can observe secure work without replacing it:

1. **`hooksecurefunc(["table"], "name", func)`** — post-hook a secure global; your func gets the same args *after* the original; return values from your hook are discarded; original taint mode is restored after your hook ([wiki](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting); [AddOn Studio mirror](https://addonstudio.org/wiki/WoW:Secure_Execution_and_Tainting)).
2. **`frame:HookScript("scriptTypeName", func)`** — post-hook a widget script; runs after existing handlers without spreading taint into already-done secure work ([wiki](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)).

`hooksecurefunc` cannot *remove* existing taint; it only avoids introducing more into the original call ([AddOn Studio](https://addonstudio.org/wiki/WoW:Secure_Execution_and_Tainting)).

### Inspection APIs

- **`issecurevariable([tbl,] variable)`** → `isSecure, taint` where `taint` names the addon (or `""` for macro) ([wiki](https://warcraft.wiki.gg/wiki/API_issecurevariable)).
- Related trail: `issecure`, `forceinsecure`, `securecall`, `secureexecuterange` ([wiki trail](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)).

Secondary guides also note that `loadstring` / `setfenv` produce irrevocably tainted code ([better-addons security guide](https://www.better-addons.com/security)) — avoid for anything that must stay near secure UI.

## How failures look to players

- Chat: “Interface action failed because of an AddOn …” / action blocked ([Townlong Yak](https://web.archive.org/web/20210518120056/https://www.townlong-yak.com/taint.log/about.html); [ADDON_ACTION_BLOCKED (Wowpedia)](https://wowpedia.fandom.com/wiki/ADDON_ACTION_BLOCKED)).
- Popups suggesting disable of a specific addon (blame can be misleading if multiple flavors of honey mixed).
- Silent functional breakage (e.g. bags/quest frame won’t open in combat) until reload.

## Diagnostics: `taint.log`

Enable with `/console taintlog N` → `Logs/taint.log` ([Townlong Yak](https://web.archive.org/web/20210518120056/https://www.townlong-yak.com/taint.log/about.html)):

| Level | Logs |
|------:|------|
| 0 | Nothing (default) |
| 1 | Blocked protected actions (stack traces) |
| 2 | + tainting / accessing tainted globals |
| 11 | + tainted table entries |

**Gap:** no level traces taint through locals, widget properties, or non-string table keys — so level-1 “action blocked” with empty upstream trail is possible ([Townlong Yak](https://web.archive.org/web/20210518120056/https://www.townlong-yak.com/taint.log/about.html)). Tip: drop level to 0 after reproducing before `/reload` when chasing a specific case.

## Beef design takeaway

Church of Beef’s product surface (ladder, titles, announcements, officer approve/reject) is **display and coordination**. Treat every interaction with Blizzard FrameXML globals as a contamination risk. Prefer:

- Own frames + own tables
- Post-hooks only where observing Blizzard is required
- Never overwrite FrameXML functions “because it’s easier”

See [social-addon-footguns.md](social-addon-footguns.md) for the high-frequency failure modes.