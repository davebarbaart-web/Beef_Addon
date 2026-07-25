# BeefNet message-type catalog (recommended)

**Track:** 68  
**Purpose:** Normative research catalog of V1 (and reserved V1.1) message types — roles, emitters, accept rules, and consistency class. Field packing lives in [wire-format-and-field-budgets.md](wire-format-and-field-budgets.md). Storm knobs live in [anti-storm-per-type.md](anti-storm-per-type.md) + track 47.

## Status legend

| Status | Meaning |
|--------|---------|
| **V1 ship** | On the wire in launch BeefNet |
| **V1 local** | Spec type exists; prefer never broadcast |
| **V1.1 reserved** | Named for future flag; do not overload V1 `SYNC_STATE` |
| **Reject** | Tempting; do not add |

---

## V1 ship catalog

### `HELLO`

| Axis | Recommendation |
|------|----------------|
| Purpose | Capability / protocol version ping; soft-warn peers on major mismatch |
| Direction | GUILD broadcast |
| Who may emit | Any BeefNet client after login settle |
| Who applies | All peers — **no ladder mutate** |
| Consistency role | Version probe (track 27) |
| CTL prio | NORMAL (ALERT only if mid-flight version gate is urgent — usually not) |
| Typical size | Tiny (≤ ~40 chars body) |
| Reliability | Best-effort; absence ≠ “no addon” for co-play scoring (spec §7.1) |

**Emit when:** Once after settle on login/reload; optional rare re-HELLO after long silence *only if* a peer asked (do not periodic-mesh — track 47).  
**Accept:** Parse version; soft-warn UI if major differs; never clobber SV from HELLO alone.

---

### `SUGGESTION`

| Axis | Recommendation |
|------|----------------|
| Purpose | Member petition: “I believe I earned rank X” (advisory) |
| Direction | GUILD broadcast; Officer+ clients enqueue |
| Who may emit | Subject’s client (or allowed manual petition path) |
| Who applies | Officer+ only (members may ignore or keep local pending) |
| Consistency role | Advisory fan-in — **not** official register write |
| CTL prio | NORMAL |
| Typical size | One suggestion record (~80–140 chars) |
| Reliability | Live fanout only in V1 ([67](../67-offline-officer-suggestion-sync/)); offline officers miss it |

**Emit when:** Threshold cross / allowed re-petition (rate-limited).  
**Accept:** Shape + rankId in 1–5 (point-driven) / allowed petition ranks; ignore forged “about other players” from wrong sender (Attune anti-spoof instinct).  
**Do not:** Bundle into `SYNC_STATE` in V1.

---

### `RANK_COMMIT`

| Axis | Recommendation |
|------|----------------|
| Purpose | Officer-minted official snapshot for one player |
| Direction | GUILD broadcast |
| Who may emit | Officer+ only |
| Who applies | All peers after roster Officer+ check + revision predicate |
| Consistency role | Eager replicate of per-player LWW-register |
| CTL prio | NORMAL |
| Typical size | One official record (~50–100 chars + header) |
| Reliability | Replay-safe via revision; login sync heals misses |

**Emit when:** Approve / demote / standing correction / Council / Prophet paths that mint official state. One frame per commit (do not batch unrelated players into one commit type — batching belongs in `SYNC_STATE`).  
**Accept:** Spec §8.2 + §8.3 — Officer+ gate, rankId 1–7, non-negative standing, major compatible, `rev` wins.

---

### `SYNC_REQUEST`

| Axis | Recommendation |
|------|----------------|
| Purpose | Pull-on-join anti-entropy trigger for **official ladder** |
| Direction | GUILD broadcast |
| Who may emit | Any client after settle (login/reload/manual refresh) |
| Who applies | Peers schedule a possible `SYNC_STATE`; requester waits |
| Consistency role | Heal trigger (control) |
| CTL prio | NORMAL |
| Typical size | Tiny + watermark (~30–80 chars) |
| Reliability | Timeout → keep SV; retry with backoff (track 47) |

**Fields (conceptual):** `reqId`, optional watermark (`maxRev` and/or compact digest), requester proto version.  
**Emit when:** Once per settle epoch; coalesce if a peer request/state already heals you (track 47).  
**Never:** On every `GUILD_ROSTER_UPDATE` or combat tick.

