-- Ruta Original: StarterPlayer.StarterCharacterScripts.NoBugJumpMobile
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local _ = game:GetService("Players").LocalPlayer;
local Parent = script.Parent;
local Humanoid = Parent:WaitForChild("Humanoid");
local RunService = game:GetService("RunService");
local HumanoidRootPart = Parent:WaitForChild("HumanoidRootPart");
Humanoid.AutoJumpEnabled = false;
local u4 = RunService.PostSimulation:Connect(function(p1) -- Line: 14, Name: onPostSimulation
    -- upvalues: Humanoid (copy), HumanoidRootPart (copy)
    local v2 = Humanoid:GetState();

    if (v2 == Enum.HumanoidStateType.Running or v2 == Enum.HumanoidStateType.RunningNoPhysics) and (Humanoid.WalkSpeed >= 50 and HumanoidRootPart.AssemblyLinearVelocity.Magnitude > 10) then
        local v3 = HumanoidRootPart;
        v3.AssemblyLinearVelocity = v3.AssemblyLinearVelocity + Vector3.new(0, -50 * p1, 0);
    end;
end);
Humanoid.Died:Connect(function() -- Line: 29
    -- upvalues: u4 (copy)
    u4:Disconnect();
end);