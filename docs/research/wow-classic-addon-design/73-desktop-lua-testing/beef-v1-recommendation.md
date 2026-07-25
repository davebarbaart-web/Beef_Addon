# Church of Beef V1 — desktop testing recommendation

**Track:** [73-desktop-lua-testing](README.md)  
**Locks against:** V1 implementation plan Task 1 harness; track [34](../34-lua-module-architecture/) architecture; track [19](../19-testing-debugging-qa/) for everything interactive.

---

## Recommendation (normative for research)

1. **Ship the plan’s zero-dependency harness** — `tests/wow_stub.lua`, `tests/run.lua`, suite modules named in the plan. Do not block V1 on busted, WoWUnit, or a PersoLootRoll-scale mock.
2. **CI:** dedicated `unit` workflow — checkout → Lua **5.1** → `lua tests/run.lua` → non-zero exit fails the PR. Keep packager ([33](../33-packager-ci-releases/)) and optional Luacheck as sibling jobs.
3. **Cover offline:** Data/Ranks, Ladder, Scoring, Officer (injected roster), Net **validate** only. Add DB default-shape tests when `Core/DB.lua` lands.
4. **Do not cover offline:** frames, BeefNet transport, roster timing, combat lockdown, SavedVariables `/reload`, spectacle. Point contributors at [19 checklist](../19-testing-debugging-qa/church-of-beef-qa-checklist.md).
5. **Keep Core pure** so the harness stays tiny — any new WoW global in Core is a review smell ([34](../34-lua-module-architecture/beef-v1-architecture.md)).
6. **Optional later (not V1 blockers):**
   - Migrate asserts to busted/luassert if suite count explodes
   - Luacheck with `std = "lua51"` + WoW `read_globals`
   - Dual-path WoWUnit for bootstrap-only experiments (still not a CI substitute for guild lab)

---

## Contributor contract (one paragraph for future README)

> Run `lua tests/run.lua` (Lua 5.1 preferred) before opening a PR that touches `Data/` or `Core/`. Green tests mean scoring/ladder/officer *logic* held; they do **not** mean the addon works in Anniversary. For load, guild sync, and ceremony spectacle, follow the in-game QA checklist.

---

## Mapping plan suites → CI gate

| Suite | Gate PR that changes… |
|-------|------------------------|
| `test_ranks` | `Data/Ranks.lua`, canon docs that claim thresholds |
| `test_ladder` | commits, suggestions, demote, seats |
| `test_scoring` | grant amounts, caps, AFK flag, Gora outcomes |
| `test_officer` | officer index max / gate helpers |
| `test_net_validate` | wire format / reject rules (not send path) |

Missing suite files are currently soft-skipped in the plan’s runner (“module not found” OK until created) — **once a suite exists, CI must require it** (remove soft-skip for that name).

---

## Explicit non-goals

- Full WoW API emulator
- Headless screenshot / UI tests
- Cryptographic anti-cheat tests (spec: standings are advisory)
- Replacing multi-client BeefNet labs with stubs

---

## Relation to existing research

| Need | Track |
|------|-------|
| How to organize Lua so offline tests work | [34](../34-lua-module-architecture/) |
| How to playtest in Classic | [19](../19-testing-debugging-qa/) |
| How to ship zips from Actions | [33](../33-packager-ci-releases/) |
| What Core vs Net validate offline | this track |
