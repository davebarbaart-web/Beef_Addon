# Beef scoring windows — clock policy

**Track:** 50 — time, timezones, resets  
**Question:** How should V1 map clocks onto day keys, instance buckets, caps, and commit timestamps?

## 1. Inputs from product / plan

| Mechanism | Plan / spec intent |
|-----------|-------------------|
| Instance drip | ~60s combat-active buckets; AFK pays 0 |
| Completion bonus | Flat grant on dungeon/BG end (optional if flaky) |
| Caps | Per-day per source (instance 60 / ceremony 80 / gora 100 sketched) |
| Day key | `Scoring:GetDayKey(now) -> string` |
| Authority | Standing is advisory until officer `RANK_COMMIT` |
| Sync stamp | `updatedAt` participates in equal-revision tiebreak |

## 2. Recommended `now` convention

Every scoring entry point already takes `now` in the plan (`Grant*(…, now)`). **Production callers should pass `GetServerTime()`.** Tests pass integers.

```text
now          := GetServerTime()          -- wall / sync / day key
elapsedTick  := GetTime() - lastTick     -- bucket pacing only
```

Never pass `time()` into `GetDayKey` in production.

## 3. Day key = US daily reset boundary (CoB default)

For Dreamscythe / Doomhowl:

**Definition:** A scoring day is the half-open interval  
`[Tuesday-or-any-day 15:00:00 UTC, next day 15:00:00 UTC)` — i.e. aligned to **US daily reset**, not local midnight and not “realm calendar midnight.”

**Suggested key shape (research-level, not code):**

- Integer day index: `floor((GetServerTime() - US_DAILY_RESET_OFFSET) / 86400)` where offset is chosen so boundaries fall on 15:00 UTC, **or**
- String: `YYYY-MM-DD` of the UTC date of the interval’s start instant after shifting by −15h.

Either is fine if stable and shared. Document the chosen offset in one comment next to `GetDayKey`.

**Why not realm `GetGameTime` midnight?** Realm display midnight ≠ daily quest reset. Caps should match the moment players already understand as “dailies refreshed.”

**Why not local midnight?** Breaks multi-timezone guildmates and enables OS-clock abuse.

## 4. Cap windows vs weekly reset

| Window | Use for Beef V1? |
|--------|------------------|
| Daily (15:00 UTC US) | **Yes** — instance / ceremony / gora caps |
| Weekly (Tue 15:00 UTC US) | **No** for V1 caps (unless product later adds weekly spectacle budgets) |
| Arena season | **No** |
| Local calendar week | **No** |

Ceremony credit is already officer-gated by starting/closing a ceremony; daily ceremony cap still needs the shared day key so alts/officers cannot spray unlimited flat grants from a buggy client without the day rolling.

## 5. Instance bucket window

| Rule | Clock |
|------|-------|
| Bucket length ~60s | `GetTime()` (or server delta) |
| Combat required inside bucket | Gameplay state, not clock |
| Persist “last grant time” for anti-double-tick across reload | Prefer `GetServerTime()` so a reload mid-bucket doesn’t free a free bucket via `GetTime()` reset — **or** accept lossy local-only pacing (simpler; abuse is officer-reviewed) |

**Practical V1 stance:** Local pacing with `GetTime()` is acceptable because standing is advisory; **day-key and event log timestamps** still use `GetServerTime()`. If playtests show reload bucket farming, persist `lastBucketServerTime`.

## 6. Commit / suggestion timestamps

| Field | Clock | Notes |
|-------|-------|-------|
| `updatedAt` on official record | `GetServerTime()` | Tiebreak after revision ([track 27](../27-desync-conflict-resolution/)) |
| Suggestion createdAt | `GetServerTime()` | Officer UI “how fresh” |
| Local event log | `GetServerTime()` | My Standing history |
| Toast “3m ago” | Derive from server stamp vs current `GetServerTime()` | Do not store local-only ages |

Clock skew between honest clients should be small; revision remains primary.

## 7. Pause conditions (not clocks, but windows)

Spec: scoring paused when not in a guild. Treat as hard gate independent of day key — do not grant into a day bucket while unguilded, then flush on rejoin.

Cross-realm: impossible for shared state; each realm’s `GetServerTime()` is still the right local authority for that guild’s ladder.

## 8. Worked policy table

| Question | Answer for CoB V1 |
|----------|-------------------|
| What is `now`? | `GetServerTime()` |
| When do daily caps refresh? | US daily reset **15:00 UTC** |
| Do we follow EU if someone ports? | Out of scope; US guilds only |
| Do we wipe standing on Arena season? | No |
| Do we wipe on Tuesday weekly? | No (V1) |
| Future Lent? | Officer decree at UTC `T` or next weekly — see [season-boundaries-ladders.md](season-boundaries-ladders.md) |
| Bucket AFK check | Combat flag in interval |
| Display realm time? | Optional flavor only |

## 9. Open verification checklist (in-game, Anniversary 20506)

- [ ] `GetServerTime()` exists and moves while logged in
- [ ] `date("!*t", GetServerTime())` (or equivalent) usable for UTC fields
- [ ] Confirm daily quest reset aligns with 15:00 UTC on Dreamscythe
- [ ] Probe `C_DateAndTime.GetSecondsUntilDailyReset` — use if present, else computed anchor
- [ ] Confirm two clients’ `GetServerTime()` within a few seconds during a Gora

## 10. Steal / adapt summary

| Steal | Adapt |
|-------|-------|
| Blizzard daily reset as shared “day” | Beef `GetDayKey` |
| `GetServerTime` for multi-client stamps | All persisted times |
| `GetTime` for session pacing | Bucket ticker |
| Season/weekly as optional meta | Lent later; ignore for V1 caps |
