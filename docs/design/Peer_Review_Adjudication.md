# Church of Beef Add-On — Peer Review Adjudication
## Design Lead Rulings on Independent Review Recommendations → v1.1

**Prepared by:** Design Lead (v1.1 program)
**Inputs:** Design Bible v1.0 · Independent Peer Review · Canonical Decisions & Open Questions handoff · David's answers of 2026-08-14 (target client, Gora norms, Lord scarcity, cadence)
**Purpose:** Record which peer-review recommendations enter Design Bible v1.1, in what form, and why. Important rejections and modifications are explained. Nothing here reopens the canonical decisions.

**David's four answers, for the record, since several rulings hinge on them:**

1. **Target client:** Anniversary realms, currently in TBC. Long-term aim: the rumored "Classic+" (unannounced, rumored fall 2026).
2. **Gora norms:** No established norm — the Pope rules per match.
3. **Lord scarcity:** Attainable milestone, not elite-few.
4. **Cadence:** Weekly-ish, mixed sizes; most events modest, occasional large stream spectaculars.

---

## 1. Accepted As-Is

These enter v1.1 essentially as recommended.

**Pope-authoritative star topology for MVP synchronization.** The single most consequential ruling. David's client is the sole writer and source of truth; congregation clients are display terminals plus input devices; witnesses report, never rule. This is an order of magnitude less engineering than any distributed model, it *is* the "database does not outrank the Pope" principle expressed as architecture, and it defers every conflict-resolution problem to a phase that may never need to exist. The full Witness Network survives as long-term vision with witnesses as *reporters* feeding the authoritative store.

**Live Fight HUD as MVP-core.** Promoted into the MVP component list. Spectator legibility is a stated success criterion and forty bodies around a duel circle is visual mud without it. v1.1 contains its design direction; live-health feasibility on the TBC client is Appendix A's top validation item, with a defined graceful fallback (fight card without live health).

**Records Book replaces the ranked leaderboard.** A sorted ladder is a grind invitation that contradicts the recognition-over-grind principle; superlatives and stories are the same data with the opposite social incentive. Category list defined in v1.1 §10.9 — and note that David's "attainable milestone" ruling on Beef Lord makes the Records Book *more* important, because it becomes the primary scarcity layer above Lord (see §3 below).

**Flag Hot / Canonize Cold.** MARK THIS MOMENT is a live one-keystroke action (Pope, and eventually Council may flag); CANONIZE is a cold post-event act reserved to the Pope. Removes historical writing from performance time; preserves storytelling authority.

**The Decree.** One active event announcement, shown at login, nothing more. Accepted precisely because it solves two problems at once — the Cooked Beef → Knight attendance funnel and the quiet-mode emptiness — at near-zero build cost. Hard boundary written into v1.1: it is a proclamation, not a calendar. No RSVPs, no reminders, no recurring events in MVP.

**Sender/authority validation.** Theatrical UI renders only from registered Pope characters (addon-message sender identity is server-provided and non-spoofable — validation item, but the primitive is sound). Congregation-originated messages are console inputs only, never broadcast triggers. Player-typed free text (confessions, petition notes) renders only on the Pope's console; official theater renders only Pope-originated content.

**Event runtime state machine.** Full model now specified in v1.1 §20: states, Pope-owned transitions, late-join snapshot requests, reload recovery, Pope-disconnect degradation, protocol versioning with degrade-to-quiet for stale clients.

**Sound design.** Sparse ceremonial audio for sanction, verdict, elevation, knighting, canonization. Quiet Mode stays silent. Direction added to v1.1 §19.

**The Sacred Archive (data export/backup).** One-action export from the Pope console; a weekly archive ritual; restore path; cold-copy mirror to a designated Council member's client. The Church's history will not depend on one SavedVariables file.

**Manual override on every automated step.** Stated as a standing requirement, not an assumption. Software proposes; the Pope ratifies.

**Outcome vocabulary: Victory / Cowardice Recorded / Void / Pope's Ruling.** The duel-flee message becomes a first-class comedic ruling rather than a generic forfeit. Ambiguity resolution is designed to be *fast* — one tap to Void — because thirty confused seconds on stream is worse than a wrong call the Pope later corrects.

**Head-to-head histories surfaced at petition, sanction, and introduction.** The cheapest rivalry engine available; the Pope's voice does the rest.

**Petition hygiene.** Freshness/expiry, consequence-free dismissal, soft re-petition cooldown, presence-aware pool ("petitioning" means petitioning, present, and alive).

**Specific-opponent challenges.** A petition may name a desired opponent. The callout is the oldest dueling tradition there is and it manufactures rivalries and commentary material by itself.

**No ELO/MMR — ever.** Reaffirmed and moved to the permanent exclusion list alongside betting economies, fight analytics, and auto-generated commentary.

**The Pope's Notebook.** Private free-text notes on any member, one keystroke from the console. Tiny build, direct performer-bandwidth payoff. Added to MVP as core-adjacent (may slip one release without violating the definition of done, but it should not).

