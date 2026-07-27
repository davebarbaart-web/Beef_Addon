# 17 — UI sound design for Church of Beef

**Audience:** Coding agents polishing social / UI “juice” (toasts, ceremony chrome, officer alerts, promotion spectacle).  
**Authority:** Product law in `docs/superpowers/specs/2026-07-25-church-of-beef-design.md` §10 / §13.11 / §15 (SFX row); agent UI briefing [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md).  
**Depth tracks (do not fork policy here):** [`20-sound-sfx-feedback/`](../wow-classic-addon-design/20-sound-sfx-feedback/), [`49-officer-notifications/`](../wow-classic-addon-design/49-officer-notifications/), [`24-policy-tos-compliance/`](../wow-classic-addon-design/24-policy-tos-compliance/), [`45-licensing-maintainer-norms/`](../wow-classic-addon-design/45-licensing-maintainer-norms/).  
**Client:** TBC Classic Anniversary (`## Interface: 20506`).

---

## 1. Product doctrine (one screen)

| Lock | Meaning for agents |
|------|-------------------|
| **V1 is silent** | Spec §10 / §15 / glossary 79: no SFX in the V1 ship. Guild-chat announce + private edge toasts carry spectacle. |
| **Later SFX = optional garnish** | Default **off**; never required for a promotion to “count” (§13.11 = guild-chat reaction). |
| **Not a combat alert tool** | Do not copy DBM/WA Master-channel / Raid Warning culture. |
| **Mute before media** | Ship global mute UX *before* any play path goes live. |
| **No ripped Blizzard audio in the zip** | Play kits by ID in-client; ship only cleared custom `.ogg` (or nothing). |

**Doctrine line:** *Spectacle lives in `/g` text and quiet edge toasts; audio is rare, SFX-channel, mute-first, and never a raid ding.*

---

## 2. `PlaySound` vs `PlaySoundFile`

Two APIs, two ID spaces — pick by *what you own*.

