-- Ruta Original: ReplicatedStorage.Utilities.QuickZone.Classes.Zone
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local State = require(script.Parent.Parent.Core.State);
require(script.Parent.Parent.Types);
local Geometry = require(script.Parent.Parent.Utils.Geometry);
local Log = require(script.Parent.Parent.Utils.Log);
local Zones = require(script.Parent.Zones);
local staticCFrames = State.staticCFrames;
local staticHalfSizes = State.staticHalfSizes;
local staticTypes = State.staticTypes;
local dynamicCFrames = State.dynamicCFrames;
local dynamicHalfSizes = State.dynamicHalfSizes;
local dynamicTypes = State.dynamicTypes;
local isPointInShape = Geometry.isPointInShape;
local u1 = {
    Block = Enum.PartType.Block.Value,
    Cylinder = Enum.PartType.Cylinder.Value,
    Ball = Enum.PartType.Ball.Value,
    Wedge = Enum.PartType.Wedge.Value,
    CornerWedge = Enum.PartType.CornerWedge.Value
};

local function getShapeEnumValue(p2) -- Line: 45
    if p2:IsA("Part") then
        return p2.Shape.Value;
    end;

    if p2:IsA("WedgePart") then
        return Enum.PartType.Wedge.Value;
    end;

    if p2:IsA("CornerWedgePart") then
        return Enum.PartType.CornerWedge.Value;
    end;

    return Enum.PartType.Block.Value;
end;

local function clearAutoSync(p3) -- Line: 61
    -- upvalues: State (copy)
    State.autoSyncZones[p3.id] = nil;

    if p3.syncConnections then
        for _, v in p3.syncConnections do
            v:Disconnect();
        end;

        p3.syncConnections = nil;
    end;
end;

local function setupAutoSync(u4, u5) -- Line: 71
    -- upvalues: State (copy), dynamicHalfSizes (copy), dynamicTypes (copy)
    State.autoSyncZones[u4.id] = u4;
    local v6 = u4.syncConnections or {};

    if u5:IsA("BasePart") then
        local v7 = u5:GetPropertyChangedSignal("Size");
        table.insert(v6, v7:Connect(function() -- Line: 79
            -- upvalues: u5 (copy), dynamicHalfSizes (ref), u4 (copy), State (ref)
            local v8 = u5.ExtentsSize * 0.5;

            if dynamicHalfSizes[u4.id] ~= v8 then
                dynamicHalfSizes[u4.id] = v8;
                State.pendingDynamicRebuild = true;
            end;
        end));
    end;

    if u5:IsA("Part") then
        local v9 = u5:GetPropertyChangedSignal("Shape");
        table.insert(v6, v9:Connect(function() -- Line: 92
            -- upvalues: u5 (copy), dynamicTypes (ref), u4 (copy), State (ref)
            local Value = u5.Shape.Value;

            if dynamicTypes[u4.id] ~= Value then
                dynamicTypes[u4.id] = Value;
                State.pendingDynamicRebuild = true;
            end;
        end));
    end;

    u4.syncConnections = v6;
    u4:sync();
end;

local function updateObserverZoneCount(p10, p11, p12) -- Line: 106
    -- upvalues: State (copy)
    local v13 = p11 and State.observerDynamicCount or State.observerStaticCount;
    local v14 = v13[p10] or 0;
    local v15 = v14 + p12;
    v13[p10] = v15;

    if v14 == 0 and v15 == 1 or v14 == 1 and v15 == 0 then
        if v14 == 1 and v15 == 0 then
            local v16 = State;
            v16.logicVersion = v16.logicVersion + 1;
        end;

        for i, v in State.groupToObservers do
            if v[p10] then
                local v17 = State.groups[i];

                if v17 then
                    for _, v2 in v17.entities do
                        State.dirtyTopology[v2] = true;
                    end;
                end;
            end;
        end;
    end;
end;

local u18 = {};
u18.__index = u18;

