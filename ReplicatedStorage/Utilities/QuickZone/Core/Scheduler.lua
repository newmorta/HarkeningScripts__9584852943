-- Ruta Original: ReplicatedStorage.Utilities.QuickZone.Core.Scheduler
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Config = require(script.Parent.Parent.Config);
require(script.Parent.Parent.Types);
local Geometry = require(script.Parent.Parent.Utils.Geometry);
local LinearBVH = require(script.Parent.Parent.Utils.LinearBVH);
local Log = require(script.Parent.Parent.Utils.Log);
local State = require(script.Parent.State);
local queryPoint = LinearBVH.queryPoint;
local isPointInShape = Geometry.isPointInShape;
local staticCFrames = State.staticCFrames;
local staticHalfSizes = State.staticHalfSizes;
local staticTypes = State.staticTypes;
local dynamicCFrames = State.dynamicCFrames;
local dynamicHalfSizes = State.dynamicHalfSizes;
local dynamicTypes = State.dynamicTypes;
local zoneIdToZoneObj = State.zoneIdToZoneObj;
local zoneAttachedObservers = State.zoneAttachedObservers;
local autoSyncZones = State.autoSyncZones;
local observerPriorityMap = State.observerPriorityMap;
local observerTrackingEntities = State.observerTrackingEntities;
local observerEnteredCallbacks = State.observerEnteredCallbacks;
local observerExitedCallbacks = State.observerExitedCallbacks;
local observerTransitionedCallbacks = State.observerTransitionedCallbacks;
local observerEnabled = State.observerEnabled;
local observerSafety = State.observerSafety;
local observerPrecisionSq = State.observerPrecisionSq;
local observerUpdateRate = State.observerUpdateRate;
local observerStaticCount = State.observerStaticCount;
local observerDynamicCount = State.observerDynamicCount;
local entityToReference = State.entityToReference;
local entityData = State.entityData;
local entityToObservers = State.entityToObservers;
local entityToGroups = State.entityToGroups;
local groupToObservers = State.groupToObservers;
local dirtyProfiles = State.dirtyProfiles;
local dirtyTopology = State.dirtyTopology;
local staticTree = State.staticTree;
local dynamicTree = State.dynamicTree;
local u1 = nil;
local u2 = 0;
local u3 = nil;
local u4 = table.create(16);
local u5 = table.create(16);
local u6 = table.create(16);
local u7 = nil;
local u8 = nil;
local frameBudget = Config.Scheduler.frameBudget;
local autoSyncRate = Config.Scheduler.autoSyncRate;
local u9 = 0;
local u10 = nil;
local bucketList = State.bucketList;
local buckets = State.buckets;
local u11 = 1;
local u12 = {};
local POS = Config.Strategy.POS;
local PRIM = Config.Strategy.PRIM;
local WORLD = Config.Strategy.WORLD;
local CFRAME = Config.Strategy.CFRAME;
local TRANSFORM = Config.Strategy.TRANSFORM;
local PIVOT = Config.Strategy.PIVOT;

local function processProfileChange(p13) -- Line: 77
    -- upvalues: entityToGroups (copy), entityToObservers (copy), groupToObservers (copy), observerPrecisionSq (copy), observerUpdateRate (copy), entityData (copy), buckets (copy), bucketList (copy)
    local v14 = entityToGroups[p13];

    if not v14 then
        return;
    end;

    local v15 = entityToObservers[p13];

    if v15 then
        table.clear(v15);
    else
        v15 = {};
    end;

    local v16 = (1 / 0);
    local v17 = 0;

    for i, _ in v14 do
        local v18 = groupToObservers[i];

        if v18 then
            for i2, _ in v18 do
                v15[i2] = true;
                local v19 = observerPrecisionSq[i2];
                local v20 = observerUpdateRate[i2];

                if v19 >= v16 then
                    v19 = v16;
                end;

                if v17 < v20 then
                    v17 = v20;
                    v16 = v19;
                else
                    v16 = v19;
                end;
            end;
        end;
    end;

    local v21 = entityData[p13];
    local updateRate = v21.updateRate;

    if updateRate ~= v17 then
        if updateRate and (updateRate > 0 and buckets[updateRate]) then
            local v22 = buckets[updateRate];
            local bucketIndex = v21.bucketIndex;
            local v23 = #v22;
            local v24 = v22[v23];

            if bucketIndex ~= v23 then
                v22[bucketIndex] = v24;

                if entityData[v24] then
                    entityData[v24].bucketIndex = bucketIndex;
                end;
            end;

            v22[v23] = nil;

            if #v22 == 0 then
                buckets[updateRate] = nil;
                local v25 = table.find(bucketList, updateRate);

                if v25 then
                    table.remove(bucketList, v25);
                end;
            end;
        end;

        if v17 > 0 then
            if not buckets[v17] then
                buckets[v17] = {};
                table.insert(bucketList, v17);
                table.sort(bucketList, function(p26, p27) -- Line: 153
                    return p27 < p26;
                end);
            end;

            local v28 = buckets[v17];
            local v29 = #v28 + 1;
            v28[v29] = p13;
            v21.bucketIndex = v29;
        else
            v21.bucketIndex = 0;
        end;

        v21.updateRate = v17;
    end;

    if v17 <= 0 then
        entityToObservers[p13] = nil;

        return;
    end;

    v21.precisionSq = v16;
    entityToObservers[p13] = v15;
