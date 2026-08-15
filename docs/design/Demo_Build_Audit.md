# Church of Beef — Demo Build Audit
## Conformance Review of the Cursor Workspace Against Design Bible v1.1

**Auditor:** Design Lead
**Build reviewed:** `/Volumes/AI_Design_Drive/Beef_Addon` (addon source, tests, docs, `.cursor/rules`, as of Aug 14, 2026)
**Standard:** Design Bible v1.1 + Canonical Decisions handoff
**Files read in full or substantial part:** `Data/Ranks.lua`, `Core/Scoring.lua`, `Core/Ladder.lua`, `Core/Gora.lua`, `Core/Ceremony.lua`, `Core/Quest.lua` (head), `Core/Instance.lua` (head), `Net/BeefNet.lua` (head), `UI/Toasts.lua` (head), `UI/MainFrame.lua` (head), `README.md`, `AGENTS.md`, `docs/canon/ranks.md`. Remaining UI/Core files assessed by role and cross-reference.

---

## 1. Executive Verdict

**The demo is a well-engineered implementation of the wrong product.**

The code quality is genuinely high — disciplined module layering, an offline test harness, careful API guards with Classic+ port notes, throttled and rate-limited networking, thoughtful comments. The engineering practices should be kept almost wholesale.

The product, however, is not the Church of Beef of the design bible. What has been built is a **generic guild points-ladder with Beef-themed names**: standing points earned by minute-buckets of co-play, daily caps, threshold-triggered promotion petitions, officer approval queues, and a seven-rank linear ladder including two invented ranks. Nearly every load-bearing canonical principle is violated — not at the edges, but at the center of the design. There is no Beef Pope anywhere in the codebase. There is no ceremony theater, no sanction, no duel, no event mode, no Director Console, no records, and no player-level identity.

This is precisely the failure mode the peer review predicted: *"agent-invented answers are precisely how 'another game inside WoW' gets built by accident."* The demo predates Bible v1.1, and the Cursor workspace self-authored its own design spec (`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`) plus sixteen `.cursor/rules` files that now **enforce the divergent product** — rules literally named `ladder-authority.mdc` and `scoring-coplay.mdc`. Until those governing documents are replaced, every future agent session will confidently rebuild the wrong product, because the workspace's own law tells it to.

**Bottom line:** roughly a quarter to a third of the *code* is salvageable as plumbing. Close to none of the *product logic* survives. The rework is substantial but well-bounded, and the reusable layers (transport, test harness, identity normalization, toast engine, module discipline) are exactly the boring-hard parts you'd least want to rebuild. This audit exists so the rework happens now, at demo stage, rather than after another month of building on the wrong foundation.

---

## 2. Root Cause (read this before assigning any blame to the agents)

The agents did competent work against the spec they were given. The failure is upstream: the workspace's canon was written before the Design Bible, encodes a conventional guild-progression product, and was then hardened — rules, glossary, ADR logs, research tracks — into exactly the kind of self-reinforcing governance a good agent obeys. `AGENTS.md` says "design spec / glossary / Data/Ranks.lua win." They did. The fix is therefore not "code better"; it is **replace the workspace's law with bible-derived law**, then rework the code under it. Section 6 gives the sequence.

---

## 3. Canon Violations (what the demo does vs. what canon says)

Ordered by severity.

**V1 — A points economy is the spine of the product.** `Core/Scoring.lua` grants standing points for instance minute-buckets (5/12 pts), battleground completions (20), quest fellowship buckets (3), ceremony attendance (40), and Gora results (15/8/5), under per-source daily caps with anti-AFK rules. This is, verbatim, the "Beef XP / artificial currency / engagement treadmill" that Bible §4.6 bans, and public-facing measurement of *behavior* (minutes in combat near guildmates) rather than *events*, which §4.9 bans. The entire mechanism — points, caps, buckets, grants — is the product's engine in the demo and must not exist at all.

