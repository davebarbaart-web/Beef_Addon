# Beef maintainer checklist — patch day / Interface bump

**Track:** [62-patch-day-interface-bump](README.md)  
**Last updated:** 2026-07-25  
**Client:** TBC Classic Anniversary only (V1)

Copy into a Discord pin or maintainer note. Expand to [track 19 QA](../19-testing-debugging-qa/church-of-beef-qa-checklist.md) only if smoke fails.

---

## T−1d (or when maintenance is announced)

- [ ] Read patch / Kaivax notes for UI or addon-risk language
- [ ] Post [pre-smoke guild template](guild-comms.md) (Load Outdated OK; no TOC hand-edits)
- [ ] Confirm who owns the all-clear (one officer)
- [ ] Lab ready: Anniversary install, BugSack, officer + member alts

---

## T+0 (after client updates)

- [ ] `/dump (select(4, GetBuildInfo()))` → record **live Interface** ______
- [ ] Compare to `ChurchOfBeef.toc` `## Interface:`
- [ ] Character Select → AddOns: note Out of Date? Y/N
- [ ] Enable Load Outdated if needed; run [smoke §1–§2](smoke-test-after-bump.md)
- [ ] Decision: **TOC-only** / **code hotfix** / **investigating** ([decision tree](hotfix-vs-toc-bump.md))

### If TOC-only

- [ ] Set `## Interface:` to live number
- [ ] Bump `## Version:` / tag
- [ ] Changelog: Interface line first
- [ ] Package & distribute (zip / CF / Wago — process in [track 33](../33-packager-ci-releases/))
- [ ] If CF: set **Supported Version** for new Anniversary patch ([CF note](curseforge-unsupported.md))
- [ ] Re-test with Load Outdated **off**
- [ ] Post [TOC-only guild template](guild-comms.md)

### If code hotfix

- [ ] Capture BugSack / scriptErrors
- [ ] Minimal fix; no drive-by refactors
- [ ] TOC + Version bump with the fix
- [ ] Officer Discord / Alpha first if ranking or BeefNet touched
- [ ] Officer+member Approve smoke
- [ ] Release to guild; post [required-update template](guild-comms.md)

### If investigating

- [ ] Post [investigating template](guild-comms.md)
- [ ] Pause Officer promotions if sync/approve unsafe
- [ ] Do not upload a “green” TOC-only file

---

## T+1d

- [ ] At least one member confirmed update (or Load Outdated + green)
- [ ] Unpin / supersede “investigating” if cleared
- [ ] Watch for late BugSack reports after first guild night

---

## T+7d

- [ ] Load Outdated no longer needed for Beef on officer machines
- [ ] If public listing: CF/Wago no longer show Unsupported for Anniversary filter
- [ ] Optional: note wiki Interface table lag in research if wiki ≠ client
- [ ] If this bump taught a new API footgun, add one line to track 04 / 19 — not a novel essay here

---

## Hard rules (do not skip)

1. Trust **`GetBuildInfo`**, not memory or a stale wiki row.
2. Never instruct the guild to mass-edit TOC files.
3. Never widen multi-flavor Interfaces on patch night “for safety.”
4. Never claim CF Unsupported is fixed by a local TOC edit alone.
5. No commits/code in this research folder — execute the checklist against the addon tree / release process outside this library.
