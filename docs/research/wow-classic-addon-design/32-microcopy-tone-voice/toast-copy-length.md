# Toast copy length

**Maps to:** Spec §10 toasts on suggestion created, rank approved, Gora/ceremony credit.  
**Layout/contrast** for stream capture lives in track 17; this note is **word budgets and dismiss timing** only.

## Job of a Beef toast

Local, auto-dismiss status for the *player who cares*:

| Event | Who needs it | Toast job |
|-------|--------------|-----------|
| Suggestion created | Member (+ officer later) | “You’re eligible — officers will see it.” |
| Rank approved | Promotee (and maybe officer confirm) | Confirm new title landed |
| Gora / ceremony credit | Participant | Confirm standing tick happened |

Guild-chat announce (when it fires) is the **public** spectacle. The toast is the **private receipt**. Do not duplicate a full sermon in both.

## Length budgets (copy)

Cross-platform snackbar/toast guidance converges on **short, single-purpose lines**:

- Material: snackbars hold a **single line of text** related to the operation; on larger layouts aim for one line and treat ~**40–60 characters** as a comfortable line length ([Material snackbars](https://m2.material.io/design/components/snackbars.html); [M3 snackbar guidelines](https://m3.material.io/components/snackbar/guidelines)).
- Material classic: snackbars are brief feedback; toasts are system messaging; **only one** snackbar at a time ([MD1 snackbars & toasts](https://m1.material.io/components/snackbars-toasts.html)).
- LogRocket: toasts are for brief messages readable in the time they are shown; average attention window cited around **3–8 seconds**; do not put long/complex info in a toast ([LogRocket — toast UX](https://blog.logrocket.com/ux-design/toast-notifications)).
- Secondary guides often recommend ~**3–6s** visibility for success toasts, longer for warnings ([StudyAround toast guide](https://studyaround.blog/toast-notification-design-guide); [Number Analytics toast practices](https://www.numberanalytics.com/blog/toast-notifications-best-practices-web-design)).

### Beef copy targets

| Budget | Rule |
|--------|------|
| **Words** | Prefer **6–12 words** |
| **Characters** | Prefer **≤ ~60** visible characters; hard stop before wrapping into a paragraph |
| **Lines** | **One line** default; two lines only if name + title will not fit (rare) |
| **Humor beats** | At most **one** liturgical verb; no second joke |
| **Names** | Include character name *or* “You” — not both stacked with flavor |

### Good toast examples

| Event | Copy |
|-------|------|
| Suggestion | `Standing recognized — Beef Knight suggested.` |
| Approved (self) | `Elevated to Beef Knight.` |
| Approved (officer ack) | `Promotion recorded: Beefina → Beef Knight.` |
| Ceremony credit | `Ceremony marked. Standing +{n}.` |
| Gora credit | `Beef Gora recorded. Standing +{n}.` |

### Bad toast examples

| Copy | Failure |
|------|---------|
| `The sacred grill flares as the prophets weep tears of tallow…` | Too long; unread before dismiss |
| `Suggestion #482 queued for officer review (sync pending rev 17)` | Protocol leak; anxiety |
| `LOL U LEVELED UP BRO 🔥` | Meme mode; off-brand |
| Multi-toast stack for one approve | Violates one-at-a-time; spam |

## Duration guidance (for implementers later)

Not implementing here — craft implication only:

| Severity | Suggested dwell | Notes |
|----------|-----------------|-------|
| Standing credit / suggestion | ~**3–4s** | Skimmable receipt |
| Rank approved | ~**4–6s** | Slightly longer; title must land |
| Error / sync warning | Persistent or explicit dismiss | Do not joke; do not auto-hide critical failures too fast ([LogRocket a11y notes on timed dismiss](https://blog.logrocket.com/ux-design/toast-notifications)) |

Combat/raid context: Beef is not a combat HUD (implications synthesis). Keep toasts **edge-placed** and short so they never compete with DBM/WA center mass — same reason copy must stay tiny.

## Queueing

Material rule: **one snackbar**; a new one replaces or waits ([MD1](https://m1.material.io/components/snackbars-toasts.html)). For Beef: coalesce standing ticks (“+15 standing (3 events)”) rather than three sequential joke lines.

## Relationship to guild announce

| Surface | Length | Humor | Audience |
|---------|--------|-------|----------|
| Toast | Ultra-short | Optional deadpan verb | Local client |
| Guild announce | Short ceremonial sentence | Liturgical brand | Whole guild + stream |

If both fire on the same promotion, toast = `Elevated to Beef Knight.` and announce = full Church sentence. Do not paste the announce into the toast.