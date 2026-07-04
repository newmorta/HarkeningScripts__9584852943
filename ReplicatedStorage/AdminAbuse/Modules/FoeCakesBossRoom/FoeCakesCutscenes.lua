-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.FoeCakesBossRoom.FoeCakesCutscenes
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ContentProvider = game:GetService("ContentProvider");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local FoeCakesBossRoom = ReplicatedStorage.AdminAbuse.FoeCakesBossRoom;
local u1 = {};
local FoeCakesBossAnimIds = require(script.Parent:WaitForChild("FoeCakesBossAnimIds"));
local LocalPlayer = Players.LocalPlayer;

local function newState() -- Line: 58
    return {
        active = false,
        cachedBossCFrame = nil,
        cachedWalkSpeed = nil,
        cachedJumpPower = nil,
        cachedJumpHeight = nil,
        playerRigRef = nil,
        tracks = {},
        cleanups = {},
        savedUiStates = {},
        playerParts = {},
        playerDecals = {},
        revealedRigParts = {}
    };
end;

local u2 = newState();
local u3 = 0;
local u4 = nil;

local function getLiveMap() -- Line: 81
    local v5 = workspace:FindFirstChild("AdminAbuse") and v5:FindFirstChild("Map");

    if not v5 then
        return nil;
    end;

    for _, child in v5:GetChildren() do
        if child:IsA("Model") and child:GetAttribute("AdminAbuseLiveMap") then
            return child;
        end;
    end;

    return nil;
end;

local function getBossRig() -- Line: 93
    -- upvalues: getLiveMap (copy)
    local v6 = getLiveMap() and v6:FindFirstChild("BossRig");

    if v6 and v6:IsA("Model") then
        return v6;
    end;

    return nil;
end;

local function getCutsceneContainer() -- Line: 99
    -- upvalues: getLiveMap (copy)
    local v7 = getLiveMap() and v7:FindFirstChild("Scriptables") and v7:FindFirstChild("FoeCakesCutscene");

    return v7;
end;

local function getCameraRig() -- Line: 105
    -- upvalues: getLiveMap (copy)
    local v8 = getLiveMap() and v8:FindFirstChild("Scriptables") and v8:FindFirstChild("FoeCakesCutscene") and v8:FindFirstChild("CameraRig");

    if v8 and v8:IsA("Model") then
        return v8;
    end;

    return nil;
end;

local function getPlayerRig() -- Line: 111
    -- upvalues: getLiveMap (copy)
    local v9 = getLiveMap() and v9:FindFirstChild("Scriptables") and v9:FindFirstChild("FoeCakesCutscene") and v9:FindFirstChild("PlayerRig");

    if v9 and v9:IsA("Model") then
        return v9;
    end;

    return nil;
end;

local function getPlayerRigAnchor() -- Line: 117
    -- upvalues: getLiveMap (copy)
    local v10 = getLiveMap() and v10:FindFirstChild("Scriptables") and v10:FindFirstChild("FoeCakesCutscene") and v10:FindFirstChild("PlayerRigAnchor");

    if v10 and v10:IsA("BasePart") then
        return v10;
    end;

    return nil;
end;

local function getPlayerRigTemplate() -- Line: 123
    -- upvalues: FoeCakesBossRoom (copy)
    local v11 = FoeCakesBossRoom:FindFirstChild("Assets") and v11:FindFirstChild("PlayerRig");

    if v11 and v11:IsA("Model") then
        return v11;
    end;

    return nil;
end;

local function getPostEndCutsceneContainer() -- Line: 129
    -- upvalues: getLiveMap (copy)
    local v12 = getLiveMap() and v12:FindFirstChild("Scriptables") and v12:FindFirstChild("PostEndCutscene");

    return v12;
end;

local function hideTaggedUI() -- Line: 137
    -- upvalues: LocalPlayer (copy), u2 (ref), CollectionService (copy)
    local v13 = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui");

    if not v13 then
        return;
    end;

    table.clear(u2.savedUiStates);

    for _, v in CollectionService:GetTagged("UI") do
        if v:IsA("Frame") and v:IsDescendantOf(v13) then
            u2.savedUiStates[v] = v.Visible;
            v.Visible = false;
        end;
    end;
end;

local function restoreTaggedUI() -- Line: 149
    -- upvalues: u2 (ref)
    for i, v in u2.savedUiStates do
        if i and i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(u2.savedUiStates);
end;

local function freezeLocalPlayer() -- Line: 158
    -- upvalues: LocalPlayer (copy), u2 (ref)
    local v14 = LocalPlayer and LocalPlayer.Character and v14:FindFirstChildOfClass("Humanoid");

    if not v14 then
        return;
    end;

    u2.cachedWalkSpeed = v14.WalkSpeed;
    u2.cachedJumpPower = v14.JumpPower;
    u2.cachedJumpHeight = v14.JumpHeight;
    v14.WalkSpeed = 0;
    v14.JumpPower = 0;
    v14.JumpHeight = 0;
end;

local function unfreezeLocalPlayer() -- Line: 170
    -- upvalues: LocalPlayer (copy), u2 (ref)
    local v15 = LocalPlayer and LocalPlayer.Character and v15:FindFirstChildOfClass("Humanoid");

    if v15 then
        if u2.cachedWalkSpeed then
            v15.WalkSpeed = u2.cachedWalkSpeed;
        end;

        if u2.cachedJumpPower then
            v15.JumpPower = u2.cachedJumpPower;
        end;

        if u2.cachedJumpHeight then
            v15.JumpHeight = u2.cachedJumpHeight;
        end;
    end;

    u2.cachedWalkSpeed = nil;
    u2.cachedJumpPower = nil;
    u2.cachedJumpHeight = nil;
