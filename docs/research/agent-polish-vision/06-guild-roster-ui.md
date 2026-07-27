# Guild roster / social ladder UI patterns (Classic-relevant)

**Series:** `docs/research/agent-polish-vision/`  
**Audience:** Agents polishing Ladder / My Standing / Officer tabs  
**Status:** Research synthesis — not a spec fork. Product law remains [design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md) §4 / §10 / §15 and machine canon [`Data/Ranks.lua`](../../../addon/ChurchOfBeef/Data/Ranks.lua).  
**Last updated:** 2026-07-26

---

## 1. Church of Beef framing

Beef is a **social title ladder**, not a guild-roster manager and not an EPGP ledger.

| Spec surface | Job |
|--------------|-----|
| **Ladder** | Show all seven titles + occupants; highlight local player |
| **My Standing** | Personal standing, next threshold (or appointed-only copy), recent grants |
| **Officer** (Officer+) | Pending suggestions, evidence, rites (adjust / demote / Council / Prophet) |

Machine canon (`COB.Ranks`):

| Rank | Title | Kind | UI implication |
|------|-------|------|----------------|
| 1–5 | Fresh Beef → Beef Butcher | `points` | Threshold-eligible; show standing context on Standing / Officer evidence |
| 6 | Beef Council | `council` | Seat-limited appointment (`CouncilSeats = 4`) — never point-reached |
| 7 | Beef Prophet | `prophet` | Unique when `ProphetUnique` — bestowed only |

Plan Task 8 already locks Ladder paint order: **rank id 7→1**, comma-separated occupants (or "—"), local highlight. List construction: seven fixed band rows, no HybridScroll in V1 ([track 57](../wow-classic-addon-design/57-scrollframe-list-rows/beef-ladder-officer-lists.md)).

---

## 2. Cousin patterns (what to steal)

### 2.1 Banded “directory” ladders (primary steal)

Closest Classic cousins to Beef’s Ladder:

