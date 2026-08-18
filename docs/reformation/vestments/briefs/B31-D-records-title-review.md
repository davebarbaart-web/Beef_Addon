Spec PASS

# B31-D — Records paint re-applies Morpheus on the book title (review)

**Quality:** Approved-with-nits

**Lane:** B31-D Records paint re-applies Morpheus on the book title
**Brief:** `docs/reformation/vestments/briefs/B31-D-records-title.md`
**Writer report:** `docs/reformation/vestments/briefs/B31-D-records-title-report.md`
**Diff:** `docs/reformation/vestments/briefs/B31-D-records-title.diff` (B31-D-only exclusive-pair packet; live `RecordsBook.lua` / `test_records.lua` also carry earlier Records Book batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/RecordsBook.lua` (`paint()` ~530, `applyFont`, `PAGE_TITLE_FONT`, `buildFrame` title / page-title apply, `PAGE_TITLES`, `bodyText` / `localHonorifics` / `momentLines`, `turn` / wheel), and `tests/test_records.lua` (isolation wrap, B25-C Init remount, nested `runB28C()` Hide remount, nested `runB30C()` PageTitle paint, nested `runB31D()` after `runB30C()`, page / wheel / roman / Morpheus create-path pins); then ran `lua tests/test_records.lua` (**536 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §19.3 / license 4 stock only; Law 10 / Law 6 (theatrical parchment; player-opened Quiet identity/history; no Hide / paint sound); B30 leftover (`TitleText` Morpheus applies only in `buildFrame`); when `paint()` runs and `frame.TitleText` exists, call `applyFont(frame.TitleText, "GameFontNormalHuge", PAGE_TITLE_FONT, 20)`; do not change the chrome title string; PageTitle apply (B30-C) stays; `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`; FRIZQT / GameFont fallback stays; no category remap (#3); no generated prose. Isolation wow_ui_stub + Common + Ranks + Store + RecordsBook only. Did not mutate `RecordsBook.lua` or `test_records.lua`. Did not commit. Did not edit Decree, Toasts, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `TitleText` Morpheus still applies only in `buildFrame` (B30 leftover) | **Pass. Verified.** Live `paint()` calls `applyFont(frame.TitleText, "GameFontNormalHuge", PAGE_TITLE_FONT, 20)` when `frame.TitleText` exists. `debug.getupvalue`: `paint` is an upvalue of `Show`; `applyFont` and `PAGE_TITLE_FONT` (`Fonts\MORPHEUS.ttf`) are upvalues of `paint`. Reviewer spy (truthy `SetFont`): mint then wrap, first `Show` is **1** `SetFont` on `TitleText` (`Fonts\MORPHEUS.ttf`, size 20) and **1** on `PageTitle` (size 18); each later wheel turn is one more of each. `Body` / `Honorifics` / `Moments` stay **0**. |
| Missing apply, or `paint()` rewrites the chrome title, or PageTitle apply dropped | **Pass.** Brief requires the TitleText apply when `paint()` runs and the leaf exists. Live call is present. `paint()` has no `frame.TitleText:SetText`. PageTitle apply-then-`SetText` stays. `buildFrame` still applies Morpheus on mint (`title` 20 / `pageTitle` 18) and still `title:SetText("The Records Book")`. |
| Chrome title / `PAGE_TITLES` remapped / generated prose / honorific or roman copy changed | **Pass.** Chrome is still `"The Records Book"` after Init, Show, and a wheel turn. Live table is still the nine Bible names in Bible order. `GetPages()` is 9; titles match the Bible list. Packet does not touch `PAGE_TITLES`, `bodyText`, `localHonorifics`, `momentLines`, or `toRoman`. `toRoman(14)` is still `XIV`. Source still refuses `ordained` / `folk hero` / `This is not hatred` / `on this day` / `unrecognized`. `MODE` is still `QUIET`. |
| `PAGE_TITLE_FONT` / `applyFont` fallback / `MORPHEUS_CYR` changed | **Pass.** `PAGE_TITLE_FONT` is still `Fonts\\MORPHEUS.ttf`. Helper body is unchanged: `pcall` `SetFont(path, size)`; truthy return required; FRIZQT when `path ~= FALLBACK_TITLE_FONT`; else `SetFontObject(GameFont*)`. Source has no `MORPHEUS_CYR`, `MORPHEUS.TTF`, `Media\\`, `.tga`, or `.blp`. Reviewer spy paths are `Fonts\MORPHEUS.ttf` size 20 on TitleText success; nil-return then also tries `Fonts\FRIZQT__.TTF` size 20. |
| Existing Hide remount / wheel / Init remount / PageTitle paint / isolation pins drop | **Pass.** Those blocks sit above or beside the B31-D nest inside `runB25C()`. Isolation wrap is still **11** nil-module pins under `if standalone then` at file load. Suite green includes those asserts. `runB25C()` still re-pins Runtime / UI / Toasts / Console / Hud (**5**) after `runB31D()`. B30-C PageTitle source pin stays; the old `paint` `TitleText` refuse pin was dropped so this apply can land. |
| Isolated suite not exit 0 / pins not nested after `runB30C()` | **Pass. Verified.** 536 passed, 0 failed. Writer-reported count matches. `runB31D()` is a nested `local function` inside `runB25C()` after `runB30C()`. Packet adds no main-chunk `local`. Header comment only at file top. `luac -l -p`: main chunk **123** locals (cap 200). RecordsBook file locals stay **44**. |
| Exclusive file breach | **Pass.** Provided packet is two hunks: `UI/RecordsBook.lua` (one TitleText apply in `paint()`) and `tests/test_records.lua` (header + B30-C comment / refuse-pin drop + nested `runB31D()`). Sibling dirt vs HEAD (Decree, Toasts, MainFrame, Console, TOC, bootstrap, `run.lua`) is other lanes, not this packet. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Decree / Toasts / glue; no commit | **Pass.** Named-risk check. |
| Isolation wrap stays | **Pass.** Load list is still stub + Common + Ranks + Store + RecordsBook. Wrap is still **11** nils under `if standalone then`. |
| When `paint()` runs and `frame.TitleText` exists, call `applyFont(frame.TitleText, "GameFontNormalHuge", PAGE_TITLE_FONT, 20)` | **Pass.** Named-risk check. `Show` / `turn` / wheel all reach that path. |
| Do not change the chrome title string | **Pass.** Named-risk check. `paint()` does not `SetText` `TitleText`. Live chrome stays The Records Book. |
| PageTitle apply (B30-C) stays | **Pass.** Live order is still apply then `SetText` on `PageTitle`. Source pin in `runB31D()` re-requires it. |
| `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`; FRIZQT / GameFont fallback stays | **Pass.** Named-risk check. |
| No category remap (#3); no generated prose; no custom media | **Pass.** Named-risk check. |
| Nest after `runB30C()`; source pin: `paint()` contains `applyFont` on `TitleText` with `PAGE_TITLE_FONT`; PageTitle paint / wheel / Hide remount / isolation stay | **Pass.** Nested after B30-C. Create-path apply, `PAGE_TITLES==9`, roman XIV, Hide remount, wheel, FRIZQT, `SetFontObject`, no `MORPHEUS_CYR` stay in that nest. |
| `lua tests/test_records.lua` exit 0 | **Pass.** **536 / 0.** |

Bible §19.3 / license 4 (stock FrameXML Morpheus, not custom Media) and Law 10 (theatrical Records parchment) hold on the exclusive pair: the chrome title still mints as `GameFontNormalHuge` and tries `Fonts\\MORPHEUS.ttf`, and a later `paint()` re-applies that try. Law 6 holds: Quiet identity/history stays silent (`PlaySound` absent; paint stays silent). OPEN_QUESTIONS #3 is not answered here.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; Anniversary `SetFont("Fonts\\MORPHEUS.ttf")` after a later leaf turn / font reset is unsmoked | **Not a miss.** Brief asked the isolated suite and a source pin. Reviewer spy: truthy `SetFont` is one stock-path call per paint on TitleText; it does not prove pixels. |
| Harness `SetFont` is a no-op; chrome keeps the `GameFontNormalHuge` template; soft `GetFont` is not pinned | **On contract.** Brief asked a source pin on `paint()`, not a client `GetFont`. The stub returns nil. |
| Success-bool fallback; `applyFont` requires a truthy `SetFont` return | **On contract.** Helper body is unchanged. Anniversary `FontString:SetFont` returns `success`. Unsmoked. Reviewer spy: nil-return tries Morpheus then FRIZQT. |
| B30-C create-path pin wording still says `TitleText stays create-only Morpheus` | **On contract.** That nest still checks the `buildFrame` apply. Paint now also applies. Brief did not require a B30-C pin rewrite. |
| Full `lua tests/run.lua` was not run | **Not a miss.** Brief asked the isolated suite. |
| OPEN_QUESTIONS #3 stays parked | **On contract.** Brief forbade a remap. Nine Bible titles stay. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

B31-INT glue is not required. The re-apply is a local call on the existing `paint()` path.

---

## Isolation / paint apply / titles

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Ranks + Store + RecordsBook. No `dofile` of Runtime / Gora / Net / Console / HUD / Decree / Toasts / Sound / MainFrame. Standalone wrap is still **11** nils (Runtime, Gora, Officer, UI, Net, DB, Sender, Minimap, Toasts, Console, Hud). Wrap is load-time only (unchanged). `runB25C()` still re-pins five of them after `runB31D()`.

**paint() apply — Pass.** Helper stays `local function applyFont`. Body is unchanged. `paint()` applies `frame.TitleText` when the leaf exists, then applies `frame.PageTitle` before `SetText`. `paint()` does not `SetText` `TitleText`. `buildFrame` still applies on mint. Reviewer spy: `Show` and each wheel turn fire one stock-path `SetFont` on TitleText (20) and PageTitle (18) when `SetFont` returns true; body / honorifics / moments stay quiet.

**PAGE_TITLES / roman / Quiet — Pass.** Nine Bible names, Bible order. No tenth page. `toRoman` still paints XIV. Chrome copy stays The Records Book. Wheel / Hide remount keep-pins stay. Quiet stays silent. No generated prose. No `MORPHEUS_CYR`.

---

## Strengths

- The leftover is closed on the existing leaf-paint path: one call when `TitleText` exists, not a second font helper and not a `paint`-level global.
- Chrome title string, page titles, roman tallies, and honorific copy were left alone. PageTitle apply stayed.
- B31-D pins nest in `runB25C()` after `runB30C()` (no new main-chunk locals). Create-path Morpheus, `PAGE_TITLES==9`, roman XIV, Hide remount, wheel, FRIZQT / GameFont, and no-`PlaySound` stay in that same nest.
- Packet does not rewrite `applyFont`, `PAGE_TITLES`, identity leaves, or B25-C / B28-C remount.
- Writer-reported **536 / 0** matched the re-run. Writer-reported red (**535 / 1**, `paint re-applies PAGE_TITLE_FONT on TitleText`) matches the one new assert old `paint()` would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Client `SetFont("Fonts\\MORPHEUS.ttf", 20)` after a later leaf turn / font reset is unsmoked.** The suite cannot prove Anniversary re-applies Morpheus on the chrome title. `wow_ui_stub` `SetFont` / `GetFont` are no-ops; chrome keeps the mint template. Brief scoped this lane to a source pin and the isolated suite. Reviewer spy proves `paint()` calls `SetFont` with the stock path; it does not prove pixels.

### Nit

1. **Source pin is a `paint()` substring, not a `SetFont` spy.** A comment inside the extract would pass. Live call is real (`applyFont(frame.TitleText, "GameFontNormalHuge", PAGE_TITLE_FONT, 20)`); reviewer spy closes the hole.

2. **Harness never invokes `SetFontObject`.** `GameFontNormalHuge` is not a live font object in `wow_ui_stub`, so `if font then` skips. Writer report says the harness always falls through to `SetFontObject(GameFont*)`. It enters that branch on a nil `SetFont` return; it does not call it. Chrome still stays `GameFontNormalHuge` because that is the `CreateFontString` template.

3. **B30-C pin message still says `TitleText stays create-only Morpheus`.** The assert still checks the `buildFrame` apply. Paint now also applies. Out of this lane's pin rewrite.

4. **Isolation wrap is load-only.** Eleven pins under `if standalone then` at file load. `runB25C()` re-pins five of them. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Records delta.** Packet is the B31-D-only `paint()` TitleText apply + nested pins. `git diff HEAD` on the two files still includes earlier vestment batches. Report already says this.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **536 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **536 passed, 0 failed.** Isolation wrap: **11**.

**Leftovers:**
- Client Anniversary `SetFont("Fonts\\MORPHEUS.ttf", 20)` after a later leaf turn / font reset is unsmoked (Important, not must-fix).
- Harness `SetFont` is a no-op; soft `GetFont` is not pinned; success-bool fallback is unproven in-game.
- Source pin is a `paint()` substring, not a `SetFont` spy.
- B30-C create-path pin wording still says TitleText is create-only.
- Isolation wrap is load-only.
- Exclusive-pair packet is not a vs-HEAD Records delta.
- Full `lua tests/run.lua` was not run.
- OPEN_QUESTIONS #3 stays parked.

When `paint()` runs and `frame.TitleText` exists, it calls `applyFont(frame.TitleText, "GameFontNormalHuge", PAGE_TITLE_FONT, 20)`. Chrome copy stays `"The Records Book"`. PageTitle apply stays. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. FRIZQT / GameFont fallback stays. `PAGE_TITLES` stay 9. No category remap. No generated prose. Pins live in `runB25C()` after `runB30C()`. Isolated `lua tests/test_records.lua` **536 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
