-- Ruta Original: StarterPlayer.StarterPlayerScripts.DataViewerClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local DataViewerAction = ReplicatedStorage:WaitForChild("DataViewerAction");
local u1 = {
    {
        Name = "Stats",
        Color = Color3.fromRGB(80, 180, 255),
        Keys = { "Level", "XP", "TotalXP", "Wins", "Rebirths", "Multiplier", "StepBonus", "SpeedBoostTier", "CustomWalkSpeed", "Checkpoint" }
    },
    {
        Name = "Time",
        Color = Color3.fromRGB(100, 255, 150),
        Keys = { "firstJoin", "timePlayed", "SocialCodeClaimed", "SocialResetAppliedAt", "MedalRewardClaimed", "CheckInfinityTrailGlitch" }
    },
    {
        Name = "Access",
        Color = Color3.fromRGB(255, 200, 80),
        Keys = { "ManualGoldAccess", "ManualDiamondAccess", "ManualCandyAccess", "ManualAdminAccess", "VIP_ID", "X2Boost", "GiftClaimed" }
    },
    {
        Name = "Trails",
        Color = Color3.fromRGB(200, 130, 255),
        Keys = { "EquippedTrail", "OwnedTrails", "EquippedAura", "OwnedAuras" }
    },
    {
        Name = "Items",
        Color = Color3.fromRGB(255, 150, 100),
        Keys = { "Items", "EquippedItems" }
    },
    {
        Name = "Gifts",
        Color = Color3.fromRGB(255, 130, 180),
        Keys = { "GiftSent", "GiftReceived", "GamepassReceived" }
    },
    {
        Name = "History",
        Color = Color3.fromRGB(255, 80, 80),
        Keys = { "CheatHistory", "CheatHistory2", "PurchaseHistory" }
    },
    {
        Name = "Other",
        Color = Color3.fromRGB(180, 180, 180),
        Keys = { "TikfinityBinds", "EventRsvpClaimed", "CCPermissions", "RefundedItems", "AfkPosition" }
    }
};
local u2 = { { 1e18, "Qi" }, { 1000000000000000, "Qa" }, { 1000000000000, "T" }, { 1000000000, "B" }, { 1000000, "M" }, { 1000, "K" } };

local function formatNum(p3) -- Line: 42
    -- upvalues: u2 (copy)
    if type(p3) ~= "number" then
        return tostring(p3);
    end;

    for _, v in ipairs(u2) do
        if math.abs(p3) >= v[1] then
            return string.format("%.2f", p3 / v[1]):gsub("%.?0+$", "") .. v[2];
        end;
    end;

    local v4 = math.floor(p3 * 100) / 100;

    return tostring(v4);
end;

local function formatTime(p5) -- Line: 52
    if type(p5) ~= "number" or p5 <= 0 then
        return "0s";
    end;

    local v6 = math.floor(p5 / 86400);
    local v7 = math.floor(p5 % 86400 / 3600);
    local v8 = math.floor(p5 % 3600 / 60);
    local v9 = math.floor(p5 % 60);

    if v6 > 0 then
        return string.format("%dj %dh %02dm", v6, v7, v8);
    end;

    return string.format("%dh %02dm %02ds", v7, v8, v9);
end;

local function formatDate(p10) -- Line: 62
    return (type(p10) ~= "number" or p10 <= 0) and "N/A" or os.date("%d/%m/%Y %H:%M", p10);
end;

local function formatValue(p11, p12) -- Line: 67
    -- upvalues: formatTime (copy), formatDate (copy), formatNum (copy)
    if p11 == "timePlayed" then
        return formatTime(p12);
    end;

    if p11 == "firstJoin" and (type(p12) == "number" and p12 > 0) then
        return formatDate(p12);
    end;

    if p11 == "SocialResetAppliedAt" and (type(p12) == "number" and p12 > 0) then
        return formatDate(p12);
    end;

    if (p11 == "TotalXP" or p11 == "Wins") and type(p12) == "number" then
        return formatNum(p12) .. "  (" .. tostring(p12) .. ")";
    end;

    if type(p12) == "boolean" then
        return tostring(p12);
    end;

    if type(p12) == "number" then
        return tostring(p12);
    end;

    if type(p12) == "string" then
        return p12;
    end;

    return tostring(p12);
end;

