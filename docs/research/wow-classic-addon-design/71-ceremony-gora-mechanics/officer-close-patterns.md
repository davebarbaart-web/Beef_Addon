# Officer close patterns

**Track:** 71-ceremony-gora-mechanics  
**Purpose:** Who may end a rite, what friction they get, and how abort/manual credit work.  
**Complements:** Ceremony machine ([thin-v1-ceremony-stubs.md](thin-v1-ceremony-stubs.md)); Gora record ([gora-challenge-flows.md](gora-challenge-flows.md)); nuclear confirms ([58](../58-staticpopup-confirms/)); facilitator RACI ([51](../51-guild-night-playbook/facilitator-roles.md)).

---

## 1. Close vs nuclear

| Action | Severity | Confirm style | Spec role |
|--------|----------|---------------|-----------|
| Ceremony **Close** (credit N) | Medium | Light confirm — named count + grant preview | Score fuel |
| Gora **Record** | Medium | Light confirm — named A/B + outcome | Score fuel |
| Ceremony **void Close** (0 credit) | Low–med | Warn if Open > few minutes | Cleanup |
| Gora **void / cancel** | Low | Soft confirm | Cleanup |
| Manual standing adjust after botched rite | Medium–high | Per [58](../58-staticpopup-confirms/) light/large-delta rules | Correction |
| Demote / Prophet / wipe | High / nuclear | Full StaticPopup recipes in [58](../58-staticpopup-confirms/) | Not rite-close |

Do not reuse `COB_PROPHET`-grade friction for every ceremony Close — officers will stop running 5-minute liturgies ([51](../51-guild-night-playbook/operational-runbook.md)).

---

## 2. Authority matrix

| Capability | Member | Officer+ | Notes |
|------------|--------|----------|-------|
| Propose Gora challenge | Yes | Yes | Advisory until recorded |
| Propose Gora outcome | Yes (optional) | Yes | Officer commit recommended V1 |
| **Record** Gora (standing) | No | **Yes** | Anti-cheat stance |
| Ceremony Start | No | **Yes** | Spec §7.1 |
| Ceremony Close + attendance | No | **Yes** | Spec §7.1 / §11 |
| Manual credit after DC | No | **Yes** | Standing adjust tool |
| Guild-chat rank announce | — | Approving officer only | Spec §10 — separate from rite close |

Roster rank-index threshold is configurable; same gate as `RANK_COMMIT` ([spec §6.2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

**On-duty pattern:** Guild night names an Approving Officer / Score Desk ([51 facilitator-roles](../51-guild-night-playbook/facilitator-roles.md)). Addon does not need a second “ceremony master” rank — Officer+ is enough.

---

## 3. Ceremony close checklist (officer UX)

Before Close commits:

1. Show **Open duration** (soft — “opened 8m ago”).  
2. Show **attendance count** and scrollable name list.  
3. Show **grant preview** (`+{flat}` × N, after daily-cap note if relevant).  
4. Primary button: **Close & credit**.  
5. Secondary: **Void close** (end Open, zero grants).  
6. Escape / cancel leaves ceremony **Open**.

On success:

- Persist `ceremonyId`, closer name, timestamp, attendee set, grant value.  
- Apply local standing to attendees who still exist in SV scope.  
- Toast credited players ([32](../32-microcopy-tone-voice/toast-copy-length.md)).  
- Append My Standing events.  
- Optional: coarse `SCORE_EVENT` if BeefNet catalog allows ([68](../68-beefnet-message-catalog/) when filled) — never required for local credit.

---

## 4. Gora record checklist (officer UX)

Before Record commits:

1. Named sides (challenger / opponent).  
2. Outcome control (three-way).  
3. Cap / DR warning if same pair already paid today.  
4. Preview both grants (win/draw/loss amounts).  
5. Confirm → commit → toasts both sides (if online locally).

Steal Gargul’s “decision + short note” density ([13](../13-cousin-addon-teardowns/steal-avoid-for-beef.md)): one screen, no bracket chrome.

---

## 5. Abort, disconnect, double-close

| Pattern | Ceremony | Gora |
|---------|----------|------|
| **Clean close** | Open → Closed + credit | Challenged → Recorded + credit |
| **Void** | Open → Idle, no credit | Challenged → Idle, no credit |
| **Disconnect mid-open** | No auto-credit (spec §11); officer may still list them on Close or manual adjust later | No auto-outcome; void or human draw/forfeit |
| **Double close / double record** | Idempotent on `ceremonyId` / `goraId` | Same |
| **Officer swap mid-rite** | Any Officer+ may Close | Any Officer+ may Record |
| **No officers online** | Members cannot close; leave Idle/Open until one appears — do not invent member self-close | Challenges may sit; no standing |

Offline suggestion-queue policy ([67](../67-offline-officer-suggestion-sync/)) is about promotions, not rites — do not build a durable “ceremony inbox” in V1. Rites are live-session objects.

---

## 6. Manual credit as escape hatch

When Close was wrong (forgot a name, credited a joker):

1. Prefer **manual standing adjust** with short reason (“ceremony credit missed”) — officer tool already in §10.  
2. Do not re-open the same `ceremonyId` for a second mass grant.  
3. Audit/reason fields follow [40](../40-officer-moderation-audit/) if that track’s patterns are present.

This keeps the Close button fast and honest: Close is the happy path; Adjust is the apology.

---

## 7. Copy tone at the gate

| Moment | Voice |
|--------|-------|
| Close confirm | Procedural: “Credit 6 members +15 standing?” |
| Record confirm | Procedural + proper noun: “Record Beef Gora: Beefina beat Steaklord?” |
| Success toast | Short liturgy OK: “Ceremony recorded. Standing +15.” / “Beef Gora recorded…” ([32](../32-microcopy-tone-voice/), [53](../53-beef-lore-ui-bible/string-do-dont.md)) |
| Permission error | Sober: “Officer only.” |

Never auto-announce every ceremony close in guild chat in V1 — preserve §10 announce budget for rank spectacle.

---

## 8. Implementation-facing invariants (no code)

1. Close/Record handlers are no-ops unless local player passes Officer+ check.  
2. BeefNet peers must still re-validate officer rank on any future broadcast of rite results.  
3. `timeout` auto-accept on confirms = forbidden ([58 shared contract](../58-staticpopup-confirms/beef-demote-prophet-confirms.md)).  
4. Rite commits are **not** `RANK_COMMIT` — they mutate standing/event log; promotions still go through suggestion → approve.

---

## Related in this track

| Note | Role |
|------|------|
| [thin-v1-ceremony-stubs.md](thin-v1-ceremony-stubs.md) | Ceremony Idle → Open → Closed machine |
| [gora-challenge-flows.md](gora-challenge-flows.md) | Gora Challenged → Recorded machine |
| [cousin-ritual-addons.md](cousin-ritual-addons.md) | Gargul Award density vs RCL parliament |
| [annotated-urls.md](annotated-urls.md) | Primary URLs |
