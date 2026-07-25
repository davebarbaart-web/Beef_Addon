# Beef demote / Prophet / wipe confirm recipes

**Track:** 58-staticpopup-confirms  
**Purpose:** Map locked product actions to confirm UX. Policy/audit doctrine stays in [40](../40-officer-moderation-audit/); rite verbs in [53](../53-beef-lore-ui-bible/); this note owns **dialog behavior**.

Product baseline: [`2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §4.1–§4.3, §7.3, §10.

---

## 1. Risk ladder (what needs a modal)

| Action | Modal? | Severity | Reason field |
|--------|--------|----------|--------------|
| Approve suggestion | No | Low | Optional later |
| Reject suggestion | No (clear label); optional short reason | Low–med | Optional enum |
| Manual standing adjust | Light confirm if large delta | Med | Recommended |
| Council appoint | **Yes** | High | Required short |
| Demote / excommunicate | **Yes** | High | Required short |
| Prophet bestow (empty seat) | **Yes** | Ceremony | Required short |
| Prophet replace (displace living) | **Yes** + alert | Nuclear | Required short |
| Standing wipe / season Lent | **Yes** + alert | Nuclear | Required short |

Matches [40 beef-product-patterns](../40-officer-moderation-audit/beef-product-patterns.md) (“Confirm high-risk”) and [53 string-do-dont](../53-beef-lore-ui-bible/string-do-dont.md) (“Confirm demote / Council / Prophet”).

---

## 2. Shared confirm contract (all high-risk)

Every Beef nuclear confirm should guarantee:

1. **Named subject** — character name in the body (format arg `%s`), never “this player” alone.
2. **Named consequence** — from-rank → to-rank, or “appoint to Beef Council (N/M seats),” or “bestow Beef Prophet.”
3. **Escape cancels** — `hideOnEscape` / custom ESC; no commit on override/timeout.
4. **No timeout auto-accept** — `timeout = 0`.
5. **Works while dead** — `whileDead = true` (StaticPopup) or equivalent.
6. **Officer+ already gated** before the dialog opens; dialog is not the auth layer (BeefNet still verifies).
7. **OnAccept → Core commit only** — announce line is a side effect of commit policy (§10), not a second unsupervised `SendChatMessage` from random UI.
8. **Nil-safe show** — if StaticPopup fails, soft-fail or open custom modal; never silent no-op that looks like success.

Suggested dialog keys (names only): `COB_DEMOTE`, `COB_COUNCIL`, `COB_PROPHET`, `COB_PROPHET_REPLACE`, `COB_STANDING_WIPE`.

---

## 3. Demote / excommunicate

**Spec:** Manual demote is first-class; public demotion is on-brand comedy/rivalry content; same sync path as promotion (§4.3).

| Dialog piece | Guidance |
|--------------|----------|
| Title/body | Use rite verb **excommunicate** / **return** per [53](../53-beef-lore-ui-bible/) — not “set rank dropdown.” |
| Args | `%s` player, `%s` current title → target title (or “Fresh Beef”). |
| Alert icon | `showAlert = true` recommended |
| Reason | Required; stored for officer Recent Actions / audit |
| Announce | Body may note “a guild-chat line will be sent unless you opted out” — do not make announce a second checkbox that enables stealth demote ([40](../40-officer-moderation-audit/beef-product-patterns.md) pressure point) |
| Menu path | Context menu item may open this dialog; never demote in the menu `func` itself ([36](../36-tooltips-menus/03-context-menus-officer-actions.md)) |

**Cancel** must be obvious. Fat-finger demote mid-raid is the failure mode this modal exists to stop.

---

## 4. Council appoint

**Spec:** Seat-limited, appointed, no point threshold (§4.1).

| Dialog piece | Guidance |
|--------------|----------|
| Body | Player name + “Beef Council” + **seat usage** (“2 of 4 seats filled”) |
| Disabled upstream | If seats full, do not open confirm — disable control with tooltip |
| Reason | Required short (“raid lead,” “streamer night,” etc.) |
| Severity | High but below Prophet replace; alert icon optional |

---

## 5. Prophet bestowal & replace

**Spec:** Unique, bestowed, not grindable; should feel like an event (§4.1).

### Empty Prophet seat

| Dialog piece | Guidance |
|--------------|----------|
| Body | “Bestow Beef Prophet upon %s?” — ceremony tone, still clear |
| Alert | Optional; still `timeout = 0` |
| Reason | Required |
| Chrome | Strongest candidate for **custom** modal (seal art / scripture one-liner) if V1 art budget allows; StaticPopup OK for MVP |

### Living Prophet exists (replace)

| Dialog piece | Guidance |
|--------------|----------|
| Body | Must name **both** outgoing and incoming players |
| Alert | `showAlert = true` mandatory |
| Extra friction | Consider typing the target name to enable Accept (custom frame) — post-V1 nice-to-have; V1 at least double-names in body |
| Dual-officer ack | Explicitly **later** per [40](../40-officer-moderation-audit/beef-product-patterns.md) — do not block V1 on four-eyes |

Prophet must never share a one-click path with Approve.

---

## 6. Standing wipe / Lent-style reset

Not a V1 weekly default ([46](../46-seasonality-fresh-servers/) — demote-everyone-on-phase is a no). When officers invoke a wipe tool:

| Dialog piece | Guidance |
|--------------|----------|
| Body | Scope in words: “ranks 1–5 standing → 0” vs “full ladder” — never ambiguous |
| Council/Prophet | State whether seats survive (season notes say they usually do) |
| Alert | Mandatory |
| Reason | Required; treat as audit-grade |
| Confirm pattern | Prefer custom or StaticPopup with edit box; Ace `confirm` only if exposed as a settings execute |

---

## 7. Approve / reject (explicit non-goals)

| Action | Confirm stance |
|--------|----------------|
| Approve | Direct click; label is the confirm |
| Reject | Direct click; copy that points remain (spec / 40); optional reason without blocking modal |

Do not train officers to click through a StaticPopup on every Cooked Beef — alert fatigue makes them Accept-blind when Prophet appears.

---

## 8. Copy skeleton (illustrative — finalize in 32/53)

Not locked strings; shape only:

- Demote: “Excommunicate **%s** from **%s**, returning them to **%s**?”
- Council: “Seat **%s** on the Beef Council? (%d / %d seats filled)”
- Prophet: “Anoint **%s** as Beef Prophet?”
- Prophet replace: “Replace Prophet **%s** with **%s**? This is unique — only one Prophet remains.”
- Wipe: “Wipe standing for ranks 1–5 for the whole guild ladder? Council/Prophet seats: **unchanged**.”

Buttons: prefer clear verbs (`Excommunicate` / `Anoint` / `Cancel`) over bare Yes/No when space allows; Yes/No is acceptable if body carries the verb.

---

## 9. Combat / dungeon note

Confirms are insecure UI — may show in combat. Do not gate demote behind “leave combat.” Do not touch protected frames from OnAccept. If using StaticPopup, nil-show during a Blizzard popup storm is the main operational risk — queue a re-open on the Officer tab rather than blocking the pull.

---

## See also

- [staticpopupdialogs-api.md](staticpopupdialogs-api.md)
- [custom-confirm-frames.md](custom-confirm-frames.md)
- [40 — beef-product-patterns](../40-officer-moderation-audit/beef-product-patterns.md)
- [36 — click vs confirm](../36-tooltips-menus/03-context-menus-officer-actions.md)