---

### `SYNC_STATE`

| Axis | Recommendation |
|------|----------------|
| Purpose | Snapshot / diff answer carrying official records |
| Direction | GUILD broadcast reply |
| Who may emit | Prefer **one** peer (Officer+ preferred); others suppress |
| Who applies | Requester + any eavesdropper with older revs |
| Consistency role | Anti-entropy; same apply predicate as `RANK_COMMIT` per row |
| CTL prio | **BULK** |
| Typical size | Header + 1..N packed rows; **multi-frame** when needed |
| Reliability | Chunk index/total; incomplete set → re-request with watermark |

**Emit when:** Answering a live `SYNC_REQUEST` (or rare officer-initiated push — not V1 default).  
**Shape:** Header chunk + body chunks; prefer `rev > watermark` diffs (track 14 mapping).  
**Never:** Carry pending suggestions, score logs, or UI prefs.

---

## V1 local (spec-listed, prefer off-wire)

### `SCORE_EVENT`

| Axis | Recommendation |
|------|----------------|
| Purpose | Optional noteworthy point event |
| Status | **V1 local-first** — plan Task 12 skips on-wire |
| If ever broadcast | Coarse summary only; CTL BULK; never per-combat |
| Storm risk | Extreme (track 47 Sketch C) |

Keep local standing/event log in SV for My Standing. Spectacle for non-addon players is **guild chat announce** on promotion, not score spam.

---

## V1.1 reserved (do not ship until flag)

Per [67](../67-offline-officer-suggestion-sync/v1-recommendation.md): petition catch-up is a **flagged** product choice. Reserve distinct types so ladder sync stays lean.

| Type | Purpose | Notes |
|------|---------|-------|
| `SUGGESTION_SYNC_REQUEST` | Officer+ pull for pending petitions | After ladder sync; officer-gated emitters/responders |
| `SUGGESTION_SYNC_STATE` | Capped grow-only union payload | Union by `suggestionId` + tombstones; silent UI |
| `SUGGESTION_TOMBSTONE` (optional) | Reject / already-promoted death notice | Only if live fanout of clears proves necessary |

**Do not** overload `SYNC_STATE` with a “kind=suggestions” flag in V1 — that couples cold-ladder cost to inbox policy and invites member clients to parse officer queues.

---

## Reject list (tempting anti-types)

| Temptation | Why reject |
|------------|------------|
| `ACK` / `NACK` per commit | Doubles traffic under Classic loss; revisions + sync heal instead |
| `FULL_DUMP` without request | Login storm amplifier |
| `SCORE_TICK` / combat drip | Prefix budget death |
| `PRESENCE` heartbeat mesh | Periodic HELLO storm; co-play does not need BeefNet |
| `OFFICER_NOTE_MIRROR` | Wrong store; privacy (CEPGP contrast) |
| Second prefix for “more bandwidth” | Disconnect risk; still shares CTL (track 14) |
| Per-alt account ladder sync type | Violates per-character SV doctrine |

---

## Quick matrix

| Type | Status | Mutates official? | Multi-frame? | Officer gate on accept? |
|------|--------|-------------------|--------------|-------------------------|
| `HELLO` | V1 ship | No | No | No |
| `SUGGESTION` | V1 ship | No (pending only) | No | Enqueue: Officer+ |
| `RANK_COMMIT` | V1 ship | Yes | No | **Yes** |
| `SYNC_REQUEST` | V1 ship | No | No | No |
| `SYNC_STATE` | V1 ship | Yes (via merge) | **Yes** | Rows use same commit predicate; emitter preference Officer+ |
| `SCORE_EVENT` | V1 local | No | No | N/A |
| `SUGGESTION_SYNC_*` | V1.1 reserved | Pending union only | Maybe | Officer+ |

---

## Pointers

| Need | Where |
|------|-------|
| Byte layouts | [wire-format-and-field-budgets.md](wire-format-and-field-budgets.md) |
| Major/minor rules | [versioning.md](versioning.md) |
| Emit caps | [anti-storm-per-type.md](anti-storm-per-type.md) |
| Cousin names | [classic-precedent-map.md](classic-precedent-map.md) |