**Raid-marker and targeting assist.** Console click targets the current candidate/fighter; when the congregation is raid-grouped, auto-mark candidates and fighters. Diegetic, Classic-native stage management. API validation item.

**Dress-rehearsal release gate and the "one full Gathering" definition of done.** Adopted verbatim as the MVP acceptance test (v1.1 §22.3), including the deliberately imperfect rehearsal with late arrival, UI reload, disconnect, no-show petitioner, and disputed Gora.

**Quiet Mode contract.** In quiet state the add-on renders at most a minimap presence and the active Decree. Every future feature must declare its mode. This is the strongest standing anti-creep tool we have.

**Witness privacy: record events, not behavior.** No hours-online, no activity scores, no contribution leaderboards, member-visible records, and a per-member "curtain" opt-out for non-ritual witnessed activity (rank, Knighting, and sanctioned Gora results are public ritual by nature and are excepted). In-fiction framing retained: the Church sees all, but the humble may draw the curtain.

**Rite of Recognition for alt linking.** Human-confirmed linking, ritualized: the alt kneels, is acknowledged, and is bound to the player's Church identity. Converts an administrative task into content — the thesis applied to our own back office.

**Near-invisible onboarding.** First launch: one parchment welcome, then silence until the Church does something. No config walls, no tutorial popups.

**"The Pope is a busy streamer" as a console design constraint.** Glanceable at streaming distance, large targets, single-click operation, keybinds for the sacred actions, movable/collapsible so it never covers the ceremony it directs.

**Assembly support.** The Decree handles announcement; one "Summon the Faithful" broadcast pings installed clients with the gathering point. One button, no more.

**Post-ceremony summary export.** Copy-to-clipboard ceremony summary (Knighted: names; Goras: results) for Discord posting. Small enough to sit at the MVP boundary; classified stretch-MVP.

**Guild-rank ↔ Church-rank source of truth.** Guild rank is the public display; the Church store is the truth; the console reconciles drift and asks the Pope only when it cannot.

**Scope-filter additions.** The two new standing questions — "Quiet Mode or Event Mode?" and "Does this replace something a human currently performs that is part of the entertainment?" — are now filters 8 and 9.

---

## 2. Accepted With Modification

**Congregation favor with visible split.** Accepted — favor is pick-a-side only, with the split displayed as a simple bar on the fight HUD. *Modification:* the split is always visible to the Pope; whether it displays to the whole congregation defaults to ON but is a Pope toggle per event, because there are dramatic moments where the Pope may want to reveal the crowd's favor himself ("the congregation stands... SIXTY-FORTY AGAINST YOU"). Revealing information is performance material; the software should not always pre-empt the performer. No favor streaks, scores, or histories — the moment favor has a record, spectators optimize instead of cheering.

