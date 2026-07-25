# Track 61 — Streamer mode, name hiding, privacy CVars

**Track id:** `61-streamer-mode-privacy`  
**Last updated:** 2026-07-25  
**Sole focus:** How Blizzard client privacy controls (Names / nameplate CVars, chat filters, ignore) and the third-party “streamer mode” ecosystem affect Church of Beef **guild-chat spectacle** and **ladder name display** for stream-facing guilds.  
**Maps to:** [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §1 (streamer-event product), §10 (throttled guild-chat promotion line), §13.11 (visible guild-chat reaction).

## Out of scope (deliberate)

| Covered elsewhere | Why not here |
|-------------------|--------------|
| [17-stream-overlay-readability](../17-stream-overlay-readability/) | Capture safe zones, contrast, toast duration, typography — **do not duplicate**. This track only overlaps on **CVar / privacy depth**. |
| [01-ux-patterns/nameplates.md](../01-ux-patterns/nameplates.md) | Combat plate engines (Plater etc.); Beef never mounts plates |
| [05-packaging-community-antipatterns](../05-packaging-community-antipatterns/) | Spam culture / quiet-mode product intent (this track verifies APIs) |
| [32-microcopy-tone-voice](../32-microcopy-tone-voice/) | Announce wording craft (this track covers *filter / privacy* failure modes) |
| [49-officer-notifications](../49-officer-notifications/) | Officer attention channels (whisper-self vs print) |
| Addon Lua / commits | Research only |

## Index

| Note | Covers |
|------|--------|
| [privacy-cvars-matrix.md](privacy-cvars-matrix.md) | Names, nameplates, chat, trade — CVars that change what a stream shows |
| [name-hiding-ecosystem.md](name-hiding-ecosystem.md) | No first-party Streamer Mode API; CurseForge StreamerMode / Classic obfuscators |
| [chat-filters-and-spectacle.md](chat-filters-and-spectacle.md) | `profanityFilter`, `spamFilter`, ignore list vs guild announce |
| [beef-stream-privacy-implications.md](beef-stream-privacy-implications.md) | **Implications for Beef** ladder + announce for stream guilds |
| [annotated-urls.md](annotated-urls.md) | Annotated primary URLs |

## Top insights for Beef (read this first)

1. **There is no confirmed Classic first-party “Streamer Mode” addon API.** Ecosystem privacy is (a) Interface → Names / nameplate CVars, (b) Social chat filters + ignore, (c) third-party name-obfuscation addons. Treat “streamer quiet” as an **addon SavedVariables preset**, not `RegisterForStreamerMode` ([track 05 caveat](../05-packaging-community-antipatterns/03-anti-patterns-and-complaints.md)).

2. **V1 spectacle is a plain guild-chat string that includes a character name** (spec §10). That string is broadcast server-side. Name-hiding addons only rewrite **local chat UI** for the streamer’s client — guildmates still see the real name; stream viewers see whatever the capture shows after local filters.

3. **Ladder UI is Beef’s own surface — privacy is ours to ship.** World nameplates and floating `UnitName*` toggles do not redact `/beef` rows. A stream-facing guild needs an explicit **Beef privacy / streamer preset** that masks display names in ladder/toasts without changing BeefNet identity (GUID / officer commit keys).

4. **`profanityFilter` (default on, account-scoped) can garble liturgy.** Mature-language filtering is a real CVar ([Wowpedia console variables](https://wowpedia.fandom.com/wiki/Console_variables); [AdvancedInterfaceOptions cvars.lua](https://github.com/Stanzilla/AdvancedInterfaceOptions/blob/master/cvars.lua)). Comedy announces and rank titles should be filter-smoke-tested; do not assume “Beef” comedy is safe.

5. **Ignore includes guild chat.** A member who ignored the approving officer **will not see** the promotion line ([Ignore](https://wowpedia.fandom.com/wiki/Ignore)). Spec §13.11 “visible reaction” can fail for that client even when the announce fired correctly — not a BeefNet bug.

6. **Boundary with track 17:** readability (size, contrast, dwell) ≠ privacy (who’s identifiable on stream). Ship both: quiet/redact preset here; capture budget there.

## Boundary map

```
Capture readability (safe zones, contrast, ms) ──► Track 17
Privacy CVars + name obfuscation + chat filters ──► THIS TRACK
Announce microcopy words                        ──► Track 32
Officer local pings                             ──► Track 49
Spam / quiet product culture                    ──► Track 05
```

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer warcraft.wiki.gg / wowpedia CVar lists, AdvancedInterfaceOptions source, CurseForge StreamerMode pages, and Blizzard Ignore docs over unrelated games’ “streamer mode” marketing.
