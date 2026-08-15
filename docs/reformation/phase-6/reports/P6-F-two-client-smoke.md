# Phase 6 Lane F — Two-client star smoke

**Status:** DONE (script authored). Walk: **NOT RUN.**

**Cited:** Bible §13.1, §13.4, §20.3, §21.3; Ten Laws 5 and 6; `.cursor/rules/ceremony-runtime.mdc`; honesty pattern in `docs/phases/v1-checklist.md` and `docs/phases/dress-rehearsal.md`. Current wire read from `Net/BeefNet.lua`, `Net/Codec.lua`, `Net/Snapshot.lua`, `Core/Sender.lua`, `UI/Status.lua`.

Writer only. Exclusive files. Addon Lua / TOC / tests / `OPEN_QUESTIONS.md` / `REFORMATION_LOG.md` / other phase docs not edited. No commit. No push. Player `WTF/` not touched.

## Files written

| Path | What changed |
|------|----------------|
| `docs/phases/two-client-smoke.md` | Replaced in place. Standing / SUGGESTION / Officer-queue smoke deleted. Pope-writer + congregation-display walk. All boxes `[ ]`. Status **NOT RUN**. |
| `docs/reformation/phase-6/reports/P6-F-two-client-smoke.md` | This file |

## Mission

Rewrite the two-client smoke against the star, not the deleted ladder. Two characters, same guild, two clients, both running the addon. Client P = Pope writer. Client C = congregation display. After the load half of solo-smoke on at least one character.

## What was cut

- Standing does not synchronise / per-client testimony (decision D1)
- SUGGESTION fan-out, promote toast, Officer queue, claimed-vs-verified standing
- Sender-binding petition about "the character that sent it"
- Law cite to `docs/superpowers/specs/*` and archive
- Pass = "a petition appearing on the officer's queue"

## What the walk is (seven steps, all unchecked)

1. Both load. No script errors. No "syncing" / "synced" standing chip.
2. HELLO version: one `_WarnVersion` chat line; second mismatch stays quiet. Shipped copy quoted from code, not the Bible sentence.
3. Unlisted Pope: `SendState` / `SendSnapshot` refuse `not a registered pope`; inbound theater discarded; C STATE forge does not Restore.
4. David lists P (`Data/Popes.lua` or `ChurchOfBeefDB.ui.popeOverrides` — P6-H parallel). P can `SendState`; C Accepts only that sender; C does not become a writer. No character invented. No predicate stub.
5. SNAPSHOT request is WHISPER to the Pope only. No GUILD fan-out. C does not answer. `Snapshot:Request()` encodes only; no invented `RequestSnapshot` opcode.
6. Retired `SUGGESTION` / `SYNC_REQUEST` / `SYNC_STATE` / `RANK_COMMIT` forged with the old `/run` style, discarded unread.
7. Quiet on C: INPUT is codec-only; no live channel; no feeds/toasts from a forged INPUT body.

## APIs named from the wire (not invented)

| API | Honest behavior written into the smoke |
|-----|----------------------------------------|
| `Net:SendState(fields)` | GUILD send if local `IsRegisteredPope`; else `false, "not a registered pope"` |
| `Net:SendSnapshot(fields, target)` | WHISPER to `target` if local Pope; else the same refuse. Does not look up a Pope name |
| `Net:_WarnVersion(version)` | One chat line per session; `warnedVersion`; shipped sentence quoted |
| `Net:Send` / `Net:Encode` | Raw GUILD enqueue; Encode stamps protocol `1` |
| `Snapshot:Request()` | Encodes `1:SNAPSHOT:request` only |
| `Codec:EncodeState` / `EncodeInput` | Closed fields; INPUT is not routed |

Congregation snapshot request has no public Net sender. The smoke forges `C_ChatInfo.SendAddonMessage("COB", Snapshot:Request(), "WHISPER", <name>)` — same prefix and channel the transport uses.

## What the script refused to invent

| Temptation | Why refused |
|------------|-------------|
| A Pope character name | David adds the name |
| `/run` stub of `IsRegisteredPope` | Codes a fake list |
| `Net:RequestSnapshot` or a new opcode | Not in BeefNet |
| Live INPUT / favor / Confession / SUMMON | Not on the wire |
| Fake Gora pair so HUD paints | Hosted theater leftover; observable is `Runtime:Snapshot()` |
| 40-client rate-limit proof | A03, owner David |
| Tick any box / date a pass | Walk is NOT RUN |
| Cite `docs/superpowers/specs/*` as law | Deleted product |
| Claim V1 / MVP complete | Bible §22.3 is a human Gathering |

## Verification

- Exclusive files only.
- `two-client-smoke.md` has no `[x]` boxes and no dated pass. Status line is **NOT RUN**.
- Pass/fail matches the star (Accept / refuse / whisper / retired discard), not a ladder petition.
- `_WarnVersion` copy matches `Net/BeefNet.lua`.
- Player `WTF/` not touched. No git commit.

## Leftovers (other lanes — not fixed)

- P6-H registered-Pope list must be live before step 4 can pass.
- `solo-smoke.md` and `guild-night-playtest.md` still describe the deleted ladder. Out of lane.
- Hosted Console / HUD / Records, favor, Sound callers, SUMMON, live INPUT remain leftovers.
- A03 40-client scale stays David's sheet.
- Dress rehearsal is a different night.

## Concerns

- `Net:Send` will put congregation STATE and INPUT bytes on GUILD. The smoke says that out loud so "traffic existed" is not read as C becoming a writer.
- `BuildResponse` is `no event` while Runtime is QUIET. Step 5 depends on step 4's STATE echo.
- If P6-H has not landed on the installed client, steps 1–3 and 6–7 are still walkable; step 4 must stay unchecked.

Do not claim V1 / MVP complete. Do not claim `POLISH:PASS`.
