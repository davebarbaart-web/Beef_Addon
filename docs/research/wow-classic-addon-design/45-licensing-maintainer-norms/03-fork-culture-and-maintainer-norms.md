# Fork culture and maintainer norms

**Last updated:** 2026-07-25  
**Track:** [45-licensing-maintainer-norms](README.md)

## GitHub fork ≠ redistributable fork

Players and authors confuse three different “forks”:

| Action | Usually OK? | Notes |
|--------|-------------|--------|
| Private local edits in `Interface\AddOns` | Yes | Personal use; ElvUI explicitly allows private mods |
| GitHub fork for PRs / backup | Often yes | ElvUI explicitly allows GitHub upload; Gargul still says viewing/forking GitHub **does not** grant redistribute rights |
| Publishing a renamed CurseForge/Wago/WoWI project with copied code | Only if LICENSE allows or author consents | ARR/GPL differ; name collisions are social + moderation issues |
| Taking over the **same** CurseForge project ID | Only via owner transfer / added authors | Abandoned flag ≠ free claim |

## Abandoned addons

Community advice ([r/wowaddons abandoned takeover thread](https://www.reddit.com/r/wowaddons/comments/1d44ze3/has_anyone_taken_on_an_abandoned_addon/); Blizzard UI forum on CF “abandoned” flags):

1. **Read the LICENSE first.** Public Domain / MIT / GPL → legal path to a *new* project is clearer. ARR → need permission or a clean rewrite.
2. **Contact the original author** (Discord, CF PM, email). Best outcome: added as author or ownership transfer of the existing project (preserves URL, comments, download graph).
3. **Do not assume CurseForge “Abandoned” means reclaimable.** During the Twitch→Overwolf migration, many projects were *falsely* marked abandoned when authors had not opted into account transfer ([forum heads-up](https://us.forums.blizzard.com/en/wow/t/curseforge-transfer-marking-projects-as-abandoned/748695)). Ketho’s reply in-thread: picking up abandoned projects depends on license; typically you create a **new** project with the same code only if the license allows.
4. **Rename politely.** “Foo Continued” / “Foo Classic Fix” with clear credit is the social norm when a new project is unavoidable. Shipping under the exact original name while the original listing still exists is how flamewars and CF reports start.

## Maintainer etiquette (scene norms)

- **One canonical download page** per product flavor when possible (CF + optional WoWI/Wago mirrors of *your* builds).
- **Credit** libs and copied snippets even when LICENSE is permissive.
- **Ask before** lifting substantial modules from ARR addons — Torhal/Cairenn-style culture: ARR includes the right to say yes.
- **Don’t strip LICENSE / author TOC fields** when redistributing compilations (UI packs). Authors who allow compilations usually require links back to the project page.
- **Multi-author projects:** document who can push CF releases; bus-factor matters for guild tools that officers depend on mid-raid.

## Brand and comedy-specific fork risk (Beef)

Church of Beef is streamer-facing liturgy, not a generic library. A GPL fork could legally ship “Church of Beef” clones with altered theology strings and confuse Dreamscythe/Doomhowl audiences. Even under MIT, trademark-ish naming and listing impersonation are social/moderation problems. Track 18 already notes non-English guilds replacing liturgy as a *conscious brand fork* — that assumes *permission* or a license that allows it.

Maintainer norms for Beef specifically:

- Keep `## Title` / folder name stable.
- State in README whether community translations/forks are welcome.
- Prefer transferring CF ownership to a trusted co-maintainer over “hope someone forks if I disappear.”

## Cousin-addon license snapshot (loot / guild lane)

| Addon | License signal | Fork posture |
|-------|----------------|--------------|
| Gargul | ARR-style LICENSE; GitHub fork ≠ redistribute grant | Contributions via PR/Discord welcome; public rehost restricted |
| RCLootCouncil | LGPLv3 on CurseForge | More fork-friendly for guild tooling lineage |
| Details! | All Rights Reserved on CF | Classic ARR product |
| WeakAuras | GPL-2.0 | Forks expected; ecosystem depends on it |
| ElvUI | ARR + private mods + GitHub exception | Strict public redistribution control |

Use cousins as UX references; do **not** paste their modules into Beef without license clearance.
