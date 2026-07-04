-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.FriendBoostUIHandler
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local FriendBoost = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("FriendBoost"));
local FriendBoostUISystem = require(ReplicatedStorage:WaitForChild("UISystems"):WaitForChild("FriendBoostUISystem"));

if not FriendBoost.ENABLED then
    return;
end;

FriendBoostUISystem:InitLogic();
FriendBoostUISystem:RefreshFriendCount();
ReplicatedStorage:WaitForChild("FriendBoostOverride").OnClientEvent:Connect(function(p1) -- Line: 17
    -- upvalues: FriendBoostUISystem (copy)
    if type(p1) == "table" and p1.percent then
        FriendBoostUISystem:ApplyOverride(p1.percent);
    end;
end);
Players.PlayerAdded:Connect(function() -- Line: 23
    -- upvalues: FriendBoostUISystem (copy)
    FriendBoostUISystem:RefreshFriendCount();
end);
Players.PlayerRemoving:Connect(function() -- Line: 27
    -- upvalues: FriendBoostUISystem (copy)
    task.defer(function() -- Line: 28
        -- upvalues: FriendBoostUISystem (ref)
        FriendBoostUISystem:RefreshFriendCount();
    end);
end);