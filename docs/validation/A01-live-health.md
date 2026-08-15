# A01 — Live health of non-group units

**Appendix A item:** 1  
**Owner:** David  
**Result:** NOT RUN

Cited: Bible Appendix A item 1; §10.7; §22.1 item 2; OPEN_QUESTIONS #2 (unread here — do not resolve).

## Dependent feature

Fight HUD live health bars (§10.7). During a sanctioned Gora, every Event Mode client is meant to render both fighters with live health, plus name, class color, level, Church title, record, defense count, head-to-head, and favor split.

Appendix A: nameplate / target scanning constraints decide whether those live bars are feasible.

## Bible fallback

HUD without live health (§10.7): the HUD still renders everything except live health (cards, records, favor). That fallback is defined as still transformative for legibility. Raid-marking the fighters (§8) helps the crowd find them either way.

§22.1 item 2 names the Live Fight HUD *with* this defined no-live-health fallback.

The coded no-health HUD (`UI/Hud.lua`, `health` always nil) is that fallback shipped as a surface. **It is not a validation pass of this item.** OPEN_QUESTIONS #2: Appendix A item 1 result decides HUD final form. Do not treat the fallback as the answer.

## Live-client method (Anniversary TBC, Interface 20506)

Two characters, **not** in the same party or raid. A third observer if available (congregation distance). `/console scriptErrors 1`.

1. **Target scan.** Observer targets fighter A, then B. Record whether `UnitHealth` / `UnitHealthMax` (or the equivalent unit-token read the client actually exposes) return live values for a non-group unit. Repeat in and out of combat.
2. **Nameplate scan.** With nameplates on, record whether a non-group fighter's health is readable from nameplate unit tokens without that fighter being the target. Note combat lockdown if a read is refused.
3. **Range.** Repeat at typical Gora crowd distance (inside the circle vs outside). Record when the read becomes 0, nil, or stale.
4. **Group control.** Repeat once with the observer in the fighters' party/raid, only to contrast — the item is non-group units.
5. **Write facts on this sheet.** What the client returned. No health hack, nameplate scrape shipped as product, or combat-log HP estimator (gora-sanction: do not invent a health workaround).

Do not change addon Lua from this sheet. Do not edit OPEN_QUESTIONS.md.

## Not a pass

- Harness green on `test_hud`
- `GetView().health == nil` in `UI/Hud.lua`
- Cards / records / favor rendering without bars

Those are the fallback, not item 1.

## Leftovers

- OPEN_QUESTIONS #2 stays open until David writes a Result
- Favor split is a later INPUT surface; this item does not invent it
- Raid markers are Appendix A item 5 (sheet later)