end;

local function hideAllRealPlayers() -- Line: 187
    -- upvalues: u2 (ref), Players (copy)
    table.clear(u2.playerParts);
    table.clear(u2.playerDecals);

    for _, v in Players:GetPlayers() do
        local Character = v.Character;

        if Character then
            for _, descendant in Character:GetDescendants() do
                if descendant:IsA("BasePart") then
                    table.insert(u2.playerParts, {
                        part = descendant,
                        transparency = descendant.Transparency,
                        localTransparencyModifier = descendant.LocalTransparencyModifier
                    });
                    descendant.LocalTransparencyModifier = 1;
                elseif descendant:IsA("Decal") then
                    table.insert(u2.playerDecals, {
                        decal = descendant,
                        transparency = descendant.Transparency
                    });
                    descendant.Transparency = 1;
                end;
            end;
        end;
    end;
end;

local function restoreAllRealPlayers() -- Line: 211
    -- upvalues: u2 (ref)
    for _, v in u2.playerParts do
        if v.part and v.part.Parent then
            v.part.LocalTransparencyModifier = v.localTransparencyModifier;
        end;
    end;

    for _, v in u2.playerDecals do
        if v.decal and v.decal.Parent then
            v.decal.Transparency = v.transparency;
        end;
    end;

    table.clear(u2.playerParts);
    table.clear(u2.playerDecals);
end;

local function revealCutsceneRig(p16) -- Line: 233
    -- upvalues: u2 (ref)
    u2.playerRigRef = p16;

    for _, descendant in p16:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v17 = descendant:GetAttribute("__CutsceneOriginalTransparency");
            local v18 = typeof(v17) ~= "number" and 0 or v17;
            table.insert(u2.revealedRigParts, {
                decalInst = nil,
                partInst = descendant,
                hiddenT = descendant.Transparency
            });
            descendant.Transparency = v18;
        elseif descendant:IsA("Decal") then
            local v19 = descendant:GetAttribute("__CutsceneOriginalTransparency");
            local v20 = typeof(v19) ~= "number" and 0 or v19;
            table.insert(u2.revealedRigParts, {
                partInst = nil,
                decalInst = descendant,
                hiddenT = descendant.Transparency
            });
            descendant.Transparency = v20;
        end;
    end;
end;

local function rehideCutsceneRig() -- Line: 252
    -- upvalues: u2 (ref)
    for _, v in u2.revealedRigParts do
        if v.partInst and v.partInst.Parent then
            v.partInst.Transparency = v.hiddenT;
        elseif v.decalInst and v.decalInst.Parent then
            v.decalInst.Transparency = v.hiddenT;
        end;
    end;

    table.clear(u2.revealedRigParts);
    local playerRigRef = u2.playerRigRef;

    if playerRigRef and playerRigRef.Parent then
        for _, descendant in playerRigRef:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Transparency = 1;
                descendant.CanCollide = false;
                descendant.CanTouch = false;
                descendant.CanQuery = false;
            elseif descendant:IsA("Decal") then
                descendant.Transparency = 1;
            end;
        end;
    end;

    u2.playerRigRef = nil;
end;

local function hideBossBar() -- Line: 281
    -- upvalues: LocalPlayer (copy), u2 (ref)
    local u21 = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") and u21:FindFirstChild("FoeCakesBossHud");

    if not (u21 and u21:IsA("ScreenGui")) then
        return;
    end;

    local Enabled = u21.Enabled;
    u21.Enabled = false;
    table.insert(u2.cleanups, function() -- Line: 288
        -- upvalues: u21 (copy), Enabled (copy)
        if u21 and u21.Parent then
            u21.Enabled = Enabled;
        end;
    end);
end;

local function cacheBossCFrame() -- Line: 300
    -- upvalues: getLiveMap (copy), u2 (ref)
    local v22 = getLiveMap() and v22:FindFirstChild("BossRig");

    if not (v22 and v22:IsA("Model")) then
        v22 = nil;
    end;

    if v22 then
        v22 = v22:FindFirstChild("HumanoidRootPart");
    end;

    if v22 then
        u2.cachedBossCFrame = v22.CFrame;
    end;
end;

local function restoreBossCFrame() -- Line: 306
    -- upvalues: getLiveMap (copy), u2 (ref)
    local u23 = getLiveMap() and u23:FindFirstChild("BossRig");

    if not (u23 and u23:IsA("Model")) then
        u23 = nil;
    end;

    local cachedBossCFrame = u2.cachedBossCFrame;

    if u23 and cachedBossCFrame then
        pcall(function() -- Line: 310
            -- upvalues: u23 (copy), cachedBossCFrame (copy)
            u23:PivotTo(cachedBossCFrame);
        end);
    end;

    u2.cachedBossCFrame = nil;
end;

