-- Ruta Original: ReplicatedStorage.Utilities.QuickZone.Classes.Observer
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Config = require(script.Parent.Parent.Config);
local State = require(script.Parent.Parent.Core.State);
require(script.Parent.Parent.Types);
local Geometry = require(script.Parent.Parent.Utils.Geometry);
local Log = require(script.Parent.Parent.Utils.Log);
local isPointInShape = Geometry.isPointInShape;
local u1 = {};
local u2 = {};
local dirtyProfiles = State.dirtyProfiles;
local dirtyTopology = State.dirtyTopology;
local zoneAttachedObservers = State.zoneAttachedObservers;
local staticCFrames = State.staticCFrames;
local staticHalfSizes = State.staticHalfSizes;
local staticTypes = State.staticTypes;
local dynamicCFrames = State.dynamicCFrames;
local dynamicHalfSizes = State.dynamicHalfSizes;
local dynamicTypes = State.dynamicTypes;
local dynamicTree = State.dynamicTree;
local staticTree = State.staticTree;
local u3 = RunService:IsClient();

local function updateAllEntitiesForObserver(p4) -- Line: 39
    -- upvalues: State (copy), dirtyProfiles (copy), dirtyTopology (copy)
    for i, v in State.groupToObservers do
        if v[p4] then
            local v5 = State.groups[i];

            if v5 then
                for _, v2 in v5.entities do
                    dirtyProfiles[v2] = true;
                    dirtyTopology[v2] = true;
                end;
            end;
        end;
    end;
end;

local function disconnectObserverFromGroup(p6, p7) -- Line: 57
    -- upvalues: State (copy), dirtyProfiles (copy), dirtyTopology (copy)
    local v8 = State.observerSafety[p6];
    local v9 = State.observerEnabled[p6];

    for _, v in p7.entities do
        local v10 = State.entityData[v];

        if v10 then
            dirtyProfiles[v] = true;
            dirtyTopology[v] = true;
            local v11 = v10.activeObserverMemberships[p6];

            if v11 then
                local v12 = false;

                if v9 then
                    for i in State.entityToGroups[v] do
                        if State.groupToObservers[i] and State.groupToObservers[i][p6] then
                            v12 = true;
                            break;
                        end;
                    end;
                end;

                if not v12 then
                    v10.activeObserverMemberships[p6] = nil;

                    if State.observerTrackingEntities[p6] then
                        State.observerTrackingEntities[p6][v] = nil;
                    end;

                    local v13 = State.observerExitedCallbacks[p6];

                    if v13 then
                        local v14 = State.zoneIdToZoneObj[v11];
                        local v15 = State.entityToReference[v] or v;

                        for _, v2 in v13 do
                            if v8 then
                                task.spawn(v2, v15, v14, v);
                            else
                                v2(v15, v14, v);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

local u16 = {};
u16.__index = u16;

