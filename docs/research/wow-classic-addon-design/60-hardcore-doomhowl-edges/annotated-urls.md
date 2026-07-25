# Annotated URLs — Hardcore / Doomhowl edges

Primary sources for track 60. Prefer Blizzard Rules of Engagement and Anniversary transfer blues over listicles. Do not duplicate track [30](../30-anniversary-vs-era-deltas/) install-path catalogs or track [46](../46-seasonality-fresh-servers/) phase calendars here.

## Official Hardcore ruleset

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://worldofwarcraft.blizzard.com/en-us/news/23973734/rules-of-engagement-classic-hardcore-is-coming-to-world-of-warcraft | **Primary:** permadeath, ghost logistics, FCM off HC, `/pvp`, BGs off, dungeon 24h lockouts, anti-boost XP, no bubble-hearth, **Duel to the Death / `/makgora`**, behavior enforcement — scoring-surface bible for any HC port. |
| https://dotesports.com/wow/news/official-wow-classic-hardcore-rules-explained-deaths-pvp-dungeons-and-more | Readable summary of death → ghost → optional non-HC transfer; useful for onboarding FAQ tone. |
| https://www.icy-veins.com/wow-classic/classic-hardcore-rules | Compact rules + PvP/PvE deltas; corroborates ghost GM handoff and free death transfer. |
| https://www.warcrafttavern.com/wow-classic/news/official-hardcore-rules-explained/ | Launch-era clarification (no Soulstone/Reincarnation, 24h dungeon lockout vs community-addon “once ever,” Mak’gora). |

## Doomhowl / Anniversary → TBC transfers

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.wowhead.com/tbc/guide/the-burning-crusade-classic-anniversary-phase-release-roadmap | Realm list: Dreamscythe PvE progresses; **Doomhowl/Soulseeker stay Classic HC**; transfer to PvE for TBC — brand vs live-guild check. |
| https://www.warcrafttavern.com/wow-classic/news/anniversary-transfers-for-hardcore-and-classic-era-close-january-12th/ | **Transfer window:** HC Anniversary → Normal Anniversary closed **12 Jan 2026**; no TBC Hardcore; stayers remain Classic HC. |
| https://us.forums.blizzard.com/en/wow/t/what-happens-to-doomhowl-server-on-tbc-launch/2209819 | Player thread quoting blue Anniversary HC transfer policy (stay on realm vs move by Jan 12; later FCM → Era). |
| https://us.forums.blizzard.com/en/wow/t/fate-of-hardcore-after-tbc/2196859 | Community anxiety about ghost chars / Doomhowl after TBC — expect support questions. |
| https://www.reddit.com/r/wowhardcore/comments/1p0kfu3/relevant_info_for_hc_regarding_transition_to_tbc/ | Player paraphrase: Doomhowl → Normal Anniversary (Dreamscythe-class) by 1/12/26 to enter TBC path. |
| https://eu.forums.blizzard.com/en/wow/t/can-i-transfer-from-classic-era-hardcore-to-tbc-anniversary-pve-realm-somehow/605706 | Era HC ≠ Anniversary HC transfer path — do not promise cross-product moves. |
| https://eu.forums.blizzard.com/en/wow/t/tbc-hardcore/468665 | Long wish for TBC HC — confirms community desire; **not** a shipped product. |

## Addons allowed / ethics / API limits

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://us.forums.blizzard.com/en/wow/t/no-addons/1658472 | HC AddOns **allowed**; failure mode is wrong folder / nested zip — not a ban. |
| https://us.forums.blizzard.com/en/wow/t/why-is-addon-like-restedxp-allowed-by-blizzard/2022911?page=6 | Leash/guide ethics fight — never position CoB as survival autopilot. |
| https://www.curseforge.com/wow/addons/hardcore-mode | Emulated HC addon: death ledgers, Self-Found rulesets; documents **protected-action limits** (no auto-logout, no auto-GM transfer). Adjacent competitor — do not absorb. |
| https://www.reddit.com/r/wowhardcore/comments/1rd6o45/a_clean_ui_can_make_a_difference/ | Clean-UI-as-virtue culture — reinforces edge ladder / low chrome. |

## Soul of Iron / never-died cosmetics (do not gate Beef)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.icy-veins.com/wow-classic/soul-of-iron-system-for-hardcore-players | SoM-era Soul of Iron — cosmetic never-died proof; **not** a Beef promotion gate. |
| https://wowpedia.fandom.com/wiki/Soul_of_Iron | Wiki notes on SoI / Tarnished Soul — history only. |

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §3.3, §5, §6.3, §7, §9, §11 | Dreamscythe/Doomhowl brand, independent ladders, officer anti-cheat, scoring sources, per-character SV, edge table. |
| [`../30-anniversary-vs-era-deltas/`](../30-anniversary-vs-era-deltas/) | Install/TOC — HC not V1; do not duplicate. |
| [`../46-seasonality-fresh-servers/`](../46-seasonality-fresh-servers/) | Fresh/phase seasons + short Doomhowl caveat — this track owns HC depth. |
| [`../12-classic-vs-retail-philosophy/`](../12-classic-vs-retail-philosophy/) | Broader nostalgia/QoL + HC ethics edge. |
| [`../24-policy-tos-compliance/`](../24-policy-tos-compliance/) | No wagering on Gora/Mak’gora. |
| [`../52-competitor-market-map/`](../52-competitor-market-map/) | GRM / HC-adjacent ops tools. |

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-hc-rules-death.json`](.raw/search-hc-rules-death.json) | Parallel search: HC rules, death, addons |
| [`.raw/search-doomhowl-transfer.json`](.raw/search-doomhowl-transfer.json) | Parallel search: Doomhowl/TBC transfer, Soul of Iron |
| [`.raw/search-hc-addons-api.json`](.raw/search-hc-addons-api.json) | Parallel search: addon limits / allowed |
| [`.raw/extract-blizzard-hc-rules.json`](.raw/extract-blizzard-hc-rules.json) | Extract: Blizzard Rules of Engagement |
| [`.raw/extract-wowhead-tbc-roadmap.json`](.raw/extract-wowhead-tbc-roadmap.json) | Extract: Wowhead realm/TBC roadmap |
| [`.raw/extract-dotesports-hc-rules.json`](.raw/extract-dotesports-hc-rules.json) | Extract: Dot Esports HC rules |
| [`.raw/extract-tavern-hc-transfers.json`](.raw/extract-tavern-hc-transfers.json) | Extract: Jan 12 transfer close |
| [`.raw/extract-doomhowl-fate-forum.json`](.raw/extract-doomhowl-fate-forum.json) | Extract: Doomhowl fate forum + blue quote |
| [`.raw/extract-hc-addons-allowed.json`](.raw/extract-hc-addons-allowed.json) | Extract: “No addons?” HC thread |
