# Church of Beef — V1 Design Spec

**Date:** 2026-07-25  
**Status:** Approved  
**Platform (V1):** World of Warcraft Burning Crusade Classic Anniversary  
**Later port target:** Classic+ (rumored; not in V1 scope)  
**Approach:** Knowledge-first repository, with content (canon) separated lightly from addon engine code

---

## 1. Purpose

Church of Beef is a social guild and streamer-event add-on. It is not a raid-optimization or combat-assistance tool.

It exists to help turn the guild into a living **religious-sports-entertainment** institution by supporting:

- Social coordination and guild spectacle
- Roleplay ceremonies and recurring traditions
- Informal player-versus-player competition (theatrical, not automated)
- Stream-friendly moments
- Persistent guild history, ranks, titles, and rivalries

V1 focuses on the **rank ladder and titles** as the centerpiece. Broader ceremonial dashboard theater is planned later and documented as deferred.

---

## 2. Hard technical restrictions

Firm project rules for all versions unless explicitly revised:

- TBC Classic Anniversary scope for V1 (Classic+ is a future port)
- No Retail-only or Dragonflight-era APIs
- Lua and XML only for the functioning add-on
- Fully in-game operation
- No external process controlling gameplay
- No injection, bots, automated movement, automated spellcasting, automatic targeting, or combat decision-making
- No protected-action circumvention

The add-on **may**: announce, track, record, display, coordinate, synchronize allowed information, create social ceremonies, and visualize competition.

The add-on **must not**: play the game for anyone.

---

## 3. V1 product scope

### 3.1 In scope (must work)

- Short **rank ladder** with seven display titles (see §4)
- **Standing points** from three suggestion sources:
  1. Beef Gora results (thin: challenge + recorded outcome)
  2. Ceremony participation (thin: officer-run event + attendance mark)
  3. Shared instance presence (dungeon / raid / battleground with other guild members)
- **Promotion suggestions** when thresholds are crossed
- **Officer+ approval** using real WoW guild rank to apply or reject rank changes
- Readable **ladder UI** via `/beef` and a minimap button
- Per-character SavedVariables (`ChurchOfBeefDB`)
- **BeefNet** sync for approved ranks and score-relevant coordination among addon users

### 3.2 Explicitly deferred

- Full ceremonial dashboard theater (announcements wall, confessions feed spectacle, spotlight states as a product surface)
- Audience favor / stream betting metaphors (theatrical favor bar)
- Long Beef Scripture / lore systems beyond a one-line footer placeholder
- Classic+ support (design for portability only)
- Deep match presentation / wrestling-show packaging for Beef Gora

### 3.3 Brand context (informs tone, not V1 feature checklist)

Established Church of Beef identity includes: comedic pope outfit/hat on stream, cow prophets, Beef God, gothic cathedral / Scarlet Crusade-inspired imagery, holy energy / steaks / cows / pageantry, “The Great Church of Beef,” “Eternal Grazing,” Alliance on Dreamscythe, Horde on Doomhowl, Classic Hardcore content, community videos and streamer interactions. Visual direction should feel like an absurd religious institution, not generic game UI art — full art pass is post-V1.

---

## 4. Rank ladder (canon)

Official V1 ladder, lowest to highest:

| Order | Title |
|------:|-------|
| 1 | Fresh Beef |
| 2 | Cooked Beef |
| 3 | Beef Knight |
| 4 | Beef Lord |
| 5 | Beef Butcher |
| 6 | Beef Council |
| 7 | Beef Prophet |

Advancement model: **hybrid**. The addon **suggests** promotions from standing; **WoW guild Officer+** characters **approve or reject**. Ranks are an addon-managed social layer, not a replacement for the actual WoW guild-rank system.

### 4.1 Two tiers of rank

Not all ranks are grindable. Prestige requires scarcity:

- **Ranks 1–5 (Fresh Beef → Beef Butcher): point-driven.** Standing thresholds make you *eligible for suggestion*; officers promote in the Blizzard guild UI ([roster-backed amendment](2026-07-25-roster-backed-ladder-design.md)). Knight/Lord also carry expected rites (checklist coaches; not hard locks) — see [eligibility & rites amendment](2026-07-26-ladder-eligibility-rites-design.md).
- **Rank 6 (Beef Council): seat-limited and appointed.** A governance body, not a grind tier. **Prophet-only appointment policy** (soft UI); seats configurable in canon data. No point threshold.
- **Rank 7 (Beef Prophet): bestowed and unique.** Guild-master seat / decree only. Default one living Prophet at a time (configurable). Reaching it should be an event, not an inevitability.

This keeps the top of the ladder from being "completed" by the most active grinder in month one, and matches the religious-institution fantasy: you earn your way up the flock, but the clergy chooses the clergy.

### 4.2 Thresholds (point-driven ranks)

Exact numbers live in canon data (`addon/ChurchOfBeef/Data/Ranks.lua`) and are tunable without touching core logic.

