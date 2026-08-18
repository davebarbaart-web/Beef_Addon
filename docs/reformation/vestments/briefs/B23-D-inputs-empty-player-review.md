Spec PASS

# B23-D — Empty player name omits petition opponent (review)

**Quality:** Approved-with-nits

**Lane:** B23-D Empty player name omits petition opponent
**Brief:** `docs/reformation/vestments/briefs/B23-D-inputs-empty-player.md`
**Writer report:** `docs/reformation/vestments/briefs/B23-D-inputs-empty-player-report.md`
**Diff:** `docs/reformation/vestments/briefs/B23-D-inputs-empty-player.diff` (B23-D-only exclusive-pair packet; both exclusive files are still untracked vs HEAD and also carry earlier Inputs batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Inputs.lua` (`petitionOpponent` after dest-same / fail-closed), and `tests/test_inputs.lua` (`runB23D()` nested inside `runB21D()` / `runB18A()`, empty / whitespace player omit, unpadded Chuckroast + successful Beefina still names, pcall fail / dest-same / missing `UnitName` / Quiet / ESC / TitleBar / isolation keep-pins); then ran `lua tests/test_inputs.lua` (**756 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: trim the player name (`^%s+` / `%s+$`) like the target; after trim, empty or non-string omits opponent; successful `"Beefina"` + `"Chuckroast"` still names; nest in `runB18A()` / `runB21D()`. Bible §10.2 / §18.5 (a petition may name a desired opponent; congregation input never triggers public theater); Law 5 / §13.1 (whisper dest stays injected `inputTarget`); B21-D leftover (`""` and `"   "` from `UnitName("player")` are strings, so fail-closed does not run; `Names.Same` is false and the target is named as opponent). Challenge law (B17-C) and player-pcall fail-closed (B21-D) stay. Isolation stays `wow_ui_stub` + Common + Runtime + Inputs. Did not mutate `Inputs.lua` or `test_inputs.lua`. Did not commit. Did not edit Net, Codec, Console, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Empty / whitespace `UnitName("player")` still names Chuckroast | **Pass. Verified.** After fail-closed: `playerName = playerName:gsub("^%s+", ""):gsub("%s+$", "")` then `type(playerName) ~= "string" or playerName == ""` returns nil. Pins: target `"Chuckroast"`, player `""` / `"   "`, dest `"Host"` → `fields.opponent` nil; send still once; dest stays `"Host"`; keys stay `{ characterId }`. `Names.Same("Chuckroast", "")` / `"   "` is false (`Key` is nil), so trim-without-empty would still name. Reviewer probes: same; tab / newline-only also omit. |
| Successful `"Beefina"` + `"Chuckroast"` no longer names opponent | **Pass. Verified.** Unpadded `"Chuckroast"` + player `"Beefina"` still sends `opponent = "Chuckroast"`. B17-C / B18-A / B21-D unpadded pins still run above this block. Reviewer probe: padded `"  Beefina  "` still names; two-return Anniversary `UnitName` (`"Chuckroast","Whitemane"` / `"Beefina","Whitemane"`) still names `"Chuckroast"`. |
| Player pcall fail / dest-same / missing `UnitName` broken | **Pass. Verified.** B23-D re-pins player throw omit, dest-same Host + successful Beefina omit, missing `UnitName` omit and still send. B21-D fail-closed / dest-same / player-same / missing API pins still run above. Reviewer probe: dest-same + empty player also omits; `false` / `123` / `{}` still omit. |
| New main-chunk locals / Lua 5.1 200-local | **Pass.** Packet adds `local function runB23D()` inside `runB21D()` inside `runB18A()` and calls it before the parent restores `UnitName`. No new main-chunk locals. Isolated suite loaded on Lua **5.1.5** with no `too many local variables`. |
| Pope lookup / `TargetUnit` / `PlaySound` / `Gora:Petition` | **Pass.** Source has none of those strings (`Popes` / `IsRegisteredPope` included). `runB23D` spies `sounds == 0`, `goraCalls == 0`. Whisper dest stays `inputTarget`. Reviewer probe: dest `"NotAPope"` stays; opponent is still `"Chuckroast"` when the player read succeeds. |
| HEIGHT grown / ESC Hides / Inputs listed on `UISpecialFrames` | **Pass. Verified.** Constants still `328, 72`. `runB23D` re-pins WIDTH / HEIGHT / TitleBar 12 / root no `OnDragStart` / ESC `ClearFocus` / no Hide / not listed. Source still `SetMultiLine(true)`, `db.inputs`, `SetHeight(12)`, confess box `TOP` / `-14`. |
| Isolated suite not exit 0 | **Pass. Verified.** 756 passed, 0 failed. Writer-reported green count matches. |
| Exclusive file breach | **Pass.** Packet is two `diff --git` hunks (header comments; player trim + empty-after-trim; nested `runB23D()`). Sibling dirt in this workspace is other lanes (Net / Codec / Console / Snapshot / TOC / bootstrap / `run.lua`). Both exclusive files are still `??` vs HEAD. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Net / Codec / Console / glue; no commit | **Pass.** Named-risk check. |
| Isolation stays `wow_ui_stub` + Common + Runtime + Inputs | **Pass.** Three `dofile`s unchanged. First standalone wrap still **24** nil-module / no-slash pins. |
| Trim the player name (`^%s+` / `%s+$`) like the target | **Pass.** Same gsub pair as `targetName`. Source pin names `playerName:gsub("^%s+", ""):gsub("%s+$", "")`. |
| After trim, empty or non-string → omit opponent | **Pass.** Named-risk check. `""` and `"   "` omit. Fail-closed still catches non-string before `:gsub`. |
| pcall fail still omits; dest-same still omits; missing `UnitName` stays omit | **Pass.** Named-risk check. |
| Successful `"Beefina"` + `"Chuckroast"` still names opponent | **Pass.** Named-risk check. |
| Nest in `runB18A()` / `runB21D()`; no new main-chunk locals | **Pass.** `runB23D()` is defined and called inside `runB21D()`, which is called inside `runB18A()`. |
| Quiet / ESC / TitleBar / isolation wrap stay | **Pass.** Quiet Petition is false and does not send (empty-player stub still live). ESC `ClearFocus` only. TitleBar 12. `runB23D` re-pins Console / Popes / Sender / Sound / Hud / slash. |
| No Pope-name lookup; no `PlaySound`; no `TargetUnit`; no `Gora:Petition`; no realm compare | **Pass.** Named-risk check. `pcall` still keeps the first `UnitName` return only. |
| Challenge law (B17-C) and player-pcall fail-closed (B21-D) stay | **Pass.** Named-risk check. WIDTH 328 / HEIGHT 72 stay. Not on `UISpecialFrames`. |
| `lua tests/test_inputs.lua` exit 0 | **Pass.** **756 / 0.** |

Bible §10.2 / §18.5 hold on the exclusive pair: a petition may still carry a desired opponent name when both reads succeed and the player string is non-empty after trim; Inputs still only spies Net and does not open theater. Law 5 holds: whisper dest stays injected `inputTarget`. The B21-D leftover (empty / whitespace player fail-open) is closed. Law 4 holds: omit does not invent a kind or a rite.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Parked Console `lastRecommendation` lifetime / selected-pair inherit of Core `namedOpponent` | **On contract.** Brief froze this exclusive pair. Console paint is a later batch. |
| No client `/reload`; live `UnitName("player")` empty / whitespace on Anniversary is unproven | **Not a miss.** Brief asked the isolated suite. **POLISH:CANDIDATE** is the ceiling. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. `run.lua` was not edited. |
| Internal whitespace is not collapsed | **On contract.** Brief kept `^%s+` / `%s+$` only. |
| No realm compare | **On contract.** Brief forbade inventing one. `Names.Same` still folds dest / player spelling when the trimmed player string is non-empty. |
| Non-string player pin is still `nil` only (B21-D leftover) | **On contract.** Brief asked empty / whitespace strings. Reviewer probe: `false` / `123` / `{}` still omit. |
| Click + empty player is unpinned | **On contract.** Brief asked `Inputs:Petition`. Petition button still calls that verb. Reviewer probe: click + `""` / `"   "` omit; click + Beefina still names. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

B17-A / B17-B still own encode and Pope-side name → id. This lane only fail-closes empty / whitespace player reads on the congregation helper. B23-INT glue is not required: `Inputs:Petition` already calls `petitionOpponent`.

---

## Isolation / trim / keep

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + Inputs. No `dofile` of Net / Codec / Console / Gora / Popes / UI shell. First standalone wrap is still **24** nils (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Gora, Store, RecordsBook, Decree, DecreeBanner, Popes, Sound, FighterCard, Confession, slash). `runB14B()` re-pins 6; `runB15A()` re-pins 6 for B15-A and 6 for B16-B; `runB17C()` re-pins 6; `runB18A()` re-pins 6; `runB21D()` re-pins 6; `runB23D()` re-pins the same six. Reviewer probe: Console / Popes / Sender / Sound / Hud / UI / DB / Gora / Codec / slash stay nil after load. Wrap is load-time only (unchanged).

**Trim / empty omit — Pass.** Both unit-name reads are still pcalled. Target is still type-guarded and trimmed before `Names.Same`. Dest-same still omits first. Fail-closed `not pok` or non-string still returns before `:gsub` (a failed `pcall` stores error text in `playerName`). Then the player string is trimmed the same way as the target. Empty after trim returns nil. Player-same still omits after a successful non-empty string. `Inputs:Petition` still starts from `{ characterId }` and adds `opponent` only when the helper returns a name. Dest stays `inputTarget`. Quiet never reaches the helper. Both the trim and the empty check are required: `Names.Key("")` / `"   "` is nil, so `Same` is false and a successful Chuckroast target would be named.

**Keep — Pass.** Unpadded Chuckroast + player `"Beefina"` still names opponent. Fail-closed stays. HEIGHT 72. TitleBar persist `ChurchOfBeefDB.ui.inputs`. ESC `ClearFocus` only. `SetMultiLine(true)`. Not on `UISpecialFrames`. No Pope lookup. No `TargetUnit`. No `Gora:Petition`. No `PlaySound`. No realm compare.

---

## Strengths

- The leftover B21-D named (empty / whitespace player strings skip fail-closed and name Chuckroast) is closed on the exclusive pair with two lines after fail-closed. Failed path cannot return the target name.
- Trim and empty-after-trim are both present. Trim-only would still name (`Same` is false when `Key` is nil). Empty-check-only would still name `"   "`.
- Existing B17-C / B18-A / B21-D pins were left in place. `runB23D` re-pins unpadded Chuckroast + successful Beefina, pcall fail, dest-same + successful player, missing `UnitName`, Quiet, ESC, TitleBar 12, HEIGHT 72, and the isolation six. The new block is nested so the Lua 5.1 200-local cap is not spent in the main chunk.
- Dest-same in this block uses a successful player read (not a throw), so dest-same is not hidden behind fail-closed.
- Writer-reported **756 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **No client `/reload`.** Live Anniversary `UnitName("player")` empty / whitespace is unproven. Brief asked the isolated suite. **POLISH:CANDIDATE** only.

### Nit

1. **`type(playerName) ~= "string"` after `:gsub` is dead.** Fail-closed already refuses a non-string, and `string.gsub` returns a string. The live `playerName == ""` half is the load-bearing check. Brief asked empty or non-string after trim; the extra type test is harmless.

2. **Click + empty player is unpinned.** Petition button still calls `Inputs:Petition`. Reviewer probe: click + `""` / `"   "` omit; dest stays Host; click + Beefina still names.

3. **Padded successful player / padded player-same are unpinned.** Reviewer probe: `"  Beefina  "` + Chuckroast still names; `"  Chuckroast  "` + Chuckroast omits after trim.

4. **Non-string pin is still `nil` only** (B21-D leftover). Reviewer probe: `false` / `123` / `{}` also omit.

5. **Writer-reported red `753 / 4` does not arithmetically become `756 / 0`.** A 756-assert suite with 4 reds would be **752 / 4**. The two behavior pins plus the new `playerName:gsub` source pin are the three that old fail-closed-only code would fail; generic `gsub("^%s+"` pins already existed. Reviewer did not revert to re-run red.

6. **`runB23D` does not re-pin `targetCalls`.** B17-C / B18-A / B21-D still do. Source still has no `TargetUnit`.

7. **Isolation wrap is load-only.** Twenty-four pins under the first `if standalone then`. Later blocks re-pin six keys. Brief said the wrap stays; it did.

8. **Exclusive-pair diff is not a vs-HEAD Inputs delta.** Both exclusive files are still `??` in this workspace. Packet is the B23-D-only guard + pins vs the pre-lane text. Report already says this.

9. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **756 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **756 passed, 0 failed.** Isolation wrap: **24**.

`petitionOpponent` trims `playerName` (`^%s+` / `%s+$`) like the target and omits opponent when the trimmed string is empty. `""` and `"   "` no longer name Chuckroast. Successful `"Beefina"` + `"Chuckroast"` still names. pcall fail, dest-same, and missing `UnitName` still omit. Whisper dest stays injected `inputTarget`. No Pope lookup. HEIGHT 72. ESC `ClearFocus`. Not on `UISpecialFrames`. `runB23D()` is nested in `runB21D()` / `runB18A()`. Isolation stays `wow_ui_stub` + Common + Runtime + Inputs. Isolated `lua tests/test_inputs.lua` **756 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
