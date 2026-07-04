-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.LokiiBossRoom
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local AdminAbuseConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("AdminAbuseConfig"));
local AdminAbuseTransition = require(game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"):WaitForChild("Client"):WaitForChild("AdminAbuseTransition"));
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = 0;
local u9 = 1;
local u10 = false;
local u11 = nil;
local u12 = nil;

local function getTweenDuration() -- Line: 24
    -- upvalues: AdminAbuseConfig (copy)
    local BossBarTweenDurationSec = AdminAbuseConfig.BossBarTweenDurationSec;

    return (type(BossBarTweenDurationSec) ~= "number" or BossBarTweenDurationSec <= 0) and 0.38 or BossBarTweenDurationSec;
end;

local function refreshBarFromDriver() -- Line: 32
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u9 (ref)
    local v13 = u2;
    local v14 = u3;
    local v15 = u4;

    if not v15 or (not v13 or u9 <= 0) then
        return;
    end;

    local v16 = math.clamp(v15.Value, 0, u9);
    local v17 = math.clamp(v16 / u9, 0, 1);
    v13.Size = UDim2.new(v17, 0, 1, 0);

    if v14 then
        local v18 = u9;

        if v18 >= 1000000 then
            v14.Text = string.format("%.3fM / %.1fM", v16 / 1000000, v18 / 1000000);

            return;
        end;

        v14.Text = string.format("%d / %d", math.floor(v16 + 0.5), (math.floor(v18 + 0.5)));
    end;
end;

local function onBossHpSync(p19, p20, p21) -- Line: 52
    -- upvalues: u4 (ref), u8 (ref), u9 (ref), u7 (ref), u10 (ref), AdminAbuseConfig (copy), refreshBarFromDriver (copy), TweenService (copy)
    local v22 = u4;

    if not v22 then
        return;
    end;

    if type(p19) ~= "number" then
        return;
    end;

    if type(p20) ~= "number" then
        p20 = p19;
    end;

    if p20 <= 0 then
        return;
    end;

    if type(p21) == "number" and p21 < u8 then
        return;
    end;

    if type(p21) == "number" then
        u8 = p21;
    end;

    u9 = p20;

    if u7 then
        u7:Cancel();
        u7 = nil;
    end;

    local v23 = math.clamp(p19, 0, p20);
    local v24 = not u10;

    if not v24 then
        local BossBarTweenDurationSec = AdminAbuseConfig.BossBarTweenDurationSec;
        v24 = ((type(BossBarTweenDurationSec) ~= "number" or BossBarTweenDurationSec <= 0) and 0.38 or BossBarTweenDurationSec) <= 0;
    end;

    u10 = true;

    if v24 then
        v22.Value = v23;
        refreshBarFromDriver();

        return;
    end;

    local BossBarTweenDurationSec = AdminAbuseConfig.BossBarTweenDurationSec;
    local v25 = (type(BossBarTweenDurationSec) ~= "number" or BossBarTweenDurationSec <= 0) and 0.38 or BossBarTweenDurationSec;
    u7 = TweenService:Create(v22, TweenInfo.new(v25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Value = v23
    });
    u7:Play();
end;

local LocalPlayer = Players.LocalPlayer;
local u26 = false;
local u27 = { "rbxassetid://140658568629873", "rbxassetid://135791338543784", "rbxassetid://1838475719", "rbxassetid://1843024859", "rbxassetid://1838450596", "rbxassetid://1837922109", "rbxassetid://1847617400" };
local u28 = 1;
local u29 = nil;

local function stopPlaylist() -- Line: 111
    -- upvalues: u29 (ref)
    if u29 then
        u29:Stop();
        u29:Destroy();
        u29 = nil;
    end;
end;

local function startPlaylist() -- Line: 119
    -- upvalues: u29 (ref), u28 (ref), u1 (ref), u27 (copy), LocalPlayer (copy)
    if u29 then
        u29:Stop();
        u29:Destroy();
        u29 = nil;
    end;

    u28 = 1;

    local function playNext() -- Line: 123
        -- upvalues: u1 (ref), u28 (ref), u27 (ref), u29 (ref), LocalPlayer (ref), playNext (copy)
        if not (u1 and u1.Parent) then
            return;
        end;

        if u28 > #u27 then
            u28 = 1;
        end;

        local v30 = u27[u28];
        u29 = Instance.new("Sound");
        u29:SetAttribute("IsEventSound", true);
        u29.Name = "BossMusic";
        u29.SoundId = v30;
        u29.Volume = 0.4;
        u29.Parent = workspace.CurrentCamera or LocalPlayer:WaitForChild("PlayerGui");
        u29:Play();
        u29.Ended:Connect(function() -- Line: 138
            -- upvalues: u29 (ref), u28 (ref), playNext (ref)
            if u29 then
                u29:Destroy();
            end;

            u28 = u28 + 1;
            playNext();
        end);
    end;

    playNext();
end;

local function onCharacterAdded(p31) -- Line: 148
    -- upvalues: u26 (ref), AdminAbuseTransition (copy)
    task.wait(0.1);

    if u26 or AdminAbuseTransition.isActive() then
        return;
    end;

    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    CurrentCamera.CameraType = Enum.CameraType.Custom;
    local Humanoid = p31:WaitForChild("Humanoid", 10);

    if Humanoid then
        CurrentCamera.CameraSubject = Humanoid;
    end;
end;

if LocalPlayer then
    if LocalPlayer.Character then
        onCharacterAdded(LocalPlayer.Character);
    end;

    LocalPlayer.CharacterAdded:Connect(onCharacterAdded);
end;

local u32 = nil;
RunService:BindToRenderStep("LokiiBossCinematicLock", Enum.RenderPriority.Camera.Value + 2, function() -- Line: 168
    -- upvalues: u26 (ref), u32 (ref)
    if u26 then
        local CurrentCamera = workspace.CurrentCamera;

        if CurrentCamera then
            CurrentCamera.CameraSubject = nil;

            if CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
                CurrentCamera.CameraType = Enum.CameraType.Scriptable;

                if u32 then
                    CurrentCamera.CFrame = u32;
                end;
            end;

            u32 = CurrentCamera.CFrame;
        end;
    else
        u32 = nil;
    end;
end);

local function destroyUi() -- Line: 186
    -- upvalues: u7 (ref), u6 (ref), u5 (ref), u12 (ref), u1 (ref), u2 (ref), u3 (ref), u4 (ref), u26 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u29 (ref)
    if u7 then
        u7:Cancel();
        u7 = nil;
    end;

    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;

    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;

    if u12 then
        u12:Disconnect();
        u12 = nil;
    end;

    if u1 and u1.Parent then
        u1:Destroy();
    end;

    u1 = nil;
    u2 = nil;
    u3 = nil;
    u4 = nil;
    u26 = false;
    u8 = 0;
    u9 = 1;
    u10 = false;
    u11 = nil;

    if u29 then
        u29:Stop();
        u29:Destroy();
        u29 = nil;
    end;

    if pulseGui then
        pulseGui:Destroy();
        pulseGui = nil;
    end;
end;

local function ensureUi() -- Line: 223
    -- upvalues: u1 (ref), Players (copy), ReplicatedStorage (copy), u2 (ref), u3 (ref), RunService (copy), u4 (ref), u6 (ref), refreshBarFromDriver (copy), u29 (ref), u28 (ref), u27 (copy), LocalPlayer (copy)
    if u1 then
        return;
    end;

    local LocalPlayer2 = Players.LocalPlayer;

    if not LocalPlayer2 then
        return;
    end;

    local PlayerGui = LocalPlayer2:WaitForChild("PlayerGui");
    local PulseBoss = ReplicatedStorage:FindFirstChild("PulseBoss");

    if PulseBoss and PulseBoss:IsA("ScreenGui") then
        pulseGui = PulseBoss:Clone();
        pulseGui.Parent = PlayerGui;
        local Frame = pulseGui:FindFirstChild("Frame");

        if Frame then
            task.spawn(function() -- Line: 238
                -- upvalues: Frame (copy)
                while pulseGui and pulseGui.Parent do
                    local v33 = os.clock() * 3;
                    Frame.BackgroundTransparency = (math.sin(v33) + 1) / 2 * 0.3 + 0.6;
                    task.wait();
                end;
            end);
        end;
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "LokiiBossHud";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.DisplayOrder = 80;
    ScreenGui.Parent = PlayerGui;
    u1 = ScreenGui;
    local Frame = Instance.new("Frame");
    Frame.Name = "LevelFrame";
    Frame.Parent = ScreenGui;
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 60);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.new(0.5, 0, 0, 45);
    Frame.Size = UDim2.new(0.6, 0, 0.08, 0);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "ProgressBg";
    Frame2.Parent = Frame;
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.fromRGB(38, 17, 0);
    Frame2.BackgroundTransparency = 0.4;
    Frame2.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame2.Size = UDim2.new(1, 0, 0.65, 0);
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.5, 0);
    UICorner.Parent = Frame2;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "BossIcon";
    ImageLabel.Parent = Frame2;
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Position = UDim2.new(0, -65, 0.5, 0);
    ImageLabel.Size = UDim2.new(0, 60, 0, 60);
    ImageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=3845375404&w=150&h=150";
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = ImageLabel;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.fromRGB(255, 215, 0);
    UIStroke.Thickness = 2;
    UIStroke.Parent = ImageLabel;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TrophyIcon";
    TextLabel.Parent = Frame2;
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Position = UDim2.new(1, 10, 0.5, 0);
    TextLabel.Size = UDim2.new(0, 50, 0, 50);
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.Text = "🏆";
    TextLabel.TextScaled = true;
    TextLabel.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "ProgressFill";
    Frame3.Parent = Frame2;
    Frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame3.Size = UDim2.new(0, 0, 1, 0);
    u2 = Frame3;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.CornerRadius = UDim.new(0.5, 0);
    UICorner3.Parent = Frame3;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(167, 126, 69)), ColorSequenceKeypoint.new(1, Color3.fromRGB(221, 174, 120)) });
    UIGradient.Rotation = -90;
    UIGradient.Parent = Frame3;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "LevelText";
    TextLabel2.Parent = Frame2;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.Size = UDim2.new(0.4, 0, 1, 0);
    TextLabel2.Font = Enum.Font.GothamBold;
    TextLabel2.Text = "LOKII BOSS EVENT";
    TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.PaddingBottom = UDim.new(0.15, 0);
    UIPadding.PaddingLeft = UDim.new(0.04, 0);
    UIPadding.PaddingTop = UDim.new(0.15, 0);
    UIPadding.Parent = TextLabel2;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "XPText";
    TextLabel3.Parent = Frame2;
    TextLabel3.AnchorPoint = Vector2.new(1, 0);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.Position = UDim2.new(1, 0, 0, 0);
    TextLabel3.Size = UDim2.new(0.4, 0, 1, 0);
    TextLabel3.Font = Enum.Font.GothamBold;
    TextLabel3.Text = "0 / 100M";
    TextLabel3.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel3.TextScaled = true;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Right;
    u3 = TextLabel3;
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.PaddingBottom = UDim.new(0.15, 0);
    UIPadding2.PaddingRight = UDim.new(0.04, 0);
    UIPadding2.PaddingTop = UDim.new(0.15, 0);
    UIPadding2.Parent = TextLabel3;

    for i, v in ipairs({ 0.6, 0.9 }) do
        local Frame4 = Instance.new("Frame");
        Frame4.Name = "PhaseMarker" .. i;
        Frame4.Parent = Frame2;
        Frame4.AnchorPoint = Vector2.new(0.5, 0);
        Frame4.BackgroundColor3 = Color3.fromRGB(255, 50, 50);
        Frame4.BorderSizePixel = 0;
        Frame4.ZIndex = 6;
        Frame4.Position = UDim2.new(v, 0, 0, 0);
        Frame4.Size = UDim2.new(0, 3, 1, 0);
    end;

    local Frame4 = Instance.new("Frame");
    Frame4.Name = "SpeedDisplay";
    Frame4.Parent = Frame;
    Frame4.AnchorPoint = Vector2.new(0.5, 0);
    Frame4.BackgroundTransparency = 1;
    Frame4.Position = UDim2.new(0.5, 0, 1, 0);
    Frame4.Size = UDim2.new(0.3, 0, 0.6, 0);
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "SpeedValue";
    TextLabel4.Parent = Frame4;
    TextLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.Position = UDim2.new(0.5, 0, 0.5, 0);
    TextLabel4.Size = UDim2.new(1, 0, 1, 0);
    TextLabel4.Font = Enum.Font.GothamBlack;
    TextLabel4.Text = "GLOBAL TROPHIES WON";
    TextLabel4.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel4.TextScaled = true;
    TextLabel4.TextYAlignment = Enum.TextYAlignment.Bottom;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "GamepassMultiplierDisplay";
    Frame5.Parent = Frame;
    Frame5.AnchorPoint = Vector2.new(0, 0);
    Frame5.BackgroundTransparency = 1;
    Frame5.Position = UDim2.new(0, 0, 1, 0);
    Frame5.Size = UDim2.new(0.3, 0, 0.3, 0);
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "GamepassMultiplierLabel";
    TextLabel5.Parent = Frame5;
    TextLabel5.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.Position = UDim2.new(0.5, 0, 0.5, 0);
    TextLabel5.Size = UDim2.new(1, 0, 1, 0);
    TextLabel5.Font = Enum.Font.GothamBlack;
    TextLabel5.Text = "ACTIVE EVENT x2";
    TextLabel5.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel5.TextScaled = true;
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Parent = TextLabel5;
    task.spawn(function() -- Line: 422
        -- upvalues: TextLabel5 (copy), RunService (ref), UIGradient2 (copy)
        local v34 = 0;

        while TextLabel5 and TextLabel5.Parent do
            v34 = v34 + RunService.RenderStepped:Wait() * 0.2;
            UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHSV(v34 % 1, 0.7, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV((v34 + 0.1) % 1, 0.7, 1)) });
        end;
    end);
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Name = "BossHpDisplay";
    NumberValue.Value = 0;
    NumberValue.Parent = ScreenGui;
    u4 = NumberValue;
    u6 = NumberValue.Changed:Connect(refreshBarFromDriver);

    if u29 then
        u29:Stop();
        u29:Destroy();
        u29 = nil;
    end;

    u28 = 1;

    local function u36() -- Line: 123
        -- upvalues: u1 (ref), u28 (ref), u27 (ref), u29 (ref), LocalPlayer (ref), u36 (copy)
        if not (u1 and u1.Parent) then
            return;
        end;

        if u28 > #u27 then
            u28 = 1;
        end;

        local v35 = u27[u28];
        u29 = Instance.new("Sound");
        u29:SetAttribute("IsEventSound", true);
        u29.Name = "BossMusic";
        u29.SoundId = v35;
        u29.Volume = 0.4;
        u29.Parent = workspace.CurrentCamera or LocalPlayer:WaitForChild("PlayerGui");
        u29:Play();
        u29.Ended:Connect(function() -- Line: 138
            -- upvalues: u29 (ref), u28 (ref), u36 (ref)
            if u29 then
                u29:Destroy();
            end;

            u28 = u28 + 1;
            u36();
        end);
    end;

    u36();
