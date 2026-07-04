-- Ruta Original: ReplicatedStorage.Utilities.QuickZone
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
require(script.Types);
local Config = require(script.Config);
local Scheduler = require(script.Core.Scheduler);
local State = require(script.Core.State);
local Geometry = require(script.Utils.Geometry);
local queryPoint = require(script.Utils.LinearBVH).queryPoint;
local isPointInShape = Geometry.isPointInShape;
local zoneAttachedObservers = State.zoneAttachedObservers;
local zoneIdToZoneObj = State.zoneIdToZoneObj;
local entityData = State.entityData;
local observerIdToObserverObj = State.observerIdToObserverObj;
local groups = State.groups;
local entityToGroups = State.entityToGroups;
local entityToReference = State.entityToReference;
local referenceToEntity = State.referenceToEntity;
local staticCFrames = State.staticCFrames;
local staticHalfSizes = State.staticHalfSizes;
local staticTypes = State.staticTypes;
local dynamicCFrames = State.dynamicCFrames;
local dynamicHalfSizes = State.dynamicHalfSizes;
local dynamicTypes = State.dynamicTypes;
local dynamicTree = State.dynamicTree;
local staticTree = State.staticTree;
local u1 = nil;
local u2 = nil;
local u3 = {};

return {
    Zone = require(script.Classes.Zone),
    Observer = require(script.Classes.Observer),
    Group = require(script.Classes.Group),

    configure = function(p4, p5) -- Line: 79, Name: configure
        if p5.enabled ~= nil then
            p4:setEnabled(p5.enabled);
        end;

        if p5.autoSyncRate ~= nil then
            p4:setAutoSyncRate(p5.autoSyncRate);
        end;

        if p5.frameBudget ~= nil then
            p4:setFrameBudget(p5.frameBudget);
        end;

        return p4;
    end,

    setEnabled = function(p6, p7) -- Line: 104, Name: setEnabled
        -- upvalues: Scheduler (copy)
        Scheduler.setEnabled(p7);

        return p6;
    end,

    update = function(p8, p9) -- Line: 119, Name: update
        -- upvalues: Scheduler (copy)
        Scheduler.update(p9);

        return p8;
    end,

    setAutoSyncRate = function(p10, p11) -- Line: 134, Name: setAutoSyncRate
        -- upvalues: Scheduler (copy)
        Scheduler.setAutoSyncRate(p11);

        return p10;
    end,

    rebuild = function(p12) -- Line: 151, Name: rebuild
        -- upvalues: Scheduler (copy)
        Scheduler.rebuildTrees();

        return p12;
    end,

    setReference = function(p13, p14, p15) -- Line: 177, Name: setReference
        -- upvalues: entityToReference (copy), referenceToEntity (copy)
        local v16 = entityToReference[p14];

        if p15 == nil then
            if typeof(v16) ~= "Instance" or not v16:IsA("Player") then
                if v16 then
                    referenceToEntity[v16] = nil;
                end;

                entityToReference[p14] = nil;
            end;

            return p13;
        end;

        if typeof(p15) ~= "Instance" or not p15:IsA("Player") then
            entityToReference[p14] = p15;
            referenceToEntity[p15] = p14;
        end;

        return p13;
    end,

    setFrameBudget = function(p17, p18) -- Line: 217, Name: setFrameBudget
        -- upvalues: Scheduler (copy)
        Scheduler.setFrameBudget(p18 / 1000);

        return p17;
    end,

    removeEntity = function(p19, p20) -- Line: 234, Name: removeEntity
        -- upvalues: referenceToEntity (copy), entityToGroups (copy), groups (copy)
        local v21 = referenceToEntity[p20] or p20;
        local v22 = entityToGroups[v21];

        if not v22 then
            return p19;
        end;

        local v23 = {};

        for i in v22 do
            table.insert(v23, i);
        end;

        for _, v in v23 do
            local v24 = groups[v];

            if v24 then
                v24:remove(v21);
            end;
        end;

        return p19;
    end,

    getEntityOfReference = function(p25, p26) -- Line: 265, Name: getEntityOfReference
        -- upvalues: referenceToEntity (copy)
        local v27 = referenceToEntity[p26];

        if v27 then
            return v27;
        end;

        if typeof(p26) == "Instance" then
            if p26:IsA("BasePart") or (p26:IsA("Attachment") or (p26:IsA("Bone") or (p26:IsA("Camera") or p26:IsA("Model")))) then
                return p26;
            end;
        elseif typeof(p26) == "table" and (p26.Position or (p26.CFrame or (p26.WorldPosition or p26.GetPivot))) then
            return p26;
        end;

        return nil;
    end,

    getReferenceOfEntity = function(p28, p29) -- Line: 299, Name: getReferenceOfEntity
        -- upvalues: entityToReference (copy)
        return entityToReference[p29] or p29;
    end,

    getObservers = function(p30) -- Line: 310, Name: getObservers
        -- upvalues: observerIdToObserverObj (copy)
        local v31 = {};

        for _, v in observerIdToObserverObj do
            table.insert(v31, v);
        end;

        return v31;
    end,

    getGroups = function(p32) -- Line: 326, Name: getGroups
        -- upvalues: groups (copy)
        local v33 = {};

        for _, v in groups do
            table.insert(v33, v);
        end;

        return v33;
    end,

    getZones = function(p34) -- Line: 342, Name: getZones
        -- upvalues: zoneIdToZoneObj (copy)
        local v35 = {};

        for _, v in zoneIdToZoneObj do
            table.insert(v35, v);
        end;

        return v35;
    end,

    getEntities = function(p36) -- Line: 358, Name: getEntities
        -- upvalues: entityData (copy), entityToReference (copy)
        local v37 = 0;
        local v38 = {};

        for i in entityData do
            v37 = v37 + 1;
            v38[v37] = entityToReference[i] or i;
        end;

        return v38;
    end,

    getZonesAtPoint = function(p39, u40) -- Line: 378, Name: getZonesAtPoint
        -- upvalues: queryPoint (copy), dynamicTree (copy), isPointInShape (copy), dynamicCFrames (copy), dynamicHalfSizes (copy), dynamicTypes (copy), zoneIdToZoneObj (copy), staticTree (copy), staticCFrames (copy), staticHalfSizes (copy), staticTypes (copy)
        local u41 = {};
        local u42 = 0;
        queryPoint(dynamicTree, u40, function(p43) -- Line: 382
            -- upvalues: isPointInShape (ref), u40 (copy), dynamicCFrames (ref), dynamicHalfSizes (ref), dynamicTypes (ref), zoneIdToZoneObj (ref), u42 (ref), u41 (copy)
            local v44 = isPointInShape(u40, dynamicCFrames[p43], dynamicHalfSizes[p43], dynamicTypes[p43]) and zoneIdToZoneObj[p43];

            if v44 then
                u42 = u42 + 1;
                u41[u42] = v44;
            end;
        end);
        queryPoint(staticTree, u40, function(p45) -- Line: 392
            -- upvalues: isPointInShape (ref), u40 (copy), staticCFrames (ref), staticHalfSizes (ref), staticTypes (ref), zoneIdToZoneObj (ref), u42 (ref), u41 (copy)
            local v46 = isPointInShape(u40, staticCFrames[p45], staticHalfSizes[p45], staticTypes[p45]) and zoneIdToZoneObj[p45];

            if v46 then
                u42 = u42 + 1;
                u41[u42] = v46;
            end;
        end);

        return u41;
    end,

    getZonesOfEntity = function(p47, p48) -- Line: 414, Name: getZonesOfEntity
        -- upvalues: referenceToEntity (copy), entityData (copy), zoneIdToZoneObj (copy)
        local v49 = entityData[referenceToEntity[p48] or p48];

        if not (v49 and v49.activeObserverMemberships) then
            return {};
        end;

        local v50 = {};
        local v51 = {};

        for _, v in v49.activeObserverMemberships do
            if not v50[v] then
                v50[v] = true;
                local v52 = zoneIdToZoneObj[v];

                if v52 then
                    table.insert(v51, v52);
                end;
            end;
        end;

        return v51;
    end,

    getGroupsOfEntity = function(p53, p54) -- Line: 447, Name: getGroupsOfEntity
        -- upvalues: referenceToEntity (copy), entityToGroups (copy), groups (copy)
        local v55 = entityToGroups[referenceToEntity[p54] or p54];

        if not v55 then
            return {};
        end;

        local v56 = 0;
        local v57 = {};

        for i in v55 do
            local v58 = groups[i];

            if v58 then
                v56 = v56 + 1;
                v57[v56] = v58;
            end;
        end;

        return v57;
    end,

    iterGroups = function(p59) -- Line: 475, Name: iterGroups
        -- upvalues: groups (copy)
        local u60 = nil;

        return function() -- Line: 477
            -- upvalues: u60 (ref), groups (ref)
            u60 = next(groups, u60);

            return u60 and groups[u60] or nil;
        end;
    end,

    iterZones = function(p61) -- Line: 490, Name: iterZones
        -- upvalues: zoneIdToZoneObj (copy)
        local u62 = nil;

        return function() -- Line: 493
            -- upvalues: u62 (ref), zoneIdToZoneObj (ref)
            u62 = next(zoneIdToZoneObj, u62);

            return u62 and zoneIdToZoneObj[u62] or nil;
        end;
    end,

    iterEntities = function(p63) -- Line: 506, Name: iterEntities
        -- upvalues: entityData (copy), entityToReference (copy)
        local u64 = nil;

        return function() -- Line: 509
            -- upvalues: u64 (ref), entityData (ref), entityToReference (ref)
            u64 = next(entityData, u64);

            if u64 then
                return entityToReference[u64] or u64;
            end;

            return u64;
        end;
    end,

    iterObservers = function(p65) -- Line: 525, Name: iterObservers
        -- upvalues: observerIdToObserverObj (copy)
        local u66 = nil;

        return function() -- Line: 528
            -- upvalues: u66 (ref), observerIdToObserverObj (ref)
            u66 = next(observerIdToObserverObj, u66);

            return u66 and observerIdToObserverObj[u66] or nil;
        end;
    end,

    iterGroupsOfEntity = function(p67, p68) -- Line: 542, Name: iterGroupsOfEntity
        -- upvalues: referenceToEntity (copy), entityToGroups (copy), groups (copy)
        local u69 = entityToGroups[referenceToEntity[p68] or p68];

        if not u69 then
            return function() -- Line: 547
                return nil;
            end;
        end;

        local u70 = nil;

        return function() -- Line: 553
            -- upvalues: u70 (ref), u69 (copy), groups (ref)
            u70 = next(u69, u70);

            return u70 and groups[u70] or nil;
        end;
    end,

    iterZonesOfEntity = function(p71, p72) -- Line: 567, Name: iterZonesOfEntity
        -- upvalues: referenceToEntity (copy), entityData (copy), zoneIdToZoneObj (copy)
        local v73 = entityData[referenceToEntity[p72] or p72];

        if not (v73 and v73.activeObserverMemberships) then
            return function() -- Line: 572
                return nil;
            end;
        end;

        local activeObserverMemberships = v73.activeObserverMemberships;
        local u74 = {};
        local u75 = nil;

        return function() -- Line: 581
            -- upvalues: u75 (ref), activeObserverMemberships (copy), u74 (copy), zoneIdToZoneObj (ref)
            while true do
                u75 = next(activeObserverMemberships, u75);

                if not u75 then
                    break;
                end;

                local v76 = activeObserverMemberships[u75];

                if not u74[v76] then
                    u74[v76] = true;
                    local v77 = zoneIdToZoneObj[v76];

                    if v77 then
                        return v77;
                    end;
                end;
            end;

            return nil;
        end;
    end,

    iterZonesAtPoint = function(p78, u79) -- Line: 612, Name: iterZonesAtPoint
        -- upvalues: dynamicTree (copy), staticTree (copy), isPointInShape (copy), dynamicCFrames (copy), dynamicHalfSizes (copy), dynamicTypes (copy), zoneIdToZoneObj (copy), staticCFrames (copy), staticHalfSizes (copy), staticTypes (copy)
        local nodes = dynamicTree.nodes;
        local u80 = dynamicTree.count or 0;
        local nodes2 = staticTree.nodes;
        local u81 = staticTree.count or 0;
        local X = u79.X;
        local Y = u79.Y;
        local Z = u79.Z;
        local u82 = 1;
        local u83 = true;

        return function() -- Line: 624
            -- upvalues: u83 (ref), u82 (ref), u80 (copy), nodes (copy), X (copy), Y (copy), Z (copy), isPointInShape (ref), u79 (copy), dynamicCFrames (ref), dynamicHalfSizes (ref), dynamicTypes (ref), zoneIdToZoneObj (ref), u81 (copy), nodes2 (copy), staticCFrames (ref), staticHalfSizes (ref), staticTypes (ref)
            if u83 then
                while u82 <= u80 do
                    local v84 = nodes[u82];
                    local min = v84.min;
                    local max = v84.max;

                    if X < min.X or (X > max.X or (Y < min.Y or (Y > max.Y or (Z < min.Z or Z > max.Z)))) then
                        u82 = v84.skipIndex;
                    else
                        u82 = u82 + 1;
                        local id = v84.id;

                        if id > 0 and isPointInShape(u79, dynamicCFrames[id], dynamicHalfSizes[id], dynamicTypes[id]) then
                            return zoneIdToZoneObj[id];
                        end;
                    end;
                end;

                u83 = false;
                u82 = 1;
            end;

            if not u83 then
                while u82 <= u81 do
                    local v85 = nodes2[u82];
                    local min = v85.min;
                    local max = v85.max;

                    if X < min.X or (X > max.X or (Y < min.Y or (Y > max.Y or (Z < min.Z or Z > max.Z)))) then
                        u82 = v85.skipIndex;
                    else
                        u82 = u82 + 1;
                        local id = v85.id;

                        if id > 0 and isPointInShape(u79, staticCFrames[id], staticHalfSizes[id], staticTypes[id]) then
                            return zoneIdToZoneObj[id];
                        end;
                    end;
                end;
            end;

            return nil;
        end;
    end,

    visualize = function(p86, p87) -- Line: 686, Name: visualize
        -- upvalues: u1 (ref), u2 (ref), u3 (copy), zoneIdToZoneObj (copy), Config (copy), RunService (copy), staticCFrames (copy), staticHalfSizes (copy), zoneAttachedObservers (copy), dynamicCFrames (copy), dynamicHalfSizes (copy)
        if u1 then
            u1:Disconnect();
            u1 = nil;
        end;

        if u2 then
            u2:Destroy();
            u2 = nil;
        end;

        table.clear(u3);

        if not p87 then
            return p86;
        end;

        local Folder = Instance.new("Folder");
        Folder.Name = "QuickZone_Debug_Visuals";
        Folder.Parent = workspace;
        u2 = Folder;

        local function getOrCreateVisual(p88) -- Line: 706
            -- upvalues: u3 (ref), zoneIdToZoneObj (ref), Config (ref), u2 (ref)
            local v89 = u3[p88];
            local v90 = zoneIdToZoneObj[p88]:getShape();

            if v89 and v89.shape ~= v90 then
                v89.adornment:Destroy();
                u3[p88] = nil;
            end;

            if not v89 then
                local v91;

                if v90 == "Ball" then
                    v91 = Instance.new("SphereHandleAdornment");
                elseif v90 == "Cylinder" then
                    v91 = Instance.new("CylinderHandleAdornment");
                else
                    v91 = Instance.new("BoxHandleAdornment");
                end;

                v91.Name = "Zone_" .. p88;
                v91.Adornee = workspace.Terrain;
                v91.Transparency = Config.Debug.transparency;
                v91.AlwaysOnTop = true;
                v91.ZIndex = 1;
                v91.Parent = u2;
                v89 = {
                    adornment = v91,
                    shape = v90
                };
                u3[p88] = v89;
            end;

            return v89;
        end;

        u1 = (RunService:IsClient() and RunService.PreRender or RunService.Heartbeat):Connect(function() -- Line: 742
            -- upvalues: u2 (ref), staticCFrames (ref), getOrCreateVisual (copy), staticHalfSizes (ref), zoneAttachedObservers (ref), Config (ref), dynamicCFrames (ref), dynamicHalfSizes (ref), u3 (ref)
            if not u2 then
                return;
            end;

            for i, v in staticCFrames do
                local v92 = getOrCreateVisual(i);
                local adornment = v92.adornment;
                local v93 = staticHalfSizes[i];
                local v94 = v93 * 2;
                local v95 = zoneAttachedObservers[i] and next(v95) ~= nil;
                local v96 = v95 and Config.Debug.staticActive or Config.Debug.staticInactive;

                if v92.shape == "Ball" then
                    adornment.Radius = math.max(v93.X, v93.Y, v93.Z);
                    adornment.CFrame = v;
                elseif v92.shape == "Cylinder" then
                    adornment.Radius = math.max(v93.X, v93.Z);
                    adornment.Height = v94.X;
                    adornment.CFrame = v * CFrame.Angles(0, 1.5707963267948966, 0);
                else
                    adornment.Size = v94;
                    adornment.CFrame = v;
                end;

                adornment.Color3 = v96;
            end;

            for i, v in dynamicCFrames do
                local v97 = getOrCreateVisual(i);
                local adornment = v97.adornment;
                local v98 = dynamicHalfSizes[i];
                local v99 = v98 * 2;
                local v100 = zoneAttachedObservers[i] and next(v100) ~= nil;
                local v101 = v100 and Config.Debug.dynamicActive or Config.Debug.dynamicInactive;

                if v97.shape == "Ball" then
                    adornment.Radius = math.max(v98.X, v98.Y, v98.Z);
                    adornment.CFrame = v;
                elseif v97.shape == "Cylinder" then
                    adornment.Radius = math.max(v98.X, v98.Z);
                    adornment.Height = v99.X;
                    adornment.CFrame = v * CFrame.Angles(0, 1.5707963267948966, 0);
                else
                    adornment.Size = v99;
                    adornment.CFrame = v;
                end;

                adornment.Color3 = v101;
            end;

            for i, v in u3 do
                if not (staticCFrames[i] or dynamicCFrames[i]) then
                    v.adornment:Destroy();
                    u3[i] = nil;
                end;
            end;
        end);

        return p86;
    end
};