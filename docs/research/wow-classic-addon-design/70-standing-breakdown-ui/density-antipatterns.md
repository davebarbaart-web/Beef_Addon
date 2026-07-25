# Density anti-patterns (DKP / EPGP / meters)

**Track:** 70 · **Scope:** What “spreadsheet standing” looks like in Classic guild tools — and concrete refusals for My Standing.  
**Companion:** Fun-score vs loot economies context in [26](../26-ladders-points-gamification/classic-guild-fun-score-systems.md) (do not re-litigate seasons/toxicity here).

## Why this matters

Spec wants transparency (“why these points”) **and** comedy readability. Loot systems solved transparency by shipping **accountant UIs**. Church of Beef fails if My Standing becomes CEPGP-with-jokes.

Cross-library consensus already flags this:

- Auction-density columns are an anti-pattern for standing history ([01](../01-ux-patterns/church-of-beef-synthesis.md), [02](../02-visual-language/03-steal-adapt-matrix.md)).  
- Officer breakdown = short event list, not Details! ([02/addon-roster](../02-visual-language/02-addon-roster.md)).  
- Steal officer transparency; avoid loot-economy gravity ([26/copy-avoid](../26-ladders-points-gamification/beef-copy-avoid.md)).

---

## Anti-pattern catalog

### 1. Full guild points matrix as “my” view

**Seen in:** CEPGP / EPGP Classic standings windows — every member’s EP, GP, PR, sorts, officer-note backing ([CEPGP listing](https://www.wowinterface.com/downloads/info25051-CEPGP.html); [EPGP wiki](https://wowpedia.fandom.com/wiki/EPGP)).

**Refuse:** My Standing never lists the guild. That is the Ladder tab (titles, not PR).

### 2. Multi-currency columns

**Seen in:** EP vs GP vs Priority; DKP earned vs spent vs current.

**Refuse:** One currency — **standing**. Caps are footnotes on source chips, not parallel currencies.

### 3. Sortable history spreadsheet

**Seen in:** Raid trackers / attendance exports with date, boss, attendance %, bonus DKP, notes.

**Refuse:** Fixed reverse-chronology list, ~10 lines, no column headers for “GP,” “ratio,” “decay.”

### 4. Meter / graph essays

**Seen in:** Details!-style breakdown panes; pie charts of damage that players fake for social scores.

**Refuse:** No pie of sources, no stacked bar of lifetime composition in V1. Three chips + lines suffice.

### 5. External site as the readable UI

**Seen in:** OpenDKP / guild bank export sites; Attune optional website upload ([13/attune](../13-cousin-addon-teardowns/attune.md)).

**Refuse:** My Standing must be complete **in-game**. No “open the website to see why.”

### 6. Fake unit-frame / XP metaphors

**Seen in:** Standing drawn as health bar, castbar skin, or ElvUI XP bar clone ([02](../02-visual-language/03-steal-adapt-matrix.md)).

**Refuse:** Optional thin StatusBar only; title + remaining text remain primary.

---

## Density budget (My Standing V1)

| Allowed | Count |
|---------|------:|
| Hero title + standing number | 1 block |
| Next-threshold line | 1 |
| Source badges | 3 |
| History rows | ~10 visible (ring ≤20) |
| Status / petition / sync footer | 1 line |
| Action buttons | 0 on this tab (officer lives elsewhere) |

If a design proposal needs a horizontal scrollbar or “more columns,” it is already wrong.

---

## What *good* density looks like (positive examples)

| Cousin | Dense thing they do | Thin thing to steal |
|--------|---------------------|---------------------|
| Attune personal tree | Full quest graph | “You are here / next” |
| CEPGP Standings Tracker | Plugin on top of EPGP | Date-ordered personal change log |
| Reputation watched bar | Character sheet list | One watched summary |
| HonorSpy | Full standings table | Personal estimate / search-one |

---

## Officer exception (still not a spreadsheet)

Officers need enough evidence to laugh at implausible testimony ([§6.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). That is:

- Standing total  
- Suggested from→to  
- Same source-tagged recent events  

Not: EP decay simulator, attendance %, or multi-raid ledger. If officers demand more later, add **one** tooltip or “show more history” expand — not new columns.
