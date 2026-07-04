-- Ruta Original: ReplicatedStorage.Utilities.Events.LightCubeController
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local u2 = {
    TweenSpeed = 10,
    PatternSpeed = 1,
    ActiveColor = Color3.fromRGB(125, 182, 105),
    InactiveColor = Color3.fromRGB(0, 0, 0)
};
local u3 = {};

local function mapPattern(p4) -- Line: 25
    -- upvalues: u3 (copy)
    return not u3[p4] and (p4 == "Blackout" and "FullOff" or ((p4 == "Cross" or p4 == "ConcertScan") and "Alternating" or (p4 == "Fan" and "Pulse" or (p4 == "SkyRise" and "BottomUp" or "Wave")))) or p4;
end;

function u3.FullOff(p5, p6, p7) -- Line: 38
    p5[1] = false;
    p5[2] = false;
    p5[3] = false;
    p5[4] = false;
    p5[5] = false;
end;

function u3.FullOn(p8, p9, p10) -- Line: 42
    p8[1] = true;
    p8[2] = true;
    p8[3] = true;
    p8[4] = true;
    p8[5] = true;
end;

function u3.AudienceSweep(p11, p12, p13) -- Line: 46
    local v14 = math.floor(p12 * 6);
    p11[1] = v14 >= 1;
    p11[2] = v14 >= 2;
    p11[3] = v14 >= 3;
    p11[4] = v14 >= 4;
    p11[5] = v14 >= 5;
end;

function u3.TopDown(p15, p16, p17) -- Line: 54
    local v18 = math.floor(p16 * 5) + 1;
    p15[1] = v18 == 1;
    p15[2] = v18 == 2;
    p15[3] = v18 == 3;
    p15[4] = v18 == 4;
    p15[5] = v18 == 5;
end;

function u3.BottomUp(p19, p20, p21) -- Line: 61
    local v22 = 5 - math.floor(p20 * 5);
    p19[1] = v22 == 1;
    p19[2] = v22 == 2;
    p19[3] = v22 == 3;
    p19[4] = v22 == 4;
    p19[5] = v22 == 5;
end;

function u3.Wave(p23, p24, p25) -- Line: 68
    for i = 1, 5 do
        p23[i] = math.sin(p24 * 3.141592653589793 * 2 + i * 0.5) > 0;
    end;
end;

function u3.Pulse(p26, p27, p28) -- Line: 76
    local v29 = math.sin(p27 * 3.141592653589793 * 2) > 0;
    p26[1] = v29;
    p26[2] = v29;
    p26[3] = v29;
    p26[4] = v29;
    p26[5] = v29;
end;

function u3.Alternating(p30, p31, p32) -- Line: 83
    local v33 = math.sin(p31 * 3.141592653589793 * 2) > 0;

    if v33 then
        p30[1] = true;
    else
        p30[1] = false;
    end;

    if v33 then
        p30[2] = false;
    else
        p30[2] = true;
    end;

    if v33 then
        p30[3] = true;
    else
        p30[3] = false;
    end;

    if v33 then
        p30[4] = false;
    else
        p30[4] = true;
    end;

    if v33 then
        p30[5] = true;

        return;
    end;

    p30[5] = false;
end;

function u3.Mirror(p34, p35, p36) -- Line: 94
    local v37 = math.floor(p35 * 3);
    p34[1] = false;
    p34[2] = false;
    p34[3] = false;
    p34[4] = false;
    p34[5] = false;

    if v37 == 0 then
        p34[3] = true;

        return;
    end;

    if v37 == 1 then
        p34[2] = true;
        p34[4] = true;

        return;
    end;

    p34[1] = true;
    p34[5] = true;
end;

function u1.new(p38) -- Line: 112
    -- upvalues: u1 (copy), u2 (copy), u3 (copy)
    local v39 = setmetatable({}, u1);
    v39._config = {};

    for i, v in pairs(u2) do
        v39._config[i] = v;
    end;

    if p38 then
        for i, v in pairs(p38) do
            v39._config[i] = v;
        end;
    end;

    v39._cubeGroups = {};
    v39._activeState = { false, false, false, false, false };
    v39._patternPhase = 0;
    v39._currentPatternName = "Wave";
    v39._patternFunc = u3.Wave;

    return v39;
end;

function u1.scan(p40, p41) -- Line: 129
    table.clear(p40._cubeGroups);

    if not p41 then
        return;
    end;

    for _, descendant in ipairs(p41:GetDescendants()) do
        if descendant.Name == "LightCubes" and descendant:IsA("Model") then
            local v42 = {
                neonParts = {}
            };
            local v43 = true;

            for i = 1, 5 do
                local v44 = descendant:FindFirstChild((tostring(i)));

                if not (v44 and v44:IsA("Model")) then
                    v43 = false;
                    break;
                end;

                local Neon = v44:FindFirstChild("Neon");

                if not (Neon and Neon:IsA("BasePart")) then
                    v43 = false;
                    break;
                end;

                v42.neonParts[i] = Neon;
            end;

            if v43 then
                table.insert(p40._cubeGroups, v42);
            end;
        end;
    end;

    warn(string.format("[LightCubeController] %d LightCubes détectés et mis en cache", #p40._cubeGroups));
end;

function u1.setPattern(p45, p46) -- Line: 162
    -- upvalues: u3 (copy)
    local v47 = not u3[p46] and (p46 == "Blackout" and "FullOff" or ((p46 == "Cross" or p46 == "ConcertScan") and "Alternating" or (p46 == "Fan" and "Pulse" or (p46 == "SkyRise" and "BottomUp" or "Wave")))) or p46;

    if u3[v47] then
        p45._currentPatternName = v47;
        p45._patternFunc = u3[v47];
    end;
end;

function u1.update(p48, p49) -- Line: 170
    if #p48._cubeGroups == 0 then
        return;
    end;

    p48._patternPhase = p48._patternPhase + p49 * p48._config.PatternSpeed;

    if p48._patternPhase >= 1 then
        p48._patternPhase = p48._patternPhase - 1;
    end;

    if p48._patternFunc then
        p48._patternFunc(p48._activeState, p48._patternPhase, p49);
    end;

    local ActiveColor = p48._config.ActiveColor;
    local InactiveColor = p48._config.InactiveColor;
    local v50 = 1 - math.exp(-p48._config.TweenSpeed * p49);

    for _, v in ipairs(p48._cubeGroups) do
        for i = 1, 5 do
            local v51 = v.neonParts[i];
            v51.Color = v51.Color:Lerp(p48._activeState[i] and ActiveColor and ActiveColor or InactiveColor, v50);
        end;
    end;
end;

function u1.destroy(p52) -- Line: 198
    table.clear(p52._cubeGroups);
end;

return u1;