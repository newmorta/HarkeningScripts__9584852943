-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.ChichineBossRoom
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local SoundService = game:GetService("SoundService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AdminAbuse = ReplicatedStorage:WaitForChild("AdminAbuse");
local BossClientBase = require(AdminAbuse.Modules.Shared.BossClientBase);
local FakeAdminMessageUtil = require(ReplicatedStorage.Utilities.FakeAdminMessageUtil);
local ChichineConfig = require(script.ChichineConfig);
local ChichineCutscenes = require(script.ChichineCutscenes);
local ZoneSweet = require(script.AttacksClient.ZoneSweet);
local HammerSmash = require(script.AttacksClient.HammerSmash);
local SwordTango = require(script.AttacksClient.SwordTango);
local BoulderRain = require(script.AttacksClient.BoulderRain);
local GlassShatter = require(script.AttacksClient.GlassShatter);
local ShootingKeycaps = require(script.AttacksClient.ShootingKeycaps);
local MiguelSwarm = require(script.AttacksClient.MiguelSwarm);
local u1 = nil;
local u2 = {};
local u3 = {};
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = 0;
local u11 = false;
local u12 = nil;
local Animation = Instance.new("Animation");
Animation.AnimationId = "rbxassetid://123920758489558";

local function getTransitionManager() -- Line: 51
    -- upvalues: u4 (ref), ReplicatedStorage (copy), Players (copy)
    if not u4 then
        local coolTransitions = require(ReplicatedStorage.coolTransitions);
        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
        u4 = coolTransitions.TransitionManager.new(PlayerGui);
    end;

    return u4;
end;

local function getLiveCosmeticRig() -- Line: 62
    -- upvalues: u12 (ref)
    if not u12 then
        return nil;
    end;

    local v13 = workspace:FindFirstChild("AdminAbuse") and v13:FindFirstChild("Map");

    if not v13 then
        return nil;
    end;

    local v14 = v13:FindFirstChild(u12);

    if not v14 then
        return nil;
    end;

    local Scriptables = v14:FindFirstChild("Scriptables");

    if not Scriptables then
        return nil;
    end;

    local CosmeticBossRig = Scriptables:FindFirstChild("CosmeticBossRig");

    if CosmeticBossRig and CosmeticBossRig:IsA("Model") then
        return CosmeticBossRig;
    end;

    return nil;
end;

local function startLaughLoop() -- Line: 75
    -- upvalues: u11 (ref), getLiveCosmeticRig (copy), Animation (copy), Players (copy), Debris (copy)
    u11 = true;
    local u15 = Random.new();
    task.spawn(function() -- Line: 78
        -- upvalues: u11 (ref), u15 (copy), getLiveCosmeticRig (ref), Animation (ref), Players (ref), Debris (ref)
        while u11 do
            task.wait(u15:NextNumber(35, 120));

            if not u11 then
                break;
            end;

            local v16 = getLiveCosmeticRig();

            if v16 then
                local v17 = v16:FindFirstChildOfClass("Humanoid");
                local v18 = v17 and v17:FindFirstChildOfClass("Animator") or v16:FindFirstChildOfClass("Animator");

                if v18 then
                    local v19 = v18:LoadAnimation(Animation);
                    v19.Looped = true;
                    v19.Priority = Enum.AnimationPriority.Action;
                    v19:Play(0.5);
                    local Sound = Instance.new("Sound");
                    Sound.SoundId = "rbxassetid://4810729995";
                    Sound.Volume = 1;
                    Sound.Parent = Players.LocalPlayer;
                    Sound:Play();
                    Debris:AddItem(Sound, 20);
                    local u20 = false;
                    local v21 = Sound.Ended:Connect(function() -- Line: 104
                        -- upvalues: u20 (ref)
                        u20 = true;
                    end);
                    local v22 = 0;

                    repeat
                        v22 = v22 + task.wait(0.1);
                    until u20 or (not u11 or v22 > 15);

                    v21:Disconnect();
                    Sound:Stop();
                    v19:Stop(0.5);
                end;
            end;
        end;
    end);
end;

local function showCredits() -- Line: 119
    -- upvalues: Players (copy), TweenService (copy)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "ChichineCredits";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.DisplayOrder = 100;
    ScreenGui.Parent = PlayerGui;
    local Frame = Instance.new("Frame");
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundTransparency = 1;
    Frame.Parent = ScreenGui;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Size = UDim2.fromScale(1, 0.6);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.TextStrokeColor3 = Color3.new();
    TextLabel.TextStrokeTransparency = 0;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.Text = "Host - Secret_Lokii & LuckyMatg\n\nProducer - FoeCakes & Chichine\n\nScripter - FoeCakes\n\nBuilder - Nextune_Dev\n\nMusic - X3LL3N\n";
    TextLabel.TextTransparency = 1;
    TextLabel.Parent = Frame;
    TweenService:Create(TextLabel, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play();
    task.wait(6.5);
    local v23 = TweenService:Create(TextLabel, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    });
    v23:Play();
    v23.Completed:Once(function() -- Line: 169
        -- upvalues: ScreenGui (copy)
        ScreenGui:Destroy();
    end);
end;

local function _destroyTimeshiftFx() -- Line: 174
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    if u5 then
        u5:Destroy();
        u5 = nil;
    end;

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    if u7 then
        u7:Destroy();
        u7 = nil;
    end;

    if u8 then
        u8:Destroy();
        u8 = nil;
    end;

    if u9 then
        u9:Destroy();
        u9 = nil;
    end;
end;

local function _findActiveSoundtrack() -- Line: 182
    -- upvalues: CollectionService (copy)
    for _, v in CollectionService:GetTagged("Music") do
        if v:IsA("Sound") and v.IsPlaying then
            return v;
        end;
    end;

    return nil;
end;

local function _timeshiftBegin(p24) -- Line: 191
    -- upvalues: u10 (ref), _destroyTimeshiftFx (copy), u5 (ref), TweenService (copy), Players (copy), u9 (ref), ChichineConfig (copy), _findActiveSoundtrack (copy), u6 (ref), u7 (ref), u8 (ref)
    u10 = u10 + 1;
    _destroyTimeshiftFx();
    local Lighting = game:GetService("Lighting");
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.Name = "ChichineTimeshiftCC";
    ColorCorrectionEffect.Saturation = 0;
    ColorCorrectionEffect.Contrast = 0;
    ColorCorrectionEffect.Brightness = 0;
    ColorCorrectionEffect.TintColor = Color3.fromRGB(255, 255, 255);
    ColorCorrectionEffect.Parent = Lighting;
    u5 = ColorCorrectionEffect;
    TweenService:Create(ColorCorrectionEffect, TweenInfo.new(p24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Saturation = -1,
        Contrast = 0.4,
        Brightness = -0.12
    }):Play();
    local v25 = Players.LocalPlayer and v25:FindFirstChild("PlayerGui");

    if v25 then
        local ScreenGui = Instance.new("ScreenGui");
        ScreenGui.Name = "ChichineTimeshiftFlash";
        ScreenGui.IgnoreGuiInset = true;
        ScreenGui.ResetOnSpawn = false;
        ScreenGui.DisplayOrder = 1000000;
        ScreenGui.Parent = v25;
        local Frame = Instance.new("Frame");
        Frame.Size = UDim2.fromScale(1, 1);
        Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
        Frame.BackgroundTransparency = 0;
        Frame.BorderSizePixel = 0;
        Frame.Parent = ScreenGui;
        u9 = ScreenGui;
        TweenService:Create(Frame, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        }):Play();
        task.delay(0.5, function() -- Line: 232
            -- upvalues: ScreenGui (copy), Frame (copy)
            if not ScreenGui.Parent then
                return;
            end;

            Frame.BackgroundColor3 = Color3.fromRGB(150, 110, 255);
            Frame.BackgroundTransparency = 0.85;
        end);
    end;

    if not ChichineConfig.GlassShatter.timeshiftDistortAudio then
        return;
    end;

    print("[ChichineBossRoom] _timeshiftBegin: CC+flash created, finding soundtrack");
    local v26 = _findActiveSoundtrack();

    if v26 and v26.Parent then
        local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect");
        EqualizerSoundEffect.LowGain = 0;
        EqualizerSoundEffect.MidGain = 0;
        EqualizerSoundEffect.HighGain = 0;
        EqualizerSoundEffect.Parent = v26;
        u6 = EqualizerSoundEffect;
        TweenService:Create(EqualizerSoundEffect, TweenInfo.new(p24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            HighGain = -20,
            MidGain = -8,
            LowGain = 2
        }):Play();
        local ReverbSoundEffect = Instance.new("ReverbSoundEffect");
        ReverbSoundEffect.DecayTime = 1.5;
        ReverbSoundEffect.Density = 1;
        ReverbSoundEffect.WetLevel = 0;
        ReverbSoundEffect.DryLevel = 0;
        ReverbSoundEffect.Parent = v26;
        u7 = ReverbSoundEffect;
        TweenService:Create(ReverbSoundEffect, TweenInfo.new(p24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            DecayTime = 3,
            WetLevel = 6,
            DryLevel = -3
        }):Play();
        local PitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect");
        PitchShiftSoundEffect.Octave = 1;
        PitchShiftSoundEffect.Parent = v26;
        u8 = PitchShiftSoundEffect;
        TweenService:Create(PitchShiftSoundEffect, TweenInfo.new(p24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Octave = 0.7
        }):Play();
    end;
