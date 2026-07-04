-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.FoeCakesBossRoom
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Debris = game:GetService("Debris");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Remotes = ReplicatedStorage:WaitForChild("AdminAbuse"):WaitForChild("Remotes");
local FoeCakesBossAnimIds = require(script:FindFirstChild("FoeCakesBossAnimIds"));
local _ = require(script:FindFirstChild("FoeCakesBossSoundIds")).SFX;
local Soundtracks = require(script:FindFirstChild("FoeCakesBossSoundIds")).Soundtracks;
local FoeCakesCutscenes = require(script:FindFirstChild("FoeCakesCutscenes"));
local camerashaker = require(ReplicatedStorage.Packages.camerashaker);
local AdminAbuseBossFx = Remotes:WaitForChild("AdminAbuseBossFx");
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = 1;
local u10 = 0;
local u11 = false;
local u12 = {};
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local identity = CFrame.identity;
local identity2 = CFrame.identity;
local u17 = {};
local u18 = nil;
local u19 = {};
local u20 = nil;
local u21 = false;
local u22 = 1;
local u23 = 0;
local Animation = Instance.new("Animation");
Animation.AnimationId = FoeCakesBossAnimIds.Laugh;
local u24 = nil;
local u25 = nil;
local u26 = nil;
local u27 = nil;
local u28 = nil;
local u29 = 0;

local function hideTaggedUI() -- Line: 70
    -- upvalues: Players (copy), u17 (copy), CollectionService (copy)
    local v30 = Players.LocalPlayer and v30:FindFirstChild("PlayerGui");

    if not v30 then
        return;
    end;

    table.clear(u17);

    for _, v in CollectionService:GetTagged("UI") do
        if v:IsA("Frame") and v:IsDescendantOf(v30) then
            u17[v] = v.Visible;
            v.Visible = false;
        end;
    end;
end;

local function restoreTaggedUI() -- Line: 83
    -- upvalues: u17 (copy)
    for i, v in u17 do
        if i and i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(u17);
end;

local function forceEndCinematic() -- Line: 90
    -- upvalues: u17 (copy)
    for i, v in u17 do
        if i and i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(u17);
end;

local function getClientDebrisFolder() -- Line: 95
    local v31 = workspace:FindFirstChild("AdminAbuse") and v31:FindFirstChild("Map") and v31:FindFirstChild("Debris", true);

    return v31 or workspace;
end;

local function getSoundtrackIndex(p32) -- Line: 104
    return p32 >= 7 and 3 or (p32 >= 4 and 2 or 1);
end;

local function stopSoundtrack() -- Line: 111
    -- upvalues: u23 (ref), u18 (ref), TweenService (copy)
    u23 = 0;

    if u18 and u18.Parent then
        local u33 = u18;
        local u34 = TweenService:Create(u33, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Volume = 0
        });
        u34:Play();
        u34.Completed:Once(function() -- Line: 119
            -- upvalues: u33 (copy), u34 (copy)
            u33:Stop();
            u33:Destroy();
            u34:Destroy();
        end);
    end;

    u18 = nil;
end;

local function startSoundtrack(p35) -- Line: 126
    -- upvalues: u22 (ref), stopSoundtrack (copy), Soundtracks (copy), Players (copy), u18 (ref), u23 (ref), TweenService (copy)
    local v36 = p35 or u22;
    local v37 = v36 >= 7 and 3 or (v36 >= 4 and 2 or 1);
    stopSoundtrack();
    local v38 = Soundtracks[v37];

    if not v38 then
        return;
    end;

    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return;
    end;

    local Sound = Instance.new("Sound");
    Sound.Name = "FoeCakesBossMusic";
    Sound.SoundId = "rbxassetid://" .. tostring(v38);
    Sound.Looped = true;
    Sound.Volume = 0;
    Sound.Parent = LocalPlayer;
    u18 = Sound;
    u23 = v37;
    task.spawn(function() -- Line: 141
        -- upvalues: Sound (copy), TweenService (ref)
        if not Sound.IsLoaded then
            Sound.Loaded:Wait();
        end;

        if not (Sound and Sound.Parent) then
            return;
        end;

        Sound:Play();
        TweenService:Create(Sound, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Volume = 0.5
        }):Play();
    end);
end;

local function getLiveBossRig() -- Line: 154
    local v39 = workspace:FindFirstChild("AdminAbuse") and v39:FindFirstChild("Map");

    if not v39 then
        return nil;
    end;

    for _, child in v39:GetChildren() do
        if child:IsA("Model") and child:GetAttribute("AdminAbuseLiveMap") then
            local BossRig = child:FindFirstChild("BossRig");

            if BossRig and BossRig:IsA("Model") then
                return BossRig;
            end;

            return nil;
        end;
    end;

    return nil;
end;

local function startLaughLoop() -- Line: 167
    -- upvalues: u21 (ref), getLiveBossRig (copy), Animation (copy), Debris (copy)
    u21 = true;
    local u40 = Random.new();
    task.spawn(function() -- Line: 170
        -- upvalues: u21 (ref), u40 (copy), getLiveBossRig (ref), Animation (ref), Debris (ref)
        while u21 do
            task.wait(u40:NextNumber(15, 35));

            if not u21 then
                break;
            end;

            local v41 = getLiveBossRig();

            if v41 then
                local v42 = v41:FindFirstChildOfClass("Humanoid");
                local v43 = v42 and v42:FindFirstChildOfClass("Animator") or v41:FindFirstChildOfClass("Animator");

                if v43 then
                    local v44 = v43:LoadAnimation(Animation);
                    v44.Looped = true;
                    v44.Priority = Enum.AnimationPriority.Action;
                    v44:Play(0.5);
                    local Sound = Instance.new("Sound");
                    Sound.SoundId = "rbxassetid://4810729995";
                    Sound.Volume = 4.5;
                    Sound.Parent = v41.PrimaryPart or v41;
                    Sound:Play();
                    Debris:AddItem(Sound, 20);
                    local u45 = false;
                    local v46 = Sound.Ended:Connect(function() -- Line: 196
                        -- upvalues: u45 (ref)
                        u45 = true;
                    end);
                    local v47 = 0;

                    repeat
                        v47 = v47 + task.wait(0.1);
                    until u45 or (not u21 or v47 > 15);

                    v46:Disconnect();
                    Sound:Stop();
                    v44:Stop(0.5);
                end;
            end;
        end;
    end);
end;

local function refreshBar() -- Line: 211
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u9 (ref), u12 (copy)
    local v48 = u2;
    local v49 = u3;
    local v50 = u5;

    if not v50 or (not v48 or u9 <= 0) then
        return;
    end;

    local v51 = math.clamp(v50.Value, 0, u9);
    v48.Size = UDim2.new(math.clamp(v51 / u9, 0, 1), 0, 1, 0);

    if v49 then
        if u9 >= 1000000 then
            v49.Text = string.format("%.3fM / %.1fM", v51 / 1000000, u9 / 1000000);
        else
            v49.Text = string.format("%d / %d", math.floor(v51 + 0.5), (math.floor(u9 + 0.5)));
        end;
    end;

    local v52 = v51 / u9;

    for i, v in ipairs(u12) do
        local v53 = i * 0.1 <= v52;
        local v54;

        if v53 then
            v54 = Color3.fromRGB(220, 30, 60);
        else
            v54 = Color3.fromRGB(95, 95, 105);
        end;

        v.BackgroundColor3 = v54;
        v.BackgroundTransparency = v53 and 0.05 or 0.35;
    end;
end;

local function onBossHpSync(p55, p56, p57) -- Line: 234
    -- upvalues: u10 (ref), u9 (ref), u6 (ref), u11 (ref), u5 (ref), refreshBar (copy), TweenService (copy)
    if type(p55) ~= "number" then
        return;
    end;

    if type(p56) ~= "number" then
        p56 = p55;
    end;

    if p56 <= 0 then
        return;
    end;

    if type(p57) == "number" and p57 < u10 then
        return;
    end;

    if type(p57) == "number" then
        u10 = p57;
    end;

    u9 = p56;

    if u6 then
        u6:Cancel();
        u6 = nil;
    end;

    local v58 = math.clamp(p55, 0, p56);

    if not u11 then
        u11 = true;

        if u5 then
            u5.Value = v58;
        end;

        refreshBar();

        return;
    end;

    local v59 = u5;

    if not v59 then
        return;
    end;

    local v60 = TweenService:Create(v59, TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Value = v58
    });
    u6 = v60;
    v60:Play();
end;

local function destroyUi() -- Line: 258
    -- upvalues: u6 (ref), u7 (ref), u14 (ref), u13 (ref), u1 (ref), u12 (copy), u2 (ref), u3 (ref), u4 (ref), u5 (ref), u10 (ref), u9 (ref), u11 (ref)
    if u6 then
        u6:Cancel();
        u6 = nil;
    end;

    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    if u14 then
        u14:Cancel();
        u14:Destroy();
        u14 = nil;
    end;

    if u13 then
        u13:Destroy();
        u13 = nil;
    end;

    if u1 then
        u1:Destroy();
        u1 = nil;
    end;

    table.clear(u12);
    u2 = nil;
    u3 = nil;
    u4 = nil;
    u5 = nil;
    u10 = 0;
    u9 = 1;
    u11 = false;
end;

