# Accessibility: Photosensitivity, Audio Spam & Mute UX

**Last updated:** 2026-07-25  
**Track:** [20-sound-sfx-feedback](README.md)  
**Boundary:** Full “clean UI” visual a11y is packaging/community track territory. Here: **audio** and how sound pairs with flashy feedback.

---

## 1. Photosensitivity (sound’s job is not to compensate with strobe)

Blizzard’s modern Accessibility menu includes **Alternate Full Screen Effects** aimed at players who need fewer flashing lights / patterns ([Blizzard Watch — Dragonflight accessibility](https://blizzardwatch.com/2022/07/27/accessibility-options-dragonflight/)). Photosensitive epilepsy is uncommon but high-impact; community threads still ask for friendlier defaults ([US forums — Epilepsy / Photosensitivity Friendly](https://us.forums.blizzard.com/en/wow/t/epilepsy-photosensitivity-friendly-please/2286418)).

Beef V1 toasts are visual. Rules for pairing with SFX:

| Do | Don’t |
|----|--------|
| One short, non-looping cue | Rapid repeat flashes + ding every standing tick |
| Steady toast fade (no screen flash / full-screen textures) | Reuse Blizzard full-screen alert textures as “ceremony” |
| Let mute kill audio without forcing louder visuals | “If muted, pulse the whole UI harder” |
| Prefer guild-chat text spectacle (spec §10) | Strobe raid-warning frame + RAID_WARNING sound |

Classic Anniversary may not expose the full Retail accessibility panel identically — do not depend on Retail-only a11y CVars. **Design as if Alternate Full Screen Effects exists:** Beef never becomes the thing those players must disable the game for.

Motion note (adjacent): camera shake / whirling camera are separate a11y toggles in Retail ([same Blizzard Watch article](https://blizzardwatch.com/2022/07/27/accessibility-options-dragonflight/)). Beef should not script camera tricks for ceremony.

---

## 2. Audio spam is a first-class failure mode

### 2.1 What players hate

- **Imported packs that re-enable sounds on every update** ([WeakAuras #5040](https://github.com/WeakAuras/WeakAuras2/issues/5040)).
- **Boss-mod / alert audio that ignores “I muted Effects”** when forced through Master — players resort to OS-level mute ([Reddit — raid audio alerts still audible](https://www.reddit.com/r/wow/comments/1og52mo/raid_audio_alerts_is_there_anyway_to_mute_ingame/)).
- **Repetitive world VO / toy / pet / fizzle loops** — entire addon category exists to `MuteSoundFile` them ([Mute Annoying WoW Sounds](https://www.curseforge.com/wow/addons/mute-wow-sounds), [MuteSoundFile](https://github.com/funkydude/MuteSoundFile), Leatrix-style mute features in QoL suites).

Beef’s risk surface (from the design spec):

| Event | Frequency | Sound risk |
|-------|-----------|------------|
| Shared instance co-play credit | Can tick / cap often | **High** if sounded — keep silent |
| Suggestion created | Per threshold cross | Medium — prefer silent or very soft |
| Gora / ceremony credit toast | Per event | Low–medium — optional soft cue |
| Rank approved / demotion | Rare | Only good default candidate |
| Guild-chat announce | Rare, officer-gated | Text is enough; optional local SFX for *recipients with addon* |

### 2.2 Anti-spam controls (design requirements)

1. **Global mute** — one checkbox / `/beef mute` style flag; persists in per-character SV (alongside other UI prefs).
2. **Per-category toggles** (V1 minimum: Promotions | Other toasts | None).
3. **Cooldown** — e.g. no Beef SFX more than once per N seconds; collapse bursts (sync storms, multi-credit) to one cue.
4. **No sound in combat** (optional but wise) — social toast can wait; never compete with DBM during a boss.
5. **Respect `willPlay` / SFX off** — do not escalate to Master to “fix” silence.
6. **Never play on login sync replay** — reconciliation must be silent (revision merges are not ceremonies).

---

## 3. Mute UX patterns to steal

| Pattern | Source | Steal for Beef |
|---------|--------|----------------|
| Global / group remove-sounds | WA sound-icon menu ([#5040](https://github.com/WeakAuras/WeakAuras2/issues/5040)) | One “Disable all Church sounds” |
| Master vs SFX channel option | DBM `UseMasterVolume` ([WoWInterface thread](https://www.wowinterface.com/forums/printthread.php?pp=60&t=39223)) | Advanced: “Use Master channel (louder)” default **off** |
| Sounds disabled by default for noncritical cues | ElvUI: select-unit / battle-res sounds **off by default** ([ElvUI changelog notes in library `.raw`](../.raw/elvui-short.md)) | Match: only promotion may default on — or all off |
| Surgical MuteSoundFile lists | MuteAnnoying / MuteSoundFile addons | Not Beef’s job; document for power users only |

Officer announce opt-out already exists in spec §10 (per-officer). Keep **SFX mute separate** from announce opt-out so silencing your own ears does not silence guild-chat spectacle for everyone.

---

## 4. Stream & voice-chat courtesy

Church of Beef is stream-facing (spec §1). Extra constraints:

- Loud Master fanfares bleed into Twitch VODs and Discord when the streamer monitors game audio.
- Guild-chat text is readable on stream overlays without ear fatigue (success criterion §13.11).
- If V2 adds ceremony audio, provide a **Streamer profile**: all SFX off, toasts on, announces on.

---

## 5. Checklist before any Beef sound ships

- [ ] Global mute exists and defaults are conservative  
- [ ] Event is rare or explicitly user-enabled  
- [ ] Channel is `SFX` unless user opted into Master  
- [ ] Kit is not Raid Warning / Ready Check / Level-up cliché  
- [ ] Cooldown prevents multi-fire from BeefNet / toast spam  
- [ ] Visual toast does not flash full-screen  
- [ ] Login sync / duplicate revision paths are silent  
