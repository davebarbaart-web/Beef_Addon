# Overused Blizzard Sounds & Custom Media Packaging

**Last updated:** 2026-07-25  
**Track:** [20-sound-sfx-feedback](README.md)  
**Boundary:** LibSharedMedia *skinning / fonts / statusbars* belong to [track 10](../10-skinning-masque-sharedmedia/). This file covers **sound** registration and packaging only.

---

## 1. Overused Blizzard kits (avoid as Beef defaults)

These are the auditory clichés of the addon ecosystem — fine as player-selectable options later, poor as Church-of-Beef brand defaults.

| Kit / cue | Typical ID / constant | Why it’s worn out |
|-----------|----------------------|-------------------|
| Raid Warning ding | `SOUNDKIT.RAID_WARNING` = **8959** ([Wowhead](https://www.wowhead.com/sound=8959/raidwarning), [SoundKit list thread](https://www.wowinterface.com/forums/showthread.php?t=55702)) | Default mental model for “something urgent in raid.” Also abused by noisy raid leaders ([EU forums — Raid Warnings Off](https://eu.forums.blizzard.com/en/wow/t/raid-warnings-off/353992)). |
| Ready Check | `SOUNDKIT.READY_CHECK` = **8960** | Already means “stack for pull.” Hijacking it for promotions trains the wrong reflex. |
| Level-up / invite fanfare | SoundKit **888** (level-up; also associated with guild invite in community notes) ([WoWInterface SoundKit thread](https://www.wowinterface.com/forums/showthread.php?t=55702)); FileDataID examples like **569593** for LevelUp.ogg ([MuteSoundFile wiki](https://warcraft.wiki.gg/wiki/API_MuteSoundFile)) | Every achievement, WA pack, and LFG enhance uses cousins of this fanfare (DBM historically blasted `levelup2.ogg` on Master for queue alerts). |
| Raid boss whisper / emote warning | `RAID_BOSS_EMOTE_WARNING` = **12197** | Combat-adjacent urgency. |
| Generic UI clicks | `IG_MAINMENU_OPEN` / `GS_TITLE_OPTION_OK` family | Harmless for frame open/close; meaningless as “you were promoted.” |
| Quest complete / accept | Common mute-list targets in [Mute Annoying WoW Sounds](https://www.curseforge.com/wow/addons/mute-wow-sounds) | Players already fatigue on quest audio; don’t pile Beef on top. |

Boss-mod culture explicitly *registers* Raid Warning / Raid Boss Whisper into SharedMedia and plays them on **Master** ([BigWigs Sound.lua pattern](https://github.com/nickbender/wow-interface/blob/master/BigWigs_Plugins/Sound.lua)). Anything Beef plays that sounds like that stack will be mis-attributed as a combat alert on stream VODs.

**Brand heuristic:** If a random raider would ask “what mechanic was that?”, the kit is wrong for a rank toast.

---

## 2. What *does* fit a social / ceremonial tool

Safer Blizzard-adjacent choices if V1 wants *any* stock audio without shipping files:

- Soft UI confirm / gold coin / quiet “paper” style interface kits (loot coin, menu OK) — still optional.
- Prefer **silence + guild chat + toast** over a borrowed fanfare.
- If a stock kit is used once: pick something *not* in DBM/WA default lists, keep it promotion-only, and expose mute.

Longer term (V2): one short custom `.ogg` with Church character (bell, choir stab, grill sizzle — tasteful, short, low peak) beats any Blizzard kit for brand recognition.

---

## 3. Custom media packaging

### 3.1 Layout

```
ChurchOfBeef/
  Media/Sounds/           # or Sounds/
    promotion.ogg
    ceremony_open.ogg
  ...
```

Play with:

`PlaySoundFile("Interface\\AddOns\\ChurchOfBeef\\Media\\Sounds\\promotion.ogg", channel)`

Slash separators also accepted per wiki. File must be present before login.

### 3.2 Format & mastering

- Prefer **Ogg Vorbis**, mono or stereo, short (≤2s for toasts; longer only for ceremony open/close).
- Master quieter than Blizzard UI clicks; players already run loud Master for boss mods.
- No `.wav` reliance for custom addon media (legacy restriction notes).
- License everything you ship (CC0 / original / cleared). Don’t yank YouTube rips into CurseForge packages.

### 3.3 TOC / size

- Sound files need not be listed in `.toc` ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format)).
- Keep V1 zip lean — Anniversary guild installs are already multi-addon. A sound pack is easy to add later; hard to remove from “why is this addon huge?” complaints.

### 3.4 Missing media

Silent no-op if file absent — align with spec §10 “Missing fonts/textures must fall back.” Never error-spam chat when an ogg is deleted.

---

## 4. LibSharedMedia sound registration (optional V2)

[LibSharedMedia-3.0](https://www.wowace.com/projects/libsharedmedia-3-0) exposes `MediaType.SOUND`. Register:

`LSM:Register("sound", "Beef Promotion Bell", [[Interface\AddOns\ChurchOfBeef\Media\Sounds\promotion.ogg]])`

API docs: [WowAce LSM API](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation).

Conventions from LSM docs:

- Descriptive handles (“Beef Rank Approved”), not generic “Alert”.
- Built-in default sound handle is effectively **None** → `Interface\Quiet.ogg` (no-op path pattern used across LSM consumers).
- Do not prefix fake namespaces that fragment dropdowns.

Community packaging patterns:

- **SharedMedia / MyMedia** — drop files into `sound\` and register paths ([MyMedia instructions](https://github.com/abl/AddOns/blob/master/SharedMedia/INSTRUCTIONS%20for%20MyMedia.txt)).
- **SharedMediaAdditionalSounds** — injects extra Blizzard sounds into LSM for WA/TMW/etc. ([CurseForge](https://www.curseforge.com/wow/addons/sharedmediaadditionalsounds)).
- Players still hand-roll LSM packs for custom alerts ([Blizzard forum — custom sound pack](https://us.forums.blizzard.com/en/wow/t/i-created-my-own-addon-just-to-register-custom-sounds/2024737)).

**Beef stance:** Do **not** require LSM in V1 (matches implications synthesis: no LSM hard dependency). In V2, optionally *register* Beef sounds so WA-using guildies can reuse them — still play internally via direct `PlaySoundFile` so Beef works without LSM installed.

---

## 5. Antipatterns

| Antipattern | Why |
|-------------|-----|
| Play Raid Warning on every toast | Auditory cry-wolf; stream fatigue |
| Ship 40 meme soundboard clips | Bloat + spam + copyright |
| Hot-loop a sound on standing ticks | Same class of hate as worgen sniffs / train toy ([mute addon economy](https://www.curseforge.com/wow/addons/mute-wow-sounds)) |
| Change `Sound_*` CVars around a play | Breaks user’s mix; races other addons |
| Depend on SharedMediaAdditionalSounds | Invisible dependency; empty dropdowns confuse support |

---

## 6. Cross-links

- Channel / mute API detail → [01-api-norms-and-channels.md](01-api-norms-and-channels.md)
- Spam & a11y → [03-accessibility-and-spam.md](03-accessibility-and-spam.md)
- Product cut → [04-beef-v1-v2.md](04-beef-v1-v2.md)
