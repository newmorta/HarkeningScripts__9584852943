-- Ruta Original: ReplicatedStorage.Config.WorldConfigsBuilder
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TableUtils = require(ReplicatedStorage.Utilities.TableUtils);
local v1 = {};
local Shared = script.Parent:WaitForChild("Shared");
local GameplayDefaults = require(Shared:WaitForChild("GameplayDefaults"));
local Progression = Shared:WaitForChild("Progression");
local Worlds = script.Parent:WaitForChild("Worlds");
local u2 = { "STEP_AWARDS", "WIN_AMOUNTS", "WIN_MIN_TIMES" };

local function mergeWinsProgression(p3) -- Line: 24
    -- upvalues: u2 (copy), Progression (copy)
    local v4 = {};

    for _, v in ipairs(u2) do
        v4[v] = {};
    end;

    for i = 1, p3 do
        local v5 = Progression:FindFirstChild("WinBlocks_World" .. i);

        if v5 then
            local v6 = require(v5);

            for _, v in ipairs(u2) do
                local v7 = v6[v];

                if v7 then
                    for i2, v2 in pairs(v7) do
                        v4[v][i2] = v2;
                    end;
                end;
            end;
        end;
    end;

    return v4;
end;

local function attachHelpers(u8, p9) -- Line: 49
    function u8.IsWorld(p10, p11) -- Line: 50
        -- upvalues: u8 (copy)
        return u8.WORLD == p11;
    end;

    function u8.GetXPRequired(p12) -- Line: 55
        -- upvalues: u8 (copy)
        return p12 <= 0 and 0 or math.round(u8.BASE_XP * u8.XP_GROWTH ^ (p12 - 1));
    end;

    function u8.GetRebirthProductId(p13) -- Line: 62
        -- upvalues: u8 (copy)
        local v14 = (p13 or 0) + 1;

        if v14 <= 7 then
            return u8.DEV_PRODUCTS.INSTANT_REBIRTH_T1;
        end;

        if v14 <= 13 then
            return u8.DEV_PRODUCTS.INSTANT_REBIRTH_T2;
        end;

        if v14 <= 20 then
            return u8.DEV_PRODUCTS.INSTANT_REBIRTH_T3;
        end;

        return u8.DEV_PRODUCTS.INSTANT_REBIRTH_T4;
    end;

    local u15 = p9.SPEED_FORMULA and p9.SPEED_FORMULA.FLAT_BELOW_LEVEL;

    function u8.CalculateMaxSpeed(p16) -- Line: 79
        -- upvalues: u15 (copy), u8 (copy)
        if u15 and p16 < u15 then
            return u8.DEFAULT_WALKSPEED;
        end;

        if u15 then
            p16 = p16 - u15;
        end;

        return math.min(u8.DEFAULT_WALKSPEED + p16 * u8.SPEED_GAIN_PER_LEVEL, u8.MAX_LEVEL_SPEED_CAP);
    end;
end;

function v1.build(p17) -- Line: 90
    -- upvalues: TableUtils (copy), GameplayDefaults (copy), mergeWinsProgression (copy), Worlds (copy), attachHelpers (copy)
    local v18 = TableUtils.Copy(GameplayDefaults, true);
    local v19 = mergeWinsProgression(p17);

    for i, v in pairs(v19) do
        v18[i] = v;
    end;

    local v20 = Worlds:FindFirstChild("World" .. p17);
    local v21 = "[WorldConfigsBuilder] Module monde introuvable : World" .. tostring(p17);
    assert(v20, v21);
    local v22 = TableUtils.Copy(require(v20), true);

    for i, v in pairs(v22) do
        v18[i] = v;
    end;

    attachHelpers(v18, v22);

    return v18;
end;

return v1;