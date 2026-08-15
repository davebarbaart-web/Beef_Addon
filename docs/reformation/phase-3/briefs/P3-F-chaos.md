# Phase 3 Lane F — Ceremony chaos tests (quality bar)

Read: Ten Laws 4, 5, 6; Bible §20.3, §20.4, §13.1, §13.4; `.cursor/rules/ceremony-runtime.mdc` (Chaos test; Disconnect). Lanes A–E are signed.

## Exclusive files

- `tests/test_ceremony_chaos.lua` (create)
- Report: `docs/reformation/phase-3/reports/P3-F-chaos.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, BeefNet, Codec, Runtime, Snapshot, Sender, Store, UI, or any signed production file. **Do not** create `Data/Popes.lua`.

## Mission

Test-first. Isolated suite: Common + Runtime + Codec + Snapshot + Sender. Compose the signed APIs. Do not add new verbs, TYPEs, snapshot fields, holdSeconds, or a Pope list.

§20.4: the runtime must survive, on stream: late arrival, reload, disconnect (including the Pope's), no-show petitioner, disputed outcome. A confused client is acceptable for five seconds and embarrassing for thirty. That is the **quality bar** — not a timeout constant to code. Handoff also names spoofed senders, replayed sequences, floods, mid-rite reloads, version skew.

Drive these through the signed surface:

- **Late arrival** — Pope Runtime is in Event Mode; `Request()` does not change it; `BuildResponse()` then `ResetForTests` + `ApplyResponse` lands the cold client on the current Bible fields. QUIET has nothing to catch up to.
- **Reload / mid-rite reload** — `BuildResponse` / `ApplyResponse` (or Runtime Snapshot / Restore) resumes the same event id, state, rite, subjects, sequence. `awaitingPope` round-trips on Runtime Restore when set; Lane C strips it from the wire.
- **Pope disconnect** — `MarkPopeLost` holds last state; not a sixth state; no self-promotion API; `ClearPopeLost` is not a transition. `EndEvent` is still a Pope verb, not automatic.
- **No-show petitioner** — `Accept(sender, "INPUT")` may be true; Runtime does not auto-advance, auto-open, or auto-end.
- **Disputed outcome** — no auto-declare / Narrate / Grant. CloseRite / Continue / EndEvent stay explicit.
- **Spoofed senders** — `IsRegisteredPope` is always false; `Accept` is false for STATE / SNAPSHOT / theater. Do not invent a list to make one true.
- **Version skew** — `ApplyResponse` of a foreign-major SNAPSHOT fails closed; Runtime unchanged. Do not paint a second Quiet notice.
- **Floods** — many INPUT Accepts do not change Runtime and do not encode theater. SUGGESTION / SYNC_* / HELLO do not Apply.
- **Replayed sequences** — assert what the signed APIs actually do. Do **not** invent a monotonic-sequence gate if Restore/Apply does not have one. Name that leftover.

Do not `SendAddonMessage`. Do not invent whisper routing. Do not load BeefNet (HELLO adversarial stays in `test_net_adversarial.lua`). Wrap “other modules are nil” asserts in `if standalone then` so the full harness can list this suite later.

## Do not git commit.
