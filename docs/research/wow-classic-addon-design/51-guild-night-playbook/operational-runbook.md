# Operational runbook — first Beef guild night

**Track:** [51-guild-night-playbook](README.md)  
**Last updated:** 2026-07-25  
**Audience:** Night Lead + officers launching Church of Beef on one guild (one realm)

This is an *ops* checklist. It does not redefine BeefNet, scoring math, or calendar APIs. Use Discord (or the guild’s existing habit) to announce time/place — Track 39 owns calendar research.

---

## 0. Success definition (pin this in Discord)

The night succeeds if **all** of the following are true:

| # | Gate | Spec |
|---|------|------|
| A | Addon loads for participants; `/beef` shows Ladder + My Standing | §13.1–3 |
| B | At least one member earns standing from co-play **or** thin Gora/ceremony | §13.4–5 |
| C | At least one threshold crossing creates an officer-visible suggestion | §13.6 |
| D | Officer approves → rank updates for online addon users | §13.7 |
| E | **Social check:** guild chat shows the promotion line and someone reacts (emote, joke, “gz”) | §13.11 |
| F | Instrumentation sheet filled enough to decide whether §4.2 numbers stay or move | §16.6 |

Technical pass without E is a **soft fail** — ship fixes for spectacle before celebrating “V1 done.”

---

## 1. T−7 to T−2 days — prepare the cohort

| Step | Owner | Action |
|------|-------|--------|
| 1.1 | Night Lead | Pick **one** guild night that already has dungeon/BG/social density (do not invent a separate “addon meeting” unless necessary). |
| 1.2 | Night Lead | Announce in Discord: what Church of Beef is (comedy ladder, officer-approved ranks), install link/zip, `/beef`, “alters start Fresh,” “no auto-promote.” |
| 1.3 | Tech Spotter | Freeze a **Release-shaped** build for the night (or clearly labeled Discord zip). Officers+volunteers may have run Alpha earlier — see [alpha-channels.md](../19-testing-debugging-qa/alpha-channels.md). Live night = everyone on the **same** build. |
| 1.4 | Night Lead | Recruit facilitators ([facilitator-roles.md](facilitator-roles.md)). Minimum: Night Lead + Score Desk. |
| 1.5 | Score Desk | Print / open the measurement sheet ([instrumentation-and-thresholds.md](instrumentation-and-thresholds.md)). Agree which draft weights are shipping (`Data/Ranks.lua` + scoring constants). |
| 1.6 | Night Lead | Confirm **officer rank-index threshold** matches this guild’s roster layout (names are arbitrary — index matters). Spot-check with a non-officer that Officer tab is hidden. |
| 1.7 | Night Lead | Explicitly ask officers **not** to disable guild-chat announce for the first promotions unless chat is already on fire. |

**Do not:** schedule via new calendar addon research; **do not** require every member to install — spectacle must work for non-addon viewers via guild chat.

---

## 2. T−1 day / pre-invite — smoke (lab, not full night)

Borrow the minimum lab from [mock-guild-scenarios.md](../19-testing-debugging-qa/mock-guild-scenarios.md) Scenario A:

1. Officer + member on same guild, both with addon.
2. Force or earn a suggestion → approve → one guild-chat line.
3. Optional: log member out before approve → login sync (Scenario B) if time allows.
4. BugSack on both clients; note any errors.

If smoke fails, **slip the guild-night launch** — do not debug BeefNet in front of 20 people.

---

## 3. T−30 minutes — open the floor

| Step | Action |
|------|--------|
| 3.1 | Night Lead in voice/Discord: “Tonight we’re running Church of Beef — ranks are comedy prestige, officers approve, first Cooked Beef is the hook.” |
| 3.2 | Tech Spotter: `/reload` cohort if anyone installed mid-login; confirm `Church of Beef` in addon list on Anniversary client. |
| 3.3 | Score Desk: note start server time, online headcount with addon vs without, officer names on duty. |
| 3.4 | Spectacle Watcher: enable chat logging or stream VOD if available; watch for announce opt-out accidents. |
| 3.5 | Confirm BeefNet soft-warn: if anyone sees version mismatch, park them on the frozen build before commits. |

