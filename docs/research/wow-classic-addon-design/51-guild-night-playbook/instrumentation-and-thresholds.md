# Instrumentation & threshold retune sheet

**Track:** [51-guild-night-playbook](README.md)  
**Last updated:** 2026-07-25  
**Replaces after playtest:** design spec §4.2 draft thresholds (and optionally §7 weight sketches)

Draft scaffolding (do not treat as sacred):

| Title | Standing to become suggestion-eligible |
|-------|----------------------------------------|
| Fresh Beef | 0 |
| Cooked Beef | 50 |
| Beef Knight | 200 |
| Beef Lord | 500 |
| Beef Butcher | 1000 |
| Beef Council / Prophet | appointed / bestowed — **out of threshold math** |

**Pacing rule (locked intent):** first full dungeon night with guildmates → first promotion *suggestion* (Fresh → Cooked).

---

## 1. What this sheet is for

Standing is self-reported advisory testimony; officers are the anti-cheat (spec §6.3). Instrumentation therefore measures **felt pacing and spectacle**, not cryptographic honesty.

You are answering:

1. Was Cooked Beef reachable in one honest co-play night?
2. Did later ranks feel impossibly far or trivially close?
3. Did caps, anti-AFK, or flaky completion detection distort the curve?
4. Which lever to pull: **threshold**, **per-event weight**, **daily cap**, or **process** (more ceremonies/Gora)?

Change **one primary lever** per debrief unless data clearly implicates two.

---

## 2. Cohort tags (fill before night)

Tag each observed character (3–8 is enough; prefer diversity over census):

| Tag | Meaning |
|-----|---------|
| `NEW` | Fresh Beef, first serious night with addon |
| `VET` | Already active guildmate, starting Fresh for playtest |
| `ALT` | Alt on same account (expect separate ladder) |
| `OFF` | Officer (may spend less time in instances) |
| `NOADDON` | Present in content, no Beef — control for chat spectacle only |

Record: character, guild (Dreamscythe / Doomhowl), build id/zip label, officer-index setting.

---

## 3. Per-member log (copy rows as needed)

Fill at night start, mid, and end (or after each major activity block).

| Field | Why |
|-------|-----|
| Character + tag | Cohort |
| Official rank id / title | Ladder truth after commits |
| Local standing (start / end) | Gross progress |
| Standing Δ total | Night yield |
| Δ from instance drip | Source mix |
| Δ from completion bonuses | Flaky API watch (§16.4) |
| Δ from ceremony | Flat-grant feel |
| Δ from Gora win / loss / draw | Loss-must-pay check |
| Buckets that paid vs denied (AFK) | Anti-AFK validation |
| Hit daily cap? (Y/N, which source) | Cap tuning |
| Suggestion fired? (rank → rank, time) | Threshold proximity |
| Officer action (approve / reject / defer) + reason | Human gate quality |
| Player quote (one line) | “felt fair / too grindy / too fast” |

**Optional if alpha logging exists:** count of `SCORE_EVENT` / `SUGGESTION` / `RANK_COMMIT` / sync frames — bandwidth sanity only; deep CTL math stays in track 14.

---

## 4. Night-level aggregates (Score Desk)

Compute roughly (median is enough; no spreadsheet cult):

| Metric | How | Healthy first-night signal |
|--------|-----|----------------------------|
| `M_new_cooked` | Fraction of `NEW` who became Cooked-eligible (standing ≥ Cooked threshold) | **≈ 0.5–1.0** if they finished a real dungeon block |
| `T_first_suggestion` | Minutes from night start to first suggestion (any member) | Early enough that officers still online |
| `Y_median_new` | Median standing Δ among `NEW` | Near Cooked threshold (e.g. ~40–70 if threshold is 50) |
| `Y_p90` | 90th percentile standing Δ (all tagged) | Should **not** reach Knight (200) for a normal night without stacked Gora/ceremony abuse |
| `Src_mix` | % of total Δ from instance / ceremony / Gora | Instance should dominate unless you ran a ceremony-heavy social night |
| `Cap_hits` | # players who hit a daily cap | 0–few; if many, caps too tight *or* farm exploit |
| `AFK_false_pay` | Reports of points with no combat | Must be **0** |
| `Completion_miss` | Dungeons finished, no completion bonus when expected | Informs §16.4 fallback |
| `Suggest_approve_rate` | Approves / (approves+rejects) | Low rate → thresholds OK but testimony noisy, or culture mismatch |
| `Spectacle_ok` | First announce got a visible reaction | **Required** for §13.11 |

