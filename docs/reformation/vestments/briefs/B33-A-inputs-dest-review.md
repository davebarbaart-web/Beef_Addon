Spec PASS

# B33-A — SetInputTarget trims the whisper dest (review)

**Quality:** Approved-with-nits

**Lane:** B33-A SetInputTarget trims the whisper dest
**Brief:** `docs/reformation/vestments/briefs/B33-A-inputs-dest.md`
**Writer report:** `docs/reformation/vestments/briefs/B33-A-inputs-dest-report.md`
**Diff:** `docs/reformation/vestments/briefs/B33-A-inputs-dest.diff` (B33-A-only exclusive-pair packet; live `Inputs.lua` / `test_inputs.lua` are untracked vs HEAD and also carry earlier Inputs batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Inputs.lua` (`SetInputTarget` ~221–239 / `readyToSend` / Petition / Catchup / Confess / `petitionOpponent` gsub trim), and `tests/test_inputs.lua` (isolation wrap, existing empty-dest pins, nested `runB33A()` inside `runB21D()` after `runB23D()`); then ran `lua tests/test_inputs.lua` (**848 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: License 2 / Bible §13.1 (favor / petition / confess / catchup whisper to the injected dest); B23-D leftover (`SetInputTarget` stored any non-empty string, including `" "`, so `Names.Same("Host", " ")` was false and dest-same omit failed). `SetInputTarget` calls `Names.Trim` (fallback `^%s+` / `%s+$`); empty after trim is nil (no target). Opponent / player gsub trim stay. `readyToSend` / Petition / Catchup / Confess keep. No Pope-name lookup. No auto snapshot. No realm compare invent. Did not mutate `Inputs.lua` or `test_inputs.lua`. Did not commit. Did not edit BeefNet, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `SetInputTarget` still stores `" "` / `"  Host  "` (B23 leftover; dest-same omit fails; whisper dest is padded) | **Pass. Verified.** Live body prefers `COB.Names.Trim`, else `gsub("^%s+", "")` / `gsub("%s+$", "")` and nils `""`. Nested: `"  Host  "` stores / whispers `"Host"`; `"   "` / `" "` are no target. Reviewer probe: `Names.Trim` is invoked (1 call); space dest refuses Petition; unpadded `"Host"` opponent vs trimmed dest omits. |
| Empty after trim is still a dest; Petition / Catchup / Confess still send | **Pass. Verified.** Nested whitespace dest: all three verbs `false, "no target"` and spy counts 0. Reviewer probe: tabs / newlines / `"\t\n  \r"` are no target; number / nil / `""` / bool wipe a prior dest. |
| Opponent / player trim rewritten or dropped | **Pass.** Live `petitionOpponent` still `targetName` / `playerName` `gsub("^%s+", ""):gsub("%s+$", "")`. Source pins stay. Nested keep pins: whitespace opponent omits; padded Chuckroast names; dest-same / player-same omit; empty / whitespace player omit. Reviewer probe: Petition does not call `Names.Trim`; opponent still `"Chuckroast"`. |
| Pope-name lookup / `Popes` / `IsRegisteredPope` / `TargetUnit` | **Pass.** Live `Inputs.lua` has no `Popes`, `IsRegisteredPope`, `TargetUnit`, `GetGuildRosterInfo`, `LookupPope`, or `FindPope`. Nested source + wrap pins. Reviewer probe: those APIs stay nil; `Inputs.Favor` is nil. |
| `readyToSend` / Petition / Catchup / Confess rewritten; auto snapshot | **Pass.** Packet is `SetInputTarget` + header comments. Live verbs still refuse then spy Net. Catchup still has its own empty-dest check. No `RequestSnapshot` inside `SetInputTarget`. |
| `Names.Display` / `Names.Key` / invented realm compare | **Pass. Verified.** Dest path names `Names.Trim` only. Reviewer probe: `"  Host-Whitemane  "` stores `"Host-Whitemane"`; `Display` would have stripped to `"Host"`. |
| New main-chunk locals / not nested after `runB23D()` / isolation wrap rewritten | **Pass.** `runB33A()` is a nested `local function` inside `runB21D()` after `runB23D()` / `runB18A()`. Packet adds no main-chunk `local`. Isolation wrap stays **23** under the first `if standalone then`. |
| Isolated suite not exit 0 / exclusive breach | **Pass. Verified.** 848 passed, 0 failed. Writer-reported count matches. Packet is the two named files. Sibling dirt (`ChurchOfBeef.lua`, TOC, BeefNet, `tests/run.lua`) is other lanes, not this packet. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit BeefNet, glue; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| `SetInputTarget`: `Names.Trim(name)` (fallback `^%s+` / `%s+$`) | **Pass.** Live body + source pin + reviewer Trim wrap / fallback probes. |
| Empty after trim is nil (no target) | **Pass.** Nested `"   "` / `" "` + existing `""` / nil pins. |
| `readyToSend` / Petition / Catchup / Confess keep | **Pass.** Named-risk check. |
| Opponent trim stays | **Pass.** Named-risk check. |
| No Pope-name lookup | **Pass.** Named-risk check. |
| No auto snapshot; no realm compare invent | **Pass.** Named-risk check. |
| Nest `runB33A()` after `runB23D()`; `SetInputTarget("  Host  ")` stores `"Host"`; whitespace dest is `"no target"` and does not send | **Pass.** Nested block. |
| Existing opponent / player trim pins stay; isolation wrap stays | **Pass.** Keep pins re-run inside `runB33A()`. Wrap **23**. |
| `lua tests/test_inputs.lua` exit 0 | **Pass.** **848 / 0.** |

License 2 / §13.1 holds on the exclusive pair: petition / catchup / confess whisper the injected dest after trim, or they refuse when trim leaves nothing. Inputs still does not look up a Pope. Law 5 holds: congregation verbs remain dest-injected, not self-authoritative. Opponent / player identity trim stays on `petitionOpponent`; dest trim did not replace it.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client / two-client smoke; padded injected dest unproven on Anniversary | **Not a miss.** Brief asked the isolated suite. Dest trim is Event Mode whisper. |
| Glue still injects dest; this lane does not look up a Pope name | **On contract.** Brief forbade Pope lookup and glue edits. `paintInboundInputs` / `bindSlashInputTarget` still own the string. |
| Fallback path is source-only; isolated suite always loads Common | **On contract as a leftover.** Brief required the fallback in `SetInputTarget`. Reviewer probe (Trim nil / `Names` nil) trims and refuses. Suite does not pin that runtime. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

Inputs has no Favor verb. License 2 names favor alongside the three Inputs verbs; favor dest is not this exclusive (sibling B33-D / Hud). Not a miss.

---

## Isolation / dest / opponent

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + Inputs. No `dofile` of Net, glue, Console, Popes, or BeefNet. Standalone wrap is still **23** nils (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Gora, Store, RecordsBook, Decree, DecreeBanner, Popes, Sound, FighterCard, Confession). Reviewer probe: `COB.Popes` is nil at load. Wrap was not rewritten. Nested B33-A re-pins Console / Popes / Sender / Sound / Hud plus slash.

**Dest trim — Pass.** `SetInputTarget` stores only a string from `Names.Trim` (or the matching fallback). Empty after trim is nil. `GetView().target` after `"  Host  "` is `"Host"`; Petition / Catchup / Confess whisper `"Host"`. `"   "` / `" "` / `""` / nil / non-string are no target. `readyToSend` and Catchup still refuse `type(inputTarget) ~= "string" or inputTarget == ""`. Refresh / Hide rebuild `lastView` from `inputTarget`, so the trimmed dest survives paint. Reviewer probe: tab / newline pad stores `"Host"`; `"  Host Roast  "` keeps the inner space; `"  host  "` keeps case.

**Opponent / player — Pass.** `petitionOpponent` still trims with `gsub`, then `Names.Same` versus dest and player. Dest-same omit now sees a trimmed dest, so the B23 leftover (`Same("Host", " ")` is false) cannot fire: whitespace dest is no target before opponent is read. Padded opponent / player keep pins still pass.

---

## Strengths

- The delta is the brief: one `SetInputTarget` trim. `readyToSend`, Petition, Catchup, Confess, and opponent `gsub` were left alone.
- B23 leftover (stored `" "` broke dest-same; padded dest would whisper spaces) is closed on the same Host / Chuckroast / Beefina fixture, not a second dest language. Whitespace refuse sits next to padded-Host send, so a blanket nil would fail.
- `Names.Trim` is the existing Common helper. Fallback matches that helper. Dest does not call `Display` / `Key`, so realm is not invented.
- `runB33A()` sits after `runB23D()` on the same fixture. Isolation wrap stays **23**. No new main-chunk locals. Writer-reported **848 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Glue still injects dest.** `paintInboundInputs` passes the inbound sender; `bindSlashInputTarget` still treats `UnitName("target") ~= ""` as injectable, so a slash-time `" "` reaches `SetInputTarget` and becomes no target. Brief forbade Pope lookup and glue edits. B33-D Net dest refuse is a sibling exclusive. Do not expand this pair.

### Nit

1. **Fallback `gsub` is source-pinned, not suite-exercised.** Isolated load always has Common. Reviewer probe (Trim nil / `Names` nil) matches `Names.Trim`. A comment token would still pass the `Names.Trim` / `gsub` finds.

2. **Tabs / newlines / realm dest / inner spaces are not pinned.** Reviewer probe: `%s` pad trims; `"Host-Whitemane"` stays; inner space and case stay.

3. **`runB33A()` re-pins opponent / player trim already covered by B23-D.** Brief said those pins stay. They still pass earlier in the same `runB21D()` nest.

4. **`readyToSend` / Catchup `== ""` is now belt-and-suspenders** if `SetInputTarget` is the only writer. Brief said keep those checks.

5. **Exclusive-pair diff is not a vs-HEAD Inputs delta.** Packet is the B33-A-only `SetInputTarget` trim + nested pins. This checkout shows the two exclusive files as untracked; `git diff HEAD` on them is empty. Report already says this. Sibling dirt is other lanes.

6. **No `/reload` / two-client padded-dest smoke and no full `lua tests/run.lua`.** Isolated **848 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **848 passed, 0 failed.** Isolation wrap: **23**.

`SetInputTarget` trims via `Names.Trim` (fallback `^%s+` / `%s+$`). Empty after trim is nil (no target). `"  Host  "` stores and whispers `"Host"`. `"   "` / `" "` refuse Petition / Catchup / Confess with `"no target"` and do not send. Opponent / player `gsub` trim stay. No Pope lookup. No `Names.Display` realm strip. Isolated `lua tests/test_inputs.lua` **848 passed, 0 failed**, exit 0.

Leftovers: glue still injects dest (slash `" "` becomes no target here; B33-D is sibling Net refuse; do not expand exclusive); fallback is source-pinned (reviewer probe agrees); no client smoke; full harness not run.

Do not claim V1 / MVP complete. This review does not sign the lane.
