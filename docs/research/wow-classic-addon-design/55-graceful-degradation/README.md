# Track 55 — Graceful degradation & missing API resilience

**Track id:** `55-graceful-degradation`  
**Last updated:** 2026-07-25  
**Sole focus:** How Church of Beef stays usable when APIs are missing, prefixes fail to register, flavors diverge, peers are absent, or sync is only partial.  
**Out of scope:** Empty-state UX copy (track [41](../41-empty-states-degraded-ux/)); soft deps / LibStub embeds (track [42](../42-soft-deps-embeds/)); BeefNet budgets & CTL pacing (track [14](../14-addon-messaging-beefnet/)); conflict merge rules (track [27](../27-desync-conflict-resolution/)); feature-flag rollout product policy (track [48](../48-feature-flags-rollout/)). No addon implementation in this folder.

## Product truth (from V1 spec)

| Locked default | Value |
|----------------|-------|
| Target client | TBC Classic Anniversary (`Interface` ~20506 — verify live) |
| BeefNet | Prefix `COB`, channel `GUILD`; best-effort, revisioned |
| Non-addon peers | Invisible to BeefNet; guild play must not soft-lock |
| Authority | Officer+ `RANK_COMMIT` only; roster verify or queue/drop |
| Offline | Login `SYNC_REQUEST` → `SYNC_STATE`; keep cache if silence |
| Media | Missing fonts/textures → default UI; addon still loads |
| Portability | Isolate TOC / instance / messaging APIs (spec §12) |

Sources: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §8.2–§8.3, §10–§13.

## Index

| Note | Covers |
|------|--------|
| [feature-detection.md](feature-detection.md) | Capability probes: globals, `WOW_PROJECT_ID`, prefix registration, roster readiness |
| [pcall-api-guards.md](pcall-api-guards.md) | When to `pcall` / `xpcall`, what never to swallow, optional API seams |
| [flavor-mismatches.md](flavor-mismatches.md) | Wrong client / TOC / Interface; Anniversary-only V1 posture |
| [partial-sync-mode.md](partial-sync-mode.md) | Local-cache-first ladder when peers/net are incomplete |
| [beef-resilience-checklist.md](beef-resilience-checklist.md) | Copy/paste V1 resilience gates for playtests |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Detect capabilities; never assume the full Classic+ surface.** Prefer `type(C_ChatInfo) == "table"` / nil-checks and `WOW_PROJECT_ID` over hard-requiring Retail namespaces. Spec §12 already isolates TOC, instance detection, and messaging — treat those as the degradation seams.

2. **`pcall` is for optional / foreign / load-order risk — not for core ladder authority.** Guard media loads, optional libs, and exploratory API calls. Do **not** wrap `RANK_COMMIT` validation so a failed roster lookup silently “succeeds.” Failed officer verification → queue or drop (spec §11).

3. **Prefix registration failure is a first-class degraded mode.** Recipients only see `CHAT_MSG_ADDON` for registered prefixes ([RegisterAddonMessagePrefix](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.RegisterAddonMessagePrefix); [SO: RAID receive](https://stackoverflow.com/questions/61752395/raid-doesnt-receive-c-chatinfo-sendaddonmessage)). If register returns false, BeefNet is off — UI + local cache + guild-chat spectacle must still work.

4. **Flavor mismatch should fail loud at TOC, soft at runtime.** Anniversary-only `## Interface:` is the V1 preference (track 19). If code ever loads on the wrong project, `WOW_PROJECT_ID` should disable BeefNet / scoring rather than call missing APIs and error-loop.

5. **Partial sync is the default operating mode, not an edge case.** Classic GUILD addon traffic can silently drop while APIs return success ([forum: SendAddonMessage problems](https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054)). Spec §8.3 already designs for this: show cache, merge higher revisions when peers answer, retry later.

6. **Players without the addon are a success path.** Attune’s survey pattern: non-installers simply don’t appear in the mesh; play continues ([attune teardown](../13-cousin-addon-teardowns/attune.md)). Beef’s guild-chat promotion line is the spectacle layer for them (spec §10).

7. **Resilience checklist beats hope.** Use [beef-resilience-checklist.md](beef-resilience-checklist.md) on every alpha: missing media, no guild, empty roster, register fail, zero peers, major version mismatch, wrong folder install.

## Boundary map

| Concern | Lives in |
|---------|----------|
| Capability / API absence / partial mesh | **This track (55)** |
| Empty-state copy & onboarding gates | [41](../41-empty-states-degraded-ux/) |
| Optional Ace/LibStub missing | [42](../42-soft-deps-embeds/) |
| CTL budgets, reply storms, payload size | [14](../14-addon-messaging-beefnet/) |
| Revision merge / officer races | [27](../27-desync-conflict-resolution/) |
| SV wipe / corruption | [21](../21-savedvariables-migration/) |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer design spec + Warcraft Wiki / Wowpedia / Blizzard forum throttle reports over listicles.
