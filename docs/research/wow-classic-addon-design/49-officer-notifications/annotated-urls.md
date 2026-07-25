# Annotated URLs — officer notifications

Primary sources for track 49. Prefer these when deciding how officers notice pending suggestions.

## Flash / OS attention

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/API_FlashClientIcon | Canonical `FlashClientIcon([briefly])`; OS icon flash; added 6.2.0 / Classic **1.13.2**; `briefly` is modern Retail — Classic callers should omit until verified. Documents NOP pattern players use to kill flashing. |
| https://wowpedia.fandom.com/wiki/API_FlashClientIcon | Mirror of FlashClientIcon docs if wiki.gg is down. |
| https://us.forums.blizzard.com/en/wow/t/help-with-addon/219481?page=2 | Real addon author pairing `FlashClientIcon()` with `PlaySound(8959, "master")` for a loot reminder — proves the ecosystem combo *and* why Beef should not copy Master + 8959 as default. |

## RAID_WARNING-*style* local caution

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.wowinterface.com/forums/showthread.php?t=36250 | **Personal** raid warning pattern: `RaidNotice_AddMessage(RaidWarningFrame, text, ChatTypeInfo["RAID_WARNING"])`; sound called out as a *separate* step. Steal the local frame, not raid chat. |
| https://www.wowinterface.com/forums/showthread.php?t=43198 | Same `RaidNotice_AddMessage` on `RaidWarningFrame` / `RaidBossEmoteFrame` as alternate message sinks — reinforces FrameXML notice API as local chrome. |
| https://github.com/Ennie/wow-ui-source/blob/master/FrameXML/RaidWarning.lua | FrameXML reference for how raid notices are implemented (duration / stacking behavior archaeology). |
| https://wowwiki-archive.fandom.com/wiki/API_SendChatMessage | Documents real `"RAID_WARNING"` *chat type* (RL/assist history, party abuse note) — contrast with local RaidNotice so implementers do not broadcast. |

## Print / chat frame

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://wowwiki-archive.fandom.com/wiki/API_print | `print` → current print handler; default chat frame; safer than raw AddMessage for nils. Default durable breadcrumb. |
| https://www.wowinterface.com/forums/showthread.php?t=34379 | `DEFAULT_CHAT_FRAME` / `ChatFrameN:AddMessage` targeting — if officers want a dedicated tab later. |
| https://us.forums.blizzard.com/en/wow/t/defaultchatframeaddmessage-and-icons/1187021 | Limits of icons in AddMessage — keep Beef print lines text + color, not raid-marker texture hacks. |

## Whisper self

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://wowwiki-archive.fandom.com/wiki/API_SendChatMessage | `"WHISPER"` requires target name; language nil OK; 255-char cap. |
| https://addonstudio.org/wiki/WoW:API_SendChatMessage | Compact SendChatMessage reference (types include WHISPER). |
| https://www.mmo-champion.com/threads/1251787-SendChatMessage-and-SetRaidTarget-help | Community troubleshooting of whisper-to-self by character name / `UnitName("player")` — confirms pattern and footguns. |

## Sound (officer-adjacent; full policy in track 20)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/API_PlaySound | `willPlay`, channels, `forceNoDuplicates`; SoundKitID era. |
| https://www.wowhead.com/sound=8959/raidwarning | `SOUNDKIT.RAID_WARNING` identity — the ding officers already associate with raid urgency. |
| https://www.wowinterface.com/forums/showthread.php?t=55702 | SOUNDKIT constant discussion / ID browsing culture. |
| [`../20-sound-sfx-feedback/`](../20-sound-sfx-feedback/) | Library track: SFX vs Master, mute, overused kits — do not fork policy here. |

## Cousin UX (awareness via UI, not spam)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://rclootcouncil.com/ | Council awareness model: automatic frames when a session matters. |
| https://www.curseforge.com/wow/addons/rclootcouncil-classic | Classic/TBC-relevant RCL port; guild loot-council cousin. |
| https://github.com/evil-morfar/RCLootCouncil2/wiki | Operator docs — compare “how council notices work” vs Beef inbox. |

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §7.3, §8.1, §10, §16.5 | Pending suggestions, `SUGGESTION`, toasts vs guild announce, offline-officer gap. |
| [`../16-guild-roster-officer-edges/`](../16-guild-roster-officer-edges/) | Who may receive officer alerts. |
| [`../40-officer-moderation-audit/`](../40-officer-moderation-audit/) | What happens after they open the queue. |
| [`../20-sound-sfx-feedback/03-accessibility-and-spam.md`](../20-sound-sfx-feedback/03-accessibility-and-spam.md) | Mute, combat quiet, no strobe. |

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-officer-alerts.json`](.raw/search-officer-alerts.json) | FlashClientIcon, personal RW, PlaySound patterns |
| [`.raw/search-notification-ux.json`](.raw/search-notification-ux.json) | Print/AddMessage, RCL, Flash mirrors |
| [`.raw/search-whisper-print.json`](.raw/search-whisper-print.json) | Whisper-self, print, SendChatMessage |
| [`.raw/search-cousin-alerts.json`](.raw/search-cousin-alerts.json) | RCLootCouncil Classic awareness model |
| [`.raw/extract-flashclienticon.json`](.raw/extract-flashclienticon.json) | Wiki extract: FlashClientIcon |
| [`.raw/extract-playsound.json`](.raw/extract-playsound.json) | Wiki extract: PlaySound |
| [`.raw/extract-sendchat-archive.json`](.raw/extract-sendchat-archive.json) | Archive SendChatMessage |
| [`.raw/extract-print.json`](.raw/extract-print.json) | Archive print API |
| [`.raw/extract-personal-rw.json`](.raw/extract-personal-rw.json) | WoWInterface personal raid warning thread |