local function applyPhase4BossBarStyle() -- Line: 269
    -- upvalues: u2 (ref), TweenService (copy), u14 (ref), u13 (ref)
    if not u2 then
        return;
    end;

    local u61 = TweenService:Create(u2, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(160, 160, 160)
    });
    u61:Play();
    u61.Completed:Once(function() -- Line: 275
        -- upvalues: u61 (copy)
        u61:Destroy();
    end);

    if u14 then
        u14:Cancel();
        u14:Destroy();
        u14 = nil;
    end;

    if u13 then
        u13:Destroy();
    end;

    local UIGradient = Instance.new("UIGradient");
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(10, 10, 10)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(220, 220, 220)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
    });
    UIGradient.Rotation = 0;
    UIGradient.Offset = Vector2.new(-0.6, 0);
    UIGradient.Parent = u2;
    u13 = UIGradient;
    u14 = TweenService:Create(UIGradient, TweenInfo.new(4.1887902047863905, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Offset = Vector2.new(0.6, 0)
    });
    u14:Play();
end;

local function applyPhase8BossBarStyle() -- Line: 300
    -- upvalues: u2 (ref), TweenService (copy), u14 (ref), u13 (ref)
    if not u2 then
        return;
    end;

    local u62 = TweenService:Create(u2, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(120, 0, 160)
    });
    u62:Play();
    u62.Completed:Once(function() -- Line: 306
        -- upvalues: u62 (copy)
        u62:Destroy();
    end);

    if u14 then
        u14:Cancel();
        u14:Destroy();
        u14 = nil;
    end;

    if u13 then
        u13:Destroy();
    end;

    local UIGradient = Instance.new("UIGradient");
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 30, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(10, 0, 20)),
        ColorSequenceKeypoint.new(0.68, Color3.fromRGB(185, 20, 240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 0, 10))
    });
    UIGradient.Rotation = 0;
    UIGradient.Offset = Vector2.new(-0.65, 0);
    UIGradient.Parent = u2;
    u13 = UIGradient;
    u14 = TweenService:Create(UIGradient, TweenInfo.new(3.6959913571644627, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Offset = Vector2.new(0.65, 0)
    });
    u14:Play();
end;

local function buildUi() -- Line: 331
    -- upvalues: destroyUi (copy), Players (copy), u1 (ref), u2 (ref), u12 (copy), u3 (ref), refreshBar (copy), u5 (ref), u4 (ref)
    destroyUi();
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return;
    end;

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "FoeCakesBossHud";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.DisplayOrder = 80;
    ScreenGui.Parent = PlayerGui;
    u1 = ScreenGui;
    local Frame = Instance.new("Frame");
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.new(0.5, 0, 0, 45);
    Frame.Size = UDim2.new(0.6, 0, 0.08, 0);
    Frame.Parent = ScreenGui;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "ProgressBg";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.fromRGB(20, 20, 30);
    Frame2.BackgroundTransparency = 0.4;
    Frame2.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame2.Size = UDim2.new(1, 0, 0.65, 0);
    Frame2.Parent = Frame;
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0.5, 0);
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Position = UDim2.new(0, -65, 0.5, 0);
    ImageLabel.Size = UDim2.new(0, 60, 0, 60);
    ImageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=586487285&w=150&h=150";
    ImageLabel.Parent = Frame2;
    Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(1, 0);
    local UIStroke = Instance.new("UIStroke", ImageLabel);
    UIStroke.Color = Color3.fromRGB(148, 8, 8);
    UIStroke.Thickness = 2;
    local Frame3 = Instance.new("Frame", Frame2);
    Frame3.Name = "Fill";
    Frame3.BackgroundColor3 = Color3.fromRGB(148, 8, 8);
    Frame3.Size = UDim2.new(0, 0, 1, 0);
    Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0.5, 0);
    u2 = Frame3;

    for i = 1, 9 do
        local v63 = i * 0.1;
        local Frame4 = Instance.new("Frame");
        Frame4.Name = "PhaseMarker" .. i;
        Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame4.Position = UDim2.new(v63, 0, 0.5, 0);
        Frame4.Size = UDim2.new(0, 4, 1, 0);
        Frame4.BorderSizePixel = 0;
        Frame4.BackgroundColor3 = Color3.fromRGB(95, 95, 105);
        Frame4.BackgroundTransparency = 0.35;
        Frame4.ZIndex = Frame3.ZIndex + 2;
        Frame4.Parent = Frame2;
        Instance.new("UIStroke", Frame4).Thickness = 1;
        u12[i] = Frame4;
        local TextLabel = Instance.new("TextLabel");
        TextLabel.AnchorPoint = Vector2.new(0.5, 0);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.Position = UDim2.new(v63, 0, 0.5, 14);
        TextLabel.Size = UDim2.new(0, 40, 0, 16);
        TextLabel.ZIndex = Frame3.ZIndex + 3;
        TextLabel.Font = Enum.Font.GothamBold;
        TextLabel.Text = "P" .. i + 1;
        TextLabel.TextScaled = true;
        TextLabel.TextStrokeTransparency = 0.55;
        TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
        TextLabel.TextColor3 = Color3.fromRGB(190, 190, 200);
        TextLabel.Parent = Frame2;
    end;

    local TextLabel = Instance.new("TextLabel", Frame2);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Size = UDim2.new(0.45, 0, 1, 0);
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.Text = ("FoeCakes"):upper() .. " BOSS EVENT";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    Instance.new("UIPadding", TextLabel).PaddingLeft = UDim.new(0.04, 0);
    local TextLabel2 = Instance.new("TextLabel", Frame2);
    TextLabel2.AnchorPoint = Vector2.new(1, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.Position = UDim2.new(1, 0, 0, 0);
    TextLabel2.Size = UDim2.new(0.4, 0, 1, 0);
    TextLabel2.Font = Enum.Font.GothamBold;
    TextLabel2.Text = "0 / 0";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Right;
    Instance.new("UIPadding", TextLabel2).PaddingRight = UDim.new(0.04, 0);
    u3 = TextLabel2;
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = 0;
    NumberValue.Changed:Connect(refreshBar);
    u5 = NumberValue;
    local TextLabel3 = Instance.new("TextLabel", ScreenGui);
    TextLabel3.Name = "PhaseLabel";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.Position = UDim2.new(0.5, 0, 0.08, 52);
    TextLabel3.Size = UDim2.new(0.12, 0, 0, 20);
    TextLabel3.Font = Enum.Font.GothamBold;
    TextLabel3.Text = "PHASE 1";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextStrokeTransparency = 0.5;
    TextLabel3.TextStrokeColor3 = Color3.new(0, 0, 0);
    u4 = TextLabel3;
end;

local function destroyTimeshiftEffects() -- Line: 461
    -- upvalues: u24 (ref), u25 (ref), u26 (ref), u27 (ref), u28 (ref)
    if u24 then
        u24:Destroy();
        u24 = nil;
    end;

    if u25 then
        u25:Destroy();
        u25 = nil;
    end;

    if u26 then
        u26:Destroy();
        u26 = nil;
    end;

    if u27 then
        u27:Destroy();
        u27 = nil;
    end;

    if u28 then
        u28:Destroy();
        u28 = nil;
    end;
end;

local function timeshiftBegin(p64) -- Line: 469
    -- upvalues: u29 (ref), destroyTimeshiftEffects (copy), u24 (ref), TweenService (copy), Players (copy), u28 (ref), u18 (ref), u25 (ref), u26 (ref), u27 (ref)
    u29 = u29 + 1;
    destroyTimeshiftEffects();
    local Lighting = game:GetService("Lighting");
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.Name = "FoeCakesTimeshiftCC";
    ColorCorrectionEffect.Saturation = 0;
    ColorCorrectionEffect.Contrast = 0;
    ColorCorrectionEffect.Brightness = 0;
    ColorCorrectionEffect.TintColor = Color3.fromRGB(255, 255, 255);
    ColorCorrectionEffect.Parent = Lighting;
    u24 = ColorCorrectionEffect;
    TweenService:Create(ColorCorrectionEffect, TweenInfo.new(p64, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Saturation = -1,
        Contrast = 0.4,
        Brightness = -0.12
    }):Play();
    local v65 = Players.LocalPlayer and v65:FindFirstChild("PlayerGui");

    if v65 then
        local ScreenGui = Instance.new("ScreenGui");
        ScreenGui.Name = "FoeCakesTimeshiftFlash";
        ScreenGui.IgnoreGuiInset = true;
        ScreenGui.ResetOnSpawn = false;
        ScreenGui.DisplayOrder = 1000000;
        ScreenGui.Parent = v65;
        local Frame = Instance.new("Frame");
        Frame.Size = UDim2.fromScale(1, 1);
        Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
        Frame.BackgroundTransparency = 0;
        Frame.BorderSizePixel = 0;
        Frame.Parent = ScreenGui;
        u28 = ScreenGui;
        TweenService:Create(Frame, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        }):Play();
        task.delay(0.5, function() -- Line: 510
            -- upvalues: ScreenGui (copy), Frame (copy)
            if not ScreenGui.Parent then
                return;
            end;

            Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
            Frame.BackgroundTransparency = 0.85;
        end);
    end;

    local v66 = u18;

    if v66 and v66.Parent then
        local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect");
        EqualizerSoundEffect.LowGain = 0;
        EqualizerSoundEffect.MidGain = 0;
        EqualizerSoundEffect.HighGain = 0;
        EqualizerSoundEffect.Parent = v66;
        u25 = EqualizerSoundEffect;
        TweenService:Create(EqualizerSoundEffect, TweenInfo.new(p64, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            HighGain = -20,
            MidGain = -8,
            LowGain = 2
        }):Play();
        local ReverbSoundEffect = Instance.new("ReverbSoundEffect");
        ReverbSoundEffect.DecayTime = 1.5;
        ReverbSoundEffect.Density = 1;
        ReverbSoundEffect.WetLevel = 0;
        ReverbSoundEffect.DryLevel = 0;
        ReverbSoundEffect.Parent = v66;
        u26 = ReverbSoundEffect;
        TweenService:Create(ReverbSoundEffect, TweenInfo.new(p64, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            DecayTime = 3,
            WetLevel = 6,
            DryLevel = -3
        }):Play();
        local PitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect");
        PitchShiftSoundEffect.Octave = 1;
        PitchShiftSoundEffect.Parent = v66;
        u27 = PitchShiftSoundEffect;
        TweenService:Create(PitchShiftSoundEffect, TweenInfo.new(p64, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Octave = 0.7
        }):Play();
    end;
