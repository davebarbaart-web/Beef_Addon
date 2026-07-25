# Parallel deep research — Immersion / RP / Flavor (raw)
**Run:** `trun_91f36069f09644808c0fb7f501b69f6b`  
**Processor:** pro-fast  
**Note:** Machine synthesis. Prefer CurseForge/GitHub primary pages cited in annotated-references.md for product decisions.

## Core RP addons

**Total RP 3 (TRP3)** — SolanyaStormbreaker · Apache 2.0 · 6.3 M DLs · supported on Retail, Classic, TBC Classic, MoP Classic. Marketed as *"the best role-playing add-on"* and the simplest MRP-style tool that *"doesn't sacrifice your freedom when defining characters."* Profiles carry names, descriptions, images, custom characteristics, and per-character state. This is the canonical "character card" pattern: identity shows in tooltip mouseovers and inspect frames rather than in a custom HUD.

**MyRolePlay (MRP)** — the lighter-weight predecessor many Classic roleplayers still use; one character profile at a time, minimal UI surface area.

**Listener** (tmgpub) · MIT · 244 K DLs · *"Tracks chat per player. Includes a feature to mouseover players and see their chat only."* Two tabs (Listener/Snooper) so the targeted player's chat filters into its own window. Solves a very specific RP problem: drowning in cross-conversation noise.

**Emote Splitter** (tmgpub) · *"Unlocks your chatbox and lets you paste or type unlimited text into it."* Splits long-form prose into multi-paragraph `/e` blocks — the single most-cited pain point in Classic/TBC RP.

**Emote Menu** (updated 2024) — searchable list of every in-game emote with a tooltip preview and click-to-perform.

**RP Assist** — a *"roleplay companion addon that helps you craft in-character responses during live RP interactions."* Template prompts + suggestion lists.

**Dialogue UI** (Peterodox) · 6.8 M DLs · *"Quest Dialogue UI with built-in camera control and gamepad support."* Re-skins the Blizzard quest-text panel and (importantly for SoD/TBC Classic) makes it camera-friendly for sofa play. Last updated mid-2026.

**Immersion** (MunkDev) · 8.2 M DLs · *"An immersive questing experience, without any extra fuss."* A lighter alternative to Questie + QuestFrame-style overlays; integrates with the existing Blizzard dialog rather than replacing it.

**Total RP 3: Extended (TRP3 Extended)** — companion to TRP3: campaigns, quests, NPCs, in-game documents, books, signs. Authoring world content.

**Cross RP** — bridge addon so TRP3 and MRP profiles can read each other.

**Chatter** — chat enhancer: scroll-on-mouse-wheel, clickable item/spell/talent links, timestamps, copy/paste.

**RP Assist · Tongues · Emote Menu · Elephant** — auxiliary utilities that fill gaps: language barriers, macro emote lists, background chat logging.

**RPEngine (RPEngine / RPE)** — "next-generation roleplay event system" — *a comprehensive suite of tools to bring a new and immersive feel to your DM events.* DM tools, event broadcasts, stats, crafting. This is the closest existing reference for guild-event spectacle.

**Simply RP – Looking for RP (LFRP)** — *just install and start discovering RP around you; broadcast your RP availability and location in a controlled, immersive way.*

---

## Native vs gimmicky

Native-feeling addons in the Blizzard addon ecosystem share four signature traits. They are the design checklist any new RP addon — including a religion/sports/entertainment guild addon — should follow.

### A. Replace or re-skin an existing Blizzard frame; do not invent a new panel.

- **Dialogue UI** doesn't add a popup. It re-styles the *quest text* panel and adds camera control. The information still lives where players expect to find it.
- **Immersion** keeps the quest dialog in place and just enriches it.
- **Total RP 3** writes RP data into *the existing* tooltip and inspect-frame rather than a separate window. The player reads the description by hovering an existing unit-frame element — the same gesture used for everything else in the game.
- **Listener/Snooper** uses a second chat tab on the existing chat window instead of opening a new frame.
- **Chatter** extends the chat frame rather than replacing it.

Pattern: **native feel = "the existing frame, only more capable."** Gimmicky feel = "a new floating window the player has to manage."

### B. Use Blizzard's chrome, fonts, and animations as the visual baseline.

