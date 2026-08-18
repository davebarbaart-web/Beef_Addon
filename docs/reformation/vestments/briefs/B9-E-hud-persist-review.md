Spec PASS

# B9-E — HUD persists through the verdict (review)

**Quality:** Approved-with-nits

**Lane:** B9-E HUD persists through the verdict
**Brief:** `docs/reformation/vestments/briefs/B9-E-hud-persist.md`
**Writer report:** `docs/reformation/vestments/briefs/B9-E-hud-persist-report.md`
**Diff:** `docs/reformation/vestments/briefs/B9-E-hud-persist.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, `UI/Hud.lua` Refresh/persist, and `tests/test_hud.lua`; then ran `lua tests/test_hud.lua` (**466 passed, 0 failed**, exit 0, Lua 5.1.5). Law cited: Bible §10.7 (appears at sanction, persists through the verdict beat, exits with the consequence; defined no-live-health fallback), Law 6 / §19.1 (Quiet hides Event chrome), W-F favor (Pope from `GetFavorSplit` while live; congregation `SetBroadcastFavor` only). Did not mutate Hud or the suite. Did not commit. Did not edit Gora, FighterCard, Console, TOC, bootstrap, or `run.lua`.

This review does not sign the lane.

---

## Named gates

| Gate | Verdict |
|---|---|
| Persist through the verdict (Bible §10.7) | **Pass.** `displayPair` remembers `{ fighterA, fighterB }` while `GetSanctioned()` is live. After the pair is nil, `Refresh` still `paintShown`s that pair when `eventLive()` (`Runtime` state `~= "QUIET"`). Flipped pin: `DeclareVictor` + still-live event → `IsShown() == true` and `view.shown == true`, names still painted. A later `Sanction` overwrites `lastPair` (rematch path). No `view.verdict`. |
| Hide on QUIET / EndEvent / no last pair | **Pass.** `Refresh` calls `forgetPersist` + `paintHidden` when not `eventLive`. Persist block: `EndEvent` → hidden, favor nil, no fighter A. `StartEvent` after that QUIET forget does not revive the last pair. Event-without-a-pair (ASSEMBLY, no `lastPair`) still hides. |
| No `UnitHealth`; `health` stays nil | **Pass.** `Hud.lua` has no `UnitHealth`, `UnitHealthMax`, combat-log, or nameplate scrape. `hiddenView` and `paintShown` both set `health = nil`. Persist pins re-assert nil. Suite source greps stay. `healthReads == 0` at suite end. Mute rails stay textures. `countStatusBars` stays 2. |
| Favor W-F intact | **Pass.** Congregation persist still follows `SetBroadcastFavor` only (nil without broadcast; `{2,1}` still 66/34 when set). Clearing broadcast hides favor and does **not** hide the persisted card. Pope live path still reads `Gora:GetFavorSplit()` (including zeros). After the pair clears, Pope returns `lastPopeFavor` (frozen last painted split) instead of the post-clear `{0,0}` from Gora — that is the persist add, not a congregation fill from Gora. `PickFavor` / plate `OnClick` still require a live pair. STATE-off still omits the FAVOR label and both halves. `Hud.Favor` / `Hud.SendFavor` stay nil. |
| Isolated green | **Pass.** Reviewer ran `lua tests/test_hud.lua`: **466 passed, 0 failed**, exit 0. Isolation nil-module block (13 pins) and the standalone summary stay under `if standalone then`. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Gora, FighterCard, Console; no commit | **Pass.** Provided packet is two `diff --git` hunks: `UI/Hud.lua` and `tests/test_hud.lua`. Gora / FighterCard / Console are not in the packet. |
| Bible §10.7: appears at sanction; persists through the verdict beat; hide on QUIET | **Pass.** Named-gate check. Old pin `HUD hides when the pair clears, even mid-event` is gone. |
| Remember last sanctioned pair; new Sanction replaces it; forget on QUIET so later ASSEMBLY does not revive | **Pass.** `rememberPair` on live `GetSanctioned`. `forgetPersist` on QUIET and `ResetForTests`. ASSEMBLY-after-QUIET pin is in the persist block. Rematch `Sanction` after persist shows the live pair again. |
| No verdict qualifier; health nil; defense integers unchanged | **Pass.** `view.verdict` is nil after `DeclareVictor` (congregation and Pope persist pins). `health` nil. Provided persist hunks do not touch `defenseCount` / `paintDefense`. |
| Favor frozen on the last split; W-F intact | **Pass.** Named-gate check. Pope freeze is HUD-local (`lastPopeFavor`) because `GetFavorSplit` is `{0,0}` once Gora clears the pair (Gora exclusive). Congregation freeze is the existing broadcast table. |
| Flip the mid-event hide pin; `shown == true`; favor still W-F; QUIET still hides; isolation wrap stays | **Pass.** First flipped pin sits in the existing head-to-head block. Dedicated persist block covers Pope 2/1 freeze, congregation broadcast persist, broadcast-nil, QUIET hide, and no-revive. Isolation stayed gated. |
| `lua tests/test_hud.lua` exit 0; **POLISH:CANDIDATE** at most | **Pass. Verified.** 466 / 0. Writer claimed that polish ceiling and no more. |

Bible §10.7 (persist through the verdict beat; defined no-live-health fallback), Law 6 (Quiet hides Event chrome), Law 4 (no invented verdict copy), Law 8 (no health hack), and W-F (Pope from Gora while live; congregation broadcast-only; plate click still live-pair-gated) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; **POLISH:CANDIDATE** only | **Not a spec miss.** Brief asked isolated green. See Minor. |
| Favor freeze is HUD-local; congregation with no broadcast paints names without favor | **Matches the brief + W-F.** `GetFavorSplit` after clear is `{0,0}` and Gora is exclusive. Congregation still must not read Gora. |
| Plate click still requires a live pair | **Not a miss.** Brief said W-F intact. `PickFavor` must not invent a post-verdict Gora. |
| Store W/L updates on persist paint | **Not a verdict qualifier.** Tape re-reads Store. No `view.verdict`, no “Victor declared” copy. |
| A01 still NOT RUN; no `UnitHealth` | **Not a miss.** Brief forbade opening it. |
| Cowardice / Void share the persist path; only `DeclareVictor` is pinned | **Not a miss.** Brief keys off `GetSanctioned()` nil + not QUIET. Same `clearLive` in Gora. See Minor. |
| FighterCard / Console still hide when the pair clears | **Not a miss.** Exclusive HUD-only persist. |
| Integrator still lists the files in the TOC and `run.lua` | **Not a miss.** Brief forbade those edits. Already listed. |

---

## Strengths

- Exclusive pair is small and on-contract. Dress, mute rails, defense integers, `PickFavor`, and A01 were not reopened.
- Persist is fail-closed on Quiet: `forgetPersist` runs before `paintHidden`, so a later ASSEMBLY cannot revive the last pair. `ResetForTests` uses the same forget.
- Remembered pair is ids only. Paint still goes through `fighterFrom` / Store. HUD does not keep a stale name table and does not copy Gora stipulation leftover into the view.
- W-F still proves itself after the ruling: congregation without broadcast has `favor == nil` and stays shown; broadcast `{2,1}` still 66/34; plate click still no-ops without a live pair.
- Isolation stayed gated (13). Writer-reported 466 / 0 matches the reviewer run.

---

## Issues

### Critical

None.

### Important (must-fix)

None.

### Minor

1. **Pope freeze is last-painted, not last Gora tally.** `lastPopeFavor` updates only inside `resolveFavor` while `livePair()` is true. Console `refreshHud`s on Sanction and on `DeclareVictor`; `RecordFavor` (inbound whisper) does not. Typical Pope path therefore freezes the sanction-time `0/0` unless something else `Refresh`es after picks. The persist suite hides that hole by `Refresh`ing after `RecordFavor` before the ruling. Exclusive-legal robustness: after the pair clears, derive the split from `Gora:GetFavor()` + remembered ids (`favorPicks` survive `clearLive`; `GetFavorSplit` does not). Integrator alternative: `RecordFavor` → `Hud:Refresh`. Not a W-F break.

2. **Congregation favor drops on the next STATE.** `ChurchOfBeef.lua` `stateFields` only attaches `favor` when a live pair exists. `DeclareVictor` does not `SendState`; `CloseRite` / `Continue` / `EndEvent` do. Inbound `paintInboundFavor` then `SetBroadcastFavor(nil)` and `Refresh`. Exclusive HUD keeps names (W-F) and loses the split. Freezing across `SetBroadcastFavor(nil)` would break STATE-off. Integrator must keep sending the last split during CONSEQUENCE if stream favor must survive the verdict beat. Out of exclusive scope.

3. **Cowardice / Void / FreeRuling persist is implemented, not pinned.** All three `clearLive`. Console `refreshHud`s them. Only `DeclareVictor` is in the suite.

4. **A new different pair replacing `lastPair` is unpinned.** Rematch is the same ids. `rememberPair` overwrites on any live `GetSanctioned`.

5. **Continue-to-ASSEMBLY persist is unpinned.** Brief says keep painting while not QUIET. Implementation does. The persist block goes `DeclareVictor` → `EndEvent`, not `Continue`.

6. **Head-to-head and W/L can appear at the ruling.** First persist `Refresh` re-reads Store, so `1-0` / H2H can land on the card at the same beat as `DeclareVictor`. Writer disclosed it. Not a qualifier; it can still read as the HUD announcing the winner.

7. **`lastPair` is module-local.** `/reload` or a late join during CONSEQUENCE with `GetSanctioned()` already nil has nothing to remember. Catch-up / snapshot schema is not this lane.

8. **Forget is Refresh-lazy.** If a client never `Refresh`es while QUIET, then `StartEvent` + `Refresh`, an old `lastPair` could revive. Console `EndEvent` and inbound QUIET STATE both `Refresh`. The suite pins the happy path.

9. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated suite was re-run here. Do not treat this as **POLISH:PASS**.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

The exclusive pair does what the brief asked: after `DeclareVictor` the HUD stays shown while the event is live; Quiet / EndEvent hides and forgets; a later ASSEMBLY does not revive the last pair; `health` stays nil; no `UnitHealth`; W-F favor (Pope freeze vs congregation broadcast, plate click still live-pair-gated) holds; isolated suite green (466 / 0). Named gates are clean. Nits are last-painted Pope freeze (production often `0/0` until a post-pick `Refresh`), congregation STATE omitting favor once the pair is gone, unpinned Cowardice/Void/new-pair/Continue paths, and unsmoked theater — not trust-breakers.

Must-fix list: **none.**

Do not sign. Do not claim **POLISH:PASS**. Do not claim V1 / MVP complete.
