-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.IndependenceDay.IndependenceDayLightsDirector
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local IndependenceDayConfig = require(script.Parent.IndependenceDayConfig);
local u1 = {};
u1.__index = u1;

local function pickRandomPattern(p2) -- Line: 23
    -- upvalues: IndependenceDayConfig (copy)
    local STAGE_LIGHT_PATTERNS = IndependenceDayConfig.STAGE_LIGHT_PATTERNS;
    local v3 = STAGE_LIGHT_PATTERNS[math.random(1, #STAGE_LIGHT_PATTERNS)];

    if v3 == p2 and #STAGE_LIGHT_PATTERNS > 1 then
        for _, v in STAGE_LIGHT_PATTERNS do
            if v ~= p2 then
                return v;
            end;
        end;
    end;

    return v3;
end;

function u1.new(p4, p5) -- Line: 40
    -- upvalues: u1 (copy), pickRandomPattern (copy), IndependenceDayConfig (copy)
    local v6 = setmetatable({}, u1);
    v6._stageLights = p4;
    v6._laserSweep = p5;
    v6._currentPattern = pickRandomPattern(nil);
    v6._timeSinceLastChange = 0;
    v6._nextChangeDuration = math.random(IndependenceDayConfig.STAGE_LIGHT_PATTERN_MIN_SEC, IndependenceDayConfig.STAGE_LIGHT_PATTERN_MAX_SEC);

    if v6._stageLights then
        v6._stageLights:setPattern(v6._currentPattern);
    end;

    if v6._laserSweep then
        v6._laserSweep:setPattern(IndependenceDayConfig.LASER_PATTERN);
    end;

    return v6;
end;

function u1.update(p7, p8, p9) -- Line: 63
    -- upvalues: IndependenceDayConfig (copy), pickRandomPattern (copy)
    p7._timeSinceLastChange = p7._timeSinceLastChange + p8;

    if p7._timeSinceLastChange >= p7._nextChangeDuration then
        p7._timeSinceLastChange = 0;
        p7._nextChangeDuration = math.random(IndependenceDayConfig.STAGE_LIGHT_PATTERN_MIN_SEC, IndependenceDayConfig.STAGE_LIGHT_PATTERN_MAX_SEC);
        p7._currentPattern = pickRandomPattern(p7._currentPattern);

        if p7._stageLights then
            p7._stageLights:setPattern(p7._currentPattern);
        end;
    end;

    if p7._stageLights then
        p7._stageLights:update(p8, p9);
    end;

    if p7._laserSweep then
        p7._laserSweep:update(p8, p9);
    end;
end;

return u1;