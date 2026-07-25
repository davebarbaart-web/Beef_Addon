# Track 68 — BeefNet message-type catalog & wire format

**Track id:** `68-beefnet-message-catalog`  
**Last updated:** 2026-07-25  
**Sole focus:** Deepen **protocol design** for BeefNet — recommended message types, field layouts, 255-byte frame budgets, versioning, and per-type anti-storm discipline — without re-deriving transport (CTL / prefix), merge theory, login-herd math, or suggestion-offline *policy*.  
**Out of scope:** ChatThrottleLib / token-bucket floors ([14](../14-addon-messaging-beefnet/)); revision/LWW merge predicates ([27](../27-desync-conflict-resolution/)); guild-scale jitter envelopes ([47](../47-login-storms-guild-scale/)); whether offline officers share a petition inbox ([67](../67-offline-officer-suggestion-sync/)). No addon code or commits in this folder.

## Product truth (locked upstream)

| Locked default | Value | Source |
|----------------|-------|--------|
| Protocol name | BeefNet | Spec §8 |
| Prefix / channel | `COB` / `GUILD` | Spec §8.2 |
| Serialization | Small colon-delimited (or Ace-style packed) strings | Spec §8.2; plan Task 12 |
| V1 types | `HELLO`, `SCORE_EVENT` (prefer off-wire), `SUGGESTION`, `RANK_COMMIT`, `SYNC_REQUEST`, `SYNC_STATE` | Spec §8.1 |
| Authority | Officer+ mint `RANK_COMMIT`; peers validate roster | Spec §6.2, §8.2 |
| Heal | Login `SYNC_REQUEST` → revisioned `SYNC_STATE` | Spec §8.3 |
| Hard envelope | ≤255 chars message body; ≤16-char prefix | Track 14 / wiki |

Sources: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §8–§9, §11; plan Task 12.

## Index

| Note | Covers |
|------|--------|
| [message-type-catalog.md](message-type-catalog.md) | Normative V1 catalog + reserved V1.1 types; emit/accept rules |
| [wire-format-and-field-budgets.md](wire-format-and-field-budgets.md) | Frame grammar, field encodings, byte budgets vs 255 |
| [versioning.md](versioning.md) | Major/minor fencing, soft-warn, forward/backward rules |
| [anti-storm-per-type.md](anti-storm-per-type.md) | Per-type storm failure modes (points to 14/47 for mechanisms) |
| [classic-precedent-map.md](classic-precedent-map.md) | Message shapes ↔ RCLC / Gargul / Attune / CEPGP / GRM |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Boundary with sibling tracks

| This track (68) | Elsewhere |
|-----------------|-----------|
| *Which* fields ride on which type; *how* they pack into 255 | [14](../14-addon-messaging-beefnet/) — CTL prio, channels, silent drops |
| Wire identity + type tags as protocol | [27](../27-desync-conflict-resolution/) — *when* a commit applies |
| Per-type storm *discipline* (what not to emit) | [47](../47-login-storms-guild-scale/) — herd jitter / coalesce *numbers* |
| Reserved catch-up types for petitions | [67](../67-offline-officer-suggestion-sync/) — *whether* V1.1 ships them |

## Top insights for Beef (read this first)

1. **Six V1 types; one bandwidth product.** Spec §8.1 lists six names; plan Task 12 correctly skips on-wire `SCORE_EVENT`. Live path is tiny (`HELLO` / `SUGGESTION` / `RANK_COMMIT` / `SYNC_REQUEST`); `SYNC_STATE` is the only multi-frame type and must stay **diff-first, chunked, single-responder**.

2. **Reconcile plan framing with track-14 sketches.** Plan says `VERSION|TYPE|fields…`; track 14 sketched `TYPE:protoMajor:…`. Recommended grammar here: **type-first, then proto major/minor, then fields**, using `:` as the primary separator and forbidding `:` inside field values (encode names via a safe alphabet). One grammar for all types beats dual conventions.

3. **Budget by field, not by hope.** A packed official row is ~45–90 bytes depending on name length and timestamp encoding. One 255-byte frame holds **~2–4** full records after headers — never a 150-seat cold dump. Watermarks and chunk headers are first-class fields, not afterthoughts.

4. **Version on every frame; fence on major.** Soft-warn + drop incompatible commits (spec §11). Minor may add optional trailing fields; major may rename/reorder/repurpose. Do not invent a chatty VERSION_NEGOTIATE handshake for V1 — `HELLO` is enough.

5. **Reserve V1.1 petition types; do not overload `SYNC_STATE`.** Track 67 keeps V1 petitions local+live. If catch-up ships, use dedicated `SUGGESTION_SYNC_REQUEST` / `SUGGESTION_SYNC_STATE` (grow-only union) so official ladder anti-entropy stays small and officer-gated.

6. **Classic cousins already named these roles.** HELLO ≈ RCLC version check; SUGGESTION ≈ Attune survey fan-in; RANK_COMMIT ≈ ML award fact; SYNC_* ≈ Gargul/RCLC pull-on-join — Beef’s catalog should stay that boring.

## Recommended one-liner

**Type-first colon frames ≤255; V1 ships five on-wire types (+ local SCORE_EVENT); SYNC_STATE is chunked diffs; major fences; never storm HELLO or SCORE_EVENT.**

## Provenance

No `.raw/` dumps in this track — synthesis from design spec, plan Task 12, and sibling research (14 / 27 / 47 / 67) plus the annotated primary URLs. Prefer those siblings for transport/merge/herd/policy depth; this folder owns the **catalog and wire grammar**.