local function newZoneInternal(p19, p20, p21, p22, p23, p24, p25) -- Line: 139
    -- upvalues: State (copy), u18 (copy)
    local nextZoneId = State.nextZoneId;
    local v26 = State;
    v26.nextZoneId = v26.nextZoneId + 1;
    local v27 = p20 * 0.5;

    if p23 then
        State.dynamicCFrames[nextZoneId] = p19;
        State.dynamicHalfSizes[nextZoneId] = v27;
        State.dynamicTypes[nextZoneId] = p21;
        State.pendingDynamicRebuild = true;
    else
        State.staticCFrames[nextZoneId] = p19;
        State.staticHalfSizes[nextZoneId] = v27;
        State.staticTypes[nextZoneId] = p21;
        State.pendingStaticRebuild = true;
    end;

    local v28 = setmetatable({
        autoSync = false,
        id = nextZoneId,
        reference = p22,
        dynamic = p23,
        metadata = p24
    }, u18);
    State.zoneIdToZoneObj[nextZoneId] = v28;

    if p25 then
        v28:setAutoSync(true);
    end;

    return v28;
end;

function u18.new(p29) -- Line: 207
    -- upvalues: u1 (copy), Log (copy), newZoneInternal (copy)
    local Value = Enum.PartType.Block.Value;

    if p29.shape then
        local v30 = u1[p29.shape];

        if v30 then
            Value = v30;
        else
            Log.warn("Invalid shape \'%s\'. Defaulting to Block.", nil, (tostring(p29.shape)));
        end;
    end;

    return newZoneInternal(p29.cframe, p29.size, Value, p29.reference, p29.isDynamic or false, p29.metadata, p29.autoSync or false);
end;

function u18.fromPart(p31, p32) -- Line: 263
    -- upvalues: newZoneInternal (copy)
    local Value = Enum.PartType.Block.Value;

    if p31:IsA("Part") then
        Value = p31.Shape.Value;
    elseif p31:IsA("WedgePart") then
        Value = Enum.PartType.Wedge.Value;
    elseif p31:IsA("CornerWedgePart") then
        Value = Enum.PartType.CornerWedge.Value;
    end;

    local v33;

    if p32 then
        v33 = p32.isDynamic or false;
    else
        v33 = false;
    end;

    local v34;

    if p32 then
        v34 = p32.metadata;
    else
        v34 = p32;
    end;

    return newZoneInternal(p31.CFrame, p31.ExtentsSize, Value, p31, v33, v34, p32 and p32.autoSync or false);
end;

function u18.fromParts(p35, p36) -- Line: 297
    -- upvalues: Zones (copy), u18 (copy)
    local v37;

    if p36 and p36.isDynamic ~= nil then
        v37 = p36.isDynamic;
    else
        v37 = false;
    end;

    local v38;

    if p36 and p36.metadata ~= nil then
        v38 = p36.metadata;
    else
        v38 = nil;
    end;

    local v39;

    if p36 and p36.autoSync ~= nil then
        v39 = p36.autoSync;
    else
        v39 = false;
    end;

    local v40 = Zones.new({
        isDynamic = v37,
        metadata = v38,
        autoSync = v39
    });

    for _, v in p35 do
        if v:IsA("BasePart") then
            v40:add((u18.fromPart(v, {
                isDynamic = v37,
                metadata = v40.metadata,
                autoSync = v39
            })));
        end;
    end;

    return v40;
end;

function u18.fromChildren(p41, p42) -- Line: 340
    -- upvalues: Zones (copy), u18 (copy)
    local u43;

    if p42 and p42.isDynamic ~= nil then
        u43 = p42.isDynamic;
    else
        u43 = false;
    end;

    local v44;

    if p42 and p42.metadata ~= nil then
        v44 = p42.metadata;
    else
        v44 = nil;
    end;

    local v45;

    if p42 and p42.autoSync ~= nil then
        v45 = p42.autoSync;
    else
        v45 = false;
    end;

    local u46 = Zones.new({
        isDynamic = u43,
        metadata = v44,
        autoSync = v45
    });
    local u47 = {};

    local function onAdded(p48) -- Line: 360
        -- upvalues: u47 (copy), u18 (ref), u43 (copy), u46 (copy)
        if p48:IsA("BasePart") and not u47[p48] then
            local v49 = u18.fromPart(p48, {
                isDynamic = u43,
                metadata = u46.metadata
            });
            u47[p48] = v49;
            u46:add(v49);
        end;
    end;

    local u50 = p41.ChildAdded:Connect(onAdded);
    local u53 = p41.ChildRemoved:Connect(function(p51) -- Line: 371, Name: onRemoved
        -- upvalues: u47 (copy)
        local v52 = u47[p51];

        if v52 then
            u47[p51] = nil;
            v52:destroy();
        end;
    end);

    for _, child in p41:GetChildren() do
        onAdded(child);
    end;

    u46:onDestroy(function() -- Line: 385
        -- upvalues: u50 (copy), u53 (copy), u47 (copy)
        u50:Disconnect();
        u53:Disconnect();

        for i, _ in u47 do
            local v54 = u47[i];

            if v54 then
                u47[i] = nil;
                v54:destroy();
            end;
        end;

        table.clear(u47);
    end);

    return u46;
