-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.IndependenceDay.IndependenceDayCutscenes
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local IndependenceDayConfig = require(script.Parent.IndependenceDayConfig);
local u1, u2;

if RunService:IsClient() then
    u1 = Players.LocalPlayer;
    u2 = u1.PlayerGui;
else
    u2 = nil;
    u1 = nil;
end;

local CurrentCamera = workspace.CurrentCamera;
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "IndependenceDayCutsceneFade";
ScreenGui.IgnoreGuiInset = true;
ScreenGui.ResetOnSpawn = false;
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
ScreenGui.DisplayOrder = 999999;
ScreenGui.Parent = u2;
local Frame = Instance.new("Frame");
Frame.Size = UDim2.fromScale(1, 1);
Frame.BackgroundColor3 = Color3.new(0, 0, 0);
Frame.BackgroundTransparency = 1;
Frame.BorderSizePixel = 0;
Frame.ZIndex = 999999;
Frame.Parent = ScreenGui;
local u3 = nil;

local function fade(p4, p5) -- Line: 46
    -- upvalues: u3 (ref), TweenService (copy), Frame (copy)
    if u3 then
        u3:Cancel();
    end;

    local v6 = TweenService:Create(Frame, TweenInfo.new(p4, Enum.EasingStyle.Linear), {
        BackgroundTransparency = p5
    });
    u3 = v6;
    v6:Play();

    return v6;
end;

local function getLiveMap() -- Line: 60
    local v7 = workspace.AdminAbuse.Map:GetChildren()[1];

    if v7 and v7:IsA("Model") then
        return v7;
    end;

    return nil;
end;

local function showRig(p8) -- Line: 73
    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant.Name ~= "HumanoidRootPart" and descendant.Name ~= "RootPart" then
                descendant.Transparency = 0;
            end;
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            descendant.Transparency = 0;
        end;
    end;
end;

local function hideRig(p9) -- Line: 84
    for _, descendant in p9:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 1;
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            descendant.Transparency = 1;
        end;
    end;
end;

local u10 = 16;
local u11 = 7.2;

local function freezePlayer() -- Line: 99
    -- upvalues: u1 (ref), u10 (ref), u11 (ref)
    local v12 = u1.Character and v12:FindFirstChildOfClass("Humanoid");

    if not v12 then
        return;
    end;

    u10 = v12.WalkSpeed;
    u11 = v12.JumpHeight;
    v12.WalkSpeed = 0;
    v12.JumpHeight = 0;
end;

local function unfreezePlayer() -- Line: 109
    -- upvalues: u1 (ref), u10 (ref), u11 (ref)
    local v13 = u1.Character and v13:FindFirstChildOfClass("Humanoid");

    if not v13 then
        return;
    end;

    v13.WalkSpeed = u10;
    v13.JumpHeight = u11;
end;

local u14 = {
    IndependenceDayCutsceneFade = true
};
local u15 = {};

local function disableOtherGuis() -- Line: 125
    -- upvalues: u1 (ref), u15 (copy), u14 (copy)
    local v16 = u1:FindFirstChildOfClass("PlayerGui");

    if not v16 then
        return;
    end;

    table.clear(u15);

    for _, child in v16:GetChildren() do
        if child.Name ~= "AdminAnnounce" and (child:IsA("ScreenGui") and not u14[child.Name]) then
            u15[child] = child.Enabled;
            child.Enabled = false;
        end;
    end;
end;

local function restoreOtherGuis() -- Line: 138
    -- upvalues: u1 (ref), u14 (copy), u15 (copy)
    local v17 = u1:FindFirstChildOfClass("PlayerGui");

    if not v17 then
        return;
    end;

    for _, child in v17:GetChildren() do
        if child:IsA("ScreenGui") and not u14[child.Name] then
            local v18 = u15[child];

            if v18 ~= nil then
                child.Enabled = v18;
            end;
        end;
    end;

    table.clear(u15);
end;

local u19 = false;

