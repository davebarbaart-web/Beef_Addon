# Track 60 — Hardcore / Doomhowl scoring & UX edges

**Track id:** `60-hardcore-doomhowl-edges`  
**Last updated:** 2026-07-25  
**Sole focus:** Classic **Hardcore** constraints (death, ghost logistics, ruleset, addon ethics/API limits) and **Doomhowl → TBC** guild/character transfer edges as they affect Church of Beef **scoring, ceremonies, Gora, and ladder UX** — without re-litigating Anniversary packaging or season calendars.  
**Out of scope:** Full Anniversary vs Era install/TOC deltas ([30](../30-anniversary-vs-era-deltas/)); phase seasons, lockout calendars, raid-tier soft resets ([46](../46-seasonality-fresh-servers/)); ladder psychology/thresholds ([26](../26-ladders-points-gamification/)); ToS wagering ([24](../24-policy-tos-compliance/)). No addon implementation in this folder.

## Product truth (from V1 spec)

| Locked default | Value |
|----------------|-------|
| V1 platform | **TBC Classic Anniversary** — not Hardcore, not Era |
| Brand lore | Alliance **Dreamscythe**, Horde **Doomhowl**, Classic Hardcore content in identity ([spec §3.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Ladders | Each guild = independent ladder; no cross-realm state ([spec §5](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Scoring sources | Shared instance co-play, ceremony, Beef Gora ([spec §7](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Persistence | Per-character SavedVariables; alts start Fresh Beef ([spec §9](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Anti-cheat | Officer judgment, not automated purity policing ([spec §6.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |

## Index

| Note | Covers |
|------|--------|
| [classic-hardcore-constraints.md](classic-hardcore-constraints.md) | Official HC ruleset that changes scoring surface (permadeath, PvP, dungeons, Mak’gora) |
| [death-ghost-and-guild-logistics.md](death-ghost-and-guild-logistics.md) | Ghost mode, GM handoff, free death-transfer, ladder orphan edges |
| [addon-limitations-and-ethics.md](addon-limitations-and-ethics.md) | Addons allowed; what APIs cannot do; leash/ethics UX |
| [beef-scoring-ceremony-hc-rules.md](beef-scoring-ceremony-hc-rules.md) | Recommended HC-aware scoring / ceremony / Gora rules (V1 + future HC port) |
| [doomhowl-transfer-to-tbc.md](doomhowl-transfer-to-tbc.md) | Doomhowl stays Classic; transfer window to Normal Anniversary / Dreamscythe |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Boundary with tracks 30 and 46

| This track (60) | Track 30 | Track 46 |
|-----------------|----------|----------|
| HC **ruleset** & death UX depth | Client trees, TOC, Interface numbers | Fresh launch → phase seasons |
| Scoring pause on ghost/death; Gora ≠ Mak’gora | “Hardcore not V1” packaging | Dreamscythe ≠ Doomhowl as progression peers (one-liner only there) |
| Transfer **as ladder discontinuity** for HC flock | Install path after client flip | Season *labels* and lockout rhythm |
| Addon ethics / protected-action limits on HC | Multi-TOC strategy | Raid-tier soft resets |

Do not restate `_anniversary_` vs `_classic_era_` install trees here. Do not rebuild the TBC phase calendar. Point to 30/46 and go deeper only on HC-specific consequences.

## Top insights for Beef (read this first)

1. **V1 does not run on Doomhowl Hardcore.** Dreamscythe (and any Horde guild that transferred to a Normal Anniversary / TBC realm) is the live V1 install. Doomhowl is brand lore + optional future Classic-line port, not the Anniversary TOC target ([Wowhead TBC roadmap](https://www.wowhead.com/tbc/guide/the-burning-crusade-classic-anniversary-phase-release-roadmap); [spec §2–§3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

2. **“Horde on Doomhowl” may now mean “Horde who *were* Doomhowl.”** Free Hardcore Anniversary → Normal Anniversary transfers closed **12 Jan 2026** (pre-patch window); stayers remain Classic HC with no TBC Hardcore product ([Warcraft Tavern transfer close](https://www.warcrafttavern.com/wow-classic/news/anniversary-transfers-for-hardcore-and-classic-era-close-january-12th/); blue post quoted in [Doomhowl fate thread](https://us.forums.blizzard.com/en/wow/t/what-happens-to-doomhowl-server-on-tbc-launch/2209819)). Verify the guild’s **current realm** before assuming one SV mesh.

3. **Permadeath forces ladder orphan policy, not “demote on death.”** On official HC, death ends play on that realm; ghosts exist for chat + guild logistics (e.g. GM handoff); free move off HC to non-HC Era/Anniversary destinations was the Blizzard safety valve ([Blizzard Rules of Engagement](https://worldofwarcraft.blizzard.com/en-us/news/23973734/rules-of-engagement-classic-hardcore-is-coming-to-world-of-warcraft)). Beef should treat death like **character end-of-life**: pause scoring, keep committed rank history as memorial/hidden, never invent auto-excommunication from `PLAYER_DEAD`.

4. **Beef Gora must never be confused with `/makgora`.** HC “Duel to the Death” is permanent death with Stack-of-Ears cosmetics ([Blizzard](https://worldofwarcraft.blizzard.com/en-us/news/23973734/rules-of-engagement-classic-hardcore-is-coming-to-world-of-warcraft)). Spec Gora is a **recorded sporting ritual** with participation points for losses. Copy, slash help, and stream language must say “Beef Gora / challenge record,” not Mak’gora — especially if any HC-adjacent cohort uses both products.

5. **HC changes the co-play scoring surface.** Battlegrounds are disabled; dungeon spam is throttled (24h lockouts below 60; no high-level boosting lowbies) ([Blizzard](https://worldofwarcraft.blizzard.com/en-us/news/23973734/rules-of-engagement-classic-hardcore-is-coming-to-world-of-warcraft)). A future HC port would lean harder on **ceremony + Gora + careful group instances**, not BG drip. V1 Anniversary can ignore this for scoring tables, but brand UX should not joke about “farm BGs for Beef” in HC lore clips.

6. **Addons are allowed; leash vibes are not.** HC players use AddOns (install-path confusion is the common failure, not a ban) ([“No addons?” forums](https://us.forums.blizzard.com/en/wow/t/no-addons/1658472)). Community heat is about paid guide automation ([RestedXP debate](https://us.forums.blizzard.com/en/wow/t/why-is-addon-like-restedxp-allowed-by-blizzard/2022911?page=6)). Beef stays social/officer-judged; never position as survival autopilot. Addon APIs also **cannot** force logout or auto-transfer guild leadership on death — official HC does those server-side; community HC addons document the gap ([Hardcore Mode CurseForge](https://www.curseforge.com/wow/addons/hardcore-mode)).

7. **Ghost / dead = scoring pause (HC-aware rule worth shipping even on Anniversary).** Spec already pauses when not in a guild. Add: no instance drip, no ceremony attendance credit, no Gora outcome while `UnitIsDeadOrGhost("player")` (or equivalent). Prevents absurd “ghost standing” edge cases and matches HC ghost logistics reality.

8. **Transfers are hard congregation breaks unless officers migrate commits.** Per-character SV does not follow a Free Character Move into a new guild mesh. Doctrine (“flesh must prove itself anew”) already matches Fresh Beef on the TBC side; optional officer “recognize the pilgrim” ceremony is lore, not automatic standing import ([spec §9](../../../superpowers/specs/2026-07-25-church-of-beef-design.md); track [46 transfer edge](../46-seasonality-fresh-servers/fresh-servers-and-realm-identity.md)).

## Recommended policy sketch

| Horizon | HC / Doomhowl fact | Beef response |
|---------|-------------------|---------------|
| V1 ship (Anniversary) | Not on HC client | No HC ruleset code; optional copy that Gora ≠ Mak’gora; ghost pause still useful |
| Brand / stream | Doomhowl HC history | Lore + memorial ceremonies; don’t claim live TBC Doomhowl ladder |
| Post-transfer Horde guild on Dreamscythe (etc.) | New realm, new guild id | New ladder; officers may manually seed ranks via correction — never silent SV merge |
| Future Classic HC port | Permadeath, no BGs, dungeon timers | Disable BG source; pause on death/ghost; memorial ladder; ceremony-heavy fuel |
| Dead HC character | Ghost → FCM off realm | Hide from live ladder; retain commit history; no auto-demote spam |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Blizzard Hardcore Rules of Engagement and Wowhead/Tavern Anniversary transfer notes over listicles. Product locks stay in the design spec.
