# Tear-down: RP / community directory addons (TRP3 & MyRolePlay)

**Primary cousin:** [Total RP 3](https://www.curseforge.com/wow/addons/total-rp-3) ([GitHub](https://github.com/Total-RP/Total-RP-3), [WowInterface](https://www.wowinterface.com/downloads/info24113-TotalRP3.html))  
**Lightweight Classic peer:** [MyRolePlay Classic](https://legacy-wow.com/classic-addons/myroleplay-classic/) (CurseForge slug historically `myroleplay-classic`)  
**Era context:** [Blizzard Watch — Roleplaying in WoW Classic](https://blizzardwatch.com/2019/08/26/roleplaying-in-wow-classic-guide); [Forum — RP profile addon for Classic](https://us.forums.blizzard.com/en/wow/t/rp-profile-addon-for-classic-popular-here/273469)  
**Interop standard:** [Mary Sue Protocol (MSP)](https://moonshyne.org/msp/) · [TRP3 wiki — MSP module](https://github.com/Total-RP/Total-RP-3/wiki/Mary-Sue-Protocol)

> **Classic equivalent note:** There is no dominant “guild Yellow Pages” addon separate from RP profiles. The directory-style product in Classic is **TRP3’s Directory + target/tooltip profile viewer**, with **MRP** as the lighter MSP peer. Guild rank ladders (Beef) sit in a different niche but share identity/title UX.

---

## 1. What problem they solve

Let players **author a social identity** (name, title, description, IC/OOC) and **browse peers’ identities** without leaving the client. Community value is a **living directory of people you’ve met**, not DPS meters.

Church of Beef’s titles (Fresh Beef → Beef Prophet) are closer to **RP titles / directory rows** than to raid buffs — theatrical social rank with a browseable roster.

---

## 2. Screen / IA map (Total RP 3)

From [GitHub README](https://github.com/Total-RP/Total-RP-3) and [WowInterface description](https://www.wowinterface.com/downloads/info24113-TotalRP3.html):

| Surface | Role | Notes |
|---------|------|-------|
| **Profile editor** | Author your character (and companions) | Multiple profiles; switchable |
| **Directory** | Repository of profiles you have encountered | Core “Yellow Pages” metaphor |
| **Profile viewer** | Full read of a target’s sheet | Also tooltip preview (MRP emphasizes this) |
| **Target frame (RP)** | Quick actions: open profile, theme, relationship | Contextual, not a full dashboard |
| **Map scan** | Find other TRP3 users on the world map | Privacy toggles (hide / IC-only show) |
| **Toolbar** | IC↔OOC, AFK/DND, profile switch, language, helm/cloak | Status machine for social presence |
| **Chat customizations** | OOC/emote coloring; RP names in chat | High spectacle; easy to overdo |
| **Mature profile filtering** | Warn before opening flagged content | Consent / safety pattern |
| **Modules** | Optional Extended creation system, etc. | Modular so UI doesn’t force everything |

**MyRolePlay** ([legacy-wow feature list](https://legacy-wow.com/classic-addons/myroleplay-classic/)): lighter profile + tooltip preview + full viewer; designed to stay efficient; MSP-compatible. Forum consensus at Classic launch: MRP simpler, TRP3 more fields/traits ([Blizzard forums](https://us.forums.blizzard.com/en/wow/t/rp-profile-addon-for-classic-popular-here/273469)).

### Classic availability

- Launch-era Classic had **MRP Classic** and **Total RP 3: Classic** as the two profile-exclusive options ([Blizzard Watch](https://blizzardwatch.com/2019/08/26/roleplaying-in-wow-classic-guide)).  
- WowInterface currently lists TRP3 as compatible with **Retail, Classic & TBC** ([WowInterface](https://www.wowinterface.com/downloads/info24113-TotalRP3.html)).  
- Always install into the **Anniversary** AddOns tree; do not assume one Shared Client folder.

---

## 3. “Officer queue” analogue

RP directories generally **have no officer queue**. Authority is personal:

- You author *your* profile.  
- Peers cache what they receive.  
- No guild officer approves your title in MRP/TRP3.

**Beef difference:** titles are **guild-institutional** and officer-gated. Steal directory *browsing* UX, not self-serve title assignment for Council/Prophet.

| RP directory | Beef |
|--------------|------|
| Self-authored title/name | Officer-committed display title |
| Directory of encountered players | Ladder of guild members by rank |
| Relationship flags (TRP3) | Rivalries deferred / soft lore later |
| Mature content warn | Confirm on excommunication / Prophet |

---

## 4. Sync model — Mary Sue Protocol

Documented in [TRP3 MSP wiki](https://github.com/Total-RP/Total-RP-3/wiki/Mary-Sue-Protocol) and [moonshyne.org/msp](https://moonshyne.org/msp/):

- **MSP** is a shared field protocol so TRP3, MRP, XRP, FlagRSP-family addons can **exchange profiles**.  
- Exchange is **peer-to-peer / on demand** when you target or request a profile — not a guild-wide authoritative ledger.  
- Fields include identity slices (e.g. eye color `AE`, tooltip blob `TT`, addon versions `VA`, protocol version `VP`) — payload is **user-authored prose + metadata**.  
- Classic constraint noted by MRP docs: **no cross-faction / cross-realm** profile exchange without Blizzard friendship bridges ([MyRolePlay Classic FAQ](https://legacy-wow.com/classic-addons/myroleplay-classic/)). Matches Beef’s per-guild, per-realm ladder isolation (Dreamscythe Alliance vs Doomhowl Horde).

**Blizzard Watch caution (2019):** Classic policy changes that killed CHANNEL-based social tooling could affect RP addons that relied on channels ([Blizzard Watch](https://blizzardwatch.com/2019/08/26/roleplaying-in-wow-classic-guide)). BeefNet already commits to **GUILD** (and allowed group channels) — stay there.

### Comparison to BeefNet

| MSP / TRP3 | BeefNet |
|------------|---------|
| Request profile ↔ receive fields | `SYNC_REQUEST` / `SYNC_STATE`, `RANK_COMMIT` |
| Anyone can publish their own sheet | Only Officer+ publishes official ranks |
| Cache of met players | Cache of official records + revisions |
| Interop across competing addons | Single protocol `COB` — no need for MSP |
| Prose-heavy payloads | Keep colon-delimited small commits |

**Steal:** on-demand / login pull, local directory cache, version fields (`VA`/`VP` ≈ `HELLO`).  
**Avoid:** shipping a second identity stack that fights TRP3; Beef titles should **display beside** RP names, not replace MSP.

---

## 5. Announce patterns

TRP3’s spectacle is mostly **ambient**:

- Chat name/color/emote formatting  
- Tooltip identity on mouseover  
- Map dots for nearby roleplayers  

There is no “officer announces promotion” equivalent. Presence is continuous, not event-gated.

**Beef implication:** don’t invent continuous chat restyling for ranks in V1. Prefer **event announces** (Gargul/Attune style) + **directory/ladder browse** (TRP3 style). Chat coloring of “Beef Knight” in every message is high-friction and ElvUI/Prat-conflict prone (TRP3 changelogs themselves show ongoing chat/UI conflict fixes on WowInterface).

---

## 6. Steal / avoid (RP directory–specific)

### Steal

1. **Directory as first-class surface** — a scrollable list of people + identity, not only a tree of systems. Beef Ladder ≈ guild directory filtered by title.  
2. **Tooltip / highlight for local player** — know yourself in the list (spec already wants local highlight).  
3. **Privacy / consent toggles** (map hide, mature warn) → pattern for officer announce opt-out and future confession feeds.  
4. **Modular UI** — don’t force ceremonial dashboard into V1.  
5. **Titles as social chrome** — short, readable, brandable strings.  
6. **Interop humility** — if a player runs TRP3, Beef should not overwrite their RP name display aggressively.

### Avoid

1. **Self-serve prestige titles** for seat-limited ranks (Council/Prophet).  
2. **Prose-heavy MSP-sized payloads** on `GUILD` for ladder sync.  
3. **Map scan / proximity social radar** in V1 (scope creep; streamer doxxing vibes).  
4. **Chat restyle wars** with other UI addons.  
5. **Assuming RP-realm density** — Dreamscythe/Doomhowl guilds may not be RP realms; directory still works as *guild* directory.

---

## 7. Relevance score for Beef

| Spec need | TRP3 / MRP coverage |
|-----------|---------------------|
| Social identity / titles | **Strong** |
| Browseable directory | **Strong** |
| Officer gate / anti-cheat | None (by design) |
| Guild announce spectacle | Weak (ambient chat) |
| Durable official ledger | Weak (personal cache) |
| Soft dependency / interop | Strong (MSP among RP addons) |

**Bottom line:** Steal the **directory metaphor and title presentation**. Keep Beef’s **officer-authored official state** — the opposite of MSP’s self-publish model — and keep payloads small.
