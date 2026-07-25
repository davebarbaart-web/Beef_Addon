# Policy options & tradeoffs (§16.5)

**Track:** 67  
**Decision frame:** Spec already allows “online officers only” for V1 and invites extending login sync if officers complain ([§16.5](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). This note compares concrete policies without re-deriving BeefNet budgets ([14](../14-addon-messaging-beefnet/)) or revision theory ([27](../27-desync-conflict-resolution/)).

## Shared constraints (all options)

| Constraint | Implication |
|------------|-------------|
| No server; GUILD addon messages reach **online** listeners only | Something must persist or the petition dies with the night |
| Per-character SV ([§9](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) | Officer main ≠ officer alt unless later sync + same guild toon online |
| Suggestions are advisory; commits are law ([§6.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) | Missing a petition ≠ missing a promotion forever |
| CTL / login storms ([47](../47-login-storms-guild-scale/)) | Do not dump full petition histories on every login |
| Officer alerts ([49](../49-officer-notifications/)) | Catch-up must be silent; toast on 0→≥1 live edge only |

## Option A — Ephemeral live only (no SV pending)

Emit `SUGGESTION`; if no Officer+ online, discard.

| Pros | Cons |
|------|------|
| Zero sync complexity | Violates spec §9 (“stores … pending suggestions”) |
| No stale petitions | Members grind thresholds while officers asleep → silent loss |
| | Empty-state “petitions wait” becomes a lie |

**Verdict:** Reject. Spec already commits to local pending storage.

## Option B — Local persist + live fanout only (no shared store)

**Member** keeps pending in SV. **Online Officer+** who hear `SUGGESTION` keep a local queue. Offline officers see nothing until a later live re-emit or human Discord process. Soft-expire stale rows. Ladder still heals via §8.3.

| Pros | Cons |
|------|------|
| Matches §16.5 V1 sketch + [14 mapping](../14-addon-messaging-beefnet/beefnet-mapping.md) | Officers who missed guild night lack shared inbox |
| Aligns with Attune blanks + RCL “be present” culture | Alt officers on different toons miss main’s queue ([25](../25-multi-toon-realm-edges/alts-and-account-scope.md)) |
| No extra `SYNC_STATE` payload / reject races | Transparency among officers weaker until reject audit sync ([40](../40-officer-moderation-audit/)) |
| On-duty officer ([51](../51-guild-night-playbook/)) covers comedy nights | |

**Traffic:** Existing rate-limited `SUGGESTION` only — tens/night at guild scale, not sync chunks ([47](../47-login-storms-guild-scale/guild-scale-event-load.md)).

**Verdict:** **Recommended V1.**

## Option C — Member rebroadcast on officer HELLO / login

When an Officer+ settles login, members (or the suggester) re-emit still-pending `SUGGESTION`s.

| Pros | Cons |
|------|------|
| No new message type | Login storm amplifier: `W` members × pending rows |
| Offline officers eventually see petitions | Duplicate toasts unless carefully coalesced ([49](../49-officer-notifications/)) |
| | Easy to DOS CTL during raid login wave |

**Verdict:** Avoid as default. If ever used, officer-initiated pull + hard caps — not member push-on-HELLO.

## Option D — Extend login sync: grow-only suggestion store

Peers (prefer Officer+) include pending suggestion records in catch-up: either chunked inside/alongside `SYNC_STATE`, or a dedicated `SUGGESTION_SYNC` answered on officer `SYNC_REQUEST`. Merge = **union by suggestionId**; clear on `RANK_COMMIT` covering the target / explicit reject tombstone; never overwrite ladder with petitions.

| Pros | Cons |
|------|------|
| Fixes §16.5 officer complaints | Protocol + merge + tombstone design (reject races) |
| Matches [27](../27-desync-conflict-resolution/) “grow-only queue later” | Traffic: small but multiplies login sync work |
| Officer transparency improves | Risk of resurrecting stale / already-handled petitions without tombstones |
| | Still per-character until account-scope exists |

**Traffic estimate (V1.1 ballpark):**

| Scenario | Frames (order of magnitude) |
|----------|-----------------------------|
| Quiet night, 0–5 pending | 0–1 BULK chunk (~≤255 B each) |
| Busy night, ~20 pending × ~120 B packed | ~2–4 BULK chunks, officer-prefer responder, suppress peers |
| Cold officer + full week backlog uncapped | Bad — need cap (e.g. last 50 or 14 days) |

Compare: full ladder cold sync already uses chunked `SYNC_STATE` ([14](../14-addon-messaging-beefnet/beefnet-mapping.md)). Suggestion catch-up should stay **smaller** and **officer-gated** (members need not receive the queue).

**Verdict:** **V1.1 behind a feature flag** — ship when playtest shows missed petitions hurt more than protocol cost.

## Option E — Blizzard officer notes / Discord as the store

Encode pending in notes, or require Discord #promotions for missed nights.

| Pros | Cons |
|------|------|
| Notes: “hosted” like CEPGP | Note size/privacy fights; wrong UX for evidence rows |
| Discord: already guild habit | Leaves in-addon Officer tab empty; splits source of truth |
| | Spec V1 is peer SV + BeefNet, not notes |

**Verdict:** Discord is a **social fallback** in the playbook (“officer of the night posts pending”), not the V1 data plane. Notes are out for Beef petitions.

## Comparison matrix

| Option | Persists local? | Offline officer sees queue? | Extra BeefNet? | V1 fit |
|--------|-----------------|-----------------------------|----------------|--------|
| A Ephemeral | No | No | No | No |
| **B Local + live** | **Yes** | **No** | **No** | **Yes** |
| C Rebroadcast | Yes | Eventually | High risk | No default |
| D Grow-only sync | Yes | Yes (with peers) | Moderate | V1.1 flag |
| E Notes/Discord | External | Maybe | N/A | Social only |

## Soft-expiry rules (pair with B or D)

Any persist option needs death conditions so SV does not become a museum of dead petitions:

| Clear when | Why |
|------------|-----|
| Officer Reject (local, and tombstone if D) | Spec §7.3 |
| Matching `RANK_COMMIT` already ≥ suggested rank | Promotion happened elsewhere |
| Age > **14 days** (tunable) | CEPGP-style claim expiry culture |
| Member left guild / rename unresolved | Identity hygiene ([25](../25-multi-toon-realm-edges/)) |
| Optional: standing no longer meets threshold | Avoid approving stale testimony |

**Do not hard-delete** solely because all officers were offline at fire time — that is Option A’s bug.

## Re-petition (pairs with B)

If a suggestion expired or no officer ever saw it, allow the member client to emit again after a **cooldown** (e.g. once per day per rank step) while still eligible — not on every login. Keeps Option B humane without Option C storms.
