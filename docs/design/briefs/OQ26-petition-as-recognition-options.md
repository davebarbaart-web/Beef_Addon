# OPEN_QUESTIONS #26 — Petition as recognition (options only)

**For:** David  
**Filed:** 2026-09-14 (Wave 2 first-night review)  
**Status:** Unanswered. This file presents options. It does not pick.  
**Do not edit** `docs/design/OPEN_QUESTIONS.md` from this brief.  
**Do not implement** either option from this brief.

---

## The question

Zip-fresh names are not in the Pope store. Live `Gora:Petition` refuses `unknown character`. Targeting + Knighting / Sanctioning is already recognition (**#18**).

Unanswered: may the Pope client `EnsureCharacterByName` on an INPUT sender so a recruit can ask to fight, or must the desk show an unsigned name with **no** Store write until a Pope target-verb?

**Locked either way (not options):**

- Congregation clients never mint. No pew `EnsureCharacterByName` / `CreateHuman` / `LinkCharacter`.
- No silent alt-link. A new character always gets a fresh human. Linking a second character to an existing human waits for the parked Recognition rite (**#17**, **#18**).
- INPUT keys to the **server sender**, not a payload `characterId`.
- Named unknown opponent is ignored, not a refuse. The ask still sends.

`Store:EnsureCharacterByName` (Pope recognition spine): miss → `CreateCharacter` + `CreateHuman` + `LinkCharacter`. `rankId` stays nil. History records `created` and `linked`. Found + already linked → `created=false` (no new rows). Found but unlinked → fresh human, then link. Never merges into an existing human by name similarity.

---

## Night-one refuse path (not an answer)

Until David answers, Wave 2 ships **A**.

Unsigned desk row. No Store write on INPUT. Ask still sends. Named unknown opponent is ignored. Congregation Store stays empty after login bind.

That is the refuse path in `docs/superpowers/specs/2026-09-14-church-of-beef-wave-2-review.md` §2.1 and §4. It is not a resolution of #26.

---

## Option A — Unsigned desk; write only on Pope target-verb

**What it is.** Night-one default already in Wave 2. A pew ask is a name on the desk. It is not Church identity. Recognition stays the existing Pope verb: target the logged-in character and Knight / Sanction (console `ensureSubjectId` → `EnsureCharacterByName`). Asking to fight does not enter the store.

### Who writes the store

Nobody, on INPUT.

The Pope client may look up `Names.Key(sender)` against rows that already exist. Lookup is not a write. `CreateHuman` / `CreateCharacter` / `LinkCharacter` run only when the Pope later uses a target-verb that already Ensures (Knight, Sanction, Set Fighter A/B, and the other id-needing verbs). Congregation never writes.

### What the desk shows

An **unsigned** petition row: the sender's display name, keyed in Gora memory by name-key, not by `characterId`. No store id on the row. Presence / player-card gold plate keep today's #21 rule: no human row → live guild rank name (display only). The strip can still fill an empty fighter slot **by name**; that click is not sanction and, under A, is not a Store write.

### Zip-fresh sender vs already-Knighted sender

| | Zip-fresh (never in the Pope store) | Already Knighted (store row exists) |
|---|---|---|
| On ask | Name appears unsigned. Human count does not rise. `Gora:Petition(id)` is not called. | No new write. Desk may paint the known name. A lookup may attach the existing `characterId` for display; that is still not Ensure. |
| Rank / card (Pope store) | No human row. Census stays Unrecorded / guild-title display. | Store already wins. Rank and Gora record are the prior Knighting. |
| To become real | Pope targets them and verbs. Then Ensure mints character + human + link, `rankId` nil until Knighting writes the title. | Already real. A later verb finds the linked row (`created=false`). |
| Dismiss | Name leaves the desk. Nothing to un-mint. | Petition leaves. History untouched. |

### Law 5 / §12.2 risks

- **Law 5 (one writer):** Holds. A whisper does not grow the Pope store. The pew is an input device. The only writer remains a Pope click on the Pope client.
- **§12.2 / #18 (recognition):** Holds the decided rite shape. First entry is still one action, Pope present, character logged in. Asking is not that action.
- **Residual risk:** Thedave sees a name he has not written. He cannot `Gora:Sanction` two unsigned names until a verb Ensures them (live Sanction already requires `knownCharacter`). Night-one accepts that: petition ≠ pair, pair names select, `DECLARE VICTOR` commits. If he never targets them, they leave no row — and also cannot be the official pair until he does.
- **Name reuse (#15):** Unsigned memory is a spelling. It does not pick the lowest-id store row. Impersonation is answered when he targets the logged-in character, not when the whisper arrives.
- **Alt:** A second character asking under a new name stays a second unsigned name. A does not bind it to the Knighted human.

### What Wave 2 code would need later

Already scoped as Wave 2 Task 6 (unsigned desk), not as a #26 resolution:

- `Net:_HandlePetition` (and favor / confession apply): ignore payload `characterId`; key by `Names.Key(sender)`.
- `Gora` unsigned petition / favor rows by name-key; Snapshot / Restore those keys; Dismiss by name-key.
- Console strip paints names without ids; petition click fills an empty fighter slot by name and does not sanction.
- Tests: empty congregation Store after login bind → zero new humans / characters; Pope human count does not rise on a zip-fresh ask; named unknown opponent does not refuse the ask.
- Live `Gora:Petition` + `unknown opponent` refuse stay on the **id** path. They are not the unsigned path.
- If David later picks **B**, Task 6 is not ripped out — Pope-side Ensure on apply is a follow-on, not this slice.

---

## Option B — Pope-side Ensure on apply of the petition sender

**What it is.** When a petition INPUT lands on the **Pope client only**, apply calls `EnsureCharacterByName` on the server sender, then `Gora:Petition` with the returned id. A recruit can ask to fight because they now have a store row. Congregation still never mints. Ensure still never merges a new name onto an existing human.

### Who writes the store

The Pope client, on apply, without a Pope click.

Writer is still the Pope machine (not a pew Store). Occasion is the whisper. `rankId` stays nil. History `created` + `linked` are real and persist in account-level `ChurchOfBeefDB`. Dismiss does not delete them (Law 7). Congregation Store stays empty.

Favor and confession are **not** licensed here. #26 is petition-as-recognition. Do not invent Ensure-on-favor from this option.

### What the desk shows

A normal petition row with a `characterId`. Zip-fresh paint is **entered / unranked** (store human exists, `rankId` nil). That is #21: if the store has a human row, the store wins — including entered-but-unranked. Knighting remains the rite that writes the title. The pew's own `/beef` card still has no local row, so the recruit still looks new on their client until a later Pope write reaches them the lawful way (not this brief).

### Zip-fresh sender vs already-Knighted sender

| | Zip-fresh | Already Knighted |
|---|---|---|
| On ask | Ensure miss path: new character, new human, link. `created=true`. Then `Gora:Petition(id)` succeeds. | Ensure hit, already linked: `created=false`. No new rows. Petition attaches to the existing id. |
| Rank / card (Pope store) | Entered, unranked. Presence / gold plate leave the guild-title-only branch. | Unchanged. Store already had the Knight. |
| Class / level | INPUT has no target. Ensure is name-only; class / level stay nil until a later target-verb refresh. | Already on the row if previously targeted. |
| Dismiss | Petition leaves. Human + character + link + history **remain**. | Petition leaves. History untouched. |
| Alt under a new name | Fresh human, not the Knighted human. Still no silent alt-link. Two humans until the parked Recognition rite. | Same rule if the Knighted player asks on an unknown alt: new human, not a merge. |

### Law 5 / §12.2 risks

- **Law 5 (one writer):** The pew is not a second writer. The tension is **occasion**, not topology: Church history grows because someone whispered, not because the Pope verbed. Software proposes the row; the Pope did not ratify the entry. That is the Law 4 / #18 edge this option accepts if chosen.
- **§12.2:** First-character recognition-by-ask. #18 reserved “you are in the book” for target + Knight / Sanction with the character logged in. A whisper proves a sender string, not that the Pope saw them. Impersonation / name reuse (#15): Ensure on a reused spelling resolves to the **lowest-id** existing row and will not mint a second character for that key. The parked Recognition rite is still the only lawful alt bind; B must not grow a merge.
- **Law 7:** A dismissed or never-called recruit is still in the book. Night-one A avoids that; B cannot undo it.
- **Shared-account / two humans (§12.4):** No new machinery. B can mint a second human for a second name on the same WoW account. The Pope still resolves socially.
- **Not a Law 5 congregation mint.** B is still illegal if anyone ports the Ensure to the pew (Wave 1 item 23). Local id `1` ≠ Pope id `1`; pew mint still fails `Gora:Petition` on the Pope store and can steal favor if payload ids are trusted.

### What Wave 2 code would need later

Not night-one. Only if David picks B after A has shipped the unsigned desk:

- Pope-only `Net:_HandlePetition`: `EnsureCharacterByName({ name = sender })` then `Gora:Petition(id)`. Still ignore payload `characterId`. Still `_LocalPope` gate.
- Do not Ensure on congregation. Do not Ensure on favor / confession unless a later question says so.
- Do not pass a guessed `humanId`. Do not add a merge path.
- Console can keep id-keyed `GetPetitions` for those rows; unsigned-name memory becomes a fallback for non-petition INPUT, not the petition path.
- Tests: zip-fresh ask on Pope client → human count +1, `rankId` nil, history `created`+`linked`; second ask from the same sender → `created=false`; congregation client after the same ask → still zero humans / characters; Ensure is not called from Inputs / pew login bind.
- Presence / card copy: entered-but-unranked must not read as a seventh rank (Wave 2 already rejected `NEW` as a plate rank).
- Snapshot / Restore: petitions are ids again once Ensure has run; do not require schema 8 for this.

---

## Side-by-side (scan)

| | **A — unsigned until target-verb** | **B — Pope Ensure on petition apply** |
|---|---|---|
| Store write on ask | None | Pope client only; character + human + link if unknown |
| Desk | Unsigned name | Ordinary petition id; zip-fresh = entered / unranked |
| Zip-fresh | Name only; not in the book | In the book, no title |
| Already Knighted | Lookup ok; no new row | `created=false`; no new row |
| Recognition moment | Pope target-verb (#18) | Whisper apply (Pope machine, no Pope click) |
| Congregation mint | No | No |
| Silent alt-link | No | No |
| Night-one | **Ships this** | Wait for David |

---

## Out of scope (do not invent from this brief)

- Congregation `EnsureCharacterByName` (Wave 1 item 23 — convicted).
- Silent bind of a second character onto an existing human.
- Durable character identity / schema (#15, #23, §12.4).
- Ensure on favor or confession.
- Presence “here” (#13), Forever names (#23), Archive / Recognition UI (#17).
- A third option.
