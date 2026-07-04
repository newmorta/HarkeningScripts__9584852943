-- Ruta Original: ReplicatedStorage.FeatureConfigs.ItemsRefund
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {
    INDIVIDUAL_REFUNDS = {},
    RARITY_REFUNDS = {
        Common = 47000,
        Uncommon = 975000,
        Rare = 49750000,
        Epic = 496500000,
        Legendary = 960000000,
        Mythic = 2650000000
    },
    REFUNDS_NAME_PRODUCT = {
        ["Common Item (Shop)"] = 47000,
        ["Uncommon Item (Shop)"] = 975000,
        ["Rare Item (Shop)"] = 49750000,
        ["Epic Item (Shop)"] = 496500000,
        ["Legendary Item (Shop)"] = 960000000,
        ["Mythic Item (Shop)"] = 2650000000
    }
};

function u1.GetRefundAmount(p2, p3) -- Line: 34
    -- upvalues: u1 (copy)
    return not u1.INDIVIDUAL_REFUNDS[p2] and (u1.RARITY_REFUNDS[p3] or 0) or u1.INDIVIDUAL_REFUNDS[p2];
end;

return u1;