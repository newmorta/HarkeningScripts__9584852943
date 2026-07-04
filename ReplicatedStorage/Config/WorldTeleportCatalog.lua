-- Ruta Original: ReplicatedStorage.Config.WorldTeleportCatalog
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PlaceRegistry = require(script.Parent:WaitForChild("PlaceRegistry"));
local WorldConfigsBuilder = require(script.Parent:WaitForChild("WorldConfigsBuilder"));
local GeneralConfig = require(script.Parent:WaitForChild("GeneralConfig"));

return {
    getEntries = function() -- Line: 12, Name: getEntries
        -- upvalues: ReplicatedStorage (copy), GeneralConfig (copy), PlaceRegistry (copy), WorldConfigsBuilder (copy)
        local WORLD = require(ReplicatedStorage:WaitForChild("Config")).WORLD;
        local v1 = GeneralConfig:GetWorlds();
        local v2 = {};

        for i = 1, PlaceRegistry.getWorldCount() do
            local v3 = WorldConfigsBuilder.build(i);
            local v4 = v3.DISPLAY or {};
            local v5 = {
                index = i,
                entryLevel = v3.ENTRY and (v3.ENTRY.LEVEL or 0) or 0,
                color = v4.COLOR or Color3.fromRGB(80, 80, 90),
                icon = v4.ICON,
                hasPlace = v1[i] ~= nil,
                isCurrent = v3.WORLD == WORLD
            };
            table.insert(v2, v5);
        end;

        return v2;
    end
};