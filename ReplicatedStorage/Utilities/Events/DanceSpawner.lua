-- Ruta Original: ReplicatedStorage.Utilities.Events.DanceSpawner
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 5
    -- upvalues: u1 (copy)
    local v3 = p2 or {};
    local v4 = setmetatable({}, u1);
    v4._spinSpeed = v3.spinSpeed or 10;
    v4._jumpFreq = v3.jumpFreq or 5;
    v4._jumpHeight = v3.jumpHeight or 2;
    v4._items = {};

    return v4;
end;

function u1.setup(p5, p6, p7, p8) -- Line: 22
    p5._items = {};

    if not p7 then
        return;
    end;

    for _, child in p7:GetChildren() do
        if child:IsA("Model") then
            local v9;

            if p8 then
                v9 = p6:Add(p8:Clone());
                v9:PivotTo(child:GetPivot());
            else
                v9 = p6:Add(child:Clone());
            end;

            v9.Parent = workspace;
            local _items = p5._items;
            local v10 = {
                model = v9,
                baseCFrame = child:GetPivot(),
                phaseOffset = math.random() * 3.141592653589793 * 2
            };
            table.insert(_items, v10);
        end;
    end;
end;

function u1.update(p11, p12) -- Line: 45
    for _, v in p11._items do
        if v.model and v.model.Parent then
            local v13 = math.sin((p12 + v.phaseOffset) * p11._jumpFreq);
            local v14 = math.abs(v13) * p11._jumpHeight;
            local v15 = p12 * p11._spinSpeed + v.phaseOffset;
            v.model:PivotTo(v.baseCFrame * CFrame.new(0, v14, 0) * CFrame.Angles(0, v15, 0));
        end;
    end;
end;

return u1;