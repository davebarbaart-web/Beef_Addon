Spec PASS

# B5-B — Candidate / fighter raid marks (review)

**Quality:** Approved-with-nits

**Lane:** B5-B Candidate / fighter raid marks
**Brief:** `docs/reformation/vestments/briefs/B5-B-markers.md`
**Writer report (unverified claims except isolated count):** `docs/reformation/vestments/briefs/B5-B-markers-report.md`
**Diff:** `docs/reformation/vestments/briefs/B5-B-markers.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, `UI/Markers.lua`, and `tests/test_markers.lua`. Isolated `lua tests/test_markers.lua` was re-run: **251 passed, 0 failed, exit 0**. Did not edit addon code or tests. Did not commit. Did not run `lua tests/run.lua`. This review does not sign the lane.

The provided diff is two `diff --git` hunks: `UI/Markers.lua` and `tests/test_markers.lua`. Current `ChurchOfBeef.toc` does not list `Markers.lua`. Current `tests/run.lua` does not list `test_markers`. No other addon file references `COB.Markers`. Sibling dirt on Console / Knighting / Gora / TOC is other lanes.

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Event + Pope + grouped → `MarkCandidate` spies `SetRaidTarget(unit, 1)` | **Pass.** `StartEvent` + `Sender:IsRegisteredPope == true` + raid stub → `SetRaidTarget("raid2", 1)`. Token is scanned, not the character name. `MarkFighters` places 2 then 3. `Clear` places 0. |
| Quiet refuse (all verbs) | **Pass.** Fresh runtime is `QUIET`. `Target` / `MarkCandidate` / `MarkFighters` / `Clear` return `false, "quiet"`. No `TargetUnit`, no `SetRaidTarget`. Missing Runtime is the same refuse. `EndEvent` refuses again. Law 6 preference (Quiet-refuse Target too) is the path they took. |
| `SetRaidTarget` / `TargetUnit` type-guarded | **Pass.** Both are `type(...) == "function"` before use, then `pcall`. `GetRaidTargetIndex`, `GetNumGroupMembers`, and `IsInRaid` are type-guarded the same way. Source pins in the suite are literal `type(TargetUnit)` / `type(SetRaidTarget)` finds. |
| Fail-closed | **Pass.** Missing `SetRaidTarget` / `TargetUnit` / group APIs → `false`, no throw (`pcall` wrapper around the verb). `TargetUnit` / `SetRaidTarget` errors are swallowed. Missing `GetRaidTargetIndex` still marks. Unlisted / missing / non-`true` Pope → `false, "not a registered pope"`. Ungrouped Mark* / Clear → `false, "not in a group"`. Unresolved name → `false, "unit not found"`. |
| No combat automation | **Pass.** Source has no `StartAttack`, `AttackTarget`, `AssistUnit`, `CastSpell`, `UseAction`, or `SecureActionButton`. Suite combat spies stay at 0 through Quiet, marks, and a planted `playerInCombat`. `TargetUnit(name, true)` is desk assist (Bible §8 / Appendix A item 6), not an attack. |
| Isolated green | **Pass. Verified.** `lua tests/test_markers.lua` → **251 passed, 0 failed, exit 0**. Load list is wow_ui_stub + Common + Runtime + Markers. **27** nil-module / slash pins sit inside `if standalone then`. |
| Exclusive files; no TOC / `run.lua` / Knighting / Gora / Console / commit | **Pass.** Packet is the two exclusive files. TOC and the harness still omit this module (integrator work, as the brief required). No `GuildPromote`. |

Bible §8 (target the candidate; raid-mark when grouped), Appendix A items 5–6 (mark + name-target, fail toward target-assist), Law 5 (Pope client only), and Law 6 (Event chrome; Quiet silent) hold on this pair. The module is a verb library. Auto-place on a queue click is integrator glue, not this lane.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Integrator must list TOC / `run.lua` and wire Console / Knighting | **Not a miss.** Brief forbade those edits. |
| `#8` stays fail-closed until `IsRegisteredPope(local)` is true | **Not a miss.** That is the Pope gate. |
| Party scan cannot mark the local player | **Not a miss.** Brief forbids inventing a `player` token. `raid1..N` includes the player; `party1..N` does not. |
| `SetRaidTarget` still needs raid leader/assist | **Acceptable leftover; report overclaims.** See Minor. |
| `TargetUnit` may be protected in combat | **Not a miss.** `pcall`; no secure button. Appendix A item 6. |
| `MarkFighters` is resolve-atomic, not apply-atomic | **Named accurately.** See Minor. |
| No client `/reload` | **Expected.** No Quiet chrome this lane. |

---

## Named risks

