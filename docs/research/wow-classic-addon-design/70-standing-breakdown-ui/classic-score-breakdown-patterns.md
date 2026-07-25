# Classic & social-score “why I have N” patterns

**Track:** 70 · **Scope:** Personal score / progress UIs in the Classic ecosystem (and close cousins) that explain contribution without opening a loot spreadsheet.  
**Not in scope:** Guild-wide ranking boards ([26](../26-ladders-points-gamification/)); full Attune/Gargul tear-downs ([13](../13-cousin-addon-teardowns/)).

## Spec / plan anchor

My Standing must show **points, next threshold, recent contributing events** ([spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). Officers reviewing a suggestion also need **point breakdown + recent events** ([§7.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). Plan Task 8: standing, current title, next point-driven threshold, last ~10 grant lines.

---

## Pattern library (steal / adapt / avoid)

### 1. Blizzard reputation — named standing + bounded progress

**Shape:** Faction has a **named standing** (Hostile → Exalted) and a **progress window inside that standing** (current value between min/max for the tier). Players can “watch” a faction so a compact bar shows name, standing, and fill toward the next tier ([Reputation — Warcraft Wiki](https://warcraft.wiki.gg/wiki/Reputation); watched API returns name, standing id, min, max, value — [GetWatchedFactionInfo](https://warcraft.wiki.gg/wiki/API_GetWatchedFactionInfo)).

| Steal | Avoid |
|-------|-------|
| Named tier is primary; number supports it | Exposing every faction as a dense table on first open |
| Determinate “how far through this band” | Hiding the next threshold until hover-only |
| Compact watched bar as *secondary* chrome | Treating the bar as a combat HUD |

**Beef map:** Title = standing name; standing points = value; next rank threshold = max of current band (for ranks 1–5). Vocabulary stays **standing**, not “rep” ([53](../53-beef-lore-ui-bible/)).

### 2. Attune — personal “where / next / evidence”

**Shape:** Personal attunement **tree**: current step, next objectives, hover tooltips for requirements; guild survey is a *separate* table ([Arcane Intellect spotlight](https://arcaneintellect.com/attune-world-of-warcraft-wow-tbc-addon-spotlight/); [forum intro](https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832); tear-down [13/attune](../13-cousin-addon-teardowns/attune.md)).

| Steal | Avoid |
|-------|-------|
| Split **my progress** from **group board** | Merging survey-density into My Standing |
| “What’s next” as first-class | Questie-like pin spam for every grant |
| Celebrate completion events, not every micro-step | Per-drip guild chat |

**Beef map:** My Standing ≈ Attune personal tree (flattened to summary + list). Ladder ≈ guild summary. Officer ≈ human gate Attune never had.

### 3. HonorSpy — “estimate my progress” without owning the board

**Shape:** Collects honor/rank standings; estimates **your** onward RP/rank/progress; minimap right-click estimates without opening the full table; `/hs search` for one player ([HonorSpy README](https://github.com/kakysha/HonorSpy)).

| Steal | Avoid |
|-------|-------|
| Personal progress estimate as a first-class action | Making the full standings table the default My Standing view |
| Glance path (minimap / short report) | Weekly-rank anxiety chrome as comedy UI |

**Beef map:** My Standing defaults to **self**; ladder owns the social board. Optional later: “nearest rivals” is track-26 territory, not V1 Standing chrome.

### 4. CEPGP Standings Tracker — dated change log (the good slice of EPGP)

**Shape:** Plugin tracks EP/GP **changes** and shows a **date-ordered window** from a name click — not the main standings matrix ([CEPGP Standings Tracker](https://www.curseforge.com/wow/addons/cepgp-standings-tracker)).

| Steal | Avoid |
|-------|-------|
| Chronological contribution history | Full CEPGP guild grid as My Standing |
| Per-player drill-down for officers | Officer-notes as Beef’s system of record |

**Beef map:** Recent events list = Standings Tracker energy. CEPGP main window = anti-pattern ([density-antipatterns.md](density-antipatterns.md)).

### 5. Duel / rivalry logs — story lines with opponents

**Shape:** Personal W/L memory vs opponents (DuelBook / duel-tracker demand — summarized in [26 classic fun-score](../26-ladders-points-gamification/classic-guild-fun-score-systems.md)).

| Steal | Avoid |
|-------|-------|
| Gora lines name opponent + outcome | Elo column on My Standing |
| Losses still appear (participation story) | Only showing wins |

**Beef map:** Gora history lines are rivalry biography, not a second ladder.

---

## Shared “why N” recipe (cross-cousin)

Successful personal score UIs converge on:

1. **Identity line** — who I am in the system (title / standing name).  
2. **Magnitude** — one primary number (standing / points).  
3. **Next gate** — explicit distance to the next named tier (or “no grind gate”).  
4. **Attribution** — recent lines tagged by source.  
5. **Cap honesty** (when relevant) — today’s remaining room so “why didn’t I get more?” is answerable.

Beef V1 already locks 1–4 in spec/plan; cap honesty is a cheap chip footer (see [source-chips.md](source-chips.md)).

---

## Relation to officer breakdown

§7.3 officer view reuses the **same attribution model** (standing + recent events), not a second spreadsheet language. Officer tab may show a denser one-row summary; My Standing stays the member-facing story. Approve/reject chrome stays in [40](../40-officer-moderation-audit/).
