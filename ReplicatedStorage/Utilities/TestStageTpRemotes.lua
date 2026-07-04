-- Ruta Original: ReplicatedStorage.Utilities.TestStageTpRemotes
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local remo = require(ReplicatedStorage.Packages.remo);

return remo.createRemotes({
    TeleportToStage = remo.remote(),
    GetStages = remo.remote().returns()
});