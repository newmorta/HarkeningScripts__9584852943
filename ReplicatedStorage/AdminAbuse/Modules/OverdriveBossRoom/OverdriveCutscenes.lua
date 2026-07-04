-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.OverdriveBossRoom.OverdriveCutscenes
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local TweenService = game:GetService("TweenService");
local OverdriveBossRoom = ReplicatedStorage.AdminAbuse.OverdriveBossRoom;
local OverdriveSoundIds = require(script.Parent.OverdriveSoundIds);
local OverdriveAnimIds = require(script.Parent:WaitForChild("OverdriveAnimIds"));
local LocalPlayer = Players.LocalPlayer;
local u1 = {};

local function newState() -- Line: 50
    return {
        active = false,
        cachedWalkSpeed = nil,
        cachedJumpPower = nil,
        cachedJumpHeight = nil,
        tracks = {},
        cleanups = {},
        savedUiStates = {}
    };
end;

local u2 = newState();
local u3 = 0;
local u4 = nil;
local u5 = nil;
local u6 = nil;

local function playMarkerSound(p7) -- Line: 71
    -- upvalues: OverdriveBossRoom (copy), SoundService (copy)
    local SFX = OverdriveBossRoom:FindFirstChild("SFX");

    if not SFX then
        return;
    end;

    local v8 = SFX:FindFirstChild(p7);

    if v8 and v8:IsA("Sound") then
        local u9 = v8:Clone();
        v8.Volume = v8.Volume + 0.5;
        u9.Parent = SoundService;
        u9:Play();
        u9.Ended:Once(function() -- Line: 80
            -- upvalues: u9 (copy)
            u9:Destroy();
        end);
    end;
end;

local function playVoiceline(p10) -- Line: 84
    -- upvalues: OverdriveSoundIds (copy), SoundService (copy)
    local v11 = OverdriveSoundIds.Voicelines[p10];
    local Sound = Instance.new("Sound");
    Sound.Name = p10;
    Sound.SoundId = v11;
    Sound.Volume = Sound.Volume + 1;
    Sound.Parent = SoundService;
    Sound:Play();
    Sound.Ended:Once(function() -- Line: 95
        -- upvalues: Sound (copy)
        Sound:Destroy();
    end);
end;

local function getLiveMap() -- Line: 102
    local v12 = workspace:FindFirstChild("AdminAbuse") and v12:FindFirstChild("Map");

    if not v12 then
        return nil;
    end;

    for _, child in v12:GetChildren() do
        if child:IsA("Model") and child:GetAttribute("AdminAbuseLiveMap") then
            return child;
        end;
    end;

    return nil;
end;

local function getPortal() -- Line: 114
    -- upvalues: getLiveMap (copy)
    local v13 = getLiveMap() and v13:FindFirstChild("Scriptables") and v13:FindFirstChild("PortalVFX");

    if v13 and v13:IsA("BasePart") then
        return v13;
    end;

    return nil;
end;

local function getBossRig() -- Line: 122
    -- upvalues: getLiveMap (copy)
    local v14 = getLiveMap() and v14:FindFirstChild("Scriptables") and v14:FindFirstChild("BossRig");

    if v14 and v14:IsA("Model") then
        return v14;
    end;

    return nil;
end;

local function getCameraRig() -- Line: 129
    -- upvalues: getLiveMap (copy)
    local v15 = getLiveMap() and v15:FindFirstChild("Scriptables") and v15:FindFirstChild("Cutscenes") and v15:FindFirstChild("General") and v15:FindFirstChild("Rigs") and v15:FindFirstChild("HumanoidCameraRig");

    if v15 and v15:IsA("Model") then
        return v15;
    end;

    return nil;
end;

local function getWeaponsRig() -- Line: 139
    -- upvalues: getLiveMap (copy)
    local v16 = getLiveMap() and v16:FindFirstChild("Scriptables") and v16:FindFirstChild("Cutscenes") and v16:FindFirstChild("General") and v16:FindFirstChild("Rigs") and v16:FindFirstChild("WeaponsRig");

    if v16 and v16:IsA("Model") then
        return v16;
    end;

    return nil;
end;