| Risk | Verdict |
|---|---|
| Event + Pope + grouped | **Clean.** Happy path spies `SetRaidTarget("raid2", 1)`. Party path spies `party1`. Pope gate reads `Group.PlayerName()` (`"Beefina"`). |
| Quiet refuse | **Clean.** All four verbs. No targeting, no marks, no sound, no chat, no addon messages. |
| Type-guarded `SetRaidTarget` / `TargetUnit` | **Clean.** Guard then `pcall`. Nil API and thrown API are both false. |
| Fail-closed / no throw | **Clean.** Suite wraps the missing-API and error cases in `pcall` and pins `threw == true` (the wrapper), `callOk == false` (the verb). |
| No combat automation | **Clean.** Source greps and runtime spies agree. |
| Isolated green | **Clean.** Re-run here: 251 / 0, exit 0. |

---

## Strengths

- Gate order is Quiet → Pope → name → grouped → resolve → apply. Congregation and ungrouped clients cannot mark. `Target` is the only verb that may run ungrouped, and only in Event for a registered Pope.
- Unit tokens are only `raidN` / `partyN` from `GetNumGroupMembers`. `SetRaidTarget` never receives a character name. Anniversary `SetRaidTarget(target, userIndex)` wants a `UnitToken`; they honor that.
- `TargetUnit(trimmed, true)` matches the catalog (`name`, `exactMatch`). Padding is trimmed through `Names.Trim`. `Names.Same` covers case and realm suffix on the mark path.
- `MarkFighters` resolves both names before either `SetRaidTarget`. A missing second fighter leaves `#raidTargets` at 0.
- `GetView` is a deepcopy. Mutating `ok` / `unit` / `index` / `mode` does not move `last`. `ResetForTests` is `_IN_TEST` only.
- Isolation stayed gated. The suite can join `tests/run.lua` later without the nil-module pins exploding.
- No frames, sound, Toasts, Net, chat, GuildPromote, or custom Media. `MODE = "Event"` is declared.

wow-api MCP (`classic_anniversary`): `TargetUnit`, `SetRaidTarget`, and `GetRaidTargetIndex` exist. `GetNumGroupMembers` / `IsInRaid` / `IsInGroup` are absent from the catalog. The brief already required `type() == "function"` guards and fail-closed, same as `Core/Common.lua` Group. That catalog gap is handled, not papered over.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **`GetRaidTargetIndex` is invoked and discarded.** `applyMark` `pcall`s it after a successful `SetRaidTarget` and ignores the return. The happy-path suite pins that it was read, so it looks like a stick-check that is not one. If the client no-ops `SetRaidTarget` without error (Pope not raid leader/assist — Appendix A item 5), `MarkCandidate` still returns `true`. The writer report's "silent fail-closed false" is therefore wrong for the no-throw no-assist case. Fallback is still `Target`, but the boolean is not a mark-applied signal. Brief fail-closed is "missing API → false"; this is not a spec miss.

2. **`MarkFighters` apply is not atomic.** Both units must resolve first (pinned). If the second `SetRaidTarget` throws, the first mark (index 2) can remain while the verb returns false. Writer named this.

3. **`reset()` asserts `ResetForTests` on every fixture.** Ten resets × two hatch asserts are part of the 251. The hatch is also pinned once at the end (in-harness / out-of-harness). Inflated count, not a missing gate.

4. **`IsInGroup` is an extra probe.** Brief named `GetNumGroupMembers` / `IsInRaid`, matching Common. `IsInGroup` is type-guarded and unused on this stub (the stub does not define it). Harmless. If a later client had `IsInGroup` without `GetNumGroupMembers`, grouped would pass and resolve would still fail closed as `"unit not found"`.

5. **`Runtime:Snapshot()` is not pcalled.** A throwing Snapshot would escape the verb. Production Runtime should not throw. Missing Runtime / missing `Snapshot` already refuse Quiet.

6. **Client `/reload` was not run.** Expected. No chrome. Integrator still owes two-client Event smoke after Console wires the verbs.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

This is the B5-B contract: Event Mode target + raid marks on the Pope's client; Quiet refuses every verb; `TargetUnit` / `SetRaidTarget` are type-guarded and pcalled; missing APIs and ungrouped / unlisted-Pope / unresolved-unit paths fail closed without throwing; no combat automation; isolated suite green (251 / 0, exit 0). Exclusive pair only.

Nits are an unused `GetRaidTargetIndex` result (writer overclaims no-assist fail-closed), apply-not-atomic `MarkFighters`, and hatch asserts folded into `reset()`. None break the named gates. Integrator can sign B5-B on the exclusive pair after TOC / `run.lua` / Console wire; do not block on the Minors. This review does not sign the lane.

Do not claim **POLISH:PASS**. Do not claim V1 / MVP complete.
