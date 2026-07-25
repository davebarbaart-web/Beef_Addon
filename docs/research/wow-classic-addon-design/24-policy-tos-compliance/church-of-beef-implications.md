# Church of Beef — policy & ToS implications

**Track:** `24-policy-tos-compliance`  
**Last updated:** 2026-07-25  
**Purpose:** Actionable compliance implications for Church of Beef only. Does not fork the design spec; flags confirmations and watch-items against [`2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md).

## Verdict

**V1 as specified is policy-aligned** if implementation stays faithful to §2 (no automation), §6.3 (officer anti-cheat), free distribution, no in-game ads/donation asks, and guild-scoped in-game sync. The main future risk is **wagering/monetization drift** around Gora and deferred stream-favor metaphors — not the rank ladder itself.

---

## Confirmations (spec already correct)

| Spec stance | Policy support |
|-------------|----------------|
| §2 No bots / no auto cast-move-target / no external control | [EULA](https://www.blizzard.com/en-us/legal/fba4d00f-c7e4-4883-b8b9-1b4500a402ea/blizzard-end-user-license-agreement) bots/cheats; [CoC](https://us.battle.net/support/en/article/42673) automation ban; [secure execution](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting) on Classic |
| §2 Fully in-game Lua/XML | Avoids client-modifying third-party software ([2025 blue post](https://us.forums.blizzard.com/en/wow/t/prohibitions-on-third-party-software/2142972)) |
| §6.3 Officer is the anti-cheat; standings advisory | Honest about SV editability; avoids fake “trusted server” that would tempt external tooling |
| §7 Human-entered Gora/ceremony; capped co-play drip | Social scoring, not combat automation |
| §13.10 No Retail-only APIs; no combat automation | Success criterion doubles as compliance criterion |
| Ranks are addon social layer, not WoW guild-rank replacement | Reduces “unfair advantage” confusion |

---

## Hard do / don’t for Church of Beef

### Do

- Distribute free, with readable Lua ([UI policy](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534) rules 1–2).
- Keep donation/support links on the **website / CurseForge page only** (rule 5).
- Require explicit officer clicks for `RANK_COMMIT` / official ladder changes.
- Throttle BeefNet and guild announces so you don’t “negatively impact” other players (rule 3; details in track 14).
- Keep Teen/T-rating-safe comedy tone (rule 6) while preserving brand absurdity.
- Treat Blizzard’s right to disable functionality as real (rule 8) — no fragile exploit-APIs.

### Don’t

- Ship premium / Patreon-gated Beef features or paid rank unlocks (rule 1 + RMT themes).
- Put ads, sponsor frames, or tip jars in `/beef` UI or automated chat (rules 4–5; EULA commercial ads).
- Add AHK/companion bots “to help farm standing.”
- Build a silent telemetry pipeline out of the client ([data-exfiltration note](data-exfiltration-forbidden-apis.md)).
- Productize betting, buy-ins, or odds on Gora/BG outcomes ([EULA wagering](https://www.blizzard.com/en-us/legal/fba4d00f-c7e4-4883-b8b9-1b4500a402ea/blizzard-end-user-license-agreement)).
- Bundle ripped Blizzard soundtrack files (music copyright note on [US sticky](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534)).

---

## Watch-items (not blockers for V1)

| Topic | Spec today | Policy watch |
|-------|------------|--------------|
| Audience favor / stream betting metaphors | Deferred §3.2 | Rename/frame as theater; no stakes; avoid “bet/odds/pot” product copy |
| Guild uses Beef rank for real loot rights | Not required by addon | Guild social contract issue; avoid scummy pay-for-rank culture |
| Public website ladder | Not in V1 | Prefer opt-in export; don’t make paid backend mandatory |
| WeakAuras-like combat assists | Out of scope (Beef is social) | Stay out of rotation-assistant territory entirely |
| Alt linking / account standing | Open decision §15 | Policy-neutral; still no RMT |

---

## Mapping research → product surfaces

| Surface | Compliance note |
|---------|-----------------|
| Rank ladder UI | Fine as social fiction; no paywall |
| Suggestion → officer approve | Best-practice trust model under client-side SV |
| Beef Gora | Record outcomes; no automation; no wagering engine |
| Ceremony | Officer-run; attendance credit OK |
| Instance co-play scoring | API observation + caps; never auto-clear content |
| BeefNet | Guild-scoped sync; not data brokerage |
| Minimap / `/beef` | No ad units |
| Stream overlay readability (track 17) | Visual only; don’t imply gambling UI |

---

## What this track deliberately does not decide

- Implementation APIs for roster timing (track 16)
- Message budgets and CTL (track 14)
- Packaging channel choice (track 05) — except: whatever channel, the **addon package** must remain free and ad-free inside the game
- Whether voluntary website donations are desirable — only that they must not appear in-game

If a future change would monetize access, automate play, export guild data off-client by default, or add betting, **update the design spec decisions log** after revisiting this track’s primary URLs (policies change; re-read before shipping).