function u16.new(p17) -- Line: 151
    -- upvalues: State (copy), u16 (copy), Config (copy), u1 (copy), u2 (copy), Log (copy)
    local nextObserverId = State.nextObserverId;
    local v18 = State;
    v18.nextObserverId = v18.nextObserverId + 1;
    local u19 = setmetatable({
        id = nextObserverId
    }, u16);
    State.observerPriorityMap[nextObserverId] = p17 and (p17.priority or 0) or 0;
    State.observerUpdateRate[nextObserverId] = p17 and p17.updateRate or Config.Observer.updateRate;
    State.observerPrecisionSq[nextObserverId] = (p17 and p17.precision or Config.Observer.precision) ^ 2;
    State.observerEnteredCallbacks[nextObserverId] = {};
    State.observerExitedCallbacks[nextObserverId] = {};
    State.observerTransitionedCallbacks[nextObserverId] = {};
    State.observerTrackingEntities[nextObserverId] = {};
    State.observerIdToObserverObj[nextObserverId] = u19;
    State.observerEnabled[nextObserverId] = (not p17 or p17.enabled == nil) and true or p17.enabled;
    local v20;

    if p17 and p17.safety ~= nil then
        v20 = p17.safety;
    else
        v20 = Config.Observer.safety;
    end;

    State.observerSafety[nextObserverId] = v20;
    State.observerStaticCount[nextObserverId] = 0;
    State.observerDynamicCount[nextObserverId] = 0;
    u1[nextObserverId] = false;
    u2[nextObserverId] = false;

    if p17 and p17.zones then
        for _, v in p17.zones do
            u19:attach(v);
        end;
    end;

    if p17 and p17.groups then
        for _, v in p17.groups do
            u19:subscribe(v);
        end;
    end;

    local v21;

    if p17 then
        v21 = p17.zones ~= nil;
    else
        v21 = p17;
    end;

    if p17 then
        p17 = p17.groups ~= nil;
    end;

    local u22 = not v21 and not u1[nextObserverId];
    local u23 = not p17 and not u2[nextObserverId];

    if u22 or u23 then
        local u24 = debug.traceback("", 2);
        task.defer(function() -- Line: 206
            -- upvalues: State (ref), nextObserverId (copy), u19 (copy), u22 (copy), u1 (ref), Log (ref), u24 (copy), u23 (copy), u2 (ref)
            if not (State.observerIdToObserverObj[nextObserverId] and u19:isEnabled()) then
                return;
            end;

            if u22 and not u1[nextObserverId] then
                Log.warn("Observer %d has no attached zones. It will not detect spatial queries.", u24, nextObserverId);
            end;

            if u23 and not u2[nextObserverId] then
                Log.warn("Observer %d has no subscribed groups. It will not track any entities.", u24, nextObserverId);
            end;
        end);
    end;

    return u19;
end;

function u16.subscribe(p25, p26) -- Line: 239
    -- upvalues: u2 (copy), State (copy), dirtyProfiles (copy), dirtyTopology (copy)
    u2[p25.id] = true;
    local id = p26.id;

    if not State.groupToObservers[id] then
        State.groupToObservers[id] = {};
    end;

    State.groupToObservers[id][p25.id] = true;

    for _, v in p26.entities do
        dirtyProfiles[v] = true;
        dirtyTopology[v] = true;
    end;

    return p25;
end;

function u16.unsubscribe(p27, p28) -- Line: 265
    -- upvalues: State (copy), disconnectObserverFromGroup (copy)
    local id = p28.id;

    if State.groupToObservers[id] then
        State.groupToObservers[id][p27.id] = nil;
    end;

    disconnectObserverFromGroup(p27.id, p28);

    return p27;
end;

function u16.attach(p29, p30) -- Line: 294
    -- upvalues: u1 (copy)
    u1[p29.id] = true;
    p30:attach(p29);

    return p29;
end;

function u16.detach(p31, p32) -- Line: 310
    p32:detach(p31);

    return p31;
end;

function u16.observe(p33, u34) -- Line: 338
    local u35 = {};
    local u36 = {};
    local u37 = 0;
    local u43 = p33:onEnter(function(p38, p39, p40) -- Line: 346
        -- upvalues: u37 (ref), u36 (copy), u34 (copy), u35 (copy)
        u37 = u37 + 1;
        local v41 = u37;
        u36[p40] = v41;
        local v42 = u34(p38, p39, p40);

        if u36[p40] == v41 then
            if type(v42) == "function" then
                u35[p40] = v42;
            end;

            return;
        end;

        if type(v42) == "function" then
            v42();
        end;
    end);
    local u48 = p33:onExit(function(p44, p45, p46) -- Line: 365
        -- upvalues: u36 (copy), u35 (copy)
        u36[p46] = nil;
        local v47 = u35[p46];

        if v47 then
            u35[p46] = nil;
            v47();
        end;
    end);

    local function disconnect() -- Line: 375
        -- upvalues: u43 (copy), u48 (copy), u36 (copy), u35 (copy)
        u43();
        u48();
        table.clear(u36);

        for i, v in u35 do
            u35[i] = nil;
            task.spawn(v);
        end;
    end;

    local u49 = p33:onDestroy(disconnect);

    return function() -- Line: 389
        -- upvalues: u49 (copy), disconnect (copy)
        u49();
        disconnect();
    end;
