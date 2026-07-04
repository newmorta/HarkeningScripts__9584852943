-- Ruta Original: ReplicatedStorage.Utilities.Events.CCPulse
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 23
    -- upvalues: u1 (copy)
    local v3 = p2 or {};
    local v4 = setmetatable({}, u1);
    v4._name = v3.name or "CCPulse";
    v4._colorSpeed = v3.colorSpeed or 0.23;
    v4._contrast = v3.contrast or 0.06;
    v4._satCenter = v3.satCenter or 0.12;
    v4._satAmp = v3.satAmp or 0.08;
    v4._satFreq = v3.satFreq or 1.1;
    v4._tintSatMin = v3.tintSatMin or 0.18;
    v4._tintSatAmp = v3.tintSatAmp or 0.1;
    v4._tintSatFreq = v3.tintSatFreq or 2.3;
    v4._brightBase = v3.brightBase or 0.01;
    v4._brightAmp = v3.brightAmp or 0.02;
    v4._brightFreq = v3.brightFreq or 3.8;
    v4._bloomIntensity = v3.bloomIntensity or 0.45;
    v4._bloomSize = v3.bloomSize or 18;
    v4._bloomThreshold = v3.bloomThreshold or 0.9;
    v4._cc = nil;

    return v4;
end;

function u1.setup(p5, p6) -- Line: 46
    -- upvalues: Lighting (copy)
    local v7 = p6:Add(Instance.new("ColorCorrectionEffect"));
    v7.Name = p5._name .. "CC";
    v7.Brightness = p5._brightBase;
    v7.Contrast = p5._contrast;
    v7.Saturation = p5._satCenter;
    v7.TintColor = Color3.fromRGB(255, 200, 255);
    v7.Parent = Lighting;
    p5._cc = v7;
    local v8 = p6:Add(Instance.new("BloomEffect"));
    v8.Name = p5._name .. "Bloom";
    v8.Intensity = p5._bloomIntensity;
    v8.Size = p5._bloomSize;
    v8.Threshold = p5._bloomThreshold;
    v8.Parent = Lighting;
end;

function u1.update(p9, p10) -- Line: 65
    local _cc = p9._cc;

    if not (_cc and _cc.Parent) then
        return;
    end;

    local v11 = p10 * p9._colorSpeed % 1;
    local _tintSatMin = p9._tintSatMin;
    local v12 = math.sin(p10 * p9._tintSatFreq);
    local v13 = _tintSatMin + math.abs(v12) * p9._tintSatAmp;
    _cc.TintColor = Color3.fromHSV(v11, v13, 1);
    _cc.Saturation = p9._satCenter + math.sin(p10 * p9._satFreq) * p9._satAmp;
    local _brightBase = p9._brightBase;
    local v14 = math.sin(p10 * p9._brightFreq);
    _cc.Brightness = _brightBase + math.abs(v14) * p9._brightAmp;
end;

return u1;