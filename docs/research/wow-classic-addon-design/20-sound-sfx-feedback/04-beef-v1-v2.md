# Church of Beef — Sound / SFX: V1 vs V2

**Last updated:** 2026-07-25  
**Track:** [20-sound-sfx-feedback](README.md)  
**Spec anchors:** §10 V1 UI (toasts + guild-chat announce), §13.11 social check, §14 phase map (V2 ceremonial dashboard)

---

## Product principle

**Guild chat is the V1 spectacle budget.** Audio must never be required for a promotion to “count,” never drown combat alert stacks, and never ship as an unmutable surprise.

---

## V1 — Ship (minimal)

| Item | Recommendation | Rationale |
|------|----------------|-----------|
| Bundled `.ogg` files | **None** | Matches “plain frames / missing media OK”; keeps zip small |
| LibSharedMedia | **Do not depend** | Same as visual/LSM stance in implications synthesis |
| Default sound policy | **All Beef SFX off** *or* single soft cue on **rank approved** only (still muted by one checkbox) | Rare event; aligns with §13.11 moment without toast spam |
| Channel | **`SFX` only** | Respects Effects mute; does not fight DBM Master culture |
| Overused kits | **Do not call** `RAID_WARNING`, `READY_CHECK`, level-up **888** | Avoid combat-alert false alarms |
| If any stock kit | Quiet UI confirm (`GS_TITLE_OPTION_OK` / similar) — never raid ding | Low semantic collision |
| Mute UX | **Global “Enable sounds”** in UI prefs (default off); store in `ChurchOfBeefDB` | WA/DBM taught this the hard way |
| Per-event | V1 can be a single flag; no picker required | Scope control |
| Silent paths | Login sync, revision ignore, co-play ticks, suggestion create | High frequency = spam |
| Toasts | Visual only is enough for suggestion / Gora / ceremony credit | Spec lists toasts; does not require SFX |
| Officer announce | Keep text announce; **do not** auto-play sound on send | Announce opt-out ≠ SFX mute |
| Combat | If a sound exists, skip while `InCombatLockdown` / player in combat | Courtesy to boss mods |

### V1 non-goals (explicit)

- Ceremony soundtrack / looping ambience  
- Soundboard / meme clips  
- Master-channel “guaranteed hear” behavior  
- Muting other addons or Blizzard VO via `MuteSoundFile`  
- TTS / Dialog-channel sermons  

---

## V2 — Add when ceremonial theater lands

| Item | Recommendation |
|------|----------------|
| Custom media pack | 2–4 short branded `.ogg` under `Media/Sounds/` (promotion, demotion/excommunication, ceremony open, ceremony close) |
| LSM | Optional `Register("sound", ...)` so guild WA users can reuse; Beef playback still direct-path |
| Options | Per-event sound enable; optional sound picker (stock kit **or** Beef media **or** None); channel Advanced → Master |
| Ceremony profile | “Streamer quiet mode”: SFX off, visuals + guild text on |
| Spotlight moments | One cue when ceremonial dashboard spotlight starts — still cooldown-gated |
| Confessions feed | **Silent** by default (high frequency risk) |
| Accessibility | Document that Beef does not use full-screen flash; keep Alternate-Full-Screen-Effects-friendly toasts |

V3 (Gora theater) may add match-start / victory stingers — still behind mute, still not Raid Warning.

---

## Mapping to V1 toast list (spec §10)

| Toast | V1 sound | V2 sound |
|-------|----------|----------|
| Suggestion created | Silent | Optional soft tick (off by default) |
| Rank approved | Optional single soft cue (off by default) | Branded promotion `.ogg` |
| Gora / ceremony credit | Silent | Optional distinct soft cues |
| Demotion | Silent or same family as promotion (rarer) | Branded solemn cue |
| Guild-chat announce | N/A (text) | Optional local receive cue for addon users |

---

## Decision table (lock unless product revises)

| Decision | V1 lock |
|----------|---------|
| Is SFX required for success criterion §13.11? | **No** — guild chat reaction is the metric |
| Default channel | `SFX` |
| Default enabled | **false** (recommended) |
| Custom media in V1 zip | **false** |
| May use Master | **false** until V2 advanced option |

---

## Implementation notes (guidance only — no code in this track)

When engine work happens later:

- Centralize `BeefSound:Play(eventKey)` behind prefs + cooldown + combat check.  
- Never scatter raw `PlaySound` calls in Net sync handlers.  
- Prefs live with other UI settings (frame position, announce opt-out) in per-character SV.
