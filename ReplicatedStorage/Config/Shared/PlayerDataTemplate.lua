-- Ruta Original: ReplicatedStorage.Config.Shared.PlayerDataTemplate
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");

return {
    TotalXP = 0,
    Level = 1,
    XP = 0,
    Wins = 0,
    Rebirths = 0,
    Multiplier = 1,
    StepBonus = 1,
    CustomWalkSpeed = 0,
    GiftClaimed = false,
    ManualGoldAccess = false,
    ManualDiamondAccess = false,
    ManualCandyAccess = false,
    ManualAdminAccess = false,
    GamepassReceived = {},
    GiftSent = {},
    GiftReceived = {},
    OwnedTrails = {},
    EquippedTrail = "None",
    OwnedAuras = {},
    EquippedAura = "None",
    Items = {},
    EquippedItems = {},
    ItemsShopState = {
        cycle = 0,
        override = false,
        rerolls = 0,
        purchases = {}
    },
    OwnedTreadmillSkins = {},
    EquippedTreadmillSkin = "Default",
    PersonalTreadmillWasActive = false,
    firstJoin = 0,
    timePlayed = 0,
    Checkpoint = 0,
    PurchaseHistory = {},
    TikfinityBinds = {},
    SpeedBoostTier = 0,
    EventRsvpClaimed = {},
    SocialCodeClaimed = false,
    SocialResetAppliedAt = 0,
    CheatHistory = {},
    CheatHistory2 = {},
    VIP_ID = false,
    X2Boost = false,
    CCPermissions = require(ReplicatedStorage.CCPanel.CCPermissionsTemplate),
    RefundedItems = false,
    MedalRewardClaimed = false,
    AfkPosition = false,
    CheckInfinityTrailGlitch = false,
    CheckInfinityTrailGlitch2 = false,
    SeenNewBadgeGroups = {}
};