-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.HourlyTreadmillClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local NotificationSystem = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
local SoundManager = require(ReplicatedStorage:WaitForChild("SoundManager"));
ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("HourlyTreadmillEvent").OnClientEvent:Connect(function(p1) -- Line: 16
    -- upvalues: NotificationSystem (copy), SoundManager (copy)
    if type(p1) ~= "table" then
        return;
    end;

    if p1.action == "spawn" then
        NotificationSystem:ShowGeneralNotification("A special treadmill has spawned for 5 minutes! (x5 XP)", Color3.fromRGB(255, 200, 50));
        SoundManager:Play("NOTIF1");
    end;
end);