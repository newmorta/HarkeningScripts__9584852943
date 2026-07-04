-- Ruta Original: ReplicatedStorage.Config.Shared.GameplayDefaults
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local v1 = {
    DEFAULT_DATA = require(script.Parent:WaitForChild("PlayerDataTemplate")),
    GROUP_ID = 1074557114,
    GIFT_REWARD = 15000,
    BADGE_IDS = {
        WELCOME = 1420201693079850,
        REBIRTH = 2153967300203954
    },
    USE_DEVPRODUCT_SPEED = false,
    SPEED_UPGRADES = { {
            Tier = 1,
            Multiplier = 2,
            ID = 1674499710,
            Price = 3,
            DevProductId = 0
        }, {
            Tier = 2,
            Multiplier = 4,
            ID = 1675776515,
            Price = 9,
            DevProductId = 0
        }, {
            Tier = 3,
            Multiplier = 8,
            ID = 1681102268,
            Price = 24,
            DevProductId = 0
        }, {
            Tier = 4,
            Multiplier = 16,
            ID = 1684020325,
            Price = 39,
            DevProductId = 0
        }, {
            Tier = 5,
            Multiplier = 32,
            ID = 1683754343,
            Price = 79,
            DevProductId = 0
        }, {
            Tier = 6,
            Multiplier = 64,
            ID = 1684176331,
            Price = 129,
            DevProductId = 0
        }, {
            Tier = 7,
            Multiplier = 128,
            ID = 1683446348,
            Price = 199,
            DevProductId = 0
        }, {
            Tier = 8,
            Multiplier = 256,
            ID = 1683918331,
            Price = 299,
            DevProductId = 0
        }, {
            Tier = 9,
            Multiplier = 512,
            ID = 1683374348,
            Price = 449,
            DevProductId = 0
        }, {
            Tier = 10,
            Multiplier = 1024,
            ID = 1682706361,
            Price = 649,
            DevProductId = 0
        }, {
            Tier = 11,
            Multiplier = 2048,
            ID = 1825333938,
            Price = 949,
            DevProductId = 0
        }, {
            Tier = 12,
            Multiplier = 4096,
            ID = 1827574761,
            Price = 1375,
            DevProductId = 0
        } },
    GAMEPASS_IDS = {
        WINS_X2 = 1675021026,
        GOLD_ACCESS = 1674743386,
        DIAMOND_ACCESS = 1724758929,
        CANDY_ACCESS = 1799448573,
        ADMIN_ACCESS = 1799430547,
        SOUNDPACK_ACCESS = 1724877043
    },
    DEV_PRODUCTS = {
        SPEED_150K = 3516546135,
        SPEED_1M = 3516546329,
        SPEED_10M = 3516546512,
        SPEED_50M = 3549331385,
        SPEED_500M = 3549331706,
        SPEED_1B = 3549331820,
        INSTANT_REBIRTH_T1 = 3523582310,
        INSTANT_REBIRTH_T2 = 3588524269,
        INSTANT_REBIRTH_T3 = 3588524394,
        INSTANT_REBIRTH_T4 = 3606745133,
        REVIVE = RunService:IsStudio() and 3591855647 or 3583707964
    }
};
v1.PERCENTAGE_SPEED_BOOSTS = {
    {
        Key = "Boost150K",
        Percent = 0.02,
        MinAmount = 150000,
        ProductId = v1.DEV_PRODUCTS.SPEED_150K
    },
    {
        Key = "Boost1M",
        Percent = 0.05,
        MinAmount = 1000000,
        ProductId = v1.DEV_PRODUCTS.SPEED_1M
    },
    {
        Key = "Boost10M",
        Percent = 0.12,
        MinAmount = 10000000,
        ProductId = v1.DEV_PRODUCTS.SPEED_10M
    },
    {
        Key = "Boost50M",
        Percent = 0.25,
        MinAmount = 50000000,
        ProductId = v1.DEV_PRODUCTS.SPEED_50M
    },
    {
        Key = "Boost500M",
        Percent = 0.6,
        MinAmount = 500000000,
        ProductId = v1.DEV_PRODUCTS.SPEED_500M
    },
    {
        Key = "Boost1B",
        Percent = 1.2,
        MinAmount = 1000000000,
        ProductId = v1.DEV_PRODUCTS.SPEED_1B
    }
};
v1.STEP_DISTANCE = 3;
v1.MAX_LEVEL_SPEED_CAP = 300;
v1.SPAWN_OFFSET = Vector3.new(0, 5, 0);
v1.TREADMILL_CHECK_INTERVAL = 0.15;
v1.TREADMILL_CHECK_RANGE = 2;
v1.TREADMILL_HEIGHT_RANGE = 5;
v1.BASE_XP = 100;
v1.XP_GROWTH = 1.15;
v1.XP_EXPONENT = 1.15;
v1.WORLD_MULTIPLIER = 1;
v1.REBIRTH_TIERS = { {
        level = 15,
        multiplier = 1.5
    }, {
        level = 25,
        multiplier = 2
    }, {
        level = 40,
        multiplier = 2.5
    }, {
        level = 60,
        multiplier = 3
    }, {
        level = 75,
        multiplier = 3.5
    }, {
        level = 100,
        multiplier = 4
    }, {
        level = 125,
        multiplier = 5
    }, {
        level = 150,
        multiplier = 10
    }, {
        level = 175,
        multiplier = 25
    }, {
        level = 200,
        multiplier = 75
    }, {
        level = 225,
        multiplier = 250
    }, {
        level = 260,
        multiplier = 1500
    }, {
        level = 300,
        multiplier = 15000
    }, {
        level = 340,
        multiplier = 200000
    }, {
        level = 380,
        multiplier = 3000000
    }, {
        level = 420,
        multiplier = 25000000
    }, {
        level = 465,
        multiplier = 200000000
    }, {
        level = 510,
        multiplier = 1000000000
    }, {
        level = 560,
        multiplier = 6000000000
    }, {
        level = 600,
        multiplier = 36000000000
    }, {
        level = 650,
        multiplier = 216000000000
    }, {
        level = 700,
        multiplier = 1300000000000
    }, {
        level = 750,
        multiplier = 8000000000000
    }, {
        level = 800,
        multiplier = 50000000000000
    }, {
        level = 850,
        multiplier = 300000000000000
    } };
