Spec PASS

# B37-D — Quiet Hide blanks leftover confess text (review)

**Quality:** Approved-with-nits

**Lane:** B37-D Quiet Hide blanks leftover confess text
**Brief:** `docs/reformation/vestments/briefs/B37-D-confess-wipe.md`
**Writer report:** `docs/reformation/vestments/briefs/B37-D-confess-wipe-report.md`
**Diff:** `docs/reformation/vestments/briefs/B37-D-confess-wipe.diff` (B37-D-only exclusive-pair packet; live `Inputs.lua` / `test_inputs.lua` also carry earlier Inputs batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Inputs.lua` (`paintHidden` ~82–89, `Hide` ~370–373, `Confess` GetText ~311–318, `readyToSend` / `Init` / `Refresh` / `Show` callers, `inputTarget` upvalue, WIDTH / HEIGHT / ESC ClearFocus), and `tests/test_inputs.lua` (isolation wrap, nested `runB37D()` after `runB35B()` inside `runB21D()` / `runB18A()`); then ran `lua tests/test_inputs.lua` (**995 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §13.4 / §9 leftover player-typed confession text. Anniversary `EditBox:SetText(text)` (SimpleEditBoxAPI, `cstring`). `paintHidden` previously only `frame:Hide()`. `Confess` still reads `confessBox:GetText()` when no string arg. Only `ResetForTests` used to blank the box. Quiet Hide then a new Event `Show` + `Confess()` would send leftover text. Dest persist stays. No Pope lookup. Exclusive files only. No commit. Lane is not signed. Did not mutate `Inputs.lua` or `test_inputs.lua`. Did not edit BeefNet, Confession, glue, TOC, bootstrap, `ChurchOfBeef.lua`, OPEN_QUESTIONS, REFORMATION_LOG, or `tests/run.lua`.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Quiet Hide still leaves `"leftover line"` on `confessBox`; new Event `Show` + `Confess()` re-sends it | **Pass. Verified.** Live `paintHidden` type-guards `confessBox:SetText("")` then `frame:Hide()`. Nested: leftover is `""` after Quiet Hide and after new Event Show; `Confess()` without arg omits leftover (`fields.text` nil / empty) and still sends. Reviewer probe: same omit (`text` nil) after mid-Event `Hide` + `Show`. |
| Dest / `inputTarget` cleared on wipe | **Pass. Verified.** `paintHidden` does not name `inputTarget`. Nested: view dest stays `"Host"` after Quiet Hide and after new Event Show; `Confess()` whispers `"Host"`. Reviewer probe: dest stays `"Host"` after mid-Event Hide, Quiet `Refresh`, and Quiet `Confess` (`readyToSend` → `paintHidden`). |
| Fan-out: `Hide` / `Confess` / dest / ESC / WIDTH rewritten | **Pass.** Packet is header comments + `paintHidden` wipe. Live `Hide` still only calls `paintHidden()`. `Confess` still reads `GetText()` when no string arg (B35-B trim stays). ESC still `ClearFocus` and does not Hide. WIDTH 328 / HEIGHT 72 stay. Nested keep pins. |
| Pope-name lookup / `Popes` / `IsRegisteredPope` / `TargetUnit` / sound | **Pass.** Live `Inputs.lua` has no `Popes`, `IsRegisteredPope`, `TargetUnit`, `PlaySound`. Nested source + wrap pins. `Confess` still calls `SendConfession(fields, inputTarget)` once. |
| Tests not nested after `runB35B()` inside `runB21D()` / new main-chunk locals / isolation wrap rewritten | **Pass.** `runB37D()` is a nested `local function` inside `runB21D()` after `runB35B()` / `runB18A()`. Packet adds no main-chunk `local`. Isolation wrap stays **23** under the first `if standalone then`. |
| Isolated suite not exit 0 / exclusive breach | **Pass. Verified.** 995 passed, 0 failed. Writer-reported count matches. Packet is the two named files. Sibling dirt (BeefNet, Confession, glue, TOC, bootstrap) is other lanes, not this packet. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit BeefNet, Confession, glue; no commit; no Pope lookup | **Pass.** Named-risk check. Reviewer did not commit. |
| `paintHidden` blanks `confessBox` (`SetText("")` if present) | **Pass.** Live body + scoped source pin + nested `GetText() == ""` after Quiet Hide. |
| Dest / `inputTarget` persist | **Pass.** Named-risk check. |
| Width / ESC ClearFocus stay | **Pass.** Nested WIDTH 328 / HEIGHT 72 / ESC ClearFocus / ESC does not Hide. |
| No fan-out | **Pass.** Wipe lives in `paintHidden`. `Hide` still only calls that function. |
| Nest `runB37D()` after `runB35B()` inside `runB21D()`. Type leftover, Quiet Hide (or `paintHidden` via Hide), box is `""`. New Event Show + `Confess()` without a new arg omits leftover (nil / empty). Dest stays. Isolation wrap stays. No new main-chunk locals | **Pass.** Nested block. |
| `lua tests/test_inputs.lua` exit 0 | **Pass.** **995 / 0.** |

Bible §13.4 / §9 hold on the exclusive pair: confession text is player-typed free text for the Pope console. Quiet Hide blanks the leftover so a later Event `Confess()` does not re-send it. Dest persist is the injected whisper target, not leftover free text. Inputs still does not look up a Pope and does not fan-out. Law 5 holds: congregation Confess remains dest-injected. Law 4 holds: `SetText("")` is not narration. Law 6 holds: Quiet Hide dismisses the Event widget; leftover typed text does not remain on the hidden box. Law 7 is not in play: wiping an unsent EditBox draft is not Church-history deletion.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client / two-client smoke; leftover wipe unproven on Anniversary `EditBox:SetText` | **Not a miss.** Brief asked the isolated suite. wow-api `classic_anniversary` SimpleEditBoxAPI is `SetText(text)` (`cstring`). Empty string is valid. Client `/reload` was not required. |
| `paintHidden` is shared: Quiet `Init` / `Refresh` / `Show` / `readyToSend` also wipe | **On contract.** Brief named `paintHidden`, not `Hide`-only. Those callers already went through that function. Reviewer probe: Quiet `Refresh` and Quiet `Confess` (`readyToSend`) wipe and keep dest `"Host"`. Isolated `EndEvent` alone does not wipe until `paintHidden` runs. |
| `ResetForTests` still blanks the box (duplicate hatch) | **On contract.** Brief left the hatch alone. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / dest / leftover

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + Inputs. No `dofile` of Net, glue, Console, Popes, Confession, or BeefNet. Standalone wrap is still **23** nils (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Gora, Store, RecordsBook, Decree, DecreeBanner, Popes, Sound, FighterCard, Confession). Wrap was not rewritten. Nested B37-D re-pins Console / Popes / Sender / Sound / Hud plus slash.

**Leftover wipe — Pass.** `paintHidden` blanks `confessBox` when the box and `SetText` exist, then hides the frame. Nested leftover `"leftover line"` is `""` after Quiet Hide and after new Event Show. `Confess()` without arg still sends; `fields.text` is nil / empty, not `"leftover line"`. Reviewer probe: mid-Event `Hide` also wipes; `Confess()` after `Show` omits (`text` nil).

**Dest — Pass.** `inputTarget` is unchanged by `paintHidden`. Nested dest stays `"Host"` across Quiet Hide, new Event Show, and the follow-up `Confess()`. Reviewer probe: dest stays `"Host"` on Quiet `Refresh` and on Quiet `Confess` refuse.

---

## Strengths

- The delta is the brief: one `paintHidden` `SetText("")`. `Hide` / `Confess` / dest / ESC / WIDTH were left alone.
- The named hole (Quiet Hide then new Event `Show` + `Confess()` re-sends leftover) is closed on the same Host / characterId-7 fixture. Dest persist sits next to the wipe, so a blanket `ResetForTests`-style clear would fail.
- Missing `confessBox` / `SetText` is a no-op. `Hide` still only calls `paintHidden`.
- `runB37D()` sits after `runB35B()` inside `runB21D()` / `runB18A()`. Isolation wrap stays **23**. No new main-chunk locals. Writer-reported **995 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

None that this exclusive can close. Isolated `EndEvent` does not wipe leftover until `paintHidden` (Quiet Hide / `Refresh` / `readyToSend`). Client Quiet path must still call one of those (glue forbidden). Do not expand this pair.

### Nit

1. **`Confess()` leftover pin allows `nil` or `""`.** Live B35-B trim omits (`nil`). Reviewer probe: omit is `nil`. A send of `fields.text = ""` would still pass.

2. **`SetText("")` is source-pinned inside `paintHidden` plus a runtime `GetText` pin.** A comment token in that body would still pass the find; the `GetText() == ""` pin is the real contract.

3. **`runB37D()` re-pins WIDTH / HEIGHT / TitleBar / ESC / isolation already covered above the nest.** Brief said those stay. They still pass earlier in the same `runB21D()` nest.

4. **Shared `paintHidden` wipe is wider than “Quiet Hide”.** Mid-Event `Hide`, Quiet `Refresh`, and Quiet `Confess` also blank the box. Brief put the wipe on `paintHidden`. Reviewer probed those paths; dest persists.

5. **Exclusive-pair diff is not a vs-HEAD Inputs delta.** Packet is the B37-D-only `paintHidden` wipe + nested pins. Report already says this. Sibling dirt is other lanes.

6. **No `/reload` / two-client leftover-typed-text smoke and no full `lua tests/run.lua`.** Isolated **995 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: `paintHidden` blanks `confessBox` (`SetText("")` if present); dest / `inputTarget` persist; Width / ESC stay; no fan-out. Live `Inputs.lua` ~82–89 matches. Brief test pins sit in `runB37D()` after `runB35B()` inside `runB21D()`.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftover: isolated `EndEvent` does not wipe until `paintHidden` (glue forbidden). Nits listed above.

**3. Isolation count:** **995 passed, 0 failed.** Isolation wrap: **23**.

**4. Law:** Bible §13.4 / §9 hold. Leftover player-typed confession text is blanked on Quiet Hide and is not re-sent. Dest persist is the injected whisper target. No Pope-name lookup. Law 4 / Law 5 / Law 6 hold. wow-api `classic_anniversary`: SimpleEditBoxAPI `SetText(text)` (`cstring`).

`paintHidden` blanks leftover via `SetText("")`. Dest stays `"Host"`. New Event `Show` + `Confess()` without a new arg omits leftover. Isolated `lua tests/test_inputs.lua` **995 passed, 0 failed**, exit 0.

Leftovers: shared `paintHidden` wipe (on contract); isolated `EndEvent` alone does not wipe; `Confess()` pin allows `""`; no client smoke; full harness not run.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
