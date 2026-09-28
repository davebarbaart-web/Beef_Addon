# Wave synthesis — Phase B claim index (condensed)

**Wave:** `agent-polish-vision` reduce (2026-07-26)  
**Note:** Full 50-brief atomization would yield 150–400 claims ([33](33-parallel-synthesis-methods.md)). This index keeps **high-signal / decision-bearing** claims for reduce (~90). Depth briefs remain L0 evidence.

**claim_type:** `fact` · `norm` · `pattern` · `anti-pattern` · `open-question` · `product-lock`

---

## Signal-critical / safety

| claim_id | claim | type | evidence | beef_surface |
|----------|-------|------|----------|--------------|
| 50-tos-01 | No bots, injection, protected-action bypass, or gameplay automation. | product-lock | verification.mdc; spec §2; [50] | n/a |
| 03-taint-01 | Polish must use insecure Beef frames; no SecureActionButton for panels; avoid EasyMenu/ShowUIPanel combat footguns. | norm | [03]; wow-ui-taint-lockdown | toast / officer |
| 00b-taint-01 | Community treats “addon blocked from Blizzard-only action” as a flashpoint. | fact | [00b] #23 | n/a |
| 50-retail-01 | No Retail/Dragonflight-only APIs; Interface stays `20506` unless intentional bump. | product-lock | TOC; architecture | n/a |
| 48-layer-01 | UI never awards points; Net never invents ranks; Core never CreateFrame. | product-lock | architecture; [48] | ladder / Net |

---

## Classic UI / juice craft

| claim_id | claim | type | evidence | beef_surface |
|----------|-------|------|----------|--------------|
| 11b-filter-01 | No permanent OnUpdate for juice; clear scripts when idle. | norm | [11b]; [09]; wow-performance | toast |
| 11b-filter-02 | Edge toasts only — never center WA pulses. | product-lock | UI brief; [11b]; [00b] | toast |
| 11b-filter-03 | `/g` spectacle is the durable jumbotron; toast is ephemeral private flourish. | product-lock | spec §10; [14]; [11b] | announce |
| 11b-filter-04 | Silent V1 — no mandatory SFX; missing media must not fail load. | product-lock | spec §15; [17]; [11b] | n/a |
| 11b-filter-05 | No full-screen strobe / UIParent screen shake; photosensitivity. | anti-pattern | [11b]; [14] | toast |
| 11b-filter-06 | Guest on player uiScale — never UIParent:SetScale. | product-lock | UI brief; [42] | n/a |
| 11-kelly-01 | Juice recognition moments (Commit/promote); keep process chrome calm. | pattern | [11]; Kelly Don’t Juice; [11b] | officer |
| 11-hicks-01 | Juice is redundant confirmatory feedback — not a second truth channel. | pattern | Hicks CHI PLAY; [11b] | toast |
| 14-tier-01 | V1 celebration = Small (toast) + Medium (`/g`+toast); Epic reserved for scarce seats / V2+. | norm | [14]; [42] | announce / toast |
| 39-hier-01 | Juice spend order: chat > toast > in-panel > short motion > SFX > art. | norm | [39] §3 | announce |
| 39-tier-01 | T0 private (suggest/credit toast); T1 social (Commit `/g`+toast); T2+ out of V1. | norm | [34] §4.4; [39] | toast |
| 16-time-01 | Enter ease-out ~160–300ms; exit ~25% faster; purpose-bearing motion only. | pattern | [16]; NN/G; Material; [11b] | toast |
| 00b-toast-01 | Toasts that block clicks or combat vision get nuked; mute-by-type + coalesce. | fact | [00b] A2 | toast |
| 00b-mini-01 | Minimap: hideable + LibDBIcon/LDB-friendly + honest tooltip; collectors assumed. | norm | [00b] A1; [05]; [47] | n/a |
| 18-dual-01 | Dual-encode pending/approve/reject; class color on names only; no loot rainbow ranks. | product-lock | UI brief; [18] | officer / ladder |
| 42-in-01 | V1 IN: Classic shell, tabs, standing text, edge toasts, `/g`, settings starvation. | product-lock | [42]; spec §10 | ladder |
| 42-out-01 | V1 OUT: Media/, SFX packs, standing StatusBar, WA center, Streamer Mode, V2 dashboard. | anti-pattern | [42]; [49] kill-list | n/a |
| 56-ag-01 | Short AnimationGroup / C_Timer fades OK on Beef frames when available on 20506; still no permanent OnUpdate. | fact/norm | [56]; [02] | toast |
| 07-announce-01 | One throttled officer `/g` line; default ON; opt-out must not kill Commit. | product-lock | spec; [07]; [42] | announce |
| 00b-guild-01 | Rank titles wanted as glance signals; spectacle rare; no trade-spam cadence; no shame UX. | norm | [00b] Theme C | ladder / announce |
| 20-empty-01 | Empty/sync states must be honest; not look “broken.” | norm | [20]; [45] | ladder / Net |
| 09-perf-01 | Cap concurrent tweens; coalesce toasts; never full ladder rebuild per toast. | norm | [09]; [51]; [11b] | toast |
| 46-conc-01 | Concurrent toast stack = 1 (or coalesce); promote dwell longer than credit. | norm | [46]; [14]; [42] | toast |

---

## Cursor / process / hands-off

