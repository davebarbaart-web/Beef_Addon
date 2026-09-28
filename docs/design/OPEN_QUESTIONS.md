# Open Questions

Named, bounded questions the Design Bible and the Reformation handoff do not answer. **Do not invent product answers here.** David / the Design Lead resolve these.

Carried forward from Bible Appendix B (v1.1.1):

1. **Distribution:** confirm CurseForge + Wago dual publish and update cadence policy (Bible §21.3).
2. **Fight HUD feasibility:** Appendix A item 1 result decides HUD final form for **non-group** units. **Note 2026-09-14 (David):** ship live bars from raid/party `UnitHealth` (`player` / `raid1`–`raid40` / `party1`–`4`) so anyone running the addon in a 40-man (or party) sees HP. Out-of-party / global reads are not a commit gate. A01 Result stays owner David — do not mark PASS.
3. **Records Book categories:** §10.9 list awaits David's veto/additions — ideally checked against what members actually brag about in Discord.
4. **Curtain UX:** direction fixed (§17); interaction details open.
5. **Decree authorship:** ~~Pope + one designated deputy is the default; confirm against real weekly logistics.~~ **Resolved 2026-09-14 (David, nights-board spec):** Church nights are Pope-only (no deputy). Discord raid/PvP stubs may be posted by designated Council. See `docs/superpowers/specs/2026-09-14-nights-board-design.md`. Bible §14.1 is amended; the board is in the addon.
6. **Classic+ trigger:** on any official announcement, re-validate Appendix A and revisit §3 before further platform-dependent work. **Triggered 2026-09-12:** Blizzard announced [World of Warcraft: Forever](https://news.blizzard.com/en-us/article/24302093/carve-a-new-path-with-world-of-warcraft-forever) as the official Classic+ client (beta 17 Sep 2026; launch 4 Nov 2026). Home remains Anniversary TBC (`20506`) until David says otherwise. Child items: #22–#25. Do not start Forever-targeted code from this note.
7. **Council flagging of Chronicle moments:** MVP is Pope-only MARK; decide when/whether Council nomination unlocks.
8. **Registered-Pope / designated-Council configuration:** Direction (`GATE1_DESIGN_LEAD_DIRECTIVE.md` §4) — Pope list as workspace data (Ranks.lua pattern), locally overridable; Council designations in the Pope store via broadcasts. David licensed the workspace file + local SavedVariables override on 2026-08-15 (`Data/Popes.lua`; `ChurchOfBeefDB.ui.popeOverrides`). **Slice resolved 2026-09-14 (David, nights-board spec):** stub senders use the same pattern (`Data/Council.lua` + `ChurchOfBeefDB.ui.councilOverrides`). No settings panel. Still open: designated-Council **store field** and any broadcast shape beyond stub senders. Do not invent Council designation UX.

11. **Director Console open path:** Bible §18 names the Director Console, not a slash. David asked 2026-08-15 to host it. `/beef console` is the player-opened Pope tool (not unbidden Quiet chrome). Congregation `/beef` is the player card; the Records Book opens from that card. This line does not resolve whether a slash was the right host — only the stale Records Book clause.

13. **Presence “here”:** Bible §18.1 asks “who is here?” `GetPresence` today stamps `here = true` on every `Roster.members` row after a full guild walk. `GetGuildRosterInfo` exposes an online bit; the roster keeper does not store it, and `SetGuildRosterShowOffline` must not be flipped (`officer-guild-roster.mdc`). Unanswered: is “here” guild-online, same zone as the gathering, or something else? Do not invent a death scan, activity metric, or online leaderboard.

From the UX rebuild (2026-09-13; decisions by David unless marked open):

14. **Target-verb guild scope (open):** the console's target verbs guard on `UnitIsPlayer("target")`. The target-line copy says "guildmate" — should the verbs also require `UnitIsInMyGuild`, or may the Pope Knight/Sanction a visiting non-guild character? Do not invent the gate; today only the player check exists.
15. **Name-reuse tie-break (open):** `Store:EnsureCharacterByName` resolves a duplicate character name to the lowest-id row. §12.4 (durable character identity) stays out of scope; the tie-break is deterministic, not a claim about the human.
16. **Records Book shape (decided, pending #3):** the book is chronicle-first — a dated ledger of Knightings and bouts, then §10.9 superlative pages only when someone holds them. Nine empty parchment pages do not ship. David's veto/additions on the §10.9 list (#3) remain open; the chronicle-first shape is the rebuild's default, not a resolution of #3.
17. **Cold tools are Core-only (decided):** Archive export/import, Canonize, Rite of Recognition (alt-linking), Grant Honorific, Notebook, and the confession inbox have no UI. Core modules keep their APIs. A later "After" room (cold-state Pope work) is unnamed and undesigned — do not invent it.
18. **Rites in UI (decided):** the console surfaces Knighting and Gora only. Confession and Proclamation rites stay Core-only. Targeting a stranger and Knighting/Sanctioning them *is* the recognition (§12.2: one action, Pope present, character logged in); the kit never guesses an alt — linking a second character to an existing human waits for the parked Recognition rite.
19. **Congregation addressing (decided):** congregation sends (favor, petition, confession) default to the last accepted STATE sender, else the first listed Pope in `Data/Popes.lua`. `/beef petition`, `/beef confess`, `/beef catchup` are retired; the Pope's client re-broadcasts STATE when a guildmate HELLOs during a live event, so late joiners need no action.
20. **Player card comparison (decided):** the `/beef` card answers "how do I stand among the Church" with Church rank + its §5 relationship line, distinctions held (§10.9 superlatives), and head-to-head rivalries — never a sorted position, count-of-members-above, or rating (§10.9 permanent rejection). A rank census line ("one of seven Knights") was considered and not built; it is not open unless David asks for it.
21. **Guild title display (decided 2026-09-13):** David named the in-game guild ranks to Church titles. When the Church store has no human row, the player-card gold plate and the console presence census show the live Blizzard guild rank **name** (not slot index). A name that exactly matches a canon title (case-insensitive, trimmed) also gets the §5 relationship line. Any other live name — including the Guild Master slot — is labeled "Guild rank." That is display, not a store write and not a seventh Church rank. `ChurchRankIdForGuildIndex` stays nil. The plate does not invent "Beef Pope." If the store has a human row, the store wins — including entered-but-unranked. Knighting remains the rite that writes truth.

From the Forever / Classic+ announcement (2026-09-13; research only — David resolves):

22. **Forever port when:** §3.2 now has an official Classic+ product. Unanswered: whether Church of Beef ports to Forever at all, and whether Anniversary stays the home client through TBC. Do not add a Forever TOC flavor, installer path, or `WOW_PROJECT_*` gate until David opens that work. Beta is the measurement window (17 Sep–21 Oct 2026).

23. **Forever character identity:** Forever uses two-part, region-unique names; a client setting can hide the secondary. `UnitName` / roster / whisper strings are unpublished. Unanswered: how `Store:EnsureCharacterByName` and `COB.Names.Key` should treat Main vs full name vs a later GUID. Do not invent a schema (§12.4 stays out of scope).

24. **Forever guild / BeefNet topology:** Forever is realmless with rulesets (Normal / PvP / RP; Hardcore after launch) and no cross-ruleset grouping. Official pages do not say whether guilds, `GUILD` addon chat, or one Pope-writer star still exist across rulesets. Unanswered: can the Church remain one guild on one ruleset, or does the star need a new transport. Do not invent a cross-ruleset net.

25. **Forever packaging / store tree:** `## Interface`, TOC suffix, `AllowLoadGameType`, Battle.net product id, install folder, and whether `ChurchOfBeefDB` is a separate WTF tree are unpublished. Pre-beta lineage is encrypted `wowdev2` / `1.60.0.69818` (not a public addon host). Do not assume `_forever_`, Interface `16000`, or a shared SV file with Anniversary.

From the Wave 2 first-night review (2026-09-14; David resolves — do not invent in code):

26. **Petition-as-recognition:** Zip-fresh names are not in the Pope store. `Gora:Petition` refuses `unknown character`. Targeting + Knighting/Sanctioning is already recognition (#18). Unanswered: may the Pope client `EnsureCharacterByName` on an INPUT sender so a recruit can ask to fight, or must the desk show an unsigned name with **no** Store write until a Pope target-verb? Do not mint on congregation clients either way. Do not silent-link alts.

27. **Clerical beat on STATE:** Congregation theater cannot infer Victor vs Void vs Free vs Cowardice vs Knighting vs Elevation from Bible §20.2 fields (verdicts do not `CloseRite`). Unanswered: may PROTOCOL 2 carry a closed optional beat (plus display names) so inbound `Toasts:Proclaim` / `Sound` fire once, or does spectacle stay Pope-local until a later licensed TYPE? Do not infer kind. Do not add a generic theater opcode. Do not put W/L / H2H / stipulation / free-ruling prose on the wire in this pass.

28. **Player-card home vs ranked Gora / weekly calendar (2026-09-14):** a planning handoff asked `/beef` to grow a weekly raid/Decree calendar, a Top 3 Gora table with hidden Elo, win %, and generated Chronicle jokes. Bible §10.9 / OQ #20 reject a sorted position; Law 8 and `gora-sanction.mdc` reject Elo/hidden rating; §16 / Law 4 reject auto-generated Chronicle prose. **§14.1 calendar slice resolved 2026-09-14 (David):** Nights board is law and implemented — see `docs/superpowers/specs/2026-09-14-nights-board-design.md`. #20 stays closed (no Elo, win %, `#1`).

Resolved by Design Lead 2026-08-14 (`GATE1_DESIGN_LEAD_DIRECTIVE.md` §4):

9. **Gora “defense”:** a victory by a sitting Beef Lord in a sanctioned Beef Gora fought after their elevation. Derived statistic from the character Gora record plus elevation timestamp — not a title-defense system. Draws/Voids are not defenses; opponent Cowardice Recorded is a defense. Phase 2 store must timestamp elevations.

Resolved by David 2026-08-18 (`docs/reformation/CONTINUE_2026-08-18.md`):

10. **Free ruling vs Store `won`:** ~~`Store:RecordGoraResult` requires `won` for every non-void ruling, including `free`, so `FreeRuling` writes `won = false` on both characters — two losses.~~ **Ruled: a FREE RULING records the Pope's ruling text in the bout record and ceremony log and writes no win/loss to either character's Gora record.** Not a fifth W/L outcome and not a silent Void: the bout is recorded, sealed, and searchable; the tally is simply untouched. Store must accept a free ruling without a `won` field.

12. **Favor INPUT transport:** the Bible names congregation inputs "to Pope console only" (§18.5, §13.4) and Phase 3 codecs include INPUT, but the transport was deliberately unspecified. **Ruled by David 2026-08-18: favor picks travel as INPUT whisper-to-Pope on the kept BeefNet transport** (mirror of SNAPSHOT's whisper path). The Pope's client tallies; the split reaches the congregation only via STATE when the Pope's per-event display toggle is on (§10.6). Still banned regardless of transport: favor history, streaks, accuracy records, favor economy, wagering.

Phase 0 process notes (not product):

- None yet.
