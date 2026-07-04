-- Ruta Original: ReplicatedStorage.FeatureConfigs.GiftConfig
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Items = require(script.Parent:WaitForChild("Items"));
local GAMEPASS_IDS = require(ReplicatedStorage.Config.Shared.GameplayDefaults).GAMEPASS_IDS;
local v1 = {
    TREADMILL_GIFTS = {
        Gold = {
            DevProductId = 3600201213,
            Name = "Gold Treadmill",
            Image = "rbxassetid://125292754706588",
            ActivateKey = "GoldTreadmillActive",
            ManualKey = "ManualGoldAccess",
            Category = "Treadmill",
            GamepassId = GAMEPASS_IDS.GOLD_ACCESS
        },
        Diamond = {
            DevProductId = 3600201427,
            Name = "Diamond Treadmill",
            Image = "rbxassetid://113120316768005",
            ActivateKey = "DiamondTreadmillActive",
            ManualKey = "ManualDiamondAccess",
            Category = "Treadmill",
            GamepassId = GAMEPASS_IDS.DIAMOND_ACCESS
        },
        Candy = {
            DevProductId = 3600200549,
            Name = "Candy Treadmill",
            Image = "rbxassetid://92767808101132",
            ActivateKey = "CandyTreadmillActive",
            ManualKey = "ManualCandyAccess",
            Category = "Treadmill",
            GamepassId = GAMEPASS_IDS.CANDY_ACCESS
        },
        Admin = {
            DevProductId = 3600200986,
            Name = "Admin Treadmill",
            Image = "rbxassetid://94137693106401",
            ActivateKey = "AdminTreadmillActive",
            ManualKey = "ManualAdminAccess",
            Category = "Treadmill",
            GamepassId = GAMEPASS_IDS.ADMIN_ACCESS
        }
    },
    TRAIL_GIFTS = {
        GreenTrail = {
            DevProductId = 3603980009,
            Name = "Green Trail",
            Image = "rbxassetid://116315544877519",
            Category = "Trail"
        },
        BlueTrail = {
            DevProductId = 3603979549,
            Name = "Blue Trail",
            Image = "rbxassetid://72675186287041",
            Category = "Trail"
        },
        PurpleTrail = {
            DevProductId = 3603980209,
            Name = "Purple Trail",
            Image = "rbxassetid://126782245837521",
            Category = "Trail"
        },
        RedTrail = {
            DevProductId = 3603980399,
            Name = "Red Trail",
            Image = "rbxassetid://131298799241304",
            Category = "Trail"
        },
        RainbowTrail = {
            DevProductId = 3603980305,
            Name = "Rainbow Trail",
            Image = "rbxassetid://132750347496620",
            Category = "Trail"
        },
        GalaxyTrail = {
            DevProductId = 3603979789,
            Name = "Galaxy Trail",
            Image = "rbxassetid://74943114716072",
            Category = "Trail"
        },
        CosmicTrail = {
            DevProductId = 3603979681,
            Name = "Cosmic Trail",
            Image = "rbxassetid://129213243546149",
            Category = "Trail"
        },
        VoidTrail = {
            DevProductId = 3603980604,
            Name = "Void Trail",
            Image = "rbxassetid://139930714433891",
            Category = "Trail"
        },
        SupernovaTrail = {
            DevProductId = 3603980539,
            Name = "Supernova Trail",
            Image = "rbxassetid://82185160246144",
            Category = "Trail"
        },
        GodlikeTrail = {
            DevProductId = 3603979901,
            Name = "Godlike Trail",
            Image = "rbxassetid://92114716678863",
            Category = "Trail"
        },
        InfinityTrail = {
            DevProductId = 3603980117,
            Name = "Infinity Trail",
            Image = "rbxassetid://73598304145234",
            Category = "Trail"
        }
    },
    AURA_GIFTS = {
        FireAura = {
            DevProductId = 3603978890,
            Name = "Fire Aura",
            Image = "rbxassetid://79901429526247",
            Category = "Aura"
        },
        WaterAura = {
            DevProductId = 3603979004,
            Name = "Water Aura",
            Image = "rbxassetid://93367062665094",
            Category = "Aura"
        },
        WindAura = {
            DevProductId = 3603979162,
            Name = "Wind Aura",
            Image = "rbxassetid://100794940939749",
            Category = "Aura"
        },
        GlowAura = {
            DevProductId = 3603979319,
            Name = "Glow Aura",
            Image = "rbxassetid://96628369089363",
            Category = "Aura"
        },
        ElectricAura = {
            DevProductId = 3605481509,
            Name = "Electric Aura",
            Image = "rbxassetid://88995860425004",
            Category = "Aura"
        }
    },
    ITEM_GIFT_PRODUCTS = {
        Common = 3603994101,
        Uncommon = 3603994050,
        Rare = 3603993993,
        Epic = 3603993915,
        Legendary = 3603993857,
        Mythic = 3603993797,
        Secret = 3603994195
    },
    ALL_GIFTS = {}
};

for i, v in pairs(v1.TREADMILL_GIFTS) do
    v1.ALL_GIFTS[i] = v;
end;

for i, v in pairs(v1.TRAIL_GIFTS) do
    v1.ALL_GIFTS[i] = v;
end;

for i, v in pairs(v1.AURA_GIFTS) do
    v1.ALL_GIFTS[i] = v;
end;

for i, v in pairs(Items.ITEMS) do
    local rarity = v.rarity;
    local v2 = v1.ITEM_GIFT_PRODUCTS[rarity];

    if v2 then
        v1.ALL_GIFTS[i] = {
            Category = "Item",
            DevProductId = v2,
            Name = v.name,
            Image = v.icon,
            Rarity = rarity
        };
    end;
end;

v1.PRODUCT_TO_GIFT = {};

for i, v in pairs(v1.TREADMILL_GIFTS) do
    v1.PRODUCT_TO_GIFT[v.DevProductId] = {
        Category = "Treadmill",
        Type = i,
        GamepassId = v.GamepassId,
        Name = v.Name,
        ActivateKey = v.ActivateKey,
        ManualKey = v.ManualKey
    };
end;

for i, v in pairs(v1.TRAIL_GIFTS) do
    v1.PRODUCT_TO_GIFT[v.DevProductId] = {
        Category = "Trail",
        Type = i,
        Name = v.Name
    };
end;

for i, v in pairs(v1.AURA_GIFTS) do
    v1.PRODUCT_TO_GIFT[v.DevProductId] = {
        Category = "Aura",
        Type = i,
        Name = v.Name
    };
end;

for i, v in pairs(v1.ITEM_GIFT_PRODUCTS) do
    v1.PRODUCT_TO_GIFT[v] = {
        Category = "Item",
        Rarity = i
    };
end;

return v1;