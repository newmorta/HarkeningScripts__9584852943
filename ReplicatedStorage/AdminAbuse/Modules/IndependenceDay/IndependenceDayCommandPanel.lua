-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.IndependenceDay.IndependenceDayCommandPanel
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local Workspace = game:GetService("Workspace");
local FireworksController = require(script.Parent.FireworksController);
local IndependenceDayConfig = require(script.Parent.IndependenceDayConfig);
local IndependenceDayCutscenes = require(script.Parent.IndependenceDayCutscenes);
local OrbController = require(script.Parent.Parent.Shared.OrbController);
local u1, u2;

if RunService:IsClient() then
    u1 = Players.LocalPlayer;
    u2 = u1.PlayerGui;
else
    u2 = nil;
    u1 = nil;
end;

local u3 = Color3.fromRGB(24, 24, 26);
local u4 = Color3.fromRGB(38, 38, 42);
local u5 = Color3.fromRGB(48, 48, 54);
local u6 = Color3.fromRGB(210, 255, 80);
local u7 = Color3.fromRGB(235, 235, 238);
local RobotoMono = Enum.Font.RobotoMono;
local Equals = Enum.KeyCode.Equals;
local v8 = {};
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = false;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = {};
local u19 = false;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = {};

local function stopJetsSequence() -- Line: 71
    -- upvalues: u19 (ref), RunService (copy), u22 (ref), u20 (ref), u21 (ref), IndependenceDayCutscenes (copy), u23 (ref), u24 (copy)
    if u19 then
        RunService:UnbindFromRenderStep("IndependenceDayJetsCameraFollow");
        u19 = false;
    end;

    if u22 then
        u22:Disconnect();
        u22 = nil;
    end;

    if u20 and u20.IsPlaying then
        u20:Stop(0);
    end;

    u20 = nil;

    if u21 then
        IndependenceDayCutscenes.hideRig(u21);
        u21 = nil;
    end;

    if u23 then
        u23:Stop();
        u23 = nil;
    end;

    if u24 then
        for _, v in ipairs(u24) do
            if v and v:IsA("Highlight") then
                v.Enabled = false;
            end;
        end;
    end;
end;

