-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.TreadmillSystem
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local StarterPlayer = game:GetService("StarterPlayer");
local PersonalTreadmill = require(StarterPlayer.StarterPlayerScripts.PersonalTreadmill);
local Config = require(ReplicatedStorage:WaitForChild("Config"));
local TrailConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("TrailConfig"));
local EventsConfig = require(ReplicatedStorage:WaitForChild("EventsConfig"));
local NotificationSystem = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));

local function getTrailMult(p1) -- Line: 15
    -- upvalues: TrailConfig (copy), EventsConfig (copy)
    local v2 = TrailConfig.TRAILS[p1];

    if not v2 then
        for _, v in ipairs(EventsConfig.Trails or {}) do
            if v.Key == p1 then
                v2 = v;
                break;
            end;
        end;
    end;

    return v2 and v2.Multiplier or 1;
end;

local LocalPlayer = Players.LocalPlayer;
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local UpdateSpeed = Remotes:WaitForChild("UpdateSpeed");
local PromptGoldTreadmill = Remotes:WaitForChild("PromptGoldTreadmill");
local PromptDiamondTreadmill = Remotes:WaitForChild("PromptDiamondTreadmill");
local PromptCandyTreadmill = Remotes:WaitForChild("PromptCandyTreadmill");
local PromptAdminTreadmill = Remotes:WaitForChild("PromptAdminTreadmill");
local TreadmillSignal = Remotes:WaitForChild("TreadmillSignal");
local u3 = false;
local u4 = nil;
local u5 = 0;
local u6 = nil;
local u7 = require(ReplicatedStorage:WaitForChild("Treadmill"):WaitForChild("Raycast")).getTreadmillFilter();

local function checkFloor() -- Line: 49
    -- upvalues: LocalPlayer (copy), u7 (copy), CollectionService (copy)
    local v8 = LocalPlayer.Character and v8:FindFirstChild("HumanoidRootPart");

    if not v8 then
        return nil;
    end;

    local v9 = workspace:Raycast(v8.Position, Vector3.new(0, -7, 0), u7);

    if v9 and v9.Instance then
        local Instance = v9.Instance;

        if CollectionService:HasTag(Instance, "AdminTreadmill") then
            return "Admin";
        end;

        if CollectionService:HasTag(Instance, "AdminAbuseTreadmill") then
            return "AdminAbuse";
        end;

        if CollectionService:HasTag(Instance, "CandyTreadmill") then
            return "Candy";
        end;

        if CollectionService:HasTag(Instance, "DiamondTreadmill") then
            return "Diamond";
        end;

        if CollectionService:HasTag(Instance, "GoldTreadmill") then
            return "Gold";
        end;

        if CollectionService:HasTag(Instance, "AATreadmillX3ll3n") then
            return "AATreadmillX3ll3n";
        end;

        if CollectionService:HasTag(Instance, "HourlyTreadmill") then
            return "Hourly";
        end;

        if CollectionService:HasTag(Instance, "Treadmill") then
            return "Normal";
        end;

        if CollectionService:HasTag(Instance, "VoidTreadmillAAChichine") then
            return "VoidTreadmillAAChichine";
        end;

        if CollectionService:HasTag(Instance, "AdminAbuse_IndependanceTreadmill") then
            return "AdminAbuse_IndependanceTreadmill";
        end;
    end;

    return nil;
end;

