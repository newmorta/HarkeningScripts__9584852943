-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.ChichineBossRoom.ChichineCutscenes
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local u1, v2;

if RunService:IsClient() then
    u1 = Players.LocalPlayer;
    v2 = u1.PlayerGui;
else
    v2 = nil;
    u1 = nil;
end;

local CurrentCamera = workspace.CurrentCamera;
local u3 = {
    Opening = {
        chichine_start = "rbxassetid://113856668289045",
        player_start = "rbxassetid://88017832425060",
        HumanoidCameraRig_start = "rbxassetid://106227701693140"
    },
    Ending = {
        chichine_end = "rbxassetid://90430318921493",
        secretlokii_end = "rbxassetid://114579969892164",
        HumanoidCameraRig_end = "rbxassetid://137774859892392"
    }
};
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "ChichineCutsceneFade";
ScreenGui.IgnoreGuiInset = true;
ScreenGui.ResetOnSpawn = false;
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
ScreenGui.DisplayOrder = 999999;
ScreenGui.Parent = v2;
local Frame = Instance.new("Frame");
Frame.Size = UDim2.fromScale(1, 1);
Frame.BackgroundColor3 = Color3.new(0, 0, 0);
Frame.BackgroundTransparency = 1;
Frame.BorderSizePixel = 0;
Frame.ZIndex = 999999;
Frame.Parent = ScreenGui;
local u4 = nil;

local function fade(p5, p6, p7) -- Line: 55
    -- upvalues: u4 (ref), Frame (copy), TweenService (copy)
    if u4 then
        u4:Cancel();
    end;

    Frame.BackgroundColor3 = p5;
    local v8 = TweenService:Create(Frame, TweenInfo.new(p6, Enum.EasingStyle.Linear), {
        BackgroundTransparency = p7
    });
    u4 = v8;
    v8:Play();

    return v8;
end;

local u9 = {
    WhiteFadeIn = { Color3.new(1, 1, 1), 3, 0 },
    WhiteFadeOut = { Color3.new(1, 1, 1), 2, 1 },
    BlackFadeIn = { Color3.new(0, 0, 0), 2, 0 },
    BlackFadeOut = { Color3.new(0, 0, 0), 2, 1 }
};
local ScreenGui2 = Instance.new("ScreenGui");
ScreenGui2.Name = "ChichineCutsceneScreenEffect";
ScreenGui2.IgnoreGuiInset = true;
ScreenGui2.ResetOnSpawn = false;
ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
ScreenGui2.DisplayOrder = 999998;
ScreenGui2.Parent = v2;
local Frame2 = Instance.new("Frame");
Frame2.Name = "ScreenEffectFrame";
Frame2.Size = UDim2.fromScale(1, 1);
Frame2.BackgroundColor3 = Color3.fromRGB(120, 80, 180);
Frame2.BackgroundTransparency = 1;
Frame2.BorderSizePixel = 0;
Frame2.ZIndex = 999998;
Frame2.Parent = ScreenGui2;
local u10 = nil;
local u11 = nil;
local u12 = {
    ["0.5"] = 0.8,
    ["0"] = 0.2
};
local u13 = Color3.fromRGB(120, 80, 180);
local u14 = Color3.new(0, 0, 0);

local function cancelSEThread() -- Line: 101
    -- upvalues: u11 (ref)
    if u11 then
        task.cancel(u11);
        u11 = nil;
    end;
end;

local function seFade(p15, p16) -- Line: 108
    -- upvalues: u10 (ref), TweenService (copy), Frame2 (copy)
    if u10 then
        u10:Cancel();
    end;

    local v17 = TweenService:Create(Frame2, TweenInfo.new(p15, Enum.EasingStyle.Linear), {
        BackgroundTransparency = p16
    });
    u10 = v17;
    v17:Play();

    return v17;
end;

