-- Ruta Original: StarterPlayer.StarterPlayerScripts.CmdrClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

if RunService:IsStudio() then
    require((ReplicatedStorage:WaitForChild("CmdrClient"))):SetPlaceName("CrossWorld");
end;