-- Ruta Original: ReplicatedStorage.TikfinityModules.Chicken
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");

local function restoreOriginalBody(p2) -- Line: 13
    for _, descendant in ipairs(p2:GetDescendants()) do
        local v3 = descendant:GetAttribute("ChickenOldTransparency");

        if v3 ~= nil then
            descendant.Transparency = v3;
            descendant:SetAttribute("ChickenOldTransparency", nil);
        end;
    end;
end;

local function hideOriginalBody(p4, p5) -- Line: 23
    for _, descendant in ipairs(p4:GetDescendants()) do
        if descendant:IsA("BasePart") and not (p5 and descendant:IsDescendantOf(p5)) then
            if descendant:GetAttribute("ChickenOldTransparency") == nil then
                descendant:SetAttribute("ChickenOldTransparency", descendant.Transparency);
            end;

            descendant.Transparency = 1;
        end;
    end;
end;

local function attachCostume(p6) -- Line: 34
    -- upvalues: ReplicatedStorage (copy)
    local HumanoidRootPart = p6:FindFirstChild("HumanoidRootPart");
    local ChickenCostume = ReplicatedStorage:FindFirstChild("ChickenCostume");

    if not (ChickenCostume and HumanoidRootPart) then
        return nil;
    end;

    local v7 = ChickenCostume:Clone();
    v7.Name = "ChickenOutfit_Temp";
    v7.Parent = p6;
    local v8 = v7:FindFirstChildWhichIsA("BasePart");

    if not v8 then
        return nil;
    end;

    v8.Anchored = false;
    v8.CanCollide = false;
    v8.Massless = true;
    v8.CFrame = HumanoidRootPart.CFrame;
    local WeldConstraint = Instance.new("WeldConstraint", v8);
    WeldConstraint.Part0 = v8;
    WeldConstraint.Part1 = HumanoidRootPart;

    return v7;
end;

function v1.Run(p9) -- Line: 57
    -- upvalues: restoreOriginalBody (copy), attachCostume (copy), hideOriginalBody (copy), Debris (copy)
    local Character = p9.Character;

    if not (Character and Character:FindFirstChild("HumanoidRootPart")) then
        return;
    end;

    task.spawn(function() -- Line: 61
        -- upvalues: Character (copy), restoreOriginalBody (ref), attachCostume (ref), hideOriginalBody (ref), Debris (ref)
        local ChickenOutfit_Temp = Character:FindFirstChild("ChickenOutfit_Temp");

        if ChickenOutfit_Temp then
            ChickenOutfit_Temp:Destroy();
        end;

        restoreOriginalBody(Character);
        local v10 = attachCostume(Character);

        if not v10 then
            return;
        end;

        hideOriginalBody(Character, v10);
        local Sound = Instance.new("Sound", Character.HumanoidRootPart);
        Sound.SoundId = "rbxassetid://4510529019";
        Sound.Volume = 0.2;
        Sound:Play();
        Debris:AddItem(Sound, 3.8);
        task.wait(2.8);

        if Character.Parent then
            if v10 then
                v10:Destroy();
            end;

            restoreOriginalBody(Character);
        end;
    end);
end;

return v1;