end;

function u16.onEnter(u50, u51) -- Line: 410
    -- upvalues: State (copy)
    table.insert(State.observerEnteredCallbacks[u50.id], u51);

    return function() -- Line: 412
        -- upvalues: State (ref), u50 (copy), u51 (copy)
        local v52 = table.find(State.observerEnteredCallbacks[u50.id], u51);

        if v52 then
            table.remove(State.observerEnteredCallbacks[u50.id], v52);
        end;
    end;
end;

function u16.onExit(u53, u54) -- Line: 429
    -- upvalues: State (copy)
    table.insert(State.observerExitedCallbacks[u53.id], u54);

    return function() -- Line: 431
        -- upvalues: State (ref), u53 (copy), u54 (copy)
        local v55 = table.find(State.observerExitedCallbacks[u53.id], u54);

        if v55 then
            table.remove(State.observerExitedCallbacks[u53.id], v55);
        end;
    end;
end;

function u16.observePlayer(p56, u57) -- Line: 458
    local u58 = {};
    local u59 = {};
    local u60 = 0;
    local u66 = p56:onEnter(function(p61, p62, p63) -- Line: 466
        -- upvalues: u60 (ref), u59 (copy), u57 (copy), u58 (copy)
        if typeof(p61) ~= "Instance" or not p61:IsA("Player") then
            return;
        end;

        u60 = u60 + 1;
        local v64 = u60;
        u59[p63] = v64;
        local v65 = u57(p61, p62, p63);

        if u59[p63] == v64 then
            if type(v65) == "function" then
                u58[p63] = v65;
            end;

            return;
        end;

        if type(v65) == "function" then
            v65();
        end;
    end);
    local u71 = p56:onExit(function(p67, p68, p69) -- Line: 489
        -- upvalues: u59 (copy), u58 (copy)
        if not u59[p69] then
            return;
        end;

        u59[p69] = nil;
        local v70 = u58[p69];

        if v70 then
            u58[p69] = nil;
            v70();
        end;
    end);

    local function u72() -- Line: 503
        -- upvalues: u66 (copy), u71 (copy), u59 (copy), u58 (copy)
        u66();
        u71();
        table.clear(u59);

        for i, v in u58 do
            u58[i] = nil;
            task.spawn(v);
        end;
    end;

    local u73 = p56:onDestroy(u72);

    return function() -- Line: 517
        -- upvalues: u73 (copy), u72 (copy)
        u73();
        u72();
    end;
end;

function u16.onPlayerEnter(p74, u75) -- Line: 544
    return p74:onEnter(function(p76, p77, p78) -- Line: 548
        -- upvalues: u75 (copy)
        if typeof(p76) == "Instance" and p76:IsA("Player") then
            u75(p76, p77, p78);
        end;
    end);
end;

function u16.onPlayerExit(p79, u80) -- Line: 565
    return p79:onExit(function(p81, p82, p83) -- Line: 569
        -- upvalues: u80 (copy)
        if typeof(p81) == "Instance" and p81:IsA("Player") then
            u80(p81, p82, p83);
        end;
    end);
end;

