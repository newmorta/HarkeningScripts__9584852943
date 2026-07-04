-- Ruta Original: StarterPlayer.StarterPlayerScripts.Pièges.World2.Fans_Part
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local u1 = nil;
local u2 = nil;
local u3 = OverlapParams.new();
u3.FilterType = Enum.RaycastFilterType.Include;

local function updateCharacter() -- Line: 23
    -- upvalues: u1 (ref), LocalPlayer (copy), u2 (ref), u3 (copy)
    u1 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
    u2 = u1:WaitForChild("HumanoidRootPart");
    u3.FilterDescendantsInstances = { u1.PrimaryPart };
end;

u1 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
u2 = u1:WaitForChild("HumanoidRootPart");
u3.FilterDescendantsInstances = { u1.PrimaryPart };
LocalPlayer.CharacterAdded:Connect(function() -- Line: 33
    -- upvalues: u1 (ref), LocalPlayer (copy), u2 (ref), u3 (copy)
    u1 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
    u2 = u1:WaitForChild("HumanoidRootPart");
    u3.FilterDescendantsInstances = { u1.PrimaryPart };
end);

local function initFans(u4) -- Line: 37
    -- upvalues: RunService (copy), u1 (ref), u2 (ref), u3 (copy)
    local u5 = nil;
    u5 = RunService.RenderStepped:Connect(function(p6) -- Line: 40
        -- upvalues: u4 (copy), u5 (ref), u1 (ref), u2 (ref), u3 (ref)
        if not (u4 and u4.Parent) then
            u5:Disconnect();

            return;
        end;

        if not (u1 and u2) then
            return;
        end;

        if #workspace:GetPartsInPart(u4, u3) > 0 then
            local AssemblyMass = u2.AssemblyMass;
            local v7 = u2;
            v7.AssemblyLinearVelocity = v7.AssemblyLinearVelocity + u4.CFrame.LookVector * ((u2.AssemblyLinearVelocity.Magnitude < 148 and 15000 or 25) * AssemblyMass) / AssemblyMass * p6;
        end;
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("FanEffect")) do
    if v:IsA("BasePart") then
        local u8 = nil;
        u8 = RunService.RenderStepped:Connect(function(p9) -- Line: 40
            -- upvalues: v (copy), u8 (ref), u1 (ref), u2 (ref), u3 (copy)
            if not (v and v.Parent) then
                u8:Disconnect();

                return;
            end;

            if not (u1 and u2) then
                return;
            end;

            if #workspace:GetPartsInPart(v, u3) > 0 then
                local AssemblyMass = u2.AssemblyMass;
                local v10 = u2;
                v10.AssemblyLinearVelocity = v10.AssemblyLinearVelocity + v.CFrame.LookVector * ((u2.AssemblyLinearVelocity.Magnitude < 148 and 15000 or 25) * AssemblyMass) / AssemblyMass * p9;
            end;
        end);
    end;
end;

CollectionService:GetInstanceAddedSignal("FanEffect"):Connect(function(u11) -- Line: 89
    -- upvalues: RunService (copy), u1 (ref), u2 (ref), u3 (copy)
    if u11:IsA("BasePart") then
        local u12 = nil;
        u12 = RunService.RenderStepped:Connect(function(p13) -- Line: 40
            -- upvalues: u11 (copy), u12 (ref), u1 (ref), u2 (ref), u3 (ref)
            if not (u11 and u11.Parent) then
                u12:Disconnect();

                return;
            end;

            if not (u1 and u2) then
                return;
            end;

            if #workspace:GetPartsInPart(u11, u3) > 0 then
                local AssemblyMass = u2.AssemblyMass;
                local v14 = u2;
                v14.AssemblyLinearVelocity = v14.AssemblyLinearVelocity + u11.CFrame.LookVector * ((u2.AssemblyLinearVelocity.Magnitude < 148 and 15000 or 25) * AssemblyMass) / AssemblyMass * p13;
            end;
        end);
    end;
end);