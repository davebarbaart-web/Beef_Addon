# Lane K — Target-driven Pope kit (UX rebuild)

You are working in `/Volumes/AI_Design_Drive/Beef_Addon`, a WoW TBC Classic Anniversary addon (Lua 5.1, plain global `ChurchOfBeef` / `COB`). Read these first, they are binding:

- `.cursor/rules/ten-laws.mdc`, `.cursor/rules/architecture-overview.mdc`, `.cursor/rules/verification.mdc`
- `.cursor/rules/lua-cob-modules.mdc`, `.cursor/rules/pope-authority.mdc`, `.cursor/rules/ceremony-runtime.mdc`, `.cursor/rules/quiet-event-modes.mdc`, `.cursor/rules/ui-juice-standards.mdc`, `.cursor/rules/testing.mdc`, `.cursor/rules/toc-lifecycle.mdc`
- `.agents/skills/church-of-beef-dev/SKILL.md`

## Where this fits

Lane W (done) simplified the wire. This lane rebuilds the Director Console (`/beef console`) from a 47-verb module dump into a **target-driven Pope kit**. David's decisions (2026-09-13, binding):

- The console is rebuilt around **whoever the Pope is targeting**, not around lists.
- Petitions and the Knighting line stay as **secondary strips**; the Pope may pick from them or ignore them and target.
- **Cold tools leave the UI:** Archive, Canonize, Recognition, Grant Honorific, Notebook. Core modules keep their APIs untouched.
- Rites surfaced in UI: **Knighting and Gora only.** Confession and Proclamation rites stay Core-only.
- Human copy replaces engineer copy. No player-facing QUIET / ASSEMBLY / RITE / CONSEQUENCE state names.

## Binding contract

### 1. `Core/Store.lua` — new method `Store:EnsureCharacterByName(fields, now)`

The Pope Knighting or Sanctioning a targeted stranger **is** the recognition (Bible §4.4, §12.2: one action, Pope present, character logged in). This method is the spine.

- `fields`: a name string, or a table `{ name = ..., class = ..., level = ... }` (class/level optional).
- Invalid/blank name → `nil, "invalid name"`.
- Look up existing characters by `COB.Names.Key(name)` (realm-stripped, case-insensitive). If found and linked (`humanId` valid) → return `characterId, humanId, false`.
- If found but **unlinked** → create a human (`CreateHuman({ name = ch.name }, now)`), link (`LinkCharacter(ch.id, human.id, now)`), return `ch.id, human.id, true`.
- If not found → create human, create character (passing class/level when given), link, return `characterId, humanId, true`.
- **Never** merge into an existing human by name similarity. A new character always gets a fresh human. No alt guessing.
- Reuse existing `CreateHuman` / `CreateCharacter` / `LinkCharacter`. Snapshot/Restore round-trip of created rows is covered by existing persist machinery — add a test proving it.

### 2. `UI/Console.lua` — full rebuild as the target-driven kit

Rewrite the file. Keep the module header conventions (`ChurchOfBeef = ChurchOfBeef or {}`, `local COB`, colon methods, `local function` helpers, `MODE = "Event"`). Law 10: stock Blizzard templates, `GameFont*`, charcoal desk ground via Theme where the current file already does that; the only ornaments are the title-bar `seal_papal` (~20px) and iron `plate_verb`/`_hover`/`_pressed` textures on **KNIGHT THIS BEEF** and **SANCTION BEEF GORA** only.

**Public API (exact set):**

