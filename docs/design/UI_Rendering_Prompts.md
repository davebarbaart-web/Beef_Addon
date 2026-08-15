# Church of Beef — UI Concept Rendering Prompts
## Handoff Pack for GPT Image Generation

**Purpose:** Generate concept renderings to guide the addon's UI art direction, consistent with Design Bible v1.1.1 §19 (visual direction, hybrid visual law) and §10 (Gora presentation surfaces).
**Consumer:** GPT image model, prompted by David.
**Status:** Direction-setting concept art. These renders inform the theatrical asset work in Reformation Phase 4; they are not implementation specs.

---

## How to Use This Pack (read before generating)

**What the renders are for.** Mood, materials, composition, and theatrical weight — how a proclamation should *feel*, how a fight card sits over gameplay, how much screen the theater is allowed to take. The interaction design, information architecture, and exact contents of every surface are already specified in the Design Bible; do not let a pretty render renegotiate them.

**What to expect from the model.** Image models garble text. Every render will misspell something — that is fine and irrelevant. Judge renders on atmosphere, materials, hierarchy, and silhouette, never on the words. The prompts deliberately use short all-caps labels because they survive generation best. Any render whose *layout* you love can be re-specified with correct text by human/agent hands later.

**Workflow.** For each prompt: generate 3–4 variants, pick by gut ("does this look like an ancient institution taking Beef seriously?"), discard anything that reads as meme, neon, mobile-game, or modern-flat. Save keepers to `docs/design/renders/` in the repo with the prompt number in the filename, so the Phase 4 theater squad inherits both the image and the prompt that made it.

**The one-sentence test for every render:** *Would a medieval cathedral's document look like this if the cathedral had electricity and worshipped beef — and absolutely no sense that anything about that is unusual?* Solemn, never winking. The UI does not tell jokes; it is the straight man.

---

## Master Style Block

Paste this at the top of every prompt below.

> Concept art for a World of Warcraft Classic addon UI, Burning Crusade era aesthetic. Visual language: an ancient ecclesiastical institution — dark iron, charcoal, aged parchment, muted antique gold, deep oxblood accents. Gothic blackletter display typography for titles, weathered serif for body text. Ornamentation: hammered metal borders, wax seals, illuminated-manuscript flourishes, candle-lit warmth, subtle vignette. Fully compatible with WoW's classic UI style — chunky beveled frames, fantasy materiality, no modern flat design, no glassmorphism, no neon, no sci-fi. The tone is absolute institutional seriousness: this is the official liturgical stationery of a church, rendered with total dignity. The subject matter is beef, and the design must never acknowledge that this is funny. High detail, clean game-UI mockup presentation, 16:9.

---

## The Prompts

### R1 — The Sanction Proclamation (the signature theatrical moment)

*[Master Style Block]* + 

> A full-screen ceremonial proclamation overlay appearing over darkened World of Warcraft gameplay (a crowd of fantasy characters forming a circle in a grassy field at dusk, softly blurred behind the UI). Centered: a grand aged-parchment proclamation panel with hammered dark-iron corner fittings and a large red wax seal at the bottom bearing a bull's-head sigil. Blackletter headline reads "A BEEF GORA IS SANCTIONED". Below, two small heraldic name-plates face each other with a gothic "VS" between them. Gold-leaf line ornaments. The panel occupies the center third of the screen, dramatic but not covering the crowd entirely. Candle-glow lighting on the parchment edges, as if the document itself is the light source. Solemn, liturgical, momentous.

### R2 — The Fight HUD (spectator legibility over live combat)

*[Master Style Block]* +

> A compact combat spectator HUD docked top-center over bright, fully-visible World of Warcraft duel gameplay (two fantasy characters fighting inside a ring of onlookers — the gameplay is the hero, the HUD is small). The HUD: a single horizontal dark-iron-and-parchment bar, two fighter panels facing each other. Each panel: a small illuminated-portrait frame, a name in weathered serif, a class-colored health bar styled like a strip of stained glass set in iron, and a tiny record notation "6–2". Between them, a small wax-sealed centerpiece and a thin horizontal "crowd favor" gauge — a two-tone gold/oxblood split bar like a balance scale. The whole HUD takes no more than 12% of screen height. Readable at a glance from streaming distance. Ecclesiastical sports-broadcast: as if a cathedral produced a boxing match.

### R3 — The Fighter Card (tale of the tape)

*[Master Style Block]* +

> A fighter presentation card, portrait orientation, displayed at the side of WoW gameplay. Design: an illuminated-manuscript page in a dark-iron frame — a heraldic banner top with blackletter fighter name "CHUCKROAST", a painted portrait medallion of an armored warrior, then a dignified stat ledger in weathered serif: "WARRIOR · LEVEL 47", "BEEF KNIGHT", "RECORD 6–2", "DEFENSES III". At the bottom, a small historical annotation line in italic script with a tiny crossed-swords ornament: "THIRD MEETING · ONE VICTORY EACH". A modest wax seal in the lower corner. The card should feel like the official church dossier of a holy gladiator — reverent, archival, slightly worn.

### R4 — The Verdict: COWARDICE RECORDED

*[Master Style Block]* +

> A verdict stamp moment: over dimmed gameplay, a heavy parchment verdict panel is being struck by an enormous dark-iron seal stamp, mid-impact, with a ring of displaced dust and a deep red wax impression forming the words "COWARDICE RECORDED" in blackletter, encircled by a formal Latin-style motto ring and a small fleeing-figure sigil. The composition conveys institutional finality — a court record being made for eternity — with zero comedy in the rendering itself. Gold flourish border, candle-lit, absolutely solemn. Small subtitle line in serif: "SO RULED BY THE BEEF POPE".

