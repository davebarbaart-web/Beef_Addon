# Track 22 — Slash commands & chat-command UX

**Track id:** `22-slash-commands-ux`  
**Last updated:** 2026-07-25  
**Sole focus:** Classic slash / chat-command UX — discovery, help, subcommands, tab completion limits, officer vs member verbs, error messaging — mapped to Church of Beef’s `/beef` surface.  
**Out of scope:** General first-run onboarding chrome, settings trees, packaging (track 11 and siblings). No addon implementation in this folder.

## Product truth (from V1 spec + plan)

| Locked / planned | Value |
|------------------|-------|
| Primary slash | `/beef` (`SLASH_CHURCHOFBEEF1`) |
| Bare command | Opens / toggles main frame (not chat-only) |
| Parallel entry | Minimap button → same frame |
| Officer authority | UI + BeefNet gates; slash must not bypass |
| Dev-only example | `/beef debug standing N` behind `COB.DEBUG` (plan Task 8; harden/remove before release) |
| Early stub message | `Church of Beef: UI not ready yet. (version)` until UI exists |

Sources: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10–§11; [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) Task 1 / 8 / 10.

## Index

| Note | Covers |
|------|--------|
| [classic-slash-mechanics.md](classic-slash-mechanics.md) | `SlashCmdList` / `SLASH_*` registration, aliases, conflicts, discovery |
| [help-subcommands-errors.md](help-subcommands-errors.md) | Help text norms, subcommand parsing, chat error messaging |
| [tab-completion-limits.md](tab-completion-limits.md) | Built-in slash Tab vs AceTab / AceConfigCmd argument completion |
| [officer-vs-member-verbs.md](officer-vs-member-verbs.md) | Verb inventory by role; soft-deny vs hide; roster timing |
| [beef-slash-surface-map.md](beef-slash-surface-map.md) | Explicit `/beef` surface proposal mapped to V1 features |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Bare `/beef` is the product.** Spec success criterion #2 is a real frame, not a chat dump. Empty-input → toggle UI is the Classic guild-tool pattern (AceConfigCmd docs show empty → GUI; hand-rolled V1 should mirror that without Ace).

2. **Discoverability is three-legged.** Slash name in README + `/beef help` + minimap. Clients also expose registered slash strings via chat edit box Tab after `/` ([WoWInterface archive](https://wowinterface.com/forums/archive/index.php/t-48783.html)) — short unique names (`/beef`) win Tab cycles; alias sprawl hurts.

3. **Unknown input must print syntax, never silent-fail.** Wiki howto’s default branch is `print("Syntax: /yourcmd (add|remove) …")` ([Creating a slash command — Wowpedia](https://wowpedia.fandom.com/wiki/Creating_a_slash_command)). Cousins advertise `/gl help`, `/gr help` as the discovery verb ([Gargul listing](https://addonswow.com/gargul); [Guild Recruiter](https://www.curseforge.com/wow/addons/guild-recruiter)).

4. **Tab completion for subcommands is optional and costly in V1.** Built-in Tab completes *command names*, not your argv tree. Argument completion needs AceTab (API marked “not yet finalized” on WowAce) or custom hooks. Prefer a tiny verb list + good help over incomplete Tab.

5. **Officer verbs are chat UX + security UX.** Spec: Officer tab hidden; approve actions no-op; BeefNet rejects forged commits. Slash must soft-deny with a clear line (“Officers only”), never apply standing/rank from an ungated chat string. Debug grants stay behind `COB.DEBUG`.

6. **Keep the V1 verb surface shallow.** Toggle + help + (optional) tab jumpers (`ladder`, `standing`, `officer`) + thin stubs (`gora`, `ceremony`) + gated officer shortcuts. Do not grow an AceConfigCmd options dump until V2 settings need it.

## Boundary with track 11 (onboarding)

Track 11 owns first-open framing, settings density, and “what do I see when I install.” This track only deepens **what happens when someone types in chat** — help lines, verbs, Tab limits, permission copy. Do not re-litigate Ladder/Standing/Officer tab IA here.

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Wowpedia / WowAce / Blizzard forum / plan+spec over listicles for technical claims.
