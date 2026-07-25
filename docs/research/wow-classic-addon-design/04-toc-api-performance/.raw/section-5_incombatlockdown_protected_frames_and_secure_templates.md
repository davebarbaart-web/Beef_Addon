### 5.1 The Combat Lockdown Rule

`InCombatLockdown()` returns `true` once `PLAYER_REGEN_DISABLED` fires (combat start) until `PLAYER_REGEN_ENABLED` fires (combat end). During lockdown:

- Protected functions (movement, casting, targeting, secure widget attribute changes) cannot be called from addon Lua unless invoked from a hardware event handler while the player is out of combat.
- New secure frames cannot be created; existing secure frame attributes cannot be modified arbitrarily.
- Tainted execution paths are blocked silently ([5_incombatlockdown_protected_frames_and_secure_templates[0]] [21]).

### 5.2 The RunOrQueue Pattern

Defer protected operations until combat ends:

```lua
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")

local function DoProtectedWork()
    -- safe to call protected functions here
end

frame:SetScript("OnEvent", function(self)
    DoProtectedWork()
end)

local function TryRun(fn)
    if InCombatLockdown() then
        -- queue for later
    else
        fn()
    end
end

-- Usage
TryRun(function() MySecureFrame:Hide() end)
```

### 5.3 Secure Templates

Secure templates are applied via `SecureTemplates` or widget-specific mixins (e.g., `SecureActionButtonTemplate`, `SecureHandlerAttributeTemplate`). They enable:

- Attribute-driven actions (`type`, `spell`, `item`, `macrotext`).
- State machine handlers (`OnStateChanged`, `OnAttributeChanged`).
- Click/enter/drag handlers via `SecureHandlerClickTemplate`/`SecureHandlerEnterTemplate`/`SecureHandlerDragTemplate`.

**Setting attributes:**

```lua
btn:SetAttribute("type", "spell")
btn:SetAttribute("spell", "Flash Heal")
btn:SetAttribute("target", "player")
```

These calls must occur outside combat or the client silently ignores them.

### 5.4 Protected Frame Categories

- Action buttons (`ActionButton*`) - spell/item/macro execution.
- Unit frames created via `SecureUnitButtonTemplate` or `SecureAuraHeaderTemplate`.
- Boss/arena/party/raid frames (Blizzard secure headers).
- Macros invoked through secure action handlers.
- Pet/multi-bar/possess bar frames bound to secure action handlers.

### 5.5 Taint Propagation

Reading a tainted variable and using it in a protected context taints the protected function. Taint persists until UI reload or relog. To avoid:

- Never assign addon-side data to `securevalue` or attributes consumed by protected code paths.
- Wrap attribute assignments in secure handlers, not raw Lua.
- Use `issecurevariable()` to check before assigning.
- Use `SecureHandlerAttributeTemplate` to keep attribute-driven logic isolated.

---