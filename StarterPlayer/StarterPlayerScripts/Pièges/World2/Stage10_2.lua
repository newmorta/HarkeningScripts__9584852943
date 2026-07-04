-- Ruta Original: StarterPlayer.StarterPlayerScripts.Pièges.World2.Stage10_2
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local u1 = {};

local function buildCache(p2) -- Line: 20
    local v3 = {
        Parts = {},
        Texts = {}
    };

    for _, descendant in ipairs(p2:GetDescendants()) do
        if descendant:IsA("BasePart") then
            table.insert(v3.Parts, {
                Instance = descendant,
                OrigTransparency = descendant.Transparency,
                OrigCanCollide = descendant.CanCollide
            });
        elseif descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            table.insert(v3.Texts, {
                Instance = descendant,
                OrigTransparency = descendant.TextTransparency
            });
        end;
    end;

    return v3;
end;

local function applyFade(p4, p5) -- Line: 41
    for _, v in ipairs(p4.Parts) do
        v.Instance.Transparency = v.OrigTransparency + p5 * (1 - v.OrigTransparency);
    end;

    for _, v in ipairs(p4.Texts) do
        v.Instance.TextTransparency = v.OrigTransparency + p5 * (1 - v.OrigTransparency);
    end;
end;

local function setCollision(p6, p7) -- Line: 50
    for _, v in ipairs(p6.Parts) do
        if v.OrigCanCollide then
            v.Instance.CanCollide = p7;
        end;
    end;
end;

local function restoreOriginal(p8) -- Line: 58
    for _, v in ipairs(p8.Parts) do
        v.Instance.Transparency = v.OrigTransparency;
        v.Instance.CanCollide = v.OrigCanCollide;
    end;

    for _, v in ipairs(p8.Texts) do
        v.Instance.TextTransparency = v.OrigTransparency;
    end;
end;

local function triggerBridge(p9) -- Line: 68
    -- upvalues: u1 (copy), buildCache (copy), applyFade (copy), restoreOriginal (copy)
    if u1[p9] then
        return;
    end;

    u1[p9] = true;
    local v10 = buildCache(p9);

    for i = 1, 30 do
        applyFade(v10, i / 30);
        task.wait(0.06666666666666667);
    end;

    applyFade(v10, 1);

    for _, v in ipairs(v10.Parts) do
        if v.OrigCanCollide then
            v.Instance.CanCollide = false;
        end;
    end;

    task.wait(1);

    for i = 30, 0, -1 do
        applyFade(v10, i / 30);
        task.wait(0.03333333333333333);
    end;

    restoreOriginal(v10);
    u1[p9] = nil;
end;

local function connectTouch(u11) -- Line: 99
    -- upvalues: LocalPlayer (copy), triggerBridge (copy)
    for _, descendant in ipairs(u11:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Touched:Connect(function(p12) -- Line: 102
                -- upvalues: LocalPlayer (ref), triggerBridge (ref), u11 (copy)
                if not p12.Parent then
                    return;
                end;

                local Character = LocalPlayer.Character;

                if Character and p12.Parent == Character then
                    triggerBridge(u11);
                end;
            end);
        end;
    end;
end;

local function setupModel(p13) -- Line: 113
    -- upvalues: connectTouch (copy)
    if not p13:IsA("Model") then
        return;
    end;

    connectTouch(p13);
end;

for _, v in ipairs(CollectionService:GetTagged("Stage10Bridge2")) do
    if v:IsA("Model") then
        connectTouch(v);
    end;
end;

CollectionService:GetInstanceAddedSignal("Stage10Bridge2"):Connect(setupModel);