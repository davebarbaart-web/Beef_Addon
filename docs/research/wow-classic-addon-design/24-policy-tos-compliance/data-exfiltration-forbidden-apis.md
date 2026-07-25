# Data exfiltration, sandbox limits, and forbidden API classes

**Track:** `24-policy-tos-compliance`  
**Last updated:** 2026-07-25  
**Purpose:** Policy + platform constraints on getting data *out of* WoW, and API classes that are forbidden or effectively unusable for automation — without duplicating track 14’s messaging budgets.

## Two different “exfiltration” problems

| Concern | Who cares | Church of Beef stance |
|---------|-----------|------------------------|
| **Malicious / privacy exfiltration** | Players, Blizzard, ToS | No silent phone-home; no harvesting other players’ data for external sale |
| **Technical sandbox limits** | Client architecture | In-game Lua cannot open arbitrary sockets; stay in-game for V1 (spec §2 “fully in-game operation”) |

## EULA: data mining

The [Blizzard EULA](https://www.blizzard.com/en-us/legal/fba4d00f-c7e4-4883-b8b9-1b4500a402ea/blizzard-end-user-license-agreement) prohibits using unauthorized process/software that intercepts, collects, reads, or “mines” information generated or stored by the Platform — with a discretionary carve-out allowing certain third-party UIs.

**Reading for addon authors:**

- Memory scrapers, packet sniffers, and client injectors are in the ban bucket (also hit by the [2025 third-party software reminder](https://us.forums.blizzard.com/en/wow/t/prohibitions-on-third-party-software/2142972)).
- Official Lua UI addons reading **documented API/events** (unit health, guild roster, instance info) are the authorized UI path — that is how the entire addon ecosystem works.
- Building a side channel that dumps roster/combat data to an unauthorized external server without clear player action sits in a worse ethical and ToS posture than “SavedVariables + optional player-run log upload.”

## Lua sandbox: no general networking

A Blizzard forum answer on third-party resource access via Lua (historical Battle.net forums) states that Lua usable in the “WoW Sandbox” is prevented from doing networking that could be used maliciously; getting data out historically meant writing a kind of log file that is finalized on logout ([Third Party Resource Access via LUA in WoW](https://us.battle.net/forums/en/bnet/topic/16542564694)).

**Implication:** Classic Church of Beef should not plan on `SendHTTPRequest`-style telemetry from the client. Spec §2 already locks **fully in-game operation**. Guild sync stays on allowed addon messaging channels (policy/history in track 14 — GUILD prefix, not custom CHANNEL).

## Allowed in-game data movement (not “exfiltration”)

These are normal, permitted UI patterns when rate-limited and non-harmful (UI policy rule 3 — don’t harm realms/players):

| Path | Use | Policy notes |
|------|-----|--------------|
| `SavedVariables` / per-char DB | Local persistence | Editable by user; not a trust boundary (spec §6.3) |
| `SendAddonMessage` on `GUILD` / party / raid / whisper | Peer sync among addon users | Must throttle; no spam (rule 3) |
| Guild chat text announces | Spectacle for non-addon members | Human-readable; don’t advertise products (rule 4) |
| Combat log / chat log files on disk | Player-owned logs | External upload tools are separate apps; do not modify the client |

## Forbidden / blocked API classes (automation & integrity)

This is a **policy-oriented** list, not a full API catalog (TOC/API track covers packaging).

| Class | Why it’s closed | Beef response |
|-------|-----------------|---------------|
| Protected combat actions from tainted code | Secure execution — addons cannot decide casts/targets in combat ([wiki](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)) | Never attempt; ordinary frames only |
| Circumventing `InCombatLockdown` | Protected frames/methods refuse tainted combat config | Don’t touch secure templates for V1 |
| Client binary modification / injection | EULA hacks + 2025 enforcement post | Out of scope forever |
| Unauthorized memory/network mining | EULA data mining | No companion miner |
| Retail-only secret-value / Midnight combat clamps | Wrong expansion; out of V1 scope | Spec §2 / §13.10 |
| Classic custom `CHANNEL` addon messaging | Removed for social/API policy reasons (history in track 14) | BeefNet = `GUILD` only |

Official philosophy quoted on the secure-execution wiki: Blizzard does not want UI mods to make combat-sensitive decisions for players ([Secure Execution and Tainting — Official statements](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)).

## Privacy & guild data hygiene (product policy)

Even where the API allows reading guild roster / online status / instance membership:

1. **Minimize** — store what the ladder needs (standing, rank, recent event summaries), not dossiers.
2. **Scope** — BeefNet is guild-scoped; do not design cross-realm broadcast of personal data.
3. **Consent culture** — installing the addon + joining the guild is the practical consent model for social ladder sync; still avoid creepy “export everyone’s alts to a website” features.
4. **No advertising ID / telemetry** — would collide with UI policy rules 4–5 and general trust.
5. **Officer tools** — showing a suggestion breakdown to officers is analogous to loot-council notes; keep it in-game and guild-internal.

## Church of Beef V1 compliance snapshot

| Spec choice | Exfiltration / API risk |
|-------------|-------------------------|
| Fully in-game; Lua/XML only | Aligns with sandbox |
| BeefNet on GUILD | Allowed messaging surface |
| Per-character SavedVariables | Local only; expected editable |
| No external controller | Avoids EULA bot/hack buckets |
| Officer approve for official ranks | No need for trusted external score server |

**Do not add later without a fresh policy review:** automatic HTTP posting of guild ladders, always-on telemetry, or a mandatory desktop “Beef Companion” that scrapes the client.