| Cousin | Pattern | Steal for Beef | Avoid |
|--------|---------|----------------|-------|
| [Attune](https://addons.wago.io/addons/attune) guild summary | Members grouped by **progress step / readiness**, not a flat DKP sheet | Seven **rank bands**; scannable “who sits where” | Raid planner, auto-invite, website-as-authority |
| TRP3 / MRP directory | Scrollable people + identity under titles | Title → names under it; local self highlight | MSP prose spam, chat name recolor wars |
| Spec §10 + [steal/avoid map](../wow-classic-addon-design/13-cousin-addon-teardowns/steal-avoid-for-beef.md) | Ladder = Attune summary + TRP3 browse | Keep Ladder ≠ Standing ≠ Officer | Merging planner density into Ladder |

**Doctrine:** Ladder reads top→bottom as **institution hierarchy** (Prophet → Fresh Beef), not as a sortable spreadsheet of every guild member’s columns.

### 2.2 Flat standings tables (secondary steal — columns only)

Classic loot-point UIs teach sort/filter habits, not layout religion:

| Cousin | Pattern | Steal | Avoid |
|--------|---------|-------|-------|
| [EPGP standings](http://www.epgpweb.com/help/standingsandsorting) / [EPGP-Classic](https://github.com/jpxthu/EPGP-Classic) | Default sort by priority metric (`PR`); alternate sorts `NAME` / `EP` / `GP` | Header-click **sort within a flat list** *if* Beef ever adds a flat roster mode | Shipping EP/GP/PR columns; officer-note storage as ledger |
| [CEPGP](https://github.com/mullerdavid/wow_CEPGP) | Whisper `!info*` reports; officer-note gate for edits | Thin “what’s my standing?” elsewhere (Standing tab) | Whisper bot culture as primary UX |
| [RCLC Voting Frame](https://rclootcouncil.com/wiki/Voting-Frame) + CEPGP column modules | Select row → side detail; optional numeric column | Officer tab master–detail ([track 69](../wow-classic-addon-design/69-officer-tab-ia/)) | Vote tallies, ilvl Diff, session item rail |

### 2.3 True guild-roster tools (steal search / audit; not scope)

| Cousin | Pattern | Steal | Avoid |
|--------|---------|-------|-------|
| [Guild Search](https://github.com/Talryn/GuildSearch) | `/gsearch`; class-colored name; note / officer note / rank / last online; configurable search fields | **Name filter** when lists get long; class color on **names only** (already V1 brand rule) | Editing WoW guild rank / notes from Beef; XP/rank columns |
| [Guild Roster Manager (GRM)](https://www.curseforge.com/wow/addons/guild-roster-manager) | Mouseover → lockable detail; audit sorted by promotion lag; main/alt grouping; live change log | Officer **audit mental model** (who is overdue / who changed); compact history strip | Full roster CRM, ban lists, birthday columns, promote/demote macros — Beef does not manage WoW guild ranks |
| [Guild Kit](https://github.com/KetchGG/GuildKit) (Classic guild UI helper) | Sidebar pages greyed when permission missing; “Protected” / officer-rank config | **Hide or grey Officer tab** when not Officer+ (spec §11) | Replacing Blizzard guild frame; Auto Invite / Ban / Purge tools |
| Blizzard `SortGuildRoster` | Columns: name, rank, note, online, zone, level, class ([API docs](https://wowwiki-archive.fandom.com/wiki/API_SortGuildRoster)) | Online / name sort language players already know | Treating Beef titles as WoW guild ranks |

---

## 3. UX pattern catalog → Beef tabs

### 3.1 Sorting

| Pattern | Classic precedent | Beef V1 recommendation |
|---------|-------------------|------------------------|
| **Institutional order (bands)** | Attune step groups; TRP3 title browse | **Default Ladder:** fixed bands `7→1` from `COB.Ranks.List`; within band, sort names A→Z (matches `GetLadderView` “rankId desc then name”) |
| **Metric sort (flat)** | EPGP `PR` / `EP` / `GP` / `NAME` | **Not on Ladder V1.** Standing numbers belong on My Standing + Officer evidence, not as Ladder column headers |
| **Online-first** | Blizzard / Guild Search “Last Online” | Optional later chip (online/offline) — do not reorder bands by online |
| **Promotion-lag audit** | GRM audit sort by time since last promote | Officer **Recent Actions** + suggestion age — not a Ladder sort mode |
| **Header-click toggle** | EPGP / Blizzard roster | Only if a flat “Flock roster” view ships later; never fight the sacred 7-band order on the main Ladder |

**Anti-pattern:** sortable multi-column grid that visually competes with Details! / CEPGP standings. Spec + UI brief ban spreadsheet density.

### 3.2 Search / filter

| Pattern | Precedent | Beef V1 recommendation |
|---------|-----------|------------------------|
| **Substring name filter** | Guild Search, GRM | Ladder: **omit** while occupant strings fit truncated band rows. Add a single EditBox filter only if Fresh Beef overflows (tooltip / click-through first per track 57) |
| **Search notes / alts** | Guild Search officer notes | **Out of scope** — Beef does not own note fields; alts are separate characters (spec §9 / §16) |
| **Rank / class filter chips** | Guild Search optional fields | Standing/Officer: filter by suggested rank **later**; V1 Officer queue is short FIFO |
| **Find-as-you-type for rites** | Officer appoint/demote pickers | Officer Rites: name EditBox or dropdown over known ladder/roster names when appointing — not a full GRM search window |

### 3.3 Officer views (separate tab, not Ladder mode)

Keep the [track 69](../wow-classic-addon-design/69-officer-tab-ia/tab-zones.md) four-zone IA:

```text
A Pending queue  │  B Evidence (+ Approve / Reject)
C Rites (adjust / demote / Council / Prophet)
D Recent Actions (last N)
```

| Pattern | Precedent | Beef application |
|---------|-----------|------------------|
| Select → decide | Gargul RollOff, RCLC Voting Frame | One selected suggestion; evidence updates in place |
| Permission-gated chrome | Guild Kit greyed pages; GRM officer tools | Entire Officer tab hidden unless `LocalIsOfficer()` |
| Audit / history | GRM log + promotion history; RCL loot history | Compact Recent Actions only in V1 — no export UI |
| Nuclear confirms | Gargul Award | Demote / Council / Prophet / wipe — not every Approve |
| Evidence over trust | Spec §6.3 + §7.3 | Breakdown makes junk suggestions obvious |

**Do not** put Approve buttons on Ladder rows. Ladder is spectacle/browse; Officer is judgment.

### 3.4 Rank visualization

| Pattern | Recommendation |
|---------|----------------|
| **Seven band headers** | Title from `COB.Ranks.Title(id)`; kind chip optional (`points` / `council` / `prophet`) — dual-encode, not color-only |
| **Occupant string** | Class-colored names; comma-separated; truncate + tooltip if overflow |
| **Local highlight** | Stronger than peers (bright name / “you” marker) — stream-readable without WA pulses |
| **Empty band** | Em dash "—" (plan Task 8); for Council/Prophet empty seats, prefer explicit vacancy copy (below) |
| **No item-quality rainbow** | Titles are institutional, not loot tiers (UI brief anti-pattern) |
| **No standing StatusBar on Ladder** | Bars/thresholds live on My Standing (text-first; thin bar optional post-playtest) |

Suggested band chrome (copy-level, not art):

```text
Beef Prophet          1/1
  Beefina

Beef Council          2/4
  Alice, Bob
  — 2 seats open —

Beef Butcher
  Carol, Dave, …

Fresh Beef
  …
```

### 3.5 Seat limits (Council / Prophet)

Canon: `CouncilSeats = 4`, `ProphetUnique = true`.

| UX need | Pattern |
|---------|---------|
| **Capacity visible at a glance** | Header suffix `occupied/max` (`2/4`, `1/1`) — numbers from `COB.Ranks`, never hardcoded in UI strings docs |
| **Open seats as first-class empty** | Show remaining seat slots as muted "seat open" lines or a single vacancy line — officers scanning Ladder should see room before opening Rites |
| **Full seat = block appoint UX** | Officer Appoint Council disabled + plain reason when at cap; same for second Prophet when unique |
| **Not a grind meter** | Never show “points to Council”; Standing tab already switches to “Appointed ranks only” at Butcher+ |
| **Demote frees a seat** | After demote/commit, Ladder band count updates via dirty refresh — no special animation required in V1 |

### 3.6 Cross-tab consistency

| Concern | Ladder | My Standing | Officer |
|---------|--------|-------------|---------|
| Official title | Band membership | Hero title line | Evidence current → suggested |
| Standing number | Hidden (or tooltip later) | Primary number | Evidence breakdown |
| Seats | `n/max` on bands 6–7 | N/A (unless local is Council/Prophet) | Rites respect caps |
| Sort | Fixed 7→1 | N/A (history newest-first) | Queue FIFO / age |
| Search | None V1 | None | Name field on rites if needed |
| Authority actions | None | None | Approve / Reject / Rites |

---

## 4. Recommended V1 Ladder tab IA (polish target)

```text
┌─ Ladder ──────────────────────────────────────────────┐
│  [optional sync/status chip — owned by empty-state UX]│
├───────────────────────────────────────────────────────┤
│  Beef Prophet                         1/1             │
│    Name  ← highlight if you                           │
│  Beef Council                         2/4             │
│    Names… / seats open                                │
│  Beef Butcher                                         │
│    Names…                                             │
│  …                                                    │
│  Fresh Beef                                           │
│    Names… (truncate + tooltip)                        │
├───────────────────────────────────────────────────────┤
│  Footer: your title · optional “Open My Standing”     │
└───────────────────────────────────────────────────────┘
```

**Polish checklist**

1. Bands created once (7 rows); rebind on ladder revision dirty flag.  
2. Prophet/Council show seat fractions from canon.  
3. Left-guild / unguilded: empty-state ladder (spec §11), not fake occupants.  
4. Hidden left-guild records stay off the Ladder (spec §11).  
5. No sort headers, no search box, no online column in V1 unless playtest demands filter.

**V1.1 candidates** (only if guild size hurts scan): name filter; online chip; click name → Standing peek; flat “Flock” subview with FauxScroll (~10–12 rows).

---

## 5. Anti-patterns (reject in review)

| Temptation | Why it fails Beef |
|------------|-------------------|
| CEPGP/EPGP-style PR grid as the Ladder | Wrong metaphor; ladder is titles, not loot priority |
| GRM-scale roster CRM inside `/beef` | Scope explosion; WoW guild rank ≠ Beef rank |
| Officer Approve on Ladder rows | Fat-finger + mixes browse with judgment |
| Auto-promote when band looks “full of points” | Thresholds only create suggestions |
| Seat UI that invents `5` Council seats in copy | Canon only in `Data/Ranks.lua` |
| Retail Community frame assumptions | Anniversary / Classic roster APIs + Classic chrome |
| Details!-dense multi-column combat stats | Social addon performance + visual bans |

---

## 6. Sources (web + in-repo)

**Web**

- [Guild Search (GitHub)](https://github.com/Talryn/GuildSearch) — roster search fields, class-colored names, last online  
- [Guild Search (WowAce)](https://www.wowace.com/projects/guild-search) — same feature surface  
- [Guild Roster Manager (CurseForge)](https://www.curseforge.com/wow/addons/guild-roster-manager) — Classic/TBC flavors; audit; mouseover lock; promotion history  
- [GRM docs site](https://thegeneticsguy.github.io/Guild-Roster-Manager/) — audit sort by promotion lag; custom notes  
- [Attune (Wago)](https://addons.wago.io/addons/attune) — guild summary / “who’s on this step”  
- [EPGPWeb — Standings and Sorting](http://www.epgpweb.com/help/standingsandsorting) — default PR sort  
- [EPGP-Classic `StandingsSort`](https://github.com/jpxthu/EPGP-Classic/blob/master/epgp.lua) — `NAME` / `EP` / `GP` / `PR`  
- [CEPGP](https://github.com/mullerdavid/wow_CEPGP) — standings + officer-note authority  
- [RCLootCouncil Voting Frame](https://rclootcouncil.com/wiki/Voting-Frame) — select → detail  
- [SortGuildRoster API](https://wowwiki-archive.fandom.com/wiki/API_SortGuildRoster) — Classic column sort vocabulary  

**In-repo**

- Design spec §4 ladder / §10 UI / §15 locks  
- `addon/ChurchOfBeef/Data/Ranks.lua` — thresholds, seats, officer index  
- [13 steal/avoid](../wow-classic-addon-design/13-cousin-addon-teardowns/steal-avoid-for-beef.md)  
- [57 ladder list widgets](../wow-classic-addon-design/57-scrollframe-list-rows/beef-ladder-officer-lists.md)  
- [69 officer tab IA](../wow-classic-addon-design/69-officer-tab-ia/v1-ia-recommendation.md)  
- [70 My Standing](../wow-classic-addon-design/70-standing-breakdown-ui/beef-v1-recommendation.md)  
- [UI polish brief](../../superpowers/ui-polished-direction-for-agents.md)  

Raw search dumps (not product truth): `.firecrawl/guild-roster-ui-*.json`.

---

## 7. One-line doctrine

**Browse the flock as seven titled pews with seat counts on the clergy; sort and search only when the pew overflows; judge promotions on the Officer tab — never on the Ladder.**