local function handleScreenEffectMarker(p18) -- Line: 120
    -- upvalues: u12 (copy), u11 (ref), Frame2 (copy), u13 (copy), seFade (copy), TweenService (copy), u14 (copy), fade (copy)
    local v19 = p18:match("FadeToTransparency([%d%.]+)");

    if not v19 then
        return;
    end;

    local v20 = tonumber(v19);

    if not v20 then
        return;
    end;

    local v21 = u12[v19] or 1;

    if u11 then
        task.cancel(u11);
        u11 = nil;
    end;

    Frame2.BackgroundColor3 = u13;
    local u22 = seFade(v21, v20);

    if v20 >= 1 then
        u11 = task.spawn(function() -- Line: 133
            -- upvalues: u22 (copy), TweenService (ref), Frame2 (ref), u14 (ref), fade (ref), u13 (ref), u11 (ref)
            u22.Completed:Wait();
            task.wait(3);
            local v23 = TweenService:Create(Frame2, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
                BackgroundTransparency = 0
            });
            v23:Play();
            v23.Completed:Wait();
            local v24 = TweenService:Create(Frame2, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
                BackgroundColor3 = u14
            });
            v24:Play();
            v24.Completed:Wait();
            fade(Color3.new(0, 0, 0), 0.4, 0).Completed:Wait();
            task.wait(7);
            fade(Color3.new(0, 0, 0), 1.2, 1).Completed:Wait();
            Frame2.BackgroundTransparency = 1;
            Frame2.BackgroundColor3 = u13;
            u11 = nil;
        end);
    end;
end;

local function playSFX(p25) -- Line: 159
    -- upvalues: ReplicatedStorage (copy)
    local SFX = ReplicatedStorage.AdminAbuse.ChichineBossRoom:WaitForChild("SFX");
    local v26;

    if SFX then
        v26 = SFX:FindFirstChild(p25);
    else
        v26 = SFX;
    end;

    if v26 and v26:IsA("Sound") then
        local u27 = v26:Clone();
        u27.Parent = SFX;
        u27:Play();
        u27.Ended:Connect(function() -- Line: 167
            -- upvalues: u27 (copy)
            u27:Destroy();
        end);
    end;
end;

local function getAnimator(p28) -- Line: 173
    local v29 = p28:FindFirstChildOfClass("Humanoid") or p28:FindFirstChildOfClass("AnimationController");

    if not v29 then
        return nil;
    end;

    local v30 = v29:FindFirstChildOfClass("Animator");

    if not v30 then
        v30 = Instance.new("Animator");
        v30.Parent = v29;
    end;

    return v30;
end;

local function showRig(p31) -- Line: 185
    for _, descendant in p31:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant.Name ~= "HumanoidRootPart" and descendant.Name ~= "RootPart" then
                descendant.Transparency = 0;
            end;
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            descendant.Transparency = 0;
        end;
    end;
end;

local function hideRig(p32) -- Line: 196
    for _, descendant in p32:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 1;
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            descendant.Transparency = 1;
        end;
    end;
end;

local u33 = 16;
local u34 = 7.2;

local function freezePlayer() -- Line: 211
    -- upvalues: u1 (ref), u33 (ref), u34 (ref)
    local v35 = u1.Character and v35:FindFirstChildOfClass("Humanoid");

    if not v35 then
        return;
    end;

    u33 = v35.WalkSpeed;
    u34 = v35.JumpHeight;
    v35.WalkSpeed = 0;
    v35.JumpHeight = 0;
end;

local function unfreezePlayer() -- Line: 221
    -- upvalues: u1 (ref), u33 (ref), u34 (ref)
    local v36 = u1.Character and v36:FindFirstChildOfClass("Humanoid");

    if not v36 then
        return;
    end;

    v36.WalkSpeed = u33;
    v36.JumpHeight = u34;
end;

local u37 = {
    ChichineCutsceneFade = true,
    ChichineCutsceneScreenEffect = true
};
local u38 = {};

local function disableOtherGuis() -- Line: 238
    -- upvalues: u1 (ref), u38 (copy), u37 (copy)
    local v39 = u1:FindFirstChildOfClass("PlayerGui");

    if not v39 then
        return;
    end;

    table.clear(u38);

    for _, child in v39:GetChildren() do
        if child.Name ~= "AdminAnnounce" and (child:IsA("ScreenGui") and not u37[child.Name]) then
            u38[child] = child.Enabled;
            child.Enabled = false;
        end;
    end;
end;

local function restoreOtherGuis() -- Line: 253
    -- upvalues: u1 (ref), u37 (copy), u38 (copy)
    local v40 = u1:FindFirstChildOfClass("PlayerGui");

    if not v40 then
        return;
    end;

    for _, child in v40:GetChildren() do
        if child:IsA("ScreenGui") and not u37[child.Name] then
            local v41 = u38[child];

            if v41 ~= nil then
                child.Enabled = v41;
            end;
        end;
    end;

    table.clear(u38);
