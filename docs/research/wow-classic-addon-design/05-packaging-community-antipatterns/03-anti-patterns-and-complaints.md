# Common Player Complaints & Design Anti-Patterns

**Last updated:** 2026-07-25  
**Focus:** Patterns that get Classic guild/social/streamer addons muted, uninstalled, or dunked on.

Evidence mix: Blizzard forums (primary quotes), storefront/docs (behavioral norms), community search aggregates. Where a claim is synthesized from many threads, it is labeled **[sentiment]**.

---

## 1. Failure modes that dominate complaints

### 1.1 Minimap button pollution

**Primary example:** Classic forum thread *[Minimap cluttered addon help](https://us.forums.blizzard.com/en/wow/t/minimap-cluttered-addon-help/304044)* — players report addon icons filling the minimap; replies point at consolidators (e.g. Minimap Button Frame on CurseForge).

**[sentiment]** Still a standing Classic complaint in 2024–2026 UI discussions and short-form “clean your minimap” content.

| Anti-pattern | Better pattern |
|--------------|----------------|
| Always-on unique minimap button with no hide option | LibDBIcon-style button **plus** hide setting; rely on `/beef` |
| Multiple icons per addon | One entry point |
| Assuming everyone uses a collector | Document slash command in Notes + description |

### 1.2 Chat & invite spam (especially guild-adjacent)

**Primary example (Nov 2025):** *[As long as you’re breaking addons, break the guild spam addon](https://us.forums.blizzard.com/en/wow/t/as-long-as-youre-breaking-addons-break-the-guild-spam-addon/2196741)* — players rage at whisper/invite spam from guild-recruitment tooling; “useful to know which guilds to avoid” but still called out as toxic UX. Related demand for filters shows up across Classic chat-spam content.

| Anti-pattern | Better pattern for Beef |
|--------------|-------------------------|
| Auto-whisper / auto-invite | Never for V1 |
| Guild/Officer channel spam for every point tick | Silent standing updates; **officer-gated** public moments |
| Announcements on by default | Opt-in ceremony/broadcast settings |
| Writing to channels without player-visible affordance | Explicit button / confirm for anything that hits chat |

Design-spec alignment: promotions are **suggestions** until Officer+ approve — do not celebrate every threshold cross in `/g`.

### 1.3 Visual density / center-screen theft

**[sentiment]** Clean-UI and Hardcore communities treat wall-of-WeakAuras and multi-addon dashboards as self-sabotage; “default UI looks better” hot takes are cultural markers ([example thread](https://www.reddit.com/r/classicwow/comments/1hbv7lq/hot_take_default_ui_looks_better_than_90_of_your/)).

| Anti-pattern | Better pattern |
|--------------|----------------|
| Persistent center HUD for social status | Edge ladder; brief toast |
| Always-expanded lore / scripture panels in V1 | Footer placeholder only (per spec deferrals) |
| Combat-blocking modals | Queue UI until out of combat when possible |

### 1.4 Performance / “addons ruin FPS”

**[sentiment]** Ongoing YouTube/forum genre blaming specific addon stacks; retail Addon CPU panels increased player sensitivity to heavy `OnUpdate` / aura engines. Social addons that poll every frame for no reason inherit that distrust.

| Anti-pattern | Better pattern |
|--------------|----------------|
| Per-frame polling for ladder scores | Event / login / sync-driven updates |
| Sync storms on every zone change | Throttled BeefNet (see performance track when present) |
| Loading heavy media for unused ceremony theater | Defer art-heavy phases |

### 1.5 Trust & ToS-adjacent fear (Classic-specific)

**[sentiment]** Classic communities are harsher about anything that smells like automation. Design spec already forbids bots/protected actions — packaging copy must **say so** plainly so players don’t bounce.

| Anti-pattern | Better pattern |
|--------------|----------------|
| Vague “enhances gameplay” marketing | “Social rank ladder — does not cast, move, or target for you” |
| Hidden network traffic | Document BeefNet as sync among users |

---

## 2. Anti-pattern table (guild / streamer addons)

| Anti-pattern | Failure mode | Mitigation for Church of Beef |
|--------------|--------------|-------------------------------|
| Minimap sprawl | Clean-UI uninstall | One LibDBIcon + hide; `/beef` first-class |
| Chat respeaking | Guild mute / rage | No auto `/g`; officer approve path |
| Invite/whisper bots | Account reports, brand damage | Out of scope forever |
| Color-only rank meaning | Colorblind exclusion | Title text + order + optional icon |
| Center combat overlays | “Addon ruined my pull” | Edge UI; toast budget |
| Default sound spam | Instant disable | Sounds off by default |
| Silent Officer/Guild writes | Consent violation | Explicit action only |
| Unbounded roster SavedVariables | Bloat / corruption fear | Bound caches; per-character DB as spec’d |
| Fake “must have for raiding” listing | Wrong audience, bad reviews | Categories: Guild / Roleplay |
| Screenshot of cluttered ElvUI desktop | Discovery mismatch | Clean ladder-only shots |

---

## 3. Streamer / guild product expectations

Church of Beef is a **streamer-event** guild addon (spec §1). That raises the bar:

| Expectation | Why |
|-------------|-----|
| Stream-safe defaults | Alts, pending notes, officer whispers must not dump onto stream overlays |
| Spectacle is opt-in | Ceremonies are content; constant chrome is not |
| Officer agency visible | Community hates opaque automation; **human approve/reject** is a feature, not a bug |
| Comedy without harassment tools | Excommunication/demotion is on-brand; mass-ping tools are not |

**Note on “streamer mode APIs”:** deep-research text mentions hooks named like `RegisterForStreamerMode`. Treat that as **product intent language**, not a confirmed Classic API — implement as an addon setting (“Streamer quiet mode”) unless a real client API is verified on Anniversary.

---

## 4. Combat meters vs social tools (expectation gap)

| Aspect | Combat meter (Details!, etc.) | Guild/social (Beef) |
|--------|-------------------------------|---------------------|
| Density | High, columns, segments | Low, few fields |
| Update rate | Fight-event heavy | On action / sync |
| Screen real estate | Negotiated center-lower | Edge |
| Chat rights | Usually none | Dangerous if abused |
| Success metric | Accuracy & clarity under stress | Stay loved by the guild |

Copying Details! visual density for a rank ladder would be an anti-pattern even if technically pretty.

---

## 5. Complaint-driven acceptance tests (V1)

Use as qualitative gates before wider guild install:

1. Fresh install adds **at most one** minimap affordance; can be hidden.
2. Playing a full dungeon with guildmates generates **zero** unsolicited `/g` lines from the addon.
3. Crossing a standing threshold creates a **local** suggestion, not a public parade, until an officer acts.
4. Ladder readable with UI Colorblind Mode + each filter at mid/high strength.
5. Description/screenshots match actual on-screen density (no bait).
