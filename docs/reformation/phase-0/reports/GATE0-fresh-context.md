# GATE0 — Fresh-context product-law test

**Agent:** fresh (no prior conversation).  
**Read:** `README.md`, `AGENTS.md`, `.cursor/rules/ten-laws.mdc`, `.cursor/rules/architecture-overview.mdc`, `docs/design/Game_Design_Bible_v1.1.1.md` (enough to check answers), `docs/archive/pre-reformation/WHY.md` (archive status only), plus `.cursor/rules/pope-authority.mdc` and `.cursor/rules/records-not-points.mdc` for the rebuild questions.  
**Did not read:** archived specs/plans as product law.  
**Did not invent product.**

---

## Verdict: GATE0_PASS

A fresh agent reading only current workspace law is pointed at **Church of Beef as the Design Bible product**: a social ceremony, sanctioned-Gora, and memory layer for TBC Classic Anniversary, with the Beef Pope as performer and the add-on as stage manager. Product law is named as `docs/design/Game_Design_Bible_v1.1.1.md`; `docs/archive/pre-reformation/` is labeled historical and must not win. The Ten Laws, README, and AGENTS.md all ban the prior demo product (points/standing ladder, officer-performed rituals, Beef Prophet, per-character “alts start fresh”). Nothing in the allowed reading set would cause a competent agent to rebuild that product.

---

## 1. What is this product?

Church of Beef is a **social ceremony, Gora, and memory layer** for **World of Warcraft: Burning Crusade Classic Anniversary** (`## Interface: 20506`). It is not another game inside WoW, not a raid-optimization or combat-assistance tool, and not a roster-backed standing ladder. Its job is to make things players already do — a duel, a promotion, a Gathering — feel like they happened inside the Church: a duel becomes a **Beef Gora** (an unmodified world duel the Pope sanctions); a guild promotion becomes a **Knighting**; the **Beef Pope** is the performer; the software is the **stage manager**.

Ranks are kinds of relationship with the Church, not grind rungs: Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher (Raiding Team role designation — display-only in this phase), Beef Council. There are no thresholds. The Pope is not a rank. Identity is account-level: **rank belongs to the human; Gora records belong to the character.** Church history is never deleted.

Authority is a **Pope-authoritative star**: one writer (the Pope’s client); congregation clients are display terminals plus input devices; witnesses report, never rule. Ceremony runtime is **QUIET → ASSEMBLY → RITE (typed) → CONSEQUENCE → ASSEMBLY or QUIET**, owned by the Pope’s client. Outside events, **Quiet Mode** is at most a minimap presence and the active Decree. Software proposes; the Pope ratifies. The software never narrates.

The current checkout is not the finished product. MVP is done when the Church runs one complete real Gathering as Bible §22.3 describes — a human performance pass, not a green harness.

---

## 2. What is banned?

From Ten Laws, README, AGENTS.md, and Bible §§4, 5, 6, 10, 12, 13, 17, 19:

**Economies and grind**
- Points, XP, currencies (as wallets), dailies, weekly chores, unlock trees
- Engagement / favor streaks as economy (fight-record streaks and Records Book Longest Streak are narrative records, not this ban)
- Thresholds, engagement scoring, contribution scores, Grant / standing / suggestion machinery
- Activity hours, combat minutes, generalized activity numbers
- Activity leaderboards
- A sorted “#1 rating” ladder

**Combat systems the addon must not become**
- ELO / MMR / hidden rating / rated matchmaking
- Combat analytics (damage meters, duration stats, per-class win rates)
- Betting / wagering; favor streaks or favor accuracy records
- Gora as typed self-report or points faucet
- Modified combat; gameplay automation of any kind

**Authority and ceremony**
- Officers / Council performing rituals (Knighting, sanctioning Goras, verdicts, elevation, canonization, major proclamations)
- Officer+ / `rankIndex ≤ 1` as a ritual gate
- Auto-declared outcomes, auto-advanced queues, auto-announce in the Pope’s voice
- Generated narration, flavor text, or Chronicle scripture
- Distributed consensus; peer self-reported authority
- Congregation inputs triggering public theater
- Public demotion / excommunication spectacle (canon has neither)

