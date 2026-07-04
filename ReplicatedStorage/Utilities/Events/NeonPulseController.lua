-- Ruta Original: ReplicatedStorage.Utilities.Events.NeonPulseController
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ConcertSharedConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ConcertSharedConfig"));
local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 8
    -- upvalues: u1 (copy)
    local v2 = setmetatable({}, u1);
    v2._parts = {};
    v2._modelParts = {};
    v2._connections = {};
    v2._time = 0;
    v2:_init();

    return v2;
end;

function u1._cacheModel(u3, u4) -- Line: 19
    if not u4:IsA("Model") then
        return;
    end;

    if u3._modelParts[u4] then
        return;
    end;

    local v5 = {};

    for _, descendant in ipairs(u4:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Material = Enum.Material.Neon;
            u3._parts[descendant] = true;
            table.insert(v5, descendant);
        end;
    end;

    u3._modelParts[u4] = v5;
    local v7 = u4.DescendantAdded:Connect(function(p6) -- Line: 33
        -- upvalues: u3 (copy), u4 (copy)
        if p6:IsA("BasePart") then
            p6.Material = Enum.Material.Neon;
            u3._parts[p6] = true;
            table.insert(u3._modelParts[u4], p6);
        end;
    end);
    local v11 = u4.DescendantRemoving:Connect(function(p8) -- Line: 40
        -- upvalues: u3 (copy), u4 (copy)
        if p8:IsA("BasePart") then
            u3._parts[p8] = nil;
            local v9 = u3._modelParts[u4];
            local v10 = v9 and table.find(v9, p8);

            if v10 then
                table.remove(v9, v10);
            end;
        end;
    end);
    table.insert(u3._connections, v7);
    table.insert(u3._connections, v11);
end;

function u1._uncacheModel(p12, p13) -- Line: 56
    local v14 = p12._modelParts[p13];

    if v14 then
        for _, v in ipairs(v14) do
            p12._parts[v] = nil;
        end;

        p12._modelParts[p13] = nil;
    end;
end;

function u1._cachePart(p15, p16) -- Line: 66
    if not p16:IsA("BasePart") then
        return;
    end;

    p16.Material = Enum.Material.Neon;
    p15._parts[p16] = true;
end;

function u1._uncachePart(p17, p18) -- Line: 72
    p17._parts[p18] = nil;
end;

function u1._init(u19) -- Line: 76
    -- upvalues: CollectionService (copy)
    for _, v in ipairs(CollectionService:GetTagged("Neons")) do
        u19:_cacheModel(v);
    end;

    local v21 = CollectionService:GetInstanceAddedSignal("Neons"):Connect(function(p20) -- Line: 81
        -- upvalues: u19 (copy)
        u19:_cacheModel(p20);
    end);
    local v23 = CollectionService:GetInstanceRemovedSignal("Neons"):Connect(function(p22) -- Line: 84
        -- upvalues: u19 (copy)
        u19:_uncacheModel(p22);
    end);
    table.insert(u19._connections, v21);
    table.insert(u19._connections, v23);

    for _, v in ipairs(CollectionService:GetTagged("NeonPart")) do
        u19:_cachePart(v);
    end;

    local v25 = CollectionService:GetInstanceAddedSignal("NeonPart"):Connect(function(p24) -- Line: 94
        -- upvalues: u19 (copy)
        u19:_cachePart(p24);
    end);
    local v27 = CollectionService:GetInstanceRemovedSignal("NeonPart"):Connect(function(p26) -- Line: 97
        -- upvalues: u19 (copy)
        u19:_uncachePart(p26);
    end);
    table.insert(u19._connections, v25);
    table.insert(u19._connections, v27);
end;

function u1.update(p28, p29) -- Line: 104
    -- upvalues: ConcertSharedConfig (copy)
    local v30 = ConcertSharedConfig.NeonPulseDuration or 4;
    local v31 = ConcertSharedConfig.NeonMinimumBrightness or 0;
    local v32 = ConcertSharedConfig.NeonMaximumBrightness or 1;
    local v33 = ConcertSharedConfig.NeonBaseColor or Color3.fromRGB(103, 172, 114);
    local v34 = ConcertSharedConfig.NeonPulseColor or Color3.fromRGB(0, 0, 0);
    p28._time = (p28._time + p29) % v30;
    local v35 = (math.sin(p28._time * 3.141592653589793 * 2 / v30) + 1) / 2;
    local v36 = v34:Lerp(v33, v31 + (v32 - v31) * v35);

    for i in pairs(p28._parts) do
        if i and i.Parent then
            i.Color = v36;
        else
            p28._parts[i] = nil;
        end;
    end;
end;

function u1.destroy(p37) -- Line: 131
    for _, v in ipairs(p37._connections) do
        v:Disconnect();
    end;

    table.clear(p37._connections);
    table.clear(p37._parts);
    table.clear(p37._modelParts);
end;

return u1;