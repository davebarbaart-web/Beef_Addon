# Pope's Desk / Director Console rework

**Status:** Implemented (harness green). Client `/reload` smoke is the remaining human gate.  
**POLISH:CANDIDATE** — do not treat this as POLISH:PASS.  
**Source directive:** `CHURCH_OF_BEEF_POPES_DESK_DIRECTOR_CONSOLE_REWORK_HANDOFF.md`  
**Date:** 2026-09-14

The desk is still named **Director Console** in chrome (`/beef console`). Conceptually it is the Pope's Desk: a state-driven production console, not a stacked admin form.

---

## 1. Architecture inventory

Canonical ceremony state stays in Core. The desk paints a **view-model**. Widget visibility is never the source of truth.

| Layer | Keeper | Role |
|-------|--------|------|
| Runtime | `Core/Runtime.lua` | QUIET → ASSEMBLY → RITE (typed) → CONSEQUENCE. Pope client owns transitions. |
| Gora | `Core/Gora.lua` | Sanction, petitions, favor picks/split, verdicts (victor / cowardice / void / free). |
| Knighting | `Core/Knighting.lua` | Line, Knight This Beef, Elevate to Lord. |
| Store | `Core/Store.lua` | Characters, humans, ranks, ceremony log, marked moments. |
| Decree | `Core/Decree.lua` | Posted `line` + `flavor` only. |
| Records | `Core/Records.lua` | Chronicle preview when loaded. |
| Roster | `Core/Roster.lua` | Guild walk; census / presence rows. |
| Sender | `Core/Sender.lua` + `Data/Popes.lua` | Registered Pope gate. |
| Desk | `UI/Console.lua` | View-model, tabs, verbs. UI → Core only. No theater, no wire. |

`Console:GetDeskState()` returns a copy of `deskView()`:

```text
tab            gathering | decrees | chronicle | church
gathering      inactive | active     (Runtime ≠ QUIET)
rite           nil | knighting | gora | other
goraPhase      nil | setup | sanctioned | complete
knightingPhase nil | live | complete
```

Session (UI-only; not a Core schema):

- `deskTab`
- `candidateLocked` / `fightersLocked`
- `selectedWinnerId` / `selectedOutcome` / `lastVerdict`
- `knightingComplete`
- `pendingConfirm`
- `gatheringStartedAt` (also `ChurchOfBeefDB.ui.console.gatheringStartedAt`)
- `decreeBusy`
- `targetPreview`

**Target ≠ ceremony selection.** `PLAYER_TARGET_CHANGED` always refreshes `targetPreview`. It does not overwrite the working subject when `candidateLocked`. `fightersLocked` blocks Fighter A/B changes only; DECLARE VICTOR can still use the live target.

---

## 2. Control behavior audit

Existing verbs kept. New desk verbs wrap safety; Core APIs (`EndEvent`, `CloseRite`, `DeclareVictor`, …) are unchanged.

### Gathering

| Control | Behavior |
|---------|----------|
| Start the gathering | `Runtime:StartEvent()`. Session resets (fighters, locks, verdict). |
| End the gathering | Button calls `RequestEndGathering`. Confirms if a rite is open or a Gora is sanctioned with no verdict. `EndEvent` itself is unchanged. |
| Open a Knighting rite | `OpenRite("Knighting")`. Locks the candidate if one is resolved. |
| Open a Gora rite | `OpenRite("Gora")`. |

### Decree (Decrees tab only)

| Control | Behavior |
|---------|----------|
| Headline / Proclamation | Stored fields remain `line` / `flavor`. |
| Post the Decree | `Decree:Set`. Busy flag blocks double-click. |
| Withdraw | `Decree:Clear`. |

### Knighting

| Control | Behavior |
|---------|----------|
| Select as candidate | Locks the current target/subject. |
| KNIGHT THIS BEEF | Shown only when the next promotion is Regularbeef → Beef Knight. |
| Elevate to Lord | Shown only when the next promotion is Beef Knight → Beef Lord. |
| Add to the line | Enqueue waiting Regularbeef. |
| Skip | Active gathering / rite only. Inactive queue uses Review (select). |
| Close this rite | `RequestCloseRite` (confirm when a sanctioned Gora has no verdict). |

### Gora

