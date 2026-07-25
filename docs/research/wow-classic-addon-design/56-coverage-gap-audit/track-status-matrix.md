# Track status matrix (00–74)

**Audit date:** 2026-07-25 (post–Wave E refresh — **70–72** filled)  
**Parent:** [56-coverage-gap-audit](README.md)

## Status legend

| Status | Meaning |
|--------|---------|
| **solid** | Multi-doc (or intentional single-file) research with clear conclusions; usable for V1 decisions |
| **thin** | Exists, but shallow, incomplete vs its own README index, or missing Beef synthesis |
| **empty** | Directory and/or `.raw/` only — no markdown notes yet |
| **audit** | This meta track |

Byte/file counts exclude `.raw/` and `.firecrawl/`. “Content docs” = `.md` files other than `README.md`.

---

## Root synthesis & index

| Track | Path | Exists | Status | Notes |
|------:|------|:------:|:------:|-------|
| 00 | `00-church-of-beef-implications.md` | yes | **solid** | ~18 KB synthesis; Wave refresh (00–55) + post-fill Wave refresh (57–67) appended |
| 06 | `06-annotated-master-reference-list.md` | yes | **solid** | Curated URL list (~9 KB); intentional single-file format — refresh with 57–67 URLs still nice-to-have |

Superseded flat sketches at library root (`01-client-flavors-and-toc.md` … `05-persistence-and-profiles.md`) remain as historical notes; prefer folder tracks.

---

## Tracks 01–55

