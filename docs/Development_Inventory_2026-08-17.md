# Church of Beef — Development Inventory
**Date:** 2026-08-17
**Basis:** live repo survey of `Beef_Addon` (branch `reformation/phase-1-excision`), `docs/REFORMATION_LOG.md`, the v1 checklist, validation sheets, open questions, and an independent test run of the offline harness performed for this inventory.
**Independent verification:** `lua tests/run.lua` on a clean snapshot of today's working tree (including uncommitted changes): **6,043 passed, 0 failed.**

---

## The short version

The Reformation worked. Between 2026-08-14 and 08-15, six gated phases excised the old points-ladder demo and rebuilt the addon as the Bible product: a Quiet shell, a Pope-authoritative store with the Sacred Archive, a four-state ceremony runtime, BeefNet v2 (STATE/SNAPSHOT), the Gora and Knighting core verbs, and hosted UI — Director Console at `/beef console`, Records Book at `/beef`, Fight HUD, Decree banner, and Event-mode sound. Gates 0–5 are closed; Gate 6 (validation) is open and waiting on exactly one person: you, in-game, with a method sheet.

The single most important fact in this inventory: **everything ritual is currently fail-closed because `Data/Popes.lua` lists no Pope.** The machine is built, tested, and refuses to run until you put your character's name in it. That is by design — and it means the next unit of progress is not more Cursor work; it's you on the Anniversary client.

---

## Where we are, layer by layer

**Repo state.** One commit on the reformation branch (`5ff9695`, Aug 15 — the "leftover wave") sits ahead of `main`; `main` still points at the pre-reformation demo. The working tree carries substantial uncommitted work: `UI/Console.lua` grew from 638 to 879 lines (+383/−123 with its tests) — the full desk build-out with every sacred verb wired: SANCTION BEEF GORA, KNIGHT THIS BEEF, ELEVATE TO LORD, DECLARE VICTOR, COWARDICE RECORDED, VOID, FREE RULING, Post Decree, MARK THIS MOMENT, plus the runtime controls (Start Event, Open Knighting/Gora/Confession/Proclamation, Close Rite, End Event). The harness is green with this work included, but it exists only on your Mac and only uncommitted.

