# Hotfix vs TOC bump

**Track:** [62-patch-day-interface-bump](README.md)  
**Last updated:** 2026-07-25

Decision tree for what to ship after an Interface (or client) change. “Hotfix” here means **author code fix**, not Blizzard’s silent server hotfix.

---

## 1. Two different “patch day” outcomes

| Outcome | Symptom | Author response |
|---------|---------|-----------------|
| **Interface-only** | AddOns list shows Out of Date; load works with Load Outdated; no BugSack; ladder/Officer/BeefNet OK | **TOC bump** (+ changelog “Requires Interface N”); optional no-op Lua |
| **Breaking / risky UI sync** | Lua errors, missing frames, secure/taint issues, roster/messaging weirdness, or Blizzard warned addons may break | **Code hotfix** (then TOC bump to new Interface) |
| **Blizzard hotfix, no Interface change** | Build string may move; `GetBuildInfo` Interface **unchanged**; weird new bugs | Fix if Beef broken; **do not** invent a fake Interface bump |

Wiki player guidance: many addons still work when “technically” out of date; update when broken or when authors ship ([UI FAQ/AddOns — Patch Day](https://warcraft.wiki.gg/wiki/UI_FAQ/AddOns)). Authors still owe a TOC bump so the guild can turn Load Outdated **off** and trust the AddOns list again.

---

## 2. Decision tree (Beef-shaped)

```
Post-maintenance Anniversary login
        │
        ▼
GetBuildInfo Interface == TOC?
        │
   yes ─┴─ no
    │         │
    │         ▼
    │    Enable Load Outdated temporarily (author machine)
    │         │
    │         ▼
    │    Smoke: /reload, /beef, Officer tab, one BeefNet approve
    │         │
    │    ┌────┴────┐
    │  clean     errors / wrong behavior
    │    │         │
    │    ▼         ▼
    │  TOC-only   Code hotfix path
    │  ship       (bisect, fix, then TOC)
    │
    ▼
If Interface already matched but something broke:
  → Code hotfix (Blizzard UI sync / silent change)
```

**Rule of thumb:** If smoke is clean with Load Outdated, ship TOC-only the same day. If smoke fails, do not publish a TOC-only “green” file that lies about compatibility.

---

## 3. TOC-only ship (checklist)

Use when smoke is clean.

1. Set `## Interface:` to live `GetBuildInfo` value (Anniversary V1: single number, not a comma kitchen-sink).
2. Bump `## Version:` / git tag per your usual scheme ([track 33](../33-packager-ci-releases/) for how; [track 31](../31-listing-copy-discovery/changelog-culture.md) for wording).
3. Changelog lead line: Interface → N for patch X.Y.Z.
4. Optional rigor (good culture): skim [wow-ui-source](https://github.com/Gethe/wow-ui-source) or [BlizzardInterfaceResources](https://github.com/Ketho/BlizzardInterfaceResources) diff for the patch pair — if nothing Beef touches moved, note that in the changelog (pattern: [LFRaider 0.1.40 notes](https://www.curseforge.com/wow/addons/lfraider/files/8394943) — TOC `20506` + “APIs we hook unchanged”).
5. Publish / Discord zip → [guild-comms.md](guild-comms.md).

---

## 4. Code hotfix ship (checklist)

Use when smoke fails or Blizzard explicitly flagged UI/API churn ([Kaivax Classic UI post](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408)).

1. Capture BugSack / `/console scriptErrors 1` stack ([track 19](../19-testing-debugging-qa/script-errors-bugsack.md)).
2. Classify: load-time, login, Officer gate, BeefNet, instance drip, announce — [smoke-test-after-bump.md](smoke-test-after-bump.md).
3. Fix minimum surface; avoid opportunistic refactors on patch night.
4. TOC bump to new Interface **with** the fix (never leave TOC stale after a “fixed” release).
5. Prefer Alpha/officer Discord zip first if protocol or ranking logic changed ([track 48](../48-feature-flags-rollout/); [track 19 alpha](../19-testing-debugging-qa/alpha-channels.md)); Release to guild after one officer+member pair confirms.

---

## 5. Hotfix vs TOC — communication difference

| Ship type | Guild message emphasis |
|-----------|------------------------|
| TOC-only | “Update available — clears Out of Date. No feature change.” |
| Code hotfix | “Update **required** — old zip may error / mis-score. Install before guild night.” |
| Investigating | “Load Outdated OK for now; do **not** hand-edit TOC; wait for officer ping.” |

---

## 6. Anti-patterns

| Don’t | Why |
|-------|-----|
| TOC bump without any smoke | You just certified a broken build |
| Comma-add Retail + Era Interfaces “to be safe” | Wrong-client loads; belongs to track 30/55, not patch night |
| Tell guild to mass-edit TOC | Kills Out of Date diagnostics ([UI FAQ](https://warcraft.wiki.gg/wiki/UI_FAQ/AddOns)) |
| Ship TOC-only while BugSack is red | Lying with metadata |
| Wait a week “for the wiki table” | `GetBuildInfo` is enough; guild nights don’t wait |
