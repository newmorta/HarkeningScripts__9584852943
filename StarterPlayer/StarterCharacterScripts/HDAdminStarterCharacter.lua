-- Ruta Original: StarterPlayer.StarterCharacterScripts.HDAdminStarterCharacter
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local v1 = require(game:GetService("ReplicatedStorage"):WaitForChild("HDAdminSetup", 999)):GetMain();
v1.humanoidRigType = (v1.player.Character or v1.player.CharacterAdded:Wait()):WaitForChild("Humanoid").RigType;
wait(1);

for i, _ in pairs(v1.commandSpeeds) do
    if v1.commandsActive[i] then
        v1.commandsActive[i] = nil;
        v1:GetModule("cf"):ActivateClientCommand(i);
    end;
end;