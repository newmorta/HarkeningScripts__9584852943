-- Ruta Original: ReplicatedStorage.Utilities.Events.LightingSnapshot
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local u1 = {};
u1.__index = u1;

function u1.capture(p2) -- Line: 9
    -- upvalues: u1 (copy), Lighting (copy)
    local v3 = setmetatable({}, u1);
    v3._saved = {};
    v3._props = p2;

    for _, v in p2 do
        v3._saved[v] = Lighting[v];
    end;

    return v3;
end;

function u1.apply(p4, p5) -- Line: 20
    -- upvalues: Lighting (copy)
    for i, v in p5 do
        Lighting[i] = v;
    end;
end;

function u1.restore(p6) -- Line: 27
    -- upvalues: Lighting (copy)
    for i, v in p6._saved do
        Lighting[i] = v;
    end;
end;

local u7 = { "ClockTime", "Brightness", "Ambient", "OutdoorAmbient", "FogEnd", "FogColor" };
local u8 = 0;
local u9 = nil;

function u1.acquireShared() -- Line: 46
    -- upvalues: u8 (ref), u9 (ref), u7 (copy), Lighting (copy)
    u8 = u8 + 1;

    if u8 == 1 then
        u9 = {};

        for _, v in u7 do
            u9[v] = Lighting[v];
        end;
    end;
end;

function u1.releaseShared(p10) -- Line: 57
    -- upvalues: u8 (ref), u9 (ref), TweenService (copy), Lighting (copy)
    if u8 <= 0 then
        return;
    end;

    u8 = u8 - 1;

    if u8 > 0 or not u9 then
        return;
    end;

    local v11 = u9;
    u9 = nil;
    local v12 = p10 or 0;

    if v12 > 0 then
        TweenService:Create(Lighting, TweenInfo.new(v12, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), v11):Play();

        return;
    end;

    for i, v in v11 do
        Lighting[i] = v;
    end;
end;

return u1;