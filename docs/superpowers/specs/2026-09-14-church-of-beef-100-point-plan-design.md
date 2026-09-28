# Church of Beef — 100-point continuation plan

**Date:** 2026-09-14  
**Status:** Design law for the next development pass. **Wave 2 revised** the same day — see `2026-09-14-church-of-beef-wave-2-review.md`. Items marked REWRITE / DROP in §8 win over the original sentence. Not an implementation license to invent product.  
**Authority:** Design Bible v1.1.1 → Peer Review Adjudication → Demo Build Audit → Reformation handoff → `OPEN_QUESTIONS.md`. On conflict, the Bible wins. This spec is subordinate.  
**Definition of done (unchanged):** Bible §22.3 — one complete real Gathering. A green harness does not tick it. Agents may claim `POLISH:CANDIDATE` only.

User waived section-by-section approval. The zip-install recruit who has never heard of a Gora is the test user. So is a first-time Twitch viewer. Thedave on opening night is a second test user: he knows the Church, not this desk.

**Wave 2 addendum (read first):** Congregation must not call `EnsureCharacterByName`. STATE display names require a PROTOCOL bump, not “no new protocol.” Inbound Proclaim waits on OPEN_QUESTIONS **#27**. Petition mint waits on **#26**. First executable slice is `docs/superpowers/plans/2026-09-14-church-of-beef-first-night-wave-2.md`. The 2026-09-14 congregation plan is superseded.

---

## 1. Honest diagnosis

The Reformation built the *right* product’s skeleton and then dressed it. What exists on this checkout is a **Pope-client Gathering kit that is coded and harness-green, and a congregation product that still fails a second human.**

Quiet Tuesday is close to the Bible: hideable minimap, one Decree, `/beef` as a player card. `/beef console` is a target-driven desk for listed Pope **Thedave**. Sanction, four rulings, favor whisper, HELLO catch-up, Decree wire, mute fighter card, no-health HUD, and five stock-kit cues exist — **on the writer’s machine.**

A brand-new member who installed a zip because Discord said “get the addon” gets:

- No §19.5 welcome parchment.
- A card that says **UNRECORDED** / “Not yet in the Church's record.”
- Rank glosses that paint Bible *headings* (`Recruitment`, `Engagement`) instead of the sentences the Bible already wrote.
- `/beef help` is not a command; unknown arguments toggle the same card; `/beef console` opens the Director desk and stamps `not a registered pope`.
- On Gathering night, **Petition** and **favor plates** require a `localCharacterId` from *this client’s* Store. The Store is not on the wire. A zip-fresh name cannot ask to fight or pick a side, and the UI gives no reason.
- STATE carries store **ids**. Congregation HUD and fighter cards resolve names from an empty local Store. Theater is hollow.
- `Toasts:Proclaim` and Sound run only on the Pope’s local verb wraps. Congregation never sees the sanction sheet, knighting parchment, or hears the bell.
- Version skew chats engineer copy and does **not** drop theater. Pope `/reload` can restore Runtime as `RITE` while the Gora desk (petitions, sanctioned pair, favor) is memory-only — verdicts then refuse `no sanctioned gora`.
- Every client restores Event Mode from SavedVariables. A congregation logout mid-event can wake up in Event chrome with no Pope.

Gates still OPEN, owner David: Gate 6 (A01–A04 Results), Gate W (two-client smoke), Gate U item 5 (screenshot / `POLISH:PASS`). Dress rehearsal and §22.3 are unwalked. `docs/phases/` leftover tables still claim Console / HUD / favor / Popes are unhosted. That is false and will make the next agent rebuild shipped work.

**Harness (this checkout):** 15,993 passed, 0 failed. That is a precondition.

---

## 2. The newcomer test (hard)

A randomly invited Fresh Beef who has never read the Bible must, without coaching:

1. Understand on first launch that this is the guild’s meetup-and-duel addon, not raid tools.
2. Know that Tuesday is supposed to be almost nothing.
3. Open their name (bull left-click or `/beef`).
4. On Gathering night, **ask to fight** and **pick a side**, with the verbs announcing themselves.
5. See two named fighters and a winner they can explain to a Twitch chat.

If any of those fail, the night fails §22.3 even if the Pope’s desk is perfect.

Law 6 still holds. Do not “fix Quiet” with a feed, a tutorial OS, a settings wall, or Discord-inside-WoW. The one allowed welcome is §19.5: one parchment, first launch only, then silence.

---

## 3. Approaches

**A — Gathering-first close.** Walk two-client and a small night as soon as possible; treat copy and congregation bind as polish.  
*Trade-off:* fastest path to “we ran something.” The something will look like a private Pope tool. Recruits and Twitch still will not understand it. Fails the newcomer test on purpose.

**B — Newcomer-first comprehension.** Welcome parchment, plain verbs, Arabic records, congregation bind, inbound Proclaim, names on the wire — then walk the night.  
*Trade-off:* delays Archive / Notebook / SUMMON. The first night is actually public.

**C — Split tracks, newcomer-weighted.** Wave 0 honesty (stop lying in docs). Waves 1–3 make a second human able to join and see. Wave 4 keeps the Pope from losing the room on `/reload`. Wave 5 hardens the star. Wave 6 is David’s walks. Waves 7–8 are memory and dress. Forever, Curtain, Council UX, Witness, Expeditions stay parked.

