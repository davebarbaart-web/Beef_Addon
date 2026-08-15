# A06 — Targeting by name from UI

**Appendix A item:** 6  
**Owner:** David  
**Result:** NOT RUN

Cited: Bible Appendix A item 6; §8 (clicking a queue entry targets the candidate where the API allows).

## Dependent feature

Console targeting assist. Clicking a queue entry (candidate, later a Gora fighter) targets that character where the API allows, so the Pope does not search the default guild roster during an active ceremony (§8).

Appendix A: secure button constraints in combat.

This item does not invent `#8` override UX, favor, INPUT, or a SUMMON protocol. It does not invent SecureActionButton product.

## Bible fallback

Appendix A item 6 names **no** standalone fallback. The Appendix A closer applies: if name-targeting from UI fails (especially in combat lockdown), a design fallback decision happens *before* implementation improvises one.

Do not invent a fallback here. Item 5's fallback is "target-assist only" — that assumes this assist exists; it is not a substitute if this item FAILs.

`TargetUnit` / secure-template buttons are not in the addon today. That absence is leftover, not a pass.

## Live-client method (Anniversary TBC, Interface 20506)

Pope character plus one other guild character in range, names known. `/console scriptErrors 1`. Product windows stay insecure. Do not add secure templates to the addon.

1. **Out of combat, by name.** From a `/run`, call the client's name-target API (`TargetUnit` or the equivalent this client actually exposes) with the other character's exact name (record realm suffix if required). Record success or the exact error.
2. **In combat, by name.** Enter combat. Repeat the same `/run`. Record whether combat lockdown refuses it.
3. **Insecure click.** Out of combat, click a name on an insecure Church frame if one is on screen (Console / Records). Record whether that click can target. Repeat in combat. Do not add a new click-to-target control.
4. **Range / visibility.** Repeat step 1 when the other character is nearby vs far / not in the same zone if that case is available. Record when the name target fails.
5. **Write facts on this sheet.** What the client allowed out of combat vs in combat. No SecureActionButton shipped from this sheet. No `#8`. No GuildPromote.

Do not change addon Lua from this sheet.

## Not a pass

- Console list rows that do not target
- Harness green
- Raid markers (item 5) standing in for a name-target Result
- An invented secure-button control

## Leftovers

- Console click-to-target on the current candidate/fighter (later UI, only where this Result says the API allows)
- Whether a secure button is required in combat (design decision after the Result — do not invent the widget here)
- OPEN_QUESTIONS #8 stays uncoded
