# Task 7 review — Version drop + PROTOCOL 2

**Scope (this gate only):** live `Codec.PROTOCOL` / `Net.PROTOCOL` / `IsCompatible`; `Net:_WarnVersion` + drop on `HandleHello` / TYPES / `_HandleV2`; `Snapshot:ApplyResponse` incompatible path; `Runtime:DropToQuietForVersion`; invert pins I-02 / I-03 / I-05; leftover I-06; extra-colon fail-closed; SCHEMA 7; Interface 20506.

Locked options: O-Foreign A, O-Drop A, O-Warn A, O-Where. Full `lua tests/run.lua` was not re-run (per gate instruction).

**Spec-compliance:** PASS

**Task quality:** Approved

The implementer report matches the live tree. Local major is 2. Old v1 bodies are incompatible. Foreign fixtures are `1:`, not `2:`. Skew drops Event chrome to a clean QUIET object via Restore, not `EndEvent`. The Quiet notice is the Bible phrase plus “update the addon,” once per session, no toast. I-06 rewind leftovers are still leftovers. No packed `names`. No clerical kind/beat. SCHEMA stays 7. Interface stays 20506.

---

## Verdict

Task 7 matches the brief, the locked PROTOCOL 2 + chaos plan, and pin catalog I-02 / I-03 / I-05. Night-one version skew no longer keeps live ASSEMBLY/RITE. `#27` stays unanswered. Task 9 (latest-wins) is untouched.

---

## Spec Compliance

| Pin | Result | Evidence |
|-----|--------|----------|
| `Codec.PROTOCOL = 2`; `IsCompatible(1) == false` | Met | `Net/Codec.lua` `PROTOCOL = 2`. `IsCompatible` is `finite(version) == self.PROTOCOL`. `test_net_codec.lua`: `IsCompatible(2)` true, `IsCompatible(1)` false. Decode of `1:STATE:…` still succeeds; encode `version = 1` refuses `"protocol mismatch"` |
| `Net.PROTOCOL = 2` | Met | `Net/BeefNet.lua` `PROTOCOL = 2`. Same `IsCompatible`. `test_net_v2.lua` `"protocol major is 2"`. Companion `test_net_validate.lua` `"this cut speaks protocol 2"`; `test_wire_glue.lua` `HandleHello({ version = 2, … })` |
| `_WarnVersion` copy contains `the Church's software has advanced` and `update the addon` | Met | Exact chat: `the Church's software has advanced; update the addon.` Latch `warnedVersion`. No toast / Sound / status chip. I-02 pins both fragments + `#chats == 1` on the second call |
| Drop on `HandleHello` / TYPES / `_HandleV2` | Met | All three call `_WarnVersion` then `dropToQuietForVersion()`. TYPES and `_HandleV2` return `"protocol mismatch"`. Helper no-ops when `Runtime` is absent (HELLO-only validate cut) |
| `ApplyResponse` incompatible → `DropToQuiet` + `"protocol mismatch"` | Met | `Snapshot:ApplyResponse` calls `Runtime:DropToQuietForVersion()` then `nil, "protocol mismatch"`. Does not Restore the foreign body. I-03 + `test_net_snapshot.lua` pin QUIET / nil eventId / seq 0 |
| `DropToQuietForVersion` is Restore QUIET, not `EndEvent`; `nextEventId` kept | Met | Restores `newEvent()` (`state="QUIET"`, no rite, no subjects, sequence 0, eventId nil). Comment forbids `EndEvent` (illegal from RITE). Saves/restores `nextEventId`. `test_runtime.lua`: after drop, next `StartEvent` is event 2 |
| I-02 `test_net_v2.lua` QUIET after skew | Met | Foreign `"1:STATE:1:ASSEMBLY::::1"` / `"1:SNAPSHOT:response:1:ASSEMBLY::::1"`. After guild STATE: QUIET, eventId nil, sequence 0, `"protocol mismatch"`, one Bible chat. SNAPSHOT stays Quiet; `_WarnVersion(1)` false |
| I-03 `test_ceremony_chaos.lua` | Met | Header still “Do not add a Quiet toast.” After foreign Apply: QUIET, rite nil, eventId nil, sequence 0. `"this lane does drop to Quiet presentation"`. Runtime still has no toast / `_WarnVersion` |
| I-05 local major 2; foreign fixtures are `1:` not `2:` | Met | Local emit/decode literals are `2:STATE` / `2:SNAPSHOT` / `2:INPUT` / `2:HELLO`. Every remaining `1:STATE` / `1:SNAPSHOT` / `1:HELLO` in these suites is the old/foreign major (or retired transport types, which stay `1:` by name) |
| I-06 rewind leftovers still leftovers | Met | Chaos header still “Do NOT invent a monotonic-sequence gate.” Pins still say older Apply/Restore overwrite later CONSEQUENCE / seq 3 / Gora. Live `Restore` / `ApplyResponse` still last-write |
| Extra colon still `"unknown field"`; no `names` allowlist | Met | `STATE_KEYS` / `SNAPSHOT_RES_KEYS` have no `names`. `test_net_codec.lua` `"STATE extra wire field"` / `"response extra wire field"` / `"request extra wire field"` still `"unknown field"` on `2:…:extra` |
| No clerical kind/beat; `#27` unanswered | Met | STATE/SNAPSHOT keys have no `kind` / `beat`. Net/Snapshot have no `Toasts` / `Proclaim` / `Sound`. `OPEN_QUESTIONS.md` #27 still unanswered |
| SCHEMA 7; Interface 20506 | Met | `Core/DB.lua` `SCHEMA_VERSION = 7`. `test_db.lua` `"schema version is 7"`. TOC `## Interface: 20506` |
| Do-not: Schema 8, congregation Ensure, inbound Proclaim | Met | No SCHEMA 8. BeefNet / Snapshot do not call `EnsureCharacterByName` / `CreateHuman` / `LinkCharacter`. No inbound Proclaim |
| Locked options O-Foreign A / O-Drop A / O-Warn A / O-Where | Met | Foreign major is old v1 (`1:`). Quiet object is Runtime QUIET. Warn line is Bible + update, no version-number clause. Drop lives on Net inbound and `ApplyResponse` |