local function bindCameraToRig(p24) -- Line: 317
    -- upvalues: RunService (copy), LocalPlayer (copy)
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return function() -- Line: 319
        end;
    end;

    local cam = p24:FindFirstChild("cam");

    if not (cam and cam:IsA("BasePart")) then
        warn("[FoeCakesCutscenes] CameraRig.cam BasePart not found");

        return function() -- Line: 323
        end;
    end;

    CurrentCamera.FieldOfView = 50;
    CurrentCamera.CameraSubject = cam;
    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    CurrentCamera.CFrame = cam.CFrame;
    RunService:BindToRenderStep("FoeCakesCutsceneLock", Enum.RenderPriority.Camera.Value + 2, function() -- Line: 329
        -- upvalues: cam (copy), CurrentCamera (copy)
        if cam.Parent then
            CurrentCamera.CFrame = cam.CFrame;
        end;
    end);

    return function() -- Line: 332
        -- upvalues: RunService (ref), CurrentCamera (copy), LocalPlayer (ref)
        RunService:UnbindFromRenderStep("FoeCakesCutsceneLock");
        CurrentCamera.FieldOfView = 70;
        CurrentCamera.CameraType = Enum.CameraType.Custom;
        local v25 = LocalPlayer and LocalPlayer.Character and v25:FindFirstChildOfClass("Humanoid");

        if v25 then
            CurrentCamera.CameraSubject = v25;
        end;
    end;
end;

local function playMarkerSound(p26) -- Line: 344
    -- upvalues: FoeCakesBossRoom (copy)
    local Cutscene_SFX_FoeCakes = FoeCakesBossRoom:FindFirstChild("Cutscene_SFX_FoeCakes");

    if not Cutscene_SFX_FoeCakes then
        return;
    end;

    local v27 = Cutscene_SFX_FoeCakes:FindFirstChild(p26);

    if v27 and v27:IsA("Sound") then
        local u28 = v27:Clone();
        u28.Parent = workspace;
        u28:Play();
        u28.Ended:Once(function() -- Line: 352
            -- upvalues: u28 (copy)
            u28:Destroy();
        end);
    end;
end;

local function resolveEasingStyle(u29) -- Line: 361
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

    local success, result = pcall(function() -- Line: 370
        -- upvalues: u29 (copy)
        return Enum.EasingStyle[u29];
    end);

    if success and typeof(result) == "EnumItem" then
        return result;
    end;

    return Enum.EasingStyle.Quad;
end;

local function resolveEasingDirection(u31) -- Line: 375
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

    local success, result = pcall(function() -- Line: 384
        -- upvalues: u31 (copy)
        return Enum.EasingDirection[u31];
    end);

    if success and typeof(result) == "EnumItem" then
        return result;
    end;

    return Enum.EasingDirection.InOut;
end;

local function makeTI(p33, p34, p35) -- Line: 389
    -- upvalues: resolveEasingStyle (copy), resolveEasingDirection (copy)
    return TweenInfo.new(p33, resolveEasingStyle((tostring(p34))), (resolveEasingDirection((tostring(p35)))));
end;

local function handleEventMarker(u36) -- Line: 394
    -- upvalues: getLiveMap (copy), TweenService (copy), resolveEasingStyle (copy), resolveEasingDirection (copy)
    if u36 == "portal_on" or u36 == "portal_off" then
        pcall(function() -- Line: 397
            -- upvalues: getLiveMap (ref), u36 (copy)
            local v37 = getLiveMap() and v37:FindFirstChild("Scriptables") and v37:FindFirstChild("FoeCakesCutscene") and v37:FindFirstChild("PortalCutscene");
            local v38 = v37 and v37:FindFirstChild("Portal") and v37.Portal:FindFirstChild("Main");

            if not v38 then
                return;
            end;

            local v39 = u36 == "portal_on";

            for _, child in v38:GetChildren() do
                if child:IsA("ParticleEmitter") then
                    child.Enabled = v39;
                end;
            end;
        end);

        return;
    end;

    if u36 == "energy_staff" then
        task.spawn(function() -- Line: 411
            -- upvalues: getLiveMap (ref), TweenService (ref), resolveEasingStyle (ref), resolveEasingDirection (ref)
            pcall(function() -- Line: 412
                -- upvalues: getLiveMap (ref), TweenService (ref), resolveEasingStyle (ref), resolveEasingDirection (ref)
                local v40 = getLiveMap() and v40:FindFirstChild("BossRig");

                if not (v40 and v40:IsA("Model")) then
                    v40 = nil;
                end;

                if v40 then
                    v40 = v40:FindFirstChild("StaffHand");
                end;

                if not v40 then
                    return;
                end;

                local Plane = v40:FindFirstChild("Plane");
                local v41 = v40:FindFirstChild("Handle") and v41:FindFirstChild("PointLight");
                local v42;

                if Plane then
                    v42 = Plane:FindFirstChild("EnergyToStaff");
                else
                    v42 = Plane;
                end;

                if v42 then
                    v42:Emit(20);
                end;

                if v41 then
                    v41.Brightness = 0;
                    v41.Enabled = true;
                    TweenService:Create(v41, TweenInfo.new(1.6, resolveEasingStyle((tostring(3))), (resolveEasingDirection((tostring(2))))), {
                        Brightness = 10
                    }):Play();
                end;

                task.wait(1.7);

                if Plane then
                    TweenService:Create(Plane, TweenInfo.new(0.4, resolveEasingStyle((tostring(3))), (resolveEasingDirection((tostring(2))))), {
                        Color = Color3.fromRGB(170, 159, 121)
                    }):Play();
                end;

                if v41 then
                    TweenService:Create(v41, TweenInfo.new(0.5, resolveEasingStyle((tostring(3))), (resolveEasingDirection((tostring(2))))), {
                        Brightness = 0
                    }):Play();
                end;
            end);
        end);

        return;
    end;

    if u36 == "staff_off" then
        pcall(function() -- Line: 444
            -- upvalues: getLiveMap (ref)
            local v43 = getLiveMap() and v43:FindFirstChild("BossRig");

            if not (v43 and v43:IsA("Model")) then
                v43 = nil;
            end;

            if v43 then
                v43 = v43:FindFirstChild("StaffHand");
            end;

            if v43 then
                v43 = v43:FindFirstChild("Plane");
            end;

            if v43 then
                v43.Color = Color3.fromRGB(79, 74, 66);
            end;
        end);

        return;
    end;

    if u36 == "staff_hit" then
        task.spawn(function() -- Line: 453
            -- upvalues: getLiveMap (ref), TweenService (ref), resolveEasingStyle (ref), resolveEasingDirection (ref)
            pcall(function() -- Line: 454
                -- upvalues: getLiveMap (ref), TweenService (ref), resolveEasingStyle (ref), resolveEasingDirection (ref)
                local v44 = getLiveMap() and v44:FindFirstChild("BossRig");

                if not (v44 and v44:IsA("Model")) then
                    v44 = nil;
                end;

                local v45;

                if v44 then
                    v45 = v44:FindFirstChild("StaffHand");
                else
                    v45 = v44;
                end;

                if v44 then
                    v44 = v44:FindFirstChild("StaffNone");
                end;

                if v45 then
                    v45 = v45:FindFirstChild("Plane");
                end;

                if v44 then
                    v44 = v44:FindFirstChild("Plane");
                end;

                if v45 then
                    v45.Transparency = 1;
                end;

                if v44 then
                    v44.Transparency = 0;
                end;

                task.wait(0.5);

                if v44 then
                    TweenService:Create(v44, TweenInfo.new(0.5, resolveEasingStyle((tostring(0))), (resolveEasingDirection((tostring(0))))), {
                        Color = Color3.fromRGB(79, 74, 66)
                    }):Play();
                end;
            end);
        end);
    end;
