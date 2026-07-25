{
  "extract_id": "extract_b01de0c7a83b66583fb5cb76929b668d",
  "session_id": "session_b01de0c7a83b66583fb5cb76929b668d",
  "status": "ok",
  "results": [
    {
      "url": "https://warcraft.wiki.gg/wiki/API_CombatLogGetCurrentEventInfo",
      "title": "CombatLogGetCurrentEventInfo - Warcraft Wiki - Your wiki guide to the World of Warcraft",
      "publish_date": "2019-04-20",
      "excerpts": [
        "# CombatLogGetCurrentEventInfo\nFrom Warcraft Wiki\nJump to navigation Jump to search\n\u2191 _World of Warcraft API_\nReturns the current COMBAT_LOG_EVENT payload.\n```\narg1 , arg2 , ... = CombatLogGetCurrentEventInfo ()\n```\n\n## Returns\n* Returns a variable number of values: 11 base values and up to 13 extra values based upon the subtype of the event.\n\n## Details\n* In the new event system for 8.0, supporting the original functionality of the CLEU event was problematic due to the \"context\" arguments, i.e. each argument can be interpreted differently depending on the previous arguments. The payload was subsequently moved to this function. [[ 1 ]]()\n\n## Example\n* Prints all CLEU parameters.\n```\nlocal function OnEvent ( self , event ) \n print ( CombatLogGetCurrentEventInfo ()) \n end \n\n local f = CreateFrame ( \"Frame\" ) \n f : RegisterEvent ( \"COMBAT_LOG_EVENT_UNFILTERED\" ) \n f : SetScript ( \"OnEvent\" , OnEvent )\n```\n* Displays your spell or melee critical hits.\n\n...\n\n## Patch changes\n* **Patch 8.0.1 (2018-07-17):** Added. [[ 2 ]]()\n\n## References\n1. ^ TheDanW 2018-02-06. [#wowuidev IRC log](http://infobot.rikers.org/%23wowuidev/20180206.html.gz) .\n2. ^ Ythisens 2018-04-24. [Combat Log Event Changes](https://us.battle.net/forums/en/wow/topic/20762318007) ."
      ]
    }
  ],
  "errors": [],
  "usage": [
    {
      "name": "sku_extract_excerpts",
      "count": 1
    }
  ],
  "warnings": []
}