local function bindCamera(p20) -- Line: 156
    -- upvalues: CurrentCamera (copy), IndependenceDayConfig (copy), RunService (copy), u19 (ref)
    local u21 = p20:FindFirstChild("CameraTarget", true) or (p20:FindFirstChild("Torso") or p20:FindFirstChildWhichIsA("BasePart"));

    if not u21 then
        warn("[IndependenceDayCutscenes] bindCamera: no trackable part in", p20:GetFullName());

        return;
    end;

    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    CurrentCamera.FieldOfView = IndependenceDayConfig.CAMERA_FOV;

    local function getCF() -- Line: 170
        -- upvalues: u21 (copy)
        if u21:IsA("Attachment") then
            return u21.WorldCFrame;
        end;

        return u21.CFrame;
    end;

    local v22;

    if u21:IsA("Attachment") then
        v22 = u21.WorldCFrame;
    else
        v22 = u21.CFrame;
    end;

    CurrentCamera.CFrame = v22;
    RunService:BindToRenderStep("IndependenceDayCutsceneCamera", Enum.RenderPriority.Camera.Value, function() -- Line: 176
        -- upvalues: CurrentCamera (ref), u21 (copy)
        local v23;

        if u21:IsA("Attachment") then
            v23 = u21.WorldCFrame;
        else
            v23 = u21.CFrame;
        end;

        CurrentCamera.CFrame = v23;
    end);
    u19 = true;
end;

local function unbindCamera() -- Line: 182
    -- upvalues: u19 (ref), RunService (copy)
    if u19 then
        RunService:UnbindFromRenderStep("IndependenceDayCutsceneCamera");
        u19 = false;
    end;
end;

local u24 = false;
local u25 = {};
local u26 = nil;
local BindableEvent = Instance.new("BindableEvent");
local u27 = false;

local function waitForCleanupDone(p28) -- Line: 204
    -- upvalues: u27 (ref), BindableEvent (copy)
    if u27 then
        return;
    end;

    local u29 = false;
    local v30 = BindableEvent.Event:Once(function() -- Line: 207
        -- upvalues: u29 (ref)
        u29 = true;
    end);
    local v31 = os.clock();

    while not u29 and os.clock() - v31 < p28 do
        task.wait(0.1);
    end;

    v30:Disconnect();
end;

local function getAnimator(p32) -- Line: 215
    local v33 = p32:FindFirstChildOfClass("Humanoid") or p32:FindFirstChildOfClass("AnimationController");

    if not v33 then
        return nil;
    end;

    local v34 = v33:FindFirstChildOfClass("Animator");

    if not v34 then
        v34 = Instance.new("Animator");
        v34.Parent = v33;
    end;

    return v34;
end;

local function loadTrack(p35, p36) -- Line: 227
    local v37 = p35:FindFirstChildOfClass("Humanoid") or p35:FindFirstChildOfClass("AnimationController");
    local u38;

    if v37 then
        u38 = v37:FindFirstChildOfClass("Animator");

        if not u38 then
            u38 = Instance.new("Animator");
            u38.Parent = v37;
        end;
    else
        u38 = nil;
    end;

    if not u38 then
        warn("[IndependenceDayCutscenes] No Humanoid/AnimationController found on", p35:GetFullName());

        return nil;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = p36;
    local success, result = pcall(function() -- Line: 235
        -- upvalues: u38 (copy), Animation (copy)
        return u38:LoadAnimation(Animation);
    end);
    Animation:Destroy();

    if success then
        result.Looped = false;

        return result;
    end;

    warn("[IndependenceDayCutscenes] LoadAnimation failed:", result);

    return nil;
end;

local function teardownInternal() -- Line: 246
    -- upvalues: u19 (ref), RunService (copy), u26 (ref), u25 (copy)
    if u19 then
        RunService:UnbindFromRenderStep("IndependenceDayCutsceneCamera");
        u19 = false;
    end;

    if u26 then
        u26:Disconnect();
        u26 = nil;
    end;

    for _, v in u25 do
        if v.IsPlaying then
            v:Stop(0);
        end;
    end;

    table.clear(u25);
end;

