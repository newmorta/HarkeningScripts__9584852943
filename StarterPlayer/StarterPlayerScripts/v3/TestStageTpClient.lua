-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.TestStageTpClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

if not require(ReplicatedStorage:WaitForChild("Config"):WaitForChild("GeneralConfig")):IsTestPlace() then
    return;
end;

local Icon = require(ReplicatedStorage:WaitForChild("TopbarPlus"):WaitForChild("Icon"));
local TestStageTpRemotes = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("TestStageTpRemotes"));
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "TestStageTpGui";
ScreenGui.ResetOnSpawn = false;
ScreenGui.IgnoreGuiInset = true;
ScreenGui.Enabled = false;
ScreenGui.DisplayOrder = 50;
ScreenGui.Parent = PlayerGui;
local Frame = Instance.new("Frame");
Frame.Name = "Panel";
Frame.Active = true;
Frame.AnchorPoint = Vector2.new(0.5, 0.5);
Frame.Position = UDim2.fromScale(0.5, 0.5);
Frame.Size = UDim2.fromOffset(260, 360);
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30);
Frame.BorderSizePixel = 0;
Frame.Parent = ScreenGui;
local UICorner = Instance.new("UICorner");
UICorner.CornerRadius = UDim.new(0, 10);
UICorner.Parent = Frame;
Instance.new("UIDragDetector").Parent = Frame;
local TextLabel = Instance.new("TextLabel");
TextLabel.Name = "Title";
TextLabel.Size = UDim2.new(1, 0, 0, 40);
TextLabel.BackgroundTransparency = 1;
TextLabel.Text = "Stage TP (TestPlace)";
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
TextLabel.Font = Enum.Font.GothamBold;
TextLabel.TextSize = 18;
TextLabel.Parent = Frame;
local ScrollingFrame = Instance.new("ScrollingFrame");
ScrollingFrame.Name = "List";
ScrollingFrame.Position = UDim2.fromOffset(10, 48);
ScrollingFrame.Size = UDim2.new(1, -20, 1, -58);
ScrollingFrame.BackgroundTransparency = 1;
ScrollingFrame.BorderSizePixel = 0;
ScrollingFrame.ScrollBarThickness = 6;
ScrollingFrame.CanvasSize = UDim2.new();
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
ScrollingFrame.Parent = Frame;
local UIListLayout = Instance.new("UIListLayout");
UIListLayout.Padding = UDim.new(0, 6);
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
UIListLayout.Parent = ScrollingFrame;

local function makeButton(u1) -- Line: 77
    -- upvalues: ScrollingFrame (copy), TestStageTpRemotes (copy)
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Stage" .. u1;
    TextButton.Size = UDim2.new(1, -6, 0, 36);
    TextButton.BackgroundColor3 = Color3.fromRGB(45, 120, 220);
    TextButton.AutoButtonColor = true;
    TextButton.Text = "Stage " .. u1;
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextButton.Font = Enum.Font.GothamSemibold;
    TextButton.TextSize = 16;
    TextButton.LayoutOrder = u1;
    TextButton.Parent = ScrollingFrame;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(0, 6);
    UICorner2.Parent = TextButton;
    TextButton.MouseButton1Click:Connect(function() -- Line: 94
        -- upvalues: TestStageTpRemotes (ref), u1 (copy)
        TestStageTpRemotes.TeleportToStage:fire(u1);
    end);
end;

local function rebuild() -- Line: 100
    -- upvalues: TestStageTpRemotes (copy), ScrollingFrame (copy), makeButton (copy)
    local success, result = pcall(function() -- Line: 101
        -- upvalues: TestStageTpRemotes (ref)
        return TestStageTpRemotes.GetStages:request():expect();
    end);

    if not success or type(result) ~= "table" then
        return;
    end;

    for _, child in ipairs(ScrollingFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy();
        end;
    end;

    for _, v in ipairs(result) do
        makeButton(v);
    end;
end;

local v2 = Icon.new():setName("StageTP"):setLabel("Stage TP"):setImage("rbxassetid://6034509993");
v2.selected:Connect(function() -- Line: 125
    -- upvalues: rebuild (copy), ScreenGui (copy)
    rebuild();
    ScreenGui.Enabled = true;
end);
v2.deselected:Connect(function() -- Line: 130
    -- upvalues: ScreenGui (copy)
    ScreenGui.Enabled = false;
end);