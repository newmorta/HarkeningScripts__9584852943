-- Ruta Original: ReplicatedStorage.FeatureConfigs.AuraConfig
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

require(script.Parent.Auras.Types);
local Assets = script.Parent.Auras.Assets;

local function auraAttachment(p1) -- Line: 8
    -- upvalues: Assets (copy)
    return Assets:WaitForChild(p1):FindFirstChildWhichIsA("Attachment");
end;

local v2 = {};

for i, v in {
    GlowAura = {
        name = "GlowAura",
        multiplier = 1.2,
        price = 1000000,
        gamepass = 1841065578,
        full_body = true,
        icon = "rbxassetid://96628369089363",
        instance = Assets:WaitForChild("GlowAura"):FindFirstChildWhichIsA("Attachment"),
        color = Color3.fromRGB(183, 233, 255)
    },
    WindAura = {
        name = "WindAura",
        multiplier = 1.5,
        price = 5000000,
        gamepass = 1841089568,
        icon = "rbxassetid://100794940939749",
        instance = Assets:WaitForChild("WindAura"):FindFirstChildWhichIsA("Attachment"),
        color = Color3.fromRGB(104, 111, 149)
    },
    WaterAura = {
        name = "WaterAura",
        multiplier = 2,
        price = 10000000,
        gamepass = 1840979522,
        full_body = true,
        icon = "rbxassetid://93367062665094",
        instance = Assets:WaitForChild("WaterAura"):FindFirstChildWhichIsA("Attachment"),
        color = Color3.fromRGB(52, 167, 255)
    },
    MedalAura = {
        name = "MedalAura",
        multiplier = 2,
        full_body = true,
        icon = "rbxassetid://102463236218636",
        instance = Assets:WaitForChild("MedalAura"):FindFirstChildWhichIsA("Attachment"),
        color = Color3.fromRGB(143, 255, 52)
    },
    FireAura = {
        name = "FireAura",
        multiplier = 3,
        price = 25000000,
        gamepass = 1860376482,
        full_body = true,
        icon = "rbxassetid://79901429526247",
        instance = Assets:WaitForChild("FireAura"):FindFirstChildWhichIsA("Attachment"),
        color = Color3.fromRGB(168, 42, 0)
    },
    ElectricAura = {
        name = "ElectricAura",
        multiplier = 4,
        price = 50000000,
        gamepass = 1883044917,
        full_body = true,
        icon = "rbxassetid://88995860425004",
        instance = Assets:WaitForChild("ElectricAura"):FindFirstChildWhichIsA("Attachment"),
        color = Color3.fromRGB(255, 222, 34)
    }
} do
    if v.available ~= false then
        v2[i] = v;
    end;
end;

return {
    AURAS = v2
};