# 07 — Guild-chat spectacle UX (promotion announcements)

**Lane:** Agent polish vision (UX / product craft)  
**Last updated:** 2026-07-26  
**Audience:** Agents polishing announce copy, Officer-tab opt-out, throttle, and guild-night spectacle  
**Product truth:** [V1 design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10, §13.11, §15  
**Deep cousins (do not restate):** API/throttle [track 72](../wow-classic-addon-design/72-guild-chat-announce-api/), words [track 32](../wow-classic-addon-design/32-microcopy-tone-voice/), ownership patterns [track 13](../wow-classic-addon-design/13-cousin-addon-teardowns/), streamer receive filters [track 61](../wow-classic-addon-design/61-streamer-mode-privacy/)  
**Live module:** `addon/ChurchOfBeef/UI/Announce.lua`

---

## Executive take

Church of Beef’s V1 spectacle is **one plain guild-chat line per institutional rank outcome**, spoken by the **approving Officer+ client only**. That is the cheapest stream-readable ceremony: members without the addon still see it, and the flock can react in `/g`.

The failure mode is not “too quiet” alone — it is also **addon-shaped spam**: every peer echoing the same promote, multi-line liturgy, per-point drip, or auto-spam timers that make guilds install silencers. Satisfying announcements feel like **rare public ledger entries**; annoying ones feel like **interrupt bots**.

---

## What players already hate (anti-spectacle)

| Irritation | Evidence | Beef implication |
|------------|----------|------------------|
| Combat/interrupt bots dumping every ability into group chat | [Blizzard forums — addons that spam in group chat](https://us.forums.blizzard.com/en/wow/t/addons-that-spam-in-group-chat/1245769) | Never announce scoring drips, Gora rolls, or suggestion creates |
| Guild login / achievement noise → silencers | [Icy Veins — Guild Spam Silencer](https://www.icy-veins.com/wow/news/tired-of-guild-spam-heres-how-the-guild-spam-silencer-addon-brings-peace-to-your-chat); [Guild Spam Fix](https://www.wowinterface.com/downloads/info26852-GuildSpamFix.html) | Compete with *ceremony*, not with login spam; keep cadence human |
| Attune-style achievement announce without a high enough threshold | [r/classicwow — guild achievement announcements](https://www.reddit.com/r/classicwow/comments/131zulf/guild_achievement_announcements_added/) | Announce **rank commits**, not standing ticks; Attune raised min points to cut spam |
| Scheduled “promote my stream” auto-spam tools | [CurseForge — Spam auto-timer addon](https://www.curseforge.com/wow/addons/spam) | **Avoid this product shape entirely** — Beef is event-gated, not a timer |

**Rule of thumb:** if a line could fire while nobody is celebrating a person, it is spam, not spectacle.

---

## Cousin patterns that already balance spectacle vs spam

Successful Classic social tools put **authority + rarity** in front of volume:

| Pattern | Source | Steal |
|---------|--------|-------|
| One client speaks (ML loot → raid/party chat) | [Gargul — Announcing Loot in Chat](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat); [Gargul on CurseForge](https://www.curseforge.com/wow/addons/gargul) | Approving Officer+ ≈ ML; peers with the addon stay silent in `/g` |
| Award announce **default on**; consideration fanout **default off** | [RCLootCouncil Options / Features](https://rclootcouncil.com/wiki/Features-Overview); track [72 single-announcer](../wow-classic-addon-design/72-guild-chat-announce-api/single-announcer-patterns.md) | Celebrate the **decision**, not the deliberation |
| Celebrate completion, not every drip | Attune complete-announce + community threshold lore ([Reddit](https://www.reddit.com/r/classicwow/comments/131zulf/guild_achievement_announcements_added/)) | Rank commit = complete; standing grant = toast only |
| Opt-out easy; default on so spectacle lives | Gargul “Announce loot to chat”; RCL “Announce Awards” | Spec-locked Officer checkbox; default **ON** |

---

## Design principles (satisfying, not annoying)

### 1. Rare public ledger, not ambient HUD

Announce **institutional outcomes** only: promote, demote, Council seat, Prophet bestowal.  
Do **not** announce: suggestion create/reject, standing corrections within a rank, Gora/ceremony credits, login sync heals, BeefNet noise.

Severity ladder (keep it):

| Layer | Channel | Cadence |
|-------|---------|---------|
| Receipt | Local toast | Per personal event |
| Ceremony | `/g` one line | Per rank commit |
| Theater | V2 dashboard / optional SFX | Later; default off |

### 2. One speaker, one line, one beat

- **Speaker:** client that authored the successful commit (Officer+), never peers applying `RANK_COMMIT`.  
- **Channel:** `GUILD` — not `/o` (spectacle must reach the flock and stream overlays).  
- **Shape:** one sentence; liturgical deadpan; ~80–140 characters design target; hard cap 255 ([SendChatMessage](https://wowwiki-archive.fandom.com/wiki/API_SendChatMessage)).  
- **No second punchline** after the period (no emoji walls, scripture paragraphs, protocol leaks).

### 3. Two throttle layers (do not conflate)

| Layer | Job | V1 default |
|-------|-----|------------|
| **A. CPS / CTL** | Avoid disconnects; share pipe with BeefNet | ChatThrottleLib-style pacing when embedded ([ChatThrottleLib](https://www.curseforge.com/wow/addons/chatthrottlelib); [Wowpedia](https://wowpedia.fandom.com/wiki/ChatThrottleLib)) |
| **B. Product cadence** | Avoid guild fatigue | One line per commit; text+time dedup; officer opt-out |

Layer A is almost never the bottleneck for a single short `/g` line. Layer B is the UX problem. Live code already refuses repeats of the same text within **10s** (`Announce.lua` `REPEAT_WINDOW`).

Do **not** invent a global “one promote per minute” for a quiet night of human-paced officer work — spam risk is **N clients**, not **N slow promotes**.

### 4. Officer gate is ownership, not `/o`

Three different “officer” ideas ([track 72 officer-only](../wow-classic-addon-design/72-guild-chat-announce-api/officer-only-send.md)):

1. **Approve gate** — Officer+ may commit ranks.  
2. **Announce ownership** — that same approving client may `/g`.  
3. **`OFFICER` chat** — never used for V1 spectacle.

Additional send guards: `IsInGuild`, announce opt-in (default on), and preferably `guildchat_speak` (silent no-op + local warning if muted). Opt-out silences **chat only** — commit and toasts still fire.

Confirm dialogs (demote / Prophet / Council) stay **procedural** and name whether guild chat will fire; comedy lives in the announce line, not in the confirm body ([officer vs spectacle registers](../wow-classic-addon-design/32-microcopy-tone-voice/officer-serious-vs-player-spectacle.md)).

### 5. Stream skim test (pass all three)

1. Can a viewer who never installed the addon parse **who** and **new title** in under two seconds?  
2. Does the brand (“The Church”) appear without needing a logo?  
3. Would five of these in one raid night still feel ceremonial rather than spammy?

If (3) fails, tighten copy or officer pacing — do not add more lines.

### 6. Privacy must not kill the ceremony

Third-party StreamerMode may mask names in default UI/chat; it does **not** mask `/beef`, and V1 must **never** silently disable officer guild announce (spec §15). Privacy presets (V1.1) may quiet toasts / mask flock names in frames; the public ledger remains an officer choice via the checkbox.

Ignore lists and spam filters can hide lines for some receivers ([track 61](../wow-classic-addon-design/61-streamer-mode-privacy/)) — that is a receive-side failure mode, not a reason to shout louder or fan out from every peer.

### 7. Dual register forever

| Surface | Tone |
|---------|------|
| Officer tab / confirms / errors | Sincere procedural |
| Guild announce / titles / optional footer | Liturgical deadpan comedy |

Winning Classic tools sound like Attune / Gargul / RCL in **officer chrome**; Beef’s joke is sincere pageantry in **public chat**, not meme dumps every toast ([track 32](../wow-classic-addon-design/32-microcopy-tone-voice/)).

---

## Message templates (V1 bank)

Canonical structure ([announce-line craft](../wow-classic-addon-design/32-microcopy-tone-voice/announce-line-craft.md)):

```text
[Institution] [recognition verb] [Name], [elevation verb] to [Title].
```

### Shipped / locked copy (`Announce.lua`)

| Event | Template |
|-------|----------|
| Promote (1–5) | `The Church recognizes {name}, elevated to {title}.` |
| Demote | `The Church records the fall of {name}, returned to {title}.` |
| Council | `The Church seats {name} upon the {title}.` |
| Prophet | `The Church anoints {name} as {title}.` |

### Craft rules

- Name = exact character name; title = exact canon title from `Data/Ranks.lua`.  
- Prefer *recognizes / elevated / records the fall / seats / anoints* — avoid *lol*, *yeets*, ALL CAPS, emoji.  
- Reserve nuclear “excommunicates” wording for optional high-drama demotions later; overuse dulls it.  
- **No** guild announce on reject, within-rank standing fix, or sync heal.  
- Do not put standing totals, revision numbers, or “addon” in the line.

### Officer opt-out label (locked)

Procedural, not meme: **“Announce promotions to guild chat”** → `ChurchOfBeefDB.ui.announce`, default ON.

---

## Rate-limit & anti-spam recipe (product)

| Rule | Default | Why |
|------|---------|-----|
| Max `/g` lines per successful rank commit | **1** | Spec §10 |
| Who may send | Approving Officer+ client only | Gargul ML ownership |
| Peer / sync / replay | Never re-announce | Prevent stampede |
| Same-text repeat window | **10s** (live) | Double-click / UI retry |
| Dedup key (ideal) | commit id / revision+name+rank | Stronger than text alone |
| Opt-out | Per-officer SV, default on | Easy silence without killing ladder |
| Multi-line liturgy / raid warning | Forbidden in V1 | Fatigue + filter risk |
| Artificial “max 1 / minute” | No (unless playtest demands) | Human officer pace is enough |
| CTL priority | NORMAL (when CTL embedded) | Do not jump the sync queue with ALERT |

Pipeline (happy path): validate → apply `RANK_COMMIT` + BeefNet → **then** optional `/g` → local toasts independent of opt-out. Detail: [beef-v1-announce-pipeline](../wow-classic-addon-design/72-guild-chat-announce-api/beef-v1-announce-pipeline.md).

---

## Streamer / social-guild ops notes

- **Batch promotions thoughtfully.** Five Cooked→Knight lines in ten minutes after a dungeon can feel great; five lines for standing typos feel like spam — officers should reject noise before it reaches `/g`.  
- **Time the click for attention.** Approving during a pull when guild chat is raid-call chaos wastes the moment; between pulls or at the summon stone is when reactions happen (§13.11).  
- **Spectacle Watcher role** on guild night: did an unprompted reaction follow the line? ([playtest checklist](../../phases/guild-night-playtest.md)).  
- **Do not** use auto-spam timers or LFG-channel promotion tools as inspiration for Beef.  
- Roster-backed ladder amendment may defer commit-announcer until roster-diff announce is designed — do not leave a checkbox that claims to announce if send is disabled ([roster-backed ladder spec](../../superpowers/specs/2026-07-25-roster-backed-ladder-design.md)).

---

## Anti-patterns (checklist)

- [ ] Every Beef client echoes the same promote on `RANK_COMMIT` receive  
- [ ] Announce from suggestion create / reject / login sync  
- [ ] Multi-line “scripture then name” walls  
- [ ] Raid warning / yell for social ranks  
- [ ] Protocol or version strings in guild chat  
- [ ] Default-off announce (kills §13.11)  
- [ ] Meme emoji dumps that fail the stream skim test  
- [ ] Silent kill of announce via “streamer privacy” without officer consent  
- [ ] Dead Officer checkbox that claims to announce but never sends  

---

## Acceptance hooks

| Check | Pass signal |
|-------|-------------|
| Spec §13.11 | Real guild night: one promote → one `/g` line → visible human reaction |
| No peer echo | Two clients online; only approver’s name as chat sender |
| Opt-out | Uncheck → commit works, no `/g` |
| Throttle | Double-approve / retry → still one line per successful commit |
| Skim | Overlay-sized chat: who + title readable in ≤2s |

Offline harness can prove wiring and liturgy strings; **spectacle quality is a playtest pass**.

---

## Relationship to other research

| Need | Go here |
|------|---------|
| SendChatMessage, CTL CPS, `guildchat_speak` | [72-guild-chat-announce-api](../wow-classic-addon-design/72-guild-chat-announce-api/) |
| Exact words / tone registers | [32-microcopy-tone-voice](../wow-classic-addon-design/32-microcopy-tone-voice/) |
| Gargul / RCL / Attune ownership UX | [13-cousin-addon-teardowns](../wow-classic-addon-design/13-cousin-addon-teardowns/) |
| Ignore / StreamerMode / filters | [61-streamer-mode-privacy](../wow-classic-addon-design/61-streamer-mode-privacy/) |
| Locked product decisions | Spec §15 · [74 glossary](../wow-classic-addon-design/74-v1-decision-glossary/) |

This note owns **polish principles** for satisfying vs annoying announcements. It does not fork rank numbers, BeefNet wire format, or API matrices.

---

## Sources

**In-repo**

- [Church of Beef V1 design](../../superpowers/specs/2026-07-25-church-of-beef-design.md)
- [Roster-backed ladder amendment](../../superpowers/specs/2026-07-25-roster-backed-ladder-design.md)
- [Track 72 — guild-chat announce API](../wow-classic-addon-design/72-guild-chat-announce-api/)
- [Track 32 — announce-line craft](../wow-classic-addon-design/32-microcopy-tone-voice/announce-line-craft.md)
- [Track 13 — steal/avoid](../wow-classic-addon-design/13-cousin-addon-teardowns/steal-avoid-for-beef.md)
- `addon/ChurchOfBeef/UI/Announce.lua`

**External**

- [Gargul — Announcing Loot in Chat](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat)
- [Gargul — CurseForge](https://www.curseforge.com/wow/addons/gargul)
- [RCLootCouncil — Features Overview](https://rclootcouncil.com/wiki/Features-Overview)
- [ChatThrottleLib — CurseForge](https://www.curseforge.com/wow/addons/chatthrottlelib)
- [ChatThrottleLib — Wowpedia](https://wowpedia.fandom.com/wiki/ChatThrottleLib)
- [SendChatMessage — Wowwiki archive](https://wowwiki-archive.fandom.com/wiki/API_SendChatMessage)
- [Blizzard forums — addons that spam in group chat](https://us.forums.blizzard.com/en/wow/t/addons-that-spam-in-group-chat/1245769) (May 2022)
- [Icy Veins — Guild Spam Silencer](https://www.icy-veins.com/wow/news/tired-of-guild-spam-heres-how-the-guild-spam-silencer-addon-brings-peace-to-your-chat) (Sep 2024)
- [Guild Spam Fix — WoWInterface](https://www.wowinterface.com/downloads/info26852-GuildSpamFix.html)
- [r/classicwow — guild achievement announcements](https://www.reddit.com/r/classicwow/comments/131zulf/guild_achievement_announcements_added/)
- [CurseForge — Spam (auto-timer) addon](https://www.curseforge.com/wow/addons/spam) (counter-example)

Search dumps: `.raw/chat-spectacle-ux.json`, `.raw/chat-spectacle-cousins.json`.