local function getBanHammerRig() -- Line: 149
    -- upvalues: getLiveMap (copy)
    local v17 = getLiveMap() and v17:FindFirstChild("Scriptables") and v17:FindFirstChild("Cutscenes") and v17:FindFirstChild("Phase3Cutscene") and v17:FindFirstChild("Rigs") and v17:FindFirstChild("BanHammerRig");

    if v17 and v17:IsA("Model") then
        return v17;
    end;

    return nil;
end;

local function ensureAnimator(p18) -- Line: 161
    local v19 = p18:FindFirstChildOfClass("Humanoid");

    if v19 then
        local v20 = v19:FindFirstChildOfClass("Animator");

        if v20 then
            return v20;
        end;

        local Animator = Instance.new("Animator");
        Animator.Parent = v19;

        return Animator;
    end;

    local v21 = p18:FindFirstChildOfClass("AnimationController");

    if v21 then
        local v22 = v21:FindFirstChildOfClass("Animator");

        if v22 then
            return v22;
        end;

        local Animator = Instance.new("Animator");
        Animator.Parent = v21;

        return Animator;
    end;

    local AnimationController = Instance.new("AnimationController");
    AnimationController.Parent = p18;
    local Animator = Instance.new("Animator");
    Animator.Parent = AnimationController;

    return Animator;
end;

local function loadOnRig(p23, p24, p25, p26) -- Line: 181
    -- upvalues: ensureAnimator (copy)
    local v27 = ensureAnimator(p23);

    if not v27 then
        warn("[OverdriveCutscenes] No animator on " .. p23.Name);

        return nil;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = p24;
    local v28 = v27:LoadAnimation(Animation);
    v28.Priority = p25 or Enum.AnimationPriority.Action4;
    v28.Looped = p26 or false;

    return v28;
end;

local function resolveEasingStyle(u29) -- Line: 197
    if not u29 or u29 == "" then
        return Enum.EasingStyle.Quad;
    end;

    local v30 = tonumber(u29);

    if v30 then
        for _, v in Enum.EasingStyle:GetEnumItems() do
            if v.Value == v30 then
                return v;
            end;
        end;

        return Enum.EasingStyle.Quad;
    end;

    local success, result = pcall(function() -- Line: 206
        -- upvalues: u29 (copy)
        return Enum.EasingStyle[u29];
    end);

    if success and typeof(result) == "EnumItem" then
        return result;
    end;

    return Enum.EasingStyle.Quad;
end;

local function resolveEasingDirection(u31) -- Line: 210
    if not u31 or u31 == "" then
        return Enum.EasingDirection.InOut;
    end;

    local v32 = tonumber(u31);

    if v32 then
        for _, v in Enum.EasingDirection:GetEnumItems() do
            if v.Value == v32 then
                return v;
            end;
        end;

        return Enum.EasingDirection.InOut;
    end;

    local success, result = pcall(function() -- Line: 219
        -- upvalues: u31 (copy)
        return Enum.EasingDirection[u31];
    end);

    if success and typeof(result) == "EnumItem" then
        return result;
    end;

    return Enum.EasingDirection.InOut;
end;

local function handleFovMarker(p33) -- Line: 223
    -- upvalues: u4 (ref), TweenService (copy), resolveEasingStyle (copy), resolveEasingDirection (copy)
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local v34 = string.split(p33, ",");
    local v35 = tonumber(v34[1]);

    if not v35 then
        return;
    end;

    if u4 then
        u4:Cancel();
        u4:Destroy();
        u4 = nil;
    end;

    local v36 = tonumber(v34[2]) or 0;

    if v36 <= 0 then
        CurrentCamera.FieldOfView = v35;

        return;
    end;

    local u37 = TweenService:Create(CurrentCamera, TweenInfo.new(v36, resolveEasingStyle(v34[3]), (resolveEasingDirection(v34[4]))), {
        FieldOfView = v35
    });
    u4 = u37;
    u37:Play();
    u37.Completed:Once(function() -- Line: 239
        -- upvalues: u4 (ref), u37 (copy)
        if u4 == u37 then
            u4 = nil;
        end;

        u37:Destroy();
    end);
end;

local function connectMarkers(p38) -- Line: 245
    -- upvalues: handleFovMarker (copy), u2 (ref)
    local u40 = p38:GetMarkerReachedSignal("fov"):Connect(function(p39) -- Line: 246
        -- upvalues: handleFovMarker (ref)
        handleFovMarker((tostring(p39)));
    end);
    table.insert(u2.cleanups, function() -- Line: 249
        -- upvalues: u40 (copy)
        u40:Disconnect();
    end);