| API | Input | Use when |
|-----|--------|----------|
| [`PlaySound(soundKitID [, channel, forceNoDuplicates, runFinishCallback])`](https://warcraft.wiki.gg/wiki/API_PlaySound) | **SoundKitID** (number). FrameXML names in global `SOUNDKIT` | Stock Blizzard UI kits (often a random set of variants) |
| [`PlaySoundFile(sound [, channel])`](https://warcraft.wiki.gg/wiki/API_PlaySoundFile) | **FileDataID** (number) *or* addon path string | One file: game FileDataID, or `Interface\AddOns\ChurchOfBeef\…\file.ogg` |

Both return `willPlay, soundHandle`. `willPlay` is falsy when the channel is muted / playback blocked — **do not retry on Master** to “fix” silence. Use `soundHandle` + `StopSound` only if you ever ship a long ceremony cue that must cut short.

`forceNoDuplicates` on `PlaySound` (default true) collapses double-fires in one frame — useful for toast + announce race.

### Channel (the real product decision)

Optional second arg; **default is `SFX`**.

| Channel | Meaning for Beef |
|---------|------------------|
| `SFX` | **Default.** Respects Effects mute/slider. Correct for social / UI chrome. |
| `Master` | Ignores Effects; only Master gates it. Boss-mod culture. **Opt-in only** in a later spectacle pass — never V1 default. |
| `Dialog` / `Music` / `Ambience` | Wrong for short UI pings (Dialog only if you ever ship cleared VO). |

There is **no per-call volume** — loudness = channel slider + how hot the file is mastered. Master quieter than Blizzard UI clicks; raiders already run loud Master for boss mods.

### Norms summary

1. Stock tick → `PlaySound(SOUNDKIT.*)` (soft UI confirm family, not raid kits).  
2. Branded one-shot → `PlaySoundFile("Interface\\AddOns\\ChurchOfBeef\\Media\\Sounds\\….ogg", "SFX")`.  
3. Game assets: use SoundKitID / FileDataID — modern clients reject old `Sound\\…` path strings for shipped game files.  
4. Addon folder paths remain valid for files **you** ship.  
5. Centralize behind something like `BeefSound:Play(eventKey)` — never scatter raw plays in Net sync / login reconcile handlers.

---

## 3. Mute-friendly design (three layers)

| Layer | Mechanism | Beef stance |
|-------|-----------|-------------|
| **1. Addon mute (required)** | `ChurchOfBeefDB.ui.soundsEnabled` (or equivalent); global “Enable sounds”; later per-event | Own flag; persist; default **false**. Separate from officer **announce** opt-out. |
| **2. Channel respect** | Play on `"SFX"` → `Sound_EnableSFX = 0` ⇒ `willPlay` false | Feature, not a bug. Never escalate to Master. |
| **3. Surgical game mute** | `MuteSoundFile` / `UnmuteSoundFile` | **Not a Beef feature.** Do not silence other addons or Blizzard VO. |

### Mute UX rules

- One checkbox kills all Beef audio; WA history shows mute is demanded after the fact — lead with it.  
- Optional later: Promotions | Officer alerts | Ceremony | Other.  
- Cooldown: at most one Beef cue per N seconds; collapse sync storms to one play.  
- Skip while player in combat (`UnitAffectingCombat` / regen) when a sound exists — social can wait; never compete with DBM.  
- Login sync / revision merge / co-play ticks: **always silent**.  
- Do not mutate `Sound_*` CVars around a play.  
- Streamer / Discord courtesy: Master fanfares bleed into VODs; prefer text spectacle + optional SFX.

Announce opt-out silences **guild chat for others**; SFX mute silences **your ears only**. Keep them separate.

---

## 4. Spectacle without annoyance

V1 success criterion §13.11 is a **visible guild-chat reaction**, not an audible ding.

| Do | Don’t |
|----|--------|
| One short, non-looping cue on rare rites | Ding every standing tick / toast / BeefNet apply |
| Soft UI kit or quiet branded `.ogg` | `SOUNDKIT.RAID_WARNING` (8959), `READY_CHECK` (8960), level-up **888** as defaults |
| Guild-chat line + edge toast | Full-screen flash + raid ding + Master |
| Cooldown + combat skip | Retry louder when `willPlay` is false |
| Officer queue: visual + flash first | Copy loot-reminder `FlashClientIcon` + `PlaySound(8959, "master")` wholesale |

**Brand heuristic:** if a raider asks “what mechanic was that?”, the kit is wrong for a rank toast.

Photosensitivity pairing: mute must not force louder / strobing visuals. Steady toast fade only — no full-screen alert textures as “ceremony.”

---

## 5. Packing custom sounds

### Layout (post-V1 / spectacle pass)

```
ChurchOfBeef/
  Media/Sounds/
    promotion.ogg
    demotion.ogg
    ceremony_open.ogg
    ceremony_close.ogg
```

Play:

```lua
PlaySoundFile("Interface\\AddOns\\ChurchOfBeef\\Media\\Sounds\\promotion.ogg", "SFX")
```

### Packaging rules

| Rule | Detail |
|------|--------|
| TOC | Sound files **need not** be listed in `.toc` (same as textures). Must exist before login (client caches addon tree). |
| Format | Prefer **Ogg Vorbis**; short (≤2s toasts; longer only for ceremony open/close). |
| Missing media | Silent no-op — align with “missing fonts/textures still load.” Never error-spam chat. |
| V1 zip | **Zero** bundled audio (keeps install lean). |
| LSM | No hard dependency in V1. Optional V2 `LSM:Register("sound", "Beef Rank Approved", path)` while Beef still plays via direct path. |
| Mastering | Quieter than Blizzard UI; mono OK; no meme soundboard packs. |

### Provenance (before any `.ogg` lands in the zip)

One row per file: filename · source URL · license · redistributable Y/N. Prefer original / commissioned / clearly licensed free SFX. Document in `ThirdPartyNotices` / `Assets/LICENSES`.

---

## 6. ToS / policy / licensing

Not legal advice — product hygiene aligned with research tracks 24 + 45.

| Topic | Beef rule |
|-------|-----------|
| **UI Add-On Development Policy** ([US sticky](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534)) | Free addon; no in-game ads/tip jars; Teen-safe tone; no automation. |
| **Music / copyright note (2009)** | Do **not** redistribute Blizzard soundtrack / ripped game audio in the package. Playing by SoundKitID / FileDataID in-client is fine; zipping extracts is not. |
| **Meme / TV / voice clips** | Copyright minefield; CurseForge/Overwolf upload warrants rights. Prefer original or cleared licensed SFX. |
| **Sound replace era** | Post–8.2 folder override is gone; `MuteSoundFile` mutes, does not replace. Irrelevant to Beef shipping. |
| **Gameplay ToS** | Sounds never imply combat assistance, wagering, or automation. Social announce/track/display only. |

---

## 7. Sound matrix by event

Legend: **V1** = current ship (silent). **Later** = optional spectacle pass (default off unless noted). Channel always `"SFX"` unless user opts into Advanced → Master.

| Event | Frequency | V1 audio | Later audio (default off) | API / asset | Channel | Notes |
|-------|-----------|----------|---------------------------|-------------|---------|-------|
| **Rank approved** (officer Commit → promote) | Rare | Silent | Soft branded promotion cue **or** quiet UI confirm kit | `PlaySoundFile(…/promotion.ogg)` or soft `PlaySound(SOUNDKIT.*)` — **not** 8959/8960/888 | `SFX` | Best candidate if any sound exists; still gated by global mute |
| **Rank demoted / excommunication** | Rare | Silent | Solemn short cue (same family or distinct) | Custom `.ogg` or soft kit | `SFX` | Rarer than promote; still not Raid Warning |
| **Guild-chat announce send** (approving officer) | Rare | N/A (text) | No auto-sound on **send** | — | — | Announce opt-out ≠ SFX mute |
| **Guild-chat announce receive** (peers with addon) | Rare | Silent | Optional local soft tick | Soft kit / tiny `.ogg` | `SFX` | Text remains the spectacle; audio optional |
| **Private edge toast — rank change** | Rare | Silent (visual) | Same as promote/demote (one cue total, not toast+announce stack) | Shared `eventKey` | `SFX` | Coalesce with commit path |
| **Suggestion created** (threshold crossed) | Medium | Silent | Optional soft tick | Soft kit | `SFX` | Off by default even in later pass |
| **Officer pending-queue became non-empty** | Medium | Silent | Optional soft UI kit (not 8959) | `PlaySound(softKit, "SFX")` | `SFX` | Prefer RaidNotice + `FlashClientIcon` + print; sound last |
| **Officer queue soft update** (already had items) | Medium–high | Silent | **Silent** | — | — | No ding on count bumps |
| **Gora / duel credit toast** | Low–medium | Silent | Optional distinct soft cue | Soft kit / short `.ogg` | `SFX` | Never Ready Check |
| **Ceremony attendance credit** | Per event | Silent | Optional soft cue | Soft kit | `SFX` | |
| **Ceremony open / close** (V2 dashboard) | Rare | N/A | Branded open/close `.ogg` | `PlaySoundFile` | `SFX` (Master opt-in) | Streamer quiet profile: SFX off |
| **Ceremonial spotlight start** | Rare | N/A | One cue, cooldown-gated | Custom / soft | `SFX` | |
| **Confessions feed item** | High risk | N/A | **Silent** by default | — | — | High-frequency spam risk |
| **Co-play / shared-instance standing tick** | High | Silent | **Silent forever** | — | — | Hard ban — standing drip ≠ ceremony |
| **Login sync / revision reconcile** | Every login | Silent | **Silent forever** | — | — | Hard ban |
| **BeefNet apply / peer revision ignore** | High | Silent | **Silent forever** | — | — | Hard ban |
| **Panel open / tab click / button** | High | Silent | Optional stock UI click only if Chrome sounds exist | `IG_MAINMENU_*` / OK family | `SFX` | Harmless chrome; not “you were promoted” |
| **Minimap button click** | Medium | Silent | Same as panel chrome | Soft kit | `SFX` | |
| **Destructive confirm show** (demote / Prophet) | Rare | Silent | Optional soft confirm | Soft kit | `SFX` | Visual modal carries weight |
| **Settings toggle** | Low | Silent | Silent or tiny click | Soft kit | `SFX` | |

### Banned as Beef defaults (any phase)

| Kit / pattern | Why |
|---------------|-----|
| `SOUNDKIT.RAID_WARNING` / 8959 | Combat wallpaper; stream false alarm |
| `SOUNDKIT.READY_CHECK` / 8960 | Means “stack for pull” |
| Level-up / invite fanfare (e.g. kit **888**) | Achievement / WA cliché |
| `RAID_BOSS_EMOTE_WARNING` | Combat urgency |
| Master channel without explicit user option | Bypasses Effects mute; fights boss mods |
| Looping ambience / soundboard meme packs | Spam + copyright + zip bloat |
| Sound on every toast type by default | Fatigue → uninstall |

---

## 8. Implementation sketch (guidance only)

When a spectacle pass lands:

```text
✅ BeefSound:Play(eventKey)
     → if not prefs.soundsEnabled then return
     → if combat skip then return
     → if cooldown active then return
     → resolve eventKey → kit or path
     → PlaySound / PlaySoundFile(..., "SFX" or prefs.channel)
     → honor willPlay; never escalate
❌ PlaySound in Sync:OnLogin / Net apply / co-play scorer
❌ PlaySound(8959) or PlaySoundFile(..., "Master") as defaults
❌ MuteSoundFile on Blizzard / other-addon assets
```

Prefs live with other UI settings in per-character `ChurchOfBeefDB` (position, minimap, announce). V1 settings budget does **not** require a sound checkbox until sounds exist.

---

## 9. Shipping checklist (before any Beef sound ships)

- [ ] Global mute exists; default **off** (or promotion-only behind mute)  
- [ ] Event is rare or explicitly user-enabled  
- [ ] Channel is `SFX` unless user opted into Master  
- [ ] Kit is not Raid Warning / Ready Check / Level-up  
- [ ] Cooldown prevents multi-fire from BeefNet / toast spam  
- [ ] Login sync / co-play / queue soft-updates stay silent  
- [ ] Visual toast does not flash full-screen  
- [ ] Custom media: provenance table + license; no Blizzard rips  
- [ ] Missing `.ogg` → silent; addon still loads  
- [ ] Announce opt-out still independent of SFX mute  
- [ ] In-client: Effects off ⇒ no Beef audio; no Master surprise  

---

## 10. Where to deepen (do not duplicate)

| Need | Path |
|------|------|
| API / channels / `willPlay` | [`20-sound-sfx-feedback/01-api-norms-and-channels.md`](../wow-classic-addon-design/20-sound-sfx-feedback/01-api-norms-and-channels.md) |
| Overused kits + `.ogg` packaging | [`20-sound-sfx-feedback/02-overused-sounds-and-packaging.md`](../wow-classic-addon-design/20-sound-sfx-feedback/02-overused-sounds-and-packaging.md) |
| A11y / spam / mute UX | [`20-sound-sfx-feedback/03-accessibility-and-spam.md`](../wow-classic-addon-design/20-sound-sfx-feedback/03-accessibility-and-spam.md) |
| V1 vs V2 product cut | [`20-sound-sfx-feedback/04-beef-v1-v2.md`](../wow-classic-addon-design/20-sound-sfx-feedback/04-beef-v1-v2.md) |
| Officer alert combos | [`49-officer-notifications/alert-channel-matrix.md`](../wow-classic-addon-design/49-officer-notifications/alert-channel-matrix.md) |
| ToS / music copyright | [`24-policy-tos-compliance/ui-addon-development-policy.md`](../wow-classic-addon-design/24-policy-tos-compliance/ui-addon-development-policy.md) |
| Asset licenses | [`45-licensing-maintainer-norms/02-assets-and-third-party.md`](../wow-classic-addon-design/45-licensing-maintainer-norms/02-assets-and-third-party.md) |
| Annotated URLs | [`20-sound-sfx-feedback/05-annotated-urls.md`](../wow-classic-addon-design/20-sound-sfx-feedback/05-annotated-urls.md) |
| UI CreateFrame briefing | [`docs/superpowers/ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) |

---

## 11. One-line doctrine for polish agents

*Keep V1 silent; when audio arrives, play rare rites on SFX behind a default-off mute, never Raid Warning on Master, and never put ceremony in a co-play tick.*

---

## 12. Deepen pass — primary-sourced sound UX (2026-07-26)

> **CoB constraints preserved:** V1 remains **silent** (spec §10 / §15 / glossary); Anniversary `20506`; no bots/automation; no ripped Blizzard soundtrack in the zip; announce/track/sync only; UI never awards points; sound (if ever) stays optional garnish on SFX behind default-off mute — never a combat alert tool.

### API contract (cite the wiki, don’t invent args)

| API | Primary | Facts agents rely on |
|-----|---------|----------------------|
| `PlaySound` | [warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_PlaySound) · [Wowpedia](https://wowpedia.fandom.com/wiki/API_PlaySound) | SoundKitID; optional channel; `forceNoDuplicates`; returns `willPlay, soundHandle` |
| `PlaySoundFile` | [warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_PlaySoundFile) · [Wowpedia](https://wowpedia.fandom.com/wiki/API_PlaySoundFile) | FileDataID **or** addon path; channel table; Master examples exist — **do not copy as Beef default** |
| `StopSound` | [warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_StopSound) · [Wowpedia](https://wowpedia.fandom.com/wiki/API_StopSound) | Cut long ceremony cues only; not for toast spam control |
| `MuteSoundFile` | [warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_MuteSoundFile) | Surgical mute of FileDataIDs — **not a Beef feature** |

Historical channel split (Master / SFX / Music / Ambience) is documented in community threads from the 4.x era ([WoWInterface — PlaySound channel argument](https://wowinterface.com/forums/showthread.php?t=38901)). Boss-mod culture uses Master + opt-out because Effects mute would silence alerts ([DBM Master channel discussion](https://www.wowinterface.com/forums/printthread.php?pp=60&t=39223)) — that is exactly why **social** juice must default to `"SFX"` and never escalate when `willPlay` is false.

Game assets need SoundKitID / FileDataID — obsolete `Sound\\…` path macros error on modern clients ([PlaySoundFile Invalid fileDataID — US forums](https://us.forums.blizzard.com/en/wow/t/playsoundfile-macros-resulting-in-error/207665)). Addon-folder paths remain valid for files **you** ship.

### Overused kits (ban from Beef defaults)

Community `SOUNDKIT` excerpts repeatedly surface Raid Warning **8959** and Ready Check **8960** ([WoWInterface SoundKitConstants thread](https://www.wowinterface.com/forums/showthread.php?t=55702); [Wowhead RaidWarning 8959](https://www.wowhead.com/sound=8959/raidwarning); browse [Wowhead Sounds](https://www.wowhead.com/sounds)). Players already hate raid-warning spam even from humans ([Raid Warnings Off — EU forums](https://eu.forums.blizzard.com/en/wow/t/raid-warnings-off/353992)). Master-channel resentment shows up in player threads when alerts ignore Effects mute ([Reddit r/wow — raid audio alerts](https://www.reddit.com/r/wow/comments/1og52mo/raid_audio_alerts_is_there_anyway_to_mute_ingame/)).

**Brand test:** if a raider asks “what mechanic was that?”, the kit is wrong for a rank toast.

### Mute-first is mandatory (ecosystem proof)

Sound-heavy addons get mute requests after the fact — WeakAuras global mute issue is the canonical product lesson ([WeakAuras #5040](https://github.com/WeakAuras/WeakAuras2/issues/5040)). Entire addon ecosystems exist to mute fatigue sounds ([Mute Annoying WoW Sounds — CurseForge](https://www.curseforge.com/wow/addons/mute-wow-sounds); [MuteSoundFile — GitHub](https://github.com/funkydude/MuteSoundFile); [MuteAnnoying — WowAce](https://www.wowace.com/projects/muteannoying); forum ID dumps [MuteSoundFile — US forums](https://us.forums.blizzard.com/en/wow/t/mutesoundfile-post-sound-ids-here/215444)). Classic players even hunt WeakAuras to silence repair screeches ([r/classicwow](https://www.reddit.com/r/classicwow/comments/113g5gh/does_anyone_have_a_weakaura_that_mutes_the_repair)).

**CoB rule:** ship `ChurchOfBeefDB.ui.soundsEnabled` (default **false**) *before* any play path goes live. Announce opt-out ≠ SFX mute.

### Packaging & LSM (post-V1 only)

- TOC: sound files need not be listed ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format)) — must exist before login.  
- Prefer short Ogg Vorbis under `ChurchOfBeef/Media/Sounds/`.  
- Optional later: `LSM:Register("sound", …)` ([LSM API docs](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation); [LSM project](https://www.wowace.com/projects/libsharedmedia-3-0); custom register anecdote [US forums](https://us.forums.blizzard.com/en/wow/t/i-created-my-own-addon-just-to-register-custom-sounds/2024737)).  
- Never hard-depend SharedMediaAdditionalSounds ([CurseForge](https://www.curseforge.com/wow/addons/sharedmediaadditionalsounds)).

### Policy / licensing (hygiene, not legal advice)

| Source | Beef takeaway |
|--------|----------------|
| [UI Add-On Development Policy — US forums](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534) | Free addon; no ads/tip jars; Teen-safe; no automation |
| [Blizzard AddOn Policy — WoWWiki archive](https://wowwiki-archive.fandom.com/wiki/Blizzard_AddOn_Policy) | Historical policy context |
| Music / copyright sticky culture (track 24) | Do **not** redistribute ripped soundtrack; play by ID in-client is fine |
| Photosensitivity / a11y signals | [Blizzard Watch DF a11y](https://blizzardwatch.com/2022/07/27/accessibility-options-dragonflight/); [US forums photosensitivity](https://us.forums.blizzard.com/en/wow/t/epilepsy-photosensitivity-friendly-please/2286418) — mute must not force strobing visuals |

### Implementation sketch (cite-aligned)

```text
✅ BeefSound:Play(eventKey)
     → prefs.soundsEnabled == true (default false)
     → not in combat skip (social can wait)
     → cooldown / coalesce (one cue per N seconds)
     → PlaySound(kit, "SFX") or PlaySoundFile(path, "SFX")
     → if not willPlay: stop (never escalate to Master)
❌ PlaySound in Sync:OnLogin / Net apply / co-play tick
❌ PlaySound(8959) / Ready Check / level-up fanfare defaults
❌ MuteSoundFile on Blizzard or other-addon assets
```

Layer law: sound helpers live under `UI/` (or a tiny UI-adjacent helper) — never Core scoring, never Net inventing ceremony audio on peer apply.

---

## External sources

Annotated primaries for this deepen pass (≥8). Prefer wiki + Blizzard policy + mute-economy evidence over meme soundboard blogs.

1. [API PlaySound — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_PlaySound) — SoundKitID, channels, `willPlay`, `forceNoDuplicates`.  
2. [API PlaySound — Wowpedia](https://wowpedia.fandom.com/wiki/API_PlaySound) — mirror.  
3. [API PlaySoundFile — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_PlaySoundFile) — FileDataID / addon path.  
4. [API PlaySoundFile — Wowpedia](https://wowpedia.fandom.com/wiki/API_PlaySoundFile) — mirror.  
5. [API StopSound — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_StopSound) — stop by handle.  
6. [API MuteSoundFile — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_MuteSoundFile) — surgical mute (not a Beef feature).  
7. [UI Add-On Development Policy — Blizzard US forums](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534) — free addon / no automation / Teen-safe.  
8. [PlaySound channel argument — WoWInterface](https://wowinterface.com/forums/showthread.php?t=38901) — Master/SFX/Music/Ambience split.  
9. [DBM Master channel / volume — WoWInterface](https://www.wowinterface.com/forums/printthread.php?pp=60&t=39223) — why alert addons use Master (do not copy).  
10. [SoundKitConstants discussion — WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=55702) — RAID_WARNING 8959 / READY_CHECK 8960 excerpts.  
11. [Wowhead — RaidWarning sound 8959](https://www.wowhead.com/sound=8959/raidwarning) — canonical ding ID.  
12. [WeakAuras #5040 — global mute request](https://github.com/WeakAuras/WeakAuras2/issues/5040) — mute-first product lesson.  
13. [Mute Annoying WoW Sounds — CurseForge](https://www.curseforge.com/wow/addons/mute-wow-sounds) — mute economy proof.  
14. [MuteSoundFile — GitHub (funkydude)](https://github.com/funkydude/MuteSoundFile) — FileDataID mute UX.  
15. [Reddit r/wow — raid alerts vs game mute](https://www.reddit.com/r/wow/comments/1og52mo/raid_audio_alerts_is_there_anyway_to_mute_ingame/) — Master-channel resentment.  
16. [PlaySoundFile Invalid fileDataID — Blizzard US forums](https://us.forums.blizzard.com/en/wow/t/playsoundfile-macros-resulting-in-error/207665) — IDs not old Sound\\ paths.  
17. [LibSharedMedia-3.0 API — WowAce](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation) — optional SOUND register.  
18. [Raid Warnings Off — Blizzard EU forums](https://eu.forums.blizzard.com/en/wow/t/raid-warnings-off/353992) — player fatigue signal.  
19. [TOC format — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/TOC_format) — media need not be TOC-listed.  
20. [Custom LSM sounds — Blizzard US forums](https://us.forums.blizzard.com/en/wow/t/i-created-my-own-addon-just-to-register-custom-sounds/2024737) — Ogg + Register workflow anecdote.  

**Sister depth (repo):** [20/05 annotated-urls](../wow-classic-addon-design/20-sound-sfx-feedback/05-annotated-urls.md) · [20/01 API norms](../wow-classic-addon-design/20-sound-sfx-feedback/01-api-norms-and-channels.md) · [24 policy](../wow-classic-addon-design/24-policy-tos-compliance/).
