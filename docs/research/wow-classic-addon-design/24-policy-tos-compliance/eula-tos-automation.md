# EULA, Code of Conduct, and automation boundaries

**Track:** `24-policy-tos-compliance`  
**Last updated:** 2026-07-25  
**Purpose:** Separate *allowed Lua UI addons* from *banned automation / client-modifying software*, with primary Blizzard citations.

## Layered rule stack

| Layer | What it governs | Primary URL |
|-------|-----------------|-------------|
| UI Add-On Development Policy | How addons are designed/distributed | [US](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534) · [EU](https://eu.forums.blizzard.com/en/wow/t/wow-user-interface-add-on-development-policy/1642) |
| Blizzard EULA | License limitations: cheating, bots, hacks, RMT, ads, data mining, wagering | [US EULA](https://www.blizzard.com/en-us/legal/fba4d00f-c7e4-4883-b8b9-1b4500a402ea/blizzard-end-user-license-agreement) · [GB EULA](https://www.blizzard.com/en-gb/legal/08b946df-660a-40e4-a072-1fbde65173b1/blizzard-end-user-license-agreement) |
| In-Game Code of Conduct | Player conduct; cheating includes third-party automation | [US Support](https://us.battle.net/support/en/article/42673) · [EU Support](https://eu.battle.net/support/en/article/42673) |
| Client API (secure/taint) | Technical impossibility of classic combat automation | [Secure Execution and Tainting](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting) |
| Enforcement reminders | Client-modifying third-party software | [US blue post 2025-08-05](https://us.forums.blizzard.com/en/wow/t/prohibitions-on-third-party-software/2142972) |

UI policy rule 7 explicitly requires addons to follow ToU/EULA ([archive](https://web.archive.org/web/20101124173826/http://www.worldofwarcraft.com/policy/ui.html)).

---

## What the Code of Conduct calls cheating

From [Blizzard's In-Game Code of Conduct](https://us.battle.net/support/en/article/42673):

> Using third-party programs to automate any facet of the game, exploiting bugs, or engaging in any activity that grants an unfair advantage is considered cheating.

Also called out: scamming, account sharing, win-trading, and other exploitation of players.

**Research reading for addons:** A Lua addon that only uses the documented UI API is generally treated as *part of the allowed customization surface*, not as a “third-party program” in the botting sense — community consensus on official forums is that if Blizzard exposes it via the API, it is allowed until they remove the API ([EU Clarifications thread, community replies](https://eu.forums.blizzard.com/en/wow/t/clarifications-on-code-of-conduct/540820)). That does **not** authorize:

- AutoHotkey / input macros that collapse many actions into one press
- Memory editors, morph tools, packet tools
- External bots that read pixels/API and press keys
- Anything that automates character control

---

## EULA license limitations (automation-relevant)

From the [Blizzard EULA](https://www.blizzard.com/en-us/legal/fba4d00f-c7e4-4883-b8b9-1b4500a402ea/blizzard-end-user-license-agreement) (Cheating / related subsections; also quoted in the [2025-08-05 blue post](https://us.forums.blizzard.com/en/wow/t/prohibitions-on-third-party-software/2142972)):

| Ban category | Substance (paraphrased from EULA) |
|--------------|-----------------------------------|
| **Cheats** | Unauthorized methods influencing/facilitating gameplay and granting advantage |
| **Bots** | Unauthorized code/software allowing **automated control** of a Game or Platform feature (e.g. automated character control) |
| **Hacks** | Accessing or modifying Platform software in a manner not expressly authorized |
| **Unauthorized gameplay software** | Code/software not expressly authorized that changes and/or facilitates gameplay or other functionality |
| **Data mining** | Unauthorized process/software that intercepts, collects, reads, or “mines” information generated/stored by the Platform — *with* a carve-out that Blizzard may allow certain third-party UIs |
| **Unauthorized connections** | Connections using third-party programs/tools not expressly authorized |
| **Prohibited commercial uses** | RMT-style gathering for sale outside the Platform; paid boosting; commercial ads *through/within* the Platform; **wagering** on game outcomes without authorization |

The EULA also states the Platform may monitor for unauthorized third-party programs and communicate detections back to Blizzard ([GB EULA extract](https://www.blizzard.com/en-gb/legal/08b946df-660a-40e4-a072-1fbde65173b1/blizzard-end-user-license-agreement)).

---

## Official 2025 reminder: client modification

[Kaivax — Prohibitions on Third-party Software (2025-08-05)](https://us.forums.blizzard.com/en/wow/t/prohibitions-on-third-party-software/2142972):

- Blizzard acts against accounts that reverse-engineer / bypass security to **modify the game client** and/or **control the game** in prohibited ways.
- Penalties include permanent account closure.
- Quotes EULA Part 1 Section C (Derivative Works + Cheating language).
- Expectation: remove third-party software that bypasses client security.

[Wowhead coverage](https://www.wowhead.com/news/blizzard-reminds-players-that-third-party-software-is-prohibited-378029) notes the blue post is about client-modifying cheats/hacks/memory tools — **not** ordinary Lua addons, addon managers, or combat-log uploaders that do not modify the client.

---

## Technical barrier: secure execution (Classic)

Classic uses the **modern** secure-execution and tainting model. Consequence stated on the wiki:

> World of Warcraft: Classic uses the modern API, including secure execution and tainting. Consequently, addons cannot perform the blatantly harmful automation in Classic that was technically possible in Vanilla.

Source: [Secure Execution and Tainting](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting).

Historical Blizzard philosophy (quoted on that page): UI mods should not make combat-sensitive decisions; addons/macros should not cast/target via addon logic — player interaction is required; logic that intelligently picks spells/targets was the thing being blocked.

**Allowed vs forbidden (automation axis):**

| Allowed (UI addon) | Forbidden (ToS / EULA / API) |
|--------------------|------------------------------|
| Display timers, alerts, ladders, suggestions | Auto-cast, auto-target, auto-move |
| Record Gora outcomes the player/officer entered | Bot that plays the duel |
| Suggest a rank; wait for human officer click | Auto-promote without human authority *as a cheat* (social design choice; also matches trust model) |
| WeakAura-style *reminders* the player acts on | Rotation bot / pixel bot / AHK chain |
| Ordinary frames + chat announces | Secure-template abuse to circumvent human decision |

---

## Alignment with Church of Beef design spec §2

Spec §2 already states the correct compliance boundary:

- No external process controlling gameplay
- No injection, bots, automated movement, automated spellcasting, automatic targeting, or combat decision-making
- No protected-action circumvention
- **May** announce, track, record, display, coordinate, synchronize allowed information
- **Must not** play the game for anyone

That language is the product translation of EULA + CoC + secure API. Spec §6.3 (“officer is the anti-cheat”) further avoids pretending client-side points are authoritative — which is both honest engineering and anti-abuse posture.

## Practical compliance checklist (automation)

- [ ] No companion `.exe` / Python / AHK that drives the character
- [ ] No reading of process memory or packet streams
- [ ] No combat decision engine that presses abilities for the player
- [ ] UI actions that matter (approve rank, record Gora) require an explicit human click
- [ ] Do not document “workarounds” for secure templates or protected APIs
- [ ] If a future feature needs out-of-game data, prefer player-initiated log upload patterns used by the ecosystem — never silent exfiltration (see [data-exfiltration-forbidden-apis.md](data-exfiltration-forbidden-apis.md))
