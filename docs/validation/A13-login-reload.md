# A13 — Login/reload event timing

**Appendix A item:** 13  
**Owner:** David  
**Result:** NOT RUN

Cited: Bible Appendix A item 13; §14.1 (Decree shown once per login); §20.3 (late join / UI reload snapshot); §13.1 (star; whisper to the Pope).

## Dependent feature

**Decree banner display** and **snapshot requests**.

- §14.1: the active Decree is shown once per login as a parchment banner; thereafter reachable from the minimap. Hard boundary: no calendar, no RSVPs, no reminders, no recurring events, no attendance tracking.
- §20.3: on late join or UI reload the client requests current state from the Pope's client (whisper) and receives a snapshot — it lands in the right theater within seconds, mid-rite.

Appendix A: login/reload event timing.

**The existing Decree banner on login is not a pass of timing facts.** This item asks *when* events fire and *when* a snapshot request is legal — not whether a banner frame exists.

This item does not invent a SUMMON protocol, INPUT channel, favor, calendar/RSVP, or `#8` override UX.

## Bible fallback

Appendix A item 13 names **no** standalone fallback. The Appendix A closer applies. Do not invent a hold-timer, a sixth runtime state, or a snapshot schema from a FAIL.

Version-mismatch drop to Quiet (§13.4 / §20.3) is a different degrade. It is not this item's fallback.

## Live-client method (Anniversary TBC, Interface 20506)

One client for Decree timing. Two clients (Pope + congregation, same guild) for snapshot timing. `/console scriptErrors 1`. Do not change addon Lua. Do not code `#8`.

1. **Cold login order.** Fresh login (not `/reload`). Record the order and approximate delay of `ADDON_LOADED` (`ChurchOfBeef`), `PLAYER_LOGIN`, and `PLAYER_ENTERING_WORLD` if that last event fires. Note when `ChurchOfBeefDB` is already populated (item 7) vs when UI/Net init has run.
2. **Decree once-per-login.** With an active Decree already in the store, record whether the parchment appears at login, at which event, and whether a second `/reload` shows it again (once per login vs once per reload). Then hide it and confirm minimap can replay. **Seeing today's banner is not the Result.**
3. **`/reload` vs logout.** Repeat step 1 on `/reload` only. Note any event that does not re-fire. That difference is the timing fact.
4. **Snapshot request window (two clients).** Congregation `/reload`s while the Pope is online. Record the earliest moment a whisper-prefix message can be sent and received (server-provided sender — item 3). If `#8` is still fail-closed, record "request timing only; theater snapshot not authorized" — do not invent a Pope list.
5. **Write facts on this sheet.** Event order, banner timing, earliest legal whisper. No calendar. No RSVP. No SUMMON. No INPUT channel.

Do not change addon Lua from this sheet.

## Not a pass

- `DecreeBanner:Init` showing a banner when `Decree:Get()` is set
- `PLAYER_LOGIN` → `UI:Init` / `Net:Init` in bootstrap
- Harness green on `test_decree` / `test_snapshot`
- InspectProgress opening the banner
- A two-client smoke that never recorded event order

## Leftovers

- Snapshot schema (unspecified; do not invent)
- OPEN_QUESTIONS #8 — registered-Pope list; theater snapshot stays fail-closed until licensed
- SUMMON THE FAITHFUL protocol (do not invent)
- INPUT channel (unspecified; do not invent)
- Decree deputy / authorship (OPEN_QUESTIONS #5; do not invent)
- Calendar / RSVP (banned, §14.1)
