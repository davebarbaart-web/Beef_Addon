# Track 14 — Addon messaging, GUILD prefix, CTL, sync budgets

**Track id:** `14-addon-messaging-beefnet`  
**Last updated:** 2026-07-25  
**Sole focus:** Classic-safe addon comms as they constrain Church of Beef **BeefNet** (design spec §8).  
**Out of scope:** UI chrome, Ace options UX, packaging, combat HUD, TOC flavors (tracks 01–12). No addon implementation in this folder.

## Product truth (from V1 spec)

| Locked default | Value |
|----------------|-------|
| Protocol name | BeefNet |
| Prefix | `COB` |
| Channel | `GUILD` |
| Serialization | Small colon-delimited / Ace-style packed strings |
| Authority story | Officer `RANK_COMMIT` + revisioned `SYNC_STATE` merge; no server |
| Traffic stance | Prefer commits + login sync; throttle; avoid chatty `SCORE_EVENT` |

Source: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §8–§9, §11.

## Index

| Note | Covers |
|------|--------|
| [api-prefix-channels-limits.md](api-prefix-channels-limits.md) | `RegisterAddonMessagePrefix`, `SendAddonMessage`, channel matrix, 255-byte payloads, per-prefix allowance |
| [chatthrottlelib-and-budgets.md](chatthrottlelib-and-budgets.md) | ChatThrottleLib priorities, CPS/burst, AceComm vs raw, practical BeefNet budgets |
| [sync-state-and-anti-spam.md](sync-state-and-anti-spam.md) | Revisioned sync, reply-storm suppression, login timing, anti-spam rules mapped to message types |
| [classic-anniversary-realities.md](classic-anniversary-realities.md) | CHANNEL ban, Classic throttle culture, silent drops, Anniversary inheritance, Retail contrasts |
| [beefnet-mapping.md](beefnet-mapping.md) | Explicit type → channel → CTL priority → budget table for BeefNet |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **`GUILD` + prefix `COB` is the correct Classic shape.** Custom `CHANNEL` addon messaging was removed in Classic 1.13.3 to kill invisible cross-world LFG-style sync; `PARTY` / `RAID` / `GUILD` / `WHISPER` remain. BeefNet should never design around custom channels.

2. **Hard envelope: 16-char prefix, 255-char message, ~10 msgs burst / ~1 msg/sec regen per prefix** (documented client defaults; server may retune). Exhausting the allowance returns throttle failure; blasting many prefixes can disconnect. Treat CTL (or AceComm) as mandatory pacing, not polish.

3. **Classic has a second failure mode: silent / intermittent drops** even when the API looks successful and CTL is used — especially for multi-KB dumps (loot-addon war stories after the May 2020 threat-meter clamp). Design for **small, replay-safe, revisioned** packets; never assume a full ladder blast arrives intact.

4. **`SYNC_STATE` is the bandwidth product.** Live `RANK_COMMIT` only reaches online peers. Spec §8.3 (revision numbers, `SYNC_REQUEST` / `SYNC_STATE`, random delay + single-responder suppression) is how guild tools survive Classic throttle culture. Budget sync as **BULK** chunks; treat commits as **NORMAL/ALERT**.

5. **Login is a hostile window.** CTL historically clamps output for ~5s after login/zone; Stack Overflow reports `SendAddonMessage` failing on cold login but succeeding after `/reload`. Delay `SYNC_REQUEST` until after enter-world settle + guild roster readiness; do not fan-out sync in `PLAYER_LOGIN`.

6. **Anti-spam is protocol design, not just CTL.** One officer announces in guild chat; one responder answers sync; `SCORE_EVENT` stays local-first or rare; duplicate revisions are ignored. Players without the addon must not soft-lock — plain guild-chat spectacle covers them.

## Provenance

Search dumps under [`.raw/`](.raw/). Prefer Warcraft Wiki / WowAce / Blizzard forum posts over listicles for technical claims.