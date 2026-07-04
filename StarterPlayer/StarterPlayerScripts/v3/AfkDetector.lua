-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.AfkDetector
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local PlayerAfkStatus = ReplicatedStorage:WaitForChild("PlayerAfkStatus", 10);

if PlayerAfkStatus then
    LocalPlayer.Idled:Connect(function() -- Line: 12
        -- upvalues: PlayerAfkStatus (copy)
        PlayerAfkStatus:FireServer(os.time());
    end);

    return;
end;

warn("[AfkDetector] PlayerAfkStatus remote introuvable");