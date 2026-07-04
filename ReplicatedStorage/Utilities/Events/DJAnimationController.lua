-- Ruta Original: ReplicatedStorage.Utilities.Events.DJAnimationController
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Workspace = game:GetService("Workspace");
local u1 = {};
u1.__index = u1;
local u2 = {
    IdleAnimationId = "rbxassetid://139817601640585",
    VibeAnimationId = "rbxassetid://109376391805132",
    VibeEnterThreshold = 0.65,
    VibeExitThreshold = 0.35,
    MinimumVibeDuration = 5,
    RequiredLowEnergyDuration = 5,
    EnergySmoothRate = 2
};

local function ema(p3, p4, p5, p6) -- Line: 39
    return p3 + (1 - math.exp(-p5 * p6)) * (p4 - p3);
end;

function u1.new(p7) -- Line: 48
    -- upvalues: u2 (copy), u1 (copy)
    local v8 = {};

    for i, v in pairs(u2) do
        v8[i] = v;
    end;

    if p7 then
        for i, v in pairs(p7) do
            v8[i] = v;
        end;
    end;

    local v9 = setmetatable({}, u1);
    v9._config = v8;
    v9._mode = "Automatic";
    v9._currentState = "Idle";
    v9._energyAvg = 0;
    v9._timeInCurrentState = 0;
    v9._lowEnergyContinuousTimer = 0;
    v9._tracks = {};
    v9._isInitialized = false;
    v9._initAttempts = 0;

    return v9;
end;

function u1._initNPC(p10) -- Line: 75
    -- upvalues: Workspace (copy)
    if p10._isInitialized then
        return true;
    end;

    local AAX3LL3N_Live = Workspace:FindFirstChild("AAX3LL3N_Live");

    if not AAX3LL3N_Live then
        return false;
    end;

    local X3ll3nScene = AAX3LL3N_Live:FindFirstChild("X3ll3nScene");

    if not X3ll3nScene then
        return false;
    end;

    local X3ll3n = X3ll3nScene:FindFirstChild("X3ll3n");

    if not X3ll3n then
        return false;
    end;

    local Humanoid = X3ll3n:FindFirstChild("Humanoid");

    if not Humanoid then
        return false;
    end;

    local Animator = Humanoid:FindFirstChild("Animator");

    if not Animator then
        Animator = Instance.new("Animator");
        Animator.Parent = Humanoid;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = p10._config.IdleAnimationId;
    p10._tracks.Idle = Animator:LoadAnimation(Animation);
    p10._tracks.Idle.Priority = Enum.AnimationPriority.Movement;
    p10._tracks.Idle.Looped = true;
    local Animation2 = Instance.new("Animation");
    Animation2.AnimationId = p10._config.VibeAnimationId;
    p10._tracks.Vibe = Animator:LoadAnimation(Animation2);
    p10._tracks.Vibe.Priority = Enum.AnimationPriority.Action;
    p10._tracks.Vibe.Looped = true;
    p10._tracks.Idle:Play(0.5);
    p10._isInitialized = true;

    return true;
end;

function u1.setMode(p11, p12) -- Line: 118
    if p12 == "Automatic" or (p12 == "ForcedIdle" or p12 == "ForcedVibe") then
        p11._mode = p12;

        return;
    end;

    warn("[DJAnimationController] Mode invalide : " .. tostring(p12));
end;

function u1._transitionTo(p13, p14) -- Line: 126
    if p13._currentState == p14 then
        return;
    end;

    p13._currentState = p14;
    p13._timeInCurrentState = 0;

    if not p13._isInitialized then
        return;
    end;

    if p14 == "Idle" then
        if p13._tracks.Vibe.IsPlaying then
            p13._tracks.Vibe:Stop(0.5);
        end;

        if not p13._tracks.Idle.IsPlaying then
            p13._tracks.Idle:Play(0.5);
        end;
    elseif p14 == "Vibe" and not p13._tracks.Vibe.IsPlaying then
        p13._tracks.Vibe:Play(0.5);
    end;
end;

function u1.update(p15, p16, p17) -- Line: 148
    if not p15._isInitialized then
        p15._initAttempts = p15._initAttempts + p16;

        if p15._initAttempts > 0.5 then
            p15._initAttempts = 0;
            p15:_initNPC();
        end;

        if not p15._isInitialized then
            return;
        end;
    end;

    p15._timeInCurrentState = p15._timeInCurrentState + p16;

    if p15._mode == "ForcedIdle" then
        p15:_transitionTo("Idle");

        return;
    end;

    if p15._mode == "ForcedVibe" then
        p15:_transitionTo("Vibe");

        return;
    end;

    local _config = p15._config;
    local _energyAvg = p15._energyAvg;
    p15._energyAvg = _energyAvg + (1 - math.exp(-_config.EnergySmoothRate * p16)) * ((p17 or 0) - _energyAvg);

    if p15._currentState == "Idle" then
        if p15._energyAvg > _config.VibeEnterThreshold then
            p15:_transitionTo("Vibe");
            p15._lowEnergyContinuousTimer = 0;
        end;
    elseif p15._currentState == "Vibe" then
        if p15._timeInCurrentState < _config.MinimumVibeDuration then
            p15._lowEnergyContinuousTimer = 0;

            return;
        end;

        if p15._energyAvg < _config.VibeExitThreshold then
            p15._lowEnergyContinuousTimer = p15._lowEnergyContinuousTimer + p16;

            if p15._lowEnergyContinuousTimer >= _config.RequiredLowEnergyDuration then
                p15:_transitionTo("Idle");
            end;
        else
            p15._lowEnergyContinuousTimer = 0;
        end;
    end;
end;

function u1.destroy(p18) -- Line: 203
    for _, v in pairs(p18._tracks) do
        v:Stop();
        v:Destroy();
    end;

    table.clear(p18._tracks);
end;

return u1;