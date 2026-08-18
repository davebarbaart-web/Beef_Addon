Spec PASS

# B18-A — Inputs confess box below TitleBar + trim opponent (review)

**Quality:** Approved-with-nits

**Lane:** B18-A Inputs confess box below TitleBar + trim opponent
**Brief:** `docs/reformation/vestments/briefs/B18-A-inputs-gap.md`
**Writer report:** `docs/reformation/vestments/briefs/B18-A-inputs-gap-report.md`
**Diff:** `docs/reformation/vestments/briefs/B18-A-inputs-gap.diff` (B18-A-only exclusive-pair packet; both exclusive files are still untracked vs HEAD and also carry earlier Inputs batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Inputs.lua` (`build` confess-box `SetPoint` + `petitionOpponent` trim), and `tests/test_inputs.lua` (nested `runB18A()`, TitleBar 12, HEIGHT 72, existing Chuckroast pin, whitespace omit, padded trim, Quiet / ESC / isolation keep-pins); then ran `lua tests/test_inputs.lua` (**599 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: confess box `TOP` / `-14`; HEIGHT 72; trim opponent (`^%s+` / `%s+$`); whitespace-only omits; TitleBar / ESC / persist stay. Bible §13.1 / §18.5 (congregation input; inputs never trigger public theater); Law 10 / §19.3 (Inputs stay stock); B16-B leftover (box ate the lower 4px of the 12px handle); B17-C leftover (whitespace-only / padded `UnitName` reached `SendPetition`); B17-C challenge law stays. Isolation stays `wow_ui_stub` + Common + Runtime + Inputs. Did not mutate `Inputs.lua` or `test_inputs.lua`. Did not commit. Did not edit Net, Codec, Console, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Confess box still eats the lower 4px of the 12px TitleBar | **Pass. Verified.** Live `SetPoint("TOP", widget, "TOP", 0, -14)`. Pin: `GetPoint` is `TOP` / root / `TOP` / `0` / `-14`, and `by <= -12`. TitleBar height stays **12**. Reviewer probe: 2px gap under the strip (`-12` to `-14`); box occupies `-14`…`-36`; buttons sit `BOTTOM` + 10 (band from y 40). No y overlap with the handle. |
| HEIGHT grown / buttons moved | **Pass. Verified.** Constants still `328, 72`. Pins: frame 328×72; all three buttons `GetPoint` y **10**. Source pin is the existing `local WIDTH, HEIGHT = 328, 72` line. Reviewer probe: same. |
| Whitespace-only / padded `UnitName` still forwarded untrimmed | **Pass. Verified.** Stub `"   "` sends `{ characterId }` only (`opponent` nil). Stub `"  Chuckroast  "` sends `opponent = "Chuckroast"`. Click path uses the same helper. Reviewer probe: `"\t\t"` / `" \n "` omit; `"\tChuckroast\n"` trims to `"Chuckroast"`; omit keys are `characterId` only. |
| Challenge law broken (dest / self named as opponent) | **Pass. Verified.** Existing Chuckroast pin stays. Padded `"  Host  "` / `"  Beefina  "` omit after trim. B17-C Host / Host-realm / Beefina / Beefina-realm pins still run above this block. Reviewer probe: case-fold `"host"` / `"beefina"` omit (`Names.Same`); padded `"  Host-Whitemane  "` omits. Dest stays injected `inputTarget`. |
| TitleBar / ESC / persist broken; Inputs listed on `UISpecialFrames` | **Pass. Verified.** `runB18A` re-pins TitleBar height 12, root no `OnDragStart`, ESC `ClearFocus` / no Hide, not listed. Source still `SetMultiLine(true)`, `db.inputs`, `SetHeight(12)`. Persist stay is the earlier B15-A TitleBar `OnDragStop` block plus the source pin. Reviewer probe: TitleBar start/drop still writes four-field `ui.inputs` (`TOPLEFT` / `24` / `90`); `ResetForTests` leaves SV; `#UISpecialFrames == 0`. |
| `PlaySound` / Pope lookup / `TargetUnit` / `Gora:Petition` | **Pass.** Source has none of those strings. `runB18A` spies `targetCalls == 0`, `sounds == 0`, `goraCalls == 0`. Suite end still `#stub.chat == 0`. |
| Isolated suite not exit 0 | **Pass. Verified.** 599 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Packet is two `diff --git` hunks (box `-8` → `-14`; `petitionOpponent` trim-before-Same; header comments; nested `runB18A()`). Sibling dirt in this workspace is other lanes (Net / Codec / Console / Snapshot / TOC / bootstrap / `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Net / Codec / Console / glue; no commit | **Pass.** Named-risk check. |
| Isolation stays `wow_ui_stub` + Common + Runtime + Inputs | **Pass.** Three `dofile`s unchanged. First standalone wrap still **24** nil-module / no-slash pins. |
| Confess box `TOP` / `-14` (or ≤ `-12`); fully below the 12px strip | **Pass.** Live and pin are exact `-14`. B16-B 4px occlusion is closed on the exclusive pair. |
| Do not grow HEIGHT; buttons stay `BOTTOM` + 10 | **Pass.** Named-risk check. |
| Trim target name `^%s+` / `%s+$` before `Names.Same`; empty after trim → omit | **Pass.** Helper drops the old `targetName == ""` check and trims, then returns nil on `""`. `Names.Same` sees the trimmed string. |
| `"  Chuckroast  "` becomes `"Chuckroast"` | **Pass.** Petition and click pins. |
| Existing opponent pins stay | **Pass.** B17-C Chuckroast / dest / self / missing / throw / empty pins still run. `runB18A` re-pins unpadded Chuckroast. |
| TitleBar 12px + persist `ui.inputs` stay | **Pass.** Named-risk check. |
| ESC `ClearFocus`; `SetMultiLine(true)`; not `UISpecialFrames` | **Pass.** Named-risk check. |
| Quiet / isolation wrap stay | **Pass.** Quiet Petition is false and does not send. `runB18A` re-pins Console / Popes / Sender / Sound / Hud / slash. |
| No Pope-name lookup; no `PlaySound`; challenge law stays | **Pass.** Named-risk check. |
| `lua tests/test_inputs.lua` exit 0 | **Pass.** **599 / 0.** |

Bible §13.1 / §18.5 hold on the exclusive pair: Inputs still only spies Net and does not open theater. Law 10 holds: stock chrome, no copy, no `PlaySound`. B17-C challenge law holds after trim. Missing `UnitName` stays fail-closed.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; live TitleBar grab vs confess-box hit rect is unproven; harness `GetPoint` is a stub | **Not a miss.** Brief asked the isolated suite. **POLISH:CANDIDATE** is the ceiling. |
| No chrome hint that a current target will be named | **On contract.** Brief froze stock Petition chrome and HEIGHT 72. No copy was asked. |
| Internal whitespace is not collapsed (`"Chuck roast"` sends as-is) | **On contract.** Brief named leading / trailing `^%s+` / `%s+$` only. Reviewer probe: `"Chuck roast"` is forwarded. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

B17-A / B17-B still own encode and Pope-side name → id. This lane only forwards a trimmed name, or omits. B18-INT glue is not required.

---

## Isolation / box / trim / keep

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + Inputs. No `dofile` of Net / Codec / Console / Gora / Popes / UI shell. First standalone wrap is still **24** nils (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Gora, Store, RecordsBook, Decree, DecreeBanner, Popes, Sound, FighterCard, Confession, slash). `runB14B()` re-pins 6; `runB15A()` re-pins 6 for B15-A and 6 for B16-B; `runB17C()` re-pins 6; `runB18A()` re-pins the same six. Reviewer probe: Console / Popes / Sender / Sound / Hud / UI / DB / Gora / Codec / slash stay nil after load. Wrap is load-time only (unchanged).

**Confess box — Pass.** `TOP` / widget / `TOP` / `0` / `-14`. Height 22. TitleBar stays 12px TOPLEFT/TOPRIGHT at `0`,`0`. The B16-B leftover (box at `-8` eating y `-8`…`-12`) is closed. HEIGHT 72 and `BOTTOM` + 10 were not used as slack.

**Trim — Pass.** `petitionOpponent` still pcalls both unit-name reads. After a successful string target, it `gsub`s `^%s+` then `%s+$`, then omits `""` before `Names.Same`. Dest-same and player-same still omit. `Inputs:Petition` still starts from `{ characterId }` and adds `opponent` only when the helper returns a name. Dest stays `inputTarget`. Quiet never reaches the helper.

**Keep — Pass.** TitleBar persist `ChurchOfBeefDB.ui.inputs`. ESC `ClearFocus` only. `SetMultiLine(true)`. Not on `UISpecialFrames`. Existing unset-target spy stays opponent-less. No Pope lookup. No `TargetUnit`. No `Gora:Petition`. No `PlaySound`.

---

## Strengths

- The two leftovers this lane named are closed on the exclusive pair: the box is fully below the 12px handle, and whitespace-only / padded `UnitName` no longer reach `SendPetition` as-is.
- Trim runs before `Names.Same`, so padded dest / self fold through the same challenge law instead of a second compare.
- Existing B17-C pins were left in place. `runB18A` re-pins unpadded Chuckroast, Quiet, ESC, TitleBar 12, HEIGHT 72, buttons + 10, and the isolation six. The new block is nested so the Lua 5.1 200-local cap is not spent in the main chunk.
- Writer-reported **599 / 0** matched the re-run. Writer-reported red **590 / 9** is consistent with the new `-14` / trim / source-gsub pins that old `-8` / untrimmed `petitionOpponent` would fail (plus the HEIGHT source pin they then pointed at the existing constant line). Reviewer did not revert to re-run red.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **No client `/reload`.** Harness `GetPoint` / `SetPoint` is a stub. Live `InputBoxTemplate` hit rect vs the 12px TitleBar grab is unproven. Brief asked the isolated suite. **POLISH:CANDIDATE** only.

### Nit

1. **`runB18A` does not fire TitleBar `OnDragStop`.** Persist stay is the earlier B15-A block plus a `db.inputs` source pin. Reviewer probe (ClearAllPoints then `TOPLEFT` / `24` / `90` then TitleBar drop) still writes the four-field table. Brief said persist stays; it did.

2. **Player read fail-open is unchanged.** If `UnitName("player")` throws, `pok` is false and a successful target name is still returned. Reviewer probe: player throw + target `"Beefina"` names `"Beefina"`. B17-C leftover. Brief did not ask to close it.

3. **Padded dest / self omit was already `Names.Same`.** Common `Names.Key` already trims. The hole this lane closes is whitespace-only forwarded as a non-empty string (`Same("   ", "Host")` is false) and the padded name sent with spaces. The extra `"  Host  "` / `"  Beefina  "` pins are keep-pins, not the leftover.

4. **Isolation wrap is load-only.** Twenty-four pins under the first `if standalone then`. Later blocks re-pin six keys. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Inputs delta.** Both exclusive files are still `??` in this workspace. Packet is the B18-A-only box move + trim + pins vs the pre-lane text. Report already says this.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **599 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **599 passed, 0 failed.** Isolation wrap: **24**.

Confess box sits `TOP` / `-14` under the 12px TitleBar. HEIGHT stays 72. Buttons stay `BOTTOM` + 10. `petitionOpponent` trims `^%s+` / `%s+$` before `Names.Same`; empty after trim omits opponent; `"  Chuckroast  "` sends `"Chuckroast"`. Dest / self still omit. TitleBar persist, ESC `ClearFocus`, and `SetMultiLine(true)` stay. Not on `UISpecialFrames`. Isolation stays `wow_ui_stub` + Common + Runtime + Inputs. Isolated `lua tests/test_inputs.lua` **599 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
