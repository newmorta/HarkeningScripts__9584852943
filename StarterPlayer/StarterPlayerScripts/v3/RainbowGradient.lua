-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.RainbowGradient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui");
local u1 = {};

local function addGradient(p2) -- Line: 18
    -- upvalues: PlayerGui (copy), u1 (copy)
    if p2:IsA("UIGradient") and p2:IsDescendantOf(PlayerGui) then
        u1[p2] = true;
    end;
end;

local function removeGradient(p3) -- Line: 24
    -- upvalues: u1 (copy)
    u1[p3] = nil;
end;

local u4 = 0;

for _, v in ipairs(CollectionService:GetTagged("UIGradientRainbow")) do
    if v:IsA("UIGradient") and v:IsDescendantOf(PlayerGui) then
        u1[v] = true;
    end;
end;

CollectionService:GetInstanceAddedSignal("UIGradientRainbow"):Connect(function(u5) -- Line: 34
    -- upvalues: PlayerGui (copy), u1 (copy)
    task.defer(function() -- Line: 35
        -- upvalues: u5 (copy), PlayerGui (ref), u1 (ref)
        local v6 = u5;

        if v6:IsA("UIGradient") and v6:IsDescendantOf(PlayerGui) then
            u1[v6] = true;
        end;
    end);
end);
CollectionService:GetInstanceRemovedSignal("UIGradientRainbow"):Connect(removeGradient);
RunService.RenderStepped:Connect(function(p7) -- Line: 43
    -- upvalues: u4 (ref), u1 (copy)
    u4 = u4 + p7 * 0.3;
    local v8 = Color3.fromHSV(u4 % 1, 0.8, 1);
    local v9 = Color3.fromHSV((u4 + 0.15) % 1, 0.8, 1);
    local v10 = Color3.fromHSV((u4 + 0.3) % 1, 0.8, 1);
    local v11 = ColorSequence.new({ ColorSequenceKeypoint.new(0, v8), ColorSequenceKeypoint.new(0.5, v9), ColorSequenceKeypoint.new(1, v10) });

    for i in pairs(u1) do
        if i.Parent then
            i.Color = v11;
        else
            u1[i] = nil;
        end;
    end;
end);