end;

local function handleBossAnimEvent(p41) -- Line: 253
    -- upvalues: playMarkerSound (copy), getLiveMap (copy), playVoiceline (copy)
    if p41 == "Hand_1" then
        playMarkerSound("body1");

        return;
    end;

    if p41 == "Hand_2" then
        playMarkerSound("body1");

        return;
    end;

    if p41 == "GettingOut" then
        playMarkerSound("body2");
        local v42 = getLiveMap() and v42:FindFirstChild("Scriptables") and v42:FindFirstChild("PortalVFX");

        if not (v42 and v42:IsA("BasePart")) then
            v42 = nil;
        end;

        for _, child in ipairs(v42.Main:GetChildren()) do
            if child:IsA("ParticleEmitter") then
                child.Enabled = false;
            end;
        end;

        return;
    end;

    if p41 == "SwordsUp" then
        playMarkerSound("energyCompleted");

        return;
    end;

    if p41 == "Point_1" then
        playMarkerSound("body1");
        playVoiceline("Phase3");

        return;
    end;

    if p41 == "Point_2" then
        playMarkerSound("body1");
        task.delay(3, playMarkerSound, "land");
        task.delay(5, playMarkerSound, "GroundSmash1");

        return;
    end;

    if p41 == "LookRight" then
        return;
    end;

    if p41 == "LookLeft" then
        return;
    end;

    if p41 == "Glitch_1" then
        playMarkerSound("glitch1");

        return;
    end;

    if p41 == "Glitch_2" then
        playMarkerSound("glitch1");

        return;
    end;

    if p41 == "Glitch_3" then
        playMarkerSound("glitch1");

        return;
    end;

    if p41 == "SwordsDown" then
        return;
    end;

    if p41 == "UpInAir" then
        return;
    end;

    if p41 ~= "SlamDown" then
        if p41 == "BossDefeat" then
            playVoiceline("FinalCutscene");
        end;

        return;
    end;

    playMarkerSound("portal");
    local v43 = getLiveMap() and v43:FindFirstChild("Scriptables") and v43:FindFirstChild("PortalVFX");

    if not (v43 and v43:IsA("BasePart")) then
        v43 = nil;
    end;

    for _, child in ipairs(v43.Main:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            child.Enabled = true;
        end;
    end;
end;

local u44 = { "Hand_1", "Hand_2", "GettingOut", "SwordsUp", "StartFloating", "Point_1", "Point_2", "JumpLand", "HammerHit", "LookRight", "LookLeft", "Glitch_1", "Glitch_2", "Glitch_3", "SwordsDown", "UpInAir", "SlamDown", "GlitchOpens", "BossDefeat" };

local function connectBossRigMarkers(p45) -- Line: 342
    -- upvalues: u44 (copy), handleBossAnimEvent (copy), u2 (ref)
    for _, v in u44 do
        local u47 = p45:GetMarkerReachedSignal(v):Connect(function(p46) -- Line: 344
            -- upvalues: handleBossAnimEvent (ref), v (copy)
            handleBossAnimEvent(v);
        end);
        table.insert(u2.cleanups, function() -- Line: 347
            -- upvalues: u47 (copy)
            u47:Disconnect();
        end);
    end;
end;

local function bindCameraToRig(u48) -- Line: 353
    -- upvalues: RunService (copy), LocalPlayer (copy)
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return function() -- Line: 355
        end;
    end;

    local u49 = u48:FindFirstChild("cam") or (u48:FindFirstChild("Torso") or u48:FindFirstChild("HumanoidRootPart") or (u48:FindFirstChild("RootPart") or u48.PrimaryPart));

    if not (u49 and u49:IsA("BasePart")) then
        warn("[OverdriveCutscenes] CameraRig: no anchor part found — camera not bound");
        print("[OverdriveCutscenes] CameraRig children:", table.concat((function() -- Line: 367
            -- upvalues: u48 (copy)
            local v50 = {};

            for _, child in u48:GetChildren() do
                table.insert(v50, child.Name .. "(" .. child.ClassName .. ")");
            end;

            return v50;
        end)(), ", "));

        return function() -- Line: 372
        end;
    end;

    print(string.format("[OverdriveCutscenes] bindCameraToRig: using part \'%s\' (%s) on rig \'%s\'", u49.Name, u49.ClassName, u48.Name));
    CurrentCamera.FieldOfView = 50;
    CurrentCamera.CameraSubject = u49;
    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    CurrentCamera.CFrame = u49.CFrame;
    RunService:BindToRenderStep("OverdriveCutsceneLock", Enum.RenderPriority.Camera.Value + 2, function() -- Line: 380
        -- upvalues: u49 (copy), CurrentCamera (copy)
        if u49.Parent then
            CurrentCamera.CFrame = u49.CFrame;
        end;
    end);

    return function() -- Line: 383
        -- upvalues: RunService (ref), CurrentCamera (copy), LocalPlayer (ref)
        RunService:UnbindFromRenderStep("OverdriveCutsceneLock");
        CurrentCamera.FieldOfView = 70;
        CurrentCamera.CameraType = Enum.CameraType.Custom;
        local v51 = LocalPlayer and LocalPlayer.Character and v51:FindFirstChildOfClass("Humanoid");

        if v51 then
            CurrentCamera.CameraSubject = v51;
        end;
    end;
end;

local function createBlackScreen() -- Line: 395
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "OverdriveCutsceneBlack";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    local Frame = Instance.new("Frame");
    Frame.Name = "Black";
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundColor3 = Color3.new(0, 0, 0);
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.ZIndex = 100;
    Frame.Parent = ScreenGui;
    ScreenGui.Parent = PlayerGui;

    return ScreenGui;
end;

local function fadeBlackScreen(p52, p53) -- Line: 416
    -- upvalues: TweenService (copy)
    local Black = p52:FindFirstChild("Black");

    if not Black then
        return;
    end;

    local v54 = TweenService:Create(Black, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
        BackgroundTransparency = p53
    });
    v54:Play();
    v54.Completed:Wait();
    v54:Destroy();
