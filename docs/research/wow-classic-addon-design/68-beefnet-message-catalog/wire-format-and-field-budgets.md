# Wire format & field budgets (255-byte frames)

**Track:** 68  
**Maps to:** Spec §8.2 small payloads; plan Task 12 `VERSION|TYPE|fields…`; track 14 envelope facts.  
**Does not redefine:** CTL CPS, prefix token bucket, silent-drop culture — cite [14](../14-addon-messaging-beefnet/).

## Hard envelope (facts)

| Constraint | Value | Source |
|------------|-------|--------|
| Prefix | `COB` (≤16) | Spec §8.2 |
| Channel | `GUILD` | Spec §8.2 |
| Message body | ≤ **255** characters | [SendAddonMessage](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage) |
| NULL bytes | Forbidden | Wiki |
| Delivery | Best-effort; success ≠ arrived | Track 14 Classic realities |

Design rule: treat **240** chars as the practical body budget so type/version/chunk headers never surprise you at the edge.

---

## Recommended frame grammar

Unify plan Task 12 and track-14 sketches into one type-first form:

```
TYPE:maj:min:fields…
```

| Segment | Rule |
|---------|------|
| `TYPE` | Uppercase token from catalog (`HELLO`, `RANK_COMMIT`, …) |
| `maj` / `min` | Unsigned decimal protocol version (see [versioning.md](versioning.md)) |
| `fields…` | Type-specific, `:`-separated |
| Separators | `:` only; **no** `:` inside field values |
| Charset | Printable ASCII; prefer `[A-Za-z0-9_-]` for ids/names on the wire |
| Empty field | Allowed as adjacent colons only when schema says optional |

**Why type-first:** Receivers can reject unknown types before parsing version-specific bodies; debug logs read naturally; matches track-14 conceptual frames.

**AceComm note:** If AceComm multi-chunk is used later, BeefNet still defines *logical* frames ≤255 for Classic loss tolerance — AceComm is transport polish, not an excuse for multi-KB logical blobs (track 14).

---

## Identity & encoding conventions

| Concept | V1 wire recommendation | Rationale |
|---------|------------------------|-----------|
| Player key | Guild-visible name as used in roster/`UnitName` (same-realm short form) | Matches plan `Ladder` keyed by name; Anniversary guilds are same-realm |
| Officer / updatedBy | Same name form as sender when possible | Tiebreak needs stable string (spec §8.3) |
| Rank | Decimal `rankId` 1–7 | Spec |
| Standing | Non-negative integer decimal | Spec |
| Revision | Positive integer decimal | Spec |
| Timestamp | Unix seconds decimal (UTC) | Compact; equal-rev tiebreak only |
| reqId / suggestionId | Short opaque base36 or hex (6–10 chars) | Enough entropy for a guild night |
| Watermark | `maxRev` decimal **or** `0` for cold | Diff sync; optional later: compact hash |
| Booleans | `0` / `1` | Tiny |

**Avoid on V1 wire:** Full `Name-Realm` when unnecessary; GUID strings (long); JSON; LibSerialize blobs; player-authored free text (confession essays → wrong API / Logged path).

If a future connected-realm edge appears, prefer a **single** canonical form decided in Core (not mixed forms on the bus). Privacy/stream masking must never change the wire key ([61](../61-streamer-mode-privacy/)).

---

## Per-type field schemas (research-normative)

Lengths are **illustrative budgets**, not Lua structs. `H` = shared header `TYPE:maj:min` (~12–18 chars for typical tokens).

### `HELLO`

```
HELLO:maj:min:addonBuild
```

| Field | Example | Budget |
|-------|---------|--------|
| addonBuild | `1` or short semver token `010` | ≤8 |

**Body target:** ≤ 30 chars. No roster, no ranks.

---

### `SUGGESTION`

```
SUGGESTION:maj:min:suggestionId:subject:toRank:standing:createdAt
```

| Field | Notes | Typical bytes |
|-------|-------|---------------|
| suggestionId | Opaque | 6–10 |
| subject | Player name | 3–12 |
| toRank | 1–5 petition target | 1 |
| standing | Claimed standing at petition | 1–5 |
| createdAt | Unix sec | 10 |

**Body target:** ≤ 100 chars. Omit breakdown essays — officers open UI for local detail. Re-petition = new id or same id with rate-limit (product: [67](../67-offline-officer-suggestion-sync/)).

---

### `RANK_COMMIT`

```
RANK_COMMIT:maj:min:name:rankId:standing:rev:updatedAt:updatedBy
```

| Field | Notes | Typical bytes |
|-------|-------|---------------|
| name | Subject | 3–12 |
| rankId | 1–7 | 1 |
| standing | Official standing snapshot | 1–5 |
| rev | Per-player revision | 1–5 |
| updatedAt | Unix sec | 10 |
| updatedBy | Committing officer name | 3–12 |

