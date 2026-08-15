# The Ten Laws (every Phase 0 agent carries these)

Source: Reformation handoff §2. Product law: `docs/design/Game_Design_Bible_v1.1.1.md`. On conflict, the Bible wins.

1. **No points, XP, currencies, dailies, streaks, thresholds, or engagement scoring of any kind.** The points economy is not being rebalanced; it is banned. (Bible §4.6, §4.9; Audit V1)
2. **Record events, never behavior.** No tracking of hours, combat minutes, activity levels, or any generalized contribution number. No activity leaderboards, ever. (§4.9, §17)
3. **The Beef Pope holds ceremonial sovereignty.** Knighting, sanctioning Goras, verdicts, elevation, canonization: Pope actions, performed via one-click verbs on the Director Console. Officers/Council support operations; they do not perform rituals. (§6)
4. **Software proposes; the Pope ratifies.** Nothing auto-declares outcomes, auto-advances queues, auto-announces in the Pope's voice, or generates narration/flavor text. The software never narrates. (§4.2, §4.4)
5. **Pope-authoritative star topology.** One writer (the Pope's client); congregation clients are display terminals plus input devices; witnesses report, never rule. No distributed consensus, no peer self-reported authority. (§13.1)
6. **The Quiet Mode contract.** Outside events: at most a minimap presence and the active Decree. No feeds, toasts, pips, or ambient surfaces. Every UI feature declares Quiet Mode or Event Mode. (§4.8, §19.1)
7. **Church history is never deleted.** No pruning, no departed-member sweeps, no record expiry. Account-level identity; rank belongs to the human; Gora records belong to the character. (§12)
8. **Combat is WoW's.** A Beef Gora is an unmodified duel in the world. No ELO/MMR, no rated matchmaking, no combat analytics, no betting. (§10)
9. **Rank structure is exactly:** Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher (Raiding Team role designation — display-only in this phase), Beef Council. No thresholds. No "Beef Prophet." The Pope is not a rank. (§5)
10. **Hybrid visual law:** functional surfaces stock-template pragmatic; theatrical surfaces (proclamations, fighter cards, seals, verdicts, Records Book, Decree) get the full ecclesiastical parchment-and-dark-iron identity. The UI itself never tells jokes. (§19.3)

Hard safety (survive verbatim): no gameplay automation, no injection, no protected-action circumvention, Lua/XML only, target `## Interface: 20506` (TBC Anniversary), Classic+ portability via guarded API reads.

**Do not invent product answers.** If the Bible and the handoff do not answer a question, append a named, bounded item to `docs/design/OPEN_QUESTIONS.md`. Do not resolve it.