v1.BOSS_WIN_TIERS = { {
        maxLevel = 10,
        wins = 1
    }, {
        maxLevel = 20,
        wins = 10
    }, {
        maxLevel = 35,
        wins = 50
    }, {
        maxLevel = 55,
        wins = 500
    }, {
        maxLevel = 80,
        wins = 1000
    }, {
        maxLevel = 90,
        wins = 10000
    }, {
        maxLevel = 140,
        wins = 25000
    }, {
        maxLevel = 160,
        wins = 100000
    }, {
        maxLevel = 180,
        wins = 150000
    }, {
        maxLevel = 200,
        wins = 200000
    }, {
        maxLevel = 230,
        wins = 350000
    }, {
        maxLevel = 260,
        wins = 600000
    }, {
        maxLevel = 290,
        wins = 1000000
    }, {
        maxLevel = 320,
        wins = 1500000
    }, {
        maxLevel = 350,
        wins = 2000000
    }, {
        maxLevel = 380,
        wins = 3000000
    }, {
        maxLevel = 410,
        wins = 5000000
    }, {
        maxLevel = (1 / 0),
        wins = 8000000
    } };
v1.AUTO_SAVE_INTERVAL = 60;
v1.WIN_DEBOUNCE_DELAY = 3;
v1.SPECIAL_KEY = {
    NORMAL_INTERVAL = 300,
    EVENT_INTERVAL = 30,
    KEY_LIFETIME = 600,
    MAX_TOUCH_DISTANCE = 20,
    COLLECT_DEBOUNCE = 2
};
v1.ANIMATION_IDS = {
    RUN = "rbxassetid://180426354"
};
v1.SOUNDS = {
    WIN = {
        ID = "rbxassetid://136993031050456",
        Volume = 0.5
    },
    REBIRTH = {
        ID = "rbxassetid://112485797063762",
        Volume = 0.6
    },
    COLLECT = {
        ID = "rbxassetid://1289263994",
        Volume = 0.5
    },
    LEVEL_UP = {
        ID = "rbxassetid://3120909354",
        Volume = 0.3
    },
    HOVER = {
        ID = "rbxassetid://73982862253547",
        Volume = 0.6
    },
    CLICK = {
        ID = "rbxassetid://17481582653",
        Volume = 0.4
    },
    DEV_REBIRTH = {
        ID = "rbxassetid://3601621507",
        Volume = 0.7
    },
    BUY = {
        ID = "rbxassetid://133292918309565",
        Volume = 0.5
    },
    ERROR = {
        ID = "rbxassetid://87437544236708",
        Volume = 0.6
    },
    SUCCESS = {
        ID = "rbxassetid://136993031050456",
        Volume = 0.6
    },
    ERROR7 = {
        ID = "rbxassetid://133843340754810",
        Volume = 0.6
    },
    EFFECT1 = {
        ID = "rbxassetid://126805498637586",
        Volume = 0.6
    },
    NOTIF1 = {
        ID = "rbxassetid://122954374321453",
        Volume = 0.6
    },
    EFFECT2 = {
        ID = "rbxassetid://112124748378177",
        Volume = 0.6
    },
    BOSS_HIT = {
        ID = "rbxassetid://140462043853173",
        Volume = 0.7
    },
    SPECIAL_KEY_NOTIF = {
        ID = "rbxassetid://9125644905",
        Volume = 0.3
    }
};
v1.DURATIONS = {
    LEVEL_UP = 1,
    MESSAGE = 2,
    WIN = 1,
    MODAL_OPEN = 0.3,
    MODAL_CLOSE = 0.2,
    NOTIFICATION = 0.3,
    FADE_OUT = 0.5
};
v1.COLORS = {
    AWARD_EQUIPPED = BrickColor.new("New Yeller"),
    AWARD_DEFAULT = BrickColor.new("Lime green"),
    AWARD_LOCKED = BrickColor.new("Smoky grey")
};
v1.XP_TIME_BASED = {
    MIN_SPEED = 10,
    MAX_SPEED = 100,
    MIN_COOLDOWN = 0.1,
    MAX_COOLDOWN = 0.25
};

return v1;