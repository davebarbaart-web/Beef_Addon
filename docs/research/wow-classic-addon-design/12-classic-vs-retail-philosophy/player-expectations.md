# Player Expectation Differences: Classic vs Retail

**Last updated:** 2026-07-25  
**Related:** [nostalgia-vs-qol.md](nostalgia-vs-qol.md), [design-implications-church-of-beef.md](design-implications-church-of-beef.md)

---

## 1. Two products, two evaluation rubrics

Retail and Classic share a brand name and, increasingly, client code — but players judge UI by different success criteria.

| Dimension | Retail expectation | Classic expectation |
|-----------|--------------------|---------------------|
| Default UI | Competitive baseline; Edit Mode expected | Nostalgic “home” look; stock UI is a virtue for many |
| Addon role | Fill gaps Blizzard left; often combat HUD | Optional layer; purity debates still live |
| Friction | Bad UX to be removed | Often *part of the product* (LFG by hand, vague quests) |
| Information density | High — meters, plates, WA walls common | Contested — dense HUD can feel “Retail” |
| Social discovery | Tools and matchmaking | Cities, chat, guilds, standing in the world |
| Change tolerance | Continuous UI iteration accepted | Each Blizzard UI touch is a referendum |

Blizzard’s own Wrath-era pivot named the Classic pillar set: protect **social proximity**, keep things **approachable and familiar**, and treat **the world as the main character** — not the HUD as the main character ([MMORPG.com summary of the 2022 developer update](https://www.mmorpg.com/news/blizzard-devblog-dives-into-the-philosophies-behind-upcoming-wrath-of-the-lich-king-classic-changes-2000125375); original post titled *Developer Update: A Look at What’s Ahead for Wrath of the Lich King Classic*).

---

## 2. What “good UI” means in each culture

### Retail

- Layout is a solved problem via **Edit Mode** ([Wowhead Edit Mode guide](https://www.wowhead.com/guide/ui/ui-and-hud-edit-mode-guide)).
- Players expect snap grids, account-saved layouts, and moving inactive panels.
- Combat readability and throughput tooling are first-class.
- “Looks modern” is rarely an insult.

### Classic

- “Looks like 2006–07” is a *feature* for a large cohort — forum posts against forced modern UI are blunt: players say they would stop playing if modern UI were the only option ([US forums thread on Retail UI editor for Classic+](https://us.forums.blizzard.com/en/wow/t/one-retail-change-i-would-genuinely-dig-for-classic-is-the-modern-ui-editor/2137436)).
- Customization is often delegated to **addons** (ElvUI, Bartender, MoveAnything-class tools) rather than Blizzard chrome — and those addons are allowed to look modern *because the player opted in*.
- Community friction (forming groups in city chat, asking for directions) is romanticized even when individuals personally use Questie.

**Church of Beef relevance:** The addon must feel *opt-in spectacle inside Classic*, not “Retail social app skinned into TBC.” Officer approval and guild-chat announcements already match Classic’s social-proximity instinct better than silent account-wide ladders.

---

## 3. Era splits inside “Classic”

Expectations are not one blob:

| Era / mode | UI / addon posture (typical) |
|------------|------------------------------|
| Vanilla Classic (2019 ethos) | Minimum viable footprint; meters debated as toxic |
| TBC Classic | Functional parity with era tooling (arena frames, dual-spec QoL) more accepted |
| Wrath Classic | “Some changes” era; wider QoL + achievement culture |
| Season of Discovery | Experimental; SoD-specific helpers expected |
| Anniversary / Fresh | Strong “true start” nostalgia; still heavy Questie use in practice |
| Hardcore | Strictest *ethical* bar around automation and unfair info; bags/helpers still used ([HC forums discuss addons as allowed with install-path caveats](https://us.forums.blizzard.com/en/wow/t/no-addons/1658472)) |

Church of Beef V1 targets **TBC Classic Anniversary** — closer to “functional parity + spectacle” than Hardcore purity, but Brand Hardcore streams still touch the guild’s identity (spec §3.3). Design for TBC Anniversary defaults; don’t ship Hardcore-banned automation metaphors.

---

## 4. Shared-code reality vs player fantasy

As of mid-2026, Classic Era / Anniversary share retail-adjacent client bones. Blizzard can and does ship modern UI pieces (Edit Mode on TBC Anniversary PTR notes; nameplate/raid-frame modernization) that players experience as aesthetic betrayal even when framed as QoL ([Warcraft Tavern on Edit Mode for TBC Anniversary](https://www.warcrafttavern.com/tbc/news/edit-mode-is-coming-to-the-ui-for-tbc-classic-anniversary-edition/); [Blizzard Watch on July 2026 UI modernization](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)).

**Implication for addon authors:** Players may hate Blizzard’s modern chrome *and* run ElvUI or Dragonflight UI Classic. Consistency of *your* brand matters more than matching the default — but default-looking frames still read as “safer Classic” for a comedy church addon than neon Retail panels.

---

## 5. Expectation checklist for a new Classic social addon

Players will ask, consciously or not:

1. Does this remove a social moment (auto-invite, auto-path, matchmaking)? → Red flag.
2. Does this play the game for me (rotation, targeting, movement)? → Forbidden for CoB (spec §2) and culturally radioactive.
3. Does this look like Midnight/Dragonflight HUD by default? → Polarizing; keep optional.
4. Does this reduce bookkeeping tedium (bags, standing, roster clarity)? → Usually fine.
5. Can I ignore it and still play with the guild? → Required for Classic guild tools.

CoB’s hybrid ladder (suggest → officer approve) already aligns with item 1 and 5.
