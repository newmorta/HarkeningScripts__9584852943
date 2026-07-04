-- Ruta Original: ReplicatedStorage.Utilities.QuickZoneSampling
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

require(script.Parent.QuickZone);

local function samplePointInCylinderZone(p1, p2, p3) -- Line: 17
    local v4 = p2 * 0.5;
    local X = v4.X;
    local v5 = v4.Y * 0.85;
    local RightVector = p1.RightVector;
    local v6 = p1.Position - RightVector * X;
    local v7 = p3:NextNumber() * (X * 2);
    local v8 = p3:NextNumber() * 3.141592653589793 * 2;
    local v9 = p3:NextNumber();
    local v10 = math.sqrt(v9) * v5;

    return v6 + RightVector * v7 + (p1.UpVector * (math.cos(v8) * v10) + p1.LookVector * (math.sin(v8) * v10));
end;

local u24 = {
    samplePointInZone = function(p11, p12) -- Line: 33, Name: samplePointInZone
        -- upvalues: samplePointInCylinderZone (copy)
        local v13 = p11:getCFrame();
        local v14 = p11:getSize();
        local v15 = p11:getShape();

        if v15 == "Cylinder" then
            return samplePointInCylinderZone(v13, v14, p12);
        end;

        if v15 ~= "Ball" then
            local v16 = (p12:NextNumber() - 0.5) * v14.X * 0.85;
            local v17 = (p12:NextNumber() - 0.5) * v14.Y * 0.85;
            local v18 = (p12:NextNumber() - 0.5) * v14.Z * 0.85;

            return (v13 * CFrame.new(v16, v17, v18)).Position;
        end;

        local v19 = (v14 * 0.5).X * 0.85;
        local v20 = p12:NextNumber() - 0.5;
        local v21 = p12:NextNumber() - 0.5;
        local v22 = p12:NextNumber() - 0.5;
        local v23 = Vector3.new(v20, v21, v22);

        if v23.Magnitude > 0 then
            v23 = v23.Unit * (p12:NextNumber() * v19);
        end;

        return (v13 * CFrame.new(v23)).Position;
    end
};

function u24.sampleRandomPoint(p25, p26, p27) -- Line: 62
    -- upvalues: u24 (copy)
    if #p25 == 0 then
        return nil;
    end;

    for _ = 1, 32 do
        local v28 = p25[p27:NextInteger(1, #p25)];
        local v29 = u24.samplePointInZone(v28, p27);

        if p26(v29) then
            return v29;
        end;
    end;

    for _, v in p25 do
        local v30 = v:getPosition();

        if p26(v30) then
            return v30;
        end;
    end;

    return u24.samplePointInZone(p25[1], p27);
end;

function u24.sampleRandomPointFromCollection(u31, p32) -- Line: 89
    -- upvalues: u24 (copy)
    local v33 = u31:getZones();

    return u24.sampleRandomPoint(v33, function(p34) -- Line: 94
        -- upvalues: u31 (copy)
        return u31:isPointInside(p34);
    end, p32);
end;

return u24;