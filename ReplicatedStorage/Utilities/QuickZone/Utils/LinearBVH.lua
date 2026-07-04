-- Ruta Original: ReplicatedStorage.Utilities.QuickZone.Utils.LinearBVH
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Geometry = require(script.Parent.Geometry);
require(script.Parent.Parent.Types);
local u1 = Vector3.new(1, 1, 1) * (1 / 0);
local u2 = -u1;
local unionBounds = Geometry.unionBounds;
local getObjectBounds = Geometry.getObjectBounds;
local getMortonScale = Geometry.getMortonScale;
local positionToMortonCode = Geometry.positionToMortonCode;
local v3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};

local function getSplitPos(p8, p9, p10) -- Line: 28
    if p10 == p9 + 1 then
        return p9 + 1;
    end;

    local mortonCode = p8[p9].mortonCode;
    local mortonCode2 = p8[p10].mortonCode;

    if mortonCode == mortonCode2 then
        return (p9 + p10) // 2;
    end;

    local v11 = bit32.bxor(mortonCode, mortonCode2);
    local v12 = 31 - bit32.countlz(v11);
    local v13 = bit32.lshift(1, v12);
    local v14 = bit32.band(mortonCode, v13);

    while p10 - p9 > 1 do
        local v15 = (p9 + p10) // 2;

        if bit32.band(p8[v15].mortonCode, v13) == v14 then
            p9 = v15;
            v15 = p10;
        end;

        p10 = v15;
    end;

    return p9 + 1;
end;

local function buildFlatTree(p16, p17, p18, p19, p20, p21, p22) -- Line: 57
    -- upvalues: getSplitPos (copy), buildFlatTree (copy), unionBounds (copy)
    local v23 = p21.nodes[p22];

    if not v23 then
        v23 = {};
        p21.nodes[p22] = v23;
    end;

    if p19 == p20 then
        local id = p16[p19].id;
        local v24 = p17[id];
        local v25 = p18[id];
        v23.min = v24;
        v23.max = v25;
        v23.id = id;
        v23.skipIndex = p22 + 1;

        return p22 + 1, v24, v25;
    end;

    local v26 = getSplitPos(p16, p19, p20);
    v23.id = -1;
    local v27, v28, v29 = buildFlatTree(p16, p17, p18, p19, v26 - 1, p21, p22 + 1);
    local v30, v31, v32 = buildFlatTree(p16, p17, p18, v26, p20, p21, v27);
    local v33, v34 = unionBounds(v28, v29, v31, v32);
    v23.min = v33;
    v23.max = v34;
    v23.skipIndex = v30;

    return v30, v33, v34;
end;

function v3.build(p35, p36, p37) -- Line: 99
    -- upvalues: u6 (copy), u7 (copy), u1 (copy), u2 (copy), getObjectBounds (copy), u4 (copy), u5 (copy), getMortonScale (copy), positionToMortonCode (copy), buildFlatTree (copy)
    table.clear(u6);
    table.clear(u7);
    local v38 = u1;
    local v39 = u2;
    local v40 = 0;

    for i, v in p36 do
        local v41, v42 = getObjectBounds(v, p37[i]);
        u6[i] = v41;
        u7[i] = v42;
        v38 = vector.min(v38, v41);
        v39 = vector.max(v39, v42);
        v40 = v40 + 1;
        local v43 = u4[v40];

        if not v43 then
            local v44 = #u5;

            if v44 > 0 then
                v43 = u5[v44];
                u5[v44] = nil;
            else
                v43 = {
                    id = 0,
                    mortonCode = 0
                };
            end;

            u4[v40] = v43;
        end;

        v43.id = i;
    end;

    if v40 == 0 then
        p35.count = 0;

        return;
    end;

    local v45 = #u4;

    if v40 < v45 then
        local v46 = #u5;

        for i = v40 + 1, v45 do
            v46 = v46 + 1;
            u5[v46] = u4[i];
            u4[i] = nil;
        end;
    end;

    local v47 = vector.max(Vector3.new(1, 1, 1), (v39 - v38) * 0.01);
    local v48 = v38 - v47;
    local v49, v50, v51 = getMortonScale(v48, v39 + v47);

    for i = 1, v40 do
        local v52 = u4[i];
        v52.mortonCode = positionToMortonCode(p36[v52.id].Position, v48, v49, v50, v51);
    end;

    table.sort(u4, function(p53, p54) -- Line: 163
        return p53.mortonCode < p54.mortonCode;
    end);
    p35.count = buildFlatTree(u4, u6, u7, 1, v40, p35, 1) - 1;
end;

function v3.queryPoint(p55, p56, p57) -- Line: 172
    local nodes = p55.nodes;
    local X = p56.X;
    local Y = p56.Y;
    local Z = p56.Z;
    local v58 = 1;

    while v58 <= p55.count do
        local v59 = nodes[v58];
        local min = v59.min;
        local max = v59.max;

        if min.X <= X and (X <= max.X and (min.Y <= Y and (Y <= max.Y and (min.Z <= Z and Z <= max.Z)))) then
            v58 = v58 + 1;
            local id = v59.id;

            if id > 0 then
                p57(id);
            end;
        else
            v58 = v59.skipIndex;
        end;
    end;
end;

return v3;