**V2 — Ranks are a linear threshold ladder; the social structure is wrong.** `Data/Ranks.lua`: Fresh 0 → Cooked 50 → Knight 200 → Lord 500 → **Beef Butcher 1000** → Council → **Beef Prophet**. Bible §5 is explicit that ranks are *different kinds of relationship*, not a ladder: Cooked Beef is a Discord/community signal (not 50 points); Knight is a *ceremony*, not a 200-point threshold with an advisory "rite flag" that "does not block suggestions — officers are coached only" (`Ranks.lua:31`); Lord is earned in sanctioned combat, not 500 points; Council is human judgment (the demo gets the "appointed" part right); "Beef Butcher" is an invented grind capstone ("the highest grindable peak" — `docs/canon/ranks.md`) that contradicts the no-ladder-above-Lord ruling; "Beef Prophet" is an invented GM rank where canon has the Beef Pope. The demo's own lore file even inverts the funnel: "Discord is community follow-up… never a lock on this rank" — canon says Discord *is* the Cooked Beef signal.

**V3 — There is no Pope; authority belongs to "officers."** The entire authority model is guild-rank-index gating (`OfficerRankIndexMax = 1`). Knighting is performed by *any officer closing an attendance ceremony with an honoree named* (`Ceremony.lua`). Canon: Knighting, sanctioning, elevation are **ceremonial sovereignty of the Pope** (§6), non-delegable; Council supports operations, never rituals. The demo has democratized the one thing canon centralizes.

**V4 — Beef Gora is a typed self-report, not a sanctioned duel.** `Core/Gora.lua`'s own comment: *"A Gora is two members typing a result at each other… the cheapest thing in the game to fake."* No petition-to-the-Pope, no sanction, no fighter presentation, no favor, no fight HUD, no duel detection, no adjudication verbs, no records — just a pair-cooldown and points. The MVP centerpiece (§10) is entirely absent; what exists under its name is a points faucet with an anti-farming throttle. Even the "goraLordWin" rite is inverted: the demo requires *beating a sitting Lord* to be Lord-eligible — canon (David's ruling) says win a fair sanctioned match, attainable milestone.

**V5 — Ceremony is an attendance-credit ledger, not theater.** `Core/Ceremony.lua` samples who stood in the group at start and close and pays them points. No event states, no theater, no congregation experience, no runtime (§20). The bible's ceremony is a *performance the software stage-manages*; the demo's ceremony is a *timesheet*.

**V6 — Identity is per-character; canon's identity model is absent.** `SavedVariablesPerCharacter`, "Alts start fresh" (README). Canon §12: Church identity belongs to the human, characters link via the Rite of Recognition, records aggregate. The demo also *prunes departed members after 14 days* (`Ladder:SweepDeparted`) — canon §12.3: **Church history is never deleted.**

**V7 — Wrong data authority model.** The demo deliberately retired state replication in favor of "standing is local self-reported testimony + officers verify" — a peer self-report model. Canon §13.1: Pope-authoritative star; one writer; congregation clients are terminals. Note the demo's instinct here ("the wire may tell us a petition exists; it does not get to tell us how much standing the subject has") is *good security thinking aimed at the wrong authority*.

**V8 — Excommunication and demotion exist as first-class spectacle.** README ("elevated (or excommunicated)"), `Toasts.lua` kinds `demote`/`excommunicate`. Canon has no demotion mechanics (§5, §10.4) and moderation is deliberately *un-theatrical* (§6: serious, private). Public excommunication spectacle is a culture hazard canon never authorized.

**V9 — Always-on engagement surfaces.** Standing tab, points history feed, promote-suggestion toasts firing during normal play, minimap pip lighting on grants. Canon §19.1 (Quiet Mode contract): at most minimap presence + Decree. The demo's ambient layer is the "small always-visible panel" creep the bible names explicitly.

**V10 — Visual direction conflict.** The demo's rules ban custom media and mandate stock Blizzard chrome ("no brand hex paint"). Bible §19.3 establishes the dark-iron/parchment/ecclesiastical identity as core to the comedy. Stock-template pragmatism was defensible for a demo; it cannot be the law for the real product. (This one is a *conflict to resolve*, not a pure violation — see §7.)

---

## 4. Component Verdicts

