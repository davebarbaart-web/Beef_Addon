# GATE5 — Conformance grep (live addon + TOC)

**Squad:** Phase 5 everyday-layer close (scoped lanes A–C; Ten Laws 4, 5, 6, 7, 10).  
**Scope:** `addon/ChurchOfBeef/**` (Lua + `ChurchOfBeef.toc` only).  
**Ignored:** `docs/archive/**`, `docs/reformation/**`, `attic/**`, `tests/**`.  
**Tells:** `Grant(`, points faucet, Prophet rank, standing store, activity leaderboard, `threshold`, `suggestion`; `SweepDeparted`; `SavedVariablesPerCharacter`; `SYNC_STATE` / `SYNC_REQUEST` as live product; `AWAITING_POPE` sixth state; `holdSeconds` timer; `Data/Popes.lua`; `AutoAdvance` / `Narrate`; ELO / pairing score; computed Famous Upsets; calendar / RSVP / attendance tracking as Decree product; Quiet `PlaySound` / extra sound cues / Canonization; new slash beyond `/beef` and `/beef minimap`; Decree deputy UX.  
**Classification:** BAN / DISCARD / INCIDENTAL / LIVE (same as GATE1 / GATE4).  
**Product files:** not edited this pass. No commit.

This is the signed everyday-layer skeleton (Decree Core + schema 7 persist, Quiet Decree banner + minimap replay, Event Mode Sound verb). It is not the full handoff Phase 5 list.

---

## Verdict

**Criticals: none.** **Live leftover-product count: 0.**

Phase 1 Quiet shell, Phase 2 data layer, Phase 3 runtime skeleton, and Phase 4 centerpiece remain. Phase 5 added a single-proclamation Decree (`line` + optional `flavor`), schema 7 root key `decree`, a Quiet parchment banner shown once per login and replayed from the minimap, and an Event Mode `Sound:Play` verb. None of those restore Grant, standing, Prophet, peer SYNC as authority, a sixth state, a hold timer, a registered-Pope file, a ranked ladder, a Decree scheduler, Quiet sound, Canonization, a new slash, or deputy UX.

Bootstrap still does not call Console / Hud / RecordsBook. There is no Console Post. Sound has no callers. Ritual verbs stay fail-closed (`IsRegisteredPope` always false). `#8`, SUMMON, INPUT as a live channel, clipboard, onboarding, and guild-rank writes stay uncoded. Those are named leftovers, not a demo rebuild.

Full harness at this write: **5885 passed, 0 failed**.

---

## TOC truth

Listed and present (every path exists; no extra Lua on disk):

`Data/Ranks.lua`, `Core/Common.lua`, `Core/Runtime.lua`, `Core/Store.lua`, `Core/Archive.lua`, `Core/Recognition.lua`, `Core/Knighting.lua`, `Core/Officer.lua`, `Core/Sender.lua`, `Core/Roster.lua`, `Core/Gora.lua`, `Core/Decree.lua`, `Core/DB.lua`, `Net/Codec.lua`, `Net/Snapshot.lua`, `Net/BeefNet.lua`, `UI/MainFrame.lua`, `UI/Console.lua`, `UI/Hud.lua`, `UI/RecordsBook.lua`, `UI/Status.lua`, `UI/Minimap.lua`, `UI/Decree.lua`, `UI/Toasts.lua`, `UI/Sound.lua`, `ChurchOfBeef.lua`.

`## Interface: 20506`. `## SavedVariables: ChurchOfBeefDB` (account-level). No `SavedVariablesPerCharacter`.

`Core/Decree.lua` loads before `Core/DB.lua`. `UI/Decree.lua` and `UI/Sound.lua` are listed. No `Data/Popes.lua` on disk or in the TOC.

Still absent: Scoring, Ladder, Ceremony, Instance, Quest, Standing/Ladder/Officer tabs, Announce, `Data/Popes.lua`.

---

## Critical

None.

## Important

None as live product. Named leftovers (not this grep’s job to wire):

- `ChurchOfBeef.lua` does not call `Console` / `Hud` / `RecordsBook`. `/beef` is still the Quiet empty shell. Decree banner is reached from `Minimap:Init` (PLAYER_LOGIN → `UI:Init`), not from bootstrap by name.
- No Console Post. `Console.lua` has no Decree desk and does not call `Decree:Set`.
- `Sound:Play` is unwired. Console / Gora / Knighting / HUD do not call it. Event Mode is still silent on a live client.
- `IsRegisteredPope` is always false. Console rituals and STATE/SNAPSHOT send do not fire on a live client.
- `#8` registered-Pope list is uncoded. INPUT is not a live channel. Favor is omitted.
- SUMMON, Confession channel, clipboard, onboarding parchment, and guild-rank writes (`GuildPromote` / `SetGuildRank`) are uncoded.