end;

local function _timeshiftEnd(p27) -- Line: 282
    -- upvalues: u10 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), TweenService (copy), _destroyTimeshiftFx (copy)
    u10 = u10 + 1;
    local u28 = u10;
    local v29 = u5;
    local v30 = u6;
    local v31 = u7;
    local v32 = u8;
    local v33 = u9;

    if v29 then
        TweenService:Create(v29, TweenInfo.new(p27, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Saturation = 0,
            Contrast = 0,
            Brightness = 0
        }):Play();
    end;

    if v30 then
        TweenService:Create(v30, TweenInfo.new(p27, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            HighGain = 0,
            MidGain = 0,
            LowGain = 0
        }):Play();
    end;

    if v31 then
        TweenService:Create(v31, TweenInfo.new(p27, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            WetLevel = 0,
            DryLevel = 0
        }):Play();
    end;

    if v32 then
        TweenService:Create(v32, TweenInfo.new(p27, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Octave = 1
        }):Play();
    end;

    if v33 and v33:FindFirstChildOfClass("Frame") then
        TweenService:Create(v33:FindFirstChildOfClass("Frame"), TweenInfo.new(p27, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        }):Play();
    end;

    task.delay(p27 + 0.05, function() -- Line: 324
        -- upvalues: u28 (copy), u10 (ref), _destroyTimeshiftFx (ref)
        if u28 ~= u10 then
            return;
        end;

        _destroyTimeshiftFx();
    end);
end;

