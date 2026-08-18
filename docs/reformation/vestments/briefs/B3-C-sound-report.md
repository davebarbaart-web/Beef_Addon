# B3-C — §19.4 cues fire on Anniversary (SoundKit)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §19.4, Law 6; brief `docs/reformation/vestments/briefs/B3-C-sound.md`; wow-api MCP flavor `classic_anniversary` (`search_source` `SOUNDKIT.`, `get_source_file` `Blizzard_SharedXML/TBC/SoundKitConstants.lua` and FrameXML call sites).

Event Mode verb now resolves the five §19.4 cue names to existing FrameXML `SOUNDKIT` keys and `pcall`s `PlaySound` with the kit **number**. `Sound:Play` still returns the cue name string. Quiet stays silent. No new cue names. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `addon/ChurchOfBeef/UI/Sound.lua` | Map five cue names to kit **names**. Resolve via `_G.SOUNDKIT[key]`. Skip play when the table or value is missing. `pcall(PlaySound, kit)` then `pcall(C_Sound.PlaySound, kit)` only when that function is not the same as `PlaySound`. |
| `tests/test_sound.lua` | Harness stub `SOUNDKIT` for the five keys. ASSEMBLY / RITE / CONSEQUENCE pins expect a **number** (the resolved kit), not `"sanction"`. Isolation stays under `if standalone then`. |
| `docs/reformation/vestments/briefs/B3-C-sound-report.md` | This file |
| `docs/reformation/vestments/briefs/B3-C-sound.diff` | `git diff -- addon/ChurchOfBeef/UI/Sound.lua tests/test_sound.lua` |

Did not edit Toasts, Console, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add cue names. Did not add Media files. Did not invent raw kit ids in `Sound.lua`.

## SOUNDKIT map (classic_anniversary)

Keys are used in FrameXML. Ids below are from `Interface/AddOns/Blizzard_SharedXML/TBC/SoundKitConstants.lua` and exist only in the test stub — production resolves `_G.SOUNDKIT[key]` and never hardcodes the numbers.

| Cue | `SOUNDKIT` key | FrameXML cite | Stub id |
|-----|----------------|---------------|---------|
| `sanction` | `IG_QUEST_LOG_OPEN` | `Blizzard_WorldMap/Wrath/Blizzard_WorldMap.lua:281` `PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN)` | 844 |
| `verdict` | `IG_QUEST_LIST_COMPLETE` | `Blizzard_StaticPopup_Game/GameDialogDefs.lua:407` `PlaySound(SOUNDKIT.IG_QUEST_LIST_COMPLETE)` | 878 |
| `elevation` | `TALENT_SCREEN_OPEN` | `Blizzard_TalentUI/Classic/Blizzard_TalentUI.lua:211` `PlaySound(SOUNDKIT.TALENT_SCREEN_OPEN)` | 6144 |
| `knighting` | `IG_SPELLBOOK_OPEN` | `Blizzard_UIPanels_Game/Classic/SpellBookFrame.lua:127` `PlaySound(SOUNDKIT.IG_SPELLBOOK_OPEN)` | 829 |
| `cowardice` | `IG_QUEST_LOG_ABANDON_QUEST` | `Blizzard_StaticPopup_Game/Classic/GameDialogDefs.lua:774` `PlaySound(SOUNDKIT.IG_QUEST_LOG_ABANDON_QUEST)` | 846 |

Also cited: `Blizzard_WowTokenUI.lua:316/570` (`IG_MAINMENU_OPEN` / `IG_MAINMENU_CLOSE`) and `PetStable.xml:409` (`IG_CHARACTER_INFO_OPEN`) as additional FrameXML `SOUNDKIT.` hits. Not used. `RAID_WARNING` and `READY_CHECK` stay unused.

`get_api` `C_Sound.PlaySound` is present on `classic_anniversary` (build 2.5.6.68575). `Blizzard_SharedXML/Classic/Sound.lua:3` is `PlaySound = C_Sound.PlaySound`.

## Contract

| Runtime | `Play` |
|---------|--------|
| Missing `COB.Runtime` / no `Snapshot` | No-op (`nil, reason`) |
| `QUIET` | No-op (`nil, reason`). No `PlaySound`. |
| `ASSEMBLY` / `RITE` / `CONSEQUENCE` | Allow-list cue returns the name. If `_G.SOUNDKIT[key]` is a number, `pcall(PlaySound, kit)`. If `PlaySound` is missing and `C_Sound.PlaySound` exists and is a different function, `pcall` that instead. |
| `awaitingPope` | Still plays — Event Mode degraded, not a sixth state |
| `SOUNDKIT` nil / non-number | Still returns the cue name. Skips `PlaySound`. |

Unknown names still refuse. No `PlaySoundFile`. No frames. No chat.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_sound.lua   # 202 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_sound.lua` standalone | 202 passed, 0 failed. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive files only. Five cue names only. Quiet refuses. Isolation asserts stay under `if standalone then`.
- `PlaySound` receives a number, not `"sanction"`. Return value stays the cue name.
- Source has no `.ogg`, `.mp3`, `PlaySoundFile`, `PlaySoundKitID`, `RAID_WARNING`, `READY_CHECK`, `CreateFrame`, chat, or caller wires.
- Source has no hardcoded kit ids (`844` / `878` / `6144` / `829` / `846`).

## Concerns

- **Anniversary aliases `PlaySound` to `C_Sound.PlaySound`.** Calling both would double-fire the cue. `fireKit` skips `C_Sound.PlaySound` when it is the same function as `PlaySound`. The C_Sound path is the fallback when `PlaySound` is missing.
- **Stock UI kits, not branded bells.** These are existing FrameXML keys (quest log, quest complete, talent screen, spellbook, abandon quest). Appendix A #8 custom assets stay out.
- **Integrator / callers unchanged.** Console and Toasts still call `Sound:Play("sanction")` (and the other names). They were not edited. The return value is still the cue name.
- **`POLISH:CANDIDATE` only.** No in-game `/reload` smoke. A human Gathering (Bible §22.3) was not run.