LocalPlayer.CharacterAdded:Connect(function() -- Line: 79
    -- upvalues: u6 (ref), u3 (ref), u4 (ref)
    u6 = nil;
    u3 = false;
    u4 = nil;
end);
RunService.Heartbeat:Connect(function() -- Line: 91
    -- upvalues: PersonalTreadmill (copy), LocalPlayer (copy), checkFloor (copy), u3 (ref), u4 (ref), TreadmillSignal (copy), ClientState (copy), Config (copy), u5 (ref), getTrailMult (copy), UpdateSpeed (copy), NotificationSystem (copy), PromptAdminTreadmill (copy), PromptCandyTreadmill (copy), PromptDiamondTreadmill (copy), PromptGoldTreadmill (copy)
    if PersonalTreadmill:isActive() then
        return;
    end;

    local v10 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid");

    if not v10 or v10.Health <= 0 then
        return;
    end;

    local v11 = checkFloor();
    local v12 = v11 ~= nil;

    if v12 ~= u3 then
        u3 = v12;
        u4 = v11;
        TreadmillSignal:FireServer(u3);
    end;

    if u3 then
        local v13 = os.clock();
        local v14 = ClientState:Get();
        local XP_TIME_BASED = Config.XP_TIME_BASED;
        local v15 = math.clamp((v10.WalkSpeed - XP_TIME_BASED.MIN_SPEED) / (XP_TIME_BASED.MAX_SPEED - XP_TIME_BASED.MIN_SPEED), 0, 1);

        if XP_TIME_BASED.MAX_COOLDOWN - v15 * (XP_TIME_BASED.MAX_COOLDOWN - XP_TIME_BASED.MIN_COOLDOWN) <= v13 - u5 then
            local v16 = getTrailMult(v14.EquippedTrail or "None");

            if u4 == "Admin" then
                if v14.AdminTreadmillActive then
                    UpdateSpeed:FireServer("AdminTreadmill");
                    NotificationSystem:ShowPlusOne(v14.StepBonus, v14.Multiplier, v14.SpeedBoostMultiplier, v16, 100, v14.BonusXPMultiplier or 1);
                else
                    PromptAdminTreadmill:FireServer();
                    u3 = false;
                end;
            elseif u4 == "AdminAbuse" then
                UpdateSpeed:FireServer("AdminAbuseTreadmill");
                NotificationSystem:ShowPlusOne(v14.StepBonus, v14.Multiplier, v14.SpeedBoostMultiplier, v16, 120, v14.BonusXPMultiplier or 1);
            elseif u4 == "Candy" then
                if v14.CandyTreadmillActive then
                    UpdateSpeed:FireServer("CandyTreadmill");
                    NotificationSystem:ShowPlusOne(v14.StepBonus, v14.Multiplier, v14.SpeedBoostMultiplier, v16, 25, v14.BonusXPMultiplier or 1);
                else
                    PromptCandyTreadmill:FireServer();
                    u3 = false;
                end;
            elseif u4 == "Diamond" then
                if v14.DiamondTreadmillActive then
                    UpdateSpeed:FireServer("DiamondTreadmill");
                    NotificationSystem:ShowPlusOne(v14.StepBonus, v14.Multiplier, v14.SpeedBoostMultiplier, v16, 9, v14.BonusXPMultiplier or 1);
                else
                    PromptDiamondTreadmill:FireServer();
                    u3 = false;
                end;
            elseif u4 == "Gold" then
                if v14.GoldTreadmillActive then
                    UpdateSpeed:FireServer("GoldTreadmill");
                    NotificationSystem:ShowPlusOne(v14.StepBonus, v14.Multiplier, v14.SpeedBoostMultiplier, v16, 3, v14.BonusXPMultiplier or 1);
                else
                    PromptGoldTreadmill:FireServer();
                    u3 = false;
                end;
            elseif u4 == "AATreadmillX3ll3n" then
                if game:GetService("Workspace"):FindFirstChild("AAX3LL3N_Live") then
                    UpdateSpeed:FireServer("AATreadmillX3ll3n");
                    NotificationSystem:ShowPlusOne(v14.StepBonus, v14.Multiplier, v14.SpeedBoostMultiplier, v16, 150, v14.BonusXPMultiplier or 1);
                else
                    u3 = false;
                end;
            elseif u4 == "Hourly" then
                if workspace:FindFirstChild("HourlyTreadmill_Active") then
                    UpdateSpeed:FireServer("HourlyTreadmill");
                    NotificationSystem:ShowPlusOne(v14.StepBonus, v14.Multiplier, v14.SpeedBoostMultiplier, v16, 5, v14.BonusXPMultiplier or 1);
                else
                    u3 = false;
                end;
            elseif u4 == "VoidTreadmillAAChichine" then
                UpdateSpeed:FireServer("VoidTreadmillAAChichine");
                NotificationSystem:ShowPlusOne(v14.StepBonus, v14.Multiplier, v14.SpeedBoostMultiplier, v16, 150, v14.BonusXPMultiplier or 1);
            elseif u4 == "AdminAbuse_IndependanceTreadmill" then
                UpdateSpeed:FireServer("AdminAbuse_IndependanceTreadmill");
                NotificationSystem:ShowPlusOne(v14.StepBonus, v14.Multiplier, v14.SpeedBoostMultiplier, v16, 150, v14.BonusXPMultiplier or 1);
            else
                UpdateSpeed:FireServer("Treadmill");
                NotificationSystem:ShowPlusOne(v14.StepBonus, v14.Multiplier, v14.SpeedBoostMultiplier, v16, 1, v14.BonusXPMultiplier or 1);
            end;

            u5 = v13;
        end;
    end;
end);