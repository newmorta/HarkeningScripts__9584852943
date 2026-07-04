-- Ruta Original: ReplicatedStorage.Utilities.Events.StageLights
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local u1 = {};
u1.__index = u1;

local function ema(p2, p3, p4, p5) -- Line: 26
    return p2 + (1 - math.exp(-p4 * p5)) * (p3 - p2);
end;

local function getRandomPointInBox(p6) -- Line: 31
    local Size = p6.Size;
    local CFrame2 = p6.CFrame;
    local v7 = (math.random() - 0.5) * Size.X;
    local v8 = (math.random() - 0.5) * Size.Y;
    local v9 = (math.random() - 0.5) * Size.Z;

    return (CFrame2 * CFrame.new(v7, v8, v9)).Position;
end;

local function pickRandomColor(p10, p11) -- Line: 40
    local v12 = p10[math.random(1, #p10)];

    if v12 == p11 and #p10 > 1 then
        for _, v in p10 do
            if v ~= p11 then
                return v;
            end;
        end;
    end;

    return v12;
end;

local u13 = {
    ConcertScan = {}
};

function u13.ConcertScan.init(p14, p15, p16) -- Line: 63
    p14.currentCFrame = p14.baseCFrame;
    p14.targetCFrame = p14.baseCFrame;
    p14.speedMult = p15.speedVariationMin + math.random() * (p15.speedVariationMax - p15.speedVariationMin);
    p14.beatReactionDelay = math.random() * p15.maxReactionDelay;
    p14.delayTimer = 0;
    p14.hasPendingTarget = true;
    p14.timeSinceLastTarget = 0;
end;

function u13.ConcertScan.pickNewTarget(p17, p18, p19) -- Line: 78
    -- upvalues: getRandomPointInBox (copy)
    local v20 = p19._zones[p18.activeZone];

    if not v20 then
        return;
    end;

    local v21 = getRandomPointInBox(v20);
    local v22 = CFrame.lookAt(p17.baseCFrame.Position, v21);
    local v23, v24, v25 = p17.baseCFrame:ToObjectSpace(v22):ToOrientation();
    local v26 = math.rad(p18.limits.minX);
    local v27 = math.rad(p18.limits.maxX);
    local v28 = math.rad(p18.limits.minY);
    local v29 = math.rad(p18.limits.maxY);
    local v30 = math.rad(p18.limits.minZ);
    local v31 = math.rad(p18.limits.maxZ);
    local v32 = math.clamp(v23, v26, v27);
    local v33 = math.clamp(v24, v28, v29);
    local v34 = math.clamp(v25, v30, v31);
    p17.targetCFrame = p17.baseCFrame * CFrame.fromOrientation(v32, v33, v34);
    p17.timeSinceLastTarget = 0;
end;

function u13.ConcertScan.update(p35, p36, p37, p38, p39, p40) -- Line: 106
    -- upvalues: u13 (copy)
    p35.timeSinceLastTarget = p35.timeSinceLastTarget + p36;

    if p38 or p35.timeSinceLastTarget >= p39.autoTargetChangeSec then
        p35.hasPendingTarget = true;
        p35.delayTimer = p35.beatReactionDelay;

        if not p38 then
            p35.timeSinceLastTarget = math.random() * -0.5;
        end;
    end;

    if p35.hasPendingTarget then
        p35.delayTimer = math.max(0, p35.delayTimer - p36);

        if p35.delayTimer <= 0 then
            u13.ConcertScan.pickNewTarget(p35, p39, p40);
            p35.hasPendingTarget = false;
        end;
    end;

    local v41 = p37 <= 0.01 and 0 or (p39.baseSpeed + (p39.maxSpeed - p39.baseSpeed) * p37) * p35.speedMult;

    if v41 > 0 then
        local v42 = 1 - math.exp(-v41 * p36);
        p35.currentCFrame = p35.currentCFrame:Lerp(p35.targetCFrame, v42);
        p35.baseModel:PivotTo(p35.currentCFrame);
    end;
end;

u13.SkyRise = {};

function u13.SkyRise.init(p43, p44, p45) -- Line: 147
    p43.currentCFrame = p43.baseModel:GetPivot();
    p43.sweepPhase = math.random() * 3.141592653589793 * 2;
    p43.speedMult = 1;
end;

function u13.SkyRise.update(p46, p47, p48, p49, p50, p51) -- Line: 152
    p46.sweepPhase = p46.sweepPhase + p47 * (0.5 + p48 * 2);
    local v52 = math.sin(p46.sweepPhase) * 0.2617993877991494;
    p46.targetCFrame = p46.baseCFrame * CFrame.fromOrientation(0.7853981633974483, v52, 0);
    local v53;

    if p48 > 0.01 then
        if p48 > 0.7 then
            p48 = p48 * 2 or p48;
        end;

        v53 = (p50.baseSpeed + (p50.maxSpeed - p50.baseSpeed) * p48) * p46.speedMult;
    else
        v53 = 0;
    end;

    if v53 > 0 then
        local v54 = 1 - math.exp(-v53 * p47);
        p46.currentCFrame = p46.currentCFrame:Lerp(p46.targetCFrame, v54);
        p46.baseModel:PivotTo(p46.currentCFrame);
    end;
end;

u13.Fan = {};

function u13.Fan.init(p55, p56, p57) -- Line: 173
    p55.currentCFrame = p55.baseModel:GetPivot();
    p55.sweepPhase = math.random() * 3.141592653589793 * 2;
    p55.speedMult = 1;
end;

function u13.Fan.update(p58, p59, p60, p61, p62, p63) -- Line: 178
    p58.sweepPhase = p58.sweepPhase + p59 * (0.5 + p60 * 2);
    local v64 = #p63._lights;
    local v65 = -60 + 120 * (((table.find(p63._lights, p58) or 1) - 1) / ((v64 <= 1 and 2 or v64) - 1));
    local v66 = math.rad(v65) + math.sin(p58.sweepPhase) * 0.17453292519943295;
    local v67 = math.cos(p58.sweepPhase) * 0.17453292519943295 + 0.5235987755982988;
    p58.targetCFrame = p58.baseCFrame * CFrame.fromOrientation(v67, v66, 0);
    local v68;

    if p60 > 0.01 then
        if p60 > 0.7 then
            p60 = p60 * 2 or p60;
        end;

        v68 = (p62.baseSpeed + (p62.maxSpeed - p62.baseSpeed) * p60) * p58.speedMult;
    else
        v68 = 0;
    end;

    if v68 > 0 then
        local v69 = 1 - math.exp(-v68 * p59);
        p58.currentCFrame = p58.currentCFrame:Lerp(p58.targetCFrame, v69);
        p58.baseModel:PivotTo(p58.currentCFrame);
    end;
end;

u13.Cross = {};

function u13.Cross.init(p70, p71, p72) -- Line: 207
    p70.currentCFrame = p70.baseModel:GetPivot();
    p70.sweepPhase = 0;
    p70.speedMult = 1;
end;

function u13.Cross.update(p73, p74, p75, p76, p77, p78) -- Line: 212
    p73.sweepPhase = p73.sweepPhase + p74 * (1 + p75 * 3);
    local v79 = #p78._lights;
    local v80 = table.find(p78._lights, p73) or 1;
    local v81 = math.sin(p73.sweepPhase + v80) * 0.3490658503988659 + 0.2617993877991494;
    p73.targetCFrame = p73.baseCFrame * CFrame.fromOrientation(v81, v80 <= v79 / 2 and 0.7853981633974483 or -0.7853981633974483, 0);
    local v82;

    if p75 > 0.01 then
        if p75 > 0.7 then
            p75 = p75 * 2 or p75;
        end;

        v82 = (p77.baseSpeed + (p77.maxSpeed - p77.baseSpeed) * p75) * p73.speedMult;
    else
        v82 = 0;
    end;

    if v82 > 0 then
        local v83 = 1 - math.exp(-v82 * p74);
        p73.currentCFrame = p73.currentCFrame:Lerp(p73.targetCFrame, v83);
        p73.baseModel:PivotTo(p73.currentCFrame);
    end;
end;

u13.Blackout = {};

function u13.Blackout.init(p84, p85, p86) -- Line: 244
    p84.currentCFrame = p84.baseModel:GetPivot();
    p84.speedMult = 1;
end;

function u13.Blackout.update(p87, p88, p89, p90, p91, p92) -- Line: 248
    p87.targetCFrame = p87.baseCFrame * CFrame.fromOrientation(-1.5707963267948966, 0, 0);
    local v93 = 1 - math.exp(-(p91.maxSpeed * 3 * p87.speedMult) * p88);
    p87.currentCFrame = p87.currentCFrame:Lerp(p87.targetCFrame, v93);
    p87.baseModel:PivotTo(p87.currentCFrame);
end;

u13.AudienceSweep = {};

function u13.AudienceSweep.init(p94, p95, p96) -- Line: 261
    p94.currentCFrame = p94.baseModel:GetPivot();
    p94.sweepPhase = 0;
    p94.speedMult = 1;
end;

function u13.AudienceSweep.update(p97, p98, p99, p100, p101, p102) -- Line: 266
    p97.sweepPhase = p97.sweepPhase + p98 * (0.5 + p99 * 2);
    local v103 = math.sin(p97.sweepPhase) * 1.0471975511965976;
    local v104 = math.cos(p97.sweepPhase * 2) * 0.2617993877991494 + -0.2617993877991494;
    p97.targetCFrame = p97.baseCFrame * CFrame.fromOrientation(v104, v103, 0);
    local v105;

    if p99 > 0.01 then
        if p99 > 0.7 then
            p99 = p99 * 2 or p99;
        end;

        v105 = (p101.baseSpeed + (p101.maxSpeed - p101.baseSpeed) * p99) * p97.speedMult;
    else
        v105 = 0;
    end;

    if v105 > 0 then
        local v106 = 1 - math.exp(-v105 * p98);
        p97.currentCFrame = p97.currentCFrame:Lerp(p97.targetCFrame, v106);
        p97.baseModel:PivotTo(p97.currentCFrame);
    end;
end;

u13.Mirror = {};

function u13.Mirror.init(p107, p108, p109) -- Line: 289
    p107.currentCFrame = p107.baseModel:GetPivot();
    p107.sweepPhase = 0;
    local v110 = #p109._lights;
    local v111 = table.find(p109._lights, p107) or 1;
    local v112 = (v110 + 1) / 2;
    p107.mirrorSign = v111 < v112 and 1 or (v112 < v111 and -1 or 0);
    p107.speedMult = 1;
end;

function u13.Mirror.update(p113, p114, p115, p116, p117, p118) -- Line: 298
    p113.sweepPhase = p113.sweepPhase + p114 * (0.5 + p115 * 2.5);
    local v119 = math.sin(p113.sweepPhase) * 1.0471975511965976 * p113.mirrorSign;
    p113.targetCFrame = p113.baseCFrame * CFrame.fromOrientation(0.3490658503988659, p113.mirrorSign == 0 and 0 or v119, 0);
    local v120;

    if p115 > 0.01 then
        if p115 > 0.7 then
            p115 = p115 * 2 or p115;
        end;

        v120 = (p117.baseSpeed + (p117.maxSpeed - p117.baseSpeed) * p115) * p113.speedMult;
    else
        v120 = 0;
    end;

    if v120 > 0 then
        local v121 = 1 - math.exp(-v120 * p114);
        p113.currentCFrame = p113.currentCFrame:Lerp(p113.targetCFrame, v121);
        p113.baseModel:PivotTo(p113.currentCFrame);
    end;
end;

u13.Wave = {};

function u13.Wave.init(p122, p123, p124) -- Line: 321
    p122.currentCFrame = p122.baseModel:GetPivot();
    p122.sweepPhase = (table.find(p124._lights, p122) or 1) * 0.5;
    p122.speedMult = 1;
end;

function u13.Wave.update(p125, p126, p127, p128, p129, p130) -- Line: 327
    p125.sweepPhase = p125.sweepPhase + p126 * (0.5 + p127 * 2);
    local v131 = math.sin(p125.sweepPhase) * 1.0471975511965976;
    local v132 = math.cos(p125.sweepPhase) * 0.5235987755982988 + -0.2617993877991494;
    p125.targetCFrame = p125.baseCFrame * CFrame.fromOrientation(v132, v131, 0);
    local v133;

    if p127 > 0.01 then
        if p127 > 0.7 then
            p127 = p127 * 2 or p127;
        end;

        v133 = (p129.baseSpeed + (p129.maxSpeed - p129.baseSpeed) * p127) * p125.speedMult;
    else
        v133 = 0;
    end;

    if v133 > 0 then
        local v134 = 1 - math.exp(-v133 * p126);
        p125.currentCFrame = p125.currentCFrame:Lerp(p125.targetCFrame, v134);
        p125.baseModel:PivotTo(p125.currentCFrame);
    end;
end;

u13.Alternating = {};

function u13.Alternating.init(p135, p136, p137) -- Line: 350
    p135.currentCFrame = p135.baseModel:GetPivot();
    p135.isOdd = (table.find(p137._lights, p135) or 1) % 2 ~= 0;
    p135.state = true;
    p135.speedMult = 1;
    p135.sweepPhase = 0;
end;

function u13.Alternating.update(p138, p139, p140, p141, p142, p143) -- Line: 358
    if p141 then
        p138.state = not p138.state;
    end;

    p138.sweepPhase = p138.sweepPhase + p139 * (0.5 + p140 * 2);
    local v144;

    if p138.isOdd then
        v144 = p138.state and -0.7853981633974483 or 0.7853981633974483;
    else
        v144 = p138.state and 0.7853981633974483 or -0.7853981633974483;
    end;

    local v145 = math.sin(p138.sweepPhase) * 0.17453292519943295;
    p138.targetCFrame = p138.baseCFrame * CFrame.fromOrientation(v145 + 0.2617993877991494, v144, 0);
    local v146;

    if p140 > 0.01 then
        if p140 > 0.7 then
            p140 = p140 * 2 or p140;
        end;

        v146 = (p142.baseSpeed + (p142.maxSpeed - p142.baseSpeed) * p140) * p138.speedMult;
    else
        v146 = 0;
    end;

    if v146 > 0 then
        local v147 = 1 - math.exp(-v146 * p139);
        p138.currentCFrame = p138.currentCFrame:Lerp(p138.targetCFrame, v147);
        p138.baseModel:PivotTo(p138.currentCFrame);
    end;
end;

local u148 = {
    pattern = "ConcertScan",
    activeZone = "PublicZone",
    baseSpeed = 2.5,
    maxSpeed = 14,
    maxReactionDelay = 0.15,
    autoTargetChangeSec = 1.2,
    peakSmoothRate = 15,
    beatAvgRate = 1,
    beatThreshold = 1.4,
    beatCooldown = 0.3,
    speedVariationMin = 0.85,
    speedVariationMax = 1.15,
    colorCycle = false,
    colorCycleMinSec = 3,
    colorCycleMaxSec = 8,
    limits = {
        minX = -45,
        maxX = 45,
        minY = -120,
        maxY = 120,
        minZ = -20,
        maxZ = 20
    },
    colorPalette = {}
};

function u1.new(p149) -- Line: 439
    -- upvalues: u148 (copy), u1 (copy), u13 (copy)
    local v150 = {};

    for i, v in u148 do
        if type(v) == "table" then
            v150[i] = {};

            for i2, v2 in v do
                v150[i][i2] = v2;
            end;
        else
            v150[i] = v;
        end;
    end;

    if p149 then
        for i, v in p149 do
            if type(v) == "table" and type(v150[i]) == "table" then
                for i2, v2 in v do
                    v150[i][i2] = v2;
                end;
            else
                v150[i] = v;
            end;
        end;
    end;

    local v151 = setmetatable({}, u1);
    v151._config = v150;
    v151._lights = {};
    v151._zones = {};
    v151._pattern = u13[v150.pattern];
    v151._smoothedPeak = 0;
    v151._beatAvg = 0;
    v151._beatCooldownTimer = 0;

    if not v151._pattern then
        warn(string.format("[StageLights] Pattern \'%s\' inconnu, aucune animation.", (tostring(v150.pattern))));
    end;

    return v151;
end;

function u1.setPattern(p152, p153) -- Line: 477
    -- upvalues: u13 (copy)
    if u13[p153] then
        p152._config.pattern = p153;
        p152._pattern = u13[p153];

        if p152._pattern.init then
            for _, v in p152._lights do
                p152._pattern.init(v, p152._config, p152);
            end;
        end;
    else
        warn("[StageLights] Pattern inconnu lors de setPattern: " .. tostring(p153));
    end;
end;

function u1.scan(p154, p155) -- Line: 491
    -- upvalues: CollectionService (copy)
    table.clear(p154._lights);
    table.clear(p154._zones);

    if not p155 then
        return;
    end;

    local _config = p154._config;
    local _pattern = p154._pattern;

    for _, v in ipairs({ "PublicZone", "SkyZone", "StageCenter" }) do
        local v156 = p155:FindFirstChild(v);

        if v156 and v156:IsA("BasePart") then
            p154._zones[v] = v156;
        end;
    end;

    for _, v in CollectionService:GetTagged("StageLight") do
        if v:IsDescendantOf(p155) and v:IsA("Model") then
            local Base = v:FindFirstChild("Base");

            if Base and Base:IsA("Model") then
                local v157 = {
                    baseModel = Base,
                    baseCFrame = Base:GetPivot(),
                    index = tonumber(v.Name) or (tonumber(v.Parent.Name) or 999)
                };

                if _config.colorCycle then
                    v157.colorPart = Base:FindFirstChild("ColorPart");
                    local v158 = Base:FindFirstChild("Ceiling_Light") and v158:FindFirstChild("BeamBase");
                    local v159;

                    if v158 then
                        v159 = v158:FindFirstChild("Beam");
                    else
                        v159 = v158;
                    end;

                    v157.colorBeam = v159;

                    if v158 then
                        v158 = v158:FindFirstChildOfClass("SpotLight");
                    end;

                    v157.Spotlight = v158;
                    v157.colorCycleTimer = math.random() * _config.colorCycleMaxSec;
                    v157.lastColor = nil;
                end;

                table.insert(p154._lights, v157);
            end;
        end;
    end;

    table.sort(p154._lights, function(p160, p161) -- Line: 535
        return p160.index < p161.index;
    end);

    if _pattern and _pattern.init then
        for _, v in p154._lights do
            _pattern.init(v, _config, p154);
        end;
    end;

    warn(string.format("[StageLights] %d StageLight(s) (triés numériquement) et zones détectés", #p154._lights));
end;

function u1.update(p162, p163, p164) -- Line: 547
    -- upvalues: pickRandomColor (copy)
    if #p162._lights == 0 then
        return;
    end;

    local _config = p162._config;
    local _pattern = p162._pattern;

    if not _pattern then
        return;
    end;

    local v165 = p164 or 0;
    local _smoothedPeak = p162._smoothedPeak;
    p162._smoothedPeak = _smoothedPeak + (1 - math.exp(-_config.peakSmoothRate * p163)) * (v165 - _smoothedPeak);
    local v166 = math.clamp(p162._smoothedPeak, 0, 1);
    local _beatAvg = p162._beatAvg;
    p162._beatAvg = _beatAvg + (1 - math.exp(-_config.beatAvgRate * p163)) * (v165 - _beatAvg);
    p162._beatCooldownTimer = math.max(0, p162._beatCooldownTimer - p163);
    local v167;

    if p162._beatCooldownTimer <= 0 and (p162._beatAvg > 0.02 and p162._beatAvg * _config.beatThreshold < v165) then
        p162._beatCooldownTimer = _config.beatCooldown;
        v167 = true;
    else
        v167 = false;
    end;

    for _, v in p162._lights do
        if v.baseModel and v.baseModel.Parent then
            _pattern.update(v, p163, v166, v167, _config, p162);
            local v168 = _config.pattern == "Blackout";
            local v169;

            if v166 > 0.01 then
                v169 = not v168;
            else
                v169 = false;
            end;

            if v.wasPlaying ~= v169 then
                v.wasPlaying = v169;

                for _, descendant in v.baseModel:GetDescendants() do
                    if descendant:IsA("Beam") or (descendant:IsA("Light") or descendant:IsA("ParticleEmitter")) then
                        descendant.Enabled = v169;
                    end;
                end;
            end;

            for _, descendant in v.baseModel:GetDescendants() do
                if descendant:IsA("BasePart") and (descendant.Parent and descendant.Parent.Name == "BEAM") then
                    local v170 = descendant:GetAttribute("OrigTrans");

                    if not v170 then
                        v170 = descendant.Transparency;
                        descendant:SetAttribute("OrigTrans", v170);
                    end;

                    local v171 = 1 - math.exp(p163 * -15);
                    descendant.Transparency = descendant.Transparency + ((v169 and v170 and v170 or 1) - descendant.Transparency) * v171;
                end;
            end;

            if _config.colorCycle and #_config.colorPalette > 0 then
                v.colorCycleTimer = v.colorCycleTimer - p163;

                if v.colorCycleTimer <= 0 then
                    v.colorCycleTimer = _config.colorCycleMinSec + math.random() * (_config.colorCycleMaxSec - _config.colorCycleMinSec);
                    local v172 = pickRandomColor(_config.colorPalette, v.lastColor);
                    v.lastColor = v172;

                    if v.colorPart then
                        v.colorPart.Color = v172;
                    end;

                    if v.colorBeam then
                        v.colorBeam.Color = ColorSequence.new(v172);
                    end;

                    if v.Spotlight then
                        v.Spotlight.Color = v172;
                    end;
                end;
            end;
        end;
    end;
end;

function u1.destroy(p173) -- Line: 626
    for _, v in p173._lights do
        if v.baseModel and v.baseModel.Parent then
            pcall(function() -- Line: 629
                -- upvalues: v (copy)
                v.baseModel:PivotTo(v.baseCFrame);
            end);
        end;
    end;

    table.clear(p173._lights);
    table.clear(p173._zones);
end;

return u1;