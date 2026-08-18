Spec PASS

# B35-B — Confess trims optional text (review)

**Quality:** Approved-with-nits

**Lane:** B35-B Confess trims optional text
**Brief:** `docs/reformation/vestments/briefs/B35-B-confess-trim.md`
**Writer report:** `docs/reformation/vestments/briefs/B35-B-confess-trim-report.md`
**Diff:** `docs/reformation/vestments/briefs/B35-B-confess-trim.diff` (B35-B-only exclusive-pair packet; live `Inputs.lua` / `test_inputs.lua` also carry earlier Inputs batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Inputs.lua` (`Confess` ~305–331 / `readyToSend` / `SetInputTarget` / `petitionOpponent` gsub trim / Catchup dest check), and `tests/test_inputs.lua` (isolation wrap, existing dest / opponent pins, nested `runB35B()` after `runB33A()` inside `runB21D()` / `runB18A()`); then ran `lua tests/test_inputs.lua` (**937 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §13.4 / §9 (confession text is optional player-typed free text for the Pope console). B33-A leftover: `SetInputTarget` already `Names.Trim`s dest; `Confess` assigned `fields.text` raw, so `"  forgive me  "` went on the whisper. Text trim (`Names.Trim`, fallback `^%s+` / `%s+$`); empty after trim omits `fields.text` and still sends. Dest / `readyToSend` stay. Opponent trim stays. No Pope-name lookup. No auto snapshot. No fan-out. Did not mutate `Inputs.lua` or `test_inputs.lua`. Did not commit. Did not edit BeefNet, Confession, Codec, glue, TOC, bootstrap, `ChurchOfBeef.lua`, OPEN_QUESTIONS, REFORMATION_LOG, or `tests/run.lua`.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Confess` still assigns raw padded text (`"  forgive me  "` on the whisper) | **Pass. Verified.** Live body prefers `COB.Names.Trim`, else `gsub("^%s+", "")` / `gsub("%s+$", "")` and nils `""`. Nested: `Confess("  forgive me  ")` spies `"forgive me"`; box `"  typed in the box  "` spies `"typed in the box"`; unpadded `"forgive me"` stays. Reviewer probe: `Names.Trim` is invoked on the text; `"  forgive  me  "` keeps the inner space; `"  forgive-me  "` stays hyphenated (`Display` would strip to `"forgive"`; Display call count 0). |
| Empty after trim still sets `fields.text` or refuses the send | **Pass. Verified.** Nested: `Confess("   ")` and box-only `"   "` omit `fields.text`, return true, spy once, dest `"Host"`, `characterId` 7. Reviewer probe: `Confess("")` and `"\t\n  \r"` omit and still send. `readyToSend` still does not inspect text. |
| Dest path rewritten; whitespace dest now sends; dest re-trimmed inside `Confess` | **Pass.** Packet is header comments + `Confess` trim. Live `SetInputTarget` / `readyToSend` / Catchup dest check unchanged. Nested: padded dest still stores / whispers `"Host"`; `"   "` dest is `false, "no target"` and spy count 0. Reviewer probe: same refuse after a successful padded send. |
| Opponent / player trim rewritten or dropped | **Pass.** Live `petitionOpponent` still `targetName` / `playerName` `gsub("^%s+", ""):gsub("%s+$", "")`. Nested keep pins: whitespace opponent omits; padded Chuckroast names; dest-same Host omits; whitespace player omits. Dest stays `"Host"`. |
| Pope-name lookup / `Popes` / `IsRegisteredPope` / `TargetUnit` / fan-out | **Pass.** Live `Inputs.lua` has no `Popes`, `IsRegisteredPope`, `TargetUnit`, `LookupPope`, `FindPope`, `SendChatMessage`, or `SendAddonMessage`. `Confess` calls `SendConfession(fields, inputTarget)` once. Nested source + wrap pins. Reviewer probe: snapshot spy stays 0 across Confess; one whisper dest; no Display. |
| Auto snapshot / `readyToSend` / Catchup rewritten | **Pass.** `RequestSnapshot` remains Catchup-only. `readyToSend` still Event + dest + characterId. Catchup still has its own empty-dest check. No `RequestSnapshot` inside `Confess`. |
| `Names.Display` / `Names.Key` / invented realm compare on free text | **Pass. Verified.** Confess path names `Names.Trim` only. Reviewer probe: Display is not called; hyphenated text is not realm-stripped. |
| New main-chunk locals / not nested after `runB33A()` inside `runB21D()` / isolation wrap rewritten | **Pass.** `runB35B()` is a nested `local function` inside `runB21D()` after `runB33A()` / `runB18A()`. Packet adds no main-chunk `local`. Isolation wrap stays **23** under the first `if standalone then`. |
| Isolated suite not exit 0 / exclusive breach | **Pass. Verified.** 937 passed, 0 failed. Writer-reported count matches. Packet is the two named files. Sibling dirt (BeefNet, Confession, Codec, glue, TOC, bootstrap) is other lanes, not this packet. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit BeefNet, Confession, Codec, glue; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| `Confess` trims text (`Names.Trim`, fallback `^%s+` / `%s+$`) | **Pass.** Live body + source pin + reviewer Trim wrap / fallback probes. |
| Empty after trim omits `fields.text` and still sends | **Pass.** Nested `"   "` / box-only whitespace + reviewer `""` / tab-newline probes. |
| Dest path stays; `readyToSend` stays | **Pass.** Named-risk check. |
| Opponent trim stays | **Pass.** Named-risk check. |
| No Pope-name lookup | **Pass.** Named-risk check. |
| No auto snapshot; no fan-out | **Pass.** Named-risk check. |
| Nest `runB35B()` after `runB33A()` inside `runB21D()`; `Confess("  forgive me  ")` spies `"forgive me"`; `Confess("   ")` / box-only whitespace omit `fields.text` and still send when dest is set | **Pass.** Nested block. |
| Existing dest / opponent pins stay; isolation wrap stays; no new main-chunk locals | **Pass.** Keep pins re-run inside `runB35B()`. Wrap **23**. |
| `lua tests/test_inputs.lua` exit 0 | **Pass.** **937 / 0.** |

Bible §13.4 / §9 hold on the exclusive pair: confession text is optional player-typed free text for the Pope console. Trim does not invent copy. Empty after trim omits `fields.text` and the whisper still goes to the injected dest. Inputs still does not look up a Pope and does not fan-out. Law 5 holds: congregation Confess remains dest-injected, not self-authoritative. Law 4 holds: software does not narrate. Law 6 holds: Quiet still refuses and does not send. Opponent / player identity trim stays on `petitionOpponent`; text trim did not replace it.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client / two-client smoke; padded or whitespace confession text unproven on Anniversary | **Not a miss.** Brief asked the isolated suite. Text trim is Event Mode whisper. |
| Fallback path is source-only; isolated suite always loads Common | **On contract as a leftover.** Brief required the fallback in `Confess`. Reviewer probe (Trim nil / `Names` nil) trims, omits empty, and still sends. Suite does not pin that runtime. |
| Trim block is copied (`SetInputTarget` and `Confess` each own a `Names.Trim` / fallback pair) | **On contract.** Brief asked for the same pattern. No shared helper was required. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

BeefNet already treats confession text as optional (`SendConfession` comment + encode). That sibling is compatible with omit-and-send. Brief forbade BeefNet / Codec edits. Not a miss.

---

## Isolation / dest / text

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + Inputs. No `dofile` of Net, glue, Console, Popes, Confession, or BeefNet. Standalone wrap is still **23** nils (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Gora, Store, RecordsBook, Decree, DecreeBanner, Popes, Sound, FighterCard, Confession). Reviewer probe: `COB.Popes` is nil at load. Wrap was not rewritten. Nested B35-B re-pins Console / Popes / Sender / Sound / Hud plus slash.

**Text trim — Pass.** `Confess` assigns `fields.text` only when `Names.Trim` (or the matching fallback) returns a string. Empty after trim is nil and the field is omitted. `readyToSend` still decides whether the whisper goes. Nested `"  forgive me  "` spies `"forgive me"`; `"   "` / box-only whitespace omit and still send when dest is `"Host"`. Reviewer probe: `""` / tab-newline pad omit and send; inner space and hyphen stay; Display is not used.

**Dest / opponent — Pass.** `SetInputTarget` still trims dest. Empty dest is no target before text is read. `Confess` still whispers `inputTarget` once. `petitionOpponent` still trims with `gsub`, then `Names.Same` versus dest and player. Nested dest / opponent keep pins still pass.

---

## Strengths

- The delta is the brief: one `Confess` trim. `readyToSend`, `SetInputTarget`, Catchup, Petition, and opponent `gsub` were left alone.
- B33-A leftover (padded confession text on the whisper; whitespace text still set `fields.text`) is closed on the same Host fixture. Omit-and-send sits next to dest refuse, so a blanket nil or a new text-required refuse would fail.
- `Names.Trim` is the existing Common helper. Fallback matches that helper. Free text does not call `Display` / `Key`, so a hyphen in a confession is not treated as a realm.
- `runB35B()` sits after `runB33A()` inside `runB21D()` / `runB18A()`. Isolation wrap stays **23**. No new main-chunk locals. Writer-reported **937 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

None that this exclusive can close. Glue still injects dest (B33-A leftover; brief forbade Pope lookup and glue edits). Do not expand this pair.

### Nit

1. **Fallback `gsub` is source-pinned, not suite-exercised.** Isolated load always has Common. Reviewer probe (Trim nil / `Names` nil) matches `Names.Trim`. A comment token would still pass the `Names.Trim` / `gsub` finds.

2. **Tabs / newlines / empty string / inner spaces / hyphen text are not pinned.** Reviewer probe: `%s` pad omits and sends; `"forgive  me"` keeps the inner space; `"forgive-me"` is not Display-stripped.

3. **`runB35B()` re-pins dest / opponent trim already covered by B33-A / B23-D.** Brief said those pins stay. They still pass earlier in the same `runB21D()` nest.

4. **`SetInputTarget` and `Confess` each copy the `Names.Trim` / fallback pair.** Brief asked for the same pattern. No shared helper.

5. **Exclusive-pair diff is not a vs-HEAD Inputs delta.** Packet is the B35-B-only `Confess` trim + nested pins. Report already says this. Sibling dirt is other lanes.

6. **No `/reload` / two-client padded-or-whitespace confession smoke and no full `lua tests/run.lua`.** Isolated **937 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **937 passed, 0 failed.** Isolation wrap: **23**.

`Confess` trims via `Names.Trim` (fallback `^%s+` / `%s+$`). Empty after trim omits `fields.text` and still sends when dest is set. `"  forgive me  "` spies `"forgive me"`. `"   "` / box-only whitespace omit and still whisper `"Host"`. Dest / `readyToSend` stay. Opponent / player `gsub` trim stay. No Pope lookup. No fan-out. No `Names.Display` on free text. Isolated `lua tests/test_inputs.lua` **937 passed, 0 failed**, exit 0.

Leftovers: fallback is source-pinned (reviewer probe agrees); dest injection stays in glue (not this exclusive); no client smoke; full harness not run.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.
