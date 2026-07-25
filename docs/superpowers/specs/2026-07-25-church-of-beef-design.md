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

- **Ranks 1–5 (Fresh Beef → Beef Butcher): point-driven.** Standing thresholds make you *eligible for suggestion*; officers approve.
- **Rank 6 (Beef Council): seat-limited and appointed.** A governance body, not a grind tier. Officers appoint members directly (default 4 seats, configurable in canon data). No point threshold.
- **Rank 7 (Beef Prophet): bestowed and unique.** Anointed by officer decree only. Default one living Prophet at a time (configurable). Reaching it should be an event, not an inevitability.

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
| Shared instance | In dungeon / raid / BG with ≥1 other **guildmate** in the party/raid (they need not run the addon for you to earn local credit) | Small drip per active time bucket + completion bonus; strict anti-farm caps |
| Ceremony | Officer starts a ceremony; attendees get credit when it closes | Medium flat grant |
| Beef Gora | Challenge issued → outcome recorded (win / loss / draw) | Win > draw > loss participation |

**Gora losses must pay.** Losing a duel grants small participation points. If losses pay nothing, members dodge challenges and the competition system dies; the ladder should reward showing up for the spectacle, not just winning it.

### 7.2 Anti-abuse (V1)

- **Anti-AFK:** an instance time bucket only pays if the player entered combat during that bucket. Standing at a dungeon entrance with a guildmate earns nothing.
- **Completion bonus:** a flat grant on dungeon completion / BG end rewards finishing content rather than loitering in it.
- Per-day caps per source (especially instance drip)
- No points from cities / open-world loops — **instance types only** for the co-play source
- Officer manual adjust / wipe for standing corrections

### 7.3 Suggestions

- Crossing the next rank’s threshold creates a **pending suggestion**, never an auto-promote
- Officers see: player, current rank, suggested rank, point breakdown, recent contributing events
- **Approve** → official rank updates and syncs
- **Reject** → suggestion clears; points remain unless officer corrects

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
- One-line scripture/footer placeholder allowed; not a full lore system
- Missing fonts/textures must fall back to default UI fonts; addon still loads
- Frame must always be created on load or first `/beef` (fix for prior “command works, nothing appears” failure mode)

V1 may use plain Classic frames; dark-iron theatrical chrome is a later visual pass.

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

V1 succeeds when:

1. Addon loads on TBC Classic Anniversary and appears as **Church of Beef**
2. `/beef` opens a real frame (not chat-only)
3. All seven ranks display; local title/standing is visible
4. Shared dungeon/raid/BG time with a guildmate can grant capped standing
5. Thin Gora and ceremony actions can grant standing
6. Crossing a threshold creates an officer-visible suggestion
7. Officer+ can approve → rank updates locally and via BeefNet for other addon users when present
8. A player who was offline during a promotion sees the correct ladder after logging in (login sync works)
9. Non-officers cannot successfully apply a forged `RANK_COMMIT`
10. No Retail-only APIs; no combat automation
11. **Social check:** during a real guild night, at least one promotion happens and gets a visible reaction in guild chat. V1's goal is spectacle; if rank changes pass unnoticed, the feature has failed even if every function works.

### 13.1 Verification approach

- In-game checklist on a TBC Anniversary client (ideally two characters: member + officer)
- BeefNet check: approve on officer → member sees update
- Load-with-missing-assets smoke test
- Doc review: canon ranks match UI; deferred features marked as later-phase

---

## 14. Phase map (documentation only)

| Phase | Focus |
|-------|--------|
| **V1** | Rank ladder, hybrid suggestions, thin Gora/ceremony, instance co-play scoring, BeefNet commits, basic UI |
| **V2** | Ceremonial dashboard spectacle, confessions feed, richer scripture, stream contrast pass |
| **V3** | Full Beef Gora presentation (favor meter theatrical layer, match history theater) |
| **V4** | Classic+ port as primary platform |

---

## 15. Decisions log

| Topic | Decision |
|-------|----------|
| V1 centerpiece | Rank ladder + titles |
| Advancement | Hybrid: suggest → Officer+ approve |
| Approvers | Real WoW guild Officer+ (roster rank-index check, configurable threshold) |
| Suggestion fuel | Gora + ceremonies + shared instance presence |
| Co-play definition | Dungeon / raid / BG with other Beef (guild) members, with anti-AFK combat requirement |
| Platform | TBC Classic Anniversary first |
| Classic+ | Future port, not V1 |
| Ladder | Fresh Beef → Cooked Beef → Beef Knight → Beef Lord → Beef Butcher → Beef Council → Beef Prophet |
| Rank tiers | Ranks 1–5 point-driven; Beef Council seat-limited appointed; Beef Prophet bestowed, unique |
| Demotion | No automatic decay in V1; manual officer demotion is first-class |
| Anti-cheat stance | Standings are self-reported advisory testimony; officer approval is the real gate |
| Sync ordering | Per-record revision numbers; login sync reconciliation; replay-safe |
| Promotion visibility | Throttled guild-chat announcement from approving officer's client |
| Machine canon location | `addon/ChurchOfBeef/Data/Ranks.lua` (inside addon folder; TOC constraint) |
| Cross-realm | None; each guild (Dreamscythe Alliance, Doomhowl Horde) runs an independent ladder |
| Repo approach | Knowledge-first + light canon/engine split |
| SavedVariables | Per-character `ChurchOfBeefDB` |

---

## 16. Open questions (not V1 blockers)

Tracked here so they don't silently become assumptions:

1. **Alt policy.** V1 is strictly per-character. Should a future version let officers link alts to a main's rank, or is "the flesh must prove itself anew" permanent doctrine?
2. **Council seat count.** Default 4 — needs a real decision from guild leadership before the first appointment.
3. **Standing decay.** Off in V1. If the ladder saturates (everyone at Beef Butcher), revisit seasonal resets or decay — a "Lent" season reset is an on-brand option.
4. **Instance completion detection.** Dungeon-complete signals vary in reliability on Classic-era clients; if detection proves flaky, fall back to combat-active time buckets only and drop the completion bonus.
5. **Suggestion queue sharing.** V1 may keep suggestions visible only to officers who received the `SUGGESTION` message while online. If officers complain about missed suggestions, extend login sync to cover the pending queue.
6. **Threshold tuning.** All numbers in §4.2 are placeholders until one real guild night of data exists.