| Component | Verdict | Disposition |
|---|---|---|
| `Net/BeefNet.lua` — transport: throttle bucket, inbound per-sender rate limits, protocol versioning, framing, API guards | **Keep (rework messages)** | The best code in the repo. Keep the transport skeleton wholesale; replace the two message types with the v1.1 protocol (Pope-authoritative broadcast + snapshot whisper + input messages); add registered-Pope sender validation (§13.4). Its version-mismatch discard behavior already matches §20.3. |
| `Core/Common.lua` — Names.Key/Display identity law, Clock abstraction | **Keep** | Sound, needed everywhere, already battle-tested by the merge logic. |
| Test harness (`tests/run.lua`, `wow_stub`, `wow_ui_stub`, CI) | **Keep** | Offline-testable Core is a discipline worth its weight; new systems (runtime state machine, Gora flow, records) should be built test-first on this harness. Existing test *suites* die with their subjects. |
| Module layering + engineering rules (`addon-module-layers`, `lua-cob-modules`, `toc-lifecycle`, `wow-ui-taint-lockdown`, `wow-performance`, `testing`, packaging rules, install scripts) | **Keep** | Good engineering law, product-agnostic. Keep enforced. |
| `UI/Toasts.lua` — priority queue, dedupe, animation discipline | **Keep (rework kinds)** | Solid notification plumbing. Delete `demote`/`excommunicate`/`suggest`/`credit` kinds; re-aim at Event Mode consequence beats and rare Quiet Mode system notices. Its restraint rules (no center-screen pulses) survive as Quiet Mode law. |
| `UI/MainFrame.lua` — resizable tabbed shell, paint coalescing | **Rework** | Competent frame plumbing worth harvesting (drag/resize/coalescing), but the product's two surfaces are the minimal congregation view and the Director Console — not a guild-management window with Ladder/Standing/Officer tabs. Salvage the plumbing; discard the information architecture. |
| `Core/Roster.lua` — guild roster reading, completeness tracking | **Rework** | Roster sensing is needed for the Presence desk and rank reconciliation (§5). Replace the rankIndex→ChurchRank *mapping* with the display-vs-truth model; keep the read/refresh machinery. |
| `Core/Officer.lua` — authority gating | **Rework** | Becomes the Pope/Council authority module (registered Pope characters, Council designations) instead of guild-rank-index checks. |
| `UI/Minimap.lua` | **Rework (light)** | Keep the button; delete the grant-driven pip behavior (V9). |
| `Core/Ceremony.lua` | **Discard (salvage one idea)** | The attendance ledger dies with the points. The one idea that survives: a Knighting writes a durable Church record — but as the *result of KNIGHT THIS BEEF in the ceremony runtime*, not an officer timesheet close. |
| `Core/Gora.lua` | **Discard (salvage one idea)** | The typed-result model is unsalvageable (V4). Survives: pair-key head-to-head bookkeeping is a primitive the real records system also needs. |
| `Core/Scoring.lua` + all grant plumbing | **Discard** | Not reworkable — the concept itself is banned (V1). No points system may replace it. |
| `Core/Ladder.lua` — standing, suggestions, petitions, departed-sweep | **Discard** | The suggestion economy dies with scoring; the 14-day history purge violates §12.3. Its wire-distrust instinct (claimed vs. verified) is worth quoting in the new Net spec, aimed at the Pope-authority model. |
| `Core/Instance.lua`, `Core/Quest.lua` | **Shelve** | As scoring feeders: discard. But their *sensing* (instance type detection, guildmate counting, API guards) is a head start on later-phase Expedition witnessing (§14.3). Move to an attic branch; do not delete; do not ship. |
| `Data/Ranks.lua` | **Discard/replace** | Replace with v1.1 §5: five real ranks, no thresholds, no Butcher, no Prophet; Pope + rank-mapping per the display-vs-truth rule. |
| `docs/canon/ranks.md`, `docs/superpowers/specs/*`, plans | **Retire to archive** | Superseded by Bible v1.1. Archive, don't delete — the git history should show why the turn happened. |
| `.cursor/rules/ladder-authority.mdc`, `scoring-coplay.mdc`, `canon-data.mdc`, `beefnet-messaging.mdc` (domain rules) | **Discard/replace** | These are the machine that will rebuild the wrong product. Replacing them is **step one** of the rework, before any code changes. |
| README, AGENTS.md | **Rewrite** | Point at the Bible and the forthcoming implementation brief as sole product law. |
| Hard safety rules (no automation/injection; Lua/XML only; `20506` target) | **Keep verbatim** | Fully aligned with canon — and the Classic+ port-note discipline in every module is the §3.2 portability principle already practiced. Commend it; keep it. |

