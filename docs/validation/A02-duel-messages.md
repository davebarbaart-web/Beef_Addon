# A02 — Duel outcome and duel-flee system messages

**Appendix A item:** 2  
**Owner:** David  
**Result:** NOT RUN

Cited: Bible Appendix A item 2; §10.3; §10.8; Law 4; Law 8.

## Dependent feature

Auto-proposed verdicts and **COWARDICE RECORDED** (§10.8). Duel results surface as system messages visible to nearby players; the software **proposes** the outcome and the Pope **ratifies** with one action — DECLARE VICTOR, COWARDICE RECORDED, VOID, or a free ruling. Automation drafts; the human rules; the record shows the Pope's ruling, not the parser's guess.

Appendix A: exact formats, locale variance, visibility range.

§10.3 practice default: the flee system message proposes COWARDICE RECORDED. That proposal is not a declare.

## Bible fallback

Pure manual verdict (one tap; already required as override) — Appendix A item 2.

The shipped Gora desk is already that override: `Gora:Propose` is caller-supplied; the Pope taps DECLARE VICTOR, COWARDICE RECORDED, VOID, or a free ruling. No chat parser. **Do not invent auto-propose from duel chat.** A PASS on this item would unlock a proposer later; it does not ship one from this sheet.

## Live-client method (Anniversary TBC, Interface 20506)

Unmodified WoW duel in the world (Law 8). Two fighters plus at least one nearby witness. `/console scriptErrors 1`. Default client locale first (record the locale name).

1. **Win.** Fighter A defeats B. Copy the exact system message text (punctuation, names, realm suffix if any) as seen by: each fighter, a nearby witness, and (if a fourth client exists) someone outside typical duel range.
2. **Flee.** One fighter declines or runs so the client emits the duel-flee message. Copy the exact text at the same three distances.
3. **Locale.** If a second client locale is available, repeat win + flee and note whether the format changes. If not available, write "single locale" — do not guess other locales.
4. **Visibility range.** Note the farthest distance at which the witness still saw the message, and whether a distant /reload client sees it after the fact (it should not — this is a live system message, not a log replay).
5. **Write the strings on this sheet.** No parser. No auto-declare. No combat-log substitute.

Do not change addon Lua from this sheet.

## Not a pass

- Manual Console verdict buttons existing
- `Gora:Propose` accepting a caller table
- Harness cases on `DeclareVictor` / `CowardiceRecorded`

Those are the fallback, not item 2.

## Leftovers

- Auto-propose from chat is not coded and is not invented here
- VOID / free ruling stay Pope judgment (§10.8); this item does not invent extra outcome enums
- Locale coverage beyond the clients David actually has
- Raid/party 1 HP proposer may ship (David 2026-09-14): raw UnitHealth == 1
  on one sanctioned fighter, partner > 1, Gora:Propose only. Not this item.
  This sheet remains system-message formats / range / locale.
- “I lost” INPUT and CHAT_MSG_SYSTEM parser stay parked.
