-- Ruta Original: ReplicatedStorage.NotificationSystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local Config = require(ReplicatedStorage:WaitForChild("Config"));
local SoundManager = require(ReplicatedStorage:WaitForChild("SoundManager"));
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local Numbers = require(ReplicatedStorage.Utilities.Numbers);
local AuraConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("AuraConfig"));
local Items = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("Items"));
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local v1 = {};
local u2 = nil;

local function getMainGUI(p3) -- Line: 22
    -- upvalues: u2 (ref), CollectionService (copy), PlayerGui (copy)
    if u2 and u2.Parent then
        return u2;
    end;

    local v4 = p3 or 0;

    for _ = 0, v4 do
        local v5 = CollectionService:GetTagged("MainGUI");

        for _, v in ipairs(v5) do
            if v:IsDescendantOf(PlayerGui) then
                u2 = v;

                return v;
            end;
        end;

        if v4 > 0 then
            task.wait(0.2);
        end;
    end;

    return nil;
end;

local function formatXP(p6) -- Line: 40
    -- upvalues: Numbers (copy)
    return Numbers.formatNumber(p6);
end;

local function formatWinNotificationText(p7) -- Line: 44
    -- upvalues: Numbers (copy)
    return "+" .. Numbers.formatNumber(p7) .. " " .. (p7 == 1 and "Win" or "Wins") .. "!";
end;

function v1.ShowMessage(p8, p9, p10) -- Line: 53
    -- upvalues: getMainGUI (copy), TweenService (copy), Config (copy)
    local v11 = getMainGUI();

    if not v11 then
        return;
    end;

    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "CenterMessage";
    TextLabel.Size = UDim2.new(0.6, 0, 0.06, 0);
    TextLabel.Position = UDim2.new(0.5, 0, 0.35, 0);
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = p9;
    TextLabel.TextColor3 = p10 or Color3.fromRGB(255, 255, 255);
    TextLabel.TextScaled = true;
    TextLabel.Font = Enum.Font.GothamBlack;
    TextLabel.Parent = v11;
    Instance.new("UITextSizeConstraint", TextLabel).MaxTextSize = 35;
    local UIStroke = Instance.new("UIStroke", TextLabel);
    UIStroke.Color = Color3.fromRGB(0, 0, 0);
    UIStroke.Thickness = 2.5;
    local UIScale = Instance.new("UIScale", TextLabel);
    UIScale.Scale = 0.7;
    TweenService:Create(UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play();
    TweenService:Create(TextLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.3, 0)
    }):Play();
    task.delay(Config.DURATIONS.MESSAGE or 2, function() -- Line: 89
        -- upvalues: TweenService (ref), TextLabel (copy), UIStroke (copy)
        local v12 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
        TweenService:Create(TextLabel, v12, {
            TextTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.25, 0)
        }):Play();
        TweenService:Create(UIStroke, v12, {
            Transparency = 1
        }):Play();
        task.delay(0.5, function() -- Line: 96
            -- upvalues: TextLabel (ref)
            TextLabel:Destroy();
        end);
    end);
end;

function v1.ShowLevelUp(p13, p14, p15) -- Line: 104
    -- upvalues: getMainGUI (copy), SoundManager (copy), TweenService (copy), Config (copy)
    local v16 = getMainGUI(10);

    if not v16 then
        return;
    end;

    SoundManager:Play("LEVEL_UP");
    local Frame = Instance.new("Frame");
    Frame.Name = "LevelUpNotification";
    Frame.Size = UDim2.new(0.6, 0, 0.2, 0);
    Frame.Position = UDim2.new(0.5, 0, 0.45, 0);
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Parent = v16;
    local UIListLayout = Instance.new("UIListLayout", Frame);
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.05, 0);
    local UIScale = Instance.new("UIScale", Frame);
    UIScale.Scale = 0;
    local TextLabel = Instance.new("TextLabel", Frame);
    TextLabel.Size = UDim2.new(1, 0, 0.4, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = "🎉 LEVEL UP! 🎉";
    TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0);
    TextLabel.TextScaled = true;
    TextLabel.Font = Enum.Font.GothamBlack;
    Instance.new("UIStroke", TextLabel).Thickness = 4;
    local TextLabel2 = Instance.new("TextLabel", Frame);
    TextLabel2.Size = UDim2.new(1, 0, 0.3, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.Text = "Level " .. p15;
    TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel2.TextScaled = true;
    TextLabel2.Font = Enum.Font.GothamBold;
    Instance.new("UIStroke", TextLabel2).Thickness = 3;
    TweenService:Create(UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play();
    TweenService:Create(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.4, 0)
    }):Play();
    task.delay(Config.DURATIONS.LEVEL_UP or 2.5, function() -- Line: 149
        -- upvalues: TweenService (ref), Frame (copy), UIScale (copy)
        TweenService:Create(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, 0.3, 0)
        }):Play();
        TweenService:Create(UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Scale = 0
        }):Play();
        local v17 = TweenInfo.new(0.5);

        for _, descendant in pairs(Frame:GetDescendants()) do
            if descendant:IsA("TextLabel") then
                TweenService:Create(descendant, v17, {
                    TextTransparency = 1
                }):Play();
            elseif descendant:IsA("UIStroke") then
                TweenService:Create(descendant, v17, {
                    Transparency = 1
                }):Play();
            end;
        end;

        task.wait(0.6);
        Frame:Destroy();
    end);
