# 43 — Canon lore presentation UX (in-addon)

**Audience:** Coding agents polishing Church of Beef UI copy, tooltips, footers, and empty states.  
**Last updated:** 2026-07-26  
**Status:** Research / design synthesis for polish — **not** product law. Locked decisions stay in the [design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md) §3.2–§5 / §10 / §15 and [glossary 74](../wow-classic-addon-design/74-v1-decision-glossary/locked-v1-decisions.md).  
**Deep tracks:** [53 lore bible](../wow-classic-addon-design/53-beef-lore-ui-bible/), [32 microcopy](../wow-classic-addon-design/32-microcopy-tone-voice/), [70 standing UI](../wow-classic-addon-design/70-standing-breakdown-ui/), rule [`canon-data.mdc`](../../../.cursor/rules/canon-data.mdc).  
**Prose source today:** [`docs/canon/ranks.md`](../../canon/ranks.md).  
**Machine source:** [`addon/ChurchOfBeef/Data/Ranks.lua`](../../../addon/ChurchOfBeef/Data/Ranks.lua).

Research scrapes (`.firecrawl/`, `**/.raw/`) are **not** product truth.

---

## 1. Executive rules (read first)

1. **Two canons, one join.** Numbers/titles/kinds live only in `Data/Ranks.lua` (`COB.Ranks`). Flavor prose lives in `docs/canon/` (authoring) and, when shipped, a **prose-only** in-addon table (e.g. `Data/Lore.lua` → `COB.Lore`). UI **joins** them at paint time; it never forks thresholds into strings.
2. **`docs/canon/` is not loadable.** TOC can only load files under `addon/ChurchOfBeef/`. Repo lore docs guide authors; the client never `dofile`s `docs/`.
3. **V1 lore budget is thin.** Spec §3.2 / §10: one-line scripture footer placeholder + short rank glosses. No multi-page Beef Bible, confessions feed, or scripture novel in V1.
4. **Brand is in the words.** Classic Blizzard chrome stays; Church voice carries identity (see [UI brief](../../superpowers/ui-polished-direction-for-agents.md)).
5. **Speak as a church that means it.** The world is funny; the narrator is not winking every sentence.
6. **Doctrine tripwires are instant rewrites** — auto-promote fantasy, grind-to-Council, protocol liturgy, cross-realm church, alt-merge, decay that does not exist (§7).

---

## 2. Dual-source model (no number drift)

```text
┌─────────────────────┐     ┌──────────────────────────┐
│ docs/canon/*.md     │     │ Data/Ranks.lua           │
│ (repo authoring)    │     │ titles, thresholds,      │
│ prose only          │     │ seats, kinds, officer max│
└─────────┬───────────┘     └────────────┬─────────────┘
          │ excerpt / sync                │ COB.Ranks.*
          ▼                               ▼
┌─────────────────────┐     ┌──────────────────────────┐
│ Data/Lore.lua       │────▶│ UI paint / format        │
│ (optional V1 ship)  │ join│ "M to {Title}"           │
│ gloss, footer lines │     │ never hardcode 50/200/…  │
└─────────────────────┘     └──────────────────────────┘
```

| Concern | Owner | Example |
|---------|-------|---------|
| Rank id / title / threshold / kind | `COB.Ranks` | `Title(3)` → `"Beef Knight"`; `Threshold(3)` → `200` |
| Council seat count / Prophet uniqueness | `COB.Ranks` | `CouncilSeats`, `ProphetUnique` |
| Officer rank-index gate | `COB.Ranks` | `OfficerRankIndexMax` |
| Rank fantasy paragraph | `docs/canon/` → optional `COB.Lore` | “Sworn to the plate…” |
| UI gloss (≤ ~8 words) | Lore table or string bank | “Sworn blade of the Church” |
| Scripture footer line | Lore / constants | One rotating or static line |
| Progress readout | **Format at runtime** | `string.format("%d to %s", need, COB.Ranks.Title(nextId))` |

### Forbidden patterns

```lua
-- ❌ Number inside lore / UI constant
local GLOSS = "Reach 50 standing for Cooked Beef."

-- ❌ Title paraphrase
font:SetText("Knight of Beef")

-- ❌ Fake clergy grind
font:SetText("1000 more to unlock Beef Council")
```

```lua
-- ✅ Join machine + prose
local title = COB.Ranks.Title(rankId)
local gloss = COB.Lore and COB.Lore.Gloss(rankId) -- prose only
local need  = nextThreshold - standing            -- from COB.Ranks.Threshold
line:SetText(string.format("%d to %s", need, nextTitle))
```

### Authorship workflow

