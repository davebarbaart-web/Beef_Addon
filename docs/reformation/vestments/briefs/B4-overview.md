# Batch 4 — Inputs & Event furniture

**Cited:** CONTINUE 2026-08-18 licenses 1–4; Bible §9, §10.2, §13.1, §13.4, §18.1, §18.5, §19.1–19.3. Stock textures/fonts only.

Codec already names INPUT kinds `petition` and `confession`. Favor is live. This batch opens those two kinds on the **same whisper-to-Pope path** as favor. No new codec kinds. No named-opponent field (wire is `characterId` only). No Confession fan-out. No Notebook persist. No dismiss-cooldown number (existing Gora pin stands). No Pope-name lookup. No custom media. Do not claim Gate W/V or POLISH:PASS.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B4-A | `Net/BeefNet.lua`, `tests/test_net_v2.lua` | `SendPetition` / `SendConfession`; Pope recv → Gora / Confession |
| B4-C | **new** `Core/Confession.lua`, `tests/test_confession.lua` | Memory-only private inbox |
| B4-D | `UI/Console.lua`, `tests/test_console.lua` | Petition H2H line; confession inbox; stock Dismiss |
| B4-E | `UI/FighterCard.lua`, `tests/test_fighter_card.lua` | Left-third dock; MORPHEUS names; keep `1-0` |
| B4-F | `UI/Hud.lua`, `tests/test_hud.lua` | Thin parchment behind name/title; health stays nil |
| B4-G | **new** `UI/Inputs.lua`, `tests/test_inputs.lua` | Event congregation Petition / Confess |
| B4-H | **new** `UI/ConsoleDock.lua`, `tests/test_console_dock.lua` | Event-only Pope dock: SANCTION + expand |

Writers do not edit TOC, `ChurchOfBeef.lua`, `tests/run.lua`, `OPEN_QUESTIONS.md`, or the Reformation log.