end;

function v1.ShowPlusOne(p18, p19, p20, p21, p22, p23, p24) -- Line: 167
    -- upvalues: LocalPlayer (copy), ClientState (copy), AuraConfig (copy), Items (copy), PlayerGui (copy), Numbers (copy), TweenService (copy)
    local Character = LocalPlayer.Character;

    if not (Character and Character:FindFirstChild("HumanoidRootPart")) then
        return;
    end;

    local HumanoidRootPart = Character.HumanoidRootPart;
    local v25 = p23 or 1;
    local v26 = p22 or 1;
    local v27 = p24 or 1;
    local v28 = ClientState:Get();
    local v29 = v28.EquippedAura or "None";
    local v30 = AuraConfig.AURAS[v29] and AuraConfig.AURAS[v29].multiplier or 1;
    local v31 = Items.GetTotalMultiplier(v28.EquippedItems or {});
    local v32 = v28.X2BoostExpiresAt and os.time() < v28.X2BoostExpiresAt and 2 or 1;
    local v33 = 1 + (v28.FriendBoostPercent or 0) / 100;
    local v34 = LocalPlayer:GetAttribute("RELICSxyz_OwnsBoombox") and 2 or 1;
    local BillboardGui = Instance.new("BillboardGui", PlayerGui);
    BillboardGui.Name = "PlusOne";
    BillboardGui.Size = UDim2.new(4.5, 0, 1.5, 0);
    BillboardGui.StudsOffset = Vector3.new(0, 1, 0);
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.Adornee = HumanoidRootPart;
    local Frame = Instance.new("Frame", BillboardGui);
    Frame.Size = UDim2.new(0, 0, 0, 0);
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    local UIListLayout = Instance.new("UIListLayout", Frame);
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.05, 0);
    local ImageLabel = Instance.new("ImageLabel", Frame);
    ImageLabel.Size = UDim2.new(0.3, 0, 0.8, 0);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://16408406294";
    Instance.new("UIAspectRatioConstraint", ImageLabel).AspectRatio = 1;
    local TextLabel = Instance.new("TextLabel", Frame);
    TextLabel.Size = UDim2.new(0.6, 0, 0.9, 0);
    TextLabel.BackgroundTransparency = 1;
    local v35 = Color3.fromRGB(255, 227, 178);

    if v25 >= 100 then
        v35 = Color3.fromRGB(255, 0, 0);
    elseif v25 >= 25 then
        v35 = Color3.fromRGB(255, 67, 199);
    elseif v25 >= 9 then
        v35 = Color3.fromRGB(0, 255, 255);
    elseif v25 > 1 then
        v35 = Color3.fromRGB(255, 238, 0);
    elseif p21 and p21 > 1 then
        v35 = Color3.fromRGB(255, 125, 65);
    elseif v27 > 1 then
        v35 = Color3.fromRGB(200, 80, 255);
    elseif v26 * v30 > 1 then
        v35 = Color3.fromRGB(0, 220, 110);
    end;

    TextLabel.TextColor3 = v35;
    TextLabel.Text = "+" .. Numbers.formatNumber(p19 * p20 * (p21 or 1) * v26 * v30 * v25 * v27 * v31 * v32 * v33 * v34);
    TextLabel.TextScaled = true;
    TextLabel.Font = Enum.Font.GothamBlack;
    local UIStroke = Instance.new("UIStroke", TextLabel);
    UIStroke.Thickness = 2;
    local v36 = math.random(-4, 4);
    local v37 = math.random(3, 5);
    local u38 = Vector3.new(v36, v37, math.random(-2, 2));
    TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 1, 0)
    }):Play();
    TweenService:Create(BillboardGui, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        StudsOffset = u38
    }):Play();
    task.delay(0.5, function() -- Line: 260
        -- upvalues: TweenService (ref), TextLabel (copy), ImageLabel (copy), UIStroke (copy), BillboardGui (copy), u38 (copy)
        local v39 = TweenInfo.new(0.3);
        TweenService:Create(TextLabel, v39, {
            TextTransparency = 1
        }):Play();
        TweenService:Create(ImageLabel, v39, {
            ImageTransparency = 1
        }):Play();
        TweenService:Create(UIStroke, v39, {
            Transparency = 1
        }):Play();
        TweenService:Create(BillboardGui, v39, {
            StudsOffset = u38 + Vector3.new(0, -1, 0)
        }):Play();
        task.delay(0.35, function() -- Line: 266
            -- upvalues: BillboardGui (ref)
            BillboardGui:Destroy();
        end);
    end);
