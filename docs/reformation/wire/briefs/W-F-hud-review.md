# W-F — HUD: favor split bar + congregation plate pick (review)

**Lane:** W-F Fight HUD — favor split + congregation plate pick
**Brief:** `docs/reformation/wire/briefs/W-F-hud.md`
**API pin:** `docs/reformation/wire/briefs/W-EF-wow-api.md`
**Writer report (unverified):** `docs/reformation/wire/briefs/W-F-hud-report.md`
**Diff:** `docs/reformation/wire/briefs/W-F-hud.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

**Spec:** PASS
**Quality:** Approved

Task-scoped gate only. Reviewer read the brief, the API pin, the writer report, and the provided diff; then made one focused check per named risk (congregation favor fill vs `GetFavorSplit`; `health` stays nil; `{2,1}` floor-then-remainder) plus the plate-click widget type. Did not mutate the working tree, did not re-run git or the harness, and did not treat writer counts as verified.

---

## Spec Compliance

- **Spec PASS**
- **Quality Approved**

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Gora / Store / Codec / BeefNet / Console / TOC / bootstrap / Sender / Runtime / `run.lua` / OPEN_QUESTIONS / REFORMATION_LOG / `Data/Popes.lua` / commit | **Pass.** Provided diff touches only the two exclusive files. |
| `GetView().favor` nil when hidden / no pair / congregation with no broadcast | **Pass.** `hiddenView().favor` is nil. Pope path returns nil without a live pair. Congregation is `favorView(broadcastFavor)` only. |
| Local Pope (`Sender:IsRegisteredPope` of the local player): live pair → `Gora:GetFavorSplit()`, including `{0,0}` → 0/0 | **Pass.** Missing Sender ⇒ congregation (brief rule 3). Zeros are painted and asserted. |
| Congregation never fills from Gora tally | **Pass.** Named-risk check: `GetFavorSplit` is only called inside `isLocalPope()`. Toggle-off test keeps Gora picks at 2/1 and still hides favor. |
| `Hud:SetBroadcastFavor({a,b} or nil)`; invalid table clears | **Pass.** Non-table or non-numeric `a`/`b` sets `broadcastFavor = nil`. Present table copies `{a,b}` only. |
| Percents: `a+b==0` → 0/0; else `floor(100*a/(a+b))` then remainder | **Pass.** Named-risk check: `{2,1}` is pinned **66/34** in Pope and congregation tests. |
| `GetView` is a copy; `health` stays nil | **Pass.** Named-risk check: `hiddenView` and `paintShown` both set `health = nil`. Existing scrape greps stay. Pope + Quiet + shown views re-pin nil. Favor copy is mutated in the Pope block. |
| Stock split bar: `StatusBar` + `Interface\TargetingFrame\UI-StatusBar`; `FAVOR`; end percents; class tint or muted ink | **Pass.** API pin matched. `GameFontHighlightSmall` for the label. Hidden when `favor` is nil. No OnUpdate, PlaySound, portraits, or sigil. |
| `PickFavor(pickId, target, characterId)` → `Net:SendFavor({characterId, pick}, target)` | **Pass.** Missing target → `nil, "no target"`. Missing characterId → `nil, "no character"`. Plate click uses live `fighterA` / `fighterB`. |
| No invented Pope name; `SetFavorTarget` / `SetLocalCharacterId` required for plate send | **Pass.** `localSender()` is `Group.PlayerName` / `UnitName("player")` for the predicate only. Plate click no-ops without both injects; no error chat. |
| Insecure `Button` + `EnableMouse` + `OnClick`; not Frame+OnClick; not SecureActionButton | **Pass.** `CreateFrame("Button", nil, widget)` with no secure template. |
| `ResetForTests` clears broadcast + target + local id | **Pass.** Cleared before `paintHidden`. Suite pins click no-op and `favor == nil` after reset. |
| No `Hud.SendFavor` alias; no `Hud.Favor` economy table | **Pass.** Both stay nil. Old “view never carries favor” pin was replaced as the brief allowed. |
| Isolation asserts stay under `if standalone then` | **Pass.** Existing nil-module block is unchanged and still gated. Suite does not `dofile` Sender, TOC, bootstrap, Console, or `Data/Popes.lua`. |
| Named tests (Pope split + bar, congregation 66/34, toggle-off ignores Gora, PickFavor / missing args, plate click gated) | **Pass.** Quiet hidden, Store names/class colors/W–L, GetView copy, health nil, no nameplates, no sound kept. |

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Integrator must feed broadcast / target / local id | **Not a miss.** The brief forbade Pope-name lookup and named those three setters as the inject points. |
| `SetBroadcastFavor` does not Refresh | **Not a miss.** Brief did not require paint-on-set. `Refresh` is already the paint entry; tests Refresh after set. |
| Plate overlays may steal HUD drag | **Real UX note, not a spec fail.** The brief asked for Button overlays on the name plates. Center / favor chrome still has the parent drag scripts. |
| Extra `"no net"` when `Net.SendFavor` is missing | **Acceptable fail-closed.** Brief said send “when Net offers it” and only named the target / character strings. Those two still match. |

---

## Strengths

- Favor fill is a single predicate split: Pope + live pair reads Gora; everyone else reads the last broadcast table. Congregation cannot accidentally inherit a Pope tally when Sender is missing.
- Percents are one helper, pinned at the brief’s allowed 66/34, and the bar text uses the same integers. Zeros stay a real split, not a hide.
- Plate send is gated twice: click no-ops without target + local id; `PickFavor` still returns the named errors. Fields are `{ characterId, pick }`, not an invented `pickId` key or `Hud.SendFavor` alias.
- Widget choices match the API pin: insecure `Button`+`OnClick`, stock `StatusBar` texture, no `UnitHealth` / nameplates / `OnUpdate` / custom media. HUD grew 20px for the bar, not into a toast.
- Isolation discipline holds. Sender is a boolean stub, not a `Data/Popes.lua` load. Cleanup nils the stubs before the toast trap.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Plate overlays consume the name-plate drag hit.** `pickA` / `pickB` are 190×36 Buttons on the top halves and do not forward `OnDragStart`. Parent `RegisterForDrag("LeftButton")` still works on the center strip and the favor row. Follows the brief; unsmoked in-game, as the writer said.

2. **`COB.Sender` / `COB.Net` are overwritten, then niled, not restored.** Same hygiene as W-D’s stub cleanup. Later harness suites re-`dofile` or do not need those keepers (`test_hud` is late in `run.lua`). Save/restore would be cheaper.

3. **Programmatic `PickFavor` does not check that `pickId` is the live A/B store id.** Plate click does (`livePair()`). The public method forwards any pick once target + characterId + Net are present. Pope-side `RecordFavor` is the refuse. Brief only named target / character errors.

4. **Invalid-broadcast clear and `"no net"` are implemented, not pinned.** Non-numeric `{a,b}` clears. Missing `SendFavor` returns `"no net"`. Live tests always Refresh after a valid set and stub Net on the send path.

---

## Assessment

**Spec PASS. Quality Approved.**

This is the W-F HUD contract: Pope-local split from `GetFavorSplit` while a pair is live; congregation fill from `SetBroadcastFavor` only; stock dual-encoded bar; plate click whispers through `PickFavor` only after the integrator sets target + local character id. `health` stays nil. No Pope name, no custom media, no live health, no V-D dress. Exclusive files only.

Writer-reported isolated `lua tests/test_hud.lua` **320 / 0** was **not** re-run here.

No Critical or Important findings. Integrator can sign W-F on this diff; do not block on the Minors. This review does not sign the lane.
