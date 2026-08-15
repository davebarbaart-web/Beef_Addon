# Phase 0 Lane J — Adversarial Review

**Lane:** Engineering keepers  
**Artifacts:** the nine exclusive `.cursor/rules` keepers  
**Lane report:** `docs/reformation/phase-0/reports/J-engineering.md`

**Spec:** PASS  
**Quality:** Changes required

Keepers not edited. No Critical leftover in the nine files. Lane report still documents a blanket guild-promote ban as *kept*.

## Verdict

The nine keepers no longer encode the points-ladder. Scoring/Ladder rows, threshold/Prophet language, per-character SV as law, “cap/rotate event logs,” V1-silent Media, Officer+/Member as the two-client pair, and guild-chat-on-promote as the product pass are gone from the keepers. Account-level `ChurchOfBeefDB`, theatrical Media on §19.3 surfaces, Pope client + congregation client, and Bible §22.3 as the human MVP gate are in. The integrator-aligned promote line matches Bible §8 / `pope-authority.mdc`. No new always-on rule. No invented engineering OS.

The lane report is stale on the one Critical attack: it lists “no guild promote/demote APIs” as kept. The current exclusive file does not say that.

## Attack results

| Attack | Result |
|---|---|
| Scoring / Ladder / threshold / Prophet leftover in the nine keepers? | **No.** Product sentences removed. Residual “not scoring feeders” and `feat-church-of-beef-v1` are negation / path names, not law. |
| Per-character SV still stated as law? | **No.** Packaging law is `## SavedVariables: ChurchOfBeefDB`. TOC still PerCharacter (code; out of exclusive files). |
| Blanket “no guild promote” contradicting Bible §8? | **No in keepers.** Exception is KNIGHT THIS BEEF where the API permits. **Yes in the lane report** (documents the old ban as kept). |
| Never-delete violated by “cap event logs”? | **No.** Cap is lossy UI caches only; store / Chronicle / Gora records are never deleted (Law 7 / §12.3). |
| Invented engineering OS? | **No.** Light edits only. `verification.mdc` was already `alwaysApply: true`. Dual-publish left as §21.3 recommendation. |

## Findings

### Critical

None in the nine keepers.

### Important

1. **Lane report still records a blanket guild-promote ban as kept** (Bible §8; Appendix A item 4; `pope-authority.mdc` “KNIGHT THIS BEEF”; Law 3).  
   Report § `addon-module-layers.mdc`: “Kept: … no guild promote/demote APIs.”  
   Current exclusive file: `❌ Guild promote/demote except the Pope verb KNIGHT THIS BEEF where the API permits (`pope-authority.mdc`)`.  
   That exception is the Bible line (Church record + guild-rank write where the API permits). The report’s “kept” bullet is the pre-integrator ban. A later agent who trusts the report over the file can restore a Critical leftover. Update the report bullet; do not re-ban promote APIs.

### Minor

2. **`build-packaging.mdc` still says no `.github/workflows` yet** (brief: do not invent CI; keep infra-gap honesty).  
   `testing.mdc` already points at `.github/workflows/lua-tests.yml`, and that workflow exists. The packaging sentence is leftover demo-era infra, not a new OS. Agents may skip or re-invent CI that is already there.

3. **`testing.mdc` still names `.worktrees/feat-church-of-beef-v1` as the worktree fallback** (brief: workspace `addon/` first, not worktree-only).  
   Addon-first is correct. The fallback path is a V1 worktree name, not threshold/Prophet law.

4. **Lane report concerns are stale** (brief report contract: current exclusive files).  
   `architecture-overview.mdc` is already “not a points ladder” (Lane C). `ceremony-runtime.mdc` exists (Lane G). The TOC PerCharacter / skill Officer+ notes remain true and out of this lane.

5. **`build-packaging.mdc` “Identity is per human” flattens §12.1** (Law 7; Bible §12).  
   Account-level SV is the right packaging law. Rank belongs to the human; Gora records belong to the character. The sentence does not re-state PerCharacter, but it can be read as erasing character-owned Gora from the store shape. Identity schema is Lane F.

