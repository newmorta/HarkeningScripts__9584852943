-- Ruta Original: StarterPlayer.StarterPlayerScripts.RespawnCameraFix
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
Players.LocalPlayer.CharacterAdded:Connect(function(p1) -- Line: 8
    -- upvalues: RunService (copy)
    local HumanoidRootPart = p1:WaitForChild("HumanoidRootPart", 5);

    if not HumanoidRootPart then
        return;
    end;

    RunService.RenderStepped:Wait();
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    CurrentCamera.CFrame = CFrame.lookAt(HumanoidRootPart.Position - HumanoidRootPart.CFrame.LookVector * 12 + Vector3.new(0, 4, 0), HumanoidRootPart.Position + Vector3.new(0, 1, 0));
end);