local u40 = {
    RunJetsSequence = function(p25) -- Line: 106, Name: runJetsSequence
        -- upvalues: stopJetsSequence (copy), IndependenceDayCutscenes (copy), u21 (ref), IndependenceDayConfig (copy), u20 (ref), RunService (copy), Workspace (copy), u19 (ref), u24 (copy), u23 (ref), TweenService (copy), u22 (ref)
        stopJetsSequence();
        local v26 = IndependenceDayCutscenes.getCutsceneRigsFolder();

        if not v26 then
            warn("[IndependenceDayCommandPanel] RunJetsSequence: CutsceneRigs not found");

            return;
        end;

        local Jets = v26:FindFirstChild("Jets");

        if not (Jets and Jets:IsA("Model")) then
            warn("[IndependenceDayCommandPanel] RunJetsSequence: Jets rig not found");

            return;
        end;

        u21 = Jets;
        IndependenceDayCutscenes.showRig(Jets);
        local u27 = IndependenceDayCutscenes.loadTrack(Jets, IndependenceDayConfig.ANIM_IDS.Command.Jets);

        if not u27 then
            warn("[IndependenceDayCommandPanel] RunJetsSequence: failed to load Command.Jets animation");
            IndependenceDayCutscenes.hideRig(Jets);
            u21 = nil;

            return;
        end;

        u20 = u27;
        u27:Play(0, 1, 1);
        local Jet_1 = Jets:FindFirstChild("Jet_1", true);

        if Jet_1 and Jet_1:IsA("BasePart") then
            RunService:BindToRenderStep("IndependenceDayJetsCameraFollow", Enum.RenderPriority.Camera.Value + 1, function(p28) -- Line: 140
                -- upvalues: Jet_1 (copy), Workspace (ref), IndependenceDayConfig (ref)
                if not Jet_1.Parent then
                    return;
                end;

                local CurrentCamera = Workspace.CurrentCamera;

                if not CurrentCamera then
                    return;
                end;

                local v29 = CurrentCamera.CFrame + Vector3.new(0, IndependenceDayConfig.COMMAND_CAMERA_FOLLOW_HEIGHT_OFFSET, 0);
                CurrentCamera.CFrame = v29:Lerp(CFrame.lookAt(v29.Position, Jet_1.Position), 1 - math.exp(-p28 / IndependenceDayConfig.COMMAND_CAMERA_FOLLOW_SMOOTH_TIME));
            end);
            u19 = true;

            for _, child in ipairs(Jets:GetChildren()) do
                if child:IsA("BasePart") and child ~= Jets.PrimaryPart then
                    local v30 = child:FindFirstChildOfClass("Highlight");

                    if not v30 then
                        v30 = Instance.new("Highlight");
                        v30.Parent = child;
                        v30.FillColor = Color3.fromHex(child:GetAttribute("HighlightColor")) or Color3.fromHex("#FF0000");
                        table.insert(u24, v30);
                    end;

                    v30.Enabled = true;
                end;
            end;

            local SFX = Jet_1:FindFirstChild("SFX");

            if SFX and not u23 then
                SFX.RollOffMaxDistance = 5000;
                SFX.Volume = 5;
                u23 = SFX;
                SFX:Play();
                task.delay(u27.Length - 3, function() -- Line: 206
                    -- upvalues: TweenService (ref), SFX (copy)
                    local u31 = TweenService:Create(SFX, TweenInfo.new(2), {
                        Volume = 0
                    });
                    u31:Play();
                    u31.Completed:Once(function(p32) -- Line: 211
                        -- upvalues: u31 (copy)
                        u31:Destroy();
                    end);
                end);
                print("played sfx");
            end;
        else
            warn("[IndependenceDayCommandPanel] RunJetsSequence: Jet_1 part not found — skipping camera follow");
        end;

        u22 = u27.Ended:Once(stopJetsSequence);
        task.delay(u27.Length - 0.5, function() -- Line: 226
            -- upvalues: u20 (ref), u27 (copy), stopJetsSequence (ref)
            if u20 == u27 then
                stopJetsSequence();
            end;
        end);
    end,

    SpawnWinOrbs = function(p33) -- Line: 235, Name: spawnWinOrbsEffect
        -- upvalues: u11 (ref), Workspace (copy), IndependenceDayConfig (copy), u12 (ref), OrbController (copy)
        if not u11 then
            warn("[IndependenceDayCommandPanel] SpawnWinOrbs: win orb remote not ready");

            return;
        end;

        local v34 = type(p33) == "table" and p33.arg or 0;

        if type(v34) ~= "number" or v34 <= 0 then
            return;
        end;

        local v35 = Workspace:FindFirstChild("AdminAbuse") and v35:FindFirstChild("Map") and v35:FindFirstChild(IndependenceDayConfig.MAP_LIVE_NAME);

        if not v35 then
            warn("[IndependenceDayCommandPanel] SpawnWinOrbs: live map not found");

            return;
        end;

        if not u12 then
            u12 = OrbController.new(u11, {
                despawnSec = IndependenceDayConfig.WIN_ORB_DESPAWN_SEC
            });
        end;

        if not u12:isScanned() then
            u12:scan(v35);
        end;

        u12:spawnFromZone(v34);
    end,

    LaunchFireworks = function(p36) -- Line: 265, Name: launchFireworksEffect
        -- upvalues: Workspace (copy), IndependenceDayConfig (copy), FireworksController (copy)
        local v37 = type(p36) == "table" and (p36.arg or 0) or 0;

        if type(v37) ~= "number" or v37 <= 0 then
            return;
        end;

        local v38 = Workspace:FindFirstChild("AdminAbuse") and v38:FindFirstChild("Map") and v38:FindFirstChild(IndependenceDayConfig.MAP_LIVE_NAME);

        if not v38 then
            warn("[IndependenceDayCommandPanel] LaunchFireworks: live map not found");

            return;
        end;

        local v39;

        if type(p36) == "table" then
            v39 = p36.colors or nil;
        else
            v39 = nil;
        end;

        FireworksController.FireMany(v38, v37, v39);
    end
};

local function isTrusted() -- Line: 293
    -- upvalues: u1 (ref)
    return u1:GetAttribute("IndependenceDayCommandTrusted") == true;
end;

