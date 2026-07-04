-- Ruta Original: StarterPlayer.StarterPlayerScripts.FakeAdminMessageClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FakeAdminMessageUtil = require(ReplicatedStorage.Utilities.FakeAdminMessageUtil);
require(ReplicatedStorage.Utilities.FakeAdminMessageUtil.FakeAdminMessageRemotes).FakeAdminMessage:connect(function(p1) -- Line: 6
    -- upvalues: FakeAdminMessageUtil (copy)
    FakeAdminMessageUtil.show(p1);
end);