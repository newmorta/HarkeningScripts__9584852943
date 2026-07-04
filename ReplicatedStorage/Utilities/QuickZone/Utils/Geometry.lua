-- Ruta Original: ReplicatedStorage.Utilities.QuickZone.Utils.Geometry
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Value = Enum.PartType.Block.Value;
local Value2 = Enum.PartType.Ball.Value;
local Value3 = Enum.PartType.Cylinder.Value;
local Value4 = Enum.PartType.Wedge.Value;
local Value5 = Enum.PartType.CornerWedge.Value;
local u1 = table.create(1024);

for i = 0, 1023 do
    local v2 = bit32.lshift(i, 16);
    local v3 = bit32.bor(v2, i);
    local v4 = bit32.band(v3, 4278190335);
    local v5 = bit32.lshift(v4, 8);
    local v6 = bit32.bor(v5, v4);
    local v7 = bit32.band(v6, 251719695);
    local v8 = bit32.lshift(v7, 4);
    local v9 = bit32.bor(v8, v7);
    local v10 = bit32.band(v9, 51130563);
    local v11 = bit32.lshift(v10, 2);
    local v12 = bit32.bor(v11, v10);
    local v13 = bit32.band(v12, 153391689);
    u1[i + 1] = v13;
end;

local function expandBits(p14) -- Line: 30
    -- upvalues: u1 (copy)
    return u1[bit32.band(p14, 1023) + 1];
end;

return {
    unionBounds = function(p15, p16, p17, p18) -- Line: 36, Name: unionBounds
        return vector.min(p15, p17), vector.max(p16, p18);
    end,

    getObjectBounds = function(p19, p20) -- Line: 40, Name: getObjectBounds
        local Position = p19.Position;
        local RightVector = p19.RightVector;
        local UpVector = p19.UpVector;
        local LookVector = p19.LookVector;
        local v21 = math.abs(RightVector.X) * p20.X + math.abs(UpVector.X) * p20.Y + math.abs(LookVector.X) * p20.Z;
        local v22 = math.abs(RightVector.Y) * p20.X + math.abs(UpVector.Y) * p20.Y + math.abs(LookVector.Y) * p20.Z;
        local v23 = math.abs(RightVector.Z) * p20.X + math.abs(UpVector.Z) * p20.Y + math.abs(LookVector.Z) * p20.Z;
        local v24 = Vector3.new(v21, v22, v23);

        return Position - v24, Position + v24;
    end,

    getMortonScale = function(p25, p26) -- Line: 55, Name: getMortonScale
        local v27 = p26 - p25;

        return 1023 / v27.X, 1023 / v27.Y, 1023 / v27.Z;
    end,

    positionToMortonCode = function(p28, p29, p30, p31, p32) -- Line: 60, Name: positionToMortonCode
        -- upvalues: u1 (copy)
        local v33 = math.clamp((p28.X - p29.X) * p30, 0, 1023);
        local v34 = math.floor(v33);
        local v35 = math.clamp((p28.Y - p29.Y) * p31, 0, 1023);
        local v36 = math.floor(v35);
        local v37 = math.clamp((p28.Z - p29.Z) * p32, 0, 1023);
        local v38 = math.floor(v37);
        local v39 = u1[bit32.band(v34, 1023) + 1];
        local v40 = u1[bit32.band(v36, 1023) + 1];
        local v41 = bit32.lshift(v40, 1);
        local v42 = u1[bit32.band(v38, 1023) + 1];
        local v43 = bit32.lshift(v42, 2);

        return bit32.bor(v39, v41, v43);
    end,

    isPointInShape = function(p44, p45, p46, p47) -- Line: 74, Name: isPointInShape
        -- upvalues: Value (copy), Value3 (copy), Value2 (copy), Value4 (copy), Value5 (copy)
        if p47 == Value then
            local v48 = p45:PointToObjectSpace(p44);
            local v49 = vector.abs(v48);

            return vector.min(v49, p46) == v49;
        end;

        if p47 == Value3 then
            local X = p46.X;
            local v50 = p45.Position - p45.RightVector * X;
            local RightVector = p45.RightVector;
            local v51 = vector.dot(p44 - v50, RightVector);

            if v51 < 0 or v51 > X * 2 then
                return false;
            end;

            local v52 = v50 + RightVector * v51;

            return vector.dot(p44 - v52, p44 - v52) <= p46.Y * p46.Y;
        end;

        if p47 == Value2 then
            local v53 = p46.X * p46.X;
            local Position = p45.Position;

            return vector.dot(Position - p44, Position - p44) <= v53;
        end;

        if p47 == Value4 then
            local v54 = p45:PointToObjectSpace(p44);
            local v55 = vector.abs(v54);

            if vector.min(v55, p46) ~= v55 then
                return false;
            end;

            local v56 = p46 * 2;

            return v54.Y / v56.Y - v54.Z / v56.Z <= 0;
        end;

        if p47 ~= Value5 then
            return false;
        end;

        local v57 = p46 * 2;
        local v58 = p45:PointToObjectSpace(p44);
        local v59 = Vector3.new(0, v57.Z, v57.Y);
        local v60 = vector.normalize(v59);

        if vector.dot(v58, v60) > 0 then
            return false;
        end;

        local v61 = Vector3.new(-v57.Y, v57.X, 0);
        local v62 = vector.normalize(v61);

        if vector.dot(v58, v62) > 0 then
            return false;
        end;

        local v63 = vector.abs(v58);

        return vector.min(v63, p46) == v63;
    end
};