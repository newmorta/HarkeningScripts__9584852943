-- Ruta Original: ReplicatedStorage.Config.Worlds.World3
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

return {
    WORLD = 3,
    WORLD_MULTIPLIER = 10,
    DEFAULT_WALKSPEED = 60,
    SPEED_GAIN_PER_LEVEL = 0.2,
    SECURITY = {
        MAX_SPEED_ALLOWED = 300,
        DISTANCE_MARGIN = 2,
        TELEPORT_COOLDOWN = 0.5,
        STATION_MARGIN = 20
    },
    SPEED_FORMULA = {
        FLAT_BELOW_LEVEL = 400
    },
    ENTRY = {
        LEVEL = 400,
        REDIRECT_WORLD_INDEX = 2
    },
    FEATURES = {
        CHECKPOINTS = false
    },
    DISPLAY = {
        COLOR = Color3.fromRGB(180, 90, 255)
    },
    PROGRESSION = {
        WIN_BLOCK_FIRST = 32,
        WIN_BLOCK_LAST = 37,
        CHECKPOINT_SEGMENT_START = 32,
        STEP_AWARD_SKIP = 8
    },
    STAGE_RECOMMENDED_LEVELS = {
        [2] = 480,
        [3] = 520,
        [4] = 580,
        [5] = 620,
        [6] = 650
    },
    CHECKPOINTS = {},
    SkipCheckpoints = {}
};