| Track | Folder | Status | md files | ~content KB | Notes |
|------:|--------|:------:|---------:|------------:|-------|
| 01 | `01-ux-patterns/` | **solid** | 13 | ~31 | Surface briefs + filled `church-of-beef-synthesis.md` |
| 02 | `02-visual-language/` | **solid** | 6 | ~29 | Includes implications + steal/adapt |
| 03 | `03-ace-libs-options/` | **solid** | 8 | ~32 | Full Ace/LibStub/options stack |
| 04 | `04-toc-api-performance/` | **solid** | 8 | ~31 | TOC/SV/events/lockdown/perf + Beef constraints; `SOURCES.md` present |
| 05 | `05-packaging-community-antipatterns/` | **solid** | 6 | ~34 | Packaging + antipatterns + Beef |
| 07 | `07-immersion-roleplay-flavor/` | **solid** | 5 | ~27 | Immersion / RP catalog + implications |
| 08 | `08-combat-hud-alerts/` | **solid** | 9 | ~39 | Contrast track — what Beef must *not* be |
| 09 | `09-guild-social-community/` | **solid** | 7 | ~40 | Closest social-product landscape |
| 10 | `10-skinning-masque-sharedmedia/` | **solid** | 8 | ~47 | Notes 01–05 + filled `06-…adopt-vs-invent.md` + `07-annotated-urls.md` |
| 11 | `11-onboarding-settings-ux/` | **solid** | 10 | ~40 | First-run, AceConfig, minimap, overwhelm |
| 12 | `12-classic-vs-retail-philosophy/` | **solid** | 7 | ~39 | Philosophy + Beef design implications |
| 13 | `13-cousin-addon-teardowns/` | **solid** | 6 | ~38 | Attune / Gargul / TRP3-MRP + steal/avoid |
| 14 | `14-addon-messaging-beefnet/` | **solid** | 7 | ~28 | Prefix, CTL, sync anti-spam, BeefNet map |
| 15 | `15-instance-completion-events/` | **solid** | 3 | ~17 | Compact; strong matrix; Anniversary **prototype** still required |
| 16 | `16-guild-roster-officer-edges/` | **solid** | 3 | ~16 | Compact; deep `api-edges.md` |
| 17 | `17-stream-overlay-readability/` | **solid** | 7 | ~34 | Capture/stream spectacle budget |
| 18 | `18-localization-i18n/` | **solid** | 7 | ~26 | enUS-first + AceLocale norms |
| 19 | `19-testing-debugging-qa/` | **solid** | 8 | ~32 | QA checklist + mock guild scenarios |
| 20 | `20-sound-sfx-feedback/` | **solid** | 6 | ~31 | SFX norms; V1/V2 stance |
| 21 | `21-savedvariables-migration/` | **solid** | 8 | ~35 | Schema/migration + Beef mapping |
| 22 | `22-slash-commands-ux/` | **solid** | 7 | ~23 | Slash surface map for `/beef` |
| 23 | `23-color-brand-tokens/` | **solid** | 5 | ~32 | Brand tokens + contrast |
| 24 | `24-policy-tos-compliance/` | **solid** | 8 | ~44 | EULA/ToS, points gray areas, Beef |
| 25 | `25-multi-toon-realm-edges/` | **solid** | 7 | ~27 | Alts, realms, guild-scope keys |
| 26 | `26-ladders-points-gamification/` | **solid** | 8 | ~35 | Ladder UX, anti-farm, copy/avoid |
| 27 | `27-desync-conflict-resolution/` | **solid** | 7 | ~43 | Revisions, LWW, officer authority |
| 28 | `28-minimap-addon-compartment/` | **solid** | 7 | ~27 | LibDBIcon / collectors / compartment |
| 29 | `29-taint-secure-ui/` | **solid** | 6 | ~36 | Taint, lockdown, social footguns |
| 30 | `30-anniversary-vs-era-deltas/` | **solid** | 7 | ~31 | Client trees, Interface, packaging |
| 31 | `31-listing-copy-discovery/` | **solid** | 7 | ~33 | CurseForge listing patterns |
| 32 | `32-microcopy-tone-voice/` | **solid** | 7 | ~31 | Toast/announce voice |
| 33 | `33-packager-ci-releases/` | **solid** | 8 | ~34 | BigWigs packager / CI / channels |
| 34 | `34-lua-module-architecture/` | **solid** | 7 | ~28 | Module layout for V1 plan |
| 35 | `35-xml-vs-lua-ui/` | **solid** | 5 | ~19 | Officer/ladder UI construction choice |
| 36 | `36-tooltips-menus/` | **solid** | 6 | ~23 | Tooltips + officer context menus |
| 37 | `37-movable-frames-anchors/` | **solid** | 7 | ~25 | Drag, anchors, toast placement |
| 38 | `38-keybinds-bindings/` | **solid** | 7 | ~22 | Bindings.xml; V1 recommend sparse |
| 39 | `39-guild-calendar-events/` | **solid** | 6 | ~28 | Calendar APIs + guild-night instrumentation |
| 40 | `40-officer-moderation-audit/` | **solid** | 8 | ~31 | Audit, undo, griefing, transparency |
| 41 | `41-empty-states-degraded-ux/` | **solid** | 5 | ~26 | Not-in-guild / no-peers UX |
| 42 | `42-soft-deps-embeds/` | **solid** | 6 | ~27 | Soft deps, embeds, LibStub etiquette |
| 43 | `43-ui-scale-pixel-perfection/` | **solid** | 8 | ~28 | Scale, 4K, toast sizing |
| 44 | `44-custom-textures-media-packaging/` | **solid** | 5 | ~21 | Media paths; V2 icon authoring |
| 45 | `45-licensing-maintainer-norms/` | **solid** | 7 | ~29 | License options for Beef |
| 46 | `46-seasonality-fresh-servers/` | **solid** | 6 | ~20 | Fresh realms, lockouts, seasons |
| 47 | `47-login-storms-guild-scale/` | **solid** | 6 | ~27 | Login storms + BeefNet load |
| 48 | `48-feature-flags-rollout/` | **solid** | 8 | ~32 | Flags, channels, V1/V2 rollout |
| 49 | `49-officer-notifications/` | **solid** | 5 | ~21 | Officer alert channels + anti-spam |
| 50 | `50-time-timezones-resets/` | **solid** | 6 | ~26 | Server time, weekly resets, scoring windows |
| 51 | `51-guild-night-playbook/` | **solid** | 5 | ~28 | Ops runbook + threshold instrumentation |
| 52 | `52-competitor-market-map/` | **solid** | 4 | ~24 | Market map + white space |
| 53 | `53-beef-lore-ui-bible/` | **solid** | 7 | ~31 | Lore vocabulary / string do-don’t |
| 54 | `54-memory-fps-budgets/` | **solid** | 6 | ~27 | Social-addon budgets + GC patterns |
| 55 | `55-graceful-degradation/` | **solid** | 7 | ~25 | pcall, partial sync, flavor mismatch |

### 01–55 rollup (incl. root 00 + 06)

| Status | Count |
|--------|------:|
| solid | 56 (00–55 inclusive; 01 & 10 repaired) |
| thin | 0 |
| empty | 0 |

---

## Track 56 (this audit)

| Track | Folder | Status | Notes |
|------:|--------|:------:|-------|
| 56 | `56-coverage-gap-audit/` | **audit** | Meta inventory; not primary ecosystem research |

---

## Tracks 57–67 (post-fill wave)

Previously empty shells; all now have README + synthesis notes (+ `.raw/` provenance).

