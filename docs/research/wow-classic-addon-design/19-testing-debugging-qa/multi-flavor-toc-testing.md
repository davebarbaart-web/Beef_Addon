# Multi-Flavor TOC Testing

**Last updated:** 2026-07-25  
**Track:** [19-testing-debugging-qa](README.md)  
**Related (do not duplicate):** client/TOC depth in library [01-client-flavors-and-toc.md](../01-client-flavors-and-toc.md) and packaging track 05 — this note is **QA procedure only**.

---

## 1. What “multi-flavor” means for testers

WoW clients pick TOC by **suffix** (`_TBC.toc`, `_Vanilla.toc`, `_Mainline.toc`, …) or fall back to `AddonName.toc`. One zip can declare multiple `## Interface:` values comma-separated ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format); [CurseForge Multi-TOC](https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons)).

Wrong Interface → addon marked **Out of Date** / may not load depending on “Load out of date” checkbox. Missing Interface → always out of date ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format)).

---

## 2. V1 Beef gate (Anniversary)

| Check | How |
|-------|-----|
| Live Interface number | `/dump (select(4, GetBuildInfo()))` in **Anniversary** client ([TOC format — GetBuildInfo](https://warcraft.wiki.gg/wiki/TOC_format)) |
| Spec/plan target | `20506` — **verify live**; wiki tables drift (e.g. TBC listed as `20505` in some wiki snapshots) |
| Install tree | Anniversary / TBC Classic folder `Interface/AddOns/ChurchOfBeef` — **not** Era, Retail, or MoP trees |
| Addon list | Appears as **Church of Beef**, enabled, not greyed as wrong flavor |

V1 product decision: **single-flavor TOC** is enough. Multi-flavor is a **regression drill for portability** (spec §12), not a ship requirement.

---

## 3. QA matrix when multi-TOC appears later

| Client install | Expected TOC resolution | Pass criteria |
|----------------|-------------------------|---------------|
| TBC Anniversary | `_TBC.toc` or Interface including Anniversary number | Loads; `/beef` works |
| Classic Era | `_Vanilla.toc` or Era Interface | Either loads intentionally **or** clearly absent — never silent wrong ladder |
| Retail | `_Mainline.toc` | Prefer **not load** for V1-scoped builds |
| MoP / Cata | Matching suffix | Port-only |

**CurseForge App note:** Multi-TOC needs correct file tagging and folder naming so the manager installs the right artifact per client ([Multi-TOC support article](https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons)).

**Automation helpers (authors):** [p3lim/toc-interface-updater](https://github.com/p3lim/toc-interface-updater) updates Interface lines per flavor (includes `tbc` / `anniversary` aliases); BigWigs packager can emit flavor TOC variants. Use these in CI later — still **confirm in-game** once per flavor.

---

## 4. TOC testing checklist (copy/paste)

1. Note `GetBuildInfo()` interface on the client under test.
2. Confirm `## Interface:` in the loaded TOC matches (or comma-list includes) that number.
3. Confirm folder name == TOC basename (`ChurchOfBeef/ChurchOfBeef.toc`).
4. Toggle “Load out of date AddOns” **off** — Beef must still load on target flavor with correct Interface.
5. `/reload` after TOC edits; check BugSack for load errors.
6. If using `_TBC.toc` + root `.toc`, document which file Anniversary actually loads after a rename test.

---

## 5. Beef-specific pitfalls

- **Dreamscythe vs Doomhowl** are separate guilds — TOC flavor is orthogonal to realm, but testers must not mix SavedVariables across clients when comparing ladders.
- **Comma-delimited Interface** that includes Retail numbers can make the addon look “supported” on Mainline while APIs diverge — for V1, prefer **Anniversary-only** Interface to fail loud on wrong clients.