end;

function u18.fromDescendants(p55, p56) -- Line: 414
    -- upvalues: Zones (copy), u18 (copy)
    local u57;

    if p56 and p56.isDynamic ~= nil then
        u57 = p56.isDynamic;
    else
        u57 = false;
    end;

    local v58;

    if p56 and p56.metadata ~= nil then
        v58 = p56.metadata;
    else
        v58 = nil;
    end;

    local v59;

    if p56 and p56.autoSync ~= nil then
        v59 = p56.autoSync;
    else
        v59 = false;
    end;

    local u60 = Zones.new({
        isDynamic = u57,
        metadata = v58,
        autoSync = v59
    });
    local u61 = {};

    local function v64(p62) -- Line: 434
        -- upvalues: u61 (copy), u18 (ref), u57 (copy), u60 (copy)
        if p62:IsA("BasePart") and not u61[p62] then
            local v63 = u18.fromPart(p62, {
                isDynamic = u57,
                metadata = u60.metadata
            });
            u61[p62] = v63;
            u60:add(v63);
        end;
    end;

    local u65 = p55.DescendantAdded:Connect(v64);
    local u68 = p55.DescendantRemoving:Connect(function(p66) -- Line: 445, Name: onRemoved
        -- upvalues: u61 (copy)
        local v67 = u61[p66];

        if v67 then
            u61[p66] = nil;
            v67:destroy();
        end;
    end);

    for _, descendant in p55:GetDescendants() do
        v64(descendant);
    end;

    u60:onDestroy(function() -- Line: 459
        -- upvalues: u65 (copy), u68 (copy), u61 (copy)
        u65:Disconnect();
        u68:Disconnect();

        for i, _ in u61 do
            local v69 = u61[i];

            if v69 then
                u61[i] = nil;
                v69:destroy();
            end;
        end;

        table.clear(u61);
    end);

    return u60;
end;