**Identity and history**
- Per-character Church rank; “alts start fresh”
- Self-service / silent alt linking
- Pruning, departed-member sweeps, record expiry
- Treating a name string as the human or as durable character identity

**Ranks**
- Beef Prophet
- The Pope as a rank
- Linear threshold ladder; invented ranks above Lord
- Treating Butcher as a grind capstone (it is a raid-team role designation)

**Quiet Mode and visual law**
- Feeds, dashboards, bars, toasts, pips, sound, or ambient surfaces outside Event Mode
- UI that tells jokes
- Stock-chrome-only visual law on theatrical surfaces (hybrid law: functional = pragmatic; theatrical = ecclesiastical)

**Hard safety**
- Bots, injection, protected-action circumvention, external process control
- Retail / Dragonflight-only APIs
- Anything other than Lua/XML in-game

**Process**
- Inventing product answers; following archived pre-reformation specs as winners on conflict

---

## 3. Where is product law?

| Role | Path |
|------|------|
| **Sole product law** | `docs/design/Game_Design_Bible_v1.1.1.md` |
| Why the law says that | `docs/design/Peer_Review_Adjudication.md` |
| Keep / rework / discard of the demo | `docs/design/Demo_Build_Audit.md` |
| Ten Laws (Phase 0 restatement; Bible wins on conflict) | `.cursor/rules/ten-laws.mdc`, `docs/reformation/phase-0/TEN_LAWS.md` |
| Architecture / star / ceremony skeleton | `.cursor/rules/architecture-overview.mdc` |
| Unanswered product questions (append; do not invent) | `docs/design/OPEN_QUESTIONS.md` |
| Orchestration | `CURSOR_REWORK_HANDOFF.md` |
| Agent map (not a second law) | `AGENTS.md` |
| **Archived law — historical only; do not follow** | `docs/archive/pre-reformation/` (confirmed by `WHY.md`) |
| Research (≠ law) | `docs/research/` |

On conflict: **Bible wins**, then Adjudication, then the Audit. `docs/superpowers/specs/*` and `docs/archive/pre-reformation/` are historical.

---

## 4. Would you rebuild these?

| Rebuild? | Answer | Why |
|----------|--------|-----|
| **Points ladder** | **No** | Law 1 / Bible §4.6, §4.9, §10.6, §10.9. The points economy is banned, not rebalanced. Recognition comes from events the Pope ratifies and records the Church remembers. |
| **Standing** (as a points/standing economy or roster-backed standing ladder) | **No** | README and AGENTS.md: this is not a roster-backed standing ladder. `records-not-points.mdc` lists Grant / standing / suggestion machinery as a regression. Bible “standing” elsewhere means automation red lines or social relationship — not a score. |
| **Officer+ rituals** | **No** | Law 3 / Bible §6. Knighting, sanction, verdicts, elevation, canonization are Pope-only. Council/officers support operations and activities; they do not perform rituals. `rankIndex ≤ 1` is not the Church and is not a ritual gate. |
| **Beef Prophet** | **No** | Law 9 / Bible §5 and v1.1.1 changelog. Rank list is exactly six titles. Prophet is removed. Do not invent it. |
| **Per-character “alts start fresh”** | **No** | Law 7 / Bible §12. Identity is account-level: rank belongs to the human; Gora records belong to the character. Alts bind via Rite of Recognition; they do not start a new Church identity. History is never deleted. |

---

## Archive check

`docs/archive/pre-reformation/WHY.md` states those files are **historical** and must not be followed. Product law is now the Bible. The old law encoded the demo’s wrong product (points spine, threshold ladder, Prophet, officer sovereignty, per-character prune). This GATE0 read used that file only to confirm the archive is not law.