function u16.observeLocalPlayer(p84, u85) -- Line: 594
    -- upvalues: u3 (copy), Log (copy), Players (copy)
    if not u3 then
        Log.fatal("Observer:observeLocalPlayer can only be called on the Client.", nil);
    end;

    local u86 = {};
    local u87 = {};
    local u88 = 0;
    local u94 = p84:onEnter(function(p89, p90, p91) -- Line: 606
        -- upvalues: Players (ref), u88 (ref), u87 (copy), u85 (copy), u86 (copy)
        if p89 ~= Players.LocalPlayer then
            return;
        end;

        u88 = u88 + 1;
        local v92 = u88;
        u87[p91] = v92;
        local v93 = u85(p90, p91);

        if u87[p91] == v92 then
            if type(v93) == "function" then
                u86[p91] = v93;
            end;

            return;
        end;

        if type(v93) == "function" then
            v93();
        end;
    end);
    local u99 = p84:onExit(function(p95, p96, p97) -- Line: 629
        -- upvalues: u87 (copy), u86 (copy)
        if not u87[p97] then
            return;
        end;

        u87[p97] = nil;
        local v98 = u86[p97];

        if v98 then
            u86[p97] = nil;
            v98();
        end;
    end);

    local function u100() -- Line: 643
        -- upvalues: u94 (copy), u99 (copy), u87 (copy), u86 (copy)
        u94();
        u99();
        table.clear(u87);

        for i, v in u86 do
            u86[i] = nil;
            task.spawn(v);
        end;
    end;

    local u101 = p84:onDestroy(u100);

    return function() -- Line: 657
        -- upvalues: u101 (copy), u100 (copy)
        u101();
        u100();
    end;
end;

function u16.onLocalPlayerEnter(p102, u103) -- Line: 684
    -- upvalues: u3 (copy), Log (copy), Players (copy)
    if not u3 then
        Log.fatal("Observer:onLocalPlayerEnter can only be called on the Client.", nil);
    end;

    return p102:onEnter(function(p104, p105, p106) -- Line: 689
        -- upvalues: Players (ref), u103 (copy)
        if p104 == Players.LocalPlayer then
            u103(p105, p106);
        end;
    end);
end;

function u16.onLocalPlayerExit(p107, u108) -- Line: 707
    -- upvalues: u3 (copy), Log (copy), Players (copy)
    if not u3 then
        Log.fatal("Observer:onLocalPlayerExit can only be called on the Client.", nil);
    end;

    return p107:onExit(function(p109, p110, p111) -- Line: 712
        -- upvalues: Players (ref), u108 (copy)
        if p109 == Players.LocalPlayer then
            u108(p110, p111);
        end;
    end);
end;

function u16.observeGroup(u112, u113) -- Line: 738
    -- upvalues: State (copy)
    local u114 = {};
    local u115 = {};

    return u112:observe(function(p116, p117, u118) -- Line: 745
        -- upvalues: State (ref), u112 (copy), u114 (copy), u113 (copy), u115 (copy)
        local v119 = State.entityToGroups[u118];

        if not v119 then
            return nil;
        end;

        for i, _ in v119 do
            local v120 = State.groups[i];

            if v120 and State.groupToObservers[i][u112.id] then
                if not u114[i] then
                    u114[i] = {};
                end;

                if next(u114[i]) == nil then
                    u114[i][u118] = true;
                    local v121 = u113(v120, p117, u118);

                    if typeof(v121) == "function" then
                        u115[i] = v121;
                    end;
                else
                    u114[i][u118] = true;
                end;
            end;
        end;

        return function() -- Line: 772
            -- upvalues: u114 (ref), u118 (copy), u115 (ref)
            for i, v in u114 do
                if v[u118] then
                    v[u118] = nil;

                    if next(v) == nil then
                        u114[i] = nil;
                        local v122 = u115[i];

                        if v122 then
                            v122();
                            u115[i] = nil;
                        end;
                    end;
                end;
            end;
        end;
    end);
end;

function u16.onGroupEnter(u123, u124) -- Line: 805
    -- upvalues: State (copy)
    local u125 = {};

    return u123:observe(function(p126, p127, u128) -- Line: 811
        -- upvalues: State (ref), u123 (copy), u125 (copy), u124 (copy)
        local v129 = State.entityToGroups[u128];

        if not v129 then
            return nil;
        end;

        for i, _ in v129 do
            if State.groupToObservers[i] and State.groupToObservers[i][u123.id] then
                if not u125[i] then
                    u125[i] = {};
                end;

                local v130 = next(u125[i]) == nil;
                u125[i][u128] = true;

                if v130 then
                    local v131 = State.groups[i];

                    if v131 then
                        u124(v131, p127, u128);
                    end;
                end;
            end;
        end;

        return function() -- Line: 837
            -- upvalues: u125 (ref), u128 (copy)
            for i, v in u125 do
                if v[u128] then
                    v[u128] = nil;

                    if next(v) == nil then
                        u125[i] = nil;
                    end;
                end;
            end;
        end;
    end);
