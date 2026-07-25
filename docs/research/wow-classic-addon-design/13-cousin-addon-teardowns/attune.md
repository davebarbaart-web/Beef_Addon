# Tear-down: Attune

**Product:** Attune (CixiDelmont) — attunement progress + guild readiness  
**Primary listing:** [CurseForge — Attune](https://www.curseforge.com/wow/addons/attune)  
**Spotlight write-up:** [Arcane Intellect — Attune TBC AddOn Spotlight](https://arcaneintellect.com/attune-world-of-warcraft-wow-tbc-addon-spotlight/) (2021-06-02)  
**Author forum intro:** [Blizzard forums — Attune addon](https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832)  
**Flavors listed on CurseForge:** Retail, Classic, Classic TBC, MoP Classic (Anniversary-relevant: Classic / Classic TBC trees)

---

## 1. What problem it solves

TBC (and Classic) attunements are long multi-step quest graphs. Attune turns that into:

1. A **personal progress tree** (where am I / what’s next)  
2. A **guild/raid survey table** (who else is stuck on which step)  
3. Optional **raid planning** from that readiness data  

This is the closest Classic ecosystem analogue to Beef’s “shared institutional state among addon users.”

---

## 2. Screen / IA map

Sources describe these primary surfaces (names as marketed; exact tab chrome may vary by version):

| Surface | Entry | What it shows | Actor |
|---------|-------|---------------|-------|
| **Personal progress tree** | `/attune` or minimap LMB | Quest-chain graph for an attunement; hover tooltips (incl. recommended group size) | Any member |
| **Left nav of attunements** | Inside main frame | Switch which dungeon/raid chain you’re viewing | Any |
| **Survey trigger** | “Survey” button | Chooses guild / party / raid target, then collects peer progress | Anyone who surveys |
| **Results / Guild summary** | After survey; “Results” | Table of members × attunement steps / completion | Surveyor + local cache |
| **Toon profiles** | Results → “Show Profiles” | Self-declared status (e.g. alt) + role (tank/healer/dps) for raid org | Each member sets own |
| **Raid Planner** | Results → Raid Planner, or `/attune raid` | Build stored raid teams; see attuned vs not; one-click invite | Raid lead / organizer |
| **Export** | “Export” → “My Data” / guild export | Encoded string for clipboard → optional website upload | Any |
| **Options** | Minimap RMB / Interface Options | Auto-survey, chat announce on attunement complete, other toggles | Any |

Gallery / forum references call out a visual **tree map** of quest steps ([Arcane Intellect](https://arcaneintellect.com/attune-world-of-warcraft-wow-tbc-addon-spotlight/); sample screenshot linked from the [forum post](https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832)). CurseForge description also highlights **Guild summary** consolidation and “see who’s on the attunement step / who’s completed.”

### Information architecture lesson for Beef

Attune splits **my progress** (tree) from **group readiness** (table) from **action tools** (planner). Beef V1 already mirrors this: **My Standing** / **Ladder** / **Officer** — keep that separation; do not merge planner-density into the ladder.

---

## 3. “Officer queue” analogue

Attune is **not** an approve/reject queue. Authority pattern:

- Progress is **self-reported testimony** from each client (quest completion state on that character).  
- The surveyor **pulls** a snapshot; there is no officer commit that mutates another player’s tree.  
- Raid leads *use* the table for human decisions (who to invite, who to nag) — decisions live outside the addon.

| Attune | Church of Beef |
|--------|----------------|
| Self-reported step completion | Self-reported standing (spec §6.3) |
| Survey → results table | `SUGGESTION` → Officer tab |
| Human raid lead invites | Officer+ `RANK_COMMIT` |
| No forged “official attuned” stamp in-addon | Official rank only after officer approve |

**Steal:** treat member-side data as advisory until an authority action; show officers a scannable **who / what / evidence** list.  
**Avoid:** assuming a survey snapshot is forever-correct without refresh (Attune’s model is episodic; Beef needs revisioned commits + login sync because ranks are official).

---

## 4. Sync model

Documented behavior ([CurseForge description](https://www.curseforge.com/wow/addons/attune); [Arcane Intellect](https://arcaneintellect.com/attune-world-of-warcraft-wow-tbc-addon-spotlight/); forked README at [Attune-3.3.5 README](https://github.com/r-o-b-o-t-o/Attune-3.3.5/blob/master/Attune/README.md)):

| Mechanism | Direction | When | Notes |
|-----------|-----------|------|-------|
| **Survey** | Pull: surveyor asks → peers with Attune reply | On button (guild / party / raid) | Soft dependency: non-installers invisible |
| **Optional auto-survey** | Same, automated | Options toggle ([Arcane Intellect](https://arcaneintellect.com/attune-world-of-warcraft-wow-tbc-addon-spotlight/)) | Convenience vs traffic tradeoff |
| **Export string** | Offline / website | Clipboard encode → warcraftratings.com upload (legacy / optional path) | Out-of-band sharing; not Beef’s V1 model |
| **Discord bot** | Out-of-game | CurseForge mentions Discord bot / `!attune` for server lists | Outside in-game BeefNet |

**Classic messaging constraint:** surveys must use allowed addon channels (guild/party/raid/whisper family). BeefNet’s `GUILD` + login sync is the durable pattern; Attune’s survey is closer to Beef’s `SYNC_REQUEST` / `SYNC_STATE` *pull*, not continuous SCORE spam.

### Offline / stale data

Survey only reaches **online** peers with the addon. Offline guildies stay blank until a later survey. Beef’s open question on suggestion-queue sync ([spec §16.5](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) is the same failure mode Attune accepts for readiness tables — except Beef’s ladder is *official*, so login reconciliation is mandatory (spec §8.3).

---

## 5. Announce patterns

From options coverage ([Arcane Intellect](https://arcaneintellect.com/attune-world-of-warcraft-wow-tbc-addon-spotlight/)):

- Toggle to **send chat messages when you complete attunements**  
- Auto-survey toggle  

Pattern: **celebration is opt-in and event-tied** (step complete), not continuous progress drip.

CurseForge also markets social proof (“see who’s completed”) inside the UI rather than guild-chat spam for every step.

**Beef alignment:** spec §10 already wants **one throttled guild-chat line on promote/demote from the approving officer** — closer to Attune’s “complete” celebration than to per-point chatter. Prefer announce on **institutionally meaningful events** (rank commit), not every standing drip.

---

## 6. Soft dependency & graceful degradation

Repeated in primary docs: guild survey / raid planner **only work for members who installed Attune**. Others simply don’t appear. Play continues.

This matches BeefNet’s “players without the addon must not soft-lock” ([spec §8.2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). Guild-chat rank lines cover non-addon members for spectacle.

---

## 7. Steal / avoid (Attune-specific)

### Steal

1. **Slash + minimap** open the same primary frame (`/attune` ≈ `/beef`).  
2. **Progress visualization that is a graph/list of stages**, not a combat HUD.  
3. **Guild summary as a table** — who occupies which stage (Beef ladder rows).  
4. **Survey / sync as explicit action + login pull**, not chat flood.  
5. **Self-declared role/status profiles** as a light social layer (Beef can stay thinner: title + standing only in V1).  
6. **Optional announce on meaningful completion** with a settings toggle.

### Avoid

1. **Website export as the source of truth** for guild state (Beef has no server; officer commits are the truth).  
2. **Raid planner / invite automation** in V1 (out of scope; invite bots are a different product risk surface).  
3. **Questie-like pin spam** — Attune’s tree is dense enough for attunements; Beef has seven ranks and should stay scannable.  
4. **Treating survey data as anti-cheat** — it isn’t; officers still judge (same as Beef standing).

---

## 8. Relevance score for Beef

| Spec need | Attune coverage |
|-----------|-----------------|
| Ladder / progress visibility | Strong (tree + guild table) |
| Officer approve queue | Weak (no commit model) |
| Sync / offline | Medium (survey pull; stale offline) |
| Guild-chat spectacle | Medium (optional complete announce) |
| Soft dependency | Strong |

**Bottom line:** Steal Attune’s **shared readiness IA** and **pull-style sync manners**. Do not steal its authority model — Beef’s Officer+ `RANK_COMMIT` is closer to Gargul’s award than to Attune’s survey.
