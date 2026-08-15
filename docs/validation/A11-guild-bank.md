# A11 — Guild bank transaction log queryability

**Appendix A item:** 11  
**Owner:** David  
**Result:** NOT RUN

Cited: Bible Appendix A item 11; §3.1 (guild banks exist, client-queryable logs); §14.3 (later-phase tithe recognition); §17 (no contribution scores); Adjudication (Important Later; no donation leaderboard).

## Dependent feature

Later-phase **tithe recognition** (§14.3). Possible on TBC because real guild banks have logs. Recognition of tithes is human and occasional — a canonized Great Tithe beats a donations table. No contribution scores. No donation leaderboard.

Appendix A: guild bank transaction log queryability.

This sheet is **method only**. Do not spec tithe UX, a donations table, or Grant/standing.

## Bible fallback

Appendix A item 11 names **no** standalone fallback. The Appendix A closer applies. A FAIL does not invent a manual tithe ledger or a gold-in-mail parser.

§3.2: guild bank is platform-dependent and isolates behind a capability check — again a portability rule, not a tithe design.

## Live-client method (Anniversary TBC, Interface 20506)

A character who can open the **guild bank** (whatever Blizzard rank permission this character actually has). `/console scriptErrors 1`. Default guild-bank UI. Do not add bank-query code to the addon.

1. **Open the bank.** Record whether this character can open the guild bank, and which tab is visible. If refused, write the exact error and stop — that is a fact.
2. **Log UI.** Open the transaction log the default UI provides (if any). Record whether deposits/withdrawals show: who, item or money, count, tab, and a time.
3. **Query (observation).** From a `/run`, request a log refresh if this client exposes one, then read one transaction if a getter exists. Record the API names that actually exist and one sanitized row (no need to paste every item). If the query API is absent, write "query API absent."
4. **Permission control.** If a second character without bank view exists, confirm they cannot read the log. Record that refuse.
5. **Write facts on this sheet.** Queryable or not; what fields a row has. No tithe product. No contribution number. No activity leaderboard.

Do not change addon Lua from this sheet.

## Not a pass

- Harness green
- §3.1 prose that logs "exist"
- An invented donations table
- Archive / store persist (item 7)

## Leftovers

- Tithe recognition (§14.3 — later phase; do not spec)
- Canonized Great Tithe as human Chronicle (not a score)
- Capability-check isolation for Classic+ (§3.2 — after this Result)
