-- Ruta Original: ReplicatedStorage.CCPanel.CCPanelUISystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local ContextActionService = game:GetService("ContextActionService");
local Remotes = require(ReplicatedStorage.CCPanel.Remotes);
local GiftTreadmillConfig = require(ReplicatedStorage.CCPanel.GiftTreadmillConfig);
local NotificationSystem = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local CurrentCamera = workspace.CurrentCamera;
local u1 = Color3.fromRGB(25, 25, 30);
local u2 = Color3.fromRGB(18, 18, 22);
local u3 = Color3.fromRGB(32, 32, 40);
local u4 = Color3.fromRGB(42, 42, 50);
local u5 = Color3.fromRGB(58, 58, 70);
local u6 = Color3.fromRGB(40, 80, 140);
local u7 = Color3.fromRGB(60, 180, 90);
local u8 = Color3.fromRGB(180, 60, 60);
local u9 = Color3.fromRGB(80, 130, 220);
local u10 = Color3.fromRGB(220, 220, 230);
local u11 = Color3.fromRGB(150, 150, 165);
local GothamMedium = Enum.Font.GothamMedium;
local GothamBold = Enum.Font.GothamBold;

local function corner(p12, p13) -- Line: 30
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, p13 or 6);
    UICorner.Parent = p12;
end;

local function label(p14, p15, p16, p17, p18, p19, p20, p21, p22) -- Line: 34
    -- upvalues: u10 (copy), GothamMedium (copy)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = p15;
    TextLabel.Size = p17;
    TextLabel.Position = p18;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = p16;
    TextLabel.TextSize = p19 or 13;
    TextLabel.TextColor3 = p20 or u10;
    TextLabel.Font = p21 or GothamMedium;
    TextLabel.TextXAlignment = p22 or Enum.TextXAlignment.Left;
    TextLabel.Parent = p14;

    return TextLabel;
end;

local function btn(p23, p24, p25, p26, p27, p28, p29) -- Line: 44
    -- upvalues: u4 (copy), u10 (copy), GothamMedium (copy), u5 (copy)
    local TextButton = Instance.new("TextButton");
    TextButton.Name = p24;
    TextButton.Size = p26;
    TextButton.Position = p27;
    TextButton.BackgroundColor3 = p28 or u4;
    TextButton.TextColor3 = p29 or u10;
    TextButton.Text = p25;
    TextButton.TextSize = 13;
    TextButton.Font = GothamMedium;
    TextButton.BorderSizePixel = 0;
    TextButton.AutoButtonColor = false;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 5);
    UICorner.Parent = TextButton;
    TextButton.Parent = p23;
    local u30 = p28 or u4;
    TextButton.MouseEnter:Connect(function() -- Line: 52
        -- upvalues: TextButton (copy), u5 (ref)
        if TextButton:GetAttribute("locked") then
            return;
        end;

        TextButton.BackgroundColor3 = u5;
    end);
    TextButton.MouseLeave:Connect(function() -- Line: 56
        -- upvalues: TextButton (copy), u30 (copy)
        if TextButton:GetAttribute("locked") then
            return;
        end;

        TextButton.BackgroundColor3 = u30;
    end);

    return TextButton;
end;

local function freezeChar() -- Line: 67
    -- upvalues: ContextActionService (copy)
    ContextActionService:BindAction("CCPanelFreezeMovement", function() -- Line: 68, Name: sink
        return Enum.ContextActionResult.Sink;
    end, false, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Space, Enum.KeyCode.LeftShift);
end;

local function unfreezeChar() -- Line: 74
    -- upvalues: ContextActionService (copy)
    ContextActionService:UnbindAction("CCPanelFreezeMovement");
end;

local u31 = nil;
local u32 = nil;
local u33 = nil;

local function stopSpectate() -- Line: 84
    -- upvalues: u31 (ref), u32 (ref), u33 (ref), Remotes (copy), ContextActionService (copy), CurrentCamera (copy), LocalPlayer (copy)
    if not u31 then
        return;
    end;

    u31 = nil;

    if u32 then
        task.cancel(u32);
        u32 = nil;
    end;

    if u33 then
        u33:Disconnect();
        u33 = nil;
    end;

    Remotes.Events.ccSpectateFollow:FireServer(nil);
    ContextActionService:UnbindAction("CCPanelFreezeMovement");
    CurrentCamera.CameraType = Enum.CameraType.Custom;
    local v34 = LocalPlayer.Character and v34:FindFirstChildOfClass("Humanoid");

    if v34 then
        CurrentCamera.CameraSubject = v34;
    end;
end;

local function attachCamera(u35) -- Line: 97
    -- upvalues: u32 (ref), u31 (ref), CurrentCamera (copy)
    if u32 then
        task.cancel(u32);
    end;

    u32 = task.spawn(function() -- Line: 99
        -- upvalues: u31 (ref), u35 (copy), CurrentCamera (ref), u32 (ref)
        while u31 == u35 do
            local v36 = u35.Character and v36:FindFirstChildOfClass("Humanoid");

            if v36 then
                CurrentCamera.CameraType = Enum.CameraType.Custom;
                CurrentCamera.CameraSubject = v36;
                u32 = nil;

                return;
            end;

            task.wait(0.1);
        end;
    end);
end;

local function startSpectate(u37) -- Line: 113
    -- upvalues: stopSpectate (copy), u31 (ref), freezeChar (copy), Remotes (copy), u33 (ref), u32 (ref), CurrentCamera (copy)
    stopSpectate();
    u31 = u37;
    freezeChar();
    Remotes.Events.ccSpectateFollow:FireServer(u37.UserId);
    u33 = u37.CharacterAdded:Connect(function() -- Line: 118
        -- upvalues: u31 (ref), u37 (copy), u32 (ref), CurrentCamera (ref)
        if u31 == u37 then
            local u38 = u37;

            if u32 then
                task.cancel(u32);
            end;

            u32 = task.spawn(function() -- Line: 99
                -- upvalues: u31 (ref), u38 (copy), CurrentCamera (ref), u32 (ref)
                while u31 == u38 do
                    local v39 = u38.Character and v39:FindFirstChildOfClass("Humanoid");

                    if v39 then
                        CurrentCamera.CameraType = Enum.CameraType.Custom;
                        CurrentCamera.CameraSubject = v39;
                        u32 = nil;

                        return;
                    end;

                    task.wait(0.1);
                end;
            end);
        end;
    end);

    if u32 then
        task.cancel(u32);
    end;

    u32 = task.spawn(function() -- Line: 99
        -- upvalues: u31 (ref), u37 (copy), CurrentCamera (ref), u32 (ref)
        while u31 == u37 do
            local v40 = u37.Character and v40:FindFirstChildOfClass("Humanoid");

            if v40 then
                CurrentCamera.CameraType = Enum.CameraType.Custom;
                CurrentCamera.CameraSubject = v40;
                u32 = nil;

                return;
            end;

            task.wait(0.1);
        end;
    end);
end;

local u41 = false;
local u42 = nil;
local u43 = 20;

local function disableFreecam() -- Line: 130
    -- upvalues: u41 (ref), u42 (ref), UserInputService (copy), ContextActionService (copy), CurrentCamera (copy), LocalPlayer (copy)
    u41 = false;

    if u42 then
        u42:Disconnect();
        u42 = nil;
    end;

    UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
    ContextActionService:UnbindAction("CCPanelFreezeMovement");
    CurrentCamera.CameraType = Enum.CameraType.Custom;
    local v44 = LocalPlayer.Character and v44:FindFirstChildOfClass("Humanoid");

    if v44 then
        CurrentCamera.CameraSubject = v44;
    end;
end;

