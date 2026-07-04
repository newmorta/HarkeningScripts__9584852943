-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.WinStreakClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local WinStreakUpdate = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("WinStreakUpdate", 15);

if not WinStreakUpdate then
    return;
end;

local function getTaggedElement(p1) -- Line: 20
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged(p1)) do
        if v:IsDescendantOf(PlayerGui) then
            return v;
        end;
    end;

    return nil;
end;

local u2 = {
    [10] = Color3.fromRGB(255, 255, 255),
    [20] = Color3.fromRGB(170, 255, 170),
    [30] = Color3.fromRGB(85, 255, 85),
    [40] = Color3.fromRGB(0, 255, 0),
    [50] = Color3.fromRGB(200, 255, 0),
    [60] = Color3.fromRGB(255, 255, 0),
    [70] = Color3.fromRGB(255, 200, 0),
    [80] = Color3.fromRGB(255, 140, 0),
    [90] = Color3.fromRGB(255, 80, 0),
    [100] = Color3.fromRGB(255, 30, 30)
};

local function getStreakColor(p3) -- Line: 46
    -- upvalues: u2 (copy)
    for _, v in ipairs({ 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 }) do
        if p3 <= v then
            return u2[v];
        end;
    end;

    return u2[100];
end;

local u4 = nil;

local function animateBounce(p5) -- Line: 63
    -- upvalues: u4 (ref), TweenService (copy)
    if not p5 then
        return;
    end;

    local v6 = p5:FindFirstChildWhichIsA("UIScale");

    if not v6 then
        v6 = Instance.new("UIScale");
        v6.Parent = p5;
    end;

    if u4 then
        u4:Cancel();
    end;

    v6.Scale = 1;
    local v7 = TweenService:Create(v6, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1.25
    });
    local u8 = TweenService:Create(v6, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Scale = 1
    });
    v7:Play();
    v7.Completed:Once(function() -- Line: 84
        -- upvalues: u8 (copy), u4 (ref)
        u8:Play();
        u4 = u8;
    end);
    u4 = v7;
end;

local function animateTextPunch(p9) -- Line: 91
    -- upvalues: TweenService (copy)
    if not p9 then
        return;
    end;

    local v10 = p9:FindFirstChildWhichIsA("UIScale");

    if not v10 then
        v10 = Instance.new("UIScale");
        v10.Parent = p9;
    end;

    v10.Scale = 1.4;
    TweenService:Create(v10, TweenInfo.new(0.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play();
end;

local function showFrame(p11) -- Line: 105
    -- upvalues: TweenService (copy)
    if not p11 then
        return;
    end;

    if p11.Visible then
        return;
    end;

    p11.Visible = true;
    local v12 = p11:FindFirstChildWhichIsA("UIScale");

    if not v12 then
        v12 = Instance.new("UIScale");
        v12.Parent = p11;
    end;

    v12.Scale = 0.5;
    TweenService:Create(v12, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play();
end;

local function hideFrame(u13) -- Line: 122
    -- upvalues: TweenService (copy)
    if not u13 then
        return;
    end;

    if not u13.Visible then
        return;
    end;

    local v14 = u13:FindFirstChildWhichIsA("UIScale");

    if not v14 then
        u13.Visible = false;

        return;
    end;

    local v15 = TweenService:Create(v14, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Scale = 0.5
    });
    v15:Play();
    v15.Completed:Once(function() -- Line: 130
        -- upvalues: u13 (copy)
        u13.Visible = false;
    end);
end;

WinStreakUpdate.OnClientEvent:Connect(function(p16) -- Line: 142
    -- upvalues: getTaggedElement (copy), hideFrame (copy), showFrame (copy), getStreakColor (copy), animateTextPunch (copy), animateBounce (copy)
    local v17 = getTaggedElement("WinStrikeFrame");
    local v18 = getTaggedElement("WinStrikeMultiplier");

    if not p16 or p16 <= 0 then
        hideFrame(v17);

        return;
    end;

    if v17 and not v17.Visible then
        showFrame(v17);
    end;

    if v18 then
        v18.Text = "+" .. tostring(p16) .. "% Wins";
        v18.TextColor3 = getStreakColor(p16);
        animateTextPunch(v18);
    end;

    animateBounce(v17);
end);