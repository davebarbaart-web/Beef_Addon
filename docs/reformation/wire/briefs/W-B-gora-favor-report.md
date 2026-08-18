# W-B — Gora favor tally + FreeRuling

**Status:** DONE

**Cited:** CONTINUE 2026-08-18 licenses 2–3; Bible §10.6; `.cursor/rules/gora-sanction.mdc`; brief `docs/reformation/wire/briefs/W-B-gora-favor.md`.

Favor is one standing pick per member, latest replaces earlier, memory only. Free ruling writes no win/loss. Store / Codec / Net / UI / TOC / bootstrap / `tests/run.lua` / OPEN_QUESTIONS / REFORMATION_LOG not edited. No commit.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_gora.lua` | TDD first. Removed leftover `Gora.Favor == nil`. Favor + FreeRuling contract tests. Isolation stays under `if standalone then`. |
| `addon/ChurchOfBeef/Core/Gora.lua` | `RecordFavor` / `GetFavor` / `GetFavorSplit`. `writeBoth` treats `free` like void (no `won`). `FreeRuling` calls Store without `won` and `AppendCeremony("free", { a, b }, now, line)`. |
| `docs/reformation/wire/briefs/W-B-gora-favor-report.md` | This file |

## API

| Method | Role |
|--------|------|
| `RecordFavor(characterId, pickId)` | Requires a live sanctioned pair. `pickId` must be fighterA or fighterB. Latest pick replaces earlier. Store integers ≥ 1. |
| `GetFavor()` | Copy of memberId → pickId, or `{}`. |
| `GetFavorSplit()` | Copy `{ a = n, b = n }` for the live pair. Zeros if none. |
| `Sanction` (success) | Writes the new pair, then clears picks. Failed Sanction does not clear. |
| `FreeRuling(text?)` | Both characters: `ruling = "free"`, no `won`. Optional trimmed `text` on both Store rows. Then `AppendCeremony`. `clearLive` as before. Returns `{ ruling = "free", text = line }`. |
| `_Expire` / `ResetForTests` | Event end and harness reset clear picks. Out-of-harness Reset still refuses and does not wipe. |

Verdicts (`DeclareVictor` / `CowardiceRecorded` / `Void` / `FreeRuling`) leave the tally; the next successful Sanction clears. Getters return copies. No `Gora.Favor` product table, no history, no SV write, no ELO, no HUD.

## Verification

- Isolated (`lua tests/test_gora.lua`): **394 passed, 0 failed**. Lua 5.1. Exit 0.
- Isolated Store (`lua tests/test_store.lua`): **330 passed, 0 failed**. W-C had already landed; `RecordGoraResult` accepts `ruling = "free"` with no `won` and stores optional `text`. `AppendCeremony` accepts the 4th arg. No Gora+Store `won` mismatch.
- Full harness (`lua tests/run.lua`): **6134 passed, 2 failed**. Failures are `test_ceremony_chaos` (parallel lane), not Gora or Store. An earlier full run in this session failed `test_net_codec` (W-A) the same way — not this lane.
- Gora verbs still do not `CreateFrame`, `SendChatMessage`, or `SendAddonMessage`, and do not write `ChurchOfBeefDB`. Favor is a file-local map.

## Self-review

- Names are the brief’s: `RecordFavor`, `GetFavor`, `GetFavorSplit`. No public Favor economy object.
- `writeBoth` omits `won` for `void` and `free`. Non-empty trimmed `text` is set on both field tables.
- `FreeRuling` still requires a sanctioned pair; non-string `text` errors before Store; whitespace-only becomes `nil`.
- Ceremony append happens only after both Store writes succeed. Existing 3-arg `AppendCeremony` callers were not touched (this lane does not edit Store).
- Isolation asserts remain behind `if standalone then`.

## Concerns

- Congregation INPUT / STATE / HUD / Console favor pane are later lanes (W-D, W-E, W-F). This lane only tallies in Core memory.
- After a verdict the split reads `{ a = 0, b = 0 }` because there is no live pair; `GetFavor` may still hold leftover picks until the next Sanction or event expire. Intentional per the brief.
- Full harness is still red on parallel Wire lanes. Do not treat that as a W-B miss.
- Do not claim V1 / MVP complete. Client smoke and a human Gathering (Bible §22.3) were not run.
