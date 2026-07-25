# Annotated URLs — Sound / SFX Feedback

**Last updated:** 2026-07-25  
**Track:** [20-sound-sfx-feedback](README.md)

Steal / adapt / avoid notes are for Church of Beef design judgment, not endorsements of every addon’s defaults.

---

## Primary API & constants

| URL | Why it matters | Beef note |
|-----|----------------|-----------|
| [API PlaySound — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_PlaySound) | SoundKitID args, channels, `willPlay` / `soundHandle`, `forceNoDuplicates`, SOUNDKIT pointer | Prefer kit playback for stock UI; check `willPlay` |
| [API PlaySoundFile — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_PlaySoundFile) | FileDataID or addon path; Master example; channel table | Path for V2 custom media; default channel SFX |
| [API MuteSoundFile — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_MuteSoundFile) | Surgical mute; persistence caveat; no replace API | Not a Beef feature; support folklore only |
| [TOC format — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/TOC_format) | Addon folder media need not be TOC-listed | Confirm when packaging V2 sounds |
| [SoundKitConstants discussion — WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=55702) | Excerpts of `SOUNDKIT` IDs (RAID_WARNING 8959, READY_CHECK 8960, etc.) | Avoid overused IDs as defaults |
| [Gethe / UI SoundKitConstants (path may move)](https://github.com/Gethe/wow-ui-source) | Authoritative FrameXML constants when raw path resolves | Verify on target Classic build |

---

## Channels, Master vs SFX, ecosystem practice

| URL | Why it matters | Beef note |
|-----|----------------|-----------|
| [4.0.6 PlaySound channel argument — WoWInterface](https://wowinterface.com/forums/showthread.php?t=38901) | Documents Master / SFX / Music / Ambience split | Historical root of today’s channel choice |
| [DBM Master channel / volume — WoWInterface](https://www.wowinterface.com/forums/printthread.php?pp=60&t=39223) | Why alert addons use Master + offer opt-out; no per-play volume | **Do not copy Master-as-default** for social SFX |
| [PlaySoundFile Invalid fileDataID — Blizzard forums](https://us.forums.blizzard.com/en/wow/t/playsoundfile-macros-resulting-in-error/207665) | Game assets need IDs, not old `Sound\\...` paths | Don’t document obsolete path macros |
| [BigWigs Sound.lua (example fork)](https://github.com/nickbender/wow-interface/blob/master/BigWigs_Plugins/Sound.lua) | Registers Raid Warning into LSM; plays Master | Pattern to **differentiate from**, not steal |

---

## Overused sounds & mute economy

| URL | Why it matters | Beef note |
|-----|----------------|-----------|
| [Wowhead RaidWarning sound=8959](https://www.wowhead.com/sound=8959/raidwarning) | Canonical raid ding ID | Ban from Beef defaults |
| [Wowhead Sounds index](https://www.wowhead.com/sounds) | Browse kits by ID | Picker research for V2 |
| [Mute Annoying WoW Sounds — CurseForge](https://www.curseforge.com/wow/addons/mute-wow-sounds) | Classic MuteSoundFile availability note; culture of fatigue sounds | Proof players will mute hostility |
| [MuteSoundFile addon — GitHub](https://github.com/funkydude/MuteSoundFile) | UX for muting by FileDataID | Out of scope for Beef core |
| [MuteAnnoying — WowAce](https://www.wowace.com/projects/muteannoying) | Post-8.2 mute-only world (no Sound\\ replace) | Context for Classic audio modding |
| [Raid Warnings Off — EU forums](https://eu.forums.blizzard.com/en/wow/t/raid-warnings-off/353992) | Players hate raid-warning spam even from humans | Don’t add addon spam on the same ding |
| [Sound ID Finder — CurseForge](https://www.curseforge.com/wow/addons/sound-id-finder) | Find FileDataIDs to mute | Dev/support tool, not dependency |

---

## Custom packaging & LibSharedMedia (sound only)

| URL | Why it matters | Beef note |
|-----|----------------|-----------|
| [LibSharedMedia-3.0 — WowAce](https://www.wowace.com/projects/libsharedmedia-3-0) | Shared fonts/sounds/textures | Optional V2 register only |
| [LSM API documentation](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation) | `MediaType.SOUND`, naming rules, Quiet.ogg default | Follow naming; don’t require lib |
| [SharedMedia MyMedia instructions](https://github.com/abl/AddOns/blob/master/SharedMedia/INSTRUCTIONS%20for%20MyMedia.txt) | Community custom sound folder pattern | Reference for V2 layout |
| [SharedMediaAdditionalSounds — CurseForge](https://www.curseforge.com/wow/addons/sharedmediaadditionalsounds) | Injects Blizzard sounds into LSM | Do not hard-depend |
| [Custom LSM sound pack — Blizzard forums](https://us.forums.blizzard.com/en/wow/t/i-created-my-own-addon-just-to-register-custom-sounds/2024737) | Ogg + LSM:Register workflow still current | V2 packaging anecdote |
| [Archive PlaySoundFile notes](https://wowwiki-archive.fandom.com/wiki/API_PlaySoundFile) | Addon path examples; wav caveat | Historical packaging constraints |

---

## Accessibility & spam UX

| URL | Why it matters | Beef note |
|-----|----------------|-----------|
| [Dragonflight accessibility — Blizzard Watch](https://blizzardwatch.com/2022/07/27/accessibility-options-dragonflight/) | Alternate Full Screen Effects, motion sickness options | Design toasts without strobe; don’t rely on Retail menu existing in Classic |
| [Epilepsy / Photosensitivity Friendly — US forums](https://us.forums.blizzard.com/en/wow/t/epilepsy-photosensitivity-friendly-please/2286418) | Player demand signal | Keep ceremony visuals calm |
| [WeakAuras #5040 — global mute request](https://github.com/WeakAuras/WeakAuras2/issues/5040) | Mute UX is mandatory for sound-heavy addons | Ship mute before sounds |
| [Reddit — alerts audible with game muted](https://www.reddit.com/r/wow/comments/1og52mo/raid_audio_alerts_is_there_anyway_to_mute_ingame/) | Master-channel resentment | Reinforces SFX-default for Beef |
| [Epilepsy Foundation — photosensitivity primer](https://www.epilepsy.com/stories/epilepsy-foundation-applauds-tiktoks-efforts-address-needs-people-photosensitive-epilepsy) | General PSE context (~3% of people with epilepsy) | Severity reminder, not WoW-specific API |

---

## Design-spec crosswalk (repo)

| URL / path | Why |
|------------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | V1 toasts, guild-chat spectacle, V2 ceremony phase |
| [`00-church-of-beef-implications.md`](../00-church-of-beef-implications.md) | “Guild-chat is the V1 spectacle budget” |
| [`04-ace3-and-libraries.md`](../04-ace3-and-libraries.md) | LSM mentioned at lib level — defer sound detail here |

---

## Provenance files

| File | Contents |
|------|----------|
| [`.raw/search-playsound-api.json`](.raw/search-playsound-api.json) | PlaySound / PlaySoundFile search |
| [`.raw/search-channel-norms.json`](.raw/search-channel-norms.json) | Master vs SFX / DBM norms |
| [`.raw/search-soundkit-ids.json`](.raw/search-soundkit-ids.json) | SOUNDKIT / RaidWarning IDs |
| [`.raw/search-sharedmedia-sounds.json`](.raw/search-sharedmedia-sounds.json) | LSM / custom packaging |
| [`.raw/search-overused-sounds.json`](.raw/search-overused-sounds.json) | WA mute, overused alerts |
| [`.raw/search-a11y-audio.json`](.raw/search-a11y-audio.json) | Photosensitivity + mute addons |
