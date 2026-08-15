# Phase 5 Lane C — Adversarial Review

**Lane:** Event Mode sound cues
**Exclusive files:** `addon/ChurchOfBeef/UI/Sound.lua`, `tests/test_sound.lua`, `docs/reformation/phase-5/reports/P5-C-sound.md`
**Lane report:** `docs/reformation/phase-5/reports/P5-C-sound.md`
**Cited law:** Ten Laws 6, 10; Bible §19.4, §19.1, §20.1, §20.3; `.cursor/rules/quiet-event-modes.mdc` (Sound); `.cursor/rules/ceremony-runtime.mdc` (awaitingPope); brief `docs/reformation/phase-5/briefs/P5-C-sound.md`
**Writer:** [Sound](6fec9432-0cf5-41d7-8966-883748542570)

**Spec:** PASS
**Quality:** Approved

Event Mode verb only. `Sound.MODE = "Event"`. `Play` allow-list is exactly `sanction`, `verdict`, `elevation`, `knighting`, `cowardice`. Quiet, missing Runtime, or a Snapshot that is not `ASSEMBLY` / `RITE` / `CONSEQUENCE` is a no-op. No load play. No `Init`. No addon media. No `PlaySoundFile`. No caller wiring. Isolated suite: **177 passed, 0 failed**. Writer stayed inside exclusive files. `OPEN_QUESTIONS.md` untouched. Appendix A #8 unanswered. No commit. This review did not invent kit ids, a sixth state, Canonization, or callers, and did not edit `Sound.lua` or the suite.

## Verdict

Refutation of Law 6, Bible §19.4, and “Quiet is silent / allow-list only / no media / no callers / no invented sixth state” **fails** for this lane’s exclusive files.

Law 6 is intact. The surface declares Event Mode. `Play` in `QUIET`, after `EndEvent`, after a valid QUIET `Restore`, with Runtime missing, or with a Snapshot that is not one of the three Event names, returns `nil, reason` and does not call `PlaySound`. File load and the absence of `Init` play nothing. `awaitingPope` is a flag on a live Event state — Event Mode degraded, not Quiet chrome, not a sixth name. Reviewer: `QUIET` plus a stubbed `awaitingPope = true` still mutes.