| claim_id | claim | type | evidence | beef_surface |
|----------|-------|------|----------|--------------|
| 21b-tax-01 | Rules = short policy; Skills = workflows; Hooks = mechanical gates; keep always-on tiny. | pattern | [21b]; [00b] #24–30; Cursor docs | n/a |
| 21b-ralph-01 | Ralph ≠ Cursor `/loop`; both need max iterations + external verify. | fact | [21b] conflicts; [49] | n/a |
| 22b-bir-01 | Prefer Bounded Iterative Refinement: hard verify before soft LLM critique; max_iter 2–3. | pattern | [22b]; Anthropic; LangGraph | n/a |
| 22b-human-01 | Human in-game smoke cannot be closed by LLM judges; spectacle not unit-testable. | product-lock | verification.mdc; [22b]; Anthropic | announce |
| 22b-writer-01 | Writer ≠ reviewer; separate critic session/model. | pattern | [22b] #20; [27] | n/a |
| 24-pass-01 | Agents may claim POLISH:CANDIDATE only; POLISH:PASS is human-signed. | norm | [24] | n/a |
| 24-gate-01 | Gate A integrity (harness/TOC/layers/safety/load/entry) must pass before polish. | norm | [24] | n/a |
| 24-tier-01 | Polish tiers P0 process / P1 feedback / P2 spectacle / P3 art post-V1. | norm | [24]; [53] | n/a |
| 25-rubric-01 | Agent-facing craft bar = 8×1–5 rubric ([25]); not the only truth vs Gates. | pattern | [25]; [52] | n/a |
| 31-stop-01 | Stop on: hard fail, clean critique, nit-only, plateau, max_iter, reopen-locked finding. | norm | [31]; [22b] | n/a |
| 31-best-01 | On max_iter with hard gates OK → ship best-so-far, not last revision. | pattern | [31] | n/a |
| 30-goal-01 | Refuse vague “make nicer”; require Goal anatomy (intent, AC, critique budget, stop, handoff). | norm | [30]; [36] | n/a |
| 29-loop-01 | Default loop: implement → mechanical verify → ≤2–3 critique → ledger. | pattern | [29]; [54] | n/a |
| 40-leap-01 | One user prompt → one verifiable vertical slice; anti-nibble. | norm | [40]; [34] | n/a |
| 32-h-01 | Human gates H0 install → H1 smoke → H2 two-client → H3 spectacle → H4 guild night → H5 V1 walk. | pattern | [32]; [53] | n/a |
| 26-vqa-01 | Visual QA = human PNG capture → agent Read; never automate WoW process. | anti-pattern | [26]; [35]; [22b] | n/a |
| 00b-loop-01 | Unattended ambiguous polish without spend/iteration caps causes thrash/cost spikes. | fact | [00b] #32–33; [21b] | n/a |
| 49-kill-01 | Do not build juice OS, ≥3-agent UI swarms, unbounded critique, overnight UI Ralph, Media in Task 7–10. | anti-pattern | [49] | n/a |
| 49-keep-01 | Checklist + harness + TOC + `/reload` + two-client + `/g`+edge toast + layer law are the keep-list. | norm | [49] | n/a |
| 35-pixel-01 | Pixelmatch CI for Anniversary frames is out of scope. | anti-pattern | [35]; [22b] | n/a |

---

## CoB scope / roadmap / wiring

| claim_id | claim | type | evidence | beef_surface |
|----------|-------|------|----------|--------------|
| 53-seq-01 | Sequence: process OS → functional spine → V1 juice P0–P1 → two-client → guild night P2 → V1 declaration. | pattern | [53] M0–M5 | n/a |
| 53-claim-01 | Do not claim V1 complete until dated `v1-checklist.md` walk including §13.11. | product-lock | verification; [53] | n/a |
| 52-gap-01 | Product docs lock *what*; missing thin *how* (goal→critique→stop→human). | fact | [52] | n/a |
| 36-gap-01 | Polish OS unwired from AGENTS/skill/rules — agents need paste or promotion. | fact | [36] | n/a |
| 36-wire-01 | Lightest wiring: AGENTS index → skill § Polish → thin verification bullet → optional rules/skill 37. | norm | [36] §6; [29] | n/a |
| 34-rules-01 | Proposed: 2 thin always-on (leaps, self-critique) + picker polish-loop + UI-glob juice standards. | open-question | [34] — needs human | n/a |
| 37-skill-01 | Draft polish-loop skill exists; not installed; prefer skill ops + short rules policy. | open-question | [37]; [34] | n/a |
| 08-set-01 | Settings budget: position + minimap hide + announce opt-out (toast mute only if playtest proves noise). | product-lock | [08]; [42]; UI brief | SV |
| 45-sync-01 | Sync UX may clarify degraded/stale copy; must not invent Net authority. | norm | [45]; [48] | Net |
| 36-c1 | Roster-backed ladder amendment (Draft) may defer spectacle/Commit — constitution fork until §15. | open-question | [36] C1/C2; [52] | announce |
| 52-score-01 | Multiple rubrics (22 H/U/P, 25 8×1–5, 31 composite) — product docs should pick one agent-facing checklist. | open-question | [52]; [36] C9 | n/a |
| 54-auth-01 | Authority: spec → glossary → Ranks.lua → always-on rules → UI brief → skill → research. | product-lock | [54]; [33] | n/a |

---

## Conflicts flagged (raw)

| claim_id | conflicts_with | note |
|----------|----------------|------|
| 34-rules-01 | 49-kill-01 / 36-wire-01 | How many always-on rules / when to install |
| 14-tier-01 | 39-tier-01 | Small/Medium/Epic vs T0/T1/T2 naming |
| 31 max_iter=3 | 49 ≤2 critique | Cap numbers |
| 25-rubric-01 | 31 composite | Which score bar |
| 36-c1 | 07-announce-01 / 14-tier-01 | Roster amendment vs V1 spectacle |
| 05 LibDBIcon | 42 “no hard dep unless triggered” | Minimap library stance |

---

## Exit (Phase B)

Condensed claim index ready for clustering. Full per-brief atomization deferred (time-box per [33] anti-pattern “re-clustering forever”).
