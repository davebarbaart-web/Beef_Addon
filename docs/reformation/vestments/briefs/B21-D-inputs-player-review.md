Spec PASS

# B21-D — Petition omits opponent when the player name read fails (review)

**Quality:** Approved-with-nits

**Lane:** B21-D Petition omits opponent when the player name read fails
**Brief:** `docs/reformation/vestments/briefs/B21-D-inputs-player.md`
**Writer report:** `docs/reformation/vestments/briefs/B21-D-inputs-player-report.md`
**Diff:** `docs/reformation/vestments/briefs/B21-D-inputs-player.diff` (B21-D-only exclusive-pair packet; both exclusive files are still untracked vs HEAD and also carry earlier Inputs batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Inputs.lua` (`petitionOpponent` after dest-same), and `tests/test_inputs.lua` (`runB21D()` nested inside `runB18A()`, player-throw omit, unpadded Chuckroast + successful player still names, non-string omit, dest-same / player-same / missing `UnitName` / Quiet / ESC / TitleBar / isolation keep-pins); then ran `lua tests/test_inputs.lua` (**676 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: player pcall fail or non-string `playerName` omits opponent (fail-closed); successful player read still names Chuckroast; nest `runB21D()` in `runB18A()`; no Pope lookup. Bible §10.2 / §18.5 (a petition may name a desired opponent; congregation input never triggers public theater); Law 5 / §13.1 (whisper dest stays injected `inputTarget`); B17-C / B18-A leftover (`pok` false still returned a successful target name). Challenge law (B17-C) and trim (B18-A) stay. Isolation stays `wow_ui_stub` + Common + Runtime + Inputs. Did not mutate `Inputs.lua` or `test_inputs.lua`. Did not commit. Did not edit Net, Codec, Console, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Player pcall fail still names a successful target as opponent | **Pass. Verified.** Live guard is `if not pok or type(playerName) ~= "string" then return nil end` after dest-same. Pin: target `"Chuckroast"`, player throws, dest `"Host"` → `fields.opponent` nil; send still once; dest stays `"Host"`; keys stay `{ characterId }`. Reviewer probe: same; player throw + self-as-target `"Beefina"` (the B18-A leftover probe) also omits. |
| Non-string `playerName` still names opponent | **Pass. Verified.** Pin: player `nil` omits. Source pin names the combined `not pok or type(...) ~= "string"` line. Reviewer probe: `false` / `123` / `{}` also omit; field keys are `characterId` only. |
| Successful player read no longer names Chuckroast | **Pass. Verified.** Unpadded `"Chuckroast"` + player `"Beefina"` still sends `opponent = "Chuckroast"`. B18-A unpadded / padded Chuckroast pins still run above this block. Reviewer probe: two-return Anniversary `UnitName` (`"Chuckroast","Whitemane"` / `"Beefina","Whitemane"`) still names `"Chuckroast"`. |
| Dest-same / player-same / missing `UnitName` broken | **Pass. Verified.** Dest-same Host + player throw omits; player-same Beefina omits; missing `UnitName` omits and still sends. B17-C Host / Host-realm / Beefina / Beefina-realm pins still run above. Reviewer probe: dest-same + successful player also omits. |
| New main-chunk locals / Lua 5.1 200-local | **Pass.** Packet adds `local function runB21D()` inside `runB18A()` and calls it before the parent restores `UnitName`. No new main-chunk locals. Isolated suite loaded on Lua **5.1.5** with no `too many local variables`. |
| Pope lookup / `TargetUnit` / `PlaySound` / `Gora:Petition` | **Pass.** Source has none of those strings (`Popes` / `IsRegisteredPope` / `Data/Popes` included). `runB21D` spies `targetCalls == 0`, `sounds == 0`, `goraCalls == 0`. Whisper dest stays `inputTarget`. Reviewer probe: dest `"NotAPope"` stays; opponent is still `"Chuckroast"` when the player read succeeds. |
| HEIGHT grown / ESC Hides / Inputs listed on `UISpecialFrames` | **Pass. Verified.** Constants still `328, 72`. `runB21D` re-pins WIDTH / HEIGHT / TitleBar 12 / root no `OnDragStart` / ESC `ClearFocus` / no Hide / not listed. Source still `SetMultiLine(true)`, `db.inputs`, `SetHeight(12)`, confess box `TOP` / `-14`. |
| Isolated suite not exit 0 | **Pass. Verified.** 676 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Packet is two `diff --git` hunks (header comments; dest-same stay + fail-closed then player-same; nested `runB21D()`). Sibling dirt in this workspace is other lanes (Net / Codec / Console / Snapshot / TOC / bootstrap / `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Net / Codec / Console / glue; no commit | **Pass.** Named-risk check. |
| Isolation stays `wow_ui_stub` + Common + Runtime + Inputs | **Pass.** Three `dofile`s unchanged. First standalone wrap still **24** nil-module / no-slash pins. |
| Player pcall fail omits opponent (fail-closed) | **Pass.** Named-risk check. A throw no longer returns the target name. |
| Non-string `playerName` omits opponent | **Pass.** Named-risk check. |
| Unpadded Chuckroast + successful player read still names opponent | **Pass.** Named-risk check. |
| Target still trimmed (`^%s+` / `%s+$`); dest-same and player-same still omit; missing `UnitName` stays omit | **Pass.** Trim source pins stay. Dest-same / player-same / missing API pins stay. B18-A padded Chuckroast pin still names `"Chuckroast"` when the player read succeeds. |
| Nest in `runB18A()` (or `runB21D()` inside it); no new main-chunk locals | **Pass.** `runB21D()` is defined and called inside `runB18A()`. |
| Quiet / ESC / TitleBar / isolation wrap stay | **Pass.** Quiet Petition is false and does not send (player-throw stub still live). ESC `ClearFocus` only. TitleBar 12. `runB21D` re-pins Console / Popes / Sender / Sound / Hud / slash. |
| No Pope-name lookup; no `PlaySound`; no `TargetUnit`; no `Gora:Petition`; no realm compare | **Pass.** Named-risk check. `pcall` still keeps the first `UnitName` return only. |
| Challenge law (B17-C) and trim (B18-A) stay | **Pass.** Named-risk check. WIDTH 328 / HEIGHT 72 stay. Not on `UISpecialFrames`. |
| `lua tests/test_inputs.lua` exit 0 | **Pass.** **676 / 0.** |

Bible §10.2 / §18.5 hold on the exclusive pair: a petition may still carry a desired opponent name when both reads succeed; Inputs still only spies Net and does not open theater. Law 5 holds: whisper dest stays injected `inputTarget`. The B17-C / B18-A leftover (player throw fail-open) is closed. Law 4 holds: omit does not invent a kind or a rite.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Parked Console `namedOpponent` paint / desk `after()` double cue | **On contract.** Brief froze this exclusive pair. Console paint is a later batch. |
| No client `/reload`; live `UnitName("player")` throw / nil on Anniversary is unproven | **Not a miss.** Brief asked the isolated suite. **POLISH:CANDIDATE** is the ceiling. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. `run.lua` was not edited. |
| No chrome hint that a current target will be named | **On contract.** Brief froze stock Petition chrome and HEIGHT 72. No copy was asked. |
| Internal whitespace is not collapsed | **On contract.** Brief kept B18-A `^%s+` / `%s+$` only. |
| No realm compare | **On contract.** Brief forbade inventing one. `Names.Same` still folds dest / player spelling when the player read succeeds. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

B17-A / B17-B still own encode and Pope-side name → id. This lane only fail-closes the congregation helper. B21-INT glue is not required: `Inputs:Petition` already calls `petitionOpponent`.

---

## Isolation / fail-closed / keep

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + Inputs. No `dofile` of Net / Codec / Console / Gora / Popes / UI shell. First standalone wrap is still **24** nils (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Gora, Store, RecordsBook, Decree, DecreeBanner, Popes, Sound, FighterCard, Confession, slash). `runB14B()` re-pins 6; `runB15A()` re-pins 6 for B15-A and 6 for B16-B; `runB17C()` re-pins 6; `runB18A()` re-pins 6; `runB21D()` re-pins the same six. Reviewer probe: Console / Popes / Sender / Sound / Hud / UI / DB / Gora / Codec / slash stay nil after load. Wrap is load-time only (unchanged).

**Fail-closed — Pass.** Both unit-name reads are still pcalled. Target is still type-guarded and trimmed before `Names.Same`. Dest-same still omits first. Then `not pok` or non-string `playerName` returns nil. Player-same still omits after a successful string read. `Inputs:Petition` still starts from `{ characterId }` and adds `opponent` only when the helper returns a name. Dest stays `inputTarget`. Quiet never reaches the helper. The combined `not pok` check is required: a failed `pcall` yields an error string, so a type-only guard would still name Chuckroast.

**Keep — Pass.** Unpadded Chuckroast + player `"Beefina"` still names opponent. Trim `^%s+` / `%s+$` stays. HEIGHT 72. TitleBar persist `ChurchOfBeefDB.ui.inputs`. ESC `ClearFocus` only. `SetMultiLine(true)`. Not on `UISpecialFrames`. No Pope lookup. No `TargetUnit`. No `Gora:Petition`. No `PlaySound`. No realm compare.

---

## Strengths

- The leftover B18-A named (player throw fail-open) is closed on the exclusive pair with two lines after dest-same. Failed path cannot return the target name.
- The guard is `not pok or type(playerName) ~= "string"`, not type alone. A failed `pcall` stores the error text in `playerName`; without `not pok` that string would pass `Names.Same` and name Chuckroast.
- Existing B17-C / B18-A pins were left in place. `runB21D` re-pins unpadded Chuckroast + successful player, dest-same, player-same, missing `UnitName`, Quiet, ESC, TitleBar 12, HEIGHT 72, and the isolation six. The new block is nested so the Lua 5.1 200-local cap is not spent in the main chunk.
- Writer-reported **676 / 0** matched the re-run. Writer-reported red **673 / 3** is consistent with the three pins old `if pok and Names.Same` would fail (player-throw omit; non-string omit; fail-closed source pin). Reviewer did not revert to re-run red.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **No client `/reload`.** Live Anniversary `UnitName("player")` throw / nil is unproven. Brief asked the isolated suite. **POLISH:CANDIDATE** only.

### Nit

1. **Dest-same pin in `runB21D` uses a player throw.** Fail-closed would omit Host even if the dest-same line were removed. Dest-same + successful player is already pinned in B17-C / B18-A. Reviewer probe: dest-same + successful player still omits.

2. **Empty / whitespace player strings still name opponent.** `""` and `"   "` are strings, so they skip fail-closed; `Names.Key` is nil and `Same` is false. Brief asked pcall fail or non-string only. Live `UnitName("player")` is not expected to return those.

3. **Non-string pin is `nil` only.** Reviewer probe: `false` / `123` / `{}` also omit.

4. **Click + player throw is unpinned.** Petition button still calls `Inputs:Petition`. Reviewer probe: click omits and dest stays Host.

5. **Isolation wrap is load-only.** Twenty-four pins under the first `if standalone then`. Later blocks re-pin six keys. Brief said the wrap stays; it did.

6. **Exclusive-pair diff is not a vs-HEAD Inputs delta.** Both exclusive files are still `??` in this workspace. Packet is the B21-D-only guard + pins vs the pre-lane text. Report already says this.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **676 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **676 passed, 0 failed.** Isolation wrap: **24**.

`petitionOpponent` fail-closes when the player pcall fails or `playerName` is not a string. A successful player read still names unpadded Chuckroast. Dest-same, player-same, and missing `UnitName` still omit. Target still trims. Whisper dest stays injected `inputTarget`. No Pope lookup. HEIGHT 72. ESC `ClearFocus`. Not on `UISpecialFrames`. `runB21D()` is nested in `runB18A()`. Isolation stays `wow_ui_stub` + Common + Runtime + Inputs. Isolated `lua tests/test_inputs.lua` **676 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
