# Lane W — Wire simplification report

Brief: `docs/reformation/ux-rebuild/briefs/W-wire-simplify.md`. TDD: suites changed first, new assertions watched failing on the isolated suites, then implemented, then green, then full harness.

## What changed, per file

### `addon/ChurchOfBeef/Net/BeefNet.lua`

- New `defaultDest()` / `resolveDest()` locals next to `destName`. Resolution order: explicit caller target → `Net._lastStateSender` → `COB.Popes.List[1]` (guarded for absence; non-empty string only) → refuse. `destName` trim is applied to whichever source wins. No roster lookup, no SavedVariables; a self dest is not skipped.
- `Net:SendFavor`, `Net:SendPetition`, `Net:SendConfession`, `Net:RequestSnapshot` now resolve through `resolveDest` and only refuse `false, "no target"` when nothing resolves. `Net:SendSnapshot` (Pope-gated) is unchanged — still caller-supplied dest.
- `_HandleV2` STATE branch sets `Net._lastStateSender = sender` (raw sender string) whenever `COB.Sender:Accept(sender, "STATE")` passes. SNAPSHOT / DECREE / INPUT never set it; rejected senders never set it; version-mismatch discards never reach it.
- `Net:HandleHello` pcalls `COB._OnPeerHello(sender)` after the peer-record step, only on the compatible non-self path that returns `true`. Missing callback is a no-op; errors are swallowed.
- `Net:ResetForTests` also clears `_lastStateSender`.
- No new message types, opcodes, or peer SYNC. No SUMMON.

### `addon/ChurchOfBeef/ChurchOfBeef.lua`

- `InstallWire` now installs `COB._OnPeerHello = function(sender) ... end`: no-ops unless `COB.Runtime:Snapshot().state` is a string other than `"QUIET"` and the local player is a registered Pope (`COB.Sender:IsRegisteredPope(UnitName("player"))`, existing local-sender pattern); then calls the same pcall-guarded `sendState()` (`stateFields()` + `COB.Net:SendState`) the other glue wrappers use. No UI refresh, no toast, no sound; quiet no-op on congregation clients and in QUIET; missing Runtime/Net return quietly.
- Deleted the `/beef petition`, `/beef confess`, `/beef catchup` subcommand blocks and the now-unused `bindSlashInputTarget` helper. `/beef`, `/beef minimap`, `/beef console` stay; unrecognized arguments (including the three removed verbs) still fall through to `COB.UI:Toggle()` (Records Book). Subcommand comment updated.
- Kept the inbound-STATE → `Inputs:SetInputTarget(sender)` binding (`paintInboundInputs`) untouched.

### `addon/ChurchOfBeef/UI/Inputs.lua`

- Shrunk to the one-button Petition strip: frame, TitleBar drag handle + `ChurchOfBeefDB.ui.inputs` position persist, `SetInputTarget` (trim law unchanged), `SetLocalCharacterId`, `GetView` (copy), `Refresh`, `Show`, `Hide`, Event-Mode-only visibility, recipient display, Petition button with the named-opponent-from-`UnitName("target")` behavior (pcalled reads, trim, dest-same/player-same omission all unchanged).
- Removed: the Confession edit box (`InputBoxTemplate`, placeholder, `OnEscapePressed`/`SetMultiLine` wiring), `Inputs:Confess`, the Catch-up button, `Inputs:Catchup`, and the now-dead `refreshPlaceholder` helper. `paintHidden` no longer blanks box text.
- Recipient line resolves the effective destination: bound target → `COB.Popes.List[1]` (guarded) → `"No recipient"`.
- Petition availability may rely on the Net default: `readyToSend` refuses `"no target"` only when neither a bound target nor a listed Pope exists; event-live and local character id are still required. `Inputs:Petition` passes the raw bound target (nil when unbound) so Net's `_lastStateSender` default can outrank the listed Pope.
- Frame HEIGHT 92 → 64 (title bar + one button row); WIDTH 360, button stock `UIPanelButtonTemplate` at BOTTOMLEFT 12,10, GameFontHighlight scan, and the "no Pope-name lookup beyond `COB.Popes.List`" law all kept.

### `addon/ChurchOfBeef/UI/Hud.lua`

- `clickPlate` no longer returns early on a blank `favorTarget`; a plate click always attempts the pick (still requires a live sanctioned pair via `pickPair()` and a numeric local character id).
- `Hud:PickFavor` no longer refuses a missing/blank target; it passes the target through so `Net:SendFavor` resolves the default destination. `"no character"` and `"no net"` refusals unchanged. `Hud:SetFavorTarget` and the `favorTarget` persist behavior stay as an override. No other HUD behavior touched.