end;

local u42 = false;

local function bindCamera(p43) -- Line: 271
    -- upvalues: CurrentCamera (copy), RunService (copy), u42 (ref)
    local u44 = p43:FindFirstChild("CameraTarget", true) or (p43:FindFirstChild("Torso") or p43:FindFirstChildWhichIsA("BasePart"));

    if not u44 then
        warn("[ChichineCutscenes] bindCamera: no trackable part in", p43:GetFullName());

        return;
    end;

    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    CurrentCamera.FieldOfView = 35;

    local function getCF() -- Line: 285
        -- upvalues: u44 (copy)
        if u44:IsA("Attachment") then
            return u44.WorldCFrame;
        end;

        return u44.CFrame;
    end;

    local v45;

    if u44:IsA("Attachment") then
        v45 = u44.WorldCFrame;
    else
        v45 = u44.CFrame;
    end;

    CurrentCamera.CFrame = v45;
    RunService:BindToRenderStep("ChichineCutsceneCamera", Enum.RenderPriority.Camera.Value, function() -- Line: 291
        -- upvalues: CurrentCamera (ref), u44 (copy)
        local v46;

        if u44:IsA("Attachment") then
            v46 = u44.WorldCFrame;
        else
            v46 = u44.CFrame;
        end;

        CurrentCamera.CFrame = v46;
    end);
    u42 = true;
end;

local function unbindCamera() -- Line: 297
    -- upvalues: u42 (ref), RunService (copy)
    if u42 then
        RunService:UnbindFromRenderStep("ChichineCutsceneCamera");
        u42 = false;
    end;
end;

local u47 = false;
local u48 = {};
local u49 = {};
local u50 = nil;
local u51 = nil;

local function teardownInternal() -- Line: 312
    -- upvalues: u42 (ref), RunService (copy), u50 (ref), u49 (copy), u48 (copy), u51 (ref), u11 (ref), Frame2 (copy), u13 (copy)
    if u42 then
        RunService:UnbindFromRenderStep("ChichineCutsceneCamera");
        u42 = false;
    end;

    if u50 then
        u50:Disconnect();
        u50 = nil;
    end;

    for _, v in u49 do
        v:Disconnect();
    end;

    table.clear(u49);

    for _, v in u48 do
        if v.IsPlaying then
            v:Stop(0);
        end;
    end;

    table.clear(u48);

    if u51 then
        pcall(function() -- Line: 325
            -- upvalues: u51 (ref)
            u51:Destroy();
        end);
        u51 = nil;
    end;

    if u11 then
        task.cancel(u11);
        u11 = nil;
    end;

    Frame2.BackgroundTransparency = 1;
    Frame2.BackgroundColor3 = u13;
end;

local function attachSFXMarkers(p52) -- Line: 336
    -- upvalues: u49 (copy), playSFX (copy)
    local v53 = p52:GetMarkerReachedSignal("Sound");
    table.insert(u49, v53:Connect(function(p54) -- Line: 337
        -- upvalues: playSFX (ref)
        playSFX(p54);
    end));
end;

local function attachSEMarkers(p55) -- Line: 342
    -- upvalues: u49 (copy), handleScreenEffectMarker (copy)
    local v56 = p55:GetMarkerReachedSignal("ScreenEffect");
    table.insert(u49, v56:Connect(function(p57) -- Line: 343
        -- upvalues: handleScreenEffectMarker (ref)
        handleScreenEffectMarker(p57);
    end));
end;

local function attachFadeMarkers(p58) -- Line: 348
    -- upvalues: u9 (copy), u49 (copy), fade (copy)
    for i, v in u9 do
        local u59 = v[1];
        local u60 = v[2];
        local u61 = v[3];
        local v62 = p58:GetMarkerReachedSignal(i);
        table.insert(u49, v62:Connect(function() -- Line: 351
            -- upvalues: fade (ref), u59 (copy), u60 (copy), u61 (copy)
            fade(u59, u60, u61);
        end));
    end;
end;

local function loadTrack(p63, p64) -- Line: 359
    local v65 = p63:FindFirstChildOfClass("Humanoid") or p63:FindFirstChildOfClass("AnimationController");
    local u66;

    if v65 then
        u66 = v65:FindFirstChildOfClass("Animator");

        if not u66 then
            u66 = Instance.new("Animator");
            u66.Parent = v65;
        end;
    else
        u66 = nil;
    end;

    if not u66 then
        return nil;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = p64;
    local success, result = pcall(function() -- Line: 364
        -- upvalues: u66 (copy), Animation (copy)
        return u66:LoadAnimation(Animation);
    end);
    Animation:Destroy();

    if success then
        result.Looped = false;

        return result;
    end;

    warn("[ChichineCutscenes] LoadAnimation failed:", result);

    return nil;
