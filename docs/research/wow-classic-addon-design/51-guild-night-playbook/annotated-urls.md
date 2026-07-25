# Annotated URLs — guild-night ops analogues

**Track:** [51-guild-night-playbook](README.md)  
**Last updated:** 2026-07-25

Focus: **how guilds launch and facilitate addon-backed social systems**, not calendar/RSVP APIs. For scheduling research, see Track 39 when it exists; for messaging budgets see [14 annotated-urls](../14-addon-messaging-beefnet/annotated-urls.md).

---

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §4.2, §7, §10, §13, §16.6 | Placeholder thresholds, pacing rule, spectacle announce, social check, open threshold question |
| [`docs/research/wow-classic-addon-design/00-church-of-beef-implications.md`](../00-church-of-beef-implications.md) | Synthesis: threshold playtest is a field problem (#8) |
| [`docs/research/wow-classic-addon-design/19-testing-debugging-qa/mock-guild-scenarios.md`](../19-testing-debugging-qa/mock-guild-scenarios.md) | Lab scenarios to smoke before the real night |
| [`docs/research/wow-classic-addon-design/19-testing-debugging-qa/alpha-channels.md`](../19-testing-debugging-qa/alpha-channels.md) | Alpha → guild-night Release distribution ladder |
| [`docs/research/wow-classic-addon-design/14-addon-messaging-beefnet/classic-anniversary-realities.md`](../14-addon-messaging-beefnet/classic-anniversary-realities.md) | Short BeefNet guild-night hygiene checklist |

---

## Facilitator / council analogues (steal process, not loot math)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://rclootcouncil.com/ | RCLC product framing: facilitate a council process with a clear award path — maps to Officer tab + single commit owner. |
| https://www.curseforge.com/wow/addons/rclootcouncil | Retail/main RCLC listing; culture of ML + council + history. |
| https://www.curseforge.com/wow/addons/rclootcouncil-classic | Classic port officers actually install — same facilitation expectations on Anniversary-adjacent clients. |
| https://github.com/evil-morfar/RCLootCouncil_Classic | Classic port source/readme; points at wiki + Discord for operator support culture. |
| https://github.com/evil-morfar/RCLootCouncil2/wiki | Operator docs (features, workflows). **Steal:** test before live raid; keep council small; history for disputes. |
| https://www.youtube.com/watch?v=R_tnBR2BSE0 | 2026 RCLC setup/tutorial stressing **test mode**, council size ≈3–5, history tab for transparency — facilitator lessons for Approving Officers. |
| https://github.com/SafeteeWoW/RCLootCouncil_EPGP | Unofficial EPGP module docs: ML-centric install, council recommended to run related tools — reminds Beef that **not everyone needs officer machinery**, only facilitators. |
| http://www.epgpweb.com/help/system | EPGP system explainer — analogue for “publish the rules before the night,” not for copying EP/GP formulas into Church standing. |

---

## Points / attendance guild culture (pacing & expectations)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.curseforge.com/wow/addons/epgp-dkp-reloaded | Long-running points addon culture: officers maintain shared standing; members expect published rules. |
| https://www.curseforge.com/wow/addons/cegp | CEPGP Classic-era pattern: officer notes as shared store — contrast with Beef’s `RANK_COMMIT` + SV cache (see track 27). |
| https://www.curseforge.com/wow/addons/guildhelperclassic | Guild helper / share culture; early alphas may be noisy — reinforces Alpha cohort vs Release guild-night split. |
| https://legacy-wow.com/mop-addons/guild-2-guild/ | Historical note: guild sync tools expect multiple online clients — justifies two-client smoke before launch. |

---

## Distribution & QA (pre-night pipe)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://wowup.io/guide/my-addons/addons | Per-addon Stable/Alpha/Beta channel — officer pipe before guild-wide Release. |
| https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging | Alpha/Beta/Release tagging + `@alpha@` strips — keep verbose playtest logs out of the live zip. |
| https://warcraft.wiki.gg/wiki/TOC_format | Confirm participants are on the right client/Interface tree when “addon missing” reports roll in. |

---

## Messaging hygiene (escalate, don’t duplicate)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage | Prefix/channel/throttle envelope — if the night dies to sync spam, fix here (track 14), not in threshold numbers. |
| https://www.wowace.com/projects/chatthrottlelib | Pacing library officers should already be running via the addon — not a facilitator tool. |
| https://www.wowhead.com/classic/news/wow-classic-patch-1-13-3-lua-api-change-disabling-addons-from-communicating-in-299371 | Why BeefNet stays on `GUILD` — useful one-liner if someone asks for a custom sync channel mid-night. |

---

## Scheduling platforms (pointers only — not Track 51 research)

Use these to *book* the evening with existing guild habits. **Do not** expand into API matrices here.

| URL | Role vs this track |
|-----|--------------------|
| https://guildsofwow.com/ | Web RSVP / Discord bot — schedule only |
| https://help.guildsofwow.com/ | GoW help center — schedule only |
| https://www.curseforge.com/wow/addons/group-guild-calendar-for-classic-continued | In-game guild calendar port — schedule only |
| Discord Events / guild Discord | Default Church of Beef scheduling surface |

---

## Intentionally omitted

- Full Blizzard Calendar / `C_Calendar` API surface → Track 39  
- Deep BeefNet chunking / CTL math → Track 14  
- Conflict/CRDT theory → Track 27  
- Visual language / toast choreography → tracks 02 / 17 (spectacle *process* is here; pixels are not)
