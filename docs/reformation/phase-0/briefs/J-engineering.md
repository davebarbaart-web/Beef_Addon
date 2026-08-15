# Phase 0 Lane J — Light-edit surviving engineering rules

Read first: `docs/reformation/phase-0/TEN_LAWS.md`, Audit §4 (keepers), Bible §3.2 (portability).

## Mission

Keep engineering law. Remove product sentences that encode the points-ladder (Scoring, standing, thresholds, Prophet, Officer-tab-as-ritual, per-character SV as *product* law, “V1 silent / no Media”). Do not invent a new engineering OS.

## Exclusive files (edit only these)

- `.cursor/rules/addon-module-layers.mdc`
- `.cursor/rules/lua-cob-modules.mdc`
- `.cursor/rules/toc-lifecycle.mdc`
- `.cursor/rules/wow-ui-taint-lockdown.mdc`
- `.cursor/rules/wow-performance.mdc`
- `.cursor/rules/testing.mdc`
- `.cursor/rules/build-packaging.mdc`
- `.cursor/rules/packaging-assets.mdc`
- `.cursor/rules/verification.mdc`
- Report: `docs/reformation/phase-0/reports/J-engineering.md`

**Do not** edit `architecture-overview.mdc`, `ten-laws.mdc`, domain rules, `ui-juice-standards.mdc`, or `officer-guild-roster.mdc` (other lanes).

## Per-file intent

**addon-module-layers:** Keep UI→Core→Data / Net→Core→Data. Replace the module table: drop Scoring/Ladder/standing coupling. Keep Ranks, DB, Roster, Officer (as future Pope/Council module), BeefNet, UI shell. Gora/Ceremony are not “thin → Scoring.” Net does not invent ranks/verdicts. UI does not record official outcomes.

**lua-cob-modules:** Keep COB global, multi-return errors, copies, Core purity, ResetForTests. Remove threshold/`0` coalescing-as-rank-policy, Prophet/Council auto-suggest, “only Commit bumps revision” standing language. Time via injectable clock may stay (Common/Clock).

**toc-lifecycle:** Keep ADDON_LOADED / PLAYER_LOGIN / insecure frames / prefix register. Remove “data paths (scoring…)”. Do not re-assert peer Sync as authority. SV init still gated on ADDON_LOADED.

**wow-ui-taint-lockdown:** Keep insecure frames, no SecureActionButton for panels, taint table, combat deferral. Remove “tabs never grant points / Scoring owns grants,” demote/Prophet confirms, RefreshLadder, Officer-tab-only. Director Console and theatrical surfaces are still insecure frames. Targeting assist later may need secure buttons — do not invent; say “no secure templates to open panels; Appendix A item 6 is a later validation.”

**wow-performance:** Keep no permanent OnUpdate, combat idle, SV size caution. Remove scoring ticks, ladder rebuild storms, “cap/rotate event logs” if phrased as deleting Church history (Law 7: never-delete — cap *lossy UI caches* only, not records). Remove beefnet-messaging.mdc cross-link (that rule is being archived); point at ceremony-runtime / BeefNet keepers.

**testing:** Keep harness commands, dofile, _IN_TEST. Remove Threshold(1)==0, test_ladder as the exemplar. Say suites die with discarded subjects; new Core (store, runtime, codecs) is test-first. Addon may live at workspace `addon/` not only `.worktrees/`.

**build-packaging:** Keep Interface 20506, TOC truth, no upload without approval. **Change:** Bible wants account-level `SavedVariables: ChurchOfBeefDB` (not PerCharacter). State that as packaging law. Dual-publish CurseForge+Wago is Bible §21.3 recommendation — do not treat it as already configured.

**packaging-assets:** Keep fallbacks, no ripped soundtrack, no ads. **Change:** custom Media is permitted and expected **on theatrical surfaces** (Law 10 / §19.3). Missing media must not fail load. Quiet-by-default (no auto-invite, no ambient /g). Remove “promotion announce = one officer line” as the spectacle law.

**verification:** Keep safety, no WTF wipes, no force-push, no packager upload, no ResetForTests outside harness. **Change:** do not claim V1/MVP complete until Bible §22.3 (human). Do not claim POLISH:PASS. Offline harness still required for Core/Data. Guild/net checks become Pope client + congregation client (not Officer+/Member). Remove “guild-chat spectacle on promote” as the product pass. Point checklists at `docs/design/` not archived V1 spec.

## Do not

- `git commit`
- Touch addon Lua
- Add new always-on rules

## Report contract

Status, per-file bullet of what you deleted vs kept, sections cited.
