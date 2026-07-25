# Facilitator roles — Beef guild night

**Track:** [51-guild-night-playbook](README.md)  
**Last updated:** 2026-07-25

Classic guild addons that survive raid night share a pattern: **a thin set of named human roles**, test-before-live, and one person who owns “is the public moment working?” RCLootCouncil’s “configure + test mode before raid,” CEPGP’s officer-note discipline, and loot-council size advice (small council, clear ML) are the analogues — not calendar RSVP bots.

Beef is comedy prestige, not loot. Roles below map to *promotion spectacle* and *threshold science*, not item awards.

---

## 1. Role roster (recommended)

| Role | Count | Must be Officer+? | Primary job |
|------|-------|-------------------|-------------|
| **Night Lead** | 1 | Yes (or GM) | Own the evening narrative; call activity blocks; final call on abort/slip |
| **Score Desk** | 1 | Preferably | Fill instrumentation sheet; sample My Standing; recommend retune at T+1 |
| **Spectacle Watcher** | 1 | No | Watch guild chat / stream for §13.11; catch announce opt-out |
| **Tech Spotter** | 0–1 | No | BugSack, install/version skew, “addon missing” triage |
| **Approving Officers** | 1–3 on duty | Yes | Process suggestion queue; keep human gate funny and fair |

**Hard cap:** avoid more than ~3 people with “officer desk” attention. Too many cooks delays approvals and kills comedy timing (same failure mode loot guides warn about with oversized councils).

One person may double-cover (e.g. Night Lead = Approving Officer; Score Desk = Tech Spotter on a small night).

---

## 2. Role cards

### Night Lead

**Before:** announce purpose, freeze build, recruit facilitators, confirm officer-index config.  
**During:** keep the activity mix moving (co-play → optional ceremony → Gora); protect the night from becoming a debug meeting.  
**After:** run T+1 debrief; record threshold decisions.

**Says out loud once:** ranks 1–5 are suggestion-eligible by standing; Council/Prophet are appointed/bestowed; alts start Fresh; officers can demote.

**Does not:** rewrite `Ranks.lua` mid-night; argue BeefNet theory in raid chat.

---

### Score Desk

**Before:** open blank sheet from [instrumentation-and-thresholds.md](instrumentation-and-thresholds.md); note shipping thresholds/weights.  
**During:** sample standing every block; track suggestions and source mix; flag AFK false-pays and completion misses.  
**After:** compute rough aggregates (`M_new_cooked`, `Y_median_new`, `Spectacle_ok`); bring decision-table recommendation.

**Tools:** `/beef` My Standing on consenting volunteers; notepad or Discord private paste; optional alpha logs if present.

**Does not:** approve ranks (unless also Approving Officer); shame players for low standing.

---

### Spectacle Watcher

**During:** when the first `RANK_COMMIT` announce hits guild chat, note timestamp and whether *anyone* reacts without being prompted.  
**Also watch:** duplicate announces, silence (opt-out), or announce so long it scrolls past unread.

**Pass:** unprompted reaction (gz, emote, bit).  
**Fail:** rank changes only visible inside `/beef` for addon users — fails spec §13.11 even if sync is perfect.

**Does not:** spam “react for the science” before the first natural moment (prompted reactions inflate the metric). After the first natural pass, coaching chat is fine.

---

### Tech Spotter

**Before:** BugSack + script errors on facilitator clients; same build id for all.  
**During:** triage load failures, version mismatch soft-warns, obvious Lua errors; park broken clients rather than hot-patching live.  
**After:** zip error exports; file themes (roster race, sync, UI) for engineering — point at tracks 14 / 19 / 27 as needed.

**Does not:** redesign protocol on voice; force `/reload` storms during boss pulls.

---

### Approving Officers (on duty)

**Job:** treat suggestions as testimony; approve when the story is funny/fair; reject when standing looks absurd or the moment is wrong.

**Hygiene:**

- Prefer **one** officer handling a given suggestion to avoid concurrent commits on the same player (track 27).
- Keep guild-chat announce **on** for the first nights.
- Manual standing adjust is for corrections, not silent power-leveling friends.
- Council seat / Prophet bestowal: only if leadership already decided — not a threshold playtest goal.

**UX analogue:** RCLootCouncil council votes + ML award — Beef collapses “vote” into officer judgment, but the *facilitation* lesson is the same: decide promptly, leave a history, don’t deadlock the night.

---

## 3. Member expectations (post in Discord)

Short copy you can paste:

> Church of Beef is running tonight. Install the zip we posted, type `/beef`. Your standing goes up when you play instances with guildmates (and from short ceremonies / Gora). Crossing a threshold only *suggests* a rank — officers approve. Alts are separate. If you don’t install, you’ll still see promotions in guild chat.

---

## 4. RACI (night operations)

| Activity | Night Lead | Score Desk | Spectacle | Tech | Approving Officers |
|----------|------------|------------|-----------|------|--------------------|
| Announce / slip call | **A/R** | C | I | C | C |
| Freeze build / install help | C | I | I | **R** | I |
| Instrumentation sheet | C | **A/R** | C | C | I |
| §13.11 social check | I | C | **A/R** | I | C |
| Approve promotions | C | I | I | I | **A/R** |
| Ceremony / Gora stubs | **R** | C | I | I | **R** (start/close / record) |
| Abort on errors | **A** | C | I | **R** | C |
| T+1 threshold decision | **A** | **R** | C | C | C |

R = responsible, A = accountable, C = consulted, I = informed.

---

## 5. Anti-patterns

| Anti-pattern | Failure mode |
|--------------|--------------|
| Everyone is “helping” with `/beef` | Queue thrash, no Score Desk data |
| Officers disable announce “to reduce spam” | Silent promotions → social check fail |
| Score Desk chases perfect census | Misses the night; median of 4 tagged chars is enough |
| Tech debugs BeefNet mid-dungeon | Mood death; slip instead |
| Threshold edits live | Invalidates the measurement sheet |
| Treating Council as “next grind rank” | Spec violation; confuses the flock |

---

## 6. Mapping to cousin addon culture

| Cousin practice | Beef facilitator translate |
|-----------------|----------------------------|
| RCLC test mode before raid | T−1 smoke with officer + member |
| Small loot council (≈3–5) | 1–3 Approving Officers on duty |
| ML owns award click | One officer owns a given `RANK_COMMIT` |
| EPGP / CEPGP officer notes as shared truth | Officer commits + revisions are shared truth (no note-field dependency in V1) |
| GuildHelper / multi-client sync expectations | Two-client smoke; login sync for offline |
| “Publish loot rules before raid” | Discord paste of member expectations (§3) |

Calendar/RSVP platforms (Guilds of WoW, Group Calendar, Discord event bots) may *schedule* the night — they are not facilitator roles for Beef and are out of scope here.
