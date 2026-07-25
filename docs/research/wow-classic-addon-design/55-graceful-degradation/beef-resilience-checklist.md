# Church of Beef — V1 resilience checklist

**Last updated:** 2026-07-25  
**Track:** [55-graceful-degradation](README.md)  
**Use with:** Spec §11 / §13.1 · [19 QA checklist](../19-testing-debugging-qa/church-of-beef-qa-checklist.md) (functional) · this list (degraded / missing-API).

Pass = addon remains usable; no soft-lock; no error-loop; authority rules still hold.

---

## A. Load & media

| # | Scenario | Pass criteria |
|---|----------|---------------|
| A1 | Fresh install, all media present | Loads; `/beef` opens real frame |
| A2 | Delete/rename custom font or texture files | Loads; defaults used; no Lua error spam |
| A3 | `scriptErrors` on + BugSack | No unexpected errors on load/reload |
| A4 | Wrong folder name / TOC basename mismatch | Addon absent (loud) — not half-loaded |

---

## B. Flavor / client

| # | Scenario | Pass criteria |
|---|----------|---------------|
| B1 | Anniversary client, correct Interface | Enabled, not Out of Date |
| B2 | Install into Era or Retail tree (negative) | Prefer not load; if loads, one warning + BeefNet/scoring off |
| B3 | “Load out of date” unchecked with correct Interface | Still loads on target flavor |
| B4 | `WOW_PROJECT_ID` logged once in debug | Matches expected BC Classic / Anniversary family |

---

## C. Guild & roster readiness

| # | Scenario | Pass criteria |
|---|----------|---------------|
| C1 | Character not in a guild | Empty ladder; scoring paused; `/beef` works |
| C2 | Join guild mid-session | Transitions to normal without `/reload` if events wired; else after reload |
| C3 | `RANK_COMMIT` arrives before roster populated | Queued or dropped — **never** applied unverified |
| C4 | Non-officer crafts/forges commit | Rejected |

---

## D. BeefNet / prefix / peers

| # | Scenario | Pass criteria |
|---|----------|---------------|
| D1 | Prefix `COB` registers successfully | HELLO/SYNC path armed |
| D2 | Simulate / force register failure (or max prefixes) | One clear degraded signal; UI+cache work; no send loop |
| D3 | Zero other addon users online | Cache shown; local officer commit applies locally; guild-chat spectacle still possible |
| D4 | Mixed guild: some with addon, some without | Non-addon players not soft-locked; they still see guild-chat promote line |
| D5 | Member offline during promote, then login | Login sync heals to higher revision (spec §13.8) |
| D6 | Sync timeout (no answer) | Keeps cache; no spinner forever; retry later OK |
| D7 | Major BeefNet version mismatch | Soft warn; incompatible commits discarded |
| D8 | Burst / large sync stress | Prefer small payloads; partial delivery must not corrupt via revision rules |

---

## E. Partial sync & silent drops

| # | Scenario | Pass criteria |
|---|----------|---------------|
| E1 | Open `/beef` during SYNC in flight | Frame opens on cache immediately |
| E2 | API reports send success but peer never receives (Classic throttle lore) | Next login/HELLO/SYNC still converges; no double-apply of old rev |
| E3 | Cold login send too early | Settled delay prevents “works after /reload only” class bugs |
| E4 | Leave guild after having ladder cache | Spec §11: retained but hidden; no crash |

---

## F. Authority under degradation

| # | Scenario | Pass criteria |
|---|----------|---------------|
| F1 | Degraded net + officer approve | Local official state updates; broadcast best-effort |
| F2 | Degraded net + member suggestion | No crash; suggestion queued or visible locally to officers when present |
| F3 | Never treat “degraded” as “skip officer check” | Roster verify always required to apply |

---

## G. Smoke for guild night (minimum)

1. Officer + member both with addon: approve → member sees update.  
2. Third guildie **without** addon: still sees guild-chat promotion line; game play unaffected.  
3. `/reload` on member: ladder still correct (SV cache + optional re-SYNC).  
4. Missing-asset folder copy on a tester: still opens UI.

---

## Sign-off

| Field | Value |
|-------|-------|
| Build / TOC Interface | |
| Client `GetBuildInfo()` | |
| Tester | |
| Date | |
| Failures (IDs) | |
| Notes | |
