# Task 5 review — Quiet card copy

**Scope (this gate only):** `COPY` + `paintStrings` + live Gathering in `UI/PlayerCard.lua`, the Runtime tooltip line in `UI/Minimap.lua`, and the inverted pins in `tests/test_player_card.lua` / `tests/test_minimap.lua`.

OPEN_QUESTIONS **#21** is not resolved. Full `lua tests/run.lua` was not re-run (per gate instruction).

**Spec-compliance:** PASS

**Task quality:** Approved

The implementer report is accurate for the exclusive slice. Gold plate is never `UNRECORDED` / `NEW`. Newness is the relationship line. Live Runtime paints `The gathering has started.` No toast, no welcome, no Store write.

---

## Verdict

Task 5 matches the brief. Unwritten gold plate is a real Church title, a live guild rank, or empty. The Pope-has-not-written sentence is the newness line, including when the plate shows a non-canon guild rank. Entered-but-unranked stays. Matching canon guild titles still get the §5 heading — that is #21 display, not a store write and not a document edit. Runtime ≠ `QUIET` replaces the Gathering body on the card and adds the same sentence on a shown minimap tooltip. `CHURCH RECORDS` is unchanged.

The slice stays in UI copy/paint. No Core→UI, no congregation Store mint, no `EnsureCharacterByName`, no SCHEMA / Interface churn, no `POLISH:PASS`.

---

## Spec pins

| Pin | Result | Evidence |
|-----|--------|----------|
| Gold plate is a real Church title, live guild rank, or empty | Met | `paintStrings`: `rankTitle` → `string.upper`; else entered → `UNRANKED`; else non-empty `guildRank` → upper guild name; else `""`. `COPY.unrecorded` is nil. Source has no `UNRECORDED`. Empty-store pin: `RankText` is `""` |
| Do not paint `NEW` as a seventh rank | Met | No `NEW` COPY key. Source pin against `unrecorded = "NEW"`. Painted empties use `""` / Pope line / `UNRANKED` |
| Newness line verbatim | Met | `COPY.unrecordedLine = "The Pope has not written you yet. That is normal."` on unwritten (no `rankTitle`) paths, including empty plate |
| Guild-rank plate (no human row) uses that line, not `Guild rank.` | Met | Non-canon guild name (`Guild Master`, listed-Pope `Beef Prophet`) paints upper guild name + Pope line. `COPY.guildRankLine` is nil. Source never contains `Guild rank.` |
| No Church title and no guild rank: empty plate + Pope line | Met | `test_player_card.lua` empty-store Show: `RankText` `""`, relationship the Pope line |
| Entered-but-unranked stays | Met | `UNRANKED` / `Recorded, no rank yet.` Store row beats a matching guild title |
| Matching canon guild title (#21 display, not a resolution) | Met | No human row + `Beef Knight` → plate `BEEF KNIGHT` + `Belonging`. `IdForTitle` only; `entered` stays false. `OPEN_QUESTIONS.md` #21 text untouched |
| Runtime ≠ `QUIET`: Gathering body is `The gathering has started.` | Met | `paintStrings` `runtimeState ~= "QUIET"` → `COPY.gatheringStarted`. Replaces empty or posted Decree on that one plate (brief’s simplest lawful read). ASSEMBLY / RITE / CONSEQUENCE pinned. Missing Runtime is Quiet |
| No toast. Do not reopen welcome | Met | Live-Gathering block stubs `Welcome:Show` / `Toasts:Proclaim` and asserts zero calls. Source has no `Welcome` / `COB.Toast` |
| Minimap tooltip, only if shown: started line; no toast | Met | `fillTooltip`: hidden `IsShown() ~= true` returns without fill. Live adds `The gathering has started.` then keeps a posted Decree. Quiet posted tooltip unchanged. Missing Runtime is Quiet |
| Do not rename `CHURCH RECORDS` | Met | `COPY.records` and Records button text stay `CHURCH RECORDS` |
| No Store writes. No `EnsureCharacterByName` | Met | Model reads `Store:Snapshot()` only. Source has no `Ensure` / `Proclaim`. Tests pin the same |
| Do not resolve #21 | Met | Matching-title → §5 line kept as display. OQ #21 not edited. Wave 2 only replaces the old `Guild rank.` label with the Pope line |
| Invert `UNRECORDED` gold-plate pin + `COPY.unrecorded` / `unrecordedLine` | Met | Empty plate + Pope line; `COPY.unrecorded` nil; `unrecordedLine` is the Pope sentence; painted-text ban list includes `UNRECORDED`, `Not yet in the Church's record.`, `Guild rank.` |
| `lua tests/run.lua` exit 0 | Reported for exclusive suites; full run not re-checked | Implementer: `test_player_card` 326/0, `test_minimap` 241/0, leftover-isolated 1325/0. Full harness blocked by sibling Task 6. Not re-run |

---

## Strengths

- `paintStrings` branches are the spec: store title, entered-unranked, live guild name, empty. Newness is one COPY line, reused.
- Matching canon titles stay #21 display (`rankId` / `rankTitle` / `Relationship` from `Ranks.IdForTitle`). Non-canon names, including Guild Master and a listed Pope’s guild title `Beef Prophet`, do not invent a Church rank.
- Live Gathering is Runtime-state only. Card takes the brief’s simplest lawful read (one plate, started sentence). Minimap **adds** the line so a posted Decree stays visible. Neither path toasts or reopens welcome.
- Invert is real: old `UNRECORDED` / `Guild rank.` / empty-Gathering pins fail the new asserts. `reset()` calls `Runtime:ResetForTests` when present.
- Exclusive file set held. `CHURCH RECORDS` untouched. `POLISH:PASS` not claimed.

---

## Issues

### Critical

None.

### Important

1. **Already-open card does not pick up a live Gathering line.** Paint runs on Show/Refresh only. Glue (`ChurchOfBeef.lua` Runtime verbs) is exclusive-out. If the card is open when the gathering starts, the plate stays on the last paint until the next Show/Refresh. Report is honest. Not a miss inside this file set.

### Minor

1. **Card vs minimap when a Decree is posted and Runtime is live.** Card replaces the meetup line; minimap keeps it under the started sentence. Brief allows both. Lawful, slightly inconsistent.

2. **Report leftover is stale.** Report says `tests/preview_dump.lua` still pins gold-plate `UNRECORDED`. Current dump already expects empty plate + the Pope line. Not a product miss.

3. **`NEW` source pin is a specific substring** (`unrecorded = "NEW"`). Combined with empty-plate / banned-text pins this is enough; a different `NEW` paint would not trip that one find.

4. **Minimap live pins cover ASSEMBLY (and hidden-button RITE), not CONSEQUENCE.** Implementation is `state ~= "QUIET"`; same helper as the card.

---

## Out of scope (not scored)

- Full harness vs sibling Task 6 inversions.
- `docs/phases/solo-smoke.md` still describes `UNRECORDED` / `Guild rank.`
- Glue Refresh on Runtime verbs.
- In-game `/reload` smoke. Do not claim `POLISH:PASS`.

Forbidden files (`ChurchOfBeef.lua`, `Core/DB.lua`, `UI/Console.lua`, `UI/Hud.lua`, `Net/Codec.lua`) were not used as the implementation site.

---

## Task quality

**Approved.**

Requirements are met with copy/paint changes and inverted pins. Remaining notes are the exclusive-out glue gap, a brief-blessed card/minimap split, and a stale leftover in the report — not fix-before-pass.
