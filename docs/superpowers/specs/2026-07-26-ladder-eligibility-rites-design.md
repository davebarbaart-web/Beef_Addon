# Church of Beef — Ladder eligibility & rites (design amendment)

**Date:** 2026-07-26  
**Status:** Accepted — implemented 2026-07-26  
**Amends:** [2026-07-25-church-of-beef-design.md](2026-07-25-church-of-beef-design.md) (§4 rank meaning, §7 scoring sources), [2026-07-25-roster-backed-ladder-design.md](2026-07-25-roster-backed-ladder-design.md) (suggestion payload / Officer UX)  
**Does not amend:** Roster as title authority, no auto guild promote/demote, Officer+ gate via `rankIndex`, Interface `20506`, layer rules

---

## 1. Intent

Align Church rank *meaning* with lived guild culture and the standing system:

- Standing = loyalty testimony (who has shown up).
- Rites = identity moments (knighting, Gora upset).
- Officers (especially the Beef Prophet) = the real gate, via Blizzard guild UI.

Discord is demoted from an early hard gate; **running the addon + co-play standing** becomes the on-ramp. Beef Butcher becomes a **pure standing capstone**, fueled heavily by raid loyalty. Questing groups with guildmates earn capped standing so open-world fellowship counts.

---

## 2. Decisions (locked)

| Topic | Decision |
|-------|----------|
| Approach | **Eligibility tags** — standing thresholds still enqueue suggestions; Knight/Lord show a rite checklist that coaches, does not hard-block |
| Fresh Beef | Default intro; no special gate |
| Cooked Beef | Mostly standing (early threshold); addon use is the digital on-ramp; Discord is community follow-up, not eligibility |
| Beef Knight | Standing threshold + expected **Knighting of the Beef** rite |
| Beef Lord | Standing threshold + expected **Gora win vs a seated Beef Lord** |
| Beef Butcher | Pure standing peak / guild capstone; no rite lock; raid co-play heavily weighted |
| Beef Council | Never point-suggested; seat-limited; **Prophet-only appointment policy** (soft UI copy; Blizzard UI not locked) |
| Beef Prophet | Unique; reserved for guild master / Dave; never earned by standing |
| Quest fellowship | New capped co-play source: party with guildmate + activity gate |
| Hard dual-key (no suggestion without rite) | Rejected for V1 — too brittle with thin ceremony/Gora stubs |
| Discord verify / API | Out of scope |
| Auto guild promote | Still never |

---

## 3. Ladder eligibility model

Church titles remain a **live roster mirror** (`rankIndex` → Church id). Standing never writes titles.

| Rank | Standing | Rite / soft gate | Suggested from points? |
|------|----------|------------------|------------------------|
| Fresh Beef | 0 | None | — (default) |
| Cooked Beef | Early threshold | Narrative only: addon use is how standing starts — **no machine checklist** | Yes |
| Beef Knight | Threshold | Knighting expected; checklist on suggestion | Yes |
| Beef Lord | Threshold | Gora win vs Beef Lord expected; checklist | Yes |
| Beef Butcher | Capstone threshold | None (pure standing) | Yes |
| Beef Council | — | Prophet appoints (policy) | Never |
| Beef Prophet | — | Unique GM seat | Never |

### 3.1 Suggestion rules (Approach 1)

- Crossing the next **point-driven** threshold enqueues a promote suggestion (unchanged trigger).
- **Only Knight and Lord** suggestion rows include an eligibility checklist:
  - `standingMet` (always true at enqueue time)
  - `riteMet` (`knighted` or `goraLordWin`)
- Missing rite does **not** suppress the row; Officer copy warns and coaches.
- Cooked and Butcher suggestions are standing-only (no rite checklist). Cooked’s “addon on-ramp” is product story + the fact that standing only accrues on clients running the addon — not a separate flag officers must verify.
- Council/Prophet never appear from points.

### 3.2 Officer queue UX

- Actions remain: **Dismiss** + standing correction; promote in Blizzard guild UI.
- Knight row copy (intent): “Promote *Name* to Beef Knight in the guild roster. Standing met. Knighting: yes/no.”
- Lord row copy (intent): “… Gora win vs Lord: yes/no.”
- Council tooling copy: “Beef Council seats are appointed by the Beef Prophet.”
- No new Approve/Commit path; roster-backed amendment stands.

---

## 4. Standing sources (intent)

Exact weights/caps stay tunable in machine data after playtest. Product intent:

| Source | Intent |
|--------|--------|
| Dungeon / BG co-play | Early flock drip; combat-gated buckets; completion bonus when reliable |
| Raid co-play | **Heavy** toward Butcher capstone; stronger night/completion intent |
| Quest fellowship | Medium-small drip in a party with ≥1 guildmate; bucket pays only with recent combat or quest turn-in; **strict daily/weekly cap** below instance/raid so questing cannot outpace raid to Butcher; no city/idle pay |
| Ceremony | Medium flat on close; Knighting also sets `knighted` on the honoree |
| Beef Gora | Win > draw > loss-still-pays; win vs opponent mapped to Beef Lord sets `goraLordWin` on winner |

### 4.1 Addon as early hook (replaces Discord gate)

- Using the addon is sufficient to begin accruing standing (implicit). That is the V1 on-ramp.
- **One-time “digital flock” grant:** deferred — post-playtest option only. Not in the first implementation slice; Cooked eligibility is standing threshold alone.
- Discord remains culture/onboarding outside the addon, not a checklist field in V1.

### 4.2 Capstone pacing (product rule)

- Cooked: fast (first real guild night with the addon).
- Knight/Lord: cultural stretch — standing unlocks the suggestion; the expected rite is what officers wait for before promoting (checklist coaches; does **not** dual-key enqueue).
- Butcher: rare guild capstone via sustained loyalty, especially raid — not one lucky week.

---

## 5. Rite flags (data intent)

Local standing / suggestion store gains soft flags (names illustrative):

| Flag | Set when | Used for |
|------|----------|----------|
| `knighted` | Officer closes Knighting ceremony with honoree marked | Knight checklist |
| `goraLordWin` | Gora result: winner beats opponent whose roster-mapped title is Beef Lord | Lord checklist |

- Flags are **advisory** (same trust model as standing): officer judgment remains the gate.
- Clearing/correcting flags is an Officer+ standing-correction adjacent action (or re-run rite) — exact UI can land with implementation plan.
- Flags do not invent Church titles; roster remains authority.

---

## 6. Authority unchanged

| Truth | Source |
|-------|--------|
| Church title | Live guild roster map |
| Standing, suggestions, rite flags | SavedVariables / Core |
| Council/Prophet policy | Soft product rules + UI copy; cannot block Blizzard promotes |

---

## 7. Out of scope

- Hard-blocking Blizzard guild promotes/demotes
- Discord join verification
- Auto guild promote/demote APIs
- Full Gora spectacle / ceremonial dashboard theater
- Claiming V1 complete or **POLISH:PASS**

---

## 8. Implementation slices (for later plan)

1. This amendment + `docs/canon/ranks.md`; parent design §4/§7 body marked superseded where roster-backed + this doc win.
2. Data: rite flags on standing records; suggestion payload checklist fields (Knight/Lord only).
3. Scoring: raid weight-up; quest fellowship buckets + caps. (No digital-flock grant in first slice.)
4. Ceremony/Gora thin hooks set rite flags. Knighting = thin ceremony type (or ceremony + honoree mark); Officer+ may run the stub; social expectation is Prophet-led nights.
5. Officer/Standing UI: checklist + Prophet-only Council messaging.
6. Offline tests for suggestion checklist math; in-game smoke for ceremony/Gora/quest paths.

---

## 9. Success criteria (design)

1. Officers can see Knight/Lord suggestions with standing + rite status without the missing rite hiding loyalty.
2. Cooked does not require Discord in product copy or checklist.
3. Butcher remains reachable by standing alone; raid is the intended main fuel.
4. Quest fellowship can grant capped standing with a guildmate under activity gates.
5. Council/Prophet never suggested from points; Council copy names the Prophet as appointer.
6. Roster-backed promote path unchanged (no `RANK_COMMIT` authority revival).

---

## 10. Open questions

1. **Quest activity signal on Anniversary.** Prefer quest turn-in events and/or combat-in-bucket without CLEU scoring registration if still banned — validate in playtest; drop quest turn-in if flaky and keep combat-gated party drip only.
2. **Who may start Knighting.** Prophet-only vs any Officer+ for the ceremony stub (policy). Default proposal: Officer+ may run the thin ceremony; social expectation is Prophet-led nights.
3. **Gora opponent must be Lord at record time.** If opponent was demoted before record, flag does not set — acceptable.
4. **Threshold retune** after first instrumented night with raid + quest weights live.