| Step | Who | Rule |
|------|-----|------|
| Change a threshold / seat / title | Edit `Data/Ranks.lua` + tests | Never edit `docs/canon/` to “match” a number |
| Change fantasy prose | Edit `docs/canon/ranks.md` | If a digit appears, delete it |
| Ship gloss in-client | Copy **shortened** prose into `Data/Lore.lua` (or string table) | Still no digits; key by `rankId` |
| Retune after playtest | `Ranks.lua` only | Lore paragraphs should still read true without numbers |

`docs/canon/ranks.md` already states the drift rule; keep that file as the long-form authoring surface. In-addon strings are **excerpts**, not a second novel.

---

## 3. Where lore surfaces (V1 vs later)

### V1 — allowed surfaces

| Surface | Lore role | Register | Length |
|---------|-----------|----------|--------|
| Ladder row title | Exact `COB.Ranks.Title` | Sacred | Fixed |
| Ladder row tier chip | “Earned” / “Appointed” / “Bestowed” | Office-plain | 1 word family |
| Ladder / title tooltip | One gloss from canon (1 sentence or ≤ ~12 words) | Sacred / flock | Short |
| My Standing hero title | Exact title | Sacred | Fixed |
| My Standing progress | Runtime remaining + next title | Procedural + sacred object | `"N standing"` / `"M to {Title}"` |
| My Standing appointed ceiling | Honest non-grind copy | Procedural + doctrine | “Appointed ranks only” / “Bestowed — not grindable” |
| Frame footer | One scripture line (placeholder OK) | Sacred | ≤ ~80 chars |
| Guild-chat commit | Liturgy template + title slot | Sacred | One sentence, ~80–140 chars (hard ≤ 255) |
| Private toast (rank change) | Title as hero; short receipt | Sacred + light Church | ≤ ~60 chars |
| Empty states | Soft Church OK | Flock / soft | One sentence |
| TOC Notes / about | Brand pitch | Brand | Short |

### V1 — do **not** ship

| Surface | Why |
|---------|-----|
| Multi-tab Scripture / Beef Bible | Deferred §3.2 |
| Per-event liturgical sermons on every standing drip | Noise; standing log stays plain |
| Lore paragraphs on Officer Approve/Reject | Officers need procedural trust |
| Joke lines on sync / permission errors | Trust burn |
| Hardcoded threshold tables in Settings “About” | Drift magnet — link mentally to machine canon, or show live `Threshold` values only |

### Post-V1 (orientation only)

Richer scripture rotation, ceremonial dashboard, confessions feed — still join `COB.Ranks` for any numeric claim. Never backfill numbers into `docs/canon/`.

---

## 4. Presentation patterns (join recipes)

### 4.1 Rank tooltip / Ladder hover

```text
{Title}                          ← COB.Ranks.Title(id)
{Tier label}                     ← from kind: Earned | Appointed | Bestowed
{Gloss}                          ← COB.Lore.Gloss(id) or excerpt from docs/canon
{Optional progress}              ← only if kind == "points" AND viewing self/context needs it
```

**Gloss source priority:** in-addon `COB.Lore` short string → fallback to title alone. Do not paste the full `docs/canon` paragraph into a tooltip in V1 (too long for Classic tooltips; skim dies).

Recommended gloss length: **one clause**, aligned to [rank-titles-lore](../wow-classic-addon-design/53-beef-lore-ui-bible/rank-titles-lore.md) “UI gloss” field. Full paragraphs stay in repo canon for humans and future lore UI.

| Rank | Suggested V1 gloss (prose; no numbers) |
|------|----------------------------------------|
| Fresh Beef | New to the Church — the flesh proves itself anew. |
| Cooked Beef | First heat applied; the flock has noticed. |
| Beef Knight | Sworn to the plate; reliably present. |
| Beef Lord | Pillar of many nights, not one lucky week. |
| Beef Butcher | Apex of earned standing — the grind climbs no higher. |
| Beef Council | Seated clergy — appointment only. |
| Beef Prophet | Anointed by decree — not grindable. |

### 4.2 My Standing progress (numbers from machine only)

| Band | Copy pattern | Data |
|------|--------------|------|
| Point-driven, below next threshold | `{S} standing` + `{M} to {NextTitle}` | `S` local; `M = Threshold(next) - S`; titles from `COB.Ranks` |
| Point-driven, eligible / pending | Same standing line + “Suggestion pending officers” | Ladder suggestion state |
| At Beef Butcher (apex earned) | Standing + “Appointed ranks only” (or equivalent) | No fake next threshold |
| Council / Prophet | Title + “Bestowed — not grindable” / seat scarcity line | Seats from `COB.Ranks.CouncilSeats` **formatted live** if shown |

