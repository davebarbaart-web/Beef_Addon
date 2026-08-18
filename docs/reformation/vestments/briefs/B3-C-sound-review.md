# B3-C — §19.4 cues fire on Anniversary (SoundKit) (review)

**Spec:** PASS
**Quality:** Approved

**Lane:** B3-C — §19.4 cues fire on Anniversary (SoundKit)
**Brief:** `docs/reformation/vestments/briefs/B3-C-sound.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/B3-C-sound-report.md`
**Diff:** `docs/reformation/vestments/briefs/B3-C-sound.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Sound.lua`, `tests/test_sound.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, and the provided diff once; then made one focused check per named risk (still five cue names; `PlaySound` gets a number; Quiet silent; no `PlaySoundFile`). SOUNDKIT keys were checked against wow-api MCP flavor `classic_anniversary` (`search_source` FrameXML sites; `get_source_file` `Blizzard_SharedXML/TBC/SoundKitConstants.lua` and `Classic/Sound.lua`). Did not mutate addon code, did not re-run git or the suite, and did not treat writer counts as verified.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Still five cue names | **Pass.** `CUES` is exactly `sanction` / `verdict` / `elevation` / `knighting` / `cowardice`. `Play` refuses any other string (`nil, "unknown cue"`). No sixth public method. Suite banned set still includes `canonization`, `summon`, `favor`, `grant`, `click`, `login`, `ambient`. |
| `PlaySound` gets a number | **Pass.** `resolveKit` returns only when `_G.SOUNDKIT[key]` is a number. `fireKit` `pcall`s `PlaySound` only with that number. ASSEMBLY pins `type(lastPlayed()) == "number"`, equality to the stub kit, and `lastPlayed() ~= name`. Return value stays the cue name string. |
| Quiet silent | **Pass.** Missing Runtime / missing `Snapshot` / state not `ASSEMBLY`/`RITE`/`CONSEQUENCE` returns before `fireKit`. Suite: all five names in `QUIET` → `nil, reason`; `#played == 0`; `filePlays == 0`. `EndEvent` back to `QUIET` adds no cue. |
| No `PlaySoundFile` | **Pass.** `Sound.lua` has no `PlaySoundFile`, `PlaySoundKitID`, `.ogg`, or `.mp3`. Missing `PlaySound` does not fall back to a file. Suite `filePlays` stays 0. No addon media files. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Toasts / Console / TOC / bootstrap / `run.lua` / OPEN_QUESTIONS / REFORMATION_LOG / commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/Sound.lua` and `tests/test_sound.lua`. |
| Do not add cue names beyond the §19.4 five | **Pass.** Named-risk check. |
| Map five names to existing FrameXML `SOUNDKIT.*` keys; resolve via `_G.SOUNDKIT[key]`; skip play if missing / non-number; do not invent raw ids in source | **Pass.** Keys below. Source has no `844` / `878` / `6144` / `829` / `846`. Stub ids live only in the test file, as the brief allows. |
| Preferred call: `pcall(PlaySound, kit)` then `pcall(C_Sound.PlaySound, kit)` if `C_Sound` exists | **Pass with justified guard.** Second call is skipped when `C_Sound.PlaySound == PlaySound`. Anniversary FrameXML is `PlaySound = C_Sound.PlaySound` (`Blizzard_SharedXML/Classic/Sound.lua:3`). Unguarded dual `pcall` would double-fire. Fallback still runs when `PlaySound` is missing. |
| `Sound:Play` still returns the cue name string on success | **Pass.** `return name` after `fireKit`. Tests and Console `playCue` still pass the name. |
| Quiet still silent; unknown names still refuse | **Pass.** Named-risk checks. |
| Isolation asserts stay under `if standalone then` | **Pass.** Nil-module cluster and standalone summary print remain gated. New kit pins sit in the shared body. |
| ASSEMBLY pins: number (or resolved kit), not `"sanction"`; return stays `"sanction"` | **Pass.** All five ASSEMBLY cues plus RITE / CONSEQUENCE / `awaitingPope` / Continue pins. |
| `lua tests/test_sound.lua` exit 0 | **Writer claim only.** Report says **202 / 0**. Not re-run here. |

Cited keys — each exists in `TBC/SoundKitConstants.lua` and is used in FrameXML on `classic_anniversary`:

| Cue | Key | Stub id | FrameXML cite (confirmed) |
|---|---|---|---|
| `sanction` | `IG_QUEST_LOG_OPEN` | 844 | `Blizzard_WorldMap/Wrath/Blizzard_WorldMap.lua:281` |
| `verdict` | `IG_QUEST_LIST_COMPLETE` | 878 | `Blizzard_StaticPopup_Game/GameDialogDefs.lua:407` |
| `elevation` | `TALENT_SCREEN_OPEN` | 6144 | `Blizzard_TalentUI/Classic/Blizzard_TalentUI.lua:211` |
| `knighting` | `IG_SPELLBOOK_OPEN` | 829 | `Blizzard_UIPanels_Game/Classic/SpellBookFrame.lua:127` |
| `cowardice` | `IG_QUEST_LOG_ABANDON_QUEST` | 846 | `Blizzard_StaticPopup_Game/Classic/GameDialogDefs.lua:774` |

`RAID_WARNING` and `READY_CHECK` stay unused. `get_api` `C_Sound.PlaySound` is present on this flavor (build 2.5.6.68575).

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Anniversary aliases `PlaySound` to `C_Sound.PlaySound`; dual call would double-fire | **Not a miss.** Same-function skip is required on 20506. C_Sound remains the missing-`PlaySound` fallback. |
| Stock UI kits, not branded bells | **Not a miss.** Brief required existing FrameXML keys. Appendix A #8 stays out. |
| Console / Toasts still call `Sound:Play("sanction")` (and the other names) | **Not a miss.** Brief forbade those edits. Return value is still the cue name. |
| No client `/reload` smoke | **Expected.** **POLISH:CANDIDATE** only. |

---

## Strengths

- The verb contract did not move. Callers still pass a cue name; `Play` still returns that name; only the `PlaySound` argument became a kit number.
- Fail-closed kit resolve: missing `SOUNDKIT`, missing key, or non-number value still records the cue and skips play. No invented raw ids in `Sound.lua`.
- Quiet is a real refuse in front of `fireKit`, not a mute inside it. Missing Runtime and non-Event snapshots never reach `PlaySound`.
- Same-function guard matches live FrameXML (`PlaySound = C_Sound.PlaySound`) instead of blindly firing both `pcall`s.
- Isolation stayed gated. Source greps still refuse media, `PlaySoundFile`, `PlaySoundKitID`, raid-warning kits, frames, chat, and caller wires.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Writer-reported isolated `tests/test_sound.lua` 202 / 0 was not re-run here.** Do not treat that count as verified.

2. **Stock kits will sound like quest log / quest complete / talents / spellbook / abandon.** Allowed by the brief. Not a branded Sanction bell. **POLISH:CANDIDATE** only.

3. **Suite `CUE_KIT` duplicates `Sound.lua` `CUES`.** Pins fail if the maps drift, which is useful, but the stub ids are a second source of truth for the numbers.

4. **Hardcoded-id source greps are literal (`= 844`, …).** A differently spelled number would slip the pin. Source currently has none.

5. **Client `/reload` smoke was not run.** Hearing the five stock kits in Event Mode, and silence in Quiet, still needs a human ear.

---

## Assessment

**Spec PASS. Quality: Approved.** Gate PASS for this lane’s contract. Do not sign.

The exclusive pair does what the brief asked: the five §19.4 names still resolve through `_G.SOUNDKIT`, `PlaySound` receives a number, `Play` still returns the cue name, Quiet and unknown names stay silent, and there is no `PlaySoundFile`. Named risks are clean. Minors are unverified harness count, stock-kit taste, and unsmoked client audio — not trust-breakers.

Writer-reported isolated `lua tests/test_sound.lua` **202 / 0** was **not** re-run here. Do not claim **POLISH:PASS**. Do not claim V1 / MVP complete.
