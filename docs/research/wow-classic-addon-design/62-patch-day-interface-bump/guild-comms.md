# Guild communication on patch day

**Track:** [62-patch-day-interface-bump](README.md)  
**Last updated:** 2026-07-25

What Church of Beef maintainers / officers say in Discord (or guild chat) so the roster does not invent TOC edits or install into the wrong folder.

---

## 1. Principles

1. **One channel owner** — Night Lead or Tech Spotter ([track 51](../51-guild-night-playbook/facilitator-roles.md)); avoid three conflicting “update now” posts.
2. **Never ask members to hand-edit `## Interface`** — kills Out of Date as a diagnostic ([UI FAQ/AddOns](https://warcraft.wiki.gg/wiki/UI_FAQ/AddOns)).
3. **Separate “client Out of Date” from “addon broken.”** Load Outdated is OK while you smoke; broken means wait for a hotfix zip.
4. **Always name the client** — Anniversary AddOns folder / BCC Anniversary tab — wrong tree is the #1 false “Beef missing” report ([track 30](../30-anniversary-vs-era-deltas/)).

---

## 2. Message templates

### T−1d / maintenance night (pre-smoke)

```text
Anniversary maintenance tonight. Church of Beef may show Out of Date.
OK: Character Select → AddOns → Load Outdated AddOns (temporary).
NOT OK: editing .toc files yourself.
Wait for an officer ping before guild night scoring / Officer approvals.
Install path remains: World of Warcraft/_anniversary_/Interface/AddOns/ChurchOfBeef
```

### After TOC-only smoke (green)

```text
Church of Beef update: Interface NNNNN (Anniversary patch X.Y.Z).
TOC bump only — no feature change. Update via [Discord zip / CF / WowUp].
After update you can turn Load Outdated off if you enabled it.
If BugSack shows Church of Beef errors, post a screenshot and stay on Load Outdated until we say otherwise.
```

### After code hotfix (required)

```text
Church of Beef update REQUIRED for tonight.
Old builds may error or mis-sync after the patch. Install version X.Y.Z (Interface NNNNN) before Officer approvals.
Officers: smoke Approve once with a member online before the first dungeon.
```

### Still investigating

```text
Still verifying Church of Beef on the new Anniversary build.
Load Outdated is fine for play. Pause Officer promotions / trust ladder sync until the all-clear.
Do not hand-edit TOC. Ping Tech Spotter with BugSack if you see errors.
```

---

## 3. Who needs which message

| Audience | Care about |
|----------|------------|
| **Officers** | Approve path, BeefNet, whether to pause promotions |
| **Members** | “Update or Load Outdated,” install folder, ignore grey Out of Date if officer said OK |
| **Stream / recruits** | Same as members + “not a combat addon” if they panic at AddOns list |

Spectacle announce opt-out is unrelated to Interface — do not mix “turn off promote chat” into patch messages ([spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

---

## 4. Changelog / listing one-liner

When a public or Discord file drops, lead with Interface (players skim for that first — [track 31](../31-listing-copy-discovery/changelog-culture.md)):

```markdown
## X.Y.Z
### Changed
- TOC Interface → NNNNN for current Anniversary patch
```

Add a **Fixed** section only if this was a code hotfix.

---

## 5. Post-comms hygiene (T+24h)

- [ ] Confirm at least one officer + one member updated (or confirmed Load Outdated + green smoke).
- [ ] If CF/Wago used: Supported Version matches the patch ([curseforge-unsupported.md](curseforge-unsupported.md)).
- [ ] Pin or delete the “investigating” message so it does not outlive the all-clear.
