-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.OverdriveBossRoom.OverdriveRemotes
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local remo = require(ReplicatedStorage.Packages.remo);

return remo.createRemotes({
    OverdriveOrbCollected = remo.remote()
});