local function bindDrag(u41) -- Line: 298
    -- upvalues: u17 (ref), UserInputService (copy)
    local u42 = false;
    local u43 = nil;
    local u44 = nil;
    local u45 = nil;

    local function update(p46) -- Line: 304
        -- upvalues: u44 (ref), u45 (ref), u41 (copy)
        local v47 = p46.Position - u44;
        local v48 = u45;
        u41.Position = UDim2.new(v48.X.Scale, v48.X.Offset + v47.X, v48.Y.Scale, v48.Y.Offset + v47.Y);
    end;

    u41.InputBegan:Connect(function(u49) -- Line: 310
        -- upvalues: u42 (ref), u44 (ref), u45 (ref), u41 (copy)
        if u49.UserInputType == Enum.UserInputType.MouseButton1 or u49.UserInputType == Enum.UserInputType.Touch then
            u42 = true;
            u44 = u49.Position;
            u45 = u41.Position;
            u49.Changed:Connect(function() -- Line: 316
                -- upvalues: u49 (copy), u42 (ref)
                if u49.UserInputState == Enum.UserInputState.End then
                    u42 = false;
                end;
            end);
        end;
    end);
    u41.InputChanged:Connect(function(p50) -- Line: 324
        -- upvalues: u43 (ref)
        if p50.UserInputType == Enum.UserInputType.MouseMovement or p50.UserInputType == Enum.UserInputType.Touch then
            u43 = p50;
        end;
    end);
    u17 = UserInputService.InputChanged:Connect(function(p51) -- Line: 330
        -- upvalues: u43 (ref), u42 (ref), u44 (ref), u45 (ref), u41 (copy)
        if p51 == u43 and u42 then
            local v52 = p51.Position - u44;
            local v53 = u45;
            u41.Position = UDim2.new(v53.X.Scale, v53.X.Offset + v52.X, v53.Y.Scale, v53.Y.Offset + v52.Y);
        end;
    end);
end;

