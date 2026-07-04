-- Ruta Original: ReplicatedStorage.Config.GeneralConfig
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local PlaceRegistry = require(script.Parent:WaitForChild("PlaceRegistry"));
local u3 = {
    ConfigXPMultiplier = 1,

    GetWorlds = function(p1) -- Line: 26, Name: GetWorlds
        -- upvalues: PlaceRegistry (copy)
        return PlaceRegistry.getWorlds();
    end,

    IsTestPlace = function(p2) -- Line: 30, Name: IsTestPlace
        -- upvalues: PlaceRegistry (copy)
        return PlaceRegistry.isTestPlace();
    end
};

function u3.GetConfigXPMultiplier(p4) -- Line: 34
    -- upvalues: u3 (copy)
    return u3.ConfigXPMultiplier;
end;

function u3.GetWorldStatus(p5) -- Line: 38
    -- upvalues: PlaceRegistry (copy)
    return PlaceRegistry.getWorldStatus();
end;

if u3:IsTestPlace() then
    u3.ConfigXPMultiplier = 10000000;
    warn("YOU ARE IN A TESTING PLACE - EARNED XP MULTIPLIED BY : ", u3.ConfigXPMultiplier);
    warn("WORLD " .. u3:GetWorldStatus());
end;

return u3;