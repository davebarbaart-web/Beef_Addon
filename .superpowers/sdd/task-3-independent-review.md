# Task 3 independent review — Slash honesty + console gate

Read-only review of the listed functions. No harness re-run. Controller note treated as context, not as a pass.

### Spec Compliance

- ✅ Unknown `/beef` args print help and do not `PlayerCard:Toggle` — `ChurchOfBeef.lua:641-644`; inverted pins at `tests/test_wire_glue.lua:1264-1266` and `tests/test_minimap.lua:320-327`. Retired `petition` / `confess` / `catchup` take the same path (`test_wire_glue.lua:1276-1277`).
- ✅ `/beef help` is one congregation line: bull / `/beef` opens your name; Ask to fight; pick a side when two names appear. It does not name the Director Console or advertise `/beef console` — `ChurchOfBeef.lua:599`; `test_wire_glue.lua:1267-1274`.
- ✅ Listed Pope may get a second line: `The desk is /beef console.` — `ChurchOfBeef.lua:600-604` (`Sender:IsRegisteredPope` on `UnitName("player")`).
- ❌ `Console:Show` is not gated for non-Popes before the 560×600 desk is built or shown. The guard is `if not self.frame and not isRegisteredPope() then return end` (`UI/Console.lua:1528-1531`; same on `Toggle` at `1576-1578`). That only blocks lazy mint. `PLAYER_LOGIN` `initUi()` always calls `Console:Init()` (`ChurchOfBeef.lua:39`), so after login `self.frame` exists and `/beef console` (`ChurchOfBeef.lua:631-638`) shows the desk. `applyGate` (`UI/Console.lua:1225-1238`) only disables verbs and paints `not a registered pope`; it does not hide the frame.
- ✅ Verbs still refuse with the exact string `not a registered pope` — `UI/Console.lua:53`; `tests/test_console.lua:509` and the rest of `runPopeGate`.
- ✅ `tests/test_console.lua` header still forbids slash tests (`test_console.lua:13-14`). No `SlashCmdList` pins in that suite.
- ✅ `reset()` (`test_console.lua:76-90`) does not force `IsRegisteredPope` true. Fail-closed pin remains at `test_console.lua:347-348`. Non-Pope Show pin is present at `test_console.lua:350-359`.
- ⚠️ Cannot verify from diff: SCHEMA 7, no congregation Ensure, no inbound Proclaim. Not in the inspected functions. `## Interface: 20506` still on the TOC (supporting file, not in the listed slice).

### Strengths

- Slash honesty matches the brief: bare `/beef` toggles the card; unknown and retired args print help; congregation help stays night-facing and does not advertise the desk.
- Pope desk line is correctly listed-Pope-only and uses the same `IsRegisteredPope` predicate as the rest of the star.
- Verb refuse string is untouched. Console suite header and `reset()` stay fail-closed.
- Isolated non-Pope pin exists for the pre-Init case (`test_console.lua:350-359`).

### Issues

**Critical**

- Congregation can open the Director Console after a normal login. `Show`/`Toggle` refuse mint only when `self.frame` is nil. Live clients always Init the desk first (`ChurchOfBeef.lua:34-49`), then slash `console` calls `Show` with the frame already built. The brief required gating `Show` itself (and `stubPope()` on existing Show paths). The controller’s “cannot mint” reading does not hold on the login path: the desk is already minted, then shown. Congregation sees administration chrome (Bible §18.5) with dead buttons. The pin at `test_console.lua:350-359` does not cover this; `runLifecycle` (`test_console.lua:364-399`) Inits first, then Toggle/Show without a Pope stub — that is the live hole, encoded as the happy path.

**Important**

- Listed-Pope help second line is implemented and unpinned. `test_wire_glue.lua:1271-1274` checks `/beef help` without stubbing Pope, so a regression that always prints the desk line, or never does, is not caught.
- Non-Pope pin replaces `Sender.IsRegisteredPope` with `function() return false end` and never restores it (`test_console.lua:352`). Fail-closed for later verbs, but it drops the real predicate for the rest of the file.

**Minor**

- `test_wire_glue.lua:1238-1240` still says retired slash args “fall through to the player card.” The pins now assert the opposite.
- `test_minimap.lua:311` section title still says everything else is the player card.

### Assessment

Slash honesty is done. The console gate is not: it protects a path the client does not take, and leaves the path it does take (`Init` at login, then `Show`) open. Fix is the brief’s original shape: `Show`/`Toggle` return unless `isRegisteredPope()`, then Init; existing Show paths that expect a visible desk call `popeOn()` / `stubPope()`. Optional: stop calling `Console:Init()` from congregation `initUi()`.

**Task quality:** Needs fixes

---

## Controller follow-up (same day)

Critical fixed: `Console:Show` / `Toggle` now return unless `isRegisteredPope()` (`UI/Console.lua`). `test_console.lua` uses `popeOn()` on desk-visible paths; Init-then-Show without Pope stays hidden. `test_wire_glue.lua` pins congregation one-line help, listed-Pope second line (`/beef console`), and congregation `/beef console` after Init does not show. `lua tests/run.lua` 16323/0.
