# Annotated URLs — Track 71

Primary sources for Anniversary ceremony / Beef Gora ritual mechanics. Prefer design spec for product truth; wiki for duel API surfaces; cousin listings for steal/avoid.

**Do not duplicate here:** HC `/makgora` Rules of Engagement — see [60 annotated-urls](../60-hardcore-doomhowl-edges/annotated-urls.md) and [60 scoring rules](../60-hardcore-doomhowl-edges/beef-scoring-ceremony-hc-rules.md).

---

## Design truth (repo)

| URL / path | Why it matters |
|------------|----------------|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §2, §3.2, §7.1, §10, §11 | No automation; deferred theater; ceremony/Gora sources; thin stubs; disconnect mid-ceremony |
| [Track 26 — classic-guild-fun-score-systems](../26-ladders-points-gamification/classic-guild-fun-score-systems.md) | Duel tracker cousins; losses-pay / rivalry memory |
| [Track 26 — anti-farm-incentives](../26-ladders-points-gamification/anti-farm-incentives.md) | Same-opponent Gora DR; ceremony id once |
| [Track 24 — guild-point-systems-gray-areas](../24-policy-tos-compliance/guild-point-systems-gray-areas.md) | Gora as recorded sport, not wagering |
| [Track 39 — classic-calendar-apis](../39-guild-calendar-events/classic-calendar-apis.md) | Officer close ≠ calendar Accept |
| [Track 51 — operational-runbook](../51-guild-night-playbook/operational-runbook.md) | ~5–10 min ceremony / ~10–15 min Gora blocks |
| [Track 13 — steal-avoid-for-beef](../13-cousin-addon-teardowns/steal-avoid-for-beef.md) | Thin stubs ≈ Gargul “note on decision” |
| [Track 07 — implications](../07-immersion-roleplay-flavor/implications-for-church-of-beef.md) | Skip-friendly ceremony; no ceremonial OS |
| [Track 58 — beef-demote-prophet-confirms](../58-staticpopup-confirms/beef-demote-prophet-confirms.md) | Nuclear confirms vs light rite confirms |
| [Track 60 — beef-scoring-ceremony-hc-rules](../60-hardcore-doomhowl-edges/beef-scoring-ceremony-hc-rules.md) | **Cite only** for Mak’gora naming / non-auto death duels |
| [Track 56 — spec-coverage-map](../56-coverage-gap-audit/spec-coverage-map.md) | Named ceremony/Gora as Partial — this track fills the mechanics gap |

---

## Duel client APIs (cues, not score authority)

| URL | Annotation |
|-----|------------|
| https://warcraft.wiki.gg/wiki/API_AcceptDuel | **Adapt:** `AcceptDuel()` exists — Beef must **not** auto-call it. Pair with StartDuel / CancelDuel. |
| https://wowpedia.fandom.com/wiki/API_StartDuel | **Adapt:** `StartDuel(unit\|name)` challenges a player — world theater only; never wrap into silent `/beef` automation. |
| https://warcraft.wiki.gg/wiki/DUEL_FINISHED | **Adapt:** Fired when a duel finishes — optional prefills for Record stub; **never** alone writes standing. |
| https://warcraft.wiki.gg/wiki/Dueling | **Context:** Consensual PvE-environment duels; no ladder stakes — matches theatrical Gora framing. |

**Anniversary verify:** Confirm event payload / winner clarity on `Interface 20506` before relying on prefills ([gora-challenge-flows.md](gora-challenge-flows.md) §3).

---

## Duel log cousins

| URL | Annotation |
|-----|------------|
| https://www.curseforge.com/wow/addons/duelbook | **Steal:** Classic duel outcome history (name/class/W/L); `/duelbook`. **Avoid:** Treating auto-register as official Beef Gora. |
| https://github.com/HotChilly/DuelBook | **Context:** Small open-source duel log — pattern reference for local rivalry SV. |
| https://kevinlocke.name/programs/dueltracker | **Adapt:** Personal duel outcome logging patterns for soft Record prompts. |
| https://eu.forums.blizzard.com/en/wow/t/duel-logs-addon/154534 | **Context:** Classic demand for W/L memory — rivalry UX signal, not Elo mandate. |
| https://addonswow.com/duelbook | **Context:** Mirror listing — “registers duels and records outcome vs opponents.” |

