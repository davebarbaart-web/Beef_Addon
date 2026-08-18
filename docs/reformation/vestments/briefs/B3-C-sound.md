# B3-C — §19.4 cues fire on Anniversary (SoundKit)

**Exclusive:** `addon/ChurchOfBeef/UI/Sound.lua`, `tests/test_sound.lua`

**Do not edit** Toasts, Console. Do not commit. **Do not add cue names** beyond sanction / verdict / elevation / knighting / cowardice.

## Law

`PlaySound("sanction")` is a no-op on `## Interface: 20506` (wants a SoundKit id). Flavor **classic_anniversary**.

Use MCP `project-0-Beef_Addon-wow-api` (`search_source` `SOUNDKIT.`, flavor `classic_anniversary`) and pick **existing** `SOUNDKIT.*` keys used in FrameXML (e.g. `IG_QUEST_LOG_OPEN` is used). Map the five names to five kit **names**, resolve via `_G.SOUNDKIT[key]` when present, else skip PlaySound (do not invent raw ids you cannot cite).

Preferred call order, each `pcall`:

1. `PlaySound(kit)` if kit is a number
2. `C_Sound.PlaySound(kit)` if `C_Sound` exists

`Sound:Play(name)` still **returns the cue name string** on success (tests and Console depend on that). Quiet still silent. No `PlaySoundFile`. No frames. No chat.

## Tests

Update ASSEMBLY pins: `PlaySound` is called with a **number** (or the resolved kit), not the string `"sanction"`. Return value stays `"sanction"`. Quiet still calls nothing. Unknown names still refuse. Isolation under `if standalone then`.

If `SOUNDKIT` is nil in the harness, define a tiny stub table in the test file for the five keys you chose, then PlaySound receives those numbers.

`lua tests/test_sound.lua` exit 0.

Report `docs/reformation/vestments/briefs/B3-C-sound-report.md` + diff. Cite the SOUNDKIT keys you used.
