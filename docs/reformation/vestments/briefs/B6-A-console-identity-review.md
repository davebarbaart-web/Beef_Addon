Spec PASS

# B6-A — Console honorific + Recognition (review)

**Quality:** Approved-with-nits

**Lane:** B6-A Console honorific + Recognition (stock)
**Brief:** `docs/reformation/vestments/briefs/B6-A-console-identity.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/B6-A-console-identity-report.md`
**Diff:** `docs/reformation/vestments/briefs/B6-A-console-identity.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, `UI/Console.lua`, and `tests/test_console.lua`; then ran `lua tests/test_console.lua`. Law cited: Bible §15 (honorifics = Pope-granted plain text), §12.2 (Rite of Recognition; no self-service); Law 10 / §19.3; OPEN_QUESTIONS #8 (no designated-Council UX). Did not mutate addon code. Did not commit. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `GrantHonorific` → `Store:AddHonorific` | **Pass.** Pope-gated. Missing `Store.AddHonorific` → refuse string. Else `Store:AddHonorific(humanId or selectedHumanId, title)`. Title is trimmed box text when the argument is omitted; an explicit string wins over the box. No invented default title. Suite spies the Store method (0 on refuse; +1 on each successful grant) and pins the appended human row. |
| Newline / empty refuse | **Pass.** `honorificText` trims first, then refuses `nil`/empty/whitespace (`"honorific text required"`) and embedded `"\n"` (`"honorific text must be one line"`) before Store is called. Suite pins `""`, `"   "`, `"Duke\nof the Fountain"`, and an empty box: `addCalls` stays flat and the honorifics list does not grow. |
| Recognition Begin role `"pope"` only | **Pass.** Third argument to `Recognition:Begin` is the literal `"pope"`. Never `UnitName`, never `"council"`. Omitted ids use `selectedHumanId` / `selectedCharacterId`. Suite spies the role on omitted-args, explicit-args, and the Begin button; source has no `"council"` confirmer literal. |
| Complete / Cancel no theater | **Pass.** Both go through `after(self, result, err)` with no cue and no `wantHud`. `after()` only `Refresh`es the desk when Core returns a result; `playCue` / `Hud.Refresh` stay off. Suite stubs `Sound.Play` and pins 0 on Complete, Cancel, Grant, Begin, and the three ritual buttons. No Toasts, `SendChatMessage`, or duration timer. |
| `SaveNote` nil | **Pass.** `Console.SaveNote` is nil at API scan, after B4-D, after B5-C, at the B6-A open, and after the B6-A block. `GetNotes` stays nil. Notebook is still a label. |
| No Council button | **Pass.** No `ConfirmCouncil` / `LinkSelf` / `LinkCharacter`. `findButton` is nil for `Council`, `Council Confirm`, and `Confirm as Council`. Source has no `"council"` confirmer and no `WHISPER ALL`. |
| Isolated green | **Pass.** Reviewer ran `lua tests/test_console.lua`: **744 passed, 0 failed**, exit 0. Isolation cluster is still `if standalone then` (17 nil-module pins, including `COB.Recognition == nil`). Suite does not `dofile` `Recognition.lua`. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Store, Recognition.lua, Knighting, RecordsBook; no commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/Console.lua` and `tests/test_console.lua`. |
| Console stays stock; `SaveNote` stays nil; no WHISPER ALL; no Council confirmer button (#8) | **Pass.** New chrome is `InputBoxTemplate` + `UIPanelButtonTemplate`. No parchment, QuestBG, custom media, jokes, `OnUpdate`, or `UIParent:SetScale`. Named-risk checks for SaveNote, WHISPER ALL, and Council. |
| Stock EditBox + `GRANT HONORIFIC` → `Store:AddHonorific`; trim; empty refuse; embedded `"\n"` refuse; never invent titles; Pope-gated | **Pass.** Named-risk check. The button is a ritual plate (`applyGate` + `isRegisteredPope`), not furniture — legal reading of “stock button” (template) plus “Pope-gated like other desk verbs.” |
| `BeginRecognition` → `Recognition:Begin(..., "pope", now)` using selected human + character when args omitted; missing module → refuse string; no UnitName bind; no `"council"`; no auto-Complete on the 30s metadata duration | **Pass.** Named-risk check. `wallNow()` is `Clock.Wall()` or `time()`. No `C_Timer`. Frame `OnUpdate` stays nil. Duration stays Core metadata. |
| `CompleteRecognition` / `CancelRecognition` Pope-gated; no theater | **Pass.** Named-risk check. |
| Tests: GrantHonorific writes Store when Pope; newline/empty refuse; Begin spies `"pope"`; Complete/Cancel do not PlaySound; SaveNote nil; isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** Isolation stayed gated. This review re-ran the isolated suite. |

Bible §15 (plain Pope-authored text, no invented titles), §12.2 (no self-service link; confirmer is the Pope on this desk), Law 10 / §19.3 (functional stock), and #8 (no designated-Council UX) are met. Core still accepts `"council"`; this lane does not offer it.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; frame grew (`DEFAULT_HEIGHT` 770) | **Not a spec miss.** Brief asked isolated `tests/test_console.lua`. **POLISH:CANDIDATE** is the ceiling. See Issues. |
| `Recognition.lua` not loaded; Begin / Complete / Cancel proven against a stub | **Not a miss.** Brief allowed a stub. Integrator still wires the real module. Console adds no theater path and never passes `"council"`. |
| Duration stays Core metadata; no 30s timer / auto-Complete | **Not a miss.** Required. |
| GRANT HONORIFIC / Recognition are ritual plates (disabled when not Pope) | **Not a miss.** Brief asked Pope-gating like other desk verbs. Clicks still refuse while gated. |
| Newline refuse is after trim; trailing-only `"\n"` is whitespace | **Not a miss.** Brief order is trim, then empty, then embedded `"\n"`. |
| Console never offers a Council confirmer; Core still accepts `"council"` | **Not a miss.** #8. |

---

## Strengths

- Honorific writes are Store-only. The suite spies `AddHonorific` rather than trusting the returned human, and empty / newline paths prove Store is not called.
- Recognition confirmer is a closed literal. There is no role argument, no UnitName bind, and no Council plate to mis-click.
- Complete / Cancel / Grant / Begin share the mute `after()` path (Refresh, no cue, no HUD). They cannot pick up leftover knighting / elevation / sanction / verdict / cowardice cues.
- Missing Recognition is a refuse string, not a throw. The full-harness leftover is niled for that pin and restored.
- Isolation stayed under `if standalone then`. Theater Sound pins from the earlier desk were not deleted. Isolated **744 / 0** was re-run here.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Honorific row has no header.** It is a second unlabeled `InputBoxTemplate` stacked under Decree flavor. The GRANT HONORIFIC plate is the only tell. A Pope can type the title into the flavor box and grant an empty honorific, or the reverse. Desk-only.

2. **Recognition labels are long for `BTN_W` 172.** `Complete Recognition` / `Begin Recognition` will clip on stock `UIPanelButtonTemplate`. Three plates still fit the content width.

3. **Honorific box is not cleared after a grant.** `Refresh` does not touch `HonorificText`. A second click appends the same title. Store does not dedup. Pope-ratified, but easy to double-stamp.

4. **Complete / Cancel `now` is unpinned.** Console passes `wallNow()` into `Recognition:Complete`. The stub ignores the argument. Begin captures `now` and never asserts it.

5. **`\\r` alone is not refused.** Brief named embedded `"\n"` only. `"Duke\\rof the Fountain"` would reach Store.

6. **Suite header is still stale.** It still says the Pope predicate is always false and the suite does not stub a Pope list. B6-A uses the existing `Sender.IsRegisteredPope` wrap. Isolation itself stayed gated.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **744 / 0** was re-run here. Client path was not. Frame height 770 is unproven on Anniversary.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

This is the B6-A vestment contract: a stock honorific box that writes `Store:AddHonorific` and refuses empty / embedded newline, Recognition Begin that always confirms as `"pope"`, Complete / Cancel that never leave the desk, `SaveNote` still nil, no Council button. Named risks are clean. Nits are an unlabeled box, likely button clip, an uncleared grant field, and unsmoked desk height — not trust-breakers.

Isolated `lua tests/test_console.lua` **744 passed, 0 failed**, exit 0. Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
