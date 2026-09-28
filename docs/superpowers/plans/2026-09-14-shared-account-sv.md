# Shared-account `ChurchOfBeefDB` hazard

**Date:** 2026-09-14  
**Status:** Hazard note. Not a persist design. Not a schema.  
**Audience:** Wave 2 implementers (Tasks 10–11) and David’s two-client walk (Task 15).  
**Does not:** implement Gora persist, stamp schema 8, edit `Core/DB.lua` / `Core/Gora.lua`, or touch player `WTF/`.

Wave 2 convicted this as a ship-blocker that a green harness will not see. Same-account Pope + pew share one SavedVariables file. A congregation `Save` after `Gora:_Expire()` can wipe Thedave’s desk.

**Law:** Bible §12 / Law 7; `.cursor/rules/identity-records.mdc`.  
**Conviction:** `docs/superpowers/specs/2026-09-14-church-of-beef-wave-2-review.md` §2.1 and §2.3.  
**Walk:** `docs/superpowers/plans/2026-09-14-church-of-beef-first-night-wave-2.md` Task 15 step 10.  
**Related items:** 100-point **#115** (schema stays 7), **#116** (Pope-only gora persist).

---

## 1. Account-level SV is law (keep it)

`ChurchOfBeef.toc` ships:

```toc
## SavedVariables: ChurchOfBeefDB
```

That is the correct product. Law 7 / Bible §12.1 / Audit V6: the store is **account-wide**, not per character. Rank belongs to the human; Gora *records* belong to the character. Per-character `SavedVariablesPerCharacter` / “alts start fresh” is **not law**. Do not “fix” the wipe by splitting the file.

Blizzard writes one account file:

`WTF/Account/<ACCOUNT>/SavedVariables/ChurchOfBeefDB.lua`

Every character on that WoW account — Thedave, a pew alt, a zip-fresh recruit logged on the same Battle.net account — loads and flushes **the same table**. Shared accounts / two humans on one login: identity-records says **no machinery**; the Pope resolves socially. This note is the software hazard on that same file, not an identity linker.

---

## 2. What the keepers do today (facts)

`Core/DB.lua` schema **7** is `{ version, ui, store, event, decree }`. There is no `gora` root key. `SCHEMA_VERSION` is 7. `applyDefaults` already fills missing known keys; a version stamp of 8 is unnecessary (Wave 2 §2.3).

`DB:Init` (`ADDON_LOADED`) Restores **store**, **event**, and **decree** for whoever loads the addon. Empty `{}` / missing `event` does not Restore (gate is `event.state` is a string). A Pope-shaped `event` with a string `state` Restores Event Mode for **everyone**, including a pew character on this account.

`DB:Save` snapshots store + event + decree for whoever calls it. `ChurchOfBeef.lua` `OnLogout` calls `DB:Save()` on **every** client.

`Core/Gora.lua` has **no persist**. Favor and `lastSanctioned` comments say memory only, never SV. `Gora:_Expire()` is the live wipe: if Runtime has no live `eventId` (QUIET or missing), it clears petitions, `sanctioned`, proposal, favor, and last pair. After that, memory is an empty desk. `DeclareVictor` then refuses `no sanctioned gora`.

Wave 2 first-night Task 11 will add Pope-only Snapshot/Restore. This note exists so that task does not land as “everyone Saves `gora`.”

---

## 3. The wipe Wave 2 convicted

§2.1, last bullet: same-account alt / Pope share one SV. Congregation `Save()` of an empty `gora` after `_Expire()` can wipe the Pope’s persisted desk.

The deadly combo is the *lawful* Task 10 split plus a *naive* Task 11 Save:

1. Thedave sanctions a pair. Desk and (once Task 11 exists) `ChurchOfBeefDB.gora` hold the bout.
2. A congregation character logs into **the same WTF Account tree**. One file.
3. Task 10 (correct): pew must **not** Restore Event Mode from SV. `PLAYER_LOGIN` Restores QUIET / skips applying `db.event` before `initUi`. Local Runtime is QUIET.
4. Any Gora call runs `_Expire()`. No live `eventId` → memory pair is gone.
5. Logout or a wrap calls `DB:Save()`. If Save writes `Gora:Snapshot()` of that empty memory, the shared file becomes `gora = {}` (or an empty-shaped snapshot).
6. Thedave `/reload` or relogs. Restore reads the empty blob. Desk is gone. `Declare Victor` refuses `no sanctioned gora`. Night is over.

