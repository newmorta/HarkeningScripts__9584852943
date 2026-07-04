-- Ruta Original: ReplicatedStorage.RelicsXYZ
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Shared = script.Shared;
local RunContext = require(Shared.RunContext);
local LogService = game:GetService("LogService");

if not pcall(function() -- Line: 7
    -- upvalues: LogService (copy)
    LogService:Info("LOADING RELICSXYZ MODULE...");
end) then
    warn("LOADING RELICSXYZ MODULE");
end;

for _, child in script.Shared:GetChildren() do
    xpcall(require, function(p1) -- Line: 14
        -- upvalues: child (copy)
        warn((`Error loading module {child.Name}: {p1} {debug.traceback()}`));
    end, child);
end;

local v2;

if RunContext.IsClient or RunContext.IsEdit then
    v2 = require(script.RelicsPlayer);
else
    v2 = table.freeze({
        new = function(p3) -- Line: 22, Name: new
            error("RelicsPlayer cannot be created on the server.");
        end
    });
end;

return table.freeze({
    Auras = require(Shared.Auras),
    Emotes = require(Shared.Emotes),
    Boombox = require(Shared.Boombox),
    Settings = require(Shared.Settings),
    Favorites = require(Shared.Favorites),
    MusicData = require(Shared.MusicData),
    GamePasses = require(Shared.GamePasses),
    RelicsPlayer = v2
});