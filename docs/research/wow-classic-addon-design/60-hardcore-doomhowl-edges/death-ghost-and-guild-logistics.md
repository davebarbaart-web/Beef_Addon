# Death, ghost mode, and guild logistics

**Last updated:** 2026-07-25  
**Scope:** What happens after a Hardcore death, and how that maps onto Beef ladder / officer flows.

---

## 1. Official post-death flow

From [Blizzard Rules of Engagement](https://worldofwarcraft.blizzard.com/en-us/news/23973734/rules-of-engagement-classic-hardcore-is-coming-to-world-of-warcraft) and secondary summaries ([Dot Esports](https://dotesports.com/wow/news/official-wow-classic-hardcore-rules-explained-deaths-pvp-dungeons-and-more), [Icy Veins](https://www.icy-veins.com/wow-classic/classic-hardcore-rules)):

1. Character dies → **cannot resurrect on Hardcore**.
2. Player may **release and exist as a ghost** in the world.
3. Ghost time is for **communication and logistics** — notably handing off **guild leadership** if the GM died.
4. Player may use **Free Character Move** to a non-Hardcore realm; after transfer, normal resurrection applies; **no return to HC**.

Anniversary-era nuance: after TBC pre-patch transfer windows, dead Anniversary HC characters’ FCM destinations shifted toward **non-HC Classic Era** (see [doomhowl-transfer-to-tbc.md](doomhowl-transfer-to-tbc.md)).

---

## 2. Spec edges that already almost fit

| Spec situation ([§11](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) | HC death rhyme |
|----------------------------------------------------------------------------------------|----------------|
| Not in a guild → scoring paused | Ghost may still be “in guild” until ranks transfer — pause on **dead/ghost**, not only unguilded |
| Player leaves guild → record retained but hidden | Death → hide from live ladder; retain commits |
| Disconnect mid-ceremony → no credit until clean close | Death mid-ceremony → treat as disconnect; officer grants manual credit or voids |
| Officers demote manually (excommunication) | Death is **not** demotion content by default — memorial > roast, unless clergy chooses spectacle |

---

## 3. Recommended Beef behaviors (HC-aware; cheap on Anniversary too)

### 3.1 Scoring pause

While local player is dead or ghost:

- Stop instance drip / completion credit
- Ignore ceremony attendance ticks
- Block Gora outcome recording for self
- Allow UI read-only: ladder, My Standing history, officer queue if somehow still Officer+ as ghost

Rationale: prevents “ghost farming” absurdities and matches HC’s “logistics only” ghost role.

### 3.2 Ladder presentation after death

| Approach | Recommendation |
|----------|----------------|
| Auto-wipe standing | **No** — fights no-decay V1 and memorial storytelling |
| Auto-demote to Fresh Beef | **No** — confusing with live alts |
| Hide from live ladder; keep commit history | **Yes** — same family as “left guild” |
| Officer “Requiem” ceremony (optional) | **Yes** — brand-aligned; manual standing adjust if clergy wants |

### 3.3 Guild Master death

Official HC expects ghosts to transfer GM. Beef cannot automate that ([addon-limitations-and-ethics.md](addon-limitations-and-ethics.md)). Officer checklist for clergy:

1. Transfer WoW guild rank/leadership in-game (protected action).
2. Ensure a living Officer+ holds Beef approve rights.
3. Optionally `RANK_COMMIT` corrections if Prophet/Council seats were on the dead character.

### 3.4 Alts after a main dies

Spec: each character starts Fresh Beef. HC culture often immediate-rerolls. That is already correct — **no account merge**. Optional streamer ceremony: “the herd renews” when the alt joins the guild.

---

## 4. Anniversary / Dreamscythe note

On TBC Anniversary, death is normal. Ghost pause still costs little and avoids weird mid-wipe scoring. Do **not** ship HC death popups, String-of-Ears trackers, or realm-wide death ledgers in V1 — that is a different product category ([Hardcore Mode addon](https://www.curseforge.com/wow/addons/hardcore-mode)).
