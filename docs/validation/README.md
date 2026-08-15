# Appendix A — validation ledger

Bible Appendix A (`docs/design/Game_Design_Bible_v1.1.1.md`) is the implementation gate. Each item names a dependent feature and, where the Bible gives one, a fallback. Validate on the live Anniversary TBC client (`## Interface: 20506`) before the dependent system is treated as proven.

**Owner of in-game results:** David. Agents write method sheets only. Do not invent a Result.

Any item that fails validation triggers a design fallback decision *before* implementation improvises one (Appendix A closer).

OPEN_QUESTIONS #2 (HUD final form) waits on item 1. OPEN_QUESTIONS #8 (registered-Pope / designated-Council configuration) is not coded from these sheets.

## Ledger

| # | Item (Bible title) | Sheet | Result |
|---|--------------------|-------|--------|
| 1 | Live health of non-group units | [A01-live-health.md](A01-live-health.md) | NOT RUN |
| 2 | Duel outcome and duel-flee system messages | [A02-duel-messages.md](A02-duel-messages.md) | NOT RUN |
| 3 | Addon message sender integrity | [A03-sender-integrity.md](A03-sender-integrity.md) | NOT RUN |
| 4 | Guild roster API | [A04-guild-roster.md](A04-guild-roster.md) | NOT RUN |
| 5 | Raid target markers | [A05-raid-markers.md](A05-raid-markers.md) | NOT RUN |
| 6 | Targeting by name from UI | [A06-targeting-by-name.md](A06-targeting-by-name.md) | NOT RUN |
| 7 | SavedVariables size and write behavior | [A07-savedvariables.md](A07-savedvariables.md) | NOT RUN |
| 8 | PlaySoundFile / custom sound assets | [A08-playsoundfile.md](A08-playsoundfile.md) | NOT RUN |
| 9 | Party/raid composition and raid-leader detection | [A09-party-raid.md](A09-party-raid.md) | NOT RUN |
| 10 | Profession/tradeskill links on TBC client | [A10-profession-links.md](A10-profession-links.md) | NOT RUN |
| 11 | Guild bank transaction log queryability | [A11-guild-bank.md](A11-guild-bank.md) | NOT RUN |
| 12 | Dungeon "completion" signals | [A12-dungeon-completion.md](A12-dungeon-completion.md) | NOT RUN |
| 13 | Login/reload event timing | [A13-login-reload.md](A13-login-reload.md) | NOT RUN |

Items 1–4 are load-bearing (handoff Phase 6). Walk them on the live client early, not last.

## How a Result is written

David fills **Result** on the item sheet after the live-client method. Allowed values: `PASS`, `FAIL` (name the Bible fallback or the design decision), or `PARTIAL` (say what held and what did not). Agents do not tick these.