local function buildLines(p13, p14, p15, p16) -- Line: 80
    -- upvalues: buildLines (copy), formatValue (copy)
    local v17 = p15 or 0;
    local v18 = p16 or {};
    local v19 = string.rep("    ", v17);

    if type(p14) ~= "table" then
        local v20 = {
            Text = v19 .. tostring(p13) .. " : " .. formatValue(p13, p14),
            Depth = v17
        };
        table.insert(v18, v20);

        return v18;
    end;

    if next(p14) == nil then
        local v21 = {
            Text = v19 .. tostring(p13) .. " : (vide)",
            Depth = v17
        };
        table.insert(v18, v21);

        return v18;
    end;

    local v22 = {
        IsHeader = true,
        Text = v19 .. tostring(p13) .. " :",
        Depth = v17
    };
    table.insert(v18, v22);
    local v23 = {};

    for i in pairs(p14) do
        table.insert(v23, i);
    end;

    table.sort(v23, function(p24, p25) -- Line: 93
        return tostring(p24) < tostring(p25);
    end);

    for _, v in ipairs(v23) do
        if v17 < 3 then
            buildLines(v, p14[v], v17 + 1, v18);
        else
            local v26 = {
                Text = v19 .. "    " .. tostring(v) .. " : " .. tostring(p14[v]),
                Depth = v17 + 1
            };
            table.insert(v18, v26);
        end;
    end;

    return v18;
end;

local u27 = nil;

local function destroyExisting() -- Line: 115
    -- upvalues: PlayerGui (copy)
    local DataViewerPanel = PlayerGui:FindFirstChild("DataViewerPanel");

    if DataViewerPanel then
        DataViewerPanel:Destroy();
    end;
end;

local function createEntry(p28, p29, p30, p31, p32) -- Line: 120
    local TextLabel = Instance.new("TextLabel", p28);
    TextLabel.Size = UDim2.new(1, -10, 0, 22);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.Font = p31 and Enum.Font.GothamBold or Enum.Font.Gotham;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextScaled = true;
    TextLabel.RichText = true;
    Instance.new("UITextSizeConstraint", TextLabel).MaxTextSize = 12;

    if p31 and p30 == 0 then
        TextLabel.TextColor3 = p32 or Color3.fromRGB(255, 215, 0);
        TextLabel.Text = p29;
        TextLabel.Size = UDim2.new(1, -10, 0, 26);

        return TextLabel;
    end;

    if p31 then
        TextLabel.TextColor3 = Color3.fromRGB(200, 200, 220);
        TextLabel.Text = p29;

        return TextLabel;
    end;

    TextLabel.TextColor3 = Color3.fromRGB(170, 170, 185);
    TextLabel.Text = p29;

    return TextLabel;
end;

local function populateCategory(p33, p34, p35) -- Line: 146
    -- upvalues: u1 (copy), buildLines (copy), createEntry (copy)
    for _, child in ipairs(p33:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("Frame") then
            child:Destroy();
        end;
    end;

    local v36 = u1[p35];

    if not v36 then
        return;
    end;

    local v37 = 0;

    for _, v in ipairs(v36.Keys) do
        local v38 = p34[v];
        local v39 = buildLines(v, v38 == nil and "nil" or v38, 0);

        for _, v2 in ipairs(v39) do
            local v40 = createEntry(p33, v2.Text, v2.Depth, v2.IsHeader, v36.Color);
            v37 = v37 + 1;
            v40.LayoutOrder = v37;
        end;

        local Frame = Instance.new("Frame", p33);
        Frame.Name = "Sep";
        Frame.Size = UDim2.new(1, -20, 0, 1);
        Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55);
        Frame.BorderSizePixel = 0;
        v37 = v37 + 1;
        Frame.LayoutOrder = v37;
    end;
end;

