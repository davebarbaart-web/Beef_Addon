# Recommendation options for Church of Beef

**Last updated:** 2026-07-25  
**Track:** [45-licensing-maintainer-norms](README.md)  
**Status:** Research options — not a locked design-spec decision until copied into the decisions log.

## Decision drivers unique to Beef

| Driver | Pulls toward |
|--------|----------------|
| Streamer brand, liturgy microcopy, “Church of Beef” naming | ARR / custom ARR |
| Guild officers depending on a single canonical build | ARR + one CF project + named co-maintainers |
| Desire for outside contributors / Classic fork maintainers | MIT or GPL + clear contribution guide |
| Ace3 / LibStub / LibDBIcon / LSM embeds | Keep third-party notices; do not relicense Ace as MIT |
| V1 ships little/no custom media | Low asset risk; still write LICENSE now |
| Blizzard free + visible code rules | Any choice still free-to-play and unobfuscated |

## Option A — ARR (recommended default)

**Shape:** `LICENSE` = All Rights Reserved; short README permissions block (ElvUI-inspired).

Suggested grant language (adapt, not legal advice):

- Free to download and use in WoW.
- Private modifications OK.
- Public redistribution / republishing of the addon (or substantial portions) requires written permission.
- Do not rename the addon / folder when redistributing authorized builds.
- GitHub: either disallow public forks for redistribution, or allow GitHub for contribution only (ElvUI pattern).
- Contributions: by PR, assigned to the project under the same ARR.

**Pros:** Matches Details/DBM/Gargul/ElvUI culture; protects liturgy and project identity; simple story for CF dropdown (“All Rights Reserved”).  
**Cons:** Discourages unaffiliated Classic “Beef Continued” if maintainers vanish — mitigate with co-authors + succession note.  
**Best if:** Brand control > community forkability.

## Option B — ARR + explicit contribution / translation carve-outs

Same as A, plus README bullets:

- Locale PRs welcome; translators credited.
- Official mirrors (Wago/WoWI) listed; unofficial mirrors discouraged.
- Optional: “Officers may privately patch for their guild; public release needs permission.”

**Pros:** Softens ARR without GPL.  
**Cons:** Custom text must stay consistent on CF “Custom” license field.  
**Best if:** You want help but not hostile forks.

## Option C — MIT (or MIT + Commons Clause–style name restriction — careful)

**Shape:** MIT for code; separate trademark-style note that “Church of Beef” name/logo require permission.

**Pros:** Familiar to GitHub contributors; maximal reuse of non-brand code.  
**Cons:** Scene history shows MIT invites stale mirrors; name reservation may be weakly enforceable if poorly drafted; uncommon for brand-forward player addons.  
**Best if:** Beef is intentionally positioned as a reusable guild-ladder framework others should re-skin.

## Option D — GPL-2.0 / LGPLv3

**Shape:** WeakAuras-like GPL or RCLC-like LGPL.

**Pros:** Clear rules for forks; attracts libre-minded contributors.  
**Cons:** Forces share-alike on derivatives — including parody forks that keep sacred comedy strings; poor fit for exclusive streamer liturgy; GPL + ARR Ace embeds need careful compliance (Ace is not GPL).  
**Best if:** Product thesis shifts to “open guild framework,” not “Church brand.”

## Concrete recommendation for V1

1. **Ship Option A or B** (ARR ± contribution carve-outs). Aligns with cousin loot/UI tools and brand risk.
2. **Vendor Ace/LSM with notices** in `Libs/` + `ThirdPartyNotices.md` (Ace Style BSD / each lib’s file).
3. **Set CurseForge project license** to match the repo `LICENSE` on day one (avoid “Custom” mismatch).
4. **Add at least one co-author** on CF before first public Release.
5. **Do not bundle uncleared meme SFX/fonts** in V1; keep media provenance table before V2 theater.
6. **Document succession:** who can transfer the CF project if the primary maintainer goes dark.
7. Revisit MIT/GPL only if Beef is later split into a generic ladder library + a branded liturgy pack (library permissive, brand pack ARR).

## Checklist before first CurseForge upload

- [ ] `LICENSE` committed and matches CF dropdown
- [ ] `## Author` / `## X-Website` / `## X-Curse-Project-ID` ready
- [ ] Third-party lib notices present
- [ ] No Blizzard ripped audio/art in the zip
- [ ] No in-game donation / paywall UI (Patreon link only on CF/README)
- [ ] README states private-mod vs public-fork policy in one paragraph
- [ ] Co-maintainer / transfer plan written (even if private)

## Non-goals

- This track does not draft attorney-approved trademark filings.
- Overwolf Rewards enrollment is optional and orthogonal to LICENSE choice.
- Dual-licensing (ARR for binary distribution + GPL for a core lib) is possible later; unnecessary for V1.
