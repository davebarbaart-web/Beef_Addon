# Track 24 — Blizzard addon policy, ToS, and compliance boundaries

**Track id:** `24-policy-tos-compliance`  
**Last updated:** 2026-07-25  
**Sole focus:** What Classic UI addons **may / may not** do under Blizzard policy and the Blizzard EULA/Code of Conduct — automation, advertising, data exfiltration, paid benefits, forbidden APIs, and gray areas for guild point systems — with implications for Church of Beef.  
**Out of scope:** BeefNet throttle mechanics (track 14), roster/officer API edges (track 16), secure-frame *implementation* patterns (touched only as policy barriers), packaging/distribution culture (track 05), cousin-addon UX tear-downs (track 13). No addon code or commits in this folder.

## Product truth (from V1 spec)

| Locked stance | Source |
|---------------|--------|
| No combat automation; no external process controlling gameplay | Design spec §2 |
| May announce, track, record, display, coordinate, sync allowed info | Design spec §2 |
| Standings are advisory; **officer approval is the anti-cheat** | Design spec §6.3 |
| No Retail-only APIs; no combat automation (success criteria) | Design spec §13.10 |
| Free social guild tool; no paywalled features contemplated | Design intent + this track |

Source: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §2, §6.3, §13.

## Index

| Note | Covers |
|------|--------|
| [ui-addon-development-policy.md](ui-addon-development-policy.md) | Official 8-rule UI Add-On Development Policy (free, visible code, no ads, no in-game donation asks, …) |
| [eula-tos-automation.md](eula-tos-automation.md) | EULA cheating/bots/hacks, Code of Conduct automation, third-party client-modifying software |
| [advertising-paid-benefits-monetization.md](advertising-paid-benefits-monetization.md) | No ads, no premium/paywalled features, donation placement rules, RMT adjacency |
| [data-exfiltration-forbidden-apis.md](data-exfiltration-forbidden-apis.md) | Lua sandbox networking limits, data-mining clause, secure/protected barriers |
| [guild-point-systems-gray-areas.md](guild-point-systems-gray-areas.md) | DKP/EPGP/loot-council analogues; wagering; real-money ranks; social vs unfair advantage |
| [church-of-beef-implications.md](church-of-beef-implications.md) | Explicit do / don't / watch for Church of Beef V1–V2 |
| [annotated-urls.md](annotated-urls.md) | Annotated primary policy URLs |

## Top insights for Beef (read this first)

1. **Church of Beef’s hard “no automation” line is not optional product taste — it is alignment with Blizzard’s EULA + CoC + secure API model.** Spec §2 matches [Blizzard EULA](https://www.blizzard.com/en-us/legal/fba4d00f-c7e4-4883-b8b9-1b4500a402ea/blizzard-end-user-license-agreement) bot/cheat bans and the [In-Game Code of Conduct](https://us.battle.net/support/en/article/42673) ban on third-party automation. Classic uses the modern secure-execution model, so Lua addons cannot cast/target/decide combat for the player ([Secure Execution and Tainting](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)).

2. **Legitimate UI addons are allowed; client-modifying “third-party software” is not.** Blizzard’s Aug 2025 reminder targets software that modifies the game client / bypasses security — not CurseForge-style Lua addons ([Prohibitions on Third-party Software](https://us.forums.blizzard.com/en/wow/t/prohibitions-on-third-party-software/2142972); [Wowhead summary](https://www.wowhead.com/news/blizzard-reminds-players-that-third-party-software-is-prohibited-378029)). Stay in the Lua/XML sandbox; never ship an external controller.

3. **The UI Add-On Development Policy still governs distribution ethics:** free of charge, no premium features, no in-game ads, no in-game donation solicits, open/visible code, no realm/player harm, abide by ToU/EULA, Blizzard can disable functionality ([US policy thread](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534); [EU mirror](https://eu.forums.blizzard.com/en/wow/t/wow-user-interface-add-on-development-policy/1642); [2010 archive](https://web.archive.org/web/20101124173826/http://www.worldofwarcraft.com/policy/ui.html)).

4. **Guild point / rank ladders are a gray *social* space, not a forbidden API space** — as long as points are cosmetic/social, officer-gated, not sold for real money, and not used as wagering infrastructure. Spec §6.3 (officer as anti-cheat) is the compliance-honest design.

5. **Deferred “stream betting / favor meter” metaphors (spec §3.2) need careful framing.** EULA Prohibited Commercial Uses bans organizing/participating in events involving **wagering** on game outcomes without authorization. Keep Gora theatrical and unpaid; do not wire real-money stakes or “odds” productization.

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Blizzard Legal, Blizzard Support, and official forum “blue” posts over community speculation. Policy text is paraphrased with citations; re-check live EULA/policy pages before any commercial or distribution decision.