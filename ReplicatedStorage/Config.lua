-- Ruta Original: ReplicatedStorage.Config
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local PlaceRegistry = require(script:WaitForChild("PlaceRegistry"));
local WorldConfigsBuilder = require(script:WaitForChild("WorldConfigsBuilder"));
local v1 = PlaceRegistry.getWorldIndex();
warn("[Config] PlaceId =", game.PlaceId, "| World =", v1);

return WorldConfigsBuilder.build(v1);