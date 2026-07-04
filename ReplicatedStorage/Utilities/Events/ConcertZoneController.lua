-- Ruta Original: ReplicatedStorage.Utilities.Events.ConcertZoneController
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local Lighting = game:GetService("Lighting");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GravityManager = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("GravityManager"));
local JumpHeightManager = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("JumpHeightManager"));
local ConcertSharedConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ConcertSharedConfig"));
local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 13
    -- upvalues: u1 (copy), Players (copy), Lighting (copy), Workspace (copy)
    local v2 = setmetatable({}, u1);
    v2._zonePart = nil;
    v2._gravityPart = nil;
    v2._player = Players.LocalPlayer;
    v2._isInsideZone = false;
    v2._isInsideGravityZone = false;
    v2._originalTimeOfDay = Lighting.TimeOfDay;
    v2._originalGravity = Workspace.Gravity;
    v2._originalJumpHeight = nil;
    v2._originalJumpPower = nil;
    v2._boundHumanoid = nil;
    v2._activeEffects = {
        NoGravity = false,
        Spinning = false,
        ChickenParty = false,
        FastDay = false
    };
    v2._chickenCostume = nil;
    v2._lastCharacter = nil;
    v2._checkTimer = 0;

    return v2;
end;

function u1.scan(p3, p4) -- Line: 41
    -- upvalues: Lighting (copy), Workspace (copy)
    if not p4 then
        return;
    end;

    if p4.Parent and p4.Parent:IsA("Model") then
        p4 = p4.Parent;
    end;

    local v5 = nil;
    local v6 = nil;

    for _, descendant in ipairs(p4:GetDescendants()) do
        if descendant:IsA("BasePart") then
            if descendant.Name == "ConcertZone" then
                v5 = descendant;
            elseif descendant.Name == "GravityPart" then
                v6 = descendant;
            end;
        end;
    end;

    if not v5 then
        warn("[ConcertZoneController] Missing part \'ConcertZone\' in scene. Env overrides will be disabled.");
    end;

    p3._zonePart = v5;
    p3._gravityPart = v6;
    p3._originalTimeOfDay = Lighting.TimeOfDay;
    p3._originalGravity = Workspace.Gravity;
end;

function u1._isCharacterInZone(p7, p8) -- Line: 71
    if not (p7._zonePart and p8) then
        return false;
    end;

    local HumanoidRootPart = p8:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return false;
    end;

    local v9 = p7._zonePart.CFrame:PointToObjectSpace(HumanoidRootPart.Position);
    local v10 = p7._zonePart.Size / 2;
    local v11 = math.abs(v9.X) <= v10.X;
    local v12 = math.abs(v9.Y) <= v10.Y + 10;
    local v13 = math.abs(v9.Z) <= v10.Z;

    if v11 then
        if not v12 then
            v13 = v12;
        end;
    else
        v13 = v11;
    end;

    return v13;
end;

function u1._updateAllPlayerChickenOutfits(p14) -- Line: 86
    -- upvalues: Players (copy)
    for _, v in ipairs(Players:GetPlayers()) do
        local Character = v.Character;

        if Character then
            local v15 = p14:_isCharacterInZone(Character);

            if p14._activeEffects.ChickenParty and v15 then
                if not Character:FindFirstChild("ChickenOutfit_Temp") then
                    p14:_restoreOriginalBody(Character);
                    local v16 = p14:_attachCostume(Character);

                    if v16 then
                        p14:_hideOriginalBody(Character, v16);
                    end;
                end;
            else
                local ChickenOutfit_Temp = Character:FindFirstChild("ChickenOutfit_Temp");

                if ChickenOutfit_Temp then
                    ChickenOutfit_Temp:Destroy();
                    p14:_restoreOriginalBody(Character);
                end;
            end;
        end;
    end;
end;

function u1._checkPlayerInZone(p17) -- Line: 111
    return p17:_isCharacterInZone(p17._player.Character);
end;