function u18.fromTag(p70, p71) -- Line: 482
    -- upvalues: Zones (copy), u18 (copy), CollectionService (copy)
    local u72;

    if p71 and p71.isDynamic ~= nil then
        u72 = p71.isDynamic;
    else
        u72 = false;
    end;

    local v73;

    if p71 and p71.metadata ~= nil then
        v73 = p71.metadata;
    else
        v73 = nil;
    end;

    local u74;

    if p71 and p71.autoSync ~= nil then
        u74 = p71.autoSync;
    else
        u74 = false;
    end;

    local u75 = Zones.new({
        isDynamic = u72,
        metadata = v73,
        autoSync = u74
    });
    local u76 = {};
    local u77 = {};
    local u78 = {};
    local u79 = {};

    local function addPart(p80) -- Line: 505
        -- upvalues: u79 (copy), u18 (ref), u72 (copy), u75 (copy), u74 (copy), u78 (copy)
        local v81 = (u79[p80] or 0) + 1;
        u79[p80] = v81;

        if v81 == 1 then
            local v82 = u18.fromPart(p80, {
                isDynamic = u72,
                metadata = u75.metadata,
                autoSync = u74
            });
            u78[p80] = v82;
            u75:add(v82);
        end;
    end;

    local function removePart(p83) -- Line: 521
        -- upvalues: u79 (copy), u78 (copy)
        local v84 = (u79[p83] or 0) - 1;

        if v84 <= 0 then
            u79[p83] = nil;
            local v85 = u78[p83];

            if v85 then
                u78[p83] = nil;
                v85:destroy();
            end;
        else
            u79[p83] = v84;
        end;
    end;

    local function processTaggedInstance(p86) -- Line: 536
        -- upvalues: addPart (copy), u77 (copy), u79 (copy), u78 (copy)
        if p86:IsDescendantOf(workspace) then
            if p86:IsA("BasePart") then
                addPart(p86);

                return;
            end;

            if not u77[p86] then
                u77[p86] = { p86.DescendantAdded:Connect(function(p87) -- Line: 543
                        -- upvalues: addPart (ref)
                        if p87:IsA("BasePart") then
                            addPart(p87);
                        end;
                    end), (p86.DescendantRemoving:Connect(function(p88) -- Line: 548
                        -- upvalues: u79 (ref), u78 (ref)
                        if p88:IsA("BasePart") then
                            local v89 = (u79[p88] or 0) - 1;

                            if v89 <= 0 then
                                u79[p88] = nil;
                                local v90 = u78[p88];

                                if v90 then
                                    u78[p88] = nil;
                                    v90:destroy();
                                end;
                            else
                                u79[p88] = v89;
                            end;
                        end;
                    end)) };

                for _, descendant in p86:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        addPart(descendant);
                    end;
                end;
            end;
        elseif p86:IsA("BasePart") then
            local v91 = (u79[p86] or 0) - 1;

            if v91 > 0 then
                u79[p86] = v91;

                return;
            end;

            u79[p86] = nil;
            local v92 = u78[p86];

            if v92 then
                u78[p86] = nil;
                v92:destroy();
            end;
        else
            local v93 = u77[p86];

            if v93 then
                v93[1]:Disconnect();
                v93[2]:Disconnect();
                u77[p86] = nil;
            end;

            for _, descendant in p86:GetDescendants() do
                if descendant:IsA("BasePart") then
                    local v94 = (u79[descendant] or 0) - 1;

                    if v94 <= 0 then
                        u79[descendant] = nil;
                        local v95 = u78[descendant];

                        if v95 then
                            u78[descendant] = nil;
                            v95:destroy();
                        end;
                    else
                        u79[descendant] = v94;
                    end;
                end;
            end;
        end;
    end;

    local function stopWatching(p96) -- Line: 591
        -- upvalues: u76 (copy), u79 (copy), u78 (copy), u77 (copy)
        local v97 = u76[p96];

        if v97 then
            v97:Disconnect();
            u76[p96] = nil;
        end;

        if p96:IsA("BasePart") then
            local v98 = (u79[p96] or 0) - 1;

            if v98 > 0 then
                u79[p96] = v98;

                return;
            end;

            u79[p96] = nil;
            local v99 = u78[p96];

            if v99 then
                u78[p96] = nil;
                v99:destroy();
            end;
        else
            local v100 = u77[p96];

            if v100 then
                v100[1]:Disconnect();
                v100[2]:Disconnect();
                u77[p96] = nil;
            end;

            for _, descendant in p96:GetDescendants() do
                if descendant:IsA("BasePart") then
                    local v101 = (u79[descendant] or 0) - 1;

                    if v101 <= 0 then
                        u79[descendant] = nil;
                        local v102 = u78[descendant];

                        if v102 then
                            u78[descendant] = nil;
                            v102:destroy();
                        end;
                    else
                        u79[descendant] = v101;
                    end;
                end;
            end;
        end;
    end;

    local u104 = CollectionService:GetInstanceAddedSignal(p70):Connect(function(u103) -- Line: 581, Name: startWatching
        -- upvalues: u76 (copy), processTaggedInstance (copy)
        if u76[u103] then
            return;
        end;

        u76[u103] = u103.AncestryChanged:Connect(function() -- Line: 585
            -- upvalues: processTaggedInstance (ref), u103 (copy)
            processTaggedInstance(u103);
        end);
        processTaggedInstance(u103);
    end);
    local u105 = CollectionService:GetInstanceRemovedSignal(p70):Connect(stopWatching);

    for _, v in CollectionService:GetTagged(p70) do
        if not u76[v] then
            u76[v] = v.AncestryChanged:Connect(function() -- Line: 585
                -- upvalues: processTaggedInstance (copy), v (copy)
                processTaggedInstance(v);
            end);
            processTaggedInstance(v);
        end;
    end;

    u75:onDestroy(function() -- Line: 621
        -- upvalues: u104 (copy), u105 (copy), u76 (copy), stopWatching (copy), u77 (copy), u78 (copy), u79 (copy)
        u104:Disconnect();
        u105:Disconnect();

        for i in u76 do
            stopWatching(i);
        end;

        table.clear(u76);
        table.clear(u77);
        table.clear(u78);
        table.clear(u79);
    end);

    return u75;
end;