end;

local function hideTaggedUI() -- Line: 431
    -- upvalues: LocalPlayer (copy), u2 (ref), CollectionService (copy)
    local v55 = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui");

    if not v55 then
        return;
    end;

    table.clear(u2.savedUiStates);

    for _, v in CollectionService:GetTagged("UI") do
        if v:IsA("Frame") and v:IsDescendantOf(v55) then
            u2.savedUiStates[v] = v.Visible;
            v.Visible = false;
        end;
    end;
end;

local function restoreTaggedUI() -- Line: 443
    -- upvalues: u2 (ref)
    for i, v in u2.savedUiStates do
        if i and i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(u2.savedUiStates);
end;

local function freezeLocalPlayer() -- Line: 452
    -- upvalues: LocalPlayer (copy), u2 (ref)
    local v56 = LocalPlayer and LocalPlayer.Character and v56:FindFirstChildOfClass("Humanoid");

    if not v56 then
        return;
    end;

    u2.cachedWalkSpeed = v56.WalkSpeed;
    u2.cachedJumpPower = v56.JumpPower;
    u2.cachedJumpHeight = v56.JumpHeight;
    v56.WalkSpeed = 0;
    v56.JumpPower = 0;
    v56.JumpHeight = 0;
end;

local function unfreezeLocalPlayer() -- Line: 464
    -- upvalues: LocalPlayer (copy), u2 (ref)
    local v57 = LocalPlayer and LocalPlayer.Character and v57:FindFirstChildOfClass("Humanoid");

    if v57 then
        if u2.cachedWalkSpeed then
            v57.WalkSpeed = u2.cachedWalkSpeed;
        end;

        if u2.cachedJumpPower then
            v57.JumpPower = u2.cachedJumpPower;
        end;

        if u2.cachedJumpHeight then
            v57.JumpHeight = u2.cachedJumpHeight;
        end;
    end;

    u2.cachedWalkSpeed = nil;
    u2.cachedJumpPower = nil;
    u2.cachedJumpHeight = nil;
end;

local u58 = {};

