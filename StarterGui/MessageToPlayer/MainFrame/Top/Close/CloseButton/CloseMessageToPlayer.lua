-- Ruta Original: StarterGui.MessageToPlayer.MainFrame.Top.Close.CloseButton.CloseMessageToPlayer
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local _ = Players.LocalPlayer;
local Parent = script.Parent;
local u1 = Parent:FindFirstAncestorOfClass("ScreenGui");
local ClearMessageToPlayer = ReplicatedStorage:WaitForChild("ClearMessageToPlayer");
Parent.MouseButton1Click:Connect(function() -- Line: 13
    -- upvalues: ClearMessageToPlayer (copy), u1 (copy)
    ClearMessageToPlayer:FireServer();

    if u1 then
        u1.Enabled = false;
    end;
end);