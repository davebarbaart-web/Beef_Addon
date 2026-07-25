# Annotated URLs — Blizzard policy & compliance

**Track:** `24-policy-tos-compliance`  
**Last updated:** 2026-07-25  
**Purpose:** Primary citations for this track. Prefer these over listicles when making compliance claims. Re-fetch before any monetization or distribution decision — legal pages move.

---

## A. UI Add-On Development Policy (must-read)

| URL | Annotation |
|-----|------------|
| https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534 | **Canonical US sticky** (Kaivax). Full 8 rules + 2009 music/copyright note + grace-period history. Best live citation for “addons must be free / no ads / no in-game donation asks.” |
| https://eu.forums.blizzard.com/en/wow/t/wow-user-interface-add-on-development-policy/1642 | **EU mirror** of the same 8 rules. Use when citing for EU guilds/players. |
| https://web.archive.org/web/20101124173826/http://www.worldofwarcraft.com/policy/ui.html | **Archived official HTML** of `worldofwarcraft.com/policy/ui.html` (2010-11-24). Clean verbatim copy when forum UI is noisy. Confirms rules 1–8 wording. |

---

## B. Blizzard EULA & Legal hub

| URL | Annotation |
|-----|------------|
| https://www.blizzard.com/en-us/legal/fba4d00f-c7e4-4883-b8b9-1b4500a402ea/blizzard-end-user-license-agreement | **US EULA** — cheating/bots/hacks, Prohibited Commercial Uses (RMT, in-Platform ads, **wagering**), data mining, unauthorized connections. Primary automation/commercial citation. |
| https://www.blizzard.com/en-gb/legal/08b946df-660a-40e4-a072-1fbde65173b1/blizzard-end-user-license-agreement | **GB/EU-style EULA** — same themes; useful alternate extract; includes Code of Conduct incorporation and consent-to-monitor language. |
| https://www.blizzard.com/en-us/legal | **Blizzard Legal index** — jump-off for Privacy Policy, Terms of Sale, Developer API ToU, UGC policies. Not WoW-addon-specific but the map of binding docs. |

*Note: Blizzard sometimes rotates legal document UUIDs in URLs. If a link 404s, start from the Legal index.*

---

## C. Code of Conduct & enforcement reminders

| URL | Annotation |
|-----|------------|
| https://us.battle.net/support/en/article/42673 | **In-Game Code of Conduct (US)** — “third-party programs to automate any facet of the game” = cheating; also scamming, account sharing, win-trading. |
| https://eu.battle.net/support/en/article/42673 | **Same CoC article (EU Support)**. |
| https://us.forums.blizzard.com/en/wow/t/prohibitions-on-third-party-software/2142972 | **2025-08-05 Kaivax blue post** — enforcement against client-modifying / security-bypassing software; quotes EULA §1.C. Clarifies the *banned* third-party bucket vs Lua addons. |
| https://www.wowhead.com/news/blizzard-reminds-players-that-third-party-software-is-prohibited-378029 | **Secondary summary** of the 2025 blue post; useful for “not all third-party software — client modifiers” reading. Prefer citing the blue post for authority. |

---

## D. Technical policy barriers (API)

| URL | Annotation |
|-----|------------|
| https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting | Explains why Classic addons **cannot** automate combat the way Vanilla-era mods could; taint/protected functions; official “no combat-sensitive decisions” philosophy quotes. Cite for the hard technical half of “no automation.” |
| https://us.battle.net/forums/en/bnet/topic/16542564694 | Historical Blizzard answer: WoW Lua sandbox lacks general networking; limits malicious data export. Use as **supporting** sandbox evidence (old thread; confirm current API separately if claiming a specific HTTP API). |

---

## E. Community enforcement / monetization debates (secondary)

| URL | Annotation |
|-----|------------|
| https://us.forums.blizzard.com/en/wow/t/blizzard-tos-on-addon/797705 | Players quoting UI policy rule 1 against premium/paywalled addon features (MDT-era discussion). Shows the policy is still treated as live by the community. |
| https://eu.forums.blizzard.com/en/wow/t/addon-for-money-violation-of-eula/212887 | EU support-area thread on paid guides vs free-addon rule. |
| https://us.forums.blizzard.com/en/wow/t/rmt-is-it-actually-against-the-letter-of-the-eula/1556709 | Community Council discussion quoting Prohibited Commercial Uses (including wagering). Secondary — useful for the **quoted EULA block**, not as legal advice. |
| https://eu.forums.blizzard.com/en/wow/t/clarifications-on-code-of-conduct/540820 | Player questions on whether addons count as cheating; community replies distinguish API addons vs memory tools/AHK. **Not official clarification** — Blizzard rarely narrows CoC on forums. |

---

## F. Related design-spec / sibling research (not duplicated here)

| URL / path | Why linked |
|------------|------------|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Product hard restrictions §2; officer anti-cheat §6.3 |
| Track 14 `addon-messaging-beefnet` | CHANNEL ban / GUILD messaging — social API history, not re-litigated here |
| Track 16 `guild-roster-officer-edges` | How to *implement* Officer+ checks — mechanics, not ToS |

---

## Citation hygiene

1. Prefer **Blizzard Legal / Support / blue posts** over Wowhead for rules.
2. Prefer **wiki** for secure-execution mechanics.
3. Treat forum *player* replies as culture signals, not policy.
4. When quoting “addons must be free,” cite the US/EU sticky or the 2010 archive — not a Reddit paraphrase.
5. Re-check the live EULA before any real-money adjacent feature (even “optional tips”).