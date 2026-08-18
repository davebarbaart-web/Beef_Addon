Spec PASS

# B22-B — HUD fighter names use FrameXML Morpheus casing (review)

**Quality:** Approved-with-nits

**Lane:** B22-B HUD fighter names use FrameXML Morpheus casing
**Brief:** `docs/reformation/vestments/briefs/B22-B-hud-font.md`
**Writer report:** `docs/reformation/vestments/briefs/B22-B-hud-font-report.md`
**Diff:** `docs/reformation/vestments/briefs/B22-B-hud-font.diff` (B22-B-only exclusive-pair packet; live `Hud.lua` also carries earlier HUD batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Hud.lua` (`NAME_FONT`, `applyNameFont`, `nameA` / `nameB` mint), and `tests/test_hud.lua` (nested Morpheus source pins, template keep-pins, existing persist / Gora-RITE / lastPair / `1-0` / health-nil pins); then ran `lua tests/test_hud.lua` (**741 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §19.3 / license 4 stock only; Law 10 (theatrical names); `nameA` / `nameB` try `Fonts\\MORPHEUS.ttf`; fallback `GameFontHighlight`; no `MORPHEUS_CYR`; `health` nil; B16-C / B17-D / B19-C / B21-B gates stay. Did not mutate `Hud.lua` or `test_hud.lua`. Did not commit. Did not edit Gora, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `nameA` / `nameB` miss `Fonts\\MORPHEUS.ttf` or use `MORPHEUS.TTF` | **Pass. Verified.** Live `NAME_FONT = "Fonts\\MORPHEUS.ttf"`. `applyNameFont` `pcall`s `SetFont(NAME_FONT, 14)` only. Source pin finds `Fonts\\MORPHEUS.ttf`; refuse `MORPHEUS.TTF`. Reviewer probe: build-time `SetFont` fires twice, both `Fonts\MORPHEUS.ttf` size 14 on `GameFontHighlight` templates. |
| `MORPHEUS_CYR` / GlueFonts / custom Media | **Pass.** Source has no `MORPHEUS_CYR`, `Media\\`, `.tga`, or `.blp`. After stripping the stock path, no other `.ttf` remains. No new Media files. |
| Titles / records / defenses / vs / favor also take Morpheus | **Pass.** `applyNameFont` is called only on `nameA` / `nameB`. Titles, records, defenses, vs, and favor stay `GameFont*`. Reviewer probe: `SetFont` count is 2; `titleA` / `recordA` / `defenseA` / `vs` / `favorLabel` stay their mint templates. |
| Fallback is not `SetFontObject(GameFontHighlight)` | **Pass.** Failed / nil `SetFont` falls through to `SetFontObject(GameFontHighlight)` (string-or-global, then `pcall`). Names still mint as `GameFontHighlight`. Suite template pins stay. Anniversary `FontString:SetFont` returns `success`; the `ok and applied` house pattern matches Decree / Toasts / FighterCard. |
| `health` no longer nil / `UnitHealth` scrape | **Pass.** `hiddenView` and shown view still set `health = nil`. Source has no `UnitHealth`, `UnitHealthMax`, `UnitIsDead`, combat-log, or nameplate scrape. Suite `GetHealth` / `ScrapeHealth` stay nil. Persist / lastPair / rebuild pins stay `health` nil. Reviewer probe: view `health` nil through Gora CONSEQUENCE and Knighting hide. |
| B16-C / B17-D / B19-C / B21-B gates rewritten | **Pass.** Packet does not touch `livePair` / `pickPair` / `displayPair`. Live source still has exactly two `state == "RITE" and snap.riteType == "Gora"` compares and the lastPair `RITE` or `CONSEQUENCE` + `riteType ~= "Gora"` refuse. Existing suite pins stay and pass. Reviewer probe: Gora CONSEQUENCE still shown; Knighting RITE / CONSEQUENCE still hidden. |
| Favor W-F / dress / drag-persist rewritten | **Pass.** Packet is header comments + `NAME_FONT` + `applyNameFont` + two apply calls + suite pins. `resolveFavor`, stock iron/parchment, and `savePoint` OnDragStop are untouched. `countStatusBars` stays 2. |
| Isolated suite not exit 0 | **Pass. Verified.** 741 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Provided packet is two `diff --git` hunks: `UI/Hud.lua` and `tests/test_hud.lua`. Live `NAME_FONT` / `applyNameFont` match that slice. Sibling dirt in this workspace is other lanes (Gora, Console, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Gora, glue; no commit; no `UnitHealth` | **Pass.** Named-risk check. |
| `NAME_FONT = "Fonts\\MORPHEUS.ttf"`; apply only to `nameA` / `nameB` via pcall `SetFont` (size 14 or 16) | **Pass.** Size is 14. Probe: two `SetFont` calls, both that path and size. |
| Fallback `SetFontObject(GameFontHighlight)` when `SetFont` fails | **Pass.** Named-risk check. |
| Titles, records, defenses, vs, favor stay GameFont | **Pass.** Named-risk check. New template pins cover those five surfaces. |
| Do not use `MORPHEUS_CYR`; refuse `MORPHEUS.TTF` | **Pass.** Source pins + live grep. |
| `health` stays nil; lastPair CONSEQUENCE gate stays; no drag-persist rewrite | **Pass.** Named-risk check. |
| Source pin for `Fonts\\MORPHEUS.ttf`; existing persist / Gora-RITE / lastPair / `1-0` / health-nil pins stay; isolation wrap stays; nest new pins if the 200-local cap is tight | **Pass.** Morpheus pins sit in a `do` block (no new main-chunk locals). Isolation wrap stays **13**. `1-0` record / head-to-head pins stay. |
| Dress stays stock; Favor W-F intact; B16-C / B17-D / B19-C / B21-B gates stay | **Pass.** Named-risk check. |
| `lua tests/test_hud.lua` exit 0 | **Pass.** **741 / 0.** |

Bible §19.3 / license 4 (stock FrameXML Morpheus, not custom Media) and Law 10 (theatrical names) hold on the exclusive pair. Names still mint as `GameFontHighlight` and try `Fonts\\MORPHEUS.ttf`. Mute rails stay textures. A01 stays NOT RUN.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Harness `SetFont` is a no-op; names keep the `GameFontHighlight` template; soft `GetFont` is not pinned | **On contract.** Brief asked a source pin, not a client `GetFont`. Reviewer spy: `SetFont` is invoked twice; the stub returns nil. |
| Success-bool fallback; missing file on 20506 stays GameFontHighlight | **On contract.** Anniversary `FontString:SetFont` returns `success`. House pattern matches FighterCard / Decree / Toasts. Unsmoked. |
| No client / `/reload` smoke; full `lua tests/run.lua` not run; A01 still NOT RUN | **Not a miss.** Brief asked the isolated suite and forbade `UnitHealth`. `health` stays nil. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

B22-INT glue is not required. `applyNameFont` runs at `build()` only; Refresh still `SetText`.

---

## Isolation / NAME_FONT / gates

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Ranks + Store + Runtime + Gora + Hud. No `dofile` of Net / Snapshot / Knighting / Console. **13** nil-module pins stay under the first `if standalone then` (Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console). Wrap was not rewritten. Reviewer probe: those keys are nil at load.

**NAME_FONT / applyNameFont — Pass.** Constant is the FrameXML lowercase path. Helper `pcall`s `SetFont` size 14 with flags omitted (Anniversary flags are optional). `used` requires a truthy `SetFont` return; otherwise `SetFontObject(GameFontHighlight)`. Applied only to `nameA` / `nameB` after they mint as `GameFontHighlight`. Titles / records / defenses / vs / favor / levels / pct / head-to-head stay GameFont. No `MORPHEUS_CYR`.

**Gates / health — Pass.** `livePair` and `pickPair` still require Gora RITE for the runtime arm. `displayPair` lastPair refuse still covers non-Gora RITE and CONSEQUENCE. Gora CONSEQUENCE and ASSEMBLY Continue persist stay. `health` stays nil. No `UnitHealth`. No `UnitIsDead`. `savePoint` is unchanged.

---

## Strengths

- The helper is fourteen lines next to `makeLabel` and is called only on the two fighter names. Failed `SetFont` cannot touch titles or favor.
- Path casing matches Decree / Toasts / Records / FighterCard (`Fonts\\MORPHEUS.ttf`). Size 14 is in the brief's 14-or-16 window. Fallback object is the mint template.
- Source pins refuse `MORPHEUS.TTF` and `MORPHEUS_CYR`, then strip the stock path before the custom-font grep. New Morpheus asserts are nested; isolation wrap and gate pins were left in place.
- Packet does not rewrite persist, favor, dress, or drag. `health = nil` stays on both views.
- Writer-reported **741 / 0** matched the re-run. Writer-reported red count (**739 / 2**) matches the two asserts old Hud.lua would fail (missing `Fonts\\MORPHEUS.ttf` and missing `SetFontObject`). Net +12 suite asserts versus B21-B **729** is the replaced `.ttf` refuse plus the nested Morpheus block plus the eight template keep-pins.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Client `SetFont("Fonts\\MORPHEUS.ttf", 14)` is unsmoked.** The suite cannot prove Anniversary applies Morpheus. `wow_ui_stub` `SetFont` / `GetFont` are no-ops; names keep the mint template. Brief scoped this lane to source pins and the isolated suite. Reviewer spy proves the helper is called twice with the stock path; it does not prove pixels.

### Nit

1. **Harness never invokes `SetFontObject`.** `GameFontHighlight` is nil in `wow_ui_stub`, so `if font then` skips. Writer report says the harness always falls through to `SetFontObject(GameFontHighlight)`. It enters that branch; it does not call it. Names still stay `GameFontHighlight` because that is the `CreateFontString` template.

2. **Flags omitted.** FighterCard / Decree pass `""`. Toasts omit flags the same way. Anniversary `FontString:SetFont` treats flags as optional. A 2-arg error would `pcall` into the fallback.

3. **Template keep-pins do not prove Morpheus.** They prove mint objects. Soft `GetFont` is unpinned. Brief asked source pins.

4. **`applyNameFont` runs only in `build()`.** Refresh paints text and tint. A later font reset would not re-apply. Brief did not ask a Refresh rebind.

5. **level / pct / head-to-head GameFont are unpinned.** Brief named titles, records, defenses, vs, and favor. Probe: those three stay `GameFontNormal` and do not receive `SetFont`.

6. **Exclusive-pair diff is not a vs-HEAD Hud delta.** Packet is the B22-B-only font helper + pins. `git diff HEAD` on the two files still includes earlier HUD batches. Report already says this.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **741 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **741 passed, 0 failed.** Isolation wrap: **13**.

`nameA` / `nameB` mint as `GameFontHighlight` and try `Fonts\\MORPHEUS.ttf` size 14 via `pcall` `SetFont`. Fallback is `SetFontObject(GameFontHighlight)`. Titles, records, defenses, vs, and favor stay GameFont. No `MORPHEUS_CYR`. `health` stays nil. B16-C / B17-D / B19-C / B21-B gates stay. Isolation stays `wow_ui_stub` + Common + Ranks + Store + Runtime + Gora + Hud. Isolated `lua tests/test_hud.lua` **741 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
