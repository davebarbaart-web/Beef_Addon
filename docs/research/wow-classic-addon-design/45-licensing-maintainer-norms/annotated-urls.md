# Annotated URLs — Licensing & maintainer norms

Primary sources for track 45. Prefer these over “best license for your addon” listicles.

## Blizzard policy (above your LICENSE)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534 | Canonical UI Add-On Development Policy: free of charge, code visible, no ads/in-game donation prompts, ToU/EULA, disable right; music redistribution warning. |
| https://wowwiki-archive.fandom.com/wiki/Blizzard_AddOn_Policy | Archived summary + pointers; useful if forum formatting is noisy. |
| https://www.blizzard.com/legal/28d5ebbf-c245-4408-8ba9-043dd5f056bf/faq-prawny | Blizzard Legal FAQ: no commercial redistribution of game music/samples. |
| https://www.blizzard.com/en-us/legal/a2989b50-5f16-43b1-abec-2ae17cc09dd6/blizzard-developer-api-terms-of-use | Developer API ToU — premium/paywalled Application restrictions (cited in 2026 policy-enforcement threads). |

## Source-viewable vs open source (community doctrine)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.wowinterface.com/forums/showthread.php?t=48644 | “Are all addons open source?” — Berne default ARR; visible ≠ open source; obfuscation banned. |
| https://wowinterface.com/forums/showthread.php?p=190341 | License design thread: why ARR/MIT-with-rename-ban beat pure MIT for update/feedback integrity. |
| https://en.wikipedia.org/wiki/Berne_Convention | Background for “no license = all rights reserved” claims in author forums. |

## CurseForge / Overwolf ownership

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://legal.overwolf.com/docs/curseforge/mod-authors-terms/ | **Primary.** Author keeps title; broad license to Overwolf; exclusive CF marketing/distribution + usage data; withdrawal & retention rules. |
| https://legal.overwolf.com/docs/archive/curseforge/miscellaneous/13-01-2025/mod-authors-terms/ | Archived snapshot of Mod Authors Terms (compare if live page drifts). |
| https://legalclarity.org/who-owns-curseforge-from-twitch-to-overwolf/ | Plain-language Overwolf acquisition + IP summary (secondary; verify against legal.overwolf.com). |
| https://techcrunch.com/2020/06/22/in-game-app-development-platform-overwolf-acquires-curseforge-assets-from-twitch-to-get-into-mods/ | Acquisition announcement context (platform owner change). |
| https://curseforge-ideas.overwolf.com/ideas/CF-I-222 | Author pushback on breadth of rights grant — cultural signal, not binding terms. |
| https://support.curseforge.com/en/support/solutions/articles/9000197898-rewards-program-terms-of-service | Rewards Program is separate from copyright LICENSE choice. |
| https://us.forums.blizzard.com/en/wow/t/curseforge-transfer-marking-projects-as-abandoned/748695 | False “Abandoned” flags after Twitch→Overwolf migration; do not treat badge as free reclaim. |

## Exemplar project licenses

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://tukui.org/elvui | ElvUI ARR + private mods only + GitHub exception + no rename — brand-control template. |
| https://github.com/tukui-org/ElvUI | Source home; LICENSE.md alongside ThirdPartyNotices pattern. |
| https://github.com/DeadlyBossMods/DeadlyBossMods/blob/master/LICENSE | DBM ARR short form — combat-addon ARR precedent. |
| https://www.curseforge.com/wow/addons/details | Details! CF license field: All Rights Reserved. |
| https://github.com/WeakAuras/WeakAuras2 | WeakAuras GPL-2.0 — collaborative framework contrast case. |
| https://www.curseforge.com/wow/addons/rclootcouncil | RCLootCouncil LGPLv3 — guild-tool copyleft option. |
| https://github.com/papa-smurf/Gargul/blob/master/LICENSE | Gargul: GitHub view/fork ≠ redistribute grant; ARR default. |
| https://www.wowace.com/projects/Ace3 | Ace3 project page; license labeled “Ace3 Style BSD”. |
| https://openhub.net/licenses/AceStyleBSD | Full Ace Style Limited BSD text incl. stand-alone redistribution ban. |
| https://www.curseforge.com/wow/addons/libsharedmedia-3-0 | LSM project page / license field signal for media library norms. |
| https://www.wowace.com/projects/shared-media-additional-fonts | Font pack ARR + “credits to file owners” culture. |

## Fork / abandonment etiquette

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.reddit.com/r/wowaddons/comments/1d44ze3/has_anyone_taken_on_an_abandoned_addon/ | Practical advice: contact owner + CF for transfer; license gates new project. |
| https://addons.wago.io/addons/gargul | Example dual-host listing with License link back to GitHub. |

## Related repo tracks

| Path | Why |
|------|-----|
| [`../24-policy-tos-compliance/`](../24-policy-tos-compliance/) | Free/visible/no paywall policy depth; monetization edges. |
| [`../05-packaging-community-antipatterns/`](../05-packaging-community-antipatterns/) | CF submission metadata including license dropdown. |
| [`../20-sound-sfx-feedback/`](../20-sound-sfx-feedback/) | Why V1 avoids custom media (also reduces asset-license risk). |
| [`../13-cousin-addon-teardowns/`](../13-cousin-addon-teardowns/) | UX cousins — check their LICENSE before copying code. |
| [`../../../superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Brand/liturgy constraints that favor ARR. |

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-licensing-norms.json`](.raw/search-licensing-norms.json) | ARR vs MIT/GPL, WowAce, CF terms |
| [`.raw/search-curseforge-ownership-forks.json`](.raw/search-curseforge-ownership-forks.json) | Overwolf ownership, abandoned flags, ElvUI license |
| [`.raw/search-assets-and-library-licenses.json`](.raw/search-assets-and-library-licenses.json) | LSM, SharedMedia fonts, Ace Style BSD |
| [`.raw/search-popular-addon-licenses.json`](.raw/search-popular-addon-licenses.json) | WeakAuras GPL, Details ARR, DBM |
| [`.raw/search-blizzard-addon-policy-ip.json`](.raw/search-blizzard-addon-policy-ip.json) | UI Add-On Development Policy |
| [`.raw/search-cousin-addon-licenses.json`](.raw/search-cousin-addon-licenses.json) | Gargul / RCLC / Attune license signals |
| [`.raw/extract-cf-mod-authors-terms.json`](.raw/extract-cf-mod-authors-terms.json) | Full Mod Authors Terms excerpts |
| [`.raw/extract-elvui-license.json`](.raw/extract-elvui-license.json) | ElvUI license block |
| [`.raw/extract-ace-style-bsd.json`](.raw/extract-ace-style-bsd.json) | Ace Style BSD text |
| [`.raw/extract-wowiface-opensource.json`](.raw/extract-wowiface-opensource.json) | Visible vs open source thread |
| [`.raw/extract-cf-ownership-summary.json`](.raw/extract-cf-ownership-summary.json) | Secondary CF ownership summary |
| [`.raw/extract-dbm-license.json`](.raw/extract-dbm-license.json) | DBM LICENSE |
| [`.raw/extract-weakauras-license.json`](.raw/extract-weakauras-license.json) | WeakAuras GPL-2.0 |
| [`.raw/extract-gargul-license.json`](.raw/extract-gargul-license.json) | Gargul LICENSE |
| [`.raw/extract-abandoned-fork-etiquette.json`](.raw/extract-abandoned-fork-etiquette.json) | Abandoned takeover discussion |