function u18.attach(p106, p107) -- Line: 636
    -- upvalues: State (copy), updateObserverZoneCount (copy)
    local v108 = State.zoneAttachedObservers[p106.id] or {};
    State.zoneAttachedObservers[p106.id] = v108;

    if not table.find(v108, p107.id) then
        table.insert(v108, p107.id);
        updateObserverZoneCount(p107.id, p106.dynamic, 1);
    end;

    if p106.dynamic then
        local v109 = State;
        v109.dynamicVersion = v109.dynamicVersion + 1;

        return p106;
    end;

    local v110 = State;
    v110.staticVersion = v110.staticVersion + 1;

    return p106;
end;

function u18.detach(p111, p112) -- Line: 654
    -- upvalues: State (copy), updateObserverZoneCount (copy)
    local v113 = State.zoneAttachedObservers[p111.id];

    if not v113 then
        return p111;
    end;

    local v114 = table.find(v113, p112.id);

    if v114 then
        local v115 = #v113;

        if v114 ~= v115 then
            v113[v114] = v113[v115];
        end;

        v113[v115] = nil;
        updateObserverZoneCount(p112.id, p111.dynamic, -1);
    end;

    if #v113 == 0 then
        State.zoneAttachedObservers[p111.id] = nil;
    end;

    if p111.dynamic then
        local v116 = State;
        v116.dynamicVersion = v116.dynamicVersion + 1;

        return p111;
    end;

    local v117 = State;
    v117.staticVersion = v117.staticVersion + 1;

    return p111;
end;

function u18.setAutoSync(p118, p119) -- Line: 693
    -- upvalues: setupAutoSync (copy), Log (copy), State (copy)
    if p118.autoSync == p119 then
        return p118;
    end;

    p118.autoSync = p119;

    if not p119 then
        State.autoSyncZones[p118.id] = nil;

        if p118.syncConnections then
            for _, v in p118.syncConnections do
                v:Disconnect();
            end;

            p118.syncConnections = nil;
        end;

        return p118;
    end;

    if not p118.dynamic then
        p118:setDynamic(true);
    end;

    if p118.reference then
        setupAutoSync(p118, p118.reference);

        return p118;
    end;

    Log.warn("Cannot autoSync Zone %d without a tracked reference.", nil, p118.id);

    return p118;
end;

function u18.setReference(p120, p121) -- Line: 726
    -- upvalues: State (copy), setupAutoSync (copy)
    p120.reference = p121;

    if p120.autoSync then
        State.autoSyncZones[p120.id] = nil;

        if p120.syncConnections then
            for _, v in p120.syncConnections do
                v:Disconnect();
            end;

            p120.syncConnections = nil;
        end;

        if p121 then
            setupAutoSync(p120, p121);
        end;
    end;

    return p120;
end;

function u18.sync(p122) -- Line: 755
    -- upvalues: Log (copy), getShapeEnumValue (copy), dynamicCFrames (copy), dynamicHalfSizes (copy), dynamicTypes (copy), State (copy), staticCFrames (copy), staticHalfSizes (copy), staticTypes (copy)
    local reference = p122.reference;

    if not reference then
        Log.warn("Zone:sync failed for Zone %d. No reference found.", nil, p122.id);

        return p122;
    end;

    local id = p122.id;

    if reference:IsA("BasePart") then
        local CFrame = reference.CFrame;
        local v123 = reference.ExtentsSize * 0.5;
        local v124 = getShapeEnumValue(reference);

        if p122.dynamic then
            local v125;

            if dynamicCFrames[id] == CFrame then
                v125 = false;
            else
                dynamicCFrames[id] = CFrame;
                v125 = true;
            end;

            if dynamicHalfSizes[id] ~= v123 then
                dynamicHalfSizes[id] = v123;
                v125 = true;
            end;

            if dynamicTypes[id] ~= v124 then
                dynamicTypes[id] = v124;
                v125 = true;
            end;

            if v125 then
                State.pendingDynamicRebuild = true;

                return p122;
            end;
        else
            local v126;

            if staticCFrames[id] == CFrame then
                v126 = false;
            else
                staticCFrames[id] = CFrame;
                v126 = true;
            end;

            if staticHalfSizes[id] ~= v123 then
                staticHalfSizes[id] = v123;
                v126 = true;
            end;

            if staticTypes[id] ~= v124 then
                staticTypes[id] = v124;
                v126 = true;
            end;

            if v126 then
                State.pendingStaticRebuild = true;
            end;
        end;

        return p122;
    end;

    if not (reference:IsA("Attachment") or reference:IsA("Bone")) then
        return p122;
    end;

    local WorldCFrame = reference.WorldCFrame;

    if p122.dynamic then
        if dynamicCFrames[id] == WorldCFrame then
            return p122;
        end;

        dynamicCFrames[id] = WorldCFrame;
        State.pendingDynamicRebuild = true;

        return p122;
    end;

    if staticCFrames[id] == WorldCFrame then
        return p122;
    end;

    staticCFrames[id] = WorldCFrame;
    State.pendingStaticRebuild = true;

    return p122;
