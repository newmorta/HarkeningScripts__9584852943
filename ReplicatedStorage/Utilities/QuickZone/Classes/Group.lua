-- Ruta Original: ReplicatedStorage.Utilities.QuickZone.Classes.Group
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
require(script.Parent.Parent.Types);
local Config = require(script.Parent.Parent.Config);
local PlayerTracker = require(script.Parent.Parent.Core.PlayerTracker);
local State = require(script.Parent.Parent.Core.State);
local Log = require(script.Parent.Parent.Utils.Log);
local POS = Config.Strategy.POS;
local PRIM = Config.Strategy.PRIM;
local WORLD = Config.Strategy.WORLD;
local CFRAME = Config.Strategy.CFRAME;
local TRANSFORM = Config.Strategy.TRANSFORM;
local PIVOT = Config.Strategy.PIVOT;
local u1 = Config.Observer.precision ^ 2;
local u2 = RunService:IsClient();
local u3 = {};
u3.__index = u3;

function u3.new(p4) -- Line: 52
    -- upvalues: State (copy), Config (copy), u3 (copy)
    local nextGroupId = State.nextGroupId;
    local v5 = State;
    v5.nextGroupId = v5.nextGroupId + 1;
    local autoClean = Config.Group.autoClean;

    if p4 and p4.autoClean ~= nil then
        autoClean = p4.autoClean;
    end;

    local v6 = setmetatable({
        id = nextGroupId,
        entities = {},
        entityIndices = {},
        autoClean = autoClean
    }, u3);
    State.groups[nextGroupId] = v6;
    State.groupToObservers[nextGroupId] = {};
    State.groupEntityCleanups[nextGroupId] = {};

    if p4 and p4.entities then
        v6:_addBulk(p4.entities);
    end;

    return v6;
end;

function u3.fromTag(p7) -- Line: 91
    -- upvalues: u3 (copy), CollectionService (copy)
    local u8 = u3.new({
        autoClean = false,
        entities = nil
    });
    u8.isManaged = true;
    local u9 = {};

    local function checkAncestry(p10) -- Line: 97
        -- upvalues: u8 (copy)
        if p10:IsDescendantOf(workspace) then
            u8:_add(p10);

            return;
        end;

        u8:_remove(p10);
    end;

    local function startWatching(u11) -- Line: 105
        -- upvalues: u9 (copy), u8 (copy)
        if u9[u11] then
            return;
        end;

        if not (u11:IsA("BasePart") or (u11:IsA("Model") or (u11:IsA("Attachment") or (u11:IsA("Bone") or u11:IsA("Camera"))))) then
            return;
        end;

        u9[u11] = u11.AncestryChanged:Connect(function() -- Line: 122
            -- upvalues: u11 (copy), u8 (ref)
            local v12 = u11;

            if v12:IsDescendantOf(workspace) then
                u8:_add(v12);

                return;
            end;

            u8:_remove(v12);
        end);

        if u11:IsDescendantOf(workspace) then
            u8:_add(u11);

            return;
        end;

        u8:_remove(u11);
    end;

    local u13 = CollectionService:GetInstanceAddedSignal(p7):Connect(startWatching);
    local u16 = CollectionService:GetInstanceRemovedSignal(p7):Connect(function(p14) -- Line: 129, Name: stopWatching
        -- upvalues: u9 (copy), u8 (copy)
        local v15 = u9[p14];

        if v15 then
            v15:Disconnect();
            u9[p14] = nil;
        end;

        u8:_remove(p14);
    end);

    for _, v in CollectionService:GetTagged(p7) do
        startWatching(v);
    end;

    u8:onDestroy(function() -- Line: 145
        -- upvalues: u13 (copy), u16 (copy), u9 (copy), u8 (copy)
        u13:Disconnect();
        u16:Disconnect();

        for i, _ in u9 do
            local v17 = u9[i];

            if v17 then
                v17:Disconnect();
                u9[i] = nil;
            end;

            u8:_remove(i);
        end;
    end);

    return u8;
