# Thin V1 ceremony stubs

**Track:** 71-ceremony-gora-mechanics  
**Client focus:** TBC Classic Anniversary (`Interface` **20506**)  
**Product baseline:** Spec §7.1 (ceremony source), §10 (thin stubs), §11 (disconnect mid-ceremony)

---

## 1. What “thin” means

| In V1 | Not in V1 |
|-------|-----------|
| Officer **Start** / **Close** controls (Officer tab or stub panel) | Ceremonial dashboard, announcements wall, confession feed |
| One open ceremony id per guild night (or per officer session) | Parallel nested liturgies / worship calendar widgets |
| Attendance mark applied **on close** | Calendar Accept, Discord RSVP, proximity radar as credit |
| Medium flat standing grant (canon-tunable) to listed attendees | Per-minute drip while “in service” |
| Local toast: ceremony credit ([32 toast craft](../32-microcopy-tone-voice/toast-copy-length.md)) | Multi-line scripture spam in guild chat |
| Optional one-line free-text “rite name” for My Standing history | Full Beef Scripture CMS |

Deep research and immersion tracks invent liturgy metaphors; they stay **flavor brainstorm**, not V1 chrome ([07 implications](../07-immersion-roleplay-flavor/implications-for-church-of-beef.md); [10 adopt-vs-invent](../10-skinning-masque-sharedmedia/06-church-of-beef-adopt-vs-invent.md)).

---

## 2. State machine

```
                    Officer+ Start
   Idle ──────────────────────────► Open
    ▲                                 │
    │                                 │ Officer+ Close
    │                                 │  (with attendance set)
    │                                 ▼
    └────────── Closed ───────────────┘
                 │
                 └─► SCORE_EVENT / local standing grant
                     (attendees only; once per ceremony id)
```

| State | Who sees what | Scoring |
|-------|---------------|---------|
| **Idle** | Stub shows Start (Officer+) | None |
| **Open** | Stub shows Close + attendance picker; non-officers may see “Ceremony in progress” status chip | None yet |
| **Closed** | Recent event on My Standing; toast for credited players | Flat grant once |

**Invariant:** No standing from ceremony without a successful transition `Open → Closed` by a verified Officer+ (roster rank-index gate — [16](../16-guild-roster-officer-edges/), spec §6.2).

---

## 3. Attendance model (Anniversary)

**Authority:** Officer close list — not instance membership, not calendar Accept ([39 classic-calendar-apis](../39-guild-calendar-events/classic-calendar-apis.md)).

Recommended V1 picker (keep tiny):

1. **Default seed:** online guild roster present in the officer’s party/raid *or* a short “nearby guildies” checklist the officer ticks (manual).
2. **Officer edits:** add/remove names before Close (steal GRA Attendance Editor energy — [cousin note](cousin-ritual-addons.md)).
3. **Credit rule:** each character id receives at most one grant per `ceremonyId`.
4. **Offline / disconnected:** if a player DC’d mid-open, they are **not** credited unless the officer still lists them on Close **or** later uses manual standing adjust (spec §11).

Do **not** require BeefNet peers for local credit. Peers without the addon can still be listed if the officer saw them — standing is local until/unless a future SCORE_EVENT broadcast is productized ([14](../14-addon-messaging-beefnet/)).

---

## 4. UI budget (stub surface)

| Element | Required V1 | Notes |
|---------|-------------|-------|
| Start button | Yes (Officer+) | Disabled when already Open; soft error if not Officer+ |
| Close button | Yes (Officer+) | Disabled when Idle |
| Attendance checklist | Yes (minimal) | Scroll if needed — [57](../57-scrollframe-list-rows/) |
| Rite name field | Optional one-liner | Feeds My Standing “Ceremony: {name}” |
| Preview grant amount | Nice | Shows canon flat value so officers don’t surprise the flock |
| Confirm on Close | Light | “Credit N members +{points}?” — not nuclear StaticPopup ([58](../58-staticpopup-confirms/)); Escape cancels |
| Cutscene / gossip takeover | **No** | Immersion skip-friendly doctrine ([07](../07-immersion-roleplay-flavor/)) |
| Guild-chat “ceremony closed” | Optional later | Spec §10 spectacle budget is for **rank** announce; ceremony credit stays toast-local in V1 |

Placement: Officer tab stub row or a small “Rites” strip — never a center combat HUD ([01 UX synthesis](../01-ux-patterns/church-of-beef-synthesis.md)).

---

## 5. Scoring & anti-abuse hooks

Owned numerically by [26](../26-ladders-points-gamification/); mechanics constraints here:

| Rule | Why |
|------|-----|
| Flat grant once per `ceremonyId` | Stops Close spam |
| Daily ceremony-source cap | Stops “Start/Close every 30s” farms |
| Pause if local unit dead/ghost | Cheap correctness ([60 R1](../60-hardcore-doomhowl-edges/beef-scoring-ceremony-hc-rules.md) — shared Anniversary rule, not HC-only product) |
| Officer remains anti-cheat | Implausible attendance lists are comedy, then manual adjust (spec §6.3) |

---

## 6. Ceremony types (content labels, same machine)

V1 uses **one** machine; labels are free text or a short enum in canon data:

| Label (examples) | Intent |
|------------------|--------|
| Promotion rite | Flavor after an approve — optional; approve already toasts |
| Guild night liturgy | Default social block ([51](../51-guild-night-playbook/)) |
| Welcome / pilgrim | Manual culture; no SV import magic |
| Lent / season open | Soft reset *ceremony* is calendar ritual language ([39](../39-guild-calendar-events/ritual-cadence-seasons.md)) — still officer close |

Do not ship separate UIs per label in V1.

---

## 7. Failure modes

| Situation | Behavior |
|-----------|----------|
| Start while Open | No-op + “Ceremony already open” |
| Close while Idle | No-op |
| Officer logs mid-Open; another Officer+ closes | Allowed — first clean Close wins; second Close on same id ignored |
| Zero attendees on Close | Allow void close (no grants) or warn — prefer warn + confirm |
| Member expects auto-credit from standing in city | Empty — explain officer mark required |
| Disconnect mid-ceremony | Spec §11: no credit until clean close or manual |

---

## 8. Success criteria for the stub

From guild-night playbook intent ([51 operational](../51-guild-night-playbook/operational-runbook.md)):

1. Officer can Start → Close in under ~60 seconds of UI time.  
2. At least one attendee sees ceremony credit on My Standing / toast.  
3. A disconnected player without manual credit sees **no** silent grant.  
4. Non-officers cannot Start/Close.

---

## Related in this track

| Note | Role |
|------|------|
| [officer-close-patterns.md](officer-close-patterns.md) | Who may Close; light confirm; void / manual credit |
| [cousin-ritual-addons.md](cousin-ritual-addons.md) | GRA attendance editor + Immersion time budget |
| [annotated-urls.md](annotated-urls.md) | Primary URLs |