end;

function u16.onGroupExit(u132, u133) -- Line: 862
    -- upvalues: State (copy)
    local u134 = {};

    return u132:observe(function(p135, u136, u137) -- Line: 868
        -- upvalues: State (ref), u132 (copy), u134 (copy), u133 (copy)
        local v138 = State.entityToGroups[u137];

        if not v138 then
            return nil;
        end;

        for i, _ in v138 do
            if State.groupToObservers[i] and State.groupToObservers[i][u132.id] then
                if not u134[i] then
                    u134[i] = {};
                end;

                u134[i][u137] = true;
            end;
        end;

        return function() -- Line: 885
            -- upvalues: u134 (ref), u137 (copy), State (ref), u133 (ref), u136 (copy)
            for i, v in u134 do
                if v[u137] then
                    v[u137] = nil;

                    if next(v) == nil then
                        u134[i] = nil;
                        local v139 = State.groups[i];

                        if v139 then
                            u133(v139, u136, u137);
                        end;
                    end;
                end;
            end;
        end;
    end);
end;

function u16.onTransition(u140, u141) -- Line: 914
    -- upvalues: State (copy)
    table.insert(State.observerTransitionedCallbacks[u140.id], u141);

    return function() -- Line: 917
        -- upvalues: State (ref), u140 (copy), u141 (copy)
        local v142 = table.find(State.observerTransitionedCallbacks[u140.id], u141);

        if v142 then
            table.remove(State.observerTransitionedCallbacks[u140.id], v142);
        end;
    end;
end;

function u16.onPlayerTransition(p143, u144) -- Line: 935
    -- upvalues: State (copy)
    return p143:onTransition(function(p145, p146, p147) -- Line: 939
        -- upvalues: State (ref), u144 (copy)
        local v148 = State.entityToReference[p145] or p145;

        if typeof(v148) == "Instance" and v148:IsA("Player") then
            u144(v148, p146, p147);
        end;
    end);
end;

function u16.onLocalPlayerTransition(p149, u150) -- Line: 957
    -- upvalues: u3 (copy), Log (copy), State (copy), Players (copy)
    if not u3 then
        Log.fatal("Observer:onLocalPlayerTransition can only be called on the Client.", nil);
    end;

    return p149:onTransition(function(p151, p152, p153) -- Line: 965
        -- upvalues: State (ref), Players (ref), u150 (copy)
        if (State.entityToReference[p151] or p151) == Players.LocalPlayer then
            u150(p152, p153);
        end;
    end);
end;

function u16.setEnabled(p154, p155) -- Line: 983
    -- upvalues: State (copy), disconnectObserverFromGroup (copy), updateAllEntitiesForObserver (copy)
    if p154:isEnabled() == p155 then
        return p154;
    end;

    local id = p154.id;
    State.observerEnabled[id] = p155;
    local v156 = State;
    v156.logicVersion = v156.logicVersion + 1;

    if not p155 then
        for i, v in State.groupToObservers do
            if v[id] then
                local v157 = State.groups[i];

                if v157 then
                    disconnectObserverFromGroup(id, v157);
                end;
            end;
        end;
    end;

    updateAllEntitiesForObserver(p154.id);

    return p154;
end;

function u16.setSafety(p158, p159) -- Line: 1027
    -- upvalues: State (copy)
    State.observerSafety[p158.id] = p159;

    return p158;
end;

function u16.setPriority(p160, p161) -- Line: 1041
    -- upvalues: State (copy)
    State.observerPriorityMap[p160.id] = p161;
    local v162 = State;
    v162.logicVersion = v162.logicVersion + 1;

    return p160;
end;

function u16.setUpdateRate(p163, p164) -- Line: 1056
    -- upvalues: Log (copy), State (copy), updateAllEntitiesForObserver (copy)
    if p164 < 0 then
        Log.fatal("updateRate must be non-negative.", nil);
    end;

    State.observerUpdateRate[p163.id] = p164;
    updateAllEntitiesForObserver(p163.id);

    return p163;
