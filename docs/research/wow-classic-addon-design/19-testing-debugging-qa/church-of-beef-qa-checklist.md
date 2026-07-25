# Recommended QA Checklist — Church of Beef V1

**Last updated:** 2026-07-25  
**Track:** [19-testing-debugging-qa](README.md)  
**Sources:** Design spec §11, §13, §13.1 + this track’s research notes

Use on **TBC Classic Anniversary** only. Check boxes in order when possible; mark N/A for deferred V2+ surfaces.

---

## 0. Lab setup

- [ ] Anniversary client install; AddOns path confirmed (not Era/Retail)
- [ ] `/console scriptErrors 1` on author + tester accounts ([script-errors-bugsack.md](script-errors-bugsack.md))
- [ ] BugGrabber + BugSack installed; sack empty at start
- [ ] Two characters in same guild: **Officer+** and **Member** ([mock-guild-scenarios.md](mock-guild-scenarios.md))
- [ ] Optional third character **without** addon for announce visibility
- [ ] Note Interface: `/dump (select(4, GetBuildInfo()))` — expect **20506** or live equivalent ([multi-flavor-toc-testing.md](multi-flavor-toc-testing.md))
- [ ] Church of Beef enabled; appears in AddOns list with correct title

---

## 1. Load / smoke

- [ ] Fresh `/reload` — no BugSack errors from Church of Beef
- [ ] `/beef` opens a **real frame** (not chat-only) — success §13.2
- [ ] Minimap button toggles same frame
- [ ] Frame movable, clamped; position persists across reload (SV)
- [ ] Missing-media smoke: rename/remove optional textures if any — falls back, still loads (§10 / §13.1)

---

## 2. Ladder & standing UI

- [ ] All seven ranks display (Fresh Beef → Beef Prophet)
- [ ] Local player highlight + title correct
- [ ] My Standing shows points, next threshold, recent events
- [ ] Officer tab **hidden** on member; **visible** on Officer+
- [ ] Not-in-guild character: empty-state ladder; scoring paused (§11)

---

## 3. Scoring sources

- [ ] Shared instance with guildmate + combat in bucket → standing increases
- [ ] AFK at entrance with guildmate → **no** instance drip
- [ ] Daily cap eventually stops drip (spot-check)
- [ ] Thin Gora: win / loss / draw all grant; **loss pays**
- [ ] Ceremony start/close grants attendee credit
- [ ] Disconnect mid-ceremony → no credit until clean close or manual grant

---

## 4. Suggestions & officer gate

- [ ] Crossing threshold creates **pending suggestion** (no auto-promote)
- [ ] Officer sees player, ranks, breakdown, recent events
- [ ] Approve → official rank updates locally
- [ ] Reject → suggestion clears; points remain
- [ ] Manual standing adjust / demote / Council appoint / Prophet bestow (smoke each)
- [ ] Non-officer cannot apply forged `RANK_COMMIT` (§13.9)

---

## 5. BeefNet & sync

- [ ] Both online: officer approve → member ladder updates (§13.1 / §13.7)
- [ ] Member offline during promote → correct ladder after login sync (§13.8)
- [ ] Duplicate/replay commit ignored (revision ≤ local)
- [ ] Roster-not-loaded: commit queued or dropped, never unverified apply
- [ ] Major version skew: soft warn; incompatible discarded
- [ ] No soft-lock for players without addon

---

## 6. Social / stream criteria

- [ ] One throttled guild-chat announce on promote/demote from **approving officer only**
- [ ] Member without addon sees the chat line
- [ ] Officer opt-out honored (if implemented)
- [ ] **§13.11:** during a real guild night, ≥1 promotion gets a visible social reaction

---

## 7. Combat lockdown

- [ ] In combat: `/beef` open, tabs, minimap toggle — no Beef-attributed BugSack errors ([combat-lockdown-testing.md](combat-lockdown-testing.md))
- [ ] Optional: officer approve during combat — defined behavior (apply or queue), no taint storm
- [ ] Instance anti-AFK still detects combat while UI open

---

## 8. Persistence & alts

- [ ] Per-character SV: alt starts Fresh Beef / zero standing
- [ ] Official ladder cache + revisions survive `/reload`
- [ ] Left-guild: record hidden; restore on rejoin (if testable)

---

## 9. Packaging / channels (when distributing)

- [ ] Alpha build reaches officer WowUp/CurseForge Alpha subscribers ([alpha-channels.md](alpha-channels.md))
- [ ] Release build does not include alpha-only debug spam
- [ ] Flavor tags match Anniversary / Classic TBC
- [ ] TOC Interface matches live `GetBuildInfo()`

---

## 10. Hard restrictions (regression)

- [ ] No Retail-only APIs on Anniversary
- [ ] No combat automation / protected-action circumvention
- [ ] Deferred V2 chrome absent or clearly stubbed

---

## Sign-off

| Field | Value |
|-------|--------|
| Build / version | |
| Interface (`GetBuildInfo`) | |
| Date | |
| Testers (officer / member) | |
| BugSack residual (Beef) | none / filed # |
| §13.11 social check | pass / fail / deferred |

**Related notes:** [mock-guild-scenarios.md](mock-guild-scenarios.md) · [script-errors-bugsack.md](script-errors-bugsack.md) · [combat-lockdown-testing.md](combat-lockdown-testing.md)
