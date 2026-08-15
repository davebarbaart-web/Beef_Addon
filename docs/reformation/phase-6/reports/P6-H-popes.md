# Phase 6 Lane H — Registered-Pope list (#8)

**Status:** DONE (writer). Not a Gathering. Not V1 / MVP complete.

**Cited:** Bible §13.1, §13.4; Law 5; `.cursor/rules/pope-authority.mdc`; `GATE1_DESIGN_LEAD_DIRECTIVE.md` §4; David license 2026-08-15 (workspace file + `ChurchOfBeefDB.ui.popeOverrides` via `/run`). Council designations stay uncoded (`OPEN_QUESTIONS.md` #8 remainder).

Workspace list + Sender override. No TOC / bootstrap / `tests/run.lua` / BeefNet / Codec / Store / DB / Officer / Console / UI / `OPEN_QUESTIONS.md` / `REFORMATION_LOG.md` edits. No settings panel. No slash. No "I am the Pope" button. No guild-rank map. No commit.

## Files written

| Path | What changed |
|------|----------------|
| `addon/ChurchOfBeef/Data/Popes.lua` | Created. `COB.Popes.List` ships empty. `IsListed(name)` keys via `Names.Key`. Fail-closed if Common is missing. Data never reads SV. |
| `addon/ChurchOfBeef/Core/Sender.lua` | `IsRegisteredPope` is true if listed or in `ChurchOfBeefDB.ui.popeOverrides` (Names.Key). `Accept`: INPUT unchanged; STATE / SNAPSHOT consult the predicate; every other kind false. |
| `tests/test_sender.lua` | Rewritten for the new contract. Isolation asserts wrapped `if standalone then`. |
| `docs/reformation/phase-6/reports/P6-H-popes.md` | This file |

## Contract

`COB.Popes.List` is an array of name-key strings. It ships **empty**. Do not invent David's character name. Comment documents the `/run` override path. No Register / Add / Set APIs on Popes.

`Sender:IsRegisteredPope(sender)` normalizes with `Names.Key`. Missing / empty / non-string is false. True if `COB.Popes.IsListed(sender)` **or** the sender key is in `ChurchOfBeefDB.ui.popeOverrides`. Missing `ChurchOfBeefDB` / `ui` / override is ignored. Guild rank, GM, Officer, and a sender named "Pope" are not the Church.

When `COB.Popes` is not loaded, the workspace list is empty; only the SV override can return true. Suites that do not load Popes.lua and do not set the override stay fail-closed.

`Sender:Accept(sender, kind)`:

| Kind | Rule |
|------|------|
| `INPUT` | Non-empty sender string (`Names.Trim`). Independent of `IsRegisteredPope`. |
| `STATE` / `SNAPSHOT` | `IsRegisteredPope(sender)` |
| Any other kind | `false` |

Discarded messages are not stored. No `Sender.RegisterPope` / `OverridePope` / `SetPope` / `LoadPopes` / `popes` table.

## Verification

- Isolated suite (`Core/Common.lua` + `Data/Popes.lua` + `Core/Sender.lua`): **263 passed, 0 failed**.
- Lua 5.1. `lua tests/test_sender.lua` exits 0.
- Guild-rank stubs recorded **0** reads. No `SendAddonMessage`. No `CreateFrame`.
- Empty List: Beefina / Pope / GM / nil stay false; STATE / SNAPSHOT refuse.
- Test-only append of `Names.Key("Beefina")`: that name and realm / pad / case variants are true; STATE and SNAPSHOT Accept; other theater kinds still false; INPUT still true for non-Popes. List restored empty.
- Override with empty List: `ChurchOfBeefDB.ui.popeOverrides = { "Beefina" }` makes `IsRegisteredPope("Beefina")` true. `Popes.IsListed` stays false (Data does not read SV). Cleared after.
- Under `tests/run.lua`, this suite restores the prior `COB.Popes` slot so later leftover `COB.Popes == nil` asserts stay green. That restore is harness isolation, not a product unload.

## Leftovers (other lanes / David — not fixed)

- **Council designations** stay uncoded. Store field and broadcast shape remain `OPEN_QUESTIONS.md` #8. This lane did not invent them.
- **Integrator:** list `Data\Popes.lua` in `ChurchOfBeef.toc` after `Data\Ranks.lua`. Writer must not edit the TOC.
- Later suites still assert `COB.Popes == nil` (`test_net_v2`, `test_ceremony_chaos`, `test_console`). Update those writers when they load the list; do not treat the harness restore as the product.
- A live Gathering still needs a real name in the list or a local override. Shipping empty is the license. Console rituals and BeefNet STATE / SNAPSHOT stay fail-closed until then.
- Full harness (`lua tests/run.lua`) reported **1 failed** in `test_console` (`EditBox` count) — Console / P6-I, not this lane. Exclusive files here were not edited to chase it.

## What this lane refused to invent

- Council designation store or broadcast
- Settings panel, slash to register, or an "I am the Pope" button
- Guild-rank / GM / Officer map
- Sixth runtime state, `holdSeconds`, fake Gora rows
- Sender config UX methods (`RegisterPope`, `OverridePope`, `SetPope`, `LoadPopes`)
- A shipped Pope character name
- Edits to BeefNet, TOC, bootstrap, `tests/run.lua`, `OPEN_QUESTIONS.md`, `REFORMATION_LOG.md`

## Concerns

- Until a name is listed or overridden, no client can paint theater from the wire, including a real Pope character. That is the empty-list ship, not a bug.
- INPUT acceptance is still identity presence, not authority.
- `OPEN_QUESTIONS.md` was not edited. Council remains open.
