Spec PASS

# B5-D — Theater toast display face (review)

**Quality:** Approved-with-nits

**Lane:** B5-D Theater toast display face
**Brief:** `docs/reformation/vestments/briefs/B5-D-toast-face.md`
**API note:** `docs/reformation/vestments/briefs/V-stock-textures.md`
**Writer report:** `docs/reformation/vestments/briefs/B5-D-toast-face-report.md`
**Diff:** `docs/reformation/vestments/briefs/B5-D-toast-face.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, `UI/Toasts.lua`, and `tests/test_ui.lua`; checked the provided exclusive-pair diff; then ran `lua tests/test_ui.lua`. Isolated result: **321 passed, 0 failed**, exit 0. Did not mutate addon code. Did not commit. This review does not sign the lane.

---

## Named gates

| Gate | Verdict |
|---|---|
| `MORPHEUS.ttf` `pcall` on headlines | **Pass.** `HEADLINE_FONT = "Fonts\\MORPHEUS.ttf"` (FrameXML lowercase). `applyHeadlineFont` runs only on `theater.headline` after `CreateFontString(..., "GameFontNormalLarge")`. `pcall(fs.SetFont, fs, HEADLINE_FONT, HEADLINE_SIZE)` — flags omitted. Fallback `SetFontObject(GameFontNormalLarge)` when `SetFont` is missing or `applied` is not truthy. Body is `GameFontNormal` with no `SetFont`. System toast stays `GameFontNormal`. Source-pin `MORPHEUS` + `MORPHEUS.ttf`; soft `GetFont` does not fail when the stub ignores `SetFont`. **Nit:** runtime apply is unproven (see Issues). |
| Clerical copy unchanged | **Pass.** `clericalCopy` strings are not in the exclusive diff. Pins still exact: `A Beef Gora is Sanctioned`, `Cowardice recorded: Thickcut. So ruled by the Beef Pope.`, `Victor declared: Thickcut.`, `Void.`, `The bout is set aside.`, `Free ruling.`, `RISE, BEEF KNIGHT\nBeefina`, `RISE, BEEF LORD\nJuicyj`. `theaterCopy()` joins headline + body so the B3-A concatenated pins stay. Split is display only: first `\n` is the headline; single-line beats sit on the headline and hide an empty body. No `"found worthy"`, `"Their third meeting"`, or `"Let it be known"`. |
| Quiet refuse | **Pass.** `theaterAllowed` still refuses missing Runtime, nil snapshot, and `state == "QUIET"` before copy, show, chat, or Sound. Suite pins Quiet sanction, missing-Runtime cowardice, Quiet knighting, and missing-Runtime elevation. Overlay stays hidden. Source reason remains `"quiet"`. |
| `Sound:Play` name pins (not `PlaySound` string) | **Pass.** `playTheaterCue` is still `pcall` → `sound:Play(kind)`. Suite wraps `COB.Sound.Play` and pins the **name**: `sanction`, `cowardice`, `verdict`, `knighting`, `elevation`. `PlaySound` is stubbed empty; `PlaySoundFile` errors. Missing Sound still shows. No new cue names. Exclusive pair does not edit `Sound.lua`. |
| Isolated green | **Pass.** Reviewer ran `lua tests/test_ui.lua`: **321 passed, 0 failed**, exit 0. Isolation nil-module asserts and the standalone summary stay under `if standalone then`. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Sound.lua, Console, Hud; no commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/Toasts.lua` and `tests/test_ui.lua`. Suite still `dofile`s Runtime and Sound for the Quiet / cue pins (same as V-B / B3-A). |
| Stock fonts only; FrameXML `Fonts\MORPHEUS.ttf` via `pcall` `SetFont` on the **headline** FontString; fallback GameFont/template; body stays `GameFont*` | **Pass.** Named-gate check. Path matches V-stock / `GlueFonts` lowercase `.ttf`, not the `.TTF` form B4-E shipped. No `Media\`. |
| Do not change clerical copy | **Pass.** Named-gate check. |
| Quiet still refuses; dim ≤ 0.5; no close button | **Pass.** `DIM_ALPHA = 0.45`. `findButton(root) == nil` on sanction / cowardice / knighting / elevation. `EnableMouse(false)` kept. |
| No new cue names; no `SendChatMessage` | **Pass.** Source grep `SendChatMessage(` is nil. Cue remains `Sound:Play(kind)`. |
| Keep B3-A kind pins and `Sound:Play` name pins; isolation wrap stays | **Pass.** Named-gate checks. |
| Isolated `lua tests/test_ui.lua` exit 0 | **Pass.** Verified 321 / 0. |
| **POLISH:CANDIDATE** at most | **Pass.** Writer claimed that ceiling and no more. |

Bible §19.3 / Law 10 (one theatrical display face; stock this wave), Law 4 (clerical copy only), Law 6 (Quiet refuses theater), B3-A kind / cue-name pins, and CONTINUE 2026-08-18 license 4 are met on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; Morpheus at height 18 unsmoked on 20506 | **Not a spec miss.** Brief asked isolated green. **POLISH:CANDIDATE** is the ceiling. |
| Harness `SetFont` is a no-op; soft `GetFont` pin does not fail | **Not a miss.** Brief: if the stub `SetFont` is a no-op, source-pin `MORPHEUS` and soft-pin the path. |
| Stock Morpheus is not the Batch 4 custom blackletter | **Not a miss.** License 4 / brief: stock only. |
| Single-line verdicts / cowardice on the headline | **Not a miss.** Copy is unchanged; split is first newline. |
| Integrator still lists TOC / `run.lua`; Console / Knighting still do not call Proclaim | **Not a miss.** Brief forbade those edits. |

---

## Strengths

- The delta is the brief: one headline FontString tries stock Morpheus; body and system toasts stay `GameFont*`; clerical strings were not rewritten.
- FrameXML casing is `MORPHEUS.ttf`. Flags are omitted. Both are cleaner than the B4-E name-face (`MORPHEUS.TTF` + empty `""`).
- `theaterCopy()` join keeps the B3-A exact-string pins. Headline / body split pins were added on top, not instead.
- Quiet still refuses before overlay mint, chat, or Sound. `Sound:Play` is still the name contract; `PlaySound` is not the pin.
- Isolation stayed gated. Exclusive pair only. No `SendChatMessage`, no Console / Gora / Knighting wire, no new cue name.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Morpheus apply is source-only.** `wow_ui_stub` `SetFont` is an allowed no-op (`function() end`) that returns nil. `used = ok and applied and true or false` then calls `SetFontObject(GameFontNormalLarge)`. Soft `GetFont` never fires. The suite proves the path is in the file and the headline widget exists, not that a 20506 FontString wears Morpheus. Brief allowed this.

2. **Success-bool fallback.** `SimpleFontStringAPI` `SetFont` returns `success`. Gating on a truthy `applied` is correct on the client. On the harness it always falls through. A missing file on 20506 also returns false and stays `GameFontNormalLarge` — intended, but unsmoked.

3. **Quiet reason is still only typed.** Pre-existing B3-A softness. Source returns `"quiet"`. The pin accepts any string.

4. **Dim pin is a field Toasts writes, not a widget read.** Pre-existing. Source applies `0.45` via `SetColorTexture` / `SetVertexColor`. Suite reads `theater.dimAlpha`.

5. **Height 18 is unsmoked.** Brief did not name a size. Single-line cowardice / victor sentences now sit on the Morpheus headline with word wrap. Client paint is a human eye, not this suite.

6. **`applyHeadlineFont` runs once in `InitTheater`.** Later `Proclaim` calls reuse the FontString. Fine unless something else resets the font object. Not a miss.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated 321 / 0 was re-run here. Client path and runner listing were not.

---

## Assessment

**Spec PASS. Quality Approved-with-nits.**

This is the B5-D contract: Proclaim headlines try stock `Fonts\MORPHEUS.ttf` via `pcall` `SetFont` with `GameFontNormalLarge` fallback; clerical copy is unchanged; Quiet still refuses; `Sound:Play` name pins stay (not `PlaySound` strings); isolated suite green. Named gates are clean. The nits cluster on the display face: the harness cannot prove `SetFont`, and height 18 is unsmoked. That is the brief’s own stub accommodation, not a copy or Quiet regression.

Expected leftover (not a miss): integrator lists the files in the TOC and `run.lua` if those lines are not already present. Console / Knighting still do not call Proclaim. Brief forbade those edits.

Isolated **321 passed, 0 failed** verified. Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
