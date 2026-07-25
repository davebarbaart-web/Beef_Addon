[![promotional banner](https://media.forgecdn.net/banners-image-urls/banners-image-url_87348f68-3700-493e-860b-27ca0f2510b0.webp)![mobile promotional banner](https://media.forgecdn.net/banners-image-urls/banners-image-url_5470a2ea-c09b-44b9-b9d9-108c8f9083cc.webp)](https://links.curseforge.com/mc_modjam_2026_top)

[![Immersion and Dialogue UI Bridge logo](https://media.forgecdn.net/avatars/thumbnails/1623/323/64/64/639043269302753602.png)](https://www.curseforge.com/wow/addons/immersion-and-dialogue-ui-bridge#project-logo)

# Immersion and Dialogue UI Bridge

- By
[![Brostafa](https://lh3.googleusercontent.com/a/ACg8ocIJD6EdgFhWdTSe6tD8hnsRBPVXvGzUnsGhd1CQ9VDgk8KkmND2=s96-c)Brostafa](https://www.curseforge.com/members/brostafa)


A bridge addon for World of Warcraft TBC Anniversary edition that combines the best features of Immersion and DialogueUI addons

Download

- [Description](https://www.curseforge.com/wow/addons/immersion-and-dialogue-ui-bridge)
- [Comments](https://www.curseforge.com/wow/addons/immersion-and-dialogue-ui-bridge/comments)
- [Files](https://www.curseforge.com/wow/addons/immersion-and-dialogue-ui-bridge/files?page=1&pageSize=20&showAlphaFiles=hide)
- [Gallery (3)](https://www.curseforge.com/wow/addons/immersion-and-dialogue-ui-bridge/gallery)
- [Relations](https://www.curseforge.com/wow/addons/immersion-and-dialogue-ui-bridge/relations/dependencies)

# ImmersionBridge

A bridge addon for World of Warcraft Classic TBC Anniversary edition that combines the best features of: **Immersion** and **DialogueUI** addons

## Description

ImmersionBridge seamlessly integrates Immersion's animated 3D NPC portrait system with DialogueUI's elegant quest scroll presentation. The animated portrait appears in the top-left corner of DialogueUI's quest frame, with all quest text and options displayed below it, creating an immersive and visually appealing questing experience.

## Features

- **Animated 3D Portraits**: Displays animated 3D models of NPCs during quest interactions, borrowed from Immersion
- **Quest Scroll UI**: Uses DialogueUI's beautiful parchment-style quest presentation
- **Smart Integration**: Portrait is positioned as an overlay in the top-left corner of the quest frame
- **Text Padding**: Automatically adjusts scroll content to prevent text from being covered by the portrait
- **Event Support**: Works with gossip, quest details, quest progress, quest completion, and quest greeting events
- **UI Independence**: Portrait remains visible even when DialogueUI's "HideUI" setting is enabled

## Requirements

- **World of Warcraft Classic TBC Anniversary Edition** (Interface version 20505)
- **Immersion** addon (must be installed and enabled)
- **DialogueUI** addon (must be installed and enabled)

## Installation

1. Download or clone this addon to your World of Warcraft `Interface/AddOns/` directory
2. Ensure both **Immersion** and **DialogueUI** are installed and enabled
3. Restart World of Warcraft or type `/reload` in-game
4. The addon will automatically initialize when both dependencies are loaded

The addon folder structure should look like:

```
Interface/AddOns/
  ├── Immersion/
  ├── DialogueUI/
  └── ImmersionBridge/
      ├── ImmersionBridge.toc
      ├── ImmersionBridge.lua
      ├── PortraitFrame.xml
      └── README.md
```

## Usage

Once installed, ImmersionBridge works automatically. Simply interact with NPCs as you normally would:

- Talk to quest givers
- Accept quests
- Turn in quests
- Browse gossip options

The animated portrait will appear automatically in the top-left corner of DialogueUI's quest frame.

## Commands

- `/ib show` \- Manually show the portrait
- `/ib hide` \- Manually hide the portrait
- `/ib test` \- Test the portrait with your player model
- `/ib status` \- Display addon status and dependency information

## How It Works

ImmersionBridge:

1. **Disables Immersion's UI**: Prevents Immersion's quest frame from showing, using only its portrait system
2. **Hooks into DialogueUI**: Monitors when DialogueUI's quest frame is shown/hidden
3. **Displays Portrait**: Shows the animated 3D NPC portrait in the top-left corner of DialogueUI's frame
4. **Adjusts Layout**: Automatically adds padding to push quest text below the portrait
5. **Maintains Visibility**: Ensures the portrait remains visible even when DialogueUI's HideUI setting is active

## Technical Details

- The portrait frame uses `ignoreParentAlpha` to remain visible when DialogueUI's HideUI is enabled
- Portrait positioning is handled via frame parenting and anchoring to `DUIQuestFrame`
- Scroll content padding is applied by offsetting DialogueUI's `ContentFrame` position
- The addon uses Immersion's `ModelMixin` for NPC model animations and lip-sync

## Author

**Brostafa**

## License

This addon is provided as-is. It integrates functionality from Immersion and DialogueUI but does not modify their core files.

## Credits

- **Immersion** \- For the animated portrait system and model animation code
- **DialogueUI** \- For the beautiful quest scroll presentation

## Version

1.0.0

## Support

For issues or questions, please check that both Immersion and DialogueUI are properly installed and enabled. The addon requires both dependencies to function correctly.

## The Immersion and Dialogue UI Bridge Team

![profile avatar](https://lh3.googleusercontent.com/a/ACg8ocIJD6EdgFhWdTSe6tD8hnsRBPVXvGzUnsGhd1CQ9VDgk8KkmND2=s96-c)

[Brostafa](https://www.curseforge.com/members/brostafa)

Owner

- 1

Projects

- 212

Downloads


Follow