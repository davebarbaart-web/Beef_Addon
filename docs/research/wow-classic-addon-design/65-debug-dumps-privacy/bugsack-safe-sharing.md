# BugSack / BugGrabber — safe sharing norms

**Track:** [65-debug-dumps-privacy](README.md)  
**Last updated:** 2026-07-25  
**Purpose:** How Classic authors and testers share Lua error traces without oversharing. Install/how-to stays in track [19](../19-testing-debugging-qa/script-errors-bugsack.md); this note is privacy + paste hygiene.

---

## 1. Ecosystem default (what “good” looks like)

| Step | Norm | Sources |
|------|------|---------|
| 1 | Install **BugGrabber** + **BugSack** (both) on the correct Classic/TBC flavor | [BugSack](https://github.com/funkydude/BugSack); [CurseForge BugSack](https://www.curseforge.com/wow/addons/bugsack); [BugGrabber](https://addons.wago.io/addons/buggrabber) |
| 2 | Reproduce once | — |
| 3 | Open sack (LDB/minimap or `/bugsack`) → **copy one error** | BugSack: “text of the error can then be copied & pasted” |
| 4 | Paste to author Discord / GitHub with **addon version**, **client build**, **what you clicked** | [r/classicwow TBC reporting culture](https://www.reddit.com/r/classicwow/comments/1q8eg6k/some_addons_are_gonna_break_in_tbc_here_is_the/); [19 reporting hygiene](../19-testing-debugging-qa/script-errors-bugsack.md) |
| 5 | Clear sack after filing if history is noisy | Community practice (ElvUI stacks fill fast) |

BugGrabber alone prints to chat — fine for emergency triage, poor for streamers and for privacy (errors spam into a buffer that `/chatlog` can persist). Prefer Sack’s copy UI ([BugGrabber “use BugSack” guidance](https://addons.wago.io/addons/buggrabber)).

---

## 2. Share unit = one stack, not the archive

| Artifact | Share publicly? | Notes |
|----------|-----------------|-------|
| BugSack clipboard of **current** error | **Yes** (after quick redact) | Standard |
| BugSack “session” list as a screenshot | Prefer copy text of the relevant one | Screenshots may show other addons’ errors |
| `WTF\...\SavedVariables\!BugGrabber.lua` (or `BugGrabberDB`) | **No** by default | Multi-addon error archive; may retain prior sessions ([Turtle wiki usage notes](https://turtle-wow.fandom.com/wiki/BugSack); [local SV debug TIL](https://rpmessner.github.io/til/wow/debugging-addons-with-savedvariables.html)) |
| Full `ChurchOfBeefDB` / other addon SV zips | **No** unless maintainer explicitly asks privately | Mature cousin: WeakAuras asks for `WeakAuras.lua` only when the failing aura is unknown ([bug_report.yml](https://github.com/WeakAuras/WeakAuras2/blob/main/.github/ISSUE_TEMPLATE/bug_report.yml)) |

---

## 3. What usually lands inside a stack

Typical BugGrabber error objects include a **message** and a **stack** of file paths / function names (example SV dumps in the wild show path + line frames, e.g. [sample !BugGrabber.lua](https://github.com/mmathias01/WoWza/blob/master/WTF/Account/SWEETDOC/SavedVariables/!BugGrabber.lua)).

**Usually low sensitivity:** addon folder names, Line numbers, Blizzard `FrameXML\...` frames.

**Sometimes sensitive:**

- Error messages that interpolated `UnitName`, guild names, or whisper fragments
- Custom `print`/`error` strings that embedded roster keys
- Absolute-ish path noise is rare in WoW stacks (addon-relative), but **do not** accompany the paste with your WTF account-folder path

**Redact before public GitHub:** replace third-party character names in the *message* line; leave stack frames intact unless a frame name itself embeds a player string (uncommon).

---

## 4. Minimum accompaniment (support template)

When pasting a BugSack stack for Church of Beef, include:

```
Addon: Church of Beef <version>
Client: /dump select(4, GetBuildInfo())  → <paste result>
Flavor: TBC Anniversary (or actual)
COB.DEBUG: on/off (if known)
Repro: 1) … 2) … 3) …
BugSack: <one stack>
```

Optional: curated `/beef` status dump — see [debug-dump-allow-deny.md](debug-dump-allow-deny.md).  
Do **not** attach `WoWChatLog.txt` or combat logs — see [chat-logs-and-disk-artifacts.md](chat-logs-and-disk-artifacts.md).

---

## 5. Channel choice

| Channel | Stack OK? | SV file OK? |
|---------|-----------|-------------|
| Private maintainer Discord / DM | Yes | Only if asked; zip single addon SV |
| Guild officer private channel | Yes | Rarely; prefer status dump |
| Public Discord | Yes after redact | No |
| Public GitHub Issues | Yes after redact | No (unless maintainer requests + you accept exposure) |
| Livestream chat | Avoid — use whisper/DM to tech spotter | No |

WeakAuras / BigWigs-scale projects normalize “BugSack + both addons” in issue templates; they do **not** normalize dumping the whole WTF tree ([WA template](https://github.com/WeakAuras/WeakAuras2/blob/main/.github/ISSUE_TEMPLATE/bug_report.yml); Blizzard forum “get BugSack” advice for WA issues).

---

## 6. Author-side receiving norms (Beef maintainers)

1. Ask for **one** stack first; escalate to private SV only for migration/corrupt-DB bugs.
2. Never commit player SV or BugGrabber DBs into the research/code repo.
3. If a public issue includes a full roster or chat log, ask the reporter to edit/redact; do not quote the sensitive block in replies.
4. Treat streamer playtest errors like public: assume VOD/Discord scrape.

---

## 7. Boundary with track 19

| In 19 | In 65 (this note) |
|-------|-------------------|
| `/console scriptErrors 1` | Whether error *paste* may contain names |
| Install BugGrabber+BugSack | Share unit = one stack vs SV file |
| QA checklist inclusion | Redaction + channel matrix |
| Alpha distribution | N/A |

---

## 8. Implications for Church of Beef

- Playtest kit = BugSack (per 19) + **this paste template** (per 65).
- Document “copy one error, not !BugGrabber.lua” in future contributor README.
- Avoid Beef `error()` / `print()` strings that concatenate other players’ names ([names-and-identifiers.md](names-and-identifiers.md)).