function u1.update(p18, p19) -- Line: 115
    -- upvalues: Workspace (copy)
    if not (p18._zonePart or p18._gravityPart) then
        return;
    end;

    p18._checkTimer = p18._checkTimer + p19;

    if p18._checkTimer >= 0.25 then
        p18._checkTimer = 0;
        local Character = p18._player.Character;
        local v20 = Character ~= p18._lastCharacter;
        p18._lastCharacter = Character;
        local v21 = p18:_checkPlayerInZone();

        if v21 ~= p18._isInsideZone or v20 then
            p18._isInsideZone = v21;

            if p18._isInsideZone then
                p18:_onEnterZone();
            else
                p18:_onExitZone();
            end;
        end;

        p18._isInsideGravityZone = p18:_checkPlayerInGravityPart();
        local ConcertState = Workspace:FindFirstChild("ConcertState");
        local v22 = {
            NoGravity = false,
            Spinning = false,
            ChickenParty = false,
            FastDay = false
        };

        if ConcertState then
            for i in pairs(v22) do
                local v23 = ConcertState:FindFirstChild(i);

                if v23 and v23:IsA("BoolValue") then
                    v22[i] = v23.Value;
                end;
            end;
        end;

        local v24 = {};
        v24.NoGravity = p18._isInsideGravityZone and v22.NoGravity;
        v24.Spinning = p18._isInsideZone and v22.Spinning;
        v24.ChickenParty = p18._isInsideZone and v22.ChickenParty;
        v24.FastDay = p18._isInsideZone and v22.FastDay;

        if v20 then
            p18._activeEffects.NoGravity = nil;
            p18._activeEffects.ChickenParty = nil;
            p18._boundHumanoid = nil;
        end;

        p18:_reconcileEffects(v24);
        p18:_updateAllPlayerChickenOutfits();
    end;

    p18:_runFrameEffects(p19);
end;

function u1._onEnterZone(p25) -- Line: 176
    -- upvalues: Lighting (copy)
    p25._originalTimeOfDay = Lighting.TimeOfDay;
    Lighting.TimeOfDay = "00:00:00";
end;

function u1._onExitZone(p26) -- Line: 181
    -- upvalues: Lighting (copy)
    Lighting.TimeOfDay = p26._originalTimeOfDay;
end;

function u1._checkPlayerInGravityPart(p27) -- Line: 185
    local v28 = p27._gravityPart or p27._zonePart;

    if not v28 then
        return false;
    end;

    local Character = p27._player.Character;

    if not Character then
        return false;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return false;
    end;

    local v29 = v28.CFrame:PointToObjectSpace(HumanoidRootPart.Position);
    local v30 = v28.Size / 2;
    local v31 = math.abs(v29.X) <= v30.X;
    local v32 = v28 == p27._gravityPart and 0 or 10;
    local v33 = math.abs(v29.Y) <= v30.Y + v32;
    local v34 = math.abs(v29.Z) <= v30.Z;

    if v31 then
        if not v33 then
            v34 = v33;
        end;
    else
        v34 = v31;
    end;

    return v34;
end;

function u1._restoreOriginalBody(p35, p36) -- Line: 204
    for _, descendant in ipairs(p36:GetDescendants()) do
        local v37 = descendant:GetAttribute("ChickenOldTransparency");

        if v37 ~= nil then
            descendant.Transparency = v37;
            descendant:SetAttribute("ChickenOldTransparency", nil);
        end;
    end;
end;

function u1._hideOriginalBody(p38, p39, p40) -- Line: 214
    for _, descendant in ipairs(p39:GetDescendants()) do
        if (descendant:IsA("BasePart") or descendant:IsA("Decal")) and not (p40 and descendant:IsDescendantOf(p40)) then
            if descendant:GetAttribute("ChickenOldTransparency") == nil then
                descendant:SetAttribute("ChickenOldTransparency", descendant.Transparency);
            end;

            descendant.Transparency = 1;
        end;
    end;
end;

function u1._getFootPart(p41, p42) -- Line: 225
    return p42:FindFirstChild("LeftFoot", true) or p42:FindFirstChild("RightFoot", true) or (p42:FindFirstChild("LeftLowerLeg", true) or p42:FindFirstChild("RightLowerLeg", true) or (p42:FindFirstChild("Left Leg", true) or p42:FindFirstChild("Right Leg", true)));
end;

function u1._attachCostume(p43, p44) -- Line: 235
    -- upvalues: ReplicatedStorage (copy)
    local HumanoidRootPart = p44:FindFirstChild("HumanoidRootPart");
    local ChickenCostume = ReplicatedStorage:FindFirstChild("ChickenCostume");

    if not (ChickenCostume and HumanoidRootPart) then
        return nil;
    end;

    local v45 = ChickenCostume:Clone();
    v45.Name = "ChickenOutfit_Temp";
    v45.Parent = p44;
    local v46 = v45:FindFirstChildWhichIsA("BasePart");

    if not v46 then
        return nil;
    end;

    v46.Anchored = false;
    v46.CanCollide = false;
    v46.Massless = true;
    local Position = (p43:_getFootPart(p44) or HumanoidRootPart).Position;
    v46.CFrame = HumanoidRootPart.CFrame;
    v46.CFrame = v46.CFrame + Vector3.new(0, Position.Y - (v46.Position.Y - v46.Size.Y / 2), 0);
    local WeldConstraint = Instance.new("WeldConstraint", v46);
    WeldConstraint.Part0 = v46;
    WeldConstraint.Part1 = HumanoidRootPart;
    WeldConstraint.Parent = v46;

    return v45;
