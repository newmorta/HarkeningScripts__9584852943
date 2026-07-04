-- Ruta Original: StarterPlayer.StarterPlayerScripts.PersonalTreadmill
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Config = require(ReplicatedStorage:WaitForChild("Config"));
local TrailConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("TrailConfig"));
local NotificationSystem = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local SoundManager = require(ReplicatedStorage:WaitForChild("SoundManager"));
local PersonalTreadmill = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("PersonalTreadmill"));
local LocalPlayer = Players.LocalPlayer;
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local PersonalTreadmillStep = Remotes:WaitForChild("PersonalTreadmillStep");
local PersonalTreadmillSync = Remotes:WaitForChild("PersonalTreadmillSync");
local TreadmillSignal = Remotes:WaitForChild("TreadmillSignal");
local u2 = false;
local u3 = nil;
local u4 = 1;
local u5 = 0;
local u6 = false;

local function getTrailMult(p7) -- Line: 38
    -- upvalues: TrailConfig (copy)
    local v8 = TrailConfig.TRAILS[p7];

    return v8 and v8.Multiplier or 1;
end;

local function easeOutBack(p9) -- Line: 53
    return (p9 - 1) ^ 3 * 2.70158 + 1 + (p9 - 1) ^ 2 * 1.70158;
end;

local function playBounce(p10) -- Line: 59
    -- upvalues: RunService (copy)
    local v11 = p10:GetScale();
    p10:ScaleTo(v11 * 0.5);
    local v12 = 0;

    while v12 < 0.3 do
        v12 = v12 + RunService.Heartbeat:Wait();
        local v13 = math.clamp(v12 / 0.3, 0, 1);
        p10:ScaleTo(v11 * (((v13 - 1) ^ 3 * 2.70158 + 1 + (v13 - 1) ^ 2 * 1.70158) * 0.5 + 0.5));
    end;

    p10:ScaleTo(v11);
end;

local u14 = setmetatable({}, {
    __mode = "k"
});

local function handleMat(u15) -- Line: 74
    -- upvalues: u14 (copy), LocalPlayer (copy), playBounce (copy)
    if not u15:IsA("Model") or u14[u15] then
        return;
    end;

    u14[u15] = true;
    print(u15);
    local u16 = false;

    local function refreshOwner() -- Line: 89
        -- upvalues: u16 (ref), u15 (copy), LocalPlayer (ref)
        u16 = u15:GetAttribute("OwnerUserId") == LocalPlayer.UserId;
        print(u16);

        if u16 then
            for _, descendant in ipairs(u15:GetDescendants()) do
                if u16 and descendant:IsA("BasePart") then
                    descendant.CanCollide = true;
                end;
            end;
        end;
    end;

    local u18 = u15.DescendantAdded:Connect(function(p17) -- Line: 84, Name: applyCollision
        -- upvalues: u16 (ref)
        if u16 and p17:IsA("BasePart") then
            p17.CanCollide = true;
        end;
    end);
    local u19 = u15:GetAttributeChangedSignal("OwnerUserId"):Connect(refreshOwner);
    refreshOwner();
    u15.Destroying:Once(function() -- Line: 107
        -- upvalues: u18 (copy), u19 (copy)
        u18:Disconnect();
        u19:Disconnect();
    end);
    task.defer(function() -- Line: 113
        -- upvalues: playBounce (ref), u15 (copy)
        playBounce(u15);
    end);
end;

function v1.init(p20) -- Line: 120
    -- upvalues: PersonalTreadmill (copy), handleMat (copy), PersonalTreadmillSync (copy), u2 (ref), u3 (ref), u4 (ref), SoundManager (copy), LocalPlayer (copy), u6 (ref), RunService (copy), TreadmillSignal (copy), Config (copy), u5 (ref), PersonalTreadmillStep (copy), ClientState (copy), TrailConfig (copy), NotificationSystem (copy)
    task.spawn(function() -- Line: 122
        -- upvalues: PersonalTreadmill (ref), handleMat (ref)
        local v21 = workspace:WaitForChild(PersonalTreadmill.WORKSPACE_FOLDER, 30);

        if not v21 then
            return;
        end;

        for _, child in ipairs(v21:GetChildren()) do
            handleMat(child);
        end;

        v21.ChildAdded:Connect(handleMat);
    end);
    PersonalTreadmillSync.OnClientEvent:Connect(function(p22) -- Line: 135
        -- upvalues: u2 (ref), u3 (ref), u4 (ref), SoundManager (ref)
        u2 = p22.active == true;

        if not u2 then
            u3 = nil;

            return;
        end;

        u3 = p22.pos;
        u4 = p22.mult or 1;
        SoundManager:Play("SUCCESS");
    end);
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 151
        -- upvalues: u2 (ref), u3 (ref), u6 (ref)
        u2 = false;
        u3 = nil;
        u6 = false;
    end);
    RunService.Heartbeat:Connect(function() -- Line: 161
        -- upvalues: LocalPlayer (ref), u2 (ref), u3 (ref), PersonalTreadmill (ref), u6 (ref), TreadmillSignal (ref), Config (ref), u5 (ref), PersonalTreadmillStep (ref), ClientState (ref), TrailConfig (ref), NotificationSystem (ref), u4 (ref)
        local Character = LocalPlayer.Character;
        local v23;

        if Character then
            v23 = Character:FindFirstChildOfClass("Humanoid");
        else
            v23 = Character;
        end;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if not v23 or (not Character or v23.Health <= 0) then
            return;
        end;

        if u2 and u3 then
            local v24 = (Vector3.new(Character.Position.X, 0, Character.Position.Z) - Vector3.new(u3.X, 0, u3.Z)).Magnitude <= PersonalTreadmill.STEP_DISTANCE;

            if v24 ~= u6 then
                u6 = v24;
                TreadmillSignal:FireServer(v24);
            end;

            if v24 then
                local v25 = os.clock();
                local XP_TIME_BASED = Config.XP_TIME_BASED;
                local v26 = math.clamp((v23.WalkSpeed - XP_TIME_BASED.MIN_SPEED) / (XP_TIME_BASED.MAX_SPEED - XP_TIME_BASED.MIN_SPEED), 0, 1);

                if XP_TIME_BASED.MAX_COOLDOWN - v26 * (XP_TIME_BASED.MAX_COOLDOWN - XP_TIME_BASED.MIN_COOLDOWN) <= v25 - u5 then
                    u5 = v25;
                    PersonalTreadmillStep:FireServer();
                    local v27 = ClientState:Get();
                    local v28 = TrailConfig.TRAILS[v27.EquippedTrail or "None"];
                    NotificationSystem:ShowPlusOne(v27.StepBonus, v27.Multiplier, v27.SpeedBoostMultiplier, v28 and v28.Multiplier or 1, u4, v27.BonusXPMultiplier or 1);
                end;
            end;
        elseif u6 then
            u6 = false;
            TreadmillSignal:FireServer(false);
        end;
    end);
end;

function v1.isActive(p29) -- Line: 203
    -- upvalues: u2 (ref)
    return u2;
end;

return v1;