end;

local function processTopologyChange(p30) -- Line: 177
    -- upvalues: entityData (copy), entityToObservers (copy), observerStaticCount (copy), observerDynamicCount (copy)
    local v31 = entityData[p30];

    if not v31 then
        return;
    end;

    local v32 = false;
    local v33 = false;
    local v34 = entityToObservers[p30];

    if v34 then
        for i, _ in v34 do
            v32 = (observerStaticCount[i] or 0) > 0 and true or v32;
            v33 = (observerDynamicCount[i] or 0) > 0 and true or v33;

            if v32 and v33 then
                break;
            end;
        end;
    end;

    v31.needsStatic = v32;
    v31.needsDynamic = v33;
end;

local function processZoneHit(p35) -- Line: 205
    -- upvalues: zoneAttachedObservers (copy), u7 (ref), observerEnabled (copy), u4 (copy), observerPriorityMap (copy), u2 (ref), u6 (copy), u5 (copy), u3 (ref), u8 (ref)
    local v36 = zoneAttachedObservers[p35];

    if not v36 then
        return;
    end;

    for _, v in v36 do
        if u7[v] and observerEnabled[v] ~= false then
            local v37 = u4[v];
            local v38 = observerPriorityMap[v] or 0;

            if v37 then
                if v37 < v38 then
                    u5[v] = p35;
                    u4[v] = v38;

                    if u3 < v38 then
                        u3 = v38;
                    end;
                elseif v38 == v37 and u8[v] == p35 then
                    u5[v] = p35;
                end;
            else
                u2 = u2 + 1;
                u6[u2] = v;
                u5[v] = p35;
                u4[v] = v38;

                if u3 < v38 then
                    u3 = v38;
                end;
            end;
        end;
    end;
end;

local function queryCallbackStatic(p39) -- Line: 239
    -- upvalues: isPointInShape (copy), u1 (ref), staticCFrames (copy), staticHalfSizes (copy), staticTypes (copy), processZoneHit (copy)
    if isPointInShape(u1, staticCFrames[p39], staticHalfSizes[p39], staticTypes[p39]) then
        processZoneHit(p39);
    end;
end;

local function queryCallbackDynamic(p40) -- Line: 245
    -- upvalues: isPointInShape (copy), u1 (ref), dynamicCFrames (copy), dynamicHalfSizes (copy), dynamicTypes (copy), processZoneHit (copy)
    if isPointInShape(u1, dynamicCFrames[p40], dynamicHalfSizes[p40], dynamicTypes[p40]) then
        processZoneHit(p40);
    end;
end;

local function fireCallback(p41, p42, p43, p44, p45) -- Line: 251
    if p45 then
        for _, v in p41 do
            task.spawn(v, p42, p43, p44);
        end;

        return;
    end;

    for _, v in p41 do
        v(p42, p43, p44);
    end;
end;

local u46 = {};