end;

local function applyPlayerAppearance(p67) -- Line: 377
    -- upvalues: Players (copy), u1 (ref)
    local u68 = p67:FindFirstChildOfClass("Humanoid");

    if not u68 then
        return;
    end;

    local success, result = pcall(function() -- Line: 380
        -- upvalues: Players (ref), u1 (ref)
        return Players:GetHumanoidDescriptionFromUserId(u1.UserId);
    end);

    if success and result then
        pcall(function() -- Line: 384
            -- upvalues: u68 (copy), result (copy)
            u68:ApplyDescriptionAsync(result);
        end);
    end;
end;

local function finishCutscene(u69, u70) -- Line: 390
    -- upvalues: fade (copy), teardownInternal (copy), hideRig (copy), CurrentCamera (copy), UserInputService (copy), u1 (ref), u33 (ref), u34 (ref), restoreOtherGuis (copy), Frame (copy), u47 (ref)
    fade(Color3.new(0, 0, 0), 0.5, 0).Completed:Connect(function() -- Line: 392
        -- upvalues: teardownInternal (ref), u69 (copy), hideRig (ref), CurrentCamera (ref), UserInputService (ref), u1 (ref), u33 (ref), u34 (ref), restoreOtherGuis (ref), fade (ref), Frame (ref), u47 (ref), u70 (copy)
        teardownInternal();

        for _, v in u69 do
            pcall(function() -- Line: 395
                -- upvalues: hideRig (ref), v (copy)
                hideRig(v);
            end);
        end;

        CurrentCamera.CameraType = Enum.CameraType.Custom;
        CurrentCamera.FieldOfView = 70;
        UserInputService.MouseIconEnabled = true;
        local v71 = u1.Character and v71:FindFirstChildOfClass("Humanoid");

        if v71 then
            v71.WalkSpeed = u33;
            v71.JumpHeight = u34;
        end;

        restoreOtherGuis();
        fade(Color3.new(0, 0, 0), 0.5, 1).Completed:Connect(function() -- Line: 404
            -- upvalues: Frame (ref), u47 (ref), u70 (ref)
            Frame.BackgroundTransparency = 1;
            u47 = false;

            if u70 then
                u70();
            end;
        end);
    end);
end;

