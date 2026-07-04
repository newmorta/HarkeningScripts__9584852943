-- Ruta Original: StarterPlayer.StarterPlayerScripts.Pièges.CrushWall
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local u1 = {};
local u2 = {};

local function setupTrap(u3) -- Line: 20
    -- upvalues: u2 (copy), setupTrap (copy), u1 (copy)
    local WallL = u3:WaitForChild("WallL", 5);
    local WallR = u3:WaitForChild("WallR", 5);
    local TargetL = u3:WaitForChild("TargetL", 5);
    local TargetR = u3:WaitForChild("TargetR", 5);
    local CrushCenter = u3:WaitForChild("CrushCenter", 5);

    if not (WallL and (WallR and (TargetL and (TargetR and CrushCenter)))) then
        return;
    end;

    local v4 = u3:GetAttribute("CycleStartTime");

    if not v4 then
        if u2[u3] then
            return;
        end;

        local u5 = nil;
        u5 = u3:GetAttributeChangedSignal("CycleStartTime"):Connect(function() -- Line: 34
            -- upvalues: u2 (ref), u3 (copy), u5 (ref), setupTrap (ref)
            u2[u3] = nil;

            if u5 then
                u5:Disconnect();
            end;

            setupTrap(u3);
        end);
        u2[u3] = u5;

        return;
    end;

    local v6 = u3:GetAttribute("CloseTime") or 2;
    local v7 = u3:GetAttribute("WaitTime") or 1;
    local v8 = u3:GetAttribute("OpenTime") or 1;
    u1[u3] = {
        LastState = "Idle",
        L = WallL,
        R = WallR,
        startL = WallL.CFrame,
        startR = WallR.CFrame,
        endL = TargetL.CFrame,
        endR = TargetR.CFrame,
        closeT = v6,
        waitT = v7,
        openT = v8,
        total = v6 + v7 + v8,
        startTime = v4,
        SoundL = WallL:FindFirstChild("MoveSoundL"),
        SoundR = WallR:FindFirstChild("MoveSoundR"),
        ImpactS = CrushCenter:FindFirstChild("ImpactSound")
    };
    TargetL.CanCollide = false;
    TargetR.CanCollide = false;
end;

RunService.PreRender:Connect(function() -- Line: 64
    -- upvalues: u1 (copy)
    local v9 = workspace:GetServerTimeNow();

    for i, v in u1 do
        if i:IsDescendantOf(workspace) then
            local v10 = (v9 - v.startTime) % v.total;

            if v10 < v.closeT then
                local v11 = v10 / v.closeT;
                v.L.CFrame = v.startL:Lerp(v.endL, v11);
                v.R.CFrame = v.startR:Lerp(v.endR, v11);
            elseif v10 < v.closeT + v.waitT then
                v.L.CFrame = v.endL;
                v.R.CFrame = v.endR;
            else
                local v12 = (v10 - v.closeT - v.waitT) / v.openT;
                v.L.CFrame = v.endL:Lerp(v.startL, v12);
                v.R.CFrame = v.endR:Lerp(v.startR, v12);
            end;

            if v10 < v.closeT then
                if v.SoundL and not v.SoundL.IsPlaying then
                    v.SoundL:Play();
                end;

                if v.SoundR and not v.SoundR.IsPlaying then
                    v.SoundR:Play();
                end;

                v.LastState = "Closing";
            elseif v10 < v.closeT + v.waitT then
                if v.LastState == "Closing" then
                    if v.SoundL then
                        v.SoundL:Stop();
                    end;

                    if v.SoundR then
                        v.SoundR:Stop();
                    end;

                    if v.ImpactS then
                        v.ImpactS:Play();
                    end;

                    v.LastState = "Wait";
                end;
            else
                if v.SoundL and not v.SoundL.IsPlaying then
                    v.SoundL:Play();
                end;

                if v.SoundR and not v.SoundR.IsPlaying then
                    v.SoundR:Play();
                end;

                v.LastState = "Opening";
            end;
        end;
    end;
end);
CollectionService:GetInstanceRemovedSignal("CrushTrap"):Connect(function(p13) -- Line: 107
    -- upvalues: u1 (copy), u2 (copy)
    u1[p13] = nil;
    local v14 = u2[p13];

    if v14 then
        v14:Disconnect();
        u2[p13] = nil;
    end;
end);

for _, v in ipairs(CollectionService:GetTagged("CrushTrap")) do
    setupTrap(v);
end;

CollectionService:GetInstanceAddedSignal("CrushTrap"):Connect(function(p15) -- Line: 117
    -- upvalues: setupTrap (copy)
    if p15:IsA("Model") then
        setupTrap(p15);
    end;
end);