function u46.update(p47) -- Line: 271
    -- upvalues: dirtyProfiles (copy), entityData (copy), processProfileChange (copy), dirtyTopology (copy), processTopologyChange (copy), autoSyncRate (ref), u9 (ref), autoSyncZones (copy), dynamicCFrames (copy), State (copy), u46 (copy), frameBudget (ref), bucketList (copy), u11 (ref), buckets (copy), u12 (copy), POS (copy), WORLD (copy), CFRAME (copy), TRANSFORM (copy), PRIM (copy), PIVOT (copy), u7 (ref), entityToObservers (copy), u8 (ref), u1 (ref), u2 (ref), u3 (ref), queryPoint (copy), dynamicTree (copy), queryCallbackDynamic (copy), staticTree (copy), queryCallbackStatic (copy), u4 (copy), observerTrackingEntities (copy), observerExitedCallbacks (copy), observerSafety (copy), zoneIdToZoneObj (copy), entityToReference (copy), fireCallback (copy), u6 (copy), u5 (copy), observerEnteredCallbacks (copy), observerTransitionedCallbacks (copy)
    local v48 = os.clock();

    for i, _ in dirtyProfiles do
        dirtyProfiles[i] = nil;

        if entityData[i] then
            processProfileChange(i);
        end;
    end;

    for i, _ in dirtyTopology do
        dirtyTopology[i] = nil;

        if entityData[i] then
            processTopologyChange(i);
        end;
    end;

    if autoSyncRate > 0 then
        u9 = u9 + p47;

        if 1 / autoSyncRate <= u9 then
            u9 = 0;
            local v49 = false;

            for i, v in autoSyncZones do
                local reference = v.reference;

                if reference then
                    local v50 = reference:IsA("Attachment") and reference.WorldCFrame or reference.CFrame;

                    if dynamicCFrames[i] ~= v50 then
                        dynamicCFrames[i] = v50;
                        v49 = true;
                    end;
                end;
            end;

            if v49 then
                State.pendingDynamicRebuild = true;
            end;
        end;
    end;

    u46.rebuildTrees();

    if frameBudget < os.clock() - v48 then
        return;
    end;

    local v51 = #bucketList;

    if v51 == 0 then
        return;
    end;

    if v51 < u11 then
        u11 = 1;
    end;

    local dynamicVersion = State.dynamicVersion;
    local staticVersion = State.staticVersion;
    local logicVersion = State.logicVersion;

    for _ = 1, v51 do
        local v52 = bucketList[u11];
        u11 = u11 % v51 + 1;
        local v53 = buckets[v52];
        local v54 = #v53;

        if v54 ~= 0 then
            local v55 = math.ceil(v54 * v52 * p47);
            local v56 = math.clamp(v55, 1, v54);
            local v57 = u12[v52] or 1;
            local v58 = v54 < v57 and 1 or v57;
            local v59 = 0;
            local v60 = 32;

            while v59 < v56 do
                local v61 = v53[v58];
                local v62 = entityData[v61];
                local v63 = nil;
                local strategy = v62.strategy;

                if strategy == POS then
                    v63 = v61.Position;
                elseif strategy == WORLD then
                    v63 = v61.WorldPosition;
                elseif strategy == CFRAME then
                    v63 = v61.CFrame.Position;
                elseif strategy == TRANSFORM then
                    v63 = v61.Transform.Position;
                elseif strategy == PRIM then
                    local PrimaryPart = v61.PrimaryPart;
                    v63 = PrimaryPart and PrimaryPart.Position or v61:GetPivot().Position;
                elseif strategy == PIVOT then
                    v63 = v61:GetPivot().Position;
                end;

                local needsStatic = v62.needsStatic;
                local needsDynamic = v62.needsDynamic;
                local v64 = false;
                local v65;

                if v62.logicVersion == logicVersion and (not needsDynamic or v62.dynamicVersion == dynamicVersion) and (not needsStatic or v62.staticVersion == staticVersion) then
                    local lastPosition = v62.lastPosition;
                    local v66 = v63.X - lastPosition.X;
                    local v67 = v63.Y - lastPosition.Y;
                    local v68 = v63.Z - lastPosition.Z;
                    v65 = v66 * v66 + v67 * v67 + v68 * v68 >= v62.precisionSq and true or v64;
                else
                    v65 = true;
                end;

                if v65 then
                    v62.lastPosition = v63;
                    v62.dynamicVersion = dynamicVersion;
                    v62.logicVersion = logicVersion;
                    v62.staticVersion = staticVersion;
                    u7 = entityToObservers[v61];
                    u8 = v62.activeObserverMemberships;
                    u1 = v63;
                    u2 = 0;
                    u3 = (-1 / 0);

                    if needsDynamic then
                        queryPoint(dynamicTree, v63, queryCallbackDynamic);
                    end;

                    if needsStatic then
                        queryPoint(staticTree, v63, queryCallbackStatic);
                    end;

                    local activeObserverMemberships = v62.activeObserverMemberships;

                    for i, v in activeObserverMemberships do
                        local v69 = u4[i];

                        if not v69 or u3 > v69 then
                            activeObserverMemberships[i] = nil;

                            if observerTrackingEntities[i] then
                                observerTrackingEntities[i][v61] = nil;
                            end;

                            local v70 = observerExitedCallbacks[i];

                            if v70 then
                                fireCallback(v70, entityToReference[v61] or v61, zoneIdToZoneObj[v], v61, observerSafety[i]);
                            end;
                        end;
                    end;

                    for i = 1, u2 do
                        local v71 = u6[i];
                        local v72 = u4[v71];
                        local v73 = u5[v71];
                        u4[v71] = nil;
                        u5[v71] = nil;
                        u6[i] = nil;

                        if observerTrackingEntities[v71] and v72 >= u3 then
                            local v74 = activeObserverMemberships[v71];

                            if v74 ~= v73 then
                                activeObserverMemberships[v71] = v73;
                                local v75 = observerSafety[v71];

                                if v74 then
                                    local v76 = observerTransitionedCallbacks[v71];

                                    if v76 then
                                        fireCallback(v76, entityToReference[v61] or v61, zoneIdToZoneObj[v73], v61, v75);
                                    end;
                                else
                                    observerTrackingEntities[v71][v61] = true;
                                    local v77 = observerEnteredCallbacks[v71];

                                    if v77 then
                                        fireCallback(v77, entityToReference[v61] or v61, zoneIdToZoneObj[v73], v61, v75);
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;

                local v78 = v58 + 1;
                v58 = v54 < v78 and 1 or v78;
                v59 = v59 + 1;
                v60 = v60 - 1;

                if v60 == 0 then
                    if frameBudget < os.clock() - v48 then
                        break;
                    end;

                    v60 = 32;
                end;
            end;

            u12[v52] = v58;

            if frameBudget < os.clock() - v48 then
                break;
            end;
        end;
    end;
