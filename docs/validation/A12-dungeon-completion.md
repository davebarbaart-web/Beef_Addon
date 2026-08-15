# A12 — Dungeon "completion" signals

**Appendix A item:** 12  
**Owner:** David  
**Result:** NOT RUN

Cited: Bible Appendix A item 12; §14.3 (later-phase Expeditions; final-boss-kill heuristic); §13.2 (dungeon completions with Church majority are worth observing later).

## Dependent feature

Later-phase **Church Expeditions** (§14.3): a qualifying Expedition at ~3-of-5 Church members; witnessed completion (final-boss-kill heuristic — this item); recorded simply: dungeon, date, participants, milestone status.

Appendix A: dungeon "completion" signals (final-boss-kill heuristic **per dungeon**).

This sheet is **method only**. Do not spec Expeditions, a boss table, attendance, or a fifth Gora outcome.

## Bible fallback

Appendix A item 12 names **no** standalone fallback. The Appendix A closer applies. Do not invent a combat-log HP estimator, a generic "any elite died" rule, or an instance-lock substitute as product.

§13.2: when in doubt, do not observe. Under-observation is a missing scrapbook line; over-observation is a culture problem.

## Live-client method (Anniversary TBC, Interface 20506)

A five-person dungeon this client can enter, or the closest available instance. `/console scriptErrors 1`. Unmodified dungeon combat (Law 8's spirit: combat is WoW's). Do not add encounter code to the addon.

1. **Enter.** Record instance name and difficulty the client reports (`GetInstanceInfo` or the equivalent this client exposes).
2. **Mid-boss (if any).** On a non-final boss kill, record every completion-like signal the client actually emitted (system message text, combat-log event name, UI toast). Copy exact strings. If no mid-boss, write "no mid-boss."
3. **Final boss.** On the instance's last boss kill, record the same signals. Note what differs from step 2. That difference is the heuristic input.
4. **Second dungeon (if available).** Repeat steps 1–3 in a different instance. Appendix A says **per dungeon**. If only one instance is walked, write "single dungeon" — do not invent the rest of the TBC list.
5. **Lock / save.** After leave, record whether a saved-instance / lock API shows that dungeon. That is a lock fact, not a completion product.
6. **Write facts on this sheet.** What fired, per dungeon walked. No Expedition recorder. No Grant. No activity minutes.

Do not change addon Lua from this sheet.

## Not a pass

- Harness green
- §14.3 prose naming the heuristic
- An invented per-dungeon boss table
- Retail encounter APIs named but not seen on 20506

## Leftovers

- Church Expeditions (§14.3 — later phase; do not spec)
- Per-dungeon final-boss map (only after this Result; do not invent)
- Witness Network corroboration (§13.2 — later)
