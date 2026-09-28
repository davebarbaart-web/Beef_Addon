# Church of Beef Add-On
## Game Design Bible v1.1

**Status:** Canonical Product & Game Design Source of Truth
**Purpose:** Macro-level design direction for implementation
**Design Lead:** Claude (Fable), succeeding ChatGPT collaboration with David Barba
**Implementation:** Cursor and associated development agents
**Version:** 1.1.1
**Supersedes:** Game Design Bible v1.0 (and v1.1)

### What Changed in v1.1.1

Two rulings from David following the demo-build audit: **Beef Butcher is confirmed canon** — a real Church rank reserved for the Raiding Team (§5), previously misidentified in the audit as an agent invention; and the **visual law is hybrid** (§19.3) — functional surfaces stay stock-template pragmatic, theatrical surfaces get the full ecclesiastical identity. "Beef Prophet" is removed as a rank; the Beef Pope is not a rung on anyone's ladder.

### What Changed in v1.1

v1.1 preserves the entire vision of v1.0 and adds the specificity production needs. The philosophy is unchanged; the gaps the independent peer review identified are closed. New in this version: the target platform and its constraints (§3); the Rules of the Gora and the promotion norm (§10.3–10.4); the Fight HUD and Records Book (§10.8–10.9); the ceremony runtime model (§20); the Pope-authoritative data architecture, message trust rules, and the Sacred Archive (§13); the Decree (§14.1); the flag-hot/canonize-cold Chronicle flow (§16); the privacy contract (§17); sound direction, the Quiet Mode contract, and near-invisible onboarding (§19); a revised MVP with a performance-based definition of done and a dress-rehearsal release gate (§22); and two new scope filters (§24). A companion document, the *Peer Review Adjudication*, records which review recommendations were accepted, modified, deferred, or rejected, and why.

Two rulings from David reshaped recommendations: **Beef Lord is an attainable milestone**, not an elite title — prestige scarcity moves upward into the Records Book and honorifics; and **Gora rules are pure Pope discretion** — the software codifies the discretion, not a rulebook.

---

# 1. Executive Vision

The Church of Beef add-on is a social gameplay layer for World of Warcraft Classic designed to transform ordinary WoW gameplay into memorable community stories, rituals, competitions, and shared history.

Its purpose is **not to create another game inside World of Warcraft**. Its purpose is to make the things players are already doing in World of Warcraft feel like they happened **inside the Church of Beef**.

A duel becomes a **Beef Gora**. A guild promotion becomes a **Knighting of the Beef**. A funny admission becomes a **Beef Confession**. A dungeon becomes a **Church Expedition**. A raid becomes part of the Church's collective history. A highly engaged player organically becomes a recognizable leader.

The add-on strengthens belonging, recognition, cooperation, emergent gameplay, competition, roleplay, community memory, and live-stream spectacle — while remaining subordinate to World of Warcraft itself.

> **The add-on should make World of Warcraft more Church of Beef. It should never replace World of Warcraft with an artificial Church of Beef game.**

The add-on succeeds when the software becomes nearly invisible infrastructure beneath an unforgettable human community. It fails if players begin interacting primarily with the add-on instead of with each other and the game world.

---

# 2. Product Fantasy

For an ordinary player, the fantasy is:

> *I randomly joined this ridiculous guild, but somehow it became my World of Warcraft community.*

Over time, that player may be randomly recruited as Fresh Beef; join the wider community and become Cooked Beef; attend their first Gathering; bend the knee before the Beef Pope; become a Beef Knight; run dungeons with other Church members; develop professions useful to the guild; raid; fight in sanctioned Beef Goras; earn Beef Lord; build rivalries and a combat record; become known for helping other members; potentially rise to the Beef Council; and accumulate a persistent history within the Church.

The add-on lets that player's relationship with the guild become increasingly visible and meaningful without demanding they grind an artificial progression system.

---

# 3. Target Platform & Constraints *(new in v1.1)*

## 3.1 Primary Target

**The Church's current home is the Anniversary realms, presently in The Burning Crusade.** All MVP design and API assumptions target the Anniversary TBC client.

Practical consequences the design may rely on (each listed in Appendix A for implementation validation):

- **Guild banks exist**, with client-queryable transaction logs. Tithe recognition is therefore *possible* — it remains non-MVP and governed by §17's prohibitions.
- **Profession/tradeskill links exist**, enabling opt-in self-reported profession capability in later phases.
- **Level cap 70; flying mounts exist in Outland.** Ceremony staging should assume grounded processions by convention; the Gathering playbook (not software) handles this.
- **Arenas exist.** Beef Gora deliberately ignores them: a Gora is a duel in the world, in front of the congregation. The arena is Blizzard's theater; the Gora is ours.
- Addon communication, guild roster APIs, raid markers, duel system messages, and SavedVariables behave per the modern Classic-family client (validation list in Appendix A).

## 3.2 The Classic+ Horizon

The long-term ambition is the rumored **"Classic+"**, unannounced at time of writing. Because it is speculative, it imposes exactly one obligation now:

> **Portability principle: no system may depend on APIs or game features beyond a conservative Classic-family baseline unless the feature gracefully degrades.**

Concretely: the data model never assumes a specific level cap; platform-dependent features (guild bank, profession links, flying) are isolated behind capability checks; and the event/runtime/identity cores must be portable to any Classic-family client unchanged. On any official Classic+ announcement, Appendix A is re-validated before further platform-dependent work. Anniversary realms will also *progress* (TBC → Wrath, presumably) — the same principle covers that drift.

## 3.3 Hardcore

Hardcore realms are not the Church's home but host recurring Church **tournaments**. Hardcore-specific design (notably memorialization of the Fallen, §12.6) is scoped to tournament events and re-promoted to core if the platform picture changes.

---

# 4. Core Design Principles

## 4.1 WoW Comes First

World of Warcraft supplies combat, exploration, dungeons, raids, professions, loot, PvP, character progression, and social spaces. The Church add-on supplies **context, identity, ceremony, recognition, spectacle, and institutional memory.** When the base game already provides a satisfying mechanic, the add-on frames it rather than recreates it.

## 4.2 Formalize the Tradition, Not the Joke

The Church's strongest traditions were improvised by players, not designed as software. The add-on must not over-systematize the comedy.

The software formalizes: queues, records, sanctions, ceremony state, administrative information, presentation.
Humans continue generating: comedy, improvisation, roleplay, commentary, physical staging, social unpredictability.

The software can organize a Confession queue; it does not write David's response. It can sanction and present a Beef Gora; it does not replace the color commentary. It can organize Knighting participants; it does not replace walking forward, kneeling, and pledging.

**Standing automation red lines** *(new in v1.1)*: fight cards are mute (the Pope is the voice); adjudication proposes, never declares; no ceremony scripting engines; no auto-generated Chronicle prose; no queue auto-advance — the software knows who is next, the Pope calls them. The stage manager whispers "the mage is next, your Holiness." It does not grab the mic. **The software never narrates. Anything with a verb happens in the Pope's voice.**

