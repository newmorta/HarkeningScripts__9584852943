-- Ruta Original: StarterPlayer.StarterPlayerScripts.Pièges.PontAuto
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local u1 = {};

local function registerTimer(p2) -- Line: 9
    -- upvalues: u1 (copy)
    if not p2:IsA("TextLabel") then
        return;
    end;

    local v3 = p2:FindFirstAncestorOfClass("Model");

    if v3 then
        u1[p2] = v3;
    end;
end;

local function unregisterTimer(p4) -- Line: 17
    -- upvalues: u1 (copy)
    u1[p4] = nil;
end;

for _, v in ipairs(CollectionService:GetTagged("Timer")) do
    if v:IsA("TextLabel") then
        local v5 = v:FindFirstAncestorOfClass("Model");

        if v5 then
            u1[v] = v5;
        end;
    end;
end;

CollectionService:GetInstanceAddedSignal("Timer"):Connect(registerTimer);
CollectionService:GetInstanceRemovedSignal("Timer"):Connect(unregisterTimer);
RunService.RenderStepped:Connect(function() -- Line: 26
    -- upvalues: u1 (copy)
    local v6 = workspace:GetServerTimeNow();

    for i, v in u1 do
        local v7 = v:GetAttribute("BridgeDie");
        local v8 = v:GetAttribute("ServerStartTime");

        if v7 and v8 then
            local v9 = math.max(0, v7 - (v6 - v8));

            if v9 > 0 then
                i.Text = string.format("%.2f", v9);
                i.TextColor3 = v9 < 1 and Color3.new(1, 0, 0) or Color3.new(1, 1, 1);
            else
                i.Text = "Wait...";
                i.TextColor3 = Color3.new(1, 0, 0);
            end;
        end;
    end;
end);