end;

function u16.setPrecision(p165, p166) -- Line: 1075
    -- upvalues: Log (copy), State (copy), updateAllEntitiesForObserver (copy)
    if p166 < 0 then
        Log.fatal("precision must be non-negative.", nil);
    end;

    State.observerPrecisionSq[p165.id] = p166 ^ 2;
    updateAllEntitiesForObserver(p165.id);

    return p165;
end;

function u16.isEnabled(p167) -- Line: 1092
    -- upvalues: State (copy)
    return State.observerEnabled[p167.id] ~= false;
end;

function u16.isPointInside(p168, p169) -- Line: 1104
    -- upvalues: dynamicTree (copy), zoneAttachedObservers (copy), isPointInShape (copy), dynamicCFrames (copy), dynamicHalfSizes (copy), dynamicTypes (copy), staticTree (copy), staticCFrames (copy), staticHalfSizes (copy), staticTypes (copy)
    local X = p169.X;
    local Y = p169.Y;
    local Z = p169.Z;
    local id = p168.id;
    local nodes = dynamicTree.nodes;
    local v170 = 1;

    while v170 <= dynamicTree.count do
        local v171 = nodes[v170];
        local min = v171.min;
        local max = v171.max;

        if X < min.X or (max.X < X or (Y < min.Y or (max.Y < Y or (Z < min.Z or max.Z < Z)))) then
            v170 = v171.skipIndex;
        else
            local id2 = v171.id;
            v170 = v170 + 1;

            if id2 ~= 0 then
                local v172 = zoneAttachedObservers[id2];

                if v172 and (table.find(v172, id) and isPointInShape(p169, dynamicCFrames[id2], dynamicHalfSizes[id2], dynamicTypes[id2])) then
                    return true;
                end;
            end;
        end;
    end;

    local nodes2 = staticTree.nodes;
    local v173 = 1;

    while v173 <= staticTree.count do
        local v174 = nodes2[v173];
        local min = v174.min;
        local max = v174.max;

        if X < min.X or (max.X < X or (Y < min.Y or (max.Y < Y or (Z < min.Z or max.Z < Z)))) then
            v173 = v174.skipIndex;
        else
            local id2 = v174.id;
            v173 = v173 + 1;

            if id2 ~= 0 then
                local v175 = zoneAttachedObservers[id2];

                if v175 and (table.find(v175, id) and isPointInShape(p169, staticCFrames[id2], staticHalfSizes[id2], staticTypes[id2])) then
                    return true;
                end;
            end;
        end;
    end;

    return false;
end;

function u16.isSafe(p176) -- Line: 1176
    -- upvalues: State (copy)
    return State.observerSafety[p176.id];
end;

function u16.getId(p177) -- Line: 1187
    return p177.id;
end;

function u16.getPriority(p178) -- Line: 1198
    -- upvalues: State (copy)
    return State.observerPriorityMap[p178.id];
end;

function u16.getUpdateRate(p179) -- Line: 1209
    -- upvalues: State (copy)
    return State.observerUpdateRate[p179.id];
end;

function u16.getPrecision(p180) -- Line: 1220
    -- upvalues: State (copy)
    return math.sqrt(State.observerPrecisionSq[p180.id]);
end;

function u16.getEntitiesInside(p181) -- Line: 1231
    -- upvalues: State (copy)
    local v182 = State.observerTrackingEntities[p181.id];

    if not v182 then
        return {};
    end;

    local v183 = {};

    for i, _ in v182 do
        table.insert(v183, State.entityToReference[i] or i);
    end;

    return v183;
end;

function u16.getPlayersInside(p184) -- Line: 1251
    -- upvalues: State (copy)
    local v185 = {};

    for i in State.observerTrackingEntities[p184.id] do
        local v186 = State.entityToReference[i] or i;

        if typeof(v186) == "Instance" and (v186:IsA("Player") and not table.find(v185, v186)) then
            table.insert(v185, v186);
        end;
    end;

    return v185;