## 4.3 The Pope Is the Performer; the Add-On Is the Stage Manager

The Beef Pope is the cultural center of the Church. The add-on's job is to increase the Pope's bandwidth as a performer, removing clerical burdens so attention stays on comedy, commentary, Twitch chat, guild chat, roleplay, crowd control, storytelling, and community interaction.

## 4.4 If the Software Knows, David Should Not Have to Enter It

> **If the software already knows the answer, David should never have to enter it. If David must make a judgment, that judgment should usually require one clear action.**

The system knows class, level, rank, records, and who still needs Knighting — it surfaces them. David decides legitimacy, completion, and history — via **SANCTION BEEF GORA**, **KNIGHT THIS BEEF**, **DECLARE VICTOR**, **MARK THIS MOMENT**, **CANONIZE**.

## 4.5 Player Expression Happens in WoW

When players can express themselves through their characters — formations, RP walking, kneeling, dancing, yelling, disrobing, fountain-jumping, physically forming the Gora circle — the add-on supports those moments rather than pulling players into menus.

## 4.6 Recognition Over Grind

No Beef XP, daily quests, weekly chores, arbitrary currencies, engagement streaks, or unlock trees. Progression emerges from **things that actually happened within the community.**

## 4.7 Cooperation Through Visibility

The ordinary-day experience encourages members to play WoW together through recognition, visibility, social identity, shared history, member discovery, and useful guild information — not artificial reward loops.

## 4.8 Quiet Mode and Event Mode *(new in v1.1)*

The add-on has exactly two presentation states, and every feature must declare which it lives in.

**Quiet Mode** (normal WoW): at most a hideable minimap presence. The Nights board (§14.1) is player-opened (the `/beef` week strip and the Nights parchment), not an always-on overlay. The one licensed unbidden cue is a faint minimap glow when the board changed since the player last opened the card — not a pip for “a night exists,” not a toast, not a reminder. No feeds, no dashboards, no toasts, no sound. This is contractual, not aspirational — it is the strongest standing defense against scope creep, because most creep arrives as "just a small always-visible panel."

**Event Mode** (ceremonies and Goras): theatrical presentation — proclamations, fight HUD, favor, outcomes, sound. Entered and exited only through the ceremony runtime (§20).

Rhythm: **Quiet → Ritual Begins → Spectacle → Consequence → Quiet.**

## 4.9 Record Events, Not Behavior *(new in v1.1)*

The Church remembers *events* (a completed dungeon, a sanctioned Gora, a Knighting). It never measures *behavior* (hours online, damage output, gold farmed, generalized activity). No contribution scores. No activity leaderboards. Ever.

## 4.10 Witnesses Report; They Never Rule *(new in v1.1)*

Human ceremonial authority is canonical. Witnessed gameplay is reporting. Authorized humans correct errors. **The database does not outrank the Beef Pope** — and in the MVP architecture (§13), the database effectively *is* the Pope.

## 4.11 The Floor Is a Tuesday *(new in v1.1)*

Ceremony cadence is weekly-ish with mixed sizes: most events are modest, with occasional 30–40+ stream spectaculars. The tooling must therefore scale **down** before it scales up: a six-person impromptu Knighting must be *cheaper with the add-on than without it* — zero setup, no event configuration, the Pope simply begins. If the add-on ever makes a small ceremony feel not-worth-doing, it has damaged the Church. The spectacular is the ceiling; the Tuesday is the floor; the floor is where weekly retention lives.

---

# 5. Social Structure of the Church

The hierarchy is not a linear RPG ladder. Different ranks represent different kinds of relationship with the community.

## Fresh Beef — Recruitment

Newly recruited, largely (85–90% historically) through rapid random guild invitations. Intentionally low-commitment. Inactive Fresh Beef may be removed in Beef Purges. **Existing recruitment and mass-removal add-ons handle these functions; the Church add-on does not duplicate them.**

## Cooked Beef — Engagement

Basic demonstrated commitment — historically joining the Church Discord and posting their character in the promotions thread. Protected from routine Purges. This is the first voluntary step into the wider community, and it is also **where the add-on install funnel begins** (§21.2).

The Fresh → Cooked transition happens outside the add-on (Discord), and the add-on does not observe it: a Council member promotes, and the add-on reflects the change. This is deliberate; the add-on does not own Discord.

## Beef Knight — Belonging

Formal initiation: attended a ceremony, approached the Pope, bent the knee, pledged loyalty, was Knighted. Primarily a **badge of belonging**, never an achievement grind. May carry guild privileges (invitation rights, bank access). The threshold where full Church identity features become expected.

> **Beef Knight says: "I belong here."**

**The non-competitive majority** *(new in v1.1)*: most Knights will never fight a Gora, and the design owes them a journey. The answer is deliberately non-mechanical: their witnessed history (§13–14) makes quiet contribution visible; recognition of it remains human (§15); honorifics give it permanence. No service scores, no achievement tracks — visibility plus human recognition is the design.

## Beef Lord — Proven Prestige

Earned through sanctioned Beef Gora combat. Prestige and public proof, not service or authority.

**Canonical ruling (v1.1): Beef Lord is an attainable milestone.** It means *proven fighter*, not *top fighter*. A Knight who seriously competes should expect to earn it. Promotion norm in §10.4.

Lords receive bragging rights, stand with the Pope during ceremonies, and occupy a visibly elevated cultural place. Because Lord is attainable, staging assumes *many* Lords: they form an honor formation — **the Lords' Line** — rather than a privileged pair of flankers.

Beef Lord remains the endpoint of routine competitive advancement. No ladder of increasingly absurd permanent ranks above it. After Lord, competition produces records, rivalries, defenses, streaks, tournament accolades, and reputation — and the scarce prestige currencies become **Records Book superlatives and Pope-granted honorifics** (§10.9, §15). A Lord does not lose the title by losing fights.

> **Beef Lord says: "I proved something here."**

## Beef Butcher — The Raiding Team *(confirmed canon in v1.1.1)*

Beef Butcher is a **role designation reserved for members of the Church's Raiding Team**. Like Council, it is human-granted — joining the raid team, as judged by leadership — never a points threshold or a competitive step. It sits alongside Lord and Council as its own kind of relationship with the Church: not prestige from combat, not governance, but *committed service in the raid*.

