-- Ruta Original: ReplicatedStorage.Utilities.Events.LaserSweep
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local u2 = {
    Sweep = {}
};

function u2.Sweep.init(p3, p4) -- Line: 36
    p3.phase = math.random();
    p3.direction = math.random() > 0.5 and 1 or -1;
    p3.speedMult = p4.speedVariationMin + math.random() * (p4.speedVariationMax - p4.speedVariationMin);
    p3.burst = 1;
end;

function u2.Sweep.update(p5, p6, p7, p8, p9) -- Line: 44
    if p8 then
        p5.burst = p9.beatBurstMultiplier;

        if math.random() > 0.5 then
            p5.direction = -p5.direction;
        end;
    end;

    local v10 = math.exp(-p9.beatBurstDecayRate * p6);
    p5.burst = 1 + (p5.burst - 1) * v10;
    local v11 = p7 <= 0.01 and 0 or (p9.baseSpeed + (p9.maxSpeed - p9.baseSpeed) * p7) * p5.speedMult * p5.burst;

    if v11 > 0 then
        p5.phase = p5.phase + p5.direction * v11 * p6;
    end;

    if p5.phase >= 1 then
        p5.phase = 2 - p5.phase;
        p5.direction = -1;
    elseif p5.phase <= 0 then
        p5.phase = -p5.phase;
        p5.direction = 1;
    end;

    p5.phase = math.clamp(p5.phase, 0, 1);
    p5.baseModel:PivotTo(p5.baseCFrame * CFrame.Angles(0, math.rad(p9.minAngleDeg + p5.phase * (p9.maxAngleDeg - p9.minAngleDeg)), 0));
end;

u2.Blackout = {};

function u2.Blackout.init(p12, p13) -- Line: 91
end;

function u2.Blackout.update(p14, p15, p16, p17, p18) -- Line: 93
    p14.baseModel:PivotTo(p14.baseCFrame * CFrame.Angles(-1.5707963267948966, 0, 0));
end;

local u19 = {
    pattern = "Sweep",
    minAngleDeg = 90,
    maxAngleDeg = -90,
    baseSpeed = 0.1,
    maxSpeed = 0.55,
    peakSmoothRate = 8,
    beatAvgRate = 1.5,
    beatThreshold = 1.8,
    beatCooldown = 0.3,
    beatBurstMultiplier = 2.2,
    beatBurstDecayRate = 4,
    speedVariationMin = 0.82,
    speedVariationMax = 1.18,
    colorCycle = false,
    colorCycleMinSec = 3,
    colorCycleMaxSec = 8,
    colorPalette = {}
};

local function ema(p20, p21, p22, p23) -- Line: 140
    return p20 + (1 - math.exp(-p22 * p23)) * (p21 - p20);
end;

