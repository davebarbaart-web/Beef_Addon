# B3-A — Knighting / elevation proclamation (review)

**Spec:** PASS
**Quality:** Approved

**Lane:** B3-A Knighting / elevation proclamation
**Brief:** `docs/reformation/vestments/briefs/B3-A-knighting.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/B3-A-knighting-report.md`
**Diff:** `docs/reformation/vestments/briefs/B3-A-knighting.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, and the provided diff once; then checked `Toasts.lua` (`THEATER_KINDS`, `theaterAllowed`, `clericalCopy`, `tintFor`, `playTheaterCue`, `Proclaim`, `Celebrate`) and the B3-A block in `test_ui.lua` for the named risks. Did not mutate the working tree except this review file. Did not re-run git or the suite. Writer-reported **302 / 0** is a claim — do not treat it as verified.

This review does not sign the lane.

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Console / Knighting Core / Sound.lua / HUD / Decree / Records / Core / TOC / bootstrap / `run.lua` / OPEN_QUESTIONS / REFORMATION_LOG / commit | **Pass.** Named risk. Provided diff touches only the two exclusive files. Suite `dofile`s Runtime and Sound for the Quiet / cue pins, as V-B already did. Sibling dirt on Sound.lua (B3-C) is not this lane’s edit. |
| No custom media; no new sound cue **names** | **Pass.** Named risk. Overlay still uses `QuestBG` / tooltip border / `WHITE8X8`. `playTheaterCue` calls `Sound:Play(kind)` with `knighting` / `elevation` only. Those two names already exist in Sound.lua. No sixth name. |
| Kinds: `knighting` / `elevation` via `Proclaim`; sanction / verdict / cowardice unchanged; unknown kinds mint no copy | **Pass.** Two keys added to `THEATER_KINDS`. Existing three kinds and the `sermon` refuse stay. Theater kinds are still not queue `KINDS`. |
| Quiet / missing Runtime refuse (`return false`); no overlay show | **Pass.** Named risk. Shared `theaterAllowed` refuses missing Runtime, nil snapshot, and `state == "QUIET"` before copy, show, chat, or Sound. Suite pins Quiet knighting and missing-Runtime elevation; overlay stays hidden. |
| Fixed clerical headlines only: `RISE, BEEF KNIGHT` + `name`; `RISE, BEEF LORD` + `name` | **Pass.** Named risk. Two-line mute cards. Missing / empty `name` → `false, "invalid"` and no show. No `"found worthy"`. No generated oratory. |
| Same overlay contract as sanction: center third; dim ≤ 0.5; `C_Timer.After`; no close button; no `SendChatMessage` | **Pass.** Shared `InitTheater` / `Proclaim` path. `DIM_ALPHA = 0.45`. Panel is `floor(parentW / 3)` or 420. No Button children. Hide via existing `after()` → `C_Timer.After`. Source has no `SendChatMessage(`. |
| `Sound:Play("knighting")` / `Sound:Play("elevation")` when Sound exists; missing Sound still shows | **Pass.** `pcall` into `Sound:Play(kind)`. Quiet never reaches Play. Pre-existing missing-Sound sanction pin still shows. |
| Do not wire Console / Knighting; tests Proclaim directly | **Pass.** No `COB.Console` / `COB.Gora` / `COB.Knighting` in Toasts.lua. Isolation stays under `if standalone then`. |
| Keep sanction / verdict / cowardice and system / debug green | **Pass.** V-B pins remain above the B3-A block. Post-theater `Push({ kind = "system" })` still queues. `Celebrate("knighting")` with no fields refuses via Proclaim instead of minting a system toast. |

Bible §8 / §19.2–19.4, Law 4 (mute card, no oratory), and Batch 3 R7 (ALL CAPS clerical headlines, not title-case storybook) are met on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Integrator must wrap Console / Knighting later | **Not a miss.** Brief forbade that wiring. |
| Headline face is stock `GameFontNormalLarge` | **Not a miss.** No custom media this lane. Blackletter is Batch 4. |
| B3-C may change the `PlaySound` argument to a kit id | **Acceptable.** This lane’s contract is the cue *name* passed to `Sound:Play`. See Minor. |
| No client `/reload` smoke | **Expected.** POLISH:CANDIDATE only. |

---

## Named risks

| Risk | Verdict |
|---|---|
| Quiet refuse | **Clean.** `theaterAllowed` runs before copy, show, chat, or Sound. Quiet knighting and missing-Runtime elevation both return `false` and do not show. Source reason is `"quiet"`. |
| Fixed RISE headlines | **Clean.** Exact `RISE, BEEF KNIGHT` / `RISE, BEEF LORD` plus the field name on the next line. Empty / missing name is `invalid`. Source greps refuse `"found worthy"`. |
| No new cue names | **Clean.** Exclusive pair does not edit Sound.lua and does not add a sixth name. Play asks `knighting` / `elevation` only — already on the §19.4 five. |
| Exclusive files | **Clean.** Provided diff is `UI/Toasts.lua` and `tests/test_ui.lua` only. |

---

## Strengths

- Quiet is a real refuse, not a comment. Knighting and elevation share the sanction gate; Sound is never asked to paper over a Quiet show.
- Copy is two fixed headlines plus a required name. No oratory builder, no title-case storybook, no `"found worthy"`.
- `Celebrate` already routed `THEATER_KINDS` into `Proclaim`. Adding the two keys is enough — `"knighting"` cannot fall through to a system toast that says `"knighting"`.
- Overlay geometry, dim, timed hide, and no-close are reused, not forked. Gold tint on these two kinds is extra, not a new surface.
- Suite work matches the brief’s list and keeps the V-B / system / debug body. Isolation was not pulled out of `if standalone then`.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Quiet reason is only typed, not pinned.** Quiet knighting asserts `kQuietReason` is a string. Missing-Runtime elevation does not read the reason at all. Source returns `"quiet"` for both. An implementer could return `"no"` and still pass the new pins.

2. **Cue pin watches global `PlaySound`, not `Sound:Play`.** Same V-B stub. After B3-C, `PlaySound` may receive a kit number or nothing (nil `SOUNDKIT` in this suite). The brief’s name contract lives on `playTheaterCue(kind)`. The pin can go red without Toasts regressing, or stay green while a later Sound change swallows the call. Writer already named this.

3. **Dim pin is a field Toasts writes, not a widget read.** Same V-B weakness. Source applies `0.45` via `SetColorTexture` / `SetVertexColor`. Suite reads `theater.dimAlpha`.

4. **Elevation Quiet, center-third, OnUpdate, and timed hide share the knighting pins.** The function is the same. Celebrate elevation is not separately pinned.

5. **Whitespace-only `name` is accepted.** `""` is `invalid`; `"   "` paints. Same as other field fills. Not a voice violation.

6. **Gold tint is implemented, not asserted.** Brief did not require gold. Not a miss.

7. **Client `/reload` smoke was not run.** Stock QuestBG + dim at 45% + ALL CAPS `GameFontNormalLarge` need a human eye. **POLISH:CANDIDATE** only.

---

## Assessment

**Spec PASS. Quality: Approved.** Gate PASS for this lane’s contract. Do not sign.

The exclusive pair does what the brief asked: Event Mode `Proclaim` for knighting / elevation, Quiet refuse, fixed `RISE, BEEF KNIGHT` / `RISE, BEEF LORD` plus name, no new cue names, no Console / Knighting wire, sanction / verdict / cowardice and system / debug left standing. Named risks are clean. Minors are test indirection, sibling SoundKit interop, and unsmoked client paint — not trust-breakers.

Writer-reported isolated `tests/test_ui.lua` **302 / 0** was **not** re-run here. Do not treat that count as verified. Do not claim **POLISH:PASS**. Do not claim V1 / MVP complete.
