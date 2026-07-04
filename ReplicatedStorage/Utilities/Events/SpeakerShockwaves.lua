-- Ruta Original: ReplicatedStorage.Utilities.Events.SpeakerShockwaves
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local u1 = {};
u1.__index = u1;
local u2 = {
    BeatThreshold = 1.2,
    BeatCooldown = 0.2,
    beatAvgRate = 1.5,
    SmallShockwaveEmitCount = 1,
    BigShockwaveEmitCount = 2,
    MaximumShockwaveMultiplier = 3
};

local function ema(p3, p4, p5, p6) -- Line: 39
    return p3 + (1 - math.exp(-p5 * p6)) * (p4 - p3);
end;

function u1.new(p7) -- Line: 48
    -- upvalues: u2 (copy), u1 (copy)
    local v8 = {};

    for i, v in u2 do
        v8[i] = v;
    end;

    if p7 then
        for i, v in p7 do
            v8[i] = v;
        end;
    end;

    local v9 = setmetatable({}, u1);
    v9._config = v8;
    v9._speakers = {};
    v9._connections = {};
    v9._beatAvg = 0;
    v9._beatCooldownTimer = 0;
    v9:_initCollectionService();

    return v9;
end;

function u1._cacheSpeaker(p10, p11) -- Line: 76
    if not p11:IsA("Model") then
        return;
    end;

    local v12 = {
        model = p11,
        smallEmitters = {},
        bigEmitters = {}
    };
    local CircleBeamSmall = p11:FindFirstChild("CircleBeamSmall");

    if CircleBeamSmall then
        local Main = CircleBeamSmall:FindFirstChild("Main");

        if Main then
            for _, child in ipairs(Main:GetChildren()) do
                if child:IsA("ParticleEmitter") and child.Name == "ShockWave" then
                    table.insert(v12.smallEmitters, child);
                end;
            end;
        end;
    end;

    local CircleBeamBig = p11:FindFirstChild("CircleBeamBig");

    if CircleBeamBig then
        local Main = CircleBeamBig:FindFirstChild("Main");

        if Main then
            for _, child in ipairs(Main:GetChildren()) do
                if child:IsA("ParticleEmitter") and child.Name == "ShockWave" then
                    table.insert(v12.bigEmitters, child);
                end;
            end;
        end;
    end;

    if #v12.smallEmitters > 0 or #v12.bigEmitters > 0 then
        p10._speakers[p11] = v12;
    end;
end;

function u1._initCollectionService(u13) -- Line: 116
    -- upvalues: CollectionService (copy)
    for _, v in ipairs({ "Speaker", "MiniSpeaker" }) do
        for _, v2 in ipairs(CollectionService:GetTagged(v)) do
            u13:_cacheSpeaker(v2);
        end;

        local v15 = CollectionService:GetInstanceAddedSignal(v):Connect(function(p14) -- Line: 126
            -- upvalues: u13 (copy)
            u13:_cacheSpeaker(p14);
        end);
        local v17 = CollectionService:GetInstanceRemovedSignal(v):Connect(function(p16) -- Line: 130
            -- upvalues: u13 (copy)
            u13._speakers[p16] = nil;
        end);
        table.insert(u13._connections, v15);
        table.insert(u13._connections, v17);
    end;
end;

function u1.update(p18, p19, p20) -- Line: 140
    local _config = p18._config;
    local v21 = p20 or 0;
    local _beatAvg = p18._beatAvg;
    p18._beatAvg = _beatAvg + (1 - math.exp(-_config.beatAvgRate * p19)) * (v21 - _beatAvg);
    p18._beatCooldownTimer = math.max(0, p18._beatCooldownTimer - p19);
    local v22, v23;

    if p18._beatCooldownTimer <= 0 and (p18._beatAvg > 0.02 and p18._beatAvg * _config.BeatThreshold < v21) then
        p18._beatCooldownTimer = _config.BeatCooldown;
        v22 = math.clamp(v21 / (p18._beatAvg * _config.BeatThreshold), 1, _config.MaximumShockwaveMultiplier);
        v23 = true;
    else
        v23 = false;
        v22 = 1;
    end;

    if v23 then
        local v24 = math.floor(_config.SmallShockwaveEmitCount * v22 + 0.5);
        local v25 = math.floor(_config.BigShockwaveEmitCount * v22 + 0.5);

        for _, v in pairs(p18._speakers) do
            if v24 > 0 then
                for _, v2 in ipairs(v.smallEmitters) do
                    v2:Emit(v24);
                end;
            end;

            if v25 > 0 then
                for _, v2 in ipairs(v.bigEmitters) do
                    v2:Emit(v25);
                end;
            end;
        end;
    end;
end;

function u1.destroy(p26) -- Line: 183
    for _, v in ipairs(p26._connections) do
        v:Disconnect();
    end;

    table.clear(p26._connections);
    table.clear(p26._speakers);
end;

return u1;