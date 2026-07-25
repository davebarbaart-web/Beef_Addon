# Detecting Interface bumps

**Track:** [62-patch-day-interface-bump](README.md)  
**Last updated:** 2026-07-25

How authors know the client moved — and what number to put in `## Interface:`.

---

## 1. What “out of date” means in-client

From [TOC format](https://warcraft.wiki.gg/wiki/TOC_format):

| Condition | Client behavior |
|-----------|-----------------|
| Addon `## Interface` **older** than client Interface | Addon classified **out of date** |
| `## Interface` **omitted** | Treated as **always** out of date |
| Numbers match (or comma-list includes client) | Not out of date for that reason |

Players clear the load gate with **Load Outdated AddOns** on the Character Select → AddOns panel ([UI FAQ/AddOns](https://warcraft.wiki.gg/wiki/UI_FAQ/AddOns); [WoWInterface install FAQ](https://www.wowinterface.com/forums/faq.php?faq=install)). That does **not** make the addon “current” for authors — it only lets the client load it.

---

## 2. Authoritative ways to read the new number

Use these in order. Prefer live client over secondary docs.

| Method | How | Trust |
|--------|-----|-------|
| **`GetBuildInfo`** | In Anniversary chat: `/dump (select(4, GetBuildInfo()))` | Highest — what the client actually uses ([TOC format — GetBuildInfo](https://warcraft.wiki.gg/wiki/TOC_format); [Wowpedia](https://wowpedia.fandom.com/wiki/Getting_the_current_interface_number)) |
| **Peer TOC** | Open a *freshly updated* popular addon’s TOC that is **not** marked out of date | High if you trust that author just shipped |
| **Wiki patch API page** | e.g. [Patch 2.5.6/API changes](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes) lists `TOC: 20506` | High shortly after patch; still verify in-game |
| **Wiki latest-interfaces table** | [TOC format](https://warcraft.wiki.gg/wiki/TOC_format) / `API_LatestInterface` template | Medium — contributor lag (snapshots still listed TBC as `20505` after 2.5.6 docs said `20506`) |
| **`WTF/Config.wtf` `lastAddonVersion`** | Classic/Anniversary tree after at least one post-patch launch | Historical author tip ([Wowpedia](https://wowpedia.fandom.com/wiki/Getting_the_current_interface_number)); confirm with `GetBuildInfo` |

**Church of Beef V1:** plan/spec target was **`20506`**. After every Anniversary maintenance, re-run `GetBuildInfo` before tagging a release. Never assume the number from last month’s research note.

---

## 3. Early-warning signals (before guild Discord melts)

| Signal | Where | Action |
|--------|-------|--------|
| Weekly maintenance / patch notes mention UI, Edit Mode, nameplates, raid frames | Blizzard forums / in-game news | Schedule maintainer smoke window |
| Kaivax-style “shared UI code / addons may error” posts | e.g. [User Interface Updates in Classic](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408) | Treat as **API-risk** patch, not TOC-only by default |
| Character Select: Beef (or everything) grey / Out of Date | AddOns list | Capture `GetBuildInfo`; decide TOC vs hotfix ([hotfix-vs-toc-bump.md](hotfix-vs-toc-bump.md)) |
| CurseForge / WowUp: no update for new game version; “Unsupported” / flavor warning | Listing or app | See [curseforge-unsupported.md](curseforge-unsupported.md) — separate from TOC |
| Officer reports: BugSack on login after maintenance | Guild Discord | Skip TOC-only path; go straight to code smoke |

---

## 4. Optional automation (detect, don’t auto-ship)

[p3lim/toc-interface-updater](https://github.com/p3lim/toc-interface-updater) can bump TOC Interface lines per flavor (`tbc` / `anniversary` aliases). Useful as a **PR signal** that upstream Interface moved — not as an unattended guild Release. Always confirm with in-client `GetBuildInfo` and the smoke checklist before announcing.

Packager / multi-flavor build mechanics stay in [track 33](../33-packager-ci-releases/). This track only cares that someone noticed the number changed.

---

## 5. What *not* to do when detecting

- Do **not** tell players to hand-edit every TOC to silence Out of Date — destroys the diagnostic signal ([UI FAQ/AddOns](https://warcraft.wiki.gg/wiki/UI_FAQ/AddOns)).
- Do **not** trust a Retail Interface scraped from a blog for Anniversary.
- Do **not** treat “Era got a patch” as “Anniversary Interface moved” (or the reverse) — verify on the **Anniversary** client ([track 30](../30-anniversary-vs-era-deltas/) for install trees).