local u42 = {
    isActive = function() -- Line: 261, Name: isActive
        -- upvalues: u24 (ref)
        return u24;
    end,

    stop = function() -- Line: 265, Name: stop
        -- upvalues: u24 (ref), teardownInternal (copy), CurrentCamera (copy), IndependenceDayConfig (copy), u1 (ref), u10 (ref), u11 (ref), restoreOtherGuis (copy), Frame (copy), u2 (ref)
        if not u24 then
            return;
        end;

        teardownInternal();
        CurrentCamera.CameraType = Enum.CameraType.Custom;
        CurrentCamera.FieldOfView = IndependenceDayConfig.DEFAULT_FOV;
        local v39 = u1.Character and v39:FindFirstChildOfClass("Humanoid");

        if v39 then
            v39.WalkSpeed = u10;
            v39.JumpHeight = u11;
        end;

        restoreOtherGuis();
        Frame.BackgroundTransparency = 1;
        u24 = false;
        local v40 = u2 and u2:FindFirstChild("IndependenceDayCredits");

        if v40 then
            v40:Destroy();
        end;
    end,

    showCredits = function() -- Line: 279, Name: showCredits
        -- upvalues: u2 (ref), TweenService (copy), IndependenceDayConfig (copy)
        if not u2 then
            return;
        end;

        local ScreenGui2 = Instance.new("ScreenGui");
        ScreenGui2.Name = "IndependenceDayCredits";
        ScreenGui2.IgnoreGuiInset = true;
        ScreenGui2.DisplayOrder = 1000000;
        ScreenGui2.Parent = u2;
        local Frame2 = Instance.new("Frame");
        Frame2.Size = UDim2.fromScale(1, 1);
        Frame2.BackgroundTransparency = 1;
        Frame2.Parent = ScreenGui2;
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Size = UDim2.fromScale(0.8, 0.4);
        TextLabel.Position = UDim2.fromScale(0.5, 0.5);
        TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.Font = Enum.Font.GothamBold;
        TextLabel.TextColor3 = Color3.new(1, 1, 1);
        TextLabel.TextScaled = true;
        TextLabel.Text = "Host - Secret_Lokii & LuckyMatg\nProducer - Chichine & FoeCakes\nScripter - FoeCakes\nAnimator - EternityReality\nBuilder - Nextune_Dev\nMusic - X3ll3n\n";
        TextLabel.TextTransparency = 1;
        TextLabel.Parent = Frame2;
        local UIStroke = Instance.new("UIStroke");
        UIStroke.Color = Color3.new();
        UIStroke.Parent = TextLabel;
        TweenService:Create(TextLabel, TweenInfo.new(IndependenceDayConfig.CREDITS_FADE_SEC, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0
        }):Play();
        task.wait(IndependenceDayConfig.CREDITS_DURATION + IndependenceDayConfig.CREDITS_FADE_SEC);
        local u41 = TweenService:Create(TextLabel, TweenInfo.new(IndependenceDayConfig.CREDITS_FADE_SEC, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            TextTransparency = 1
        });
        u41:Play();
        u41.Completed:Once(function() -- Line: 327
            -- upvalues: ScreenGui2 (copy), u41 (copy)
            ScreenGui2:Destroy();
            u41:Destroy();
        end);
    end
};

local function finishCutscene(u43) -- Line: 330
    -- upvalues: fade (copy), IndependenceDayConfig (copy), teardownInternal (copy), hideRig (copy), CurrentCamera (copy), u1 (ref), u10 (ref), u11 (ref), restoreOtherGuis (copy), Frame (copy), u24 (ref)
    fade(IndependenceDayConfig.FADE_DURATION, 0).Completed:Connect(function() -- Line: 332
        -- upvalues: teardownInternal (ref), u43 (copy), hideRig (ref), CurrentCamera (ref), IndependenceDayConfig (ref), u1 (ref), u10 (ref), u11 (ref), restoreOtherGuis (ref), fade (ref), Frame (ref), u24 (ref)
        teardownInternal();

        for _, v in u43 do
            pcall(function() -- Line: 335
                -- upvalues: hideRig (ref), v (copy)
                hideRig(v);
            end);
        end;

        CurrentCamera.CameraType = Enum.CameraType.Custom;
        CurrentCamera.FieldOfView = IndependenceDayConfig.DEFAULT_FOV;
        local v44 = u1.Character and v44:FindFirstChildOfClass("Humanoid");

        if v44 then
            v44.WalkSpeed = u10;
            v44.JumpHeight = u11;
        end;

        restoreOtherGuis();
        fade(IndependenceDayConfig.FADE_DURATION, 1).Completed:Connect(function() -- Line: 343
            -- upvalues: Frame (ref), u24 (ref)
            Frame.BackgroundTransparency = 1;
            u24 = false;
        end);
    end);
end;

