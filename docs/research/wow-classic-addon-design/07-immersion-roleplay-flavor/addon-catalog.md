# Immersion / RP / Flavor Addon Catalog

**Last updated:** 2026-07-25  
**Client focus:** Patterns that transfer to **TBC Classic Anniversary**. Always re-check CurseForge “Game Versions” before relying on a specific build — forks and Interface numbers drift.

---

## 1. Dialogue & quest immersion

### Dialogue UI (Peterodox)

- **Job:** Replace/restyle quest & dialogue presentation; optional **camera motion**; keyboard/gamepad selection; adjustable fonts; copy dialogue text; book-style themes (light/dark, parchment/metal).
- **Author pitch:** “Quest Dialogue UI with built-in camera control and gamepad support.”
- **Why it feels native:** Still *quest/gossip dialogue* — same job as Blizzard’s frame — with cinematic camera as an opt-out enhancement, not a second app.
- **Classic note:** Heavily associated with modern/Retail immersion stacks; related author work includes Narcissus Classic. Confirm Anniversary Interface before recommending as a guild “must install.”
- **Beef relevance:** V2 ceremony/confession presentation metaphor — *reuse dialogue pacing and camera restraint*, not a hard dependency. Liturgy should feel like reading a quest, not opening a dashboard.
- **Source:** [CurseForge — Dialogue UI](https://www.curseforge.com/wow/addons/dialogueui)

### Immersion (MunkDev)

- **Job:** Replacement for dated quest & gossip frames; talking-head-inspired presentation; one-button / click-to-advance; customizable hotkeys including number keys for options.
- **Author pitch:** “An immersive questing experience, without any extra fuss.” Explicitly: immersive when you want it, out of the way when you don’t.
- **Why it feels native:** Enriches the existing *talk-to-NPC* loop; skip-friendly so immersion isn’t a tax on busy players.
- **Classic presence:** Long-standing Classic ports (e.g. WowInterface Immersion Classic listings).
- **Beef relevance:** Ceremony UX should be **skip-friendly for busy officers** and **readable for stream moments** — Immersion’s dual speed is the right product instinct for thin V1 ceremony stubs.
- **Sources:** [CurseForge — Immersion](https://www.curseforge.com/wow/addons/immersion), [WowInterface — Immersion Classic](https://www.wowinterface.com/downloads/info24931-ImmersionClassic.html)

### Immersion ↔ Dialogue UI bridge

- **Job:** Compatibility glue when players mix both dialogue stacks.
- **Beef relevance:** Reminder that *flavor stacks collide*. Church of Beef should not fight Immersion/DialogueUI for strata or exclusive gossip hooks in V1.
- **Source:** [CurseForge — Immersion and Dialogue UI Bridge](https://www.curseforge.com/wow/addons/immersion-and-dialogue-ui-bridge)

---

## 2. Character identity & world authoring

### Total RP 3 (TRP3)

- **Job:** Modular RP profiles (name, description, images, companions), directory of met characters, optional map location, IC/OOC/AFK helpers, chat formatting (OOC/emote coloring, RP names), MSP interoperability with MyRolePlay / XRP, NPC speech helpers.
- **Author pitch:** MRP-like simplicity without sacrificing customization freedom; **modular** — enable only what you need.
- **Why it feels native:** Identity rides on **tooltips / target interactions / chat**, not a permanent custom HUD. Other players discover flavor by hovering and chatting — gestures they already use.
- **Beef relevance:** **Coexistence layer**, not a V1 dependency. Guild ranks (Fresh Beef → Beef Prophet) are officer-committed social state; TRP titles/descriptions are personal RP identity. Do not fork a second profile system. Optional later: document recommended TRP “About” lines for church lore.
- **Sources:** [CurseForge — Total RP 3](https://www.curseforge.com/wow/addons/total-rp-3), [GitHub — Total-RP/Total-RP-3](https://github.com/Total-RP/Total-RP-3)

### Total RP 3: Extended

- **Job:** Authoring — items, readable documents, campaigns/quests, custom NPCs/dialogs, inventory inspect, stashes, trade with permission levels.
- **Why it matters for themed guilds:** Scripture, tickets, relics, and “holy texts” are **content**, not chrome. Extended is how RP communities ship shareable lore objects.
- **Beef relevance:** Strong **V2+** inspiration for scripture/confessions *as documents*, not for V1 ladder UI. V1 already separates machine canon (`Data/Ranks.lua`) from prose (`docs/canon/`).
- **Source:** [CurseForge — Total RP 3: Extended](https://www.curseforge.com/wow/addons/total-rp-3-extended)

### MyRolePlay / lighter MSP tools

- **Job:** Minimal character cards for players who find TRP3 heavy.
- **Beef relevance:** Confirms demand for *small surface* identity — Beef’s ladder title in chat/toasts should stay short and readable even without TRP.

---

## 3. Chat, emotes, and crowd listening

### Listener (+ Listener Classic)

- **Job:** Per-player chat filtering; **Snooper** shows recent chat/emotes from the unit under mouse; notifications when someone emotes at you; designed for crowded RP / hosted scenarios.
- **Author pitch:** Make it easy to track each player when a lot is going on; beginners can use Snooper only.
- **Why it feels native:** Extends **chat tabs / mouseover**, not a second social network UI. Attention is on-demand.
- **Beef relevance:** Ceremony and Gora nights get noisy. Spec’s guild-chat promotion line is the V1 broadcast; Listener-like *focus* is a player-side habit, not something Beef must reimplement. Avoid always-on “beef chat HUD.”
- **Sources:** [CurseForge — Listener](https://www.curseforge.com/wow/addons/listener), [Listener Classic](https://www.curseforge.com/wow/addons/listener-classic)

### Emote Splitter [Classic]

- **Job:** Remove chatbox length friction; split long paste into verified sequential sends (handles throttling); undo; communities chatbox support.
- **Why it feels native:** Extends the **existing chat edit box** — zero new spectacle chrome.
- **Beef relevance:** Officers writing ceremony blurbs / scripture paste benefit from this ecosystem tool. Beef itself should keep **announcements short** (spec §10: one throttled guild-chat line) so non-addon members and stream VODs stay readable without Splitter.
- **Source:** [CurseForge — Emote Splitter Classic](https://www.curseforge.com/wow/addons/emote-splitter-classic)

### Emote Menu / emote wheels

- **Job:** Browse/search built-in emotes; click-to-perform (and Classic ports of radial wheels).
- **Beef relevance:** Low priority. Theatrical Gora reactions can stay slash-emote culture; don’t ship an emote encyclopedia in V1.

### Glass (chat skin)

- **Job:** Immersive minimal chat — fades, hidden tabs until hover, no always-visible background; “didn’t look like it was designed in 2004.”
- **Why players like it:** Atmosphere + declutter for screenshots/streams.
- **Risk:** Chat-skin addons are fragile across client eras; coexistence notes (disable ElvUI chat module, etc.).
- **Beef relevance:** Do **not** skin guild chat globally. Design Beef frames to coexist with Glass/ElvUI chat. Stream readability still wants high-contrast **toasts and rank titles**, not translucent gray-on-gray.
- **Source:** [CurseForge — Glass](https://www.curseforge.com/wow/addons/glass)

---

## 4. Event / DM systems (contrast class)

### RPEngine (and RPToolkit predecessor)

- **Job:** Full DM event suite — stats/spells, turn-based events, crafting/economy, rulesets, LFRP map tags, party chat sync (“Chanter”), customisable datasets.
- **Why it’s a contrast, not a template for V1:** Ambitious, ruleset-heavy, closer to a tabletop OS inside WoW. Downloads are niche vs TRP3/Immersion. Powerful for dedicated RP guilds; easy to become **monolithic and gimmicky** if Church of Beef tried to absorb it.
- **Beef relevance:** Steal **modularity / ruleset mindset** (tunable thresholds, officer authority) — reject combat-stat / turn-order scope. Spec already forbids playing the game for the user.
- **Source:** [CurseForge — RPEngine](https://www.curseforge.com/wow/addons/rpengine)

---

## 5. Atmospheric UI adjacent (not pure RP)

| Addon / pattern | Role | Beef takeaway |
|-----------------|------|----------------|
| Narcissus Classic | Immersive character pane / in-game studio | Flavor photography ≠ ladder UX |
| ClassicUI / “simple clean UI” packs | Nostalgia or declutter stacks | Brand chrome later; V1 plain frames OK (spec §10) |
| Chatter / Prat-class chat enhancers | Timestamps, links, scroll | Extend chat; don’t replace social systems |

---

## 6. Stack mental model (for guild packs)

Typical immersion/RP player stack (composition varies by realm):

```
Identity:     TRP3 (± Extended) or MRP
Dialogue:     Immersion and/or Dialogue UI (± bridge)
Chat focus:   Listener / Snooper
Long prose:   Emote Splitter
Atmosphere:   Glass or ElvUI chat (pick one chat skinner)
Events (opt): RPEngine / TRP Extended campaigns
```

Church of Beef should sit beside this stack as **guild institutional state** (ranks, standing, officer gates, thin ceremony/Gora), not as a seventh dialogue skinner or a TRP competitor.