---

## Strengths

- Both invert lanes are real. Net inbound and isolated `ApplyResponse` each drop chrome. A Net-only or Apply-only drop would have left one suite green-wrong.
- O-Drop A uses Restore of a Quiet object, so I-03 can see QUIET without UI and without the illegal `EndEvent` from RITE. Keeping `nextEventId` is the correct follow-up to that Restore; it is pinned.
- I-05 retarget is complete in the named suites and the Option V1 companion. `2:` is no longer the skew body.
- I-06 was left alone. Task 9 still has a leftover to invert.
- Extra colon parts stay fail-closed. PROTOCOL 2 did not invent `names` or a clerical beat.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **`tests/test_net_validate.lua` still cannot run isolated.** It `require`s `wow_ui_stub` and uses harness `assert_eq`. Pre-existing. Option V1 retargeted the major. Covered only by `lua tests/run.lua`.

2. **Full-harness HELLO mismatch can `DropToQuiet` a leftover Runtime.** The Net helper no-ops when Runtime is absent (isolated validate cut). In `lua tests/run.lua`, `COB.Runtime` already exists, so a `1:HELLO` in that suite Restores QUIET on whatever event the previous suite left. Later suites `ResetForTests`. Not a product miss.

3. **`_WarnVersion(version)` no longer uses `version`.** O-Warn A dropped the engineer `v%s` / `v%d` clause. The latch and once-per-session pins still pass the foreign major in. Harmless.

---

## Assessment

**PASS / Approved.**

PROTOCOL 2 + §13.4 Quiet drop is in the tree. I-02 / I-03 / I-05 are inverted. I-06 rewind leftovers remain Task 9. `#27` stays unanswered. No packed names. SCHEMA 7. Interface 20506.

Full harness counts in the report (16314 / 0) were not re-checked. No client `/reload` smoke. Do not claim `POLISH:PASS`.
