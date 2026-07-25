# Officer Queues, Voting Frames & Ledgers

**Last updated:** 2026-07-25  
**Focus:** The “fair judgment” UX that loot councils and DKP systems trained Classic officers to expect — and how it maps to Church of Beef’s officer tab.

---

## 1. Why this matters for Beef

V1’s social centerpiece is not loot; it is **rank**. But the **interaction pattern** officers already know is loot council / DKP:

1. Something scarce is contested (item / promotion).
2. Candidates or systems produce **claims**.
3. Trusted humans **vote or approve**.
4. The outcome is **logged** and preferably **announced**.

Church of Beef’s design stance (“standings are advisory testimony; officer approval is the real anti-cheat”) is the comedy-church restatement of how RCLootCouncil already thinks about trust: tools facilitate judgment; they do not replace it ([RCLC wiki](https://github.com/evil-morfar/RCLootCouncil2/wiki)).

---

## 2. RCLootCouncil role split (steal the IA)

From the [RCLootCouncil2 wiki](https://github.com/evil-morfar/RCLootCouncil2/wiki):

| Role | Primary UI | Job |
|------|------------|-----|
| Candidate / raider | Loot Frame | Express need/response quickly |
| Council member | Voting Frame | See candidate context; cast vote |
| Master Looter / lead | Session Frame + options | Start sessions, configure buttons/council, award |
| Observer (optional) | Voting Frame (read) | Transparency without power |

**Odd-number councils** are recommended to avoid ties; one-person councils are supported but change the culture.

### Steal for Beef Officer tab

| RCLC concept | Beef analogue |
|--------------|---------------|
| Candidate response | `SUGGESTION` (self-reported eligibility) |
| Voting Frame rows | Pending suggestions: player, current → suggested rank, point breakdown, recent events |
| Award | `RANK_COMMIT` from Officer+ |
| Observe mode | Non-officers see ladder + toasts, not the queue |
| History / export | Revisioned official records; later: scripture/history tab |
| Usage popup (“use RCLC this instance?”) | Ceremony/Gora must be **officer-initiated** — never silent background promotion |

### Do not steal

- Gear comparison / ilvl greed detection (wrong domain).
- Auto-pass armor rules.
- Requirement that every raider install for full features (RCLC wants broad install; Beef must degrade like Attune/Gargul for non-users).

---

## 3. Gargul contrast (speed vs deliberation)

[Gargul](https://addons.wago.io/addons/gargul) optimizes master-loot **throughput** (SoftRes import, rolls, trade timers, packmule). Community comparison pieces position RCLC as drama-resistant deliberation and Gargul as casual/SR speed ([Medium 2026 comparison](https://medium.com/@rengo_wow_world_of_warcraft/rclootcouncil-vs-gargul-which-wow-loot-addon-should-you-use-f99ac760e944)).

**Beef is deliberation-shaped.** Rank theater should feel like a council chamber, not an auctioneer. Speed matters only for toast + guild-chat announcement latency after approve.

---

## 4. Ledger patterns (DKP / EPGP / bank)

| System | Ledger contents | Trust model |
|--------|-----------------|-------------|
| WebDKP | Attendance + DKP awards/bids | Officers run the table; often web-mirrored ([webdkp.com](https://webdkp.com/addon)) |
| EPGP | EP earn / GP spend → priority | Formulaic; decay/tiers keep economy healthy ([wiki](https://wowwiki-archive.fandom.com/wiki/EPGP)) |
| Guild Bank Ledger | Who withdrew what | Multi-player sync of transactions ([CurseForge](https://www.curseforge.com/wow/addons/guild-bank-ledger)) |
| GRM | Who joined/left/promoted | Rank-gated sync among addon users ([Wago](https://addons.wago.io/addons/guild-roster-manager)) |

### Design lessons for BeefNet

1. **Immutable-enough history beats perfect anti-cheat.** RCLC/WebDKP win drama by logs, not cryptography — aligned with Beef’s officer-as-anti-cheat stance.
2. **Revision numbers** (already in V1) are the modern form of “last award wins” for offline peers.
3. **Officer copies are freshest** — same social reality as ML-held RCLC sessions.
4. **Publish summaries, not firehoses.** `/gkp`-style dumps and Beef’s single guild-chat line are the same discipline.

---

## 5. Pending-queue UX checklist (officer)

Drawn from RCLC Voting Frame practice + Beef V1 officer requirements:

- [ ] One clear **pending list** (not buried in chat)
- [ ] Each row: **who**, **from → to**, **why** (breakdown), **when**
- [ ] Primary actions: **Approve** / **Reject** (and demote / appoint / bestow as first-class)
- [ ] Manual correct standing (officers fix testimony)
- [ ] No action if local player fails Officer+ rank-index check
- [ ] After approve: local apply → BeefNet commit → **one** throttled guild announcement
- [ ] Reject clears suggestion without silently wiping points (unless officer corrects)
- [ ] Empty states: not in guild / no pending / roster not loaded

---

## 6. Scarcity & seats (council pattern beyond loot)

RCLC’s “named council members” and Beef’s **Beef Council (seat-limited)** / **Beef Prophet (unique)** solve the same cultural problem: if everything is grindable, status collapses.

UX implication: appointed seats need a **different officer flow** than threshold suggestions — pick from roster, confirm seat slot, announce with different vernacular (“anointed” / “seated”) so the flock hears the difference.