**Pacing rule:** a new member's first full dungeon night with guildmates should produce their first promotion suggestion (Fresh Beef → Cooked Beef). Fast early advancement is the hook; later ranks stretch out.

**Draft thresholds for V1 scaffolding** (replace after first guild playtest):

| Title | Standing to become suggestion-eligible |
|-------|----------------------------------------|
| Fresh Beef | 0 (default) |
| Cooked Beef | 50 |
| Beef Knight | 200 |
| Beef Lord | 500 |
| Beef Butcher | 1000 |
| Beef Council | — appointed (no threshold) |
| Beef Prophet | — bestowed (no threshold) |

### 4.3 Demotion

- **No automatic decay in V1.** Points only go up; decay can be revisited later if the ladder tops out.
- **Officers can demote manually.** Public demotion ("excommunication") is on-brand content for a guild built on comedy and rivalry — the addon supports it as a first-class officer action, with the same commit/sync path as promotion.

---

## 5. Repository structure

Knowledge-first layout with light content/engine separation:

```
Beef_Addon/
  docs/
    superpowers/specs/     # Design specs (this document)
    canon/                 # Prose lore: rank descriptions, scripture, ceremony notes
    phases/                # V1 vs later roadmap
  addon/ChurchOfBeef/      # Installable TBC Anniversary addon
    ChurchOfBeef.toc
    ChurchOfBeef.lua       # Bootstrap, slash commands, SavedVariables
    Core/                  # Score, suggestions, officer gate
    Net/                   # BeefNet
    UI/                    # Ladder frame, toasts, minimap
    Data/
      Ranks.lua            # MACHINE CANON: rank ids, titles, thresholds, seats
  README.md
```

**Canon lives inside the addon.** A WoW TOC can only load files within the addon's own folder, so `Data/Ranks.lua` is the single machine-readable source of truth for ranks and thresholds. `docs/canon/` holds prose lore only and must never duplicate the numbers — one source, no drift.

Install path on a player machine remains the conventional:

`Interface/AddOns/ChurchOfBeef`

(packaged from `addon/ChurchOfBeef/` in this repo).

**Filename discipline:** keep Lua/XML casing consistent (`ChurchOfBeef.lua`, etc.) for case-sensitive packaging.

**Scope note:** the guild has Alliance presence on Dreamscythe and Horde presence on Doomhowl. These are separate realms and separate guilds — **each guild runs its own independent ladder**. There is no cross-realm or cross-faction shared church state.

---

## 6. Runtime architecture

```
[Game events / thin Gora & ceremony UI]
        → Core scoring (local standing + caps)
        → Suggestion if threshold crossed
        → Officer+ reviews in UI
        → RANK_COMMIT on approve
        → BeefNet broadcast
        → Peers validate and apply
        → UI refresh (ladder, titles, toasts)
```

### 6.1 Components

| Unit | Responsibility | Depends on |
|------|----------------|------------|
| Canon ranks data | Titles, order, thresholds | Nothing |
| Core scoring | Apply capped point grants; compute suggestions | Canon, SavedVariables |
| Officer gate | Resolve whether local player is guild Officer+ | WoW guild APIs |
| BeefNet | Send/receive validated messages | Officer gate for commits |
| UI | Ladder, standing, officer queue, thin Gora/ceremony stubs | Core, Net |
| Bootstrap | TOC load, `/beef`, DB init, minimap | UI, Core |

### 6.2 Authority

- Only characters with a real WoW guild rank of **Officer or higher** may approve rank changes.
- Clients **must ignore** `RANK_COMMIT` (and equivalent) from non-officers.
- Officers may manually correct standing when needed.

**Concrete officer check.** "Officer+" must be resolved mechanically, since WoW guild rank names are arbitrary per guild:

- Addon message **sender names are supplied by the server** and cannot be spoofed by another player's addon. Sender identity is therefore trustworthy.
- Validation = look up the sender in the guild roster and compare their **guild rank index** against a configurable threshold (default: rank index ≤ 1, i.e., Guild Master and the top officer rank). The threshold lives in canon data / officer settings.
- If the roster lookup fails (sender not in guild, roster not yet loaded), the commit is queued or dropped — never applied unverified.

### 6.3 Design stance: the officer is the anti-cheat

Standing accrues on each member's own client, which means **all point data is self-reported**. SavedVariables are trivially editable, and this project will not build cryptographic verification into a comedy church addon.

The design stance, stated plainly: **standings are advisory testimony; officer approval is the real anti-cheat.** A suggestion is a member's client saying "I believe I earned this." Officers see the breakdown, apply human judgment, and their approval is what creates official state. Payload validation (§8.2) exists to stop malformed or forged *commits*, not to make self-reported points tamper-proof. If someone inflates their own numbers, the failure mode is an officer laughing at an implausible suggestion — which is acceptable, and arguably content.

---

## 7. Scoring rules

### 7.1 Sources and weights (V1 sketch; numbers tunable in canon)