end;

local function handleFovMarker(p46) -- Line: 475
    -- upvalues: u4 (ref), resolveEasingStyle (copy), resolveEasingDirection (copy), TweenService (copy)
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local v47 = string.split(p46, ",");
    local v48 = tonumber(v47[1]);

    if not v48 then
        return;
    end;

    if u4 then
        u4:Cancel();
        u4:Destroy();
        u4 = nil;
    end;

    local v49 = tonumber(v47[2]) or 0;

    if v49 <= 0 then
        CurrentCamera.FieldOfView = v48;

        return;
    end;

    local v50 = resolveEasingStyle(v47[3]);
    local v51 = resolveEasingDirection(v47[4]);
    local u52 = TweenService:Create(CurrentCamera, TweenInfo.new(v49, v50, v51), {
        FieldOfView = v48
    });
    u4 = u52;
    u52:Play();
    u52.Completed:Once(function() -- Line: 497
        -- upvalues: u4 (ref), u52 (copy)
        if u4 == u52 then
            u4 = nil;
        end;

        u52:Destroy();
    end);
end;

local function ensureAnimator(p53) -- Line: 505
    local v54 = p53:FindFirstChildOfClass("Humanoid");

    if v54 then
        local v55 = v54:FindFirstChildOfClass("Animator");

        if v55 then
            return v55;
        end;

        local Animator = Instance.new("Animator");
        Animator.Parent = v54;

        return Animator;
    end;

    local v56 = p53:FindFirstChildOfClass("AnimationController");

    if v56 then
        local v57 = v56:FindFirstChildOfClass("Animator");

        if v57 then
            return v57;
        end;

        local Animator = Instance.new("Animator");
        Animator.Parent = v56;

        return Animator;
    end;

    local AnimationController = Instance.new("AnimationController");
    AnimationController.Parent = p53;
    local Animator = Instance.new("Animator");
    Animator.Parent = AnimationController;

    return Animator;
end;

local function loadOnRig(p58, p59) -- Line: 530
    -- upvalues: ensureAnimator (copy)
    local v60 = ensureAnimator(p58);

    if not v60 then
        warn("[FoeCakesCutscenes] No Animator/AnimationController found on " .. p58.Name);

        return nil;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = p59;
    local v61 = v60:LoadAnimation(Animation);
    v61.Looped = false;
    v61.Priority = Enum.AnimationPriority.Action4;

    return v61;
end;

local function connectMarkers(p62) -- Line: 544
    -- upvalues: playMarkerSound (copy), handleEventMarker (copy), handleFovMarker (copy), u2 (ref)
    local u64 = p62:GetMarkerReachedSignal("Sound"):Connect(function(p63) -- Line: 545
        -- upvalues: playMarkerSound (ref)
        playMarkerSound((tostring(p63)));
    end);
    local u66 = p62:GetMarkerReachedSignal("Event"):Connect(function(p65) -- Line: 548
        -- upvalues: handleEventMarker (ref)
        handleEventMarker((tostring(p65)));
    end);
    local u68 = p62:GetMarkerReachedSignal("fov"):Connect(function(p67) -- Line: 551
        -- upvalues: handleFovMarker (ref)
        handleFovMarker((tostring(p67)));
    end);
    table.insert(u2.cleanups, function() -- Line: 554
        -- upvalues: u64 (copy)
        u64:Disconnect();
    end);
    table.insert(u2.cleanups, function() -- Line: 555
        -- upvalues: u66 (copy)
        u66:Disconnect();
    end);
    table.insert(u2.cleanups, function() -- Line: 556
        -- upvalues: u68 (copy)
        u68:Disconnect();
    end);
