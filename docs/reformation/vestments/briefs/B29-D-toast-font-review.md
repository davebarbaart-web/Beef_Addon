Spec PASS

# B29-D — Proclaim re-applies Morpheus on the headline (review)

**Quality:** Approved-with-nits

**Lane:** B29-D Proclaim re-applies Morpheus on the headline
**Brief:** `docs/reformation/vestments/briefs/B29-D-toast-font.md`
**Writer report:** `docs/reformation/vestments/briefs/B29-D-toast-font-report.md`
**Diff:** `docs/reformation/vestments/briefs/B29-D-toast-font.diff` (B29-D-only exclusive-pair packet; live `Toasts.lua` / `test_ui.lua` also carry earlier toast / Quiet-shell batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Toasts.lua` (`applyHeadlineFont`, `HEADLINE_FONT`, `InitTheater`, `Proclaim`, `playTheaterCue`, `THEATER_KINDS`, clerical builders), and `tests/test_ui.lua` (isolation wrap, clerical / ESC / B26-B OnHide / B27-C shell pins, nested B29-D source pins inside `runB12D()`); then ran `lua tests/test_ui.lua` (**558 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §19.3 / license 4 stock only; Law 10 (theatrical Proclaim headlines); B22 leftover (`applyHeadlineFont` only in `InitTheater` build); when `Proclaim` paints a shown beat, call `applyHeadlineFont` on `theater.headline`; hidden / refused Proclaim does not need it; `HEADLINE_FONT` stays `Fonts\\MORPHEUS.ttf`; fallback `GameFontNormalLarge` stays; no `MORPHEUS_CYR`; no new cue names; no `PlaySound`. Did not mutate `Toasts.lua` or `test_ui.lua`. Did not commit. Did not edit MainFrame, Decree, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `applyHeadlineFont` still runs only in `InitTheater` (B22 leftover) | **Pass. Verified.** Live shown-beat `Proclaim` calls `applyHeadlineFont(theater.headline)` immediately after `headline:SetText`. Source pin extracts the `Proclaim` body (through `wireSmallOnHide`) and requires `applyHeadlineFont` inside it; `InitTheater` still contains the mint apply. Reviewer spy: `InitTheater` mint then wrap `SetFont` → first shown `Proclaim` is **1** `SetFont` on the headline (`Fonts\MORPHEUS.ttf`, size 18); a second shown `Proclaim` is one more. `InitTheater` early-return after mint is **0** `SetFont`; the following shown `Proclaim` is **1**. Body `copy` `SetFont` stays 0. |
| Hidden / refused Proclaim is required to re-apply, or incorrectly does | **Pass.** Brief says hidden / refused does not need it. Quiet / missing Runtime / invalid kind / empty clerical copy return before paint. Reviewer spy after a minted theater: Quiet refuse, `sermon` invalid, empty knighting, and missing Runtime are all **0** `SetFont` on headline and copy. |
| `HEADLINE_FONT` / fallback / `MORPHEUS_CYR` changed | **Pass.** `HEADLINE_FONT` is still `Fonts\\MORPHEUS.ttf`. Helper body is unchanged: `pcall` `SetFont(HEADLINE_FONT, 18)` plus `SetFontObject(GameFontNormalLarge)` fallback. Source has no `MORPHEUS_CYR`, `MORPHEUS.TTF`, other `.ttf`, `Media\\`, `.tga`, or `.blp`. Reviewer spy paths are `Fonts\MORPHEUS.ttf` size 18. |
| New cue names / `PlaySound` | **Pass.** `THEATER_KINDS` is still sanction / verdict / cowardice / knighting / elevation. Cue remains `playTheaterCue` → `Sound:Play(kind)` from shown `Proclaim` only. Live `Toasts.lua` has no `PlaySound`, `PlaySoundFile`, `SOUNDKIT`, or `IG_CHARACTER_INFO`. `_G.applyHeadlineFont` / `_G.HEADLINE_FONT` / `_G.playTheaterCue` are nil. `debug.getupvalue`: `applyHeadlineFont` is an upvalue of `Proclaim` and of `InitTheater`. |
| Existing clerical / ESC / B26-B OnHide / B27-C shell pins drop | **Pass.** Those blocks sit above the B29-D nest inside `runB12D()`. Isolation wrap is still **11** nil-module pins under `if standalone then` at file load. Suite green includes those asserts. `runB12D()` still re-pins Console / Hud / Records Book / Gora (**4**). |
| Isolated suite not exit 0 / pins not nested in `runB12D()` | **Pass. Verified.** 558 passed, 0 failed. Writer-reported count matches. New source asserts sit inside `runB12D()`. Packet adds no main-chunk `local`. Header comment only at file top. `luac -l -p`: main chunk **75** locals (cap 200). |
| Exclusive file breach / MainFrame edited | **Pass.** Provided packet is two `diff --git` hunks: `UI/Toasts.lua` (one apply after `SetText`) and `tests/test_ui.lua` (header + nested pins). Live MainFrame has no B29-D / `applyHeadlineFont` / `HEADLINE_FONT` tokens. Sibling dirt vs HEAD on MainFrame is earlier Quiet-shell batches, not this lane. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit MainFrame / Decree / glue; no commit | **Pass.** Named-risk check. |
| Isolation wrap stays | **Pass.** Load wrap is still **11** nil-module pins under `if standalone then`. Runtime + Sound stay dofiled later. |
| When `Proclaim` paints a shown beat, call `applyHeadlineFont` on `theater.headline` | **Pass.** Named-risk check. Live call is after `SetText`, before body `SetText` / `Show`. |
| Hidden / refused Proclaim does not need apply | **Pass.** Named-risk check. |
| `HEADLINE_FONT` stays `Fonts\\MORPHEUS.ttf`; fallback `GameFontNormalLarge` stays; no `MORPHEUS_CYR` | **Pass.** Named-risk check. |
| No new cue names; no `PlaySound` | **Pass.** Named-risk check. |
| Source pin: `applyHeadlineFont` from `Proclaim` (not only `InitTheater`); clerical / ESC / B26-B / B27-C pins stay; nest in `runB12D()` | **Pass.** Nested after B27-C. `InitTheater` still applies on mint. Existing pins stay. |
| `lua tests/test_ui.lua` exit 0 | **Pass.** **558 / 0.** |

Bible §19.3 / license 4 (stock FrameXML Morpheus, not custom Media) and Law 10 (theatrical Proclaim headlines) hold on the exclusive pair: headlines still mint as `GameFontNormalLarge` and try `Fonts\\MORPHEUS.ttf`, and a later shown `Proclaim` re-applies that try. Body stays `GameFontNormal`. System toast stays `GameFont*`. Cue names stay the five theater kinds.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Harness `SetFont` is a no-op; headlines keep the `GameFontNormalLarge` template; soft `GetFont` is not pinned | **On contract.** Brief asked a source pin on `Proclaim`, not a client `GetFont`. Reviewer spy: shown `Proclaim` invokes `SetFont` once with the stock path; the stub returns nil. |
| Success-bool fallback; `applyHeadlineFont` requires a truthy `SetFont` return | **On contract.** Helper body is unchanged. Anniversary `FontString:SetFont` returns `success`. Unsmoked. |
| No client / `/reload` smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

B29-INT glue is not required. The re-apply is a local call on the shown paint path.

---

## Isolation / applyHeadlineFont / hidden Proclaim

**Isolation wrap — Pass.** Load list is still Common + Ranks + Officer + Roster + DB + MainFrame + Status + Minimap + Toasts. Runtime + Sound are dofiled later for Quiet / cue pins. No `dofile` of Console / Hud / Records Book / Gora / Knighting / Codec / Sender / Archive / Recognition. Standalone wrap is still **11** nil-module pins under the first `if standalone then`. Wrap was not rewritten. `runB12D()` still re-pins Console / Hud / Records Book / Gora.

**applyHeadlineFont / shown Proclaim — Pass.** Helper stays `local function applyHeadlineFont`. Body is unchanged: `pcall` `SetFont(HEADLINE_FONT, 18)`; truthy return required; else `SetFontObject(GameFontNormalLarge)`. `Proclaim` applies only `theater.headline` after `SetText` and before body paint / `Show`. `InitTheater` still applies on mint and does not re-apply on early-return. Reviewer spy: two shown Proclaims each fire one stock-path `SetFont` on the headline after mint; copy stays quiet. Celebrate elevation (routes to `Proclaim`) also fires one.

**Hidden / cues / stock — Pass.** Refused arms do not re-apply. `THEATER_KINDS` is unchanged. No `PlaySound` in `Toasts.lua`. No `MORPHEUS_CYR`.

---

## Strengths

- The leftover is closed on the existing shown paint path: one call after `SetText`, not a second font helper and not a `Proclaim`-level global.
- Hidden / refused arms stay return-before-paint. `_G.applyHeadlineFont` stays nil.
- B29-D pins nest in `runB12D()` (no new main-chunk locals). `InitTheater` apply, Morpheus path, `MORPHEUS_CYR` refuse, `GameFontNormalLarge` fallback, and no-`PlaySound` stay in that same nest.
- Packet does not rewrite clerical copy, ESC / `UISpecialFrames`, Quiet-shell `rememberSpecial`, HideAll / `theaterGen`, small-toast ESC / pump, or B26-B / B27-C OnHide restore.
- Writer-reported **558 / 0** matched the re-run. Writer-reported red (**557 / 1**, `Proclaim re-applies headline font on a shown beat`) matches the one new assert old `Proclaim` would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Client `SetFont("Fonts\\MORPHEUS.ttf", 18)` after a later Proclaim / font reset is unsmoked.** The suite cannot prove Anniversary re-applies Morpheus. `wow_ui_stub` `SetFont` / `GetFont` are no-ops; headlines keep the mint template. Brief scoped this lane to a source pin and the isolated suite. Reviewer spy proves shown `Proclaim` calls `SetFont` with the stock path; it does not prove pixels.

### Nit

1. **Source pin is a `Proclaim` substring, not a `SetFont` spy and not an after-`SetText` order pin.** A comment inside the extract would pass. Live call is real (`applyHeadlineFont(theater.headline)` after `SetText`); reviewer spy closes the hole.

2. **Hidden / refused skip is not pinned.** Brief said those arms do not need apply. Live code returns before paint; reviewer spy is 0 `SetFont`. A later edit that applied on refuse would still pass the suite.

3. **Harness never invokes `SetFontObject`.** `GameFontNormalLarge` is not a live font object in `wow_ui_stub`, so `if font then` skips. Writer report says the harness always falls through to `SetFontObject(GameFontNormalLarge)`. It enters that branch; it does not call it. Headlines still stay `GameFontNormalLarge` because that is the `CreateFontString` template.

4. **Isolation wrap is load-only.** Eleven pins under `if standalone then` at file load. `runB12D()` re-pins four of them. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Toasts delta.** Packet is the B29-D-only `Proclaim` apply + nested pins. `git diff HEAD` on the two files still includes earlier toast / Quiet-shell batches. Report already says this.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **558 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **558 passed, 0 failed.** Isolation wrap: **11**.

When `Proclaim` paints a shown beat, it calls local `applyHeadlineFont` on `theater.headline` after `SetText`. Hidden / refused Proclaim does not. `HEADLINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Fallback `GameFontNormalLarge` stays. No `MORPHEUS_CYR`. No new cue names. No `PlaySound`. Pins live in `runB12D()`. Isolated `lua tests/test_ui.lua` **558 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
