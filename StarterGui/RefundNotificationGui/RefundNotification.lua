-- Ruta Original: StarterGui.RefundNotificationGui.RefundNotification
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local u1 = { { 1e63, "Vg" }, { 1e60, "Nd" }, { 1e57, "Od" }, { 1e54, "Spd" }, { 1e51, "Sxd" }, { 1e48, "Qid" }, { 1e45, "Qad" }, { 1e42, "Td" }, { 1e39, "Dd" }, { 1e36, "Ud" }, { 1e33, "Dc" }, { 1e30, "No" }, { 1e27, "Oc" }, { 1e24, "Sp" }, { 1e21, "Sx" }, { 1e18, "Qi" }, { 1000000000000000, "Qa" }, { 1000000000000, "T" }, { 1000000000, "B" }, { 1000000, "M" }, { 1000, "K" } };

local function formatNumber(p2) -- Line: 29
    -- upvalues: u1 (copy)
    local v3 = tonumber(p2) or 0;

    for _, v in ipairs(u1) do
        local v4 = v[1];
        local v5 = v[2];

        if v4 <= v3 then
            return string.format("%.2f", v3 / v4):gsub("%.?0+$", "") .. v5;
        end;
    end;

    local v6 = math.floor(v3);

    return tostring(v6);
end;

