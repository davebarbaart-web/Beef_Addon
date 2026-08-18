Spec PASS

# B20-C — Fighter card name uses FrameXML Morpheus casing (review)

**Quality:** Approved-with-nits

**Lane:** B20-C Fighter card name uses FrameXML Morpheus casing
**Brief:** `docs/reformation/vestments/briefs/B20-C-card-font.md`
**Writer report:** `docs/reformation/vestments/briefs/B20-C-card-font-report.md`
**Diff:** `docs/reformation/vestments/briefs/B20-C-card-font.diff` (B20-C-only exclusive-pair packet; live `FighterCard.lua` also carries earlier vestment batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/FighterCard.lua` (`NAME_FONT`, `applyNameFont` after `makeLabel`, plate-name-only apply, `EnableMouse(false)`, `rememberSpecial` / `lastPair` / `hiddenView.health`), and `tests/test_fighter_card.lua` (new source pins after the stock-Morpheus assert, then existing dock / persist / ESC / `1-0` / health-nil pins and the isolation wrap); then ran `lua tests/test_fighter_card.lua` (**486 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §19.3 / CONTINUE 2026-08-18 license 4 stock only; `NAME_FONT` `Fonts\\MORPHEUS.ttf` (match Decree / Toasts); `applyNameFont` pcall fallback stays; keep arabic `1-0`; no `UnitHealth`; no drag persist; lastPair until QUIET; ESC `UISpecialFrames` stays; no `MORPHEUS_CYR`. Isolation wow_ui_stub + Common + Ranks + Store + Runtime + Gora + FighterCard only. Did not mutate `FighterCard.lua` or `test_fighter_card.lua`. Did not commit. Did not edit Decree, Records, Toasts, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `NAME_FONT` still `Fonts\\MORPHEUS.TTF` (V-A leftover; `SetFont` fail → GameFontHighlight) | **Pass. Verified.** Live assignment is `local NAME_FONT = "Fonts\\MORPHEUS.ttf"`. Only consumer is `applyNameFont` → `plate.name`. Anniversary FrameXML GlueFonts names `Fonts\MORPHEUS.ttf`. Decree / Toasts already use that casing. Suite source pin finds `Fonts\\MORPHEUS.ttf` and refuses `MORPHEUS.TTF`. Reviewer spy (upvalue): truthy `SetFont` is path `Fonts\MORPHEUS.ttf`, size 16, flags `""`; no `SetFontObject` on the success arm. |
| `applyNameFont` fallback dropped | **Pass. Verified.** `SetFont` still `pcall`s; `used` still requires a truthy return; `SetFontObject(GameFontHighlight)` still runs when `used` is false. Packet does not touch the helper. Suite still pins `SetFontObject`. Reviewer probe: `SetFont` nil, `SetFont` throw, and missing `SetFont` all fall through to `GameFontHighlight` when that global exists. |
| GlueFonts `MORPHEUS_CYR` used | **Pass.** Source has no `MORPHEUS_CYR`. Suite refuses it. Anniversary GlueFonts still has `Fonts\MORPHEUS_CYR.TTF` as the localization face; this lane did not take it. |
| `UnitHealth` / live health | **Pass. Verified.** Source has no `UnitHealth`. `hiddenView.health` stays nil. Suite source pin and `healthReads == 0` stay. Reviewer probe: shown / persist / QUIET views stay `health == nil`. |
| Drag persist / dock moved | **Pass.** `EnableMouse(false)` stays. Source has no `RegisterForDrag` / `StartMoving`. Default `SetPoint("LEFT", parent, "LEFT", 0, 0)` and clamp stay. Suite LEFT / clamp / left-third rebuild pins stay. |
| Arabic `1-0` broken | **Pass.** Persist / rematch / honorific / defenses keep-pins still assert painted `1-0` / H2H `1-0`. Reviewer probe: after `DeclareVictor`, record A and H2H are `1-0`. |
| lastPair forgotten before QUIET, or ESC dropped | **Pass.** `OnHide` still syncs `lastView.shown` without `forgetPersist`. `Refresh` / `Show` still forget only when `eventLive()` is false. `rememberSpecial` / `UISpecialFrames` stay. Suite persist / OnHide / widget Hide / subjects / special-frame pins stay. Reviewer probe: lastPair remains after the ruling; QUIET nils it; ASSEMBLY does not revive; special-frame count stays 1. |
| Isolated suite not exit 0 | **Pass. Verified.** 486 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two hunks (`NAME_FONT` casing; five source-pin lines including the custom-font grep retarget). Sibling dirt in this workspace is other lanes (Records font, Decree, Toasts, Console, glue). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Decree / Records / Toasts / glue; no commit | **Pass.** Named-risk check. |
| Isolation stays wow_ui_stub + Common + Ranks + Store + Runtime + Gora + FighterCard | **Pass.** Six `dofile`s unchanged. Load wrap still **17** nil-module pins under `if standalone then`. |
| `NAME_FONT` is `Fonts\\MORPHEUS.ttf` (FrameXML / Decree / Toasts casing) | **Pass.** Live local and plate-name `applyNameFont` call. Decree `LINE_FONT` and Toasts `HEADLINE_FONT` already use `Fonts\\MORPHEUS.ttf`. |
| `SetFont` pcall fallback stays (`GameFontHighlight` if `SetFont` fails) | **Pass.** Named-risk check. FontString `SetFont` on anniversary returns `success` bool; the truthy check is the client contract. |
| Keep arabic `1-0` | **Pass.** Named-risk check. |
| No drag persist (left-third docked) | **Pass.** Named-risk check. |
| No `UnitHealth` | **Pass.** Named-risk check. |
| lastPair until QUIET | **Pass.** Named-risk check. |
| ESC `UISpecialFrames` stays | **Pass.** Named-risk check. Deduped `rememberSpecial` / missing-table Init pin stay. |
| No `MORPHEUS_CYR` | **Pass.** Named-risk check. |
| Source pin for `Fonts\\MORPHEUS.ttf`; existing dock / persist / ESC / `1-0` / health-nil pins stay | **Pass.** New pins sit immediately after `names try stock Morpheus`. Custom-font grep now strips the lowercase stock path. Keep-blocks were not rewritten. |
| Isolation wrap stays | **Pass.** Wrap untouched. Reviewer probe: those keys are nil at load. |
| `lua tests/test_fighter_card.lua` exit 0 | **Pass.** **486 / 0.** |

Bible §19.3 / license 4 stock only hold on the exclusive pair. The V-A casing leftover on the fighter-card names is closed. Law 8 / §10.6–§10.7 hold: mute tape, no live health, persist through the verdict, hide on QUIET. ESC stays a named `UISpecialFrames` Hide.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Records Book still uses `Fonts\\MORPHEUS.TTF` (B20-B) | **Stale vs live tree.** Out of exclusive pair. Live `PAGE_TITLE_FONT` is already `Fonts\\MORPHEUS.ttf`. Not a B20-C miss. |
| `applyNameFont` fallback is source-pinned, not client-proven | **On contract.** Brief asked to keep the helper, not to prove missing-face load in-game. Reviewer probe with `GameFontHighlight` present confirmed nil / throw / missing-`SetFont` arms. |
| Soft `GetFont` pin does not fail when the stub ignores `SetFont` | **On contract.** Pre-existing soft pin. Stub `GetFont` returns nil; the `if type(...) == "string"` arm never runs. |
| No client / `/reload` smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

No INT glue is required. Names already paint through `applyNameFont(plate.name)`.

---

## Isolation / font / persist

**Isolation wrap — Pass.** Load list is still stub + Common + Ranks + Store + Runtime + Gora + FighterCard. No `dofile` of Net / Console / HUD / Decree / Records / Toasts / Sound / MainFrame / DB. Standalone wrap is still 17 nils (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Sound, Decree, Records Book). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged).

**Name font — Pass.** `NAME_FONT` is `Fonts\\MORPHEUS.ttf`. It is applied only to plate names. Titles / records / H2H / stipulation / VS stay `GameFont*`. `applyNameFont` is unchanged. No `MORPHEUS_CYR`. No custom `Media\\`.

**Persist / ESC / health / `1-0` — Pass.** lastPair survives Hide / OnHide / a cleared live pair while the event is live, and is forgotten on QUIET. `UISpecialFrames` stays. View `health` stays nil. Painted W–L and H2H stay arabic `1-0`. No drag persist.

---

## Strengths

- The change is one assignment. `applyNameFont`, dock, persist, ESC, `1-0`, and health-nil were left alone.
- Source pins refuse the old `.TTF` and the GlueFonts CYR face, retarget the custom-font grep at `.ttf`, and keep `SetFontObject`. Writer-reported red (**484 / 2**) matches those two new fails against a still-uppercase `NAME_FONT` (CYR / `SetFontObject` / retargeted custom-font grep already passed).
- Decree and Toasts already use the FrameXML path; this lane matches that face instead of inventing a third casing.
- Isolation wrap and existing keep-pins were not rewritten. No `UnitHealth`, no drag persist, no custom media.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

None in exclusive scope. Live theatrical Morpheus paths (Decree, Toasts, Records, FighterCard) are already `.ttf`. The V-A leftover on this surface is closed.

### Nit

1. **Suite pins are source-greps.** Stub `SetFont` is a nil-returning no-op, so `applyNameFont` never records a live path during `lua tests/test_fighter_card.lua`. The soft `GetFont` pin does not fail (`GetFont` returns nil). Reviewer spy with a truthy `SetFont` confirmed the name face gets `Fonts\MORPHEUS.ttf` at 16.

2. **`applyNameFont` fallback is unproven in the suite.** Same stub gap. Reviewer probe with `GameFontHighlight` present confirmed nil-return, throw, and missing `SetFont` all call `SetFontObject`. Brief asked to keep the helper, not to add a runtime pin.

3. **`SetFontObject` pin is any occurrence.** Live source has that call only inside `applyNameFont`, so the grep is tight here. It is still a source pin, not a fallback-path exercise.

4. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD FighterCard delta.** Packet is the B20-C-only casing + pins. `git diff HEAD` on the two files still includes earlier vestment batches. Report already says this.

6. **Writer leftover overstates Records Book.** Report says Records still uses `Fonts\\MORPHEUS.TTF`. Live `PAGE_TITLE_FONT` is already lowercase (sibling B20-B). Harmless; out of exclusive pair.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **486 / 0** was re-run here. Anniversary `SetFont("Fonts\\MORPHEUS.ttf")` is not walked in-game this lane.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **486 passed, 0 failed.** Isolation wrap: **17**.

FighterCard `NAME_FONT` is `Fonts\\MORPHEUS.ttf`. `applyNameFont` still falls back to `GameFontHighlight` when `SetFont` fails. Arabic `1-0` stays. No `UnitHealth`. No drag persist. lastPair remains until QUIET. ESC `UISpecialFrames` stays. No `MORPHEUS_CYR`. Isolation stays stub + Common + Ranks + Store + Runtime + Gora + FighterCard. Isolated `lua tests/test_fighter_card.lua` **486 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