local function buildGUI(u41) -- Line: 179
    -- upvalues: PlayerGui (copy), u27 (ref), u1 (copy), populateCategory (copy)
    local DataViewerPanel = PlayerGui:FindFirstChild("DataViewerPanel");

    if DataViewerPanel then
        DataViewerPanel:Destroy();
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "DataViewerPanel";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.DisplayOrder = 125;
    ScreenGui.Parent = PlayerGui;
    local Frame = Instance.new("Frame", ScreenGui);
    Frame.Name = "Background";
    Frame.Size = UDim2.new(1, 0, 1, 0);
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    Frame.BackgroundTransparency = 0.4;
    Frame.BorderSizePixel = 0;
    local Frame2 = Instance.new("Frame", Frame);
    Frame2.Name = "Panel";
    Frame2.Size = UDim2.new(0, 520, 0, 620);
    Frame2.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.fromRGB(18, 18, 28);
    Frame2.BorderSizePixel = 0;
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 14);
    local v42 = u41.IsOnline and "  [EN LIGNE]" or "  [HORS LIGNE]";
    local v43 = u41.IsOnline and "#44FF44" or "#FF6666";
    local TextLabel = Instance.new("TextLabel", Frame2);
    TextLabel.Name = "Title";
    TextLabel.Size = UDim2.new(1, -50, 0, 22);
    TextLabel.Position = UDim2.new(0, 15, 0, 10);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.RichText = true;
    TextLabel.Text = string.format("<font color=\"#FFD700\"><b>DATA:</b></font> %s <font color=\"#AAAAAA\">(%d)</font><font color=\"%s\">%s</font>", u41.DisplayName, u41.UserId, v43, v42);
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel.TextScaled = true;
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    Instance.new("UITextSizeConstraint", TextLabel).MaxTextSize = 16;
    local TextButton = Instance.new("TextButton", Frame2);
    TextButton.Name = "CloseBtn";
    TextButton.Size = UDim2.new(0, 32, 0, 32);
    TextButton.Position = UDim2.new(1, -40, 0, 6);
    TextButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50);
    TextButton.Text = "X";
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextButton.TextScaled = true;
    TextButton.Font = Enum.Font.GothamBold;
    Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6);
    TextButton.MouseButton1Click:Connect(function() -- Line: 238
        -- upvalues: ScreenGui (copy)
        ScreenGui:Destroy();
    end);
    Frame.InputBegan:Connect(function(p44) -- Line: 243
        -- upvalues: Frame2 (copy), ScreenGui (copy)
        if p44.UserInputType == Enum.UserInputType.MouseButton1 or p44.UserInputType == Enum.UserInputType.Touch then
            local AbsolutePosition = Frame2.AbsolutePosition;
            local AbsoluteSize = Frame2.AbsoluteSize;
            local Position = p44.Position;

            if Position.X < AbsolutePosition.X or (Position.X > AbsolutePosition.X + AbsoluteSize.X or (Position.Y < AbsolutePosition.Y or Position.Y > AbsolutePosition.Y + AbsoluteSize.Y)) then
                ScreenGui:Destroy();
            end;
        end;
    end);
    local Frame3 = Instance.new("Frame", Frame2);
    Frame3.Name = "TabFrame";
    Frame3.Size = UDim2.new(1, -20, 0, 32);
    Frame3.Position = UDim2.new(0, 10, 0, 38);
    Frame3.BackgroundTransparency = 1;
    local UIListLayout = Instance.new("UIListLayout", Frame3);
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.Padding = UDim.new(0, 4);
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    local ScrollingFrame = Instance.new("ScrollingFrame", Frame2);
    ScrollingFrame.Name = "DataScroll";
    ScrollingFrame.Size = UDim2.new(1, -20, 1, -82);
    ScrollingFrame.Position = UDim2.new(0, 10, 0, 76);
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 20);
    ScrollingFrame.BackgroundTransparency = 0.3;
    ScrollingFrame.BorderSizePixel = 0;
    ScrollingFrame.ScrollBarThickness = 4;
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0);
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0);
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    Instance.new("UICorner", ScrollingFrame).CornerRadius = UDim.new(0, 8);
    local UIListLayout2 = Instance.new("UIListLayout", ScrollingFrame);
    UIListLayout2.Padding = UDim.new(0, 2);
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    local UIPadding = Instance.new("UIPadding", ScrollingFrame);
    UIPadding.PaddingTop = UDim.new(0, 6);
    UIPadding.PaddingBottom = UDim.new(0, 6);
    UIPadding.PaddingLeft = UDim.new(0, 8);
    local u45 = {};

    local function selectTab(p46) -- Line: 295
        -- upvalues: u27 (ref), u45 (copy), u1 (ref), populateCategory (ref), ScrollingFrame (copy), u41 (copy)
        u27 = p46;

        for i, v in ipairs(u45) do
            if i == p46 then
                v.BackgroundColor3 = u1[i].Color;
                v.TextColor3 = Color3.fromRGB(0, 0, 0);
            else
                v.BackgroundColor3 = Color3.fromRGB(40, 40, 55);
                v.TextColor3 = Color3.fromRGB(180, 180, 180);
            end;
        end;

        populateCategory(ScrollingFrame, u41.Data, p46);
    end;

    for i, v in ipairs(u1) do
        local TextButton2 = Instance.new("TextButton", Frame3);
        TextButton2.Name = "Tab_" .. i;
        TextButton2.Size = UDim2.new(0, 56, 0, 28);
        TextButton2.BackgroundColor3 = Color3.fromRGB(40, 40, 55);
        TextButton2.Text = v.Name;
        TextButton2.TextColor3 = Color3.fromRGB(180, 180, 180);
        TextButton2.TextScaled = true;
        TextButton2.Font = Enum.Font.GothamBold;
        TextButton2.AutoButtonColor = true;
        Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 6);
        Instance.new("UITextSizeConstraint", TextButton2).MaxTextSize = 11;
        TextButton2.MouseButton1Click:Connect(function() -- Line: 322
            -- upvalues: selectTab (copy), i (copy)
            selectTab(i);
        end);
        table.insert(u45, TextButton2);
    end;

    selectTab(1);
end;

DataViewerAction.OnClientEvent:Connect(function(p47) -- Line: 337
    -- upvalues: buildGUI (copy)
    if type(p47) ~= "table" then
        return;
    end;

    if p47.Action == "showData" then
        buildGUI(p47);
    end;
end);