local function showRefundPopup(p7) -- Line: 44
    -- upvalues: PlayerGui (copy), formatNumber (copy), TweenService (copy)
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "RefundPopupOverlay";
    ScreenGui.DisplayOrder = 200;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.Parent = PlayerGui;
    local Frame = Instance.new("Frame");
    Frame.Name = "Overlay";
    Frame.Size = UDim2.new(1, 0, 1, 0);
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.ZIndex = 1;
    Frame.Parent = ScreenGui;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "PopupFrame";
    Frame2.Size = UDim2.new(0, 420, 0, 320);
    Frame2.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.fromRGB(22, 22, 35);
    Frame2.BorderSizePixel = 0;
    Frame2.ZIndex = 2;
    Frame2.Parent = ScreenGui;
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 16);
    local UIStroke = Instance.new("UIStroke", Frame2);
    UIStroke.Color = Color3.fromRGB(255, 200, 60);
    UIStroke.Thickness = 2.5;
    UIStroke.Transparency = 0.2;
    local UIScale = Instance.new("UIScale", Frame2);
    UIScale.Scale = 0;
    local UIGradient = Instance.new("UIGradient", Frame2);
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 28)) });
    UIGradient.Rotation = 135;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "TrophyIcon";
    ImageLabel.Size = UDim2.new(0, 64, 0, 64);
    ImageLabel.Position = UDim2.new(0.5, 0, 0, 24);
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://15540211845";
    ImageLabel.ZIndex = 3;
    ImageLabel.Parent = Frame2;
    Instance.new("UIAspectRatioConstraint", ImageLabel).AspectRatio = 1;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.Size = UDim2.new(0.85, 0, 0, 36);
    TextLabel.Position = UDim2.new(0.5, 0, 0, 98);
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = "🎁 REFUND";
    TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0);
    TextLabel.TextScaled = true;
    TextLabel.Font = Enum.Font.GothamBlack;
    TextLabel.ZIndex = 3;
    TextLabel.Parent = Frame2;
    local UIStroke2 = Instance.new("UIStroke", TextLabel);
    UIStroke2.Color = Color3.fromRGB(120, 80, 0);
    UIStroke2.Thickness = 2;
    Instance.new("UITextSizeConstraint", TextLabel).MaxTextSize = 32;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Message";
    TextLabel2.Size = UDim2.new(0.85, 0, 0, 30);
    TextLabel2.Position = UDim2.new(0.5, 0, 0, 142);
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.Text = "You have been refunded for the purchase of the items!";
    TextLabel2.TextColor3 = Color3.fromRGB(200, 200, 220);
    TextLabel2.TextScaled = true;
    TextLabel2.Font = Enum.Font.GothamMedium;
    TextLabel2.ZIndex = 3;
    TextLabel2.Parent = Frame2;
    Instance.new("UITextSizeConstraint", TextLabel2).MaxTextSize = 20;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Amount";
    TextLabel3.Size = UDim2.new(0.85, 0, 0, 50);
    TextLabel3.Position = UDim2.new(0.5, 0, 0, 178);
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.Text = "+" .. formatNumber(p7) .. " 🏆";
    TextLabel3.TextColor3 = Color3.fromRGB(80, 255, 120);
    TextLabel3.TextScaled = true;
    TextLabel3.Font = Enum.Font.GothamBlack;
    TextLabel3.ZIndex = 3;
    TextLabel3.Parent = Frame2;
    local UIStroke3 = Instance.new("UIStroke", TextLabel3);
    UIStroke3.Color = Color3.fromRGB(0, 60, 20);
    UIStroke3.Thickness = 2.5;
    Instance.new("UITextSizeConstraint", TextLabel3).MaxTextSize = 42;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "OKButton";
    TextButton.Size = UDim2.new(0.5, 0, 0, 46);
    TextButton.Position = UDim2.new(0.5, 0, 1, -36);
    TextButton.AnchorPoint = Vector2.new(0.5, 1);
    TextButton.BackgroundColor3 = Color3.fromRGB(255, 200, 60);
    TextButton.Text = "OK";
    TextButton.TextColor3 = Color3.fromRGB(20, 15, 5);
    TextButton.TextScaled = true;
    TextButton.Font = Enum.Font.GothamBlack;
    TextButton.ZIndex = 3;
    TextButton.AutoButtonColor = true;
    TextButton.Parent = Frame2;
    Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 10);
    local UIStroke4 = Instance.new("UIStroke", TextButton);
    UIStroke4.Color = Color3.fromRGB(200, 150, 0);
    UIStroke4.Thickness = 1.5;
    Instance.new("UITextSizeConstraint", TextButton).MaxTextSize = 28;
    local UIPadding = Instance.new("UIPadding", TextButton);
    UIPadding.PaddingBottom = UDim.new(0, 4);
    UIPadding.PaddingTop = UDim.new(0, 4);
    TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.55
    }):Play();
    TweenService:Create(UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play();
    ImageLabel.Rotation = -15;
    TweenService:Create(ImageLabel, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Rotation = 0
    }):Play();
    task.spawn(function() -- Line: 217
        -- upvalues: Frame2 (copy), TweenService (ref), UIStroke (copy)
        while Frame2 and Frame2.Parent do
            TweenService:Create(UIStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0,
                Color = Color3.fromRGB(255, 240, 130)
            }):Play();
            task.wait(1);

            if not (Frame2 and Frame2.Parent) then
                break;
            end;

            TweenService:Create(UIStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0.3,
                Color = Color3.fromRGB(255, 180, 40)
            }):Play();
            task.wait(1);
        end;
    end);
    TextButton.MouseEnter:Connect(function() -- Line: 234
        -- upvalues: TweenService (ref), TextButton (copy)
        TweenService:Create(TextButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 225, 100),
            Size = UDim2.new(0.53, 0, 0, 50)
        }):Play();
    end);
    TextButton.MouseLeave:Connect(function() -- Line: 241
        -- upvalues: TweenService (ref), TextButton (copy)
        TweenService:Create(TextButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 200, 60),
            Size = UDim2.new(0.5, 0, 0, 46)
        }):Play();
    end);
    TextButton.MouseButton1Click:Connect(function() -- Line: 249
        -- upvalues: TextButton (copy), TweenService (ref), UIScale (copy), Frame (copy), ScreenGui (copy)
        TextButton.Active = false;
        TweenService:Create(UIScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Scale = 0
        }):Play();
        TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        }):Play();
        task.delay(0.4, function() -- Line: 262
            -- upvalues: ScreenGui (ref)
            if ScreenGui and ScreenGui.Parent then
                ScreenGui:Destroy();
            end;
        end);
    end);
end;

ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RefundNotification").OnClientEvent:Connect(function(p8) -- Line: 274
    -- upvalues: showRefundPopup (copy)
    if type(p8) ~= "number" or p8 <= 0 then
        return;
    end;

    showRefundPopup(p8);
end);