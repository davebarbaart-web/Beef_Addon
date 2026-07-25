# Track 23 — Color systems, faction colors, brand tokens

**Track id:** `23-color-brand-tokens`  
**Last updated:** 2026-07-25  
**Sole focus:** Classic-native color systems + Church of Beef brand/token palette (readable, colorblind-safe).  
**Out of scope:** Visual chrome / ElvUI aesthetics ([02-visual-language](../02-visual-language/), [03-visual-language-reference.md](../03-visual-language-reference.md)); Masque / LibSharedMedia skinning ([10-skinning-masque-sharedmedia](../10-skinning-masque-sharedmedia/)); stream toast choreography detail ([17-stream-overlay-readability](../17-stream-overlay-readability/)). No addon implementation in this folder.

## Product truth (from V1 spec)

| Locked brand signal | Value |
|---------------------|-------|
| Identity | Absurd religious institution — gothic cathedral / Scarlet Crusade–inspired, holy energy, steaks/cows/pageantry |
| Tone | Comedy + rivalry + ceremony; not generic game UI art |
| Realms | Alliance Dreamscythe + Horde Doomhowl are **separate guilds / ladders** — no shared cross-faction church state |
| V1 chrome | Plain Classic frames OK; theatrical “dark-iron” pass is later |
| Stream | High-contrast text; guild-chat announce is primary spectacle |

Source: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §3.3, §5, §10.

## Index

| Note | Covers |
|------|--------|
| [wow-system-colors.md](wow-system-colors.md) | Class, quality, faction/reaction colors; Classic history; runtime APIs |
| [church-of-beef-brand-tokens.md](church-of-beef-brand-tokens.md) | Scarlet-gothic brand palette, semantic tokens, rank ladder hues |
| [overlays-contrast-colorblind.md](overlays-contrast-colorblind.md) | Overlay readability, WCAG contrast targets, dual-encoding rules |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Borrow Blizzard system colors; invent brand colors once.** Class / quality / reaction hues are player-learned grammar. Use `GetClassColor` / `GetItemQualityColor` (or client tables) for player names and rarity metaphors — do not invent a second “rare blue.” Church scarlet/gold/parchment is the only custom brand layer.

2. **Class colors are identity, not ladder prestige.** Neon class coloring everywhere is a retail-modern signal ([visual language](../03-visual-language-reference.md)). On the ladder, color **rank tier** and **semantic state** (pending / approved / demoted); use class color only as a small identity chip (name tint), never as standing magnitude.

3. **Alliance blue / Horde red are realm costume, not one church palette.** Spec: separate guilds, independent ladders. Brand tokens stay Scarlet-holy-absurd on both sides; optional faction accent chips may use client `GetFactionColor` / `PLAYER_FACTION_COLORS` when showing realm flavor — never merge ladders or force one faction’s blue/red as the whole UI.

4. **Scarlet brand ≠ Death Knight red ≠ Hostile red.** Spec leans Scarlet Crusade pageantry (ruby tabard / cathedral light). Hostile reaction red and DK class red already mean “danger / class.” Brand scarlet should sit warmer/deeper (tabard crimson + parchment + holy gold) so it does not collide with combat-hostile semantics.

5. **Never encode meaning with color alone.** Blizzard’s UI Colorblind Mode adds text labels for rarity/reaction for a reason ([Blizzard 6.1 colorblind support](http://worldofwarcraft.blizzard.com/en-us/news/17964863/new-colorblind-support-in-patch-61)). Beef toasts and officer queue rows need icon + word (“Approved”, “Pending”, “Excommunicated”) plus color.

6. **Overlay rule: opaque panel + ≥4.5:1 body text (3:1 large titles).** WCAG AA is the practical stream target ([MDN color contrast](https://developer.mozilla.org/en-US/docs/Web/Accessibility/Guides/Understanding_WCAG/Perceivable/Color_contrast)). Avoid translucent gray-on-gray; put a dark scrim under toast text if anything shows through the world.

7. **V1 tokens can be a Lua table of named hex/RGB; art chrome later.** Spec allows plain frames. Ship semantic names (`cob.brand.scarlet`, `cob.state.pending`) so V2 textures can re-skin without renaming meaning.

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Warcraft Wiki / FrameXML / Blizzard accessibility posts over fan hex listicles for system colors. Brand hexes in this track are **design proposals** grounded in Scarlet/gothic cues + a11y rules — validate on Anniversary client screenshots before locking.