end;

local function timeshiftEnd(p67) -- Line: 555
    -- upvalues: u29 (ref), u24 (ref), u25 (ref), u26 (ref), u27 (ref), u28 (ref), TweenService (copy), destroyTimeshiftEffects (copy)
    u29 = u29 + 1;
    local u68 = u29;
    local v69 = u24;
    local v70 = u25;
    local v71 = u26;
    local v72 = u27;
    local v73 = u28;

    if v69 then
        TweenService:Create(v69, TweenInfo.new(p67, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Saturation = 0,
            Contrast = 0,
            Brightness = 0
        }):Play();
    end;

    if v70 then
        TweenService:Create(v70, TweenInfo.new(p67, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            HighGain = 0,
            MidGain = 0,
            LowGain = 0
        }):Play();
    end;

    if v71 then
        TweenService:Create(v71, TweenInfo.new(p67, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            WetLevel = 0,
            DryLevel = 0
        }):Play();
    end;

    if v72 then
        TweenService:Create(v72, TweenInfo.new(p67, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Octave = 1
        }):Play();
    end;

    if v73 and v73:FindFirstChildOfClass("Frame") then
        TweenService:Create(v73:FindFirstChildOfClass("Frame"), TweenInfo.new(p67, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        }):Play();
    end;

    task.delay(p67 + 0.05, function() -- Line: 597
        -- upvalues: u68 (copy), u29 (ref), destroyTimeshiftEffects (ref)
        if u68 ~= u29 then
            return;
        end;

        destroyTimeshiftEffects();
    end);
end;

local function showFakeAnnouncement(p74) -- Line: 607
    -- upvalues: Players (copy), ReplicatedStorage (copy), TweenService (copy)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
    local NotificationFrame = ReplicatedStorage:FindFirstChild("NotificationFrame");

    if not NotificationFrame then
        return;
    end;

    local u75 = NotificationFrame:Clone();
    local Avatar = u75:FindFirstChild("Avatar");

    if Avatar and Avatar:IsA("ImageLabel") then
        local success, result = pcall(function() -- Line: 624
            -- upvalues: Players (ref)
            return Players:GetUserThumbnailAsync(586487285, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100);
        end);

        if success and result then
            Avatar.Image = result;
        end;
    end;

    local Text = u75:FindFirstChild("Text");

    if Text and Text:IsA("TextLabel") then
        Text.RichText = true;
        Text.Text = "<font color=\"rgb(255,120,200)\"><b>FoeCakes</b></font> : " .. p74;
    end;

    local u76 = {};
    local u77 = {};

    for _, descendant in u75:GetDescendants() do
        if descendant:IsA("UIStroke") then
            table.insert(u76, {
                prop = "Transparency",
                obj = descendant
            });
        elseif descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            table.insert(u76, {
                prop = "TextTransparency",
                obj = descendant
            });

            if descendant.BackgroundTransparency < 1 then
                table.insert(u76, {
                    prop = "BackgroundTransparency",
                    obj = descendant
                });
            end;
        elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
            table.insert(u76, {
                prop = "ImageTransparency",
                obj = descendant
            });

            if descendant.BackgroundTransparency < 1 then
                table.insert(u76, {
                    prop = "BackgroundTransparency",
                    obj = descendant
                });
            end;
        elseif descendant:IsA("Frame") and descendant.BackgroundTransparency < 1 then
            table.insert(u76, {
                prop = "BackgroundTransparency",
                obj = descendant
            });
        end;

        if descendant:IsA("UIGradient") then
            table.insert(u77, {
                obj = descendant,
                original = descendant.Transparency
            });
        end;
    end;

    if u75:IsA("Frame") and u75.BackgroundTransparency < 1 then
        table.insert(u76, {
            prop = "BackgroundTransparency",
            obj = u75
        });
    end;

    local v78 = {};

    for i, v in ipairs(u76) do
        v78[i] = v.obj[v.prop];
        v.obj[v.prop] = 1;
    end;

    local u79 = NumberSequence.new(1);

    for _, v in ipairs(u77) do
        v.obj.Transparency = u79;
    end;

    local AdminAnnounce = PlayerGui:FindFirstChild("AdminAnnounce");

    if AdminAnnounce and AdminAnnounce:IsA("ScreenGui") then
        AdminAnnounce.DisplayOrder = 1000001;
    end;

    if AdminAnnounce then
        AdminAnnounce = AdminAnnounce:FindFirstChild("MainFrame");
    end;

    local u80 = nil;

    if AdminAnnounce then
        u75.Parent = AdminAnnounce;
    else
        u80 = Instance.new("ScreenGui");
        u80.Name = "FakeAnnounce";
        u80.IgnoreGuiInset = true;
        u80.DisplayOrder = 1000001;
        u80.Parent = PlayerGui;
        u75.Parent = u80;
    end;

    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://98797174600699";
    Sound.Volume = 0.4;
    Sound.Parent = PlayerGui;
    Sound:Play();
    game:GetService("Debris"):AddItem(Sound, 5);
    local v81 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

    for i, v in ipairs(u76) do
        TweenService:Create(v.obj, v81, {
            [v.prop] = v78[i]
        }):Play();
    end;

    for _, v in ipairs(u77) do
        v.obj.Transparency = v.original;
    end;

    task.delay(3.5, function() -- Line: 705
        -- upvalues: u76 (copy), TweenService (ref), u77 (copy), u79 (copy), u75 (copy), u80 (ref)
        local v82 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

        for _, v in ipairs(u76) do
            TweenService:Create(v.obj, v82, {
                [v.prop] = 1
            }):Play();
        end;

        for _, v in ipairs(u77) do
            v.obj.Transparency = u79;
        end;

        task.delay(0.5, function() -- Line: 713
            -- upvalues: u75 (ref), u80 (ref)
            if u75 and u75.Parent then
                u75:Destroy();
            end;

            if u80 and u80.Parent then
                u80:Destroy();
            end;
        end);
    end);
end;

local function handlePlaySound(p83) -- Line: 722
    -- upvalues: Players (copy), Debris (copy), u19 (copy)
    local v84 = tostring(p83.id or "");

    if v84 == "" then
        return;
    end;

    local v85 = tonumber(p83.vol) or 1;
    local v86 = tonumber(p83.pitch) or 1;
    local v87 = p83.global == true;
    local Sound = Instance.new("Sound");
    Sound.SoundId = v84;
    Sound.Volume = v85;
    Sound.PlaybackSpeed = v86;

    if v87 then
        Sound.Parent = Players.LocalPlayer or workspace;
    else
        local v88 = tonumber(p83.x) or 0;
        local v89 = tonumber(p83.y) or 0;
        local v90 = tonumber(p83.z) or 0;
        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.Transparency = 1;
        Part.Position = Vector3.new(v88, v89, v90);
        local v91 = workspace:FindFirstChild("AdminAbuse") and v91:FindFirstChild("Map") and v91:FindFirstChild("Debris", true);
        Part.Parent = v91 or workspace;
        Debris:AddItem(Part, 12);
        local v92 = tonumber(p83.minDist);
        local v93 = tonumber(p83.maxDist);

        if v92 then
            Sound.RollOffMinDistance = v92;
        end;

        if v93 then
            Sound.RollOffMaxDistance = v93;
        end;

        Sound.Parent = Part;
    end;

    u19[v84] = Sound;
    Sound:Play();
    Debris:AddItem(Sound, 20);
end;

local function teardownFxListener() -- Line: 762
    -- upvalues: u8 (ref), u15 (ref), u17 (copy), u16 (ref), identity (ref), identity2 (ref), RunService (copy)
    if u8 then
        u8:Disconnect();
        u8 = nil;
    end;

    if u15 then
        u15:Stop();
        u15 = nil;
    end;

    for i, v in u17 do
        if i and i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(u17);
    u16 = nil;
    identity = CFrame.identity;
    identity2 = CFrame.identity;
    RunService:UnbindFromRenderStep("FoeCakesCinematicLock");
end;

local u94 = {
    [7] = 0.6,
    [8] = 0.48,
    [9] = 0.36,
    [10] = 0.25
};