end;

function u3.players() -- Line: 168
    -- upvalues: u3 (copy), Players (copy)
    local u18 = u3.new({
        autoClean = false,
        entities = nil
    });
    u18.isManaged = true;
    local u20 = Players.PlayerAdded:Connect(function(p19) -- Line: 172
        -- upvalues: u18 (copy)
        u18:_add(p19);
    end);

    for _, v in Players:GetPlayers() do
        u18:_add(v);
    end;

    u18:onDestroy(function() -- Line: 180
        -- upvalues: u20 (copy)
        u20:Disconnect();
    end);

    return u18;
end;

function u3.localPlayer() -- Line: 200
    -- upvalues: u2 (copy), Log (copy), u3 (copy), Players (copy)
    if not u2 then
        Log.fatal("Group.localPlayer() can only be called on the Client.", nil);
    end;

    local v21 = u3.new({
        autoClean = false,
        entities = nil
    });
    v21.isManaged = true;
    v21:_add(Players.LocalPlayer);

    return v21;
end;

function u3.setAutoClean(u22, p23) -- Line: 224
    -- upvalues: Log (copy), State (copy)
    if u22.isManaged then
        Log.warn("Cannot set autoClean on a Managed Group. Ignoring request.", nil);

        return u22;
    end;

    if u22.autoClean == p23 then
        return u22;
    end;

    u22.autoClean = p23;
    local v24 = State.groupEntityCleanups[u22.id];

    if p23 then
        for _, v in u22.entities do
            if typeof(v) == "Instance" and not v24[v] then
                v24[v] = v.AncestryChanged:Connect(function(p25, p26) -- Line: 240
                    -- upvalues: u22 (copy), v (copy)
                    if not p26 then
                        u22:_remove(v);
                    end;
                end);
            end;
        end;

        return u22;
    end;

    for i, v in v24 do
        v:Disconnect();
        v24[i] = nil;
    end;

    return u22;
end;

function u3.add(p27, p28) -- Line: 288
    -- upvalues: Log (copy)
    if not p27.isManaged then
        return p27:_add(p28);
    end;

    Log.warn("Cannot manually add to a Managed Group. Ignoring request.", nil);

    return p27;
end;

function u3.addBulk(p29, p30) -- Line: 310
    -- upvalues: Log (copy)
    if not p29.isManaged then
        return p29:_addBulk(p30);
    end;

    Log.warn("Cannot manually addBulk to a Managed Group. Ignoring request.", nil);

    return p29;
end;

function u3.remove(p31, p32) -- Line: 327
    -- upvalues: Log (copy)
    if not p31.isManaged then
        return p31:_remove(p32);
    end;

    Log.warn("Cannot manually remove from a Managed Group. Ignoring request.", nil);

    return p31;
end;

function u3.removeBulk(p33, p34) -- Line: 344
    -- upvalues: Log (copy)
    if not p33.isManaged then
        return p33:_removeBulk(p34);
    end;

    Log.warn("Cannot manually removeBulk from a Managed Group. Ignoring request.", nil);

    return p33;
end;

function u3.clear(p35) -- Line: 361
    -- upvalues: Log (copy)
    if not p35.isManaged then
        return p35:_clear();
    end;

    Log.warn("Cannot clear a Managed Group. Ignoring request.", nil);

    return p35;
end;

function u3.contains(p36, p37) -- Line: 377
    -- upvalues: State (copy)
    local v38 = State.entityToGroups[State.referenceToEntity[p37] or p37];

    return v38 and v38[p36.id] == true and true or false;
end;

function u3.getId(p39) -- Line: 390
    return p39.id;
end;