| Control | Behavior |
|---------|----------|
| Fighter A / B | Empty label is the slot; filled label is Change. Same id in both slots refuses. |
| A vs B line | Still updated for old tests; **hidden** in paint (duplicate summary removed). |
| Stipulation | Stock edit; passed into Sanction. |
| SANCTION BEEF GORA | Disabled until two different fighters. From ASSEMBLY, auto-`OpenRite("Gora")`. Locks fighters. |
| Winner buttons | Set `selectedWinnerId` + outcome `victor`. |
| DECLARE VICTOR / COWARDICE RECORDED / VOID / FREE RULING | Legacy commits. Still write Core. After any verdict, desk closes the rite so Runtime can leave RITE (End Gathering works). |
| RECORD VERDICT | Structured commit from selected winner + outcome. Duplicate refused: `verdict already recorded`. |
| Raid-health draft | `Gora:GetProposal()` victor table arms `selectedWinnerId` and the target line `Proposed victor: <name>. DECLARE VICTOR to ratify.` `DeclareVictor()` with no target records that id. |
| Cowardice | Core still takes the **fleer**. With a winner selected, fleer is the other fighter. |

### Favor

| API | Meaning |
|-----|---------|
| `Gora:GetFavorSplit()` | Pick counts for A / B. |
| `Gora:GetFavor()` / `GetFavorCount()` | Number of pickers. |
| Congregation checkbox | Per-event visibility default on. Session only; no new SV field. |

No stored neutral. Desk shows named lines + `a / b` + picker count + an ASCII split bar.

### Shared

| Control | Behavior |
|---------|----------|
| Mark this moment | Shell utility on every tab. `Store:FlagMoment`. No extra chronicle schema. |
| Church census | Church tab only (`GetPresenceCensus`), header **By rank**. Live Gathering shows `congregationHere()` only. |

---

## 3. State machine actually implemented

```text
INACTIVE  (Runtime QUIET)
   │  Start the gathering
   ▼
GATHERING ACTIVE  (ASSEMBLY, or CONSEQUENCE after Continue)
   │
   ├─ Open a Knighting rite → KNIGHTING live → promotion → complete → Return to Gathering
   ├─ Open a Gora rite     → GORA setup → Sanction → sanctioned → verdict → complete → Return
   │
   └─ End the gathering → INACTIVE
```

Only one live rite. Knighting and Gora are modes, not extra controls stacked on the overview. `OpenRite` of the already-open same kind is a no-op.

Player-facing copy never uses QUIET / ASSEMBLY / RITE / CONSEQUENCE.

---

## 4. Files changed

| File | Change |
|------|--------|
| `addon/ChurchOfBeef/UI/Console.lua` | Desk shell, view-model, rite modes, verdict/safety, tab paints, button hierarchy. |
| `tests/test_console.lua` | Pins for tabs, locks, uniqueness, duplicate verdict, gold/oxblood/silver hierarchy, raid-health draft. |
| `tests/test_gora.lua` | Snapshot mutation pin no longer poisons Restore. |
| `tests/test_hud.lua` | Grouped fighter A keeps *live* HP after the floor tick. |
| `tests/preview_dump.lua` | Ten desk-state scenarios (`console_*`). |
| `docs/design/renders/popes-desk/` | Offline scene graphs + PNGs for those states. |
| `docs/design/POPES_DESK_REWORK.md` | This record. |

No new TOC files. `ChurchOfBeef.toc` Interface stays `20506`.

---

## 5. SavedVariables / schema

No Core store migration.

`ChurchOfBeefDB.ui.console` (already used for point / size) may also hold:

```lua
gatheringStartedAt = <number>  -- wall clock when the gathering began
lastVerdict = { ruling, winnerId, fleerId, text }
knightingComplete = { name, toTitle, humanId }
```

Absent fields are fine. After `/reload`, `Show` rehydrates locks from Core (sanctioned pair, Knighting subject) and completion from this slot. Congregation favor visibility is not persisted.

---

## 6. Migration notes

None. Old clients already have `ui.console`. A missing `gatheringStartedAt` shows `00:00:00` until the next Start or Show-while-live.

---

## 7. Screenshots

Offline compositor (not the WoW rasterizer). Stand-in fonts smear ligatures; use these for **structure and state**, not pixel fidelity.

| State | Path |
|-------|------|
| Gathering inactive | `docs/design/renders/popes-desk/console_inactive.png` |
| Gathering active | `docs/design/renders/popes-desk/console_active.png` |
| Knighting setup | `docs/design/renders/popes-desk/console_knighting.png` |
| Knighting completed | `docs/design/renders/popes-desk/console_knighting_done.png` |
| Gora setup | `docs/design/renders/popes-desk/console_gora_setup.png` |
| Gora sanctioned / live | `docs/design/renders/popes-desk/console_gora_live.png` |
| Gora verdict completed | `docs/design/renders/popes-desk/console_gora_done.png` |
| Decrees tab | `docs/design/renders/popes-desk/console_decrees.png` |
| Chronicle tab | `docs/design/renders/popes-desk/console_chronicle.png` |
| Church census | `docs/design/renders/popes-desk/console_church.png` |
| Contact sheet | `docs/design/renders/popes-desk/contact-sheet.png` |

