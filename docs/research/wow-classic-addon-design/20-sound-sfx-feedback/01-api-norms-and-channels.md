# PlaySound / PlaySoundFile Norms & Volume Channels

**Last updated:** 2026-07-25  
**Track:** [20-sound-sfx-feedback](README.md)

---

## 1. Two APIs, two ID spaces

| API | Input | Use when |
|-----|--------|----------|
| [`PlaySound(soundKitID [, channel, forceNoDuplicates, runFinishCallback])`](https://warcraft.wiki.gg/wiki/API_PlaySound) | **SoundKitID** (number). FrameXML names live in the global `SOUNDKIT` table | Playing a Blizzard kit (often a *set* of random variants) |
| [`PlaySoundFile(sound [, channel])`](https://warcraft.wiki.gg/wiki/API_PlaySoundFile) | **FileDataID** (number) *or* addon-relative path string | Playing one file: game FileDataID, or `Interface\AddOns\...\file.ogg` |

Modern clients reject string path playback of *shipped game* assets via `PlaySoundFile` — use FileDataID / SoundKitID instead ([Blizzard forums — PlaySoundFile Invalid fileDataID](https://us.forums.blizzard.com/en/wow/t/playsoundfile-macros-resulting-in-error/207665)). Addon-folder paths remain valid for files you ship.

Returns (modern): `willPlay, soundHandle`. `willPlay` is nil when the channel is muted / playback is blocked ([PlaySound wiki](https://warcraft.wiki.gg/wiki/API_PlaySound)). Use `soundHandle` with `StopSound` if you ever need to cut a long cue short.

`forceNoDuplicates` (PlaySound, default true) suppresses stacking identical kits — useful if a toast can fire twice in one frame.

---

## 2. Volume channels (the real product decision)

Optional second argument; **default is `SFX`** ([PlaySoundFile wiki](https://warcraft.wiki.gg/wiki/API_PlaySoundFile)).

| Channel | Toggle CVar | Volume CVar | Practical meaning for addons |
|---------|-------------|-------------|------------------------------|
| `SFX` | `Sound_EnableSFX` | `Sound_SFXVolume` | Default. Respects “Sound Effects” mute/slider. Correct for social / UI chrome. |
| `Master` | `Sound_EnableAllSound` | `Sound_MasterVolume` | Ignores SFX/Music/Ambience/Dialog sliders; only Master gates it. Heard even when Effects are off. |
| `Dialog` | `Sound_EnableDialog` | `Sound_DialogVolume` | Voice / dialog bus. Rare for UI toasts; OK for scripted “spoken” ceremony lines if you ever ship VO. |
| `Music` | `Sound_EnableMusic` | `Sound_MusicVolume` | Zone music bus. Wrong for short UI pings. |
| `Ambience` | `Sound_EnableAmbience` | `Sound_AmbienceVolume` | Ambient loops. Wrong for one-shots. |

Channel argument was restored so addons could again separate from game SFX ([WoWInterface — 4.0.6 channel change](https://wowinterface.com/forums/showthread.php?t=38901)). Wiki example for “always hear even with Effects off”:

`PlaySoundFile("Interface\\AddOns\\MyAddOn\\mysound.ogg", "Master")` ([PlaySoundFile wiki](https://warcraft.wiki.gg/wiki/API_PlaySoundFile)).

### Ecosystem norm: combat alerts → Master; UI chrome → SFX

Boss mods deliberately use **Master** so warnings remain audible when SFX is low or off. DBM’s author documented the trade-off: Master fixes “can’t hear alerts,” but volume then tracks Master — and they shipped an option to fall back to SFX ([WoWInterface DBM Master-channel thread](https://www.wowinterface.com/forums/printthread.php?pp=60&t=39223); pattern still in DBM `UseMasterVolume` + `PlaySoundFile(..., "Master")` forks).

**Implication for Beef:** Church of Beef is not a combat alert tool. Defaulting to Master competes with DBM/WA/BigWigs and ignores players who mute Effects on purpose. Prefer **SFX + global mute**, with optional “Play on Master” for rare ceremony moments only.

There is **no per-call volume parameter** on `PlaySoundFile` — loudness is channel slider + how hot the file is mastered ([same DBM thread](https://www.wowinterface.com/forums/printthread.php?pp=60&t=39223)). Control loudness by file gain and rarity, not Lua volume args.

---

## 3. Mute options (three layers)

### 3.1 Addon-owned mute (required for any social SFX)

Own SavedVariables flags, e.g. `soundsEnabled` / per-event toggles. This is the only mute that is reliable, persistable, and does not fight other addons. WeakAuras users begged for pack-level silence after custom sounds/TTS became default ([WA issue #5040](https://github.com/WeakAuras/WeakAuras2/issues/5040)).

### 3.2 Channel respect

Calling with `"SFX"` means `Sound_EnableSFX = 0` → `willPlay` false. That is a feature: players who silence Effects silence Beef UI ticks for free.

### 3.3 `MuteSoundFile` / `UnmuteSoundFile` (game-file surgical mute)

[`MuteSoundFile(sound)`](https://warcraft.wiki.gg/wiki/API_MuteSoundFile) mutes a FileDataID or addon path. Notes from wiki:

- Persists through `/reload` and relog, **not** full client restart — re-apply on login.
- Works on game sounds, addon sounds, and `PlaySoundFile` playback.
- No API to *replace* game sound files (post–8.2 folder-override era is over).

Classic note: CurseForge’s Mute Annoying WoW Sounds states MuteSoundFile landed on Classic with TBC-era clients ([Mute Annoying WoW Sounds](https://www.curseforge.com/wow/addons/mute-wow-sounds)). Dedicated helpers: [MuteSoundFile (funkydude)](https://github.com/funkydude/MuteSoundFile), [MuteAnnoying](https://www.wowace.com/projects/muteannoying).

**Beef should not use MuteSoundFile** to silence *other* addons or Blizzard VO. Only consider it if Beef ships a sound players want to kill without uninstalling — still secondary to an in-addon mute checkbox.

---

## 4. Packaging constraint (TOC)

Sounds under the addon folder do **not** need TOC file entries; `PlaySoundFile` resolves paths inside the addon tree the same way textures do ([TOC format notes](https://warcraft.wiki.gg/wiki/TOC_format) / library `.raw/toc-format.md`). Files must exist before login (client caches addon tree at load).

Formats: prefer **`.ogg`**. Historical notes: `.wav` custom files dropped (4.0.1 era); `.mp3`/`.ogg` commonly accepted for addon media ([archive PlaySoundFile notes](https://wowwiki-archive.fandom.com/wiki/API_PlaySoundFile)).

Missing file: typically silent fail (return indicates failure) — same spirit as Beef’s “missing fonts/textures still load” policy.

---

## 5. Finding IDs

| Goal | Source |
|------|--------|
| FrameXML kit constants | `SOUNDKIT` in UI source ([SoundKitConstants.lua discussion](https://www.wowinterface.com/forums/showthread.php?t=55702)) |
| Browse / preview kits | [Wowhead Sounds](https://www.wowhead.com/sounds) (ID in URL) |
| FileDataID ↔ path | wow.tools / wago.tools file browsers; [Sound ID Finder](https://www.curseforge.com/wow/addons/sound-id-finder) for binary search mute |

Kit ≠ file: one SoundKitID can pick randomly among several FileDataIDs ([PlaySound wiki details](https://warcraft.wiki.gg/wiki/API_PlaySound)).

---

## 6. Norms summary for social addons

1. Gate every play behind addon prefs; default **off** or **promotion-only**.
2. Prefer `PlaySound(SOUNDKIT.*)` for stock UI ticks; prefer `PlaySoundFile(path)` for branded custom media.
3. Channel: **`SFX` default**; `Master` only with explicit user option (and rare events).
4. Honor `willPlay`; do not retry on mute.
5. Cooldown / anti-spam at the event layer (see [03-accessibility-and-spam.md](03-accessibility-and-spam.md)).
6. Do not mutate global CVars for volume — that is hostile UX.
