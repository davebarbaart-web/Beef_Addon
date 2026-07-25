# Implications for Church of Beef

**Last updated:** 2026-07-25  
**Maps to:** [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)  
**Sources:** This track’s [addon-catalog.md](addon-catalog.md), [native-vs-gimmicky.md](native-vs-gimmicky.md), Parallel deep research + CurseForge primaries in [`.raw/`](.raw/).

---

## 1. Positioning in the immersion stack

Church of Beef is **guild institutional software** (ranks, standing, officer gates, thin Gora/ceremony), not a dialogue skinner and not an MSP profile host.

| Layer | Who owns it | Beef role |
|-------|-------------|-----------|
| Quest/gossip immersion | Immersion / Dialogue UI | Coexist; don’t steal gossip |
| Personal RP identity | TRP3 / MRP | Coexist; optional lore guidance later |
| Chat focus / long emotes | Listener / Emote Splitter | Coexist; keep Beef announces short |
| Chat atmosphere | Glass / ElvUI chat | Coexist; high-contrast Beef toasts |
| Guild rank institution | **Church of Beef** | Primary V1 job |
| DM / tabletop OS | RPEngine-class | Out of scope |

Deep-research suggestions to “build on TRP3 as backbone” are **rejected for V1**. BeefNet + officer-committed ranks are a different trust model than MSP profile exchange. Treat TRP as optional player tooling beside the church, not a dependency.

---

## 2. What V1 already gets right (reinforce)

From the immersion/RP ecosystem lens, the approved spec already follows native patterns:

1. **Guild-chat announcement on promotion/demotion** — spectacle visible to members *without* the addon (spec §10). Same philosophy as TRP’s “identity in shared chat,” applied to institutional events.
2. **Toasts for suggestion / rank / credit** — short-lived attention, then gone (Immersion’s “not in the way”).
3. **Thin ceremony & Gora stubs** — score fuel without ceremonial OS (avoids RPEngine-scale scope creep).
4. **Officer as anti-cheat / liturgy authority** — mirrors how RP events trust a DM/host; standing is testimony, commit is sacrament.
5. **Plain Classic frames + media fallback** — Immersion/TRP modularity lesson: don’t require cathedral art for V1 to function.
6. **One-line scripture footer placeholder** — Extended-style lore deferred; no gimmick lore browser yet.

**Social success criterion** (spec §13.11): a promotion that gets a visible guild reaction. That is an immersion win metric, not a DPS win metric.

---

## 3. Steal these patterns (by phase)

### V1 (now)

| Pattern | From | Apply as |
|---------|------|----------|
| Skip-friendly ceremony | Immersion | Officer start/close must be fast; no mandatory cutscene |
| Short institutional announce | Listener/chat culture + spec | Keep copy punchy: title + name; no Bee Movie liturgy in guild chat |
| Tooltip/list clarity for identity | TRP3 | Ladder rows: title first, standing second; stream-readable |
| Quiet until `/beef` or toast | Whole stack | No always-on faith HUD |
| Modular tone | TRP3 modules | Ladder / My Standing / Officer tabs; hide Officer if not Officer+ |
| Coexistence | Dialogue bridge lesson | Unique frame names, no global chat skinning |

### V2 (ceremonial dashboard — deferred)

| Pattern | From | Apply as |
|---------|------|----------|
| Dialogue pacing | Dialogue UI / Immersion | Confessions / announcements wall as paged “readings,” not meters |
| Optional camera | Dialogue UI | Off by default; streamer opt-in only |
| Documents as content | TRP3 Extended | Scripture/confessions as readable text objects or feeds — authoring > chrome |
| Mouseover focus | Listener Snooper | Spotlight states on demand, not permanent nameplate mods |
| Macro-enabled staging | Emote Splitter culture | Publish suggested `/e` liturgy packs in docs — don’t auto-emote |

### V3 (Gora theater — deferred)

| Pattern | From | Apply as |
|---------|------|----------|
| Bracket as list/tooltip | TRP / Listener tabs | Match history as roster-like UI, not esports broadcast |
| Crowd noise via chat | Emote culture | Encourage reactions; never mass-forced emotes |
| Favor meter (theatrical) | WeakAuras caution | One centerpiece moment, then clear — avoid WA spam aesthetic |

---

## 4. Explicit non-goals (from this research)

- Do not depend on Dialogue UI, Immersion, TRP3, Listener, Glass, or RPEngine.
- Do not reimplement MSP profiles, long-emote splitting, or chat skinning.
- Do not auto-perform emotes, move the camera without opt-in, or script player actions.
- Do not make standing look like raid-frame health bars or Details meters.
- Do not ship meme SFX/fonts as the default V1 experience (brand pass can be ornate later without becoming a joke UI).

---

## 5. Copy & ceremony craft (flavor without gimmick)

Immersion addons teach that **words carry the fantasy**. For Beef:

- Rank titles are already strong canon (Fresh Beef → Beef Prophet). Lead with them in UI and chat.
- Promotion line tone: institutional + slightly absurd, one breath long.
- Demotion (“excommunication”) is on-brand *content* when officer-driven and announced — matches native “public social consequence” better than a custom VFX.
- Council seats / Prophet uniqueness (spec §4.1) are scarcity theater — the same instinct as unique RP titles, implemented as governance, not as a grind meter.

---

## 6. Classic Anniversary practical notes

- Prefer patterns proven on Classic forks (Immersion Classic listings, Emote Splitter Classic, Listener Classic, TRP3 multi-flavor support) when advising players.
- Re-verify Interface / game-version tags before any “recommended companion addons” guild guide.
- Separate Dreamscythe Alliance / Doomhowl Horde ladders (spec §5) — immersion tools are per-character installs; church state stays per-guild, no cross-realm fantasy sync.

---

## 7. Top insights (executive)

1. **Native = extend Blizzard habitats; gimmicky = invent parallel apps.** Beef’s habitat is guild chat + a small tabbed frame + toasts.
2. **Spectacle for people without the addon** is the immersion stack’s real social lesson — keep the guild-chat announce sacred.
3. **Sit beside TRP/Immersion/Listener; don’t absorb them.** Institutional ranks ≠ RP profiles ≠ dialogue skins.
4. **Authoring beats chrome** for lasting religion fantasy — V2 scripture/confessions as content; V1 ranks as the only hard chrome.
5. **Skip-friendly ceremony** (Immersion) matches officer reality and stream pacing better than forced cinematic religion.
6. **Quiet default, loud moments** — Listener/TRP attention model: mouseover and events, not always-on holiness HUD.
7. **Reject RPEngine-scale scope** for Church of Beef; borrow modularity/authority ideas only.
