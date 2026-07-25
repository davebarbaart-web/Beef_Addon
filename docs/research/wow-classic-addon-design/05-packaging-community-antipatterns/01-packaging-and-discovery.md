# Packaging & Discovery Norms (CurseForge / Wago / WowInterface)

**Last updated:** 2026-07-25  
**Audience:** Authors packaging a Classic-first social/guild addon (Church of Beef).

---

## 1. The three hubs (what players actually use)

Mature Classic addons typically publish to **more than one** hub. None fully owns Classic discovery:

| Hub | Role in 2024–2026 | Automation path |
|-----|-------------------|-----------------|
| **CurseForge** | Largest library + CurseForge App; moderation gate on new projects | Webhook packaging and/or [BigWigs packager](https://github.com/BigWigsMods/packager) (`-p` / `X-Curse-Project-ID`) |
| **Wago Addons** | Modern alternate storefront + Wago App; packager-first culture | Packager `WAGO_API_TOKEN` + `## X-Wago-ID:` ([docs.wago.io](https://docs.wago.io/)) |
| **WowInterface** | Veteran repository; still used by long-lived UI projects and players who avoid Overwolf apps | Packager `-w` / `## X-WoWI-ID:` or manual ZIP |

**Cross-check:** BigWigs packager README states it can zip and upload to CurseForge, WowInterface, Wago, and GitHub Releases from one release tag. Wago’s own docs treat the packager as the default publish path.

**Church of Beef implication:** Plan for CurseForge + Wago at minimum; WowInterface is optional but cheap if packager IDs are set early.

---

## 2. CurseForge author norms

Sources: [Creating and Submitting a Project](https://support.curseforge.com/en/support/solutions/articles/9000197241-creating-and-submitting-a-project), [Project Submission Guide and Tips](https://support.curseforge.com/support/solutions/articles/9000199552-project-submission-guide-and-tips), [Automatic Packaging](https://support.curseforge.com/en/support/solutions/articles/9000197281-automatic-packaging), [Multi-TOC for WoW Addons](https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons).

### 2.1 Project creation fields that matter for discovery

Verified required/expected fields on project create:

| Field | Norm |
|-------|------|
| **Name** | Unique; avoid version numbers and embedding the word “addon” ([tips](https://support.curseforge.com/support/solutions/articles/9000199552-project-submission-guide-and-tips)) |
| **Summary** | Short blurb for listings |
| **Description** | Long-form; **titles and descriptions must be in English**; must sufficiently describe the project or moderation rejects |
| **License** | Dropdown (or custom) |
| **Class** | Root type (Addons for WoW) |
| **Main category** | Primary filter bucket |
| **Additional categories** | Up to **4**; irrelevant tags may be sent back |
| **Logo** | Unique project icon; tips recommend **≥ 400×400 PNG, 1:1** |

Submission is incomplete until a **file** is uploaded; projects await moderator approval.

### 2.2 Images & listing quality

CurseForge tips explicitly push **in-game screenshots** of the addon enabled, plus optional UI-instruction images. Screenshots are not always mandatory for “mods/addons” the way they are for texture packs, but they are the practical discovery surface.

### 2.3 Categories useful for Church of Beef

Wago’s browse surface lists **Guild** and **Roleplay** among addon categories ([addons.wago.io](https://addons.wago.io/)). CurseForge’s WoW taxonomy is broader (Guild, Roleplay, Chat & Communication, UI Mods, Miscellaneous, etc. — verify on project create UI; do not invent tags).

**Practical listing strategy for Beef:**

- Main: **Guild** (rank ladder / officer approval is guild social tooling)
- Additional: **Roleplay** (religious-sports theater brand) and/or **Chat & Communication** only if the addon actually posts/coordinates in chat
- Avoid combat categories — false advertising and wrong discovery audience

### 2.4 Packaging automation on CurseForge

- Optional repo webhook → CurseForge package API (`/api/projects/{id}/package?token=…`)
- Tag naming drives **alpha / beta / release** when the word `alpha` or `beta` appears in the tag
- Optional **`pkgmeta.yaml` / `.pkgmeta`**: package name, externals, move/ignore paths, dependencies, changelog override

### 2.5 Multi-TOC + flavor tagging

CurseForge documents Multi-TOC (post–Burning Crusade Classic): one project, multiple TOC flavors; **TOC basename must match parent folder** or the validator/client fails. Authors must also **tag supported game flavors on the file upload page** so the CurseForge App maps the ZIP to the right client.

---

## 3. Wago Addons norms

Sources: [docs.wago.io](https://docs.wago.io/), [addons.wago.io](https://addons.wago.io/), [BigWigsMods/packager](https://github.com/BigWigsMods/packager).

### 3.1 Packager-first publish

1. Create project; copy **8-character alphanumeric** project id from developer dashboard.
2. Add anywhere in `.toc`:

   ```text
   ## X-Wago-ID: as3Dfg57
   ```

3. Set GitHub secret `WAGO_API_TOKEN` (from [API keys](https://addons.wago.io/account/apikeys)).
4. Run BigWigs packager Action with `WAGO_API_TOKEN` in `env`.

### 3.2 Manual API (if not using packager)

`POST https://addons.wago.io/api/projects/<id>/version` with bearer token and multipart:

- `metadata` JSON: `label`, `stability` (`stable`|`beta`|`alpha`), `changelog` (markdown), plus at least one of `supported_retail_patch` / `supported_wotlk_patch` / `supported_bc_patch` / `supported_classic_patch`
- `file`: the ZIP

Patch catalog: `https://addons.wago.io/api/data/game`.

### 3.3 Why Wago matters for Classic social addons

- Explicit **Burning Crusade Classic** and **Classic Era** flavor filters on the site home
- Same Guild / Roleplay discovery language players already use for WA UI packs
- Dual-publish is nearly free once packager IDs exist

---

## 4. WowInterface norms

Sources: [WowInterface Developer FAQ hub](https://www.wowinterface.com/forums/faq.php?faq=developer), packager support for `-w` / `## X-WoWI-ID:`.

- Manual ZIP upload remains the mental model; Git/SVN help and auto-zip tooling still exist on the site.
- Universal packaging rule (also true everywhere else): **ZIP contains `AddonName/AddonName.toc` at the root** — not a nested extra folder, and not loose files without the folder.
- Smaller, older audience than CurseForge, but still a legitimacy signal for Classic-era UI tools.

---

## 5. TOC & zip conventions authors are judged by

Primary reference: [Warcraft Wiki — TOC format](https://warcraft.wiki.gg/wiki/TOC_format).

### 5.1 Hard rules

- Folder name == `.toc` basename (`Interface/AddOns/ChurchOfBeef/ChurchOfBeef.toc`)
- Missing / wrong `## Interface:` → treated as **out of date**
- Comma-separated Interface lists are supported, e.g. wiki example includes `20506` (TBC)

### 5.2 Client-specific TOC suffixes (current wiki table)

Prefer comma Interface lists / per-file conditionals when possible; suffixes when APIs diverge:

| Suffix | Targets |
|--------|---------|
| `_TBC.toc` | Burning Crusade Classic **and** Classic Anniversary Edition |
| `_Vanilla.toc` | Classic Era |
| `_Classic.toc` | All Classic expansions (lower priority than specific suffixes) |
| `_Wrath.toc` / `_Cata.toc` / `_Mists.toc` | Later Classic progressions |
| Legacy | `-BCC`, `-WOTLKC` still recognized |

**Church of Beef V1:** design spec / plan use **`Interface: 20506`** for TBC Anniversary — matches wiki’s TBC / TBC Test value as of this research pass. Confirm with `/dump (select(4, GetBuildInfo()))` on the live Anniversary client before each release.

### 5.3 Distribution metadata in TOC (packager)

```text
## X-Curse-Project-ID: 1234
## X-WoWI-ID: 5678
## X-Wago-ID: he54k6bL
```

(From [BigWigs packager README](https://github.com/BigWigsMods/packager).)

### 5.4 Retail-only discovery note (do not depend on for Classic V1)

Dragonflight+ **Addon Compartment** TOC directives (`AddonCompartmentFunc*`) reduce minimap-button sprawl on retail. Classic Anniversary may not have the same compartment — treat as a future portability note, not a V1 dependency. ([Wiki section](https://warcraft.wiki.gg/wiki/TOC_format#Addon_compartment_integration))

---

## 6. Changelog & versioning norms

| Practice | Why |
|----------|-----|
| Semver in `## Version:` | Players see it in Addon List; packagers use tags as versions |
| Per-file changelog on CF/Wago | Surfaces in update UIs |
| Alpha/beta tags | CurseForge auto-marks release type from tag text |
| Bump Interface before patch day | Avoids “out of date” surge complaints |

---

## 7. Discovery checklist (Beef-shaped)

1. English summary that says **guild rank ladder + officer approval**, not “raid helper.”
2. Logo that reads as Church of Beef (brand), not generic sword icon.
3. Screenshots: ladder frame open, toast/promotion moment, minimap entry — **edge UI**, not center combat HUD.
4. Categories: Guild (+ Roleplay).
5. Flavor tags: Burning Crusade Classic / Anniversary only for V1.
6. Dual-publish CurseForge + Wago via packager once IDs exist.
7. Clear install path text matching spec: `Interface/AddOns/ChurchOfBeef`.