local function cleanupCosmetics() -- Line: 333
    -- upvalues: u2 (copy), u3 (copy), HammerSmash (copy), SwordTango (copy), BoulderRain (copy), GlassShatter (copy), ShootingKeycaps (copy), MiguelSwarm (copy), _destroyTimeshiftFx (copy)
    for _, v in pairs(u2) do
        pcall(function() -- Line: 335
            -- upvalues: v (copy)
            v:Destroy();
        end);
    end;

    table.clear(u2);

    for _, v in u3 do
        pcall(function() -- Line: 340
            -- upvalues: v (copy)
            v:Destroy();
        end);
    end;

    table.clear(u3);
    HammerSmash.cleanup();
    SwordTango.cleanup();
    BoulderRain.cleanup();
    GlassShatter.cleanup();
    ShootingKeycaps.cleanup();
    MiguelSwarm.cleanup();
    _destroyTimeshiftFx();
end;

local function playSpatialSound(p34, p35, p36, p37, p38) -- Line: 355
    -- upvalues: u3 (copy)
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Transparency = 1;
    Part.Size = Vector3.new(1, 1, 1);
    Part.CFrame = CFrame.new(p34, p35, p36);
    Part.Parent = workspace;
    local Sound = Instance.new("Sound");
    Sound.SoundId = p37;
    Sound.Volume = p38;
    Sound.RollOffMaxDistance = 120;
    Sound.Parent = Part;
    table.insert(u3, Sound);
    Sound:Play();
    Sound.Ended:Connect(function() -- Line: 372
        -- upvalues: u3 (ref), Sound (copy), Part (copy)
        pcall(function() -- Line: 373
            -- upvalues: u3 (ref), Sound (ref), Part (ref)
            table.remove(u3, table.find(u3, Sound) or 0);
            Part:Destroy();
        end);
    end);
end;

local function screenShake(u39, u40) -- Line: 380
    -- upvalues: Players (copy)
    local u41 = Players.LocalPlayer.Character and u41:FindFirstChildOfClass("Humanoid");

    if not u41 then
        return;
    end;

    task.spawn(function() -- Line: 384
        -- upvalues: u39 (copy), u41 (copy), u40 (copy)
        local v42 = 0;

        while v42 < u39 do
            v42 = v42 + task.wait();
            local v43 = 1 - v42 / u39;
            local v44 = math.sin(v42 * 43) * v43 * u40;
            local v45 = math.sin(v42 * 29) * v43 * u40;
            u41.CameraOffset = Vector3.new(v44, v45, 0);
        end;

        u41.CameraOffset = Vector3.new(0, 0, 0);
    end);
end;