end;

function v1.ShowWinNotification(p40, p41) -- Line: 274
    -- upvalues: getMainGUI (copy), SoundManager (copy), Numbers (copy), TweenService (copy), Config (copy)
    local v42 = getMainGUI(10);

    if not v42 then
        return;
    end;

    local v43 = tonumber(p41) or 1;
    SoundManager:Play("WIN");
    local Frame = Instance.new("Frame", v42);
    Frame.Name = "WinNotification";
    Frame.Size = UDim2.new(0.5, 0, 0.12, 0);
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    local UIListLayout = Instance.new("UIListLayout", Frame);
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.02, 0);
    local UIScale = Instance.new("UIScale", Frame);
    UIScale.Scale = 0;
    local ImageLabel = Instance.new("ImageLabel", Frame);
    ImageLabel.Size = UDim2.new(0.15, 0, 0.9, 0);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://15540211845";
    ImageLabel.Rotation = -20;
    Instance.new("UIAspectRatioConstraint", ImageLabel);
    local TextLabel = Instance.new("TextLabel", Frame);
    TextLabel.AutomaticSize = Enum.AutomaticSize.X;
    TextLabel.Size = UDim2.new(0, 0, 0.8, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = "+" .. Numbers.formatNumber(v43) .. " " .. (v43 == 1 and "Win" or "Wins") .. "!";
    TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0);
    TextLabel.TextScaled = true;
    TextLabel.Font = Enum.Font.GothamBlack;
    local UIStroke = Instance.new("UIStroke", TextLabel);
    UIStroke.Thickness = 3;
    TweenService:Create(UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play();
    TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.4, 0)
    }):Play();
    TweenService:Create(ImageLabel, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Rotation = 0
    }):Play();
    task.delay(Config.DURATIONS.WIN or 2, function() -- Line: 322
        -- upvalues: TweenService (ref), Frame (copy), UIScale (copy), TextLabel (copy), ImageLabel (copy), UIStroke (copy)
        TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, 0.3, 0)
        }):Play();
        TweenService:Create(UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Scale = 0
        }):Play();
        local v44 = TweenInfo.new(0.4);
        TweenService:Create(TextLabel, v44, {
            TextTransparency = 1
        }):Play();
        TweenService:Create(ImageLabel, v44, {
            ImageTransparency = 1
        }):Play();
        TweenService:Create(UIStroke, v44, {
            Transparency = 1
        }):Play();
        task.wait(0.5);
        Frame:Destroy();
    end);
end;

