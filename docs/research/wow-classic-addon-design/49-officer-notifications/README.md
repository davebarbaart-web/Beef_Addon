# Track 49 — Officer notifications (whisper / print / flash)

**Track id:** `49-officer-notifications`  
**Last updated:** 2026-07-25  
**Sole focus:** How Officer+ clients learn about **pending promotion suggestions** without chat/SFX spam — Classic attention channels (`RaidNotice` caution, `FlashClientIcon`, print/chat log, whisper-self, sound-once) mapped to Church of Beef.  
**Out of scope:** Officer+ roster gates ([16](../16-guild-roster-officer-edges/)); approve/reject accountability ([40](../40-officer-moderation-audit/)); BeefNet transport ([14](../14-addon-messaging-beefnet/)); general toast/SFX packaging ([20](../20-sound-sfx-feedback/), [08](../08-combat-hud-alerts/)); announce-line craft ([32](../32-microcopy-tone-voice/)). No addon implementation in this folder.

## Product truth (from V1 design spec)

| Locked default | Value |
|----------------|-------|
| Trigger | Threshold cross → **pending suggestion** (never auto-promote) |
| Net type | `SUGGESTION` — members submit; officers filter |
| Officer surface | Officer tab: pending queue, approve/reject, corrections |
| Member toasts | Suggestion created · rank approved · Gora/ceremony credit |
| Spectacle | Guild-chat promotion line from **approving** officer only |
| Open risk §16.5 | V1 may only notify officers who were online for the `SUGGESTION` |

Sources: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §7.3, §8.1, §10, §16.5.

## Index

| Note | Covers |
|------|--------|
| [alert-channel-matrix.md](alert-channel-matrix.md) | Print vs whisper-self vs RaidNotice vs FlashClientIcon vs sound |
| [anti-spam-coalescing.md](anti-spam-coalescing.md) | Queue coalescing, cooldowns, silent sync replay |
| [beef-officer-alert-recipe.md](beef-officer-alert-recipe.md) | Concrete V1 / opt-in recipe for Beef |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Alert on queue edge, not every `SUGGESTION` packet.** Classic officers hate loot-council / ready-check spam culture. Fire the “attention kit” when pending count goes **0 → ≥1** (or after a long quiet cooldown), then only soft-update (badge / chat line) for further arrivals. Sync replay and login catch-up stay silent.

2. **Steal the *visual* RAID_WARNING frame, not the *raid* channel and not the worn-out ding by default.** Ecosystem norm for a *personal* center caution is `RaidNotice_AddMessage(RaidWarningFrame, text, ChatTypeInfo["RAID_WARNING"])` ([WoWInterface — personal raid warning](https://www.wowinterface.com/forums/showthread.php?t=36250)) — local only, no `SendChatMessage(..., "RAID_WARNING")`. Pairing that with `SOUNDKIT.RAID_WARNING` (8959) trains “boss mechanic” reflexes; track [20](../20-sound-sfx-feedback/) already bans that kit as a Beef default.

3. **`FlashClientIcon` is the right alt-tab ping.** Wiki: flashes the OS client icon; available since Classic **1.13.2** / Retail 6.2.0 ([FlashClientIcon](https://warcraft.wiki.gg/wiki/API_FlashClientIcon)). Use once per coalesced alert. Players who hate it already NOP the global (`FlashClientIcon = function() end` — same wiki). Respect that culture: expose a toggle.

4. **Prefer `print` / `DEFAULT_CHAT_FRAME:AddMessage` over whisper-self for the durable breadcrumb.** `print` is the clean local log path ([API print](https://wowwiki-archive.fandom.com/wiki/API_print)). Whisper-self via `SendChatMessage(msg, "WHISPER", nil, UnitName("player"))` works in principle ([SendChatMessage](https://wowwiki-archive.fandom.com/wiki/API_SendChatMessage); community self-whisper threads) but pollutes whisper history, can trip chat filters / WIM, and looks like social traffic on stream. Treat whisper-self as **opt-in power-user**, not default.

5. **Sound once, on SFX, behind mute + cooldown.** One short cue when the queue becomes non-empty; never on every suggestion, never on Master by default, never during combat if the player opted into “quiet in combat” ([20 — accessibility & spam](../20-sound-sfx-feedback/03-accessibility-and-spam.md)). Soft UI kit ≫ Raid Warning ding.

6. **Cousin tools open UI; they do not strobe.** RCLootCouncil’s value prop is an automatic council/loot *frame* when a session matters ([RCLootCouncil](https://rclootcouncil.com/), [Classic CurseForge](https://www.curseforge.com/wow/addons/rclootcouncil-classic)) — awareness comes from the frame appearing, not a RAID_WARNING loop. Beef should match: optional center caution + flash + one sound, then rely on Officer tab / minimap badge.

## Boundary with sibling tracks

| This track (49) | Sibling |
|-----------------|---------|
| *How* officers notice pending work | [16](../16-guild-roster-officer-edges/) — *who* may act |
| Attention channels & anti-spam | [40](../40-officer-moderation-audit/) — what happens after they open the queue |
| Local officer ping vs guild spectacle | [32](../32-microcopy-tone-voice/) — announce/toast *words* |
| One sound policy | [20](../20-sound-sfx-feedback/) — kit/channel/mute |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer warcraft.wiki.gg / wowwiki-archive / WoWInterface primary threads over listicles.