- Lifecycle: `Init`, `Show`, `Hide`, `Toggle`, `IsShown`, `Refresh`, `ResetForTests`
- Data: `GetPresence` (keep current semantics incl. roster+store seed, `here`, dim-when-incomplete), `GetKnightingLine`, `GetPetitions`, `GetWorkingSubject`, `GetProposedBout`, `GetFavorSplit`, `GetFavorCount`, `GetCongregationFavorVisible`
- Selection: `SelectHuman(humanId)`, `SelectCharacter(characterId)` (both set the working subject, source `"selection"`), `SetFighterA()`, `SetFighterB()` (assign the working subject's characterId to that pair slot)
- Verbs: `StartEvent`, `OpenRite(kind)` (`"Knighting"`/`"Gora"` only from UI), `CloseRite`, `Continue`, `EndEvent`, `KnightThisBeef(humanId?)`, `ElevateToLord(humanId?)`, `Sanction(fighterA?, fighterB?, stipulation?)`, `DeclareVictor(winnerId?)`, `CowardiceRecorded(fleerId?)`, `Void()`, `FreeRuling(text?)`, `FlagMoment(location?, now?)`, `PostDecree(fields?)`, `Dismiss(characterId)`, `Enqueue(humanId?)`, `Skip(humanId?)`, `SetCongregationFavorVisible(flag)`

**Removed (assert nil in tests):** `CallForward`, `Recommend`, `GetConfessions`, `GetCeremonyLog`, `GrantHonorific`, `BeginRecognition`, `CompleteRecognition`, `CancelRecognition`, `ExportArchive`, `ImportArchive`, `CanonizeMoment`, `FlagFamousUpset`, `SelectFighters`. No Archive/Canonize/Recognition/Honorific/Notebook/ceremony-log/confession-inbox/Recommend widgets, no Records & archive fold, no Open Confession / Open Proclamation buttons.

**Working subject:**

- `GetWorkingSubject()` returns a copy: `{ name, humanId, characterId, rankId, rankTitle, needsKnighting, source }` (`source` = `"target"`, `"selection"`, or nil).
- Set by `SelectHuman`/`SelectCharacter` (source `"selection"`) or by target refresh (source `"target"`): the frame registers `PLAYER_TARGET_CHANGED` and re-resolves from `UnitName("target")` (pcall/type-guarded). A target change to a named character replaces the subject; clearing the target clears the subject only when `source == "target"` (a row selection persists). Ids resolve through `Names.Key` against `Store:Snapshot().characters` (+ linked human), exactly like the current `GetPresence`.
- Verbs called with no explicit id use the working subject. When the subject has a name but no ids, the verb first calls `Store:EnsureCharacterByName({ name = subject.name, class = <UnitClass("target") when source=="target" and available>, level = <UnitLevel("target") likewise> })`. All WoW API reads pcall/type-guarded; the harness has no `UnitClass`/`UnitLevel` and that must be fine.
- No subject → human refusals: `KnightThisBeef` → `nil, "Target the Beef you are knighting"`; `Sanction` without both fighters → `nil, "Set Fighter A and Fighter B first"`; `DeclareVictor` without subject → `nil, "Target the victor"`; `CowardiceRecorded` without subject → `nil, "Target the fleeing fighter"`. Explicit id arguments still work exactly as today.
- All verbs stay Pope-gated via the existing `isRegisteredPope()` pattern (`Sender:IsRegisteredPope(UnitName("player"))`), refusing `nil, "not a registered pope"`.

**Elevation beat:** after a successful `DeclareVictor`, set the working subject to the victor's character. `Elevate to Lord` is visible/enabled when the working subject's human rank is Beef Knight (rankId 3). Core already refuses Lord+ (`"already elevated"`).

**Frame and copy (human, no state names):**

- Title bar: seal + "Director Console". Drag to move; stock grip resize; default about 560×600, floor 520×440, clamped to UIParent; persist `ChurchOfBeefDB.ui.console` (keep the existing persist shape). ESC hides via the existing `UISpecialFrames` + OnHide-remount pattern.
- Phase hint line: QUIET → "No gathering is live."; ASSEMBLY → "Gathering live — no rite open."; RITE+Knighting → "Knighting rite open."; RITE+Gora → "Gora rite open."; RITE+other → "Rite open."; CONSEQUENCE → "Consequence — rule, then continue."
- Phase verbs (only the current phase's render; one primary):
  - QUIET: **Start the gathering** (large stock button).
  - ASSEMBLY: **Open a Knighting rite**, **Open a Gora rite**; **End the gathering** secondary, right-aligned.
  - RITE: **Close this rite**.
  - CONSEQUENCE: **Continue**; **End the gathering** secondary.
- Decree compose (visible in QUIET and ASSEMBLY): line box, flavor box, **Post the Decree** button → `PostDecree` (Core `Decree:Set`; glue broadcasts — do not call Net from Console).
- Target line: `Targeting: <name> — <rank title>` plus the word "needs Knighting" when true; or "Target a guildmate to act on them."
- Subject verbs (render only in their context):
  - Knighting rite or ASSEMBLY: **KNIGHT THIS BEEF** (iron plate).
  - Subject rank 3 (any event phase): **Elevate to Lord** (stock).
  - ASSEMBLY or Gora rite: **Fighter A** / **Fighter B** (stock), pair line "A: <name>  vs  B: <name>", one-line **stipulation** box, **SANCTION BEEF GORA** (iron plate, enabled when both fighters set).
  - Gora live (RITE or CONSEQUENCE with riteType Gora): **DECLARE VICTOR** (on subject; the pair line's fighter names are also clickable → `DeclareVictor(thatId)`), **COWARDICE RECORDED** (on subject), **VOID**, **FREE RULING** (text box + button). Favor readout + congregation-visibility checkbox render only in this context.
  - Event live (any non-QUIET): **Mark this moment**.
- Secondary strips (compact stock lists, below the verbs; each row click sets the working subject):
  - **Waiting to be knighted** — `GetKnightingLine` rows; per-row **Skip**. Empty → one muted line "No one is waiting."
  - **Asked to fight** — `GetPetitions` (present-and-alive) rows; mute numeric H2H token when Store has history (keep current `1-0` format); per-row **Dismiss**. Empty → "No petitions."
  - **Presence** — `GetPresence` rows: name, rank title, "needs Knighting" word when true; per-needs-Knighting-row **+line** (Enqueue). Keep the current dim-at-0.45 behavior for store-seeded rows while the roster is incomplete.
- `OpenRite("Knighting")` keeps the line-head candidate fallback; `OpenRite("Gora")` keeps the selected-pair → live-sanctioned fallback. `KnightThisBeef`/`ElevateToLord` Core already dequeue from the line.
- `Dismiss(characterId)` now reaches `Gora:Dismiss` only (no confession inbox). Keep the current selection/pair cleanup-on-success semantics where they still apply.
- Keep `GetProposedBout` returning `{ fighterA, fighterB, stipulation }` from the pair slots + box.

### 3. Retire the Console Dock

- Delete `addon/ChurchOfBeef/UI/ConsoleDock.lua` and `tests/test_console_dock.lua`.
- Remove `UI\ConsoleDock.lua` from `addon/ChurchOfBeef/ChurchOfBeef.toc` and `test_console_dock` from `tests/run.lua`.
- Remove dock references: `ChurchOfBeef.lua` glue (`hideInputsAndDock` becomes inputs-only — rename or adjust; `paintInboundInputs`; `refreshEventFurniture`), the `ConsoleDock:Init` block in `UI/MainFrame.lua`, and the dock dofile + `dock` scenario in `tests/preview_dump.lua` (keep every other scenario working).
- `tests/test_wire_glue.lua`: remove the ConsoleDock spy and its pins; keep every other pin.
- `tests/test_markers.lua` already pins the dock is not loaded in isolation — keep it true.

### 4. Glue alignment (`ChurchOfBeef.lua`)

The InstallWire glue wraps **Core** modules and must keep working unchanged: `Runtime` Start/Open/Close/Continue/End, `Gora` Sanction/DeclareVictor/Void/FreeRuling/CowardiceRecorded/RecordFavor, `Knighting` Enqueue/Skip/Insert/KnightThisBeef/ElevateToLord, `Console.SetCongregationFavorVisible`, `Console.PostDecree`, `Decree.Clear`, `Store.Restore`, Net `_HandleState`/`_HandleSnapshot`. Do not rename those Console methods. No new wraps. No theater calls from Console (Law 4: Console never calls Toasts/Sound/FighterCard/Markers directly — glue owns that).

## Tests (TDD: rewrite suites first, watch fail, implement, green)

- `tests/test_store.lua` — add an `EnsureCharacterByName` block: by string; by table with class/level; found-linked returns `created=false`; found-unlinked creates+links a human; unknown creates human+character+link; invalid name refuses; no alt-merge (existing human "X" untouched when "Y" arrives); Snapshot/Restore keeps created rows.
- `tests/test_console.lua` — **rewrite wholesale** around the new kit. Cover: lifecycle (Init/Show/Hide/Toggle/ESC/resize-persist); Pope gate refuses every verb unlisted with the exact refuse string; working subject from target (stub `UnitName("target")` + fire `PLAYER_TARGET_CHANGED`), from row clicks, precedence and clearing rules; ensure-on-verb (Knight a named-but-unknown target → Store rows created, rank 3); each phase's visible buttons and human copy (pin the exact strings above); strips content + empty lines; favor toggle only during live Gora; removed-method nil assertions; iron plates only on KNIGHT/SANCTION (census); no QUIET/ASSEMBLY/RITE/CONSEQUENCE strings anywhere user-facing; `GetProposedBout`; OpenRite fallbacks; Dismiss semantics.
- `tests/test_wire_glue.lua` — dock removal only; everything else keeps passing.
- `tests/run.lua`, `tests/preview_dump.lua`, `tests/test_console_dock.lua` — as §3.
- `tests/wow_ui_stub.lua` — only touch if the stub cannot fire `PLAYER_TARGET_CHANGED` or lacks something the new frame needs.

Keep every pin covering behavior this lane did not remove. Full harness `lua tests/run.lua` exits 0 at the end. Also run `lua tests/preview_dump.lua <tmp dir>` if that script takes an output argument (check its header) to prove the remaining scenarios still dump.

## Hard rules

- Lua 5.1. Multi-return errors. Getters return copies. Core stays pure (Store gains no WoW API reads — class/level arrive via `fields`).
- Ten Laws. No auto-advance, no narration, no generated prose, no new Quiet chrome. The console is a player-opened Pope tool (`/beef console`), not unbidden chrome.
- No GuildPromote. No new Net. No SUMMON. No Notebook persist.
- Do not delete or rewrite `Core/Gora.lua`, `Core/Knighting.lua`, `Core/Confession.lua`, `Core/Archive.lua`, `Core/Recognition.lua` — their APIs stay for later phases.
- Do not touch `UI/RecordsBook.lua`, `UI/Hud.lua`, `UI/FighterCard.lua`, `UI/Toasts.lua`, `UI/Inputs.lua`, `UI/Minimap.lua`, `UI/Decree.lua`, `UI/Sound.lua` — later lanes own them. (Exception: the dock Init removal in `UI/MainFrame.lua` §3.)
- Do not commit. Do not touch `WTF/`. Do not edit `docs/` except your report.

## Report

Write your full report to `docs/reformation/ux-rebuild/briefs/K-pope-kit-report.md`: what changed per file, test counts before/after per touched suite, full-harness result, and concerns. Return only: status (DONE / DONE_WITH_CONCERNS / BLOCKED / NEEDS_CONTEXT), one-line test summary, and concerns if any.
