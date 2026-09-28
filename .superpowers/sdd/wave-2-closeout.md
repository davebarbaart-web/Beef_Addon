# Wave 2 close-out — implementable slice (14 Sep 2026)

Plan: `docs/superpowers/plans/2026-09-14-church-of-beef-first-night-wave-2.md`  
Spec: `docs/superpowers/specs/2026-09-14-church-of-beef-wave-2-review.md`  
Ledger: `.superpowers/sdd/progress.md`

**This file covers agent work only.** Task 15, Bible §22.3, `POLISH:PASS`, and MVP are not claimed. No commit. SCHEMA 7. Interface 20506. PROTOCOL 2.

Last reported harness (Task 14 implementer): `lua tests/run.lua` **17028 passed, 0 failed**. Isolated suites that night: `test_console` 2689/0, `test_player_card` 348/0. No in-game `/reload` smoke.

---

## Verdict

| Slice | Status |
|-------|--------|
| Tasks 1–14 (code + leftovers honesty) | **Done.** Each has an independent review: Approved / spec PASS. |
| Task 15 two-client walk | **Not walked.** Script: `docs/superpowers/plans/2026-09-14-task-15-walk.md`. Precondition #118 (Thedave is the live writer). |
| Plan “Done when” | **Not met.** That sentence requires Task 15 on two Anniversary clients. |

---

## Requirement audit (Tasks 1–14)

Each row is a plan pin. Evidence is the matching `task-N-review.md` plus live stamps (`SCHEMA_VERSION = 7`, `## Interface: 20506`, `Codec.PROTOCOL` / `Net.PROTOCOL` = 2).

| Task | Plan pin | Review | Residual (not a miss) |
|------|----------|--------|------------------------|
| 1 Boot safety | Every `initUi` Init in `pcall`; Hud throw still reaches `Net:Init`; chat `Church of Beef: <Name> failed to start.`; BackdropTemplate kept until a live 20506 abort | Approved | No live abort; template stays. |
| 2 Honesty leftovers | Bottom leftover table / README Decree / BeefNet header / zip gitignore; dress rehearsal & Appendix A Status/Result stay NOT RUN; #11 not resolved | Approved (audit) | Extra docs-only: v1-checklist, guild-night right-click, A13. |
| 3 Slash + console gate | Unknown args → help, not card toggle; help is bull / Ask to fight / pick a side; listed Pope second line `The desk is /beef console.`; `Show`/`Toggle` refuse before minting the desk; verbs stay `not a registered pope` | Approved (after Critical re-review) | — |
| 4 Welcome parchment | `welcomeSeen` default false; SCHEMA 7; one §19.5 Quiet sheet; no Director Console; skip if Decree showing or Runtime ≠ QUIET; flag on Close only | Approved | Post-Init inbound Decree/STATE can stack under a still-showing welcome. Brief only contracted Init. |
| 5 Quiet card copy | Gold plate = Church title, live guild rank, or empty — never `UNRECORDED`/`NEW`; unwritten line; Gathering line when Runtime ≠ QUIET; `CHURCH RECORDS` stays | Approved | #21 unanswered. Open-card Gathering refresh is bootstrap glue. |
| 6 Sender-keyed INPUT | Empty pew Store stays empty; ignore payload `characterId`; unsigned name-key rows; unknown opponent dropped, ask recorded; no pew Ensure | Approved | #26 unanswered. |
| 7 PROTOCOL 2 + Quiet drop | `PROTOCOL = 2`; v1 incompatible; `_WarnVersion` Bible sentence once; drop HELLO/TYPES/`_HandleV2`/Snapshot via `Runtime:DropToQuietForVersion()` (not `EndEvent`); keep `nextEventId` | Approved | #27 unanswered. I-06 was Task 9. |
| 8 Packed names + 240 | STATE/SNAPSHOT `names`; fail-closed on `:` / `\n`; stash, no upsert; fat STATE/SNAPSHOT through `Net:Send` ≤ 240; ASSEMBLY pair; #111 dismissed flag | Approved | Leftover pew RITE+fighters still pickable is #27. |
| 9 Latest-wins | Different `eventId` apply; same id + greater seq apply; equal seq no-op but ok (favor still paints); older `stale sequence`; favor never a Runtime field | Approved | — |
| 10 Login restore | `DB:Init` restore ungated; pew `DropToQuietForVersion` before `initUi`; Pope keeps event; `sendState()` once after `InstallWire` if ≠ QUIET; `RequestSnapshot` once after accepted Pope HELLO (or leftover-Quiet live STATE) | Approved | Shared-account Quiet `event` Save closed on Task 11 Save gate. |
| 11 Pope-only Gora persist | Snapshot sanctioned / unsigned petitions / favorPicks / lastSanctioned / eventId; restore after event; SCHEMA 7 root `gora`; Save event+gora only if listed Pope; never wrap `ResetForTests` | Approved | Pew still Snapshots **store**. #26 unanswered. |
| 12 Ask to fight | Face **Ask to fight**; hide on listed Pope; dest = `Net:DefaultDest()`; reasons: not in guild / send failed / already asked / Knighting; after send `Asked. Waiting.`; no Store mint | Approved | BackdropTemplate kept. |
| 13 HUD + toast gloss | Hover `Click to pick this side.`; footer **Pick a side** at 0/0; after ruling hide favor, footer **Ruled**, no winner string; void / fled / sanctioned duel / `Free ruling.`; no `The Pope ruled.`; no inbound Proclaim | Approved | Pew RITE pickable leftover is #27. #111 not unwrapped. |
| 14 Pope desk | Listed-Pope **THE DESK** → `Console:Show()`; congregation no door; `PHASE_HINT` next verb; `after()` GateStatus including End-during-RITE; petition fills A/B or “use this petitioner”; pair names select; `DECLARE VICTOR` commits; unsigned Zipfresh still paints | Approved | End button hidden in RITE (refuse is invoke-only). Door is card-only. `OpenDesk` does not hide the card. |

**Out of slice (held):** no pew `EnsureCharacterByName` / `CreateHuman` / `LinkCharacter`; no inbound `Toasts:Proclaim` / Sound; no schema 8; no SUMMON; no HUD health; no Forever TOC; no mute-card replica; no Archive UI; no Presence-as-queue.

---

## What is not done

- Task 15 two-client smoke (Thedave + a recruit, two Account SV trees).
- In-game `/reload` polish on the touched UI/Net/SV/slash paths.
- OPEN_QUESTIONS **#11**, **#21**, **#26**, **#27** — filed, unanswered.
- Post-Init welcome stacking under inbound Decree/STATE.
- Congregation Event-Mode favor on leftover RITE (waits on #27).
- Phase Status/Result boxes — stay **NOT RUN**. Agents do not tick them.
- `POLISH:PASS`, Bible §22.3, MVP / V1 complete.

---

## Task 15 (human)

Walk: `docs/superpowers/plans/2026-09-14-task-15-walk.md`.  
Precondition: David confirms Thedave is the live writer, or he adds `popeOverrides` himself (#118). Agents do not invent Pope names or edit `Data/Popes.lua` / `WTF/`.
