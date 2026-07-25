# Chat filters vs guild-announce spectacle

**Track:** [61-streamer-mode-privacy](README.md)  
**Last updated:** 2026-07-25  

V1 spectacle is one throttled guild-chat line from the approving officer (spec §10), e.g. “The Church recognizes Beefina, elevated to Beef Knight.” Success criterion §13.11 requires a **visible guild-chat reaction**. This note covers client filters that can hide, garble, or mute that line for some viewers — including the streamer’s capture.

---

## Filter stack (what can touch a Beef announce)

| Layer | Mechanism | Typical effect on `/g` announce |
|-------|-----------|----------------------------------|
| Mature language | CVar `profanityFilter` (default **1**, account scope) ([Wowpedia CVars](https://wowpedia.fandom.com/wiki/Console_variables); [AIO cvars.lua](https://github.com/Stanzilla/AdvancedInterfaceOptions/blob/master/cvars.lua); [WoWI profanity thread](https://wowinterface.com/forums/showthread.php?t=53263)) | Asterisks / strips substrings that match Blizzard’s mature list — liturgy and comedy titles are **not** exempt |
| Spam filter | CVar `spamFilter` (Social option tooltip in AIO) | Heuristic mute of spammy chat; guild is usually safer than trade, but odd repeated announce patterns are a risk if officers spam |
| Ignore list | Blizzard Ignore (cap **50**) ([Ignore](https://wowpedia.fandom.com/wiki/Ignore)) | **Suppresses guild chat** from ignored characters — if a member ignored the approving officer, they see **no** promotion line |
| Addon spam filters | BadBoy, Global Ignore List, Chat Filter, etc. ([GIL](https://www.curseforge.com/wow/addons/global-ignore-list); Classic forum culture [chat filters thread](https://us.forums.blizzard.com/en/wow/t/chat-filters-unlimited-ignore-lists/261792)) | Often **exempt** guild / party / friends by default — still a footgun if “filter everything” profiles are used |
| Local name obfuscators | StreamerMode-class addons ([name-hiding-ecosystem.md](name-hiding-ecosystem.md)) | Rewrite **display** of names in chat for that client only; payload elsewhere unchanged |
| Chat bubbles | `chatBubbles` | Guild announces land in the chat frame, not world bubbles — low direct impact |

---

## Failure modes for §13.11 “visible reaction”

| Failure | Looks like | Root cause | Beef response |
|---------|------------|------------|---------------|
| Officer announce fired; half the raid shrugs | “Nobody saw it” | Recipients ignored the officer; or chat tab not showing Guild | Ops: confirm Guild tab visible; don’t treat as BeefNet desync |
| Stream chat shows `B****ina` / broken title | Liturgy looks broken on Twitch | `profanityFilter` on streamer’s account | Ceremony checklist: disable mature filter for broadcast night; smoke-test announce strings |
| Streamer sees “Warrior” / masked name; guild sees real name | Split reality | Local StreamerMode rewrite | Expected; document for streamer guilds |
| Announce never appears for one client | Silent | Per-officer opt-out (spec §10) or announce not sent | Product; not a filter |
| Third-party filter ate the line | Silent or “filtered” toast from GIL | Keyword filter matched “elevated” / church words / links | Recommend GIL “never filter guild”; avoid URL-like tokens in V1 announces |

---

## Profanity filter — design implications

1. **Default is on.** New accounts and many streamers leave mature language filtering enabled.
2. **Filter is display-side.** The server still delivers the string; other clients with filter off see full text.
3. **Smoke-test the canon strings** before locking microcopy (track 32 owns wording; this track owns the risk):
   - Rank titles (Fresh Meat → Prophet of Beef, etc.)
   - Promotion / demotion templates
   - Toast short lines that may also hit chat if officers paste them
4. **Do not build a “bypass filter” hack.** That fights Blizzard Social options and parental expectations. Prefer clean copy + optional officer note in `/beef help`: “For ceremony streams, turn off Mature Language Filter under Interface → Social.”

---

## Ignore list — officer spectacle edge case

From [Ignore](https://wowpedia.fandom.com/wiki/Ignore):

- Suppresses say/yell **and** trade/guild/party channels from the ignored character
- Cap 50 names (3.3.0+); alts are separate names
- Whisper from ignored player is blocked; ignored player is notified on whisper attempt

**Beef-specific:** Promotion announce is sent by the **approving officer’s client**. Drama between member and officer → ignore → that member never sees the public spectacle. Officer tab / toast on the promotee’s own client (if online with addon) still works — so V1 should not rely on guild chat alone for the **promotee’s** awareness (toasts cover that; track 49 is officer-side).

---

## Spam filters and announce cadence

Spec already throttles to **one line per promotion**, officer-only, with per-officer opt-out. That is the right shape for `spamFilter` / BadBoy culture:

| Practice | Why |
|----------|-----|
| One line, no raid icons spam | Chat Filter–style addons strip raid markers; Beef shouldn’t use them in announces anyway |
| No repeated identical lines | Duplicate filters ([WoWI Chat Filter](https://www.wowinterface.com/downloads/info19125-ChatFilter.html) pattern) |
| No gold-seller-shaped punctuation | Keyword thresholds in spam addons |
| Prefer plain text over item/spell links | Fewer false positives |

---

## Whisper-self and filters (cross-link)

Track 49 already rejects whisper-self as default officer ping partly because it looks like social traffic on stream and trips whisper UIs. Same privacy lens: **guild announce is the public spectacle; local `print` / toast is the private breadcrumb.** Do not route promotion awareness through whisper just to “feel quieter” on stream — it still leaks names into whisper history if the streamer shows whispers.
