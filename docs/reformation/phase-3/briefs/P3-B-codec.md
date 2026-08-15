# Phase 3 Lane B — BeefNet v2 codecs (encode/decode only)

Read: Ten Laws 5, 6; Bible §13.1, §13.4, §20.2–20.3; `.cursor/rules/ceremony-runtime.mdc` (Broadcast and catch-up).

## Exclusive files

- `addon/ChurchOfBeef/Net/Codec.lua` (create)
- `tests/test_net_codec.lua` (create)
- Report: `docs/reformation/phase-3/reports/P3-B-codec.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, `Net/BeefNet.lua` (transport stays HELLO until later lanes), Runtime, Store, UI.

## Mission

Test-first. Isolated suite: Common + Codec (and Ranks if needed). **Encode/decode only.** Do not `SendAddonMessage`. Do not invent a kitchen-sink opcode list.

Closed kind families from the runtime rule (these are the wire TYPEs — do not add others):

| TYPE | Bible kind | Payload (Bible-named fields only) |
|------|------------|-----------------------------------|
| `STATE` | State broadcast | protocol version, event id, state, rite type, subjects, sequence |
| `SNAPSHOT` | Snapshot request / response | protocol version, role `request` or `response`; response carries the same fields as STATE (do **not** invent extra snapshot schema) |
| `INPUT` | Congregation input | protocol version, kind `petition` / `favor` / `confession`, character id; confession may carry text. Inputs never encode theater. |

Fail closed: unknown TYPE, missing protocol version, bad role/kind, Grant/standing/points keys, free-text rite kinds.

Keep HELLO out of this module (BeefNet already has it). Do not restore SUGGESTION / SYNC_* / RANK_COMMIT.

Do not invent: registered-Pope file (#8), whisper routing, Director Console, hold timers, SUMMON protocol.

## Do not git commit.
