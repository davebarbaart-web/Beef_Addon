# Lane W — Wire simplification (UX rebuild)

You are working in `/Volumes/AI_Design_Drive/Beef_Addon`, a WoW TBC Classic Anniversary addon (Lua 5.1, plain global `ChurchOfBeef` / `COB`). Read these first, they are binding:

- `.cursor/rules/ten-laws.mdc`, `.cursor/rules/architecture-overview.mdc`, `.cursor/rules/verification.mdc`
- `.cursor/rules/lua-cob-modules.mdc`, `.cursor/rules/ceremony-runtime.mdc`, `.cursor/rules/testing.mdc`, `.cursor/rules/toc-lifecycle.mdc`
- `.agents/skills/church-of-beef-dev/SKILL.md` (operational loop)

## Where this fits

David (product owner) approved a UX rebuild. This lane is the wire layer: congregation sends stop demanding a caller-supplied whisper target, late joiners stop needing a manual catch-up action, and three slash subcommands die. Later lanes rebuild the Director Console and Records Book on top of this wire. Do not build any of that here.

## Binding contract

### 1. Default whisper destination in `addon/ChurchOfBeef/Net/BeefNet.lua`

Today `Net:SendFavor(fields, target, nowSeconds)`, `Net:SendPetition(fields, target, now)`, `Net:SendConfession(fields, target, now)`, and `Net:RequestSnapshot(target, nowSeconds)` all refuse with `false, "no target"` when `target` is missing/blank. Change: when `target` is missing or blank, resolve a default destination before refusing:

1. `Net._lastStateSender` — set this new field inside `_HandleV2` whenever an inbound **STATE** message passes sender auth (`Sender:Accept(sender, "STATE")`). Store the raw sender string.
2. Else the first entry of `COB.Popes.List` (`COB.Popes` is loaded from `Data/Popes.lua`; guard for absence) when it is a non-empty string.
3. Else refuse `false, "no target"` as today.

Apply the existing `destName` trim to whichever source wins. An explicit caller `target` always wins over the default. Do not look up the Pope by guild roster, do not read SavedVariables, do not skip the send when the resolved dest is the local player (self-whisper is legal and harmless).

### 2. Pope re-broadcasts STATE on guildmate HELLO

In `Net:HandleHello(message, sender)`, after the existing peer-record step (and only when the message was compatible and not self — i.e. on the path that currently `return true`), pcall `COB._OnPeerHello(sender)` when `type(COB._OnPeerHello) == "function"`. Errors are swallowed. No other change to HandleHello. No new message types, no new opcodes, no peer SYNC.

### 3. Bootstrap glue in `addon/ChurchOfBeef/ChurchOfBeef.lua`

- In the InstallWire section, set `COB._OnPeerHello = function(sender) ... end`. The callback: if `COB.Runtime` and `COB.Runtime.Snapshot` exist and the snapshot's `state` is a string other than `"QUIET"`, and the local player is a registered Pope (`COB.Sender:IsRegisteredPope(UnitName("player"))` — follow the file's existing local-sender pattern), then call the same send-state path the other glue wrappers use (the existing `stateFields()` + `COB.Net:SendState(...)` pattern, pcall-guarded like its neighbors). It must no-op quietly on a congregation client or in QUIET. It does not refresh UI, does not toast, does not play sound.
- Remove the `/beef petition`, `/beef confess`, and `/beef catchup` subcommand blocks from `SlashCmdList["CHURCHOFBEEF"]` and delete the now-unused `bindSlashInputTarget` helper. `/beef`, `/beef minimap`, and `/beef console` stay. Unrecognized arguments still open the Records Book. Update the subcommand comment above the handler.
- Keep the existing inbound-STATE → `Inputs:SetInputTarget(sender)` binding (it is what makes favor plates work before any default exists).

### 4. `addon/ChurchOfBeef/UI/Inputs.lua` shrinks to one Petition button

The Event Inputs strip keeps: frame, drag handle + position persist, `SetInputTarget`, `SetLocalCharacterId`, `GetView`, `Refresh`, `Show`, `Hide`, Event-Mode-only visibility, recipient display, and the Petition button (including the named-opponent-from-`UnitName("target")` behavior).

Remove: the Confession edit box and `Inputs:Confess`, the Catch-up button and `Inputs:Catchup`, and all now-dead helpers/persist for them. The recipient line should show the effective destination: the bound target when set, else the listed Pope (`COB.Popes.List[1]`) when present, else the existing "No recipient" state. Petition availability may rely on the Net default — a missing bound target no longer disables Petition when a listed Pope exists.

### 5. `addon/ChurchOfBeef/UI/Hud.lua` favor plates use the Net default

`clickPlate` currently returns early when `favorTarget` is blank. Remove that early return so a plate click always attempts the pick (still requires a live sanctioned pair and a local character id); `Net:SendFavor` now resolves the default destination. `Hud:SetFavorTarget` and the `favorTarget` persist behavior stay as an override. Do not touch any other HUD behavior.

## Tests (TDD: change suites first, watch them fail, then implement)

- `tests/test_net_v2.lua` — default-dest resolution order (explicit target > `_lastStateSender` > `Popes.List[1]` > refuse), `_lastStateSender` set only on accepted STATE (not on rejected sender, not on SNAPSHOT/DECREE/INPUT), `_OnPeerHello` pcall-fired on compatible non-self HELLO only (absent function, self-HELLO, and version-mismatch paths must not error or fire).
- `tests/test_wire_glue.lua` — `_OnPeerHello` installed by InstallWire; sends STATE when event live + local registered Pope; no send in QUIET; no send on a non-Pope client; swallows missing Runtime/Net. Remove pins for the deleted slash subcommands; pin that `petition`/`confess`/`catchup` now fall through to the Records Book toggle (or whatever unrecognized-argument behavior the file documents).
- `tests/test_inputs.lua` — rewrite around the Petition-only strip: no Confess/Catchup API (`Inputs.Confess == nil`, `Inputs.Catchup == nil`), recipient display resolution (bound target > listed Pope > none), Petition still requires event-live + local character id and still attaches a named opponent from `UnitName("target")` when appropriate, drag/persist/ESC behavior intact.
- `tests/test_hud.lua` — plate click without a bound favor target now sends through Net (spy on `Net:SendFavor`); explicit `SetFavorTarget` still wins.

Suites must keep every pin that covers behavior this lane did not touch. Do not weaken unrelated assertions to make the run green.

## Hard rules

- Lua 5.1. Multi-return errors (`return nil, "reason"`), never `error()` for expected failures. Getters return copies.
- Core stays pure; this lane touches Net/UI/bootstrap only.
- No new message types or opcodes. No peer SYNC. No Pope-name lookup beyond `COB.Popes.List` and `_lastStateSender`. No SUMMON.
- Ten Laws: no points, no auto-advance, no narration, Pope-only writes, Quiet stays quiet (no new Quiet chrome, no toasts, no sound).
- Do not edit `ChurchOfBeef.toc` (no files are added or removed in this lane).
- Do not edit `docs/` except your report. Do not commit. Do not touch `WTF/`.
- `lua tests/run.lua` from the workspace root must exit 0 when you are done.

## Report

Write your full report to `docs/reformation/ux-rebuild/briefs/W-wire-simplify-report.md`: what changed per file, test counts before/after per touched suite, full-harness result, and any concerns. Return only: status (DONE / DONE_WITH_CONCERNS / BLOCKED / NEEDS_CONTEXT), one-line test summary, and concerns if any.