function v1.ShowRebirth(p45, p46) -- Line: 339
    -- upvalues: getMainGUI (copy), SoundManager (copy), TweenService (copy)
    local v47 = getMainGUI(10);

    if not v47 then
        return;
    end;

    SoundManager:Play("REBIRTH");
    local Frame = Instance.new("Frame");
    Frame.Name = "RebirthNotification";
    Frame.Size = UDim2.new(0.6, 0, 0.2, 0);
    Frame.Position = UDim2.new(0.5, 0, 0.45, 0);
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Parent = v47;
    local UIListLayout = Instance.new("UIListLayout", Frame);
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.05, 0);
    local UIScale = Instance.new("UIScale", Frame);
    UIScale.Scale = 0;
    local TextLabel = Instance.new("TextLabel", Frame);
    TextLabel.Size = UDim2.new(1, 0, 0.4, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = "🌀 NEW REBIRTH! 🌀";
    TextLabel.TextColor3 = Color3.fromRGB(0, 255, 255);
    TextLabel.TextScaled = true;
    TextLabel.Font = Enum.Font.GothamBlack;
    local UIStroke = Instance.new("UIStroke", TextLabel);
    UIStroke.Thickness = 4;
    UIStroke.Color = Color3.fromRGB(0, 50, 100);
    local TextLabel2 = Instance.new("TextLabel", Frame);
    TextLabel2.Size = UDim2.new(1, 0, 0.3, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.Text = "Rebirth #" .. p46;
    TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel2.TextScaled = true;
    TextLabel2.Font = Enum.Font.GothamBold;
    Instance.new("UIStroke", TextLabel2).Thickness = 3;
    TweenService:Create(UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play();
    TweenService:Create(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.4, 0)
    }):Play();
    task.delay(3, function() -- Line: 390
        -- upvalues: TweenService (ref), Frame (copy), UIScale (copy)
        TweenService:Create(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, 0.3, 0)
        }):Play();
        TweenService:Create(UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Scale = 0
        }):Play();
        local v48 = TweenInfo.new(0.5);

        for _, descendant in pairs(Frame:GetDescendants()) do
            if descendant:IsA("TextLabel") then
                TweenService:Create(descendant, v48, {
                    TextTransparency = 1
                }):Play();
            elseif descendant:IsA("UIStroke") then
                TweenService:Create(descendant, v48, {
                    Transparency = 1
                }):Play();
            end;
        end;

        task.wait(0.6);
        Frame:Destroy();
    end);
end;

function v1.ShowCurrencyCollect(p49, p50, p51, p52, p53) -- Line: 406
    -- upvalues: LocalPlayer (copy), PlayerGui (copy), TweenService (copy)
    local Character = LocalPlayer.Character;

    if not (Character and Character:FindFirstChild("HumanoidRootPart")) then
        return;
    end;

    local HumanoidRootPart = Character.HumanoidRootPart;
    local v54 = p53 == 1 and Color3.fromRGB(255, 247, 0) or Color3.fromRGB(238, 0, 255);
    local BillboardGui = Instance.new("BillboardGui", PlayerGui);
    BillboardGui.Name = "CurrencyCollect";
    BillboardGui.Size = UDim2.new(8, 0, 2.2, 0);
    BillboardGui.StudsOffset = Vector3.new(0, 1, 0);
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.Adornee = HumanoidRootPart;
    local Frame = Instance.new("Frame", BillboardGui);
    Frame.Size = UDim2.new(0, 0, 0, 0);
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    local UIListLayout = Instance.new("UIListLayout", Frame);
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.05, 0);
    local ImageLabel = Instance.new("ImageLabel", Frame);
    ImageLabel.Size = UDim2.new(0.3, 0, 0.8, 0);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://" .. tostring(p50 or 0);
    Instance.new("UIAspectRatioConstraint", ImageLabel).AspectRatio = 1;
    local TextLabel = Instance.new("TextLabel", Frame);
    TextLabel.Size = UDim2.new(0.65, 0, 0.9, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = "+" .. tostring(p52 or 1) .. " " .. tostring(p51 or "");
    TextLabel.TextColor3 = v54;
    TextLabel.TextScaled = true;
    TextLabel.Font = Enum.Font.GothamBlack;
    local UIStroke = Instance.new("UIStroke", TextLabel);
    UIStroke.Thickness = 2;
    local v55 = math.random(-4, 4);
    local v56 = math.random(3, 5);
    local u57 = Vector3.new(v55, v56, math.random(-2, 2));
    TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 1, 0)
    }):Play();
    TweenService:Create(BillboardGui, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        StudsOffset = u57
    }):Play();
    task.delay(1.8, function() -- Line: 459
        -- upvalues: TweenService (ref), TextLabel (copy), ImageLabel (copy), UIStroke (copy), BillboardGui (copy), u57 (copy)
        local v58 = TweenInfo.new(0.45);
        TweenService:Create(TextLabel, v58, {
            TextTransparency = 1
        }):Play();
        TweenService:Create(ImageLabel, v58, {
            ImageTransparency = 1
        }):Play();
        TweenService:Create(UIStroke, v58, {
            Transparency = 1
        }):Play();
        TweenService:Create(BillboardGui, v58, {
            StudsOffset = u57 + Vector3.new(0, -1, 0)
        }):Play();
        task.delay(0.5, function() -- Line: 465
            -- upvalues: BillboardGui (ref)
            BillboardGui:Destroy();
        end);
    end);
end;

