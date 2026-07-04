-- Ruta Original: ReplicatedStorage.Utilities.Numbers
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Suffixes = require(script.Suffixes);

return {
    formatNumber = function(p1, p2) -- Line: 3, Name: formatNumber
        -- upvalues: Suffixes (copy)
        local v3 = tonumber(p1) or 0;
        local v4 = "%." .. (p2 or 2) .. "f";

        for _, v in ipairs(Suffixes.SUFFIXES) do
            local v5 = v[1];
            local v6 = v[2];

            if v5 <= v3 then
                return string.format(v4, v3 / v5):gsub("%.?0+$", "") .. v6;
            end;
        end;

        local v7 = math.floor(v3);

        return tostring(v7);
    end,

    formatMultiplier = function(p8) -- Line: 16, Name: formatMultiplier
        -- upvalues: Suffixes (copy)
        local v9 = tonumber(p8) or 1;

        for _, v in ipairs(Suffixes.SUFFIXES) do
            local v10 = v[1];
            local v11 = v[2];

            if v10 <= v9 then
                return string.format("%.2f", v9 / v10):gsub("%.?0+$", "") .. v11;
            end;
        end;

        if v9 ~= math.floor(v9) then
            return string.format("%.2f", v9):gsub("0+$", ""):gsub("%.$", "");
        end;

        local v12 = math.floor(v9);

        return tostring(v12);
    end,

    formatComma = function(p13) -- Line: 30, Name: formatComma
        local v14 = math.floor(p13);

        return tostring(v14):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    end
};