**Recommendation: C.** A repeats the demo failure mode (well-engineered, wrong audience). B is the right *priority* but needs C’s sequencing so Pope persist and two-client proof are not skipped. Stretch (SUMMON, clipboard, custom bells) may slip one release. Congregation bind + inbound theater + Pope reload persist **may not.**

---

## 4. Architecture (what to extend, not rewrite)

Keep: `Store`, `Runtime`, `Archive` codec, `Ranks`, `Sender`, `BeefNet` transport, Gora ruling verbs, target-driven Console, PlayerCard, Records Book, Theme fallbacks.

Integrator remains `ChurchOfBeef.lua` `InstallWire`. UI never records official outcomes. Net never invents ranks or verdicts. Core never `CreateFrame`. Data never reads SV.

**Allowed without a new TYPE** (PROTOCOL may bump; that is not store-gossip)

- Packed **display names** on STATE/SNAPSHOT (fighters / candidate only). Paint-only. Never upsert congregation Store. Cap 240 bytes through `Net:Send`. Fail-closed on `:` in a name.
- INPUT apply keyed to the **server sender**. Keep Codec `characterId` so the body stays closed; **ignore** it as authority.
- Unsigned desk row for an unknown sender (name-key in Gora memory). No congregation `EnsureCharacterByName` / `CreateHuman` / `LinkCharacter`.
- Latest-wins: ceremony fields apply only if `sequence` is **greater**. Favor overlay when `eventId` matches and `sequence >= current`. Equal sequence must not Proclaim / Sound.
- HELLO / favor STATE coalesce to the **token bucket** (burst 10, refill 1/s), one live STATE per current sequence — not an invented 10 Hz wire rate.
- `RequestSnapshot` only after an accepted Pope HELLO or live STATE this session, local still QUIET. Never on a cold Tuesday from `Popes.List[1]` alone.
- `MarkPopeLost` paint-only when a detector David licenses exists. **No** `holdSeconds`. No self-promote. Until #13 or a hold policy is answered, document the hole.

**Do not invent**

- Store-gossip, peer SYNC, SUMMON protocol, RAID product channel, generic theater opcode, settings-panel Pope list, designated-Council UX, Curtain widgets, Forever TOC, HUD health hacks, pairing scores, computed Famous Upsets, petition TTL **numbers**, sixth Runtime state.
- Congregation identity rows, W/L / H2H / title / stipulation / clerical kind on the wire this pass, inferred Proclaim copy, “The Pope ruled.”
- Answers to OPEN_QUESTIONS **#26** (petition-as-recognition) or **#27** (clerical beat). Night-one defaults are in the Wave 2 review §4.

If a closed beat is still required for inbound spectacle, that is **#27** — already filed. Do not silently add a theater opcode.

---

## 5. Data flow after this plan

```
Pope verbs → Core write → persist debounce (Pope only) → STATE (ids + packed names + optional favor)
Congregation: Accept → Restore Runtime → paint HUD/card from last accepted payload (no Store upsert)
Inbound Proclaim/Sound: off until OPEN_QUESTIONS #27; Pope wrap stays local
Congregation inputs: whisper INPUT → Pope apply by server sender → unsigned desk or known row → coalesced STATE
Late join: HELLO → coalesced STATE; RequestSnapshot only after HELLO/STATE this session if still QUIET
Pope /reload: restore Gora desk + sendState (self-HELLO is skipped)
Pope lost: paint awaitingPope only if a licensed detector exists → no self-promote
Stale protocol: discard + §13.4 Quiet notice + drop Event chrome
```

---

## 6. Error handling

- Disabled Petition / dead favor plates must say **why** on the face of the surface.
- Markers / TargetUnit refuse: desk-visible, not only a view flag.
- `initUi` failures: one chat line; **always** reach `Net:Init()`.
- `Store:Restore` / Archive: fail-closed on Prophet / Grant-shaped rows.
- Empty Snapshot arrays do not wipe a live store unless the operator imported that blob.
- Version mismatch: one Quiet notice per session, then silence.

---

## 7. Testing

- Offline: `lua tests/run.lua` exit 0 after every Core/Data/Net/glue change. Pin new fail-closed cases (latest-wins, congregation restore QUIET, sender-bound INPUT, empty-snapshot no wipe).
- Stop pinning leftover product as law (`Gora:Challenge` forever, `Archive.Remind == nil`, `#8` always false).
- In-game: skill install → `/console scriptErrors 1` → `/reload`. Two clients for any wire item.
- Agents do not tick `docs/phases/*` or Appendix A Results. David walks those.
- Preview: regenerate `docs/design/renders/responsive/` from current `preview_dump.lua` before treating PNGs as the product.

---

## 8. The 100 points

Owner: **A** = agent (may implement). **D** = David (walk, Result, or product answer). **A→D** = agent prepares; David closes.  
Priority: **P0** first-night / law. **P1** night quality. **P2** proof / dress. **P3** memory / polish.

### Wave 0 — Stop lying to the next agent

