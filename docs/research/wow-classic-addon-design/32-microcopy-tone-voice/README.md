# Track 32 — Microcopy, humor, and guild-addon voice

**Track id:** `32-microcopy-tone-voice`  
**Last updated:** 2026-07-25  
**Sole focus:** Words — tone registers, announce-line craft, toast length, officer seriousness vs player spectacle, and Church of Beef copy guidelines.  
**Out of scope:** Immersion UI chrome / native-vs-gimmicky frames (track [07](../07-immersion-roleplay-flavor/)); stream layout/contrast (track [17](../17-stream-overlay-readability/)); BeefNet protocol; visual brand tokens (track [23](../23-color-brand-tokens/)). No addon implementation in this folder.

## Product truth (from V1 spec)

| Locked default | Value |
|----------------|-------|
| Brand voice root | Absurd religious institution (pope hat, Beef God, gothic/Scarlet pageantry) — comedy + rivalry, not generic UI prose |
| V1 spectacle budget | One throttled **guild-chat** promotion/demotion line from the approving officer |
| Spec example announce | “The Church recognizes Beefina, elevated to Beef Knight.” |
| Local toasts | Suggestion created · rank approved · Gora/ceremony credit |
| Officer surface | Approve/reject queue, demote, appoint, bestow — human judgment is the anti-cheat |
| Success criterion §13.11 | Visible guild-chat reaction on a real promotion night |

Source: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §3.3, §4.3, §10, §13.

## Boundary with track 07

| Track 07 owns | This track owns |
|---------------|-----------------|
| Where identity/ceremony *appears* (tooltips, gossip, macros) | What the *words* say and how funny they are |
| Native vs gimmicky chrome | Sincere vs meme **registers** |
| TRP3 / Immersion / Dialogue UI patterns | Announce lines, toasts, officer labels, empty states |

Do not restate 07’s frame heuristics here. Steal only the copy implication: **spectacle is content in chat and short status lines**, not a new floating sermon window.

## Index

| Note | Covers |
|------|--------|
| [sincere-vs-meme-guild-tone.md](sincere-vs-meme-guild-tone.md) | What successful Classic guild tools sound like; where meme humor belongs |
| [announce-line-craft.md](announce-line-craft.md) | Guild-chat promotion/demotion line structure, length, throttle, stream skim |
| [toast-copy-length.md](toast-copy-length.md) | Toast word/character budgets, duration, one-at-a-time rules |
| [officer-serious-vs-player-spectacle.md](officer-serious-vs-player-spectacle.md) | Dual register: officer UI vs flock-facing spectacle |
| [beef-copy-guidelines.md](beef-copy-guidelines.md) | Concrete Beef do/don’t, surface matrix, sample lines |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Winning Classic guild tools are sincere, not meme-forward.** [Attune](https://www.curseforge.com/wow/addons/attune), [Gargul](https://www.curseforge.com/wow/addons/gargul), and [RCLootCouncil](https://www.curseforge.com/wow/addons/rclootcouncil) sell clarity, transparency, and speed. Their chat announces are factual procedural lines; optional humor products stay separate ([DadJokes](https://www.curseforge.com/wow/addons/dadjokes) by Gargul’s author is a different addon, not loot UI voice).

2. **Beef’s comedy should be liturgical deadpan, not chat spam.** Spec brand is “absurd holy institution.” The joke is sincere pageantry (Church recognizes X), not random meme dumps in guild chat. Keep the flock laughing *at the ceremony*, not at the addon trying to be a comedian every toast.

3. **One announce line is the V1 spectacle.** Officer client only, throttled, plain text, readable without the addon — matches Gargul’s “announce to chat / opt-out / quality gate” pattern ([Gargul wiki — Announcing Loot](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat)). Hard cap: **255 characters** per [`SendChatMessage`](https://wowwiki-archive.fandom.com/wiki/API_SendChatMessage); design for **~80–140** skim length.

4. **Toasts are short confirmations; announces are the show.** UX consensus: one snackbar at a time, ideally one short line (~40–60 characters of readable text), auto-dismiss in a few seconds ([Material snackbars](https://m2.material.io/design/components/snackbars.html); [LogRocket toast UX](https://blog.logrocket.com/ux-design/toast-notifications)). Put the punchline in guild chat, not in a multi-line toast over the combat HUD.

5. **Split registers: officer UI is serious; flock UI is spectacle.** Approve/Reject/Demote labels and confirm dialogs stay plain and high-friction (loot-council honesty). Rank titles, announce lines, and optional footer scripture carry Church voice. Errors and sync warnings stay sober — jokes that hide failures burn trust.

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer CurseForge/Wago project pages, Gargul wiki, SendChatMessage docs, and Material/LogRocket toast guidance over listicles for craft claims.