Spec PASS

# B25-D — HUD re-applies Morpheus on Refresh (review)

**Quality:** Approved-with-nits

**Lane:** B25-D HUD re-applies Morpheus on Refresh
**Brief:** `docs/reformation/vestments/briefs/B25-D-hud-font-refresh.md`
**Writer report:** `docs/reformation/vestments/briefs/B25-D-hud-font-refresh-report.md`
**Diff:** `docs/reformation/vestments/briefs/B25-D-hud-font-refresh.diff` (B25-D-only exclusive-pair packet; live `Hud.lua` also carries earlier HUD batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Hud.lua` (`applyNameFont`, `paintShown`, `paintHidden`, `build`, `Refresh`), and `tests/test_hud.lua` (B22-B `do` block + nested B25-D source pins, isolation wrap, existing persist / lastPair / `1-0` / health-nil / Morpheus path pins); then ran `lua tests/test_hud.lua` (**747 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §19.3 / license 4 stock only; Law 10 (theatrical names); B22-B leftover (`applyNameFont` only in `build()`); when `Refresh` paints a shown pair, `paintShown` calls `applyNameFont` on `nameA` / `nameB`; hidden Refresh does not need it; `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`; fallback `GameFontHighlight` stays; no `MORPHEUS_CYR`; `health` stays nil; no `UnitHealth`; B16-C / B17-D / B19-C / B21-B gates stay. Did not mutate `Hud.lua` or `test_hud.lua`. Did not commit. Did not edit Gora, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `applyNameFont` still runs only in `build()` (B22-B leftover) | **Pass. Verified.** Live `paintShown` calls `applyNameFont(frame.nameA)` and `applyNameFont(frame.nameB)` before `frame:Show()`. `Refresh` reaches that path via `paintShown(pair)` when `displayPair()` returns a pair. Source pin extracts the `paintShown` body and requires `applyNameFont` inside it; `build()` still contains the mint apply. Reviewer spy: first shown `Refresh` after mint is two `SetFont` calls (`nameA` / `nameB`); a second shown `Refresh` is two more. Titles / records / defenses / vs / favor are not in that list. |
| Helper move above `paintShown` leaked a global | **Pass. Verified.** Live definition is `local function applyNameFont`. `_G.applyNameFont`, `_G.paintShown`, and `_G.NAME_FONT` are nil after load. `debug.getupvalue`: `applyNameFont` is an upvalue of `paintShown`, not of `Refresh` and not of `paintHidden`. |
| Hidden Refresh is required to re-apply, or incorrectly does | **Pass.** Brief says hidden Refresh does not need it. `paintHidden` body has no `applyNameFont`. `Refresh` hidden arms (`not eventLive()`, no `displayPair`) call `paintHidden` only. Reviewer spy: QUIET `Refresh` after `Init` is 0 `SetFont`; `EndEvent` then `Refresh` is 0 `SetFont`. |
| `NAME_FONT` / fallback / `MORPHEUS_CYR` changed | **Pass.** `NAME_FONT` is still `Fonts\\MORPHEUS.ttf`. Helper body is the B22-B `pcall` `SetFont(NAME_FONT, 14)` plus `SetFontObject(GameFontHighlight)` fallback. Source has no `MORPHEUS_CYR`, `MORPHEUS.TTF`, other `.ttf`, `Media\\`, `.tga`, or `.blp`. Reviewer spy paths are `Fonts\MORPHEUS.ttf` size 14. |
| `health` no longer nil / `UnitHealth` scrape | **Pass.** `hiddenView` and shown `lastView` still set `health = nil`. Source has no `UnitHealth`, `UnitHealthMax`, `UnitIsDead`, combat-log, or nameplate scrape. `Hud.GetHealth` / `Hud.ScrapeHealth` stay nil. Existing persist / lastPair / `1-0` / health-nil pins stay and pass. Reviewer probe: shown, Gora CONSEQUENCE, Quiet hide, and Knighting hide views stay `health` nil. |
| B16-C / B17-D / B19-C / B21-B gates rewritten | **Pass.** Packet does not touch `livePair` / `pickPair` / `displayPair`. Live source still has exactly two `state == "RITE" and snap.riteType == "Gora"` compares and the lastPair `RITE` or `CONSEQUENCE` + `riteType ~= "Gora"` refuse. Existing suite pins stay and pass. Reviewer probe: Gora CONSEQUENCE still shown; Knighting RITE / CONSEQUENCE still hidden. |
| New main-chunk locals / pins not nested in the B22-B `do` block | **Pass.** Six new source asserts sit inside the existing B22-B `do` block. Packet adds no main-chunk `local`. Header comment only at file top. |
| Isolated suite not exit 0 | **Pass. Verified.** 747 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Provided packet is two `diff --git` hunks: `UI/Hud.lua` and `tests/test_hud.lua`. Live helper move + `paintShown` apply + nested pins match that slice. Sibling dirt in this workspace is other lanes (earlier HUD batches vs HEAD). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Gora / glue; no commit | **Pass.** Named-risk check. |
| Isolation wrap stays | **Pass.** Load list is still `wow_ui_stub` + Common + Ranks + Store + Runtime + Gora + Hud. Standalone wrap is still **13** nil-module pins under `if standalone then`. |
| When `Refresh` paints a shown pair, call `applyNameFont` on `nameA` and `nameB` | **Pass.** Named-risk check. Shown path is `Refresh` → `paintShown` → local helper. |
| Hidden Refresh does not need apply | **Pass.** Named-risk check. |
| Helper move above `paintShown` stays a local (not a global) | **Pass.** Named-risk check. |
| `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`; fallback `GameFontHighlight` stays; no `MORPHEUS_CYR` | **Pass.** Named-risk check. |
| `health` stays nil; no `UnitHealth` | **Pass.** Named-risk check. |
| B16-C / B17-D / B19-C / B21-B gates stay | **Pass.** Named-risk check. |
| Source pin: `applyNameFont` from `Refresh` / `paintShown` (not only `build`); persist / lastPair / `1-0` / health-nil / Morpheus path pins stay; nest if the 200-local cap is tight | **Pass.** Nested in the B22-B `do` block. `build()` still applies on mint. Existing pins stay. |
| Favor W-F intact; dress stays stock | **Pass.** Packet is header comments + helper move + two `paintShown` applies + nested pins. `resolveFavor` and stock iron/parchment are untouched. |
| `lua tests/test_hud.lua` exit 0 | **Pass.** **747 / 0.** |

Bible §19.3 / license 4 (stock FrameXML Morpheus, not custom Media) and Law 10 (theatrical names) hold on the exclusive pair: names still mint as `GameFontHighlight` and try `Fonts\\MORPHEUS.ttf`, and a later shown `Refresh` re-applies that try. Mute rails stay textures. A01 stays NOT RUN.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Harness `SetFont` is a no-op; names keep the `GameFontHighlight` template; soft `GetFont` is not pinned | **On contract.** Brief asked a source pin on `Refresh` / `paintShown`, not a client `GetFont`. Reviewer spy: shown `Refresh` invokes `SetFont` twice with the stock path; the stub returns nil. |
| Success-bool fallback; missing file on 20506 stays GameFontHighlight | **On contract.** Helper body is unchanged from B22-B. Anniversary `FontString:SetFont` returns `success`. Unsmoked. |
| No client / `/reload` smoke; full `lua tests/run.lua` not run; A01 still NOT RUN | **Not a miss.** Brief asked the isolated suite and forbade `UnitHealth`. `health` stays nil. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

B25-INT glue is not required. The re-apply is a local call on the shown paint path.

---

## Isolation / applyNameFont / hidden Refresh

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Ranks + Store + Runtime + Gora + Hud. No `dofile` of Net / Snapshot / Knighting / Console. **13** nil-module pins stay under the first `if standalone then` (Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console). Wrap was not rewritten. Reviewer probe: those keys are nil at load.

**applyNameFont / shown Refresh — Pass.** Helper was moved above `paintShown` so the call is the local, not a global lookup. Body is unchanged: `pcall` `SetFont(NAME_FONT, 14)`; truthy return required; else `SetFontObject(GameFontHighlight)`. `paintShown` applies only `nameA` / `nameB` after the shown `lastView` write (`health = nil`) and before `Show()`. `build()` still applies on mint. `Refresh` does not name the helper; it calls `paintShown` when a pair is shown. Reviewer spy: two shown refreshes each fire two stock-path `SetFont`s; title / record / defense / vs / favor spies stay quiet.

**Hidden / gates / health — Pass.** `paintHidden` does not re-apply. QUIET and `EndEvent` refreshes do not call `SetFont`. `livePair` and `pickPair` still require Gora RITE for the runtime arm. `displayPair` lastPair refuse still covers non-Gora RITE and CONSEQUENCE. Gora CONSEQUENCE persist stays shown and still re-applies. `health` stays nil. No `UnitHealth`.

---

## Strengths

- The leftover is closed on the existing shown paint path: two calls before `Show()`, not a second font helper and not a `Refresh`-level global.
- Moving the local above `paintShown` is the Lua 5.1 scope fix. `_G.applyNameFont` stays nil. Hidden paint does not gain an apply.
- B25-D pins nest in the B22-B `do` block (no new main-chunk locals). `build()` apply, Morpheus path, `MORPHEUS_CYR` refuse, and `SetFontObject` fallback stay in that same block.
- Packet does not rewrite persist, favor, dress, or the four Gora-RITE / lastPair gates. `health = nil` stays on both views.
- Writer-reported **747 / 0** matched the re-run. Writer-reported red (**746 / 1**, `paintShown re-applies name font on a shown pair`) matches the one new assert old `paintShown` would fail. Net +6 suite asserts versus B22-B **741** is the nested existence / body / `build()` keep pins.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Client `SetFont("Fonts\\MORPHEUS.ttf", 14)` after a later Refresh is unsmoked.** The suite cannot prove Anniversary re-applies Morpheus. `wow_ui_stub` `SetFont` / `GetFont` are no-ops; names keep the mint template. Brief scoped this lane to a source pin and the isolated suite. Reviewer spy proves shown `Refresh` calls `SetFont` twice with the stock path; it does not prove pixels.

### Nit

1. **Source pin is a `paintShown` substring, not a `Refresh` body pin and not a `SetFont` spy.** `Refresh` itself has no `applyNameFont` token; it calls `paintShown`. A comment inside `paintShown` would pass the extract. Live calls are real; reviewer spy closes the hole.

2. **Harness never invokes `SetFontObject`.** `GameFontHighlight` is nil in `wow_ui_stub`, so `if font then` skips. Writer report says the harness always falls through to `SetFontObject(GameFontHighlight)`. It enters that branch; it does not call it. Names still stay `GameFontHighlight` because that is the `CreateFontString` template.

3. **Header extra `)`.** `+ B25-D Refresh/paintShown re-applies applyNameFont). Isolated:`

4. **Isolation wrap is load-only.** Thirteen pins under `if standalone then` at file load. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Hud delta.** Packet is the B25-D-only helper move + `paintShown` apply + nested pins. `git diff HEAD` on the two files still includes earlier HUD batches. Report already says this.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **747 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **747 passed, 0 failed.** Isolation wrap: **13**.

When `Refresh` paints a shown pair, `paintShown` calls local `applyNameFont` on `nameA` / `nameB`. Hidden Refresh does not. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. Fallback `GameFontHighlight` stays. No `MORPHEUS_CYR`. `health` stays nil. B16-C / B17-D / B19-C / B21-B gates stay. Isolation stays `wow_ui_stub` + Common + Ranks + Store + Runtime + Gora + Hud. Isolated `lua tests/test_hud.lua` **747 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
