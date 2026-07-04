-- Ruta Original: StarterGui.AnnouncementGui.MessageAllGui
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");
game:GetService("Debris");
local AdminMessageToAll = ReplicatedStorage:WaitForChild("AdminMessageToAll");
local Parent = script.Parent;
local AnnouncementSound = SoundService:WaitForChild("AnnouncementSound");

local function getHeadshot(p1) -- Line: 14
    -- upvalues: Players (copy)
    local v2, _ = Players:GetUserThumbnailAsync(p1, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48);

    return v2;
end;

AdminMessageToAll.OnClientEvent:Connect(function(p3, p4) -- Line: 21
    -- upvalues: Parent (copy), Players (copy), TweenService (copy), AnnouncementSound (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "AdminMsgFrame";
    Frame.Parent = Parent;
    Frame.Size = UDim2.new(0.6, 0, 0.06, 0);
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.Position = UDim2.new(0.5, 0, -0.1, 0);
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15);
    Frame.BackgroundTransparency = 0.15;
    Frame.BorderSizePixel = 0;
    Frame.ZIndex = 10;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.5, 0);
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Parent = Frame;
    UIStroke.Thickness = 2;
    UIStroke.Transparency = 0.8;
    UIStroke.Color = Color3.fromRGB(255, 255, 255);
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Parent = Frame;
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Padding = UDim.new(0, 12);
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Parent = Frame;
    UIPadding.PaddingLeft = UDim.new(0, 8);
    UIPadding.PaddingRight = UDim.new(0, 8);
    UIPadding.PaddingTop = UDim.new(0, 4);
    UIPadding.PaddingBottom = UDim.new(0, 4);
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Parent = Frame;
    ImageLabel.Size = UDim2.new(0.8, 0, 0.8, 0);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.BackgroundColor3 = Color3.fromRGB(200, 200, 200);
    ImageLabel.BackgroundTransparency = 0;
    local v5, _ = Players:GetUserThumbnailAsync(p3.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48);
    ImageLabel.Image = v5;
    ImageLabel.ZIndex = 11;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = ImageLabel;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Parent = ImageLabel;
    UIStroke2.Thickness = 1;
    UIStroke2.Color = Color3.fromRGB(150, 150, 150);
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Parent = Frame;
    TextLabel.Text = p3.Name .. " :";
    TextLabel.TextColor3 = Color3.fromRGB(255, 80, 80);
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.TextScaled = true;
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint");
    UITextSizeConstraint.MaxTextSize = 24;
    UITextSizeConstraint.MinTextSize = 12;
    UITextSizeConstraint.Parent = TextLabel;
    TextLabel.AutomaticSize = Enum.AutomaticSize.X;
    TextLabel.Size = UDim2.new(0, 0, 1, 0);
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 11;
    TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0);
    TextLabel.TextStrokeTransparency = 0;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Parent = Frame;
    TextLabel2.Text = p4;
    TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel2.Font = Enum.Font.GothamSemibold;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.TextScaled = true;
    local UITextSizeConstraint2 = Instance.new("UITextSizeConstraint");
    UITextSizeConstraint2.MaxTextSize = 24;
    UITextSizeConstraint2.MinTextSize = 12;
    UITextSizeConstraint2.Parent = TextLabel2;
    TextLabel2.Size = UDim2.new(1, 0, 1, 0);
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.TextTruncate = Enum.TextTruncate.AtEnd;
    TextLabel2.ZIndex = 11;
    TextLabel2.TextStrokeColor3 = Color3.new(0, 0, 0);
    TextLabel2.TextStrokeTransparency = 0;
    local v6 = UDim2.new(0.5, 0, 0.08, 0);
    local v7 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
    TweenService:Create(Frame, v7, {
        Position = v6
    }):Play();
    local u8 = AnnouncementSound:Clone();
    u8.Parent = Parent;
    u8:Play();
    task.wait(8);
    local v9 = TweenService:Create(Frame, v7, {
        Position = UDim2.new(0.5, 0, -0.15, 0)
    });
    v9:Play();
    v9.Completed:Connect(function() -- Line: 163
        -- upvalues: Frame (copy), u8 (copy)
        Frame:Destroy();
        u8:Destroy();
    end);
end);