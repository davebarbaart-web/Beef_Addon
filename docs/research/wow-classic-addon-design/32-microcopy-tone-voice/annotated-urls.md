# Annotated URLs — microcopy, tone, announce, toasts

Primary references for track 32. **Steal/adapt** notes are about *voice and copy craft*, not UI chrome (see track 07 for frames).

## Classic guild / social addons (tone exemplars)

| URL | What it is | Steal / adapt for Beef |
|-----|------------|------------------------|
| [https://www.curseforge.com/wow/addons/gargul](https://www.curseforge.com/wow/addons/gargul) | Gargul — master-loot / SoftRes / GDKP tool; ~19M+ downloads | **Sincere, transparent, opt-out announces.** Marketing is about speed and clarity, not jokes. Trade announce = accountability pattern for Beef’s promotion line. |
| [https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat) | Wiki: loot announce defaults + settings | **Toggle + quality gate + single ML speaker.** Map to officer opt-out + throttle + officer-only `SendChatMessage`. |
| [https://github.com/papa-smurf/Gargul/wiki](https://github.com/papa-smurf/Gargul/wiki) | Gargul wiki hub | Procedural docs voice — model for `/beef` help and officer settings copy. |
| [https://www.curseforge.com/wow/addons/attune](https://www.curseforge.com/wow/addons/attune) | Attune — attunement progress + guild survey | **Earnest utility voice.** Survey/results language stays sober; author humor stays on the download page, not in every string. |
| [https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832](https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832) | Attune launch thread | How guild tools are pitched to officers: readiness, clarity, usefulness. |
| [https://arcaneintellect.com/attune-world-of-warcraft-wow-tbc-addon-spotlight/](https://arcaneintellect.com/attune-world-of-warcraft-wow-tbc-addon-spotlight/) | Attune spotlight (TBC) | Documents survey + optional chat-on-complete settings — precedent for **opt-in chat noise**. |
| [https://www.curseforge.com/wow/addons/rclootcouncil](https://www.curseforge.com/wow/addons/rclootcouncil) | RCLootCouncil | **Officer seriousness:** voting, history, confirm award. Response button text = guild policy, not comedy. |
| [https://medium.com/@rengo_wow_world_of_warcraft/rclootcouncil-vs-gargul-which-wow-loot-addon-should-you-use-f99ac760e944](https://medium.com/@rengo_wow_world_of_warcraft/rclootcouncil-vs-gargul-which-wow-loot-addon-should-you-use-f99ac760e944) | RCLC vs Gargul comparison | Reinforces: drama-prone systems want **transparent, defensible** language. |
| [https://addons.wago.io/addons/gargul](https://addons.wago.io/addons/gargul) | Gargul on Wago | Same product pitch; useful mirror of CurseForge description tone. |

## Humor as a *separate* product (anti-pattern for default guild voice)

| URL | What it is | Steal / adapt for Beef |
|-----|------------|------------------------|
| [https://www.curseforge.com/wow/addons/dadjokes](https://www.curseforge.com/wow/addons/dadjokes) | DadJokes — random jokes to a chosen channel | Proof that even Gargul’s author keeps **gag spam out of the loot addon**. If Beef wants gag mode later, ship it opt-in — not as promotion defaults. |
| [https://www.curseforge.com/wow/addons/chucknorris](https://www.curseforge.com/wow/addons/chucknorris) | ChuckNorris facts to chat | Same lesson: meme channels are voluntary entertainment. |

## RP identity tools (sincere, not meme UI)

| URL | What it is | Steal / adapt for Beef |
|-----|------------|------------------------|
| [https://github.com/Total-RP/Total-RP-3](https://github.com/Total-RP/Total-RP-3) | Total RP 3 README | **Sincere freedom / modularity** marketing. Players bring humor in content; chrome stays adult. Map: titles/announces funny; settings/errors straight. |

## Chat API / length

| URL | What it is | Steal / adapt for Beef |
|-----|------------|------------------------|
| [https://wowwiki-archive.fandom.com/wiki/API_SendChatMessage](https://wowwiki-archive.fandom.com/wiki/API_SendChatMessage) | `SendChatMessage` docs | **255-character hard max** for announce payloads. Design skim length much shorter. Prefer live warcraft.wiki.gg mirror when available. |

## Toast / snackbar craft (cross-platform)

| URL | What it is | Steal / adapt for Beef |
|-----|------------|------------------------|
| [https://m2.material.io/design/components/snackbars.html](https://m2.material.io/design/components/snackbars.html) | Material snackbars | Single-purpose feedback; ~**40–60 character** comfort line length; don’t stack. |
| [https://m3.material.io/components/snackbar/guidelines](https://m3.material.io/components/snackbar/guidelines) | M3 snackbar guidelines | Prefer one line on wide layouts; scale carefully. |
| [https://m1.material.io/components/snackbars-toasts.html](https://m1.material.io/components/snackbars-toasts.html) | MD1 snackbars & toasts | **One snackbar at a time**; brief operation-related text. |
| [https://blog.logrocket.com/ux-design/toast-notifications](https://blog.logrocket.com/ux-design/toast-notifications) | LogRocket toast UX (2025 rewrite) | Brief only; ~3–8s attention; don’t put complex info in toasts; timed-dismiss a11y caveats. |
| [https://studyaround.blog/toast-notification-design-guide](https://studyaround.blog/toast-notification-design-guide) | Toast design practices | ~3–6s success window; severity scales duration. |
| [https://www.numberanalytics.com/blog/toast-notifications-best-practices-web-design](https://www.numberanalytics.com/blog/toast-notifications-best-practices-web-design) | Toast timing/placement summary | Concise copy; ~5–7s cited for readable dwell — treat as soft guidance, not WoW law. |

## In-repo product sources (not web, but binding)

| Path | Role |
|------|------|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §3.3, §10, §13 | Brand context; announce example; toast events; social success criterion |
| [`docs/research/wow-classic-addon-design/00-church-of-beef-implications.md`](../00-church-of-beef-implications.md) | Guild-chat line as V1 spectacle budget |
| Track [07](../07-immersion-roleplay-flavor/) | Frame/immersion patterns — do not duplicate; copy only here |

## Provenance dumps

Raw search/extract JSON for this track:

- `.raw/search-guild-addon-tone.json`
- `.raw/search-toast-announce-craft.json`
- `.raw/search-chat-limits-announce.json`
- `.raw/search-gargul-rp-voice.json`
- `.raw/search-rclootcouncil-announce.json`
- `.raw/extract-gargul-wiki.json`
- `.raw/extract-gargul-announce.json`
- `.raw/extract-sendchatmessage-fandom.json`