end;

function u16.getZones(p187) -- Line: 1273
    -- upvalues: State (copy)
    local v188 = {};

    for i, v in State.zoneAttachedObservers do
        if table.find(v, p187.id) then
            local v189 = State.zoneIdToZoneObj[i];

            if v189 then
                table.insert(v188, v189);
            end;
        end;
    end;

    return v188;
end;

function u16.getGroups(p190) -- Line: 1295
    -- upvalues: State (copy)
    local v191 = {};

    for i, v in State.groupToObservers do
        if v[p190.id] then
            local v192 = State.groups[i];

            if v192 then
                table.insert(v191, v192);
            end;
        end;
    end;

    return v191;
end;

function u16.getZoneOfEntity(p193, p194) -- Line: 1320
    -- upvalues: State (copy)
    local v195 = State.entityData[State.referenceToEntity[p194] or p194];

    if not v195 then
        return nil;
    end;

    local v196 = v195.activeObserverMemberships[p193.id];

    if v196 then
        return State.zoneIdToZoneObj[v196];
    end;

    return nil;
end;

function u16.getZoneOfPlayer(p197, p198) -- Line: 1343
    return p197:getZoneOfEntity(p198);
end;

function u16.getEntitiesInZone(p199, p200) -- Line: 1355
    local v201 = {};

    for i in p199:iterEntitiesInZone(p200) do
        table.insert(v201, i);
    end;

    return v201;
end;

function u16.getPlayersInZone(p202, p203) -- Line: 1373
    local v204 = {};

    for i in p202:iterPlayersInZone(p203) do
        table.insert(v204, i);
    end;

    return v204;
end;

function u16.iterZones(p205) -- Line: 1390
    -- upvalues: zoneAttachedObservers (copy), State (copy)
    local u206 = nil;
    local u207 = nil;
    local id = p205.id;

    return function() -- Line: 1395
        -- upvalues: u206 (ref), u207 (ref), zoneAttachedObservers (ref), id (copy), State (ref)
        while true do
            local v208, v209 = next(zoneAttachedObservers, u206);
            u206 = v208;
            u207 = v209;

            if not u206 then
                break;
            end;

            local v210 = table.find(u207, id) and State.zoneIdToZoneObj[u206];

            if v210 then
                return v210;
            end;
        end;

        return nil;
    end;
end;

function u16.iterGroups(p211) -- Line: 1422
    -- upvalues: State (copy)
    local u212 = nil;
    local u213 = nil;
    local id = p211.id;

    return function() -- Line: 1427
        -- upvalues: u212 (ref), u213 (ref), State (ref), id (copy)
        while true do
            local v214, v215 = next(State.groupToObservers, u212);
            u212 = v214;
            u213 = v215;

            if not u212 then
                break;
            end;

            local v216 = u213[id] and State.groups[u212];

            if v216 then
                return v216;
            end;
        end;

        return nil;
    end;
end;

function u16.iterEntitiesInside(p217) -- Line: 1455
    -- upvalues: State (copy)
    local u218 = State.observerTrackingEntities[p217.id] or {};
    local u219 = nil;
    local id = p217.id;

    return function() -- Line: 1460
        -- upvalues: u219 (ref), u218 (copy), State (ref), id (copy)
        while true do
            u219 = next(u218, u219);

            if not u219 then
                break;
            end;

            local v220 = State.entityData[u219];
            local v221 = v220 and v220.activeObserverMemberships[id];

            if v221 then
                return State.entityToReference[u219] or u219, State.zoneIdToZoneObj[v221];
            end;
        end;

        return nil;
    end;
end;

