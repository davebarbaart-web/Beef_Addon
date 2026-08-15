# Phase 4 Lane B — BeefNet v2 wire (STATE + SNAPSHOT only)

Read: Ten Laws 5, 6; Bible §13.1, §13.4, §20.2–20.3; `.cursor/rules/ceremony-runtime.mdc` (Broadcast and catch-up). Phase 3 Codec / Snapshot / Sender / Runtime are signed. Gate 3 leftover: BeefNet is HELLO-only.

## Exclusive files

- `addon/ChurchOfBeef/Net/BeefNet.lua`
- `tests/test_net_v2.lua` (create)
- Report: `docs/reformation/phase-4/reports/P4-B-wire.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, `Net/Codec.lua`, `Net/Snapshot.lua`, `Core/Runtime.lua`, `Core/Sender.lua`, UI, DB. **Do not** create `Data/Popes.lua`. Keep `tests/test_net_validate.lua` and `tests/test_net_adversarial.lua` HELLO-green (do not edit them unless a HELLO decode break forces a one-line fix — prefer not).

## Mission

Test-first. Isolated suite: Common + Runtime + Codec + Snapshot + Sender + BeefNet. Wrap “other modules nil” asserts in `if standalone then`.

Put the signed codecs on the **kept** transport. Do not invent opcodes, a fourth TYPE, or an INPUT channel (unspecified — leftover).

- **HELLO** stays the transport presence/version message. Prefix `COB`, channel `GUILD`, throttle, inbound rate limits, `_WarnVersion` stay.
- **Inbound STATE** on **GUILD** only: `Codec:Decode` the payload; `Sender:Accept(sender, "STATE")`; if true, Restore Bible fields only (do not encode `awaitingPope`). Today Accept is always false for STATE — discard; **do not store for later paint**.
- **Inbound SNAPSHOT** on **WHISPER** only (not GUILD fan-out): decode; request vs response via Codec `role`. Response: `Accept(sender, "SNAPSHOT")` then `Snapshot:ApplyResponse` only if Accept. Request: congregation → Pope; do **not** run it through the Pope-sender theater gate the same way; `BuildResponse` only if `IsRegisteredPope` of the local player (always false today — no one else answers). Do not invent a Pope-name lookup.
- **Outbound:** `SendState` / snapshot send only if `IsRegisteredPope` of the local player. Always false today — no send. Do not invent a list to make one true.
- **INPUT:** do not add a live INPUT channel or inbox. If an INPUT payload arrives, do not Restore Runtime and do not paint. Do not invent a console queue.
- Retired `SUGGESTION` / `SYNC_*` / `RANK_COMMIT` stay discarded unread.

Stale clients: incompatible version still `_WarnVersion` and discard (the only Quiet notice). Do not invent a second notice or a toast.

Do not `CreateFrame`. Do not invent Director Console, Gora loop, holdSeconds, peer SYNC, or `#8`.

## Do not git commit.
