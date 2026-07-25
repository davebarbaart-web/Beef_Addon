# Source chips for standing attribution

**Track:** 70 · **Scope:** How to label the three V1 standing sources on My Standing (and officer breakdown) without inventing a filter dashboard.  
**Product truth:** Sources = Shared instance · Ceremony · Beef Gora ([spec §7.1](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)); per-day caps per source ([§7.2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

## Chip / badge / tag language (UX)

Industry pattern guidance separates:

| Control | Role | Beef use |
|---------|------|----------|
| **Badge** | Static status / category label | **V1 default** — source on summary + history lines |
| **Chip / filter chip** | Interactive select / filter | Optional V1.1 if history grows noisy |
| **Tag** | Metadata on an object | Same as badge for Classic FontString UI |
| **Pill** | Often CTA-shaped; easy to overuse | Avoid as primary My Standing chrome |

Sources: [Badges vs chips/tags/pills](https://smart-interface-design-patterns.com/articles/badges-chips-tags-pills/); [Material filter chips](https://m2.material.io/components/chips) (filter semantics — not a V1 requirement).

**Classic reality:** WoW addon UIs rarely ship Material chips. Prefer **colored or bracketed prefixes** on FontStrings (`[Instance]`, `[Ceremony]`, `[Gora]`) or small textured icons if media pack allows later ([44](../44-custom-textures-media-packaging/)). Do not block V1 on custom chip art.

---

## V1 source set (closed)

| Source id | Member-facing label | History line verb sketch | Cap note |
|-----------|---------------------|--------------------------|----------|
| `instance` | Instance | “Shared dungeon/raid/BG with guildmate” | Daily drip + completion; show remaining if capped |
| `ceremony` | Ceremony | “Ceremony credit” | Flat grant when officer closes |
| `gora` | Gora | “Gora vs Name — win/loss/draw” | Losses pay (spec §7.1) |

Do **not** invent extra chips for officer adjust / wipe on the member summary as “sources that earn standing.” Manual corrections can appear as history lines tagged `[Officer]` (status badge), distinct from the three earning channels.

---

## Where chips appear

### A. Summary strip (always visible)

Three compact badges under the standing header:

```text
Instance  ·  Ceremony  ·  Gora
  +12/40     +0/…        +5/…
```

Numbers = **today granted / today cap** (or “—” if uncapped). This answers “why didn’t instance pay?” without opening a spreadsheet.

If caps are not yet exposed in UI data, ship labels only in V1 and add today/cap in the same slots later — do not redesign the strip.

### B. Recent events list (every row)

Each grant line starts with the source badge, then plain language:

```text
[Instance]  +3  ·  Shadow Labyrinth (combat bucket)
[Gora]      +2  ·  vs BeefKnight — loss (showed up)
[Ceremony]  +10 ·  Sunday Rite
```

### C. Officer suggestion breakdown

Reuse the same three badges + last N lines. Officers should not learn a parallel taxonomy ([40](../40-officer-moderation-audit/)).

---

## Interaction policy

| Mode | V1 | Later |
|------|----|-------|
| Static badges | **Yes** | — |
| Click chip to filter history | **No** (three sources × ~10 lines is scannable) | Optional if ring buffer grows |
| Multi-select filters | **No** | Avoid unless history becomes a log browser |
| Color-only meaning | Prefer badge **text** + optional tint | Colorblind: never color alone ([23](../23-color-brand-tokens/)) |

---

## Anti-patterns

| Anti-pattern | Why it fails |
|--------------|--------------|
| One column per source × day × instance | Auctionator / CEPGP density |
| Pie chart of standing composition | Wrong Classic chrome; meter energy |
| Source chips in guild chat | Spectacle stays promote/demote lines ([§10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| “XP from quests / kills / explores” open taxonomy | Spec locks three sources |
| Chip row that wraps into a second toolbar | Header must stay one glance |

---

## Copy guardrails

- Say **standing**, not DKP/EP/XP/elo ([53](../53-beef-lore-ui-bible/)).  
- Source labels stay secular-short on chips; liturgy belongs in titles / announces, not every drip.  
- Cap-hit line idea: “Instance standing capped for today” as a single history or footer note — not a modal.