function v1.ShowBossHit(p59) -- Line: 473
    -- upvalues: getMainGUI (copy), SoundManager (copy), TweenService (copy)
    local v60 = getMainGUI(10);

    if not v60 then
        return;
    end;

    SoundManager:Play("BOSS_HIT");
    local Frame = Instance.new("Frame", v60);
    Frame.Name = "BossHitNotification";
    Frame.Size = UDim2.new(0.5, 0, 0.08, 0);
    Frame.Position = UDim2.new(0.5, 0, 0.12, 0);
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundTransparency = 1;
    local UIScale = Instance.new("UIScale", Frame);
    UIScale.Scale = 0;
    local TextLabel = Instance.new("TextLabel", Frame);
    TextLabel.Size = UDim2.new(1, 0, 1, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = "[BOSS] -100 HP 💥";
    TextLabel.TextColor3 = Color3.fromRGB(255, 30, 30);
    TextLabel.TextScaled = true;
    TextLabel.Font = Enum.Font.GothamBlack;
    local UIStroke = Instance.new("UIStroke", TextLabel);
    UIStroke.Thickness = 3;
    UIStroke.Color = Color3.fromRGB(80, 0, 0);
    TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1.2
    }):Play();
    task.delay(0.3, function() -- Line: 502
        -- upvalues: TweenService (ref), UIScale (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Scale = 1
        }):Play();
    end);
    task.spawn(function() -- Line: 507
        -- upvalues: TweenService (ref), Frame (copy)
        for _ = 1, 4 do
            local v61 = math.random(-8, 8);
            TweenService:Create(Frame, TweenInfo.new(0.05), {
                Position = UDim2.new(0.5, v61, 0.12, 0)
            }):Play();
            task.wait(0.05);
        end;

        TweenService:Create(Frame, TweenInfo.new(0.05), {
            Position = UDim2.new(0.5, 0, 0.12, 0)
        }):Play();
    end);
    task.delay(1.5, function() -- Line: 517
        -- upvalues: TweenService (ref), UIScale (copy), TextLabel (copy), UIStroke (copy), Frame (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Scale = 0
        }):Play();
        TweenService:Create(TextLabel, TweenInfo.new(0.4), {
            TextTransparency = 1
        }):Play();
        TweenService:Create(UIStroke, TweenInfo.new(0.4), {
            Transparency = 1
        }):Play();
        task.wait(0.5);
        Frame:Destroy();
    end);
end;

function v1.ShowGeneralNotification(p62, p63, p64, p65) -- Line: 532
    -- upvalues: ReplicatedStorage (copy), PlayerGui (copy), TweenService (copy)
    local GeneralNotificationFrame = ReplicatedStorage:FindFirstChild("GeneralNotificationFrame");

    if not GeneralNotificationFrame then
        warn("[NotificationSystem] GeneralNotificationFrame introuvable dans ReplicatedStorage");

        return;
    end;

    local GeneralNotificationGui = PlayerGui:FindFirstChild("GeneralNotificationGui");

    if not GeneralNotificationGui then
        warn("[NotificationSystem] GeneralNotificationGui introuvable dans PlayerGui");

        return;
    end;

    local MainFrame = GeneralNotificationGui:FindFirstChild("MainFrame");

    if not MainFrame then
        warn("[NotificationSystem] MainFrame introuvable dans GeneralNotificationGui");

        return;
    end;

    local u66 = GeneralNotificationFrame:Clone();
    local Text = u66:FindFirstChild("Text");

    if Text then
        Text.Text = p63;

        if p64 then
            Text.TextColor3 = p64;
        end;

        if p63:find("Secret Black Key") or p64 and p64.R + p64.G + p64.B < 0.5 then
            local v67 = Text:FindFirstChildWhichIsA("UIStroke");

            if not v67 then
                v67 = Instance.new("UIStroke");
                v67.Thickness = 1;
                v67.Parent = Text;
            end;

            v67.Color = Color3.fromRGB(255, 255, 255);
        end;
    end;

    u66.Parent = MainFrame;
    local u68 = u66:FindFirstChildWhichIsA("UIScale") or Instance.new("UIScale", u66);
    u68.Scale = 0;
    TweenService:Create(u68, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play();
    task.delay(p65 or 4, function() -- Line: 584
        -- upvalues: u66 (copy), TweenService (ref), u68 (ref)
        if not u66.Parent then
            return;
        end;

        TweenService:Create(u68, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Scale = 0
        }):Play();
        task.wait(0.4);

        if u66.Parent then
            u66:Destroy();
        end;
    end);
end;

return v1;