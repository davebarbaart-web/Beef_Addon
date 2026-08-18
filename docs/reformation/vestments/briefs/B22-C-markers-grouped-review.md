Spec PASS

# B22-C — resolveUnit player token does not need GetNumGroupMembers (review)

**Quality:** Approved-with-nits

**Lane:** B22-C resolveUnit player token does not need GetNumGroupMembers
**Brief:** `docs/reformation/vestments/briefs/B22-C-markers-grouped.md`
**Writer report:** `docs/reformation/vestments/briefs/B22-C-markers-grouped-report.md`
**Diff:** `docs/reformation/vestments/briefs/B22-C-markers-grouped.diff` (B22-C-only exclusive-pair packet; both exclusive files are still untracked vs HEAD and also carry earlier Markers batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Markers.lua` (`resolveUnit`), and `tests/test_markers.lua` (B22-C grouped `IsInRaid` + Pope + Event + `GetNumGroupMembers = nil` player pin, existing both-nil group-API pin, Quiet / ungrouped / party scan keep-pins, isolation wrap); then ran `lua tests/test_markers.lua` (**349 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: player token without `GetNumGroupMembers`; scan still type-guards it; ungrouped refuse stays. Bible §8 (candidate / fighter marks); Law 5 (Pope client); Law 6 (Quiet refuse). Anniversary `SetRaidTarget(target, userIndex)` takes a UnitToken — `"player"` is valid. wow-api `classic_anniversary` catalog still omits `GetNumGroupMembers` / `IsInRaid` / `IsInGroup`; no replacement API invented. Isolation wow_ui_stub + Common + Runtime + Markers only. Did not mutate `Markers.lua` or `test_markers.lua`. Did not commit. Did not edit Knighting, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `resolveUnit` still type-guards `GetNumGroupMembers` before the player return (B16-D leftover) | **Pass. Verified.** Live player arm type-guards `UnitName` only, then `pcall(UnitName, "player")` + `namesSame(me, name)` returns `"player"`. `GetNumGroupMembers` type-guard sits after that return. Pin: grouped `IsInRaid` + Pope + Event, count API nil, `MarkCandidate("Beefina")` spies `SetRaidTarget("player", 1)`. Reviewer probe: same; index 1. Combined `or type(UnitName)` guard is gone. |
| Party / raid scan no longer type-guards `GetNumGroupMembers` | **Pass. Verified.** After the player miss: `if type(GetNumGroupMembers) ~= "function" then return nil end`, then `pcall`. Reviewer probe: grouped + count API nil + `MarkCandidate("Chuckroast")` → `false, "unit not found"`, `#raidTargets == 0`. Count API as a number, or a throwing function, also fail-closes the scan. No `GetNumPartyMembers` / `GetNumRaidMembers` / `GetNumSubgroupMembers`. |
| Ungrouped Mark now `SetRaidTarget`s because the player arm no longer needs the count API | **Pass. Verified.** `isGrouped` still runs before `resolveUnit` on Mark / Clear. Existing ungrouped Beefina pin stays `"not in a group"`, no spy. Reviewer probe: same. Both-nil (`GetNumGroupMembers` + `IsInRaid`) pin stays `"not in a group"` for Chuckroast; probe also refuses Beefina. |
| Event + Pope + grouped no longer required / Quiet broken | **Pass.** Quiet / missing Runtime / unlisted Pope still refuse before resolve. Existing Beefina Quiet / unlisted pins stay. Reviewer probe: Quiet Beefina is `"quiet"`; unlisted Pope + count API nil is `"not a registered pope"`; no spy. |
| Missing `UnitName` no longer fail-closed | **Pass.** Player arm returns nil when `type(UnitName) ~= "function"`. Reviewer probe: `UnitName = nil` → `false, "unit not found"`, no spy. `pcall` on the player read stays. Probe: injected `Group.PlayerName` plus throwing `UnitName("player")` is caught, then scan type-guard → `"unit not found"`. |
| Target verb changed | **Pass.** Target still does not call `resolveUnit`. Existing ungrouped Target pin stays. Reviewer probe: ungrouped `Target("Chuckroast")` spies `TargetUnit(..., true)`, mark count 0; grouped + count API nil `Target("Beefina")` still spies the name, not `"player"`. |
| Party scan pins lost | **Pass.** Pre-lane `Chuckroast` → `party1` pin stays (with the count API present). Reviewer probe: same. |
| Isolated suite not exit 0 | **Pass. Verified.** 349 passed, 0 failed. Writer-reported count matches. |
| GuildPromote / combat automation / CreateFrame | **Pass.** Source has none. Suite `combatCalls` / chat / addon / sounds stay 0. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two `diff --git` hunks (split type-guard; B22-C pin in a `do`/`end`). Sibling dirt in this workspace is other lanes (Console, Hud, ConsoleDock, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Knighting / glue; no commit; no GuildPromote; no combat automation | **Pass.** Named-risk check. |
| Isolation stays wow_ui_stub + Common + Runtime + Markers | **Pass.** Three `dofile`s unchanged. Load wrap still **27** nil-module / slash pins under `if standalone then`. |
| Player arm requires `UnitName` only; names-same returns `"player"` without `GetNumGroupMembers` | **Pass.** Named-risk check. |
| Party / raid scan still requires and type-guards `GetNumGroupMembers` | **Pass.** Named-risk check. |
| Missing `UnitName` stays fail-closed | **Pass.** Named-risk check. |
| Ungrouped Mark still refuses (`isGrouped`) | **Pass.** Named-risk check. |
| Event + Pope + grouped still required | **Pass.** Named-risk check. |
| Target verb unchanged | **Pass.** Named-risk check. |
| Grouped (`IsInRaid` true) + Pope + Event, `GetNumGroupMembers = nil`: `MarkCandidate("Beefina")` spies `SetRaidTarget("player", …)` | **Pass.** Star index 1. |
| Existing missing-group-APIs pin (nils both `GetNumGroupMembers` and `IsInRaid`) stays `"not in a group"` | **Pass.** Untouched block after the new pin. |
| Quiet / ungrouped / party scan pins stay | **Pass.** Named-risk check. |
| Isolation wrap stays; no invented replacement API; keep existing pcall guards | **Pass.** Wrap untouched. Scan still `pcall(GetNumGroupMembers)`. Player read still `pcall(UnitName, "player")`. |
| `lua tests/test_markers.lua` exit 0 | **Pass.** **349 / 0.** |

Bible §8 (candidate / fighter marks on the Pope client) and Law 5 / Law 6 hold on the exclusive pair. The B16-D leftover (count API required before `"player"`) is closed. Catalog omit of `GetNumGroupMembers` is handled by the split guard, not papered over with another roster-size API.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Scan-without-count-API is unpinned | **On contract.** Brief asked the player-arm spy. Reviewer probe: other name → `"unit not found"`. |
| Missing `UnitName` has no new pin | **On contract.** Fail-closed stays at the type-guard. Reviewer probe: `"unit not found"`. |
| No client / two-client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Gate W / Gate V stay OPEN; not signed | **On contract.** This review does not sign either. |

B22-INT glue is not required. Mark / Clear already go through `resolveUnit`; Target is unchanged.

---

## Isolation / resolve / gates

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Runtime + Markers. No `dofile` of Knighting / Gora / Store / UI shell / Net. Standalone wrap is still 27 nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Confession, Inputs, ConsoleDock, Decree, slash). Reviewer probe: those 26 `COB.*` keys and the slash are nil at load. Wrap is load-time only (unchanged).

**Resolve — Pass.** `UnitName` type-guard, then player token, then `GetNumGroupMembers` type-guard, then `raidN` / `partyN` scan. Self-mark no longer dies when `isGrouped` is already true via `IsInRaid` / `IsInGroup` and the count API is missing. Other names still need the count API. `namesSame` is still `COB.Names.Same`.

**Gates — Pass.** Quiet / missing Runtime / unlisted Pope / ungrouped still refuse before resolve. `isGrouped` is unchanged (`IsInRaid` / `IsInGroup` / `GetNumGroupMembers`). Target does not call `resolveUnit`.

---

## Strengths

- The production change is a split of the combined type-guard: `UnitName` only on the player arm; `GetNumGroupMembers` only on the scan arm. Failed scan cannot invent a token. Player return cannot demand a catalog-omitted API.
- B16-D leftover #3 / B18-D leftover (self-mark `"unit not found"` when `IsInRaid` is true and the count API is nil) is closed on the named pin the brief asked for.
- Existing both-nil group-API pin, Quiet / ungrouped Beefina refuses, party `Chuckroast` → `party1` pin, and isolation wrap were left in place.
- TDD order matches the brief. New pin sits in a `do`/`end` and restores the count API; `ok` / `err` reused. No new main-chunk locals.
- Source still has no GuildPromote / combat / `CreateFrame`. No replacement roster-size API. Existing pcall guards stay.
- Writer-reported **349 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

None.

### Nit

1. **Existing source pin `type(GetNumGroupMembers)` is not scan-specific.** It also matches `isGrouped`. Writer report calls it a scan-path pin. The live scan arm does type-guard; the substring pin would stay green if only `isGrouped` kept the spelling.

2. **Scan-without-count-API is unpinned.** Brief asked the player spy only. Reviewer probe: grouped + count API nil + `Chuckroast` → `"unit not found"`, no spy.

3. **Missing `UnitName` has no dedicated B22-C pin.** Fail-closed stays at the type-guard. Reviewer probe: `"unit not found"`.

4. **`Clear` / `MarkFighters` inherit the split and are unpinned on the count-API-nil path.** Reviewer probe: `Clear("Beefina")` spies `"player", 0`; mixed `MarkFighters("Beefina", "Chuckroast")` is `"unit not found"`; both-player `MarkFighters` spies two `"player"` marks. Brief scoped `MarkCandidate`.

5. **`IsInGroup`-only grouped (no `IsInRaid`, no count API) is unpinned.** Brief named `IsInRaid`. Reviewer probe: injected `IsInGroup` + player name spies `"player", 1`. Closes the B5-B leftover on the player arm only.

6. **Isolation wrap is load-only.** Twenty-seven pins under `if standalone then` at file load. There is no end wrap after Sender / API stubs. Brief said the wrap stays; it did.

7. **Exclusive-pair diff is not a vs-HEAD Markers delta.** Both exclusive files are untracked. Packet is the B22-C-only guard split + pin. `git diff HEAD` is empty because the files are not in the index. Report already says this.

8. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **349 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **349 passed, 0 failed.** Isolation wrap: **27**.

`resolveUnit` returns `"player"` from a pcalled `UnitName("player")` names-same without `GetNumGroupMembers`. The party / raid scan still type-guards `GetNumGroupMembers` and fail-closes when it is missing. Ungrouped Mark still refuses via `isGrouped` before resolve. Event + Pope + grouped still required. Quiet / both-nil group APIs / unlisted Pope still refuse. Target is unchanged. Isolation stays wow_ui_stub + Common + Runtime + Markers. Isolated `lua tests/test_markers.lua` **349 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
