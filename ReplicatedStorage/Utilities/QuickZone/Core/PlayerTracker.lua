-- Ruta Original: ReplicatedStorage.Utilities.QuickZone.Core.PlayerTracker
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local State = require(script.Parent.State);
local u1 = {};
local u2 = {};
local v3 = {};

local function trackPlayer(u4) -- Line: 13
    -- upvalues: u1 (copy), u2 (copy), State (copy)
    if u1[u4] then
        return;
    end;

    local u5 = nil;
    local u6 = nil;
    local u7 = nil;
    local u8 = nil;

    local function clearHrp(p9) -- Line: 23
        -- upvalues: u8 (ref), u6 (ref), u2 (ref), u4 (copy), State (ref)
        if p9 and p9 ~= u8 then
            return;
        end;

        if u6 then
            u6:Disconnect();
            u6 = nil;
        end;

        if u8 then
            local v10 = u2[u4];

            if v10 then
                for i, v in v10 do
                    if State.groups[i] then
                        v:_remove(u8);
                    else
                        v10[i] = nil;
                    end;
                end;
            end;

            State.entityToReference[u8] = nil;

            if State.referenceToEntity[u4] == u8 then
                State.referenceToEntity[u4] = nil;
            end;

            u8 = nil;
        end;
    end;

    local function clearCharacter() -- Line: 53
        -- upvalues: clearHrp (copy), u5 (ref), u7 (ref)
        clearHrp();

        if u5 then
            u5:Disconnect();
            u5 = nil;
        end;

        u7 = nil;
    end;

    local function checkHrp(p11) -- Line: 62
        -- upvalues: u7 (ref), u8 (ref), clearHrp (copy), State (ref), u4 (copy), u2 (ref), u6 (ref)
        if p11 ~= u7 then
            return;
        end;

        local HumanoidRootPart = p11:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart and (HumanoidRootPart:IsA("BasePart") and HumanoidRootPart ~= u8) then
            clearHrp();
            u8 = HumanoidRootPart;
            State.entityToReference[HumanoidRootPart] = u4;
            State.referenceToEntity[u4] = HumanoidRootPart;
            local v12 = u2[u4];

            if v12 then
                for i, v in v12 do
                    if State.groups[i] then
                        v:_add(HumanoidRootPart);
                    else
                        v12[i] = nil;
                    end;
                end;
            end;

            u6 = HumanoidRootPart.AncestryChanged:Connect(function(p13, p14) -- Line: 88
                -- upvalues: clearHrp (ref), HumanoidRootPart (copy)
                if not p14 then
                    clearHrp(HumanoidRootPart);
                end;
            end);
        end;
    end;

    local u17 = u4.CharacterAdded:Connect(function(u15) -- Line: 96, Name: onCharacterAdded
        -- upvalues: clearHrp (copy), u5 (ref), u7 (ref), checkHrp (copy)
        clearHrp();

        if u5 then
            u5:Disconnect();
            u5 = nil;
        end;

        u7 = nil;
        u7 = u15;
        checkHrp(u15);
        u5 = u15.ChildAdded:Connect(function(p16) -- Line: 102
            -- upvalues: checkHrp (ref), u15 (copy)
            if p16.Name == "HumanoidRootPart" then
                checkHrp(u15);
            end;
        end);
    end);
    local u19 = u4.CharacterRemoving:Connect(function(p18) -- Line: 110
        -- upvalues: u7 (ref), clearHrp (copy), u5 (ref)
        if u7 == p18 then
            clearHrp();

            if u5 then
                u5:Disconnect();
                u5 = nil;
            end;

            u7 = nil;
        end;
    end);

    u1[u4] = function() -- Line: 116
        -- upvalues: u17 (copy), u19 (copy), clearHrp (copy), u5 (ref), u7 (ref)
        u17:Disconnect();
        u19:Disconnect();
        clearHrp();

        if u5 then
            u5:Disconnect();
            u5 = nil;
        end;

        u7 = nil;
    end;

    if u4.Character then
        local Character = u4.Character;
        clearHrp();

        if u5 then
            u5:Disconnect();
            u5 = nil;
        end;

        u7 = nil;
        u7 = Character;
        checkHrp(Character);
        u5 = Character.ChildAdded:Connect(function(p20) -- Line: 102
            -- upvalues: checkHrp (copy), Character (copy)
            if p20.Name == "HumanoidRootPart" then
                checkHrp(Character);
            end;
        end);
    end;
end;

function v3.subscribe(p21, p22) -- Line: 127
    -- upvalues: u2 (copy), trackPlayer (copy), State (copy)
    if not u2[p21] then
        u2[p21] = {};
    end;

    u2[p21][p22.id] = p22;
    trackPlayer(p21);
    local v23 = State.referenceToEntity[p21];

    if v23 then
        p22:_add(v23);
    end;
end;

function v3.unsubscribe(p24, p25) -- Line: 141
    -- upvalues: u2 (copy), State (copy)
    if u2[p24] then
        u2[p24][p25.id] = nil;
    end;

    local v26 = State.referenceToEntity[p24];

    if v26 then
        p25:_remove(v26);
    end;
end;

Players.PlayerRemoving:Connect(function(p27) -- Line: 152
    -- upvalues: u1 (copy), u2 (copy)
    local v28 = u1[p27];

    if v28 then
        v28();
    end;

    u1[p27] = nil;
    u2[p27] = nil;
end);

return v3;