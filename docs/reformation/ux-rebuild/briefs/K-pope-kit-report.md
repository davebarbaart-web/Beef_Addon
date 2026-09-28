# Lane K — Target-driven Pope kit: report

Lane: `K-pope-kit.md` (UX rebuild). Director Console rebuilt around whoever the
Pope is targeting; cold tools left the UI; Console Dock retired; glue aligned.
TDD per suite: tests rewritten/extended first, watched red, implemented, green.

## What changed, per file

### `addon/ChurchOfBeef/Core/Store.lua`
- New method `Store:EnsureCharacterByName(fields, now)` — the target-verb spine
  (Bible §4.4, §12.2: the Pope Knighting/Sanctioning a targeted stranger *is*
  the recognition). `fields` is a name string or `{ name, class, level }`.
  Blank/invalid name → `nil, "invalid name"`. Lookup over characters by
  `Names.Key` (realm-stripped, case-insensitive; first-created row wins a
  name-reuse tie). Found + linked → `characterId, humanId, false`. Found but
  unlinked → fresh human created + linked, `ch.id, human.id, true`. Unknown →
  character created first (so a refused character leaves no orphan human),
  then human, then link → `characterId, humanId, true`. Never merges into an
  existing human by name similarity — a name-matching human with no such
  character row is not reused. Reuses `CreateHuman` / `CreateCharacter` /
  `LinkCharacter`; no WoW API reads (class/level arrive via `fields`).

