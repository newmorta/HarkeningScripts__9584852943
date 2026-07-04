-- Ruta Original: ReplicatedStorage.Utilities.Events.ParticleZone
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 5
    -- upvalues: u1 (copy)
    local v3 = setmetatable({}, u1);
    v3._diameter = p2 and p2.diameter or 50;
    v3.part = nil;

    return v3;
end;

function u1.setup(p4, p5, p6) -- Line: 15
    local _diameter = p4._diameter;
    local v7 = p5:Add(Instance.new("Part"));
    v7.Name = "ParticleZone";
    v7.Size = Vector3.new(_diameter, _diameter, _diameter);
    v7.Shape = Enum.PartType.Ball;
    v7.Transparency = 1;
    v7.Anchored = true;
    v7.CanCollide = false;
    v7.CanQuery = false;
    v7.CanTouch = false;
    v7.CastShadow = false;
    v7.CFrame = p6 or CFrame.new();
    v7.Parent = workspace;
    p4.part = v7;

    return v7;
end;

function u1.update(p8, p9) -- Line: 34
    if p8.part and p8.part.Parent then
        p8.part.CFrame = CFrame.new(p9);
    end;
end;

return u1;