local function enableFreecam() -- Line: 141
    -- upvalues: u31 (ref), stopSpectate (copy), freezeChar (copy), u41 (ref), CurrentCamera (copy), u42 (ref), RunService (copy), UserInputService (copy), u43 (ref)
    if u31 then
        stopSpectate();
    end;

    freezeChar();
    u41 = true;
    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    local v45, v46, _ = CurrentCamera.CFrame:ToEulerAnglesYXZ();
    local u47 = v45;
    local u48 = v46;
    u42 = RunService.RenderStepped:Connect(function(p49) -- Line: 151
        -- upvalues: UserInputService (ref), u48 (ref), u47 (ref), u43 (ref), CurrentCamera (ref)
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition;
            local v50 = UserInputService:GetMouseDelta();
            u48 = u48 - v50.X * 0.003;
            u47 = u47 - v50.Y * 0.003;
            u47 = math.clamp(u47, -1.5607963267948965, 1.5607963267948965);
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
        end;

        local v51 = Vector3.new(0, 0, 0);

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            v51 = v51 + Vector3.new(0, 0, -1);
        end;

        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            v51 = v51 + Vector3.new(0, 0, 1);
        end;

        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            v51 = v51 + Vector3.new(-1, 0, 0);
        end;

        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            v51 = v51 + Vector3.new(1, 0, 0);
        end;

        if UserInputService:IsKeyDown(Enum.KeyCode.E) then
            v51 = v51 + Vector3.new(0, 1, 0);
        end;

        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            v51 = v51 + Vector3.new(0, -1, 0);
        end;

        local v52 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and u43 * 3 or u43;
        local v53 = CFrame.fromEulerAnglesYXZ(u47, u48, 0);
        CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position + v53:VectorToWorldSpace(v51 * v52 * p49)) * v53;
    end);
end;

local function formatTimeRemaining(p54, p55) -- Line: 174
    if p54 == 0 then
        return "";
    end;

    local v56 = p55 - (os.time() - p54);

    if v56 <= 0 then
        return "Expired";
    end;

    local v57 = math.floor(v56 / 86400);
    local v58 = math.floor(v56 % 86400 / 3600);
    local v59 = math.floor(v56 % 3600 / 60);

    if v57 > 0 then
        return "⏱ " .. v57 .. "d " .. v58 .. "h";
    end;

    if v58 > 0 then
        return "⏱ " .. v58 .. "h " .. v59 .. "m";
    end;

    return "⏱ " .. v59 .. "m";
end;

local v60 = {};
local u61 = nil;
local u62 = nil;
local u63 = nil;

