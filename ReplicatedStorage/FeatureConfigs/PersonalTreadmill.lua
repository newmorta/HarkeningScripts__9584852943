-- Ruta Original: ReplicatedStorage.FeatureConfigs.PersonalTreadmill
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

return {
    TIER_MULT = {
        Normal = 1,
        Gold = 3,
        Diamond = 9,
        Candy = 25,
        Admin = 100
    },
    TIER_ORDER = { "Admin", "Candy", "Diamond", "Gold" },
    WORKSPACE_FOLDER = "PersonalTreadmills",
    DESPAWN_RADIUS = 6,
    STEP_DISTANCE = 5,
    OVERLAP_PROBE_SIZE = Vector3.new(4, 12, 4),
    MONITOR_INTERVAL = 0.2,
    DEFAULT_SKIN = "Default"
};