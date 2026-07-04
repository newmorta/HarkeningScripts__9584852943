-- Ruta Original: ReplicatedStorage.Utilities.FakeAdminMessageUtil.FakeAdminMessageRemotes
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local remo = require(ReplicatedStorage.Packages.remo);

return remo.createRemotes({
    FakeAdminMessage = remo.remote()
});