Seat scarcity example (if UI shows occupancy):

```lua
-- ✅ Live format — seat count never baked into lore markdown
string.format("Beef Council · %d of %d seats", occupied, COB.Ranks.CouncilSeats)
```

### 4.3 Scripture footer

Spec allows **one line**. Treat as atmosphere, not instruction.

| Do | Don’t |
|----|-------|
| Static or rare-rotate line from a tiny pool | Cycle every frame / OnUpdate |
| Proper nouns: Church, Eternal Grazing, Beef God (rare) | Fake Latin walls |
| Deadpan | Meme of the week |
| Optional; frame works if omitted | Block V1 on lore completeness |

Sample pool (placeholders — tune in playtest):

- The Church keeps the ledger; the officers keep the faith.
- Standing is testimony. Elevation is decree.
- Eternal Grazing awaits the devoted — and the amusing.
- The ladder is flesh; the word that raises it is Officer.

### 4.4 Empty & edge (lore-soft, rule-clear)

| State | Preferred line |
|-------|----------------|
| Not in guild | You are outside the flock. Join a guild to earn standing. |
| Not officer | Officer tools require a guild Officer+ rank. |
| No suggestions | No pending suggestions. |
| Alt / fresh character | This character begins as Fresh Beef. The flesh must prove itself anew. |
| Appointed-only progress | Appointed ranks only — officers seat and anoint. |

Clarity beats cleverness when the player is stuck. Sacred garnish is allowed **after** the actionable fact.

---

## 5. Microcopy guidelines (Church brand voice)

Distilled for agents. Full craft: [32 beef-copy-guidelines](../wow-classic-addon-design/32-microcopy-tone-voice/beef-copy-guidelines.md). Lexicon: [53 sacred-profane](../wow-classic-addon-design/53-beef-lore-ui-bible/sacred-profane-vocabulary.md).

### 5.1 North star

**Speak as a church that means it.**  
Absurd premise, sincere delivery. Rank titles carry the joke; system sentences stay dignified.

> Yes: *The Church recognizes Beefina, elevated to Beef Knight.*  
> No: *omg BEEFINA just got KNIGHTED lmao get the steaks*

### 5.2 Four registers

| Register | Surfaces | Humor |
|----------|----------|-------|
| **Sacred** | Guild announce, titles, footer, promote toast title | Deadpan institution |
| **Flock** | Empty states, Gora/ceremony proper names, soft flavor | Low, warm absurdity |
| **Office** | Appoint / Bestow / Demote labels + confirms | None — sacred *object*, plain *verb* |
| **Procedural** | Errors, sync, settings, Approve/Reject | None |

Mixing sacred jokes into procedural errors burns trust. Mixing protocol words (`RANK_COMMIT`, `revision`, prefix `COB`) into flock surfaces burns immersion.

### 5.3 Lexicon cheatsheet

| Prefer | Avoid |
|--------|-------|
| Church / the flock | users, subscribers, players (in liturgy) |
| standing | XP, DKP, elo, level |
| suggestion / eligible | application, unlock, level-up |
| elevate / seat / anoint | promote-to-Council-via-points, unlock Prophet |
| exact titles (`Beef Knight`) | “knight”, “rank 3”, “Knight of Beef” |
| excommunicate (rare, officer) | meme shame in system copy |
| Beef Gora, Ceremony | generic “event #3” |

### 5.4 Grammar of Church voice

1. **Institution first** on public lines: “The Church …” beats “You just …”.
2. **Name second, title last** in announces.
3. **Ceremonial present or simple past:** recognizes / elevated / records — not hype future.
4. **One metaphor per line** — do not stack grill + crusade + sports.
5. **Exact canon titles** — spelling and casing from `Data/Ranks.lua` only.
6. **Hybrid honesty:** thresholds create *eligibility*; officers create *truth*.

### 5.5 Surface length budgets

| Surface | Budget |
|---------|--------|
| Guild announce | ~80–140 chars skim; hard ≤ 255 |
| Toast | ≤ ~60 chars / 6–12 words; one humor beat max |
| Tooltip gloss | One sentence or ≤ ~12 words |
| Footer | One line ≤ ~80 chars |
| Officer label | 1–3 words |
| Error | Cause + next step; zero jokes |

### 5.6 Sample bank (join-ready)

**Announces** (title slot = `COB.Ranks.Title`):

| Event | Line |
|-------|------|
| Elevate 1–5 | The Church recognizes {name}, elevated to {title}. |
| Demote | The Church records the fall of {name}, returned to {title}. |
| Excommunicate | The Church excommunicates {name}, cast down to {title}. |
| Council | The Church seats {name} upon the Beef Council. |
| Prophet | The Church anoints {name} as Beef Prophet. |

