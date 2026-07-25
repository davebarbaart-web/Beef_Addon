# Track 62 — Patch-day / Interface version bump runbook

**Track id:** `62-patch-day-interface-bump`  
**Last updated:** 2026-07-25  
**Lane:** Ops runbook (maintainer process)  
**Maps to:** [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §2 (Anniversary client), §5 (folder / TOC), §12–§13 (portability + shippable guild builds); plan Interface **`20506`** (verify live)

**Scope:** How Classic addon authors (and Beef maintainers) detect an Interface bump, decide TOC-only vs code hotfix, smoke-test, talk to the guild, and clear CurseForge “Unsupported” / out-of-date signals — without re-teaching packager CI or Anniversary↔Era flavor deltas.

**Out of scope (owned elsewhere):**

| Topic | Track |
|-------|--------|
| BigWigs packager, `.pkgmeta`, Actions, upload tokens | [33-packager-ci-releases](../33-packager-ci-releases/) |
| Anniversary vs Era install trees / game-type deltas | [30-anniversary-vs-era-deltas](../30-anniversary-vs-era-deltas/) |
| Full TOC directive catalog & Interface tables | [04 — Interface versions](../04-toc-api-performance/01-interface-versions-and-toc.md) |
| Full V1 QA matrix / BugSack / alpha channels | [19-testing-debugging-qa](../19-testing-debugging-qa/) |
| Changelog copy style | [31 — changelog culture](../31-listing-copy-discovery/changelog-culture.md) |
| Addon implementation / commits in this repo | Not this library |

## Index

| Note | Topic |
|------|--------|
| [detecting-interface-bumps.md](detecting-interface-bumps.md) | Signals that a bump happened; how to read the new number |
| [hotfix-vs-toc-bump.md](hotfix-vs-toc-bump.md) | Decision tree: TOC-only ship vs real code hotfix |
| [smoke-test-after-bump.md](smoke-test-after-bump.md) | Patch-day smoke (thin); escalate to track 19 when broken |
| [guild-comms.md](guild-comms.md) | What to tell officers / members before and after |
| [curseforge-unsupported.md](curseforge-unsupported.md) | Client Out of Date vs CF Unsupported / app warnings |
| [beef-maintainer-checklist.md](beef-maintainer-checklist.md) | Copy/paste T−1d → T+7d checklist |
| [annotated-urls.md](annotated-urls.md) | Annotated primary URLs |

## Top insights for Church of Beef

1. **Interface is a gate, not a changelog.** Older `## Interface:` than the client → **Out of Date**; omitted Interface → always out of date. Probe live with `/dump (select(4, GetBuildInfo()))` — wiki tables lag ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format); [Getting the current interface number](https://wowpedia.fandom.com/wiki/Getting_the_current_interface_number)).

2. **Most Anniversary bumps are TOC-only until smoke fails.** Players may run with **Load Outdated AddOns** until authors ship; authors should *not* tell the guild to hand-edit TOC numbers ([UI FAQ/AddOns — Patch Day](https://warcraft.wiki.gg/wiki/UI_FAQ/AddOns)). Beef: bump TOC after verifying load + ladder/Officer/BeefNet smoke.

3. **Blizzard can change UI without “content” patches.** Kaivax: Classic shares modern UI code; 2.5.5→2.5.6 was mostly services but still moved nameplates/raid frames and set TOC **`20506`**. Authors were told some addons will error until updated ([User Interface Updates in Classic](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408); [Patch 2.5.6/API changes](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes)).

4. **CurseForge “Unsupported” ≠ client Out of Date.** Client cares about TOC Interface. CF listing/app care about **file Supported Version / flavor tags** and whether a compatible file exists for the selected game instance. Clearing the badge means uploading a Release (or Beta) tagged for the new game version — not only editing TOC locally ([Creating and Submitting a Project](https://support.curseforge.com/en/support/solutions/articles/9000197241-creating-and-submitting-a-project); [Updating Addons for New Classic Expansions](https://support.curseforge.com/support/solutions/articles/9000202351-burning-crusade-classic-troubleshooting)).

5. **Guild comms beat silent zip drops.** Pre-patch: “Load Outdated OK; wait for officer ping.” Post-smoke: one Discord/officer note with Interface number + install path reminder (Anniversary folder). Changelog lead with Interface ([track 31](../31-listing-copy-discovery/changelog-culture.md)).

6. **V1 Beef stays Anniversary-only.** Do not widen comma-Interfaces or multi-TOC on patch day “just in case” — that is track 30/33 work. Patch day is: verify number → decide TOC vs hotfix → smoke → ship → tell guild.

## Boundary map

```
Flavor / install tree     ──► Track 30
TOC directive encyclopedia ──► Track 04
How to zip / CI / upload   ──► Track 33
Full guild QA matrix       ──► Track 19
Patch-day ops decision     ──► THIS TRACK
```

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Warcraft Wiki, Blizzard (Kaivax), CurseForge support, and in-client `GetBuildInfo` over listicles. Wiki Interface tables are contributor-maintained — treat as hints, not ground truth.
