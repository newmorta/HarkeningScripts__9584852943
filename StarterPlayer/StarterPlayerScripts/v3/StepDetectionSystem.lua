-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.StepDetectionSystem
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TextChatService = game:GetService("TextChatService");
local Config = require(ReplicatedStorage:WaitForChild("Config"));
local TrailConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("TrailConfig"));
local EventsConfig = require(ReplicatedStorage:WaitForChild("EventsConfig"));
local NotificationSystem = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));

local function getTrailMult(p1) -- Line: 14
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
local UpdateSpeed = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("UpdateSpeed");
local u3 = 0;
local u4 = LocalPlayer.UserId ~= 3845375404;

if LocalPlayer.UserId == 3845375404 then
    local TextChatCommand = Instance.new("TextChatCommand");
    TextChatCommand.Name = "ProgressionToggle";
    TextChatCommand.PrimaryAlias = "/progression";
    TextChatCommand.Parent = TextChatService;
    TextChatCommand.Triggered:Connect(function() -- Line: 42
        -- upvalues: u4 (ref)
        u4 = not u4;
        print("[Admin] Progression " .. (u4 and "ACTIVÉE" or "DÉSACTIVÉE"));
    end);
end;

RunService.Heartbeat:Connect(function() -- Line: 53
    -- upvalues: u4 (ref), LocalPlayer (copy), ClientState (copy), Config (copy), u3 (ref), UpdateSpeed (copy), getTrailMult (copy), NotificationSystem (copy)
    if not u4 then
        return;
    end;

    local v5 = LocalPlayer.Character and v5:FindFirstChild("Humanoid");
    local v6 = ClientState:Get();

    if not v5 or (v5.Health <= 0 or v6.onTreadmill) then
        return;
    end;

    if v5.MoveDirection.Magnitude > 0 then
        local v7 = os.clock();
        local XP_TIME_BASED = Config.XP_TIME_BASED;
        local v8 = math.clamp((v5.WalkSpeed - XP_TIME_BASED.MIN_SPEED) / (XP_TIME_BASED.MAX_SPEED - XP_TIME_BASED.MIN_SPEED), 0, 1);

        if XP_TIME_BASED.MAX_COOLDOWN - v8 * (XP_TIME_BASED.MAX_COOLDOWN - XP_TIME_BASED.MIN_COOLDOWN) <= v7 - u3 then
            UpdateSpeed:FireServer("Walking");
            local v9 = ClientState:Get();
            local v10 = getTrailMult(v9.EquippedTrail or "None");
            NotificationSystem:ShowPlusOne(v9.StepBonus, v9.Multiplier, v9.SpeedBoostMultiplier, v10, 1, v9.BonusXPMultiplier or 1);
            u3 = v7;
        end;
    else
        u3 = 0;
    end;
end);