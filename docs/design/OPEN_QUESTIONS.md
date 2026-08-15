# Open Questions

Named, bounded questions the Design Bible and the Reformation handoff do not answer. **Do not invent product answers here.** David / the Design Lead resolve these.

Carried forward from Bible Appendix B (v1.1.1):

1. **Distribution:** confirm CurseForge + Wago dual publish and update cadence policy (Bible §21.3).
2. **Fight HUD feasibility:** Appendix A item 1 result decides HUD final form.
3. **Records Book categories:** §10.9 list awaits David's veto/additions — ideally checked against what members actually brag about in Discord.
4. **Curtain UX:** direction fixed (§17); interaction details open.
5. **Decree authorship:** Pope + one designated deputy is the default; confirm against real weekly logistics.
6. **Classic+ trigger:** on any official announcement, re-validate Appendix A and revisit §3 before further platform-dependent work.
7. **Council flagging of Chronicle moments:** MVP is Pope-only MARK; decide when/whether Council nomination unlocks.
8. **Registered-Pope / designated-Council configuration:** Direction (`GATE1_DESIGN_LEAD_DIRECTIVE.md` §4) — Pope list as workspace data (Ranks.lua pattern), locally overridable; Council designations in the Pope store via broadcasts. David licensed the workspace file + local SavedVariables override on 2026-08-15 (`Data/Popes.lua`; `ChurchOfBeefDB.ui.popeOverrides`). Still open: designated-Council store field and broadcast shape; any override UX beyond the SavedVariables table (no settings panel). Do not invent Council designation UX.

11. **Director Console open path:** Bible §18 names the Director Console, not a slash. David asked 2026-08-15 to host it. `/beef console` is the player-opened Pope tool (not unbidden Quiet chrome). Congregation `/beef` stays the Records Book.

Resolved by Design Lead 2026-08-14 (`GATE1_DESIGN_LEAD_DIRECTIVE.md` §4):

9. **Gora “defense”:** a victory by a sitting Beef Lord in a sanctioned Beef Gora fought after their elevation. Derived statistic from the character Gora record plus elevation timestamp — not a title-defense system. Draws/Voids are not defenses; opponent Cowardice Recorded is a defense. Phase 2 store must timestamp elevations.

10. **Free ruling vs Store `won`:** `Store:RecordGoraResult` requires `won` for every non-void ruling, including `free`. Lane C `FreeRuling` therefore writes `won = false` on both characters, which increments two losses. Bible §10.8 names a free ruling as any other Pope judgment — it does not say whether that is a win, a loss, or neither. Do not invent a fifth outcome or a silent Void.

Phase 0 process notes (not product):

- None yet.