§19.4 is intact on the terms the brief set. Five MVP cue names only. Canonization seal is later and is not a method, not a key, and not a source token. Unknown names — including `canonization`, `summon`, `favor`, `grant`, `click`, `login`, `ambient` — play nothing. No ambient loop. No UI whoosh. No login jingle. `PlaySound` is called with the cue name string so the suite can record it; that is a stub, not a branded bell (Appendix A #8). `pcall` keeps a missing kit from erroring. `PlaySoundFile` is never called.

The writer did not invent `SOUNDKIT` ids, `RAID_WARNING`, `READY_CHECK`, a sixth runtime state, `holdSeconds`, auto-play on Runtime transitions, or a Master/channel argument. Console / Gora / Knighting / HUD do not call `Play`. TOC / bootstrap / `tests/run.lua` were not edited.

This review did not invent a kit map, a Canonization seal, or caller wires, and did not commit.

## Confirmations

| Check | Result |
|---|---|
| Quiet Mode is silent; `Play` in `QUIET` / missing Runtime is no-op; no load play; no `Init` play | **Yes.** Default Snapshot is `QUIET`. Suite: all five names return `nil, reason` and `#played == 0`. Missing Runtime / Runtime without `Snapshot` same. File-load counters are 0. `Sound.Init` is nil. Reviewer: `StartEvent` / `OpenRite` / `CloseRite` / `Continue` / `EndEvent` / `MarkPopeLost` auto-play nothing. Valid QUIET `Restore` mutes. |
| Allow-list only: `sanction`, `verdict`, `elevation`, `knighting`, `cowardice` | **Yes.** Those five record and, when present, `pcall(PlaySound, name)`. Banned set in the suite includes `canonization`, `Sanction`, `summon`, `favor`, `grant`, `standing`, `click`, `login`, `ambient`, `whoosh`, `pip`, `toast`, `#8`. Nil / numeric / empty / leading-space names rejected. No extra public keys on `Sound`. |
| Plays only in `ASSEMBLY` / `RITE` / `CONSEQUENCE`; `awaitingPope` is Event Mode degraded | **Yes.** Three-name gate. `MarkPopeLost` does not change `state`. Suite: `awaitingPope` still records `elevation`. Reviewer: `ASSEMBLY` + `awaitingPope` still records `sanction`. Invented `AWAITING_POPE` state is mute. `QUIET` + stubbed `awaitingPope` is mute. |
| No addon `.ogg` / `.mp3`; no `PlaySoundFile`; missing `PlaySound` does not error | **Yes.** `find` on `addon/ChurchOfBeef` for `.ogg` / `.mp3` / `.wav` / `.flac` is empty. Source has no `PlaySoundFile`, `PlaySoundKitID`, or `SOUNDKIT`. Missing `PlaySound` still returns the cue name. A throwing `PlaySound` is swallowed. Reviewer: `PlaySound` arity is 1 (no Master / channel). |
| No caller wiring | **Yes.** `Sound.lua` has no `COB.Console` / `COB.Gora` / `COB.Knighting` / `COB.Hud`. Addon grep: those four files, bootstrap, TOC, MainFrame, Minimap, Toasts, Net have no `Sound` / `PlaySound` / `Sound:Play`. |
| Isolation asserts wrapped in `if standalone then` | **Yes.** 19 `COB.* == nil` asserts in the standalone block (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Gora, Store, RecordsBook, Decree, Popes). |
| Writer did not invent `SOUNDKIT` ids, a sixth state, or auto-play on Runtime transitions | **Yes.** Source grep clean for `SOUNDKIT`, `AWAITING`, `holdSeconds`. No Runtime watcher. No `Init`. Transitions do not call `Play`. |
| Isolated suite green | **Yes.** Reviewer rerun, Lua 5.1.5: `lua tests/test_sound.lua` → **177 passed, 0 failed**. Writer count matches. Isolation asserts in `if standalone then`. |
| Writer did not edit TOC / bootstrap / `run.lua` / Runtime / Console / HUD / Gora / Knighting / Minimap / Toasts / MainFrame / Net, or add media | **Yes.** Transcript Writes: `tests/test_sound.lua` (first), `UI/Sound.lua`, this lane’s report. No StrReplace on forbidden files. Mtimes: suite 07:42:25, Sound 07:42:30, report 07:42:52. TOC 07:31:56; `run.lua` 07:29:32; Runtime 06:37; Console 07:28:45; Hud 07:28:51; Gora 07:16; Knighting 07:13; bootstrap / MainFrame / Minimap / Toasts Aug 14; BeefNet 07:02. TOC does not list `UI\Sound.lua`. `run.lua` does not list `test_sound`. `OPEN_QUESTIONS.md` 07:23. No commit (`Sound.lua` still untracked). |

## Attack results

| Attack | Result |
|---|---|
| Law 6 — `Play` in `QUIET` still rings `PlaySound`? | **No.** Suite + reviewer: `#played == 0`. Reason is a string. |
| Law 6 — missing Runtime / nil `Snapshot` fail-opens into a cue? | **No.** `nil, "runtime missing"`. No `PlaySound`. |
| Law 6 — file load or a hidden `Init` is a login jingle? | **No.** Load counters are 0. `Init` is nil. No `CreateFrame`. |
| Law 6 — `awaitingPope` is Quiet chrome, so any cue is a leak? | **No.** Ceremony-runtime: Event Mode degraded, not a sixth state, not Quiet. State stays `ASSEMBLY` / `RITE` / `CONSEQUENCE`. Brief: do not invent a sixth-state check. Muting it would have been the invention. |
| Law 6 — `QUIET` plus a leftover `awaitingPope` flag still plays? | **No.** Reviewer stub `{ state = "QUIET", awaitingPope = true }` mutes. Production `Restore` QUIET clears the flag. |
| Law 6 / §20.1 — invented `AWAITING_POPE` state is treated as live Event? | **No.** Only the three named Event states play. Invented name is mute. |
| §19.4 — Canonization / SUMMON / favor / Grant / clicks / login / ambient slipped in? | **No.** Unknown cue → `nil, "unknown cue"`. No matching methods. Source has no `canonization`. |
| §19.4 — `PlaySound("sanction")` invents a `SOUNDKIT` id or a sixth cue? | **No as this lane.** Brief: call `PlaySound` if it exists; do not invent kit ids or `.ogg`. Writer passes the allow-list name and `pcall`s. Stub, not a branded bell. `#8` leftover. |
| §19.4 — missing `PlaySound` errors, or falls back to `PlaySoundFile` / a bundled asset? | **No.** Records the cue name. `filePlays` stays 0. No media on disk. |
| Callers — Console / Gora / Knighting / HUD already fire `Play`? | **No.** Grep clean. This lane must not wire them. |
| Isolation — `COB.Net == nil` (etc.) run under the full harness and poison it? | **No.** Those 19 are inside `if standalone then`. |
| Auto-play — `StartEvent` / rite open-close / `EndEvent` / `MarkPopeLost` ring a cue? | **No.** Reviewer: `#played == 0` across those verbs. Suite: `EndEvent` adds no cue. |
| Writer edited TOC / `run.lua` / Runtime / UI callers, added media, or committed? | **No.** Exclusive Writes only. No media. No commit. |
| Full harness is green, so the lane listed itself? | **No.** `test_sound` is unlisted. Writer was forbidden to edit `run.lua`. Integrator leftover — not a writer miss. Do not treat an unlisted-suite runner FAIL as a Sound.lua defect. |

Refutation of Law 6 (Quiet silent; no ambient / click / login sound), Bible §19.4 (five MVP names; later seal out; no invented kits or media), §20.1 / ceremony-runtime (`awaitingPope` is not a sixth state and not Quiet), and “no callers / no load play / isolation wrap” **fails** for the exclusive files.

## Isolated rerun

```
lua tests/test_sound.lua
Tests finished: 177 passed, 0 failed
```

Lua 5.1.5. Exit 0. Writer count matches. Isolation asserts (standalone only): **19**.

## Leftovers (other lanes — expected; not fixed)

### Integrator (listing has not landed)

- `ChurchOfBeef.toc` does not list `UI\Sound.lua`. Interface stays `20506`. Writer did not edit TOC. The file will not load in the client until it is on the TOC.
- `tests/run.lua` does not list `test_sound`. Writer did not edit it. The runner will report the file as unlisted until the integrator adds it. Do not “fix” that here.

### Callers (later exclusive edit)

- Console / Gora / Knighting / HUD do not call `Play`. A live client will not hear a cue until a later lane wires the Pope verbs. Correct for this lane. Do not add `Sound:Play` in review.

### Appendix A #8 / Canonization (do not invent here)

- `PlaySound` is called with the cue name string. That is a recorded stub, not a Sanction bell. Custom `PlaySoundFile` assets stay out. No kit map.
- Canonization seal is later (§19.4). Not this phase.

### Other surfaces

- Director Console, Fight HUD, Decree, Records Book are other lanes.
- `POLISH:CANDIDATE` only. No `/reload` smoke — TOC was not edited. A human Gathering (Bible §22.3) was not run.

### Out of scope (do not invent here)

- `SOUNDKIT` ids, addon `.ogg` / `.mp3`, Canonization, SUMMON chime, favor sting, Grant / standing, caller wiring, a sixth runtime state, `holdSeconds`, PlaySound channel / Master.

## Findings

### Critical

None. No one-line Law 6, §19.4, Quiet-sound, invented-cue, media, caller-wire, or sixth-state breach in the exclusive files. This review did not revert or edit the writer’s files.

### Important

1. **Listing is not load.** TOC / `run.lua` do not name the file. Until the integrator lists them, the client never loads `Sound.lua` and the full harness treats `test_sound.lua` as unlisted. Correct for this lane. Do not add the TOC line in review.

2. **Wiring is not this verb.** Nothing calls `Play` after Sanction / verdict / elevation / Knighting / Cowardice. Until that lands, Event Mode is still silent in the client. Do not add `Sound:Play` to Console / Gora / Knighting / HUD here.

3. **`PlaySound(name)` is a stub.** Appendix A #8 remains open. `pcall` keeps a missing kit from erroring. Do not invent kit ids or ship `.ogg` to “make the bell real.”

### Nit

1. **Suite does not lock** QUIET + stubbed leftover `awaitingPope`, an invented `AWAITING_POPE` state name, Runtime-verb auto-play, or `PlaySound` arity. Reviewer probes confirm all four. Coverage gaps only.

2. **Reason `"quiet"` covers any non-Event Snapshot**, including nil / empty / non-table snaps. Fail-closed. Not a sixth state.

3. **Invalid QUIET `Restore` leaves ASSEMBLY.** Runtime contract (sequence required), not a Sound leak. A valid `{ state = "QUIET", sequence = 0 }` mutes.

4. **`ResetForTests` is a flag check only.** Nothing to clear. Fine for a verb.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated Common + Runtime + Sound; standalone wrap | Met (177 / 0). Transcript: suite first, then `Sound.lua`. |
| Event Mode only; Quiet silent absolutely | Met |
| `Play` allow-list: `sanction`, `verdict`, `elevation`, `knighting`, `cowardice` | Met |
| Play only when Snapshot state is `ASSEMBLY` / `RITE` / `CONSEQUENCE`; no sixth state | Met |
| Missing Runtime / `QUIET` → no-op | Met |
| No play on file load or `Init` | Met |
| No addon `.ogg` / `.mp3`; no `PlaySoundFile`; missing `PlaySound` does not error | Met |
| No ambient / clicks / login / Canonization / SUMMON / favor / Grant | Met |
| Do not wire Console / Gora / Knighting / HUD | Met |
| Isolation asserts in `if standalone then` | Met (19) |
| Do not edit TOC / bootstrap / `run.lua` / Runtime / Console / HUD / Gora / Knighting / Minimap / Toasts / MainFrame / Net | Met |
| Isolated `test_sound.lua` must pass | Met (177 / 0) |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- Brief `docs/reformation/phase-5/briefs/P5-C-sound.md`
- Writer report `docs/reformation/phase-5/reports/P5-C-sound.md`
- `addon/ChurchOfBeef/UI/Sound.lua`
- `tests/test_sound.lua` (isolated run: 177 / 0)
- `.cursor/rules/ten-laws.mdc` Law 6
- `.cursor/rules/quiet-event-modes.mdc` (Sound)
- `.cursor/rules/ceremony-runtime.mdc` (`awaitingPope`)
- Bible §19.4 (also §19.1 Quiet, §20.1 states, §20.3 Pope-disconnect, Appendix A #8 — not rebuilt)
- `addon/ChurchOfBeef/Core/Runtime.lua` Snapshot / `MarkPopeLost` / `Restore` (read only; mtime 06:37)
- Writer transcript ([Sound](6fec9432-0cf5-41d7-8966-883748542570)) — exclusive Writes only
- `ChurchOfBeef.toc` / `tests/run.lua` / `ChurchOfBeef.lua` (writer did not edit; Sound unlisted)
- `UI/Console.lua` / `UI/Hud.lua` / `Core/Gora.lua` / `Core/Knighting.lua` (no `Play` callees)
- `docs/design/OPEN_QUESTIONS.md` (writer did not edit; #8 unanswered)
- Reviewer probes (throwaway; suite not edited): Runtime verbs do not auto-play; QUIET + stubbed `awaitingPope` mutes; invented `AWAITING_POPE` mutes; nil / empty / non-table Snapshot mutes; `ASSEMBLY` + `awaitingPope` still plays; valid QUIET `Restore` mutes; `PlaySound` arity 1; no extra public keys; empty / leading-space names rejected; no media files
