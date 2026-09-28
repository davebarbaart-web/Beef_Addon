# Lane T — Theater collapse: report

Lane: `T-theater-collapse.md` (UX rebuild). The fighter card is now a sanction
beat (hidden by the verdict wraps, CloseRite, inbound CONSEQUENCE/QUIET;
EndEvent kept), the Fight HUD stays the single persistent Gora surface, the
empty Quiet shell (`UI/MainFrame.lua`) and the roster status chip
(`UI/Status.lua`) are retired, the small-toast engine is dead (zero callers),
and the two Lane K glue gaps (Pope HUD refresh after a verdict; Decree banner
on post) are closed. TDD per suite: suites changed first, watched red,
implemented, green, then the full harness.

## What changed, per file

### `addon/ChurchOfBeef/ChurchOfBeef.lua`
- `OnLogin` no longer calls `COB.UI:Init()`. A bootstrap-owned `initUi()`
  local calls each module's `Init` when present, in the brief's order —
  `Minimap`, `RecordsBook`, `Hud`, `Console`, `Toasts`, `DecreeBanner`,
  `Sound`, `FighterCard`, `Inputs`, `Markers` — with the retired `UI:Init`'s
  exact pcall pattern (Minimap / RecordsBook / Hud bare; the rest pcall'd).
  No shell frame, no `rememberSpecial("ChurchOfBeefFrame")`, no roster event
  registration on a shell, no `ui.shown` reopen-on-login (the SV key stays in
  `Core/DB.lua` defaults harmlessly — not migrated, not deleted).
- Verdict wraps (`Gora.DeclareVictor`, `Gora.Void`, `Gora.FreeRuling`,
  `Gora.CowardiceRecorded`) now call the existing pcall-guarded
  `hideFighterCard()` plus a new pcall-guarded `refreshHud()` local
  (skipSend-guarded like `refreshEventFurniture`), alongside the existing
  `proclaim` / `sendState`. Deterministic on the Pope client; does not rely
  on the STATE echo.
- `Runtime.CloseRite` wrap is now `sendState` + `hideFighterCard()` (was
  bare `sendState`). `EndEvent` already hid the card — kept.
- `_HandleState` glue wrap: hides the card when the inbound STATE's `state`
  is `"CONSEQUENCE"` in addition to the existing `"QUIET"` hide.
  RITE-with-fighters still shows.
- New `wrapAfter(COB.Decree, "Set", ...)` → pcall `COB.DecreeBanner:Show()`.
  Covers `Console:PostDecree` and inbound DECREE (`_HandleDecree` →
  `Decree:Set`). `Decree:Set` returns a non-nil copy on success, so the wrap
  fires only on a real set; login restore goes through `Decree:Restore`
  (never `Set`), so no login double-show past the once-per-login reveal in
  `DecreeBanner:Init`. `Decree:Clear` keeps its `wrapAlways` banner refresh.
- `/beef` fall-through (bare or unrecognised argument) calls
  `COB.RecordsBook:ToggleHome()` directly (guarded). The not-ready chat
  fallback now names the Records Book. `/beef minimap` and `/beef console`
  unchanged.

### `addon/ChurchOfBeef/UI/FighterCard.lua`
- Header comment only: documents the new Hide triggers (verdict / inbound
  CONSEQUENCE / QUIET / EndEvent). ESC dismissal, lastPair-while-shown,
  persist, and all dress are byte-for-byte unchanged. No auto-timer, no new
  wire fields.

### `addon/ChurchOfBeef/UI/Hud.lua`
- Not edited (per the brief). Keeps lastPair through the verdict beat; exits
  at QUIET.

### `addon/ChurchOfBeef/UI/MainFrame.lua` — deleted
### `addon/ChurchOfBeef/UI/Status.lua` — deleted
### `addon/ChurchOfBeef/ChurchOfBeef.toc`
- `UI\MainFrame.lua` and `UI\Status.lua` removed. TOC lists only existing
  files (verified by shell loop); `## Interface: 20506` unchanged.

### `addon/ChurchOfBeef/UI/Minimap.lua`
- Left-click calls `COB.RecordsBook:ToggleHome()` (guarded) instead of
  `COB.UI:Toggle()`. Right-click Decree replay unchanged.

### `addon/ChurchOfBeef/UI/Decree.lua`
- OPEN CHURCH BOOK calls `COB.RecordsBook:ToggleHome()` (guarded) instead of
  `ShowHome`-or-`COB.UI:Toggle()`. With no Records Book module the click is a
  silent no-op after dismissing the banner (pinned).

### `addon/ChurchOfBeef/UI/Console.lua`
- `Console:Show` gained the roster kick the shell's OnShow owned: if
  `COB.Roster` exists, pcall `AttachLibrary` then `Refresh`; and if
  `Roster:IsReady()` is false and `COB.Net.RequestRoster` exists, pcall
  `Net:RequestRoster(nil, true)`. Type-guarded so the plain-table Roster
  fixture in `tests/preview_dump.lua` (no methods) stays a no-op. Presence
  reads Roster; the book does not need this kick.

### `addon/ChurchOfBeef/Net/BeefNet.lua`
- `Net:NotifyStatus` deleted with its three call sites (`OnRosterUpdate`,
  `_ScheduleRosterRetries`, and the `Roster:SetOnChanged` registration in
  `Net:Init`) — the status chip it refreshed is gone. `_WarnVersion` is
  exactly as it was: the one permitted Quiet notice.

### `addon/ChurchOfBeef/UI/Toasts.lua`
- Small-toast engine removed: `Toasts:Show`, `Toasts:Push`,
  `Toasts:Celebrate`, `Toasts:PendingCount`, `Toasts:ShowingKind`, the
  queue/pump (`pending`, `recentKeys`, `gen`, `arrivalSeq`, `normalize`,
  `KINDS`, dedupe, interrupt), the small `ChurchOfBeefToast` frame, its
  motion helpers (`ensureMotion` / `stopMotion` / `fadeIn` / `fadeOutThen` /
  `present` / `pump` / `interruptShowing` / `resetAnchor` / `tryBackdrop` /
  `probeAlpha` / `animGroup`), and `wireSmallOnHide`. Zero callers existed in
  `addon/`.
- Kept byte-for-byte: `InitTheater`, `Proclaim`, the theater beats
  (sanction / verdict / cowardice / knighting / elevation), the clerical
  copy, dress, chat echo, cue names, and the ESC / `UISpecialFrames`
  behavior. `HideAll` is now theater-only (`hideTheater` +
  `rememberSpecial(PROCLAIM_NAME)`). `Init` delegates to `InitTheater`
  (theater root now builds hidden at login instead of the small frame).
  `ResetForTests` stays as the harness hatch (HideAll under `_IN_TEST`).

### Tests
- `tests/test_ui.lua` → `tests/test_toasts.lua` (renamed/rewritten):
  Proclaim theater only. Shell, Status-chip, and small-toast engine pins
  died with their subjects. New retirement pins: `Toasts.Show` / `Push` /
  `Celebrate` / `PendingCount` / `ShowingKind` are nil, no
  `ChurchOfBeefToast` frame or `UISpecialFrames` listing, source-level bans
  on the removed engine; `Init` delegates to `InitTheater`; HideAll/Init
  remount pins re-pointed at `ChurchOfBeefProclaim` only. All theater copy /
  dress / ESC / timed-hide / Quiet-gate pins kept.
- `tests/run.lua`: `test_ui` → `test_toasts` in the suite contract.
- `tests/test_wire_glue.lua`: added a `Hud.Refresh` spy; each of the four
  verdict sections now pins card Hide + HUD Refresh (+1 each); new CloseRite
  section (hides card; EndEvent still hides; inspecting CloseRite stays
  silent); new inbound-STATE section (RITE+fighters shows, CONSEQUENCE hides,
  QUIET hides); PostDecree pins the banner Show via the `Decree:Set` wrap;
  new inbound-DECREE section (banner shows on accept; `Decree:Restore` does
  not show); the `/beef` fall-through section now spies
  `RecordsBook:ToggleHome` instead of `COB.UI.Toggle`, plus a not-ready
  fallback pin; `Decree.Set` saved/restored with the other wraps.
- `tests/test_minimap.lua`: left-click and `/beef` fall-throughs drive a
  `RecordsBook:ToggleHome` spy; right-click Decree replay unchanged.
- `tests/test_decree_ui.lua`: OPEN CHURCH BOOK drives a
  `RecordsBook:ToggleHome` spy (installed after the isolation pins so they
  still prove the module is not loaded); absent-book click is a silent
  no-op; minimap left-click pins re-pointed; `COB.UI` spy removed and the
  isolation pin is now `COB.UI == nil`.
- `tests/test_console.lua`: new `runRosterKick()` — Show attaches + refreshes
  the roster, kicks `RequestRoster(nil, true)` only while not ready, and is
  a no-op with no Roster/Net.
- `tests/test_fighter_card.lua`: unchanged — module pins (ESC, lastPair,
  persist, dress) live here; the new Hide triggers are glue-side and live in
  `test_wire_glue.lua` where the wraps are spied.
- `tests/preview_dump.lua`: not edited — it never dofiled MainFrame/Status
  and only reads `Toasts:Proclaim` / `ResetForTests`, which stay.
- `tests/wow_ui_stub.lua`: not edited — nothing needed it.

## Test counts (standalone runs; `if standalone` isolation pins included)

| Suite | Before | After |
|---|---|---|
| `test_ui` → `test_toasts` | 873 | 493 |
| `test_wire_glue` | 653 | 724 |
| `test_minimap` | 173 | 173 |
| `test_decree_ui` | 757 | 761 |
| `test_console` | 2623 | 2644 |
| `test_fighter_card` | 914 | 914 |

Red phase (new pins failing before implementation): test_toasts 22,
test_wire_glue 22, test_minimap 9, test_decree_ui 5, test_console 5.

Full harness: `lua tests/run.lua` → **15905 → 15611 passed, 0 failed,
exit 0**. The −294 is the retired shell / chip / small-toast-engine coverage
dying with its subjects, per the brief.

Preview: `COB_PREVIEW_DIR=$(mktemp -d) lua tests/preview_dump.lua` →
**exit 0**, 13 scenarios at 1024x768 (console scenario's plain-table
`COB.Roster` fixture exercises the type-guarded kick as a no-op).

## Grep proofs

- `COB.UI` anywhere in `addon/`: **zero matches**.
- `MainFrame` / `Status` / `Toasts:Show` outside the deleted files: only
  retirement pins in `tests/test_toasts.lua` (asserting absence), stale
  *comments* in `tests/test_decree_ui.lua` / `tests/test_console.lua` /
  `tests/test_sound.lua` / `tests/test_records.lua` / `tests/wow_ui_stub.lua`
  headers ("does not load MainFrame" — still literally true), and historical
  docs (`CURSOR_REWORK_HANDOFF.md`, `.cursor/rules/addon-module-layers.mdc`)
  — see Concerns. No live code references.
- `OnStatusChanged` / `RefreshLadder` / `statusChip` in `addon/`: zero
  matches. `ui.shown` remains only in `Core/DB.lua` defaults (per the brief)
  plus a comment.
- TOC: every listed file exists; `## Interface: 20506`.

## Hard-rule check

Lua 5.1 (ran on 5.1.5); multi-return errors kept; no new getters; Core and
Data untouched; no dress or copy changes on any surface (proclamation copy
byte-for-byte, pinned); Quiet Mode stays minimap + Decree — the Decree banner
on post is the §14.1 feature itself, and the §13.4 version-mismatch chat line
remains the only Quiet *notice*; no new chrome, no new wire fields, no
auto-timer; nothing committed; `WTF/` untouched; no renders regenerated
(preview wrote to a mktemp dir).

## Concerns

1. **Pope-client STATE echo re-shows the card right after the verdict hide.**
   The contract was implemented verbatim: verdict wraps hide the card on the
   Pope client; the `_HandleState` glue shows on RITE-with-fighters and hides
   on CONSEQUENCE/QUIET. The verdict STATE is RITE carrying the lastPair
   overlay (pinned by the existing B10 pins), and a client's own GUILD addon
   traffic echoes back (that is why `Net:IsSelf` exists). So on the Pope
   client the verdict-click hide is followed a beat later by the echo
   re-showing the card; it finally dies at CloseRite (wrap and CONSEQUENCE
   echo agree). Congregation clients match the intent exactly (card lives
   through the verdict beat, dies at CONSEQUENCE). If the product wants the
   Pope's card to stay gone from the ruling click, that is a product decision
   (e.g. skip the card show for self-originated STATE, or stop overlaying
   lastPair into RITE for the Pope's own client) — not invented here. The
   harness never exercises the echo for the card (loopback is opt-in in the
   stub), so this is unpinned in both directions.
2. **Stale rule text.** `.cursor/rules/architecture-overview.mdc` still lists
   `COB.UI:Init()` / `COB.UI:Toggle()` as entry points, and
   `.cursor/rules/addon-module-layers.mdc` still maps `COB.UI` →
   `UI/MainFrame.lua`. Both describe retired scaffolding. Out of this lane's
   scope (rules are not `docs/` and not the brief's files) — flagged for the
   rules owner.
3. **`Toasts:Init` now builds the (hidden) theater root at login** instead of
   the small toast frame; `InitTheater` was previously lazy on first
   Proclaim. One hidden insecure full-screen frame, no `OnUpdate` — inside
   the performance law, noted because it is an eager-build change.
4. `wow_ui_stub.lua` comments still name MainFrame as the
   BasicFrameTemplate consumer; cosmetic, left untouched per "touch only if
   something above needs it."

## Fix wave 1

Review came back Approved with one Important, plus one orchestrator-adjudicated
defect (Concern 1 above). TDD per finding: failing assertion first, watched
red, fixed, green. Lua 5.1.5; no Core edits; nothing committed.

### 1. Adjudicated defect — Pope-client STATE echo re-shows the fighter card

**What changed:** `addon/ChurchOfBeef/ChurchOfBeef.lua`, the `_HandleState`
glue wrap only. The card show/hide branch now skips when the sender is the
local player, via the existing `Net:IsSelf` pattern (guarded:
`type(self.IsSelf) == "function" and self:IsSelf(sender) == true`). The skip
is scoped to the card branch — `paintInboundFavor` / `paintInboundInputs`
keep their pre-existing self-echo behavior. The Pope's card now has exactly
one show source (the Sanction wrap); congregation clients are unchanged.

**Test evidence:** new pin block in `tests/test_wire_glue.lua` — local player
stubbed as a registered Pope, an inbound RITE-with-fighters STATE from the
local player's own name fires neither the card-show nor card-hide spy (favor
and inputs self-echo paints pinned as unchanged); the same STATE from a
different registered-Pope name still shows the card.

```
$ lua tests/test_wire_glue.lua   # red, before the fix
FAIL: self-echo RITE with fighters does not Show the fighter card expected 0 got 1
FAIL: another registered Pope's RITE with fighters still Shows the card expected 1 got 2
Tests finished: 747 passed, 2 failed
$ lua tests/test_wire_glue.lua   # green, after the fix
Tests finished: 749 passed, 0 failed
```

### 2. Important — bootstrap initUi harness coverage

**What changed:** `tests/test_wire_glue.lua` only (it already loads
`ChurchOfBeef.lua`). New block stubs each of the ten UI modules (Minimap,
RecordsBook, Hud, Console, Toasts, DecreeBanner, Sound, FighterCard, Inputs,
Markers) with an Init spy recording call order, stubs `COB.Net.Init` and a
`COB.InstallWire` spy, then calls `COB:OnLogin()` twice. Pins: (a) all ten
Init calls fire in the contract order; (b) a throwing `Console.Init` does not
prevent later modules' Init (pcall shape) and `InstallWire` still runs;
(c) Net Init and InstallWire run on each OnLogin. Every stubbed key is
saved and restored (12 saves). The InstallWire spy keeps the block from
double-wrapping the real modules; the real install is covered by the rest of
the suite.

**Test evidence:** the pins pass against the shipped `initUi` (coverage gap,
not a behavior bug). Sensitivity proven by mutation: stripping the `pcall`
around `Console.Init` aborts the suite at the throwing-Init OnLogin
(`ChurchOfBeef.lua:53: in function 'OnLogin'`); swapping two modules' Init
order reddens both order pins
(`expected Minimap,RecordsBook,... got RecordsBook,Minimap,...`). Reverted;
green. Counts included in the suite totals above (724 → 749: +12 self-echo
pins, +6 initUi pins, +7 `reset()` asserts in the new block).

### 3. Minor — orphaned Minimap:Refresh

**What changed:** `addon/ChurchOfBeef/UI/Minimap.lua` — `MinimapButton:Refresh`
removed (its only production caller was the retired shell's RefreshLadder).
Stale comments fixed: the `IsShown` comment now reads "/beef minimap asks
IsShown/SetShown before Init has built the button" (was "before UI:Init has
built anything"); the "Callers (shell refresh) may still invoke this" comment
died with the function. `tests/test_decree_ui.lua` — removed the one call
line (`COB.Minimap:Refresh()` in the tooltip section; the tooltip pins are
untouched and still pass, since OnEnter fills live). `tests/test_minimap.lua`
— added the retirement pin `COB.Minimap.Refresh == nil` beside the other
retirement pins.

```
$ lua tests/test_minimap.lua     # 173 → 174 passed, 0 failed
$ lua tests/test_decree_ui.lua   # 761 passed, 0 failed
```

Grep proof: `Minimap:Refresh` / `MinimapButton:Refresh` anywhere outside
`docs/` → only the retirement pin in `tests/test_minimap.lua` asserting
absence.

### 4. Minor — FighterCard.lua header orphan line

**What changed:** header comment only. The Lane T edit split "ESC Hide()s
the named frame via UISpecialFrames (deduped)." across the "-- EndEvent. ESC
Hide()s the named / frame via ..." line break; the sentence is re-wrapped
whole. No code touched.

```
$ lua tests/test_fighter_card.lua   # 914 passed, 0 failed (unchanged)
```

### 5. Minor — runRosterKick save/restore

**What changed:** `tests/test_console.lua` — `runRosterKick` now saves
`COB.Roster` / `COB.Net` on entry and restores both after the section's
trailing `reset()` (the restore sits after `reset()` because `reset()` nils
`COB.Roster` by suite convention; the Net restore is the one that matters
cross-suite in the shared harness process). Matches the saved*/restore
pattern used elsewhere in the suite.

```
$ lua tests/test_console.lua     # 2644 passed, 0 failed (unchanged count)
```

### Full verification

```
$ lua tests/run.lua              # 15611 → 15637 passed, 0 failed; exit 0
$ COB_PREVIEW_DIR=$(mktemp -d) lua tests/preview_dump.lua   # exit 0; 13 scenarios at 1024x768
```

`COB.UI` in `addon/`: still zero matches. No commits; `WTF/` untouched; no
renders regenerated (preview wrote to a mktemp dir).

### Concerns

None new. Concern 1 from the original report is resolved by fix 1 above;
concerns 2–4 (stale rule text naming the retired shell, eager theater-root
build at login, stub comment naming MainFrame) stand as flagged for their
owners — out of this fix wave's scope.
