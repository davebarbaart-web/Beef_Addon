# Phase 0 Lane J — Engineering keepers report

**Status:** DONE

**Cited:** Ten Laws 1, 6, 7, 9, 10; Audit §4 keepers (module layering + engineering rules, test harness, Common, BeefNet transport, hard safety); Audit V1, V6; Bible §3.2 (portability), §12 / §13 (account-level store), §19.3 (hybrid visual / theatrical media), §21.3 (dual-publish recommendation), §22.3 (MVP done = human), Appendix A item 6 (targeting assist later); Handoff Phase 0 “keep engineering rules with light edits.”

No new always-on rules. No addon Lua. No commit. `OPEN_QUESTIONS.md` unchanged (dual-publish already listed as Bible Appendix B item 1).

## Per file

### `addon-module-layers.mdc`

- **Kept:** UI→Core→Data / Net→Core→Data; extend planned modules; TOC only for existing files; Ranks, DB, Roster, Officer, BeefNet, UI shell; Common (Audit §4); no Core→UI / CreateFrame / SendAddonMessage / slash; no second authority-gate.
- **Integrator:** guild promote/demote is banned except the Pope verb `KNIGHT THIS BEEF` where the API permits (`pope-authority.mdc`, Bible §8). Do not restore a blanket ban.
- **Deleted:** Scoring and Ladder rows; thresholds / seats / officer-index as Ranks payload; Roster→ladder view; Gora/Ceremony/Instance as “thin → Scoring”; Sync as a peer-authority module; promote-prompt and standing-correction coupling; “points granted in Toasts”; RANK_COMMIT / roster-backed model language.
- **Replaced with:** Officer as future Pope/Council module; Gora/Ceremony as domain, not scoring feeders; UI does not record official outcomes; Net does not invent ranks or verdicts.

### `lua-cob-modules.mdc`

- **Kept:** `ChurchOfBeef` / `COB` global; multi-return errors; getter copies; Core purity; `ResetForTests` + `_IN_TEST`; injectable clock (Common/Clock); AceAddon/LibStub ban in Core; `0`-is-truthy as a Lua footgun (not rank policy).
- **Deleted:** `COB.Ladder` / `Ladder:Commit` examples; `CouncilSeats` / `OfficerRankIndexMax`; “coalesce thresholds that may be `0`”; “only Commit bumps revision” standing language; auto-suggest Council/Prophet; hardcoding *thresholds*.

### `toc-lifecycle.mdc`

- **Kept:** SV gated on `ADDON_LOADED` + addon name; Data→Core→Net/UI→bootstrap; insecure frames; PLAYER_LOGOUT flush-only; registration hygiene; prefix register; combat deferral of protected widget work.
- **Deleted:** `COB.Sync:OnLogin()` as lifecycle authority; “data paths (scoring…)”.
- **Replaced with:** PLAYER_LOGIN = UI + Net; Core store writes and BeefNet apply may run in combat.

### `wow-ui-taint-lockdown.mdc`

- **Kept:** insecure `CreateFrame` under UIParent / Beef root; no `ShowUIPanel` in combat; no `SecureActionButtonTemplate` to open panels; taint table; combat deferral table; movable/clamped/minimap/`/beef`; no ads.
- **Deleted:** “tabs never grant points”; “Scoring owns grants”; demote / Prophet / Council confirm list; `RefreshLadder`; Officer-tab-only visibility; “Frame policy (V1)”.
- **Replaced with:** Director Console and theatrical surfaces stay insecure; views never record official outcomes; Appendix A item 6 is a later validation — do not invent secure targeting buttons now.

### `wow-performance.mdc`

- **Kept:** no permanent OnUpdate; combat idle; ≪ 1 MB SV caution; dirty-flag ≤10 Hz; event-driven roster; CTL pacing.
- **Deleted:** scoring ticks / `Scoring:Tick`; ladder rebuild storms; “cap/rotate event logs” as SV deletion; suggestion rescans; instance-drip / anti-AFK buckets; “one officer-origin line per promotion”; live `beefnet-messaging.mdc` cross-link; “My Standing logs”.
- **Replaced with:** cap *lossy UI caches* only; Law 7 never-delete for records; point throttle at ceremony-runtime / BeefNet keepers.

### `testing.mdc`

- **Kept:** harness commands, `dofile`, `_IN_TEST` / `ResetForTests`, getter copies, no extra CI matrices, no Ace in Core.
- **Deleted:** `test_ladder` as exemplar; `Threshold(1) == 0`; worktree-only checkout assumption.
- **Replaced with:** workspace `addon/` first; suites die with discarded subjects; new Core (store, runtime, codecs) is test-first.

### `build-packaging.mdc`

- **Kept:** Interface `20506`; TOC truth; no upload without approval; secrets; zip root = `ChurchOfBeef/`; infra gap / no invented packager.
- **Deleted:** `SavedVariablesPerCharacter` as product law; “alts start Fresh Beef”; “Numbers only in `Data/Ranks.lua`” / `docs/canon/` zip note as V1 canon law.
- **Replaced with:** account-level `## SavedVariables: ChurchOfBeefDB`; §21.3 dual-publish is a recommendation, not a configured pipeline.

### `packaging-assets.mdc`

- **Kept:** missing media must not fail load; default UI fallbacks; no ripped soundtrack; no ads; quiet-by-default (no auto-invite, no ambient `/g`); stream-safe dumps.
- **Deleted:** “promotion announce = one officer line”; V1-silent / no-Media implication.
- **Replaced with:** custom Media permitted and expected on theatrical surfaces (Law 10 / §19.3).

### `verification.mdc`

- **Kept:** safety; no WTF wipes; no force-push / install wipe; no packager upload; no `ResetForTests` outside harness; offline harness for Core/Data; TOC `20506`; POLISH:CANDIDATE only.
- **Deleted:** Officer+/Member as the two-client pair; `docs/phases/v1-checklist.md` as V1-complete gate; “guild-chat spectacle on promote”; research spine / archived UI brief as the polish law; “clear ladder state”.
- **Replaced with:** Pope client + congregation client; do not claim V1/MVP complete until Bible §22.3 (human); checklists at `docs/design/`; do not claim POLISH:PASS; workspace `addon/` first.

## Concerns

- `architecture-overview.mdc` still describes the points-ladder (other lane). Until it lands, always-on overview and these keepers disagree on Sync, per-character SV, and Scoring/Ladder.
- `ceremony-runtime.mdc` may not exist yet; performance now points at that keeper plus BeefNet, as the brief required.
- Packaging law now requires account-level SV; current TOC/Lua still PerCharacter until Phase 2. Agents may try to flip the TOC early.
- Skill `church-of-beef-dev` still says Officer+/Member, V1 no Media, and worktree-only checkout — out of this lane.