end;

local function wireBossRemoteListeners() -- Line: 446
    -- upvalues: ReplicatedStorage (copy), u5 (ref), ensureUi (copy), u4 (ref), onBossHpSync (copy), u12 (ref), TweenService (copy), LocalPlayer (copy), RunService (copy), u26 (ref), Players (copy)
    local AdminAbuseBossSync = ReplicatedStorage:WaitForChild("AdminAbuse"):WaitForChild("Remotes"):WaitForChild("AdminAbuseBossSync");

    if AdminAbuseBossSync:IsA("RemoteEvent") then
        if u5 then
            u5:Disconnect();
        end;

        u5 = AdminAbuseBossSync.OnClientEvent:Connect(function(...) -- Line: 450
            -- upvalues: ensureUi (ref), u4 (ref), onBossHpSync (ref)
            ensureUi();

            if u4 then
                onBossHpSync(...);
            end;
        end);
    end;

    local AdminAbuseBossFx = ReplicatedStorage:WaitForChild("AdminAbuse"):WaitForChild("Remotes"):WaitForChild("AdminAbuseBossFx");

    if AdminAbuseBossFx:IsA("RemoteEvent") then
        if u12 then
            u12:Disconnect();
        end;

        u12 = AdminAbuseBossFx.OnClientEvent:Connect(function(p37, u38) -- Line: 461
            -- upvalues: TweenService (ref), LocalPlayer (ref), RunService (ref), u26 (ref), Players (ref), ensureUi (ref)
            if type(p37) ~= "string" or type(u38) ~= "table" then
                return;
            end;

            local function num(p39, p40) -- Line: 466
                -- upvalues: u38 (copy)
                local v41 = u38[p39];

                if type(v41) == "number" then
                    return v41;
                end;

                return p40;
            end;

            if p37 == "ZoneWarn" then
                local x = u38.x;
                local v42 = type(x) ~= "number" and 0 or x;
                local y = u38.y;
                local v43 = type(y) ~= "number" and 0 or y;
                local z = u38.z;
                local v44 = type(z) ~= "number" and 0 or z;
                local v45 = Vector3.new(v42, v43, v44);
                local hx = u38.hx;
                local v46 = type(hx) ~= "number" and 6 or hx;
                local hz = u38.hz;
                local v47 = type(hz) ~= "number" and 6 or hz;
                local t = u38.t;
                local v48 = type(t) ~= "number" and 1.2 or t;
                local Part = Instance.new("Part");
                Part.Name = "BossZoneWarnFx";
                Part.Shape = Enum.PartType.Cylinder;
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CanQuery = false;
                Part.Material = Enum.Material.Neon;
                Part.Color = Color3.fromRGB(200, 70, 70);
                Part.Size = Vector3.new(4.5, v46 * 2, v47 * 2);
                Part.CFrame = CFrame.new(v45 + Vector3.new(0, -0.2, 0)) * CFrame.Angles(0, 0, 1.5707963267948966);
                Part.Transparency = 0.4;
                Part.Parent = workspace;
                task.delay(v48, function() -- Line: 488
                    -- upvalues: Part (copy)
                    if Part.Parent then
                        Part:Destroy();
                    end;
                end);

                return;
            end;

            if p37 == "ZoneHit" then
                local x = u38.x;
                local v49 = type(x) ~= "number" and 0 or x;
                local y = u38.y;
                local v50 = type(y) ~= "number" and 0 or y;
                local z = u38.z;
                local v51 = type(z) ~= "number" and 0 or z;
                local v52 = Vector3.new(v49, v50, v51);
                local hx = u38.hx;
                local v53 = type(hx) ~= "number" and 6 or hx;
                local hz = u38.hz;
                local v54 = type(hz) ~= "number" and 6 or hz;
                local style = u38.style;
                local v55;

                if (type(style) ~= "string" and "sweet" or style) == "chocolate" then
                    v55 = Color3.fromRGB(113, 54, 0);
                else
                    v55 = Color3.fromRGB(255, 130, 210);
                end;

                local Part = Instance.new("Part");
                Part.Name = "BossZoneJetFx";
                Part.Shape = Enum.PartType.Cylinder;
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CanQuery = false;
                Part.Material = Enum.Material.SmoothPlastic;
                Part.Color = v55;
                Part.Size = Vector3.new(2, v53 * 1.5, v54 * 1.5);
                Part.CFrame = CFrame.new(v52 + Vector3.new(0, -10, 0)) * CFrame.Angles(0, 0, 1.5707963267948966);
                Part.Parent = workspace;
                local v56 = Vector3.new(150, v53 * 1.8, v54 * 1.8);
                TweenService:Create(Part, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = v56,
                    CFrame = CFrame.new(v52 + Vector3.new(0, 65, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
                }):Play();
                task.delay(0.4, function() -- Line: 523
                    -- upvalues: TweenService (ref), Part (copy)
                    local v57 = TweenService:Create(Part, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                        Transparency = 1,
                        Size = Vector3.new(150, 0.1, 0.1)
                    });
                    v57:Play();
                    v57.Completed:Connect(function() -- Line: 529
                        -- upvalues: Part (ref)
                        Part:Destroy();
                    end);
                end);
                local Part2 = Instance.new("Part");
                Part2.Anchored = true;
                Part2.CanCollide = false;
                Part2.CanQuery = false;
                Part2.Size = Vector3.new(2, 0.4, 2);
                Part2.Transparency = 0.5;
                Part2.Color = Color3.fromRGB(255, 255, 255);
                Part2.CFrame = CFrame.new(v52 + Vector3.new(0, 0.2, 0));
                Part2.Parent = workspace;
                TweenService:Create(Part2, TweenInfo.new(0.3), {
                    Transparency = 1,
                    Size = Vector3.new(v53 * 3, 0.4, v54 * 3)
                }):Play();
                task.delay(0.35, function() -- Line: 545
                    -- upvalues: Part2 (copy)
                    if Part2.Parent then
                        Part2:Destroy();
                    end;
                end);

                return;
            end;

            if p37 == "DashTelegraph" then
                local sx = u38.sx;
                local v58 = type(sx) ~= "number" and 0 or sx;
                local sy = u38.sy;
                local v59 = type(sy) ~= "number" and 0 or sy;
                local sz = u38.sz;
                local v60 = type(sz) ~= "number" and 0 or sz;
                local lx = u38.lx;
                local v61 = type(lx) ~= "number" and 0 or lx;
                local ly = u38.ly;
                local v62 = type(ly) ~= "number" and 0 or ly;
                local lz = u38.lz;
                local v63 = type(lz) ~= "number" and 0 or lz;
                local r = u38.r;
                local v64 = type(r) ~= "number" and 11 or r;
                local t = u38.t;
                local v65 = type(t) ~= "number" and 2.5 or t;
                local v66 = math.min(v59, v62) + 0.35;
                local v67 = Vector3.new(v58, v66, v60);
                local v68 = Vector3.new(v61, v66, v63);
                local Magnitude = (v68 - v67).Magnitude;
                local v69 = (v67 + v68) * 0.5;
                local Part = Instance.new("Part");
                Part.Name = "BossDashTrailFx";
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CanQuery = false;
                Part.Material = Enum.Material.Neon;
                Part.Color = Color3.fromRGB(255, 50, 80);
                Part.Transparency = 0.28;
                local v70 = math.clamp(v64 * 0.75, 6, 32);
                local v71 = math.max(Magnitude, 0.05);
                Part.Size = Vector3.new(v70, 1.7, v71);
                local v72;

                if Magnitude > 0.05 then
                    v72 = CFrame.lookAt(v69 + Vector3.new(0, 0.85, 0), v68 + Vector3.new(0, 0.85, 0));
                else
                    v72 = CFrame.new(v69 + Vector3.new(0, 0.85, 0));
                end;

                Part.CFrame = v72;
                Part.Parent = workspace;
                local Part2 = Instance.new("Part");
                Part2.Name = "BossDashLandFx";
                Part2.Shape = Enum.PartType.Cylinder;
                Part2.Anchored = true;
                Part2.CanCollide = false;
                Part2.CanQuery = false;
                Part2.Material = Enum.Material.Neon;
                Part2.Color = Color3.fromRGB(255, 90, 110);
                Part2.Size = Vector3.new(1.7, v64 * 2, v64 * 2);
                Part2.CFrame = CFrame.new((Vector3.new(v61, v66 + 0.85, v63))) * CFrame.Angles(0, 0, 1.5707963267948966);
                Part2.Transparency = 0.45;
                Part2.Parent = workspace;
                local v73 = TweenService:Create(Part2, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    Transparency = 0.2
                });
                local u74 = TweenService:Create(Part2, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                    Transparency = 0.55
                });
                v73:Play();
                v73.Completed:Connect(function() -- Line: 588
                    -- upvalues: u74 (copy)
                    u74:Play();
                end);
                task.delay(v65, function() -- Line: 591
                    -- upvalues: Part (copy), Part2 (copy)
                    if Part.Parent then
                        Part:Destroy();
                    end;

                    if Part2.Parent then
                        Part2:Destroy();
                    end;
                end);

                return;
            end;

            if p37 == "CircleWarn" then
                local x = u38.x;
                local v75 = type(x) ~= "number" and 0 or x;
                local y = u38.y;
                local v76 = type(y) ~= "number" and 0 or y;
                local z = u38.z;
                local v77 = type(z) ~= "number" and 0 or z;
                local r = u38.r;
                local v78 = type(r) ~= "number" and 26 or r;
                local t = u38.t;
                local v79 = type(t) ~= "number" and 2.2 or t;
                local Part = Instance.new("Part");
                Part.Name = "BossCircleWarnFx";
                Part.Shape = Enum.PartType.Cylinder;
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CanQuery = false;
                Part.Material = Enum.Material.Neon;
                Part.Color = Color3.fromRGB(235, 45, 65);
                Part.Size = Vector3.new(1.7, v78 * 2, v78 * 2);
                Part.CFrame = CFrame.new(v75, v76 + 0.85, v77) * CFrame.Angles(0, 0, 1.5707963267948966);
                Part.Transparency = 0.52;
                Part.Parent = workspace;
                local Part2 = Instance.new("Part");
                Part2.Name = "BossCircleWarnRingFx";
                Part2.Shape = Enum.PartType.Cylinder;
                Part2.Anchored = true;
                Part2.CanCollide = false;
                Part2.CanQuery = false;
                Part2.Material = Enum.Material.Neon;
                Part2.Color = Color3.fromRGB(255, 120, 70);
                Part2.Size = Vector3.new(0.18, v78 * 2 + 4, v78 * 2 + 4);
                Part2.CFrame = CFrame.new(v75, v76 + 0.04, v77) * CFrame.Angles(0, 0, 1.5707963267948966);
                Part2.Transparency = 0.65;
                Part2.Parent = workspace;
                local v80 = TweenService:Create(Part, TweenInfo.new(math.min(0.4, v79 * 0.18), Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    Transparency = 0.22
                });
                local v81 = TweenService:Create(Part2, TweenInfo.new(math.min(0.45, v79 * 0.2), Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Transparency = 0.38
                });
                v80:Play();
                v81:Play();
                task.delay(v79, function() -- Line: 637
                    -- upvalues: Part (copy), Part2 (copy)
                    if Part.Parent then
                        Part:Destroy();
                    end;

                    if Part2.Parent then
                        Part2:Destroy();
                    end;
                end);

                return;
            end;

            if p37 == "DashHit" then
                local x = u38.x;
                local v82 = type(x) ~= "number" and 0 or x;
                local y = u38.y;
                local v83 = type(y) ~= "number" and 0 or y;
                local z = u38.z;
                local v84 = type(z) ~= "number" and 0 or z;
                local v85 = Vector3.new(v82, v83, v84);
                local Part = Instance.new("Part");
                Part.Shape = Enum.PartType.Ball;
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.Size = Vector3.new(6, 6, 6);
                Part.Transparency = 0.65;
                Part.Color = Color3.fromRGB(255, 50, 80);
                Part.CFrame = CFrame.new(v85 + Vector3.new(0, 2, 0));
                Part.Parent = workspace;
                TweenService:Create(Part, TweenInfo.new(0.2), {
                    Transparency = 1,
                    Size = Vector3.new(18, 18, 18)
                }):Play();
                task.delay(0.22, function() -- Line: 657
                    -- upvalues: Part (copy)
                    if Part.Parent then
                        Part:Destroy();
                    end;
                end);

                return;
            end;

            if p37 == "PlaySound" then
                local id = u38.id;

                if type(id) ~= "string" then
                    return;
                end;

                local vol = u38.vol;
                local v86 = type(vol) ~= "number" and 1 or vol;
                local pitch = u38.pitch;
                local v87 = type(pitch) ~= "number" and 1 or pitch;
                local u88 = u38.global == true;
                local u89;

                if u88 then
                    u89 = workspace.CurrentCamera or LocalPlayer:FindFirstChild("PlayerGui");
                else
                    local x = u38.x;
                    local v90 = type(x) ~= "number" and 0 or x;
                    local y = u38.y;
                    local v91 = type(y) ~= "number" and 0 or y;
                    local z = u38.z;
                    local v92 = type(z) ~= "number" and 0 or z;
                    local v93 = Vector3.new(v90, v91, v92);
                    u89 = Instance.new("Part");
                    u89.Transparency = 1;
                    u89.Anchored = true;
                    u89.CanCollide = false;
                    u89.CFrame = CFrame.new(v93);
                    u89.Parent = workspace;
                end;

                if not u89 then
                    return;
                end;

                local Sound = Instance.new("Sound");
                Sound.SoundId = id;
                Sound.Volume = v86;
                Sound.PlaybackSpeed = v87;
                Sound.Parent = u89;
                local minDist = u38.minDist;
                local v94 = type(minDist) ~= "number" and 0 or minDist;
                local maxDist = u38.maxDist;
                local v95 = type(maxDist) ~= "number" and 0 or maxDist;

                if v94 > 0 then
                    Sound.RollOffMinDistance = v94;
                end;

                if v95 > 0 then
                    Sound.RollOffMaxDistance = v95;
                end;

                Sound:Play();
                Sound.Ended:Connect(function() -- Line: 698
                    -- upvalues: u88 (copy), u89 (ref), Sound (copy)
                    if u88 then
                        Sound:Destroy();

                        return;
                    end;

                    u89:Destroy();
                end);
                task.delay(10, function() -- Line: 706
                    -- upvalues: u88 (copy), u89 (ref), Sound (copy)
                    if u88 or not (u89 and u89.Parent) then
                        if u88 and Sound.Parent then
                            Sound:Destroy();
                        end;

                        return;
                    end;

                    u89:Destroy();
                end);

                return;
            end;

            if p37 == "StopSound" then
                local id = u38.id;

                if type(id) ~= "string" then
                    return;
                end;

                for _, v in { workspace.CurrentCamera, LocalPlayer:FindFirstChild("PlayerGui") } do
                    if v then
                        for _, child in v:GetChildren() do
                            if child:IsA("Sound") and child.SoundId == id then
                                child:Stop();
                                child:Destroy();
                            end;
                        end;
                    end;
                end;

                return;
            end;

            if p37 == "ScreenShake" then
                local intensity = u38.intensity;
                local u96 = type(intensity) ~= "number" and 1 or intensity;
                local duration = u38.duration;
                local u97 = type(duration) ~= "number" and 0.5 or duration;
                local x = u38.x;
                local y = u38.y;
                local z = u38.z;
                local CurrentCamera = workspace.CurrentCamera;

                if CurrentCamera then
                    if type(x) == "number" and (type(y) == "number" and type(z) == "number") then
                        local Magnitude = (CurrentCamera.CFrame.Position - Vector3.new(x, y, z)).Magnitude;

                        if Magnitude > 150 then
                            return;
                        end;

                        u96 = u96 * math.clamp(1 - Magnitude / 150, 0, 1);
                    end;

                    if u96 <= 0.01 then
                        return;
                    end;

                    task.spawn(function() -- Line: 743
                        -- upvalues: u97 (copy), u96 (ref), CurrentCamera (copy), RunService (ref)
                        local v98 = os.clock();

                        while os.clock() - v98 < u97 do
                            local v99 = u96 * (1 - (os.clock() - v98) / u97);
                            CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new((math.random() - 0.5) * v99, (math.random() - 0.5) * v99, (math.random() - 0.5) * v99);
                            RunService.RenderStepped:Wait();
                        end;
                    end);
                end;

                return;
            end;

            if p37 == "DustPuff" then
                local x = u38.x;
                local v100 = type(x) ~= "number" and 0 or x;
                local y = u38.y;
                local v101 = type(y) ~= "number" and 0 or y;
                local z = u38.z;
                local v102 = type(z) ~= "number" and 0 or z;
                local v103 = Vector3.new(v100, v101, v102);
                local Part = Instance.new("Part");
                Part.Transparency = 1;
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CFrame = CFrame.new(v103);
                Part.Parent = workspace;
                local Attachment = Instance.new("Attachment");
                Attachment.Parent = Part;
                local ParticleEmitter = Instance.new("ParticleEmitter");
                ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(200, 200, 200));
                ParticleEmitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 2), NumberSequenceKeypoint.new(1, 0) });
                ParticleEmitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.2, 0.5), NumberSequenceKeypoint.new(1, 1) });
                ParticleEmitter.Lifetime = NumberRange.new(0.5, 1);
                ParticleEmitter.Rate = 0;
                ParticleEmitter.Speed = NumberRange.new(5, 10);
                ParticleEmitter.SpreadAngle = Vector2.new(0, 360);
                ParticleEmitter.Parent = Attachment;
                ParticleEmitter:Emit(15);
                task.delay(1.5, function() -- Line: 780
                    -- upvalues: Part (copy)
                    Part:Destroy();
                end);

                return;
            end;

            if p37 == "MapBreak" then
                local CurrentCamera = workspace.CurrentCamera;

                if CurrentCamera then
                    local CFrame2 = CurrentCamera.CFrame;
                    task.spawn(function() -- Line: 787
                        -- upvalues: CurrentCamera (copy), CFrame2 (copy)
                        for _ = 1, 8 do
                            if not CurrentCamera or CurrentCamera.Parent == nil then
                                break;
                            end;

                            CurrentCamera.CFrame = CFrame2 * CFrame.new((math.random() - 0.5) * 0.8, (math.random() - 0.5) * 0.6, 0);
                            task.wait(0.03);
                        end;

                        if CurrentCamera then
                            CurrentCamera.CFrame = CFrame2;
                        end;
                    end);
                end;
            elseif p37 == "SetCamera" then
                local CurrentCamera = workspace.CurrentCamera;

                if not CurrentCamera then
                    return;
                end;

                local type2 = u38.type;

                if type2 == "Reset" then
                    task.wait(0.1);
                    u26 = false;
                    CurrentCamera.CameraType = Enum.CameraType.Custom;
                    local Character = Players.LocalPlayer.Character;
                    local v104 = Character and Character:FindFirstChild("Humanoid");

                    if v104 then
                        CurrentCamera.CameraSubject = v104;
                    end;

                    return;
                end;

                local new = CFrame.new;
                local cx = u38.cx;
                local v105 = type(cx) ~= "number" and 0 or cx;
                local cy = u38.cy;
                local v106 = type(cy) ~= "number" and 0 or cy;
                local cz = u38.cz;
                local v107 = new(v105, v106, type(cz) ~= "number" and 0 or cz);
                local tx = u38.tx;
                local v108 = type(tx) ~= "number" and 0 or tx;
                local ty = u38.ty;
                local v109 = type(ty) ~= "number" and 0 or ty;
                local tz = u38.tz;
                local v110 = type(tz) ~= "number" and 0 or tz;
                local v111 = Vector3.new(v108, v109, v110);
                local v112 = CFrame.lookAt(v107.Position, v111);
                u26 = true;
                CurrentCamera.CameraType = Enum.CameraType.Scriptable;
                CurrentCamera.CameraSubject = nil;

                if type2 == "Fixed" then
                    CurrentCamera.CFrame = v112;

                    return;
                end;

                if type2 == "Tween" then
                    local dur = u38.dur;
                    local v113 = type(dur) ~= "number" and 2 or dur;
                    TweenService:Create(CurrentCamera, TweenInfo.new(v113, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                        CFrame = v112
                    }):Play();
                end;
            elseif p37 == "Presentation" then
                u26 = true;
                local CurrentCamera = workspace.CurrentCamera;

                if CurrentCamera then
                    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
                    CurrentCamera.CameraSubject = nil;
                end;

                task.wait(1);

                if not CurrentCamera then
                    return;
                end;

                local BossRig_Live = workspace:FindFirstChild("BossRig_Live");

                if not BossRig_Live then
                    for _, child in workspace:GetChildren() do
                        if child.Name:find("Boss") then
                            BossRig_Live = child;
                            break;
                        end;
                    end;
                end;

                local v114 = not BossRig_Live and Vector3.new(0, 20, -320) or BossRig_Live:GetPivot().Position;
                local _ = CurrentCamera.CFrame;
                local v115 = CFrame.lookAt(v114 + Vector3.new(0, 25, 60), v114);
                local v116 = TweenService:Create(CurrentCamera, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    CFrame = v115
                });
                v116:Play();
                v116.Completed:Connect(function() -- Line: 863
                    -- upvalues: ensureUi (ref), u26 (ref), CurrentCamera (copy), LocalPlayer (ref)
                    ensureUi();
                    task.wait(0.5);
                    u26 = false;
                    CurrentCamera.CameraType = Enum.CameraType.Custom;
                    local v117 = LocalPlayer.Character and v117:FindFirstChildOfClass("Humanoid");

                    if v117 then
                        CurrentCamera.CameraSubject = v117;
                    end;
                end);
            end;
        end);
    end;
end;

return {
    Hidden = true,
    IsAdminAbuse = true,

    Stop = function() -- Line: 880, Name: bossModuleStop
        -- upvalues: destroyUi (copy)
        destroyUi();
    end,

    Fire = function() -- Line: 884, Name: bossModuleFire
        -- upvalues: destroyUi (copy), wireBossRemoteListeners (copy)
        destroyUi();
        wireBossRemoteListeners();
    end
};