Butcher is deliberately low-priority in the product: it exists in the rank data model and displays correctly on profiles and rosters, and that is all the MVP owes it. It carries no thresholds, no progression mechanics, and no special add-on features unless raid-team traditions organically demand them later (§14.3's Campaign tracking is the natural future home).

> **Beef Butcher says: "I raid for the Church."**

## Beef Council — Trusted Leadership

Fundamentally different from Lord. Council represents loyalty, consistency, trust, member support, presence, contribution, leadership, and usually strong Discord participation. **Always a human judgment, never a score.**

Council members may recruit, moderate, remove problem players, manage logistics and the guild bank, organize groups, and lead raids. They do **not** inherit ceremonial sovereignty.

*Council exit (new in v1.1):* people go inactive or step back; the Council must be prunable by the same human judgment that appoints it. Communities that never remove officers accumulate ghost governments. Process is human; the principle is written here so it is nobody's surprise.

## Guild Rank ↔ Church Rank *(new in v1.1)*

Blizzard guild rank (10 slots) is the **public display**; the Church store is the **truth**. KNIGHT THIS BEEF performs both the Church record and the guild-rank promotion where the API permits. When they drift (an officer promotes someone in the Blizzard UI), the console reconciles silently where the mapping is unambiguous and asks the Pope one clear question where it is not.

---

# 6. The Beef Pope

The Beef Pope is the cultural anchor: primary entertainer, face of the Church, cultural authority, tone-setter, recruiter, roleplay leader, comedic dictator, community moderator, ceremony administrator. Humor may be absurd and authoritarian; actual moderation remains serious — racism and similar behavior is dealt with decisively.

## Ceremonial Sovereignty

Pope-controlled, not normally delegable: Knighting of the Beef, sanctioning Beef Goras, major Church rituals, formal elevation, major proclamations.

> **Culturally centralized around the Pope, operationally supported by the Council.**

## The Pope Is a Busy Streamer *(new in v1.1)*

The console's real operating environment: voice on the mic, eyes bouncing between game, Twitch chat, and Discord, one hand available. Every console screen is tested against this: glanceable at streaming distance, large click targets, one-click sacred actions with optional keybinds, movable and collapsible so it never covers the ceremony it directs.

## Pope Absence *(new in v1.1)*

No Pope, no rituals — that is a deliberate property of a personality-centered institution, and the Church owns it. Council can run *activities* (dungeons, raids, informal fights) but not *rituals*. The data layer tolerates the Pope being offline for weeks (nothing decays, nothing breaks; clients simply stay quiet). The real succession plan is the Sacred Archive (§13.5): the Church's history survives any single machine, and any single human, intact.

## Sustainability *(new in v1.1)*

The add-on amplifies one human's performance; it must never raise the cost of an ordinary night. Production values are optional per event — §4.11's floor requirement is also a protection for David: the tooling makes a low-energy ceremony *easier*, and never makes smallness feel like failure.

---

# 7. The Gathering

The primary ceremonial event format, larger than any individual ceremony. The historical arc:

1. **Assembly** — 20–40+ members at an inn or recognizable location (Goldshire, Stormwind, Thunder Bluff…).
2. **Controlled Chaos** — the Pope enters character; music, dancing, spammed praise of Beef; deliberate chaos.
3. **Sudden Order** — the Pope abruptly commands disciplined formation (two lines; ranks positioned; the Lords' Line beside the Pope). The chaos/authority contrast is central to the comedy.
4. **Procession** — RP walk through the city to the ritual location.
5. **Knighting** — newcomers initiated.
6. **Movement to the Arena.**
7. **Beef Gora** — the competitive climax.

This human staging is the product. The software's contributions are the Decree beforehand (§14.1), one **SUMMON THE FAITHFUL** broadcast during assembly (a ping with the gathering point to installed clients — one button, nothing more), the runtime state that synchronizes everyone's theater (§20), and the console that lets the Pope run the whole arc without opening Blizzard's roster.

Not every Gathering is the full arc. A Tuesday Knighting of one nervous newcomer in front of six members is a complete, legitimate ceremony and must cost the Pope nothing to run (§4.11).

*Venue note (playbook, not software):* public spaces mean outsider chaos — randoms dancing on the ritual, contesting the fountain, chasing the stream camera. This is content; the Pope narrating a heckler beats any mitigation feature. Locations with natural enclosure make big ceremonies easier to stage; the Gathering playbook may say so. The software does nothing about it — the fight HUD already keeps the *stream* legible when the scene isn't.

---

# 8. Knighting of the Beef

The ritual stays simple and human: newcomers line up; the Pope calls one forward; the candidate RP walks, kneels, pledges loyalty or says something appropriately Beef; the Pope judges the ritual complete; the candidate becomes a Beef Knight; the congregation reacts.

## Add-On Role

Remove the administrative friction around the human ritual. The Pope sees at a glance: who is present, current rank, who still needs Knighting, who has completed it, who is next. The interaction approaches **KNIGHT THIS BEEF** — one action that performs everything the API legally permits (Church record, guild-rank promotion, proclamation to installed clients, record entry) and stages the next candidate.

*New in v1.1 — the physical half of the bottleneck:* finding one level-14 gnome in a 40-body scrum is stage management too. Clicking a queue entry targets the candidate where the API allows; when the congregation is raid-grouped, the add-on auto-places a raid marker on the current candidate (and later, on Gora fighters). Diegetic, Classic-native, cheap.

*Latecomers:* every real ceremony has someone arriving during the third Knighting. The queue accepts insertions without reordering pain, and a late-joining client receives current ceremony state automatically (§20).

The Pope never searches the default guild roster during an active ceremony. That sentence is an acceptance test.

---

# 9. Beef Confession

Intentionally lightweight. Traditional flow: congregation gathers at a fountain; confessors queue; the Pope calls one forward; the player types their confession; the character strips and jumps in the fountain; the Pope improvises a response. **The improvisation is the entertainment.**

The add-on may assist with the queue, calling the next participant, capturing confession text **privately to the Pope's console** (free-typed player text never auto-renders in public theater — §13.4), and remembering notable confessions when flagged.

The add-on does not systematize penance, sin categories, dialogue, rewards, or confession progression — unless those traditions first emerge naturally in play. Holding this line is the standing test case for §4.2.

---

# 10. Beef Gora

## 10.1 Role in the Product

Beef Gora is the MVP centerpiece and the primary repeatable competitive system. It receives the greatest early design, UX, polish, and testing investment. A successful Gora is fun to fight, fun to spectate, easy to administer, legible to Twitch, dramatic without overwhelming WoW, and persistent enough to create rivalries and legacy.

The core loop:

**Petition → Assisted Matchmaking → Pope Sanction → Fighter Presentation → Congregation Favor → Normal WoW Duel → Pope Adjudication → Record → Possible Elevation**

The actual combat is an unmodified WoW duel, fought in the world, inside a circle the congregation physically forms. The software recommends; the Pope decides. **Sanction** is a formal Church game verb: a match becomes a Beef Gora only when the Pope sanctions it.

## 10.2 Petition

Players step forward seeking sanctioned combat; the console pools petitioners with player, character, class, level, rank, record, and head-to-head context.

*Petition hygiene (new in v1.1):* petitions expire (freshness window, default ~the current event); the pool shows only petitioners who are **present and alive**; the Pope dismisses petitions consequence-free with one tap; a dismissed petitioner gets a soft re-petition cooldown so affectionate trolling stays affectionate. Petition volume is performance material, not a backlog.

*Challenges (new in v1.1):* a petition may **name a desired opponent**. The callout is the oldest dueling tradition there is; it manufactures rivalries and hands the Pope material ("Tendermage has DEMANDED Chuckroast"). The named party is notified only via the Pope — the callout becomes official when the Pope announces it, not when the software does.

## 10.3 The Rules of the Gora *(new in v1.1)*

**Canonical ruling: there is no standing rulebook. The ruleset is the Pope.**

The Church has never had fixed loadout norms, and v1.1 codifies the discretion rather than inventing standards. Defaults that reflect actual practice:

- **Loadout:** come as you are. No standing bans on consumables, pre-buffs, or engineering. Cheese is content.
- **Stipulations:** the Pope may attach conditions at sanction time — spoken as a ruling, optionally recorded in one line on the fight card ("STIPULATION: no potions; combatants shall be nude"). Stipulations are performance material; the software's only job is remembering what was decreed. There is no stipulations database, picker, or rules engine.
- **Level gap:** ~2 levels is the historical guidance the matchmaker uses; the Pope may waive it theatrically. A deliberate mismatch, sanctioned with ceremony, is entertainment.
- **Fight boundary:** to the duel's natural end, not first blood.
- **Fleeing:** the duel-flee system message triggers the ruling **COWARDICE RECORDED** — a first-class outcome with its own sound and seal, funnier and more canonical than "forfeit."
- **Interference / weirdness:** defaults to **VOID** — one tap, immediate, no shame. A fast Void beats thirty confused seconds on stream; the Pope can always re-rule later (§13.3).
- **Disconnect:** Pope's ruling; the console suggests Void with a rematch encouraged.
- **Rematches:** at the Pope's pleasure. Head-to-head history (§10.7) makes every rematch a story.

## 10.4 Promotion and the Lord Milestone *(new in v1.1)*

**Norm:** a Beef Knight who **wins a sanctioned Gora in a match the Pope judges fair** has earned elevation. Elevation itself is always performed by the Pope — normally at the same event, as its own ceremony beat with its own sound. "Fair" is entirely the Pope's judgment; the console simply shows him what he needs (levels, classes, records) to make it in one glance.

Lord is deliberately attainable (§5). The scarcity lives above the title: defenses, streaks, Records Book superlatives, and honorifics. A Lord's later fights matter because the software surfaces what is at stake narratively — head-to-head history at sanction, defense counts on the card, and whatever stakes the Pope invents ("the winner takes the title Duke of the Fountain"). Named, transferable, purely cosmetic honorifics are pure Church culture and cost nothing. There is no demotion, no decay, no mandatory defense.

## 10.5 Matchmaking Assistance

The system identifies sensible matches — level proximity, freshness, head-to-head history, challenge requests — and shows class matchup plainly without editorializing about odds. The Pope's game knowledge is the judgment layer. **The software recommends; the Pope decides. There is no ELO, no MMR, no hidden rating, ever.** Numerically "fair" matchmaking would cost us underdogs, grudge matches, and the comedy mismatches the Pope sanctions on purpose.

## 10.6 Sanction, Presentation, and Favor

**Sanction.** SANCTION BEEF GORA is one action. On every installed client it lands with weight: the sanction proclamation and the sanction bell (§19.4). Once sanctioned, the result is recognized by the Church.

**Fighter presentation.** Installed clients receive the tale of the tape: name, class/portrait, level, Church title, Gora record, defenses, relevant accolades — and the head-to-head line when the fighters have history ("they have met twice; one apiece; this is the rubber match"). **The card is mute.** It shows; the Pope tells. No generated flavor text, no auto-announced introductions — automating the introductions automates the color commentary, which is forbidden (§4.2).

**Congregation favor.** Spectators pick one fighter. That is the entire mechanic — sides, investment, underdogs, commentary material, stream readability. The favor split renders as a simple bar. It is always visible to the Pope; display to the congregation defaults on but is a per-event Pope toggle, because *revealing the crowd's favor is itself performance material* ("the congregation stands... SIXTY-FORTY AGAINST YOU"). No favor streaks, no accuracy records, no economy, no wagering — the moment favor has a score, spectators optimize instead of cheering.

## 10.7 The Fight HUD *(new in v1.1)*

The single most important spectator feature. During a sanctioned Gora, every Event Mode client renders a compact HUD: both fighters — name, class color, level, Church title, record, defense count — with live health bars, the head-to-head line, and the favor split beneath. Top-center by default, movable, appears at sanction, persists through the verdict beat, exits with the consequence.

This is what converts forty bodies of visual mud into a legible sporting event for the congregation and for a first-time Twitch viewer. It renders only in Event Mode, only during a sanctioned fight.

*Feasibility:* live health for non-group units is Appendix A's top validation item. Defined fallback: the HUD renders everything except live health (cards, records, favor) — still transformative for legibility. Raid-marking the fighters (§8) helps the crowd find them in the scrum either way.

## 10.8 Adjudication and Outcomes

Duel results surface as system messages visible to nearby players; the software **proposes** the outcome and the Pope **ratifies** with one action — DECLARE VICTOR, COWARDICE RECORDED, VOID, or a free ruling. Automation drafts; the human rules; the record shows the Pope's ruling, not the parser's guess. Elevation, when earned (§10.4), follows as its own beat.

## 10.9 Records and the Records Book

**Records are stories, not analytics.** Character-level: wins/losses, streaks, defenses, head-to-heads, notable victims, rulings received (a COWARDICE on your record is a story you carry). No damage meters, no duration stats, no per-class win rates — the moment records become analytics, fighters optimize and the comedy dies.

Character records belong to the character; the player profile aggregates (§12). A famous 0–9 fighter is a folk hero, and the presentation must let a bad record read as *legend*, not *stat* — narrative framing ("The Glorious Martyr of Goldshire, nine times fallen, nine times risen") is a presentation requirement, not a flourish.

**The Records Book** replaces any ranked leaderboard — superlatives, not rankings; parchment pages, not sortable tables. MVP categories (subject to David's veto and community sanity-check):

- **Most Sanctioned Victories**
- **Longest Streak**
- **Most Successful Defenses**
- **The Iron Chin** — most Goras fought
- **Greatest Rivalry** — the most-fought pairing, with its running score
- **Famous Upsets** — Pope-flagged
- **The Undefeated** — active unbeaten records
- **The Glorious Martyr** — most losses, presented with love
- **Tournament Champions** — as they occur

A sorted "#1 rating" ladder is permanently rejected: same data, opposite social incentive.

## 10.10 Long-Term Replayability

Four renewable resources: new challengers (the recruitment pipeline), rivalries (head-to-head surfacing plus the Pope's voice), stakes the Pope invents (stipulations, honorifics), and tournaments (§11). What would kill it: seasons, resets, decay, or anything that expires old records. **The Church's product is permanence.**

---

# 11. Major Tournaments

A future extension of Beef Gora, not MVP. Historically successful formats: Hardcore, Solo Self-Found, low-level caps (5/10), brackets, permadeath stakes, limited preparation. Their strength: **low barrier + understandable rules + meaningful preparation + high stakes.** Tournaments award special accolades (Tournament Champion, Hardcore Champion, Undefeated) — never permanent linear ranks — and their distinctions enter Church history. Hand-run tournaments work today; software brackets wait until the core is proven.

---

# 12. Player Identity and Linked Characters

## 12.1 The Hybrid Model (canonical)

**The human player owns:** Church rank, Council status, major accolades and honorifics, membership history, aggregate identity.
**The character owns:** name, class, level, profession information, its Beef Gora record, its gameplay history.
**The profile aggregates:** *Steve — Beef Lord — Career Gora 7–5 (Chuckroast, Warrior, 6–2; Tendermage, Mage, 1–3).*

Social standing is a relationship between a person and the community; combat records are stories about specific characters. Both are true at once.

## 12.2 Linking: the Rite of Recognition *(new in v1.1)*

WoW cannot prove alt ownership; humans confirm it. There is **no self-service linking**. A linking claim is confirmed by the Pope or Council interacting with the logged-in character — and the confirmation is *ritualized*: a thirty-second Rite of Recognition in which the alt kneels and is formally bound to the player's Church identity. An administrative task becomes content; the thesis applied to our own back office.

## 12.3 Permanence

**Church history is never deleted.** Members who leave and return find their record intact; rank restoration is a human call. Character records survive the character (deletion, death, abandonment).

## 12.4 Edge Cases the Design Anticipates *(new in v1.1)*

- **Name reuse:** freed character names can be re-created by anyone; internal character identity is more than a name string, and human-confirmed linking is the guard.
- **Impersonation:** someone claims a famous player's alt — answered by 12.2; no self-service, human confirmation only.
- **Shared accounts / two humans:** technically unsolvable; socially handled. Church identity is one human; disputes are resolved by the Pope. No machinery is built for this.
- **Transfers/faction changes:** per platform capability (Appendix A); treated as a re-link confirmation, not a new identity.

## 12.5 Aggregation

The player profile aggregates character Gora records, participation, and accolades. Aggregate views stay simple in MVP (§22).

## 12.6 The Fallen *(deferred; scoped)*

For Hardcore tournament events, character death is permanent and records become memorials — a dead HC tournament character with a 6–2 record is a legend deserving a page (character, record, cause of death, canonized moments). Deferred while the Church's home is Anniversary TBC; the permanence rule (12.3) means nothing is lost by waiting; re-promoted to core if Classic+ or a platform shift makes death mechanics central.

---

# 13. Data Architecture, Trust, and the Beef Network

## 13.1 MVP Architecture: the Pope-Authoritative Star *(new in v1.1 — canonical)*

WoW add-ons have no server: persistence is per-client SavedVariables; communication is rate-limited addon messages. The MVP therefore uses the simplest architecture that matches the Church's actual authority structure:

- **The Pope's client is the single writer and source of truth.** Ranks, records, ceremony state, the Chronicle — all canonical data lives in, and is modified only by, the Pope's store.
- **Congregation clients are display terminals plus input devices.** They render broadcast state (proclamations, fight cards, HUD, outcomes) and send inputs (petitions, favor, confession text) *to the Pope's console* — inputs never trigger public theater directly.
- **State broadcasts one-way** over the guild addon channel with sequence numbers; clients reconcile to the latest state.

This is an order of magnitude less engineering than any distributed model, and it *is* §4.10 expressed as architecture. Conflict resolution in MVP: there are no conflicts, because there is one writer.

## 13.2 The Witness Model (long-term)

Distributed witnessing remains a required long-term capability: installed clients observe qualifying nearby guild activity (dungeon groups, raids, raid leadership, ceremonies, Goras, profession milestones) where the API allows, and as adoption grows the Church's memory of what its members did together grows with it.

> **The Beef Network is the Church's sensory system. The Chronicle is its memory.**

The architectural rule that carries from MVP into the full vision: **witnesses observe and report to the authoritative store; witnesses never rule.** Later phases add reporters and corroboration hints ("reported by 4 clients") on the console — never competing authoritative databases, never consensus protocols. Witnessing requires physical presence (combat-log range) — which is thematically perfect: *the Church saw it because the Church was there.*

Worth-observing test (two parts, both required): the event is **objective** (clear signal, hard to dispute) and **socially legible** (a member hearing of it understands why it mattered). Passes: dungeon completions with Church majority, raid boss kills, Gora outcomes, ceremony participation, raid leadership. Fails: gold looted, deaths, playtime, damage. When in doubt, do not observe — under-observation is a missing scrapbook line; over-observation is a culture problem.

## 13.3 Authority Hierarchy

1. **Direct ceremonial decisions by the Pope** — canonical (sanctions, verdicts, Knightings, elevations, canonizations).
2. **Witnessed gameplay** — reported; accepted into the store by the authoritative client.
3. **Administrative correction** — authorized humans (Pope; designated Council for non-ceremonial records) correct erroneous records at any time. The Network exists to support the Church.

## 13.4 Message Trust *(new in v1.1)*

- Theatrical UI (proclamations, sanctions, verdicts, Knightings, HUD state) renders **only** from messages whose server-provided sender is a registered Pope character (validation item; the sender primitive is non-spoofable).
- Congregation-originated messages are console inputs only.
- **Player-typed free text renders only on the Pope's console.** The Pope chooses what to perform; official theater renders only Pope-originated content. This closes both the spoofing hole and the content-on-stream hole with one rule.
- Every message carries a protocol version; clients on stale versions degrade to Quiet Mode with a gentle "the Church's software has advanced" notice rather than misrendering theater (§21.3).

## 13.5 The Sacred Archive *(new in v1.1)*

The Church's history cannot depend on one SavedVariables file. Requirements:

- **One-action export** from the Pope console (file/string), restorable by import.
- **The weekly Archive ritual:** the console reminds the Pope (cold state, never mid-ceremony) to export and post to Discord. Framed in-fiction: the Sacred Archive.
- **Cold mirror:** a designated Council member's client holds a read-only copy, refreshed periodically. Still one writer; the mirror is disaster recovery, not a second authority.

## 13.6 Graceful Degradation

Church gameplay never fails because someone lacks the add-on. Non-users fully participate in Knighting, Gatherings, Goras, dungeons, and raids; installed users get the richer experience and contribute observation. The ceremony must always be performable entirely in the world, add-on or no.

---

# 14. Everyday Church Gameplay

Outside ceremonies, the add-on helps answer: **what is the Church doing together?** — without chores, currencies, or FOMO.

## 14.1 The Nights board *(was the Decree; David 2026-09-14)*

The Quiet Mode feature beyond mere presence. The Pope posts **Church nights** (Gathering, Knighting night, Gora night) as a weekly series he can skip or move for a given week. Designated Council (workspace list, same pattern as registered Popes) may post **Discord stubs** (Raid, PvP) — title, when/where, and the cue “Sign up on Discord” — including when the Pope is offline. Congregation may tap **Going** on a Church occurrence: everyone sees a count; names stay on the Pope desk. Going is informational, not attendance, not a score, not a rank gate.

The board is a **notice**. It does not start ASSEMBLY. The Pope still starts the Gathering from the Director Console.

**Quiet surfaces:** no login parchment. `/beef` shows the next seven local days; a click-through Nights parchment shows twenty-eight. Minimap left-click opens the card; right-click opens the parchment. A faint glow means the board changed since the player last opened the card; it stops when they view it.

**Hard boundary:** no Discord API or URLs; no role signup; no reminders or toasts; no auto-start; no attendance ledger; no Blizzard calendar sync. Raid and PvP nights are Discord stubs on this board, not in-addon RSVP. The Cooked Beef → Knight funnel still runs through attending a ceremony; the board is how the next nights are posted.

## 14.2 The Honest MVP Answer for a Random Tuesday

A Beef Knight logging in on an ordinary evening sees: **almost nothing** — a hideable minimap, glowing only if the Nights board changed since they last opened `/beef`. Their profile, records, and the week of posted nights are player-opened; the add-on is otherwise silent. This is deliberate. Everyday *features* beyond identity, history, and the posted nights are a later phase. We state this honestly so nobody "fixes" the quiet with a feed.

## 14.3 Later-Phase Everyday Systems

**Church Expeditions (dungeons):** a qualifying Expedition at ~3-of-5 Church members; witnessed completion (final-boss-kill heuristic — Appendix A), recorded simply: dungeon, date, participants, milestone status.
**Church Campaigns (raids):** *Church Raid* (majority/supermajority of members) vs. *Church-Led Raid* (member leading, outsiders welcome) — different contributions, never collapsed into one statistic.
**Professions:** recognition ("meaningful capability in service of the guild") and utility ("who in the Church can make this?"). Self-reported by installed clients via profession links (Appendix A); opt-in; never rewards crafting volume.
**Guild Bank / Tithe:** possible on TBC (real guild banks with logs — Appendix A). Later phase. Governed by §17: recognition of tithes is human and occasional — a canonized Great Tithe beats a donations table. No contribution scores.

---

# 15. Recognition Philosophy

The Church recognizes many forms of contribution: winning Goras, organizing dungeons, raiding and raid-leading, helping low-level members, developing professions, supporting the bank, consistent presence, building Discord culture, becoming socially trusted. **Different contributions stay distinguishable** — a feared Beef Lord and a beloved raid organizer are valuable for different reasons, and no single number may ever collapse them.

**Honorifics** *(new in v1.1)*: Pope-granted, named, purely cosmetic titles — "Duke of the Fountain," "Defender of the Faith," "Martyr of Goldshire" — recorded on profiles, transferable when the Pope decrees stakes (§10.4). With Lord attainable, honorifics and Records Book entries are the Church's scarce prestige currency. They start as pure text; they must never acquire mechanical benefits.

Recognition of quiet contribution (the non-competitive majority, §5) works the same way: witnessed history makes it visible; the Pope and Council recognize it humanly; honorifics make it permanent.

---

# 16. The Chronicle

> **The Beef Network sees. The Chronicle remembers.**

Two layers, never merged:

**Activity History** — routine witnessed events (dungeon runs, raids, participation, profession progress). Automatic, boring, browsable.

**The Chronicle** — significant Church history: momentous Knightings, elevations, major Gora outcomes, tournament championships, first clears, exceptional milestones, memorable incidents. Selective and sacred.

## Flag Hot / Canonize Cold *(new in v1.1 — canonical)*

During live performance: **MARK THIS MOMENT** — one keystroke, Pope (Council may eventually flag/nominate). Nothing else happens live.
Later, in the cold state: the Pope reviews flags and **CANONIZES** — writing the entry in his own words, however brief. The software supplies the *seal*, never the *scripture*.

## Scarcity Norm

The Chronicle grows by a handful of entries per Gathering at most. Every entry passes through a human hand. Council may nominate; **only the Pope canonizes.** Scarcity is what makes canonization an honor worth roleplaying; every "auto-include X" request moves the Chronicle one step toward the activity feed it must never become.

## The Chronicle Feeds Back *(later phase; data model supports now)*

History that is never re-encountered is a database. Later surfaces: canonization as a ceremony beat (seal and sound, on stream); "on this day in Church history" on the Decree banner; head-to-head and rivalry callbacks at sanction; memorable-location callbacks; the Fallen (§12.6). Timestamps and locations are recorded from MVP onward so these stay cheap.

---

# 17. Public and Private Information

**Generally public:** Church rank, Gora records, accolades and honorifics, ceremony participation, dungeon/raid participation, profession capabilities (self-reported), significant contributions, Chronicle history.

**Private:** moderation notes, behavioral concerns, disciplinary context, sensitive officer commentary, the Pope's Notebook (§18.3). Access controls reflect this.

**The privacy contract** *(new in v1.1)*:

- **Record events, not behavior** (§4.9). Publicly measured hours-online, activity scores, damage, gold, or any generalized contribution number: prohibited.
- **No activity leaderboards. Ever.**
- **Members see their own record** — everything witnessed about them is visible to them.
- **The Curtain:** any member may opt out of *displayed* witnessed activity. In-fiction: *the Church sees all, but the humble may draw the curtain.* Exception: rank, Knighting, and sanctioned Gora results are public ritual by nature and are not curtainable — you cannot be publicly Knighted in front of forty people and privately un-Knighted in the database.
- Free-typed player text (confessions, petition notes) is never auto-published (§13.4).

---

# 18. Performer-First Administration

## 18.1 The Beef Pope Director Console

A live-production tool organized around the questions the Pope is actually asking, in order:

- Who is here, and what rank are they?
- Who needs Knighting? Who is next?
- Who is petitioning for Gora — present and alive? Which matches make sense? Do these two have history?
- What action needs my decision *right now*?
- What just happened? What happens next?

It minimizes typing, roster searching, scrolling, window switching, memory burden, and duplicate entry. It is built for a busy streamer (§6): glanceable, large targets, one-click sacred actions, keybinds, movable, collapsible. It requires zero setup to start a small ceremony (§4.11).

Core desks in MVP: **Presence** (who's here, ranks, needs-Knighting flags), **Knighting queue** (with targeting/marker assist and latecomer insertion), **Gora desk** (petitions with hygiene, suggested pairings with head-to-head context, SANCTION with optional stipulation line, verdict buttons), **MARK THIS MOMENT**, and the **Notebook**.

## 18.2 What the Console Never Does

It never advances the queue itself, never announces in the Pope's place, never auto-declares outcomes, never renders a player's free text to the public, and never demands data entry for things the software can know (§4.4).

## 18.3 The Pope's Notebook *(new in v1.1)*

Private free-text notes attachable to any member, one keystroke from any console context. "Promised him a Gora next week." "Shy — call gently." Externalizes the promise-tracking that currently taxes David between weekly events. Private absolutely (§17).

## 18.4 The Post-Show *(stretch-MVP)*

One click copies a ceremony summary to the clipboard — *Knighted: 4 (names). Goras: 3 (results). Marked moments: 2.* — for Discord posting. Removes the last recurring chore of a ceremony night. Deeper Discord integration stays out (§22).

## 18.5 Congregation Interface

The congregation receives **theater, not administration**: proclamations, fighter cards, the HUD, favor selection, ceremony prompts, outcomes, rank recognition. Simple enough to need no manual.

---

# 19. UI / UX Philosophy

## 19.1 The Quiet Mode Contract

In Quiet Mode the add-on renders **at most a hideable minimap.** The Nights board is player-opened. The one licensed unbidden cue is the unseen-change glow (§14.1). No bars, feeds, toasts, reminders, or sound. Every feature proposal must declare its mode (§24, filter 8); "just a small always-visible panel" is how products die.

## 19.2 Event Mode

Temporarily theatrical during Church moments, entered and exited only via the runtime (§20): proclamations, cards, HUD, favor, outcomes, sound. Rhythm: **Quiet → Ritual Begins → Spectacle → Consequence → Quiet.**

## 19.3 Visual Direction

Dark iron, charcoal, aged parchment, muted gold; gothic/ecclesiastical typography; Warcraft-compatible ornamentation; official seals and proclamations. An ancient institution treating completely ridiculous Beef matters with absolute seriousness. **The comedy comes from the contrast between institutional dignity and complete stupidity — therefore the UI itself never tells jokes.** No meme clutter. The institution is funny because it appears not to know it is funny.

**The hybrid visual law** *(ruled in v1.1.1)*: functional surfaces — the Director Console's desks, lists, settings — stay stock-Blizzard-template pragmatic; **theatrical surfaces — proclamations, fighter cards, seals, verdicts, the Records Book, the Nights parchment — receive the full ecclesiastical identity, and this is non-negotiable.** The visual contrast between the plain working tool and the absurdly dignified theater is itself part of the §19.3 comedy engine. Custom media is therefore permitted and expected, but only where the theater lives.

## 19.4 Sound *(new in v1.1)*

Sparse, ceremonial, meaningful — sound so rare that its presence *is* information. The MVP set: the **Sanction bell**, the **Verdict**, **Elevation**, **Knighting**, and (later) the **Canonization seal**. Cowardice Recorded deserves its own cue. Quiet Mode is silent, absolutely. No ambient audio, no UI clicks-and-whooshes, no notification sounds. When the bell rings, the whole guild knows something is happening — that is the feature.

## 19.5 Onboarding *(new in v1.1)*

Near-invisible. First launch: one parchment welcome, then silence until the Church does something. No configuration walls, no tutorial popups, no minimap-icon fanfare. An experienced WoW player discovers the main functions unaided; a new member's first real encounter with the add-on should be a ceremony, not a settings screen.

---

# 20. Ceremony Runtime Model *(new in v1.1)*

The skeleton every Event Mode surface hangs from.

## 20.1 States

**QUIET** → **ASSEMBLY** (an event is live; Decree/summon context; congregation gathering) → **RITE** (an active ceremony segment, typed: Knighting, Gora, Confession, Proclamation — a Gathering chains several RITEs) → **CONSEQUENCE** (verdict/elevation/reaction beat) → back to ASSEMBLY (next rite) or **QUIET** (event ends).

## 20.2 Ownership

**The Pope's client owns every transition.** Starting an event, opening a rite, closing it, ending the event — all are Pope console actions (one click each; starting a small ceremony is a single action with zero configuration, per §4.11). Broadcast state carries the event id, state, rite type, active subjects (candidate, fighters), and a sequence number.

## 20.3 Joining, Reloading, Recovering

- **Late join / UI reload:** the client requests current state from the Pope's client (whisper channel) and receives a snapshot — it lands in the right theater within seconds, mid-rite.
- **Pope disconnect:** clients hold last state briefly, then degrade gracefully to a quiet-leaning "awaiting the Pope" presentation. No client promotes itself. On reconnect, the Pope's console resumes exactly where the state machine stood — the event object persists in his SavedVariables.
- **Version mismatch:** protocol-versioned messages; stale clients drop to Quiet Mode with a gentle update notice rather than misrender theater (§13.4).
- **Congregation client crash mid-favor/petition:** inputs are re-sendable; the console deduplicates by character.

## 20.4 The Chaos Test

The runtime is designed for the dress rehearsal's deliberate failures (§22.3): late arrival, reload, disconnect, no-show petitioner, disputed outcome. The product must survive real human chaos *on stream* — a confused client is acceptable for five seconds and embarrassing for thirty.

---

# 21. Adoption, Distribution, and the Install Funnel

## 21.1 Adoption Expectations

**Fresh Beef:** optional. **Cooked Beef:** strongly encouraged. **Beef Knight and above:** expected for the full experience. Real reasons to install: ceremony theater, Gora participation and the HUD, profiles and history, the Decree, recognition — and the bells: when a Gora is sanctioned somewhere in the world, installed clients hear it. The Church still functions socially when some players haven't installed (§13.6).

## 21.2 The Install Funnel *(new in v1.1)*

A randomly-invited stranger has never heard of the add-on, and telling them is nobody's job unless we make it one. The funnel is owned at **Cooked Beef onboarding**: the Discord promotion flow includes the install link and one sentence of why (see the ceremonies properly; fight in the Gora; be remembered). Knights hear it again at Knighting ("your deeds will be recorded — if the Church can see you"). No in-game nagging of non-users, ever.

## 21.3 Distribution and Versioning

Publish through a manager (recommendation: dual-publish CurseForge + Wago) from the first public build — "download this zip" loses half of casual installers. Every addon message carries a protocol version; old clients degrade to Quiet Mode (§20.3). Update cadence must respect ceremony nights: no breaking protocol changes released on a Gathering day.

---

# 22. MVP Definition

The MVP proves the thesis and its quality — not the full long-term design.

## 22.1 MVP Components

1. **Exceptional Beef Gora** — petitions with hygiene and challenges, matchmaking assistance, sanction with stipulations, mute fighter cards with head-to-head, favor with split display, adjudication verbs (Victor / Cowardice / Void / free ruling), elevation, character records + player aggregation.
2. **Live Fight HUD** — §10.7, with the defined no-live-health fallback.
3. **Beef Pope Director Console** — §18: presence, Knighting queue with targeting/marker assist, Gora desk, MARK THIS MOMENT, Notebook. Zero-setup small ceremonies.
4. **Knighting administration** — the great Knighting workflow; no generic ceremony engine.
5. **Ceremony runtime** — §20 in full, including late join, reload, Pope-disconnect recovery, and version degradation.
6. **Pope-authoritative synchronization** — §13.1 star topology; sender/authority validation (§13.4).
7. **Basic Church identity** — player + linked characters (human-confirmed via the Rite of Recognition), rank, records, plain profile. Aggregate views stay simple.
8. **Records Book** — §10.9 categories; no ranked ladder.
9. **The Nights board** — §14.1, hard-bounded (Church series + Discord stubs + informational Going; no reminders, no attendance ledger, no Discord API).
10. **Sound cues** — the §19.4 MVP set.
11. **Manual overrides on every automated step** — standing requirement.
12. **The Sacred Archive** — export, import, weekly ritual reminder, cold mirror.
13. **Polish** — animation discipline, typography, hierarchy, feedback, transitions, responsiveness, coherence. The target already feels credible on a Twitch stream.

*Stretch-MVP (may slip one release, should not):* the post-show clipboard summary (§18.4); SUMMON THE FAITHFUL (§7).

## 22.2 Explicitly Not MVP

Full Witness Network and multi-witness corroboration; profession ecosystem; dungeon/raid tracking (Expeditions/Campaigns); guild-bank/tithe recognition; tournament builder; deep Chronicle tooling and consumption surfaces; generic ceremony builder (blacklisted until two bespoke ceremony workflows exist to generalize from); extensive accolade tooling (honorifics ship as plain profile text); Discord integration beyond the clipboard summary; Twitch integration (rejected outright); the Fallen (deferred, §12.6); Blood Feud declarations; cross-guild challenges (approved as a zero-software manual experiment); massive progression trees; artificial economies; ELO/MMR; fight analytics; AI-generated commentary.

## 22.3 Definition of Done *(canonical)*

> **The MVP is done when the Church runs one complete, real Gathering — assembly under a Decree, several Knightings, several sanctioned Beef Goras with fight HUD and favor — live on stream, with records persisting afterward and visible the next morning, with a first-time Twitch viewer able to understand the spectacle, and with David never opening Blizzard's guild roster and never touching an external spreadsheet during the performance.**

**Release gate:** before public release, at least one deliberately imperfect **dress rehearsal** (guild-only, unstreamed, on an early ugly build — live-event failure modes only appear under real crowds) that includes, on purpose: a late arrival, a UI reload, a disconnect (including the Pope's), a no-show petitioner, and an interrupted or disputed Gora. The product must survive real human chaos before it meets an audience.

**Pre-code validation:** before console UI code is written, run one real ceremony with a paper-prototype console — David narrates what he wishes the console showed and did; someone takes notes. §18.1's question list is validated by performance, not by review. The success metrics are human-observable: did the ceremony feel bigger, and how often did David alt-tab.

---

# 23. Long-Term Product Systems

Subordinate to the core vision, in likely order: witness reporters feeding the authoritative store; Church Expedition and Campaign tracking; profession directory (self-reported); Chronicle consumption surfaces ("on this day," rivalry and location callbacks); the Fallen; honorific tooling; tournament creation and brackets; additional bespoke ceremony workflows; guild contribution history; leadership discovery; historical timelines; enhanced streamer presentation; community event tooling; one-way Discord export. Each faces §24 before it faces a developer.

---

# 24. Scope-Creep Filters

Every proposed feature answers all nine:

1. Does it help players create, participate in, or remember a Church of Beef moment?
2. Does WoW already do this well? (Prefer contextualizing over rebuilding.)
3. Does it reduce or increase David's live administrative workload?
4. Does it encourage members to play WoW together?
5. Does it create meaningful status or merely another number?
6. Does it preserve player expression?
7. Is it required for the current release?
8. **Is it Quiet Mode or Event Mode — and does Quiet Mode stay quiet?** *(new)*
9. **Does it replace something a human currently performs that is part of the entertainment?** *(new)*

Unfavorable answers mean defer or reject.

---

# 25. Design Success Criteria

The add-on is succeeding when: a randomly recruited player gradually feels they joined a real community; a Beef Knight sees a persistent history of their relationship with the Church; members increasingly seek each other out for ordinary WoW; the Pope runs a 20–40-player event spending most of his attention performing; a small Tuesday ceremony costs nothing to run; a Beef Gora is immediately understandable and entertaining to a Twitch viewer; a major Church moment feels dramatically larger than a normal WoW interaction; the add-on disappears when unnecessary; months of gameplay naturally produce shared history; and players value their status because of what happened, not because of a grind.

---

# 26. Product Thesis

The Church of Beef add-on becomes distributed social infrastructure for the guild. Ceremonies generate belonging. Beef Gora generates competition and prestige. Normal World of Warcraft generates long-term commitment. The Beef Network observes the community; the Chronicle remembers it; profiles show each member's relationship to that history. The Beef Pope provides cultural meaning; the Beef Council sustains the institution. The add-on connects these layers without becoming more important than the game in which they exist.

> **The Church of Beef add-on is not intended to give players more things to do in World of Warcraft. It is intended to make the things they already do together become part of something they remember.**

---

# Appendix A — API Validation Checklist (Implementation Gate)

Ordered by design impact; each item names its dependent feature and fallback. Validate against the live Anniversary TBC client before building the dependent system.

1. **Live health of non-group units** (nameplate/target scanning constraints) → Fight HUD live bars. *Fallback:* HUD without live health (§10.7).
2. **Duel outcome and duel-flee system messages** — exact formats, locale variance, visibility range → auto-proposed verdicts, Cowardice Recorded. *Fallback:* pure manual verdict (one tap; already required as override).
3. **Addon message sender integrity** (server-provided sender; channels: GUILD, RAID, WHISPER; rate limits at 40-client scale; throttle library) → §13.4 trust model, §13.1 broadcast, §20.3 snapshots.
4. **Guild roster API** — rank read/write (GuildPromote/SetRank permissions), roster refresh behavior → KNIGHT THIS BEEF, presence desk, §5 rank mapping.
5. **Raid target markers** — setting markers programmatically as leader/assist → candidate/fighter marking (§8). *Fallback:* target-assist only.
6. **Targeting by name from UI** (secure button constraints in combat) → console targeting assist.
7. **SavedVariables size and write behavior** → records, Chronicle, Archive export/import.
8. **PlaySoundFile / custom sound assets** → §19.4 cues.
9. **Party/raid composition and raid-leader detection** → later-phase Expeditions/Campaigns.
10. **Profession/tradeskill links on TBC client** → later-phase self-reported profession directory.
11. **Guild bank transaction log queryability** → later-phase tithe recognition.
12. **Dungeon "completion" signals** (final-boss-kill heuristic per dungeon) → later-phase Expeditions.
13. **Login/reload event timing** → Nights persist / snapshot requests; no login banner.

Any item that fails validation triggers a design fallback decision *before* implementation improvises one.

# Appendix B — Open Questions Carried Forward

1. **Distribution:** confirm CurseForge + Wago dual publish and update cadence policy (§21.3).
2. **Fight HUD feasibility:** Appendix A item 1 result decides HUD final form.
3. **Records Book categories:** §10.9 list awaits David's veto/additions — ideally checked against what members actually brag about in Discord.
4. **Curtain UX:** direction fixed (§17); interaction details open.
5. **Nights authorship:** Church nights are Pope-only. Discord stubs may be posted by designated Council (`Data/Council.lua`). See `docs/superpowers/specs/2026-09-14-nights-board-design.md`.
6. **Classic+ trigger:** on any official announcement, re-validate Appendix A and revisit §3 before further platform-dependent work.
7. **Council flagging of Chronicle moments:** MVP is Pope-only MARK; decide when/whether Council nomination unlocks.

*End of Design Bible v1.1.*
