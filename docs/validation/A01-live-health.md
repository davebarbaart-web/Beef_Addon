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

The HUD still ships the no-health fallback for fighters who are **not** in the local party or raid (`UI/Hud.lua`, mute rails, `health` nil). **That is not a validation pass of this item.** OPEN_QUESTIONS #2: Appendix A item 1 result decides HUD final form for non-group units. Do not treat the fallback as the answer.

**Ship-first (David, 2026-09-14):** raid/party `UnitHealth` on `player` / `raid1`–`raid40` / `party1`–`4` is ordinary group API, not this item. Make that viable for a 40-man before treating out-of-party reads as a commit gate. This sheet stays about non-group units. Result stays NOT RUN until David writes PASS / FAIL / PARTIAL.

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
- `GetView().health == nil` when the fighter is not a local group unit
- Cards / records / favor rendering without bars for unbound fighters

Those are the fallback, not item 1.

## Leftovers

- OPEN_QUESTIONS #2 stays open until David writes a Result for non-group units
- Raid/party bars may ship while this Result is still NOT RUN
- Favor split is a later INPUT surface; this item does not invent it
- Raid markers are Appendix A item 5 (sheet later)