---

## Officer decision / attendance cousins

| URL | Annotation |
|-----|------------|
| https://www.curseforge.com/wow/addons/gargul | **Steal:** ML-centric Award + confirm + note density for Close/Record. BCC/Classic flavors exist — confirm Anniversary file. |
| https://github.com/papa-smurf/Gargul/wiki/Awarding-Items | **Steal:** Confirm dialogue before award sticks. |
| https://github.com/papa-smurf/Gargul/wiki/Rolling-Items | **Adapt:** Single-authority session UI anatomy — not the roll timer itself. |
| https://addons.wago.io/addons/gargul | **Context:** Soft dependency pitch (“only ML needs it for most features”). |
| https://medium.com/@rengo_wow_world_of_warcraft/rclootcouncil-vs-gargul-which-wow-loot-addon-should-you-use-f99ac760e944 | **Context:** Speed/ML vs structured council — Beef rites follow Gargul, not RCL parliament. |
| https://rclootcouncil.com/ | **Avoid as rite template:** Live council session assumption. |
| https://github.com/evil-morfar/RCLootCouncil2/wiki/Synchronizer | **Avoid for V1 rites:** Consent bulk sync — rites stay live-session ([67](../67-offline-officer-suggestion-sync/) owns petition sync debate). |
| https://www.curseforge.com/wow/addons/guild-raid-attendance | **Steal:** Admin attendance editor + save gate. **Avoid:** Built-in EPGP/CSV product scope. |
| https://www.curseforge.com/wow/addons/group-calendar-for-classic | **Avoid for credit:** RSVP/schedule only — Discord/calendar lane ([39](../39-guild-calendar-events/)). |

---

## Immersion / spectacle cousins (skip-friendly)

| URL | Annotation |
|-----|------------|
| https://www.curseforge.com/wow/addons/immersion | **Steal instinct:** Immersive when wanted, out of the way when not — ceremony stub time budget. |
| https://www.wowinterface.com/downloads/info24931-ImmersionClassic.html | **Context:** Classic Immersion port lineage — re-check Anniversary Interface. |
| https://www.curseforge.com/wow/addons/dialogueui | **Adapt (V2+):** Quest-dialogue pacing for liturgy text — not a V1 dependency. |
| https://www.curseforge.com/wow/addons/emote-splitter-classic | **Adapt:** Officers paste long liturgy in chat *outside* Beef; keep §10 announce one line. |
| https://www.curseforge.com/wow/addons/listener | **Coexist:** Crowded ceremony/Gora attention — do not reimplement as Beef chat HUD. |

---

## Policy / automation (pointer)

| URL | Annotation |
|-----|------------|
| https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534 | **Bound:** UI Add-On Development Policy — no playing the game for the user; human click for score rites. |
| https://www.blizzard.com/en-us/legal/fba4d00f-c7e4-4883-b8b9-1b4500a402ea/blizzard-end-user-license-agreement | **Bound:** EULA wagering ban — Gora stays unpaid recorded sport ([24](../24-policy-tos-compliance/)). |

Full policy synthesis stays in track 24 — do not expand wagering essays here.

---

## Provenance dumps

| Path | Contents |
|------|----------|
| [`.raw/search-duel-apis.json`](.raw/search-duel-apis.json) | Parallel search: duel APIs, DuelBook, automation policy threads |
| [`.raw/search-wiki-duel.json`](.raw/search-wiki-duel.json) | Wiki-focused StartDuel / AcceptDuel / DUEL_FINISHED |
| [`.raw/extract-duel-wiki.json`](.raw/extract-duel-wiki.json) | Extract attempt: AcceptDuel page (wiki API maintenance / 403s on siblings noted) |
| [`.raw/search-ritual-cousins.json`](.raw/search-ritual-cousins.json) | GRA, Group Calendar, Immersion-adjacent, RCL vs Gargul |

---

## How to use this list

1. Implementing stubs → start with **Design truth** + [thin-v1-ceremony-stubs.md](thin-v1-ceremony-stubs.md) / [gora-challenge-flows.md](gora-challenge-flows.md).  
2. Wiring duel events → **Duel client APIs** as hints only.  
3. UI density questions → **Gargul / GRA** rows.  
4. HC naming questions → leave this file; open **track 60**.
