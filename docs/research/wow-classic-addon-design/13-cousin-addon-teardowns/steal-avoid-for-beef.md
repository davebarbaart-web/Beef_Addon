# Steal / avoid map — Church of Beef V1

**Inputs:** [attune.md](attune.md) · [gargul.md](gargul.md) · [rp-directory-trp3-mrp.md](rp-directory-trp3-mrp.md)  
**Product truth:** [design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)

Composite product Beef should feel like:

> **Attune’s guild readiness table** + **Gargul’s officer decision queue** + **TRP3’s title/directory browse** — without loot automation, without MSP prose spam, without raid-planner scope.

---

## 1. Screen composition (recommended V1 IA)

| Tab / surface | Steal from | Notes |
|---------------|------------|-------|
| **Ladder** | Attune guild summary + TRP3 directory | Seven rank bands; occupant names; local highlight |
| **My Standing** | Attune personal progress | Points, next threshold, short event list — not a meter |
| **Officer** | Gargul RollOff / Award | Pending suggestions; breakdown; Approve / Reject; confirm on demote / Prophet / wipe |
| **Thin Gora / Ceremony stubs** | Gargul “note on decision” | Enough to record outcome; no match theater (deferred) |
| **Toasts** | Gargul roller widget manners | Brief, hideable, non-center-HUD |
| **Guild chat line** | Gargul announce ownership + Attune complete celebrate | Officer client only; throttled; opt-out |

Do **not** add: SoftRes matrices, GDKP, PackMule, map scan, raid invite planner, chat name recolor.

---

## 2. Officer queues

| Pattern | Source | Beef application |
|---------|--------|------------------|
| Single authority actor | Gargul ML | Officer+ only for commits |
| Pending list with evidence | Gargul rolls + Attune “who’s on step” | Player, from→to rank, standing breakdown, recent events |
| Confirm dialogue on commit | Gargul Award | Especially demote / Council appoint / Prophet |
| Reject without destroying underlying progress | Implicit in both | Reject clears suggestion; points remain (spec §7.3) |
| Multi-voter council UI | RCLootCouncil (contrast) | **Avoid for V1** — hybrid ladder is not loot council |

---

## 3. Sync models

| Pattern | Source | Beef application |
|---------|--------|------------------|
| Soft dependency | All three | Non-installers invisible to BeefNet; game still playable |
| Pull / survey | Attune survey | `SYNC_REQUEST` / `SYNC_STATE` on login |
| Officer broadcast of official snapshot | Gargul SoftRes Broadcast | `RANK_COMMIT` |
| Version capability ping | Gargul `/gl version`, MSP `VA`/`VP` | `HELLO` soft-warn |
| Peer profile cache | TRP3 directory | Cached official records + revisions (spec §8.3) |
| Website as ledger | Attune export / TMB | **Avoid** as authority (optional future tooling only) |
| Self-published identity as truth | MSP | **Avoid** for ranks; keep for player’s own TRP3 sheet |

**Critical Beef-specific add** (cousins under-serve this): **revision numbers + replay safety**. Loot awards and attunement surveys are episodic; ranks persist across logouts.

---

## 4. Announce patterns

| Do | Don’t |
|----|-------|
| One guild-chat line on promote/demote from approving officer | Everyone’s client announcing the same event |
| Toast the affected player + officers | Permanent center-screen widgets |
| Settings: announce opt-out, maybe verbosity later | Per-point or per-instance drip in guild chat |
| Plain text readable without addon | Dependence on colored RP chat names for spectacle |
| Severity: toast < guild chat < (never) raid warning for ranks | Gargul-style raid warning for SoftRes rolls |

Success criterion remains social reaction ([spec §13.11](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

---

## 5. Authority & anti-cheat stance (reinforced)

Cousins agree with the spec’s honesty:

- **Attune / MSP:** self-reported client data.  
- **Gargul:** human ML is the gate for awards.  
- **Beef:** standings are advisory testimony; **officer approve is anti-cheat** (spec §6.3).

Build officer UI that makes junk suggestions *funny and obvious*, not cryptographically impossible.

---

## 6. Priority steal list (implementation-facing)

1. `/beef` + minimap → one frame, three tabs (Attune/Gargul entry culture).  
2. Officer queue: select → evidence → Approve/Reject → confirm when destructive (Gargul).  
3. Ladder as directory rows under seven titles (TRP3 + Attune summary).  
4. Login pull sync + officer commit broadcast (Attune survey + Gargul broadcast + revisions).  
5. Single-owner guild-chat announce with opt-out (Gargul announce ownership).  
6. `HELLO` / version soft-warn (Gargul version check).  
7. Empty states that teach (`/gl start` spirit, not Ace installer).

## 7. Priority avoid list

1. Loot automation / PackMule / autoloot (Gargul features + hard ban).  
2. Spreadsheet density (TMB matrices, auctionator-scale tables).  
3. Raid planner / auto-invite (Attune feature creep for V1).  
4. MSP-sized prose on GUILD.  
5. Chat restyling wars.  
6. Requiring every member to install for the guild night to function.  
7. Treating website export or SV edits as trusted without officer eyes.

---

## 8. One-page cousin matrix

| Concern | Attune | Gargul | TRP3/MRP | Beef V1 target |
|---------|--------|--------|----------|----------------|
| Progress UI | Tree | Loot/roll windows | Profile sheets | Ladder + My Standing |
| Group table | Guild survey | Roll list | Directory | Ladder occupants |
| Authority | None (self) | ML award | Self profile | Officer+ commit |
| Sync | Survey pull | Session + broadcast | MSP on demand | Commit + login sync |
| Announce | Optional complete | Raid/party loot+rolls | Ambient chat | Guild promote line |
| Soft dependency | Yes | Yes (strong) | Yes | Yes |

---

## 9. Open questions this research sharpens (not blockers)

Already in spec §16; cousins add pressure:

1. **Suggestion queue offline** — Attune-style “missed the survey” will annoy officers; plan sync extension early if nights are sparse.  
2. **Announce opt-out default** — if default off, spectacle dies; if default on, prepare for one grumpy officer. Prefer **default on, easy off**.  
3. **TRP3 coexistence** — decide whether Beef shows WoW name, RP name, or both on ladder rows (V1: WoW name is enough).