local function revealBanHammerRig(p59) -- Line: 482
    -- upvalues: u58 (copy)
    table.clear(u58);
    local v60 = 0;

    for _, descendant in p59:GetDescendants() do
        if descendant.Name == "BanHammer" and descendant:IsA("BasePart") then
            local v61 = descendant:GetAttribute("__CutsceneOriginalTransparency");
            local v62 = typeof(v61) ~= "number" and 0 or v61;
            table.insert(u58, {
                part = descendant,
                hiddenT = descendant.Transparency
            });
            descendant.Transparency = v62;
            v60 = v60 + 1;
        end;
    end;

    print(string.format("[OverdriveCutscenes] revealBanHammerRig: revealed %d parts on \'%s\'", v60, p59.Name));
end;

local function hideBanHammerRig() -- Line: 500
    -- upvalues: u58 (copy)
    local v63 = 0;

    for _, v in u58 do
        if v.part and v.part.Parent then
            v.part.Transparency = v.hiddenT;
            v63 = v63 + 1;
        end;
    end;

    table.clear(u58);

    if v63 > 0 then
        print(string.format("[OverdriveCutscenes] hideBanHammerRig: re-hid %d parts", v63));
    end;
end;

local function teardown() -- Line: 516
    -- upvalues: u2 (ref), LocalPlayer (copy), hideBanHammerRig (copy), u4 (ref)
    for _, v in u2.tracks do
        pcall(function() -- Line: 517
            -- upvalues: v (copy)
            v:Stop(0);
        end);
    end;

    table.clear(u2.tracks);

    for i = #u2.cleanups, 1, -1 do
        pcall(u2.cleanups[i]);
    end;

    table.clear(u2.cleanups);

    for i, v in u2.savedUiStates do
        if i and i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(u2.savedUiStates);
    local v64 = LocalPlayer and LocalPlayer.Character and v64:FindFirstChildOfClass("Humanoid");

    if v64 then
        if u2.cachedWalkSpeed then
            v64.WalkSpeed = u2.cachedWalkSpeed;
        end;

        if u2.cachedJumpPower then
            v64.JumpPower = u2.cachedJumpPower;
        end;

        if u2.cachedJumpHeight then
            v64.JumpHeight = u2.cachedJumpHeight;
        end;
    end;

    u2.cachedWalkSpeed = nil;
    u2.cachedJumpPower = nil;
    u2.cachedJumpHeight = nil;
    hideBanHammerRig();

    if u4 then
        u4:Cancel();
        u4:Destroy();
        u4 = nil;
    end;

    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera.FieldOfView = 70;
    end;

    u2.active = false;
end;

local function playTracks(p65) -- Line: 534
    -- upvalues: loadOnRig (copy), connectMarkers (copy), connectBossRigMarkers (copy), u2 (ref)
    local v66 = 0;

    for _, v in p65 do
        local v67 = loadOnRig(v.rig, v.id);

        if v67 then
            connectMarkers(v67);

            if v.rig.Name == "BossRig" then
                connectBossRigMarkers(v67);
            end;

            table.insert(u2.tracks, v67);
            v67:Play(0);

            if v66 < v67.Length then
                v66 = v67.Length;
            end;
        end;
    end;

    return v66;
end;

