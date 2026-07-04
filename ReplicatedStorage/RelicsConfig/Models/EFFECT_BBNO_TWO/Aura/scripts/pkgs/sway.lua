-- Ruta Original: ReplicatedStorage.RelicsConfig.Models.EFFECT_BBNO_TWO.Aura.scripts.pkgs.sway
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local rad = math.rad;
local sin = math.sin;
local cos = math.cos;
local u1 = Random.new();
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = {};
local u10 = {};
local u11 = 0;

local function newEntity() -- Line: 36
    -- upvalues: u11 (ref)
    u11 = u11 + 1;

    return u11;
end;

return {
    Create = function(p12, p13) -- Line: 44, Name: Create
        -- upvalues: u11 (ref), u2 (copy), u3 (copy), u4 (copy), u5 (copy), u1 (copy), u6 (copy), u8 (copy), u7 (copy), u9 (copy), u10 (copy)
        local v14 = p13 or {};
        u11 = u11 + 1;
        local v15 = u11;
        u2[v15] = v14.Speed or 1;
        u3[v15] = v14.Intensity or Vector3.new(1, 1, 1);
        u4[v15] = v14.RotationMultiplier or 1;
        u5[v15] = u1:NextNumber(0, 6.283185307179586);
        u6[v15] = u1:NextNumber(0, 6.283185307179586);
        local v16 = p12:IsA("Motor6D") or p12:IsA("Weld");
        u8[v15] = p12;
        u7[v15] = v16 and p12.C0 or p12.CFrame;
        u9[v15] = v16;
        u10[v15] = true;

        return v15;
    end,

    Step = function(p17) -- Line: 67, Name: Step
        -- upvalues: u10 (copy), u5 (copy), u2 (copy), sin (copy), cos (copy), u6 (copy), u4 (copy), u3 (copy), u7 (copy), rad (copy), u9 (copy), u8 (copy)
        for i in u10 do
            local v18 = u5[i] + p17 * u2[i];
            u5[i] = v18;
            local v19 = sin(v18);
            local v20 = cos(v18);
            local v21 = sin(v18 + u6[i]);
            local v22 = u4[i];
            local v23 = u3[i];
            local v24 = u7[i] * CFrame.Angles(rad(v19 * v22), rad(v21 * v22), (rad(v20 * v22))) + vector.create(v19 * v23.x, v21 * v23.y, v20 * v23.z);

            if u9[i] then
                u8[i].C0 = v24;
            else
                u8[i].CFrame = v24;
            end;
        end;
    end
};