Restore **order** is a second wipe even on the Pope client: if `gora` Restores before `event`, the next `_Expire()` sees QUIET and clears the pair (Wave 2 Task 11). Event first, gora second.

Do not gate `restoreEventFromSv` on `UnitName` inside `DB:Init`. `ADDON_LOADED` is too early; the Pope would skip his own restore (Wave 2 Task 10). The role split is `PLAYER_LOGIN`.

---

## 4. Congregation must not Restore Event Mode from SV

Wave 2 review §1 locked this; the honest first slice repeats it: congregation starts QUIET. Theater this session comes from an accepted Pope STATE / snapshot, not from leftover `ChurchOfBeefDB.event`.

A pew client that Restores `RITE` + `Gora` from Thedave’s file is a second ceremony machine on a display terminal. That is Law 5 / §13.1, not “helpful catch-up.” Catch-up is a whisper snapshot from the Pope’s client after live STATE or HELLO this session (Task 10). Tuesday no-response is not a failure.

Today `DB:Init` already Restores a string-`state` event for everyone. Task 10 must undo that on the pew at login **without** teaching `DB:Init` to look up the local name.

---

## 5. Congregation must not write `gora = {}`

Once a `gora` key exists, **Pope-only** Save and Restore (item #116). Congregation must not:

- Snapshot empty Gora memory over the shared file
- `ensureTable` a fresh `{}` and flush it as truth
- Call `DB:Save()` on a path that assigns `db.gora` from pew memory

Missing `gora` / empty `{}` must not replace live Pope memory (same gate shape as `event` and `decree`: empty is not a snapshot). `ResetForTests` must not Save.

`SCHEMA_VERSION` stays **7**. If Task 11 adds a root `gora`, use `applyDefaults` / `ensureTable` and update `rootKeys`. Do not stamp 8. Do not invent a persist schema in this note.

Store mint is the sibling §2.1 hole: pew `EnsureCharacterByName` writes real humans/characters/links into the same account file. No congregation Store write. That is OPEN_QUESTIONS **#26** refuse path, not a persist design.

---

## 6. Task 15 walk — do not share Thedave’s WTF tree

Two-client smoke means **two Anniversary clients** and **two Account SavedVariables files**.

Do **not** log a congregation character into the same `WTF/Account/<ACCOUNT>/` tree as **Thedave** during this walk. A second toon on Thedave’s account is not a pew client. It is a second writer on the Pope’s file. Step 8 (`/reload` still has the pair) will lie or fail for a reason the wire did not cause.

Precondition (item #118): David confirms Thedave is the live writer, or he adds `popeOverrides` himself. Agents do not invent names and do not edit `WTF/`.

If only one WoW account is available tonight: do not claim Task 15. The shared-SV hazard will fire by construction; a green harness will not save you.

Walk reminder (do not tick `docs/phases/*`):

1. Pew WTF is its own Account folder (blank-ish: welcome once, then silence).
2. `/beef` on Thedave reaches the desk.
3. Sanction named fighters. Pew HUD shows names from the wire.
4. Pope `/reload`. Desk still has the pair. `Declare Victor` does not refuse `no sanctioned gora`.
5. Never: pew alt on Thedave’s account, copied/symlinked `ChurchOfBeefDB.lua`, or an agent “helpfully” editing WTF.

---

## 7. Implementer rules (when persist is tasked)

- Law 7 stays: `## SavedVariables: ChurchOfBeefDB`. No per-character split.
- Congregation: no Event Mode from SV. No `gora = {}` write. No `Ensure` / `CreateHuman` / `LinkCharacter`.
- Pope `/reload` restores the Gora desk from **his** SV and rebroadcasts STATE.
- Restore gora **after** event restore.
- Do not put `UnitName` in `DB:Init`.
- `SCHEMA_VERSION == 7`. No schema 8.
- Guard `C_Timer`; `wow_stub.lua` has none.
- Agents never touch player `WTF/**/ChurchOfBeefDB.lua`.

This file is the warning. Persist lands in Wave 2 Task 11, not here.