**"Formalize the tradition" red lines on automation.** All five accepted (mute fight cards, propose-don't-declare adjudication, no ceremony scripting, no auto-generated Chronicle prose, no queue auto-advance), with one clarification: the fight card may include a *written* record and title line, because static text on a card is a tale-of-the-tape, not commentary. The line we hold: the software never *narrates*. Anything with a verb happens in the Pope's voice.

**Ceremony-location enclosure guidance.** The peer review suggested playbook guidance for grief-resistant venues. Accepted as one paragraph of *lore-book* guidance, not software: outsider chaos at Goldshire is content, and the Pope narrating a heckler outperforms any mitigation feature. The fight HUD already keeps the stream legible when the scene isn't. No software features for disruption control.

**Non-competitive Knight recognition.** The review flagged that the design details the competitor's journey and leaves the majority underserved. Accepted as a named design responsibility with a deliberately *non-mechanical* answer in v1.1 §15: witnessed history makes quiet contribution visible; recognition of it stays human (Pope/Council); honorifics give it permanence. Explicitly rejected: any achievement system, service score, or automated recognition for this population — that is the artificial-progression trap wearing a kind face.

---

## 3. Overridden or Reshaped by David's Answers

**Beef Lord scarcity — peer review recommendation overridden.** The review recommended "elite few — guarded prestige." **David has ruled: attainable milestone.** Lord means *proven fighter*, not *top fighter* — most Knights who seriously compete should eventually earn it. This is now canon, and it is a defensible product choice: it maximizes arena participation and keeps the elevation moment frequent enough to be a weekly ceremony beat rather than a rare shock.

Design consequences propagated through v1.1: (a) the promotion norm is codified as *win a sanctioned Gora in a match the Pope judges fair; elevation performed by the Pope, normally same event* — discretion retained, default generous; (b) the **scarcity layer moves up**: with Lord attainable, the rare currencies become Records Book superlatives, defense counts and streaks, and Pope-granted named honorifics ("Duke of the Fountain") — these now carry the prestige weight the review wanted Lord to carry; (c) staging note: "Lords stand beside the Pope" must scale to many Lords — v1.1 frames them as an honor *formation* (the Lords' line) rather than a privileged few flanking him.

**Hardcore memorialization ("the Fallen") — deferred, not rejected.** The review treated HC memorials as near-obligatory *if* Hardcore is a target. David's answer places the Church's home on Anniversary TBC, with Hardcore appearing mainly in tournament formats. Ruling: the Fallen is **Important Later**, scoped to Hardcore tournament events (a dead HC tournament character's record is still a legend worth a page), and re-promoted to core if Classic+ materializes with death-relevant mechanics. The identity model in v1.1 keeps character records permanent regardless, so nothing is lost by waiting.

**Guild-bank tracking — peer review reversed on new facts.** The review classified guild-bank/tithe tracking "should probably not be built," reasoning from Classic Era, where no guild bank exists. The actual target is Anniversary TBC, which has real guild banks with transaction logs the client can query (validation item). Ruling: reclassified to **Important Later** — genuine API support exists and tithing is thematically rich — but it remains firmly non-MVP, and the standing prohibitions hold: no contribution score, no donation leaderboard. Recognition of tithes stays human and occasional (a canonized Great Tithe beats a donations table).

**"Rules of the Gora" — codified as pure discretion, per David.** The review asked for a one-page default house-rules section. David's answer — *no established norm; the Pope rules per match* — means we codify the discretion itself rather than inventing standards the community never had. v1.1 §10.3 therefore defines: no standing loadout restrictions ("come as you are" is the default reality); the Pope may attach **Stipulations** at sanction time (a short spoken ruling, optionally recorded on the fight card — stipulations are performance material, not a rules database); and a small set of default *procedural* norms that reflect practice (fight to duel end, interference → Void by default, flee → Cowardice Recorded, disconnect → Pope's ruling with rematch encouraged, rematches at Pope's pleasure, ±2 levels as guidance the Pope may waive theatrically). The ruleset *is* the Pope; the software just remembers what he ruled.

**Weekly cadence — reshapes the console's center of gravity.** The review warned the tooling must "scale down to a lazy Tuesday knighting." David's answer (weekly-ish, mixed sizes, mostly modest) makes that the *primary* case, not an edge case. v1.1 states it as a requirement: the console must make a six-person impromptu ceremony *cheaper than not using the add-on* — zero setup, no event configuration, the Pope just starts. The 40-person stream spectacular is the ceiling; the Tuesday knighting is the floor; the floor is where weekly retention lives.

---

## 4. Deferred

**Multi-witness corroboration hints** ("reported by 4 clients" on the console) — later phase of the Witness Network; meaningless under pure star topology.
**Blood Feud declarations** (Pope-declared official rivalries with auto-flagging Chronicle matches) — post-MVP; head-to-head surfacing covers MVP needs.
**Chronicle consumption surfaces** ("on this day," location callbacks) — post-MVP, but the v1.1 data model preserves timestamps and locations so these remain cheap to add.
**Discord one-way export beyond the clipboard summary** — post-MVP; no bots, no API integration until the core is proven.
**Cross-guild "heretic" challenge matches** — approved as a *manual experiment* (zero software) whenever David wants to try one; software support only if the manual version proves out.
**Tournament tooling** — unchanged from v1.0: deferred; hand-run tournaments already work.

---

## 5. Rejected

**Ranked ladder leaderboard** — rejected permanently (superseded by Records Book). Reason: a sorted ranking is a grind engine and a bitterness generator; it contradicts §3.6 of the founding vision.
**Elite-few Lord scarcity** — rejected by David's ruling (see §3); recorded here so the reasoning survives: the review's concern (title inflation) is real but is answered by moving prestige upward to honorifics and the Records Book rather than by gatekeeping Lord.
**Twitch chat integration (viewer voting/steering)** — rejected. The stream watches the Church; it does not steer it. Participation belongs to characters in the world.
**Generic ceremony builder** — remains blacklisted-until-proven-necessary. A ceremony engine is a machine for replacing improvisation; we will build a second bespoke workflow the day a second ceremony actually needs one, and judge a generic engine only after two bespoke workflows exist to generalize from.
**Any always-visible everyday panel** ("now playing," activity feeds) — rejected for MVP and viewed skeptically forever; violates the Quiet Mode contract.
**Automated eligibility/rules engine for Gora** — rejected; conflicts with the discretion ruling above.

---

## 6. Remaining Open Questions (carried into v1.1 Appendix B)

1. Distribution channel and update strategy (recommendation pending: dual-publish CurseForge + Wago from first public build).
2. Fight HUD live-health feasibility on the Anniversary TBC client (validation gate; fallback defined).
3. Records Book final category list — proposal in v1.1 §10.9 awaits David's veto/additions, ideally sanity-checked against what the community would actually brag about.
4. Curtain opt-out UX details (direction fixed; interaction design open).
5. Classic+ re-evaluation trigger: on any official announcement, revisit Appendix A assumptions before further platform-dependent work.
6. Whether Council members may post Decrees or only the Pope (v1.1 defaults to Pope + designated deputy; confirm against real logistics).

---

*Net result: of the peer review's material recommendations, the large majority enter v1.1 intact; two were overridden by David's answers (Lord scarcity, HC memorial priority); one was reversed on new platform facts (guild bank); and the review's most important architectural recommendation — the Pope-authoritative star — is adopted as the foundation of the MVP.*