## What was checked and held

- **No points economy / no Ladder.** Module table: Ranks (ids, titles only), DB, Common, Officer (future Pope/Council), Roster (live snapshot), Gora/Ceremony as domain not scoring feeders, BeefNet, UI shell. No Scoring, Ladder, Sync, Instance→Scoring, RANK_COMMIT, standing correction, promote-prompt, or “points granted in Toasts.”
- **No threshold / Prophet policy.** `lua-cob-modules.mdc`: `0` is a Lua footgun, not rank coalescing. No `CouncilSeats` / `OfficerRankIndexMax` / auto-suggest Council/Prophet / “only Commit bumps revision.” `wow-ui-taint-lockdown.mdc`: no demote / Prophet / Council confirm list, no `RefreshLadder`, no Officer-tab-only.
- **Account-level SV.** `build-packaging.mdc` requires `## SavedVariables: ChurchOfBeefDB` and forbids shipping PerCharacter as product law (Bible §12 / §13; Audit V6). Current TOC remains PerCharacter until Phase 2 — flagged in the lane report, not restated as keeper law.
- **§8 promote capability.** Current `addon-module-layers.mdc` matches `pope-authority.mdc`: no congregation / Council ritual promote; Pope verb may write guild rank where the API permits. Not a blanket ban.
- **Law 7 never-delete.** `wow-performance.mdc` deleted “cap/rotate event logs” and “My Standing logs as lossy/capped.” Cap applies to lossy UI caches only. ≪ 1 MB remains a caution, not a prune order.
- **No invented OS.** No new always-on rule. No AceAddon in Core. No packager pipeline treated as configured. §21.3 dual-publish is a recommendation (`OPEN_QUESTIONS.md` item 1 unchanged). Appendix A item 6 deferred, not invented as secure targeting buttons.
- **§3.2 / hard safety.** Host stays `20506`; no Retail-only APIs; no bots / injection / protected-action bypass (`verification.mdc`, `build-packaging.mdc`).
- **§19.3 / Law 10.** Custom Media permitted and expected on theatrical surfaces; missing media must not fail load; functional fallbacks stay (`packaging-assets.mdc`, `wow-ui-taint-lockdown.mdc`).
- **§22.3.** Do not claim V1/MVP complete until a human walks the Gathering. Checklists at `docs/design/`, not archived V1. POLISH:CANDIDATE only. Two-client pair is Pope + congregation (`verification.mdc`).
- **Quiet / no spectacle-as-pass.** Promotion-announce officer line and guild-chat-on-promote product pass removed (`packaging-assets.mdc`, `verification.mdc`). Quiet-by-default kept.

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` (Laws 1, 3, 6, 7, 9, 10; hard safety; Bible-wins)
- `docs/reformation/phase-0/briefs/J-engineering.md`
- `docs/reformation/phase-0/reports/J-engineering.md`
- `.cursor/rules/addon-module-layers.mdc`
- `.cursor/rules/lua-cob-modules.mdc`
- `.cursor/rules/toc-lifecycle.mdc`
- `.cursor/rules/wow-ui-taint-lockdown.mdc`
- `.cursor/rules/wow-performance.mdc`
- `.cursor/rules/testing.mdc`
- `.cursor/rules/build-packaging.mdc`
- `.cursor/rules/packaging-assets.mdc`
- `.cursor/rules/verification.mdc`
- `.cursor/rules/pope-authority.mdc` (KNIGHT THIS BEEF; no blanket promote ban)
- Bible §3.2, §8, §12, §19.3, §21.3, §22.3, Appendix A items 4 and 6
- Audit §4 keepers / V1 / V6; `OPEN_QUESTIONS.md` item 1

## Brief contract

Exclusive-file set honored. Addon Lua untouched. No commit. No new always-on rule. Per-file keep/delete in the lane report matches the keepers except the guild-promote “kept” bullet (Important). `OPEN_QUESTIONS.md` unchanged.
