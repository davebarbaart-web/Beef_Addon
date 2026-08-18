Spec PASS

# B30-C — Records paint re-applies Morpheus on the page title (review)

**Quality:** Approved-with-nits

**Lane:** B30-C Records paint re-applies Morpheus on the page title
**Brief:** `docs/reformation/vestments/briefs/B30-C-records-font.md`
**Writer report:** `docs/reformation/vestments/briefs/B30-C-records-font-report.md`
**Diff:** `docs/reformation/vestments/briefs/B30-C-records-font.diff` (B30-C-only exclusive-pair packet; live `RecordsBook.lua` / `test_records.lua` also carry earlier Records Book batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/RecordsBook.lua` (`paint()` ~538, `applyFont`, `PAGE_TITLE_FONT`, `buildFrame` title / page-title apply, `PAGE_TITLES`, `bodyText` / `localHonorifics` / `momentLines`, `turn` / wheel), and `tests/test_records.lua` (isolation wrap, B25-C Init remount, nested `runB28C()` Hide remount, nested `runB30C()` after `runB28C()`, page / wheel / roman / Morpheus create-path pins); then ran `lua tests/test_records.lua` (**511 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §19.3 / license 4 stock only; Law 10 / Law 6 (theatrical parchment; player-opened Quiet identity/history; no Hide / paint sound); B28 leftover (`applyFont(..., PAGE_TITLE_FONT, 18)` only in `buildFrame`); when `paint()` writes `frame.PageTitle`, call `applyFont(frame.PageTitle, "GameFontNormalLarge", PAGE_TITLE_FONT, 18)` first; `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`; FRIZQT / GameFont fallback stays; TitleText may stay create-only; no category remap (#3); no generated prose. Isolation wow_ui_stub + Common + Ranks + Store + RecordsBook only. Did not mutate `RecordsBook.lua` or `test_records.lua`. Did not commit. Did not edit Decree, Toasts, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `applyFont(..., PAGE_TITLE_FONT, 18)` still runs only in `buildFrame` (B28 leftover) | **Pass. Verified.** Live `paint()` calls `applyFont(frame.PageTitle, "GameFontNormalLarge", PAGE_TITLE_FONT, 18)` immediately before `PageTitle:SetText`. `debug.getupvalue`: `paint` is an upvalue of `Show`; `applyFont` and `PAGE_TITLE_FONT` (`Fonts\MORPHEUS.ttf`) are upvalues of `paint`. Reviewer spy (truthy `SetFont`): mint then wrap, first `Show` is **1** `SetFont` on `PageTitle` (`Fonts\MORPHEUS.ttf`, size 18); each later wheel turn is one more. `TitleText` / `Body` / `Honorifics` / `Moments` stay **0**. |
| Missing apply, or apply after `SetText`, or apply on TitleText | **Pass.** Brief requires apply first when `paint()` writes `PageTitle`. Live order is apply then `SetText`. `paint()` body has no `TitleText`. Source pin extracts `paint()` through `turn(` and requires that call before `SetText`, and refuses `TitleText` in the extract. `buildFrame` still applies Morpheus on mint (`title` 20 / `pageTitle` 18). |
| `PAGE_TITLES` remapped / generated prose / honorific or roman copy changed | **Pass.** Live table is still the nine Bible names in Bible order. `GetPages()` is 9; titles match the Bible list. Packet does not touch `PAGE_TITLES`, `bodyText`, `localHonorifics`, `momentLines`, or `toRoman`. `toRoman(14)` is still `XIV`. Source still refuses `ordained` / `folk hero` / `This is not hatred` / `on this day` / `unrecognized`. `MODE` is still `QUIET`. |
| `PAGE_TITLE_FONT` / `applyFont` fallback / `MORPHEUS_CYR` changed | **Pass.** `PAGE_TITLE_FONT` is still `Fonts\\MORPHEUS.ttf`. Helper body is unchanged: `pcall` `SetFont(path, size)`; truthy return required; FRIZQT when `path ~= FALLBACK_TITLE_FONT`; else `SetFontObject(GameFont*)`. Source has no `MORPHEUS_CYR`, `MORPHEUS.TTF`, `Media\\`, `.tga`, or `.blp`. Reviewer spy paths are `Fonts\MORPHEUS.ttf` size 18 on success; nil-return then also tries `Fonts\FRIZQT__.TTF` size 18. |
| Existing Hide remount / wheel / Init remount / isolation pins drop | **Pass.** Those blocks sit above or beside the B30-C nest inside `runB25C()`. Isolation wrap is still **11** nil-module pins under `if standalone then` at file load. Suite green includes those asserts. `runB25C()` still re-pins Runtime / UI / Toasts / Console / Hud (**5**) after `runB30C()`. |
| Isolated suite not exit 0 / pins not nested after `runB28C()` | **Pass. Verified.** 511 passed, 0 failed. Writer-reported count matches. `runB30C()` is a nested `local function` inside `runB25C()` after `runB28C()`. Packet adds no main-chunk `local`. Header comment only at file top. `luac -l -p`: main chunk **123** locals (cap 200). RecordsBook file locals stay **44**. |
| Exclusive file breach | **Pass.** Provided packet is two `diff --git` hunks: `UI/RecordsBook.lua` (one apply before `SetText`) and `tests/test_records.lua` (header + nested `runB30C()`). Sibling dirt vs HEAD (Decree, Toasts, MainFrame, Console, TOC, bootstrap, `run.lua`) is other lanes, not this packet. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Decree / Toasts / glue; no commit | **Pass.** Named-risk check. |
| Isolation wrap stays | **Pass.** Load list is still stub + Common + Ranks + Store + RecordsBook. Wrap is still **11** nils under `if standalone then`. Reviewer probe: those keys are nil at load. |
| When `paint()` writes `frame.PageTitle`, call `applyFont(frame.PageTitle, "GameFontNormalLarge", PAGE_TITLE_FONT, 18)` first | **Pass.** Named-risk check. Live call is before `SetText`. `Show` / `turn` / wheel all reach that path. |
| Do not change page titles, roman tallies, or honorific copy | **Pass.** Named-risk check. First leaf after `Show` is still Most Sanctioned Victories. Chrome title stays The Records Book. |
| Book chrome `TitleText` may stay create-only | **Pass.** `paint()` does not restyle `TitleText`. `buildFrame` still applies Morpheus 20 on mint. Reviewer spy: `TitleText` `SetFont` stays 0 on Show and leaf turns. |
| `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`; FRIZQT / GameFont fallback stays | **Pass.** Named-risk check. |
| No category remap (#3); no generated prose; no custom media | **Pass.** Named-risk check. |
| Nest after `runB28C()`; source pin: `paint()` contains `applyFont` with `PAGE_TITLE_FONT`; wheel / Hide remount / Morpheus create-path / isolation stay | **Pass.** Nested after B28-C. Create-path apply, `PAGE_TITLES==9`, roman XIV, Hide remount, wheel, FRIZQT, `SetFontObject`, no `MORPHEUS_CYR` stay in that nest. |
| `lua tests/test_records.lua` exit 0 | **Pass.** **511 / 0.** |

Bible §19.3 / license 4 (stock FrameXML Morpheus, not custom Media) and Law 10 (theatrical Records parchment) hold on the exclusive pair: the leaf title still mints as `GameFontNormalLarge` and tries `Fonts\\MORPHEUS.ttf`, and a later `paint()` re-applies that try. Law 6 holds: Quiet identity/history stays silent (`PlaySound` absent; paint stays silent). OPEN_QUESTIONS #3 is not answered here.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Harness `SetFont` is a no-op; page titles keep the `GameFontNormalLarge` template; soft `GetFont` is not pinned | **On contract.** Brief asked a source pin on `paint()`, not a client `GetFont`. Reviewer spy: truthy `SetFont` is one stock-path call per paint; the stub returns nil. |
| Success-bool fallback; `applyFont` requires a truthy `SetFont` return | **On contract.** Helper body is unchanged. Anniversary `FontString:SetFont` returns `success`. Unsmoked. Reviewer spy: nil-return tries Morpheus then FRIZQT. |
| `TitleText` stays create-only | **On contract.** Brief allowed it. |
| No client / `/reload` smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| OPEN_QUESTIONS #3 stays parked | **On contract.** Brief forbade a remap. Nine Bible titles stay. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

B30-INT glue is not required. The re-apply is a local call on the existing `paint()` path.

---

## Isolation / paint apply / titles

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Ranks + Store + RecordsBook. No `dofile` of Runtime / Gora / Net / Console / HUD / Decree / Toasts / Sound / MainFrame. Standalone wrap is still **11** nils (Runtime, Gora, Officer, UI, Net, DB, Sender, Minimap, Toasts, Console, Hud). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). `runB25C()` still re-pins five of them after `runB30C()`.

**paint() apply — Pass.** Helper stays `local function applyFont`. Body is unchanged. `paint()` applies only `frame.PageTitle` before `SetText` and does not restyle `TitleText`. `buildFrame` still applies on mint. Reviewer spy: `Show` and each wheel turn fire one stock-path `SetFont` on `PageTitle` when `SetFont` returns true; chrome / body / honorifics / moments stay quiet.

**PAGE_TITLES / roman / Quiet — Pass.** Nine Bible names, Bible order. No tenth page. `toRoman` still paints XIV. Wheel / Hide remount keep-pins stay. Quiet stays silent. No generated prose. No `MORPHEUS_CYR`.

---

## Strengths

- The leftover is closed on the existing leaf-paint path: one call before `SetText`, not a second font helper and not a `paint`-level global.
- `TitleText` stays create-only. Page titles, roman tallies, and honorific copy were left alone.
- B30-C pins nest in `runB25C()` after `runB28C()` (no new main-chunk locals). Create-path Morpheus, `PAGE_TITLES==9`, roman XIV, Hide remount, wheel, FRIZQT / GameFont, and no-`PlaySound` stay in that same nest.
- Packet does not rewrite `applyFont`, `PAGE_TITLES`, identity leaves, or B25-C / B28-C remount.
- Writer-reported **511 / 0** matched the re-run. Writer-reported red (**510 / 1**, `paint re-applies PAGE_TITLE_FONT on PageTitle before SetText`) matches the one new assert old `paint()` would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Client `SetFont("Fonts\\MORPHEUS.ttf", 18)` after a later leaf turn / font reset is unsmoked.** The suite cannot prove Anniversary re-applies Morpheus. `wow_ui_stub` `SetFont` / `GetFont` are no-ops; page titles keep the mint template. Brief scoped this lane to a source pin and the isolated suite. Reviewer spy proves `paint()` calls `SetFont` with the stock path; it does not prove pixels.

### Nit

1. **Source pin is a `paint()` substring, not a `SetFont` spy.** A comment inside the extract would pass. Live call is real (`applyFont(frame.PageTitle, "GameFontNormalLarge", PAGE_TITLE_FONT, 18)` before `SetText`); reviewer spy closes the hole.

2. **Harness never invokes `SetFontObject`.** `GameFontNormalLarge` is not a live font object in `wow_ui_stub`, so `if font then` skips. Writer report says the harness always falls through to `SetFontObject(GameFontNormalLarge)`. It enters that branch on a nil `SetFont` return; it does not call it. Page titles still stay `GameFontNormalLarge` because that is the `CreateFontString` template.

3. **`TitleText` stays create-only.** A later chrome-title font reset would not re-apply on paint. Brief allowed this.

4. **Isolation wrap is load-only.** Eleven pins under `if standalone then` at file load. `runB25C()` re-pins five of them. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Records delta.** Packet is the B30-C-only `paint()` apply + nested pins. `git diff HEAD` on the two files still includes earlier vestment batches. Report already says this.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **511 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **511 passed, 0 failed.** Isolation wrap: **11**.

**Leftovers:**
- Client Anniversary `SetFont("Fonts\\MORPHEUS.ttf", 18)` after a later leaf turn / font reset is unsmoked (Important, not must-fix).
- Harness `SetFont` is a no-op; soft `GetFont` is not pinned; success-bool fallback is unproven in-game.
- `TitleText` stays create-only (allowed).
- Source pin is a `paint()` substring, not a `SetFont` spy.
- Isolation wrap is load-only.
- Exclusive-pair packet is not a vs-HEAD Records delta.
- Full `lua tests/run.lua` was not run.
- OPEN_QUESTIONS #3 stays parked.

When `paint()` writes `frame.PageTitle`, it calls `applyFont(frame.PageTitle, "GameFontNormalLarge", PAGE_TITLE_FONT, 18)` before `SetText`. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. FRIZQT / GameFont fallback stays. TitleText stays create-only. `PAGE_TITLES` stay 9. No category remap. No generated prose. Pins live in `runB25C()` after `runB28C()`. Isolated `lua tests/test_records.lua` **511 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
