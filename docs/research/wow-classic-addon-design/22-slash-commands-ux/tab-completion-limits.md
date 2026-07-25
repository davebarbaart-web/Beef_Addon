# Tab completion limits

**Last updated:** 2026-07-25

## Two different “Tab” behaviors

### 1. Built-in slash-name completion (always on)

Typing `/` then Tab cycles available slash command strings registered with the client. Typing `/a` then Tab suggests `/afk`, etc. Bare `/` + Tab walks the full list ([WoWInterface archive](https://wowinterface.com/forums/archive/index.php/t-48783.html)).

**Limits for Beef:**

- Completes **command names** (`/beef`), not subcommands (`ladder`).
- Competition: every addon + Blizzard command is in the pool — short unique names surface faster.
- No API to attach “description” chips like Discord; players only see the string.

### 2. Argument / wordlist completion (opt-in library)

[AceTab-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-tab-3-0) provides tab-completion support. WowAce explicitly notes the library is **“not yet finalized.”**

`RegisterTabCompletion(descriptor, prematches, wordlist, usagefunc, listenframes, postfunc, pmoverwrite)` ([AceTab source](https://github.com/WoWUIDev/Ace3/blob/master/AceTab-3.0/AceTab-3.0.lua); documented historically via AceTab-2.0 wiki referenced in source comments).

Observed behaviors from source:

- Prematch string/table gates when the completion set applies (e.g. after `/beef `).
- Wordlist may be a table or function that fills candidates.
- Multiple matches → cycle on subsequent Tabs; can print usage lines to `DEFAULT_CHAT_FRAME`.
- Secure commands are filtered via `IsSecureCmd` in the completion path.

[AceConfigCmd:CreateChatCommand](https://www.wowace.com/projects/ace3/pages/api/ace-config-cmd-3-0) **also registers tab completion with AceTab** when you wire options to a slash. That is the “free” Tab for nested `options.args` trees — and the reason Ace options slash UIs feel complete.

## Practical limits (design constraints)

| Constraint | Implication |
|------------|-------------|
| No Ace in V1 plan | No AceTab / AceConfigCmd Tab for free |
| Hand-rolled Tab is non-trivial | Hooks edit box; fights other addons; easy to break |
| Usage dump on cycle | Can spam chat if wordlist is huge |
| Officer-only candidates | Completing `approve` for members teaches the wrong surface |
| Secure / Blizzard commands | Never try to Tab-complete protected macros into Beef |

## Recommendation for Church of Beef

**V1:** Rely on built-in `/beef` name completion + excellent `/beef help`. Do not ship AceTab.

**V1.5 (if officers demand):** Tiny custom completion for a **closed** member verb set (`help`, `ladder`, `standing`, `gora`, `ceremony`) only when prematch is `^/beef%s`; omit officer verbs from the wordlist for non-officers (or omit entirely and keep officer actions in UI).

**V2+ with AceConfig:** Let AceConfigCmd own settings Tab; keep gameplay verbs in the hand-rolled handler so settings noise does not swallow `ladder` / `standing`.

## Streamer / accessibility note

Tab discovery helps power users. Voice-driven streamers still need **speakable** verbs (`/beef help`, `/beef ladder`). Prefer whole words over cryptic flags (`/beef -o`).