function v60.createPanel(u64) -- Line: 197
    -- upvalues: PlayerGui (copy), u1 (copy), u2 (copy), u10 (copy), GothamBold (copy), GothamMedium (copy), u3 (copy), u11 (copy), btn (copy), u7 (copy), u8 (copy), u9 (copy), u4 (copy), GiftTreadmillConfig (copy), u31 (ref), formatTimeRemaining (copy), Remotes (copy), u62 (ref), RunService (copy), u63 (ref), NotificationSystem (copy), Players (copy), LocalPlayer (copy), u6 (copy), u5 (copy), u61 (ref), u41 (ref), u42 (ref), UserInputService (copy), ContextActionService (copy), CurrentCamera (copy), enableFreecam (copy), u43 (ref), startSpectate (copy), stopSpectate (copy)
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "CCPanelGui";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.DisplayOrder = 300;
    ScreenGui.Enabled = false;
    ScreenGui.Parent = PlayerGui;
    local Frame = Instance.new("Frame");
    Frame.Name = "Panel";
    Frame.Size = UDim2.new(0, 480, 0, 420);
    Frame.Position = UDim2.new(0.5, -240, 0.5, -210);
    Frame.BackgroundColor3 = u1;
    Frame.BorderSizePixel = 0;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 8);
    UICorner.Parent = Frame;
    Frame.Parent = ScreenGui;
    local UIDragDetector = Instance.new("UIDragDetector");
    UIDragDetector.DragStyle = Enum.UIDragDetectorDragStyle.TranslatePlane;
    UIDragDetector.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Header";
    Frame2.Size = UDim2.new(1, 0, 0, 44);
    Frame2.BackgroundColor3 = u2;
    Frame2.BorderSizePixel = 0;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(0, 8);
    UICorner2.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Size = UDim2.new(1, 0, 0.5, 0);
    Frame3.Position = UDim2.new(0, 0, 0.5, 0);
    Frame3.BackgroundColor3 = u2;
    Frame3.BorderSizePixel = 0;
    Frame3.Parent = Frame2;
    local v65 = UDim2.new(1, -50, 1, 0);
    local v66 = UDim2.new(0, 14, 0, 0);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.Size = v65;
    TextLabel.Position = v66;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = "CC Panel";
    TextLabel.TextSize = 16;
    TextLabel.TextColor3 = u10 or u10;
    TextLabel.Font = GothamBold or GothamMedium;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame2;
    local TextButton = Instance.new("TextButton");
    TextButton.Size = UDim2.new(0, 32, 0, 32);
    TextButton.Position = UDim2.new(1, -38, 0.5, -16);
    TextButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60);
    TextButton.Text = "✕";
    TextButton.TextSize = 16;
    TextButton.Font = GothamBold;
    TextButton.TextColor3 = Color3.new(1, 1, 1);
    TextButton.BorderSizePixel = 0;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.CornerRadius = UDim.new(0, 5);
    UICorner3.Parent = TextButton;
    TextButton.Parent = Frame2;
    TextButton.MouseButton1Click:Connect(function() -- Line: 230
        -- upvalues: ScreenGui (copy), u64 (copy)
        ScreenGui.Enabled = false;

        if u64 then
            u64();
        end;
    end);
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Body";
    Frame4.Size = UDim2.new(1, -12, 1, -72);
    Frame4.Position = UDim2.new(0, 6, 0, 48);
    Frame4.BackgroundTransparency = 1;
    Frame4.Parent = Frame;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "LeftCol";
    Frame5.Size = UDim2.new(0, 160, 1, 0);
    Frame5.BackgroundColor3 = u3;
    Frame5.BorderSizePixel = 0;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.CornerRadius = UDim.new(0, 6);
    UICorner4.Parent = Frame5;
    Frame5.Parent = Frame4;
    local v67 = UDim2.new(1, -8, 0, 22);
    local v68 = UDim2.new(0, 4, 0, 4);
    local Center = Enum.TextXAlignment.Center;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "ListTitle";
    TextLabel2.Size = v67;
    TextLabel2.Position = v68;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.Text = "Players";
    TextLabel2.TextSize = 11;
    TextLabel2.TextColor3 = u11 or u10;
    TextLabel2.Font = GothamBold or GothamMedium;
    TextLabel2.TextXAlignment = Center or Enum.TextXAlignment.Left;
    TextLabel2.Parent = Frame5;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "PlayerList";
    ScrollingFrame.Size = UDim2.new(1, -6, 1, -30);
    ScrollingFrame.Position = UDim2.new(0, 3, 0, 26);
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BorderSizePixel = 0;
    ScrollingFrame.ScrollBarThickness = 3;
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120);
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0);
    ScrollingFrame.Parent = Frame5;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Padding = UDim.new(0, 2);
    UIListLayout.SortOrder = Enum.SortOrder.Name;
    UIListLayout.Parent = ScrollingFrame;
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 260
        -- upvalues: ScrollingFrame (copy), UIListLayout (copy)
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 4);
    end);
    local UIPadding = Instance.new("UIPadding");
    UIPadding.PaddingTop = UDim.new(0, 2);
    UIPadding.PaddingLeft = UDim.new(0, 2);
    UIPadding.PaddingRight = UDim.new(0, 2);
    UIPadding.Parent = ScrollingFrame;
    local ScrollingFrame2 = Instance.new("ScrollingFrame");
    ScrollingFrame2.Name = "RightScroll";
    ScrollingFrame2.Size = UDim2.new(1, -168, 1, 0);
    ScrollingFrame2.Position = UDim2.new(0, 166, 0, 0);
    ScrollingFrame2.BackgroundTransparency = 1;
    ScrollingFrame2.BorderSizePixel = 0;
    ScrollingFrame2.ScrollBarThickness = 3;
    ScrollingFrame2.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120);
    ScrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0);
    ScrollingFrame2.Parent = Frame4;
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Padding = UDim.new(0, 6);
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.Parent = ScrollingFrame2;
    UIListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 279
        -- upvalues: ScrollingFrame2 (copy), UIListLayout2 (copy)
        ScrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, UIListLayout2.AbsoluteContentSize.Y + 6);
    end);
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.PaddingTop = UDim.new(0, 3);
    UIPadding2.PaddingRight = UDim.new(0, 3);
    UIPadding2.Parent = ScrollingFrame2;

    local function makeSection(p69, p70) -- Line: 285
        -- upvalues: u3 (ref), ScrollingFrame2 (copy)
        local Frame6 = Instance.new("Frame");
        Frame6.Size = UDim2.new(1, 0, 0, p70);
        Frame6.LayoutOrder = p69;
        Frame6.BackgroundColor3 = u3;
        Frame6.BorderSizePixel = 0;
        local UICorner5 = Instance.new("UICorner");
        UICorner5.CornerRadius = UDim.new(0, 6);
        UICorner5.Parent = Frame6;
        Frame6.Parent = ScrollingFrame2;

        return Frame6;
    end;

    local Frame6 = Instance.new("Frame");
    Frame6.Size = UDim2.new(1, 0, 0, 112);
    Frame6.LayoutOrder = 1;
    Frame6.BackgroundColor3 = u3;
    Frame6.BorderSizePixel = 0;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.CornerRadius = UDim.new(0, 6);
    UICorner5.Parent = Frame6;
    Frame6.Parent = ScrollingFrame2;
    local v71 = UDim2.new(1, -10, 0, 20);
    local v72 = UDim2.new(0, 10, 0, 6);
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "T";
    TextLabel3.Size = v71;
    TextLabel3.Position = v72;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.Text = "Spectate";
    TextLabel3.TextSize = 13;
    TextLabel3.TextColor3 = u10 or u10;
    TextLabel3.Font = GothamBold or GothamMedium;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.Parent = Frame6;
    local v73 = UDim2.new(1, -10, 0, 16);
    local v74 = UDim2.new(0, 10, 0, 28);
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Target";
    TextLabel4.Size = v73;
    TextLabel4.Position = v74;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.Text = "No target";
    TextLabel4.TextSize = 11;
    TextLabel4.TextColor3 = u11 or u10;
    TextLabel4.Font = GothamMedium or GothamMedium;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.Parent = Frame6;
    local Frame7 = Instance.new("Frame");
    Frame7.Size = UDim2.new(1, -20, 0, 28);
    Frame7.Position = UDim2.new(0, 10, 0, 48);
    Frame7.BackgroundTransparency = 1;
    Frame7.Parent = Frame6;
    local v75 = btn(Frame7, "Go", "▶ Spectate", UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0), u7, Color3.new(1, 1, 1));
    local v76 = btn(Frame7, "Stop", "■ Stop", UDim2.new(0.48, 0, 1, 0), UDim2.new(0.52, 0, 0, 0), u8, Color3.new(1, 1, 1));
    local Frame8 = Instance.new("Frame");
    Frame8.Size = UDim2.new(1, -20, 0, 26);
    Frame8.Position = UDim2.new(0, 10, 0, 80);
    Frame8.BackgroundTransparency = 1;
    Frame8.Parent = Frame6;
    local v77 = btn(Frame8, "Prev", "◄", UDim2.new(0, 40, 1, 0), UDim2.new(0, 0, 0, 0), u9, Color3.new(1, 1, 1));
    local v78 = btn(Frame8, "Next", "►", UDim2.new(0, 40, 1, 0), UDim2.new(1, -40, 0, 0), u9, Color3.new(1, 1, 1));
    local Frame9 = Instance.new("Frame");
    Frame9.Size = UDim2.new(1, 0, 0, 90);
    Frame9.LayoutOrder = 2;
    Frame9.BackgroundColor3 = u3;
    Frame9.BorderSizePixel = 0;
    local UICorner6 = Instance.new("UICorner");
    UICorner6.CornerRadius = UDim.new(0, 6);
    UICorner6.Parent = Frame9;
    Frame9.Parent = ScrollingFrame2;
    local v79 = UDim2.new(1, -10, 0, 20);
    local v80 = UDim2.new(0, 10, 0, 6);
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "T";
    TextLabel5.Size = v79;
    TextLabel5.Position = v80;
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.Text = "Freecam";
    TextLabel5.TextSize = 13;
    TextLabel5.TextColor3 = u10 or u10;
    TextLabel5.Font = GothamBold or GothamMedium;
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel5.Parent = Frame9;
    local u81 = btn(Frame9, "Toggle", "Enable", UDim2.new(0.5, -14, 0, 28), UDim2.new(0, 10, 0, 30), u7, Color3.new(1, 1, 1));
    local Frame10 = Instance.new("Frame");
    Frame10.Size = UDim2.new(0.5, -14, 0, 28);
    Frame10.Position = UDim2.new(0.5, 4, 0, 30);
    Frame10.BackgroundTransparency = 1;
    Frame10.Parent = Frame9;
    local v82 = btn(Frame10, "Minus", "−", UDim2.new(0, 26, 1, 0), UDim2.new(0, 0, 0, 0), u4);
    local v83 = UDim2.new(1, -56, 1, 0);
    local v84 = UDim2.new(0, 28, 0, 0);
    local Center2 = Enum.TextXAlignment.Center;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "Val";
    TextLabel6.Size = v83;
    TextLabel6.Position = v84;
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.Text = "20";
    TextLabel6.TextSize = 12;
    TextLabel6.TextColor3 = u10 or u10;
    TextLabel6.Font = GothamBold or GothamMedium;
    TextLabel6.TextXAlignment = Center2 or Enum.TextXAlignment.Left;
    TextLabel6.Parent = Frame10;
    local v85 = btn(Frame10, "Plus", "+", UDim2.new(0, 26, 1, 0), UDim2.new(1, -26, 0, 0), u4);
    local v86 = UDim2.new(1, -10, 0, 14);
    local v87 = UDim2.new(0, 8, 1, -16);
    local Center3 = Enum.TextXAlignment.Center;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "Hint";
    TextLabel7.Size = v86;
    TextLabel7.Position = v87;
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.Text = "RMB look  ·  WASD/Q/E move  ·  Shift fast";
    TextLabel7.TextSize = 9;
    TextLabel7.TextColor3 = u11 or u10;
    TextLabel7.Font = GothamMedium or GothamMedium;
    TextLabel7.TextXAlignment = Center3 or Enum.TextXAlignment.Left;
    TextLabel7.Parent = Frame9;
    local Frame11 = Instance.new("Frame");
    Frame11.Size = UDim2.new(1, 0, 0, 36);
    Frame11.LayoutOrder = 3;
    Frame11.BackgroundColor3 = u3;
    Frame11.BorderSizePixel = 0;
    local UICorner7 = Instance.new("UICorner");
    UICorner7.CornerRadius = UDim.new(0, 6);
    UICorner7.Parent = Frame11;
    Frame11.Parent = ScrollingFrame2;
    Frame11.Visible = false;
    local Frame12 = Instance.new("Frame");
    Frame12.Size = UDim2.new(1, -14, 0, 20);
    Frame12.Position = UDim2.new(0, 10, 0, 6);
    Frame12.BackgroundTransparency = 1;
    Frame12.Parent = Frame11;
    local UIListLayout3 = Instance.new("UIListLayout");
    UIListLayout3.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout3.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout3.Padding = UDim.new(0, 6);
    UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout3.Parent = Frame12;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.LayoutOrder = 1;
    TextLabel8.AutomaticSize = Enum.AutomaticSize.X;
    TextLabel8.Size = UDim2.new(0, 0, 1, 0);
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.Text = "Troll Actions";
    TextLabel8.TextSize = 13;
    TextLabel8.Font = GothamBold;
    TextLabel8.TextColor3 = u10;
    TextLabel8.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel8.Parent = Frame12;
    local TextLabel9 = Instance.new("TextLabel");
    TextLabel9.LayoutOrder = 2;
    TextLabel9.AutomaticSize = Enum.AutomaticSize.X;
    TextLabel9.Size = UDim2.new(0, 0, 1, 0);
    TextLabel9.BackgroundTransparency = 1;
    TextLabel9.Text = "";
    TextLabel9.TextSize = 12;
    TextLabel9.Font = GothamBold;
    TextLabel9.TextColor3 = u8;
    TextLabel9.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel9.Visible = false;
    TextLabel9.Parent = Frame12;
    local v88 = #GiftTreadmillConfig.TREADMILLS * 52 + 82 + 10;
    local Frame13 = Instance.new("Frame");
    Frame13.Size = UDim2.new(1, 0, 0, v88);
    Frame13.LayoutOrder = 4;
    Frame13.BackgroundColor3 = u3;
    Frame13.BorderSizePixel = 0;
    local UICorner8 = Instance.new("UICorner");
    UICorner8.CornerRadius = UDim.new(0, 6);
    UICorner8.Parent = Frame13;
    Frame13.Parent = ScrollingFrame2;
    local v89 = UDim2.new(1, -60, 0, 20);
    local v90 = UDim2.new(0, 10, 0, 6);
    local TextLabel10 = Instance.new("TextLabel");
    TextLabel10.Name = "T";
    TextLabel10.Size = v89;
    TextLabel10.Position = v90;
    TextLabel10.BackgroundTransparency = 1;
    TextLabel10.Text = "Gift Treadmill";
    TextLabel10.TextSize = 13;
    TextLabel10.TextColor3 = u10 or u10;
    TextLabel10.Font = GothamBold or GothamMedium;
    TextLabel10.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel10.Parent = Frame13;
    local v91 = UDim2.new(1, -10, 0, 16);
    local v92 = UDim2.new(0, 10, 0, 28);
    local TextLabel11 = Instance.new("TextLabel");
    TextLabel11.Name = "Target";
    TextLabel11.Size = v91;
    TextLabel11.Position = v92;
    TextLabel11.BackgroundTransparency = 1;
    TextLabel11.Text = "No target";
    TextLabel11.TextSize = 11;
    TextLabel11.TextColor3 = u11 or u10;
    TextLabel11.Font = GothamMedium or GothamMedium;
    TextLabel11.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel11.Parent = Frame13;
    local Frame14 = Instance.new("Frame");
    Frame14.Size = UDim2.new(1, -20, 0, 24);
    Frame14.Position = UDim2.new(0, 10, 0, 48);
    Frame14.BackgroundTransparency = 1;
    Frame14.Parent = Frame13;
    local TextBox = Instance.new("TextBox");
    TextBox.Size = UDim2.new(1, -36, 1, 0);
    TextBox.Position = UDim2.new(0, 0, 0, 0);
    TextBox.BackgroundColor3 = u4;
    TextBox.TextColor3 = u10;
    TextBox.PlaceholderText = "Username ou UserId...";
    TextBox.PlaceholderColor3 = u11;
    TextBox.Text = "";
    TextBox.TextSize = 12;
    TextBox.Font = GothamMedium;
    TextBox.BorderSizePixel = 0;
    TextBox.ClearTextOnFocus = false;
    local UICorner9 = Instance.new("UICorner");
    UICorner9.CornerRadius = UDim.new(0, 4);
    UICorner9.Parent = TextBox;
    TextBox.Parent = Frame14;
    local u93 = btn(Frame14, "Confirm", "→", UDim2.new(0, 30, 1, 0), UDim2.new(1, -30, 0, 0), u9, Color3.new(1, 1, 1));
    local v94 = btn(Frame13, "Refresh", "↺", UDim2.new(0, 26, 0, 20), UDim2.new(1, -32, 0, 6), u4);
    local v95 = UDim2.new(1, -10, 0, 20);
    local v96 = UDim2.new(0, 10, 0, 80);
    local Center4 = Enum.TextXAlignment.Center;
    local TextLabel12 = Instance.new("TextLabel");
    TextLabel12.Name = "NoPerm";
    TextLabel12.Size = v95;
    TextLabel12.Position = v96;
    TextLabel12.BackgroundTransparency = 1;
    TextLabel12.Text = "No gift permission";
    TextLabel12.TextSize = 11;
    TextLabel12.TextColor3 = u11 or u10;
    TextLabel12.Font = GothamMedium or GothamMedium;
    TextLabel12.TextXAlignment = Center4 or Enum.TextXAlignment.Left;
    TextLabel12.Parent = Frame13;
    TextLabel12.Visible = false;
    local u97 = {};

    for i, v in GiftTreadmillConfig.TREADMILLS do
        local v98 = 78 + (i - 1) * 52;
        local v99 = btn(Frame13, "Btn_" .. v.tag, v.label, UDim2.new(1, -76, 0, 28), UDim2.new(0, 10, 0, v98), u9, Color3.new(1, 1, 1));
        local TextLabel13 = Instance.new("TextLabel");
        TextLabel13.Name = "Badge_" .. v.tag;
        TextLabel13.Size = UDim2.new(0, 58, 0, 28);
        TextLabel13.Position = UDim2.new(1, -66, 0, v98);
        TextLabel13.BackgroundColor3 = u4;
        TextLabel13.BorderSizePixel = 0;
        TextLabel13.Text = "...";
        TextLabel13.TextSize = 11;
        TextLabel13.Font = GothamBold;
        TextLabel13.TextColor3 = u10;
        TextLabel13.TextXAlignment = Enum.TextXAlignment.Center;
        local UICorner10 = Instance.new("UICorner");
        UICorner10.CornerRadius = UDim.new(0, 5);
        UICorner10.Parent = TextLabel13;
        TextLabel13.Parent = Frame13;
        local v100 = "Timer_" .. v.tag;
        local v101 = UDim2.new(1, -76, 0, 14);
        local v102 = UDim2.new(0, 10, 0, v98 + 30);
        local TextLabel14 = Instance.new("TextLabel");
        TextLabel14.Name = v100;
        TextLabel14.Size = v101;
        TextLabel14.Position = v102;
        TextLabel14.BackgroundTransparency = 1;
        TextLabel14.Text = "";
        TextLabel14.TextSize = 10;
        TextLabel14.TextColor3 = u11 or u10;
        TextLabel14.Font = GothamMedium or GothamMedium;
        TextLabel14.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel14.Parent = Frame13;
        local v103 = TextLabel14;
        v103.Visible = false;
        table.insert(u97, {
            _periodStart = 0,
            _periodSeconds = 0,
            btn = v99,
            badge = TextLabel13,
            timerLbl = v103,
            tag = v.tag
        });
    end;

    local Frame15 = Instance.new("Frame");
    Frame15.Size = UDim2.new(1, 0, 0, 66);
    Frame15.LayoutOrder = 5;
    Frame15.BackgroundColor3 = u3;
    Frame15.BorderSizePixel = 0;
    local UICorner10 = Instance.new("UICorner");
    UICorner10.CornerRadius = UDim.new(0, 6);
    UICorner10.Parent = Frame15;
    Frame15.Parent = ScrollingFrame2;
    Frame15.Visible = false;
    local v104 = UDim2.new(1, -10, 0, 20);
    local v105 = UDim2.new(0, 10, 0, 6);
    local TextLabel13 = Instance.new("TextLabel");
    TextLabel13.Name = "T";
    TextLabel13.Size = v104;
    TextLabel13.Position = v105;
    TextLabel13.BackgroundTransparency = 1;
    TextLabel13.Text = "🍬 Candy — Self Gift";
    TextLabel13.TextSize = 13;
    TextLabel13.TextColor3 = u10 or u10;
    TextLabel13.Font = GothamBold or GothamMedium;
    TextLabel13.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel13.Parent = Frame15;
    local u106 = btn(Frame15, "SelfGift", "Gift to myself", UDim2.new(1, -20, 0, 28), UDim2.new(0, 10, 0, 30), u9, Color3.new(1, 1, 1));

    local function applySelfGiftState(p107) -- Line: 443
        -- upvalues: Frame15 (copy), u106 (copy), u8 (ref), u9 (ref)
        if not p107.success then
            Frame15.Visible = false;

            return;
        end;

        Frame15.Visible = true;

        if p107.hasCandy then
            u106.Text = "✓ Already owned";
            u106.BackgroundColor3 = u8;
            u106:SetAttribute("locked", true);

            return;
        end;

        u106.Text = "Gift to myself";
        u106.BackgroundColor3 = u9;
        u106:SetAttribute("locked", false);
    end;

    local v108 = UDim2.new(1, -20, 0, 20);
    local v109 = UDim2.new(0, 10, 1, -24);
    local TextLabel14 = Instance.new("TextLabel");
    TextLabel14.Name = "Status";
    TextLabel14.Size = v108;
    TextLabel14.Position = v109;
    TextLabel14.BackgroundTransparency = 1;
    TextLabel14.Text = "";
    TextLabel14.TextSize = 11;
    TextLabel14.TextColor3 = u7 or u10;
    TextLabel14.Font = GothamMedium or GothamMedium;
    TextLabel14.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel14.Parent = Frame;

    local function setStatus(u110, p111) -- Line: 466
        -- upvalues: TextLabel14 (copy), u8 (ref), u7 (ref)
        TextLabel14.Text = u110;
        TextLabel14.TextColor3 = p111 and u8 or u7;
        task.delay(3, function() -- Line: 469
            -- upvalues: TextLabel14 (ref), u110 (copy)
            if TextLabel14.Text == u110 then
                TextLabel14.Text = "";
            end;
        end);
    end;

    local u112 = nil;
    local u113 = {};
    local u114 = nil;

    local function syncSpecTarget() -- Line: 476
        -- upvalues: TextLabel4 (copy), u31 (ref)
        TextLabel4.Text = u31 and "▶ " .. u31.Name or "No target";
    end;

    local function applyGiftState(p115) -- Line: 481
        -- upvalues: TextLabel12 (copy), u97 (copy), u7 (ref), u8 (ref), u9 (ref), formatTimeRemaining (ref)
        if not p115.success then
            TextLabel12.Text = p115.error or "Unavailable";
            TextLabel12.Visible = true;

            for _, v in u97 do
                v.btn.Visible = false;
                v.badge.Visible = false;
                v.timerLbl.Visible = false;
            end;

            return;
        end;

        TextLabel12.Visible = false;

        for _, v in u97 do
            v.btn.Visible = true;
            v.badge.Visible = true;
        end;

        for _, v in p115.treadmills do
            for _, v2 in u97 do
                if v2.tag == v.tag then
                    local v116 = v.remaining > 0;
                    v2.badge.Text = v.remaining .. "/" .. v.quota;
                    v2.badge.TextColor3 = v116 and u7 or u8;
                    v2.btn.BackgroundColor3 = v116 and u9 or u8;
                    v2.btn:SetAttribute("locked", not v116);
                    v2._periodStart = v.periodStart or 0;
                    v2._periodSeconds = v.periodSeconds or 0;
                    local v117 = formatTimeRemaining(v2._periodStart, v2._periodSeconds);
                    v2.timerLbl.Text = v117;
                    v2.timerLbl.Visible = v117 ~= "";
                    break;
                end;
            end;
        end;
    end;

    local function refreshSelfCandyState() -- Line: 513
        -- upvalues: Remotes (ref), Frame15 (copy), u106 (copy), u8 (ref), u9 (ref)
        task.spawn(function() -- Line: 514
            -- upvalues: Remotes (ref), Frame15 (ref), u106 (ref), u8 (ref), u9 (ref)
            local v118 = Remotes.Functions.getSelfCandyState:InvokeServer();

            if not v118.success then
                Frame15.Visible = false;

                return;
            end;

            Frame15.Visible = true;

            if v118.hasCandy then
                u106.Text = "✓ Already owned";
                u106.BackgroundColor3 = u8;
                u106:SetAttribute("locked", true);

                return;
            end;

            u106.Text = "Gift to myself";
            u106.BackgroundColor3 = u9;
            u106:SetAttribute("locked", false);
        end);
    end;

    local function refreshGiftState() -- Line: 520
        -- upvalues: Remotes (ref), applyGiftState (copy), Frame15 (copy), u106 (copy), u8 (ref), u9 (ref)
        task.spawn(function() -- Line: 521
            -- upvalues: Remotes (ref), applyGiftState (ref)
            applyGiftState((Remotes.Functions.getGiftTreadmillState:InvokeServer()));
        end);
        task.spawn(function() -- Line: 514
            -- upvalues: Remotes (ref), Frame15 (ref), u106 (ref), u8 (ref), u9 (ref)
            local v119 = Remotes.Functions.getSelfCandyState:InvokeServer();

            if not v119.success then
                Frame15.Visible = false;

                return;
            end;

            Frame15.Visible = true;

            if v119.hasCandy then
                u106.Text = "✓ Already owned";
                u106.BackgroundColor3 = u8;
                u106:SetAttribute("locked", true);

                return;
            end;

            u106.Text = "Gift to myself";
            u106.BackgroundColor3 = u9;
            u106:SetAttribute("locked", false);
        end);
    end;

    u62 = refreshGiftState;
    local u120 = 0;
    local u121 = {};
    local u122 = nil;

    local function startTrollCooldownUI() -- Line: 535
        -- upvalues: u122 (ref), u121 (ref), u4 (ref), TextLabel9 (ref), RunService (ref), u9 (ref)
        if u122 then
            u122:Disconnect();
            u122 = nil;
        end;

        local u123 = tick();

        for _, v in u121 do
            v.BackgroundColor3 = u4;
            v:SetAttribute("locked", true);
        end;

        TextLabel9.Text = "⏳ " .. 10 .. "s";
        TextLabel9.Visible = true;
        u122 = RunService.Heartbeat:Connect(function() -- Line: 546
            -- upvalues: u123 (copy), u122 (ref), TextLabel9 (ref), u121 (ref), u9 (ref)
            local v124 = 10 - (tick() - u123);

            if v124 > 0 then
                TextLabel9.Text = "⏳ " .. math.ceil(v124) .. "s";

                return;
            end;

            u122:Disconnect();
            u122 = nil;
            TextLabel9.Visible = false;

            for _, v in u121 do
                v.BackgroundColor3 = u9;
                v:SetAttribute("locked", false);
            end;
        end);
    end;

    local function applyTrollState(p125) -- Line: 561
        -- upvalues: u121 (ref), Frame11 (copy), u120 (ref), btn (ref), u4 (ref), u9 (ref), u112 (ref), TextLabel14 (copy), u8 (ref), u7 (ref), startTrollCooldownUI (copy), Remotes (ref)
        u121 = {};

        for _, child in Frame11:GetChildren() do
            if child:IsA("TextButton") then
                child:Destroy();
            end;
        end;

        if not p125.success then
            Frame11.Visible = false;

            return;
        end;

        local v126 = p125.actions or {};
        local v127 = math.ceil(#v126 / 2) * 32 + 28 + 6;
        Frame11.Size = UDim2.new(1, 0, 0, v127);
        Frame11.Visible = true;
        local v128 = tick() - u120 < 10;

        for i, v in ipairs(v126) do
            local v129 = math.floor((i - 1) / 2);
            local v130 = (i - 1) % 2 == 0 and UDim2.new(0, 10, 0, 0) or UDim2.new(0.5, 3, 0, 0);
            local v131 = btn(Frame11, "Troll_" .. v.id, v.label, UDim2.new(0.5, -7, 0, 26), UDim2.new(v130.X.Scale, v130.X.Offset, 0, v129 * 32 + 28), v128 and u4 or u9, Color3.new(1, 1, 1));

            if v128 then
                v131:SetAttribute("locked", true);
            end;

            table.insert(u121, v131);
            v131.MouseButton1Click:Connect(function() -- Line: 586
                -- upvalues: u112 (ref), TextLabel14 (ref), u8 (ref), u7 (ref), u120 (ref), startTrollCooldownUI (ref), Remotes (ref), v (copy)
                if not (u112 and u112.Parent) then
                    TextLabel14.Text = "Select a player first";
                    TextLabel14.TextColor3 = u8 or u7;
                    local u132 = "Select a player first";
                    task.delay(3, function() -- Line: 469
                        -- upvalues: TextLabel14 (ref), u132 (copy)
                        if TextLabel14.Text == u132 then
                            TextLabel14.Text = "";
                        end;
                    end);

                    return;
                end;

                local v133 = tick();

                if v133 - u120 < 10 then
                    return;
                end;

                u120 = v133;
                startTrollCooldownUI();
                Remotes.Events.ccTrollAction:FireServer(v.id, u112.UserId);
                local u134 = v.label .. " → " .. u112.Name;
                TextLabel14.Text = u134;
                TextLabel14.TextColor3 = u7;
                task.delay(3, function() -- Line: 469
                    -- upvalues: TextLabel14 (ref), u134 (copy)
                    if TextLabel14.Text == u134 then
                        TextLabel14.Text = "";
                    end;
                end);
            end);
        end;
    end;

    u63 = function() -- Line: 601, Name: refreshTrollState
        -- upvalues: Remotes (ref), applyTrollState (copy)
        task.spawn(function() -- Line: 602
            -- upvalues: Remotes (ref), applyTrollState (ref)
            applyTrollState((Remotes.Functions.getTrollState:InvokeServer()));
        end);
    end;

    u106.MouseButton1Click:Connect(function() -- Line: 609
        -- upvalues: u106 (copy), Remotes (ref), TextLabel14 (copy), u7 (ref), NotificationSystem (ref), u8 (ref)
        if u106:GetAttribute("locked") then
            return;
        end;

        u106.Active = false;
        local v135 = Remotes.Functions.selfGiftCandy:InvokeServer();
        u106.Active = true;

        if not v135.success then
            local u136 = v135.error or "Self gift failed";
            TextLabel14.Text = u136;
            TextLabel14.TextColor3 = u8 or u7;
            task.delay(3, function() -- Line: 469
                -- upvalues: TextLabel14 (ref), u136 (copy)
                if TextLabel14.Text == u136 then
                    TextLabel14.Text = "";
                end;
            end);
            NotificationSystem:ShowMessage("✗ " .. (v135.error or "Self gift failed"), Color3.fromRGB(255, 60, 60));

            return;
        end;

        TextLabel14.Text = "🍬 Candy Treadmill gifted to yourself!";
        TextLabel14.TextColor3 = u7;
        local u137 = "🍬 Candy Treadmill gifted to yourself!";
        task.delay(3, function() -- Line: 469
            -- upvalues: TextLabel14 (ref), u137 (copy)
            if TextLabel14.Text == u137 then
                TextLabel14.Text = "";
            end;
        end);
        NotificationSystem:ShowMessage("🍬 Candy Treadmill gifté !", Color3.fromRGB(255, 67, 199));
        u106.Text = "✓ Already owned";
        u106.BackgroundColor3 = u8;
        u106:SetAttribute("locked", true);
    end);
    task.spawn(function() -- Line: 627
        -- upvalues: ScreenGui (copy), u97 (copy), formatTimeRemaining (ref)
        while ScreenGui.Parent do
            task.wait(10);

            for _, v in u97 do
                if v._periodStart > 0 and v.timerLbl.Parent then
                    local v138 = formatTimeRemaining(v._periodStart, v._periodSeconds);
                    v.timerLbl.Text = v138;
                    v.timerLbl.Visible = v138 ~= "";
                end;
            end;
        end;
    end);

    for _, v in u97 do
        v.btn.MouseButton1Click:Connect(function() -- Line: 641
            -- upvalues: v (copy), u114 (ref), u112 (ref), TextLabel14 (copy), u8 (ref), u7 (ref), Remotes (ref), NotificationSystem (ref), TextLabel11 (copy), refreshGiftState (copy)
            if v.btn:GetAttribute("locked") then
                return;
            end;

            local v139, v140;

            if u114 then
                v139 = u114.userId;
                v140 = u114.name;
            else
                if not (u112 and u112.Parent) then
                    TextLabel14.Text = "Sélectionner un joueur d\'abord";
                    TextLabel14.TextColor3 = u8 or u7;
                    local u141 = "Sélectionner un joueur d\'abord";
                    task.delay(3, function() -- Line: 469
                        -- upvalues: TextLabel14 (ref), u141 (copy)
                        if TextLabel14.Text == u141 then
                            TextLabel14.Text = "";
                        end;
                    end);

                    return;
                end;

                v139 = u112.UserId;
                v140 = u112.Name;
            end;

            v.btn.Active = false;
            local v142 = Remotes.Functions.giftTreadmill:InvokeServer(v.tag, v139, v140);
            v.btn.Active = true;

            if not v142.success then
                local u143 = v142.error or "Gift failed";
                TextLabel14.Text = u143;
                TextLabel14.TextColor3 = u8 or u7;
                task.delay(3, function() -- Line: 469
                    -- upvalues: TextLabel14 (ref), u143 (copy)
                    if TextLabel14.Text == u143 then
                        TextLabel14.Text = "";
                    end;
                end);
                NotificationSystem:ShowMessage("✗ " .. (v142.error or "Gift failed"), Color3.fromRGB(255, 60, 60));

                return;
            end;

            local v144 = v142.offline and " (offline)" or "";
            local u145 = "Gifted " .. v142.label .. " → " .. v142.targetName .. v144 .. "  (" .. v142.remaining .. " left)";
            TextLabel14.Text = u145;
            TextLabel14.TextColor3 = u7;
            task.delay(3, function() -- Line: 469
                -- upvalues: TextLabel14 (ref), u145 (copy)
                if TextLabel14.Text == u145 then
                    TextLabel14.Text = "";
                end;
            end);
            NotificationSystem:ShowMessage("✓ " .. v142.label .. " → " .. v142.targetName .. v144, Color3.fromRGB(0, 220, 110));
            v.badge.Text = v142.remaining .. "/" .. (v142.quota or "?");
            v.badge.TextColor3 = v142.remaining > 0 and u7 or u8;

            if v142.remaining == 0 then
                v.btn.BackgroundColor3 = u8;
                v.btn:SetAttribute("locked", true);
            end;

            if v142.offline then
                u114 = nil;
                TextLabel11.Text = "No target";
            end;

            task.spawn(refreshGiftState);
        end);
    end;

    local function resolveOfflineTarget(p146) -- Line: 679
        -- upvalues: u93 (copy), TextLabel14 (copy), u7 (ref), Players (ref), u8 (ref), u114 (ref), u112 (ref), u113 (ref), u4 (ref), TextLabel11 (copy), TextBox (copy)
        local u147 = string.match(p146, "^%s*(.-)%s*$") or "";

        if u147 == "" then
            return;
        end;

        u93.Active = false;
        TextLabel14.Text = "Résolution en cours…";
        TextLabel14.TextColor3 = u7;
        local u148 = "Résolution en cours…";
        task.delay(3, function() -- Line: 469
            -- upvalues: TextLabel14 (ref), u148 (copy)
            if TextLabel14.Text == u148 then
                TextLabel14.Text = "";
            end;
        end);
        task.spawn(function() -- Line: 684
            -- upvalues: u147 (ref), Players (ref), u93 (ref), TextLabel14 (ref), u8 (ref), u7 (ref), u114 (ref), u112 (ref), u113 (ref), u4 (ref), TextLabel11 (ref), TextBox (ref)
            local u149 = tonumber(u147);
            local v150;

            if u149 then
                local v151;
                v151, v150 = pcall(function() -- Line: 689
                    -- upvalues: Players (ref), u149 (copy)
                    return Players:GetNameFromUserIdAsync(u149);
                end);

                if not v151 then
                    u93.Active = true;
                    TextLabel14.Text = "UserId introuvable";
                    TextLabel14.TextColor3 = u8 or u7;
                    local u152 = "UserId introuvable";
                    task.delay(3, function() -- Line: 469
                        -- upvalues: TextLabel14 (ref), u152 (copy)
                        if TextLabel14.Text == u152 then
                            TextLabel14.Text = "";
                        end;
                    end);

                    return;
                end;
            else
                local v153;
                v153, u149 = pcall(function() -- Line: 696
                    -- upvalues: Players (ref), u147 (ref)
                    return Players:GetUserIdFromNameAsync(u147);
                end);

                if not v153 then
                    u93.Active = true;
                    TextLabel14.Text = "Username introuvable";
                    TextLabel14.TextColor3 = u8 or u7;
                    local u154 = "Username introuvable";
                    task.delay(3, function() -- Line: 469
                        -- upvalues: TextLabel14 (ref), u154 (copy)
                        if TextLabel14.Text == u154 then
                            TextLabel14.Text = "";
                        end;
                    end);

                    return;
                end;

                v150 = u147;
            end;

            u114 = {
                userId = u149,
                name = v150
            };

            if u112 and u113[u112] then
                u113[u112].BackgroundColor3 = u4;
            end;

            u112 = nil;
            TextLabel11.Text = "→ " .. v150 .. " (offline)";
            TextBox.Text = "";
            u93.Active = true;
            local u155 = "Cible offline : " .. v150 .. " [" .. u149 .. "]";
            TextLabel14.Text = u155;
            TextLabel14.TextColor3 = u7;
            task.delay(3, function() -- Line: 469
                -- upvalues: TextLabel14 (ref), u155 (copy)
                if TextLabel14.Text == u155 then
                    TextLabel14.Text = "";
                end;
            end);
        end);
    end;

    u93.MouseButton1Click:Connect(function() -- Line: 715
        -- upvalues: resolveOfflineTarget (copy), TextBox (copy)
        resolveOfflineTarget(TextBox.Text);
    end);
    TextBox.FocusLost:Connect(function(p156) -- Line: 718
        -- upvalues: resolveOfflineTarget (copy), TextBox (copy)
        if p156 then
            resolveOfflineTarget(TextBox.Text);
        end;
    end);
    v94.MouseButton1Click:Connect(refreshGiftState);

    local function buildPlayerList() -- Line: 725
        -- upvalues: ScrollingFrame (copy), u113 (ref), Players (ref), LocalPlayer (ref), u112 (ref), u31 (ref), u6 (ref), u4 (ref), GothamMedium (ref), u10 (ref), u5 (ref), u114 (ref), TextLabel11 (copy), u11 (ref)
        for _, child in ScrollingFrame:GetChildren() do
            if not (child:IsA("UIListLayout") or child:IsA("UIPadding")) then
                child:Destroy();
            end;
        end;

        u113 = {};
        local v157 = false;

        for _, v in Players:GetPlayers() do
            if v ~= LocalPlayer then
                local TextButton2 = Instance.new("TextButton");
                TextButton2.Name = v.Name;
                TextButton2.Size = UDim2.new(1, 0, 0, 30);
                TextButton2.BackgroundColor3 = (u112 == v or u31 == v) and u6 or u4;
                TextButton2.Text = v.Name;
                TextButton2.TextSize = 12;
                TextButton2.Font = GothamMedium;
                TextButton2.TextColor3 = u10;
                TextButton2.BorderSizePixel = 0;
                TextButton2.AutoButtonColor = false;
                TextButton2.TextTruncate = Enum.TextTruncate.AtEnd;
                local UICorner11 = Instance.new("UICorner");
                UICorner11.CornerRadius = UDim.new(0, 4);
                UICorner11.Parent = TextButton2;
                TextButton2.Parent = ScrollingFrame;
                u113[v] = TextButton2;
                TextButton2.MouseEnter:Connect(function() -- Line: 741
                    -- upvalues: u112 (ref), v (copy), TextButton2 (copy), u5 (ref)
                    if u112 ~= v then
                        TextButton2.BackgroundColor3 = u5;
                    end;
                end);
                TextButton2.MouseLeave:Connect(function() -- Line: 742
                    -- upvalues: u112 (ref), v (copy), TextButton2 (copy), u4 (ref)
                    if u112 ~= v then
                        TextButton2.BackgroundColor3 = u4;
                    end;
                end);
                TextButton2.MouseButton1Click:Connect(function() -- Line: 743
                    -- upvalues: u112 (ref), u113 (ref), u4 (ref), u114 (ref), v (copy), TextButton2 (copy), u6 (ref), TextLabel11 (ref)
                    if u112 and u113[u112] then
                        u113[u112].BackgroundColor3 = u4;
                    end;

                    u114 = nil;
                    u112 = v;
                    TextButton2.BackgroundColor3 = u6;
                    TextLabel11.Text = "→ " .. v.Name;
                end);
                v157 = true;
            end;
        end;

        if not v157 then
            local v158 = UDim2.new(1, 0, 0, 28);
            local v159 = UDim2.new(0, 0, 0, 0);
            local Center5 = Enum.TextXAlignment.Center;
            local TextLabel15 = Instance.new("TextLabel");
            TextLabel15.Name = "Empty";
            TextLabel15.Size = v158;
            TextLabel15.Position = v159;
            TextLabel15.BackgroundTransparency = 1;
            TextLabel15.Text = "No players";
            TextLabel15.TextSize = 11;
            TextLabel15.TextColor3 = u11 or u10;
            TextLabel15.Font = GothamMedium or GothamMedium;
            TextLabel15.TextXAlignment = Center5 or Enum.TextXAlignment.Left;
            TextLabel15.Parent = ScrollingFrame;
        end;
    end;

    u61 = buildPlayerList;

    local function syncFcBtn() -- Line: 760
        -- upvalues: u81 (copy), u41 (ref), u8 (ref), u7 (ref)
        u81.Text = u41 and "Disable" or "Enable";
        u81.BackgroundColor3 = u41 and u8 or u7;
    end;

    u81.MouseButton1Click:Connect(function() -- Line: 765
        -- upvalues: u41 (ref), u42 (ref), UserInputService (ref), ContextActionService (ref), CurrentCamera (ref), LocalPlayer (ref), TextLabel14 (copy), u7 (ref), enableFreecam (ref), u81 (copy), u8 (ref)
        if u41 then
            u41 = false;

            if u42 then
                u42:Disconnect();
                u42 = nil;
            end;

            UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
            ContextActionService:UnbindAction("CCPanelFreezeMovement");
            CurrentCamera.CameraType = Enum.CameraType.Custom;
            local v160 = LocalPlayer.Character and v160:FindFirstChildOfClass("Humanoid");

            if v160 then
                CurrentCamera.CameraSubject = v160;
            end;

            TextLabel14.Text = "Freecam off";
            TextLabel14.TextColor3 = u7;
            local u161 = "Freecam off";
            task.delay(3, function() -- Line: 469
                -- upvalues: TextLabel14 (ref), u161 (copy)
                if TextLabel14.Text == u161 then
                    TextLabel14.Text = "";
                end;
            end);
        else
            enableFreecam();
            TextLabel14.Text = "Freecam on  —  RMB look, WASD move";
            TextLabel14.TextColor3 = u7;
            local u162 = "Freecam on  —  RMB look, WASD move";
            task.delay(3, function() -- Line: 469
                -- upvalues: TextLabel14 (ref), u162 (copy)
                if TextLabel14.Text == u162 then
                    TextLabel14.Text = "";
                end;
            end);
        end;

        u81.Text = u41 and "Disable" or "Enable";
        u81.BackgroundColor3 = u41 and u8 or u7;
    end);
    v82.MouseButton1Click:Connect(function() -- Line: 770
        -- upvalues: u43 (ref), TextLabel6 (copy)
        u43 = math.max(5, u43 - 5);
        TextLabel6.Text = tostring(u43);
    end);
    v85.MouseButton1Click:Connect(function() -- Line: 773
        -- upvalues: u43 (ref), TextLabel6 (copy)
        u43 = math.min(200, u43 + 5);
        TextLabel6.Text = tostring(u43);
    end);
    v75.MouseButton1Click:Connect(function() -- Line: 778
        -- upvalues: u112 (ref), TextLabel14 (copy), u8 (ref), u7 (ref), startSpectate (ref), TextLabel4 (copy), u31 (ref)
        if not (u112 and u112.Parent) then
            TextLabel14.Text = "Select a player first";
            TextLabel14.TextColor3 = u8 or u7;
            local u163 = "Select a player first";
            task.delay(3, function() -- Line: 469
                -- upvalues: TextLabel14 (ref), u163 (copy)
                if TextLabel14.Text == u163 then
                    TextLabel14.Text = "";
                end;
            end);

            return;
        end;

        startSpectate(u112);
        TextLabel4.Text = u31 and "▶ " .. u31.Name or "No target";
        local u164 = "Spectate → " .. u112.Name;
        TextLabel14.Text = u164;
        TextLabel14.TextColor3 = u7;
        task.delay(3, function() -- Line: 469
            -- upvalues: TextLabel14 (ref), u164 (copy)
            if TextLabel14.Text == u164 then
                TextLabel14.Text = "";
            end;
        end);
    end);
    v76.MouseButton1Click:Connect(function() -- Line: 785
        -- upvalues: stopSpectate (ref), TextLabel4 (copy), u31 (ref), TextLabel14 (copy), u7 (ref)
        stopSpectate();
        TextLabel4.Text = u31 and "▶ " .. u31.Name or "No target";
        TextLabel14.Text = "Spectate stopped";
        TextLabel14.TextColor3 = u7;
        local u165 = "Spectate stopped";
        task.delay(3, function() -- Line: 469
            -- upvalues: TextLabel14 (ref), u165 (copy)
            if TextLabel14.Text == u165 then
                TextLabel14.Text = "";
            end;
        end);
    end);

    local function navigate(p166) -- Line: 789
        -- upvalues: Players (ref), LocalPlayer (ref), u31 (ref), startSpectate (ref), u112 (ref), u113 (ref), u4 (ref), u114 (ref), u6 (ref), TextLabel11 (copy), TextLabel4 (copy), TextLabel14 (copy), u7 (ref)
        local v167 = {};

        for _, v in Players:GetPlayers() do
            if v ~= LocalPlayer then
                table.insert(v167, v);
            end;
        end;

        if #v167 == 0 then
            return;
        end;

        local v168 = 1;

        if u31 then
            for i, v in v167 do
                if v == u31 then
                    v168 = i;
                    break;
                end;
            end;
        end;

        local v169 = v167[(v168 - 1 + p166) % #v167 + 1];
        startSpectate(v169);

        if u112 and u113[u112] then
            u113[u112].BackgroundColor3 = u4;
        end;

        u114 = nil;
        u112 = v169;

        if u113[v169] then
            u113[v169].BackgroundColor3 = u6;
        end;

        TextLabel11.Text = "→ " .. v169.Name;
        TextLabel4.Text = u31 and "▶ " .. u31.Name or "No target";
        local u170 = "Spectate → " .. v169.Name;
        TextLabel14.Text = u170;
        TextLabel14.TextColor3 = u7;
        task.delay(3, function() -- Line: 469
            -- upvalues: TextLabel14 (ref), u170 (copy)
            if TextLabel14.Text == u170 then
                TextLabel14.Text = "";
            end;
        end);
    end;

    v77.MouseButton1Click:Connect(function() -- Line: 810
        -- upvalues: navigate (copy)
        navigate(-1);
    end);
    v78.MouseButton1Click:Connect(function() -- Line: 811
        -- upvalues: navigate (copy)
        navigate(1);
    end);
    UserInputService.InputBegan:Connect(function(p171, p172) -- Line: 814
        -- upvalues: u41 (ref), u42 (ref), UserInputService (ref), ContextActionService (ref), CurrentCamera (ref), LocalPlayer (ref), u81 (copy), u8 (ref), u7 (ref), TextLabel14 (copy)
        if p172 then
            return;
        end;

        if p171.KeyCode == Enum.KeyCode.Escape and u41 then
            u41 = false;

            if u42 then
                u42:Disconnect();
                u42 = nil;
            end;

            UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
            ContextActionService:UnbindAction("CCPanelFreezeMovement");
            CurrentCamera.CameraType = Enum.CameraType.Custom;
            local v173 = LocalPlayer.Character and v173:FindFirstChildOfClass("Humanoid");

            if v173 then
                CurrentCamera.CameraSubject = v173;
            end;

            u81.Text = u41 and "Disable" or "Enable";
            u81.BackgroundColor3 = u41 and u8 or u7;
            TextLabel14.Text = "Freecam off";
            TextLabel14.TextColor3 = u7;
            local u174 = "Freecam off";
            task.delay(3, function() -- Line: 469
                -- upvalues: TextLabel14 (ref), u174 (copy)
                if TextLabel14.Text == u174 then
                    TextLabel14.Text = "";
                end;
            end);
        end;
    end);
    Players.PlayerAdded:Connect(function() -- Line: 822
        -- upvalues: ScreenGui (copy), buildPlayerList (copy)
        if ScreenGui.Enabled then
            buildPlayerList();
        end;
    end);
    Players.PlayerRemoving:Connect(function(p175) -- Line: 825
        -- upvalues: u31 (ref), stopSpectate (ref), TextLabel4 (copy), TextLabel14 (copy), u8 (ref), u7 (ref), ScreenGui (copy), buildPlayerList (copy)
        if u31 == p175 then
            stopSpectate();
            TextLabel4.Text = u31 and "▶ " .. u31.Name or "No target";
            local u176 = p175.Name .. " left";
            TextLabel14.Text = u176;
            TextLabel14.TextColor3 = u8 or u7;
            task.delay(3, function() -- Line: 469
                -- upvalues: TextLabel14 (ref), u176 (copy)
                if TextLabel14.Text == u176 then
                    TextLabel14.Text = "";
                end;
            end);
        end;

        if ScreenGui.Enabled then
            buildPlayerList();
        end;
    end);

    return ScreenGui;
end;

function v60.toggle(p177) -- Line: 833
    -- upvalues: u61 (ref), u62 (ref), u63 (ref)
    p177.Enabled = not p177.Enabled;

    if p177.Enabled then
        if u61 then
            u61();
        end;

        if u62 then
            u62();
        end;

        if u63 then
            u63();
        end;
    end;
end;

function v60.refreshGiftState() -- Line: 842
    -- upvalues: u62 (ref)
    if u62 then
        u62();
    end;
end;

return v60;