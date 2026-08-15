# A08 — PlaySoundFile / custom sound assets

**Appendix A item:** 8  
**Owner:** David  
**Result:** NOT RUN

Cited: Bible Appendix A item 8; §19.4; §4.8 / §19.1 (Quiet Mode is silent).

## Dependent feature

§19.4 ceremonial cues. Sparse, Event Mode only. The MVP set: **Sanction bell**, **Verdict**, **Elevation**, **Knighting**, and (later) the **Canonization seal**. Cowardice Recorded deserves its own cue. When the bell rings, the whole guild knows something is happening.

Appendix A: `PlaySoundFile` and custom sound assets on the live Anniversary client.

This item does not invent extra cues, ambient UI whooshes, or Canonization product.

## Bible fallback

Appendix A item 8 names **no** standalone fallback. The Appendix A closer applies: if `PlaySoundFile` or custom addon media fail validation, a design fallback decision happens *before* implementation improvises one.

Do not treat stock `PlaySound` as that decision. **`UI/Sound.lua`'s existing `PlaySound` fallback is not a validation pass of this item.**

Quiet Mode stays silent, absolutely — a FAIL here is not a license for Quiet clicks.

## Live-client method (Anniversary TBC, Interface 20506)

Event Mode if a cue is played through the addon; otherwise `/run` observation only. `/console scriptErrors 1`. Do not add Media files or change `UI/Sound.lua` from this sheet. Do not rip Blizzard soundtrack files.

1. **`PlaySoundFile` stock path.** Out of Quiet theater, from a `/run`, call `PlaySoundFile` with a path the client already ships (a Blizzard UI sound path this client accepts). Record: heard or not; any error; whether the call exists on 20506.
2. **Missing custom file.** Call `PlaySoundFile` with a path under `Interface\\AddOns\\ChurchOfBeef\\` that does **not** exist. Record whether the client errors, stays silent, or fails addon load. Missing media must not fail load.
3. **Shipped verb.** If Event Mode can be entered without coding `#8` (owner inspection only, not a Gathering), trigger the existing `Sound:Play` path once. Record whether anything is audible. That `PlaySound` name-stub is **not** item 8 PASS.
4. **Quiet.** Confirm no cue plays while runtime is QUIET (minimap + Decree only). Record any leak.
5. **Write facts on this sheet.** Whether `PlaySoundFile` exists, whether a missing addon file is safe, whether custom assets are even testable yet. No new cue names. No Canonization seal shipped.

Do not change addon Lua from this sheet.

## Not a pass

- `UI/Sound.lua` calling `pcall(PlaySound, name)` for `sanction` / `verdict` / `elevation` / `knighting` / `cowardice`
- Harness green on sound
- InspectProgress playing `sanction` inside a StartEvent/EndEvent
- Quiet Mode being silent (contract, not this API Result)

## Leftovers

- Custom theatrical cue files (permitted on Event surfaces only; do not add from this sheet)
- Wiring `Sound:Play` from Console after successful Sanction / verdict / elevation / Knighting / Cowardice (named leftover elsewhere; not this Result)
- Canonization seal (later, §19.4)
