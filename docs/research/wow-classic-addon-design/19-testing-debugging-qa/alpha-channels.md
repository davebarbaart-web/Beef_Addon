# WowUp / CurseForge Alpha–Beta–Release Channels

**Last updated:** 2026-07-25  
**Track:** [19-testing-debugging-qa](README.md)

---

## 1. Why channels matter for QA

Classic addon distribution has three consumer-facing release types: **Release**, **Beta**, and **Alpha**. Testers who opt into Alpha/Beta get pre-release zips through the same managers they already use — no Discord zip archaeology required.

Church of Beef V1 can stay private/manual installs at first; when packaging starts, **Alpha = officer + volunteer pipe**, Release = guild-wide.

---

## 2. WowUp — per-addon channel

WowUp documents channel selection under My Addons:

- Right-click addon → **Channel** → Stable / Alpha / Beta ([WowUp — Addons in Depth](https://wowup.io/guide/my-addons/addons)).
- Setting Alpha means you **accept that tier or newer**, not “alpha only.” WowUp installs the **latest build regardless of channel label**, so you are not stranded on a stale alpha after the author stops cutting alphas ([same guide](https://wowup.io/guide/my-addons/addons)).
- Channel feature applies to providers that publish pre-releases — **WowUpHub and CurseForge** called out explicitly ([same guide](https://wowup.io/guide/my-addons/addons)).
- Client selector separates Retail / Classic / PTR / Beta installs; update-all can target one client or all ([WowUp — My Addons Overview](https://wowup.io/guide/my-addons/overview)).

**Beef QA tip:** Officer testers set Church of Beef to **Alpha** on the Anniversary client only. Casual guild members stay on **Stable** so a broken commit does not land mid-raid night.

---

## 3. CurseForge — how files become Alpha / Beta / Release

### Automatic packaging rules

CurseForge Automatic Packaging marks release type from git history ([Automatic Packaging](https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging)):

1. **Untagged** commits packaged as **alpha**.
2. **Tagged** commits:
   - Tag contains `alpha` → alpha (e.g. `1.0-alpha`, `1.0.alpha7`)
   - Tag contains `beta` → beta
   - Otherwise → release

BigWigs packager / community CI mirrors the same tag heuristics ([BigWigsMods/packager](https://github.com/BigWigsMods/packager); packager `release.sh` comments on alpha/beta tag words).

### Alpha-only code blocks

Packaging supports `@alpha@` / `@end-alpha@` (and non-alpha inverse) so debug asserts and extra logging ship to alpha testers but strip from release/beta ([Automatic Packaging — Alpha replacements](https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging)). Useful later for BeefNet verbose sync dumps — keep them out of Release.

### Multi-flavor tagging

When uploading, authors tag which game flavors a file supports; Multi-TOC projects need folder/TOC naming that matches CurseForge App expectations ([Multi-TOC for WoW Addons](https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons)). Wrong flavor tags → Anniversary users get Era builds or “no files.”

---

## 4. Recommended Beef distribution ladder

| Stage | Channel | Audience | Expectation |
|-------|---------|----------|-------------|
| Dev machine | Manual copy into Anniversary `Interface/AddOns` | Authors | Fastest; BugSack on |
| Pre-guild night | **Alpha** (or Discord zip labeled alpha) | Officers + 2–3 volunteers | May have `@alpha@` logging |
| Soft launch | **Beta** | Interested members | Feature-complete, polish bugs OK |
| Guild night “live” | **Release** | Everyone | Matches success criteria §13 |

**GuildHelperClassic-era advice still applies culturally:** early `0.x` alphas may spam debug; warn testers ([GuildHelperClassic description](https://www.curseforge.com/wow/addons/guildhelperclassic)).

---

## 5. What not to confuse

- **WowUp app beta** (e.g. Softpedia listing WowUp 2.23.0 Beta) ≠ **addon alpha channel**.
- **PTR / Classic Beta client folders** ≠ CurseForge Alpha files — different install trees ([WowUp clients overview](https://wowup.io/guide/my-addons/overview)).
- Packaging track (05) owns antipatterns; this note only covers **how channels support QA**.
