# Track 20 — Sound / SFX Feedback Design

**Lane:** Focused research (sound & feedback only)  
**Last updated:** 2026-07-25  
**Maps to:** [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10 (toasts + guild-chat spectacle), §14 (V2 ceremonial theater)  
**Does not cover:** Visual toast choreography, WeakAuras combat alerts, LibSharedMedia skinning beyond sound registration (see [10-skinning-masque-sharedmedia](../10-skinning-masque-sharedmedia/), [08-combat-hud-alerts](../08-combat-hud-alerts/)).

## Purpose

How Classic addons should play, mute, package, and pace audio feedback — and what Church of Beef should ship in V1 vs V2.

## Docs in this track

| File | Contents |
|------|----------|
| [01-api-norms-and-channels.md](01-api-norms-and-channels.md) | `PlaySound` / `PlaySoundFile`, channels, `willPlay`, mute APIs |
| [02-overused-sounds-and-packaging.md](02-overused-sounds-and-packaging.md) | Overused Blizzard kits, custom `.ogg` packaging, LSM sound register |
| [03-accessibility-and-spam.md](03-accessibility-and-spam.md) | Photosensitivity (paired with flashy UI), audio spam, mute UX |
| [04-beef-v1-v2.md](04-beef-v1-v2.md) | Concrete V1 / V2 recommendations for Beef |
| [05-annotated-urls.md](05-annotated-urls.md) | Annotated primary URLs |

## Top takeaways (one screen)

1. **V1 spectacle is guild chat, not SFX.** Spec §10 / §13.11 already lock promotion visibility to a throttled guild line. Audio is optional garnish.
2. **Default to `SFX` (or silence); treat `Master` as an opt-in.** Alert addons use `Master` so sounds cut through muted Effects — that also bypasses “I turned SFX off.” Social tools should not.
3. **Never default to `RAID_WARNING` / ready-check / level-up for Beef events.** Those kits are the community’s auditory wallpaper for combat alerts.
4. **Ship a global mute before you ship any sound.** WA / DBM history shows mute UX is demanded after the fact; Beef should lead with it.
5. **Custom media is V2.** V1 needs zero bundled audio; missing-media fallback already matches the visual policy.

## Provenance

Search JSON under [`.raw/`](.raw/). Prefer wiki / WowAce / WoWInterface / CurseForge / Blizzard Watch over listicles.
