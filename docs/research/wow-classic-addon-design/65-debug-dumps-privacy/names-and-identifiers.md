# Names, identifiers, and stream-safe redaction

**Track:** [65-debug-dumps-privacy](README.md)  
**Last updated:** 2026-07-25  
**Purpose:** How character names and related identifiers should appear (or not) in Beef diagnostics and public bug reports.

---

## 1. What addons can see (Classic)

| Identifier | Typical API | Publicness in-world | Paste risk |
|------------|-------------|---------------------|------------|
| Character name | `UnitName("player")` / roster APIs | Visible in guild/raid | Medium — fine for reporter; care for third parties |
| Realm | `GetRealmName` / name-realm pairs | Often visible | Medium |
| Guild rank title | Roster APIs | Guild-visible | Low–medium |
| Standing / Beef title | Addon SV / BeefNet | Addon users + officers | Medium if full ladder pasted |
| BattleTag / Real ID | **Not** available to normal addons | Blizzard social | **Do not invent or scrape** |
| WTF account folder id | Filesystem only | Hidden from Lua | High if players paste paths ([forum archive](https://www.wowinterface.com/forums/archive/index.php/t-48899.html)) |
| GUID | Unit GUID APIs where present | Technical | Prefer avoid in public pastes |

`/dump UnitName("player")` is a common author ask ([UnitName docs](https://wowpedia.fandom.com/wiki/API_UnitName)) — that discloses **the reporter**, which is usually intended.

---

## 2. Audience ladder (same string, different harm)

| Audience | Character names OK? | Guidance |
|----------|---------------------|----------|
| Local chat frame (reporter only) | Yes | Default debug print |
| Private officer Discord | Yes, minimize | Prefer “PlayerX → Cooked” only when needed |
| Private DM to maintainer | Yes | Still avoid full roster |
| Public Discord #general | Redact others | Reporter name optional |
| Public GitHub Issues | Redact others | Replace with `PlayerA` / role labels |
| Livestream / VOD | Stream-safe defaults | No surprise alt dumps or officer-note UI ([05](../05-packaging-community-antipatterns/05-implications-for-church-of-beef.md)) |

Church of Beef is explicitly a **streamer-event** adjacent product (spec §1 / §3.3). Diagnostics that print a wall of guild names into chat can appear on stream even when “only debugging.”

---

## 3. Redaction patterns (support copy)

Use when filing public issues:

1. Keep **reporter** name if it aids repro (“errors when Beefina opens Officer tab”).
2. Replace other names with roles: `Officer1`, `MemberFresh`, `OfflinePeer`.
3. Prefer **counts**: `pendingSuggestions=3` over listing three names.
4. Strip realm suffixes unless the bug is realm-specific.
5. Never paste Battle.net email, phone, or Discord snowflake “for verification.”
6. If a BugSack stack embeds a name inside the error string (e.g. `format("%s standing nil", name)`), edit that substring before public paste — stacks are not sacred.

---

## 4. What Beef should store vs display

Aligned with track 24 minimize + track 21 per-character doctrine:

| Data | Store in SV? | Show in default UI? | Include in default debug dump? |
|------|--------------|---------------------|--------------------------------|
| Self standing / title | Yes | Yes | Yes |
| Cached peer titles for ladder | Yes (bounded) | Ladder UI | Counts + optional self only |
| Full roster dump | No (beyond what ladder needs) | No | **No** |
| Officer free-text notes | Avoid in V1 | Officer-only if ever | **No** |
| Whisper / chat lines | **No** | No | **No** |
| Alt→main mapping | Deferred (§16) | N/A | N/A |

Per-character SV already limits accidental account-wide alt dossiers ([21](../21-savedvariables-migration/account-vs-character.md)); dumps must not undo that by printing every character the cache has ever seen.

---

## 5. Error messages that leak names

Lua errors often stringify arguments. If Beef code does `error("bad standing for "..name)` or includes roster keys in `assert` messages, every BugSack paste becomes a name leak.

**Author hygiene (policy, not code here):**

- Prefer opaque ids / GUID suffixes in error strings when a name isn’t required.
- Prefer `error("COB: standing nil")` + debug dump fields over interpolating roster rows.
- Never put whisper text into an error or print.

---

## 6. Implications for Church of Beef

1. Default dump = **aggregates + self**, not guild phonebook.
2. Public bug template (future): “Redact other players’ names.”
3. Stream/spectacle path stays opt-in announce ([spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)); debug path stays quieter than spectacle.
4. Do not teach players to screenshot WTF folder trees (account ids).
