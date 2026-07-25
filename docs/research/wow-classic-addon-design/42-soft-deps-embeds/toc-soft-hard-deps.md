# TOC soft deps, hard deps, and X-Embeds

**Last updated:** 2026-07-25  
**Track:** [42-soft-deps-embeds](README.md)  
**Primary sources:** [TOC format — Warcraft Wiki](https://warcraft.wiki.gg/wiki/TOC_format), [Creating AddOn dependencies — WoWWiki archive](https://wowwiki-archive.fandom.com/wiki/Creating_AddOn_dependencies), [WelcomeHome Ace3 tutorial](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon), [Ace3 Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started).

---

## 1. What the client actually does

| Directive | Client behavior | Failure mode if missing |
|-----------|-----------------|-------------------------|
| `## Dependencies:` (aliases: `RequiredDeps`, any `Dep*`) | Listed addons **must** load before this one | This addon **does not load** |
| `## OptionalDeps:` | Listed addons load first **if present** | This addon still loads; your code must tolerate absence |
| `## X-Embeds:` | **Not a loader directive** — metadata for updaters / nolib / human readers saying “these libs are embedded in this package” | None at load time |
| `## LoadWith:` | When listed addon loads, this one loads; implies LoadOnDemand | Different product shape (plugin) |

Whitespace and comma lists follow normal TOC metadata rules ([wiki](https://warcraft.wiki.gg/wiki/TOC_format)).

**Strategy takeaway:** Soft vs hard is about *whether Beef is allowed to be disabled by another folder missing*. For a guild ladder that officers install first, hard deps create support tickets.

---

## 2. Soft dependency pattern (recommended default)

When you embed Ace/LDB/CTL **and** want to play nice with a user’s standalone Ace3 (or other shared libs):

```
## OptionalDeps: Ace3
## X-Embeds: Ace3

embeds.xml
Core.lua
```

WelcomeHome’s explanation still holds: `OptionalDeps` covers the “standalone Ace3 already installed” load-order case; `X-Embeds` documents what your zip carries for nolib/updater tooling ([WelcomeHome](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon)).

`embeds.xml` (or equivalent early TOC entries) is what actually loads files — OptionalDeps alone never copies libraries into the client.

### Soft-dep coding contract

Per classic dependency HOWTO culture ([archive](https://wowwiki-archive.fandom.com/wiki/Creating_AddOn_dependencies)):

1. Detect optional peers (`LibStub:GetLibrary(..., true)` or `C_AddOns.IsAddOnLoaded` / legacy `IsAddOnLoaded`).
2. Emit **one** clear “feature unavailable” path if needed.
3. Suppress cascade errors after that.

For Beef: optional Masque/LSM/skin hooks later must never throw on fresh Anniversary installs.

---

## 3. Hard dependency — when it is justified

Use `## Dependencies:` only when Beef **cannot meaningfully run** without another *addon folder* the user is expected to install separately (true parent/module relationship).

| Justified | Not justified for Beef V1 |
|-----------|---------------------------|
| Official “Beef_OfficerTools” LoD module that requires `ChurchOfBeef` core | Requiring Ace3 so you can skip embedding |
| Companion that patches another author’s addon and dies without it | Requiring LibDBIcon / CTL / BugSack |
| | Listing every library major as Dependencies “to be safe” |

Synthesis already flags this: hard Dependencies that break solo load are an antipattern for Church of Beef ([00](../00-church-of-beef-implications.md)).

---

## 4. X-Embeds vs OptionalDeps vs store listing

These three layers are often conflated:

| Layer | Where | Meaning |
|-------|-------|---------|
| Loader soft/hard | TOC `OptionalDeps` / `Dependencies` | Client load order / enablement |
| Embed declaration | TOC `X-Embeds` | “This zip contains these libraries” (updater / human / nolib culture) |
| Store relations | `.pkgmeta` `optional-dependencies` / `required-dependencies` | CurseForge/WowUp **listing** only — **no files added** ([pkgmeta wiki](https://github.com/BigWigsMods/packager/wiki/Preparing-the-PackageMeta-File)) |

A correct Ace-embedding addon often has **all three** pointing at related names (`Ace3` in TOC; curse slugs in pkgmeta) — but they are not interchangeable.

---

## 5. Load order inside *your* package

Independent of OptionalDeps:

1. Load LibStub first (`<Script file="Libs\LibStub\LibStub.lua"/>`).
2. Then CallbackHandler / other foundations.
3. Then leaf libs (Ace*, LibDBIcon, CTL, …).
4. Then first-party `Core.lua` / modules.

Prefer `embeds.xml` (or `Libs.xml`) listed **above** first-party files so third-party vs first-party boundaries stay obvious ([Ace3 Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started)).

---

## 6. What not to put in OptionalDeps / X-Embeds

From LibStub project guidance (see [libstub-etiquette-conflicts.md](libstub-etiquette-conflicts.md)):

- **Do not** list `LibStub` as OptionalDeps or X-Embeds.
- Prefer naming the **framework you embed** (e.g. `Ace3`) rather than every leaf folder, unless you embed a non-Ace stack and need precise updater hints.

---

## Beef mapping (TOC only)

| V1 state | TOC guidance |
|----------|--------------|
| Zero embeds | No OptionalDeps / X-Embeds needed |
| CTL (+ LibStub) only | OptionalDeps/X-Embeds usually unnecessary; load via embeds.xml |
| LibDBIcon + LDB | OptionalDeps rarely needed; still no hard Dependencies |
| Future Ace options UI | `OptionalDeps: Ace3` + `X-Embeds: Ace3` + embeds.xml |
| Soft Masque/LSM | `OptionalDeps: Masque` / `LibSharedMedia-3.0` **only if** load order matters; always feature-detect |

Full allow/deny matrix: [beef-v1-dependency-policy.md](beef-v1-dependency-policy.md).