## Benign hits (waived one by one)

| File | Hit | Class | Waiver |
|------|-----|--------|--------|
| `Data/Ranks.lua:4` | No thresholds. No Beef Prophet. | BAN | Six titles. |
| `Core/Gora.lua:5–7` | RecordResult, GrantGora, ELO | BAN | Header forbids. Product loop is Sanction + Pope rulings. |
| `Core/Archive.lua` / `Net/Codec.lua` | `isGrantShaped` / points / standing | BAN | Import / encode refuse list. Not a faucet. |
| `Net/BeefNet.lua` | `SUGGESTION` / `RANK_COMMIT` / `SYNC_*` | DISCARD | Retired inbound types. INPUT is named as not live. |
| `Core/Runtime.lua:6` | `holdSeconds` / sixth state | BAN | Header forbids. Flag is `awaitingPope`. |
| `Core/Decree.lua:6` | calendar, RSVP, deputy | BAN | Header forbids. Stored fields are `line` + optional `flavor` only. |
| `UI/Decree.lua:7` | attendance, deputy | BAN | Header forbids. Banner paints `Get()` only. |
| `UI/Sound.lua:40–41` | `PlaySound` | LIVE | Event Mode verb. Allow-list five cues. Quiet / missing Runtime no-op. Not a Quiet cue. |
| `UI/RecordsBook.lua` | Famous Upsets / `scoreLo` | LIVE + INCIDENTAL | Upsets require `famousUpset == true` (Pope-flagged). `scoreLo`/`scoreHi` are rivalry W/L, not a pairing score. |
| `UI/MainFrame.lua:7, 564–566` | GetLadderView / `RefreshLadder` | INCIDENTAL | Comment + leftover name. Body is minimap only. |
| `ChurchOfBeef.toc:3` | Ceremony | INCIDENTAL | Notes title. |
| `UI/Toasts.lua` | envelope `hold` / `Celebrate` | INCIDENTAL + BAN | Toast dwell, not a ceremony timer. Grant kinds gone. No live `addon/` caller of `Celebrate`. |
| `Core/Common.lua:16, 29` | standing / ladder | INCIDENTAL | Identity-key warning and realm-strip rationale. No standing table. |
| `UI/Status.lua` / `UI/Minimap.lua` | standing / grants | BAN | Chip and presence forbid those reads. |

## Phase 5 shape (present, not a demo rebuild)

| Piece | Live |
|-------|------|
| Persist | Schema 7 `{ version, ui, store, event, decree }` |
| Decree Core | Single active `{ line, flavor }`. No title, deputy, expiry, wire, or Pope-list gate |
| Decree banner | Quiet parchment. Once per session; empty `Get()` stays hidden |
| Minimap | Left-click replays when a Decree is active; else `UI:Toggle`. No new slash |
| Sound | Event Mode `Play` allow-list only. Unwired. No media. No Canonization |

## Tells with zero live hits

`Grant(`, `SweepDeparted`, `SavedVariablesPerCharacter`, `leaderboard`, `elo`/`ELO`/`MMR`, Prophet rank in `Ranks.List`, `AWAITING_POPE`, `holdSeconds` as a field, `AutoAdvance`, `Narrate`, `Data/Popes.lua`, calendar / RSVP / attendance as Decree product, Quiet `PlaySound`, Canonization cue, slash beyond `/beef` and `/beef minimap`, deputy UX, SUMMON, clipboard, onboarding.

---

## Findings

### Critical

None.

### Important

None as LIVE product. Hosting leftovers, unwired Sound, missing Console Post, and the uncoded handoff Phase 5 items (`#8`, SUMMON, INPUT, clipboard, onboarding, guild-rank) are later integrator / later lanes, not a points ladder.

### Nit

1. `UI:RefreshLadder` name remains stale (GATE1 Nit).
2. Bootstrap does not host Console / HUD / Records Book (correct until a slash/host is specified).
3. `#8` remains uncoded (correct — do not invent `Data/Popes.lua`).
4. `PlaySound(name)` is a stub, not a branded bell (Appendix A #8). Do not invent kit ids here.
