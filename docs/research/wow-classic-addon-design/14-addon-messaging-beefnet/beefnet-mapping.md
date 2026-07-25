# Explicit BeefNet mapping (SYNC_STATE style)

This note binds ecosystem facts to the locked V1 protocol in design spec §8. No implementation — design constraints only.

## Wire defaults

| Field | Value |
|-------|-------|
| Prefix | `COB` |
| Distribution | `GUILD` |
| Framing | Colon-delimited type-first strings (or equally small packed form) |
| Version gate | Major mismatch → soft warn; drop incompatible commits |
| Pacing | ChatThrottleLib (or AceComm wrapping CTL) |

Conceptual frame (illustrative):

`COB` / `TYPE:protoMajor:…fields…` ≤ 255 chars body

## Type → behavior table

| Type | Direction | Who may emit | CTL prio | Typical size | Reliability strategy |
|------|-----------|--------------|----------|--------------|----------------------|
| `HELLO` | Broadcast | Any addon user | NORMAL | Tiny | Soft version ping; no ladder mutate |
| `RANK_COMMIT` | Broadcast | Officer+ only (receivers verify roster) | NORMAL | 1 record | Revision ≥ apply; replay-safe |
| `SUGGESTION` | Broadcast (officers filter) | Member | NORMAL | 1 suggestion | Local queue if officers offline; optional later sync |
| `SCORE_EVENT` | Prefer local | Member | BULK if ever | Small | Default off-wire; never high-frequency |
| `SYNC_REQUEST` | Broadcast | Login/reload client | NORMAL | Tiny (+ watermark) | Once per settle; backoff retry |
| `SYNC_STATE` | Broadcast reply | Prefer one peer (officer preferred) | **BULK** | Chunked records | Diff by revision; suppress duplicates |

## SYNC_STATE design (recommended shape)

Align with revisioned guild-tool patterns and Classic lossy links:

1. **Header chunk:** `SYNC_STATE:v:reqId:chunkIndex:chunkTotal:responder:watermark`
2. **Body chunks:** packed official records `{name, rankId, standing, rev, ts, officer}` only for `rev > requester watermark` (or full set if watermark missing / first join).
3. **Merge:** identical to live `RANK_COMMIT` merge rules (spec §8.3).
4. **Suppression:** on hearing any `SYNC_STATE` for `reqId`, other peers cancel pending reply.
5. **Preference:** if an Officer+ is online, non-officers can choose longer random delay so officers answer first (freshest source).

### Chunk budget example

| Guild state | Strategy |
|-------------|----------|
| ≤ ~4 records changed since watermark | Single 255-byte `SYNC_STATE` |
| Many changes / cold cache | N BULK chunks @ ≤1/sec after burst; total seconds ≈ chunks |
| Empty local + empty peers | Keep Fresh Beef defaults; wait for officer login |

## Channel alternatives (when *not* to use them)

| Alternative | Temptation | Verdict for V1 |
|-------------|------------|----------------|
| `OFFICER` for suggestions | Hide from members | Optional later; GUILD + UI filter is enough |
| `WHISPER` sync to officer | Bypass GUILD throttle lore | Worse fanout; only for directed repair experiments |
| `RAID` during raid night | “Everyone here has the addon” | Wrong scope — ladder is guild-wide |
| Custom `CHANNEL` | Cross-guild mesh | **Impossible / banned** on Classic |

## Persistence interaction

SavedVariables (`ChurchOfBeefDB`, per-character) caches official records + revisions. BeefNet reconciles caches; it does not replace SV. Alts do not share ladder progress in V1 — each character’s sync is independent (on-brand).

## Failure modes → product behavior

| Failure | Spec / research behavior |
|---------|--------------------------|
| Not in guild | Empty ladder; no BeefNet sends |
| No peer answers sync | Keep SV cache; retry later |
| Partial chunk loss | Re-request with watermark; never accept older rev |
| Forged commit from non-officer | Drop at validation |
| Version skew | Soft warn; ignore incompatible |
| Player without addon | Invisible to BeefNet; guild-chat announce still works |

## AceComm decision gate

Use AceComm **if** chunk reassembly + CTL integration is cheaper than hand-rolled framing. Do **not** use AceComm as an excuse to send multi-KB blobs — Classic still drops them. Spec already prefers small strings; AceComm is optional polish (see also track 04 sketches / library notes outside this folder).