local function handleFx(p46, u47) -- Line: 402
    -- upvalues: ChichineConfig (copy), Players (copy), FakeAdminMessageUtil (copy), playSpatialSound (copy), u2 (copy), TweenService (copy), SoundService (copy), u12 (ref), u11 (ref), getLiveCosmeticRig (copy), Animation (copy), Debris (copy), u1 (ref), GlassShatter (copy), cleanupCosmetics (copy), showCredits (copy), u4 (ref), ReplicatedStorage (copy), ZoneSweet (copy), HammerSmash (copy), SwordTango (copy), BoulderRain (copy), ShootingKeycaps (copy), _timeshiftBegin (copy), _timeshiftEnd (copy)
    if p46 ~= "ShowBossMessage" then
        if p46 == "PhaseRoar" then
            local u48 = Players.LocalPlayer.Character and u48:FindFirstChildOfClass("Humanoid");

            if u48 then
                local u49 = 0.65;
                local u50 = 0.5;
                task.spawn(function() -- Line: 384
                    -- upvalues: u49 (copy), u48 (copy), u50 (copy)
                    local v51 = 0;

                    while v51 < u49 do
                        v51 = v51 + task.wait();
                        local v52 = 1 - v51 / u49;
                        local v53 = math.sin(v51 * 43) * v52 * u50;
                        local v54 = math.sin(v51 * 29) * v52 * u50;
                        u48.CameraOffset = Vector3.new(v53, v54, 0);
                    end;

                    u48.CameraOffset = Vector3.new(0, 0, 0);
                end);
            end;

            if u47.x then
                playSpatialSound(u47.x, u47.y or 0, u47.z or 0, "rbxassetid://0", 1);

                return;
            end;
        else
            if p46 == "PortalOpen" then
                local v55 = u47.id or 1;
                local v56 = u47.x or 0;
                local v57 = u47.y or 0;
                local v58 = u47.z or 0;
                local v59 = u47.r or 8;
                local Part = Instance.new("Part");
                Part.Name = "ChichinePortalDisc";
                Part.Shape = Enum.PartType.Cylinder;
                Part.Size = Vector3.new(0.4, v59 * 2, v59 * 2);
                Part.CFrame = CFrame.new(v56, v57 + 0.15, v58) * CFrame.Angles(0, 0, 1.5707963267948966);
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.Material = Enum.Material.Neon;
                Part.BrickColor = BrickColor.new("Dark indigo");
                Part.Transparency = 0.35;
                Part.CastShadow = false;
                Part.Parent = workspace;
                u2[v55] = Part;
                task.spawn(function() -- Line: 453
                    -- upvalues: Part (copy), TweenService (ref)
                    while Part and Part.Parent do
                        TweenService:Create(Part, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {
                            Transparency = 0.68
                        }):Play();
                        task.wait(0.72);
                    end;
                end);
                local Part2 = Instance.new("Part");
                Part2.Name = "ChichinePortalBeam";
                Part2.Shape = Enum.PartType.Cylinder;
                Part2.Size = Vector3.new(0.1, 2.5, 2.5);
                Part2.CFrame = CFrame.new(v56, v57 + 12, v58) * CFrame.Angles(0, 0, 1.5707963267948966);
                Part2.Anchored = true;
                Part2.CanCollide = false;
                Part2.Material = Enum.Material.Neon;
                Part2.BrickColor = BrickColor.new("Dark indigo");
                Part2.Transparency = 0.6;
                Part2.CastShadow = false;
                Part2.Parent = Part;
                TweenService:Create(Part2, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = Vector3.new(24, 2.5, 2.5),
                    Transparency = 0.15
                }):Play();

                return;
            end;

            if p46 == "PortalClose" then
                local v60 = u47.id or 1;
                local u61 = u2[v60];

                if not u61 then
                    return;
                end;

                u2[v60] = nil;
                TweenService:Create(u61, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Transparency = 1
                }):Play();
                task.delay(0.5, function() -- Line: 492
                    -- upvalues: u61 (copy)
                    pcall(function() -- Line: 492
                        -- upvalues: u61 (ref)
                        u61:Destroy();
                    end);
                end);

                return;
            end;

            if p46 == "PlaySound" then
                local v62 = u47.id or u47.soundId;

                if type(v62) ~= "string" then
                    return;
                end;

                local v63 = u47.vol or (u47.volume or 1);

                if not u47.global then
                    playSpatialSound(u47.x or 0, u47.y or 0, u47.z or 0, v62, v63);

                    return;
                end;

                local Sound = Instance.new("Sound");
                Sound.SoundId = v62;
                Sound.Volume = v63;
                Sound.Parent = SoundService;
                Sound:Play();
                Sound.Ended:Connect(function() -- Line: 505
                    -- upvalues: Sound (copy)
                    pcall(function() -- Line: 505
                        -- upvalues: Sound (ref)
                        Sound:Destroy();
                    end);
                end);

                return;
            end;

            if p46 == "StopOpeningCutscene" then
                return;
            end;

            if p46 == "OpeningCutscene" then
                if type(u47.mapName) == "string" then
                    u12 = u47.mapName;

                    if not u11 then
                        u11 = true;
                        local u64 = Random.new();
                        task.spawn(function() -- Line: 78
                            -- upvalues: u11 (ref), u64 (copy), getLiveCosmeticRig (ref), Animation (ref), Players (ref), Debris (ref)
                            while u11 do
                                task.wait(u64:NextNumber(35, 120));

                                if not u11 then
                                    break;
                                end;

                                local v65 = getLiveCosmeticRig();

                                if v65 then
                                    local v66 = v65:FindFirstChildOfClass("Humanoid");
                                    local v67 = v66 and v66:FindFirstChildOfClass("Animator") or v65:FindFirstChildOfClass("Animator");

                                    if v67 then
                                        local v68 = v67:LoadAnimation(Animation);
                                        v68.Looped = true;
                                        v68.Priority = Enum.AnimationPriority.Action;
                                        v68:Play(0.5);
                                        local Sound = Instance.new("Sound");
                                        Sound.SoundId = "rbxassetid://4810729995";
                                        Sound.Volume = 1;
                                        Sound.Parent = Players.LocalPlayer;
                                        Sound:Play();
                                        Debris:AddItem(Sound, 20);
                                        local u69 = false;
                                        local v70 = Sound.Ended:Connect(function() -- Line: 104
                                            -- upvalues: u69 (ref)
                                            u69 = true;
                                        end);
                                        local v71 = 0;

                                        repeat
                                            v71 = v71 + task.wait(0.1);
                                        until u69 or (not u11 or v71 > 15);

                                        v70:Disconnect();
                                        Sound:Stop();
                                        v68:Stop(0.5);
                                    end;
                                end;
                            end;
                        end);
                    end;

                    task.spawn(function() -- Line: 521
                        -- upvalues: u47 (copy), u1 (ref), GlassShatter (ref), Players (ref), TweenService (ref)
                        local u72 = workspace.AdminAbuse.Map:WaitForChild(u47.mapName, 10);

                        if not u72 then
                            warn("[ChichineBossRoom] OpeningCutscene: map not found:", u47.mapName);

                            if u1 then
                                u1:showCutsceneUi();
                            end;

                            return;
                        end;

                        GlassShatter.scan(u72);
                        task.spawn(function() -- Line: 531
                            -- upvalues: u72 (copy)
                            local v73 = u72:FindFirstChild("Scriptables") and v73:FindFirstChild("CosmeticBossRig");

                            if not (v73 and v73:IsA("Model")) then
                                return;
                            end;

                            local v74 = v73:FindFirstChildOfClass("Humanoid");
                            local u75 = v74 and v74:FindFirstChildOfClass("Animator") or v73:FindFirstChildOfClass("AnimationController") and u75:FindFirstChildOfClass("Animator");

                            if not u75 then
                                return;
                            end;

                            local Animation2 = Instance.new("Animation");
                            Animation2.AnimationId = "rbxassetid://129833233965732";
                            local success, result = pcall(function() -- Line: 544
                                -- upvalues: u75 (ref), Animation2 (copy)
                                return u75:LoadAnimation(Animation2);
                            end);
                            Animation2:Destroy();

                            if not success then
                                return;
                            end;

                            result.Looped = true;
                            result:Play();
                        end);
                        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
                        local ScreenGui = Instance.new("ScreenGui");
                        ScreenGui.Name = "ChichineOpenBlack";
                        ScreenGui.IgnoreGuiInset = true;
                        ScreenGui.ResetOnSpawn = false;
                        ScreenGui.DisplayOrder = 999998;
                        ScreenGui.Parent = PlayerGui;
                        local Frame = Instance.new("Frame");
                        Frame.Size = UDim2.fromScale(1, 1);
                        Frame.BackgroundColor3 = Color3.new(0, 0, 0);
                        Frame.BackgroundTransparency = 1;
                        Frame.BorderSizePixel = 0;
                        Frame.Parent = ScreenGui;
                        local v76 = TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            BackgroundTransparency = 0
                        });
                        v76:Play();
                        v76.Completed:Wait();
                        task.wait(0.5);
                        local v77 = TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            BackgroundTransparency = 1
                        });
                        v77:Play();
                        v77.Completed:Once(function() -- Line: 575
                            -- upvalues: ScreenGui (copy), u1 (ref)
                            ScreenGui:Destroy();

                            if u1 then
                                u1:showCutsceneUi();
                            end;
                        end);
                    end);

                    return;
                end;

                warn("[ChichineBossRoom] OpeningCutscene: mapName missing from payload");

                if u1 then
                    u1:showCutsceneUi();

                    return;
                end;
            else
                if p46 == "SpawnOrbs" then
                    local v78;

                    if type(u47.count) == "number" then
                        local v79 = math.floor(u47.count);
                        v78 = math.max(1, v79) or 1;
                    else
                        v78 = 1;
                    end;

                    task.spawn(GlassShatter.spawnFromZone, v78);

                    return;
                end;

                if p46 == "SpawnGiantOrbs" then
                    local v80;

                    if type(u47.count) == "number" then
                        local v81 = math.floor(u47.count);
                        v80 = math.max(1, v81) or 1;
                    else
                        v80 = 1;
                    end;

                    task.spawn(GlassShatter.spawnGiantFromZone, v80);

                    return;
                end;

                if p46 == "EndingCutscene" then
                    if u1 then
                        u1:stop();
                        u1 = nil;
                    end;

                    task.spawn(function() -- Line: 595
                        -- upvalues: cleanupCosmetics (ref), Players (ref), TweenService (ref), ChichineConfig (ref), FakeAdminMessageUtil (ref), showCredits (ref)
                        cleanupCosmetics();
                        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
                        local ScreenGui = Instance.new("ScreenGui");
                        ScreenGui.Name = "ChichineEndBlack";
                        ScreenGui.IgnoreGuiInset = true;
                        ScreenGui.ResetOnSpawn = false;
                        ScreenGui.DisplayOrder = 999998;
                        ScreenGui.Parent = PlayerGui;
                        local Frame = Instance.new("Frame");
                        Frame.Size = UDim2.fromScale(1, 1);
                        Frame.BackgroundColor3 = Color3.new(0, 0, 0);
                        Frame.BackgroundTransparency = 1;
                        Frame.BorderSizePixel = 0;
                        Frame.Parent = ScreenGui;
                        local v82 = TweenService:Create(Frame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            BackgroundTransparency = 0
                        });
                        v82:Play();
                        v82.Completed:Wait();
                        local DefaultSenderId = ChichineConfig.DefaultSenderId;
                        local LokiiSenderId = ChichineConfig.LokiiSenderId;

                        for _, v in {
                            {
                                msg = "What happened?",
                                id = DefaultSenderId
                            },
                            {
                                msg = "We stopped you.",
                                id = LokiiSenderId
                            },
                            {
                                msg = "There\'s no way you did. I can feel World 3 open.",
                                id = DefaultSenderId
                            },
                            {
                                msg = "Wait... really?",
                                id = LokiiSenderId
                            },
                            {
                                msg = "Yes... World 3 is here, World 1 and 2 are intact... HOW?!",
                                id = DefaultSenderId
                            }
                        } do
                            local id = v.id;
                            local msg = v.msg;
                            task.spawn(function() -- Line: 632
                                -- upvalues: Players (ref), id (copy), FakeAdminMessageUtil (ref), msg (copy)
                                local success, result = pcall(function() -- Line: 633
                                    -- upvalues: Players (ref), id (ref)
                                    return Players:GetNameFromUserIdAsync(id);
                                end);
                                FakeAdminMessageUtil.show({
                                    duration = 8,
                                    message = msg,
                                    senderName = success and result and result or "User" .. tostring(id),
                                    senderUserId = id,
                                    preloadedThumb = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(id)
                                });
                            end);
                            task.wait(4);
                        end;

                        local v83 = TweenService:Create(Frame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            BackgroundTransparency = 1
                        });
                        v83:Play();
                        v83.Completed:Once(function() -- Line: 652
                            -- upvalues: ScreenGui (copy)
                            ScreenGui:Destroy();
                        end);
                        task.wait(1.5);
                        showCredits();
                        task.wait(1.5);
                    end);

                    return;
                end;

                if p46 == "TilesTransition" then
                    if u47.targetUserId ~= Players.LocalPlayer.UserId then
                        return;
                    end;

                    if not u4 then
                        local coolTransitions = require(ReplicatedStorage.coolTransitions);
                        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
                        u4 = coolTransitions.TransitionManager.new(PlayerGui);
                    end;

                    local u84 = u4;

                    if u84 then
                        task.spawn(function() -- Line: 664
                            -- upvalues: u84 (copy)
                            u84:PlayInOut(1, function() -- Line: 665
                            end, "Center", "Tiles");
                        end);

                        return;
                    end;
                else
                    if p46 == "ZoneWarn" then
                        ZoneSweet.ZoneWarn(u47);

                        return;
                    end;

                    if p46 == "ZoneHit" then
                        ZoneSweet.ZoneHit(u47);

                        return;
                    end;

                    if p46 == "ScreenShake" then
                        local u85 = u47.duration or 0.3;
                        local u86 = u47.intensity or 0.4;
                        local u87 = Players.LocalPlayer.Character and u87:FindFirstChildOfClass("Humanoid");

                        if not u87 then
                            return;
                        end;

                        task.spawn(function() -- Line: 384
                            -- upvalues: u85 (copy), u87 (copy), u86 (copy)
                            local v88 = 0;

                            while v88 < u85 do
                                v88 = v88 + task.wait();
                                local v89 = 1 - v88 / u85;
                                local v90 = math.sin(v88 * 43) * v89 * u86;
                                local v91 = math.sin(v88 * 29) * v89 * u86;
                                u87.CameraOffset = Vector3.new(v90, v91, 0);
                            end;

                            u87.CameraOffset = Vector3.new(0, 0, 0);
                        end);

                        return;
                    end;

                    if p46 == "HMHover" then
                        task.spawn(HammerSmash.hover, u47);

                        return;
                    end;

                    if p46 == "HMWarn" then
                        HammerSmash.warn(u47);

                        return;
                    end;

                    if p46 == "HMSmash" then
                        task.spawn(HammerSmash.smash, u47);

                        return;
                    end;

                    if p46 == "HMImpact" then
                        HammerSmash.impact(u47);

                        return;
                    end;

                    if p46 == "SwordTango" then
                        task.spawn(SwordTango.play, u47);

                        return;
                    end;

                    if p46 == "BoulderRainWarn" then
                        task.spawn(BoulderRain.warn, u47);

                        return;
                    end;

                    if p46 == "BoulderRainSpawn" then
                        task.spawn(BoulderRain.spawn, u47);

                        return;
                    end;

                    if p46 == "GlassShatterOpen" then
                        print("[ChichineBossRoom] Client: GlassShatterOpen received id=" .. tostring(u47.id));
                        task.spawn(GlassShatter.open, u47);

                        return;
                    end;

                    if p46 == "GlassShatterClose" then
                        print("[ChichineBossRoom] Client: GlassShatterClose received");
                        GlassShatter.closeAll();

                        return;
                    end;

                    if p46 == "SKSpawn" then
                        task.spawn(ShootingKeycaps.spawn, u47);

                        return;
                    end;

                    if p46 == "SKImpact" then
                        ShootingKeycaps.impactFx(u47);

                        return;
                    end;

                    if p46 == "TimeshiftBegin" then
                        local fadeIn = u47.fadeIn;
                        task.spawn(_timeshiftBegin, type(fadeIn) == "number" and (math.max(0.05, fadeIn) or 0.6) or 0.6);

                        return;
                    end;

                    if p46 == "TimeshiftEnd" then
                        local fadeOut = u47.fadeOut;
                        task.spawn(_timeshiftEnd, type(fadeOut) == "number" and (math.max(0.05, fadeOut) or 0.5) or 0.5);

                        return;
                    end;

                    if p46 == "BossTeleport" then
                        print("BossTeleport was called");
                        local rigModel = u47.rigModel;

                        if rigModel then
                            for _, descendant in ipairs(rigModel:GetDescendants()) do
                                if descendant:IsA("BasePart") then
                                    local u92 = descendant:Clone();
                                    u92.Parent = u47.debrisFolder or workspace;
                                    u92.Anchored = true;
                                    u92.Color = Color3.fromRGB(255, 255, 255);
                                    u92.Material = Enum.Material.ForceField;

                                    if #u92:GetChildren() > 0 then
                                        for _, child in ipairs(u92:GetChildren()) do
                                            child:Destroy();
                                        end;
                                    end;

                                    local u93 = TweenService:Create(u92, TweenInfo.new(3), {
                                        Transparency = 1
                                    });
                                    u93:Play();
                                    u93.Completed:Once(function(p94) -- Line: 754
                                        -- upvalues: u93 (copy), u92 (copy)
                                        u93:Destroy();
                                        u92:Destroy();
                                    end);
                                end;
                            end;

                            return;
                        end;

                        warn("[Chichinebossroom.client] - BossTeleport cmd missing rigModel arg");

                        return;
                    end;

                    if p46 == "DisappearNPC" then
                        if not u47.npc then
                            warn("[Chichinebossroom FX/Client] - DisappearNPC missing npc arg");

                            return;
                        end;

                        for _, child in ipairs(u47.npc:GetChildren()) do
                            if child:IsA("BasePart") then
                                local u95 = TweenService:Create(child, TweenInfo.new(1.5), {
                                    Transparency = 1
                                });
                                u95:Play();
                                u95.Completed:Once(function(p96) -- Line: 772
                                    -- upvalues: u95 (copy)
                                    u95:Destroy();
                                end);
                            end;
                        end;
                    end;
                end;
            end;
        end;

        return;
    end;

    local message = u47.message;

    if type(message) ~= "string" or message == "" then
        return;
    end;

    local u97 = u47.senderId or ChichineConfig.DefaultSenderId;
    local u98 = u47.duration or 8;
    task.spawn(function() -- Line: 411
        -- upvalues: Players (ref), u97 (copy), FakeAdminMessageUtil (ref), message (copy), u98 (copy)
        local success, result = pcall(function() -- Line: 412
            -- upvalues: Players (ref), u97 (ref)
            return Players:GetNameFromUserIdAsync(u97);
        end);
        FakeAdminMessageUtil.show({
            message = message,
            senderName = success and result and result or "User" .. tostring(u97),
            senderUserId = u97,
            preloadedThumb = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(u97),
            duration = u98
        });
    end);