function u42.playOpening(p45) -- Line: 350
    -- upvalues: u24 (ref), teardownInternal (copy), showRig (copy), u1 (ref), u10 (ref), u11 (ref), disableOtherGuis (copy), bindCamera (copy), loadTrack (copy), IndependenceDayConfig (copy), u25 (copy), fade (copy), hideRig (copy), CurrentCamera (copy), restoreOtherGuis (copy), Frame (copy), TweenService (copy)
    if u24 then
        return;
    end;

    teardownInternal();
    u24 = true;
    local v46 = workspace.AdminAbuse.Map:GetChildren()[1];

    if not (v46 and v46:IsA("Model")) then
        v46 = nil;
    end;

    if v46 then
        v46 = v46:FindFirstChild("Scriptables");
    end;

    if v46 then
        v46 = v46:FindFirstChild("CutsceneRigs");
    end;

    if not v46 then
        warn("[IndependenceDayCutscenes] CutsceneRigs not found under live map");
        u24 = false;

        return;
    end;

    local HumanoidCameraRig = v46:FindFirstChild("HumanoidCameraRig");
    local Jets = v46:FindFirstChild("Jets");

    if not (HumanoidCameraRig and Jets) then
        warn("[IndependenceDayCutscenes] Opening: missing HumanoidCameraRig or Jets");
        u24 = false;

        return;
    end;

    showRig(HumanoidCameraRig);
    showRig(Jets);
    local v47 = u1.Character and v47:FindFirstChildOfClass("Humanoid");

    if v47 then
        u10 = v47.WalkSpeed;
        u11 = v47.JumpHeight;
        v47.WalkSpeed = 0;
        v47.JumpHeight = 0;
    end;

    disableOtherGuis();
    bindCamera(HumanoidCameraRig);
    local v48;

    if HumanoidCameraRig:IsA("Model") then
        v48 = loadTrack(HumanoidCameraRig, IndependenceDayConfig.ANIM_IDS.Opening.HumanoidCameraRig) or nil;
    else
        v48 = nil;
    end;

    local v49;

    if Jets:IsA("Model") then
        v49 = loadTrack(Jets, IndependenceDayConfig.ANIM_IDS.Opening.Jets) or nil;
    else
        v49 = nil;
    end;

    local u50 = { HumanoidCameraRig, Jets };

    if v49 then
        v49:Play(0, 1, 1);
        table.insert(u25, v49);
    end;

    if v48 then
        v48:Play(0, 1, 1);
        table.insert(u25, v48);
        task.delay(v48.Length - 0.5, function() -- Line: 396
            -- upvalues: u50 (copy), fade (ref), IndependenceDayConfig (ref), teardownInternal (ref), hideRig (ref), CurrentCamera (ref), u1 (ref), u10 (ref), u11 (ref), restoreOtherGuis (ref), Frame (ref), u24 (ref)
            local u51 = u50;
            fade(IndependenceDayConfig.FADE_DURATION, 0).Completed:Connect(function() -- Line: 332
                -- upvalues: teardownInternal (ref), u51 (copy), hideRig (ref), CurrentCamera (ref), IndependenceDayConfig (ref), u1 (ref), u10 (ref), u11 (ref), restoreOtherGuis (ref), fade (ref), Frame (ref), u24 (ref)
                teardownInternal();

                for _, v in u51 do
                    pcall(function() -- Line: 335
                        -- upvalues: hideRig (ref), v (copy)
                        hideRig(v);
                    end);
                end;

                CurrentCamera.CameraType = Enum.CameraType.Custom;
                CurrentCamera.FieldOfView = IndependenceDayConfig.DEFAULT_FOV;
                local v52 = u1.Character and v52:FindFirstChildOfClass("Humanoid");

                if v52 then
                    v52.WalkSpeed = u10;
                    v52.JumpHeight = u11;
                end;

                restoreOtherGuis();
                fade(IndependenceDayConfig.FADE_DURATION, 1).Completed:Connect(function() -- Line: 343
                    -- upvalues: Frame (ref), u24 (ref)
                    Frame.BackgroundTransparency = 1;
                    u24 = false;
                end);
            end);
        end);
    else
        warn("[IndependenceDayCutscenes] Opening: no camera track — ending immediately");
        fade(IndependenceDayConfig.FADE_DURATION, 0).Completed:Connect(function() -- Line: 332
            -- upvalues: teardownInternal (ref), u50 (copy), hideRig (ref), CurrentCamera (ref), IndependenceDayConfig (ref), u1 (ref), u10 (ref), u11 (ref), restoreOtherGuis (ref), fade (ref), Frame (ref), u24 (ref)
            teardownInternal();

            for _, v in u50 do
                pcall(function() -- Line: 335
                    -- upvalues: hideRig (ref), v (copy)
                    hideRig(v);
                end);
            end;

            CurrentCamera.CameraType = Enum.CameraType.Custom;
            CurrentCamera.FieldOfView = IndependenceDayConfig.DEFAULT_FOV;
            local v53 = u1.Character and v53:FindFirstChildOfClass("Humanoid");

            if v53 then
                v53.WalkSpeed = u10;
                v53.JumpHeight = u11;
            end;

            restoreOtherGuis();
            fade(IndependenceDayConfig.FADE_DURATION, 1).Completed:Connect(function() -- Line: 343
                -- upvalues: Frame (ref), u24 (ref)
                Frame.BackgroundTransparency = 1;
                u24 = false;
            end);
        end);
    end;

    for _, child in ipairs(Jets:GetChildren()) do
        if child:IsA("BasePart") and child ~= Jets.PrimaryPart then
            local v54 = child:FindFirstChildOfClass("Highlight");

            if not v54 then
                v54 = Instance.new("Highlight");
                v54.Parent = child;
                v54.FillColor = Color3.fromHex(child:GetAttribute("HighlightColor")) or Color3.fromHex("#FF0000");
            end;

            v54.Enabled = true;
        end;
    end;

    local u55 = Jets:FindFirstChild("Jet_1") and u55:FindFirstChild("SFX");

    if u55 then
        u55.RollOffMaxDistance = 5000;
        u55.Volume = 5;
        u55:Play();
        task.delay(v48.Length - 3, function() -- Line: 435
            -- upvalues: TweenService (ref), u55 (copy)
            local u56 = TweenService:Create(u55, TweenInfo.new(2), {
                Volume = 0
            });
            u56:Play();
            u56.Completed:Once(function(p57) -- Line: 440
                -- upvalues: u56 (copy)
                u56:Destroy();
            end);
        end);
        print("played sfx");
    end;

    task.delay(v48.Length - 1, function() -- Line: 451
        -- upvalues: Jets (copy), u55 (copy)
        for _, child in ipairs(Jets:GetChildren()) do
            if child:IsA("BasePart") and child ~= Jets.PrimaryPart then
                local v58 = child:FindFirstChildOfClass("Highlight");

                if v58 then
                    v58.Enabled = false;
                end;
            end;
        end;

        u55:Stop();
    end);
