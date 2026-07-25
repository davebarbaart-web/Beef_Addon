# Annotated URLs — BeefNet message catalog & wire format

Primary sources for track 68. Prefer these when debating field budgets, framing, or cousin message shapes. Transport deep-dives remain cited via track 14’s list.

## API envelope (255-byte / prefix)

| URL | Annotation for this track |
|-----|---------------------------|
| https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage | **Hard budget:** ≤255-char message, ≤16-char prefix, per-prefix ~10 burst / ~1 msg/s regen. Grounds every field-budget table in this folder. |
| https://warcraft.wiki.gg/wiki/API_C_ChatInfo.RegisterAddonMessagePrefix | `COB` must register before peers deliver — wire catalog assumes registered receive path. |
| https://warcraft.wiki.gg/wiki/CHAT_MSG_ADDON | Receive tuple: filter `COB` + `GUILD`; sender string feeds Officer+ gate (not a wire field). |
| https://wowpedia.fandom.com/wiki/API_C_ChatInfo.SendAddonMessage | Mirror if wiki.gg unavailable; same envelope claims. |

## Throttle & pacing (anti-storm context)

| URL | Annotation for this track |
|-----|---------------------------|
| https://warcraft.wiki.gg/wiki/ChatThrottleLib | NORMAL vs BULK priorities → map `RANK_COMMIT`/`SYNC_REQUEST` vs `SYNC_STATE` chunks. |
| https://wowpedia.fandom.com/wiki/ChatThrottleLib | Post-login ~1/10 rate window — why HELLO/SYNC wait for settle. |
| https://www.wowace.com/projects/chatthrottlelib | Embed target for paced sends. |
| https://www.wowace.com/projects/ace3/pages/api/ace-comm-3-0 | Optional multi-frame helper; **not** a license for multi-KB logical ladder blobs. |
| https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054 | Silent drops on large GUILD sync → diff+chunk catalog design. |
| https://us.forums.blizzard.com/en/wow/t/classic-changes-to-cchatinfosendaddonmessage/544278 | Burst loops partially deliver → never for-loop `SYNC_STATE`. |
| https://stackoverflow.com/questions/62723031/wow-classic-api-event-for-addon-messages | Cold-login send failures → settle-before-HELLO/SYNC. |

## Classic channel policy

| URL | Annotation for this track |
|-----|---------------------------|
| https://www.wowhead.com/classic/news/wow-classic-patch-1-13-3-lua-api-change-disabling-addons-from-communicating-in-299371 | Custom `CHANNEL` banned — catalog stays on `GUILD`. |
| https://us.forums.blizzard.com/en/wow/t/wow-classic-patch-1133-lua-api-change/384543 | Kaivax social-dynamics rationale — no cross-world invisible mesh types. |

## Cousin protocol docs (message-shape precedents)

| URL | Annotation for this track |
|-----|---------------------------|
| https://github.com/evil-morfar/RCLootCouncil2/wiki/Synchronizer | Consent BULK sync; settings overwrite vs history union — maps to `SYNC_STATE` caution + V1.1 suggestion union. |
| https://github.com/evil-morfar/RCLootCouncil2/wiki | Version checker / commands — `HELLO` cousin. |
| https://www.curseforge.com/wow/addons/rclootcouncil | Session authority culture → `RANK_COMMIT` writer class. |
| https://www.curseforge.com/wow/addons/rclootcouncil-classic | Classic fork existence — same messaging constraints. |
| https://www.curseforge.com/wow/addons/gargul | ML-centric pull-on-join → `SYNC_REQUEST` shape. |
| https://addons.wago.io/addons/gargul | Alternate listing / docs entry. |
| https://www.curseforge.com/wow/addons/attune | Survey fan-in → `SUGGESTION`; offline blanks → V1 petition policy. |
| https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832 | Author framing of guild survey trust model. |
| https://www.wowinterface.com/downloads/info25051-CEPGP.html | Officer-notes DB contrast — why BeefNet needs chunked peer sync. |
| https://www.curseforge.com/wow/addons/guild-roster-manager | Durable vs personal-log sync split; Classic disconnect lore under raid load. |

## Herd / retry theory (numbers live in track 47)

| URL | Annotation for this track |
|-----|---------------------------|
| https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter | Full jitter > aligned retries — informs `SYNC_REQUEST` retry *discipline* (values in 47). |
| https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter | Periodic jobs must not align — anti-pattern for HELLO timers. |

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §8, §11 | Locked type list, trust, reconciliation, mismatch behavior. |
| [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) Task 12 | `VERSION\|TYPE\|fields`, skip on-wire `SCORE_EVENT`, officer gate. |
| [Track 14 README](../14-addon-messaging-beefnet/README.md) | Envelope + CTL + sync anti-spam (do not duplicate). |
| [Track 27 README](../27-desync-conflict-resolution/README.md) | Consistency roles per type. |
| [Track 47 load guidance](../47-login-storms-guild-scale/beefnet-load-guidance.md) | Scale envelopes for SYNC herd. |
| [Track 67 V1 recommendation](../67-offline-officer-suggestion-sync/v1-recommendation.md) | Why petition sync types are reserved, not V1. |

## Sibling annotated lists (overlap intentional)

| Path | Use |
|------|-----|
| [14 annotated-urls](../14-addon-messaging-beefnet/annotated-urls.md) | Fuller messaging/CTL corpus |
| [27 annotated-urls](../27-desync-conflict-resolution/annotated-urls.md) | Conflict-model / Synchronizer depth |
| [47 annotated-urls](../47-login-storms-guild-scale/annotated-urls.md) | Login-storm / backoff sources |
| [67 annotated-urls](../67-offline-officer-suggestion-sync/annotated-urls.md) | Offline inbox policy sources |
