-- Ruta Original: StarterPlayer.StarterCharacterScripts.AntiTrip
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Humanoid = script.Parent:WaitForChild("Humanoid");
Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false);