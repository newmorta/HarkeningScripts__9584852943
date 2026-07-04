-- Ruta Original: ReplicatedStorage.Utilities.QuickZone.Core.State
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return {
    nextZoneId = 1,
    nextObserverId = 1,
    nextGroupId = 1,
    staticCFrames = {},
    staticHalfSizes = {},
    staticTypes = {},
    dynamicCFrames = {},
    dynamicHalfSizes = {},
    dynamicTypes = {},
    staticTree = {
        count = 0,
        nodes = {}
    },
    dynamicTree = {
        count = 0,
        nodes = {}
    },
    pendingStaticRebuild = false,
    pendingDynamicRebuild = false,
    staticVersion = 0,
    dynamicVersion = 0,
    logicVersion = 0,
    groups = {},
    groupToObservers = {},
    groupEntityCleanups = {},
    entityToGroups = {},
    entityData = {},
    entityToObservers = {},
    entityToReference = setmetatable({}, {
        __mode = "kv"
    }),
    referenceToEntity = setmetatable({}, {
        __mode = "kv"
    }),
    dirtyProfiles = {},
    dirtyTopology = {},
    bucketList = {},
    buckets = {},
    observerTrackingEntities = {},
    observerPriorityMap = {},
    observerEnteredCallbacks = {},
    observerExitedCallbacks = {},
    observerTransitionedCallbacks = {},
    observerEnabled = {},
    observerSafety = {},
    observerUpdateRate = {},
    observerPrecisionSq = {},
    observerDynamicCount = {},
    observerStaticCount = {},
    autoSyncZones = {},
    zoneAttachedObservers = {},
    zoneIdToZoneObj = {},
    observerIdToObserverObj = {}
};