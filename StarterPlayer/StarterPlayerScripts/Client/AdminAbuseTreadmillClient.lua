-- Ruta Original: StarterPlayer.StarterPlayerScripts.Client.AdminAbuseTreadmillClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;

if LocalPlayer:GetAttribute("AdminAbuseTreadmillAdmin") == nil then
    LocalPlayer:GetAttributeChangedSignal("AdminAbuseTreadmillAdmin"):Wait();
end;

if LocalPlayer:GetAttribute("AdminAbuseTreadmillAdmin") ~= true then
    return;
end;

local Remotes = ReplicatedStorage:WaitForChild("AdminAbuseTreadmill"):WaitForChild("Remotes");
local TreadmillRequest = Remotes:WaitForChild("TreadmillRequest");
local TreadmillSync = Remotes:WaitForChild("TreadmillSync");
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "AdminAbuseTreadmillGui";
ScreenGui.ResetOnSpawn = false;
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
ScreenGui.DisplayOrder = 50;
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui");
local Frame = Instance.new("Frame");
Frame.Name = "Panel";
Frame.Size = UDim2.new(0, 230, 0, 130);
Frame.Position = UDim2.new(0, 24, 0.5, -65);
Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 33);
Frame.BorderSizePixel = 0;
Frame.Parent = ScreenGui;
local UICorner = Instance.new("UICorner");
UICorner.CornerRadius = UDim.new(0, 10);
UICorner.Parent = Frame;
local UIStroke = Instance.new("UIStroke");
UIStroke.Color = Color3.fromRGB(60, 60, 70);
UIStroke.Thickness = 1;
UIStroke.Parent = Frame;
local UIDragDetector = Instance.new("UIDragDetector");
UIDragDetector.DragStyle = Enum.UIDragDetectorDragStyle.TranslatePlane;
UIDragDetector.Parent = Frame;
local Frame2 = Instance.new("Frame");
Frame2.Name = "TitleBar";
Frame2.Size = UDim2.new(1, 0, 0, 34);
Frame2.Position = UDim2.new(0, 0, 0, 0);
Frame2.BackgroundColor3 = Color3.fromRGB(18, 18, 22);
Frame2.BorderSizePixel = 0;
Frame2.Parent = Frame;
local UICorner2 = Instance.new("UICorner");
UICorner2.CornerRadius = UDim.new(0, 10);
UICorner2.Parent = Frame2;
local Frame3 = Instance.new("Frame");
Frame3.Size = UDim2.new(1, 0, 0, 10);
Frame3.Position = UDim2.new(0, 0, 1, -10);
Frame3.BackgroundColor3 = Color3.fromRGB(18, 18, 22);
Frame3.BorderSizePixel = 0;
Frame3.Parent = Frame2;
local TextLabel = Instance.new("TextLabel");
TextLabel.Size = UDim2.new(1, -12, 1, 0);
TextLabel.Position = UDim2.new(0, 12, 0, 0);
TextLabel.BackgroundTransparency = 1;
TextLabel.Text = "AdminAbuse Treadmill";
TextLabel.TextColor3 = Color3.fromRGB(210, 210, 220);
TextLabel.TextSize = 13;
TextLabel.Font = Enum.Font.GothamBold;
TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
TextLabel.Parent = Frame2;
local TextLabel2 = Instance.new("TextLabel");
TextLabel2.Name = "Status";
TextLabel2.Size = UDim2.new(1, -20, 0, 26);
TextLabel2.Position = UDim2.new(0, 12, 0, 40);
TextLabel2.BackgroundTransparency = 1;
TextLabel2.Text = "● Inactif";
TextLabel2.TextColor3 = Color3.fromRGB(200, 75, 75);
TextLabel2.TextSize = 14;
TextLabel2.Font = Enum.Font.Gotham;
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
TextLabel2.Parent = Frame;
local TextButton = Instance.new("TextButton");
TextButton.Name = "StartBtn";
TextButton.Size = UDim2.new(0, 96, 0, 38);
TextButton.Position = UDim2.new(0, 12, 0, 76);
TextButton.BackgroundColor3 = Color3.fromRGB(48, 160, 78);
TextButton.BorderSizePixel = 0;
TextButton.Text = "Start";
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
TextButton.TextSize = 14;
TextButton.Font = Enum.Font.GothamBold;
TextButton.Parent = Frame;
local UICorner3 = Instance.new("UICorner");
UICorner3.CornerRadius = UDim.new(0, 7);
UICorner3.Parent = TextButton;
local TextButton2 = Instance.new("TextButton");
TextButton2.Name = "StopBtn";
TextButton2.Size = UDim2.new(0, 96, 0, 38);
TextButton2.Position = UDim2.new(0, 122, 0, 76);
TextButton2.BackgroundColor3 = Color3.fromRGB(200, 30, 30);
TextButton2.BorderSizePixel = 0;
TextButton2.Text = "STOP";
TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255);
TextButton2.TextSize = 14;
TextButton2.Font = Enum.Font.GothamBold;
TextButton2.AutoButtonColor = true;
TextButton2.Parent = Frame;
local UICorner4 = Instance.new("UICorner");
UICorner4.CornerRadius = UDim.new(0, 7);
UICorner4.Parent = TextButton2;
local UIStroke2 = Instance.new("UIStroke");
UIStroke2.Color = Color3.fromRGB(255, 80, 80);
UIStroke2.Thickness = 1;
UIStroke2.Parent = TextButton2;
local u1 = false;

local function updateUI(p2) -- Line: 138
    -- upvalues: u1 (ref), TextLabel2 (copy), TextButton (copy)
    u1 = p2;

    if p2 then
        TextLabel2.Text = "● Actif";
        TextLabel2.TextColor3 = Color3.fromRGB(72, 200, 100);
        TextButton.Active = false;
        TextButton.BackgroundColor3 = Color3.fromRGB(30, 90, 45);
        TextButton.TextColor3 = Color3.fromRGB(100, 130, 100);

        return;
    end;

    TextLabel2.Text = "● Inactif";
    TextLabel2.TextColor3 = Color3.fromRGB(200, 75, 75);
    TextButton.Active = true;
    TextButton.BackgroundColor3 = Color3.fromRGB(48, 160, 78);
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
end;

u1 = false;
TextLabel2.Text = "● Inactif";
TextLabel2.TextColor3 = Color3.fromRGB(200, 75, 75);
TextButton.Active = true;
TextButton.BackgroundColor3 = Color3.fromRGB(48, 160, 78);
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
TextButton.Activated:Connect(function() -- Line: 159
    -- upvalues: u1 (ref), TreadmillRequest (copy)
    if not u1 then
        TreadmillRequest:FireServer("Start");
    end;
end);
TextButton2.Activated:Connect(function() -- Line: 166
    -- upvalues: TreadmillRequest (copy)
    TreadmillRequest:FireServer("ForceStop");
end);
TreadmillSync.OnClientEvent:Connect(function(p3) -- Line: 170
    -- upvalues: updateUI (copy)
    updateUI(p3);
end);
Frame.Visible = false;
UserInputService.InputBegan:Connect(function(p4, p5) -- Line: 176
    -- upvalues: Frame (copy)
    if p4.KeyCode == Enum.KeyCode.F7 then
        Frame.Visible = not Frame.Visible;
    end;
end);