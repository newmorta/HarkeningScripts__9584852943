-- Ruta Original: StarterPlayer.StarterPlayerScripts.Client.AdminAbuseGui
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local u1 = Color3.fromRGB(24, 24, 26);
local u2 = Color3.fromRGB(38, 38, 42);
local u3 = Color3.fromRGB(48, 48, 54);
local u4 = Color3.fromRGB(210, 255, 80);
local u5 = Color3.fromRGB(235, 235, 238);
local u6 = Color3.fromRGB(120, 120, 128);
local u7 = Color3.fromRGB(190, 45, 55);
local u8 = Color3.fromRGB(80, 200, 120);
local RobotoMono = Enum.Font.RobotoMono;

local function formatMinutesLabel(p9) -- Line: 42
    local v10 = p9 / 60;

    if v10 == math.floor(v10) then
        return string.format("%d min", (math.floor(v10)));
    end;

    return string.format("%.1f min", v10);
end;

local function makeRow(p11, p12) -- Line: 51
    -- upvalues: u2 (copy), RobotoMono (copy), u5 (copy), u3 (copy)
    local TextButton = Instance.new("TextButton");
    TextButton.Name = p11.name;
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundColor3 = u2;
    TextButton.BorderSizePixel = 0;
    TextButton.Size = UDim2.new(1, 0, 0, 40);
    TextButton.LayoutOrder = p12;
    TextButton.Font = RobotoMono;
    TextButton.Text = "  " .. (p11.displayName or p11.name);
    TextButton.TextColor3 = u5;
    TextButton.TextSize = 15;
    TextButton.TextXAlignment = Enum.TextXAlignment.Left;
    TextButton.ZIndex = 2;
    TextButton.MouseEnter:Connect(function() -- Line: 80
        -- upvalues: TextButton (copy), u3 (ref)
        TextButton.BackgroundColor3 = u3;
    end);
    TextButton.MouseLeave:Connect(function() -- Line: 83
        -- upvalues: TextButton (copy), u2 (ref)
        TextButton.BackgroundColor3 = u2;
    end);

    return TextButton;
end;

