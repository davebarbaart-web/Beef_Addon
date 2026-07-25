# Scenario matrix — empty & degraded states

**Track:** 41 — empty states & degraded UX  
**Question:** For each V1 failure/edge, what does the player see, what still works, and what must never happen?

State-handling order for Classic UI (adapted from SaaS three-state advice): **error/hard-gate → loading/syncing → empty → populated** — never show a skeleton that resolves to a blank panel ([Tour Kit empty-state patterns](https://usertourkit.com/blog/empty-states-that-convert-onboarding-design-patterns); [LogRocket empty-state UX](https://blog.logrocket.com/ux-design/empty-state-ux)).

---

## Matrix

| # | Scenario | Detect (conceptual) | Ladder tab | My Standing | Officer tab | Scoring / BeefNet | Primary UX job |
|---|----------|---------------------|------------|-------------|-------------|-------------------|----------------|
| A | **First install** (in guild, fresh SV) | No cached official records; first `/beef` this toon | Seven rank shelves; local player as Fresh Beef highlight; banner “Church is listening — standing starts local” | Local points = 0; next threshold visible; recent events empty with “Run content with a guildmate” | Hidden unless Officer+; if Officer+: empty suggestion queue with “No petitions yet” | Local scoring ON; `SYNC_REQUEST` fires | Onboarding empty — teach what fills the frame |
| B | **Not in a guild** | `IsInGuild()` false ([Wowpedia IsInGuild](https://wowpedia.fandom.com/wiki/API_IsInGuild)) | Empty-state ladder (spec §11); ranks shown as structure, occupants blank | Standing paused badge; last local numbers may linger grayed or zeroed | Hidden | Scoring paused; no BeefNet sends | Hard gate — join/create guild pathway |
| C | **No officers online** (member) | In guild; Officer+ not online (roster); pending suggestions local-only | Show cache / local view; status “No officers online — petitions wait” | Local accrual continues | N/A for members | Suggestions queue locally; no `RANK_COMMIT` expected | Informational — reassure, don’t block play |
| D | **Peers without addon** | Sync / optional version query: few or zero COB responders | Ladder may be thin (self + officer commits only); chip “Few Church clients online” | Unchanged — instance credit with guildmates still works (§7.1) | Officers still approve locally | BeefNet mesh sparse; guild-chat announce still reaches everyone | Partial mesh — celebrate local + chat spectacle |
| E | **Sync pending** | After login/reload `SYNC_REQUEST` until answer, timeout, or suppress | Status line: “Syncing ladder…” then “Using cached ladder” or “Synced” | Prefer not to flash empty | Same | Transient; never block opening `/beef` | System status — short-lived, distinguishable from empty |

---

## Scenario deep notes

### A — First install

**UX type:** First-time / starting state ([Shopify Polaris “starting” framing via Tour Kit summary](https://usertourkit.com/blog/empty-states-that-convert-onboarding-design-patterns); [NN/g pathways](https://www.nngroup.com/articles/empty-state-interface-design/)).

**Must show:**

- Real frame (spec §10 / success #2).
- Rank structure (success #3) even with zero occupants.
- One forward CTA in copy terms: play with guildmates / earn standing — not “No data.”

**Must not:**

- Modal wall of lore on first open (track 11 owns density; this track wants one banner max).
- Imply the ladder is “broken” because peers haven’t answered yet — combine with scenario E status chip.

**Cousin parallel:** Gargul `/gl start` teaches alone, no raid required ([Gargul](https://www.curseforge.com/wow/addons/gargul)); Attune `/attune` shows personal progress before any survey ([Attune](https://www.curseforge.com/wow/addons/attune)).

### B — Not in a guild

**UX type:** Hard gate / informational empty (spec §11).

**Must show:**

- Explicit reason: not in a guild.
- Pathway: join or create a guild (player action outside addon).
- Ladder chrome still readable as “what the Church looks like” — empty shelves beat a dead panel ([Eleken: never leave blank](https://www.eleken.co/blog-posts/empty-state-ux)).

**Must not:**

- Spam chat on every login with the same unguilded error.
- Attempt BeefNet GUILD sends (track 14 mapping already: pause).

**API note:** Gate on `IsInGuild()`; also respect roster-not-ready separately (spec: queue/drop commits — UX should not flash “not in guild” during brief roster lag). Prefer: unknown → quiet “Checking guild…” then B or populated.

### C — No officers online

**UX type:** Waiting / deferred authority (cousin: council/ML offline).

**Member view:** Standing still accrues; suggestions pile for later. Copy must say petitions *wait*, not that the addon is stuck.

**Officer view (self alone):** Officer tab works locally; commits apply locally and sit until peers sync (spec §8.3). Empty suggestion queue is a *post-completion / quiet* empty (“No petitions — the flock behaves”) — celebratory-light, not error ([Eleken celebratory empty](https://www.eleken.co/blog-posts/empty-state-ux)).

### D — Peers without addon

**UX type:** Partial network / feature-education empty for *guild* surfaces.

**Product invariants:**

- Guildmates without COB do **not** block instance standing (§7.1).
- They remain invisible on BeefNet (§8.2) — expected, not an error.
- Promotion spectacle still hits them via guild chat (§10).

**UX job:** One quiet chip or footer — not a scary banner. Optional officer tool later: version/presence list (steal RCL `/rc version` pattern) — V1 can stay a single status string.

### E — Sync pending

**UX type:** Loading / system status (not a true empty).

**Progression (steal from RCL version checker):**

1. `Syncing…` / “Waiting for Church peers…”
2. On first `SYNC_STATE` merge → `Synced` (brief).
3. On timeout, no responders → `Using cached ladder` (or `No peers online — cache kept`) — **same outcome as spec §8.3**, named in UI.

**Must not:** Block `/beef`, clear the ladder to blank during sync, or treat timeout as hard error.

Login timing: addon messages can fail cold; delay sync until world settle (track 14 cites cold-login lore). UX: don’t start the scary empty until after that window.

---

## Cross-cutting rules

| Rule | Why |
|------|-----|
| One main idea per empty panel | Avoid overload ([Eleken mistakes](https://www.eleken.co/blog-posts/empty-state-ux)) |
| Heading + why + next step | Microcopy formula ([UXPin / Yifrah structure](https://www.uxpin.com/studio/blog/ux-best-practices-designing-the-overlooked-empty-states)) |
| Personality second to clarity | Comedy church tone OK in headline; body stays instructional ([Eleken: don’t get too clever](https://www.eleken.co/blog-posts/empty-state-ux)) |
| Distinguish empty vs loading vs stale | Different chips; same frame |
| Never soft-lock unguilded or no-addon peers | Spec §8.2 / §11 |

---

## Related tracks

- Sync merge when data arrives → [27-desync-conflict-resolution](../27-desync-conflict-resolution/)
- Transport / no-send when unguilded → [14-addon-messaging-beefnet](../14-addon-messaging-beefnet/)
- Proposed status strings → [beef-copy-ux-map.md](beef-copy-ux-map.md)