| Source | What counts | Weight intent |
|--------|-------------|-----------------|
| Shared instance | In dungeon / raid / BG with ≥1 other **guildmate** in the party/raid (they need not run the addon for you to earn local credit) | Dungeon/BG: small drip + completion bonus; **raid: heavy** toward Butcher capstone; strict anti-farm caps |
| Quest fellowship | Party with ≥1 guildmate in the open world; activity-gated buckets | Medium-small drip; **strict daily/weekly cap** below raid so questing cannot outpace the capstone path |
| Ceremony | Officer starts a ceremony; attendees get credit when it closes; Knighting sets rite flag on honoree | Medium flat grant |
| Beef Gora | Challenge issued → outcome recorded (win / loss / draw); win vs a Beef Lord sets Lord rite flag | Win > draw > loss participation |

**Gora losses must pay.** Losing a duel grants small participation points. If losses pay nothing, members dodge challenges and the competition system dies; the ladder should reward showing up for the spectacle, not just winning it.

**Supersession:** full eligibility/rite model and quest fellowship detail live in [2026-07-26-ladder-eligibility-rites-design.md](2026-07-26-ladder-eligibility-rites-design.md). Rank authority is roster-backed ([2026-07-25-roster-backed-ladder-design.md](2026-07-25-roster-backed-ladder-design.md)).

### 7.2 Anti-abuse (V1)

- **Anti-AFK:** an instance or quest-fellowship time bucket only pays if the player entered combat (or, for quest fellowship, a quest turn-in when that signal is reliable) during that bucket. Idle grouping earns nothing.
- **Completion bonus:** a flat grant on dungeon completion / BG end rewards finishing content rather than loitering in it (when detection is reliable).
- Per-day caps per source (especially instance drip and quest fellowship)
- No points from cities / solo open-world loops — co-play requires a guildmate in the correct group; quest fellowship is the only capped open-world path
- Officer manual adjust / wipe for standing corrections

### 7.3 Suggestions

- Crossing the next rank’s threshold creates a **pending suggestion**, never an auto-promote
- Officers see: player, current rank, suggested rank, point breakdown, recent contributing events; Knight/Lord also show rite checklist status
- **Promote** happens in Blizzard’s guild UI; roster refresh moves the name; suggestion auto-clears when mapped title ≥ suggested
- **Dismiss** → suggestion clears; points remain unless officer corrects

---

## 8. BeefNet

Communication uses WoW addon messaging (`SendAddonMessage` / equivalent Classic-safe APIs), protocol name **BeefNet**.

### 8.1 V1 message types

| Type | Purpose |
|------|---------|
| `HELLO` | Version ping; soft-warn on major mismatch |
| `SCORE_EVENT` | Optional noteworthy point events (may stay local-first if noisy) |
| `SUGGESTION` | Member's client submits a promotion suggestion to officers |
| `RANK_COMMIT` | Officer-approved rank/standing snapshot for a player |
| `SYNC_REQUEST` | On login: ask peers for current official ladder state |
| `SYNC_STATE` | Response to a sync request: known official records (see §8.3) |

### 8.2 Trust and validation

- Accept `RANK_COMMIT` only from verified Officer+ (roster rank-index check, §6.2)
- Validate payload shape, rank id in 1–7, non-negative standing
- Incompatible/old major versions discarded
- Players without the addon are invisible to BeefNet; guild play must not soft-lock
- Avoid excessive traffic; prefer commits and coarse events over high-frequency spam, and pace outgoing messages (ChatThrottleLib-style throttling) to respect client bandwidth limits

Implementation defaults (locked unless planning revises them):

- Addon message prefix: `COB` (Church of Beef)
- Channel: `GUILD`
- Serialization: simple colon-delimited or Ace-style packed strings (keep payloads small)

### 8.3 State reconciliation (the offline problem)

Live broadcasts only reach players who are **online with the addon running**. Without reconciliation, anyone offline during a promotion holds a stale ladder forever. V1 handles this explicitly:

- **Revision numbers give ordering.** Every official player record carries an incrementing revision. Each `RANK_COMMIT` bumps the target player's revision. Higher revision wins; on a revision tie, later timestamp wins, then officer name as a deterministic tiebreak. "Last valid commit wins" is meaningless without this.
- **Login sync.** On login (or reload), a client sends `SYNC_REQUEST`. Peers respond with `SYNC_STATE` containing official records; the requester merges anything with a higher revision than its local copy. A short random response delay plus suppression (don't answer if someone else already did) prevents reply storms.
- **Officer copies are effectively authoritative.** Since only officers create commits, an officer's local state is the freshest source in practice. If no peer is online to answer a sync, the client keeps its cached view and reconciles when someone appears.
- **Replay safety.** Re-broadcast or duplicate commits with a revision ≤ the local copy are ignored. Old state can never overwrite new state.

---

## 9. Persistence

- Database: `ChurchOfBeefDB`
- Scope: **SavedVariablesPerCharacter** (not account-wide)
- Stores: UI prefs (including frame position), cached ladder view (official records + revisions), pending suggestions, local standing/event log as needed for My Standing

**There is no server.** The "ladder" is the set of officer-committed records, replicated as cached copies across members' clients and reconciled via §8.3. No single client is the database; officers' copies are simply the freshest in practice.

**Alts are separate characters.** Per-character storage means an alt starts at Fresh Beef with zero standing. This is the V1 stance, and it is on-brand — the flesh must prove itself anew. Account-level rank merging is an open question (§16), not a V1 feature.

---

## 10. V1 UI

- `/beef` opens the main frame (movable, clamped to screen, saved position)
- Minimap button toggles the same frame
- **Ladder tab:** all seven ranks, occupants, local player highlight + title
- **My Standing tab:** points, next threshold, recent contributing events
- **Officer tab** (Officer+ only): pending suggestions, approve/reject, manual standing correction, demote, Council appointment, Prophet bestowal
- **Thin stubs:** Gora “record result,” Ceremony “start/close” — enough to feed scores
- Toasts on: suggestion created, rank approved, Gora/ceremony credit
- **Guild-chat announcement on promotion/demotion** (plain text, visible to members *without* the addon): one throttled line, e.g. “The Church recognizes Beefina, elevated to Beef Knight.” Sent by the approving officer's client only (no duplicate spam); per-officer opt-out. This is the cheapest stream-friendly spectacle in V1 — a rank change nobody sees isn't a spectacle.
- **Announce opt-out UX (locked):** Officer+ checkbox on the Officer tab labeled **“Announce promotions to guild chat”** (procedural, not meme); mirrors `ChurchOfBeefDB.ui.announce`; **default ON**. Optional duplicate later under a minimal settings strip — slash-only is not sufficient.
- **V1 settings budget (locked):** frame position (always), minimap show/hide, announce opt-out. Toast mute only if playtest proves noise. No UI-scale override, strata picker, or per-event announce filters in V1.
- **My Standing progress (locked for Task 8):** text thresholds only (standing + next title / appointed-only copy). Thin track for ranks 1–5 is a post-playtest option, not a V1 requirement. No meter-dashboard breakdown chrome.
- **Streamer privacy:** no dedicated Streamer Mode in V1 code — document that third-party StreamerMode does not mask `/beef`. V1.1 may add an SV preset (mask flock names and/or quieter toasts); privacy must never silently disable officer guild announce.
- **Brand chrome colors:** V1 ships template-native Blizzard chrome + GameFont defaults. Provisional research hex is not law until an Anniversary screenshot pass. Custom brand accents beyond class-colored names and dual-encoded state colors wait on that lock.
- **Faction look:** one shared Scarlet/church brand for both guilds — no Alliance/Horde panel skins. Optional tiny faction chip is post-V1 only if streamers ask.
- **SFX:** V1 is silent. Optional cleared one-shots may arrive with a later spectacle pass, **default off**; never redistribute ripped Blizzard audio.
- One-line scripture/footer placeholder allowed; not a full lore system
- Missing fonts/textures must fall back to default UI fonts; addon still loads
- Frame must always be created on load or first `/beef` (fix for prior “command works, nothing appears” failure mode)

V1 may use plain Classic frames; dark-iron theatrical chrome / commissioned heraldry is a later visual pass (commission package may accept seal shape language when funded; until then words-only brand is correct).

---

## 11. Error and edge handling

| Situation | Behavior |
|-----------|----------|
| Not in a guild | Empty-state ladder; scoring paused |
| Not Officer+ | Officer tab hidden; approve actions no-op |
| BeefNet version mismatch | Soft warning; do not apply incompatible commits |
| Duplicate or replayed `RANK_COMMIT` (revision ≤ local) | Ignore |
| Higher-revision valid `RANK_COMMIT` | Replace local official state |
| Player offline when a commit happens | Reconciled by login sync (§8.3) |
| Guild roster not yet loaded when a commit arrives | Queue or drop; never apply unverified |
| Disconnect mid-ceremony | No credit until officer closes cleanly or grants manual credit |
| Missing media | Fallback fonts/textures; continue |
| Non-officer forged approve | Reject at validation |
| Player leaves the guild | Record retained but hidden from ladder; restored if they return |

---

## 12. Portability (Classic+)

V1 does not support Classic+. Isolate game-specific concerns:

- TOC / interface version
- Instance detection APIs
- Addon message APIs if they differ

Canon ranks, scoring policy, and UI information architecture should transfer with minimal rewrite.

---

## 13. Success criteria

V1 succeeds when (roster-backed amendment §11; walkable list in `docs/phases/v1-checklist.md`):

1. Addon loads on TBC Classic Anniversary and appears as **Church of Beef**
2. `/beef` opens a real frame (not chat-only)
3. Ladder occupants come from the live guild roster via the fixed `rankIndex`→Church map; local title/standing is visible
4. Shared dungeon/raid/BG time with a guildmate can grant capped standing
5. Thin Gora and ceremony actions can grant standing
6. Crossing a threshold creates an officer-visible promote suggestion (never auto-promotes; never suggests Council/Prophet from points)
7. Officer tab is Dismiss + standing correction only — officers promote in the Blizzard guild UI
8. Promoting in the guild UI updates the Ladder on roster refresh; satisfied suggestions auto-clear
9. Addon never calls guild promote/demote APIs; legacy `RANK_COMMIT` is soft-ignored
10. No Retail-only APIs; no combat automation
11. **Social check (deferred `/g`):** during a real session, at least one suggestion is fulfilled via the guild UI and the Ladder visibly moves. Guild-chat promote announce waits on a future roster-diff announcer.

### 13.1 Verification approach

- Prefer [`docs/phases/solo-smoke.md`](../../phases/solo-smoke.md) on one Anniversary client (GM/Officer+)
- Optional second client for `SUGGESTION` fanout only
- Load-with-missing-assets smoke test
- Doc review: canon ranks match UI; deferred features marked as later-phase

---

## 14. Phase map (documentation only)

| Phase | Focus |
|-------|--------|
| **V1** | Roster-backed ladder, standing suggestions, thin Gora/ceremony, instance co-play scoring, suggestion fanout, basic UI |
| **V2** | Ceremonial dashboard spectacle, confessions feed, richer scripture, stream contrast pass; optional roster-diff `/g` announce |
| **V3** | Full Beef Gora presentation (favor meter theatrical layer, match history theater) |
| **V4** | Classic+ port as primary platform |

---

## 15. Decisions log

| Topic | Decision |
|-------|----------|
| V1 centerpiece | Rank ladder + titles (roster-backed) |
| Advancement | Hybrid: standing suggests → Officer+ promotes in Blizzard guild UI |
| Approvers | Real WoW guild Officer+ (roster rank-index check); addon = Dismiss + standing correction only |
| Suggestion fuel | Gora + ceremonies + shared instance presence + quest fellowship (see eligibility amendment) |
| Co-play definition | Qualifying instance (dungeon/raid/BG) or capped quest fellowship ∧ connected guildmate in the correct group category; combat-gated buckets for anti-AFK; no proximity / CLEU for scoring (research tracks 59, 63) |
| Platform | TBC Classic Anniversary first (`## Interface: 20506`, `_anniversary_` tree) |
| Classic+ | Future port, not V1 |
| Ladder | Fresh Beef → Cooked Beef → Beef Knight → Beef Lord → Beef Butcher → Beef Council → Beef Prophet |
| Rank tiers | Ranks 1–5 point-driven (Knight/Lord + rite checklists); Beef Council seat-limited Prophet-appointed (soft); Beef Prophet unique GM seat |
| Rank source | Live guild roster via fixed `rankIndex`→Church map (roster-backed amendment) |
| Demotion | No automatic decay in V1; demote in Blizzard guild UI |
| Anti-cheat stance | Standings are self-reported advisory testimony; officer guild-UI judgment is the real gate |
| BeefNet ranks | Legacy `RANK_COMMIT` / rank `SYNC_STATE` soft-ignored; `SUGGESTION` fanout may remain |
| Promotion visibility | Deferred guild-chat announce until roster-diff announcer; edge toast + officer queue remain |
| Announce opt-out UX | SV key retained; Officer-tab checkbox **hidden** until roster-diff announcer |
| V1 settings budget | Position + minimap hide; announce control dormant; toast mute only if playtest demands |
| My Standing progress | Text thresholds only for Task 8; thin 1–5 track optional post-playtest; no meter-dashboard chrome |
| Streamer Mode | Not in V1 code; coexistence note only; V1.1 SV preset later; must not kill guild announce |
| Brand hex / chrome tint | Template-native V1; lock research hex only after Anniversary screenshot pass |
| Faction chrome | Shared church brand only; no Alliance/Horde skins; optional chip post-V1 if asked |
| SFX | V1 silent; later spectacle SFX default off; no ripped Blizzard audio |
| Post-V1 heraldry brief | Accept seal shape language (flock escalation + Council/Prophet break) when commissioning; delay art until shell works |
| Suggestion inbox | Local-persist + live fanout only; soft-expire ~14 days; no shared BeefNet suggestion store in V1 (track 67); officer pull-on-login = V1.1 flag |
| Combat log | Do not register CLEU for V1 scoring (track 63) |
| Dependencies | No AceAddon / hard `Dependencies` in V1; plain `COB` namespace; embed CTL/LibDBIcon only when triggered (tracks 34, 42) |
| Machine canon location | `addon/ChurchOfBeef/Data/Ranks.lua` (inside addon folder; TOC constraint) |
| Cross-realm | None; each guild (Dreamscythe Alliance, Doomhowl Horde) runs an independent ladder |
| Repo approach | Knowledge-first + light canon/engine split |
| SavedVariables | Per-character `ChurchOfBeefDB` (local standing, suggestions, UI prefs — not official ranks) |
| Implementer index | Research glossary: `docs/research/wow-classic-addon-design/74-v1-decision-glossary/` |

### 2026-07-26 — Agent polish vision Accepted

User **Accepted** the `docs/research/agent-polish-vision/` synthesis ([00-SYNTHESIS.md](../../research/agent-polish-vision/00-SYNTHESIS.md)). Celebration tiers **T0/T1**; default polish loop = **BIR** (research pack / skill path). After the roster-backed Accept the same day, T1 guild-chat promote announce is **deferred**; V1 spectacle budget for playtest = private edge toast + officer queue + visible Ladder move after guild-UI promote. ADR-0006 superseded. Does not claim V1 complete.

### 2026-07-26 — Roster-backed ladder Accepted

User **Accepted** [2026-07-25-roster-backed-ladder-design.md](2026-07-25-roster-backed-ladder-design.md). Church titles mirror the live WoW guild roster via fixed `rankIndex`→Church map (GM→Prophet … 6+→Fresh Beef). Standing still creates promote **suggestions**; officers promote in Blizzard’s guild UI (Dismiss + standing correction only). Addon `RANK_COMMIT` / rank sync are soft-ignored. Guild-chat promote announce deferred until a future roster-diff announcer.

### 2026-07-26 — Ladder eligibility & rites Accepted

User **Accepted** [2026-07-26-ladder-eligibility-rites-design.md](2026-07-26-ladder-eligibility-rites-design.md). Approach = eligibility tags (standing enqueues suggestions; Knight/Lord show rite checklists that coach, not hard-block). Cooked = standing + addon on-ramp (Discord not a rank lock). Knight = standing + Knighting rite. Lord = standing + Gora win vs a Beef Lord. Butcher = pure standing capstone (raid heavily weighted). Quest fellowship added as capped co-play. Council = Prophet-only appointment policy (soft UI). Does not claim V1 complete.

| Topic | Decision |
|-------|----------|
| Rank eligibility approach | Standing thresholds enqueue; Knight/Lord rite checklists coach only |
| Cooked Beef gate | Standing + addon use; Discord demoted to community follow-up |
| Beef Knight / Lord rites | Knighting ceremony; Gora win vs seated Beef Lord |
| Beef Butcher | Pure standing guild capstone; no rite lock |
| Co-play sources | Instance + raid (heavy) + quest fellowship (capped) + ceremony + Gora |
| Council appointment policy | Soft Prophet-only (UI copy); Blizzard UI not locked |

### 2026-07-26 — Large-guild Ladder UI (Revised — implementation in flight, awaiting human Accept)

Design lives in [2026-07-26-large-guild-ladder-ui-design.md](2026-07-26-large-guild-ladder-ui-design.md).
**Status: implementation-ready, partially implemented — not yet Accepted, and the harness is not green.**
An earlier entry here claimed “Implemented (harness green)”; live Anniversary evidence (`Fresh Beef 880`,
`Beef Council 9/4`, Council preview overlapping the Butcher header) reopened it. The amendment was revised
against a **900-in-one-band** scale target — see its §14 decisions log, rows LG-11…LG-22.

Ladder keeps institutional bands (7→1) with per-band collapse/expand, a clickable chevron / “+N more”,
a bounded-pool scroll viewport for oversized bands, and an in-tab Find/filter. New in the revision: the
MainFrame becomes **resizable** (420×320–900×760, size persisted), all tab layout derives from a pure
`LayoutPlan` with four named modes, row pools are **bounded grow-only and height-driven** (never
guild-size-driven), occupant lines are single-line clipped, seat overflow is shown honestly, and class
colors move into the Core roster snapshot so the UI paint path makes zero `GetGuildRosterInfo` calls.
Presentation-only — roster remains title authority; no flat spreadsheet; no Retail-only APIs
(resize APIs feature-detected); UI closed stays idle.

| Topic | Decision |
|-------|----------|
| Large-guild Ladder IA | Bands 7→1 + per-band overflow (collapse / +N more / bounded-pool scroll) |
| Scale target | **900+ occupants in a single band**; up to ~1200 roster rows |
| Ladder Find | In-tab name filter on the normalized name; alpha within band only |
| MainFrame resize | Resizable 420×320–900×760; size persisted; layout derived from height/width |
| Row pools | Bounded grow-only (ladder 12→48, officer 10→32), driven by viewport height |
| Seat overflow | Shown honestly (e.g. `9/4` + “over seats”) — roster stays authority |
| Officer queue scale | Height-derived pooled scroller (not a hard 6- or 10-row cap) |

### 2026-08-01 — Leap-forward Phases 1–3 (agent-implemented; awaiting human Accept)

Plan: [2026-08-01-church-of-beef-leap-forward.md](../plans/2026-08-01-church-of-beef-leap-forward.md). These
rows record the decisions the plan marked as blocking (D1–D3, D5). Conservative and reversible defaults were
taken so implementation could proceed; each is a config or copy change to undo, not a rewrite. **Does not
claim V1 complete** — no in-game smoke has been run for these phases.

**D1 — Standing divergence: accept "standing is per-client testimony."** Standing is computed from what
*this* client witnessed, so two officers will legitimately hold different numbers for the same member. The
alternative (sender-authoritative standing sync) is a much larger project and multiplies the trust surface.
The addon now says so instead of hiding it: a petition that arrived over the wire carries the sender's number
as `claimedStanding`, rendered as `Standing 0 / 50 (threshold) — Beefina reports 99999, unverified here`, and
the Officer tab states that a standing correction applies to this client only.

**D2 — Gora integrity: membership + per-pair cooldown, and it pays least.** A Gora is two members typing a
result at each other, so it is the cheapest thing in the game to fake. Both parties must now be on a
**complete** guild roster, and a pair may bank at most one result per hour. Values moved to put co-play above
typing (see the table below).

**D3 — Completion bonus: keep only the signal that exists.** `RaidComplete` and the dungeon `InstanceComplete`
were deleted rather than wired: TBC gives this client no honest "dungeon/raid finished" event, and a number
nothing can ever pay is a promise the config makes and the addon breaks. A finished battleground is detectable,
so `BattlegroundEnd` (20) survives, drawn from the shared instance budget. `Instance:GrantCompletion` refuses
any tracked run that is not a battleground, so the grant cannot be reached from a raid or dungeon by a caller
that stops checking — dungeons and raids are paid entirely by their buckets.

**D5 — `Announce.lua` stays dormant and is now provably inert.** Its header described the superseded
commit-author model and it defaulted to enabled. It now carries `Deferred = true`, so `IsEnabled()` is false
until a roster-diff announcer is actually wired. The double-announce hazard (every client announcing the same
promotion) is documented in the file. Whether to build that announcer at all remains a human call.

**Incentive table (Phase 3 gate).** Per-day ceilings, showing that playing together out-earns self-reporting:

| Source | Per event | Daily cap | Effort to reach the cap |
|--------|-----------|-----------|-------------------------|
| Ceremony | 40 | **80** | Two attended rites — organised, witnessed, hard to fake alone |
| Instance / raid / BG | 5 dungeon-BG bucket, 12 raid bucket, 20 BG finish | **60** | ~5 fought raid buckets or 12 dungeon buckets; combat-gated, guildmate present |
| Gora | 15 win / 8 draw / 5 loss | **40** | ≥3 wins against *different* guildmates, ≥1h apart per pair |
| Quest fellowship | 3 | **24** | 8 combat-or-turn-in buckets in the open world with a guildmate |

Gora's cap sits below both co-play sources by design; quest fellowship stays smallest because it is the
easiest to be passively present for. Numbers remain placeholders until one instrumented guild night.

| Topic | Decision |
|-------|----------|
| Standing divergence | Per-client testimony; wire numbers shown as `claimedStanding`, never as verified standing |
| Standing correction scope | Local client only; Officer UI says so |
| Gora integrity | Both parties on a complete guild roster; one banked result per pair per hour |
| Economy ordering | ceremony 80 > instance 60 > gora 40 > quest 24 (daily caps) |
| Completion bonus | `BattlegroundEnd` only; `RaidComplete` / `InstanceComplete` deleted as unpayable |
| Quest rest zones | 180s grace after `IsResting()` flips, so town turn-ins after field play still count |
| Ceremony kind | Explicit `kind` argument (Rite / Knighting) — no more `label:find("[Kk]night")` |
| Departed members | `Ladder.records` swept once a session against a **complete** roster; 14-day absence grace, clock persisted |
| Promotion announce | Remains deferred; `Announce.lua` default-OFF via `Deferred = true` |
| Ghost protocol | `Sync` module, `SYNC_REQUEST`, `SYNC_STATE`, `RANK_COMMIT` removed; status chip reports guild + roster readiness only |

### 2026-08-01 — Leap-forward Phases 4–5 (agent-implemented; awaiting human Accept)

Same plan, later phases: the strict harness (Phase 5) was pulled ahead of the UI work (Phase 4) so the UI
was written under it rather than checked by it afterwards.

**Layout truth.** The Ladder's `LayoutPlan` decided one thing and the paint path drew another. The plan said
an expanded band at the smallest window hides six of the seven headers; the paint path kept all seven and
re-derived its own geometry, overrunning the footer reserve slightly. Because the tested invariant was written
against the plan, nothing was checking the frame a player actually sees. Keep-all-headers is now the rule
inside `LayoutPlan` — the institutional stack 7→1 *is* the Ladder — and the footer-reserve invariant is
asserted across the whole draggable height range against the same function the paint path calls. Details and
the new `inline` mode in the [large-guild UI amendment](2026-07-26-large-guild-ladder-ui-design.md) §4.3, §7.2.

**Officer subject box.** The Officer tab auto-filled the standing-correction subject from the queue on every
repaint, so a petition arriving mid-word overwrote whatever an officer was typing. Auto-fill now writes only
over text the tab put there itself, and never into a focused box. The queue selection and the box are allowed
to disagree: the box is what the action reads.

**D4 — toast anchor: still open, and still a human call.** It needs to be judged on-screen against a real
UI at a real resolution, which no harness can do. Unchanged for now.

**Combat soft-defer: config removed rather than honoured.** Toast kinds carried a `deferInCombat` flag that no
code read. Deferring low-priority toasts until `PLAYER_REGEN_ENABLED` is a genuine improvement, but it was
explicitly decided OFF for V1, and quietly reversing that under a cleanup task would be the wrong way to make
it. The flag is gone so the table stops describing policy the addon does not have; the hook point stays
documented where the code would go.

| Topic | Decision |
|-------|----------|
| Expanded Ladder layout | All seven headers survive in every mode; `focus` differs from `compressed` only by viewport size |
| Filtered expanded band | New `inline` mode draws matches under their own header at preview height (fixes the overlap) |
| Sacrifice order at minimum size | Viewport caption first, last name row never |
| Officer subject box | Auto-fill never overwrites hand-typed text or a focused box |
| Ladder repaint cost | Band buckets cached per roster generation; Officer queue cached per (ladder revision, needle) |
| Toast combat defer | Flag deleted, not honoured; remains a documented hook point, OFF for V1 |
| D4 toast anchor | Still open — requires an on-screen human judgement |

### 2026-08-01 — UI polish loop round 1 (agent-implemented; POLISH:CANDIDATE; D4 resolved)

Plan: [2026-08-01-church-of-beef-leap-forward.md](../plans/2026-08-01-church-of-beef-leap-forward.md) §6.4, run per
the skill's polish loop (one critique→revise round; stopped clean). Baseline finding: the client's loaded UI was a
stale pre-reload build — every screenshot before the `/reload` showed chrome that no longer existed in the tree.
First evidence, then taste.

**Chrome.** Tabs are no longer `UIPanelButtonTemplate` dialog buttons parked under the title — they are Classic
`PanelTabButtonTemplate` panel tabs hanging from the frame's bottom edge (Character-frame idiom), which also freed
~28 px of content height (CONTENT_TOP 58→30; fallback content budgets updated to match). Shared `UI.Palette` now
owns the gold/muted/stone/iron tints the tabs, Ladder, Standing, Officer and toast chrome used to hardcode
separately. **Ladder:** band accent bars now mean something (open band or your own band only — idle bands get no
stripe); the heavy viewport's names are row Buttons with hover + zebra, matching the Standing/Officer lists; the
collapsed preview width-fits itself with an ellipsis instead of clipping mid-name (a pinned self survives the trim);
the Find box rides its strip instead of dual-anchoring. **Standing:** the rites strip is a two-row grid with
aligned baselines under a separating hairline; the name line is class-colored. **Officer:** petitioner names are
class-colored; the selected row stays fully gold.

**D4 — toast anchor: resolved, keep top-center −160.** Judged on-screen by the human on 2026-08-01: readable,
non-modal, mouse-transparent, and every Classic corner already has an occupant (player frame TL, minimap TR,
chat BL, bags/micro BR). Supersedes the "still open" row above.

Harness: 1474 assertions green under the strict stub; installed byte-identical to the Anniversary AddOns folder;
in-game screenshot round over Ladder / My Standing / toast came back with no P0/P1 findings. **POLISH:CANDIDATE**
claimed for shell/tabs, Ladder, Standing, Officer, toasts, and the minimap button. POLISH:PASS and V1-complete
remain human-only.

| Topic | Decision |
|-------|----------|
| Tab chrome | `PanelTabButtonTemplate` hanging from the frame's bottom edge; selected = template active textures + gold label |
| UI color authority | `COB.UI.Palette` (MainFrame, loads first); tabs alias with local fallbacks |
| Ladder accent bars | Open band or self band only; idle bands unmarked |
| Ladder heavy rows | Button rows with hover highlight + zebra (Standing/Officer parity) |
| Class color on names | Extended to My Standing name line and Officer queue names (names-only doctrine unchanged) |
| D4 toast anchor | **Keep top-center −160** (human, on-screen, 2026-08-01) |

---

## 16. Open questions (not V1 blockers)

Tracked here so they don't silently become assumptions:

1. **Alt policy.** V1 is strictly per-character. Should a future version let officers link alts to a main's rank, or is "the flesh must prove itself anew" permanent doctrine?
2. **Council seat count.** Default 4 — needs a real decision from guild leadership before the first appointment.
3. **Standing decay.** Off in V1. If the ladder saturates (everyone at Beef Butcher), revisit seasonal resets or decay — a "Lent" season reset is an on-brand option.
4. **Instance completion detection.** No reliable Classic “dungeon complete” event (track 15). Ship combat-gated drip as primary; treat completion bonus / BG winner / encounter IDs as optional—drop if flaky in Anniversary playtest.
5. **Suggestion queue sharing.** **Closed for V1** (see §15): local-persist + live fanout; no shared store. Reopen as V1.1 only if officers miss petitions in playtests.
6. **Threshold tuning.** All numbers in §4.2 are placeholders until one instrumented guild night (research track 51 playbook).
7. **Quest fellowship signal.** Turn-in vs combat-only buckets on Anniversary — see eligibility amendment open questions.