| Track | Folder | Status | Content docs | ~content KB | Topic |
|------:|--------|:------:|-------------:|------------:|-------|
| 57 | `57-scrollframe-list-rows/` | **solid** | 4 | ~19 | Ladder / officer list scroll; fixed pools; Faux if overflow |
| 58 | `58-staticpopup-confirms/` | **solid** | 5 | ~29 | StaticPopup / custom confirms for demote / Prophet / wipe |
| 59 | `59-coplay-guildmate-detection/` | **solid** | 4 | ~28 | `UnitIsInMyGuild` + roster; HOME vs INSTANCE |
| 60 | `60-hardcore-doomhowl-edges/` | **solid** | 6 | ~30 | HC / Doomhowl edges; ghost pause; Gora ≠ Mak’gora |
| 61 | `61-streamer-mode-privacy/` | **solid** | 5 | ~29 | Streamer / privacy CVars; announce/ladder stance |
| 62 | `62-patch-day-interface-bump/` | **solid** | 7 | ~27 | Interface bump runbook + maintainer checklist |
| 63 | `63-combatlog-social-signals/` | **solid** | 5 | ~28 | Explicit **avoid CLEU** for V1 standing |
| 64 | `64-fresh-lowlevel-fairness/` | **solid** | 4 | ~21 | Fresh→Cooked pacing; no Min-EP catch-up |
| 65 | `65-debug-dumps-privacy/` | **solid** | 3 | ~16 | Debug dump allow/deny; SV / chat privacy |
| 66 | `66-editmode-classic-coexistence/` | **solid** | 4 | ~32 | Edit Mode coexistence; own movers; no EM registration |
| 67 | `67-offline-officer-suggestion-sync/` | **solid** | 4 | ~25 | §16.5 V1: local-persist + live fanout; sync = V1.1 flag |

### 57–67 rollup

| Status | Count |
|--------|------:|
| solid | 11 |
| thin | 0 |
| empty | 0 |

---

## Tracks 68–74 (post-67 follow-ons + Wave E)

Indexed in the library README. **57–67 fill wave** and **Wave E (70–72)** are complete. No empty/thin primary shells remain.

| Track | Folder | Status | Content docs | ~content KB | Notes |
|------:|--------|:------:|-------------:|------------:|-------|
| 68 | `68-beefnet-message-catalog/` | **solid** | 6 | ~37 | Wire catalog, budgets, versioning, anti-storm per type |
| 69 | `69-officer-tab-ia/` | **solid** | 8 | ~34 | Officer tab zones, queue layout, evidence, empty states |
| 70 | `70-standing-breakdown-ui/` | **solid** | 6 | ~30 | My Standing composition; source chips; density anti-patterns; V1 recommendation |
| 71 | `71-ceremony-gora-mechanics/` | **solid** | 5 | ~37 | Ceremony stubs, Gora flows, officer close/abort, cousins, URLs |
| 72 | `72-guild-chat-announce-api/` | **solid** | 7 | ~35 | SendChatMessage constraints, CTL, single-announcer, V1 pipeline |
| 73 | `73-desktop-lua-testing/` | **solid** | 6 | ~28 | Desktop harnesses, mocks, offline vs in-game, GHA notes |
| 74 | `74-v1-decision-glossary/` | **solid** | 1 | ~28 | Intentional single-file glossary (~81 locked decisions) |

### 68–74 rollup

| Status | Count |
|--------|------:|
| solid | 7 |
| thin | 0 |
| empty | 0 |

---

## Library rollup (primary research only)

Excludes track **56** (audit).

| Status | Count | Tracks |
|--------|------:|--------|
| **solid** | **74** | 00–55 + 57–74 |
| **thin** | **0** | — |
| **empty** | **0** | — |
| audit | 1 | 56 |

**Fill-wave slice (57–67 only):** 11 solid / 0 thin / 0 empty.  
**Wave E slice (70–72 only):** 3 solid / 0 thin / 0 empty.

---

## Empty / thin at a glance

**Still empty:** none  

**Still thin:** none  

**Solid but prototype / ops-blocked (not library empties):**

| Item | Tracks | Why still open |
|------|--------|----------------|
| Anniversary encounter/completion playtest | **15** | Docs mark `ENCOUNTER_END` / `BOSS_KILL` as Prototype on `20506` |
| HybridScroll in-client verify | **57** | V1 ships fixed pools / Faux; Hybrid only if templates confirmed |
| Same-instance-ID guildmate harden | **59** | Deferred optional playtest; not V1 ship gate |
| Live CTL under guild login storm | **14 / 47 / 51 / 68** | Reasoned budgets; measure on a real guild night |
| Threshold / Fresh→Cooked tuning | **51 / 64** | Ops playtest owns the number |
| Brand hex / chrome screenshot lock | **23** | Spec: template-native until Anniversary screenshot pass |