end;

function u18.setDynamic(p127, p128) -- Line: 854
    -- upvalues: State (copy), updateObserverZoneCount (copy), dynamicCFrames (copy), staticCFrames (copy), dynamicHalfSizes (copy), staticHalfSizes (copy), dynamicTypes (copy), staticTypes (copy)
    if p127.dynamic == p128 then
        return p127;
    end;

    local id = p127.id;
    p127.dynamic = p128;
    local v129 = State.zoneAttachedObservers[id];

    if v129 then
        for _, v in v129 do
            updateObserverZoneCount(v, not p128, -1);
            updateObserverZoneCount(v, p128, 1);
        end;
    end;

    if p128 then
        dynamicCFrames[id] = staticCFrames[id];
        dynamicHalfSizes[id] = staticHalfSizes[id];
        dynamicTypes[id] = staticTypes[id];
        staticCFrames[id] = nil;
        staticHalfSizes[id] = nil;
        staticTypes[id] = nil;
    else
        if p127.autoSync then
            p127:setAutoSync(false);
        end;

        staticCFrames[id] = dynamicCFrames[id];
        staticHalfSizes[id] = dynamicHalfSizes[id];
        staticTypes[id] = dynamicTypes[id];
        dynamicCFrames[id] = nil;
        dynamicHalfSizes[id] = nil;
        dynamicTypes[id] = nil;
    end;

    State.pendingStaticRebuild = true;
    State.pendingDynamicRebuild = true;

    return p127;
end;

function u18.setCFrame(p130, p131) -- Line: 911
    -- upvalues: dynamicCFrames (copy), State (copy), staticCFrames (copy)
    if p130.dynamic then
        dynamicCFrames[p130.id] = p131;
        State.pendingDynamicRebuild = true;

        return p130;
    end;

    staticCFrames[p130.id] = p131;
    State.pendingStaticRebuild = true;

    return p130;
end;

function u18.setPosition(p132, p133) -- Line: 935
    -- upvalues: dynamicCFrames (copy), staticCFrames (copy)
    return p132:setCFrame((p132.dynamic and dynamicCFrames[p132.id] or staticCFrames[p132.id]).Rotation + p133);
end;

function u18.setSize(p134, p135) -- Line: 954
    -- upvalues: dynamicHalfSizes (copy), State (copy), staticHalfSizes (copy)
    local v136 = p135 * 0.5;

    if p134.dynamic then
        dynamicHalfSizes[p134.id] = v136;
        State.pendingDynamicRebuild = true;

        return p134;
    end;

    staticHalfSizes[p134.id] = v136;
    State.pendingStaticRebuild = true;

    return p134;
end;

function u18.setShape(p137, p138) -- Line: 976
    -- upvalues: u1 (copy), Log (copy), dynamicTypes (copy), staticTypes (copy), State (copy)
    local Value = Enum.PartType.Block.Value;
    local v139 = u1[p138];

    if v139 then
        Value = v139;
    else
        Log.warn("Invalid shape \'%s\'. Defaulting to Block.", nil, (tostring(p138)));
    end;

    if p137.dynamic then
        dynamicTypes[p137.id] = Value;
    else
        staticTypes[p137.id] = Value;
    end;

    if p137.dynamic then
        local v140 = State;
        v140.dynamicVersion = v140.dynamicVersion + 1;

        return p137;
    end;

    local v141 = State;
    v141.staticVersion = v141.staticVersion + 1;

    return p137;
end;

function u18.setMetadata(p142, p143) -- Line: 1010
    p142.metadata = p143;

    return p142;
end;

function u18.getMetadata(p144) -- Line: 1022
    return p144.metadata;
end;

function u18.getId(p145) -- Line: 1033
    return p145.id;
end;

function u18.getReference(p146) -- Line: 1044
    return p146.reference;
end;

function u18.getPosition(p147) -- Line: 1055
    -- upvalues: dynamicCFrames (copy), staticCFrames (copy)
    return (p147.dynamic and dynamicCFrames[p147.id] or staticCFrames[p147.id]).Position;