end;

local function createBlackScreen() -- Line: 561
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "FoeCakesCutsceneBlack";
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

local function fadeBlackScreen(p69, p70) -- Line: 581
    -- upvalues: TweenService (copy)
    local Black = p69:FindFirstChild("Black");

    if not Black then
        return;
    end;

    local v71 = TweenService:Create(Black, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
        BackgroundTransparency = p70
    });
    v71:Play();
    v71.Completed:Wait();
    v71:Destroy();
end;

local function showFakeAnnouncement(p72) -- Line: 596
    -- upvalues: LocalPlayer (copy), ReplicatedStorage (copy), Players (copy), TweenService (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local NotificationFrame = ReplicatedStorage:FindFirstChild("NotificationFrame");

    if not NotificationFrame then
        warn("[FoeCakesCutscenes] showFakeAnnouncement: NotificationFrame template missing");

        return;
    end;

    local u73 = NotificationFrame:Clone();
    local Avatar = u73:FindFirstChild("Avatar");

    if Avatar and Avatar:IsA("ImageLabel") then
        local success, result = pcall(function() -- Line: 615
            -- upvalues: Players (ref)
            return Players:GetUserThumbnailAsync(156, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100);
        end);

        if success and result then
            Avatar.Image = result;
        end;

        Avatar.ImageColor3 = Color3.new(0, 0, 0);
    end;

    local Text = u73:FindFirstChild("Text");

    if Text and Text:IsA("TextLabel") then
        Text.RichText = true;
        Text.Text = "<font color=\"rgb(225,20,255)\"><b>???</b></font> : " .. p72;
    end;

    local u74 = {};
    local u75 = {};

    for _, descendant in u73:GetDescendants() do
        if descendant:IsA("UIStroke") then
            table.insert(u74, {
                prop = "Transparency",
                obj = descendant
            });
        elseif descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            table.insert(u74, {
                prop = "TextTransparency",
                obj = descendant
            });

            if descendant.BackgroundTransparency < 1 then
                table.insert(u74, {
                    prop = "BackgroundTransparency",
                    obj = descendant
                });
            end;
        elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
            table.insert(u74, {
                prop = "ImageTransparency",
                obj = descendant
            });

            if descendant.BackgroundTransparency < 1 then
                table.insert(u74, {
                    prop = "BackgroundTransparency",
                    obj = descendant
                });
            end;
        elseif descendant:IsA("Frame") and descendant.BackgroundTransparency < 1 then
            table.insert(u74, {
                prop = "BackgroundTransparency",
                obj = descendant
            });
        end;

        if descendant:IsA("UIGradient") then
            table.insert(u75, {
                obj = descendant,
                original = descendant.Transparency
            });
        end;
    end;

    if u73:IsA("Frame") and u73.BackgroundTransparency < 1 then
        table.insert(u74, {
            prop = "BackgroundTransparency",
            obj = u73
        });
    end;

    local v76 = {};

    for i, v in ipairs(u74) do
        v76[i] = v.obj[v.prop];
        v.obj[v.prop] = 1;
    end;

    local u77 = NumberSequence.new(1);

    for _, v in ipairs(u75) do
        v.obj.Transparency = u77;
    end;

    local v78 = PlayerGui:FindFirstChild("AdminAnnounce") and v78:FindFirstChild("MainFrame");
    local u79 = nil;

    if v78 then
        u73.Parent = v78;
    else
        u79 = Instance.new("ScreenGui");
        u79.Name = "FakeAnnounceFoeCakes";
        u79.IgnoreGuiInset = true;
        u79.DisplayOrder = 110;
        u79.Parent = PlayerGui;
        u73.Parent = u79;
    end;

    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://98797174600699";
    Sound.Volume = 0.4;
    Sound.Parent = LocalPlayer;
    Sound:Play();
    task.delay(5, function() -- Line: 685
        -- upvalues: Sound (copy)
        if Sound and Sound.Parent then
            Sound:Destroy();
        end;
    end);
    local v80 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

    for i, v in ipairs(u74) do
        TweenService:Create(v.obj, v80, {
            [v.prop] = v76[i]
        }):Play();
    end;

    for _, v in ipairs(u75) do
        v.obj.Transparency = v.original;
    end;

    task.delay(3.5, function() -- Line: 695
        -- upvalues: u74 (copy), TweenService (ref), u75 (copy), u77 (copy), u73 (copy), u79 (ref)
        local v81 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

        for _, v in ipairs(u74) do
            TweenService:Create(v.obj, v81, {
                [v.prop] = 1
            }):Play();
        end;

        for _, v in ipairs(u75) do
            v.obj.Transparency = u77;
        end;

        task.delay(0.5, function() -- Line: 703
            -- upvalues: u73 (ref), u79 (ref)
            if u73 and u73.Parent then
                u73:Destroy();
            end;

            if u79 and u79.Parent then
                u79:Destroy();
            end;
        end);
    end);
end;

local function showCredits() -- Line: 710
    -- upvalues: LocalPlayer (copy), TweenService (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "FoeCakesCredits";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.DisplayOrder = 100;
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
    TextLabel.Text = "Host - Secret_Lokii & LuckyMatg\nProducer - Chichine\nScripter - FoeCakes\nCutscenes - Kenami\nBuilder - Nextune_Dev\nMusic - X3LL3N\n";
    TextLabel.TextTransparency = 1;
    TextLabel.Parent = Frame;
    TweenService:Create(TextLabel, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play();
    task.wait(6.5);
    local v82 = TweenService:Create(TextLabel, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    });
    v82:Play();
    v82.Completed:Once(function() -- Line: 755
        -- upvalues: ScreenGui (copy)
        ScreenGui:Destroy();
    end);
end;

local function teardown() -- Line: 760
    -- upvalues: u2 (ref), LocalPlayer (copy), restoreAllRealPlayers (copy), rehideCutsceneRig (copy), getLiveMap (copy), u4 (ref)
    for _, v in u2.tracks do
        pcall(function() -- Line: 762
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
    local v83 = LocalPlayer and LocalPlayer.Character and v83:FindFirstChildOfClass("Humanoid");

    if v83 then
        if u2.cachedWalkSpeed then
            v83.WalkSpeed = u2.cachedWalkSpeed;
        end;

        if u2.cachedJumpPower then
            v83.JumpPower = u2.cachedJumpPower;
        end;

        if u2.cachedJumpHeight then
            v83.JumpHeight = u2.cachedJumpHeight;
        end;
    end;

    u2.cachedWalkSpeed = nil;
    u2.cachedJumpPower = nil;
    u2.cachedJumpHeight = nil;
    restoreAllRealPlayers();
    rehideCutsceneRig();
    local u84 = getLiveMap() and u84:FindFirstChild("BossRig");

    if not (u84 and u84:IsA("Model")) then
        u84 = nil;
    end;

    local cachedBossCFrame = u2.cachedBossCFrame;

    if u84 and cachedBossCFrame then
        pcall(function() -- Line: 310
            -- upvalues: u84 (copy), cachedBossCFrame (copy)
            u84:PivotTo(cachedBossCFrame);
        end);
    end;

    u2.cachedBossCFrame = nil;

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

local function playTracks(p85) -- Line: 788
    -- upvalues: loadOnRig (copy), connectMarkers (copy), u2 (ref)
    local v86 = 0;

    for _, v in p85 do
        local v87 = loadOnRig(v.rig, v.id);

        if v87 then
            connectMarkers(v87);
            table.insert(u2.tracks, v87);
            v87:Play(0);

            if v86 < v87.Length then
                v86 = v87.Length;
            end;
        end;
    end;

    return v86;
end;

function u1.playOpening(p88) -- Line: 804
    -- upvalues: u1 (copy), u3 (ref), u2 (ref), newState (copy), getLiveMap (copy), hideTaggedUI (copy), hideBossBar (copy), LocalPlayer (copy), bindCameraToRig (copy), playTracks (copy), FoeCakesBossAnimIds (copy), createBlackScreen (copy), fadeBlackScreen (copy), teardown (copy)
    u1.stopAll();
    u3 = u3 + 1;
    local v89 = u3;
    u2 = newState();
    u2.active = true;
    local v90 = getLiveMap() and v90:FindFirstChild("BossRig");

    if not (v90 and v90:IsA("Model")) then
        v90 = nil;
    end;

    local v91 = getLiveMap() and v91:FindFirstChild("Scriptables") and v91:FindFirstChild("FoeCakesCutscene") and v91:FindFirstChild("CameraRig");

    if not (v91 and v91:IsA("Model")) then
        v91 = nil;
    end;

    if not (v90 and v91) then
        warn("[FoeCakesCutscenes] Opening: missing BossRig or CameraRig — bailing");
        u2.active = false;

        return;
    end;

    hideTaggedUI();
    hideBossBar();
    local v92 = LocalPlayer and LocalPlayer.Character and v92:FindFirstChildOfClass("Humanoid");

    if v92 then
        u2.cachedWalkSpeed = v92.WalkSpeed;
        u2.cachedJumpPower = v92.JumpPower;
        u2.cachedJumpHeight = v92.JumpHeight;
        v92.WalkSpeed = 0;
        v92.JumpPower = 0;
        v92.JumpHeight = 0;
    end;

    local v93 = getLiveMap() and v93:FindFirstChild("BossRig");

    if not (v93 and v93:IsA("Model")) then
        v93 = nil;
    end;

    if v93 then
        v93 = v93:FindFirstChild("HumanoidRootPart");
    end;

    if v93 then
        u2.cachedBossCFrame = v93.CFrame;
    end;

    local cleanups = u2.cleanups;
    local v94 = bindCameraToRig(v91);
    table.insert(cleanups, v94);
    local v95 = playTracks({
        {
            rig = v90,
            id = FoeCakesBossAnimIds.Cutscenes.Opening.BossRig
        },
        {
            rig = v91,
            id = FoeCakesBossAnimIds.Cutscenes.Opening.CameraRig
        }
    });

    if v95 <= 0 then
        v95 = FoeCakesBossAnimIds.CutsceneDurations.Opening;
    end;

    task.wait(v95);

    if v89 ~= u3 or not u2.active then
        return;
    end;

    task.wait(4.75);

    if v89 ~= u3 or not u2.active then
        return;
    end;

    local u96 = createBlackScreen();
    fadeBlackScreen(u96, 0);

    if u2.active then
        teardown();
    end;

    fadeBlackScreen(u96, 1);
    pcall(function() -- Line: 840
        -- upvalues: u96 (copy)
        u96:Destroy();
    end);
end;

function u1.playEnding(p97, p98) -- Line: 845
    -- upvalues: u1 (copy), u3 (ref), u2 (ref), newState (copy), getLiveMap (copy), hideTaggedUI (copy), hideBossBar (copy), LocalPlayer (copy), hideAllRealPlayers (copy), ContentProvider (copy), FoeCakesBossRoom (copy), Players (copy), bindCameraToRig (copy), FoeCakesBossAnimIds (copy), playTracks (copy), fadeBlackScreen (copy), createBlackScreen (copy), RunService (copy), ensureAnimator (copy), showFakeAnnouncement (copy), TweenService (copy), teardown (copy), showCredits (copy)
    u1.stopAll();
    u3 = u3 + 1;
    local v99 = u3;
    u2 = newState();
    u2.active = true;
    local v100 = getLiveMap() and v100:FindFirstChild("BossRig");

    if not (v100 and v100:IsA("Model")) then
        v100 = nil;
    end;

    local v101 = getLiveMap();
    local v102 = v101 and v101:FindFirstChild("Scriptables") and v102:FindFirstChild("FoeCakesCutscene") and v102:FindFirstChild("CameraRig");

    if not (v102 and v102:IsA("Model")) then
        v102 = nil;
    end;

    if not (v100 and v102) then
        warn("[FoeCakesCutscenes] Ending: missing BossRig or CameraRig — bailing");
        u2.active = false;

        return;
    end;

    hideTaggedUI();
    hideBossBar();
    local v103 = LocalPlayer and LocalPlayer.Character and v103:FindFirstChildOfClass("Humanoid");

    if v103 then
        u2.cachedWalkSpeed = v103.WalkSpeed;
        u2.cachedJumpPower = v103.JumpPower;
        u2.cachedJumpHeight = v103.JumpHeight;
        v103.WalkSpeed = 0;
        v103.JumpPower = 0;
        v103.JumpHeight = 0;
    end;

    local v104 = getLiveMap();
    local v105 = v104 and v104:FindFirstChild("BossRig");

    if not (v105 and v105:IsA("Model")) then
        v105 = nil;
    end;

    if v105 then
        v105 = v105:FindFirstChild("HumanoidRootPart");
    end;

    if v105 then
        u2.cachedBossCFrame = v105.CFrame;
    end;

    hideAllRealPlayers();
    task.spawn(function() -- Line: 865
        -- upvalues: ContentProvider (ref)
        ContentProvider:PreloadAsync({ "rbxassetid://70635271190744" });
    end);
    local v106 = getLiveMap();
    local v107 = v106 and v106:FindFirstChild("Scriptables") and v107:FindFirstChild("FoeCakesCutscene") and v107:FindFirstChild("PlayerRigAnchor");

    if not (v107 and v107:IsA("BasePart")) then
        v107 = nil;
    end;

    local Assets = FoeCakesBossRoom:FindFirstChild("Assets");
    local v108 = Assets and Assets:FindFirstChild("PlayerRig");

    if not (v108 and v108:IsA("Model")) then
        v108 = nil;
    end;

    local u109 = nil;

    if v108 then
        local v110;

        if v107 then
            v110 = v107.CFrame;
        else
            v110 = CFrame.identity;
        end;

        u109 = v108:Clone();
        u109.Parent = workspace;
        u109:PivotTo(v110);
        local v111 = LocalPlayer and (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()) and v111:FindFirstChildOfClass("Humanoid");
        local u112 = u109:FindFirstChildOfClass("Humanoid");

        if v111 and u112 then
            local success, result = pcall(function() -- Line: 882
                -- upvalues: Players (ref), LocalPlayer (ref)
                return Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId);
            end);

            if success and result then
                local success2, result2 = pcall(function() -- Line: 886
                    -- upvalues: u112 (copy), result (copy)
                    u112:ApplyDescriptionAsync(result);
                end);

                if not success2 then
                    warn("[FoeCakesCutscenes] ApplyDescriptionAsync failed: " .. tostring(result2));
                end;
            else
                warn("[FoeCakesCutscenes] GetHumanoidDescriptionFromUserId failed");
            end;
        end;

        for _, descendant in u109:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false;
                descendant.CanTouch = false;
                descendant.CanQuery = false;
                descendant.CollisionGroup = "FoeCakesBossRig";
            end;
        end;

        table.insert(u2.cleanups, function() -- Line: 907
            -- upvalues: u109 (ref)
            if u109 and u109.Parent then
                u109:Destroy();
            end;
        end);
    else
        warn("[FoeCakesCutscenes] Ending: PlayerRig template missing from Assets — player rig skipped");
    end;

    local cleanups = u2.cleanups;
    local v113 = bindCameraToRig(v102);
    table.insert(cleanups, v113);
    local v114 = {
        {
            rig = v100,
            id = FoeCakesBossAnimIds.Cutscenes.Ending.BossRig
        },
        {
            rig = v102,
            id = FoeCakesBossAnimIds.Cutscenes.Ending.CameraRig
        }
    };

    if u109 then
        table.insert(v114, {
            rig = u109,
            id = FoeCakesBossAnimIds.Cutscenes.Ending.PlayerRig
        });
    end;

    local v115 = playTracks(v114);

    if v115 <= 0 then
        v115 = FoeCakesBossAnimIds.CutsceneDurations.Ending;
    end;

    local u116 = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") and u116:FindFirstChild("FoeCakesCutsceneBlack");

    if u116 and u116:IsA("ScreenGui") then
        fadeBlackScreen(u116, 1);
        pcall(function() -- Line: 933
            -- upvalues: u116 (copy)
            u116:Destroy();
        end);
    end;

    task.wait(v115);

    if v99 ~= u3 or not u2.active then
        return;
    end;

    task.wait(4.75);

    if v99 ~= u3 or not u2.active then
        return;
    end;

    local u117 = createBlackScreen();
    fadeBlackScreen(u117, 0);
    local u118 = nil;
    local v119 = getLiveMap() and v119:FindFirstChild("Scriptables") and v119:FindFirstChild("PostEndCutscene");
    local v120;

    if v119 then
        v120 = v119:FindFirstChild("Cameras");
    else
        v120 = v119;
    end;

    local v121;

    if v120 then
        v121 = v120:FindFirstChild("1");
    else
        v121 = v120;
    end;

    if v120 then
        v120 = v120:FindFirstChild("2");
    end;

    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera and v121 then
        RunService:UnbindFromRenderStep("FoeCakesCutsceneLock");
        CurrentCamera.CameraType = Enum.CameraType.Scriptable;
        CurrentCamera.CFrame = v121.CFrame;
        local ScreenGui = Instance.new("ScreenGui");
        ScreenGui.Name = "FoeCakesEndImage";
        ScreenGui.IgnoreGuiInset = true;
        ScreenGui.ResetOnSpawn = false;
        ScreenGui.DisplayOrder = 200;
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui");
        u118 = ScreenGui;
        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Size = UDim2.fromScale(0.5, 0.5);
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
        ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
        ImageLabel.BackgroundTransparency = 1;
        ImageLabel.Image = "rbxassetid://70635271190744";
        ImageLabel.ImageTransparency = 1;
        ImageLabel.ScaleType = Enum.ScaleType.Fit;
        ImageLabel.Parent = ScreenGui;
        local v122 = nil;
        local v123;

        if v119 then
            v123 = v119:FindFirstChild("ChichineRig");
        else
            v123 = v119;
        end;

        if v123 and v123:IsA("Model") then
            local v124 = ensureAnimator(v123);

            if v124 then
                local Animation = Instance.new("Animation");
                Animation.AnimationId = "rbxassetid://81644450019918";
                v122 = v124:LoadAnimation(Animation);
                v122.Looped = true;
                v122.Priority = Enum.AnimationPriority.Action;
                v122:Play(0.3);
            end;
        end;

        fadeBlackScreen(u117, 1);
        task.wait(1);
        showFakeAnnouncement("Just as planned.");

        if v120 and (v99 == u3 and u2.active) then
            local v125 = TweenService:Create(CurrentCamera, TweenInfo.new(6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                CFrame = v120.CFrame
            });
            v125:Play();
            v125.Completed:Wait();
            v125:Destroy();
        end;

        if v99 == u3 and u2.active then
            showFakeAnnouncement("Let\'s see what those brothers got in store..");

            if v119 then
                v119 = v119:FindFirstChild("SanoRig");
            end;

            if v119 then
                local CatHandle = v119:FindFirstChild("CatHandle", true);

                if CatHandle and CatHandle:IsA("BasePart") then
                    local Sound = Instance.new("Sound");
                    Sound.SoundId = "rbxassetid://114631512807844";
                    Sound.Parent = workspace;
                    task.wait(1);
                    Sound:Play();
                    Sound.Ended:Once(function() -- Line: 1027
                        -- upvalues: Sound (copy)
                        Sound:Destroy();
                    end);
                    TweenService:Create(CatHandle, TweenInfo.new(2), {
                        CFrame = CatHandle.CFrame * CFrame.Angles(0, 3.141592653589793, 0)
                    }):Play();
                end;
            end;

            task.wait(5);
        end;

        TweenService:Create(ImageLabel, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
            ImageTransparency = 0
        }):Play();
        fadeBlackScreen(u117, 0);

        if v122 then
            v122:Stop(0);
        end;
    else
        warn("[FoeCakesCutscenes] PostEndCutscene.Cameras.1 missing — skipping post-ending");
    end;

    task.wait(3);
    pcall(function() -- Line: 1055
        -- upvalues: u118 (ref)
        if u118 then
            u118:Destroy();
        end;
    end);

    if u2.active then
        teardown();
    end;

    if p98 then
        pcall(p98);
    end;

    task.spawn(showCredits);
    fadeBlackScreen(u117, 1);
    pcall(function() -- Line: 1061
        -- upvalues: u117 (copy)
        u117:Destroy();
    end);
end;

function u1.stopAll() -- Line: 1066
    -- upvalues: u3 (ref), u2 (ref), teardown (copy)
    u3 = u3 + 1;

    if u2.active then
        teardown();
    end;
end;

return u1;