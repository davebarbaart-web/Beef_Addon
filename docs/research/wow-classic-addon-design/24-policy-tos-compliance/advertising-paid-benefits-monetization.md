# Advertising, paid benefits, and monetization

**Track:** `24-policy-tos-compliance`  
**Last updated:** 2026-07-25  
**Purpose:** Map Blizzard’s free-addon / no-ads / no-in-game-donation rules and EULA commercial bans onto Church of Beef distribution choices.

## UI Add-On Development Policy (money & ads)

From the official policy ([US](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534), [EU](https://eu.forums.blizzard.com/en/wow/t/wow-user-interface-add-on-development-policy/1642), [2010 archive](https://web.archive.org/web/20101124173826/http://www.worldofwarcraft.com/policy/ui.html)):

| Rule | Hard line |
|------|-----------|
| **1 — Free of charge** | No pay-to-download, no premium feature tier, no required monetary compensation to access the addon; no charging for **services related to the add-on** |
| **4 — No advertisements** | Addon must not advertise goods or services |
| **5 — No in-game donation solicits** | Donation asks OK on website/distribution site only — **not in the game** |

Community enforcement discussions repeatedly quote rule 1 when authors ship a non-functional free shell and gate the useful content behind Patreon/subscription ([Blizzard TOS on Addon](https://us.forums.blizzard.com/en/wow/t/blizzard-tos-on-addon/797705); [Addon for money — EU](https://eu.forums.blizzard.com/en/wow/t/addon-for-money-violation-of-eula/212887)). Players also argue that paid “database packages” that the addon requires are still “services related to the add-on” under rule 1.

**Voluntary donations outside the game** are the accepted cultural workaround: DBM-style “donate on the website if you want” matches rule 5’s placement guidance ([community comments in the MDT thread](https://us.forums.blizzard.com/en/wow/t/blizzard-tos-on-addon/797705)).

## EULA Prohibited Commercial Uses (broader than addons)

From the [Blizzard EULA](https://www.blizzard.com/en-us/legal/fba4d00f-c7e4-4883-b8b9-1b4500a402ea/blizzard-end-user-license-agreement), Prohibited Commercial Uses include (paraphrased):

1. Playing at commercial establishments (with limited exceptions)
2. Gathering in-game currency/items/resources for sale **outside** the Platform/Games
3. Performing in-game services (boosting, power-leveling, etc.) **in exchange for payment**
4. Communicating or facilitating commercial advertisement, solicitation, or offer **through or within** the Platform
5. Organizing, promoting, facilitating, or participating in events involving **wagering** on game outcomes (or any aspect of Blizzard’s Games) without authorization — whether or not local law calls it gambling

Also relevant: sale of Service Provided Content / virtual currency for real money outside authorized channels is prohibited (Transfers / related clauses in the same EULA).

## “Paid benefits” matrix for guild tools

| Pattern | Policy risk | Notes |
|---------|-------------|-------|
| Free addon; all ranks/features available to guildmates | **Compliant** | Default for Church of Beef |
| Tip jar / Patreon CTA inside `/beef` UI or guild chat spam | **Violates UI policy rules 4–5** | Keep support links on GitHub/CurseForge page only |
| “Prophet” title sold for USD / PayPal | **High — RMT / commercial exploitation** | Real-money sale of in-game social status + possible boosting-adjacent framing |
| Rank sold for large amounts of **in-game gold** coordinated with real-money side deals | **High — RMT adjacency** | Even “gold only” sales can be RMT laundering; don’t productize it |
| Officer appoints ranks for free; standing from play | **Compliant / intended** | Spec §4, §6, §7 |
| Stream giveaway of a ceremonial title (no payment) | **Usually fine** | Social spectacle; avoid framing as gambling prize with entry fees |
| Paid external “Beef Premium” Discord that unlocks addon modules | **Violates rule 1** (“services related to the add-on” / premium features) | Do not gate addon code or data behind payment |
| CurseForge/Overwolf ads on the **website/client**, not inside the addon | **Outside addon code** | Distribution platforms monetize; addon itself still must not embed ads (rule 4) |

## Advertising inside the addon (rule 4 + EULA)

Do **not** put in Church of Beef:

- Sponsor banners (“brought to you by …”)
- Affiliate links in tooltip/chat
- Cross-promo for unrelated Discord servers framed as ads
- In-game storefront frames

Guild-internal announcements (“ceremony at 8”) are social coordination, not commercial advertising — keep them free of product plugs.

EULA separately bans commercial advertisement/solicitation **through or within** the Platform ([US EULA](https://www.blizzard.com/en-us/legal/fba4d00f-c7e4-4883-b8b9-1b4500a402ea/blizzard-end-user-license-agreement)). An addon that spams gold-selling websites would violate both UI policy and EULA.

## Practical Church of Beef monetization stance

Recommended compliance posture for V1+ (product, not legal advice):

1. **Ship 100% free** — full ladder, Gora, ceremonies, BeefNet; no premium SKU.
2. **No in-game donation UI** — if support is wanted later, link only on the distribution/readme website.
3. **No real-money rank economy** — titles are social fiction, not a store.
4. **No wagering product** — see [guild-point-systems-gray-areas.md](guild-point-systems-gray-areas.md) for Gora / deferred favor-meter caution.
5. **Open, readable Lua** — satisfies UI policy rule 2 and community trust.

## Gray-area note (ecosystem, not endorsement)

Some popular guide/route tools have historically charged for content packs. Community threads treat that as contested under rule 1 ([MDT discussion](https://us.forums.blizzard.com/en/wow/t/blizzard-tos-on-addon/797705)). Church of Beef should **not** copy that pattern: the project is a comedy guild social layer, not a paid guide business, and the written policy is clear.