local function setupFxListener() -- Line: 781
    -- upvalues: u8 (ref), u15 (ref), u17 (copy), u16 (ref), identity (ref), identity2 (ref), RunService (copy), camerashaker (copy), AdminAbuseBossFx (copy), Players (copy), hideTaggedUI (copy), TweenService (copy), u94 (copy), u22 (ref), u18 (ref), u23 (ref), startSoundtrack (copy), u4 (ref), applyPhase8BossBarStyle (copy), applyPhase4BossBarStyle (copy), u20 (ref), ReplicatedStorage (copy), Debris (copy), FoeCakesCutscenes (copy), u21 (ref), getLiveBossRig (copy), Animation (copy), stopSoundtrack (copy), u1 (ref), timeshiftBegin (copy), timeshiftEnd (copy), handlePlaySound (copy), u19 (copy), showFakeAnnouncement (copy)
    if u8 then
        u8:Disconnect();
        u8 = nil;
    end;

    if u15 then
        u15:Stop();
        u15 = nil;
    end;

    for i, v in u17 do
        if i and i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(u17);
    u16 = nil;
    identity = CFrame.identity;
    identity2 = CFrame.identity;
    RunService:UnbindFromRenderStep("FoeCakesCinematicLock");
    u15 = camerashaker.new(Enum.RenderPriority.Camera.Value, function(p95) -- Line: 784
        -- upvalues: identity (ref)
        identity = p95;
    end);
    u15:Start();
    RunService:BindToRenderStep("FoeCakesCinematicLock", Enum.RenderPriority.Camera.Value + 1, function() -- Line: 789
        -- upvalues: u16 (ref), identity2 (ref), identity (ref)
        local CurrentCamera = workspace.CurrentCamera;

        if not CurrentCamera then
            return;
        end;

        local v96 = u16;

        if v96 then
            CurrentCamera.CFrame = v96 * identity2 * identity;

            return;
        end;

        CurrentCamera.CFrame = CurrentCamera.CFrame * identity;
    end);
    u8 = AdminAbuseBossFx.OnClientEvent:Connect(function(p97, p98) -- Line: 800
        -- upvalues: u17 (ref), u16 (ref), Players (ref), hideTaggedUI (ref), TweenService (ref), u15 (ref), u94 (ref), u22 (ref), u18 (ref), u23 (ref), startSoundtrack (ref), u4 (ref), applyPhase8BossBarStyle (ref), applyPhase4BossBarStyle (ref), u20 (ref), ReplicatedStorage (ref), Debris (ref), FoeCakesCutscenes (ref), u21 (ref), getLiveBossRig (ref), Animation (ref), stopSoundtrack (ref), u1 (ref), timeshiftBegin (ref), timeshiftEnd (ref), handlePlaySound (ref), u19 (ref), showFakeAnnouncement (ref)
        if type(p97) ~= "string" then
            return;
        end;

        local u99 = type(p98) ~= "table" and {} or p98;

        local function num(p100, p101) -- Line: 804
            -- upvalues: u99 (copy)
            local v102 = u99[p100];

            if type(v102) == "number" then
                return v102;
            end;

            return p101;
        end;

        if p97 == "SetCamera" then
            local type2 = u99.type;
            local CurrentCamera = workspace.CurrentCamera;

            if not CurrentCamera then
                return;
            end;

            if type2 == "Reset" then
                for i, v in u17 do
                    if i and i.Parent then
                        i.Visible = v;
                    end;
                end;

                table.clear(u17);
                u16 = nil;
                CurrentCamera.CameraType = Enum.CameraType.Custom;
                local v103 = Players.LocalPlayer.Character and v103:FindFirstChildOfClass("Humanoid");

                if v103 then
                    CurrentCamera.CameraSubject = v103;
                end;

                return;
            end;

            local cf = u99.cf;

            if typeof(cf) ~= "CFrame" then
                return;
            end;

            hideTaggedUI();
            CurrentCamera.CameraSubject = nil;
            CurrentCamera.CameraType = Enum.CameraType.Scriptable;

            if type2 == "Fixed" then
                u16 = cf;

                return;
            end;

            if type2 == "Tween" then
                u16 = nil;
                local dur = u99.dur;
                TweenService:Create(CurrentCamera, TweenInfo.new(type(dur) ~= "number" and 2 or dur, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    CFrame = cf
                }):Play();
            end;
        elseif p97 == "ScreenShake" then
            local intensity = u99.intensity;
            local v104 = type(intensity) ~= "number" and 0.3 or intensity;
            local duration = u99.duration;
            local v105 = type(duration) ~= "number" and 0.5 or duration;
            local radius = u99.radius;

            if type(radius) == "number" then
                local v106 = Players.LocalPlayer and v106.Character and v106:FindFirstChild("HumanoidRootPart");

                if v106 then
                    local Position = v106.Position;
                    local x = u99.x;
                    local v107 = type(x) ~= "number" and 0 or x;
                    local y = u99.y;
                    local v108 = type(y) ~= "number" and 0 or y;
                    local z = u99.z;
                    local v109 = type(z) ~= "number" and 0 or z;

                    if radius < (Position - Vector3.new(v107, v108, v109)).Magnitude then
                        return;
                    end;
                end;
            end;

            if u15 then
                u15:ShakeOnce(v104 * (u94[u22] or 1), 8, 0.05, v105 * 0.85);
            end;
        elseif p97 == "PhaseChange" then
            local phase = u99.phase;
            local v110 = type(phase) ~= "number" and 1 or phase;
            local v111 = math.clamp(v110, 1, 10);
            local v112 = math.floor(v111);
            u22 = v112;

            if u18 and (v112 >= 7 and 3 or (v112 >= 4 and 2 or 1)) ~= u23 then
                startSoundtrack(v112);
            end;

            if u4 then
                u4.Text = "PHASE " .. tostring(v112);
                u4.TextColor3 = Color3.fromRGB(255, 80, 80);
                task.delay(0.5, function() -- Line: 874
                    -- upvalues: u4 (ref), TweenService (ref)
                    if u4 then
                        TweenService:Create(u4, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            TextColor3 = Color3.new(1, 1, 1)
                        }):Play();
                    end;
                end);
            end;

            if v112 >= 8 then
                applyPhase8BossBarStyle();

                return;
            end;

            if v112 >= 4 then
                applyPhase4BossBarStyle();
            end;
        else
            if p97 == "DebrisWarn" then
                local x = u99.x;
                local v113 = type(x) ~= "number" and 0 or x;
                local y = u99.y;
                local v114 = type(y) ~= "number" and 0 or y;
                local z = u99.z;
                local v115 = type(z) ~= "number" and 0 or z;
                local v116 = Vector3.new(v113, v114, v115);
                local radius = u99.radius;
                local u117 = type(radius) ~= "number" and 6 or radius;
                local t = u99.t;
                local v118 = type(t) ~= "number" and 2.5 or t;
                local Part = Instance.new("Part");
                Part.Name = "FoeCakesDebrisWarnFx";
                Part.Shape = Enum.PartType.Cylinder;
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CanQuery = false;
                Part.Material = Enum.Material.Neon;
                Part.Color = Color3.fromRGB(255, 55, 55);
                Part.Transparency = 0.3;
                Part.Size = Vector3.new(0.05, u117 * 2, u117 * 2);
                Part.CFrame = CFrame.fromMatrix(v116 + Vector3.new(0, 2, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, -1));
                local v119 = workspace:FindFirstChild("AdminAbuse") and v119:FindFirstChild("Map") and v119:FindFirstChild("Debris", true);
                Part.Parent = v119 or workspace;
                local u120 = TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = Vector3.new(2, u117 * 2, u117 * 2)
                });
                u120:Play();
                u120.Completed:Connect(function() -- Line: 914
                    -- upvalues: u120 (copy)
                    u120:Destroy();
                end);
                local u121 = TweenService:Create(Part, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                    Transparency = 0.75
                });
                task.delay(0.15, function() -- Line: 919
                    -- upvalues: Part (copy), u121 (copy)
                    if Part.Parent then
                        u121:Play();
                    end;
                end);
                task.delay(math.max(0, v118 - 0.2), function() -- Line: 923
                    -- upvalues: Part (copy), u121 (copy), TweenService (ref), u117 (copy)
                    if not Part.Parent then
                        u121:Destroy();

                        return;
                    end;

                    u121:Cancel();
                    u121:Destroy();
                    local u122 = TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Transparency = 1,
                        Size = Vector3.new(0.05, u117 * 2, u117 * 2)
                    });
                    u122.Completed:Once(function() -- Line: 930
                        -- upvalues: u122 (copy), Part (ref)
                        u122:Destroy();

                        if Part.Parent then
                            Part:Destroy();
                        end;
                    end);
                    u122:Play();
                end);

                return;
            end;

            if p97 == "DebrisLand" then
                local x = u99.x;
                local v123 = type(x) ~= "number" and 0 or x;
                local y = u99.y;
                local v124 = type(y) ~= "number" and 0 or y;
                local z = u99.z;
                local v125 = type(z) ~= "number" and 0 or z;
                local v126 = Vector3.new(v123, v124, v125);
                local Part = Instance.new("Part");
                Part.Name = "FoeCakesDebrisLandFx";
                Part.Shape = Enum.PartType.Cylinder;
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CanQuery = false;
                Part.Material = Enum.Material.Neon;
                Part.Color = Color3.fromRGB(255, 190, 80);
                Part.Transparency = 0.15;
                Part.Size = Vector3.new(1, 1, 1);
                Part.CFrame = CFrame.fromMatrix(v126 + Vector3.new(0, 0.5, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, -1));
                local v127 = workspace:FindFirstChild("AdminAbuse") and v127:FindFirstChild("Map") and v127:FindFirstChild("Debris", true);
                Part.Parent = v127 or workspace;
                local u128 = TweenService:Create(Part, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Transparency = 1,
                    Size = Vector3.new(1, 22, 22)
                });
                u128.Completed:Once(function() -- Line: 959
                    -- upvalues: u128 (copy), Part (copy)
                    u128:Destroy();

                    if Part.Parent then
                        Part:Destroy();
                    end;
                end);
                u128:Play();

                return;
            end;

            if p97 == "DustPuff" then
                local x = u99.x;
                local v129 = type(x) ~= "number" and 0 or x;
                local y = u99.y;
                local v130 = type(y) ~= "number" and 0 or y;
                local z = u99.z;
                local v131 = type(z) ~= "number" and 0 or z;
                local v132 = Vector3.new(v129, v130, v131);
                local Part = Instance.new("Part");
                Part.Name = "FoeCakesDustPuffFx";
                Part.Shape = Enum.PartType.Cylinder;
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CanQuery = false;
                Part.Material = Enum.Material.Neon;
                Part.Color = Color3.fromRGB(210, 185, 155);
                Part.Transparency = 0.5;
                Part.Size = Vector3.new(0.4, 0.4, 0.4);
                Part.CFrame = CFrame.fromMatrix(v132 + Vector3.new(0, 0.2, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, -1));
                local v133 = workspace:FindFirstChild("AdminAbuse") and v133:FindFirstChild("Map") and v133:FindFirstChild("Debris", true);
                Part.Parent = v133 or workspace;
                local u134 = TweenService:Create(Part, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Transparency = 1,
                    Size = Vector3.new(0.4, 6, 6)
                });
                u134.Completed:Once(function() -- Line: 987
                    -- upvalues: u134 (copy), Part (copy)
                    u134:Destroy();

                    if Part.Parent then
                        Part:Destroy();
                    end;
                end);
                u134:Play();

                return;
            end;

            if p97 == "ZoneWarn" then
                local x = u99.x;
                local v135 = type(x) ~= "number" and 0 or x;
                local y = u99.y;
                local v136 = type(y) ~= "number" and 0 or y;
                local z = u99.z;
                local v137 = type(z) ~= "number" and 0 or z;
                local v138 = Vector3.new(v135, v136, v137);
                local hx = u99.hx;
                local u139 = type(hx) ~= "number" and 9 or hx;
                local hz = u99.hz;
                local u140 = type(hz) ~= "number" and 9 or hz;
                local t = u99.t;
                local v141 = type(t) ~= "number" and 1.4 or t;
                local Part = Instance.new("Part");
                Part.Name = "FoeCakesZoneWarnFx";
                Part.Shape = Enum.PartType.Cylinder;
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CanQuery = false;
                Part.Material = Enum.Material.Neon;
                Part.Color = Color3.fromRGB(220, 80, 80);
                Part.Transparency = 0.3;
                Part.Size = Vector3.new(0.05, u139 * 2, u140 * 2);
                Part.CFrame = CFrame.fromMatrix(v138 + Vector3.new(0, 2.5, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, -1));
                local v142 = workspace:FindFirstChild("AdminAbuse") and v142:FindFirstChild("Map") and v142:FindFirstChild("Debris", true);
                Part.Parent = v142 or workspace;
                local u143 = TweenService:Create(Part, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = Vector3.new(3, u139 * 2, u140 * 2)
                });
                u143:Play();
                u143.Completed:Connect(function() -- Line: 1019
                    -- upvalues: u143 (copy)
                    u143:Destroy();
                end);
                local u144 = TweenService:Create(Part, TweenInfo.new(0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                    Transparency = 0.72
                });
                task.delay(0.2, function() -- Line: 1024
                    -- upvalues: Part (copy), u144 (copy)
                    if Part.Parent then
                        u144:Play();
                    end;
                end);
                task.delay(math.max(0, v141 - 0.2), function() -- Line: 1028
                    -- upvalues: Part (copy), u144 (copy), TweenService (ref), u139 (copy), u140 (copy)
                    if not Part.Parent then
                        u144:Destroy();

                        return;
                    end;

                    u144:Cancel();
                    u144:Destroy();
                    local u145 = TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Transparency = 1,
                        Size = Vector3.new(0.05, u139 * 2, u140 * 2)
                    });
                    u145.Completed:Once(function() -- Line: 1035
                        -- upvalues: u145 (copy), Part (ref)
                        u145:Destroy();

                        if Part.Parent then
                            Part:Destroy();
                        end;
                    end);
                    u145:Play();
                end);

                return;
            end;

            if p97 == "ZoneHit" then
                local x = u99.x;
                local v146 = type(x) ~= "number" and 0 or x;
                local y = u99.y;
                local v147 = type(y) ~= "number" and 0 or y;
                local z = u99.z;
                local v148 = type(z) ~= "number" and 0 or z;
                local v149 = Vector3.new(v146, v147, v148);
                local hx = u99.hx;
                local v150 = type(hx) ~= "number" and 9 or hx;
                local hz = u99.hz;
                local v151 = type(hz) ~= "number" and 9 or hz;
                local Part = Instance.new("Part");
                Part.Name = "FoeCakesZoneJetFx";
                Part.Shape = Enum.PartType.Cylinder;
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CanQuery = false;
                Part.Material = Enum.Material.Neon;
                Part.Color = Color3.fromRGB(255, 80, 80);
                Part.Transparency = 0.15;
                Part.Size = Vector3.new(2, v150 * 1.6, v151 * 1.6);
                Part.CFrame = CFrame.fromMatrix(v149 - Vector3.new(0, 4, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, -1));
                local v152 = workspace:FindFirstChild("AdminAbuse") and v152:FindFirstChild("Map") and v152:FindFirstChild("Debris", true);
                Part.Parent = v152 or workspace;
                local u153 = TweenService:Create(Part, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = Vector3.new(120, v150 * 1.9, v151 * 1.9),
                    CFrame = CFrame.fromMatrix(v149 + Vector3.new(0, 56, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, -1))
                });
                u153:Play();
                task.delay(0.35, function() -- Line: 1072
                    -- upvalues: u153 (copy), Part (copy), TweenService (ref)
                    u153:Destroy();

                    if not Part.Parent then
                        return;
                    end;

                    local u154 = TweenService:Create(Part, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                        Transparency = 1,
                        Size = Vector3.new(120, 0.1, 0.1)
                    });
                    u154.Completed:Once(function() -- Line: 1078
                        -- upvalues: u154 (copy), Part (ref)
                        u154:Destroy();

                        if Part.Parent then
                            Part:Destroy();
                        end;
                    end);
                    u154:Play();
                end);

                return;
            end;

            if p97 == "EyeWarn" then
                local x = u99.x;
                local v155 = type(x) ~= "number" and 0 or x;
                local y = u99.y;
                local v156 = type(y) ~= "number" and 0 or y;
                local z = u99.z;
                local v157 = type(z) ~= "number" and 0 or z;
                local v158 = Vector3.new(v155, v156, v157);
                local radius = u99.radius;
                local u159 = type(radius) ~= "number" and 5 or radius;
                local t = u99.t;
                local v160 = type(t) ~= "number" and 1.5 or t;
                local Part = Instance.new("Part");
                Part.Name = "FoeCakesEyeWarnFx";
                Part.Shape = Enum.PartType.Cylinder;
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CanQuery = false;
                Part.Material = Enum.Material.Neon;
                Part.Color = Color3.fromRGB(200, 200, 255);
                Part.Transparency = 0.3;
                Part.Size = Vector3.new(0.05, u159 * 2, u159 * 2);
                Part.CFrame = CFrame.fromMatrix(v158 + Vector3.new(0, 2, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, -1));
                local v161 = workspace:FindFirstChild("AdminAbuse") and v161:FindFirstChild("Map") and v161:FindFirstChild("Debris", true);
                Part.Parent = v161 or workspace;
                local u162 = TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = Vector3.new(2, u159 * 2, u159 * 2)
                });
                u162:Play();
                u162.Completed:Connect(function() -- Line: 1110
                    -- upvalues: u162 (copy)
                    u162:Destroy();
                end);
                local u163 = TweenService:Create(Part, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                    Transparency = 0.75
                });
                task.delay(0.15, function() -- Line: 1115
                    -- upvalues: Part (copy), u163 (copy)
                    if Part.Parent then
                        u163:Play();
                    end;
                end);
                task.delay(math.max(0, v160 - 0.2), function() -- Line: 1119
                    -- upvalues: Part (copy), u163 (copy), TweenService (ref), u159 (copy)
                    if not Part.Parent then
                        u163:Destroy();

                        return;
                    end;

                    u163:Cancel();
                    u163:Destroy();
                    local u164 = TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Transparency = 1,
                        Size = Vector3.new(0.05, u159 * 2, u159 * 2)
                    });
                    u164.Completed:Once(function() -- Line: 1126
                        -- upvalues: u164 (copy), Part (ref)
                        u164:Destroy();

                        if Part.Parent then
                            Part:Destroy();
                        end;
                    end);
                    u164:Play();
                end);

                return;
            end;

            if p97 == "EyeBeam" then
                local fx = u99.fx;
                local v165 = type(fx) ~= "number" and 0 or fx;
                local fy = u99.fy;
                local v166 = type(fy) ~= "number" and 0 or fy;
                local fz = u99.fz;
                local v167 = type(fz) ~= "number" and 0 or fz;
                local v168 = Vector3.new(v165, v166, v167);
                local tx = u99.tx;
                local v169 = type(tx) ~= "number" and 0 or tx;
                local ty = u99.ty;
                local v170 = type(ty) ~= "number" and 0 or ty;
                local tz = u99.tz;
                local v171 = type(tz) ~= "number" and 0 or tz;
                local v172 = Vector3.new(v169, v170, v171);
                local Magnitude = (v172 - v168).Magnitude;

                if Magnitude < 0.1 then
                    return;
                end;

                local Unit = (v172 - v168).Unit;
                local v173 = Unit:Dot(Vector3.new(0, 1, 0));
                local v174 = math.abs(v173) < 0.99 and Vector3.new(0, 1, 0) or Vector3.new(0, 0, 1);
                local Part = Instance.new("Part");
                Part.Name = "FoeCakesEyeBeamFx";
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CanQuery = false;
                Part.Material = Enum.Material.Neon;
                Part.Color = Color3.fromRGB(220, 220, 255);
                Part.Transparency = 0.1;
                Part.Size = Vector3.new(Magnitude, 1.5, 1.5);
                Part.CFrame = CFrame.fromMatrix((v168 + v172) * 0.5, Unit, v174);
                local v175 = workspace:FindFirstChild("AdminAbuse") and v175:FindFirstChild("Map") and v175:FindFirstChild("Debris", true);
                Part.Parent = v175 or workspace;
                local u176 = TweenService:Create(Part, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Transparency = 1,
                    Size = Vector3.new(Magnitude, 0.05, 0.05)
                });
                u176.Completed:Once(function() -- Line: 1160
                    -- upvalues: u176 (copy), Part (copy)
                    u176:Destroy();

                    if Part.Parent then
                        Part:Destroy();
                    end;
                end);
                u176:Play();

                return;
            end;

            if p97 == "EyeTargetStart" then
                local v177 = Players.LocalPlayer and v177.Character;

                if not v177 then
                    return;
                end;

                local EyeTargetHL = v177:FindFirstChild("EyeTargetHL");

                if EyeTargetHL then
                    EyeTargetHL:Destroy();
                end;

                local Highlight = Instance.new("Highlight");
                Highlight.Name = "EyeTargetHL";
                Highlight.Adornee = v177;
                Highlight.FillColor = Color3.fromRGB(255, 30, 30);
                Highlight.FillTransparency = 0.5;
                Highlight.OutlineColor = Color3.fromRGB(255, 80, 80);
                Highlight.OutlineTransparency = 0;
                Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
                Highlight.Parent = v177;

                return;
            end;

            if p97 == "EyeTargetFire" then
                local v178 = Players.LocalPlayer and v178.Character and v178:FindFirstChild("EyeTargetHL");

                if not v178 then
                    return;
                end;

                v178.FillTransparency = 0;
                v178.OutlineTransparency = 0;

                return;
            end;

            if p97 == "EyeTargetEnd" then
                local u179 = Players.LocalPlayer and u179.Character and u179:FindFirstChild("EyeTargetHL");

                if not u179 then
                    return;
                end;

                local u180 = TweenService:Create(u179, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    FillTransparency = 1,
                    OutlineTransparency = 1
                });
                u180:Play();
                u180.Completed:Once(function() -- Line: 1200
                    -- upvalues: u180 (copy), u179 (copy)
                    u180:Destroy();

                    if u179 and u179.Parent then
                        u179:Destroy();
                    end;
                end);

                if u20 and u20.Parent then
                    u20:Stop();
                    u20:Destroy();
                    u20 = nil;
                end;
            elseif p97 == "EyeBeeping" then
                if u20 and u20.Parent then
                    u20:Stop();
                    u20:Destroy();
                    u20 = nil;
                end;

                local EyeOfUnionBeeping = ReplicatedStorage:FindFirstChild("EyeOfUnionBeeping");

                if EyeOfUnionBeeping and EyeOfUnionBeeping:IsA("Sound") then
                    local v181 = EyeOfUnionBeeping:Clone();
                    v181.Parent = Players.LocalPlayer;
                    v181:Play();
                    u20 = v181;
                end;
            elseif p97 == "EyePreshot" then
                if u20 and u20.Parent then
                    u20:Stop();
                    u20:Destroy();
                    u20 = nil;
                end;

                local EyeOfUnionPreshot = ReplicatedStorage:FindFirstChild("EyeOfUnionPreshot");

                if EyeOfUnionPreshot and EyeOfUnionPreshot:IsA("Sound") then
                    local v182 = EyeOfUnionPreshot:Clone();
                    v182.Parent = Players.LocalPlayer;
                    v182:Play();
                    Debris:AddItem(v182, 5);
                end;
            else
                if p97 == "FadeToBlack" then
                    local dur = u99.dur;
                    local u183 = type(dur) ~= "number" and 0.5 or dur;
                    task.spawn(function() -- Line: 1245
                        -- upvalues: Players (ref), TweenService (ref), u183 (copy)
                        local v184 = Players.LocalPlayer and v184:WaitForChild("PlayerGui");

                        if not v184 then
                            return;
                        end;

                        local FoeCakesCutsceneBlack = v184:FindFirstChild("FoeCakesCutsceneBlack");

                        if not (FoeCakesCutsceneBlack and FoeCakesCutsceneBlack:IsA("ScreenGui")) then
                            FoeCakesCutsceneBlack = Instance.new("ScreenGui");
                            FoeCakesCutsceneBlack.Name = "FoeCakesCutsceneBlack";
                            FoeCakesCutsceneBlack.ResetOnSpawn = false;
                            FoeCakesCutsceneBlack.IgnoreGuiInset = true;
                            FoeCakesCutsceneBlack.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                            local Frame = Instance.new("Frame");
                            Frame.Name = "Black";
                            Frame.Size = UDim2.fromScale(1, 1);
                            Frame.BackgroundColor3 = Color3.new(0, 0, 0);
                            Frame.BackgroundTransparency = 1;
                            Frame.BorderSizePixel = 0;
                            Frame.ZIndex = 100;
                            Frame.Parent = FoeCakesCutsceneBlack;
                            FoeCakesCutsceneBlack.Parent = v184;
                        end;

                        local Black = FoeCakesCutsceneBlack:FindFirstChild("Black");

                        if not Black then
                            return;
                        end;

                        local v185 = TweenService:Create(Black, TweenInfo.new(u183, Enum.EasingStyle.Linear), {
                            BackgroundTransparency = 0
                        });
                        v185:Play();
                        v185.Completed:Wait();
                        v185:Destroy();
                    end);

                    return;
                end;

                if p97 == "OpeningCutscene" then
                    task.spawn(function() -- Line: 1281
                        -- upvalues: FoeCakesCutscenes (ref), u99 (copy), startSoundtrack (ref), u21 (ref), getLiveBossRig (ref), Animation (ref), Debris (ref)
                        FoeCakesCutscenes.playOpening(u99);
                        startSoundtrack();
                        u21 = true;
                        local u186 = Random.new();
                        task.spawn(function() -- Line: 170
                            -- upvalues: u21 (ref), u186 (copy), getLiveBossRig (ref), Animation (ref), Debris (ref)
                            while u21 do
                                task.wait(u186:NextNumber(15, 35));

                                if not u21 then
                                    break;
                                end;

                                local v187 = getLiveBossRig();

                                if v187 then
                                    local v188 = v187:FindFirstChildOfClass("Humanoid");
                                    local v189 = v188 and v188:FindFirstChildOfClass("Animator") or v187:FindFirstChildOfClass("Animator");

                                    if v189 then
                                        local v190 = v189:LoadAnimation(Animation);
                                        v190.Looped = true;
                                        v190.Priority = Enum.AnimationPriority.Action;
                                        v190:Play(0.5);
                                        local Sound = Instance.new("Sound");
                                        Sound.SoundId = "rbxassetid://4810729995";
                                        Sound.Volume = 4.5;
                                        Sound.Parent = v187.PrimaryPart or v187;
                                        Sound:Play();
                                        Debris:AddItem(Sound, 20);
                                        local u191 = false;
                                        local v192 = Sound.Ended:Connect(function() -- Line: 196
                                            -- upvalues: u191 (ref)
                                            u191 = true;
                                        end);
                                        local v193 = 0;

                                        repeat
                                            v193 = v193 + task.wait(0.1);
                                        until u191 or (not u21 or v193 > 15);

                                        v192:Disconnect();
                                        Sound:Stop();
                                        v190:Stop(0.5);
                                    end;
                                end;
                            end;
                        end);
                    end);

                    return;
                end;

                if p97 == "EndingCutscene" then
                    u21 = false;
                    stopSoundtrack();
                    task.spawn(function() -- Line: 1290
                        -- upvalues: FoeCakesCutscenes (ref), u99 (copy)
                        FoeCakesCutscenes.playEnding(u99, function() -- Line: 1291
                            FoeCakesBossRoom.Stop();
                        end);
                    end);

                    return;
                end;

                if p97 == "FinalCutscene" then
                    u21 = false;
                    task.spawn(function() -- Line: 1299
                        -- upvalues: Players (ref), u1 (ref), TweenService (ref), stopSoundtrack (ref), Debris (ref)
                        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");

                        if u1 then
                            u1.Enabled = false;
                        end;

                        local ScreenGui = Instance.new("ScreenGui");
                        ScreenGui.Name = "FoeCakesBossEndTransition";
                        ScreenGui.IgnoreGuiInset = true;
                        ScreenGui.ResetOnSpawn = false;
                        ScreenGui.DisplayOrder = 999999;
                        ScreenGui.Parent = PlayerGui;
                        local Frame = Instance.new("Frame");
                        Frame.Size = UDim2.fromScale(1, 1);
                        Frame.BackgroundColor3 = Color3.new(0, 0, 0);
                        Frame.BorderSizePixel = 0;
                        Frame.BackgroundTransparency = 1;
                        Frame.Parent = ScreenGui;
                        TweenService:Create(Frame, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            BackgroundTransparency = 0
                        }):Play();
                        task.delay(2, function() -- Line: 1323
                            -- upvalues: stopSoundtrack (ref)
                            stopSoundtrack();
                        end);
                        Debris:AddItem(ScreenGui, 10);
                    end);

                    return;
                end;

                if p97 == "CloudWarn" then
                    local x = u99.x;
                    local v194 = type(x) ~= "number" and 0 or x;
                    local y = u99.y;
                    local v195 = type(y) ~= "number" and 0 or y;
                    local z = u99.z;
                    local v196 = type(z) ~= "number" and 0 or z;
                    local v197 = Vector3.new(v194, v195, v196);
                    local radius = u99.radius;
                    local u198 = type(radius) ~= "number" and 5 or radius;
                    local t = u99.t;
                    local v199 = type(t) ~= "number" and 2 or t;
                    local Part = Instance.new("Part");
                    Part.Name = "FoeCakesCloudWarnFx";
                    Part.Shape = Enum.PartType.Cylinder;
                    Part.Anchored = true;
                    Part.CanCollide = false;
                    Part.CanQuery = false;
                    Part.Material = Enum.Material.Neon;
                    Part.Color = Color3.fromRGB(255, 55, 55);
                    Part.Transparency = 0.3;
                    Part.Size = Vector3.new(0.05, u198 * 2, u198 * 2);
                    Part.CFrame = CFrame.fromMatrix(v197 + Vector3.new(0, 2, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, -1));
                    local v200 = workspace:FindFirstChild("AdminAbuse") and v200:FindFirstChild("Map") and v200:FindFirstChild("Debris", true);
                    Part.Parent = v200 or workspace;
                    local u201 = TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size = Vector3.new(2, u198 * 2, u198 * 2)
                    });
                    u201:Play();
                    u201.Completed:Connect(function() -- Line: 1355
                        -- upvalues: u201 (copy)
                        u201:Destroy();
                    end);
                    local u202 = TweenService:Create(Part, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                        Transparency = 0.75
                    });
                    task.delay(0.15, function() -- Line: 1360
                        -- upvalues: Part (copy), u202 (copy)
                        if Part.Parent then
                            u202:Play();
                        end;
                    end);
                    task.delay(math.max(0, v199 - 0.2), function() -- Line: 1364
                        -- upvalues: Part (copy), u202 (copy), TweenService (ref), u198 (copy)
                        if not Part.Parent then
                            u202:Destroy();

                            return;
                        end;

                        u202:Cancel();
                        u202:Destroy();
                        local u203 = TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Transparency = 1,
                            Size = Vector3.new(0.05, u198 * 2, u198 * 2)
                        });
                        u203.Completed:Once(function() -- Line: 1371
                            -- upvalues: u203 (copy), Part (ref)
                            u203:Destroy();

                            if Part.Parent then
                                Part:Destroy();
                            end;
                        end);
                        u203:Play();
                    end);

                    return;
                end;

                if p97 == "CloudStrike" then
                    local fx = u99.fx;
                    local v204 = type(fx) ~= "number" and 0 or fx;
                    local fy = u99.fy;
                    local v205 = type(fy) ~= "number" and 0 or fy;
                    local fz = u99.fz;
                    local v206 = type(fz) ~= "number" and 0 or fz;
                    local v207 = Vector3.new(v204, v205, v206);
                    local tx = u99.tx;
                    local v208 = type(tx) ~= "number" and 0 or tx;
                    local ty = u99.ty;
                    local v209 = type(ty) ~= "number" and 0 or ty;
                    local tz = u99.tz;
                    local v210 = type(tz) ~= "number" and 0 or tz;
                    local v211 = Vector3.new(v208, v209, v210);
                    local Magnitude = (v211 - v207).Magnitude;

                    if Magnitude < 0.1 then
                        return;
                    end;

                    local v212 = workspace:FindFirstChild("AdminAbuse") and v212:FindFirstChild("Map") and v212:FindFirstChild("Debris", true);
                    local v213 = v212 or workspace;
                    local v214 = Random.new();
                    local v215 = Magnitude * 0.13;
                    local Unit = (v211 - v207).Unit;
                    local v216 = Unit:Dot(Vector3.new(1, 0, 0));
                    local v217;

                    if math.abs(v216) < 0.99 then
                        v217 = Unit:Cross(Vector3.new(1, 0, 0)).Unit;
                    else
                        v217 = Unit:Cross(Vector3.new(0, 0, 1)).Unit;
                    end;

                    local Unit2 = Unit:Cross(v217).Unit;
                    local v218 = { v207 };

                    for i = 1, 6 do
                        local v219 = i / 7;
                        local v220 = v207:Lerp(v211, v219);
                        local v221 = math.sin(v219 * 3.141592653589793);
                        local v222 = v214:NextNumber(-v215, v215) * v221;
                        local v223 = v214:NextNumber(-v215 * 0.5, v215 * 0.5) * v221;
                        table.insert(v218, v220 + v217 * v222 + Unit2 * v223);
                    end;

                    table.insert(v218, v211);

                    for i = 1, #v218 - 1 do
                        local v224 = v218[i];
                        local v225 = v218[i + 1];
                        local Magnitude2 = (v225 - v224).Magnitude;

                        if Magnitude2 >= 0.01 then
                            local Unit3 = (v225 - v224).Unit;
                            local v226 = Unit3:Dot(Vector3.new(0, 1, 0));
                            local v227 = math.abs(v226) < 0.99 and Vector3.new(0, 1, 0) or Vector3.new(0, 0, 1);
                            local Part = Instance.new("Part");
                            Part.Name = "FoeCakesCloudBoltFx";
                            Part.Anchored = true;
                            Part.CanCollide = false;
                            Part.CanQuery = false;
                            Part.Material = Enum.Material.Neon;
                            Part.Color = Color3.fromRGB(200, 220, 255);
                            Part.Transparency = 0.1;
                            Part.Size = Vector3.new(Magnitude2, 2.8, 2.8);
                            Part.CFrame = CFrame.fromMatrix((v224 + v225) * 0.5, Unit3, v227);
                            Part.Parent = v213;
                            local u228 = TweenService:Create(Part, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                Transparency = 1,
                                Size = Vector3.new(Magnitude2, 0.05, 0.05)
                            });
                            u228.Completed:Once(function() -- Line: 1435
                                -- upvalues: u228 (copy), Part (copy)
                                u228:Destroy();

                                if Part.Parent then
                                    Part:Destroy();
                                end;
                            end);
                            u228:Play();
                        end;
                    end;

                    local Part = Instance.new("Part");
                    Part.Name = "FoeCakesCloudFlashFx";
                    Part.Shape = Enum.PartType.Cylinder;
                    Part.Anchored = true;
                    Part.CanCollide = false;
                    Part.CanQuery = false;
                    Part.Material = Enum.Material.Neon;
                    Part.Color = Color3.fromRGB(255, 240, 100);
                    Part.Transparency = 0.15;
                    Part.Size = Vector3.new(1, 1, 1);
                    Part.CFrame = CFrame.fromMatrix(v211 + Vector3.new(0, 0.5, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, -1));
                    Part.Parent = v213;
                    local u229 = TweenService:Create(Part, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Transparency = 1,
                        Size = Vector3.new(1, 20, 20)
                    });
                    u229.Completed:Once(function() -- Line: 1461
                        -- upvalues: u229 (copy), Part (copy)
                        u229:Destroy();

                        if Part.Parent then
                            Part:Destroy();
                        end;
                    end);
                    u229:Play();
                    local Part2 = Instance.new("Part");
                    Part2.Name = "FoeCakesCloudExplosionFx";
                    Part2.Shape = Enum.PartType.Ball;
                    Part2.Anchored = true;
                    Part2.CanCollide = false;
                    Part2.CanQuery = false;
                    Part2.Material = Enum.Material.Neon;
                    Part2.Color = Color3.fromRGB(180, 210, 255);
                    Part2.Transparency = 0.15;
                    Part2.Size = Vector3.new(3, 3, 3);
                    Part2.CFrame = CFrame.new(v211 + Vector3.new(0, 1.5, 0));
                    Part2.Parent = v213;
                    local u230 = TweenService:Create(Part2, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Transparency = 1,
                        Size = Vector3.new(16, 16, 16)
                    });
                    u230.Completed:Once(function() -- Line: 1484
                        -- upvalues: u230 (copy), Part2 (copy)
                        u230:Destroy();

                        if Part2.Parent then
                            Part2:Destroy();
                        end;
                    end);
                    u230:Play();

                    return;
                end;

                if p97 == "PortalBeam" then
                    local ox = u99.ox;
                    local v231 = type(ox) ~= "number" and 0 or ox;
                    local oy = u99.oy;
                    local v232 = type(oy) ~= "number" and 0 or oy;
                    local oz = u99.oz;
                    local v233 = type(oz) ~= "number" and 0 or oz;
                    local v234 = Vector3.new(v231, v232, v233);
                    local tx = u99.tx;
                    local v235 = type(tx) ~= "number" and 0 or tx;
                    local ty = u99.ty;
                    local v236 = type(ty) ~= "number" and 0 or ty;
                    local tz = u99.tz;
                    local v237 = type(tz) ~= "number" and 0 or tz;
                    local v238 = Vector3.new(v235, v236, v237);
                    local chargeSec = u99.chargeSec;
                    local v239 = type(chargeSec) ~= "number" and 0.8 or chargeSec;
                    local holdSec = u99.holdSec;
                    local u240 = type(holdSec) ~= "number" and 0.35 or holdSec;
                    local width = u99.width;
                    local v241 = type(width) ~= "number" and 0.6 or width;
                    local new = Color3.new;
                    local colorR = u99.colorR;
                    local v242 = type(colorR) ~= "number" and 0.667 or colorR;
                    local colorG = u99.colorG;
                    local v243 = type(colorG) ~= "number" and 0.431 or colorG;
                    local colorB = u99.colorB;
                    local v244 = new(v242, v243, type(colorB) ~= "number" and 1 or colorB);
                    local v245 = v238 - v234;
                    local Magnitude = v245.Magnitude;

                    if Magnitude < 0.1 then
                        return;
                    end;

                    local Unit = v245.Unit;
                    local v246;

                    if math.abs(Unit.Y) < 0.9 then
                        v246 = (Vector3.new(0, 1, 0)):Cross(Unit).Unit;
                    else
                        v246 = (Vector3.new(1, 0, 0)):Cross(Unit).Unit;
                    end;

                    local v247 = CFrame.fromMatrix(v234, v246, Unit, v246:Cross(Unit));
                    local Part = Instance.new("Part");
                    Part.Name = "GlassShatterBeamFx";
                    Part.Shape = Enum.PartType.Cylinder;
                    Part.Anchored = true;
                    Part.CanCollide = false;
                    Part.CanQuery = false;
                    Part.CanTouch = false;
                    Part.Material = Enum.Material.Neon;
                    Part.Color = v244;
                    Part.Transparency = 0.5;
                    Part.Size = Vector3.new(v241, 0.1, v241);
                    Part.CFrame = v247;
                    local v248 = workspace:FindFirstChild("AdminAbuse") and v248:FindFirstChild("Map") and v248:FindFirstChild("Debris", true);
                    Part.Parent = v248 or workspace;
                    local u249 = TweenService:Create(Part, TweenInfo.new(v239, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Transparency = 0.35,
                        Size = Vector3.new(v241, Magnitude, v241),
                        CFrame = CFrame.fromMatrix((v234 + v238) * 0.5, v246, Unit, v246:Cross(Unit))
                    });
                    u249:Play();
                    u249.Completed:Once(function() -- Line: 1539
                        -- upvalues: u249 (copy), Part (copy), u240 (copy), TweenService (ref), Magnitude (copy)
                        u249:Destroy();

                        if not Part.Parent then
                            return;
                        end;

                        Part.Color = Color3.new(1, 1, 1);
                        Part.Transparency = 0;
                        task.delay(u240, function() -- Line: 1545
                            -- upvalues: Part (ref), TweenService (ref), Magnitude (ref)
                            if not Part.Parent then
                                return;
                            end;

                            local u250 = TweenService:Create(Part, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                Transparency = 1,
                                Size = Vector3.new(0.05, Magnitude, 0.05)
                            });
                            u250.Completed:Once(function() -- Line: 1552
                                -- upvalues: u250 (copy), Part (ref)
                                u250:Destroy();

                                if Part.Parent then
                                    Part:Destroy();
                                end;
                            end);
                            u250:Play();
                        end);
                    end);

                    return;
                end;

                if p97 == "TimeshiftBegin" then
                    local fadeIn = u99.fadeIn;
                    local v251 = type(fadeIn) ~= "number" and 0.6 or fadeIn;
                    timeshiftBegin((math.max(0.05, v251)));

                    return;
                end;

                if p97 == "TimeshiftEnd" then
                    local fadeOut = u99.fadeOut;
                    local v252 = type(fadeOut) ~= "number" and 0.5 or fadeOut;
                    timeshiftEnd((math.max(0.05, v252)));

                    return;
                end;

                if p97 == "PlaySound" then
                    handlePlaySound(u99);

                    return;
                end;

                if p97 == "StopSound" then
                    local v253 = tostring(u99.id or "");
                    local v254 = u19[v253];

                    if v254 and v254.Parent then
                        v254:Stop();
                        v254:Destroy();
                    end;

                    u19[v253] = nil;

                    return;
                end;

                if p97 == "StartSoundtrack" then
                    if not u18 then
                        local phase = u99.phase;
                        local v255;

                        if type(phase) == "number" then
                            local v256 = math.clamp(phase, 1, 10);
                            v255 = math.floor(v256);
                        else
                            v255 = u22;
                        end;

                        startSoundtrack(v255);

                        if not u21 then
                            u21 = true;
                            local u257 = Random.new();
                            task.spawn(function() -- Line: 170
                                -- upvalues: u21 (ref), u257 (copy), getLiveBossRig (ref), Animation (ref), Debris (ref)
                                while u21 do
                                    task.wait(u257:NextNumber(15, 35));

                                    if not u21 then
                                        break;
                                    end;

                                    local v258 = getLiveBossRig();

                                    if v258 then
                                        local v259 = v258:FindFirstChildOfClass("Humanoid");
                                        local v260 = v259 and v259:FindFirstChildOfClass("Animator") or v258:FindFirstChildOfClass("Animator");

                                        if v260 then
                                            local v261 = v260:LoadAnimation(Animation);
                                            v261.Looped = true;
                                            v261.Priority = Enum.AnimationPriority.Action;
                                            v261:Play(0.5);
                                            local Sound = Instance.new("Sound");
                                            Sound.SoundId = "rbxassetid://4810729995";
                                            Sound.Volume = 4.5;
                                            Sound.Parent = v258.PrimaryPart or v258;
                                            Sound:Play();
                                            Debris:AddItem(Sound, 20);
                                            local u262 = false;
                                            local v263 = Sound.Ended:Connect(function() -- Line: 196
                                                -- upvalues: u262 (ref)
                                                u262 = true;
                                            end);
                                            local v264 = 0;

                                            repeat
                                                v264 = v264 + task.wait(0.1);
                                            until u262 or (not u21 or v264 > 15);

                                            v263:Disconnect();
                                            Sound:Stop();
                                            v261:Stop(0.5);
                                        end;
                                    end;
                                end;
                            end);
                        end;
                    end;
                elseif p97 == "FoeCakesMsg" then
                    local message = u99.message;

                    if type(message) == "string" then
                        showFakeAnnouncement(message);
                    end;
                end;
            end;
        end;
    end);