end;

function u1._reconcileEffects(p47, p48) -- Line: 266
    -- upvalues: GravityManager (copy), JumpHeightManager (copy), Lighting (copy)
    local v49 = p47._player.Character and v49:FindFirstChildOfClass("Humanoid");

    if p48.NoGravity ~= p47._activeEffects.NoGravity then
        p47._activeEffects.NoGravity = p48.NoGravity;

        if p48.NoGravity then
            GravityManager.set("ConcertZone", p47._originalGravity * 0.1, 100);

            if v49 then
                if v49 ~= p47._boundHumanoid then
                    p47._boundHumanoid = v49;
                    JumpHeightManager.setHumanoid(v49);
                    p47._originalJumpHeight = v49.JumpHeight;
                    p47._originalJumpPower = v49.JumpPower;
                end;

                if v49.UseJumpPower then
                    v49.JumpPower = p47._originalJumpPower * 1.5;
                else
                    JumpHeightManager.set("ConcertZone", p47._originalJumpHeight * 2.5, 100);
                end;
            end;
        else
            GravityManager.release("ConcertZone");
            JumpHeightManager.release("ConcertZone");

            if v49 and p47._originalJumpHeight then
                v49.JumpHeight = p47._originalJumpHeight;
                v49.JumpPower = p47._originalJumpPower;
            end;

            p47._originalJumpHeight = nil;
            p47._originalJumpPower = nil;
            p47._boundHumanoid = nil;
        end;
    end;

    if p48.ChickenParty ~= p47._activeEffects.ChickenParty then
        p47._activeEffects.ChickenParty = p48.ChickenParty;
        p47:_updateAllPlayerChickenOutfits();
    end;

    if p48.FastDay ~= p47._activeEffects.FastDay then
        p47._activeEffects.FastDay = p48.FastDay;

        if not p48.FastDay then
            if p47._isInsideZone then
                Lighting.TimeOfDay = "00:00:00";
            else
                Lighting.TimeOfDay = p47._originalTimeOfDay;
            end;
        end;
    end;

    p47._activeEffects.Spinning = p48.Spinning;
end;

function u1._runFrameEffects(p50, p51) -- Line: 323
    -- upvalues: ConcertSharedConfig (copy), Players (copy), Lighting (copy)
    local v52 = ConcertSharedConfig.SpinSpeed or 10;

    for _, v in ipairs(Players:GetPlayers()) do
        local Character = v.Character;
        local v53;

        if Character then
            v53 = Character:FindFirstChildOfClass("Humanoid");
        else
            v53 = Character;
        end;

        local v54;

        if Character then
            v54 = Character:FindFirstChild("HumanoidRootPart");
        else
            v54 = Character;
        end;

        local v55 = p50._activeEffects.Spinning or p50._activeEffects.ChickenParty;

        if v55 then
            if Character then
                Character = p50:_isCharacterInZone(Character);
            end;
        else
            Character = v55;
        end;

        if Character then
            if v54 and v53 then
                if v53.AutoRotate then
                    v53:SetAttribute("ConcertSpinOldAutoRotate", true);
                    v53.AutoRotate = false;
                end;

                v54.CFrame = v54.CFrame * CFrame.Angles(0, v52 * p51, 0);
            end;
        elseif v53 and v53:GetAttribute("ConcertSpinOldAutoRotate") then
            v53.AutoRotate = true;
            v53:SetAttribute("ConcertSpinOldAutoRotate", nil);
        end;
    end;

    if not p50._activeEffects.FastDay then
        p50._fastDayTime = nil;

        return;
    end;

    local v56 = ConcertSharedConfig.FastDayCycleDuration or 10;
    p50._fastDayTime = (p50._fastDayTime or 0) + p51;
    Lighting.ClockTime = p50._fastDayTime / v56 % 1 * 24;
end;

function u1.destroy(p57) -- Line: 362
    -- upvalues: Players (copy), Lighting (copy)
    p57:_reconcileEffects({
        NoGravity = false,
        Spinning = false,
        ChickenParty = false,
        FastDay = false
    });
    p57:_updateAllPlayerChickenOutfits();

    for _, v in ipairs(Players:GetPlayers()) do
        local v58 = v.Character and v58:FindFirstChildOfClass("Humanoid");

        if v58 and v58:GetAttribute("ConcertSpinOldAutoRotate") then
            v58.AutoRotate = true;
            v58:SetAttribute("ConcertSpinOldAutoRotate", nil);
        end;
    end;

    Lighting.TimeOfDay = p57._originalTimeOfDay;
    p57._zonePart = nil;
    p57._gravityPart = nil;
    p57._lastCharacter = nil;
end;

return u1;