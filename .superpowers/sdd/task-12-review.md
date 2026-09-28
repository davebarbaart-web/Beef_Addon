# Task 12 review — Ask to fight (no Store write)

**Scope (this gate only):** live congregation Event strip face **Ask to fight** (header is not `EVENT INPUT`); hide on listed Pope (`Sender:IsRegisteredPope`); dest line and `SendPetition` dest share `Net:DefaultDest()` (last accepted STATE sender else `Popes.List[1]`); fireable strip reasons (not a toast); asked / waiting after a successful send; unknown opponent does not refuse; zip-fresh empty store does not `Ensure` / `CreateHuman` (closed wire may carry placeholder `characterId` 1; Task 6 apply ignores it). Pins in `tests/test_inputs.lua` / `tests/test_net_v2.lua`.

Must hold: SCHEMA 7, PROTOCOL 2, Interface 20506, BackdropTemplate kept, no commit. Implementation site is `UI/Inputs.lua` + `Net:DefaultDest` export — not Console / Hud / DB / Gora / `ChurchOfBeef.lua`.

Read: `.superpowers/sdd/task-12-brief.md`, `.superpowers/sdd/task-12-report.md`. Live `UI/Inputs.lua`, `Net/BeefNet.lua`, the two test files. Full `lua tests/run.lua` was not re-run (per gate instruction). Working tree was not mutated except this review file.

**Spec-compliance:** PASS

**Task quality:** Approved

The implementer report matches the live tree. The strip face is **Ask to fight**. Listed Pope hides it. Dest line and send dest cannot diverge: both go through `petitionDest()` → `Net:DefaultDest()`. The four named reasons paint on `ReasonText`. A successful send paints asked / waiting. Empty store does not mint a Store id. BackdropTemplate is still on the root. SCHEMA stays 7. PROTOCOL stays 2.

---

## Verdict

Task 12 matches the brief, Wave 2 first-night Task 12, and plan items 24 / #107. Congregation Ask is a Net whisper from the Event strip. It does not write Store. The Pope’s desk already has petitions, so the strip hides on `IsRegisteredPope`. Two-client Ask remains Task 15.

---

## Spec Compliance

| Pin | Result | Evidence |
|-----|--------|----------|
| Face / header **Ask to fight**; not `EVENT INPUT` / `"Petition"` | Met | `FACE.ASK` is the TitleBar `HeaderText` and the stock verb. `test_inputs.lua` source + `HeaderText` / button pins. `src:find("EVENT INPUT")` and `'"Petition"'` are nil |
| Hide the strip on listed Pope (`IsRegisteredPope`); invert the forbid scan | Met | `shouldShow()` is `eventLive() and not isLocalPope()`. `isLocalPope` is `Sender:IsRegisteredPope(localPlayerName()) == true`. Source scan now requires `IsRegisteredPope`. `runTask12` Pope stub: `Show` false, frame hidden, `Petition` does not send |
| Dest line == send dest (`DefaultDest`, last STATE sender beats `List[1]`) | Met | `petitionDest()` = bound target else `Net:DefaultDest()` else `List[1]`. Paint and `SendPetition` both call it. `Net:DefaultDest()` is `defaultDest()` (`_lastStateSender` then `Popes.List[1]`). `runTask12` Steakina vs Popeonius; recipient / opponent Net-default pins; `test_net_v2.lua` DefaultDest export + dest equals `SendPetition` when no explicit target |
| Reasons that can fire: not in a guild; send failed; you already asked (no TTL); Knighting (#107) | Met | `ReasonText` on the root (TitleBar still two labels). Face strings + `Petition` return whys. Knighting keeps the strip up so the line can fire (`Show` true, verb disabled). Already-asked is `askedWaiting`, cleared when Runtime is QUIET — no TTL clock. No toast path |
| After a successful send: asked / waiting. Unknown opponent does not refuse | Met | `Asked. Waiting.` + verb disabled. Second click `you already asked` / `You already asked.` Opponent suite: Chuckroast still attaches and sends; dest-same / player-same omit opponent but still send. No Store lookup, so an unknown name cannot refuse |
| Do not mint `localCharacterId` via Store. Placeholder id is legal | Met | No `EnsureCharacterByName` / `CreateHuman` / `CreateCharacter`. Missing id → `PLACEHOLDER_CHARACTER_ID` 1 at send only. `GetView().characterId` stays nil. `runTask12` Store spies stay 0 |
| BackdropTemplate not dropped | Met | Root `CreateFrame(..., "BackdropTemplate")`. Quiet Init pin: `frame._template == "BackdropTemplate"`. Verb stays `UIPanelButtonTemplate` |
| SCHEMA 7. PROTOCOL 2. Interface 20506 | Met | `DB.lua` `SCHEMA_VERSION = 7`. `BeefNet.lua` / `Codec.lua` `PROTOCOL = 2`. TOC `## Interface: 20506`. Inputs does not stamp either |
| Implementation site is Inputs + DefaultDest export; not Console / Hud / DB / Gora / bootstrap | Met | Ask / dest / reasons / placeholder live in `UI/Inputs.lua`. `Net:DefaultDest()` is the shared helper. Console / Hud / DB / Gora have no Ask send path. `ChurchOfBeef.lua` slash help only names the face in copy |

---

## Strengths

- Dest cannot lie. The recipient line and the whisper both call `petitionDest()`, and that helper calls the same `defaultDest()` `SendPetition` uses when no explicit target is set. Last STATE sender beats `List[1]`.
- Hide-on-Pope and Knighting are different on purpose. Listed Pope hides the strip (desk already has petitions). Knighting keeps it visible so #107 can fire. Report concern 2 is the product split, not a miss.
- Zip-fresh Ask does not mint identity. Placeholder `1` is a closed-wire Codec floor; view id stays nil; Task 6 apply still ignores sender-keyed INPUT ids.
- Already-asked is event-scoped with no invented TTL. `paintHidden` clears the flag when Runtime returns to QUIET.
- Neighbors held. BackdropTemplate, TitleBar drag persist, opponent pcall/trim, dest-trim, U-Q stock scan, and Quiet hide were not unwrapped.

---

## Issues

### Critical

None.

### Important

None that miss a Task 12 pin.

### Minor

1. **Placeholder id is integer `1`.** Codec `isId` requires ≥ 1. Apply ignores it. Zip-fresh still does not write Store or set `localCharacterId`. Report concern 1.

2. **Hide-on-Pope needs a local name.** `IsRegisteredPope(nil)` is false (`Sender` `senderKey` miss). If `UnitName("player")` is not ready, a listed Pope can see the strip until a later Refresh. The harness Pope stub does not go through `UnitName`.

3. **`listedPope()` is a DefaultDest-missing fallback.** Live Net exports `DefaultDest`, so the last-sender win is the real path. The local List[1] helper does not `destName`-trim; the Net helper does.

4. **Reason line may clip.** 96-wide stock button on a 360 strip. Harness does not prove layout. Report concern 6.

5. **No client `/reload` smoke this slice.** Two-client Ask still belongs to Task 15. Report concern 5. Green isolated suites are not a gathering.

6. **Slash help in `ChurchOfBeef.lua` names the face.** That is copy, not the send path. Task 14 still owns the desk door.

---

## Assessment

**PASS / Approved.**

Congregation Event chrome is **Ask to fight**. Listed Pope hides it. Dest line equals send dest via `Net:DefaultDest()`. The four named reasons can fire on the strip. Successful send paints asked / waiting. Empty store does not Ensure. BackdropTemplate stays. SCHEMA 7. PROTOCOL 2. Interface 20506.

Do not claim `POLISH:PASS`.
