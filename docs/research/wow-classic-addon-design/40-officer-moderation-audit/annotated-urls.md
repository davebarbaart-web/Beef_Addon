# Annotated URLs — Track 40

Primary references used for officer moderation / audit / transparency patterns. Steal/adapt notes are for Church of Beef product design, not implementation.

---

## Design truth (repo)

| URL / path | Why it matters | Steal / adapt |
|------------|----------------|---------------|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Locked V1: hybrid approve, officer anti-cheat, reject leaves points, demote, announces, revisions | Product baseline — do not contradict without decisions-log update |

---

## Classic addon precedents

| URL | Why it matters | Steal / adapt |
|-----|----------------|---------------|
| [RCLootCouncil — Loot History wiki](https://rclootcouncil.com/wiki/Loot-History) | Officer history UI: filters, export, per-award rows, delete-without-undo, local vs session edits | Steal row/filter/export *mindset*; avoid no-undo delete and loot density |
| [RCLootCouncil History Explorer](https://rclootcouncil.com/history) | External history surface for RCL | Later inspiration only; V1 stays in-game |
| [RCLootCouncil ↔ EPGP — undo GP via history](https://groups.google.com/g/epgp-discuss/c/cI3TwSHD3ZM) | Explicit undo-last-GP then re-award workflow | Model Beef undo as compensating actions |
| [CEPGP — WowInterface](https://www.wowinterface.com/downloads/info25051-CEPGP.html) | Officer-note storage, traffic window, `!info` member queries, edit vs view privilege | Steal traffic + member-readable standing; avoid notes as ladder DB |
| [CEPGP — CurseForge](https://www.curseforge.com/wow/addons/cepgp) | Packaging / description mirror of Classic EPGP tooling | Same as above |
| [CEPGP \<Lore\> — WowUp](https://wowup.io/addons/475100) | Documents `/cep traffic`, whisper info commands clearly | Cite for traffic/command UX |
| [Legacy-WoW CEPGP page](https://legacy-wow.com/classic-addons/cepgp/) | Secondary Classic listing; officer-note requirements | Corroboration only |
| [EPGP-Classic manageRank / invalid notes](https://github.com/jpxthu/EPGP-Classic/blob/master/epgp.lua) | Rank management + invalid officer-note reporting | Edge reminder: human-editable stores need ignore/error paths |
| [EPGP issue — public notes for storage](https://github.com/Ex1sten/epgp/issues/493) | Guilds often make officer notes world-readable for transparency | Norm: read-wide, write-narrow |
| [RCLootCouncil — Wago](https://addons.wago.io/addons/rclootcouncil) | Canonical RCL distribution hub | Discovery pointer |
| [RCLootCouncil + wowaudit — Wago](https://addons.wago.io/addons/rclootcouncil-wowaudit) | Context data at award time (sims/wishlists) | Analogy: show standing breakdown at approve time |

---

## Guild culture / drama vectors

| URL | Why it matters | Steal / adapt |
|-----|----------------|---------------|
| [Guild Order — DKP vs EPGP vs LC](https://guildorder.com/games/wow/guides/loot-systems-dkp-vs-epgp) | Drama vectors; LC fails without written rubric; trust prerequisite | Publish Beef rubric; don’t run opaque council |
| [Guild Order wiki — loot systems](https://guildorder.com/games/wow/wiki/loot-systems) | “Public log of every distribution”; explain decisions | Member-visible last actor + announce |
| [Blizzard forums — LC not a good system](https://us.forums.blizzard.com/en/wow/t/loot-council-is-not-a-good-system/244456) | Favoritism / split risk of pure judgment systems | Beef hybrid needs visible criteria |
| [FrostyBoost — loot systems explained](https://frostyboost.com/blog/everything-about-gdkp-in-world-of-warcraft) | LC cons: subjective, drama, trust-required | Same; keep comedy tone without hiding actors |
| [Rift forums — LC abuse aside](http://forums.riftgame.com/game-discussions/dungeons-raids/226486-whats-you-thought-loot-council.html) | Older MMO echo: council can be abused by officers | Insider-threat framing |

---

## General product / governance patterns

| URL | Why it matters | Steal / adapt |
|-----|----------------|---------------|
| [Flagsmith — Four Eyes Principle](https://www.flagsmith.com/blog/what-is-the-four-eyes-principle) | Risk tiers, change requests, automatic audit, emergency bypass, no self-approve | Tiered confirm for demote/Prophet/wipe; full dual-approve later |
| [ChequeDB — four eyes + immutable audit schema](https://chequedb.com/resources/blog/four-eyes-principle-foundations) | Actor, timestamp, action, before/after payload | Schema checklist for Beef audit rows |
| [GetStream — Moderation Policy Audit Logs](https://www.prlog.org/13138222-feature-announcement-moderation-policy-audit-logs.html) | Before/after diffs, actor filters, T&S investigation UX | Officer Recent Actions filters |
| [Devolutions — four-eyes concept](https://docs.devolutions.net/rdm/concepts/advanced-concepts/four-eyes-principle) | Dual approval definition | Vocabulary only |
| [t2informatik — four-eyes](https://t2informatik.de/en/smartpedia/four-eyes-principle) | Short definition | Vocabulary only |
| [Cakey Bot — Discord audit log](https://wiki.cakey.bot/en/moderation/audit-log) | Moderator actions logged with reasons; before/after nickname/roles | Community-moderation UX parallel (not WoW API) |
| [Stack Exchange — dual inspection](https://softwareengineering.stackexchange.com/questions/152018/dual-inspection-four-eyes-principle) | Workflow-engine framing of maker-checker | Avoid overbuilding workflow engines in V1 |

---

## Sibling research (in-repo)

| Path | Role |
|------|------|
| [../01-ux-patterns/loot.md](../01-ux-patterns/loot.md) | Officer queue ≈ award/pass |
| [../13-cousin-addon-teardowns/](../13-cousin-addon-teardowns/) | Attune / Gargul / RP IA |
| [../16-guild-roster-officer-edges/](../16-guild-roster-officer-edges/) | Who is Officer+ |
| [../26-ladders-points-gamification/](../26-ladders-points-gamification/) | Ladder / toxicity context |
| [../27-desync-conflict-resolution/](../27-desync-conflict-resolution/) | Revision / compensating-write mechanics |
| [../00-church-of-beef-implications.md](../00-church-of-beef-implications.md) | Officer gate as anti-cheat synthesis |

---

## Provenance dumps

Search/extract JSON and markdown under [`.raw/`](.raw/):

- `search-officer-moderation.json`
- `search-product-moderation-patterns.json`
- `search-rcloot-history.json`
- `search-accountability-patterns.json`
- `search-guild-drama-transparency.json`
- `extract-rcl-loot-history.md`
- `extract-rcl-undo-epgp.md`
- `extract-cepgp-traffic.md`
- `extract-four-eyes.md`
- `extract-rcl-site-history.md`
