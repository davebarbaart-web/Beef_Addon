# CurseForge “Unsupported” vs client Out of Date

**Track:** [62-patch-day-interface-bump](README.md)  
**Last updated:** 2026-07-25

Three different red flags get conflated on patch week. Clear them separately.

---

## 1. Signal matrix

| Signal | Who shows it | What it means | Cleared by |
|--------|--------------|---------------|------------|
| **Out of Date** (AddOns list) | WoW client | TOC `## Interface` older than client (or missing) | Ship TOC matching `GetBuildInfo`; player updates zip ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format)) |
| **Unsupported** (CurseForge project / browse UI) | CurseForge website when viewing a game version the project has **no tagged files** for | Listing has no file whose **Supported Version** / flavor covers the selected client | Upload a new file and set **Supported Version** for that game ([Creating and Submitting a Project](https://support.curseforge.com/en/support/solutions/articles/9000197241-creating-and-submitting-a-project)) |
| **App warning** (“might be corrupt / Belongs to…”) | CurseForge App | Installed artifact doesn’t match the **game instance** flavor, or file integrity mismatch | Install from the correct flavor dropdown; Update/Reinstall; wait for author upload ([WoW Addons FAQ](https://support.curseforge.com/support/solutions/articles/9000198422-world-of-warcraft-addons-faq-and-troubleshooting); [Updating Addons for New Classic Expansions](https://support.curseforge.com/support/solutions/articles/9000202351-burning-crusade-classic-troubleshooting)) |

**Important:** Editing TOC on disk clears **client** Out of Date for that install only. It does **not** clear CurseForge Unsupported or make WowUp/CF App offer an update.

---

## 2. Author actions that clear CF Unsupported

For V1 Beef (when/if listed publicly):

1. Smoke green on Anniversary ([smoke-test-after-bump.md](smoke-test-after-bump.md)).
2. Package a zip (mechanics → [track 33](../33-packager-ci-releases/) — do not reinvent here).
3. On upload, set **Supported Version** to the new Anniversary / TBC Classic patch (e.g. `2.5.6`), not only Retail.
4. Prefer a **Release** file if you want the CurseForge App to sync by default (CF: projects need at least one Release to sync to the app — [Creating and Submitting a Project](https://support.curseforge.com/en/support/solutions/articles/9000197241-creating-and-submitting-a-project)).
5. Changelog: Interface + patch ([track 31](../31-listing-copy-discovery/changelog-culture.md)).
6. Dual-host: if Wago is used, tag the same game versions there — hosts do not auto-sync ([track 31](../31-listing-copy-discovery/changelog-culture.md)).

Multi-TOC / multi-flavor tagging is packager + CF Multi-TOC territory ([CF Multi-TOC](https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons)). Patch day for Beef V1 should stay **one Anniversary artifact**.

---

## 3. Player-facing guidance (guild paste)

```text
If CurseForge says Unsupported / no update for Anniversary:
  → Wait for our officer file drop, or check the Anniversary / Classic TBC game filter.
If the game says Out of Date but Discord has no new zip yet:
  → Load Outdated AddOns is OK until we ship.
If the CurseForge App says the addon belongs to another flavor:
  → Wrong install instance — use Anniversary, not Era/Retail.
```

App FAQ reminder: a warning does **not** always mean the addon will fail in-game ([WoW Addons FAQ](https://support.curseforge.com/support/solutions/articles/9000198422-world-of-warcraft-addons-faq-and-troubleshooting)) — but Beef officers still prefer a clean Update over “ignore warning.”

---

## 4. Guild-only distribution (no CF yet)

If Church of Beef is Discord/GitHub-only for V1:

- There is **no** CurseForge Unsupported badge to clear.
- Client Out of Date still applies — TOC bump + zip drop is enough.
- When you later list on CF, expect the first post-list patch to teach Supported Version tagging; budget that in the maintainer checklist.

---

## 5. Related but out of scope

| Topic | Where |
|-------|--------|
| Automatic packaging tokens / `@alpha@` | Track 33 / CF Automatic Packaging |
| Listing copy & discovery | Track 31 |
| Flavor install trees | Track 30 |