| # | Item | Pri | Own | Evidence |
|---|------|-----|-----|----------|
| 1 | Rewrite the leftover table at the bottom of `docs/phases/v1-checklist.md` so it matches the honesty section (Console, HUD, Records, favor, Popes, Decree wire are coded). | P0 | A | Stale table vs live TOC |
| 2 | Rewrite `docs/phases/dress-rehearsal.md` against the current product. Keep Status: NOT RUN. | P0 | A | Script still describes the empty shell |
| 3 | Rewrite `docs/phases/guild-night-playtest.md` (`/beef` is the card; favor is coded; Console sends STATE). | P0 | A | Walking it as written fails |
| 4 | Refresh A03 / A05 / A06 / A13 leftover lines (`Thedave` listed; Markers calls `SetRaidTarget` / `TargetUnit`). Results stay NOT RUN. | P0 | A | Sheets describe Phase 3 stubs |
| 5 | Fix `README.md` “The Decree is forthcoming.” | P0 | A | Decree ships |
| 6 | Amend `OPEN_QUESTIONS.md` #11 congregation `/beef` sentence to the player card. Do **not** mark #11 resolved. | P0 | A | Done in Wave 2 review; keep the row so leftover docs stay honest |
| 7 | Fix `Net/BeefNet.lua` header that still says STATE send is always false until `#8`. | P0 | A | `Data/Popes.lua` ships `Thedave` |
| 8 | Delete or regenerate repo-root `ChurchOfBeef.zip`; gitignore it. The 2026-08-20 zip still contains MainFrame / Status / ConsoleDock and has no PlayerCard. | P0 | A | Handing that zip installs a retired UI |

### Wave 1 — First 90 seconds (newcomer Quiet)

