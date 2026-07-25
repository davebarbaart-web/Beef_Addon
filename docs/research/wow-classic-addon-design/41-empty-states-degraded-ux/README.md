# Track 41 — Empty states & degraded UX

**Track id:** `41-empty-states-degraded-ux`  
**Last updated:** 2026-07-25  
**Sole focus:** First-install, not-in-guild, no-officers-online, peers-without-addon, and sync-pending UX — Classic cousin patterns + Church of Beef copy/IA.  
**Out of scope:** BeefNet transport budgets (track 14), conflict/revision theory (track 27), slash verb inventory (track 22), full onboarding settings trees (track 11), general microcopy system (track 32). No addon implementation in this folder.

## Product truth (from V1 spec)

| Situation | Locked behavior |
|-----------|-----------------|
| Not in a guild | Empty-state ladder; scoring paused |
| Not Officer+ | Officer tab hidden; approve actions no-op |
| Shared instance credit | Guildmate in party/raid; **they need not run the addon** for local credit |
| Players without addon | Invisible to BeefNet; guild play must not soft-lock |
| No peer answers sync | Keep SV cache; reconcile when someone appears |
| Guild-chat promotion line | Visible to members *without* the addon (spectacle budget) |
| Frame always exists | `/beef` opens a real frame — never “command works, nothing appears” |

Sources: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §7.1, §8.2–§8.3, §10–§11, §13.

## Index

| Note | Covers |
|------|--------|
| [scenario-matrix.md](scenario-matrix.md) | Five degraded scenarios × what the UI must say / hide / still allow |
| [classic-cousin-patterns.md](classic-cousin-patterns.md) | Attune / Gargul / RCL / GRM / CEPGP empty & peer patterns |
| [beef-copy-ux-map.md](beef-copy-ux-map.md) | Beef-flavored heading / body / status-chip proposals per scenario |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Empty ≠ broken.** Spec §11 already names “empty-state ladder” for unguilded players. UX research converges on the same rule: never leave a blank panel — state *why* it’s empty and what (if anything) the player can do ([NN/g empty-state guidelines](https://www.nngroup.com/articles/empty-state-interface-design/); [Eleken empty-state guide](https://www.eleken.co/blog-posts/empty-state-ux)).

2. **Five scenarios need five messages — not one “No data” string.** First install (onboarding), not in guild (hard gate), no officers online (queue / cache), peers without addon (partial mesh), sync pending (transient status) are different *forces*: status vs learning vs pathway ([NN/g](https://www.nngroup.com/articles/empty-state-interface-design/); four-type framing in [Tour Kit / onboarding empty states](https://usertourkit.com/blog/empty-states-that-convert-onboarding-design-patterns)).

3. **Local value must work alone; social value degrades gracefully.** Cousins split this well: Gargul’s “only loot master needs the addon for most features” + plain-chat spectacle ([Gargul CurseForge / Wago](https://www.curseforge.com/wow/addons/gargul)); Attune’s personal tree always works while guild survey explicitly requires peers ([Attune](https://www.curseforge.com/wow/addons/attune)). Beef already locks the same split: local standing + guildmate instance credit without peer addon; ladder sync and officer commit need the mesh.

4. **“Waiting for response” is a first-class pattern.** RCLootCouncil’s version checker shows every queried name as *Waiting for response*, then marks non-responders as not installed after ~5s ([RCL Version Checker wiki](https://github.com/evil-morfar/RCLootCouncil2/wiki/Version-Checker)). Steal the *status progression* for Beef sync: Pending → Using cache / No peers online — never infinite spinner with no copy.

5. **Hard gates use soft tone.** CEPGP/GRM-style tools hide or soft-deny when officer notes / ranks aren’t available (“elements visible when relevant”) ([CEPGP](https://www.wowinterface.com/downloads/info25051-CEPGP.html)). Beef: hide Officer tab; for unguilded, show ladder chrome with ranks as *empty shelves* + one clear join-guild line — do not error-toast on every `/beef`.

6. **Guild-chat announce is the no-addon peer UX.** Spec success criterion §13.11 and implications synthesis already treat plain guild chat as the spectacle that reaches non-installers. Degraded mesh UX should *point at* that channel (“ranks still shout in guild chat”) instead of nagging every raider to install.

## Boundary map

| This track (41) | Sibling |
|-----------------|---------|
| What the frame / tabs / status line say when data is missing or stale | Track 14 — how `SYNC_*` is paced |
| Player-facing degraded scenarios | Track 27 — merge predicates when data *does* arrive |
| Copy shape per scenario | Track 32 — global voice system (defer full voice bible) |
| First-open empty ladder | Track 11 — settings density / options trees |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer design spec for product truth; Wowpedia / cousin listings / NN/g for patterns.
