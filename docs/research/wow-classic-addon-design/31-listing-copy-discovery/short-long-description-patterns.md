# Short & long description patterns (Classic conversion)

**Maps to:** CurseForge/Wago **Summary** (card) + **Description** (project body).

## Platform rules that shape copy

| Rule | Source |
|------|--------|
| Summary = brief purpose/synopsis for listings | [Creating and Submitting a Project](https://support.curseforge.com/en/support/solutions/articles/9000197241-creating-and-submitting-a-project); [Best Project Page](https://blog.curseforge.com/how-to-create-the-best-project-page/) |
| Description must include **functional** what-it-adds/changes; storytelling OK but not instead of facts | [Best Project Page](https://blog.curseforge.com/how-to-create-the-best-project-page/) |
| Reject generic fluff (“adds items,” “changes the vanilla game”) | [Best Project Page](https://blog.curseforge.com/how-to-create-the-best-project-page/) |
| English, grammatically correct, sufficient detail or reject | [Creating and Submitting a Project](https://support.curseforge.com/en/support/solutions/articles/9000197241-creating-and-submitting-a-project) |
| Description can tell the story / uniqueness; embed media | [Project Submission Guide](https://support.curseforge.com/en/support/solutions/articles/9000199552-project-submission-guide-and-tips) |
| Socials: badge top or links at bottom; don’t overwhelm | [Best Project Page](https://blog.curseforge.com/how-to-create-the-best-project-page/) |
| Cross-host / portfolio links: bottom, reasonable size | [Moderation Policies](https://support.curseforge.com/en/support/solutions/articles/9000197279-moderation-policies) |

## Short summary patterns that convert

Observed winning shapes:

| Shape | Example | Why it works for Classic |
|-------|---------|--------------------------|
| **Job noun + Classic** | Questie: “The Classic Quest Helper” ([Questie](https://www.curseforge.com/wow/addons/questie)) | Instant flavor + job |
| **Job noun only** | Attune: “Attunement progress” ([Attune](https://www.curseforge.com/wow/addons/attune)) | Ultra-scannable card |
| **Feature keyword list** | Gargul summary lists GDKP/TMB/SoftRes/Auto Loot ([Gargul](https://www.curseforge.com/wow/addons/gargul)) | Search-term dense; works when players already know jargon |
| **Category claim** | TRP3: “The best role-playing add-on…” ([Total RP 3](https://www.curseforge.com/wow/addons/total-rp-3)) | Owns niche; weaker for unknown brands |
| **Player-outcome promise** | DBM: fight info “easy to process… what YOU need to do” ([DBM](https://www.curseforge.com/wow/addons/deadly-boss-mods)) | Outcome > feature dump |

**Beef draft Summary (≤ ~120 chars mindset):**  
`Guild standing ladder and officer-approved ranks for Classic — social spectacle, not a combat addon.`  
(or shorter) `Guild rank ladder for TBC Classic Anniversary — officer-approved standing.`

## Long description skeleton (cousin-derived)

High-converting Classic pages share a repeating outline:

1. **Badge / host row** — Install (Wago) · CurseForge · Discord · Patreon ([Gargul](https://www.curseforge.com/wow/addons/gargul)).
2. **One-paragraph pitch** — what + who needs it + flavor support ([Gargul](https://www.curseforge.com/wow/addons/gargul); [Attune](https://www.curseforge.com/wow/addons/attune)).
3. **Audience constraint** — “Only loot master needs it” / “guildies need the addon for survey” ([Gargul](https://www.curseforge.com/wow/addons/gargul); [Attune](https://www.curseforge.com/wow/addons/attune)). Critical for Beef: officer approve vs members; players without addon still see guild chat.
4. **WHAT IT IS FOR** (Attune’s explicit heading) — functional bullets before lore ([Attune](https://www.curseforge.com/wow/addons/attune)).
5. **Feature table or Main features list** — Feature · what · command ([Gargul](https://www.curseforge.com/wow/addons/gargul); [Total RP 3](https://www.curseforge.com/wow/addons/total-rp-3)).
6. **Getting started** — single slash command (`/gl start`, `/attune`) ([Gargul](https://www.curseforge.com/wow/addons/gargul); [Attune](https://www.curseforge.com/wow/addons/attune)).
7. **Flavor / version honesty** — Era vs TBC vs “keeping it alive for Anniversary”; explicit non-goals (Attune: no SoD) ([Attune](https://www.curseforge.com/wow/addons/attune)).
8. **FAQ / issues link** — TRP3 FAQ + troubleshooting at top of body ([Total RP 3](https://www.curseforge.com/wow/addons/total-rp-3)).
9. **Install path** — Classic `Interface\AddOns` note still common ([Attune](https://www.curseforge.com/wow/addons/attune)).
10. **Hard restrictions / not a combat tool** — Beef-specific; aligns with ecosystem positioning in synthesis `00`.

## Classic-player conversion cues

| Cue | Why Classic players care |
|-----|--------------------------|
| **Named flavor** (Anniversary / TBC Classic) | Separate install trees; wrong folder = “broken addon” |
| **Slash to open** | Power users verify before install |
| **Who must install** | Guild tools fail silently if only one person has them — Attune/Gargul state this up front |
| **Officer vs everyone** | Loot/attune cousins set expectations; Beef officer gate must be explicit |
| **Not WeakAuras / not DBM** | Avoid wrong download from combat search bleed |
| **Social proof** | Attune cites Reddit + streamer features ([Attune](https://www.curseforge.com/wow/addons/attune)) — Beef can cite guild/stream later |

## Anti-patterns in long copy

- Lore-only page with no feature list → CF moderation risk ([Best Project Page](https://blog.curseforge.com/how-to-create-the-best-project-page/)).
- Promising automation / protected actions → policy + trust failure (spec hard restrictions).
- “Works on all Classic” without testing → flavor file lie; Attune-style explicit scope is safer.
- Giant Patreon walls above the fold → moderation size rules ([Best Project Page](https://blog.curseforge.com/how-to-create-the-best-project-page/)).
- Duplicate of packager README with no Classic install note.

## Draft Beef Description outline (not final marketing)

```text
[Badges: CurseForge | Wago | Discord]

# Church of Beef
Guild standing ladder for TBC Classic Anniversary.
Suggests promotions from play; Officers approve. Social spectacle — not a combat or DPS addon.

## Who needs it
- Members: see the ladder and your standing (/beef)
- Officers+: approve/reject rank changes
- Without the addon: still see guild-chat announcements

## What it does
| Feature | What | Command |
| Ladder | Guild ranks & standing | /beef |
| Officer queue | Approve suggestions | /beef (Officer) |
| Co-play standing | Capped credit for shared instances with guildmates | automatic |
| Announcements | Throttled guild-chat on approve | officer client |

## Supported
TBC Classic Anniversary (Interface 20506). Not a Retail addon.

## Not this addon
No boss timers, nameplates, or rotation help.
```

Mirror the same outline on [Wago Addons](https://addons.wago.io/) About tab ([Gargul Wago](https://addons.wago.io/addons/gargul) shows identical feature tables).
