# Duration & Attention (Toasts / Announces)

**Track:** [17-stream-overlay-readability](README.md)

---

## Stream audiences are distracted audiences

A Twitch/YouTube viewer is not the player staring at the toast. They are also watching chat, facecam, alerts, and the fight. Toast dwell times calibrated for a focused desktop app are **short** for a stream spectator who glances back after a raid callout.

UX ranges that show up repeatedly:

| Source | Guidance |
|--------|----------|
| [LogRocket — Toast best practices](https://blog.logrocket.com/ux-design/toast-notifications) (2025) | Attention for marketing-style alerts ≈ **3–8 s**; place out of the way; auto-dismiss |
| [StudyAround — Toast design](https://studyaround.blog/toast-notification-design-guide) | Success **~3 s**; warning **~6 s**; error indefinite / manual |
| [UX Collective — Toasts or snackbars](https://uxdesign.cc/toasts-or-snack-bars-design-organic-system-notifications-1236f2883023) | Common on-screen window **2–7 s**; rough reading budget ~**100 ms per character** (incl. spaces) for short copy |
| Material snackbar (Android impl.) | `LENGTH_SHORT` ≈ **1500 ms**, `LENGTH_LONG` ≈ **2750 ms** ([Stack Overflow citing SnackbarManager](https://stackoverflow.com/questions/56598610/what-is-the-actual-duration-of-a-snackbar-with-length-long)) |
| Android `Toast` delays (historical) | Often cited **~2 s / ~3.5 s** ([Stack Overflow — Toast duration](https://stackoverflow.com/questions/7965135/what-is-the-duration-of-a-toast-length-long-and-length-short/7965192)) |

Material’s on-device snackbars are **too short** for stream spectacle: the player may catch a 2.75 s toast; a VOD scrubber or phone viewer often will not.

---

## Recommended dwell for Beef events

Assume one short line (~40–70 characters) + optional second line (player name / title).

| Event (spec §10) | Player-facing toast | Stream-facing intent | Suggested on-screen |
|------------------|---------------------|----------------------|---------------------|
| Standing / Gora / ceremony **credit** | Confirmational | Low drama | **3.5–5 s** |
| **Suggestion created** | Useful to member | Medium | **5–7 s** |
| **Rank approved** (local toast) | Peak moment | High — pair with guild chat | **6–8 s** (upper end of LogRocket band) |
| **Demotion / excommunication** | High drama | High | **6–8 s** + confirm already in officer UI |
| Guild-chat promotion line | N/A (chat persistence) | Primary V1 spectacle | Chat history holds it; wording must land in **one glance** |

**Choreography rules:**

1. **One toast at a time.** Stacking credit + suggestion + promote in a dungeon wipe is noise ([Material: only one snackbar](https://m1.material.io/components/snackbars-toasts.html)).
2. **Promote toast may interrupt** a credit toast; credit toasts should not interrupt a promote toast.
3. **Guild chat is the durable channel**; toast is the ephemeral flourish for addon users / screen grabbers.
4. Keep copy short enough that even a **4 s** window works: title + name, not a paragraph.

Reading-budget check (UX Collective heuristic): a 50-character line ≈ 5 s at 100 ms/char — so a 6–8 s promote toast is comfortable for stream glance + one re-read.

---

## Announce cadence (not just duration)

Spectacle fails from **spam** as often as from short dwell:

- Spec already: **one throttled guild line from approving officer only**, opt-out ([§10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).
- Do not mirror every `SCORE_EVENT` into chat or toast — that is meter behavior, not church theater ([00 implications](../00-church-of-beef-implications.md) #10).
- Ceremony/Gora credit toasts should be **local** by default; public chat is reserved for rank commits and (later) intentional ceremony beats.

---

## Relevance to Church of Beef

- Success criterion §13.11 is **social reaction in guild chat**, not toast FPS.
- Toast duration is a stream *assist*; chat is the archive.
- V2 ceremonial dashboard can use longer “spotlight for N seconds” beats; V1 should stay inside the 3–8 s toast band.

## Sources

- [LogRocket — Toast notifications](https://blog.logrocket.com/ux-design/toast-notifications)
- [StudyAround — Toast notification design](https://studyaround.blog/toast-notification-design-guide)
- [UX Collective — Toasts or snack bars](https://uxdesign.cc/toasts-or-snack-bars-design-organic-system-notifications-1236f2883023)
- [Material Design 1 — Snackbars & toasts](https://m1.material.io/components/snackbars-toasts.html)
- [Stack Overflow — Snackbar LENGTH_LONG ms](https://stackoverflow.com/questions/56598610/what-is-the-actual-duration-of-a-snackbar-with-length-long)
- Design spec §10, §13.11