**Toasts:**

| Event | Line |
|-------|------|
| Suggestion | Standing recognized — {title} suggested. |
| Approved (self) | Elevated to {title}. |
| Ceremony | Ceremony marked. Standing +{n}. |
| Gora | Beef Gora recorded. Standing +{n}. |

`+{n}` is a **live grant amount** from Scoring — not a threshold from lore docs.

**Officer confirms** (procedural + consequence):

| Action | Line |
|--------|------|
| Approve | Approve elevation of {name} to {title}? Announces to guild chat. |
| Reject | Reject suggestion for {name}? No guild announcement. |
| Demote | Demote {name} to {title}? This cannot be undone except by a later promotion. |
| Council | Appoint {name} to the Beef Council? |
| Prophet | Bestow Beef Prophet upon {name}? |

### 5.7 Writing checklist (PR / string pass)

- [ ] Flock-facing? Liturgical deadpan — not meme slang.
- [ ] Officer-facing? Would a serious loot-council addon ship this label?
- [ ] Announce / toast within budgets.
- [ ] Errors have zero jokes.
- [ ] Confirms name the irreversible verb + announce side effect.
- [ ] Titles match `Data/Ranks.lua` exactly.
- [ ] No digits that encode thresholds/seats/officer gate — format from `COB.Ranks` instead.
- [ ] No BeefNet/protocol leakage on flock surfaces.
- [ ] No “points to Council/Prophet,” auto-promote, alt-merge, or decay implications.
- [ ] Reject path stays quiet in guild chat.

---

## 6. Suggested in-addon shape (when implementing)

Not required to invent a new top-level package — prefer extending `Data/` per architecture rules.

```lua
-- Data/Lore.lua (illustrative) — PROSE ONLY
ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

COB.Lore = {
  -- keyed by rank id; never store threshold/seats here
  Gloss = {
    [1] = "New to the Church — the flesh proves itself anew.",
    [2] = "First heat applied; the flock has noticed.",
    -- …
  },
  Footer = {
    "Standing is testimony. Elevation is decree.",
  },
}

function COB.Lore.GetGloss(rankId)
  return COB.Lore.Gloss[rankId]
end
```

| Layer | May read Lore? | May read Ranks numbers? |
|-------|----------------|-------------------------|
| UI | Yes | Yes (display only) |
| Core | No need | Yes |
| Net | No | No inventing ranks |
| Data/Lore | — | **Never** duplicate Ranks fields |

TOC: list `Data/Lore.lua` only after the file exists; keep load order `Data → Core → …`.

**Sync rule for agents:** when editing `docs/canon/ranks.md`, update in-addon glosses in the same change if they diverge in meaning — but still leave all figures in `Ranks.lua`.

---

## 7. Doctrine tripwires (instant rewrite)

If a draft string does any of the following, rewrite before ship:

1. **Auto-promote fantasy** — implies title without officer Commit.
2. **Clergy-by-grind** — points path to Council or Prophet.
3. **Hardcoded policy numbers** — `50`, `200`, `500`, `1000`, seat `4`, officer index `1` inside lore/markdown/UI constants (show live via `COB.Ranks` if needed).
4. **Protocol liturgy** — `RANK_COMMIT`, revision, prefix dumps in flock UI.
5. **Cross-church state** — one Prophet/ladder across Dreamscythe and Doomhowl.
6. **Alt merge** — main’s title applies to alts (V1 false).
7. **Decay** — standing rotting (V1 false).
8. **Combat assistance** — sounds like a raid/DPS tool.

---

## 8. Relationship to other docs

| Doc | Use for |
|-----|---------|
| Spec §3.2–§5, §10 | Product scope (footer vs full scripture) |
| `docs/canon/ranks.md` | Long-form prose authoring |
| `Data/Ranks.lua` | Machine truth |
| Track [53](../wow-classic-addon-design/53-beef-lore-ui-bible/) | Lexicon, title theology, string do/don’t |
| Track [32](../wow-classic-addon-design/32-microcopy-tone-voice/) | Length, humor craft, announce templates |
| Track [70](../wow-classic-addon-design/70-standing-breakdown-ui/) | Progress-to-next presentation |
| [UI brief](../../superpowers/ui-polished-direction-for-agents.md) | Chrome vs words doctrine |

---

## 9. Agent verdict

**Ship thin sacred chrome:** exact titles from `COB.Ranks`, short glosses excerpted from `docs/canon`, one footer line, liturgy only on commits/toasts. **Format every number at runtime from machine canon.** Keep officer and error surfaces procedural. That preserves Church brand voice without ever duplicating thresholds from `Data/Ranks.lua`.