**Anniversary BeefNet hygiene** (from track 14 checklist — do not reinvent): register prefix, GUILD only, no custom channels, expect login sync to heal misses. Escalate desync to [27](../27-desync-conflict-resolution/) after the night, not mid-pull.

---

## 4. Live window — recommended activity mix

Goal: exercise **all three scoring sources** lightly without turning the evening into a spreadsheet.

| Block | Duration (guide) | What to do | Why |
|-------|------------------|------------|-----|
| Co-play | ~45–90 min | Normal guild dungeon / BG with ≥2 guildmates; combat required for drip | Primary path to Fresh → Cooked pacing rule |
| Ceremony | ~5–10 min | Officer Start → short bit in voice → Close | Medium flat grant; proves thin stub |
| Gora | ~10–15 min | 2–4 challenges; **record losses** | Loss participation must pay or culture dies |
| Officer desk | Continuous | Approve/reject promptly; one public promotion early | Feeds §13.11 before people log off |

**Anti-patterns during live window:**

- Farming entrance AFK “for science” (anti-AFK should zero it — note if it incorrectly pays).
- Officers racing concurrent commits on the same player (track 27 race class).
- Spamming `/beef` announcements or multiple officers all talking over the announce line.
- Changing threshold numbers mid-night — **measure first, retune after**.

---

## 5. Live window — observation cadence

Score Desk ticks every ~20–30 minutes (or after each dungeon/BG):

1. Sample 3–5 members’ My Standing (points, next threshold, recent events).
2. Count pending suggestions / approvals / rejects.
3. Note any “I got nothing” reports (instance detection, guildmate not in party, caps).
4. Note any BugSack pops (Tech Spotter owns the paste).

Spectacle Watcher marks the first promotion timestamp and whether chat reacted within ~60 seconds.

---

## 6. Close-out (same night, 15 minutes)

| Step | Owner | Action |
|------|-------|--------|
| 6.1 | Night Lead | Thank participants; remind alts are separate ladders; Council/Prophet are appointed, not grinded. |
| 6.2 | Score Desk | Freeze the instrumentation sheet; capture rough medians (see measurement note). |
| 6.3 | Spectacle Watcher | Confirm §13.11 pass/fail with chat evidence (screenshot/VOD timestamp). |
| 6.4 | Tech Spotter | Collect BugSack exports; note BeefNet mismatch or sync complaints. |
| 6.5 | Night Lead | Schedule **T+1 debrief** (30 min) before anyone retunes `Ranks.lua`. |

---

## 7. T+1 debrief — decisions only

Agenda (keep short):

1. Did pacing rule hold for at least one true newbie path?
2. Which draft threshold moves (and by how much) — [instrumentation-and-thresholds.md](instrumentation-and-thresholds.md) decision table?
3. Any scoring weight change vs threshold-only change?
4. Cap pain (hit daily cap too early / never)?
5. Process: facilitator roles keep / drop for night two?
6. Separate Doomhowl / Dreamscythe date if the other guild has not launched.

**Output:** a short decision note (Discord or `docs/` later) — e.g. “Cooked Beef 50 → 40; Knight unchanged; instance drip −20%.” No code in this track.

---

## 8. Abort / slip criteria

| Signal | Action |
|--------|--------|
| Smoke (T−1) fails sync or approve | Slip launch; keep Alpha cohort |
| Widespread Lua errors on load | Abort Beef for the night; play the game |
| Zero standing after a full co-play block for multiple members | Pause promotions; treat as scoring bug, not “grind harder” |
| Officers all offline | Do not promise ranks; suggestions can wait (open question §16.5) |
| Chat announce silent and nobody notices promotions | Fix opt-out / copy before calling social check a pass |

---

## Cross-links

- QA lab recipes: [mock-guild-scenarios.md](../19-testing-debugging-qa/mock-guild-scenarios.md)
- Distribution ladder: [alpha-channels.md](../19-testing-debugging-qa/alpha-channels.md)
- Guild-night BeefNet checklist: [classic-anniversary-realities.md](../14-addon-messaging-beefnet/classic-anniversary-realities.md)
- Product numbers: design spec §4.2 / §7 / §13
