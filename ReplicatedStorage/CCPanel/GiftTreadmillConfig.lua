-- Ruta Original: ReplicatedStorage.CCPanel.GiftTreadmillConfig
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local v1 = { {
        tag = "GoldTreadmill",
        dataKey = "ManualGoldAccess",
        label = "Gold Treadmill",
        periodSeconds = 1209600,
        defaultQuota = 0
    }, {
        tag = "DiamondTreadmill",
        dataKey = "ManualDiamondAccess",
        label = "Diamond Treadmill",
        periodSeconds = 1209600,
        defaultQuota = 1
    }, {
        tag = "CandyTreadmill",
        dataKey = "ManualCandyAccess",
        label = "Candy Treadmill",
        periodSeconds = 1209600,
        defaultQuota = 0
    } };
local v2 = {};

for _, v in v1 do
    v2[v.tag] = v;
end;

return {
    TREADMILLS = v1,
    BY_TAG = v2
};