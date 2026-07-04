-- Ruta Original: StarterPlayer.StarterPlayerScripts.Pièges.Tsunami
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local u1 = {};
RunService.PreRender:Connect(function() -- Line: 24
    -- upvalues: u1 (copy)
    local v2 = workspace:GetServerTimeNow();

    for i, v in u1 do
        local v3 = i:GetAttribute("TsunamiStartTime") or -1;
        local v4 = i:GetAttribute("TravelTime") or 1;

        if v3 ~= -1 then
            local v5 = v2 - v3;

            if v5 >= 0 then
                v.union.CFrame = v.startCF:Lerp(v.endCF, v5 % v4 / v4);

                if v.label then
                    v.label.Text = string.format("%.1f", v4 - v5 % v4);
                end;
            end;
        end;
    end;
end);

local function setupClient(p6) -- Line: 8
    -- upvalues: u1 (copy)
    local Tsunami = p6:FindFirstChild("Tsunami");
    local TsunamiSpawn = p6:FindFirstChild("TsunamiSpawn");
    local TsunamiEnd = p6:FindFirstChild("TsunamiEnd");
    local Timer = p6:FindFirstChild("Timer", true);

    if not (Tsunami and (TsunamiSpawn and TsunamiEnd)) then
        return;
    end;

    u1[p6] = {
        union = Tsunami,
        label = Timer,
        startCF = TsunamiSpawn.CFrame,
        endCF = TsunamiEnd.CFrame
    };
end;

for _, v in ipairs(CollectionService:GetTagged("TsunamiModel")) do
    setupClient(v);
end;

CollectionService:GetInstanceAddedSignal("TsunamiModel"):Connect(setupClient);