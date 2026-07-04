-- Ruta Original: ReplicatedStorage.FeatureConfigs.BoostSystemConfig
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Suffixes = require(ReplicatedStorage.Utilities.Numbers.Suffixes);
local v1 = {
    USE_PERCENTAGE_BOOSTS = true
};
local u2 = { 1, 1.5, 2, 3, 5, 7, 10 };

local function roundNice(p3) -- Line: 14
    -- upvalues: u2 (copy)
    if p3 <= 0 then
        return 0;
    end;

    local v4 = math.log10(p3);
    local v5 = 10 ^ math.floor(v4);
    local v6 = p3 / v5;

    for _, v in u2 do
        if v6 <= v then
            return v * v5;
        end;
    end;

    return v5 * 10;
end;

function v1.niceFormatNumber(p7, p8) -- Line: 31
    -- upvalues: Suffixes (copy), u2 (copy)
    local v9 = tonumber(p7) or 0;
    local v10 = "%." .. (p8 or 2) .. "f";

    for _, v in ipairs(Suffixes.SUFFIXES) do
        local v11 = v[1];
        local v12 = v[2];

        if v11 <= v9 then
            local v13 = v9 / v11;
            local v14;

            if v13 <= 0 then
                v14 = 0;
            else
                local v15 = math.log10(v13);
                local v16 = 10 ^ math.floor(v15);
                local v17 = v13 / v16;

                for _, v2 in u2 do
                    if v17 <= v2 then
                        v14 = v2 * v16;
                        break;
                    end;
                end;

                v14 = v16 * 10;
            end;

            return string.format(v10, v14):gsub("%.?0+$", "") .. v12;
        end;
    end;

    local v18;

    if v9 <= 0 then
        v18 = 0;
    else
        local v19 = math.log10(v9);
        local v20 = 10 ^ math.floor(v19);
        local v21 = v9 / v20;

        for _, v in u2 do
            if v21 <= v then
                v18 = v * v20;
                break;
            end;
        end;

        v18 = v20 * 10;
    end;

    return tostring(v18);
end;

function v1.calculSpeed(p22, p23) -- Line: 52
    -- upvalues: Suffixes (copy), u2 (copy)
    local v24 = math.floor(p23 * p22.Percent);
    local v25 = math.clamp(v24, p22.MinAmount, Suffixes.QI * p22.Percent);

    if v25 <= 0 then
        return 0;
    end;

    local v26 = math.log10(v25);
    local v27 = 10 ^ math.floor(v26);
    local v28 = v25 / v27;

    for _, v in u2 do
        if v28 <= v then
            return v * v27;
        end;
    end;

    return v27 * 10;
end;

return v1;