# Annotated URLs — login storms & guild-scale load

Primary sources for track 47. Prefer these when deciding **herd behavior**, **retry/jitter**, and **guild-size load**. For prefix/CTL/API limits see [track 14 annotated-urls](../14-addon-messaging-beefnet/annotated-urls.md) (do not duplicate that table here).

## Thundering herd, backoff, jitter, coalescing

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter | Canonical full / equal / decorrelated jitter; why unjittered exponential still clumps — map to `SYNC_REQUEST` retries. |
| https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter | Timeouts, cautious retries, jitter on **periodic** work (login settle timers), retry amplification risk. |
| https://builder.aws.com/content/3EumjoZascWd1oZiEgL8ORlv3qE/timeouts-retries-and-backoff-with-jitter | Alternate host for Builders’ Library article (same substance). |
| https://github.com/awslabs/aws-arch-backoff-simulator | Simulator behind the AWS jitter graphs — useful if someone wants to re-run intuition, not ship in addon. |
| https://dev.to/thdr/the-thundering-herd-problem-and-how-to-actually-fix-it-14aa | Plain-language herd vs normal spike; “decouple trigger from reaction.” |
| https://aryandhirhi.hashnode.dev/the-thundering-herd-problem | Singleflight / serve-stale / jittered expiry framing → coalesce + SV stale-while-revalidate. |
| https://platformwale.blog/2026/04/30/resilience-patterns-at-scale-exponential-backoff-jitter-retry-budgets-and-circuit-breakers-in-practice | Retry **budgets** (cap amplification) — adapt as max auto `SYNC_REQUEST` attempts. |
| https://medium.com/@avnein4988/mitigating-the-thundering-herd-problem-exponential-backoff-with-jitter-b507cdf90d62 | Short secondary explainer on jittered backoff. |

## Classic / WoW bus behavior under load

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054 | Silent drops despite CTL/AceComm; “send less data”; intermittent realm throttling — storms make this worse. |
| https://us.forums.blizzard.com/en/wow/t/classic-changes-to-cchatinfosendaddonmessage/544278 | Burst GUILD loops only partially delivered (cited in track 14; keep as storm evidence). |
| https://stackoverflow.com/questions/62723031/wow-classic-api-event-for-addon-messages | Cold-login send failures — correlated with mass login after downtime. |
| https://warcraft.wiki.gg/wiki/ChatThrottleLib | Post-login/zone rate clamp — every herded client shares this hostile window. |
| https://wowpedia.fandom.com/wiki/ChatThrottleLib | Mirror of CTL notes. |

## Addon precedents (sync pacing / scale)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://github.com/evil-morfar/RCLootCouncil2/wiki/Synchronizer | Consent + 1:1 sync; AceComm + CTL low priority; ~4 kB/s shared; minutes OK — anti-pattern for default GUILD dumps. |
| https://rclootcouncil.com/ | Project home / context for RCL sync philosophy. |
| https://www.curseforge.com/wow/addons/guild-roster-manager/files/2874277 | GRM Classic: disconnects when sync + grouped; shared global throttle; throttle harder in raid/combat. |
| https://www.curseforge.com/wow/addons/guild-roster-manager/files/2826271 | GRM: throttle retroactive sync when grouped; live small updates allowed. |
| https://legacy-wow.com/classic-addons/cepgp | CEPGP avoids GUILD addon storms for standings via officer notes — architectural foil, not Beef V1 path. |

## Guild size / roster scale context

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://us.forums.blizzard.com/en/wow/t/max-guild-size-in-classic/263039 | Soft ~500 UI visibility vs later hard caps; frames 500 as design ceiling. |
| https://us.forums.blizzard.com/en/wow/t/guild-member-cap/95422 | Pre-launch speculation + Cata-era soft-cap quotes. |
| https://www.reddit.com/r/classicwow/comments/apj65w/guild_member_cap/ | Community memory: soft cap ~500. |
| https://www.engadget.com/2010/10/08/cataclysm-guild-cap-revised-now-1-000-members/ | Historical soft 500 / hard-cap debate (linked from Classic forums). |
| https://eu.forums.blizzard.com/en/wow/t/guild-member-limit/474893 | Modern 1000-cap complaints — reminder retail ≠ Anniversary design band. |

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §8.2–§8.3, §11 | Login sync, random delay + suppression, traffic stance, offline/roster edges. |
| [`../14-addon-messaging-beefnet/`](../14-addon-messaging-beefnet/) | Transport budgets and anti-spam matrix. |
| [`../27-desync-conflict-resolution/`](../27-desync-conflict-resolution/) | Merge/authority — not load, but heal correctness. |

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-login-storms.json`](.raw/search-login-storms.json) | Parallel search: Classic SendAddonMessage storms, CTL, RCL, herd/jitter |
| [`.raw/search-backoff-coalescing.json`](.raw/search-backoff-coalescing.json) | Parallel search: AWS jitter, retry budgets, gossip/coalescing |
| [`.raw/search-guild-scale-events.json`](.raw/search-guild-scale-events.json) | Parallel search: guild caps, GRM sync, RCL, CEPGP |
| [`.raw/extract-sync-backoff.json`](.raw/extract-sync-backoff.json) | Extracts: RCL Synchronizer, AWS backoff+jitter, Builders’ Library retries |