### R5 — The Decree (Quiet Mode's one theatrical object)

*[Master Style Block]* +

> A modest login announcement banner, positioned upper-center over a calm WoW city scene, small and unobtrusive — roughly the size of a quest tracker. A single piece of aged parchment pinned by one iron nail, slightly curled at the corners, with a small wax seal. Blackletter header "A GATHERING IS DECREED", two serif lines beneath: "GOLDSHIRE INN" and "SUNDAY · SEVEN O'CLOCK". One thin gold rule ornament. It should feel like a notice nailed to a church door — quiet, dignified, easy to ignore, impossible to mistake for anything else in the game. The rest of the screen is untouched gameplay.

### R6 — The Records Book (superlatives, not a leaderboard)

*[Master Style Block]* +

> A two-page open tome interface — a massive leather-and-iron bound church register lying open, filling most of the frame. Left page: an illuminated chapter heading "THE RECORDS OF THE GORA" with a large decorated initial capital, then entries styled as manuscript honors, each with a small painted medallion portrait and a title in blackletter: "MOST SANCTIONED VICTORIES", "THE IRON CHIN", "THE GLORIOUS MARTYR". Right page: a "GREATEST RIVALRY" spread — two facing portrait medallions joined by crossed swords with a tally "III – III" between them, annotated in italic script like a historical chronicle. Gold leaf, red rubrication, candle-light. Crucially: this must read as a book of legends and honors, NOT a ranked list or table — no columns of numbers, no ranking.

### R7 — The Knighting Proclamation

*[Master Style Block]* +

> A ceremonial announcement overlay over gameplay showing a fantasy character kneeling before a robed figure amid a crowd (gameplay softly visible, slightly darkened). The overlay: a horizontal parchment banner across the upper third, iron-clad edges, blackletter proclamation "RISE, BEEF KNIGHT" with the new knight's name beneath in serif, flanked by two small heraldic bull sigils and a pressed gold seal. Rays of warm light rendered as engraved sunburst linework behind the banner — glory depicted with the restraint of a woodcut, not a video-game particle effect. The kneeling character in the gameplay remains the visual center; the banner crowns the moment rather than replacing it.

### R8 — The Beef Pope Director Console (functional surface — layout study only)

*[Master Style Block, then note the override below]* +

> IMPORTANT OVERRIDE: this surface is deliberately plain. A pragmatic control panel in the style of standard World of Warcraft Classic addon windows — stock beveled gray-brown frame, standard fonts, functional lists — with only the faintest ecclesiastical touches (a small seal icon in the title bar, parchment-tinted list rows). Composition: a compact movable window titled "DIRECTOR CONSOLE" with three visible panels: a "PRESENT" roster list with small rank icons; a "KNIGHTING QUEUE" with one highlighted next candidate; a "GORA DESK" showing two petitioner rows and one very large, obviously-pressable iron button reading "SANCTION". Everything is big-target, high-contrast, glanceable — designed for a busy streamer with one hand on the mouse. The contrast between this plain backstage tool and the ornate public theater IS the design statement. Show it small in the corner of a gameplay screen to convey scale.

### R9 — Full Event-Mode Composition (the stream frame)

*[Master Style Block]* +

> A complete stream-ready screenshot composition: a World of Warcraft duel in progress at the center of a large circle of 30–40 assembled fantasy characters at night, torchlight; the top-center compact fight HUD from a cathedral-of-boxing aesthetic (two portraits, stained-glass health bars, favor split gauge); a small verdict-seal notification just fading in the upper right; the plain director console window minimized in the lower left corner; the game world occupying at least 80% of the frame. This render's purpose is to prove the golden rule: the WORLD is the show and the UI is the liturgy around it — theatrical elements frame the gameplay, never bury it. Legible to a first-time Twitch viewer at a glance.

### R10 — Iconography & Seal Sheet (asset direction)

*[Master Style Block]* +

> A reference sheet on aged parchment presenting a family of small game-UI icons and seals, arranged in a labeled grid, all in a consistent engraved-metal-and-wax style: a bull's-head papal seal; a crossed-swords Gora sigil; a kneeling-knight sigil; a fleeing-coward sigil; a cleaver sigil (the Raiding Team); a council-ring sigil; a small book-and-quill chronicle mark; a bell; a minimap button roundel with the bull's head in dark iron. Each icon rendered at two sizes (large detail, small 32px-style simplified). Muted gold, oxblood, charcoal palette. Style consistency across the set matters more than detail in any single icon.

---

## Guardrails (append to any prompt that drifts)

Negative direction, phrased for the image model: *no neon, no modern flat/minimal UI, no glassmorphism, no sci-fi HUD elements, no mobile-game buttons, no comic-sans-style or "wacky" fonts, no cartoon meat with faces, no winking humor, no clutter, no watermark text, UI never covers the center of the gameplay action.*

And the standing reminders for the human picking winners:

- **The institution never knows it's funny.** If a render is visually joking (googly-eyed cows, comic fonts), kill it — the comedy budget lives entirely in the contrast between dignity and subject matter.
- **Quiet Mode surfaces (R5) must look ignorable.** If the Decree render dominates the screen, it's wrong even if beautiful.
- **The console (R8) must look boring next to the theater.** If R8 comes out ornate, regenerate — its plainness is a design decision, not a budget cut.
- **Gameplay is the hero in every in-context render.** Any composition where the UI upstages the game world contradicts Bible §1 and gets discarded no matter how good it looks.

## What NOT to Ask the Image Model

Do not prompt it for: information architecture, interaction flows, exact data fields, font licensing choices, or anything the Bible already specifies — renders that "redesign" the petition flow or add betting odds panels are noise. It is a mood engine. The Bible is the spec.
