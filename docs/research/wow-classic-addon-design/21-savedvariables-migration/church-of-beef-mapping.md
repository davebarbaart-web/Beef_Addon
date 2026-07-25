# Church of Beef — persistence mapping

**Track:** [21 README](README.md)  
**Spec:** [`2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §6.3, §8–§9, §11, §15–§16

---

## 1. Locked V1 choices (do not re-litigate here)

| Topic | Decision |
|-------|----------|
| Global | `ChurchOfBeefDB` |
| TOC | `SavedVariablesPerCharacter` |
| Ladder storage | Cache of officer commits + revisions |
| Anti-cheat | Officer approval; SV editable by users |
| Alts | Separate characters; no account merge in V1 |
| Realms | Dreamscythe Alliance and Doomhowl Horde = independent churches |

---

## 2. Data → persistence matrix

| Data | Spec home | SV class | Wipe-safe? | Notes |
|------|-----------|----------|------------|-------|
| Official rank + standing snapshot | §8.1 `RANK_COMMIT`, §8.3 | A | Yes via sync | Core product cache |
| Per-record revision / timestamps / officer tie-break | §8.3 | A | Yes | Ordering for merge |
| Pending suggestions | §7.3, §16 #5 | B | Partial | Online officers may miss queue |
| Local standing points | §6.3, §7 | C | No | Advisory testimony |
| Event log (My Standing) | §9, §10 | C | No | Cap length; lossy OK |
| Anti-farm / daily cap clocks | §7.2 | C | No | Losing clocks can *benefit* cheaters briefly — officer still gates ranks |
| Frame position / minimap / toast prefs | §9, §10 | D | No | Defaults fine |
| Announce opt-out | §10 | D | No | Per-officer |
| BeefNet throttle / in-flight queues | §8.2 | E | N/A | Memory only |
| Canon thresholds | `Data/Ranks.lua` | — | N/A | Not SV; ship in addon |

---

## 3. Recommended nesting (conceptual only)

Keep one PerCharacter global; nest by class so future resets and exports have clear boundaries:

- `ChurchOfBeefDB.schema`
- `ChurchOfBeefDB.meta` — realm, character, guild stamp, lastSyncAt
- `ChurchOfBeefDB.ladder` — class A
- `ChurchOfBeefDB.suggestions` — class B
- `ChurchOfBeefDB.standing` — class C
- `ChurchOfBeefDB.ui` — class D

Migrations and “Reset UI” act on subtrees, not the whole file blindly.

---

## 4. Relevance to open questions (§16)

| Open question | Persistence implication |
|---------------|-------------------------|
| Alt linking | Would need Account SV **or** officer-side mapping table; do not flip existing TOC without dual-global migration |
| Council seats / Prophet uniqueness | Seat config can live in canon data; occupancy is class A commits |
| Standing decay / Lent reset | Season marker should be a class A revisioned field (or wipe commits intentionally), not “delete everyone’s WTF” |
| Suggestion queue sharing | Extending sync to class B makes officer UX wipe-safer; increases sync payload (budget in track 14) |
| Threshold tuning | Canon file changes ≠ SV migration; old local suggestions may reference old thresholds — clear or recompute on canon version bump |

---

## 5. Interaction with AceDB / BeefNet (boundaries)

- **AceDB (track 03):** optional later wrapper for `ui` profiles. Do not place `ladder` under `db.profile`. If Ace namespaces are used, prefer `char` for church data to match PerCharacter TOC — or keep church data outside Ace.
- **BeefNet (track 14):** owns prefix, CTL, anti-storm, payload size. This track only requires: after wipe, client must emit `SYNC_REQUEST` once settled; must not emit authoritative empty dumps; must apply higher revisions into `ladder`.

---

## 6. Installer / streamer one-liners

- “Deleting WTF does not excommunicate you from the Church — log in and sync.”
- “Your alt is a catechumen; copy-pasting Main’s lua is not doctrine (and may be wrong).”
- “Officers: keep a second officer online and a dated WTF backup of your main — you are the warm cache.”