**Worked size:**

| Scenario | Approx body |
|----------|-------------|
| Short names (`Ann`, officer `Bob`, rev 3) | ~45–55 |
| Long Classic names (12+12) + large ints | ~85–100 |
| Headroom vs 255 | **One record per frame** — do not pack multiple commits |

Demote / Council / Prophet are still `RANK_COMMIT` snapshots (rankId reflects outcome), not separate wire types — keeps the accept path singular (track 27 one-merge-function instinct).

---

### `SYNC_REQUEST`

```
SYNC_REQUEST:maj:min:reqId:watermark
```

| Field | Notes |
|-------|-------|
| reqId | Night-unique nonce |
| watermark | `0` = cold full; else max known official rev (or future digest token) |

**Body target:** ≤ 50 chars. Optional later field: `flags` bit for “officer-prefer answer” is unnecessary if responders already delay by rank (track 14).

---

### `SYNC_STATE` (multi-frame)

**Header / control chunk:**

```
SYNC_STATE:maj:min:reqId:chunkIndex:chunkTotal:watermark:responder
```

**Body chunk (records):**

```
SYNC_STATE:maj:min:reqId:chunkIndex:chunkTotal:REC:name:rankId:standing:rev:updatedAt:updatedBy:REC:…
```

| Rule | Detail |
|------|--------|
| `chunkIndex` | 1-based |
| `chunkTotal` | ≥1; known before send or revised carefully (prefer known) |
| Record marker | Literal `REC` before each row (parsers skip unknown tokens) |
| Row fields | Same order as `RANK_COMMIT` subject fields |
| Diff | Include only rows with `rev > requester watermark` when watermark > 0 |
| Merge | Identical predicate to live commit (spec §8.3 / track 27) |

### Chunk budget math

Shared per-chunk overhead (type+ver+reqId+indices+watermark+responder): ~**55–90** chars.  
Remaining for records: ~**150–185** chars per frame.

| Record packing | Bytes / row (typ) | Rows / frame |
|----------------|-------------------|--------------|
| Short names | ~45–55 | 3–4 |
| Long names | ~70–90 | 1–2 |

| Guild ladder state | Strategy |
|--------------------|----------|
| ≤3 rows newer than watermark | Single chunk |
| Warm guild night, few promotes | 1–3 BULK chunks |
| Cold install, ~60 occupied | ~15–25 chunks @ ≤1/s after burst — **one responder only** |
| Cold install, ~200 occupied | ~50+ chunks — officer-prefer + patience (track 47 Sketch B) |

**Never** put suggestion rows, score logs, or prefs in these chunks.

---

### `SCORE_EVENT` (if ever on wire)

```
SCORE_EVENT:maj:min:kind:value:ts
```

Keep ≤ 40 chars; `kind` enum not free text. Default: **do not send**.

---

### Reserved V1.1 suggestion sync (sketch only)

```
SUGGESTION_SYNC_REQUEST:maj:min:reqId:cap
SUGGESTION_SYNC_STATE:maj:min:reqId:chunkIndex:chunkTotal:SUG:…:TMB:…
```

Cap rows (e.g. 50 / 14 days) before packing. Tombstones (`TMB:suggestionId`) prevent resurrection. Budgets mirror `SYNC_STATE` but **officer-only** interest — members should ignore.

---

## Validation checklist (wire layer)

Drop (no reply) when:

1. Body length > 255 or contains NUL.  
2. Unknown `TYPE` for this major (soft-ignore).  
3. `maj` incompatible (see versioning).  
4. Wrong arity / non-numeric where numeric required.  
5. `rankId` ∉ 1..7 or standing < 0 on commit/sync rows.  
6. `RANK_COMMIT` / sync row apply path: sender fails Officer+ check (commits); sync rows still need valid shape before merge.  
7. `chunkIndex` > `chunkTotal` or `chunkTotal` absurd (> e.g. 200) — treat as malformed.

**No NACK storm** on validation failure (track 14 reliability stack).

---

## Headroom discipline

| Practice | Why |
|----------|-----|
| Prefer decimal over padded fixed-width | Shorter for small guilds |
| Cap `updatedBy` / names at roster max | Prevent adversarial long strings |
| Refuse free-text “reason” on V1 wire | Blows frames; keep in local UI |
| Measure once on a real guild night | Track 14/47 reasoned; 51 playtest closes the loop |

---

## Pointers

| Need | Where |
|------|-------|
| CTL / token bucket | [14 chatthrottlelib-and-budgets](../14-addon-messaging-beefnet/chatthrottlelib-and-budgets.md) |
| Reply suppression | [14 sync-state-and-anti-spam](../14-addon-messaging-beefnet/sync-state-and-anti-spam.md) |
| Herd envelopes | [47 beefnet-load-guidance](../47-login-storms-guild-scale/beefnet-load-guidance.md) |