function u16.iterPlayersInside(p222) -- Line: 1491
    -- upvalues: State (copy)
    local u223 = State.observerTrackingEntities[p222.id] or {};
    local u224 = nil;
    local id = p222.id;

    return function() -- Line: 1496
        -- upvalues: u224 (ref), u223 (copy), State (ref), id (copy)
        while true do
            u224 = next(u223, u224);

            if not u224 then
                break;
            end;

            local v225 = State.entityData[u224];
            local v226 = v225 and v225.activeObserverMemberships[id];

            if v226 then
                local v227 = State.entityToReference[u224] or u224;

                if typeof(v227) == "Instance" and v227:IsA("Player") then
                    return v227, State.zoneIdToZoneObj[v226];
                end;
            end;
        end;

        return nil, nil;
    end;
end;

function u16.iterEntitiesInZone(p228, p229) -- Line: 1530
    -- upvalues: State (copy)
    local u230 = State.observerTrackingEntities[p228.id];

    if not u230 then
        return function() -- Line: 1533
            return nil;
        end;
    end;

    local u231 = nil;
    local u232 = p229:getId();
    local id = p228.id;

    return function() -- Line: 1542
        -- upvalues: u231 (ref), u230 (copy), State (ref), id (copy), u232 (copy)
        while true do
            u231 = next(u230, u231);

            if not u231 then
                break;
            end;

            local v233 = State.entityData[u231];

            if v233 and v233.activeObserverMemberships[id] == u232 then
                return State.entityToReference[u231] or u231;
            end;
        end;

        return nil;
    end;
end;

function u16.iterPlayersInZone(p234, p235) -- Line: 1569
    -- upvalues: State (copy)
    local u236 = State.observerTrackingEntities[p234.id];

    if not u236 then
        return function() -- Line: 1572
            return nil;
        end;
    end;

    local u237 = nil;
    local u238 = p235:getId();
    local id = p234.id;

    return function() -- Line: 1581
        -- upvalues: u237 (ref), u236 (copy), State (ref), id (copy), u238 (copy)
        while true do
            u237 = next(u236, u237);

            if not u237 then
                break;
            end;

            local v239 = State.entityData[u237];

            if v239 and v239.activeObserverMemberships[id] == u238 then
                local v240 = State.entityToReference[u237] or u237;

                if typeof(v240) == "Instance" and v240:IsA("Player") then
                    return v240;
                end;
            end;
        end;

        return nil;
    end;
end;

function u16.onDestroy(u241, u242) -- Line: 1617
    if not u241.onDestroyCallbacks then
        u241.onDestroyCallbacks = {};
    end;

    table.insert(u241.onDestroyCallbacks, u242);

    return function() -- Line: 1624
        -- upvalues: u241 (copy), u242 (copy)
        local v243 = table.find(u241.onDestroyCallbacks, u242);

        if v243 then
            table.remove(u241.onDestroyCallbacks, v243);
        end;
    end;
end;

function u16.destroy(p244) -- Line: 1639
    -- upvalues: State (copy), u1 (copy), u2 (copy)
    if p244.onDestroyCallbacks then
        for _, v in p244.onDestroyCallbacks do
            task.spawn(v);
        end;

        table.clear(p244.onDestroyCallbacks);
    end;

    p244:setEnabled(false);
    local id = p244.id;

    for _, v in State.groupToObservers do
        v[id] = nil;
    end;

    for _, v in State.zoneAttachedObservers do
        local v245 = table.find(v, id);

        if v245 then
            local v246 = #v;

            if v245 ~= v246 then
                v[v245] = v[v246];
            end;

            v[v246] = nil;
        end;
    end;

    State.observerPriorityMap[id] = nil;
    State.observerEnteredCallbacks[id] = nil;
    State.observerExitedCallbacks[id] = nil;
    State.observerTransitionedCallbacks[id] = nil;
    State.observerTrackingEntities[id] = nil;
    State.observerIdToObserverObj[id] = nil;
    State.observerEnabled[id] = nil;
    State.observerSafety[id] = nil;
    State.observerUpdateRate[id] = nil;
    State.observerPrecisionSq[id] = nil;
    State.observerStaticCount[id] = nil;
    State.observerDynamicCount[id] = nil;
    u1[id] = nil;
    u2[id] = nil;
    local v247 = State;
    v247.logicVersion = v247.logicVersion + 1;
    setmetatable(p244, nil);
end;

return u16;