end;

function u18.getCFrame(p148) -- Line: 1067
    -- upvalues: dynamicCFrames (copy), staticCFrames (copy)
    return p148.dynamic and dynamicCFrames[p148.id] or staticCFrames[p148.id];
end;

function u18.getSize(p149) -- Line: 1078
    -- upvalues: dynamicHalfSizes (copy), staticHalfSizes (copy)
    return (p149.dynamic and dynamicHalfSizes[p149.id] or staticHalfSizes[p149.id]) * 2;
end;

function u18.getShape(p150) -- Line: 1090
    -- upvalues: dynamicTypes (copy), staticTypes (copy)
    local v151 = p150.dynamic and dynamicTypes[p150.id] or staticTypes[p150.id];

    return v151 == Enum.PartType.Block.Value and "Block" or (v151 == Enum.PartType.Ball.Value and "Ball" or (v151 == Enum.PartType.Cylinder.Value and "Cylinder" or (v151 == Enum.PartType.Wedge.Value and "Wedge" or (v151 == Enum.PartType.CornerWedge.Value and "CornerWedge" or "Block"))));
end;

function u18.isPointInside(p152, p153) -- Line: 1114
    -- upvalues: isPointInShape (copy), dynamicCFrames (copy), dynamicHalfSizes (copy), dynamicTypes (copy), staticCFrames (copy), staticHalfSizes (copy), staticTypes (copy)
    local id = p152.id;

    if p152.dynamic then
        return isPointInShape(p153, dynamicCFrames[id], dynamicHalfSizes[id], dynamicTypes[id]);
    end;

    return isPointInShape(p153, staticCFrames[id], staticHalfSizes[id], staticTypes[id]);
end;

function u18.isDynamic(p154) -- Line: 1130
    return p154.dynamic;
end;

function u18.onDestroy(u155, u156) -- Line: 1149
    if not u155.onDestroyCallbacks then
        u155.onDestroyCallbacks = {};
    end;

    table.insert(u155.onDestroyCallbacks, u156);

    return function() -- Line: 1156
        -- upvalues: u155 (copy), u156 (copy)
        local v157 = table.find(u155.onDestroyCallbacks, u156);

        if v157 then
            table.remove(u155.onDestroyCallbacks, v157);
        end;
    end;
end;

function u18.destroy(p158) -- Line: 1175
    -- upvalues: State (copy), updateObserverZoneCount (copy), dynamicCFrames (copy), dynamicHalfSizes (copy), dynamicTypes (copy), staticCFrames (copy), staticHalfSizes (copy), staticTypes (copy)
    State.autoSyncZones[p158.id] = nil;

    if p158.syncConnections then
        for _, v in p158.syncConnections do
            v:Disconnect();
        end;

        p158.syncConnections = nil;
    end;

    local id = p158.id;
    local v159 = State.zoneAttachedObservers[id];

    if v159 then
        for _, v in v159 do
            updateObserverZoneCount(v, p158.dynamic, -1);
            local v160 = State.observerTrackingEntities[v];

            if v160 then
                for i, _ in v160 do
                    local v161 = State.entityData[i];

                    if v161 and v161.activeObserverMemberships[v] == id then
                        v161.activeObserverMemberships[v] = nil;
                        v160[i] = nil;
                        local v162 = State.observerExitedCallbacks[v];

                        if v162 then
                            local v163 = State.observerSafety[v];
                            local v164 = State.entityToReference[i] or i;

                            for _, v2 in v162 do
                                if v163 then
                                    task.spawn(v2, v164, p158, i);
                                else
                                    v2(v164, p158, i);
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    State.zoneAttachedObservers[id] = nil;

    if p158.onDestroyCallbacks then
        for _, v in table.clone(p158.onDestroyCallbacks) do
            task.spawn(v);
        end;

        table.clear(p158.onDestroyCallbacks);
    end;

    State.zoneIdToZoneObj[id] = nil;

    if p158.dynamic then
        dynamicCFrames[id] = nil;
        dynamicHalfSizes[id] = nil;
        dynamicTypes[id] = nil;
        State.pendingDynamicRebuild = true;
    else
        staticCFrames[id] = nil;
        staticHalfSizes[id] = nil;
        staticTypes[id] = nil;
        State.pendingStaticRebuild = true;
    end;

    setmetatable(p158, nil);
end;

return u18;