### `addon/ChurchOfBeef/UI/Console.lua` — full rewrite (2594 → ~1050 lines)
- Module header conventions kept; `MODE = "Event"` (now matches the other
  Event-mode modules' casing).
- **Working subject**: `Console.subject` + `GetWorkingSubject()` (returns a
  copy: `{ name, humanId, characterId, rankId, rankTitle, needsKnighting,
  source }`). Set by `SelectHuman` / `SelectCharacter` (source `"selection"`)
  or by target refresh (source `"target"`): the frame registers
  `PLAYER_TARGET_CHANGED` and re-resolves from `UnitName("target")`
  (pcall/type-guarded). A named target replaces the subject; clearing the
  target clears the subject only when `source == "target"`. Ids resolve
  through `Names.Key` against `Store:Snapshot().characters` (+ linked human),
  same as `GetPresence`. `Refresh` re-resolves rank fields from the store so
  the knight → elevate beat shows without re-picking.
- **Ensure-on-verb**: verbs called with no explicit id use the working
  subject; a name-only subject is first recognised through
  `Store:EnsureCharacterByName` (class/level from `UnitClass`/`UnitLevel` only
  when `source == "target"` and the reads exist — the harness has neither).
  Human refusals, exact strings: `KnightThisBeef` → `"Target the Beef you are
  knighting"`; `Sanction` without both fighters → `"Set Fighter A and Fighter
  B first"`; `DeclareVictor` → `"Target the victor"`; `CowardiceRecorded` →
  `"Target the fleeing fighter"`. Explicit id arguments reach Core unchanged.
- **Pope gate**: every verb refuses `nil, "not a registered pope"` via the
  existing `Sender:IsRegisteredPope(localSender())` pattern (see Concerns —
  the string changed from the old `"not the registered pope"` to the brief's
  contract string, which also matches BeefNet's gate). The gate chrome
  (`GatedButtons` registry) disables verb buttons and shows the reason line.
- **Elevation beat**: successful `DeclareVictor` sets the working subject to
  the victor's character; **Elevate to Lord** renders whenever the subject's
  human rank is Beef Knight (rankId 3), any phase.
- **Frame/copy**: BasicFrameTemplate, seal_papal (~20px) + "Director Console",
  drag title bar, stock grip, default 560×600, floor 520×440, clamped to
  UIParent, persists `ChurchOfBeefDB.ui.console` (point/relativePoint/x/y/w/h
  — existing shape kept), ESC via `UISpecialFrames` + OnHide remount. Phase
  hint line is human copy (six pinned strings; no state names anywhere
  user-facing — census-pinned per phase). Phase verbs render only in their
  phase: **Start the gathering** (QUIET), **Open a Knighting rite** / **Open a
  Gora rite** + right-aligned **End the gathering** (ASSEMBLY), **Close this
  rite** (RITE), **Continue** + **End the gathering** (CONSEQUENCE). Decree
  compose (line, flavor, **Post the Decree**) in QUIET + ASSEMBLY. Target
  line: `Targeting: <name> — <rank title>` + `  needs Knighting`, else
  `"Target a guildmate to act on them."`
- **Subject verbs in context**: **KNIGHT THIS BEEF** (iron plate; ASSEMBLY or
  Knighting rite), **Elevate to Lord** (stock; subject rank 3), **Fighter A** /
  **Fighter B** + pair line `A: <name>  vs  B: <name>` + one-line
  **Stipulation** box + **SANCTION BEEF GORA** (iron plate, enabled only when
  both slots are set) in ASSEMBLY or Gora rite; **DECLARE VICTOR** (on subject;
  the pair line's fighter names also render as clickable verdict buttons →
  `DeclareVictor(thatId)`), **COWARDICE RECORDED**, **VOID**, **FREE RULING**
  (box + button), favor readout + congregation-visibility checkbox — all only
  while a Gora lives (RITE or CONSEQUENCE with riteType Gora). **Mark this
  moment** in any non-QUIET phase.
- **Secondary strips** (always rendered below the verbs; row click sets the
  working subject): **Waiting to be knighted** (`GetKnightingLine`, per-row
  **Skip**, empty → muted `"No one is waiting."`), **Asked to fight**
  (`GetPetitions` present-and-alive, mute `1-0` H2H token kept, per-row
  **Dismiss**, empty → `"No petitions."`), **Presence** (`GetPresence`
  semantics kept verbatim — roster+store seed, `here`, rank title, `needs
  Knighting` word, per-needs-Knighting-row **+line** → `Enqueue`, 0.45 dim for
  store-seeded rows while the roster is incomplete, empty → `"No one on the
  roster yet."`).
- `OpenRite("Knighting")` keeps the line-head candidate fallback (working
  subject wins first); `OpenRite("Gora")` keeps the selected-pair →
  live-sanctioned fallback and never falls back to the last pair.
  `Dismiss(characterId)` reaches `Gora:Dismiss` only (no inbox fan-out);
  success clears the working subject when it was the dismissed character and
  clears the pair when a pair member was dismissed. `GetProposedBout()`
  returns `{ fighterA, fighterB, stipulation }` from the pair slots + box.
- **Removed**: `CallForward`, `Recommend`, `GetConfessions`, `GetCeremonyLog`,
  `GrantHonorific`, `BeginRecognition`, `CompleteRecognition`,
  `CancelRecognition`, `ExportArchive`, `ImportArchive`, `CanonizeMoment`,
  `FlagFamousUpset`, `SelectFighters` — and every widget behind them (records
  fold, inboxes, archive/canonize boxes, recognition row, Notebook label,
  ceremony log, Open Confession / Open Proclamation buttons). Core modules
  keep their APIs untouched.
- **Law 4**: the desk makes no theater or wire calls — the old `playCue` /
  `refreshHud` / `showDecreeBanner` bridges are gone (source-pinned: no
  `COB.Toasts` / `COB.Sound` / `COB.FighterCard` / `COB.Markers` / `COB.Hud` /
  `DecreeBanner` / `SendChatMessage(` / `SendAddonMessage(` / `GuildPromote(`
  / `SetGuildRank(`). Glue owns proclaims, sounds, cards, marks, and sends.

### Console Dock retirement
- Deleted `addon/ChurchOfBeef/UI/ConsoleDock.lua` and
  `tests/test_console_dock.lua`.
- `addon/ChurchOfBeef/ChurchOfBeef.toc`: removed `UI\ConsoleDock.lua`. TOC
  truth re-checked: every listed file exists.
- `addon/ChurchOfBeef/ChurchOfBeef.lua`: `hideInputsAndDock` renamed to
  `hideInputs` (inputs-only); `paintInboundInputs` and `refreshEventFurniture`
  drop the dock calls. All InstallWire wraps unchanged; no new wraps.
- `addon/ChurchOfBeef/UI/MainFrame.lua`: removed the `ConsoleDock:Init` block
  (the brief's allowed exception).
- `tests/run.lua`: removed `test_console_dock` from the suite list.
- `tests/preview_dump.lua`: removed the dock dofile, the dock scenario, and
  the dock line in `resetCores`; every other scenario untouched.
- `tests/test_wire_glue.lua`: removed the ConsoleDock spy and its pins; every
  other pin kept (653 assertions green).
- `tests/test_markers.lua`: untouched — its "isolated suite does not load
  ConsoleDock" pin stays true.

### `tests/test_store.lua`
- New `runEnsureCharacterByName()` block (function-wrapped; the main chunk is
  at Lua 5.1's 200-local cap): string form, table form with class/level, bare
  table form, found-linked `created=false`, realm-suffixed lookup, found-
  unlinked creates+links exactly one human, invalid/blank/nil/nameless-table/
  numeric refusals with `"invalid name"`, refused ensure creates no rows, no
  alt-merge (similar-name human untouched; name-matching characterless human
  not reused), Snapshot/Restore keeps created rows and post-restore ensure
  finds them.

### `tests/test_console.lua` — wholesale rewrite (6836 → ~1150 lines)
Coverage: isolation surface; exact public API set + removed-method nil
assertions; lifecycle (Init anatomy, 560×600 default, 520×440 floor, grip
clamp + persist + point restore, ESC/UISpecialFrames remount paths, no
permanent OnUpdate); Pope gate refuses every verb with `"not a registered
pope"` + dead-button writes-nothing + gate disables chrome; verbs reach Core
with explicit ids (all phases driven through the desk's own buttons); working
subject from target (realm/case-normalized), from row clicks, precedence and
clearing rules, copy semantics, rank re-resolve on Refresh; ensure-on-verb
(knight a named stranger → rows created + rank 3; class/level pass-through
with `UnitClass`/`UnitLevel` stubbed; fighter slots ensure; no-subject
refusals create nothing); per-phase visible buttons + exact human copy + a
no-state-names census per phase (incl. a Core-only rite getting the generic
`"Rite open."` hint); subject-verb contexts (KNIGHT/Elevate visibility,
pair-line text, SANCTION enable only with both fighters, clickable pair-name
verdicts, the elevation beat, Core `"already elevated"` refusal on Council);
strips content + empty lines + per-row Skip/Dismiss/+line + 0.45 dim;
presence/petition/line readout semantics kept; favor readout + toggle only
during live Gora, per-event memory (resets on a *new* event id — Runtime keeps
the event id in QUIET), non-Pope click revert; `GetProposedBout`; OpenRite
fallbacks (line head, subject wins, live-sanctioned, never last-pair);
Dismiss semantics (Gora-only, source-pinned no `Confession` reference, subject
and pair cleanup); chrome census (4 stock EditBoxes, exactly two iron plates —
KNIGHT THIS BEEF and SANCTION BEEF GORA, seal, charcoal ground via Theme, cold-
tool widgets absent, no-theater/no-wire source pins).

## Test counts

Full harness (`lua tests/run.lua`, Lua 5.1.5, from workspace root):

| When | Result |
|---|---|
| Lane start (working tree, measured before any Lane K edit) | 17280 passed, 0 failed, exit 0 |
| After Lane K | **15798 passed, 0 failed, exit 0** |
| HEAD reference (git archive of HEAD in a temp dir)* | 16770 passed, 0 failed |

\* The lane-start working tree carried uncommitted prior-lane edits, so HEAD is
a reference point, not the exact pre-lane state.

Per touched suite (standalone counts; HEAD reference in parentheses where the
lane-start working-tree version is no longer recoverable):

| Suite | Before | After |
|---|---|---|
| `test_store` | 450 (HEAD; lane-start file == HEAD, diff-verified) | 517 (+67: EnsureCharacterByName block) |
| `test_console` | 3158 (HEAD reference; lane-start working version was larger — prior-lane pins) | 2514 (wholesale rewrite; cold-tools pins left with the features) |
| `test_console_dock` | 814 (HEAD reference) | deleted with the dock |
| `test_wire_glue` | 627 (HEAD reference) | 653 (dock spy/pins removed; every other pin kept) |

Red steps observed: store suite aborted on missing `EnsureCharacterByName`;
console suite failed 20+ assertions on the old desk (MODE casing, missing
`GetWorkingSubject`/`SetFighterA`/`SetFighterB`, removed methods present, old
copy/sizes) before implementation.

## Verification status

- `lua tests/run.lua` → **exit 0** (15798 passed, 0 failed) — run after all
  edits, including the dock retirement and glue alignment.
- TOC truth: every listed file exists; Interface still 20506.
- `tests/preview_dump.lua`: the script takes **no positional output argument**
  (header: `Runner: lua tests/preview_dump.lua`; output dir comes from the
  `COB_PREVIEW_DIR` env var). My run attempt with `COB_PREVIEW_DIR` pointed at
  a tmp dir coincided with the shell execution environment wedging (subsequent
  trivial commands also return no exit status) — so the dump is **not
  execution-verified**. The dock removals are coherent by inspection and the
  `console` scenario exercises only paths covered by the green console suite.
  Re-run: `COB_PREVIEW_DIR=$(mktemp -d) lua tests/preview_dump.lua`.
- In-game smoke (`/reload` → `/beef console`) not run — harness-only lane.
  POLISH:CANDIDATE at most; no POLISH:PASS claimed.

## Concerns

1. **Refusal string changed**: the desk's Pope-gate refusal is now
   `"not a registered pope"` (the brief's contract string, matching BeefNet's
   gate) — previously `"not the registered pope"`. Only the rewritten suite
   pinned the old string.
2. **Theater bridges removed** (Law 4, brief §4): the desk no longer plays
   cues, refreshes the HUD, or shows the Decree banner. In the live client,
   §19.4 cues still fire via glue → Toasts on Core verbs. Two gaps to hand to
   later lanes (no new wraps allowed here): the Pope's own Decree banner no
   longer auto-paints on **Post the Decree** (reachable from the minimap), and
   the Pope-client Fight HUD refresh after a console verdict waits for the
   next runtime-verb glue refresh.
3. **`SetCongregationFavorVisible` is now Pope-gated at the method level**
   (brief: "All verbs stay Pope-gated"); previously only the checkbox click
   was guarded. The wire glue calls it only under a registered Pope, so the
   wrap is unchanged and green; the checkbox guard remains as defense in
   depth.
4. **`SetFighterA`/`SetFighterB` are selection-family** (not in the brief's
   Verbs list) and are not Pope-gated at the Lua level, yet they can trigger
   `Store:EnsureCharacterByName` (a Core write) for a name-only target. Their
   buttons are gated chrome (disabled for non-Popes); on a congregation client
   the next Pope snapshot Restore overwrites any stray local rows. Flagged as
   the brief's ambiguity; gating the methods is a two-line change if desired.
5. **Elevate to Lord visibility** reads "subject rank 3 (any event phase)" as
   purely subject-driven — it renders whenever the working subject's human is
   a Beef Knight, including QUIET (Core `ElevateToLord` has no event gate).
   One-line predicate change if the intent was event phases only.
6. **Name-reuse tie-break**: when two character rows share a `Names.Key`
   (§12.4), target/ensure resolution deterministically picks the first-created
   row. The contract does not specify; noted for the record.
7. **Dismiss cleanup narrowed**: the old desk cleared `selectedCharacterId` on
   *any* successful Dismiss; the new desk clears the working subject only when
   the dismissed id is the subject's character (pair cleanup unchanged:
   dismissing a pair member clears both slots). "Where they still apply" per
   the brief.
8. **Shell environment**: wedged during the `preview_dump` attempt (see
   Verification status). The binding harness result was measured before the
   wedge and after all edits.

## Fix wave 1

Review follow-up: four Important findings plus test-hygiene items, fixed TDD
(pins written/adjusted first, watched red, implemented, green). Only
`addon/ChurchOfBeef/UI/Console.lua` and `tests/test_console.lua` were touched;
Store was not. No commits.

### Finding 1 — PLAYER_TARGET_CHANGED fired while hidden (Important)

- `buildFrame` no longer registers `PLAYER_TARGET_CHANGED` at create time; the
  OnEvent handler stays. `Console:Show()` registers the event and re-resolves
  the working subject from the live target whenever the subject is nil **or**
  target-sourced (a target picked before the desk opened still counts; a move
  or clear while hidden is caught up on open; a row selection is never
  re-resolved away). Unregister lives in the OnHide handler wired by
  `wireConsoleOnHide`, so both `Console:Hide()` and ESC dismissal (direct
  `frame:Hide()`) put the listener to sleep. No more hidden-client
  `Store:Snapshot()` deep-copies per target change.
- Test evidence: `runLifecycle` pins hidden→unregistered, shown→registered,
  Hide→unregistered, ESC→unregistered; new `runShowPickup` section pins
  pre-existing-target pickup, target-moved-while-hidden re-resolve,
  target-cleared-while-hidden clearing, and selection persistence. Red before
  fix ("target listening sleeps while the desk is hidden expected false got
  true", etc.), green after.

### Finding 2 — NPC targets became Church records (Important)

- New `targetIsPlayer()` guard in `refreshTargetSubject`: when
  `UnitIsPlayer("target")` exists and returns false, the target is treated as
  no target (a target-sourced subject clears; no subject is set, so
  ensure-on-verb can never fire). API absent (harness) or pcall failure falls
  open, so existing tests are unaffected.
- Test evidence: new `runNpcTargetGuard` section — `UnitIsPlayer` stubbed
  false: NPC target clears the subject, the desk asks for a guildmate, and
  Pope-stubbed `KnightThisBeef` refuses "Target the Beef you are knighting"
  with zero new store rows; stub removed: the target path falls open. Red
  before fix ("an NPC target writes no store rows expected 1 got 2"), green
  after.

### Finding 3 — ensure-on-verb reachable without the Pope gate (Important)

- `ensureSubjectId` now refuses `nil, "not a registered pope"` at the ensure
  step when the working subject has a name but no ids and `isRegisteredPope()`
  is false. Subjects that already have ids return before the gate (selection
  stays ungated). `SetFighterA` / `SetFighterB` thread the refusal through
  (`ensureErr or "Target a fighter first"`), so the pair slot is not set and
  no Core write occurs. All other ensure callers are Pope-gated verbs already;
  their behavior is unchanged.
- Test evidence: new `runEnsureGate` section — unlisted client: SetFighterA/B
  on a name-only target refuse with the exact string, pair slots stay empty,
  zero store rows; known-id subject assigns ungated with no new rows; listed
  Pope's ensure recognises the stranger (rows created). Red before fix
  ("SetFighterA refuses the ensure for an unlisted client expected nil got
  true"), green after.

### Finding 4 — Elevate to Lord rendered in QUIET (Important, adjudicated)

- `paintDesk`: `elevateVisible` now requires `eventLive` (state ~= QUIET) in
  addition to the working subject's human rank being Beef Knight (rankId 3).
- Test evidence: the `runSubjectVerbs` pin that asserted QUIET visibility was
  updated — QUIET hides Elevate even for a Beef Knight subject, a live
  gathering shows it, Cooked Beef still hides it, and returning to QUIET hides
  it again. Red before fix ("QUIET hides Elevate to Lord even for a Beef
  Knight subject expected false got true"), green after.

### Finding 5 — test hygiene: restored pins (Minor)

- `runDeskChrome` (new section): stockEdit `OnEscapePressed` → `ClearFocus`
  on the Decree line and stipulation boxes without hiding the desk; DeskScroll
  `OnMouseWheel` 36px step with top/bottom clamp (behavioral, via an instance
  `GetVerticalScrollRange` override); `wireConsoleOnHide` never replaces an
  existing OnHide across Hide/Refresh and remounts a missing one with the
  desk's own handler.
- `runStrips`: leftover strip rows reset `SetAlpha(1)` when the list shrinks
  (the 0.45-dimmed store-seeded Presence row goes leftover → hidden, alpha 1).
- `runBoutAndFallbacks`: a successful `EndEvent` clears the working subject
  and both pair slots.
- `runShowPickup`: `Show()` picks up a pre-existing target (also Finding 1).
- These pin behavior the lane retained; they were green immediately (that is
  their purpose) and stay green.

### Finding 6 — minor behavior one-liners (Minor)

- (a) `Console:EndEvent` re-resolves from the live target via the same
  `refreshTargetSubject` path after clearing the subject — a still-selected
  target reappears. Pinned in `runBoutAndFallbacks` (red before fix: "a
  still-selected target reappears after EndEvent expected true got false").
- (b) `Console:Dismiss` returns `nil, "No petition from that fighter"` on Core
  refusal instead of a bare false; the success path still returns `true` and
  keeps the subject/pair cleanup semantics. Two existing pins updated from
  `false` to `nil` + exact error string (red before fix).

### Test evidence (exact commands and counts)

- Red phase: `lua tests/test_console.lua` → 2592 passed, **31 failed** (the 31
  map to findings 1–4 and 6 as quoted above; the restored retained-behavior
  pins passed immediately).
- Green phase: `lua tests/test_console.lua` → **2623 passed, 0 failed**
  (2514 → 2623, +109 assertions).
- Full harness: `lua tests/run.lua` from the workspace root → **15907 passed,
  0 failed, exit 0** (15798 → 15907, matching the +109 console delta; no other
  suite moved).
- `COB_PREVIEW_DIR=$(mktemp -d) lua tests/preview_dump.lua` → exit 0, 13
  scenarios dumped (this also execution-verifies the dock-retirement dump path
  left unverified in the lane report above).
- TOC truth: unchanged — no files added or removed; Interface stays 20506.
- In-game smoke not run (harness-only fix wave). POLISH:CANDIDATE at most.

### Concerns

1. `targetIsPlayer()` blocks only on an explicit `false` (per the finding's
   wording); a pcall failure or a nil return falls open. On the 2.5.x client
   `UnitIsPlayer` returns a boolean for a named target, so NPCs are caught.
2. The ensure gate lives in `ensureSubjectId`, so every verb path is covered
   by construction; the only ungated entry points were `SetFighterA` /
   `SetFighterB`, which now thread the refusal string through.
3. `Console:Dismiss`'s refusal string ("No petition from that fighter") is new
   human copy — Core `Gora:Dismiss` returns a bare `false`, so the desk names
   the refusal itself.
