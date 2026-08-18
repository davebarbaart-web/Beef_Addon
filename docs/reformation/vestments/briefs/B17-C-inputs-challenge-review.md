Spec PASS

# B17-C — Inputs Petition may name the current target (review)

**Quality:** Approved-with-nits

**Lane:** B17-C Inputs Petition may name the current target
**Brief:** `docs/reformation/vestments/briefs/B17-C-inputs-challenge.md`
**Writer report:** `docs/reformation/vestments/briefs/B17-C-inputs-challenge-report.md`
**Diff:** `docs/reformation/vestments/briefs/B17-C-inputs-challenge.diff` (B17-C-only exclusive-pair packet; both exclusive files are still untracked vs HEAD and also carry earlier Inputs batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Inputs.lua` (`petitionOpponent` + `Inputs:Petition` after `readyToSend`), and `tests/test_inputs.lua` (existing unset-target spy, nested `runB17C()`, Quiet / TitleBar / ESC / isolation keep-pins); then ran `lua tests/test_inputs.lua` (**505 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §10.2 / §18.5 (a petition may name a desired opponent; congregation input never triggers public theater); Law 5 / §13.1 (whisper dest stays injected `inputTarget`); opponent from `pcall(UnitName, "target")` when `Names.Same` is false vs dest and vs `pcall(UnitName, "player")`; existing nil-target petitions stay opponent-less; no Pope lookup; WIDTH 328 / HEIGHT 72; ESC `ClearFocus`; not `UISpecialFrames`. Isolation stays `wow_ui_stub` + Common + Runtime + Inputs. Did not mutate `Inputs.lua` or `test_inputs.lua`. Did not commit. Did not edit Net, Codec, Console, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Third-party `UnitName("target")` never reaches `SendPetition` | **Pass. Verified.** Stub `"Chuckroast"` vs dest `"Host"` / player `"Beefina"` sends `opponent = "Chuckroast"` and `target = "Host"`. Fields keys are exactly `characterId,opponent`. Petition click uses the same helper. Reviewer probe: same. |
| Opponent attached when target is the whisper dest or the local player | **Pass. Verified.** Pins: `"Host"` and `"Host-Whitemane"` omit; `"Beefina"` and `"Beefina-Whitemane"` omit; dest stays `"Host"`. Reviewer probe: case-fold `"host"` / `"beefina"` also omit (`Names.Same`). |
| Existing nil-target petitions now name an opponent | **Pass. Verified.** Stub `UnitName("target")` is still nil. Existing Event spy stays `fields.opponent == nil` (message only changed). `runB17C` re-pins unset stub: keys `{ characterId }` only. Reviewer probe: same. |
| Whisper dest drifts off injected `inputTarget` / Pope-name lookup | **Pass. Verified.** `SendPetition(fields, inputTarget)` unchanged. Source has no `Popes` / `IsRegisteredPope` / `Data/Popes`. Reviewer probe: dest `"NotAPope"` stays; opponent is still `"Chuckroast"`. |
| Bare `UnitName` throws; missing API names an opponent | **Pass. Verified.** Both reads are `pcall`ed. `type(UnitName) ~= "function"` returns nil. Pins: missing / throwing / empty omit and still send. Reviewer probe: non-string `123` omits; missing `Names.Same` omits (extra fail-closed). |
| HEIGHT grown / ESC Hides / Inputs listed on `UISpecialFrames` | **Pass. Verified.** Constants still `328, 72`. `runB17C` re-pins WIDTH / HEIGHT / TitleBar / root no `OnDragStart` / ESC `ClearFocus` / no Hide / not listed. Source still `SetMultiLine(true)` and no `UISpecialFrames`. Reviewer probe: same; `#UISpecialFrames == 0`. |
| `PlaySound` / `Gora:Petition` / `TargetUnit` / `SendChatMessage` | **Pass.** Source has none of those strings. `runB17C` spies `targetCalls == 0`, `sounds == 0`, `goraCalls == 0`. Suite end still `#stub.chat == 0`. |
| Isolated suite not exit 0 | **Pass. Verified.** 505 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Packet is two `diff --git` hunks (`petitionOpponent` + fields table; existing spy message + nested `runB17C()`). Sibling dirt in this workspace is other lanes (Codec / BeefNet / Console / Snapshot / TOC / bootstrap / `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Net / Codec / Console / glue; no commit | **Pass.** Named-risk check. |
| Isolation stays `wow_ui_stub` + Common + Runtime + Inputs | **Pass.** Three `dofile`s unchanged. First standalone wrap still **24** nil-module / no-slash pins. |
| Ready-to-send unchanged (Event, `inputTarget`, local character id) | **Pass.** `petitionOpponent` runs only after `readyToSend` and the Net guard. Quiet / missing dest / missing id still refuse and do not send. |
| `pcall(UnitName, "target")` and `pcall(UnitName, "player")` | **Pass.** Source pins both call sites. Helper always pcalls both when `UnitName` is a function. |
| Non-empty target name and `Names.Same` false vs dest and vs player → `opponent = name` | **Pass.** Named-risk check. Two-return `UnitName` uses the first value (`"Chuckroast"`, `"Whitemane"` → `"Chuckroast"`). |
| Otherwise `{ characterId = localCharacterId }` only | **Pass.** Unset / dest-same / player-same / missing / throw / empty omit. Reviewer probe: field keys are `characterId` only on omit. |
| Existing unset-target spies stay opponent-less | **Pass.** Named-risk check. |
| No Pope-name lookup; no `TargetUnit`; no `SendChatMessage`; no `PlaySound`; no `Gora:Petition` | **Pass.** Named-risk check. |
| WIDTH 328 HEIGHT 72; TitleBar persist `ui.inputs`; ESC `ClearFocus`; `SetMultiLine(true)`; not `UISpecialFrames` | **Pass.** Named-risk check. Persist key `db.inputs` is source-re-pinned. |
| Quiet / TitleBar / ESC / isolation wrap stay | **Pass.** `runB17C` re-pins all four. End wrap still Console / Popes / Sender / Sound / Hud / slash. |
| `lua tests/test_inputs.lua` exit 0 | **Pass.** **505 / 0.** |

Bible §10.2 / §18.5 hold on the exclusive pair: a petition may carry a desired opponent name; Inputs still only spies Net and does not open theater. Law 5 holds: whisper dest stays injected `inputTarget`. Missing `UnitName` stays fail-closed.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; live `UnitName("target")` (no target, dead, nameplate-only) is unproven | **Not a miss.** Brief asked the isolated suite. **POLISH:CANDIDATE** is the ceiling. |
| No chrome hint that a current target will be named | **On contract.** Brief froze stock Petition chrome and HEIGHT 72. No copy was asked. |
| Whitespace-only target names are treated as candidates; Codec (B17-A) may drop them on the wire | **Leftover — not a miss.** Brief said non-empty string. `"   "` is non-empty. See leftover. |
| Confess box / TitleBar overlap from B16-B is unchanged | **Leftover — not a miss.** Brief froze HEIGHT 72 again and did not ask to move the box. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

B17-A / B17-B already own encode and Pope-side name → id. This lane only forwards a name on the congregation `SendPetition` fields table. B17-INT glue is not required.

---

## Isolation / opponent / keep

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + Inputs. No `dofile` of Net / Codec / Console / Gora / Popes / UI shell. First standalone wrap is still **24** nils (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Gora, Store, RecordsBook, Decree, DecreeBanner, Popes, Sound, FighterCard, Confession, slash). `runB14B()` re-pins 6; `runB15A()` re-pins 6 for B15-A and 6 for B16-B; `runB17C()` re-pins the same six. Reviewer probe: Console / Popes / Sender / Sound / Hud / UI / DB / Gora / Codec / slash stay nil after load. Wrap is load-time only (unchanged).

**Opponent — Pass.** `petitionOpponent` type-guards `UnitName`, pcalls `"target"` and `"player"`, requires `COB.Names.Same`, then omits when dest-same or (successful player read and player-same). `Inputs:Petition` starts from `{ characterId }` and adds `opponent` only when the helper returns a name. Dest stays `inputTarget`. Quiet never reaches the helper.

**Keep — Pass.** HEIGHT 72. TitleBar persist. ESC `ClearFocus` only. Not on `UISpecialFrames`. Existing unset-target spy stays opponent-less. No Pope lookup. No `TargetUnit`. No `Gora:Petition`. No `PlaySound`.

---

## Strengths

- The helper is fail-closed on the API: missing `UnitName`, failed target pcall, non-string / empty name, and missing `Names.Same` all omit and still send `{ characterId }`.
- Dest and self are folded through `Names.Same`, so realm suffixes and case do not leak the Pope whisper dest or the local player onto `opponent`.
- Existing Event spy was rewritten to “unset stub omits,” not deleted. The new Chuckroast / Host / player pins sit in a nested `runB17C()` so the Lua 5.1 200-local cap is not spent in the main chunk.
- Chrome was not grown. WIDTH / HEIGHT / TitleBar / ESC / not-`UISpecialFrames` / isolation wrap were re-pinned in the same block as the new field.
- Writer-reported **505 / 0** matched the re-run. Writer-reported red **500 / 5** is consistent with the five new pins that old omit-always `Petition` would fail (two Chuckroast field asserts + three source `pcall` / `Names.Same` pins). Reviewer did not revert to re-run red.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Whitespace-only and padded `UnitName` strings are forwarded as `opponent`.** Reviewer probe: `"   "` and `"  Chuckroast  "` reach `SendPetition`. Brief called any non-empty string a candidate. B17-A Codec trims and omits whitespace-only on the wire; BeefNet copies any non-empty string into the encode body. Out of this exclusive pair.

2. **Confess box still occludes 4px of the 12px TitleBar in the center.** Box stays `TOP` / `-8` / height 22. Brief froze HEIGHT 72 and did not ask to move it. Inherited B16-B leftover.

### Nit

1. **Player read fail-open.** If `UnitName("player")` throws, `pok` is false and a successful target name is still returned. If player returns nil, `Names.Same(target, nil)` is false and a self-target is named (`"Beefina"`). Live `UnitName("player")` is not expected to fail. Brief’s dest/self omit still holds when both reads succeed.

2. **Helper extra-requires `COB.Names.Same`.** Brief assumed the compare. Isolation and TOC already load Common. Missing Same omits a valid third-party name — fail-closed extra, not a miss.

3. **Isolation wrap is load-only.** Twenty-four pins under the first `if standalone then`. Later blocks re-pin six keys. Brief said the wrap stays; it did.

4. **Exclusive-pair diff is not a vs-HEAD Inputs delta.** Both exclusive files are still `??` in this workspace. Packet is the B17-C-only helper + pins vs the pre-lane text. Report already says this.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **505 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **505 passed, 0 failed.** Isolation wrap: **24**.

`Inputs:Petition` may pass `opponent` from `pcall(UnitName, "target")` when that name is a non-empty string and `Names.Same` is false versus injected `inputTarget` and versus `pcall(UnitName, "player")`. Otherwise the fields table is `{ characterId }` only. Existing nil-target petitions stay opponent-less. Both reads are pcalled. Missing `UnitName` omits. Whisper dest stays `inputTarget`. No Pope lookup. HEIGHT 72. ESC `ClearFocus` only. Not on `UISpecialFrames`. Isolation stays `wow_ui_stub` + Common + Runtime + Inputs. Isolated `lua tests/test_inputs.lua` **505 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
