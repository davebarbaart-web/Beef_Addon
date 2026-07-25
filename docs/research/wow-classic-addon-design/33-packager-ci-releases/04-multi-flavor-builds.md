# Multi-Flavor Builds (Packager + Hosts)

**Last updated:** 2026-07-25  
**Track:** [33-packager-ci-releases](README.md)

**Boundary:** This note is about *how CI produces and labels* multi-client packages. Client-side TOC verification and Anniversary folder pitfalls live in [track 19](../19-testing-debugging-qa/) and [track 30](../30-anniversary-vs-era-deltas/).

---

## 1. Why flavors matter to packager

Blizzard clients pick TOC by suffix (or fallback `AddonName.toc`). CurseForge App additionally needs file **flavor tags** so the right zip lands in the right install tree ([CF Multi-TOC article](https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons); [Warcraft Wiki TOC format](https://warcraft.wiki.gg/wiki/TOC_format)).

Anniversary / TBC Classic uses the **`_TBC`** family (wiki: Burning Crusade Classic & Classic Anniversary Edition → `AddonName_TBC.toc`). Legacy `-BCC` suffix is called out as no longer supported on Anniversary patch notes in the wiki table footnotes ([TOC format — Classic Anniversary](https://warcraft.wiki.gg/wiki/TOC_format)).

---

## 2. Packager strategies

### A. Single zip, multi-TOC (`-S`)

Pass `-S` so packager generates game-type-specific TOC files from one source TOC that declares multiple Interface lines ([Wowpedia](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions); [README](https://github.com/BigWigsMods/packager)):

```toc
## Interface: 110005
## Interface-Wrath: 30403
## Interface-Classic: 11501
```

Resulting package can contain e.g. `AddonName.toc`, `AddonName_Wrath.toc`, `AddonName_Vanilla.toc` in one zip.

v2.3+ also allows comma-separated Interface values and uploads **all** discovered Interface numbers as supported versions ([README / releases](https://github.com/BigWigsMods/packager/releases)).

### B. Multiple packager invocations (`-g`)

Older / dual-branch pattern: run packager twice with different `-g` game versions; `@retail@` / `@non-retail@` TOC blocks flip Interface lines ([Kemayo Classic packaging](https://davidlynch.org/blog/2019/09/world-of-warcraft-classic-addon-packaging/)). Still useful when hosts need separate uploads or WoWI ids differ per flavor.

### C. Long-lived flavor branches

`classic` / `bcc` branches each package one client — higher maintenance; only when code diverges hard ([Kemayo](https://davidlynch.org/blog/2019/09/world-of-warcraft-classic-addon-packaging/)).

---

## 3. Host-specific constraints

| Host | Multi-flavor notes |
|------|--------------------|
| **CurseForge** | One project can host multi-TOC zips; tag flavors on the file page ([CF Multi-TOC](https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons)). Packager sets versions from TOC contents ([PR discussion](https://github.com/BigWigsMods/packager/pull/107)). |
| **Wago Addons** | Metadata fields per family (`supported_bc_patch`, `supported_classic_patch`, `supported_retail_patch`, …) ([Wago docs](https://docs.wago.io/)). Stability: `stable` / `beta` / `alpha`. |
| **WoWInterface** | Historically **no** retail+classic in one addon entry — separate projects / `-w` overrides per job ([Kemayo](https://davidlynch.org/blog/2019/09/world-of-warcraft-classic-addon-packaging/)). Upload typically on **release tags only**. |
| **GitHub Releases** | Attach whatever zip(s) the Action builds; flavor is filename/`{classic}` token. |

---

## 4. Church of Beef stance

| Phase | Packaging stance |
|-------|------------------|
| **V1** | One client: Anniversary TBC. Single TOC `## Interface: 20506` (verify live against `/dump select(4, GetBuildInfo())`). No `-S` required. |
| **Port rehearsal** | Add `_TBC.toc` (or Interface-TBC) only when a second client is real; keep Era/Retail out of V1 success criteria ([spec §12](../../../superpowers/specs/2026-07-25-church-of-beef-design.md); synthesis implication #4). |
| **Public multi-flavor** | Prefer one zip + multi-TOC (`-S`) on CurseForge/Wago; separate WoWI ids if publishing there. |

Filename casing remains a packaging hazard on case-sensitive zip extraction ([spec §5](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

---

## 5. What not to confuse

- **WowUp client selector** (Retail vs Classic vs Anniversary install paths) ≠ packager `-g` ([track 19](../19-testing-debugging-qa/alpha-channels.md)).
- **Wiki Interface table drift** — wiki contributors update numbers; always verify live before tagging a release ([TOC wiki](https://warcraft.wiki.gg/wiki/TOC_format)).
- **`{classic}` zip suffix** is a packager filename flag, not Blizzard’s `_Classic` TOC suffix magic.