end;

return {
    IsAdminAbuse = true,
    NeedsDuration = false,
    SkipDoorTransition = false,
    Sounds = { (tostring(Soundtracks[1])) },

    Fire = function() -- Line: 1615, Name: Fire
        -- upvalues: buildUi (copy), Remotes (copy), u7 (ref), onBossHpSync (copy), setupFxListener (copy)
        buildUi();
        u7 = Remotes:WaitForChild("AdminAbuseBossSync").OnClientEvent:Connect(onBossHpSync);
        setupFxListener();
    end,

    Stop = function() -- Line: 1624, Name: Stop
        -- upvalues: u21 (ref), Players (copy), destroyTimeshiftEffects (copy), stopSoundtrack (copy), u8 (ref), u15 (ref), u17 (copy), u16 (ref), identity (ref), identity2 (ref), RunService (copy), FoeCakesCutscenes (copy), destroyUi (copy), u20 (ref), u19 (copy)
        u21 = false;
        local v265 = Players.LocalPlayer and v265.Character and v265:FindFirstChild("EyeTargetHL");

        if v265 then
            v265:Destroy();
        end;

        destroyTimeshiftEffects();
        stopSoundtrack();

        if u8 then
            u8:Disconnect();
            u8 = nil;
        end;

        if u15 then
            u15:Stop();
            u15 = nil;
        end;

        for i, v in u17 do
            if i and i.Parent then
                i.Visible = v;
            end;
        end;

        table.clear(u17);
        u16 = nil;
        identity = CFrame.identity;
        identity2 = CFrame.identity;
        RunService:UnbindFromRenderStep("FoeCakesCinematicLock");
        FoeCakesCutscenes.stopAll();
        destroyUi();

        if u20 and u20.Parent then
            u20:Stop();
            u20:Destroy();
            u20 = nil;
        end;

        table.clear(u19);
    end,

    Hidden = true
};