local function showCredits() -- Line: 553
    -- upvalues: LocalPlayer (copy), TweenService (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "OverdriveCredits";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.DisplayOrder = 100;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.Parent = PlayerGui;
    local Frame = Instance.new("Frame");
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundTransparency = 1;
    Frame.Parent = ScreenGui;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Size = UDim2.fromScale(0.8, 0.4);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.Text = "Brought to you by:\n\nHosts - Secret_Lokii & LuckyMatg\nProducers - Chichine & FoeCakes\nScripter - FoeCakes\nAnimator - EternityReality\nBuilder - Nextune_Dev\nWriter - 0V3RDRIVE_Dev\nMusic - X3LL3N\n";
    TextLabel.TextTransparency = 1;
    TextLabel.Parent = Frame;
    TweenService:Create(TextLabel, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play();
    task.wait(6.5);
    local v68 = TweenService:Create(TextLabel, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    });
    v68:Play();
    v68.Completed:Once(function() -- Line: 603
        -- upvalues: ScreenGui (copy)
        ScreenGui:Destroy();
    end);
end;

function u1.startIdleAnimations() -- Line: 608
    -- upvalues: u1 (copy), getLiveMap (copy), getWeaponsRig (copy), loadOnRig (copy), OverdriveAnimIds (copy), u5 (ref), u6 (ref)
    u1.stopIdleAnimations();
    local v69 = getLiveMap() and v69:FindFirstChild("Scriptables") and v69:FindFirstChild("BossRig");

    if not (v69 and v69:IsA("Model")) then
        v69 = nil;
    end;

    local v70 = getWeaponsRig();
    local v71 = v69 and loadOnRig(v69, OverdriveAnimIds.Idle.BossRig, Enum.AnimationPriority.Idle, true);

    if v71 then
        v71:Play(0.3);
        u5 = v71;
    end;

    local v72 = v70 and loadOnRig(v70, OverdriveAnimIds.Idle.WeaponsRig, Enum.AnimationPriority.Idle, true);

    if v72 then
        v72:Play(0.3);
        u6 = v72;
    end;
end;

function u1.stopIdleAnimations() -- Line: 622
    -- upvalues: u5 (ref), u6 (ref)
    if u5 then
        pcall(function() -- Line: 623
            -- upvalues: u5 (ref)
            u5:Stop(0.3);
        end);
        u5 = nil;
    end;

    if u6 then
        pcall(function() -- Line: 624
            -- upvalues: u6 (ref)
            u6:Stop(0.3);
        end);
        u6 = nil;
    end;
end;

function u1.ensureIdleAnimations() -- Line: 629
    -- upvalues: u2 (ref), getLiveMap (copy), getWeaponsRig (copy), u5 (ref), loadOnRig (copy), OverdriveAnimIds (copy), u6 (ref)
    if u2.active then
        return;
    end;

    local v73 = getLiveMap() and v73:FindFirstChild("Scriptables") and v73:FindFirstChild("BossRig");

    if not (v73 and v73:IsA("Model")) then
        v73 = nil;
    end;

    local v74 = getWeaponsRig();

    if v73 and not (u5 and u5.IsPlaying) then
        if u5 then
            pcall(function() -- Line: 634
                -- upvalues: u5 (ref)
                u5:Stop(0);
            end);
        end;

        local v75 = loadOnRig(v73, OverdriveAnimIds.Idle.BossRig, Enum.AnimationPriority.Idle, true);

        if v75 then
            v75:Play(0.3);
            u5 = v75;
        end;
    end;

    if v74 and not (u6 and u6.IsPlaying) then
        if u6 then
            pcall(function() -- Line: 639
                -- upvalues: u6 (ref)
                u6:Stop(0);
            end);
        end;

        local v76 = loadOnRig(v74, OverdriveAnimIds.Idle.WeaponsRig, Enum.AnimationPriority.Idle, true);

        if v76 then
            v76:Play(0.3);
            u6 = v76;
        end;
    end;
end;

function u1.stopAll() -- Line: 647
    -- upvalues: u3 (ref), u2 (ref), teardown (copy)
    u3 = u3 + 1;

    if u2.active then
        teardown();
    end;
end;

function u1.playStartCutscene(p77) -- Line: 654
    -- upvalues: OverdriveAnimIds (copy), u1 (copy), u3 (ref), u2 (ref), newState (copy), getLiveMap (copy), getCameraRig (copy), getWeaponsRig (copy), hideTaggedUI (copy), LocalPlayer (copy), bindCameraToRig (copy), playTracks (copy), createBlackScreen (copy), fadeBlackScreen (copy), teardown (copy)
    if p77 then
        p77 = p77.firedAt;
    end;

    if type(p77) == "number" and OverdriveAnimIds.CutsceneDurations.Intro + 3.75 + 0.5 + 5 < os.time() - p77 then
        return;
    end;

    u1.stopAll();
    u3 = u3 + 1;
    local v78 = u3;
    u2 = newState();
    u2.active = true;
    local v79 = getLiveMap() and v79:FindFirstChild("Scriptables") and v79:FindFirstChild("PortalVFX");

    if not (v79 and v79:IsA("BasePart")) then
        v79 = nil;
    end;

    for _, child in ipairs(v79.Main:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            child.Enabled = true;
        end;
    end;

    local v80 = getLiveMap() and v80:FindFirstChild("Scriptables") and v80:FindFirstChild("BossRig");

    if not (v80 and v80:IsA("Model")) then
        v80 = nil;
    end;

    local v81 = getCameraRig();
    local v82 = getWeaponsRig();

    if not (v80 and (v81 and v82)) then
        warn("[OverdriveCutscenes] Intro: missing BossRig, CameraRig or WeaponsRig — bailing");
        u2.active = false;

        return;
    end;

    hideTaggedUI();
    local v83 = LocalPlayer and LocalPlayer.Character and v83:FindFirstChildOfClass("Humanoid");

    if v83 then
        u2.cachedWalkSpeed = v83.WalkSpeed;
        u2.cachedJumpPower = v83.JumpPower;
        u2.cachedJumpHeight = v83.JumpHeight;
        v83.WalkSpeed = 0;
        v83.JumpPower = 0;
        v83.JumpHeight = 0;
    end;

    local cleanups = u2.cleanups;
    local v84 = bindCameraToRig(v81);
    table.insert(cleanups, v84);
    local v85 = playTracks({
        {
            rig = v80,
            id = OverdriveAnimIds.Cutscenes.Intro.BossRig
        },
        {
            rig = v81,
            id = OverdriveAnimIds.Cutscenes.Intro.CameraRig
        },
        {
            rig = v82,
            id = OverdriveAnimIds.Cutscenes.Intro.WeaponsRig
        }
    });

    if v85 <= 0 then
        v85 = OverdriveAnimIds.CutsceneDurations.Intro;
    end;

    task.wait(v85);

    if v78 ~= u3 or not u2.active then
        return;
    end;

    task.wait(3.75);

    if v78 ~= u3 or not u2.active then
        return;
    end;

    local u86 = createBlackScreen();
    fadeBlackScreen(u86, 0);

    if u2.active then
        teardown();
    end;

    fadeBlackScreen(u86, 1);
    pcall(function() -- Line: 707
        -- upvalues: u86 (copy)
        u86:Destroy();
    end);
end;

function u1.playPhase3Cutscene(p87) -- Line: 712
    -- upvalues: OverdriveAnimIds (copy), getBanHammerRig (copy), revealBanHammerRig (copy), u1 (copy), u3 (ref), u2 (ref), newState (copy), getLiveMap (copy), getCameraRig (copy), getWeaponsRig (copy), hideTaggedUI (copy), LocalPlayer (copy), bindCameraToRig (copy), playTracks (copy), createBlackScreen (copy), fadeBlackScreen (copy), teardown (copy)
    if p87 then
        p87 = p87.firedAt;
    end;

    if type(p87) == "number" and OverdriveAnimIds.CutsceneDurations.Phase3 + 3.75 + 0.5 + 5 < os.time() - p87 then
        local v88 = getBanHammerRig();

        if v88 then
            revealBanHammerRig(v88);
        end;

        return;
    end;

    u1.stopAll();
    u3 = u3 + 1;
    local v89 = u3;
    u2 = newState();
    u2.active = true;
    local v90 = getLiveMap() and v90:FindFirstChild("Scriptables") and v90:FindFirstChild("BossRig");

    if not (v90 and v90:IsA("Model")) then
        v90 = nil;
    end;

    local v91 = getCameraRig();
    local v92 = getWeaponsRig();

    if not (v90 and (v91 and v92)) then
        warn("[OverdriveCutscenes] Phase3: missing BossRig, CameraRig or WeaponsRig — bailing");
        u2.active = false;

        return;
    end;

    local v93 = getBanHammerRig();
    print("[OverdriveCutscenes] Phase3: BanHammerRig found =", v93 ~= nil);

    if not v93 then
        warn("[OverdriveCutscenes] Phase3: BanHammerRig not found — continuing without it");
    end;

    hideTaggedUI();
    local v94 = LocalPlayer and LocalPlayer.Character and v94:FindFirstChildOfClass("Humanoid");

    if v94 then
        u2.cachedWalkSpeed = v94.WalkSpeed;
        u2.cachedJumpPower = v94.JumpPower;
        u2.cachedJumpHeight = v94.JumpHeight;
        v94.WalkSpeed = 0;
        v94.JumpPower = 0;
        v94.JumpHeight = 0;
    end;

    if v93 then
        revealBanHammerRig(v93);
    end;

    local cleanups = u2.cleanups;
    local v95 = bindCameraToRig(v91);
    table.insert(cleanups, v95);
    local v96 = {
        {
            rig = v90,
            id = OverdriveAnimIds.Cutscenes.Phase3.BossRig
        },
        {
            rig = v91,
            id = OverdriveAnimIds.Cutscenes.Phase3.CameraRig
        },
        {
            rig = v92,
            id = OverdriveAnimIds.Cutscenes.Phase3.WeaponsRig
        }
    };

    if v93 then
        table.insert(v96, {
            rig = v93,
            id = OverdriveAnimIds.Cutscenes.Phase3.BanHammerRig
        });
    end;

    local v97 = playTracks(v96);

    if v97 <= 0 then
        v97 = OverdriveAnimIds.CutsceneDurations.Phase3;
    end;

    task.wait(v97);

    if v89 ~= u3 or not u2.active then
        return;
    end;

    task.wait(3.75);

    if v89 ~= u3 or not u2.active then
        return;
    end;

    local u98 = createBlackScreen();
    fadeBlackScreen(u98, 0);

    if u2.active then
        teardown();
    end;

    fadeBlackScreen(u98, 1);
    pcall(function() -- Line: 771
        -- upvalues: u98 (copy)
        u98:Destroy();
    end);
end;

function u1.playEnding(p99) -- Line: 776
    -- upvalues: OverdriveAnimIds (copy), u1 (copy), u3 (ref), u2 (ref), newState (copy), getLiveMap (copy), getCameraRig (copy), getWeaponsRig (copy), hideTaggedUI (copy), LocalPlayer (copy), createBlackScreen (copy), fadeBlackScreen (copy), bindCameraToRig (copy), playTracks (copy), teardown (copy), showCredits (copy)
    if p99 then
        p99 = p99.firedAt;
    end;

    if type(p99) == "number" and OverdriveAnimIds.CutsceneDurations.Ending + 3.75 + 0.5 + 8.5 + 5 < os.time() - p99 then
        return;
    end;

    u1.stopAll();
    u3 = u3 + 1;
    local v100 = u3;
    u2 = newState();
    u2.active = true;
    local v101 = getLiveMap() and v101:FindFirstChild("Scriptables") and v101:FindFirstChild("BossRig");

    if not (v101 and v101:IsA("Model")) then
        v101 = nil;
    end;

    local v102 = getCameraRig();
    local v103 = getWeaponsRig();

    if not (v101 and (v102 and v103)) then
        warn("[OverdriveCutscenes] Ending: missing BossRig, CameraRig or WeaponsRig — bailing");
        u2.active = false;

        return;
    end;

    hideTaggedUI();
    local v104 = LocalPlayer and LocalPlayer.Character and v104:FindFirstChildOfClass("Humanoid");

    if v104 then
        u2.cachedWalkSpeed = v104.WalkSpeed;
        u2.cachedJumpPower = v104.JumpPower;
        u2.cachedJumpHeight = v104.JumpHeight;
        v104.WalkSpeed = 0;
        v104.JumpPower = 0;
        v104.JumpHeight = 0;
    end;

    local u105 = createBlackScreen();
    fadeBlackScreen(u105, 0);
    local cleanups = u2.cleanups;
    local v106 = bindCameraToRig(v102);
    table.insert(cleanups, v106);
    local v107 = playTracks({
        {
            rig = v101,
            id = OverdriveAnimIds.Cutscenes.Ending.BossRig
        },
        {
            rig = v102,
            id = OverdriveAnimIds.Cutscenes.Ending.CameraRig
        },
        {
            rig = v103,
            id = OverdriveAnimIds.Cutscenes.Ending.WeaponsRig
        }
    });

    if v107 <= 0 then
        v107 = OverdriveAnimIds.CutsceneDurations.Ending;
    end;

    fadeBlackScreen(u105, 1);
    task.wait(v107);

    if v100 ~= u3 or not u2.active then
        return;
    end;

    task.wait(3.75);

    if v100 ~= u3 or not u2.active then
        return;
    end;

    fadeBlackScreen(u105, 0);

    if u2.active then
        teardown();
    end;

    task.spawn(showCredits);
    task.wait(1.5);
    fadeBlackScreen(u105, 1);
    pcall(function() -- Line: 834
        -- upvalues: u105 (copy)
        u105:Destroy();
    end);
end;

return u1;