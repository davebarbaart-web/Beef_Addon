# Beef scoring & ceremonies — HC-aware rules

**Last updated:** 2026-07-25  
**Scope:** Whether Church of Beef needs Hardcore-specific scoring / ceremony rules. V1 is Anniversary; rules below are either (A) cheap to ship everywhere, or (B) required only for a future HC/Classic port.

Canon sources: [spec §7 scoring](../../../superpowers/specs/2026-07-25-church-of-beef-design.md), [§10 UI](../../../superpowers/specs/2026-07-25-church-of-beef-design.md), [§11 edges](../../../superpowers/specs/2026-07-25-church-of-beef-design.md).

---

## 1. Verdict

| Question | Answer |
|----------|--------|
| Does V1 Anniversary need a full HC ruleset module? | **No** |
| Do any HC-aware rules belong in V1 anyway? | **Yes — a few cheap ones** (ghost pause; Gora naming; transfer honesty) |
| Would a Doomhowl / Classic HC port need scoring deltas? | **Yes** (BG off; death memorial; ceremony-weighted fuel) |

---

## 2. Rules recommended for V1 (Anniversary + brand safety)

### R1 — Pause scoring while dead or ghost

**Rule:** No instance drip, completion bonus, ceremony attendance, or Gora self-outcome while the local unit is dead/ghost.

**Why:** Matches HC ghost logistics; cheap correctness on Anniversary mid-wipe; prevents joke exploits.

**Not:** Auto-demote, standing wipe, or death toast spam.

### R2 — Keep Beef Gora lexicographically far from Mak’gora

**Rule:** UI strings, `/beef` help, and stream copy say **Beef Gora** / “challenge record.” Avoid `/makgora`, “duel to the death,” and String-of-Ears metaphors in product chrome.

**Why:** On HC, `/makgora` is permanent death ([Blizzard](https://worldofwarcraft.blizzard.com/en-us/news/23973734/rules-of-engagement-classic-hardcore-is-coming-to-world-of-warcraft)). Spec Gora pays losses and is officer/human recorded — opposite stakes.

### R3 — No automatic standing import across realm transfer

**Rule:** After HC→Normal Anniversary / cross-realm move, character starts Fresh Beef unless Officer+ manually corrects / commits ranks.

**Why:** Per-character SV + independent guild ladders ([spec §5, §9](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). Optional “pilgrim recognition” ceremony is content, not sync magic.

### R4 — Officer remains anti-cheat (HC culture fit)

**Rule:** Unchanged hybrid suggest → approve. Do not add automated “Soul of Iron” or never-died checks as promotion gates.

**Why:** Soul of Iron is SoM/cosmetic-adjacent history, not Beef canon ([Icy Veins SoI](https://www.icy-veins.com/wow-classic/soul-of-iron-system-for-hardcore-players)). Officers laughing at implausible suggestions is the intended failure mode ([spec §6.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

---

## 3. Rules for a future Hardcore / Doomhowl port only

### H1 — Disable battleground co-play source

BGs do not exist on HC ([Blizzard](https://worldofwarcraft.blizzard.com/en-us/news/23973734/rules-of-engagement-classic-hardcore-is-coming-to-world-of-warcraft)). Gate `INSTANCE` scoring to dungeon/raid (and only carefully consider Wargames — default **off** because death is permanent).

### H2 — Expect lower instance drip; lean on ceremony + Gora

24h dungeon lockouts (sub-60) and anti-boost XP rules slow spam groups. Keep daily caps; consider slightly higher ceremony flat grants in HC canon data (tunable) rather than inventing lockout-based multipliers.

### H3 — Death = hide from live ladder (memorial), not demote

On `PLAYER_DEAD` / confirmed HC death:

1. Freeze local standing grants (R1).
2. Mark character inactive for ladder display (like left-guild).
3. Do not auto-broadcast excommunication.
4. Optional officer **Requiem** ceremony closes with optional manual adjust.

### H4 — Mid-content death voids open ceremony attendance

Same as disconnect mid-ceremony ([spec §11](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)): no credit until officer closes cleanly or grants manual credit. On HC, prefer **void + requiem** over forcing officers to award the dead.

### H5 — Do not score Duel to the Death as Gora

If both systems exist in the same culture, Mak’gora outcomes must **not** auto-feed Beef Gora. Only human-recorded Beef challenges pay. Prevents “double book” of a permanent-death duel.

### H6 — Self-Found community overlays are out of scope

Addon rulesets (Self-Found / Solo Self-Found) are honor/community layers ([Hardcore Mode](https://www.curseforge.com/wow/addons/hardcore-mode)). Beef does not enforce trade/AH bans.

---

## 4. Ceremony design notes (HC tone)

| Ceremony type | HC-aware guidance |
|---------------|-------------------|
| Rank promotion | Keep; spectacle is social, not survival |
| Beef Gora night | Emphasize consent + recorded sport; never conflate with Mak’gora |
| Requiem / memorial | Officer-only; optional; good stream content; no forced standing loss |
| Transfer / “pilgrim” welcome | For HC→TBC arrivals on Dreamscythe etc.; Fresh Beef + optional manual rank gift |
| Excommunication | Still officer tool; unrelated to PvE death |

Clean-UI / low-chrome pressure from HC communities reinforces V1’s thin ceremony stubs ([r/wowhardcore](https://www.reddit.com/r/wowhardcore/comments/1rd6o45/a_clean_ui_can_make_a_difference/); [track 05](../05-packaging-community-antipatterns/)).

---

## 5. What not to build

- Death cause analytics / realm death leaderboards (competitor space)
- Soul of Iron detection as rank gate
- Automatic GM succession
- BG scoring on HC
- Cross-realm Doomhowl↔Dreamscythe ladder merge
- Wagering on Mak’gora or Gora ([track 24](../24-policy-tos-compliance/))
