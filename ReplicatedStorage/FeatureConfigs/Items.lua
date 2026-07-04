-- Ruta Original: ReplicatedStorage.FeatureConfigs.Items
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {
    ITEMS = {
        ChocoBar = {
            name = "Choco Bar",
            multiplier = 0.03,
            rarity = "Common",
            icon = "rbxassetid://83707728604228"
        },
        StrawberryDonut = {
            name = "Strawberry Donut",
            multiplier = 0.03,
            rarity = "Common",
            icon = "rbxassetid://128512272946347"
        },
        CaramelBow = {
            name = "Caramel Bow",
            multiplier = 0.03,
            rarity = "Common",
            icon = "rbxassetid://106469124996927"
        },
        ChocolatePretzel = {
            name = "Chocolate Pretzel",
            multiplier = 0.03,
            rarity = "Common",
            icon = "rbxassetid://119909846998032"
        },
        MuffinHat = {
            name = "Muffin Hat",
            multiplier = 0.05,
            rarity = "Uncommon",
            icon = "rbxassetid://79719009938160"
        },
        CandyGlasses = {
            name = "Candy Glasses",
            multiplier = 0.05,
            rarity = "Uncommon",
            icon = "rbxassetid://85359360299288"
        },
        CupcakeMic = {
            name = "Cupcake Mic",
            multiplier = 0.05,
            rarity = "Uncommon",
            icon = "rbxassetid://128503145976233"
        },
        PinkHeartLollipop = {
            name = "Pink Heart Lollipop",
            multiplier = 0.05,
            rarity = "Uncommon",
            icon = "rbxassetid://85295132522638"
        },
        MarshmallowHelmet = {
            name = "Marshmallow Helmet",
            multiplier = 0.1,
            rarity = "Rare",
            icon = "rbxassetid://80245687171677"
        },
        CookieBag = {
            name = "Cookie Bag",
            multiplier = 0.1,
            rarity = "Rare",
            icon = "rbxassetid://139504376531887"
        },
        StrawberryMilkshake = {
            name = "Strawberry Milkshake",
            multiplier = 0.1,
            rarity = "Rare",
            icon = "rbxassetid://98847820818459"
        },
        PinkGummyBear = {
            name = "Pink Gummy Bear",
            multiplier = 0.1,
            rarity = "Rare",
            icon = "rbxassetid://140237835092604"
        },
        CaramelScooter = {
            name = "Caramel Scooter",
            multiplier = 0.15,
            rarity = "Epic",
            icon = "rbxassetid://101061924588501"
        },
        ChocolateGuitar = {
            name = "Chocolate Guitar",
            multiplier = 0.15,
            rarity = "Epic",
            icon = "rbxassetid://128282102586831"
        },
        DonutShield = {
            name = "Donut Shield",
            multiplier = 0.15,
            rarity = "Epic",
            icon = "rbxassetid://118519530332359"
        },
        WhiteChocolateIceCream = {
            name = "White Chocolate Ice Cream",
            multiplier = 0.15,
            rarity = "Epic",
            icon = "rbxassetid://133121645063925"
        },
        CandyCaneSword = {
            name = "Candy Cane Sword",
            multiplier = 0.25,
            rarity = "Legendary",
            icon = "rbxassetid://70623031207656"
        },
        ChocolateKart = {
            name = "Chocolate Kart",
            multiplier = 0.25,
            rarity = "Legendary",
            icon = "rbxassetid://126379720590319"
        },
        CandyWings = {
            name = "Candy Wings",
            multiplier = 0.25,
            rarity = "Legendary",
            icon = "rbxassetid://78731100327570"
        },
        CandyCrown = {
            name = "Candy Crown",
            multiplier = 0.5,
            rarity = "Mythic",
            icon = "rbxassetid://121997245505981"
        },
        GoldenMask = {
            name = "Golden Mask",
            multiplier = 1,
            rarity = "Secret",
            icon = "rbxassetid://129287120641819"
        }
    },
    RARITY_COLORS = {
        Common = Color3.fromRGB(229, 229, 229),
        Uncommon = Color3.fromRGB(73, 141, 63),
        Rare = Color3.fromRGB(24, 123, 209),
        Epic = Color3.fromRGB(115, 17, 186),
        Legendary = Color3.fromRGB(211, 175, 43),
        Mythic = Color3.fromRGB(255, 100, 200),
        Secret = Color3.fromRGB(255, 255, 255)
    },
    MAX_EQUIPPED_DEFAULT = 10,
    MAX_EQUIPPED_GAMEPASS = 20,
    EXTRA_SLOTS_GAMEPASS_ID = 1852734975
};

function u1.GetTotalMultiplier(p2) -- Line: 182
    -- upvalues: u1 (copy)
    local v3 = 0;

    for _, v in ipairs(p2) do
        local v4 = u1.ITEMS[v];

        if v4 then
            v3 = v3 + v4.multiplier;
        end;
    end;

    return v3 + 1;
end;

function u1.GetTotalBonusPercent(p5) -- Line: 194
    -- upvalues: u1 (copy)
    local v6 = 0;

    for _, v in ipairs(p5) do
        local v7 = u1.ITEMS[v];

        if v7 then
            v6 = v6 + v7.multiplier;
        end;
    end;

    return math.floor(v6 * 100 + 0.5);
end;

u1.RARITY_PRIORITY = {
    Secret = 0,
    Mythic = 1,
    Legendary = 2,
    Epic = 3,
    Rare = 4,
    Uncommon = 5,
    Common = 6
};

function u1.SortByBest(p8) -- Line: 217
    -- upvalues: u1 (copy)
    local v9 = {};

    for _, v in ipairs(p8) do
        table.insert(v9, v);
    end;

    table.sort(v9, function(p10, p11) -- Line: 222
        -- upvalues: u1 (ref)
        local v12 = u1.ITEMS[p10];
        local v13 = u1.ITEMS[p11];
        local v14 = u1.RARITY_PRIORITY[v12 and (v12.rarity or "Common") or "Common"] or 6;
        local v15 = u1.RARITY_PRIORITY[v13 and (v13.rarity or "Common") or "Common"] or 6;

        if v14 == v15 then
            return (v12 and v12.multiplier or 0) > (v13 and v13.multiplier or 0);
        end;

        return v14 < v15;
    end);

    return v9;
end;

function u1.GetItemsByRarity(p16) -- Line: 238
    -- upvalues: u1 (copy)
    local v17 = {};

    for i, v in pairs(u1.ITEMS) do
        if v.rarity == p16 then
            table.insert(v17, i);
        end;
    end;

    return v17;
end;

return u1;