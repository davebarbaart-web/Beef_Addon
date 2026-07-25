# Native vs Gimmicky — Thematic Addon Patterns

**Last updated:** 2026-07-25  
**Derived from:** CurseForge author pitches for Immersion, Dialogue UI, TRP3, Listener, Emote Splitter, Glass; Parallel deep research (`trun_91f36069f09644808c0fb7f501b69f6b`); community immersion/RP discussions.

---

## 1. Working definition

| | **Feels native** | **Feels gimmicky** |
|---|------------------|--------------------|
| Job | Extends a Blizzard job players already do (quest text, tooltip, chat, gossip) | Invents a parallel “app” for the same information |
| Attention | Quiet until requested; skippable | Always-on overlays, SFX on every social event |
| Chrome | Blizzard fonts/borders as baseline; theme via *content* | Competing art direction that fights ElvUI *and* default UI |
| Structure | Modular / opt-in pieces | Monolith that forces the full fantasy |
| Ceremony | Player- and officer-staged via chat, macros, short announcements | Forced cutscenes / scripted puppetry of the player |
| Compatibility | Coexists with dialogue skins and TRP | Hooks exclusive frames; breaks other immersion addons |

Immersion’s own marketing encodes the gold standard: immersive **without any extra fuss**, full experience when wanted, **not in the way when you’re in a hurry**.

---

## 2. Signature patterns of native-feeling tools

### A. Same frame, more capable

- **Dialogue UI / Immersion:** still quest & gossip — better pacing, camera, hotkeys.
- **TRP3:** identity in tooltips / target actions / chat names — not a permanent billboard.
- **Listener:** chat tabs + mouseover Snooper.
- **Emote Splitter:** the edit box you already type into.
- **Glass:** the chat frame, decluttered.

**Rule:** If removing the addon leaves players unsure *where* the information went, you invented a new habitat. Prefer enriching an existing habitat.

### B. Blizzard chrome as baseline; theme in the words

Native stacks reuse Friz/default UI fonts and familiar panel grammar. Thematic punch comes from **titles, liturgy lines, rank names, scripture** — not from neon custom HUDs. Church of Beef brand (gothic / Scarlet / absurd holy steak) can eventually own textures, but V1 correctly allows plain Classic frames with media fallbacks (spec §10).

### C. Peripheral until requested

| Pattern | Example |
|---------|---------|
| Mouseover reveal | Listener Snooper; TRP tooltip |
| Tab, not window | Listener filters |
| Toast, then gone | WeakAuras-like ceremony flashes (short) |
| Officer-gated noise | Spec’s promotion announce from approving officer only |

Gimmick tax: always-visible faith meters, looping holy SFX, stacked WA spam, translucent panels that stream poorly.

### D. Modularity over monoliths

TRP3 base vs Extended; Listener’s “Snooper only” beginner path; Immersion’s skip-ahead; RPEngine’s rulesets (even when the product itself is large). Players opt into ceremony depth.

### E. Authoring > skinning (2024–2026 trend)

TRP3 Extended and event suites invest in **player-authored** documents, items, campaigns. Skin-only novelty ages into “another floating window.” Lasting thematic guilds ship **shareable content** (scripture, ranks, rites) on boring reliable chrome.

### F. Enable staging; don’t puppet the avatar

Emote Splitter + macros let players stage long ceremonies. Addons that auto-move, auto-emote, or auto-speak for spectacle cross into gimmick *and* into Church of Beef’s hard technical bans (no automation of gameplay).

---

## 3. Social spectacle patterns (religion / sports / entertainment)

These map cleanly to Church of Beef’s “religious-sports-entertainment” identity without requiring Retail-only tech.

### Religious / ceremonial

| Pattern | Native implementation | Gimmicky failure |
|---------|----------------------|------------------|
| Rank / title | Short title on ladder + guild chat line + toast | Animated papal hat model permanently attached to UI |
| Liturgy | Gossip/dialogue-like paging or chat liturgy | Full-screen modal that blocks bag/map |
| Scripture | One-line footer (V1) → documents later | Endless scrolling lore pane in combat UI |
| Excommunication | Officer demote + public chat (on-brand) | Fake “banish” VFX that taints secure frames |

### Sports / competition (Beef Gora)

| Pattern | Native | Gimmicky |
|---------|--------|----------|
| Outcome | Thin record result → standing (spec) | Esports broadcast overlay with fake cameras |
| Ladder | Tabbed list of titles | Health-bar-style “standing bars” like raid frames |
| Crowd | Guild chat reactions / emotes | Forced /cheer macros on all online members |

### Entertainment / stream

| Pattern | Native | Gimmicky |
|---------|--------|----------|
| Moment | One high-contrast toast + guild announce | Five simultaneous WA popups |
| Readability | Large rank type, opaque panel | Glass-thin gray text on cathedral art |
| Camera | Optional (Dialogue UI lesson); off by default for officers rushing | Mandatory zoom every promotion |

---

## 4. Heuristic checklist (use before adding a surface)

1. **Which Blizzard job am I extending?** (If none — justify hard.)
2. **Can a player without the addon still witness the spectacle?** (Spec already requires guild-chat promotion lines for this reason.)
3. **Is it quiet until needed?**
4. **Can it be skipped or dismissed in one gesture?**
5. **Does it coexist with Immersion/DialogueUI/TRP3/ElvUI?**
6. **Is the fantasy in the copy/ranks, or only in the chrome?**
7. **Would this still work with missing media?** (Spec: fallback fonts/textures.)

If three or more answers are “no,” the feature is trending gimmicky.

---

## 5. Anti-patterns specific to “funny religion” addons

- **Joke density in chrome:** meme fonts, steak particle rain, constant moo SFX — funny once, then uninstall.
- **Parallel authority systems:** TRP title *and* Beef rank *and* custom nameplate title fighting each other. Pick channels: Beef owns guild institutional rank; TRP owns personal RP prose.
- **Ceremony as raid HUD:** center-screen meters for “holiness” during trash pulls.
- **Monolith “Church OS”:** absorbing DM stats, crafting economies, dialogue skins, and ladder into one addon. Ship the institution; let the immersion stack stay plural.