end;

function u46.setEnabled(p79) -- Line: 528
    -- upvalues: u10 (ref), RunService (copy), u46 (copy)
    if p79 then
        if not u10 then
            u10 = RunService.PostSimulation:Connect(u46.update);
        end;
    elseif u10 then
        u10:Disconnect();
        u10 = nil;
    end;
end;

function u46.setAutoSyncRate(p80) -- Line: 541
    -- upvalues: autoSyncRate (ref)
    if p80 <= 0 then
        autoSyncRate = 0;

        return;
    end;

    autoSyncRate = p80;
end;

function u46.setFrameBudget(p81) -- Line: 549
    -- upvalues: Log (copy), frameBudget (ref)
    if p81 <= 0 then
        Log.fatal("frameBudget must be greater than 0.", nil);
    end;

    frameBudget = p81;
end;

function u46.rebuildTrees() -- Line: 557
    -- upvalues: State (copy), LinearBVH (copy), dynamicTree (copy), dynamicCFrames (copy), dynamicHalfSizes (copy), staticTree (copy), staticCFrames (copy), staticHalfSizes (copy)
    if State.pendingDynamicRebuild then
        LinearBVH.build(dynamicTree, dynamicCFrames, dynamicHalfSizes);
        State.pendingDynamicRebuild = false;
        local v82 = State;
        v82.dynamicVersion = v82.dynamicVersion + 1;
    end;

    if State.pendingStaticRebuild then
        LinearBVH.build(staticTree, staticCFrames, staticHalfSizes);
        State.pendingStaticRebuild = false;
        local v83 = State;
        v83.staticVersion = v83.staticVersion + 1;
    end;
end;

u46.setEnabled(Config.Scheduler.enabled);

return u46;