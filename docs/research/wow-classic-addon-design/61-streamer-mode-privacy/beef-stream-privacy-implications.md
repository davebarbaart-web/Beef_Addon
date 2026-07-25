# Church of Beef — stream privacy implications

**Track:** [61-streamer-mode-privacy](README.md)  
**Last updated:** 2026-07-25  
**Product anchor:** Spec §1 (streamer-event guild addon), §10 (guild-chat promote line), §13.11 (visible reaction), SavedVariables UI prefs (profiles / streamer presets deferred in sibling tracks).

---

## The tension

Church of Beef’s V1 *product* needs **named people** on a ladder and in guild chat so the room can cheer. Stream-facing guilds also need **identity control** so a broadcast does not dox the streamer (or a shy member) to Twitch/YouTube. Blizzard CVars and StreamerMode addons only cover **default world/UI chrome** — not Beef’s frames and not the server-visible announce payload.

| Surface | Needs names for spectacle? | Privacy controllable by Beef? |
|---------|----------------------------|-------------------------------|
| Guild-chat announce (spec §10) | Yes (character name in string) | **Partial:** copy templates / officer opt-out; cannot redact other clients |
| Ladder UI `/beef` | Yes for recognition | **Yes:** display mask / streamer preset |
| Member toasts | Mild | **Yes:** shorter copy; mask self |
| Officer queue | Yes for officers | Prefer real names (moderation integrity) — mask only if officer opts in |
| BeefNet identity | N/A (GUID/revision) | Never mask in protocol |

---

## Recommended V1 stance

### Ship (addon settings — not Blizzard CVars)

1. **Streamer / privacy preset** (boolean or profile), account- or character-scoped UI pref:
   - Ladder rows: show **rank title + masked name** (e.g. `B***ina` or `Beef Knight #3`) or title-only for self
   - Toasts: prefer title / liturgy without full character name when preset on
   - Do **not** auto-disable guild announce globally (that kills §13.11 for the whole guild)

2. **Per-officer announce opt-out** (already in spec §10) — keep; document as the quiet switch for streamer-officers who do not want *their* client to shout.

3. **Optional announce template variant** (V1.1 ok if schedule slips):  
   - Default: “The Church recognizes **{Name}**, elevated to **{Title}**.”  
   - Stream-safe: “The Church elevates a faithful soul to **{Title}**.” / “**{Title}** has a new bearer among the flock.”  
   Officers pick template; guildmates still learn who via ladder + promotee toast.

4. **Ceremony night checklist** (ops text in `/beef help` or guild Discord pin — not auto-CVar):
   - Mature Language Filter off for broadcast host
   - Guild chat tab visible
   - Confirm StreamerMode (if installed) + Beef privacy preset both look right on a 30s test capture
   - Names panel: hide own name if desired ([privacy-cvars-matrix.md](privacy-cvars-matrix.md))

### Do not ship in V1

| Anti-feature | Why |
|--------------|-----|
| Auto-`SetCVar` on secure nameplates | Wrong layer; combat lockdown; fights Plater |
| Depend on `RegisterForStreamerMode` | Unconfirmed Classic API |
| Hide names from other players via magic | Impossible in Lua sandbox |
| Filter-bypass for profanity | Policy / parental conflict |
| Whisper the promotee as “private spectacle” | Stream leak + whisper UI; track 49 |

---

## Interaction with third-party StreamerMode

| Scenario | Expected |
|----------|----------|
| StreamerMode on, Beef privacy off | Chat/frames masked; **/beef ladder still shows real names** → streamer looks “leaky” when they open Church UI |
| Both on | Capture coherent; guildmates unaffected |
| StreamerMode on, Beef privacy on, announce uses real name | Twitch may show masked name **only if** StreamerMode rewrites that chat line; Discord/other guildies’ streams may still leak |

**Listing / onboarding copy:** one sentence under Streamer preset — “Does not replace StreamerMode; masks Church of Beef UI only.”

---

## Ladder display policy (detail)

| Row type | Privacy preset OFF | Privacy preset ON |
|----------|--------------------|-------------------|
| Self | Real name + title | Real title; name masked or “You” |
| Other members | Real name + title | Real title; name masked (default) **or** real names if “mask self only” sub-option |
| Officers viewing Officer tab | Real names | Real names (default) — moderation > stream cosmetics |
| Screenshots for CurseForge | Prefer privacy ON + fake data | Avoid shipping real Dreamscythe names in marketing |

Identity for sync remains GUID / officer-committed record keys. Masking is strictly `FontString` / list formatter level.

---

## Guild-chat announce vs stream sniping

Honest limits for streamer guilds:

1. **Announce always reveals a name to the guild.** Anyone in `/g` (or logging chat) can snitch to stream snipers. Privacy mode cannot fix social trust.
2. **Capture-side redact** only helps against *viewers of that stream*, not against other members’ clients.
3. For Hardcore / contested open-world streamers, prefer **stream-safe announce template** + ladder for recognition after the fact.

Church of Beef is a **spectacle** product first (spec §1). Default remains named announce; privacy is opt-in for hosts who need it.

---

## Mapping to sibling tracks

| Concern | Track |
|---------|-------|
| Toast size / contrast / dwell on 720p | [17](../17-stream-overlay-readability/) |
| Quiet defaults / anti-spam culture | [05](../05-packaging-community-antipatterns/) |
| Announce wording | [32](../32-microcopy-tone-voice/) |
| Officer local alerts | [49](../49-officer-notifications/) |
| Profiles / import for streamer alts | [11](../11-onboarding-settings-ux/), [21](../21-savedvariables-migration/) |
| This file | Privacy CVars + name display policy |

---

## Acceptance checks (research → product)

- [ ] Privacy preset masks ladder without breaking officer commit / sync
- [ ] Guild announce still optional/throttled; stream-safe template documented
- [ ] Help text mentions mature-language filter + StreamerMode coexistence
- [ ] No code path claims Blizzard Streamer Mode API
- [ ] §13.11 playtest counts reactions on **unfiltered** guild clients, not only the streamer’s capture
