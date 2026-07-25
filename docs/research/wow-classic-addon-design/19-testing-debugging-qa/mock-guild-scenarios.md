# Mock Guild Scenarios for QA

**Last updated:** 2026-07-25  
**Track:** [19-testing-debugging-qa](README.md)  
**Maps to:** Design spec §6–§8, §11, §13.1

WoW has no official “mock guild” API. QA builds **scenarios** from multiple characters, rank layout, online/offline timing, and (when needed) a throwaway guild on a test realm. Guild tools historically expect **several online addon users** for sync stability ([Guild 2 Guild — multiple characters](https://legacy-wow.com/mop-addons/guild-2-guild/); [GuildHelperClassic](https://www.curseforge.com/wow/addons/guildhelperclassic) telephone-style share).

---

## 1. Minimum lab (matches spec §13.1)

| Role | Character | Guild rank index | Addon |
|------|-----------|------------------|-------|
| Officer / GM | Char A | ≤ officer threshold (default GM + top officer) | Church of Beef |
| Member | Char B | Below officer threshold | Church of Beef |
| Control (no addon) | Char C optional | Any | **No** Beef |

**Platform:** two clients or one client + second PC / dual-box — both on **same Anniversary realm + same guild**.

**Pass:** Officer approves → member’s ladder updates via BeefNet while both online.

---

## 2. Scenario catalog (Beef V1)

### A. Happy path — promotion spectacle

1. Member accrues standing (instance with guildmate, or thin Gora/ceremony).
2. Threshold crossed → suggestion visible to officer.
3. Officer approves → local rank update + BeefNet `RANK_COMMIT`.
4. Guild chat shows **one** throttled announce (spec §10 / §13.11).
5. Member without addon (Char C) still **sees chat line**.

### B. Offline reconciliation (spec §8.3)

1. Officer promotes while member is **logged out**.
2. Member logs in → `SYNC_REQUEST` / `SYNC_STATE` → ladder matches officer revision.
3. Repeat with officer offline and a third peer who held the commit.

### C. Roster race

1. Immediately on login, before guild roster populates, attempt to process a commit (or send spam).
2. Expect **queue or drop**, never apply unverified (spec §6.2 / §11).

### D. Non-officer forge

1. Member client somehow emits `RANK_COMMIT`-shaped traffic (test harness or temporary debug — not shipped).
2. Peers **reject**; ladder unchanged.

### E. Version skew

1. Officer on build N, member on N−1 major.
2. Soft warn; incompatible commits discarded (spec §11).

### F. Empty / edge guild states

| State | Expected UI |
|-------|-------------|
| Not in guild | Empty ladder; scoring paused |
| In guild, Officer tab as member | Tab hidden; approve no-ops |
| Player left guild | Record retained but hidden; restore on rejoin |
| Alt on same account | Fresh Beef / separate SV (per-character) |

### G. Ceremony / Gora thin stubs

1. Officer starts ceremony → close → attendees credit.
2. Disconnect mid-ceremony → **no** credit until clean close or manual officer grant (spec §11).
3. Gora loss grants participation points (anti “dodge duel” design).

### H. Instance co-play + anti-AFK

1. Two guildmates in dungeon, both enter combat in a bucket → drip.
2. Stand at entrance, no combat → **no** points.
3. Cap: repeated buckets same day stop paying after daily cap.

### I. Reply-storm / throttle

1. Several members log in together after a raid.
2. Sync responses should not flood; ChatThrottleLib-style pacing respected (ecosystem throttle lore — see synthesis / SendAddonMessage notes). Watch for disconnects under spam (historical ChatThrottleLib testing notes).

---

## 3. “Mock guild” setup recipes

| Recipe | When to use | Notes |
|--------|-------------|-------|
| **Real guild, two ranks** | Default | Promote a second char to Officer for tests; demote after |
| **Throwaway guild** | Isolated protocol tests | Create 1–2 day guild on Anniversary; delete when done |
| **Rank-index rehearsal** | Officer threshold config | Rename ranks arbitrarily; confirm index ≤ threshold still gates — names must not matter |
| **Dual faction** | Dreamscythe vs Doomhowl | Separate ladders; never expect cross-guild sync (spec §5) |

There is **no** substitute for `GUILD` addon channel + real roster APIs for BeefNet — unit-test stubs outside the client cannot prove Classic throttle or roster timing.

---

## 4. Observation tools during scenarios

- BugSack on all participants ([script-errors-bugsack.md](script-errors-bugsack.md)).
- Optional: temporary alpha-only BeefNet logging (`@alpha@` blocks when packaging exists — [alpha-channels.md](alpha-channels.md)).
- Chat log / stream VOD for §13.11 social check.
