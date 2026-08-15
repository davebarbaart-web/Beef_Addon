# Phase 2 Lane C — Rite of Recognition (Core flow)

Read: Ten Laws 3, 4, 5, 7; Bible §12.2, §12.4; `.cursor/rules/identity-records.mdc` Linking section.

**Do not start until Lane A is signed.** Linking writes through the Pope store.

## Exclusive files

- `addon/ChurchOfBeef/Core/Recognition.lua` (create)
- `tests/test_recognition.lua` (create)
- Report: `docs/reformation/phase-2/reports/P2-C-linking.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, `Core/Store.lua`, UI, Net.

## Mission

Test-first. Core-only Rite of Recognition. **No self-service linking.** No silent same-account bind. No BattleNet auto-link.

Bible §12.2 shape: Pope or Council **confirms** with the **logged-in** character; ~thirty seconds; the alt kneels; is acknowledged; is formally bound to the human. Council may confirm; the **store write remains the Pope store** (Law 5). Do not invent kneel-detection widgets or a Director Console.

Model the rite as a Core session the harness can drive: begin (human id + character id + confirmer role), require a logged-in character id, refuse if already bound to a different human, complete → `Store` link, cancel → no write. Record that a rite occurred on the ceremony log if Store offers append (no generated scripture).

Transfers / faction changes are a **re-link confirmation**, not a new identity (§12.4). Shared accounts: no machinery.

Impersonation is answered by refusing self-service — same APIs, human confirmation only.

Isolated suite: Common + Store + Recognition. Do not `CreateFrame`.

## Do not invent

Registered-Pope list (#8). Kneel slash. UI timer. Congregation theater. Unlink-as-delete (tombstone / inactive only if Store already has it).

## Do not git commit.