### Tests (changed first, watched red, then green)

- `tests/test_net_v2.lua` — added three Lane W sections: default-dest resolution order (explicit > `_lastStateSender` > `Popes.List[1]` > refuse; trim on the winning source; self-dest legal; empty/whitespace/absent list refuses), `_lastStateSender` set only on accepted STATE (rejected sender, accepted SNAPSHOT/DECREE/INPUT never set or overwrite it; `ResetForTests` forgets it), and `_OnPeerHello` fired only on compatible non-self HELLO (absent function, self-HELLO, version-mismatch, and throwing-callback paths safe).
- `tests/test_wire_glue.lua` — pins `_OnPeerHello` is absent at dofile and installed by `InstallWire`; sends STATE on GUILD when event live + local registered Pope (including end-to-end via `Net:HandleHello`); no send in QUIET; no send on a non-Pope client; missing Runtime/Net swallowed; no furniture refresh or Proclaim from the callback. Removed the `/beef petition|confess|catchup` pins; new pins show all three fall through to the Records Book toggle and never touch Inputs.
- `tests/test_inputs.lua` — rewritten around the Petition-only strip: `Inputs.Confess == nil`, `Inputs.Catchup == nil`, no EditBox/Confess/Catch-up chrome, recipient display resolution (bound target > listed Pope > none), Petition requires event-live + character id and sends with nil target when a listed Pope exists (Net default), full opponent-naming matrix kept, drag/persist and Quiet/Event visibility kept, source-contract pins updated (no `InputBoxTemplate`/`OnEscapePressed`/`Confess`/`Catchup`/`SendConfession`/`RequestSnapshot`; `COB.Popes` read now expected; still no `IsRegisteredPope`/`LookupPope`/`FindPope`).
- `tests/test_hud.lua` — plate click without a bound favor target now sends through Net (spy on `Net:SendFavor`, nil target recorded); explicit `SetFavorTarget` still wins; `PickFavor` missing-character refusal kept; missing-target refusal pins converted to send-through pins.

## Test counts (standalone suite runs)

| Suite | Before | After |
|---|---|---|
| `test_net_v2` | 727 passed, 0 failed | 821 passed, 0 failed |
| `test_wire_glue` | 627 passed, 0 failed | 663 passed, 0 failed |
| `test_inputs` | 980 passed, 0 failed | 528 passed, 0 failed |
| `test_hud` | 954 passed, 0 failed | 965 passed, 0 failed |

Before-counts were measured against the pre-lane working tree reconstructed in a throwaway copy (the touched files already carried other lanes' uncommitted changes, so HEAD was not the before-state); the reconstruction harness ran green, and `test_inputs` before = 17635 (measured pre-lane full harness) − 16655 (reconstruction without the suite) = 980. The `test_inputs` drop is the intended removal of the Confess/Catchup assertion matrix; the Petition/opponent/drag/persist pins were carried over.

## Full harness

`lua tests/run.lua` from the workspace root: **17280 passed, 0 failed, exit 0** (baseline before the lane: 17635 passed, 0 failed). No suite weakened outside the removed Confess/Catchup surface; unrelated pins kept.

## Concerns

- **"ESC behavior intact" vs. box removal:** the brief's contract removes the Confession edit box, and the only ESC behavior was that box's `OnEscapePressed` → `ClearFocus`. I read "drag/persist/ESC behavior intact" as covering what survives the box removal; the rewritten suite pins the box's absence (no EditBox child, no `OnEscapePressed` in source) and keeps the not-on-`UISpecialFrames` pin. If the intent was to keep some panel-level ESC behavior, that needs a named follow-up.
- **Frame height:** HEIGHT went 92 → 64 with the box and two buttons gone; old 92px pins were tied to the removed layout.
- **`_lastStateSender` channel:** set on any Accept-passing STATE regardless of channel, per the brief's literal wording ("whenever an inbound STATE message passes sender auth"). A whispered STATE from a registered Pope still fails `_HandleState`'s GUILD check as theater, but would record the sender; harmless, since the sender is a registered Pope either way.
- **Inputs-layer availability vs. `_lastStateSender`:** the Petition button/verb check knows only bound-target/listed-Pope; a bare `_lastStateSender` with neither would still send at the Net layer but reads "No recipient" on the strip. In practice unreachable: the kept inbound-STATE → `SetInputTarget` binding binds the target whenever a STATE is accepted.
- **In-game smoke not run** (harness-only lane). Per `verification.mdc`, Net/UI/slash changes still want install → `/reload` → path exercise, and guild-net behavior (HELLO re-broadcast) wants the two-client check — left for the human pass.