---

## 5. Decision table — retuning §4.2

Use after aggregates exist. Prefer moving **Cooked Beef** first; leave Butcher until the ladder has weeks of life.

| Observation | Likely cause | Preferred lever |
|-------------|--------------|-----------------|
| `M_new_cooked` ≈ 0 and `Y_median_new` ≪ 50 | Weights too low and/or completion never firing | ↑ instance drip or completion bonus; only then ↓ Cooked threshold |
| `M_new_cooked` ≈ 0 but `Y_median_new` ≈ 40–49 | Threshold slightly high vs pacing rule | ↓ Cooked (e.g. 50 → 40) |
| Many `NEW` hit Cooked **and** approach Knight same night | Soft curve | ↑ Knight (and maybe Lord) **or** ↓ drip; keep Cooked hook |
| `Y_p90` ≫ Knight after “normal” play | Farm / stacked stubs / cap hole | Tighten caps / anti-AFK; don’t only raise thresholds |
| Ceremony alone jumps a rank | Ceremony flat grant too fat | ↓ ceremony grant; thresholds untouched |
| Gora losses grant 0 / players dodge | Bug or misconfig | Fix loss payout; cultural, not threshold |
| Suggestions fire but officers reject “too easy” | Social bar > math bar | Keep thresholds; coach approve culture **or** raise threshold intentionally |
| Suggestions never fire but standing crosses draft numbers | Suggestion bug | Engineering fix — not a threshold change |
| Caps hit in first hour | Cap too low for dungeon spam night | ↑ daily instance cap slightly |
| Caps never approached | Caps irrelevant for V1 night | Leave caps; revisit at saturation (§16.3) |

**Council / Prophet:** never “tune” via points. Seat count and uniqueness are leadership decisions (§16.2), not playtest medians.

---

## 6. Worked examples (illustrative)

### 6.1 Hook too weak

- Three `NEW` finish two dungeon runs with guildmates; median Δ = 22; no suggestions.
- **Read:** far below 50 → raise drip/completion before cutting Cooked to 25 (avoid making later ranks trivial by only crushing the first gate).

### 6.2 Hook on target

- Four `NEW`; median Δ = 55; three suggestions; one approve; chat reacts.
- `Y_p90` = 90 (nobody near 200).
- **Read:** keep 50 / 200 / 500 / 1000; ship as V1 defaults until a saturation night.

### 6.3 Soft ladder

- Median `NEW` Δ = 180; two players Knight-eligible same night from instance drip alone.
- **Read:** raise Knight (e.g. 200 → 350) **or** cut drip ~40%; keep Cooked at 50 so the hook remains.

---

## 7. What not to log

| Skip | Why |
|------|-----|
| Full combat log parses | Wrong tool; Beef is social standing, not parse score |
| Calendar RSVP fields | Track 39 / guild process |
| Cross-realm / cross-faction merges | Spec forbids shared state |
| Proof of anti-cheat / SV hashes | Out of design stance §6.3 |
| Every SCORE_EVENT forever in Release | Noise; alpha-only verbose logs if needed |

---

## 8. After retune — verification

1. Update machine canon only in `addon/ChurchOfBeef/Data/Ranks.lua` (and scoring constants if weights change).
2. Do **not** duplicate numbers into `docs/canon/` prose.
3. Run a short smoke (officer + member) before the next guild night.
4. Keep this sheet’s filled copy (Discord paste or private note) as the audit trail for §16.6 closure.