local u46 = {
    mount = function(p13, p14) -- Line: 92, Name: mount
        -- upvalues: u1 (copy), u4 (copy), RobotoMono (copy), u6 (copy), u7 (copy), u5 (copy), u2 (copy), u8 (copy), u3 (copy), makeRow (copy)
        local u15 = {
            current = p14
        };
        local ScreenGui = Instance.new("ScreenGui");
        ScreenGui.Name = "AdminAbuseEvent";
        ScreenGui.ResetOnSpawn = false;
        ScreenGui.IgnoreGuiInset = true;
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
        ScreenGui.DisplayOrder = 100;
        ScreenGui.Enabled = false;
        ScreenGui.Parent = p13;
        local TextButton = Instance.new("TextButton");
        TextButton.Name = "Backdrop";
        TextButton.AutoButtonColor = false;
        TextButton.Size = UDim2.fromScale(1, 1);
        TextButton.BackgroundColor3 = Color3.new(0, 0, 0);
        TextButton.BackgroundTransparency = 0.45;
        TextButton.BorderSizePixel = 0;
        TextButton.Text = "";
        TextButton.ZIndex = 1;
        TextButton.Parent = ScreenGui;
        local Frame = Instance.new("Frame");
        Frame.Name = "Root";
        Frame.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame.Position = UDim2.fromScale(0.5, 0.5);
        Frame.Size = UDim2.fromOffset(360, 420);
        Frame.BackgroundColor3 = u1;
        Frame.BorderSizePixel = 0;
        Frame.ZIndex = 2;
        Frame.Parent = ScreenGui;
        local Frame2 = Instance.new("Frame");
        Frame2.Name = "Stripe";
        Frame2.BackgroundColor3 = u4;
        Frame2.BorderSizePixel = 0;
        Frame2.Position = UDim2.new(0, 0, 0, 0);
        Frame2.Size = UDim2.new(0, 4, 1, 0);
        Frame2.ZIndex = 3;
        Frame2.Parent = Frame;
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "Title";
        TextLabel.BackgroundTransparency = 1;
        TextLabel.Position = UDim2.new(0, 16, 0, 14);
        TextLabel.Size = UDim2.new(1, -24, 0, 22);
        TextLabel.Font = RobotoMono;
        TextLabel.Text = "admin_abuse";
        TextLabel.TextColor3 = u4;
        TextLabel.TextSize = 17;
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel.ZIndex = 3;
        TextLabel.Parent = Frame;
        local TextLabel2 = Instance.new("TextLabel");
        TextLabel2.Name = "Hint";
        TextLabel2.BackgroundTransparency = 1;
        TextLabel2.Position = UDim2.new(0, 16, 0, 36);
        TextLabel2.Size = UDim2.new(1, -24, 0, 16);
        TextLabel2.Font = RobotoMono;
        TextLabel2.Text = "modules/";
        TextLabel2.TextColor3 = u6;
        TextLabel2.TextSize = 12;
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel2.ZIndex = 3;
        TextLabel2.Parent = Frame;
        local ScrollingFrame = Instance.new("ScrollingFrame");
        ScrollingFrame.Name = "Actions";
        ScrollingFrame.BackgroundTransparency = 1;
        ScrollingFrame.BorderSizePixel = 0;
        ScrollingFrame.Position = UDim2.new(0, 12, 0, 64);
        ScrollingFrame.Size = UDim2.new(1, -24, 1, -120);
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0);
        ScrollingFrame.ScrollBarThickness = 6;
        ScrollingFrame.ScrollBarImageColor3 = u6;
        ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
        ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y;
        ScrollingFrame.ZIndex = 2;
        ScrollingFrame.Parent = Frame;
        local UIListLayout = Instance.new("UIListLayout");
        UIListLayout.Padding = UDim.new(0, 2);
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout.Parent = ScrollingFrame;
        local UIPadding = Instance.new("UIPadding");
        UIPadding.PaddingBottom = UDim.new(0, 4);
        UIPadding.PaddingTop = UDim.new(0, 2);
        UIPadding.Parent = ScrollingFrame;
        local Frame3 = Instance.new("Frame");
        Frame3.Name = "Footer";
        Frame3.BackgroundTransparency = 1;
        Frame3.AnchorPoint = Vector2.new(0, 1);
        Frame3.Position = UDim2.new(0, 0, 1, 0);
        Frame3.Size = UDim2.new(1, 0, 0, 52);
        Frame3.ZIndex = 3;
        Frame3.Parent = Frame;
        local TextButton2 = Instance.new("TextButton");
        TextButton2.Name = "Stop";
        TextButton2.AutoButtonColor = false;
        TextButton2.AnchorPoint = Vector2.new(0, 1);
        TextButton2.Position = UDim2.new(0, 12, 1, -12);
        TextButton2.Size = UDim2.new(0.28, -8, 0, 36);
        TextButton2.BackgroundColor3 = u7;
        TextButton2.BorderSizePixel = 0;
        TextButton2.Font = RobotoMono;
        TextButton2.Text = "stop";
        TextButton2.TextColor3 = u5;
        TextButton2.TextSize = 14;
        TextButton2.ZIndex = 3;
        TextButton2.Parent = Frame3;
        local u16 = nil;
        local u17 = nil;
        TextButton2.MouseButton1Click:Connect(function() -- Line: 245
            -- upvalues: u16 (ref)
            u16();
        end);
        local TextButton3 = Instance.new("TextButton");
        TextButton3.Name = "Close";
        TextButton3.AutoButtonColor = false;
        TextButton3.AnchorPoint = Vector2.new(1, 1);
        TextButton3.Position = UDim2.new(1, -12, 1, -12);
        TextButton3.Size = UDim2.new(0.3, -8, 0, 36);
        TextButton3.BackgroundColor3 = u2;
        TextButton3.BorderSizePixel = 0;
        TextButton3.Font = RobotoMono;
        TextButton3.Text = "close";
        TextButton3.TextColor3 = u5;
        TextButton3.TextSize = 14;
        TextButton3.ZIndex = 3;
        TextButton3.Parent = Frame3;
        local Frame4 = Instance.new("Frame");
        Frame4.Name = "DurationPrompt";
        Frame4.BackgroundColor3 = u1;
        Frame4.BorderSizePixel = 0;
        Frame4.Size = UDim2.new(1, 0, 1, 0);
        Frame4.Position = UDim2.new(0, 0, 0, 0);
        Frame4.Visible = false;
        Frame4.ZIndex = 5;
        Frame4.Parent = Frame;
        local Frame5 = Instance.new("Frame");
        Frame5.BackgroundColor3 = u4;
        Frame5.BorderSizePixel = 0;
        Frame5.Size = UDim2.new(0, 4, 1, 0);
        Frame5.ZIndex = 6;
        Frame5.Parent = Frame4;
        local TextLabel3 = Instance.new("TextLabel");
        TextLabel3.BackgroundTransparency = 1;
        TextLabel3.Position = UDim2.new(0, 16, 0, 14);
        TextLabel3.Size = UDim2.new(1, -24, 0, 22);
        TextLabel3.Font = RobotoMono;
        TextLabel3.Text = "duration";
        TextLabel3.TextColor3 = u4;
        TextLabel3.TextSize = 17;
        TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel3.ZIndex = 6;
        TextLabel3.Parent = Frame4;
        local TextLabel4 = Instance.new("TextLabel");
        TextLabel4.Name = "Subtitle";
        TextLabel4.BackgroundTransparency = 1;
        TextLabel4.Position = UDim2.new(0, 16, 0, 36);
        TextLabel4.Size = UDim2.new(1, -24, 0, 16);
        TextLabel4.Font = RobotoMono;
        TextLabel4.Text = "module";
        TextLabel4.TextColor3 = u6;
        TextLabel4.TextSize = 12;
        TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel4.ZIndex = 6;
        TextLabel4.Parent = Frame4;
        local TextLabel5 = Instance.new("TextLabel");
        TextLabel5.BackgroundTransparency = 1;
        TextLabel5.Position = UDim2.new(0, 16, 0, 80);
        TextLabel5.Size = UDim2.new(1, -32, 0, 18);
        TextLabel5.Font = RobotoMono;
        TextLabel5.Text = "Durée (minutes)";
        TextLabel5.TextColor3 = u5;
        TextLabel5.TextSize = 13;
        TextLabel5.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel5.ZIndex = 6;
        TextLabel5.Parent = Frame4;
        local TextLabel6 = Instance.new("TextLabel");
        TextLabel6.Name = "DurHint";
        TextLabel6.BackgroundTransparency = 1;
        TextLabel6.Position = UDim2.new(0, 16, 0, 158);
        TextLabel6.Size = UDim2.new(1, -32, 0, 16);
        TextLabel6.Font = RobotoMono;
        TextLabel6.Text = "";
        TextLabel6.TextColor3 = u6;
        TextLabel6.TextSize = 12;
        TextLabel6.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel6.ZIndex = 6;
        TextLabel6.Parent = Frame4;
        local TextBox = Instance.new("TextBox");
        TextBox.Name = "DurBox";
        TextBox.BackgroundColor3 = u2;
        TextBox.BorderSizePixel = 0;
        TextBox.Position = UDim2.new(0, 16, 0, 102);
        TextBox.Size = UDim2.new(1, -32, 0, 48);
        TextBox.Font = RobotoMono;
        TextBox.PlaceholderText = "5";
        TextBox.Text = "";
        TextBox.TextColor3 = u5;
        TextBox.TextSize = 22;
        TextBox.ClearTextOnFocus = false;
        TextBox.ZIndex = 6;
        TextBox.Parent = Frame4;
        local TextButton4 = Instance.new("TextButton");
        TextButton4.Name = "DurStart";
        TextButton4.AutoButtonColor = false;
        TextButton4.AnchorPoint = Vector2.new(0, 1);
        TextButton4.Position = UDim2.new(0, 12, 1, -12);
        TextButton4.Size = UDim2.new(0.5, -14, 0, 36);
        TextButton4.BackgroundColor3 = u8;
        TextButton4.BorderSizePixel = 0;
        TextButton4.Font = RobotoMono;
        TextButton4.Text = "start";
        TextButton4.TextColor3 = u5;
        TextButton4.TextSize = 14;
        TextButton4.ZIndex = 6;
        TextButton4.Parent = Frame4;
        local TextButton5 = Instance.new("TextButton");
        TextButton5.Name = "DurCancel";
        TextButton5.AutoButtonColor = false;
        TextButton5.AnchorPoint = Vector2.new(1, 1);
        TextButton5.Position = UDim2.new(1, -12, 1, -12);
        TextButton5.Size = UDim2.new(0.5, -14, 0, 36);
        TextButton5.BackgroundColor3 = u2;
        TextButton5.BorderSizePixel = 0;
        TextButton5.Font = RobotoMono;
        TextButton5.Text = "cancel";
        TextButton5.TextColor3 = u5;
        TextButton5.TextSize = 14;
        TextButton5.ZIndex = 6;
        TextButton5.Parent = Frame4;
        local Frame6 = Instance.new("Frame");
        Frame6.Name = "ConfirmPrompt";
        Frame6.BackgroundColor3 = u1;
        Frame6.BorderSizePixel = 0;
        Frame6.Size = UDim2.new(1, 0, 1, 0);
        Frame6.Position = UDim2.new(0, 0, 0, 0);
        Frame6.Visible = false;
        Frame6.ZIndex = 8;
        Frame6.Parent = Frame;
        local Frame7 = Instance.new("Frame");
        Frame7.BackgroundColor3 = u4;
        Frame7.BorderSizePixel = 0;
        Frame7.Size = UDim2.new(0, 4, 1, 0);
        Frame7.ZIndex = 9;
        Frame7.Parent = Frame6;
        local TextLabel7 = Instance.new("TextLabel");
        TextLabel7.BackgroundTransparency = 1;
        TextLabel7.Position = UDim2.new(0, 16, 0, 14);
        TextLabel7.Size = UDim2.new(1, -24, 0, 22);
        TextLabel7.Font = RobotoMono;
        TextLabel7.Text = "are you sure?";
        TextLabel7.TextColor3 = u4;
        TextLabel7.TextSize = 17;
        TextLabel7.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel7.ZIndex = 9;
        TextLabel7.Parent = Frame6;
        local TextLabel8 = Instance.new("TextLabel");
        TextLabel8.Name = "Subtitle";
        TextLabel8.BackgroundTransparency = 1;
        TextLabel8.Position = UDim2.new(0, 16, 0, 36);
        TextLabel8.Size = UDim2.new(1, -24, 0, 16);
        TextLabel8.Font = RobotoMono;
        TextLabel8.Text = "module";
        TextLabel8.TextColor3 = u6;
        TextLabel8.TextSize = 12;
        TextLabel8.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel8.ZIndex = 9;
        TextLabel8.Parent = Frame6;
        local TextButton6 = Instance.new("TextButton");
        TextButton6.Name = "ConfirmYes";
        TextButton6.AutoButtonColor = false;
        TextButton6.AnchorPoint = Vector2.new(0, 1);
        TextButton6.Position = UDim2.new(0, 12, 1, -12);
        TextButton6.Size = UDim2.new(0.5, -14, 0, 36);
        TextButton6.BackgroundColor3 = u8;
        TextButton6.BorderSizePixel = 0;
        TextButton6.Font = RobotoMono;
        TextButton6.Text = "yes";
        TextButton6.TextColor3 = u5;
        TextButton6.TextSize = 14;
        TextButton6.ZIndex = 9;
        TextButton6.Parent = Frame6;
        local TextButton7 = Instance.new("TextButton");
        TextButton7.Name = "ConfirmNo";
        TextButton7.AutoButtonColor = false;
        TextButton7.AnchorPoint = Vector2.new(1, 1);
        TextButton7.Position = UDim2.new(1, -12, 1, -12);
        TextButton7.Size = UDim2.new(0.5, -14, 0, 36);
        TextButton7.BackgroundColor3 = u7;
        TextButton7.BorderSizePixel = 0;
        TextButton7.Font = RobotoMono;
        TextButton7.Text = "no";
        TextButton7.TextColor3 = u5;
        TextButton7.TextSize = 14;
        TextButton7.ZIndex = 9;
        TextButton7.Parent = Frame6;
        local Frame8 = Instance.new("Frame");
        Frame8.Name = "StopMenu";
        Frame8.BackgroundColor3 = u1;
        Frame8.BorderSizePixel = 0;
        Frame8.Size = UDim2.new(1, 0, 1, 0);
        Frame8.Position = UDim2.new(0, 0, 0, 0);
        Frame8.Visible = false;
        Frame8.ZIndex = 7;
        Frame8.Parent = Frame;
        local Frame9 = Instance.new("Frame");
        Frame9.BackgroundColor3 = u4;
        Frame9.BorderSizePixel = 0;
        Frame9.Size = UDim2.new(0, 4, 1, 0);
        Frame9.ZIndex = 8;
        Frame9.Parent = Frame8;
        local TextLabel9 = Instance.new("TextLabel");
        TextLabel9.BackgroundTransparency = 1;
        TextLabel9.Position = UDim2.new(0, 16, 0, 14);
        TextLabel9.Size = UDim2.new(1, -24, 0, 22);
        TextLabel9.Font = RobotoMono;
        TextLabel9.Text = "stop_event";
        TextLabel9.TextColor3 = u4;
        TextLabel9.TextSize = 17;
        TextLabel9.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel9.ZIndex = 8;
        TextLabel9.Parent = Frame8;
        local TextLabel10 = Instance.new("TextLabel");
        TextLabel10.BackgroundTransparency = 1;
        TextLabel10.Position = UDim2.new(0, 16, 0, 36);
        TextLabel10.Size = UDim2.new(1, -24, 0, 16);
        TextLabel10.Font = RobotoMono;
        TextLabel10.Text = "active/";
        TextLabel10.TextColor3 = u6;
        TextLabel10.TextSize = 12;
        TextLabel10.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel10.ZIndex = 8;
        TextLabel10.Parent = Frame8;
        local Frame10 = Instance.new("Frame");
        Frame10.BackgroundTransparency = 1;
        Frame10.BorderSizePixel = 0;
        Frame10.Position = UDim2.new(0, 12, 0, 64);
        Frame10.Size = UDim2.new(1, -24, 0, 88);
        Frame10.ZIndex = 8;
        Frame10.Parent = Frame8;
        local UIListLayout2 = Instance.new("UIListLayout");
        UIListLayout2.Padding = UDim.new(0, 4);
        UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout2.Parent = Frame10;
        local TextLabel11 = Instance.new("TextLabel");
        TextLabel11.BackgroundTransparency = 1;
        TextLabel11.Size = UDim2.new(1, 0, 0, 40);
        TextLabel11.Font = RobotoMono;
        TextLabel11.Text = "nothing active";
        TextLabel11.TextColor3 = u6;
        TextLabel11.TextSize = 14;
        TextLabel11.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel11.ZIndex = 8;
        TextLabel11.Visible = false;
        TextLabel11.Parent = Frame10;
        local TextButton8 = Instance.new("TextButton");
        TextButton8.Name = "Back";
        TextButton8.AutoButtonColor = false;
        TextButton8.AnchorPoint = Vector2.new(0.5, 1);
        TextButton8.Position = UDim2.new(0.5, 0, 1, -12);
        TextButton8.Size = UDim2.new(1, -24, 0, 36);
        TextButton8.BackgroundColor3 = u2;
        TextButton8.BorderSizePixel = 0;
        TextButton8.Font = RobotoMono;
        TextButton8.Text = "back";
        TextButton8.TextColor3 = u5;
        TextButton8.TextSize = 14;
        TextButton8.ZIndex = 8;
        TextButton8.Parent = Frame8;
        local u18 = nil;
        local u19 = nil;
        local u20 = nil;
        local u21 = nil;

        local function closeDurationPrompt() -- Line: 549
            -- upvalues: u18 (ref), Frame4 (copy)
            u18 = nil;
            Frame4.Visible = false;
        end;

        local function openDurationPrompt(p22) -- Line: 554
            -- upvalues: u18 (ref), TextLabel4 (copy), TextBox (copy), TextLabel6 (copy), Frame4 (copy)
            u18 = p22;
            local v23 = p22.maxDurationSeconds or 600;
            local v24 = math.floor((p22.defaultDurationSeconds or v23) / 60 + 0.5);
            local v25 = v24 < 1 and 1 or v24;
            TextLabel4.Text = "modules/" .. (p22.displayName or p22.name);
            TextBox.Text = tostring(v25);
            TextBox.PlaceholderText = tostring(v25);
            local v26 = v23 / 60;
            local v27;

            if v26 == math.floor(v26) then
                v27 = string.format("%d min", (math.floor(v26)));
            else
                v27 = string.format("%.1f min", v26);
            end;

            TextLabel6.Text = "Maximum " .. v27;
            Frame4.Visible = true;
        end;

        local function closeConfirmationPrompt() -- Line: 570
            -- upvalues: u19 (ref), u20 (ref), u21 (ref), TextLabel7 (copy), Frame6 (copy)
            u19 = nil;
            u20 = nil;
            u21 = nil;
            TextLabel7.Text = "are you sure?";
            Frame6.Visible = false;
        end;

        local function openConfirmationPrompt(p28, p29) -- Line: 578
            -- upvalues: u19 (ref), u20 (ref), TextLabel8 (copy), Frame6 (copy)
            u19 = p28;
            u20 = p29;
            TextLabel8.Text = "modules/" .. (p28.displayName or p28.name);
            Frame6.Visible = true;
        end;

        local function openStopConfirmation(p30, p31) -- Line: 585
            -- upvalues: u21 (ref), u19 (ref), u20 (ref), TextLabel7 (copy), TextLabel8 (copy), Frame6 (copy)
            u21 = p31;
            u19 = nil;
            u20 = nil;
            TextLabel7.Text = "end this event?";
            TextLabel8.Text = "active/" .. p30;
            Frame6.Visible = true;
        end;

        local function closeAll() -- Line: 594
            -- upvalues: u18 (ref), Frame4 (copy), u19 (ref), u20 (ref), u21 (ref), TextLabel7 (copy), Frame6 (copy), u17 (ref), ScreenGui (copy), u15 (copy)
            u18 = nil;
            Frame4.Visible = false;
            u19 = nil;
            u20 = nil;
            u21 = nil;
            TextLabel7.Text = "are you sure?";
            Frame6.Visible = false;
            u17();
            ScreenGui.Enabled = false;

            if u15.current.onClose then
                u15.current.onClose();
            end;
        end;

        u17 = function() -- Line: 604
            -- upvalues: Frame10 (copy), TextLabel11 (copy), Frame8 (copy)
            for _, child in ipairs(Frame10:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy();
                end;
            end;

            TextLabel11.Visible = false;
            Frame8.Visible = false;
        end;

        u16 = function() -- Line: 614
            -- upvalues: u17 (ref), u15 (copy), u2 (ref), RobotoMono (ref), u5 (ref), u3 (ref), u21 (ref), u19 (ref), u20 (ref), TextLabel7 (copy), TextLabel8 (copy), Frame6 (copy), Frame10 (copy), TextLabel11 (copy), Frame8 (copy)
            u17();
            local current = u15.current;
            local v32 = 0;

            if current.activeAdminAbuse and current.activeAdminAbuse ~= "" then
                v32 = v32 + 1;
                local activeAdminAbuse = current.activeAdminAbuse;
                local TextButton9 = Instance.new("TextButton");
                TextButton9.AutoButtonColor = false;
                TextButton9.BackgroundColor3 = u2;
                TextButton9.BorderSizePixel = 0;
                TextButton9.Size = UDim2.new(1, 0, 0, 40);
                TextButton9.LayoutOrder = v32;
                TextButton9.Font = RobotoMono;
                TextButton9.Text = "  " .. activeAdminAbuse .. "  [admin abuse]";
                TextButton9.TextColor3 = u5;
                TextButton9.TextSize = 14;
                TextButton9.TextXAlignment = Enum.TextXAlignment.Left;
                TextButton9.ZIndex = 8;
                TextButton9.MouseEnter:Connect(function() -- Line: 633
                    -- upvalues: TextButton9 (copy), u3 (ref)
                    TextButton9.BackgroundColor3 = u3;
                end);
                TextButton9.MouseLeave:Connect(function() -- Line: 634
                    -- upvalues: TextButton9 (copy), u2 (ref)
                    TextButton9.BackgroundColor3 = u2;
                end);
                TextButton9.MouseButton1Click:Connect(function() -- Line: 635
                    -- upvalues: u17 (ref), activeAdminAbuse (copy), u15 (ref), u21 (ref), u19 (ref), u20 (ref), TextLabel7 (ref), TextLabel8 (ref), Frame6 (ref)
                    u17();

                    u21 = function() -- Line: 637
                        -- upvalues: u15 (ref)
                        u15.current.onStop();
                    end;

                    u19 = nil;
                    u20 = nil;
                    TextLabel7.Text = "end this event?";
                    TextLabel8.Text = "active/" .. activeAdminAbuse .. "  [admin abuse]";
                    Frame6.Visible = true;
                end);
                TextButton9.Parent = Frame10;
            end;

            if current.activeEvent and current.activeEvent ~= "" then
                v32 = v32 + 1;
                local activeEvent = current.activeEvent;
                local TextButton9 = Instance.new("TextButton");
                TextButton9.AutoButtonColor = false;
                TextButton9.BackgroundColor3 = u2;
                TextButton9.BorderSizePixel = 0;
                TextButton9.Size = UDim2.new(1, 0, 0, 40);
                TextButton9.LayoutOrder = v32;
                TextButton9.Font = RobotoMono;
                TextButton9.Text = "  " .. activeEvent .. "  [event]";
                TextButton9.TextColor3 = u5;
                TextButton9.TextSize = 14;
                TextButton9.TextXAlignment = Enum.TextXAlignment.Left;
                TextButton9.ZIndex = 8;
                TextButton9.MouseEnter:Connect(function() -- Line: 658
                    -- upvalues: TextButton9 (copy), u3 (ref)
                    TextButton9.BackgroundColor3 = u3;
                end);
                TextButton9.MouseLeave:Connect(function() -- Line: 659
                    -- upvalues: TextButton9 (copy), u2 (ref)
                    TextButton9.BackgroundColor3 = u2;
                end);
                TextButton9.MouseButton1Click:Connect(function() -- Line: 660
                    -- upvalues: u17 (ref), activeEvent (copy), u15 (ref), u21 (ref), u19 (ref), u20 (ref), TextLabel7 (ref), TextLabel8 (ref), Frame6 (ref)
                    u17();

                    u21 = function() -- Line: 662
                        -- upvalues: u15 (ref)
                        u15.current.onStopEvent();
                    end;

                    u19 = nil;
                    u20 = nil;
                    TextLabel7.Text = "end this event?";
                    TextLabel8.Text = "active/" .. activeEvent .. "  [event]";
                    Frame6.Visible = true;
                end);
                TextButton9.Parent = Frame10;
            end;

            if v32 == 0 then
                TextLabel11.Visible = true;
            end;

            Frame8.Visible = true;
        end;

        TextButton3.MouseButton1Click:Connect(closeAll);
        TextButton.MouseButton1Click:Connect(closeAll);
        TextButton5.MouseButton1Click:Connect(closeDurationPrompt);
        TextButton8.MouseButton1Click:Connect(u17);
        TextButton7.MouseButton1Click:Connect(closeConfirmationPrompt);
        TextButton6.MouseButton1Click:Connect(function() -- Line: 681
            -- upvalues: u21 (ref), u19 (ref), u20 (ref), TextLabel7 (copy), Frame6 (copy), u15 (copy), ScreenGui (copy)
            if u21 then
                local v33 = u21;
                u19 = nil;
                u20 = nil;
                u21 = nil;
                TextLabel7.Text = "are you sure?";
                Frame6.Visible = false;
                v33();

                return;
            end;

            local v34 = u19;
            local v35 = u20;
            u19 = nil;
            u20 = nil;
            u21 = nil;
            TextLabel7.Text = "are you sure?";
            Frame6.Visible = false;

            if v34 then
                u15.current.onPickModule(v34.name, v35);
                ScreenGui.Enabled = false;
            end;
        end);
        TextButton4.MouseButton1Click:Connect(function() -- Line: 697
            -- upvalues: u18 (ref), TextBox (copy), Frame4 (copy), u19 (ref), u20 (ref), TextLabel8 (copy), Frame6 (copy)
            local v36 = u18;

            if not v36 then
                return;
            end;

            local v37 = v36.maxDurationSeconds or 600;
            local v38 = tonumber(TextBox.Text);

            if not v38 or v38 <= 0 then
                v38 = (v36.defaultDurationSeconds or v37) / 60;
            end;

            local v39 = math.floor(v38 * 60 + 0.5);
            local v40 = v39 <= 0 and 60 or v39;

            if v37 < v40 then
                v40 = v37;
            end;

            u18 = nil;
            Frame4.Visible = false;
            u19 = v36;
            u20 = v40;
            TextLabel8.Text = "modules/" .. (v36.displayName or v36.name);
            Frame6.Visible = true;
        end);

        local function clearScrollButtons() -- Line: 718
            -- upvalues: ScrollingFrame (copy)
            for _, child in ipairs(ScrollingFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy();
                end;
            end;
        end;

        local function applyProps(p41) -- Line: 726
            -- upvalues: clearScrollButtons (copy), u18 (ref), Frame4 (copy), u19 (ref), u20 (ref), u21 (ref), TextLabel7 (copy), Frame6 (copy), makeRow (ref), ScrollingFrame (copy), openDurationPrompt (copy), TextLabel8 (copy), TextButton2 (copy), TextButton3 (copy)
            clearScrollButtons();
            u18 = nil;
            Frame4.Visible = false;
            u19 = nil;
            u20 = nil;
            u21 = nil;
            TextLabel7.Text = "are you sure?";
            Frame6.Visible = false;

            for i, v in ipairs(p41.moduleMetas) do
                local v42 = makeRow(v, i);
                v42.Parent = ScrollingFrame;
                v42.MouseButton1Click:Connect(function() -- Line: 733
                    -- upvalues: v (copy), openDurationPrompt (ref), u19 (ref), u20 (ref), TextLabel8 (ref), Frame6 (ref)
                    if v.needsDuration then
                        openDurationPrompt(v);

                        return;
                    end;

                    local v43 = v;
                    u19 = v43;
                    u20 = nil;
                    TextLabel8.Text = "modules/" .. (v43.displayName or v43.name);
                    Frame6.Visible = true;
                end);
            end;

            TextButton2.Visible = p41.showStop;

            if not p41.showStop then
                TextButton3.AnchorPoint = Vector2.new(0.5, 1);
                TextButton3.Position = UDim2.new(0.5, 0, 1, -12);
                TextButton3.Size = UDim2.new(1, -24, 0, 36);

                return;
            end;

            TextButton2.AnchorPoint = Vector2.new(0, 1);
            TextButton2.Position = UDim2.new(0, 12, 1, -12);
            TextButton2.Size = UDim2.new(0.28, -8, 0, 36);
            TextButton3.AnchorPoint = Vector2.new(1, 1);
            TextButton3.Position = UDim2.new(1, -12, 1, -12);
            TextButton3.Size = UDim2.new(0.3, -8, 0, 36);
        end;

        applyProps(u15.current);

        return {
            ScreenGui = ScreenGui,

            SetVisible = function(p44) -- Line: 764, Name: SetVisible
                -- upvalues: u18 (ref), Frame4 (copy), u19 (ref), u20 (ref), u21 (ref), TextLabel7 (copy), Frame6 (copy), u17 (ref), ScreenGui (copy)
                if not p44 then
                    u18 = nil;
                    Frame4.Visible = false;
                    u19 = nil;
                    u20 = nil;
                    u21 = nil;
                    TextLabel7.Text = "are you sure?";
                    Frame6.Visible = false;
                    u17();
                end;

                ScreenGui.Enabled = p44;
            end,

            SetProps = function(p45) -- Line: 772, Name: SetProps
                -- upvalues: u15 (copy), applyProps (copy)
                u15.current = p45;
                applyProps(p45);
            end,

            Destroy = function() -- Line: 776, Name: Destroy
                -- upvalues: ScreenGui (copy)
                ScreenGui:Destroy();
            end
        };
    end
};

function u46.mountLocalPlayer(p47) -- Line: 782
    -- upvalues: Players (copy), u46 (copy)
    local LocalPlayer = Players.LocalPlayer;
    assert(LocalPlayer, "LocalPlayer manquant");

    return u46.mount(LocalPlayer:WaitForChild("PlayerGui"), p47);
end;

return u46;