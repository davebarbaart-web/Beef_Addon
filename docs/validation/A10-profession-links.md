# A10 — Profession/tradeskill links on TBC client

**Appendix A item:** 10  
**Owner:** David  
**Result:** NOT RUN

Cited: Bible Appendix A item 10; §3.1 (profession/tradeskill links exist); §14.3 (later-phase self-reported profession directory); §12.1 (character owns profession information); §17 (profession capabilities are self-reported, generally public).

## Dependent feature

Later-phase **self-reported profession directory** (§14.3): recognition ("meaningful capability in service of the guild") and utility ("who in the Church can make this?"). Opt-in. Never rewards crafting volume.

Appendix A: profession/tradeskill links on the TBC client.

This sheet is **method only**. Do not spec the directory, a profession schema, or a volume score.

## Bible fallback

Appendix A item 10 names **no** standalone fallback. The Appendix A closer applies. §3.2: platform-dependent features (including profession links) isolate behind capability checks — that is a portability rule, not a directory design.

Do not invent a self-typed profession form as a silent substitute.

## Live-client method (Anniversary TBC, Interface 20506)

A character who has at least one profession. `/console scriptErrors 1`. Default tradeskill UI. Do not add profession code to the addon.

1. **Open the tradeskill.** Open a crafting profession the character actually has. Record the window title / skill name the client shows.
2. **Link.** Use the client's own "link profession" (or equivalent chat-link) control if it exists. Paste or note the exact link text. Record whether a second client can click it and see the skill.
3. **API read (observation).** From a `/run` while that window is open, record whether a list-link or skill-name API this client exposes returns a string. If the call does not exist, write "API absent" — do not guess Retail `GetProfessions`.
4. **Gathering / second skill.** If a gathering profession or a second craft is available, repeat step 2. If not, write "single profession."
5. **Write facts on this sheet.** Whether TBC Anniversary can emit a clickable profession link, and what the string looked like. No directory. No Grant. No activity leaderboard.

Do not change addon Lua from this sheet.

## Not a pass

- Harness green
- Character rows existing in the store
- An invented profession table
- Retail profession APIs named but not exercised on 20506

## Leftovers

- Self-reported profession directory (§14.3 — later phase; do not spec)
- Opt-in UX (do not invent)
- Capability-check isolation for Classic+ (§3.2 — after this Result)
