-- Ruta Original: ReplicatedStorage.Utilities.QuickZone.Classes.Zones
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 16
    -- upvalues: u1 (copy)
    local v3;

    if p2 and p2.isDynamic ~= nil then
        v3 = p2.isDynamic;
    else
        v3 = false;
    end;

    local v4;

    if p2 then
        v4 = p2.metadata;
    else
        v4 = nil;
    end;

    local v5;

    if p2 and p2.autoSync ~= nil then
        v5 = p2.autoSync;
    else
        v5 = false;
    end;

    return setmetatable({
        dynamic = v3,
        metadata = v4,
        autoSync = v5,
        zones = {},
        observers = {},
        onDestroyObserverCleanups = {},
        onDestroyZoneCleanups = {}
    }, u1);
end;

function u1.attach(u6, u7) -- Line: 43
    if u6.observers[u7] then
        return u6;
    end;

    u6.observers[u7] = true;
    u6.onDestroyObserverCleanups[u7] = u7:onDestroy(function() -- Line: 49
        -- upvalues: u6 (copy), u7 (copy)
        u6:detach(u7);
    end);

    for i, _ in u6.zones do
        u7:attach(i);
    end;

    return u6;
end;

function u1.detach(p8, p9) -- Line: 69
    if not p8.observers[p9] then
        return p8;
    end;

    p8.observers[p9] = nil;
    local v10 = p8.onDestroyObserverCleanups[p9];

    if v10 then
        v10();
        p8.onDestroyObserverCleanups[p9] = nil;
    end;

    for i, _ in p8.zones do
        p9:detach(i);
    end;

    return p8;
end;

function u1.sync(p11) -- Line: 96
    if not p11.dynamic then
        return p11;
    end;

    for i, _ in p11.zones do
        i:sync();
    end;

    return p11;
end;

function u1.getZones(p12) -- Line: 113
    local v13 = {};

    for i, _ in p12.zones do
        table.insert(v13, i);
    end;

    return v13;
end;

function u1.isDynamic(p14) -- Line: 128
    return p14.dynamic;
end;

function u1.isPointInside(p15, p16) -- Line: 140
    for i, _ in p15.zones do
        if i:isPointInside(p16) then
            return true;
        end;
    end;

    return false;
end;

function u1.setAutoSync(p17, p18) -- Line: 159
    if p17.autoSync == p18 then
        return p17;
    end;

    p17.autoSync = p18;

    for i, _ in p17.zones do
        i:setAutoSync(p18);
    end;

    return p17;
end;

function u1.setDynamic(p19, p20) -- Line: 186
    if p19.dynamic == p20 then
        return p19;
    end;

    p19.dynamic = p20;

    for i, _ in p19.zones do
        i:setDynamic(p20);
    end;

    return p19;
end;

function u1.setMetadata(p21, p22) -- Line: 209
    p21.metadata = p22;

    for i, _ in p21.zones do
        i:setMetadata(p22);
    end;

    return p21;
end;

function u1.getMetadata(p23) -- Line: 224
    return p23.metadata;
end;

function u1.contains(p24, p25) -- Line: 236
    return p24.zones[p25] == true;
end;

function u1.iterZones(u26) -- Line: 247
    local u27 = nil;

    return function() -- Line: 249
        -- upvalues: u27 (ref), u26 (copy)
        u27 = next(u26.zones, u27);

        return u27;
    end;
end;

function u1.getReferences(p28) -- Line: 262
    local v29 = {};

    for i, _ in p28.zones do
        local v30 = i:getReference();

        if v30 then
            table.insert(v29, v30);
        end;
    end;

    return v29;
end;

function u1.iterReferences(u31) -- Line: 281
    local u32 = nil;

    return function() -- Line: 284
        -- upvalues: u32 (ref), u31 (copy)
        while true do
            u32 = next(u31.zones, u32);

            if not u32 then
                break;
            end;

            local v33 = u32:getReference();

            if v33 then
                return v33, u32;
            end;
        end;

        return nil, nil;
    end;
end;

function u1.onDestroy(u34, u35) -- Line: 308
    if not u34.onDestroyCallbacks then
        u34.onDestroyCallbacks = {};
    end;

    table.insert(u34.onDestroyCallbacks, u35);

    return function() -- Line: 315
        -- upvalues: u34 (copy), u35 (copy)
        local v36 = table.find(u34.onDestroyCallbacks, u35);

        if v36 then
            table.remove(u34.onDestroyCallbacks, v36);
        end;
    end;
end;

function u1.destroy(p37) -- Line: 334
    if p37.onDestroyCallbacks then
        for _, v in p37.onDestroyCallbacks do
            task.spawn(v);
        end;

        table.clear(p37.onDestroyCallbacks);
    end;

    for _, v in p37.onDestroyObserverCleanups do
        v();
    end;

    for i, v in p37.onDestroyZoneCleanups do
        v();
        i:destroy();
    end;

    table.clear(p37.zones);
    table.clear(p37.observers);
    table.clear(p37.onDestroyObserverCleanups);
    table.clear(p37.onDestroyZoneCleanups);
    setmetatable(p37, nil);
end;

function u1.add(u38, u39) -- Line: 360
    if u38.zones[u39] then
        return;
    end;

    if u38.metadata ~= nil and u39:getMetadata() == nil then
        u39:setMetadata(u38.metadata);
    end;

    if u38.dynamic and not u39:isDynamic() then
        u39:setDynamic(true);
    end;

    if u38.autoSync then
        u39:setAutoSync(true);
    end;

    u38.zones[u39] = true;
    u38.onDestroyZoneCleanups[u39] = u39:onDestroy(function() -- Line: 379
        -- upvalues: u38 (copy), u39 (copy)
        u38:remove(u39);
    end);

    for i, _ in u38.observers do
        i:attach(u39);
    end;
end;

function u1.remove(p40, p41) -- Line: 389
    if not p40.zones[p41] then
        return;
    end;

    p40.zones[p41] = nil;
    local v42 = p40.onDestroyZoneCleanups[p41];

    if v42 then
        v42();
        p40.onDestroyZoneCleanups[p41] = nil;
    end;

    for i, _ in p40.observers do
        i:detach(p41);
    end;
end;

return u1;