-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.InteractionSystem
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Config = require(ReplicatedStorage:WaitForChild("Config"));
local Numbers = require(ReplicatedStorage.Utilities.Numbers);
local NotificationSystem = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local GiftUISystem = require(ReplicatedStorage:WaitForChild("GiftUISystem"));
local LocalPlayer = Players.LocalPlayer;
local EquipStepAward = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("EquipStepAward");
local u1 = false;
local u2 = {};
local u3 = {};
local u4 = false;
local u5 = nil;
local u6 = false;

local function connectStepAward(p7) -- Line: 26
    -- upvalues: u2 (copy), Config (copy), u3 (copy), LocalPlayer (copy), u1 (ref), ClientState (copy), EquipStepAward (copy), NotificationSystem (copy), Numbers (copy)
    if u2[p7] then
        return;
    end;

    local u8 = p7:GetAttribute("AwardID");
    local u9 = Config.STEP_AWARDS[u8];

    if u9 then
        u2[p7] = true;
        u3[p7] = u9;
        task.defer(function() -- Line: 38
            if _G.RefreshAwardVisuals then
                _G.RefreshAwardVisuals();
            end;
        end);
        p7.Touched:Connect(function(p10) -- Line: 44
            -- upvalues: LocalPlayer (ref), u1 (ref), ClientState (ref), u9 (copy), EquipStepAward (ref), u8 (copy), NotificationSystem (ref), Numbers (ref)
            local Character = LocalPlayer.Character;

            if Character and (p10:IsDescendantOf(Character) and not u1) then
                u1 = true;
                local v11 = ClientState:Get();
                local v12 = v11.Wins or 0;
                local v13 = v11.StepBonus or 1;
                local v14 = tonumber(u9.ReqWins) or 0;

                if v14 <= v12 then
                    if v13 ~= u9.Bonus then
                        EquipStepAward:FireServer(u8);
                        NotificationSystem:ShowMessage("EQUIPPED! +" .. Numbers.formatNumber(u9.Bonus) .. "/step", Color3.fromRGB(0, 255, 100));
                        ClientState:Update({
                            StepBonus = u9.Bonus
                        });
                        _G.RefreshAwardVisuals();
                    end;
                else
                    NotificationSystem:ShowMessage("Need " .. Numbers.formatNumber(v14) .. " Wins!", Color3.fromRGB(255, 100, 100));
                end;

                task.delay(0.5, function() -- Line: 71
                    -- upvalues: u1 (ref)
                    u1 = false;
                end);
            end;
        end);
    end;
end;

local function startStepAwards() -- Line: 77
    -- upvalues: u4 (ref), CollectionService (copy), connectStepAward (copy)
    if u4 then
        return;
    end;

    u4 = true;

    for _, v in ipairs(CollectionService:GetTagged("StepAward")) do
        connectStepAward(v);
    end;

    if _G.RefreshAwardVisuals then
        _G.RefreshAwardVisuals();
    end;
end;

local function waitForStepAwardsReady() -- Line: 92
    -- upvalues: ReplicatedStorage (copy)
    if ReplicatedStorage:GetAttribute("StepAwardsReady") then
        return;
    end;

    ReplicatedStorage:GetAttributeChangedSignal("StepAwardsReady"):Wait();
end;

local function getGiftModal() -- Line: 100
    -- upvalues: u5 (ref), CollectionService (copy), LocalPlayer (copy)
    if u5 then
        return u5;
    end;

    local v15 = CollectionService:GetTagged("GiftModal");

    for _, v in ipairs(v15) do
        if v:IsDescendantOf(LocalPlayer:WaitForChild("PlayerGui")) then
            u5 = v;

            return v;
        end;
    end;

    return nil;
end;

local function connectGiftChest(p16) -- Line: 113
    -- upvalues: u6 (ref), getGiftModal (copy), GiftUISystem (copy), ClientState (copy)
    local v17 = p16:IsA("ProximityPrompt") and p16 and p16 or p16:FindFirstChildOfClass("ProximityPrompt");

    if not v17 then
        return;
    end;

    v17.Triggered:Connect(function() -- Line: 117
        -- upvalues: u6 (ref), getGiftModal (ref), GiftUISystem (ref), ClientState (ref)
        if u6 then
            return;
        end;

        u6 = true;
        local v18 = getGiftModal();

        if not v18 then
            task.wait(0.2);
            v18 = getGiftModal();
        end;

        if v18 then
            GiftUISystem:InitLogic();
            ClientState:ToggleModal(v18, GiftUISystem);
        else
            warn("⚠️ Problème : GiftModal introuvable dans PlayerGui");
        end;

        task.delay(0.5, function() -- Line: 135
            -- upvalues: u6 (ref)
            u6 = false;
        end);
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("GiftChest")) do
    connectGiftChest(v);
end;

CollectionService:GetInstanceAddedSignal("GiftChest"):Connect(connectGiftChest);
CollectionService:GetInstanceAddedSignal("StepAward"):Connect(function(p19) -- Line: 145
    -- upvalues: u4 (ref), connectStepAward (copy)
    if u4 then
        connectStepAward(p19);
    end;
end);
task.spawn(function() -- Line: 151
    -- upvalues: ReplicatedStorage (copy), startStepAwards (copy)
    if not ReplicatedStorage:GetAttribute("StepAwardsReady") then
        ReplicatedStorage:GetAttributeChangedSignal("StepAwardsReady"):Wait();
    end;

    startStepAwards();
end);

function _G.RefreshAwardVisuals() -- Line: 157
    -- upvalues: ClientState (copy), CollectionService (copy), Config (copy)
    local v20 = ClientState:Get();
    local v21 = v20.StepBonus or 1;
    local v22 = v20.Wins or 0;
    local v23 = CollectionService:GetTagged("StepAward");

    for _, v in ipairs(v23) do
        local v24 = v:GetAttribute("AwardID");
        local v25 = Config.STEP_AWARDS[v24];

        if v25 then
            local v26 = tonumber(v25.ReqWins) or 0;

            if v25.Bonus == v21 then
                v.BrickColor = Config.COLORS.AWARD_EQUIPPED;
            elseif v22 < v26 then
                v.BrickColor = Config.COLORS.AWARD_LOCKED;
            else
                v.BrickColor = Config.COLORS.AWARD_DEFAULT;
            end;
        end;
    end;
end;

task.delay(1.5, function() -- Line: 185
    if _G.RefreshAwardVisuals then
        _G.RefreshAwardVisuals();
    end;
end);