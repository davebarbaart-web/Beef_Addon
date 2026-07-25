# Wipe-safe design for guild sync caches

**Track:** [21 README](README.md)  
**Cross-read:** BeefNet wire behavior lives in [14](../14-addon-messaging-beefnet/); this note is only about **what must survive a local SV wipe** and what may be lost.  
**Product anchors:** design spec §8.3 (revisioned sync), §9 (SV as cache), §11 (edge table)

---

## 1. Definition: wipe-safe

A guild-shared datum is **wipe-safe** if, after a member’s `ChurchOfBeefDB` is deleted or reset to defaults, a normal login with at least one compatible peer (ideally an officer) online restores the **official** meaning of that datum without manual file surgery.

Local-only advisory data may be **lossy-on-wipe** by design — as long as product copy does not call it “the church archive.”

---

## 2. Classify every persisted field

| Class | Meaning | On SV wipe | Design rule |
|-------|---------|------------|-------------|
| **A — Official replicated** | Officer-committed ranks / standing snapshots + revisions | Rebuild via `SYNC_REQUEST` / `SYNC_STATE` / later `RANK_COMMIT` | Must be mergeable by revision; never require this file to exist |
| **B — Soft replicated** | Pending suggestions officers may have seen | May be lost if no officer still holds the queue (spec §16 open question) | Do not treat as durable history in V1 |
| **C — Local advisory** | Self-reported points, event log, anti-farm caps clocks | Lost | Cap size; label UI as personal testimony |
| **D — Local prefs** | Frame position, mute, toasts | Lost | Optional export string later; defaults OK |
| **E — Derived / ephemeral** | UI selection, roster queue, in-memory throttle state | N/A (don’t persist) | Keep out of SV |

Wipe-safe guild design = maximize class A correctness, minimize emotional attachment to class C.

---

## 3. Cache invariants (persistence side)

These complement track 14’s wire rules:

1. **Higher revision wins** — a wiped client’s empty cache is revision 0 for all keys; any peer record wins (spec §8.3).
2. **Empty is not authoritative** — never broadcast a full ladder of “everyone Fresh Beef” because your SV is nil.
3. **Do not persist “I am the sync authority”** — no local bool that suppresses peer state after a wipe.
4. **Guild identity gate** — if cached records belong to another guild/realm, drop class A cache rather than merge across Dreamscythe Alliance vs Doomhowl Horde (spec §5).
5. **Replay-safe apply** — duplicate commits with revision ≤ local ignored (spec §11); after wipe, local is low, so replays apply once — good.
6. **Size budget** — store one record per known member (or recent members), not full chat history. Smaller files → fewer corrupt writes ([WoWUIBugs #241](https://github.com/Stanzilla/WoWUIBugs/issues/241)).

---

## 4. What to put in SV vs what to re-fetch

| Put in SV (warm cache) | Re-fetch / recompute |
|------------------------|----------------------|
| Last known official record per player | Live roster Officer+ checks |
| Per-record revision + tie-break fields | Whether sender is currently Officer+ |
| UI prefs | Frame existence / media fallbacks |
| Local standing + short event ring | “Am I in an instance with guildmates right now” |

Roster and officer gates are **API state**, not SV truth (see track 16 when present). Persisting “Alice is Officer” ages badly; persisting “Alice is Beef Knight at revision 17” is the point of the cache.

---

## 5. Intentional wipe vs accidental wipe

| Intent | UX | Persistence effect |
|--------|----|--------------------|
| Member “Reset my UI” | Confirm; clear class D only | Ladder untouched |
| Member “Clear my standing log” | Confirm; clear class C | Ladder untouched |
| Officer “Excommunicate / demote” | Officer action → `RANK_COMMIT` | Class A updates via network |
| Officer “Season reset / Lent” (future) | Guild-wide policy commit | Class A revisions bump; old revisions obsolete |
| Troubleshoot “delete SavedVariables” | External file op | All classes gone; A recovers via sync |

Never overload a single “Reset Church of Beef” button that wipes A+C+D without spelling out that ladder will come back from the guild but personal logs will not.

---

## 6. Multi-client and alt wipe interactions

- **Per-character SV:** wiping Main does not wipe Alt’s file — each must sync independently (V1 doctrine: flesh proves itself anew — spec §9 / §16).
- **Same guild, two chars online:** both may answer sync (track 14 anti-storm rules apply). Persistence concern: both should hold class A caches that agree after merge.
- **Player transfers realm / renames:** treat as new identity unless you add explicit remap; stale class A rows for the old name become hidden “left guild” style records (spec §11 retain-but-hide).

---

## 7. Minimum viable wipe test (acceptance)

From a product perspective (maps to success criteria §13 #8):

1. Officer approves a rank; member sees it; both logout cleanly.
2. Member deletes `ChurchOfBeef.lua` while fully offline.
3. Member logs in with officer (or other peer with the commit) online.
4. After settle + sync, ladder shows the approved rank again.
5. Member’s personal event log is empty — acceptable; UI copy should not panic.

If step 4 fails, the bug is in sync/merge — not in “need a better backup format.”