local function pickRandomColor(p24, p25) -- Line: 145
    local v26 = p24[math.random(1, #p24)];

    if v26 == p25 and #p24 > 1 then
        for _, v in p24 do
            if v ~= p25 then
                return v;
            end;
        end;
    end;

    return v26;
end;

function u1.new(p27) -- Line: 164
    -- upvalues: u19 (copy), u1 (copy), u2 (copy)
    local v28 = {};

    for i, v in u19 do
        v28[i] = v;
    end;

    if p27 then
        for i, v in p27 do
            v28[i] = v;
        end;
    end;

    local v29 = setmetatable({}, u1);
    v29._config = v28;
    v29._lasers = {};
    v29._pattern = u2[v28.pattern];
    v29._smoothedPeak = 0;
    v29._beatAvg = 0;
    v29._beatCooldownTimer = 0;

    if not v29._pattern then
        warn(string.format("[LaserSweep] Pattern \'%s\' inconnu, aucune animation.", (tostring(v28.pattern))));
    end;

    return v29;
end;

function u1.setPattern(p30, p31) -- Line: 192
    -- upvalues: u2 (copy)
    p30._config.pattern = p31;

    if u2[p31] then
        p30._pattern = u2[p31];
    else
        p30._pattern = u2.Sweep;
    end;

    if p30._pattern and p30._pattern.init then
        for _, v in p30._lasers do
            p30._pattern.init(v, p30._config);
        end;
    end;
end;

function u1.scan(p32, p33) -- Line: 211
    table.clear(p32._lasers);

    if not p33 then
        return;
    end;

    local _config = p32._config;
    local _pattern = p32._pattern;

    for _, descendant in p33:GetDescendants() do
        if descendant.Name == "LaserSpot" and descendant:IsA("Model") then
            local Base = descendant:FindFirstChild("Base");

            if Base and Base:IsA("Model") then
                local v34 = {
                    baseModel = Base,
                    baseCFrame = Base:GetPivot()
                };

                if _pattern and _pattern.init then
                    _pattern.init(v34, _config);
                end;

                if _config.colorCycle then
                    v34.colorPart = Base:FindFirstChild("Part");
                    v34.colorBeamParts = {};
                    local BEAM = Base:FindFirstChild("BEAM");

                    if BEAM then
                        for _, descendant2 in BEAM:GetDescendants() do
                            if descendant2:IsA("BasePart") then
                                table.insert(v34.colorBeamParts, descendant2);
                            end;
                        end;
                    end;

                    v34.colorCycleTimer = math.random() * _config.colorCycleMaxSec;
                    v34.lastColor = nil;
                end;

                table.insert(p32._lasers, v34);
            end;
        end;
    end;

    warn(string.format("[LaserSweep] %d LaserSpot(s) détecté(s) et mis en cache", #p32._lasers));
end;

function u1.update(p35, p36, p37) -- Line: 256
    -- upvalues: pickRandomColor (copy)
    if #p35._lasers == 0 then
        return;
    end;

    local _config = p35._config;
    local _pattern = p35._pattern;

    if not _pattern then
        return;
    end;

    local v38 = p37 or 0;
    local _smoothedPeak = p35._smoothedPeak;
    p35._smoothedPeak = _smoothedPeak + (1 - math.exp(-_config.peakSmoothRate * p36)) * (v38 - _smoothedPeak);
    local v39 = math.clamp(p35._smoothedPeak, 0, 1);
    local _beatAvg = p35._beatAvg;
    p35._beatAvg = _beatAvg + (1 - math.exp(-_config.beatAvgRate * p36)) * (v38 - _beatAvg);
    p35._beatCooldownTimer = math.max(0, p35._beatCooldownTimer - p36);
    local v40;

    if p35._beatCooldownTimer <= 0 and (p35._beatAvg > 0.02 and p35._beatAvg * _config.beatThreshold < v38) then
        p35._beatCooldownTimer = _config.beatCooldown;
        v40 = true;
    else
        v40 = false;
    end;

    local v41 = _config.pattern == "Blackout";
    local v42;

    if v39 > 0.01 then
        v42 = not v41;
    else
        v42 = false;
    end;

    for _, v in p35._lasers do
        if v.baseModel and v.baseModel.Parent then
            _pattern.update(v, p36, v39, v40, _config);

            if v.wasPlaying ~= v42 then
                v.wasPlaying = v42;

                for _, descendant in v.baseModel:GetDescendants() do
                    if descendant:IsA("Beam") or (descendant:IsA("Light") or descendant:IsA("ParticleEmitter")) then
                        descendant.Enabled = v42;
                    end;
                end;
            end;

            for _, descendant in v.baseModel:GetDescendants() do
                if descendant:IsA("BasePart") and (descendant.Parent and descendant.Parent.Name == "BEAM") then
                    local v43 = descendant:GetAttribute("OrigTrans");

                    if not v43 then
                        v43 = descendant.Transparency;
                        descendant:SetAttribute("OrigTrans", v43);
                    end;

                    local v44 = 1 - math.exp(p36 * -15);
                    descendant.Transparency = descendant.Transparency + ((v42 and v43 and v43 or 1) - descendant.Transparency) * v44;
                end;
            end;

            if _config.colorCycle and #_config.colorPalette > 0 then
                v.colorCycleTimer = v.colorCycleTimer - p36;

                if v.colorCycleTimer <= 0 then
                    v.colorCycleTimer = _config.colorCycleMinSec + math.random() * (_config.colorCycleMaxSec - _config.colorCycleMinSec);
                    local v45 = pickRandomColor(_config.colorPalette, v.lastColor);
                    v.lastColor = v45;

                    if v.colorPart then
                        v.colorPart.Color = v45;
                    end;

                    for _, v2 in v.colorBeamParts do
                        v2.Color = v45;
                    end;
                end;
            end;
        end;
    end;
end;

function u1.destroy(p46) -- Line: 333
    for _, v in p46._lasers do
        if v.baseModel and v.baseModel.Parent then
            pcall(function() -- Line: 336
                -- upvalues: v (copy)
                v.baseModel:PivotTo(v.baseCFrame);
            end);
        end;
    end;

    table.clear(p46._lasers);
end;

return u1;