function u3.getEntities(p40) -- Line: 401
    -- upvalues: State (copy)
    local v41 = table.create(#p40.entities);

    for i, v in ipairs(p40.entities) do
        v41[i] = State.entityToReference[v] or v;
    end;

    return v41;
end;

function u3.iterEntities(u42) -- Line: 424
    -- upvalues: State (copy)
    local u43 = nil;

    return function() -- Line: 427
        -- upvalues: u43 (ref), u42 (copy), State (ref)
        u43 = next(u42.entityIndices, u43);

        if u43 then
            return State.entityToReference[u43] or u43;
        end;

        return u43;
    end;
end;

function u3.onDestroy(u44, u45) -- Line: 451
    if not u44.onDestroyCallbacks then
        u44.onDestroyCallbacks = {};
    end;

    table.insert(u44.onDestroyCallbacks, u45);

    return function() -- Line: 458
        -- upvalues: u44 (copy), u45 (copy)
        local v46 = table.find(u44.onDestroyCallbacks, u45);

        if v46 then
            table.remove(u44.onDestroyCallbacks, v46);
        end;
    end;
end;

function u3.destroy(p47) -- Line: 474
    -- upvalues: State (copy)
    if p47.onDestroyCallbacks then
        for _, v in p47.onDestroyCallbacks do
            task.spawn(v);
        end;

        table.clear(p47.onDestroyCallbacks);
    end;

    for i = #p47.entities, 1, -1 do
        p47:_remove(p47.entities[i]);
    end;

    State.groupToObservers[p47.id] = nil;
    State.groups[p47.id] = nil;
    State.groupEntityCleanups[p47.id] = nil;
    setmetatable(p47, nil);
end;

function u3._add(u48, p49) -- Line: 493
    -- upvalues: PlayerTracker (copy), State (copy), POS (copy), WORLD (copy), CFRAME (copy), PRIM (copy), PIVOT (copy), TRANSFORM (copy), Log (copy), u1 (copy)
    if typeof(p49) == "Instance" and p49:IsA("Player") then
        PlayerTracker.subscribe(p49, u48);

        return u48;
    end;

    local u50 = State.referenceToEntity[p49] or p49;

    if not State.entityToGroups[u50] then
        State.entityToGroups[u50] = {};
    end;

    if State.entityToGroups[u50][u48.id] then
        return u48;
    end;

    State.entityToGroups[u50][u48.id] = true;

    if not State.entityData[u50] then
        local v51 = nil;

        if typeof(u50) == "Instance" then
            if u50:IsA("BasePart") then
                v51 = POS;
            elseif u50:IsA("Attachment") or u50:IsA("Bone") then
                v51 = WORLD;
            elseif u50:IsA("Camera") then
                v51 = CFRAME;
            elseif u50:IsA("Model") then
                v51 = u50.PrimaryPart and PRIM or PIVOT;
            end;
        elseif typeof(u50) == "table" then
            if u50.Position then
                v51 = POS;
            elseif u50.CFrame then
                v51 = CFRAME;
            elseif u50.Transform then
                v51 = TRANSFORM;
            elseif u50.WorldPosition then
                v51 = WORLD;
            elseif u50.GetPivot then
                v51 = PIVOT;
            end;
        end;

        if not v51 then
            Log.nonFatal("Invalid entity (%s). Expected BasePart, Model, Bone, Attachment, Camera, or a valid EntityTable.", nil, (tostring(u50)));
            State.entityToGroups[u50][u48.id] = nil;

            return u48;
        end;

        State.entityData[u50] = {
            lastPosition = Vector3.new(0, 0, 0),
            updateRate = -1,
            bucketIndex = 0,
            dynamicVersion = -1,
            staticVersion = -1,
            logicVersion = -1,
            needsStatic = false,
            needsDynamic = false,
            strategy = v51,
            activeObserverMemberships = {},
            precisionSq = u1
        };
    end;

    local v52 = #u48.entities + 1;
    u48.entities[v52] = u50;
    u48.entityIndices[u50] = v52;
    State.dirtyProfiles[u50] = true;
    State.dirtyTopology[u50] = true;
    State.entityData[u50].logicVersion = -1;

    if u48.autoClean and (typeof(u50) == "Instance" and not State.groupEntityCleanups[u48.id][u50]) then
        State.groupEntityCleanups[u48.id][u50] = u50.AncestryChanged:Connect(function(p53, p54) -- Line: 571
            -- upvalues: u48 (copy), u50 (copy)
            if not p54 then
                u48:_remove(u50);
            end;
        end);
    end;

    return u48;
end;

function u3._addBulk(p55, p56) -- Line: 581
    for _, v in p56 do
        p55:_add(v);
    end;

    return p55;
end;

function u3._remove(p57, p58) -- Line: 588
    -- upvalues: PlayerTracker (copy), State (copy)
    if typeof(p58) == "Instance" and p58:IsA("Player") then
        PlayerTracker.unsubscribe(p58, p57);

        return p57;
    end;

    local v59 = State.referenceToEntity[p58] or p58;

    if not (State.entityToGroups[v59] and State.entityToGroups[v59][p57.id]) then
        return p57;
    end;

    local v60 = State.groupEntityCleanups[p57.id][v59];

    if v60 then
        v60:Disconnect();
        State.groupEntityCleanups[p57.id][v59] = nil;
    end;

    State.entityToGroups[v59][p57.id] = nil;
    local v61 = State.entityData[v59];
    local v62 = p57.entityIndices[v59];
    local v63 = #p57.entities;

    if v62 == v63 then
        p57.entities[v63] = nil;
        p57.entityIndices[v59] = nil;
    else
        local v64 = p57.entities[v63];
        p57.entities[v62] = v64;
        p57.entityIndices[v64] = v62;
        p57.entities[v63] = nil;
        p57.entityIndices[v59] = nil;
    end;

    State.dirtyProfiles[v59] = true;
    State.dirtyTopology[v59] = true;

    for i, v in v61.activeObserverMemberships do
        local v65 = false;

        for i2 in State.entityToGroups[v59] do
            if State.groupToObservers[i2] and State.groupToObservers[i2][i] then
                v65 = true;
                break;
            end;
        end;

        if not v65 then
            v61.activeObserverMemberships[i] = nil;

            if State.observerTrackingEntities[i] then
                State.observerTrackingEntities[i][v59] = nil;
            end;

            local v66 = State.observerExitedCallbacks[i];

            if v66 then
                local v67 = State.observerSafety[i];
                local v68 = State.zoneIdToZoneObj[v];
                local v69 = State.entityToReference[v59] or v59;

                for _, v2 in v66 do
                    if v67 then
                        task.spawn(v2, v69, v68, v59);
                    else
                        v2(v69, v68, v59);
                    end;
                end;
            end;
        end;
    end;

    if next(State.entityToGroups[v59]) == nil then
        local updateRate = v61.updateRate;

        if updateRate and (updateRate > 0 and State.buckets[updateRate]) then
            local v70 = State.buckets[updateRate];
            local bucketIndex = v61.bucketIndex;
            local v71 = #v70;
            local v72 = v70[v71];

            if bucketIndex ~= v71 then
                v70[bucketIndex] = v72;

                if State.entityData[v72] then
                    State.entityData[v72].bucketIndex = bucketIndex;
                end;
            end;

            v70[v71] = nil;
        end;

        State.entityData[v59] = nil;
        State.entityToGroups[v59] = nil;
        State.entityToObservers[v59] = nil;
        State.dirtyProfiles[v59] = nil;
        State.dirtyTopology[v59] = nil;
        local v73 = State.entityToReference[v59];

        if v73 and (typeof(v73) ~= "Instance" or not v73:IsA("Player")) then
            State.entityToReference[v59] = nil;

            if State.referenceToEntity[v73] == v59 then
                State.referenceToEntity[v73] = nil;
            end;
        end;
    end;

    return p57;
end;

function u3._removeBulk(p74, p75) -- Line: 700
    for _, v in p75 do
        p74:_remove(v);
    end;

    return p74;
end;

function u3._clear(p76) -- Line: 707
    local entities = p76.entities;

    for i = #entities, 1, -1 do
        p76:_remove(entities[i]);
    end;

    return p76;
end;

return u3;