**Data layer (Phase 2 — done).** Account-level `ChurchOfBeefDB` (schema 7): identities with linked characters via the Rite of Recognition, rank on the human, Gora records on the character, elevation timestamps (so "defenses" stay derivable, per resolved open question #9), ceremony log, marked moments, honorifics, tombstones-never-deletes, and the Sacred Archive export/import with fail-closed restore. This is the Church's permanence promise, implemented.

**Runtime + network (Phase 3/4 — done as skeleton).** QUIET → ASSEMBLY → RITE → CONSEQUENCE, Pope owns every transition, zero-config Tuesday start, event object persisted across reload. STATE broadcasts on GUILD (Pope-only senders), SNAPSHOT catch-up by whisper, protocol versioning with stale-client Quiet, `awaitingPope` degrade. Sender validation exists and is fail-closed against the empty Pope list.

**Ceremony verbs (Phase 4 — done as core).** Sanction-only Gora with the four Pope rulings; KnightThisBeef → Beef Knight; ElevateToLord → Beef Lord. All write the store; none touch guild rank yet (reconciliation is a named leftover).

**Everyday layer (Phase 5 — done).** The Decree: single proclamation + optional flavor line, once-per-login parchment, minimap replay, hard-bounded exactly as §14.1 demands. Sound verbs exist for the five MVP cues and are now called from Console rituals; Quiet is silent.

**Validation scaffolding (Phase 6 — authored, not executed).** Thirteen Appendix A method sheets (A01–A13), every Result field **NOT RUN**; the §22.3 v1 checklist with 39 unchecked boxes; a dress-rehearsal chaos script (late arrival, reload, Pope disconnect, no-show petitioner, disputed Gora); rewritten solo/two-client/guild-night smoke docs.

---

## The critical path to a real ceremony night

In order, each unblocking the next:

1. **Commit the working tree.** The Console desk build-out and its tests are uncommitted on one Mac. The log records you authorized a commit for in-game smoke; land it (and decide whether to finally merge the reformation branch over `main`, which still advertises the dead demo to any fresh clone).
2. **List your Pope character.** Add the Names.Key spelling to `Data/Popes.lua` (or the `ChurchOfBeefDB.ui.popeOverrides` SavedVariables table). This is the one-line change that turns every fail-closed ritual live. Nothing else on this list matters until it's done.
3. **Walk A01–A04 in-game and write the Results.** These four are load-bearing and agent work is explicitly forbidden from filling them in:
   - **A01 live health for non-group units** — decides the Fight HUD's final form (the Bible's #1 feasibility question).
   - **A02 duel system messages** — decides whether verdict proposal ("software proposes, Pope ratifies") can work.
   - **A03 sender integrity + rate limits at 40 clients** — decides BeefNet's ceiling.
   - **A04 guild roster write permissions** — decides whether KNIGHT THIS BEEF can also perform the guild-rank promotion.
4. **Solo smoke, then two-client smoke** per the rewritten phase docs — first login-to-Decree-to-Console walk with a real Pope listed.

That is the whole path to the first end-to-end rehearsal. It is measured in evenings, not weeks — and steps 2–4 are yours, not Cursor's.

## Built but not yet wired (the honest gap between skeleton and show)

- **Console `SendState`** — the console runs the state machine locally but does not yet broadcast STATE, so congregation clients can't follow an event. This is the biggest remaining *code* gap before a two-client smoke means anything.
- **Decree wire** — Post Decree writes locally; no broadcast kind exists yet, so the congregation's banner only shows their own store's Decree.
- **Congregation favor** — no UI and no INPUT channel (the channel is deliberately unspecified; inventing one was banned). Favor is MVP per §10.6/§22.1, so this is the largest unbuilt product feature.
- **Live HUD health** — correctly blocked on A01; the fallback HUD (cards/records/favor, no health) is the Bible-defined plan B.
- **Guild-rank reconciliation** — blocked on A04.

## Deliberately unbuilt (named leftovers, all correctly parked)

SUMMON THE FAITHFUL (no protocol invented), Confession transport, post-show clipboard, onboarding parchment, designated-Council configuration (#8 second half), Curtain UX (#4), Decree deputy (#5), Council Chronicle nomination (#7), polish pass, CurseForge/Wago packaging (#1). None of these block the first rehearsal.

## The theater gap — where the render work plugs in

Every shipped surface is deliberately stock-Blizzard right now, and per the hybrid visual law that's *permanently correct for the Console* — but the theatrical surfaces (Sanction proclamation, verdict seals, Fight HUD dress, Records Book parchment, Decree banner art) are still placeholder-plain. The Batch 2 renders we critiqued are the approved direction for exactly this phase; the polish pass is where "Quiet parchment" stops being a gray frame. Sequence it *after* A01–A04 — no point dressing a HUD whose final form the health test hasn't decided. Batch 3 render priorities (Fighter Card, Knighting proclamation, Victor seal) map one-to-one onto surfaces the code now has hooks for.

## Decisions sitting on your desk

These are open questions only you can close, and two of them now gate code:

1. **#10 — what a FREE RULING writes.** Today `FreeRuling` records `won = false` for **both** fighters — a free ruling silently costs both characters a loss. That's a store-semantics accident, not a product decision. Decide: neither records a W/L (ruling text only), or Pope picks per-fighter. This should be settled before the first real Gora night, because Church history is never deleted.
2. **#3 — Records Book categories** — your veto/additions, ideally checked against what members actually brag about in Discord.
3. **#8 (second half)** — how Council designations are stored/broadcast, and whether Pope-list overrides ever get UX beyond the SavedVariables table.
4. **#5 — Decree deputy** — who besides you may Post.
5. **#1 — distribution** — CurseForge + Wago cadence (only matters at packaging time).

## Distance to the definition of done (§22.3)

The MVP is done when one complete real Gathering runs live on stream — Decree → assembly → Knightings → sanctioned Goras with fight HUD *and favor* → records persisting and visible next morning — with a first-time Twitch viewer able to follow it and you never opening Blizzard's roster. Against that bar: the memory layer and verbs are built and tested (6,043 green), the wire is half-connected (STATE/SNAPSHOT exist, console doesn't send yet), favor doesn't exist, the theater isn't dressed, and zero in-game validation has been recorded. Call it: **data and law ~done; runtime ~90%; network wiring ~60%; ceremony product ~70% (favor missing); theater ~15%; validation 0% — and validation is the current bottleneck, and it's a human one.**

### Recommended next three working sessions

1. **You, in-game (no Cursor):** commit, list Pope, run solo smoke, walk A01+A02, write Results.
2. **Cursor:** Console `SendState` + Decree wire (both become unblocked, well-specified lanes once smoke confirms the transport), then two-client smoke with a friend.
3. **You + Design Lead:** rule on #10 and favor's INPUT channel; then favor becomes the last MVP feature lane, and the polish pass (with the render direction) can start behind it.