---

## 5. What the Demo Got Right (protect these through the rework)

Worth naming, because the rework should not bulldoze them: the **"suggest, never promote — a human approves" DNA** is §4.4's propose/ratify law, just pointed at officers instead of the Pope — re-aim it, don't relearn it. The **wire-skepticism** (claims vs. locally-verified data, inbound rate limiting per sender, protocol version discards) is half of §13.4 already built. The **offline test harness and layering law** ("UI must not award points; Net must not invent ranks; Core must not CreateFrame") is exactly the discipline the real product needs — the layer *names* survive even though the *content* changes. The **API-guard + Classic+ port-note convention** in every module is the portability principle as working practice. And the **anti-flood, anti-fake instincts** throughout (bounded tables, TTLs, fail-closed refusals) are the right paranoia for a guild full of jokers — they just belong under the sanction model, where legitimacy comes from the Pope's ruling rather than from caps and cooldowns.

---

## 6. Rework Sequence (recommended order, before any new feature code)

1. **Replace the workspace law.** New `.cursor/rules` derived from Bible v1.1 (the forthcoming implementation brief becomes `architecture-overview` + domain rules); archive the old spec/plans/canon docs; rewrite README/AGENTS.md. Until this lands, no agent should touch product code.
2. **Excise the points economy.** Delete Scoring, Ladder's standing/suggestion machinery, Instance/Quest wiring (attic branch), the Standing tab, grant-driven toasts and pips. The addon should compile and load doing *almost nothing* — that quiet shell is, correctly, Quiet Mode.
3. **Re-found the data layer.** Account-level SavedVariables; Pope-authoritative store with the §13 schema (identities, linked characters, Gora records, ceremony log); never-delete rule; Sacred Archive export/import.
4. **Build the ceremony runtime (§20) on the kept transport**, with registered-Pope sender validation — this is the skeleton everything else hangs on, and BeefNet's kept plumbing makes it a bounded task.
5. **Rebuild Gora as the sanctioned-duel flow (§10)** with the Director Console's Gora desk, fight cards, favor, verdict verbs, records — then Knighting workflow, Records Book, Decree, sound.
6. **Validate Appendix A items** as they become load-bearing (duel system messages and HUD health feasibility first).

The demo's own dress-rehearsal instinct (`docs/phases/guild-night-playtest.md` — "if a promotion passes unnoticed in guild chat, V1 has failed") shows the team already thinks in live-social acceptance tests. Point that instinct at the §22.3 definition of done.

---

## 7. Rulings Needed From David (two, both small)

1. **Visual identity vs. stock-chrome rules (V10).** The demo's "no custom media, stock Blizzard templates only" rule conflicts with the bible's ecclesiastical visual direction. My recommendation: keep stock-template *pragmatism* for the congregation's functional surfaces, but the theatrical layer (proclamations, fight cards, seals, Records Book) is where the parchment-and-dark-iron identity is non-negotiable — that contrast is the §19.3 comedy engine. Confirm, and the UI rules get rewritten accordingly.
2. **"Beef Prophet" and "Beef Butcher."** Both are agent inventions with some in-fiction charm. My ruling as design lead: **Butcher dies** (it exists to cap a grind that no longer exists) and **Prophet dies as a rank** (the Beef Pope is not a rung on anyone's ladder). If either name has earned real affection in the community, they belong in the honorifics pool (§15), not the rank structure. Veto if the community history says otherwise.

---

## 8. Answer to the Standing Question

*"Is this ready to hand off to Cursor?"* — After this audit: the bible is ready, the demo is not aligned, and the bridge between them is one more document: the **Cursor Implementation Brief** (workspace law derived from v1.1 + this audit's rework sequence + the keep/discard manifest as explicit file-level instructions). With that brief landed as the new `.cursor/rules` foundation, the handoff is clean and the rework is a bounded, well-lit path rather than a vibe. I recommend writing it immediately, now that these findings exist to anchor it.
