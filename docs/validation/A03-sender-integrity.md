# A03 — Addon message sender integrity

**Appendix A item:** 3  
**Owner:** David  
**Result:** NOT RUN

Cited: Bible Appendix A item 3; §13.1; §13.4; §20.3; OPEN_QUESTIONS #8 (unread here — do not code).

## Dependent feature

§13.4 trust model, §13.1 broadcast, §20.3 snapshots.

- Theatrical UI renders **only** from messages whose **server-provided sender** is a registered Pope character (Appendix A: the sender primitive is non-spoofable).
- State broadcasts one-way on the guild addon channel with sequence numbers (§13.1).
- Late join / UI reload: the client requests current state from the Pope's client on **whisper** and receives a snapshot (§20.3).
- Appendix A also names RAID and WHISPER as channels to validate, plus rate limits at 40-client scale and a throttle library.

Registered-Pope configuration is OPEN_QUESTIONS #8. **Do not code `#8`.** `Sender:IsRegisteredPope` stays fail-closed (`false`) until David specifies the list. This sheet validates the **sender primitive and channels**, not a Pope list.

## Bible fallback

Appendix A item 3 names **no** fallback. The Appendix A closer applies: if sender integrity, a named channel, or 40-client rate limits fail validation, a design fallback decision happens *before* implementation improvises one.

Do not invent a 40-client proof. Do not treat the fail-closed sender stub as a pass of this item.

## Live-client method (Anniversary TBC, Interface 20506)

Minimum: Pope client + one congregation client, same guild. `/console scriptErrors 1`. Addon prefix `COB`, channel `GUILD` as shipped.

1. **Server-provided sender (GUILD).** From the Pope client, send a harmless guild addon message (existing BeefNet traffic is enough if it is on the wire; otherwise a one-shot prefix ping). On the congregation client, record the `CHAT_MSG_ADDON` sender argument. Confirm it is the server-provided name, not a name inside the payload.
2. **WHISPER.** Congregation whispers a snapshot-shaped request to the Pope character (or any prefix whisper both clients can see). Record the sender argument on the receiver. Confirm whisper delivery and that the sender is still server-provided.
3. **RAID.** If both characters can form a raid: repeat a prefix message on RAID. If they cannot, write "RAID not exercised" — do not invent a raid.
4. **Spoof check (observation only).** Confirm theatrical UI does not render from a congregation-originated payload that *claims* to be the Pope. Do not write a spoof tool. Do not add `Data/Popes.lua`.
5. **Rate / throttle (honest scale).** With the clients you actually have, note whether outbound send is delayed or dropped under repeated sends, and whether inbound per-sender limits fire. **40-client scale is the Bible target, not a number this sheet fabricates.** If fewer than 40 installed clients are present, write the count and leave 40-client as unproven.
6. **Write facts on this sheet.** Channel, sender string shape (realm suffix or not), and what happened at the scale you had.

Do not change addon Lua from this sheet. Do not code `#8`.

## Not a pass

- `Sender:IsRegisteredPope` always `false`
- Isolated `test_sender` / `test_codec` / `test_snapshot` green
- A two-client smoke that never recorded the server sender argument
- Any desktop claim about 40-client rate limits

## Leftovers

- OPEN_QUESTIONS #8 — exact Pope list, edit path, override UX
- INPUT channel (unspecified; do not invent)
- RAID channel if no raid was formed
- 40-client rate-limit proof
- Throttle-library choice if the live client needs one the shipped bucket does not cover