Native addons reuse the Blizzard font (Friz Quadrata / Blizzard's default UI font), the same border-style textures, and the same color tokens the client uses. Thematic customisation comes from *content*, not from competing with the client's art direction. Immersion's tagline — *"without any extra fuss"* — encodes this principle.

### C. Stay out of the player's peripheral attention until requested.

Listener sits as a tab. Snooper only activates on mouseover. TRP3 surfaces its information inside tooltips already opened by the player. Emote Splitter only intervenes when a message would otherwise hit the chat-byte cap.

Gimmicky addons open always-on panels, play SFX on every chat event, or scatter tooltips anywhere. Anything that takes more pixels than Blizzard's own UI is a tax the player pays continuously.

### D. Modularity over monoliths.

TRP3 split TRP2's bag of features into a base (profile + characteristics) plus the optional Extended module (campaigns, documents, NPC dialogues). RPEngine markets itself as "a suite of tools" with separable pieces. The Listener/Snooper duality inside Listener is the same pattern at smaller scale. Players can opt into the ceremony without opting into everything.

---

## Authoring patterns

These are the reusable building blocks. A religion/sports/entertainment guild addon can mix and match them rather than starting from zero.

| Pattern | Used by | Effect |
|---|---|---|
| Tooltip enrichment (data injected into existing unit-frame tooltip) | TRP3, MRP, Cross RP | Identity information appears where the player already looks |
| Profile persistence with import/export and *broadcast-on-demand* | TRP3, MRP, RPEngine | Players can move alts freely and re-claim profiles |
| Campaign/Quest/Document authoring layer | TRP3 Extended | Lets guild leaders create their own content |
| Style-able tooltip/character-card templates | TRP3 Extended, GHI | Themed content becomes shareable |
| Multi-language codec / translation pipeline | Cross-RP, Tongues | Lets a French player and an English player see each other |
| Frame sharing via Addon-comm channel | Cross-RP | Cross-version interoperability |
| Macro integration (slash, #show, /click) | Emote Splitter, Emote Menu | Player types once, output is multi-paragraph |
| Chat-frame channels and tabs | Chatter, Listener | Native scrollback vs. floating windows |
| Camera control tied to NPC dialogue | Dialogue UI | "Talk to NPC" becomes cinematic |
| Authoring tools (text + image + link) for hand-written books, signs, letters, contracts | TRP3 Extended, GHI | Guild-themed content the player can read in-world |
| Templated response generators | RP Assist | Boilerplate + player customization |
| Per-character state (mounted, AFK, in combat, status flags) | TRP3, MRP, RPEngine | Identity state propagates without forcing roleplay actions |

---

## Mapping to themed guild addons

This is the *social spectacle* layer the question asks about. A guild-themed addon needs the same native-feel rules plus a few additions specific to organized community events.

### Religious / ceremonial guilds

- **Use existing tooltips for titles, ranks, faith.** A TRP3-style "About" entry with the deity, sect, and rank works for *character identity*; supplement it with a guild-only field like *Pantheon* and *Lay-Clergy Status* (Neophyte, Acolyte, Cleric, Patriarch). Hide those fields from non-members.
- **Reuse the dialogue frame for liturgy.** Dialogue UI / Immersion show how quest text can become ceremony. A "service" addon can plug into the Blizzard gossip frame to present a sermon, litany, or sacrament using Blizzard's own "Continue/End" button.
- **Ritual objects as inventory items.** TRP3 Extended already lets authors create books, contracts, relics, signs. A religion addon can ship a "Blessed Item" or "Relic" template and let priests consecrate items in-world.
- **Titles in tooltips are free ceremony.** Custom title + name (High Priestess of the Silver Flame) appearing in the existing tooltip is "free" worldbuilding that costs nothing to render.

### Sports / competitive guilds

- **Scoreboards in tooltips.** A tooltip that says "Tournament Score: 14-3, currently 1st in the Bracket" reuses the same channel TRP3 uses. Bracket data can travel through the Addon-channel.
- **Bracket/ranking overlays tied to chat tabs.** Listener's tab pattern works for "match channels," "ladder," and "spectator chat."
- **Macro-driven emote sequences for ceremonial plays.** Emote Splitter's "unlimited text" trick lets a player choreograph a multi-paragraph ceremonial volley for the championship point. An addon can supply the macro as a single slash command.
- **Title / banner ceremony.** TRP3 "About" + a custom banner flag for the team. Total RP 3 Extended's items module lets authors attach a heraldic image.

### Entertainment / performance guilds

- **Stage lighting via camera.** Dialogue UI's camera work is the cleanest "stage" mechanic already in the game. A performance addon can hook the same event and produce cinematic angles for a tavern show.
- **Macro-driven multi-character "lines."** Emote Splitter + a curated emote dictionary is what every bard addon effectively does.
- **Audience reactions.** A "clap/boo/cheer" macro that prints an emote line into a dedicated chat channel acts as crowd noise in RP concerts. Listener's tab/chat split is the right pattern.
- **Tip jar / instruments as TRP3 Extended items.** "Send a tip" can be a TRP3-style in-game item the player hands to the performer.

### Shared design rules for any guild-themed addon

1. **Identity lives in tooltips and inspect frames.** Anything that requires a separate window to read identity information is gimmicky.
2. **State lives in tooltips and chat tabs.** Anything that requires a new floating window is gimmicky.
3. **Ceremonies ride Blizzard's gossip/dialog frame.** Dialogue UI and Immersion show the right pattern. Custom popups break immersion.
4. **Documents/contracts/books use TRP3 Extended's authoring layer** rather than a custom UI. Players already know how to read a TRP3 book in-world.
5. **Spectacle should be commanded by macros or slash commands**, not by addons that interrupt play. *Macro-driven spectacle = native.* *Always-on overlay = gimmicky.*
6. **Theming must reuse Blizzard's art.** Fonts, borders, colors from the default UI. Custom art is fine for items/banners but should not invade the HUD chrome.
7. **Status propagation uses Addon-channel broadcasts.** Cross-version interop (Retail/Classic/TBC/SoD) requires this; tools that lock into one client feel gimmicky the moment Blizzard shifts versions.
8. **Authoring layer (campaigns, documents, items, NPCs) is what scales.** TRP3 Extended's design lesson is that player-authored content is the moat — not the UI skin.

---

## Concrete recommendations

A religion/sports/entertainment guild addon for Classic Era / TBC / SoD should:

1. **Build on TRP3 + TRP3 Extended as the identity/doc backbone.** Don't author a parallel system — extend TRP3 fields or use Addon-channel broadcast to share state with other TRP3 users.
2. **Use Listener/Snooper-style chat filtering** for guild-vs-public channels; reuse Blizzard's chat-frame tabs.
3. **Adopt Emote Splitter's unlimited-text pattern** so ceremony scripts can be paste-and-send. Pre-bundle a library of ceremonial macros.
4. **Use Dialogue UI / Immersion's "native frame" philosophy** for any in-world text. A confession booth, a sports bracket, or a stage prompt should reuse the gossip/dialog frame, never a custom popup.
5. **Lean on TRP3 Extended's campaigns, documents, and item system** to author liturgy, rulebooks, programs, and tickets — shareable as files between players.
6. **Reuse the Blizzard chat channel system** for guild vs. faction vs. RP separation; don't invent a custom chat protocol.
7. **For SoD/TBC specific flair** (runes, rune abilities, seasonal content), follow Immersion's lead — small targeted improvements that respect Blizzard's frames.
8. **For accessibility** (gamepad, camera, focus): mirror Dialogue UI's approach. RP is a focus activity; respect it.

---

## Quick reference by job

| Need | Best add-on | Why it feels native |
|---|---|---|
| Character profile & tooltips | Total RP 3 / MRP | Tooltips, not new windows |
| Cross-addon profile compat | Cross RP | Uses Addon-channel broadcast |
| Long-form RP posts | Emote Splitter | Extends the chat box; no new UI |
| Filtering chat to one person | Listener (Snooper) | Adds a tab; reuses chat frame |
| Quests / dialogue immersion | Immersion, Dialogue UI | Re-skins Blizzard's frame, no replacement |
| Live event broadcasting | RPEngine | Tooltips + chat + tab, modular |
| Finding RP partners | Simply RP – LFRP | Discovery layer, not intrusive HUD |
| Authoring campaigns/docs | TRP3 Extended | Standard authoring files |
| Macro-driven ceremony | Emote Splitter + macros | One slash, full sequence |
| Chat cleanup | Chatter | Reuses existing chat frame |

---

## Trend forecast 2024–2026

- **Multi-version support** is now table stakes. TRP3 ships a build for Retail, Classic Era, TBC Classic, MoP Classic and even has a SoD/TBC pipeline. Addons that don't ship across versions feel gimmicky to half the playerbase.
- **Authoring layers > UI skins.** TRP3 Extended and RPEngine both invest in player-authored content (campaigns, NPCs, books, events). The "skin-only" addon era is ending.
- **Cross-client compatibility** (Console port, controller) drives the "Dialogue UI" pattern: native frames with camera control, not external tools.
- **Spectacle via macros, not addons.** The Emote Splitter + macro approach is dominant for arena/ceremony/stage events. Addons that try to *stage* events with custom animations feel gimmicky; addons that *enable* the player to stage events via macros feel native.
- **Module suites are winning.** RPEngine markets itself as a "suite of tools," TRP3 is base + extended + add-ons. Players expect opt-in modular design.

---

## Native vs gimmicky heuristic summary

**Native feel:**
- Extends an existing Blizzard frame
- Reuses Blizzard typography and chrome
- Information surfaces in tooltips and chat tabs
- Modular, opt-in
- Authoring-first, UI-second
- Multi-version support
- Macro/slash-driven

**Gimmicky feel:**
- New floating window for static info
- Custom fonts replacing Blizzard typography
- Always-on overlays
- Monolithic single-purpose addon
- Prescriptive scripted experience
- Single-version locked
- Forced cutscenes or scripted sequences

For a religion/sports/entertainment guild addon targeting Classic Era, TBC Classic, or Season of Discovery in 2024–2026, the design north star is simple: **build on TRP3 + Emote Splitter + Listener + Dialogue UI/Immersion + TRP3 Extended**, and use Blizzard's own frames and chat system as the canvas. Ceremonies, brackets, services, and performances should be **content** (authored via TRP3 Extended), not chrome (new panels). The ceremony happens *inside* the existing game, with macros and chat tabs — not in front of it.
