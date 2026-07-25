# Client Flavors, Install Paths, and TOC Versioning

**Last updated:** 2026-07-25  
**Primary sources:** [TOC format (warcraft.wiki.gg)](https://warcraft.wiki.gg/wiki/TOC_format), Blizzard Watch Classic UI notes (Jul 2026), community Anniversary install reports.

---

## 1. Why this matters for Church of Beef

V1 is locked to **TBC Classic Anniversary**. Wrong `## Interface`, wrong install folder, or assuming Era/Retail APIs will make the addon show as out-of-date, invisible, or crash. Portability to Classic+ later depends on isolating TOC / flavor checks (already in the design spec §12).

---

## 2. Classic client landscape (2026)

Contemporary “Classic” is not one client:

| Flavor | Typical Interface (wiki table, verify in-game) | Notes |
|--------|-----------------------------------------------|--------|
| Classic Era / Vanilla-line | `11509` (Vanilla), test `11508` | Era, Hardcore, SoD share Era-line infrastructure with patch drift |
| **TBC Anniversary / TBC** | **`20506`** | Spec/plan target for Church of Beef |
| Wrath Classic (legacy) | `30405` | Historical |
| Titan Reforged | `38001` | Separate Wrath-era line |
| Cataclysm Classic | `40402` | Progression Classic |
| MoP Classic | `50504` | Current progression Classic as of wiki table |
| Retail / Midnight | `120007` etc. | Not V1 |

**Verify live:** `/dump (select(4, GetBuildInfo()))` in that client ([wiki](https://warcraft.wiki.gg/wiki/TOC_format#Determining_the_interface_version)).

Community reporting (Anniversary launch window): Anniversary is a **separate install / AddOns tree** from Classic Era — players must copy or reinstall addons into the Anniversary directory. Do not assume Era SavedVariables or AddOns folders auto-transfer.

---

## 3. TOC essentials

From [TOC format](https://warcraft.wiki.gg/wiki/TOC_format):

- Folder name must match `.toc` basename (`ChurchOfBeef/ChurchOfBeef.toc`).
- `## Interface:` marks out-of-date vs current client. Omit it → always out of date.
- **Multi-flavor single TOC:** comma-delimited Interfaces are supported, e.g.  
  `## Interface: 120007, 50504, 38001, 20506, 11509`
- Files load top-to-bottom; XML can pull additional scripts via `Include` / `Script`.
- Prefer backslashes in TOC paths for `Include` compatibility.

### Client-specific TOC suffixes

| Suffix | Loads on |
|--------|----------|
| `_TBC.toc` | Burning Crusade Classic **and Classic Anniversary Edition** |
| `_Vanilla.toc` | Classic Era line |
| `_Cata.toc`, `_Mists.toc`, `_Wrath.toc` | Named Classic expansions |
| `_Classic.toc` | All Classic clients (behavior updated across patches so it is not Era-only) |
| `_Mainline.toc` | Retail |

Wiki guidance: prefer comma-delimited Interface versions or per-file `[AllowLoadGameType …]` conditions over proliferating TOC files when possible.

**Anniversary note (Patch 2.5.5, 2026-01-13):** `_Classic` suffix behavior changed to load on all Classic clients (aligned with similar Cata/Titan changes). For V1, a single `ChurchOfBeef.toc` with `## Interface: 20506` is the simplest correct choice; add `_TBC.toc` or multi-Interface only when porting.

### AllowLoadGameType

Game types include `tbc`, `vanilla`, `cata`, `mists`, `wrath`, `mainline`. Example:

```
VanillaOrTBC.lua [AllowLoadGameType vanilla, tbc]
```

Useful later for Classic+ ports; unnecessary complexity for V1 single-flavor.

---

## 4. SavedVariables directives (TOC)

| Directive | Storage path (conceptually) | Use |
|-----------|----------------------------|-----|
| `## SavedVariables:` | Account-wide under WTF account | Profiles shared across characters |
| `## SavedVariablesPerCharacter:` | Per-character WTF path | Character-local state |
| `LoadSavedVariablesFirst` | Load SV before scripts | Rare; advanced load-order cases |

Church of Beef V1: **`SavedVariablesPerCharacter: ChurchOfBeefDB`** (design spec §9) — alts start Fresh Beef.

---

## 5. Shared code with retail — UI drift risk

[Blizzard Watch (2026-07-22)](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/): Classic clients share code with retail generations; Anniversary TBC mirrors contemporary retail codebases. Recent Classic UI updates modernized nameplates/raid frames/Edit Mode options toward Midnight aesthetics. Implication:

- Default Blizzard UI is **not frozen 2007 chrome**.
- Addon UIs that assume “pure Vanilla pixels” may already look mismatched next to default frames.
- Still avoid **Retail-only APIs** and Dragonflight-era assumptions (project hard rule).

---

## 6. Practical checklist for Beef TOC

- [ ] `## Interface: 20506` (or verified current Anniversary build)
- [ ] `## Title: Church of Beef` (+ Notes that sell the joke without looking like a DPS helper)
- [ ] `## SavedVariablesPerCharacter: ChurchOfBeefDB`
- [ ] Optional later: `## OptionalDeps: Ace3` only if embedding/soft-depending
- [ ] Document install path: `Interface/AddOns/ChurchOfBeef` under the **Anniversary** client folder
- [ ] When Classic+ appears: isolate Interface + game-type gates; keep canon/scoring UI IA stable (spec §12)

---

## Sources

- [TOC format — Warcraft Wiki](https://warcraft.wiki.gg/wiki/TOC_format)
- [Blizzard Watch — modernized Classic/Anniversary UI (Jul 2026)](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)
- Plan: `docs/superpowers/plans/2026-07-25-church-of-beef-v1.md` (`Interface 20506`)
