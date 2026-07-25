# First-run Experience and Defaults

**Last updated:** 2026-07-25

---

## 1. Two onboarding philosophies

Contemporary Classic addons cluster into two first-run strategies:

| Pattern | When it fits | Exemplars |
|---------|--------------|-----------|
| **Wizard / installer** | Wrong defaults make the addon useless or noisy; one decision (class, layout, expansion DB) unlocks correct behavior | ElvUI install flow ([Tukui changelog notes installer layout apply](https://tukui.org/elvui)); Questie short setup on first login ([NoobToBoss Questie guide](https://noobtoboss.com/addon/questie/)) |
| **Zero-config** | Defaults are safe; value appears without opening options | Combat helpers that “just work,” empty meters/lists, silent alert addons ([deep research synthesis](.raw/onboarding-settings-ux-deep.md)) |

**Rule of thumb:** interrupt the player only when a wrong guess is expensive. Otherwise ship working defaults and teach via empty states + slash/minimap discoverability.

---

## 2. Wizard pattern (detail)

### ElvUI-class installer

Community setup guides treat ElvUI’s first-run installer as the recommended path over hand-tuning hundreds of knobs: CVars, chat, role layout, auras, bars, nameplates, skins — then refine later with `/ec` ([Omekinteractive ElvUI setup guide](https://omekinteractive.com/elvui-setup-guide/) via search corpus; installer existence also reflected in [Tukui ElvUI changelogs](https://tukui.org/elvui) mentioning “Installer layout buttons” and “Setup Chat”).

**Stealable idea:** ask for *role / mode*, apply a named preset, exit. Do not expose the full options tree on day one.

### Questie setup

Authoritative Questie docs emphasize minimap + `/questie` for configuration ([Questie README](https://github.com/Questie/Questie)). Secondary Classic guides state Questie runs a short setup wizard on first login, then uses the minimap icon for ongoing settings ([NoobToBoss](https://noobtoboss.com/addon/questie/)).

**Stealable idea:** wizard only for *client-flavor / content DB* decisions that cannot be inferred safely — not for every toggle.

---

## 3. Zero-config pattern (detail)

| Approach | Behavior | Why it works |
|----------|----------|--------------|
| **Aggressive defaults** | Useful features on immediately | Player feels value before they find options (*ecosystem observation:* DBM-style boss mods) |
| **Empty but honest UI** | Show the product surface empty with a clear next action | WeakAuras-style empty list + import/new; no fake demo data |
| **Silent until needed** | No chrome until an event fires | Alert addons that refuse configuration theater |

AceDB formalizes defaults as a table passed to `AceDB-3.0:New(svName, defaults)` so first run inherits sensible values without a wizard ([AceDB-3.0 Tutorial](https://www.wowace.com/projects/ace3/pages/ace-db-3-0-tutorial); [Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started)).

---

## 4. Defaults hygiene (Ace mental model, usable without Ace)

From [AceDB Tutorial](https://www.wowace.com/projects/ace3/pages/ace-db-3-0-tutorial):

- Put defaults in a structure that mirrors the live DB (`profile`, `char`, `global`, …).
- Smart defaults: `['*']` / `['**']` for “every module starts enabled/disabled the same way.”
- Init DB only after SavedVariables load (`OnInitialize` / `ADDON_LOADED`) — never in the main chunk.

**Church of Beef V1 already matches the spirit:** Fresh Beef standing 0, scoring paused outside guild, Officer tab hidden for non-officers ([design spec §4, §11](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

---

## 5. Church of Beef relevance

| Decision | Recommendation |
|----------|----------------|
| First-run wizard? | **No full installer in V1.** Zero-config social surface: open ladder, show empty/not-in-guild state, toast when first points land. |
| Optional soft onboarding | One **dismissible** chat line or footer tip: “`/beef` opens the Church · Officers approve ranks.” Flag `db.firstRunDone`. |
| When a wizard *would* be justified | Later: streamer vs quiet prefs, or guild-specific officer rank-index threshold — only if wrong default causes real pain. |
| Defaults to protect | Announcements on (spectacle is the product); toast density moderate; minimap shown; frame created so `/beef` never “does nothing” (spec §10 failure mode). |

---

## Sources

- [AceDB-3.0 Tutorial — WowAce](https://www.wowace.com/projects/ace3/pages/ace-db-3-0-tutorial)
- [Ace3 Getting Started — WowAce](https://www.wowace.com/projects/ace3/pages/getting-started)
- [Questie README — GitHub](https://github.com/Questie/Questie)
- [Questie guide — NoobToBoss](https://noobtoboss.com/addon/questie/)
- [ElvUI — Tukui](https://tukui.org/elvui)
- [Design spec §4, §9–§11](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)
- Deep research: [`.raw/onboarding-settings-ux-deep.md`](.raw/onboarding-settings-ux-deep.md)
