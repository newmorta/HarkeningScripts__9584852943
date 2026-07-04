-- Ruta Original: StarterPlayer.StarterPlayerScripts.Pièges.World2.Fans
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local u1 = {};

for _, v in ipairs(CollectionService:GetTagged("Fans")) do
    if v:IsA("BasePart") then
        table.insert(u1, v);
    end;
end;

CollectionService:GetInstanceAddedSignal("Fans"):Connect(function(p2) -- Line: 14
    -- upvalues: u1 (copy)
    if p2:IsA("BasePart") then
        table.insert(u1, p2);
    end;
end);
RunService.RenderStepped:Connect(function(p3) -- Line: 20
    -- upvalues: u1 (copy)
    for _, v in ipairs(u1) do
        if v and v.Parent then
            v.CFrame = v.CFrame * CFrame.Angles(math.rad(180 * p3), 0, 0);
        end;
    end;
end);