# Smoke-test after an Interface bump

**Track:** [62-patch-day-interface-bump](README.md)  
**Last updated:** 2026-07-25

Thin patch-day smoke only. Full V1 matrix lives in [19 — church-of-beef-qa-checklist](../19-testing-debugging-qa/church-of-beef-qa-checklist.md). If anything here fails, stop TOC-only shipping and open the full checklist.

---

## 0. Lab (5 minutes)

- [ ] Anniversary client (not Era / Retail tree) — [track 30](../30-anniversary-vs-era-deltas/install-paths-and-clients.md)
- [ ] Note live Interface: `/dump (select(4, GetBuildInfo()))`
- [ ] `/console scriptErrors 1`; BugGrabber + BugSack empty at start ([track 19](../19-testing-debugging-qa/script-errors-bugsack.md))
- [ ] Church of Beef installed; TOC already bumped **or** Load Outdated enabled for pre-bump diagnosis

---

## 1. Load gate (must pass before announcing)

| # | Check | Pass |
|---|--------|------|
| 1 | Character Select → AddOns: Beef enabled | Visible |
| 2 | With Load Outdated **off** and TOC matching live Interface | Still loads (post-bump) |
| 3 | Fresh `/reload` | No Beef errors in BugSack |
| 4 | `/beef` opens real frame | Spec success §13.2 |
| 5 | Minimap (or equivalent) toggles same frame | Works |

If (2) fails only because TOC is stale → TOC-only candidate. If (3)–(5) fail with Load Outdated on → **code hotfix**.

---

## 2. Patch-day functional slice (15–20 minutes)

Run with **two characters** when possible (Officer+ and Member). Skip deep drip math; prove the social spine.

| # | Check | Pass |
|---|--------|------|
| 6 | Ladder ranks render; My Standing shows local player | No blank / Lua error |
| 7 | Officer tab hidden on member; visible on Officer+ | Gate intact |
| 8 | One pending suggestion → officer Approve | Rank updates locally |
| 9 | Member online: ladder updates after approve (BeefNet) | Sync not dead |
| 10 | Optional: one guild-chat announce if spectacle on | No spam storm / soft-lock |

Escalate to full [QA checklist](../19-testing-debugging-qa/church-of-beef-qa-checklist.md) sections 3–6 if any of 6–10 fail, or if Blizzard called out UI/API churn ([Kaivax](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408)).

---

## 3. “Looks fine but…” traps

| Trap | Mitigation |
|------|------------|
| TOC bumped, Load Outdated still on | Turn it **off** and re-login once before declaring victory |
| Only tested on officer alt | Member path is where Officer tab / sync bugs hide |
| Wiki said 20505, client said 20506 | Trust client; update TOC again |
| Combat HUD cousins broke; Beef “seems” fine | Still ship TOC if Beef smoke green — don’t block on DBM |
| Secure/taint only in combat | If Beef doesn’t touch protected frames, note N/A; if it does, see [track 29](../29-taint-secure-ui/) |

---

## 4. Exit criteria

| Result | Next |
|--------|------|
| All of §1 + §2 green after TOC match | [Guild comms — cleared](guild-comms.md); fill [maintainer checklist](beef-maintainer-checklist.md) |
| §1 green, §2 red | Hotfix path ([hotfix-vs-toc-bump.md](hotfix-vs-toc-bump.md)); officer-only zip until fixed |
| Load fails even with Load Outdated | Treat as P0; do not announce “safe with Load Outdated” |
