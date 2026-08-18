# Integrator — bootstrap SendState / Decree glue (after W-E and W-F)

**Exclusive files (integrator only):**
- `addon/ChurchOfBeef/ChurchOfBeef.lua`
- `ChurchOfBeef.toc` (only if a file already exists and must be listed — do not list missing files)
- `tests/run.lua` (only if a suite must be added — do not invent suites)
- `docs/REFORMATION_LOG.md` (verdicts)
- `docs/phases/two-client-smoke.md` (honesty table: DECREE live; favor INPUT live as whisper-to-Pope only)

**Do not edit** lane-owned files. **Do not commit.**

## Glue (layer law)

UI and Core stay Net-free. `ChurchOfBeef.lua` wraps after load. Call `COB:InstallWire()` from `OnLogin` (idempotent). Do not wrap at file-load time (minimap suite dofiles bootstrap without wanting sends).

1. **Runtime verbs → `Net:SendState`** after a successful `StartEvent` / `OpenRite` / `CloseRite` / `Continue` / `EndEvent`. Also after successful `Gora:RecordFavor` (live split) and `Console:SetCongregationFavorVisible` (toggle change). Fields from `Runtime:Snapshot()` (`eventId`, `state`, `riteType`, `subjects`, `sequence`). Include `favor = Gora:GetFavorSplit()` **only when** `Console:GetCongregationFavorVisible()` is true **and** `Gora:GetSanctioned()` is a live pair. Else omit favor.
2. **Post Decree → `Net:SendDecree`**: wrap `Console.PostDecree` (not `Decree.Set`) so inbound `_HandleDecree` and `InspectProgress` (direct `Decree:Set`) do not broadcast. Skip all sends while `COB._inspecting` is true; set that flag around the existing InspectProgress body.
3. **Inbound STATE / SNAPSHOT-response → HUD**: wrap `Net._HandleState` and `Net._HandleSnapshot`. On accepted STATE (or snapshot response with `decoded.favor`), `Hud:SetFavorTarget(sender)` and `Hud:SetBroadcastFavor(decoded.favor or nil)` then `Hud:Refresh`. Toggle-off STATE has no favor field → `SetBroadcastFavor(nil)`.
4. **Local picker id**: if Store snapshot has a character whose `Names.Key(name)` matches `UnitName("player")`, `Hud:SetLocalCharacterId(id)`. Do not invent a Pope name. Empty `Data/Popes.lua` still fail-closed.

Do not invent a Pope name. Empty `Data/Popes.lua` still fail-closed.

Optional: remember last accepted STATE sender on Net (if you must touch Net, that is **not** this brief — leave a named follow-on). HUD `SetFavorTarget` / `SetBroadcastFavor` can be called from bootstrap when STATE arrives **if** you can do it without Net→UI. Preferred: bootstrap OnAddonMessage after Net:OnAddonMessage, or a small Core holder. If that requires a new Core file, **stop** and note BLOCKED — do not add files in this glue.

## After glue

```bash
lua tests/run.lua
```

Conformance grep (0 Criticals): no favor persist to SV; no favor history/streak/economy; no congregation favor when toggle off; no narration; Quiet silent.

Then **stop**. Hand David `docs/phases/two-client-smoke.md`. Do not open Vestments. Do not claim Gate W closed.