end;

function u42.playEnding(p59) -- Line: 467
    -- upvalues: u24 (ref), teardownInternal (copy), u27 (ref), u1 (ref), u10 (ref), u11 (ref), disableOtherGuis (copy), fade (copy), IndependenceDayConfig (copy), restoreOtherGuis (copy), u42 (copy), waitForCleanupDone (copy), Frame (copy)
    if u24 then
        return;
    end;

    teardownInternal();
    u24 = true;
    u27 = false;
    local v60 = u1.Character and v60:FindFirstChildOfClass("Humanoid");

    if v60 then
        u10 = v60.WalkSpeed;
        u11 = v60.JumpHeight;
        v60.WalkSpeed = 0;
        v60.JumpHeight = 0;
    end;

    disableOtherGuis();
    fade(IndependenceDayConfig.FADE_DURATION, 0).Completed:Connect(function() -- Line: 477
        -- upvalues: u1 (ref), u10 (ref), u11 (ref), restoreOtherGuis (ref), u42 (ref), waitForCleanupDone (ref), IndependenceDayConfig (ref), fade (ref), Frame (ref), u24 (ref)
        local v61 = u1.Character and v61:FindFirstChildOfClass("Humanoid");

        if v61 then
            v61.WalkSpeed = u10;
            v61.JumpHeight = u11;
        end;

        restoreOtherGuis();
        u42.showCredits();
        waitForCleanupDone(IndependenceDayConfig.CLEANUP_SIGNAL_TIMEOUT_SEC);
        fade(IndependenceDayConfig.FADE_DURATION, 1).Completed:Connect(function() -- Line: 489
            -- upvalues: Frame (ref), u24 (ref)
            Frame.BackgroundTransparency = 1;
            u24 = false;
        end);
    end);
end;

function u42.notifyCleanupDone() -- Line: 498
    -- upvalues: u27 (ref), BindableEvent (copy)
    u27 = true;
    BindableEvent:Fire();
end;

function u42.getCutsceneRigsFolder() -- Line: 65
    local v62 = workspace.AdminAbuse.Map:GetChildren()[1];

    if not (v62 and v62:IsA("Model")) then
        v62 = nil;
    end;

    if v62 then
        v62 = v62:FindFirstChild("Scriptables");
    end;

    if v62 then
        v62 = v62:FindFirstChild("CutsceneRigs");
    end;

    return v62;
end;

u42.showRig = showRig;
u42.hideRig = hideRig;
u42.loadTrack = loadTrack;

return u42;