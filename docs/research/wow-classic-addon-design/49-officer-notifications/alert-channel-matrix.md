# Alert channel matrix — Classic officer attention

**Last updated:** 2026-07-25  
**Track:** [49-officer-notifications](README.md)

How Classic addons grab an officer’s attention, ranked for Beef’s “pending suggestion” use case. Channels are **combinable**; spam risk comes from firing all of them on every packet.

---

## 1. Matrix

| Channel | Typical API | Who sees it | Survives alt-tab? | Chat log? | Spam risk | Beef default? |
|---------|-------------|-------------|-------------------|-----------|-----------|---------------|
| Center caution (RW *style*) | `RaidNotice_AddMessage(RaidWarningFrame, text, ChatTypeInfo["RAID_WARNING"])` | Local client only | No (need focus) | No | Medium if every event | **Yes — coalesced** |
| OS icon flash | `FlashClientIcon([briefly])` | OS taskbar / dock | **Yes** | No | Low if once | **Yes — coalesced** |
| Local chat print | `print(...)` or `DEFAULT_CHAT_FRAME:AddMessage(...)` | Chat frames that show system/addon lines | No | **Yes** | Low–medium | **Yes — coalesced + soft updates** |
| Whisper self | `SendChatMessage(msg, "WHISPER", nil, UnitName("player"))` | Whisper UI + filters | No | **Yes (whisper)** | High socially | **Opt-in only** |
| Sound once | `PlaySound(kit [, "SFX"])` | Ears / stream VODs | Yes (audio) | No | High if Raid Warning / Master / repeat | **Optional, soft kit** |
| True raid warning chat | `SendChatMessage(..., "RAID_WARNING")` | Entire raid/party (RL/assist rules) | — | Yes | **Forbidden** for Beef queue | **Never** |
| Combat text / UIErrors | `UIErrorsFrame` / floating combat text | Local | No | No | Medium (looks like error) | Avoid for queue |

---

## 2. Channel notes

### 2.1 RAID_WARNING-*style* caution (local RaidNotice)

Documented community pattern for “big letters only I can see” ([WoWInterface — Outputing a personal raid warning](https://www.wowinterface.com/forums/showthread.php?t=36250)):

```lua
RaidNotice_AddMessage(RaidWarningFrame, "text", ChatTypeInfo["RAID_WARNING"])
-- sound is a separate choice; do not assume the frame plays it
```

Also used as an alternate sink for error-style messages alongside `RaidBossEmoteFrame` ([WoWInterface — error messages into chat frame](https://www.wowinterface.com/forums/showthread.php?t=43198)).

**Important split:**

| Approach | Meaning |
|----------|---------|
| `RaidNotice_AddMessage` on `RaidWarningFrame` | Local UI chrome — **correct** for officer caution |
| `SendChatMessage(msg, "RAID_WARNING")` | Real raid/party broadcast; RL/assist-gated historically ([SendChatMessage details](https://wowwiki-archive.fandom.com/wiki/API_SendChatMessage)) — **wrong** for Beef queue |

Copy for the caution line should stay sober officer register (track [32](../32-microcopy-tone-voice/)): e.g. `Church of Beef: 1 pending approval` — not liturgical comedy mid-raid.

### 2.2 FlashClientIcon

[`FlashClientIcon([briefly])`](https://warcraft.wiki.gg/wiki/API_FlashClientIcon) — flashes the game client icon in the OS. Wiki patch notes: added **6.2.0 / Classic 1.13.2**; `briefly` argument added Retail 11.1.5 (do not assume `briefly` on Anniversary without a live check — call with zero args for Classic-safe use).

Community pattern: pair with a sound when something needs attention while alt-tabbed (loot-reminder style snippets on Blizzard UI forums use `FlashClientIcon()` + `PlaySound(8959, "master")` — that *pairing* is the combat-alert cliché Beef should not copy wholesale).

Players who disable flash globally NOP the function; Beef should still gate behind its own pref so we do not fight a NOP’d global with retries.

### 2.3 Print / AddMessage

[`print(...)`](https://wowwiki-archive.fandom.com/wiki/API_print) routes through the current print handler; default is the default chat frame. Safer than raw `AddMessage` for nils. Colored prefix is fine (`|cff…|r`).

Use for:

- Coalesced “queue became non-empty” line  
- Soft updates: `Church of Beef: 3 pending approvals` (overwrite mental model, not a new flash)  
- Debug/officer diagnostics (not the same channel as guild spectacle)

`ChatFrameN:AddMessage` can target a specific tab ([WoWInterface — AddMessage](https://www.wowinterface.com/forums/showthread.php?t=34379)); V1 can stay on `print` unless officers demand a dedicated tab.

### 2.4 Whisper self

[`SendChatMessage`](https://wowwiki-archive.fandom.com/wiki/API_SendChatMessage): for `"WHISPER"`, language may be nil, target is player name (`UnitName("player")` / realm-qualified as required by client). Community threads confirm self-whisper is a supported pattern when the name is correct ([MMO-Champion self-whisper help](https://www.mmo-champion.com/threads/1251787-SendChatMessage-and-SetRaidTarget-help)).

**Costs:**

- Appears in whisper history and many chat addons’ whisper panes  
- Can look like “someone whispered me” on stream overlays  
- Competes with real officer whispers during raid nights  
- 255-character cap — irrelevant for short queue lines, still a hard limit  

**When it helps:** officers who filter whispers aggressively and want a persistent unread breadcrumb after the RaidNotice fades. Keep **off by default**.

### 2.5 Sound once

See track [20](../20-sound-sfx-feedback/) for full policy. Officer-queue implications:

| Choice | Verdict |
|--------|---------|
| `PlaySound(SOUNDKIT.RAID_WARNING)` / 8959 on Master | **No** as default — combat cliché + stream bleed |
| Soft UI kit on `"SFX"`, `forceNoDuplicates` default | Acceptable opt-in / mild default |
| Silent (visual + flash only) | Safest V1 default |

`PlaySound` returns `willPlay`; do not escalate channel when muted ([PlaySound](https://warcraft.wiki.gg/wiki/API_PlaySound)).

---

## 3. Combinations that work

| Intent | Recommended combo |
|--------|-------------------|
| Officer alt-tabbed, queue was empty | Flash + print (+ optional soft sound) |
| Officer in-game, focused | RaidNotice caution + print |
| Officer in combat / boss | Print only (or silent badge); defer RW/sound |
| Queue already had items | Print soft update only — no flash/sound/RW |
| Login / BeefNet sync catch-up | Silent — Officer tab badge only |

---

## 4. What not to invent

- Full-screen flashing textures (photosensitivity — [20/03](../20-sound-sfx-feedback/03-accessibility-and-spam.md))  
- Repeating RaidNotice every few seconds until acknowledged  
- Guild/officer chat spam for *pending* suggestions (spectacle is for **approved** ranks, spec §10)  
- Opening the Officer tab forcibly during combat lockdown edges (see QA track) without a user click  