| # | Item | Pri | Own | Evidence |
|---|------|-----|-----|----------|
| 9 | Build the one §19.5 welcome parchment. First launch only (`ChurchOfBeefDB.ui` flag). Then never again. Not the Decree. Not a toast. Not a feed. | P0 | A | No welcome surface exists |
| 10 | Welcome copy, one sheet: meetup night + sanctioned duels; Tuesday is the bull + a notice when posted; left-click / `/beef` opens your name; when the gathering starts, **Ask to fight**; when two names appear on the fight bar, click a name to pick a side; you do not run the show. If a Decree or live event is already up, do not stack a second parchment (Decree *is* the sheet, or welcome waits until closed — one surface). Close. | P0 | A | Bible §19.5, §21.2; Wave 2 — do not say “click a name” before a HUD exists |
| 11 | DROP from first-night. TOC `## Notes` already reads “Ceremony, sanctioned Gora, and memory…”. Optional later: drop the word Gora. Keep Interface `20506`. | P3 | A | Already parseable |
| 12 | `/beef help` prints one chat line (bull / `/beef` = your name; night = Ask to fight, then pick a side when two names appear). Not a command dump. Do not advertise `/beef console` to congregation. Listed Pope may get a second chat line that the desk is `/beef console`. | P0 | A | Unknown args silently toggle the card |
| 13 | Unknown slash arguments must not toggle the card as if they were `/beef`. | P1 | A | Recruits think the slash is broken |
| 14 | Gate `/beef console` (hide or refuse) for non-Popes. Congregation is theater, not administration (§18.5). | P0 | A | `Console:Show` is ungated |
| 15 | Unrecorded copy: gold plate stays a **real** title or the live guild rank (#21). Newness lives on the relationship line (“The Pope has not written you yet. That is normal.”). Do not paint `NEW` as if it were a seventh rank. In-guild zip recruits often never hit this branch — that is #21, not a bug. | P0 | A | `PlayerCard.COPY`; Wave 2 |
| 16 | DROP as written. Only Knight / Lord / Butcher have Bible sentences. Leave Fresh / Cooked / Council as headings. Optional later: paint the three quotes that exist. | P3 | A | Inventing §5 copy |
| 17 | PARK. Do not invent “Your card / History.” Keep `CHURCH RECORDS` unless David names the pair. Book Close may still return to the card (#50). | P3 | A | New product language |
| 18 | Replace `Net:_WarnVersion` with the §13.4 sentence (“the Church's software has advanced”) plus “update the addon.” One chat or Quiet parchment per session. No toast family. | P0 | A | Engineer copy; theater not dropped |
| 19 | Version mismatch must drop Event chrome to Quiet presentation (already discard the message). | P0 | A | `test_net_v2.lua` pins live event surviving skew |
| 20 | Empty Records Chronicle: say this is the guild’s dated fight-and-ceremony log and it fills in after a Gathering. Keep “Nothing has been written yet.” as the honest empty. | P1 | A | `RecordsBook` empty leaf |
| 21 | PARK. Bible already defines Iron Chin / Martyr. Subtitles are polish. #3 stays open — do not dress a tenth category. | P3 | A | Not first-night |
| 22 | Align minimap tooltip, Decree description, and player-card Gathering plate on “meetup notice — where and when.” Keep the decreed header as pomp. | P1 | A | `Minimap` / `Decree` / `PlayerCard` |

### Wave 2 — Congregation can participate

| # | Item | Pri | Own | Evidence |
|---|------|-----|-----|----------|
| 23 | REWRITE. Congregation must **not** call `EnsureCharacterByName`. Bind is a UI sentinel (I have a name), not a Store row. INPUT sends without a trusted local id. Pope apply is item 29. Unknown sender = unsigned desk name. OPEN_QUESTIONS **#26** if David wants petition-as-recognition. | P0 | A | Law 5; Wave 2 §2.1 |
| 24 | Disabled / failed **Ask to fight** must state a reason that can actually fire: send failed; not in a guild; you already asked (no TTL number); this is a Knighting, not a fight. Do not lock “Event is not live” on a hidden strip or “not written” after a local mint. | P0 | A | Wave 2 — locked reasons were dead |
| 25 | Face of the button reads like **Ask to fight**. “Gora” may follow in the tooltip after the English. | P0 | A | `Petition` + Gora tooltip |
| 26 | Tooltip: you are asking the Pope to consider you for tonight’s sanctioned duel. Targeting another player names them if that name is already written; an unknown name must **not** refuse the ask. | P0 | A | `unknown opponent` eats zip-fresh pairs |
| 27 | HUD name plates: hover “Click to pick this side.” Cursor/tooltip required. | P0 | A | `Hud.lua` `clickPlate` — no OnEnter |
| 28 | Favor click must not silent-return. Face line if there is no fight yet / already picked. Congregation footer **Pick a side** before the first pick; keep the split after. | P0 | A | `clickPlate`; Wave 2 |
| 29 | Apply INPUT using the **server sender**. Ignore payload `characterId`. `RecordFavor` must refuse unknown **or** key the pick by sender name-key in memory (no Store write). Dedup by the resolved key. Do not mint opponents. | P0 | A | `BeefNet` `_HandleFavor` / `_HandlePetition` |
| 30 | Hide the Inputs strip on the registered Pope client. The desk already has petitions. **P0** (was P1). | P0 | A | Stream noise; two-client desk test |
| 31 | Rename `EVENT INPUT` / `No recipient` to the verb and an honest dest (listed Pope vs last STATE sender). The label must match `_DefaultDest`. | P1 | A | Strip can lie vs send dest |
| 32 | Congregation HUD footer: **Pick a side** or **Crowd** — keep the split percents. `FAVOR` may stay as a small rubric. | P0 | A | Stream cannot tell the plates are buttons |
| 33 | Dual-encode records: Arabic `0–3` or `0 wins, 3 losses` as the readable value. Romans may remain ornament. **P1** — blank names kill the night, not Roman numerals. Do not spend the STATE budget on this. | P1 | A | `romanPairText` on HUD and card |
| 34 | Label HUD defenses and head-to-head the way the fighter card already does. Unlabeled Romans read as a ranking. **P1** (same reason as #33). | P1 | A | `Hud.lua` vs `FighterCard.lua` |
| 35 | Fighter-card **Stipulation** gloss as tonight’s rule. Value stays the Pope’s line. | P1 | A | Lawyer-Latin on the tape |
| 36 | Do not mint ranks, standings, or a second writer to “help” congregation bind. | P0 | A | Law 1, 5, 9 |

### Wave 3 — Congregation can see the spectacle

| # | Item | Pri | Own | Evidence |
|---|------|-----|-----|----------|
| 37 | Inbound `Toasts:Proclaim` + `Sound:Play` **wait on OPEN_QUESTIONS #27**. Until then, Pope wrap stays local. If David licenses a closed beat: fire once on accepted Pope STATE, Event Mode, not `IsSelf`, not HELLO/favor/snapshot, unknown kind refuse. Do not infer kind from `state`+`riteType`. Do not generate oratory. | P0 | A | Verdicts do not CloseRite; Wave 2 §2.2 |
| 38 | REWRITE. PROTOCOL 2 packed **display names** only (fighters / candidate). 240-byte pin through `Net:Send`. Snapshot overlay + inbound stash for paint. No W/L, H2H, title, stipulation, clerical kind this pass. Never upsert congregation Store. | P0 | A | Closed codec; `MAX_BODY` 240 |
| 39 | Either show congregation HUD on ASSEMBLY sanction, or stop allowing SANCTION before Open Gora. Pope HUD and congregation HUD must agree. | P0 | A | `Console` `pairEdit` vs `Hud` `livePair` |
| 40 | `Void.` → “This fight does not count.” `Free ruling.` stays `"Free ruling."` or the Pope’s text; **omit** the sheet if text is absent. Do not write “The Pope ruled.” Sanction headline: keep pomp, add one plain “sanctioned duel” line. Cowardice headline must say fled. | P1 | A | Law 4; Wave 2 stream |
| 41 | Sanction title card may keep pomp; add one plain line that this is a sanctioned duel (names are already there). | P1 | A | “A Beef Gora is Sanctioned” |
| 42 | Cowardice headline must remain readable as a flee if the viewer never learns the office. Keep the seal line. | P1 | A | Stream table |
| 43 | Knighting / elevation parchment: keep `RISE, BEEF KNIGHT` / `LORD`; do not add a joke. Optional one clerical clause only if it stays mute. | P2 | A | Spectacle without belonging/proof |
| 44 | Latest-wins: ceremony fields only if `sequence` **greater**. Favor overlay if `eventId` matches and `sequence >= current`. Different `eventId` still applies. Equal sequence must not Proclaim. Snapshot `ApplyResponse` uses the same rule. | P0 | A | `RecordFavor` does not bump sequence |
| 45 | `RequestSnapshot` only after accepted Pope HELLO or live STATE this session, local still QUIET. Tuesday no-response is not a failure. Keep HELLO rebroadcast. Not a `/beef catchup`. | P0 | A | QUIET snapshot is `no event`; Wave 2 |
| 46 | Do **not** apply SV Runtime on congregation at `PLAYER_LOGIN`. `DB:Init` at `ADDON_LOADED` must not gate on `UnitName` (Pope would skip event restore). Congregation starts QUIET and waits for accepted Pope STATE/snapshot. | P0 | A | `DB:Init` restores `event` for everyone |
| 47 | Paint `awaitingPope` only when the flag is already set. **Do not** invent a disconnect detector or hold timer. Complements parked #73. | P1 | A | Flag exists; no licensed sensor |
| 48 | Pope login/`/reload` during a live event must `sendState()` once after `InstallWire`. Self-HELLO is skipped today. Pairs with #51. | P0 | A | `InstallWire` + `DB` Restore |
| 49 | Player card and Records Book must not stack. Opening one hides the other. | P1 | A | `/beef` toggles card on top of the book |
| 50 | Records Book needs a return to the player card (the door we already named in #17). | P1 | A | Book has no Home / Your card |

### Wave 4 — The Pope does not lose the room

| # | Item | Pri | Own | Evidence |
|---|------|-----|-----|----------|
| 51 | Persist the live Gora desk (`sanctioned`, petitions, favor picks, `lastSanctioned`) across Pope `/reload`. | P0 | A | Memory-only; verdicts refuse after reload |
| 52 | Persist the Knighting line the same way. | P1 | A | `Knighting` locals |
| 53 | Persist the Confession inbox the same way (still no congregation confession UI — #17). | P2 | A | `Confession.inbox` memory-only |
| 54 | Snapshot Store + event after Pope writes (short debounce), not only `PLAYER_LOGOUT`. | P0 | A | Crash loses the night |
| 55 | Needs-Knighting from **store rank** / “Add to the line” only. Presence stays a census — do not paint it as a queue. “Who is here?” waits on #13 / #88. Night-one working lists: target line + Knighting strip + petition strip. | P1 | A | Mixing census with #13 |
| 56 | Stop fail-opening “everyone in the Store is present” while the roster walk is incomplete. Prefer empty / unknown over a fake full pool. | P1 | A | `presentCharacterIds` |
| 57 | After David writes A04: `KNIGHT THIS BEEF` may `GuildPromote` / set-rank **on the Pope client only**, capability-guarded. Never congregation. Never a ritual gate. | P1 | A→D | Bible §8; Console “No GuildPromote” |
| 58 | Desk-visible refuse when marks fail (not in a group / no assist). | P1 | A | `Markers` silent |
| 59 | Skip `TargetUnit` in combat lockdown. Do not add `SecureActionButton` now. | P1 | A | A06 unproven; taint rule |
| 60 | Guard double-click re-knight / re-elevate on stream (Pope may still override). | P1 | A | Duplicate ceremony rows |
| 61 | Surface `Gora:Recommend` as glanceable context on the current pair (levels, H2H, named-opponent). No pairing score. No auto-sanction. | P2 | A | Bible §10.5; UI cut it |
| 62 | One Pope verb to `FlagFamousUpset` (desk or cold). Never compute the page. | P2 | A | API unused |
| 63 | Either ship keybinds for MARK + primary verbs or append a named OPEN_QUESTION. Do not invent a bind UI. | P2 | A | §18.1; zero `SetBinding` |
| 64 | Wire `Roster:SetOnChanged` to the open Console (and card if shown). | P1 | A | Callerless leftover |
| 65 | `Roster:GetMembers()` returns a copy. Stop reading live `Roster.members`. | P1 | A | Layer / copy law |
| 66 | `pcall` **every** `Init`, including Hud, PlayerCard, Minimap, RecordsBook. | P0 | A | Hud unpcall’d |
| 67 | `pcall` Hud/Inputs Init. If `BackdropTemplate` errors on the **live** 20506 client, drop the inherit. Do not claim the template is absent until the client says so. Theme textures already paint the iron. | P0 | A | Harness stub never throws |
| 68 | Fail-soft `initUi`: one chat line on failure; **always** reach `Net:Init()`. | P0 | A | Minimap→Decree unpcall’d |

### Wave 5 — Star hardening (not a 40-person invention)

| # | Item | Pri | Own | Evidence |
|---|------|-----|-----|----------|
| 69 | Coalesce HELLO-triggered STATE to one broadcast per current sequence, not one per peer HELLO. | P0 | A | 40 logins → 40 `sendState` |
| 70 | Coalesce `RecordFavor` → STATE to the **outbound token bucket**, one STATE per current sequence. Do not invent a 10 Hz wire rate (that is the UI dirty cap). | P0 | A | Burst 10 / refill 1/s |
| 71 | Put congregation whispers on the outbound budget. Favor/petition/snapshot currently bypass the token bucket. | P1 | A | `_TransmitWhisper` immediate |
| 72 | Replace inbound-table wipe at 200 keys with evict-oldest. Do not reset the Pope’s tokens. | P1 | A | `BeefNet` `_AllowInbound` |
| 73 | PARK with #47. Do not code a “no STATE for N seconds” detector (that *is* a hold timer). Paint only if David licenses a discrete client signal. | P2 | A | OPEN_QUESTIONS #13 |
| 74 | Align `Store:Restore` with Archive fail-closed (refuse Prophet / Grant-shaped keys). | P1 | A | Leftover keys pinned as keep |
| 75 | `DB:restoreFromSv` must check Restore return values. | P1 | A | Failures ignored |
| 76 | Empty Snapshot arrays (`humans = {}`, `characters = {}`) must not wipe a live store on ordinary `Init`. Import of an empty Archive remains an operator action. | P1 | A | `DB.isSnapshot` |
| 77 | Quarantine leftover `Gora:Challenge` / `GetPending` / invented `CHALLENGE_TTL = 1800`. Product loop is Petition. | P1 | A | Audit V4 residue |
| 78 | Remove unused `Group.CountGuildmates`. | P2 | A | Law 2 smell |
| 79 | `Gora.writeBoth` fail-closed (both characters or neither). | P1 | A | Asymmetric bout |
| 80 | Walk `docs/phases/two-client-smoke.md` on two Anniversary clients (Thedave + congregation). Include default dest, HELLO rebroadcast, fighter-card self-echo skip, **and** items 23–38 once they land. | P0 | D | Gate W NOT RUN |

### Wave 6 — Proof David must walk

| # | Item | Pri | Own | Evidence |
|---|------|-----|-----|----------|
| 81 | Walk `solo-smoke.md` after install + `/reload` (`scriptErrors`, BugGrabber + BugSack). | P0 | D | NOT RUN |
| 82 | Write Appendix A **Results** for A01–A04. Agents do not tick. Gate 6 stays open until this. | P0 | D | Ledger NOT RUN |
| 83 | Walk A05 / A06 / A08 / A13 live now that Markers, `PlaySound`+SOUNDKIT, and login banner exist. | P1 | D | Sheets stale; features shipped |
| 84 | Small guild-night playtest (Tuesday size, not chaos) after #80. | P1 | D | §4.11 |
| 85 | Dress rehearsal: late arrival, `/reload`, Pope disconnect, no-show petitioner, disputed Gora. Scribe confused-client windows (5s / 30s quality bar — not a coded timer). | P0 | D | §22.3 release gate |
| 86 | Gate U screenshot / taste pass. First live check: four distinction lines vs the History button at default scale. | P1 | D | `POLISH:PASS` is human |
| 87 | Confirm **Thedave** is the live writer, or David adds a name / `popeOverrides` himself. Agents do not invent names or edit WTF. | P0 | D | `#8` remainder |
| 88 | Answer or explicitly defer for night one: #13 (here), #14 (guild-scope). Do not invent in code first. | P1 | D | Soft §22.3 roster-avoidance |
| 89 | Keep `## Version: 0.1.0` as **alpha**. No CurseForge/Wago Release until #85 and OPEN_QUESTIONS #1. | P2 | D | §21.3 |
| 90 | §22.3 streamed Gathering. Unticked until a human night. Agents never claim this. | P0 | D | Canonical done |

### Wave 7 — Memory and cold (after a night can run)

| # | Item | Pri | Own | Evidence |
|---|------|-----|-----|----------|
| 91 | DROP until David reopens #17. Archive export/import has **no UI**. Core codec stays. | P3 | A | OPEN_QUESTIONS #17 |
| 92 | DROP. “Do not invent reminder widgets.” Bible wants a cold reminder; widget shape is unlicensed. | P3 | A | identity-records |
| 93 | Add a Pope Notebook **Core** API (private per member). No UI unless David reopens #17. | P2 | A | Header claimed Core-only; no module |
| 94 | Gate `CanonizeMoment` to cold / QUIET (§16). | P2 | A | Write exists; no cold check |
| 95 | Stamp honorifics as events (`at` + ceremony row), still plain text, no mechanics. | P3 | A | `AddHonorific` is a string list |
| 96 | `SetRank` appends membership history (`created` / `linked` / `inactive` is not enough). | P3 | A | Rank changes invisible on the tape |

### Wave 8 — Dress, assets, hygiene

| # | Item | Pri | Own | Evidence |
|---|------|-----|-----|----------|
| 97 | Regenerate `docs/design/renders/responsive/` from current `preview_dump.lua`. Delete stale `dashboard` / `dock`. Add `card` / `card_empty`. | P1 | A | Renders show the retired product |
| 98 | Protect ImageGen stems so `make-geometry-placeholders.py` cannot overwrite papal / victor / gora / minimap. | P2 | A | Operational footgun |
| 99 | Provenance table (ImageGen vs geometry vs OFL). Do not ship variable `[wght]` TTFs in the zip. Keep SOUNDKIT; no ripped OGG. | P2 | A | License / Friz-fallback risk |
| 100 | In-client smoke of PlayerCard 380/580, Console 560×600, Petition-only Inputs, ImageGen seals at real sizes. Geometry already ships — this is a David walk, not an implement-geometry ticket. Claim `POLISH:CANDIDATE` only. | P1 | A→D | Geometry still reads “dev test” until David says otherwise |

### Wave 2 appendix — Pope desk + night copy (missed by the first 100)

| # | Item | Pri | Own | Evidence |
|---|------|-----|-----|----------|
| 101 | Listed Pope gets a desk door: control on **his** player card and/or a slash chat line when `IsRegisteredPope`. Bare `/beef` must not look like the kit failed. | P0 | A | `SlashCmdList`; card has CLOSE + CHURCH RECORDS only |
| 102 | `PHASE_HINT` names the **next verb** in English, not only the rite. Quiet → post notice or start; Assembly → target then knight, or set two fighters then sanction. Keep pomp on the iron plates. No wizard. | P0 | A | `Console.lua` `PHASE_HINT` / `RITE_HINT` |
| 103 | Paint verb refusals on `GateStatus` (or the target line). `after()` must not swallow `"Set Fighter A and Fighter B first"`, `"event ends from assembly or consequence"`, etc. | P0 | A | `GateStatus` only shows not-a-pope |
| 104 | Petition row fills the next empty Fighter A/B slot, or the row label says “use this petitioner.” Does **not** auto-sanction. | P0 | A | Row click is `SelectCharacter` only |
| 105 | Pair **names** select the subject. `DECLARE VICTOR` commits. `PairVictorA` / `PairVictorB` must not call `DeclareVictor` on the name buttons. | P0 | A | Fat-finger mid-duel |
| 106 | After a successful ask, the Inputs strip says asked / waiting. Named unknown opponent does not eat the ask. | P0 | A | `Inputs:Petition` paints nothing |
| 107 | Hide or disable Ask to fight during a live Knighting. One line: this is a Knighting, not a fight night. | P1 | A | `eventLive()` is any non-QUIET |
| 108 | When Runtime ≠ QUIET, the existing card Gathering line and minimap tooltip (if shown) say the gathering has started. No toast. Do not reopen welcome. | P0 | A | Only signal today is the 64px strip |
| 109 | After End the gathering, do not leave a posted-meetup Decree looking live. Either the Pope verb clears the notice or the Gathering line goes past tense on QUIET. Not auto-narration. | P1 | A | Recruits stay in town |
| 110 | HUD after a ruling must read as ruled (winner name, or hide favor) until Continue. Do not keep `lastPair` + `VS` + `FAVOR` as if the duel is on. | P0 | A | `displayPair()` through CONSEQUENCE |
| 111 | Congregation fighter card must not resurrect on post-verdict `RITE` + lastPair. | P0 | A | `_HandleState` wrap |
| 112 | Not-in-guild / offline-Pope / send-fail copy on Inputs (and welcome if first launch). Face of the strip, not chat spam. | P0 | A | `CanSend` is `IsInGuild()` |
| 113 | Congregation Decree restore is display-only until an accepted Pope DECREE this session (or clear on congregation login). Stops InspectProgress / leftover SV as Quiet chrome. | P1 | A | `DB:Init` restores decree for everyone |
| 114 | Byte-budget harness: encode max-length names + favor; refuse if `> 240`. | P0 | A | Codec tests never call `Send()` |
| 115 | `SCHEMA_VERSION` stays **7**. `welcomeSeen` and optional `gora` use `applyDefaults` / `ensureTable`. Update `rootKeys` if a root key is added. Do not stamp 8. | P0 | A | `test_db.lua` pins version 7 |
| 116 | Gora persist is **Pope-only**. Congregation must not `Save()` an empty `gora` over a shared-account SV. Restore gora **after** event restore. Guard `C_Timer`; `wow_stub` has none. | P0 | A | Account-level `ChurchOfBeefDB` |
| 117 | Do not ship #56 empty-unknown the same night as first live petitions without a desk line “roster unread — showing all written names.” | P1 | A | 10s `GuildRoster` ignore |
| 118 | #87 (Thedave / `popeOverrides`) is a **precondition** for any two-client claim. Agents do not invent names. | P0 | D | `Data/Popes.lua` |

---

## 9. Parked (named so they are not “forgotten”)

Do **not** pull these into Waves 1–5:

- SUMMON THE FAITHFUL (§7, stretch-MVP).
- Post-show clipboard (§18.4, stretch).
- Live HUD health (A01 / OPEN_QUESTIONS #2).
- Confession inbox UI; Confession / Proclamation rites in UI (#17, #18).
- Designated-Council store / broadcast (#8 remainder).
- Curtain widgets (#4).
- Decree deputy (#5).
- Forever / Classic+ TOC, names, guild topology, packaging (#6, #22–#25).
- Witness Network, Expeditions, professions, tithe, tournaments engine, Fallen, Blood Feud, Discord bots, Twitch (§22.2).
- Settings panel for Popes.
- Custom ceremonial OGG until A08 and a commissioned/CC0 source.

Duel-message `Propose` may follow A02; manual verdicts are the night-one path.

---

## 10. Do not invent (hard)

- Answers to still-open `OPEN_QUESTIONS` (especially #2, #3, #4, #5, #8 Council, #13, #14, #15, #22–#25, **#26**, **#27**).
- Store-gossip, peer SYNC, RAID product channel, generic INPUT/theater opcodes, hold-timer seconds, sixth state.
- Congregation `EnsureCharacterByName` / local Church history.
- Same-PROTOCOL extra STATE fields; inferred Proclaim kind; “The Pope ruled.”
- Pairing scores, ELO, odds, auto-sanction, computed Famous Upsets, points, Grant, standing, activity boards.
- HUD health hacks, CombatLog scrape, SecureActionButton targeting, auto-invite.
- “Beef Pope” as a rank; guild-index → Church rank map; “one of seven Knights.”
- Recognition auto-link / silent alt bind.
- `POLISH:PASS`, V1/MVP complete, ticking phase checklists from the harness.
- Editing player `WTF/`, uploading to CurseForge/Wago, Forever-targeted code.
- Rebuilding Store, Runtime, Archive, Ranks, or Sender from scratch.

---

## 11. Success criteria for *this* plan (not §22.3)

This plan succeeds when:

1. A zip-install recruit can complete the newcomer test in §2 without Discord coaching.
2. A congregation client sees **named** fighters and can ask to fight / pick a side. Closed proclamation kinds on the second client wait on OPEN_QUESTIONS **#27**.
3. The Pope can `/reload` mid-Gora and still rule the bout.
4. Stale leftover docs cannot send the next agent back to 2026-08-15.
5. David can walk two-client smoke and a dress rehearsal against scripts that describe *this* product.
6. Nobody claims MVP complete or `POLISH:PASS`.

§22.3 remains a human night after that.

---

## 12. Review sources (2026-09-14)

Subagent reviews (Grok 4.6 extra high, read-only), Wave 1:

- [Product completeness](0e1d9cc6-538d-42db-b7b4-d52bfdc48df4)
- [Architecture / safety](334ccf45-5948-4e8c-b890-683f5cf82ae4)
- [Core / Data store](0996724b-8a3e-4559-81a9-a84bc195d07f)
- [Newcomer first-night UX](cb4415e8-3702-4b83-b9e3-bf87b8c9a115)
- [UI surfaces](cf8514a6-7a6a-46a9-8c7a-0c6274833697)
- [Verification / packaging](a1ca9145-0ec3-41b4-8475-467c34b926c6)
- [BeefNet / ceremony wire](d6fbd2bb-967d-478b-ad48-a03ffdb93cce)
- [Assets / polish leftovers](af04108b-94b4-4d40-a409-a8642e96dcc7)

Wave 2 adversarial reviews (Grok 4.6 extra high, read-only):

- [Spec vs live code](35aac5a9-82a4-4b5f-b5de-06509a6acb68)
- [First-night plan feasibility](54b73234-5525-4d9e-b07b-d4454a9dc1a8)
- [Pope + recruit night-two UX](91cd7220-4c6e-4af7-8412-51b7bd53282f)
- [Law + wire conformance](f9aede96-0f30-4ee2-a6c6-97634e02027a)

Synthesis: `docs/superpowers/specs/2026-09-14-church-of-beef-wave-2-review.md`.

Deep research completed 2026-09-14 (`trun_91f36069f09644808119d4546045a5d4`). Files: `wow-tbc-addon-ceremony-2026.json` (repo root; gitignored by `/*.json`) and the poll’s metadata. Research is **guidance**, not product law.

**Keep (already in this plan):** verify `20506` on the live client before any public zip; `GUILD` + `WHISPER` only (Classic `CHANNEL` is dead); compact sequence-numbered STATE, not prose; send-queued ≠ delivered (HELLO + `RequestSnapshot`); account-level `ChurchOfBeefDB`; insecure informational frames; no gameplay automation; Forever is a separate untested target (OPEN_QUESTIONS #22–#25); coalesce to the 10-burst / 1-per-second prefix budget (items 69–71).

**Reject (contradicts Bible / Ten Laws):** officer-only control path (rituals are Pope-listed, not `OFFICER`); coordinator re-election or timeout self-promote (Law 5, §20.3); per-character identity SV (Law 7, §12); a new ACK/election protocol; multi-TOC Classic Era / Forever flavors this pass; “load out of date” as a release strategy.

---

## 13. Implementation sequencing

Do not start Wave 7–8 or stretch until the Wave 2 first-night slice is in the tree. Wave 6 walks may begin as soon as a two-client install exists; they cannot *close* until rewritten 23–29, 38, 46, 48, 51, 101–106, 110–112 are playable.

**First implementation plan (Wave 2):** `docs/superpowers/plans/2026-09-14-church-of-beef-first-night-wave-2.md`.

Order: boot safety → leftover docs → Quiet copy / welcome / slash → sender-keyed INPUT → PROTOCOL 2 + names + 240 → login/persist (Pope-only) → Ask to fight without Store writes → Pope desk door / next verb / refuse / petition slot / names≠verdict → two-client smoke.

Do **not** implement the superseded plan `2026-09-14-church-of-beef-first-night-congregation.md`.

Inbound Proclaim, Archive UI, Presence-as-queue, and congregation Store mint are out of this slice.
