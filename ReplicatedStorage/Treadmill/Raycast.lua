-- Ruta Original: ReplicatedStorage.Treadmill.Raycast
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Treadmills = require(ReplicatedStorage:WaitForChild("Treadmill"):WaitForChild("Treadmills"));
local u1 = RaycastParams.new();
u1.FilterType = Enum.RaycastFilterType.Include;
local u2 = {};

local function rebuildFilter() -- Line: 11
    -- upvalues: u2 (copy), u1 (copy)
    local v3 = {};

    for i in pairs(u2) do
        v3[#v3 + 1] = i;
    end;

    u1.FilterDescendantsInstances = v3;
end;

for _, v in Treadmills do
    for _, v2 in CollectionService:GetTagged(v) do
        u2[v2] = true;
    end;

    CollectionService:GetInstanceAddedSignal(v):Connect(function(p4) -- Line: 24
        -- upvalues: u2 (copy), u1 (copy)
        u2[p4] = true;
        u1:AddToFilter({ p4 });
    end);
    CollectionService:GetInstanceRemovedSignal(v):Connect(function(p5) -- Line: 29
        -- upvalues: u2 (copy), rebuildFilter (copy)
        u2[p5] = nil;
        rebuildFilter();
    end);
end;

rebuildFilter();

return {
    getTreadmillFilter = function() -- Line: 40, Name: getTreadmillFilter
        -- upvalues: u1 (copy)
        return u1;
    end
};