Regenerate: `COB_PREVIEW_DIR=docs/design/renders/popes-desk lua tests/preview_dump.lua` then copy `console*.json` + `theme.json` and `COB_PREVIEW_DIR=... python3 scripts/render-preview.py`.

---

## 8. Test results

| Gate | Result |
|------|--------|
| `lua tests/test_console.lua` | 4310 passed, 0 failed |
| `lua tests/run.lua` | **18990 passed, 0 failed** |
| `lua tests/preview_dump.lua` | 28 scenarios, exit 0 |
| TOC | lists only existing files; Interface `20506` |
| Source pins | no Parchment, PanelTabButtonTemplate, Toasts, wire, GuildPromote, `Console.GetCeremonyLog` |
| Install | rsync `addon/ChurchOfBeef/` → Anniversary `Interface/AddOns/ChurchOfBeef/` (WTF untouched) |
| In-game `/reload` | **not run by the agent** |

---

## 9. Known limitations

- Inactive **Asked to fight** is usually empty: Core event-scopes petitions and wipes them in QUIET.
- Elapsed time updates on `Refresh` only (no `OnUpdate`).
- Chronicle “manual entry” is still `FlagMoment` (location), not a headline / body / category modal.
- Decree has no date or event field (Core is `line` + `flavor`).
- Favor bar is an ASCII split, not a StatusBar.
- Congregation “here” is still roster-present (OPEN_QUESTIONS #13), not a proven live attendance scan.
- Title chrome stays **Director Console** (Bible §18.1 / lifecycle tests), not “THE POPE'S DESK”.
- Verb labels kept the existing human copy (`Start the gathering`, not `BEGIN GATHERING`).
- Offline preview fonts are not the in-game rasterizer.

---

## 10. Legacy behavior intentionally preserved

- Four verdict verbs still commit (Cowardice / Void / Free Ruling / Victor).
- Cowardice still records the fleer.
- Favor split = A/B picks; count = number of pickers; no invented neutral.
- Exactly two iron plates: KNIGHT THIS BEEF and SANCTION BEEF GORA.
- Four EditBoxes only (Decree line, flavor, stipulation, free ruling).
- Cold tools stay Core-only (OPEN_QUESTIONS #17–#18).
- Public APIs used by `test_wire_glue` and older console tests: `StartEvent`, `OpenRite`, `KnightThisBeef`, `Sanction`, `DeclareVictor`, `GetPresence`, `GetPresenceCensus`, …
- Frame name `ChurchOfBeefConsoleFrame`, `BasicFrameTemplate`, default 560×600, min 520×440.

---

## 11. Follow-up polish (not this directive)

- Human `/console scriptErrors 1` → `/reload` → `/beef console` walk of §35.
- Two-client favor + Decree broadcast (existing Net gate; not a desk rewrite).
- Replace the ASCII favor bar with a stock StatusBar if the live desk feels thin.
- Optional Decree date/event field — only if Core schema is opened on purpose.
- Richer Chronicle compose — only if Store grows fields; do not invent them here.
- Persist congregation-favor visibility if a Pope asks for it.

---

## Acceptance (handoff §34)

| Area | Evidence |
|------|----------|
| Navigation | Four stock tab buttons; admin compose/census off the live Gathering paint. |
| Gathering | Compact inactive; active session + rite launchers; End Gathering oxblood + confirm; census is **By rank** on Church, not on Gathering. |
| Knighting | Dedicated mode; Select as candidate; target does not replace locked candidate; one promotion verb; queue actionable; completion card. |
| Gora | Two fighter cards; pair line hidden; explicit Change; same-fighter refuse; sanction validation; lock after sanction; favor module + congregation checkbox; winner vs outcome vs RECORD VERDICT; legacy verbs intact; no duplicate verdict; completion card. |
| Decrees | Composer only on Decrees tab; `line`/`flavor` unchanged. |
| Chronicle | Mark this moment on every tab; history list on Chronicle only. |
| Church | Census on Church tab; Gathering shows congregation count. |
| Visual | Gold primary / silver secondary / oxblood destructive on button FontStrings. Red is not used for every click. **POLISH:CANDIDATE.** |