local function buildPanel() -- Line: 337
    -- upvalues: u2 (ref), u3 (copy), bindDrag (copy), u6 (copy), RobotoMono (copy), IndependenceDayConfig (copy), u4 (copy), u7 (copy), u5 (copy), u10 (ref), u18 (copy)
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "IndependenceDayCommandPanel";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    ScreenGui.DisplayOrder = 100;
    ScreenGui.Enabled = false;
    ScreenGui.Parent = u2;
    local Frame = Instance.new("Frame");
    Frame.Name = "Root";
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.Position = UDim2.new(0.5, 0, 0.15, 0);
    Frame.AutomaticSize = Enum.AutomaticSize.Y;
    Frame.Size = UDim2.new(0, 240, 0, 0);
    Frame.BackgroundColor3 = u3;
    Frame.BorderSizePixel = 0;
    Frame.ZIndex = 2;
    Frame.Parent = ScreenGui;
    bindDrag(Frame);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Stripe";
    Frame2.BackgroundColor3 = u6;
    Frame2.BorderSizePixel = 0;
    Frame2.Size = UDim2.new(0, 4, 1, 0);
    Frame2.ZIndex = 3;
    Frame2.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Position = UDim2.new(0, 12, 0, 10);
    TextLabel.Size = UDim2.new(1, -20, 0, 20);
    TextLabel.Font = RobotoMono;
    TextLabel.Text = "independenceday_cmd";
    TextLabel.TextColor3 = u6;
    TextLabel.TextSize = 14;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 3;
    TextLabel.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "List";
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.new(0, 10, 0, 36);
    Frame3.Size = UDim2.new(1, -20, 0, 0);
    Frame3.AutomaticSize = Enum.AutomaticSize.Y;
    Frame3.ZIndex = 3;
    Frame3.Parent = Frame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Padding = UDim.new(0, 4);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame3;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.PaddingBottom = UDim.new(0, 10);
    UIPadding.Parent = Frame3;
    local v54 = 0;

    for i, v in pairs(IndependenceDayConfig.COMMANDS) do
        v54 = v54 + 1;
        local u55 = v.HasArg == true;
        local Frame4 = Instance.new("Frame");
        Frame4.Name = i;
        Frame4.BackgroundTransparency = 1;
        Frame4.Size = UDim2.new(1, 0, 0, 36);
        Frame4.LayoutOrder = v54;
        Frame4.ZIndex = 4;
        Frame4.Parent = Frame3;
        local UIListLayout2 = Instance.new("UIListLayout");
        UIListLayout2.FillDirection = Enum.FillDirection.Horizontal;
        UIListLayout2.Padding = UDim.new(0, 4);
        UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout2.Parent = Frame4;
        local u56;

        if u55 then
            u56 = Instance.new("TextBox");
            u56.Name = "Arg";
            u56.BackgroundColor3 = u4;
            u56.BorderSizePixel = 0;
            u56.Size = UDim2.new(0, 60, 1, 0);
            u56.LayoutOrder = 1;
            u56.Font = RobotoMono;
            u56.PlaceholderText = v.ArgPlaceholder or "Count";
            u56.Text = v.ArgDefault or "";
            u56.TextColor3 = u7;
            u56.TextSize = 14;
            u56.ClearTextOnFocus = false;
            u56.ZIndex = 5;
            u56.Parent = Frame4;
        else
            u56 = nil;
        end;

        local TextButton = Instance.new("TextButton");
        TextButton.Name = "Button";
        TextButton.AutoButtonColor = false;
        TextButton.BackgroundColor3 = u4;
        TextButton.BorderSizePixel = 0;
        local v57;

        if u55 then
            v57 = UDim2.new(1, -64, 1, 0);
        else
            v57 = UDim2.new(1, 0, 1, 0);
        end;

        TextButton.Size = v57;
        TextButton.LayoutOrder = 2;
        TextButton.Font = RobotoMono;
        TextButton.Text = "  " .. (v.DisplayName or i);
        TextButton.TextColor3 = u7;
        TextButton.TextSize = 14;
        TextButton.TextXAlignment = Enum.TextXAlignment.Left;
        TextButton.ZIndex = 4;
        TextButton.MouseEnter:Connect(function() -- Line: 450
            -- upvalues: TextButton (copy), u5 (ref)
            TextButton.BackgroundColor3 = u5;
        end);
        TextButton.MouseLeave:Connect(function() -- Line: 451
            -- upvalues: TextButton (copy), u4 (ref)
            TextButton.BackgroundColor3 = u4;
        end);
        local u58 = v.HasColorPicker == true;
        TextButton.MouseButton1Click:Connect(function() -- Line: 453
            -- upvalues: u10 (ref), u55 (copy), u56 (ref), v (copy), IndependenceDayConfig (ref), u58 (copy), u18 (ref), i (copy)
            if not u10 then
                return;
            end;

            if not u55 then
                u10:FireServer(i);

                return;
            end;

            local v59 = tonumber(u56.Text) or tonumber(v.ArgDefault) or 1;
            local v60 = math.floor(v59);
            local v61 = math.clamp(v60, 1, v.ArgMax or IndependenceDayConfig.WIN_ORB_MAX_COUNT);

            if not u58 then
                u10:FireServer(i, v61);

                return;
            end;

            local v62 = {};

            for _, v2 in IndependenceDayConfig.FIREWORK_COLOR_ORDER do
                if u18[v2] then
                    table.insert(v62, v2);
                end;
            end;

            u10:FireServer(i, v61, v62);
        end);
        TextButton.Parent = Frame4;

        if u58 then
            v54 = v54 + 1;
            local Frame5 = Instance.new("Frame");
            Frame5.Name = i .. "Colors";
            Frame5.BackgroundTransparency = 1;
            Frame5.Size = UDim2.new(1, 0, 0, 40);
            Frame5.LayoutOrder = v54;
            Frame5.ZIndex = 4;
            Frame5.Parent = Frame3;
            local UIListLayout3 = Instance.new("UIListLayout");
            UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder;
            UIListLayout3.Padding = UDim.new(0, 2);
            UIListLayout3.Parent = Frame5;
            local TextLabel2 = Instance.new("TextLabel");
            TextLabel2.Name = "Selected";
            TextLabel2.BackgroundTransparency = 1;
            TextLabel2.Size = UDim2.new(1, 0, 0, 16);
            TextLabel2.LayoutOrder = 1;
            TextLabel2.Font = RobotoMono;
            TextLabel2.Text = "Current colors selected: None (default)";
            TextLabel2.TextColor3 = u7;
            TextLabel2.TextSize = 12;
            TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
            TextLabel2.ZIndex = 4;
            TextLabel2.Parent = Frame5;
            local Frame6 = Instance.new("Frame");
            Frame6.Name = "Swatches";
            Frame6.BackgroundTransparency = 1;
            Frame6.Size = UDim2.new(1, 0, 0, 20);
            Frame6.LayoutOrder = 2;
            Frame6.ZIndex = 4;
            Frame6.Parent = Frame5;
            local UIListLayout4 = Instance.new("UIListLayout");
            UIListLayout4.FillDirection = Enum.FillDirection.Horizontal;
            UIListLayout4.Padding = UDim.new(0, 4);
            UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder;
            UIListLayout4.Parent = Frame6;
            local u63 = {};

            local function refreshColorPickerDisplay() -- Line: 526
                -- upvalues: IndependenceDayConfig (ref), u18 (ref), u63 (copy), TextLabel2 (copy)
                local v64 = {};

                for _, v2 in IndependenceDayConfig.FIREWORK_COLOR_ORDER do
                    if u18[v2] then
                        table.insert(v64, v2);
                        local v65 = u63[v2];

                        if v65 then
                            v65.Enabled = true;
                        end;
                    else
                        local v66 = u63[v2];

                        if v66 then
                            v66.Enabled = false;
                        end;
                    end;
                end;

                TextLabel2.Text = "Current colors selected: " .. (#v64 <= 0 and "None (default)" or table.concat(v64, ", "));
            end;

            for i2, v2 in IndependenceDayConfig.FIREWORK_COLOR_ORDER do
                local TextButton2 = Instance.new("TextButton");
                TextButton2.Name = v2;
                TextButton2.AutoButtonColor = false;
                TextButton2.BackgroundColor3 = IndependenceDayConfig.FIREWORK_COLORS[v2];
                TextButton2.BorderSizePixel = 0;
                TextButton2.Size = UDim2.new(0, 40, 1, 0);
                TextButton2.LayoutOrder = i2;
                TextButton2.Text = "";
                TextButton2.ZIndex = 5;
                TextButton2.Parent = Frame6;
                local UIStroke = Instance.new("UIStroke");
                UIStroke.Name = "Selected";
                UIStroke.Color = u6;
                UIStroke.Thickness = 2;
                UIStroke.Enabled = false;
                UIStroke.Parent = TextButton2;
                u63[v2] = UIStroke;
                TextButton2.MouseButton1Click:Connect(function() -- Line: 561
                    -- upvalues: u18 (ref), v2 (copy), refreshColorPickerDisplay (copy)
                    u18[v2] = not u18[v2];
                    refreshColorPickerDisplay();
                end);
            end;

            refreshColorPickerDisplay();
        end;
    end;

    return ScreenGui;
end;

local function ensurePanel() -- Line: 574
    -- upvalues: u13 (ref), buildPanel (copy)
    if not u13 then
        u13 = buildPanel();
    end;

    return u13;
end;

local function setPanelVisible(p67) -- Line: 581
    -- upvalues: u14 (ref), u13 (ref), buildPanel (copy)
    u14 = p67;

    if not p67 then
        if u13 then
            u13.Enabled = false;
        end;

        return;
    end;

    if not u13 then
        u13 = buildPanel();
    end;

    u13.Enabled = true;
end;

local function togglePanel() -- Line: 590
    -- upvalues: u1 (ref), u14 (ref), u13 (ref), buildPanel (copy)
    if u1:GetAttribute("IndependenceDayCommandTrusted") ~= true then
        return;
    end;

    local v68 = not u14;
    u14 = v68;

    if not v68 then
        if u13 then
            u13.Enabled = false;
        end;

        return;
    end;

    if not u13 then
        u13 = buildPanel();
    end;

    u13.Enabled = true;
end;

function v8.init(p69, p70, p71) -- Line: 599
    -- upvalues: u9 (ref), u10 (ref), u11 (ref), u40 (copy), u15 (ref), UserInputService (copy), Equals (copy), u1 (ref), u14 (ref), u13 (ref), buildPanel (copy), u16 (ref)
    u9 = p69;
    u10 = p70;
    u11 = p71;
    p69:onFire("Command", function(p72) -- Line: 604
        -- upvalues: u40 (ref)
        if type(p72) ~= "table" then
            return;
        end;

        local v73 = u40[p72.command];

        if v73 then
            v73(p72);
        end;
    end);
    u15 = UserInputService.InputBegan:Connect(function(p74, p75) -- Line: 614
        -- upvalues: Equals (ref), u1 (ref), u14 (ref), u13 (ref), buildPanel (ref)
        if p75 then
            return;
        end;

        if p74.KeyCode == Equals then
            if u1:GetAttribute("IndependenceDayCommandTrusted") ~= true then
                return;
            end;

            local v76 = not u14;
            u14 = v76;

            if v76 then
                if not u13 then
                    u13 = buildPanel();
                end;

                u13.Enabled = true;

                return;
            end;

            if u13 then
                u13.Enabled = false;
            end;
        end;
    end);
    u16 = u1:GetAttributeChangedSignal("IndependenceDayCommandTrusted"):Connect(function() -- Line: 623
        -- upvalues: u1 (ref), u14 (ref), u13 (ref)
        if u1:GetAttribute("IndependenceDayCommandTrusted") ~= true then
            u14 = false;

            if u13 then
                u13.Enabled = false;
            end;
        end;
    end);
end;

function v8.Stop() -- Line: 630
    -- upvalues: stopJetsSequence (copy), u12 (ref), u15 (ref), u16 (ref), u17 (ref), u13 (ref), u14 (ref), u9 (ref), u10 (ref), u11 (ref)
    stopJetsSequence();

    if u12 then
        u12:destroy();
        u12 = nil;
    end;

    if u15 then
        u15:Disconnect();
        u15 = nil;
    end;

    if u16 then
        u16:Disconnect();
        u16 = nil;
    end;

    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    if u13 then
        u13:Destroy();
        u13 = nil;
    end;

    u14 = false;
    u9 = nil;
    u10 = nil;
    u11 = nil;
end;

return v8;