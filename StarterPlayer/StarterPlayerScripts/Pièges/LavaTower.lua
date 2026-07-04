-- Ruta Original: StarterPlayer.StarterPlayerScripts.Pièges.LavaTower
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local LocalPlayer = Players.LocalPlayer;
local u1 = {};

local function isLocalCharacterPart(p2) -- Line: 12
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;
    local v3;

    if Character == nil then
        v3 = false;
    else
        v3 = p2:IsDescendantOf(Character);
    end;

    return v3;
end;

local function computeLavaCF(p4, p5, p6, p7, p8) -- Line: 19
    if p5 < p6 then
        return p4.Bottom.CFrame:Lerp(p4.Top.CFrame, p5 / p6), true;
    end;

    if p5 < p6 + p7 then
        return p4.Top.CFrame, false;
    end;

    if p5 < p6 + p7 + p8 then
        return p4.Top.CFrame:Lerp(p4.Bottom.CFrame, (p5 - (p6 + p7)) / p8), true;
    end;

    return p4.Bottom.CFrame, false;
end;

local function setupTrap(p9) -- Line: 32
    -- upvalues: u1 (copy), LocalPlayer (copy)
    if u1[p9] then
        return;
    end;

    local LavaPart = p9:WaitForChild("LavaPart", 10);
    local LavaBottom = p9:WaitForChild("LavaBottom", 10);
    local LavaTop = p9:WaitForChild("LavaTop", 10);

    if not (LavaPart and (LavaBottom and LavaTop)) then
        return;
    end;

    LavaBottom.Transparency = 1;
    LavaBottom.CanCollide = false;
    LavaTop.Transparency = 1;
    LavaTop.CanCollide = false;
    local v10 = LavaPart:FindFirstChildOfClass("Sound");

    if v10 then
        v10:Play();
    end;

    local v11 = p9:GetAttribute("Manual") == true;
    local u12 = {
        Active = false,
        TriggerTime = 0,
        Lava = LavaPart,
        Bottom = LavaBottom,
        Top = LavaTop,
        Sound = v10,
        Manual = v11
    };

    if v11 then
        LavaPart.CFrame = LavaBottom.CFrame;

        if v10 then
            v10.Volume = 0;
        end;

        local ManualZone = p9:FindFirstChild("ManualZone");

        if ManualZone and ManualZone:IsA("BasePart") then
            ManualZone.Touched:Connect(function(p13) -- Line: 62
                -- upvalues: u12 (copy), LocalPlayer (ref)
                if u12.Active then
                    return;
                end;

                local Character = LocalPlayer.Character;
                local v14;

                if Character == nil then
                    v14 = false;
                else
                    v14 = p13:IsDescendantOf(Character);
                end;

                if not v14 then
                    return;
                end;

                u12.Active = true;
                u12.TriggerTime = workspace:GetServerTimeNow();
            end);
        else
            warn("[LavaTower] Manual activé mais \'ManualZone\' introuvable dans", p9:GetFullName());
        end;

        LavaPart.Touched:Connect(function(p15) -- Line: 74
            -- upvalues: u12 (copy), LocalPlayer (ref)
            if not u12.Active then
                return;
            end;

            local Character = LocalPlayer.Character;
            local v16;

            if Character == nil then
                v16 = false;
            else
                v16 = p15:IsDescendantOf(Character);
            end;

            if not v16 then
                return;
            end;

            local v17 = LocalPlayer.Character and v17:FindFirstChildOfClass("Humanoid");

            if v17 and v17.Health > 0 then
                v17.Health = 0;
            end;
        end);
    end;

    u1[p9] = u12;
end;

RunService.PreRender:Connect(function() -- Line: 87
    -- upvalues: u1 (copy), computeLavaCF (copy)
    local v18 = workspace:GetServerTimeNow();

    for i, v in u1 do
        if i:IsDescendantOf(workspace) then
            local v19 = i:GetAttribute("RiseTime") or 5;
            local v20 = i:GetAttribute("TopWait") or 1;
            local v21 = i:GetAttribute("FallTime") or 2;

            if v.Manual then
                if v.Active then
                    local v22 = v18 - v.TriggerTime;
                    local v23, v24 = computeLavaCF(v, v22, v19, v20, v21);
                    v.Lava.CFrame = v23;

                    if v.Sound then
                        v.Sound.Volume = v24 and 1 or 0;
                    end;

                    if v19 + v20 + v21 <= v22 then
                        v.Active = false;
                    end;
                else
                    v.Lava.CFrame = v.Bottom.CFrame;

                    if v.Sound then
                        v.Sound.Volume = 0;
                    end;
                end;
            else
                local v25 = i:GetAttribute("CycleStartTime") or 0;

                if v25 ~= 0 then
                    local v26 = i:GetAttribute("BottomWait") or 2;
                    local v27, v28 = computeLavaCF(v, (v18 - v25) % (v19 + v20 + v21 + v26), v19, v20, v21);
                    v.Lava.CFrame = v27;

                    if v.Sound then
                        v.Sound.Volume = v28 and 1 or 0;
                    end;
                end;
            end;
        end;
    end;
end);
CollectionService:GetInstanceAddedSignal("LavaTrap"):Connect(setupTrap);
CollectionService:GetInstanceRemovedSignal("LavaTrap"):Connect(function(p29) -- Line: 131
    -- upvalues: u1 (copy)
    u1[p29] = nil;
end);

for _, v in ipairs(CollectionService:GetTagged("LavaTrap")) do
    setupTrap(v);
end;