return {
    isActive = function() -- Line: 416, Name: isActive
        -- upvalues: u47 (ref)
        return u47;
    end,

    stop = function() -- Line: 420, Name: stop
        -- upvalues: u47 (ref), teardownInternal (copy), CurrentCamera (copy), UserInputService (copy), u1 (ref), u33 (ref), u34 (ref), restoreOtherGuis (copy), Frame (copy)
        if not u47 then
            return;
        end;

        teardownInternal();
        CurrentCamera.CameraType = Enum.CameraType.Custom;
        CurrentCamera.FieldOfView = 70;
        UserInputService.MouseIconEnabled = true;
        local v72 = u1.Character and v72:FindFirstChildOfClass("Humanoid");

        if v72 then
            v72.WalkSpeed = u33;
            v72.JumpHeight = u34;
        end;

        restoreOtherGuis();
        Frame.BackgroundTransparency = 1;
        u47 = false;
    end,

    playOpening = function(p73, u74) -- Line: 434, Name: playOpening
        -- upvalues: u47 (ref), teardownInternal (copy), showRig (copy), u51 (ref), applyPlayerAppearance (copy), u1 (ref), u33 (ref), u34 (ref), disableOtherGuis (copy), bindCamera (copy), loadTrack (copy), u3 (copy), u49 (copy), playSFX (copy), handleScreenEffectMarker (copy), attachFadeMarkers (copy), u48 (copy), u50 (ref), u11 (ref), finishCutscene (copy)
        if u47 then
            return;
        end;

        teardownInternal();
        u47 = true;
        local v75 = p73:FindFirstChild("Scriptables") and v75:FindFirstChild("CutsceneRigs");

        if not v75 then
            warn("[ChichineCutscenes] CutsceneRigs not found under", p73:GetFullName());
            u47 = false;

            if u74 then
                task.spawn(u74);
            end;

            return;
        end;

        local chichine_start = v75:FindFirstChild("chichine_start");
        local player_start = v75:FindFirstChild("player_start");
        local HumanoidCameraRig_start = v75:FindFirstChild("HumanoidCameraRig_start");

        if not (chichine_start and HumanoidCameraRig_start) then
            warn("[ChichineCutscenes] Opening: missing chichine_start or HumanoidCameraRig_start");
            u47 = false;

            if u74 then
                task.spawn(u74);
            end;

            return;
        end;

        showRig(chichine_start);
        showRig(HumanoidCameraRig_start);

        if player_start and player_start:IsA("Model") then
            local u76 = player_start:Clone();
            u76.Parent = workspace;
            u51 = u76;
            showRig(u76);
            task.spawn(function() -- Line: 468
                -- upvalues: applyPlayerAppearance (ref), u76 (copy)
                applyPlayerAppearance(u76);

                for _, descendant in u76:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.CanCollide = false;
                        descendant.CanTouch = false;
                        descendant.CanQuery = false;
                    end;
                end;
            end);
        end;

        local v77 = u1.Character and v77:FindFirstChildOfClass("Humanoid");

        if v77 then
            u33 = v77.WalkSpeed;
            u34 = v77.JumpHeight;
            v77.WalkSpeed = 0;
            v77.JumpHeight = 0;
        end;

        disableOtherGuis();
        bindCamera(HumanoidCameraRig_start);
        local v78;

        if HumanoidCameraRig_start:IsA("Model") then
            v78 = loadTrack(HumanoidCameraRig_start, u3.Opening.HumanoidCameraRig_start) or nil;
        else
            v78 = nil;
        end;

        local v79;

        if chichine_start:IsA("Model") then
            v79 = loadTrack(chichine_start, u3.Opening.chichine_start) or nil;
        else
            v79 = nil;
        end;

        local v80 = u51 and loadTrack(u51, u3.Opening.player_start) or nil;

        if v79 then
            local v81 = v79:GetMarkerReachedSignal("Sound");
            table.insert(u49, v81:Connect(function(p82) -- Line: 337
                -- upvalues: playSFX (ref)
                playSFX(p82);
            end));
            local v83 = v79:GetMarkerReachedSignal("ScreenEffect");
            table.insert(u49, v83:Connect(function(p84) -- Line: 343
                -- upvalues: handleScreenEffectMarker (ref)
                handleScreenEffectMarker(p84);
            end));
        end;

        if v80 then
            local v85 = v80:GetMarkerReachedSignal("Sound");
            table.insert(u49, v85:Connect(function(p86) -- Line: 337
                -- upvalues: playSFX (ref)
                playSFX(p86);
            end));
            local v87 = v80:GetMarkerReachedSignal("ScreenEffect");
            table.insert(u49, v87:Connect(function(p88) -- Line: 343
                -- upvalues: handleScreenEffectMarker (ref)
                handleScreenEffectMarker(p88);
            end));
        end;

        if v78 then
            attachFadeMarkers(v78);
            local v89 = v78:GetMarkerReachedSignal("Sound");
            table.insert(u49, v89:Connect(function(p90) -- Line: 337
                -- upvalues: playSFX (ref)
                playSFX(p90);
            end));
        end;

        if v79 then
            v79:Play(0, 1, 1);
            table.insert(u48, v79);
        end;

        if v80 then
            v80:Play(0, 1, 1);
            table.insert(u48, v80);
        end;

        local u91 = { chichine_start, HumanoidCameraRig_start };

        if not v78 then
            warn("[ChichineCutscenes] Opening: no camera track — ending immediately");
            finishCutscene(u91, u74);

            return;
        end;

        v78:Play(0, 1, 1);
        table.insert(u48, v78);
        u50 = v78.Ended:Connect(function() -- Line: 517
            -- upvalues: u11 (ref), finishCutscene (ref), u91 (copy), u74 (copy)
            if u11 then
                task.spawn(function() -- Line: 519
                    -- upvalues: u11 (ref), finishCutscene (ref), u91 (ref), u74 (ref)
                    while u11 do
                        task.wait(0.1);
                    end;

                    finishCutscene(u91, u74);
                end);

                return;
            end;

            finishCutscene(u91, u74);
        end);
    end,

    playEnding = function(p92, u93) -- Line: 535, Name: playEnding
        -- upvalues: u47 (ref), teardownInternal (copy), showRig (copy), u1 (ref), u33 (ref), u34 (ref), disableOtherGuis (copy), bindCamera (copy), loadTrack (copy), u3 (copy), u49 (copy), playSFX (copy), handleScreenEffectMarker (copy), attachFadeMarkers (copy), u48 (copy), u50 (ref), u11 (ref), finishCutscene (copy)
        if u47 then
            return;
        end;

        teardownInternal();
        u47 = true;
        local v94 = p92:FindFirstChild("Scriptables") and v94:FindFirstChild("CutsceneRigs");

        if not v94 then
            warn("[ChichineCutscenes] CutsceneRigs not found for ending");
            u47 = false;

            if u93 then
                task.spawn(u93);
            end;

            return;
        end;

        local chichine_end = v94:FindFirstChild("chichine_end");
        local secretlokii_end = v94:FindFirstChild("secretlokii_end");
        local HumanoidCameraRig_end = v94:FindFirstChild("HumanoidCameraRig_end");

        if not (chichine_end and HumanoidCameraRig_end) then
            warn("[ChichineCutscenes] Ending: missing chichine_end or HumanoidCameraRig_end");
            u47 = false;

            if u93 then
                task.spawn(u93);
            end;

            return;
        end;

        showRig(chichine_end);

        if secretlokii_end then
            showRig(secretlokii_end);
        end;

        showRig(HumanoidCameraRig_end);
        local v95 = u1.Character and v95:FindFirstChildOfClass("Humanoid");

        if v95 then
            u33 = v95.WalkSpeed;
            u34 = v95.JumpHeight;
            v95.WalkSpeed = 0;
            v95.JumpHeight = 0;
        end;

        disableOtherGuis();
        bindCamera(HumanoidCameraRig_end);
        local v96;

        if HumanoidCameraRig_end:IsA("Model") then
            v96 = loadTrack(HumanoidCameraRig_end, u3.Ending.HumanoidCameraRig_end) or nil;
        else
            v96 = nil;
        end;

        local v97;

        if chichine_end:IsA("Model") then
            v97 = loadTrack(chichine_end, u3.Ending.chichine_end) or nil;
        else
            v97 = nil;
        end;

        local v98;

        if secretlokii_end and secretlokii_end:IsA("Model") then
            v98 = loadTrack(secretlokii_end, u3.Ending.secretlokii_end) or nil;
        else
            v98 = nil;
        end;

        if v97 then
            local v99 = v97:GetMarkerReachedSignal("Sound");
            table.insert(u49, v99:Connect(function(p100) -- Line: 337
                -- upvalues: playSFX (ref)
                playSFX(p100);
            end));
            local v101 = v97:GetMarkerReachedSignal("ScreenEffect");
            table.insert(u49, v101:Connect(function(p102) -- Line: 343
                -- upvalues: handleScreenEffectMarker (ref)
                handleScreenEffectMarker(p102);
            end));
        end;

        if v96 then
            attachFadeMarkers(v96);
            local v103 = v96:GetMarkerReachedSignal("Sound");
            table.insert(u49, v103:Connect(function(p104) -- Line: 337
                -- upvalues: playSFX (ref)
                playSFX(p104);
            end));
        end;

        if v97 then
            v97:Play(0, 1, 1);
            table.insert(u48, v97);
        end;

        if v98 then
            v98:Play(0, 1, 1);
            table.insert(u48, v98);
        end;

        local u105 = { chichine_end, HumanoidCameraRig_end };

        if secretlokii_end then
            table.insert(u105, secretlokii_end);
        end;

        if not v96 then
            warn("[ChichineCutscenes] Ending: no camera track — ending immediately");
            finishCutscene(u105, u93);

            return;
        end;

        v96:Play(0, 1, 1);
        table.insert(u48, v96);
        u50 = v96.Ended:Connect(function() -- Line: 597
            -- upvalues: u11 (ref), finishCutscene (ref), u105 (copy), u93 (copy)
            if u11 then
                task.spawn(function() -- Line: 599
                    -- upvalues: u11 (ref), finishCutscene (ref), u105 (ref), u93 (ref)
                    while u11 do
                        task.wait(0.1);
                    end;

                    finishCutscene(u105, u93);
                end);

                return;
            end;

            finishCutscene(u105, u93);
        end);
    end
};