end;

local u99 = false;
local u100 = false;

return {
    IsAdminAbuse = true,
    NeedsDuration = false,
    SkipDoorTransition = ChichineConfig.SkipDoorTransition,
    SkipDoorCamera = ChichineConfig.SkipDoorCamera,

    Fire = function(p101) -- Line: 790, Name: Fire
        -- upvalues: u99 (ref), u100 (ref), u1 (ref), cleanupCosmetics (copy), BossClientBase (copy), ChichineConfig (copy), handleFx (copy), MiguelSwarm (copy), u12 (ref), u11 (ref), getLiveCosmeticRig (copy), Animation (copy), Players (copy), Debris (copy), GlassShatter (copy), TweenService (copy), FakeAdminMessageUtil (copy), showCredits (copy)
        u99 = false;
        u100 = false;

        if u1 then
            u1:stop();
        end;

        cleanupCosmetics();
        u1 = BossClientBase.new({
            hideCutsceneUi = false,
            animatedGradient = true,
            sseChannelName = ChichineConfig.sseChannelName,
            bossDisplayName = ChichineConfig.bossName,
            bossIcon = ChichineConfig.bossIcon,
            phaseThresholds = ChichineConfig.PHASE_THRESHOLDS,

            onFx = function(p102, p103) -- Line: 805, Name: onFx
                -- upvalues: u99 (ref), u100 (ref), handleFx (ref)
                if p102 == "OpeningCutscene" then
                    if u99 then
                        return;
                    end;

                    u99 = true;
                elseif p102 == "EndingCutscene" then
                    if u100 then
                        return;
                    end;

                    u100 = true;
                end;

                handleFx(p102, p103);
            end
        });
        u1:fire();
        MiguelSwarm.init();
        local _sse = u1._sse;

        if _sse then
            _sse:onChange("OpeningCutscene", function(u104) -- Line: 823
                -- upvalues: u99 (ref), u12 (ref), u11 (ref), getLiveCosmeticRig (ref), Animation (ref), Players (ref), Debris (ref), u1 (ref), GlassShatter (ref), TweenService (ref)
                if type(u104) == "table" and (u104.mapName and not u99) then
                    task.delay(2, function() -- Line: 825
                        -- upvalues: u99 (ref), u104 (copy), u12 (ref), u11 (ref), getLiveCosmeticRig (ref), Animation (ref), Players (ref), Debris (ref), u1 (ref), GlassShatter (ref), TweenService (ref)
                        if not u99 then
                            u99 = true;
                            local u105 = u104;

                            if type(u105.mapName) == "string" then
                                u12 = u105.mapName;

                                if not u11 then
                                    u11 = true;
                                    local u106 = Random.new();
                                    task.spawn(function() -- Line: 78
                                        -- upvalues: u11 (ref), u106 (copy), getLiveCosmeticRig (ref), Animation (ref), Players (ref), Debris (ref)
                                        while u11 do
                                            task.wait(u106:NextNumber(35, 120));

                                            if not u11 then
                                                break;
                                            end;

                                            local v107 = getLiveCosmeticRig();

                                            if v107 then
                                                local v108 = v107:FindFirstChildOfClass("Humanoid");
                                                local v109 = v108 and v108:FindFirstChildOfClass("Animator") or v107:FindFirstChildOfClass("Animator");

                                                if v109 then
                                                    local v110 = v109:LoadAnimation(Animation);
                                                    v110.Looped = true;
                                                    v110.Priority = Enum.AnimationPriority.Action;
                                                    v110:Play(0.5);
                                                    local Sound = Instance.new("Sound");
                                                    Sound.SoundId = "rbxassetid://4810729995";
                                                    Sound.Volume = 1;
                                                    Sound.Parent = Players.LocalPlayer;
                                                    Sound:Play();
                                                    Debris:AddItem(Sound, 20);
                                                    local u111 = false;
                                                    local v112 = Sound.Ended:Connect(function() -- Line: 104
                                                        -- upvalues: u111 (ref)
                                                        u111 = true;
                                                    end);
                                                    local v113 = 0;

                                                    repeat
                                                        v113 = v113 + task.wait(0.1);
                                                    until u111 or (not u11 or v113 > 15);

                                                    v112:Disconnect();
                                                    Sound:Stop();
                                                    v110:Stop(0.5);
                                                end;
                                            end;
                                        end;
                                    end);
                                end;

                                task.spawn(function() -- Line: 521
                                    -- upvalues: u105 (copy), u1 (ref), GlassShatter (ref), Players (ref), TweenService (ref)
                                    local u114 = workspace.AdminAbuse.Map:WaitForChild(u105.mapName, 10);

                                    if not u114 then
                                        warn("[ChichineBossRoom] OpeningCutscene: map not found:", u105.mapName);

                                        if u1 then
                                            u1:showCutsceneUi();
                                        end;

                                        return;
                                    end;

                                    GlassShatter.scan(u114);
                                    task.spawn(function() -- Line: 531
                                        -- upvalues: u114 (copy)
                                        local v115 = u114:FindFirstChild("Scriptables") and v115:FindFirstChild("CosmeticBossRig");

                                        if not (v115 and v115:IsA("Model")) then
                                            return;
                                        end;

                                        local v116 = v115:FindFirstChildOfClass("Humanoid");
                                        local u117 = v116 and v116:FindFirstChildOfClass("Animator") or v115:FindFirstChildOfClass("AnimationController") and u117:FindFirstChildOfClass("Animator");

                                        if not u117 then
                                            return;
                                        end;

                                        local Animation2 = Instance.new("Animation");
                                        Animation2.AnimationId = "rbxassetid://129833233965732";
                                        local success, result = pcall(function() -- Line: 544
                                            -- upvalues: u117 (ref), Animation2 (copy)
                                            return u117:LoadAnimation(Animation2);
                                        end);
                                        Animation2:Destroy();

                                        if not success then
                                            return;
                                        end;

                                        result.Looped = true;
                                        result:Play();
                                    end);
                                    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
                                    local ScreenGui = Instance.new("ScreenGui");
                                    ScreenGui.Name = "ChichineOpenBlack";
                                    ScreenGui.IgnoreGuiInset = true;
                                    ScreenGui.ResetOnSpawn = false;
                                    ScreenGui.DisplayOrder = 999998;
                                    ScreenGui.Parent = PlayerGui;
                                    local Frame = Instance.new("Frame");
                                    Frame.Size = UDim2.fromScale(1, 1);
                                    Frame.BackgroundColor3 = Color3.new(0, 0, 0);
                                    Frame.BackgroundTransparency = 1;
                                    Frame.BorderSizePixel = 0;
                                    Frame.Parent = ScreenGui;
                                    local v118 = TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                        BackgroundTransparency = 0
                                    });
                                    v118:Play();
                                    v118.Completed:Wait();
                                    task.wait(0.5);
                                    local v119 = TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                        BackgroundTransparency = 1
                                    });
                                    v119:Play();
                                    v119.Completed:Once(function() -- Line: 575
                                        -- upvalues: ScreenGui (copy), u1 (ref)
                                        ScreenGui:Destroy();

                                        if u1 then
                                            u1:showCutsceneUi();
                                        end;
                                    end);
                                end);

                                return;
                            end;

                            warn("[ChichineBossRoom] OpeningCutscene: mapName missing from payload");

                            if u1 then
                                u1:showCutsceneUi();
                            end;
                        end;
                    end);
                end;
            end);
            _sse:onChange("EndingCutscene", function(p120) -- Line: 833
                -- upvalues: u100 (ref), u1 (ref), cleanupCosmetics (ref), Players (ref), TweenService (ref), ChichineConfig (ref), FakeAdminMessageUtil (ref), showCredits (ref)
                if type(p120) == "table" and not u100 then
                    u100 = true;

                    if u1 then
                        u1:stop();
                        u1 = nil;
                    end;

                    task.spawn(function() -- Line: 595
                        -- upvalues: cleanupCosmetics (ref), Players (ref), TweenService (ref), ChichineConfig (ref), FakeAdminMessageUtil (ref), showCredits (ref)
                        cleanupCosmetics();
                        local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
                        local ScreenGui = Instance.new("ScreenGui");
                        ScreenGui.Name = "ChichineEndBlack";
                        ScreenGui.IgnoreGuiInset = true;
                        ScreenGui.ResetOnSpawn = false;
                        ScreenGui.DisplayOrder = 999998;
                        ScreenGui.Parent = PlayerGui;
                        local Frame = Instance.new("Frame");
                        Frame.Size = UDim2.fromScale(1, 1);
                        Frame.BackgroundColor3 = Color3.new(0, 0, 0);
                        Frame.BackgroundTransparency = 1;
                        Frame.BorderSizePixel = 0;
                        Frame.Parent = ScreenGui;
                        local v121 = TweenService:Create(Frame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            BackgroundTransparency = 0
                        });
                        v121:Play();
                        v121.Completed:Wait();
                        local DefaultSenderId = ChichineConfig.DefaultSenderId;
                        local LokiiSenderId = ChichineConfig.LokiiSenderId;

                        for _, v in {
                            {
                                msg = "What happened?",
                                id = DefaultSenderId
                            },
                            {
                                msg = "We stopped you.",
                                id = LokiiSenderId
                            },
                            {
                                msg = "There\'s no way you did. I can feel World 3 open.",
                                id = DefaultSenderId
                            },
                            {
                                msg = "Wait... really?",
                                id = LokiiSenderId
                            },
                            {
                                msg = "Yes... World 3 is here, World 1 and 2 are intact... HOW?!",
                                id = DefaultSenderId
                            }
                        } do
                            local id = v.id;
                            local msg = v.msg;
                            task.spawn(function() -- Line: 632
                                -- upvalues: Players (ref), id (copy), FakeAdminMessageUtil (ref), msg (copy)
                                local success, result = pcall(function() -- Line: 633
                                    -- upvalues: Players (ref), id (ref)
                                    return Players:GetNameFromUserIdAsync(id);
                                end);
                                FakeAdminMessageUtil.show({
                                    duration = 8,
                                    message = msg,
                                    senderName = success and result and result or "User" .. tostring(id),
                                    senderUserId = id,
                                    preloadedThumb = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(id)
                                });
                            end);
                            task.wait(4);
                        end;

                        local v122 = TweenService:Create(Frame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            BackgroundTransparency = 1
                        });
                        v122:Play();
                        v122.Completed:Once(function() -- Line: 652
                            -- upvalues: ScreenGui (copy)
                            ScreenGui:Destroy();
                        end);
                        task.wait(1.5);
                        showCredits();
                        task.wait(1.5);
                    end);
                end;
            end);
        end;
    end,

    Stop = function() -- Line: 842, Name: Stop
        -- upvalues: u11 (ref), u12 (ref), ChichineCutscenes (copy), u1 (ref), cleanupCosmetics (copy), u4 (ref), u99 (ref), u100 (ref)
        u11 = false;
        u12 = nil;
        ChichineCutscenes.stop();

        if u1 then
            u1:stop();
            u1 = nil;
        end;

        cleanupCosmetics();

        if u4 then
            u4:Destroy();
            u4 = nil;
        end;

        u99 = false;
        u100 = false;
    end
};