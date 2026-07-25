# Multi-TOC / multi-flavor packaging strategy for Beef

**Last updated:** 2026-07-25  
**Scope:** When Church of Beef should use one TOC vs many — product strategy only.  
**Not a TOC encyclopedia:** suffix tables and directive lists live in [TOC format](https://warcraft.wiki.gg/wiki/TOC_format) and track [04-toc-api-performance/](../04-toc-api-performance/).

---

## 1. V1 recommendation (locked product)

Ship **one** file:

```
ChurchOfBeef/ChurchOfBeef.toc
```

With:

- `## Interface: 20506` (verify live on Anniversary)
- `## Title` / `## Notes` that mark it as TBC Classic Anniversary / guild social tool
- `## SavedVariablesPerCharacter: ChurchOfBeefDB`
- File list for Anniversary-only code

**Install target:** `_anniversary_/Interface/AddOns/ChurchOfBeef`

Rationale:

- Spec locks Anniversary for V1; Classic+ is a later port (§12, §15).
- Single Interface avoids accidental Era loads from a too-broad `_Classic.toc`.
- Guild support scripts stay one-path.

---

## 2. What *not* to do in V1

| Anti-pattern | Why |
|--------------|-----|
| Only `ChurchOfBeef_Classic.toc` | After Anniversary 2.5.5 / similar Classic patches, `_Classic` loads on **all** Classic clients ([TOC format patch notes](https://warcraft.wiki.gg/wiki/TOC_format)) — wider than V1 support promises |
| Only `ChurchOfBeef_Vanilla.toc` | Era-line; misses Anniversary (`tbc`) |
| Legacy `ChurchOfBeef-BCC.toc` | `-BCC` no longer supported on Anniversary 2.5.5+ ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format)) |
| Comma-Interface including `11509` without Era QA | Marks “supported” on Era while instance scoring / messaging may be untested |
| Retail Interface in the same TOC | Violates hard rule; confuses managers |

---

## 3. Escalation paths (post-V1)

When intentionally expanding flavors, prefer wiki order of operations: **comma Interfaces + AllowLoadGameType file lines**, then per-suffix TOCs if load lists diverge heavily ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format)).

### Phase A — Anniversary + Era (hypothetical)

Only if product explicitly adds Era:

1. Raise packaging to declare both Interfaces (e.g. `20506, 11509` — numbers verified live).
2. Split **instance / zone tables** behind `[AllowLoadGameType tbc]` vs `vanilla` (or `[Game]\…` expansion).
3. Keep Core ladder / BeefNet / officer gate shared.
4. Document **two** install roots in README (`_anniversary_` and `_classic_era_`).
5. Consider schema version in `ChurchOfBeefDB` so copied WTF between trees does not silently corrupt.

Optional: add `ChurchOfBeef_TBC.toc` + `ChurchOfBeef_Vanilla.toc` if file lists diverge enough that one TOC becomes unreadable — both suffixes are the correct game-type gates (Anniversary uses `_TBC`).

### Phase B — Classic+ (spec V4)

Isolate the same three seams as spec §12:

1. TOC / Interface / game type  
2. Instance detection  
3. Addon messaging if APIs diverge  

Do not fork rank canon or `/beef` IA.

### Phase C — Cata/MoP “for free”

Not a product goal. If someone loads a multi-Interface build on Cata/MoP, treat breakage as unsupported unless QA is funded. Wide `_Classic.toc` alone is not a support strategy.

---

## 4. CurseForge / WowUp packaging notes

- Publish under **Classic TBC / BCC Anniversary** flavor tags when the project goes public (community managers look for BCC Anniversary tabs — [Sportskeeda](https://www.sportskeeda.com/mmo/best-wow-tbc-anniversary-addons-set)).
- Filename/version strings should include Anniversary or `2.5.x` so players do not install an Era fork by mistake.
- Cousin pattern: separate files per flavor when data differs (e.g. Attune Era vs BCC zips on [Wago Attune versions](https://addons.wago.io/addons/attune/versions)) — Beef should only split when **code or data** actually diverges.

---

## 5. Decision table

| Goal | Packaging |
|------|-----------|
| V1 guild nights on Anniversary | Single `ChurchOfBeef.toc` + `20506` |
| Dual-ship Era later | Comma Interfaces + game-type-gated instance modules; dual install docs |
| Classic+ later | New Interface + isolated seams; keep canon/UI IA |
| Accidental all-Classic load | Avoid sole `_Classic.toc` |

---

## Sources

- [TOC format — client-specific TOC / AllowLoadGameType / patch changes](https://warcraft.wiki.gg/wiki/TOC_format)
- Design spec §5, §12, §14–§15
- [Sportskeeda — BCC Anniversary CurseForge](https://www.sportskeeda.com/mmo/best-wow-tbc-anniversary-addons-set)
