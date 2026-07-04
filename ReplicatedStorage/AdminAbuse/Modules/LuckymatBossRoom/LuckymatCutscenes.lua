-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.LuckymatBossRoom.LuckymatCutscenes
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local u1;

if RunService:IsClient() then
    u1 = Players.LocalPlayer.PlayerGui;
else
    u1 = nil;
end;

local FakeAdminMessageUtil = require(ReplicatedStorage.Utilities.FakeAdminMessageUtil);
local LuckymatAnimIds = require(script.Parent.LuckymatAnimIds);
local u2 = false;
local u3 = 0;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = {};
local u12 = nil;
local u13 = {};
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;

local function getRigParts(p21) -- Line: 58
    local u22 = {};

    local function processVisible(p23, p24) -- Line: 61
        -- upvalues: u22 (copy)
        p23.Transparency = 1;

        if not p24 then
            table.insert(u22, p23);
        end;
    end;

    if p21:IsA("BasePart") then
        local v25 = p21.Name == "HumanoidRootPart" and true or p21.Name == "RootPart";
        p21.Transparency = 1;

        if not v25 then
            table.insert(u22, p21);
        end;
    end;

    for _, descendant in ipairs(p21:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local v26 = descendant.Name == "HumanoidRootPart" and true or descendant.Name == "RootPart";
            descendant.Transparency = 1;

            if not v26 then
                table.insert(u22, descendant);
            end;
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            descendant.Transparency = 1;
            table.insert(u22, descendant);
        end;
    end;

    return u22;
end;

local function setRigVisible(p27, p28) -- Line: 84
    -- upvalues: u11 (ref)
    print(u11);
    local v29 = u11[p27];

    if not v29 then
        return;
    end;

    local v30 = p28 and 0 or 1;

    for _, v in ipairs(v29) do
        v.Transparency = v30;
    end;
end;

local function setRigsVisible(p31, p32) -- Line: 94
    -- upvalues: u11 (ref)
    for _, v in ipairs(p31) do
        print(u11);
        local v33 = u11[v];

        if v33 then
            local v34 = p32 and 0 or 1;

            for _, v2 in ipairs(v33) do
                v2.Transparency = v34;
            end;
        end;
    end;
end;

local function hideAllRigs() -- Line: 100
    -- upvalues: u11 (ref)
    for i in pairs(u11) do
        print(u11);
        local v35 = u11[i];

        if v35 then
            for _, v in ipairs(v35) do
                v.Transparency = 1;
            end;
        end;
    end;
end;

local function getFrontFaceCFrame(p36) -- Line: 108
    return CFrame.lookAt(p36.Position - p36.CFrame.LookVector * (p36.Size.Z * 0.5), p36.Position);
end;

local function startCameraFollow() -- Line: 114
    -- upvalues: u12 (ref), RunService (copy), u10 (ref)
    if u12 then
        u12:Disconnect();
    end;

    local CurrentCamera = workspace.CurrentCamera;
    u12 = RunService.RenderStepped:Connect(function() -- Line: 117
        -- upvalues: u10 (ref), CurrentCamera (copy)
        if u10 and u10.Parent then
            local v37 = u10;
            CurrentCamera.CFrame = CFrame.lookAt(v37.Position - v37.CFrame.LookVector * (v37.Size.Z * 0.5), v37.Position);
        end;
    end);
end;

local function stopCameraFollow() -- Line: 124
    -- upvalues: u12 (ref)
    if u12 then
        u12:Disconnect();
        u12 = nil;
    end;
end;

local function loadTrack(p38, p39) -- Line: 133
    local v40 = p38:FindFirstChildOfClass("Humanoid") or p38:FindFirstChildOfClass("AnimationController");

    if not v40 then
        v40 = Instance.new("AnimationController");
        v40.Parent = p38;
    end;

    local u41 = v40:FindFirstChildOfClass("Animator");

    if not u41 then
        u41 = Instance.new("Animator");
        u41.Parent = v40;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = p39;
    local success, result = pcall(function() -- Line: 147
        -- upvalues: u41 (ref), Animation (copy)
        return u41:LoadAnimation(Animation);
    end);

    if success and result then
        return result;
    end;

    warn(("[LuckymatCutscenes] Failed to load \'%s\' on %s"):format(p39, p38.Name or "?"));

    return nil;
end;

local function loadAllTracks(p42) -- Line: 157
    -- upvalues: loadTrack (copy)
    local u43 = {};
    local u44 = #p42;

    if u44 > 0 then
        for _, v in ipairs(p42) do
            task.spawn(function() -- Line: 163
                -- upvalues: loadTrack (ref), v (copy), u43 (copy), u44 (ref)
                local v45 = loadTrack(v.rig, v.animId);

                if v45 then
                    local v46 = os.clock() + 2;

                    while v45.Length == 0 and os.clock() < v46 do
                        task.wait();
                    end;

                    table.insert(u43, {
                        spec = v,
                        track = v45,
                        length = v45.Length
                    });
                end;

                u44 = u44 - 1;
            end);
        end;

        while u44 > 0 do
            task.wait();
        end;
    end;

    return u43;
end;

local function playAndHold(u47) -- Line: 188
    u47.Priority = Enum.AnimationPriority.Action;
    u47.Looped = false;
    u47:Play(0);
    u47.Stopped:Connect(function() -- Line: 192
        -- upvalues: u47 (copy)
        u47:AdjustSpeed(0);
    end);
end;

local function connectFadeMarkers(p48) -- Line: 197
    -- upvalues: u17 (ref), TweenService (copy)
    p48:GetMarkerReachedSignal("FadetoBlackStart"):Connect(function() -- Line: 198
        -- upvalues: u17 (ref), TweenService (ref)
        if not u17 then
            return;
        end;

        TweenService:Create(u17, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 0
        }):Play();
    end);
    p48:GetMarkerReachedSignal("FadetoBlackEnd"):Connect(function() -- Line: 204
        -- upvalues: u17 (ref), TweenService (ref)
        if not u17 then
            return;
        end;

        TweenService:Create(u17, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 1
        }):Play();
    end);
end;

local function connectDialogueMarker(p49) -- Line: 212
    -- upvalues: FakeAdminMessageUtil (copy)
    p49:GetMarkerReachedSignal("Dialogue"):Connect(function() -- Line: 213
        -- upvalues: FakeAdminMessageUtil (ref)
        FakeAdminMessageUtil.show({
            message = "Finally, next week...",
            senderName = "chichine",
            senderUserId = 18298071
        });
    end);
end;

local function startBossIdle() -- Line: 224
    -- upvalues: u5 (ref), u11 (ref), loadTrack (copy), LuckymatAnimIds (copy), u20 (ref)
    if not u5 then
        return;
    end;

    print(u11);
    local v50 = u11[u5];

    if v50 then
        for _, v in ipairs(v50) do
            v.Transparency = 0;
        end;
    end;

    local v51 = loadTrack(u5, LuckymatAnimIds.idle.player);

    if v51 then
        v51.Priority = Enum.AnimationPriority.Idle;
        v51.Looped = true;
        v51:Play(0.3);
        u20 = v51;
    end;
end;

local function stopBossIdle() -- Line: 236
    -- upvalues: u20 (ref), u5 (ref), u11 (ref)
    if u20 then
        u20:Stop(0.3);
        u20 = nil;
    end;

    if u5 then
        print(u11);
        local v52 = u11[u5];

        if not v52 then
            return;
        end;

        for _, v in ipairs(v52) do
            v.Transparency = 1;
        end;
    end;
end;

local function tweenBarSize(p53, p54, p55) -- Line: 248
    -- upvalues: TweenService (copy)
    TweenService:Create(p53, TweenInfo.new(p55, Enum.EasingStyle.Quad), {
        Size = p54
    }):Play();
end;

local function buildGui() -- Line: 252
    -- upvalues: u14 (ref), u1 (ref), u15 (ref), u16 (ref), u17 (ref)
    if u14 and u14.Parent then
        return;
    end;

    if not u1 then
        warn("[LuckymatCutscenes.playEnding] - PlayerGui is nil. Was this called on the server? ");

        return;
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "LuckymatCutsceneGui";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    ScreenGui.Parent = u1;
    u14 = ScreenGui;

    local function makeBar(p56, p57) -- Line: 267
        -- upvalues: ScreenGui (copy)
        local Frame = Instance.new("Frame");
        Frame.Size = UDim2.new(1, 0, 0, 0);
        Frame.Position = p57;
        Frame.AnchorPoint = p56;
        Frame.BackgroundColor3 = Color3.new(0, 0, 0);
        Frame.BorderSizePixel = 0;
        Frame.ZIndex = 5;
        Frame.Parent = ScreenGui;

        return Frame;
    end;

    u15 = makeBar(Vector2.new(0, 0), UDim2.new(0, 0, 0, 0));
    u16 = makeBar(Vector2.new(0, 1), UDim2.new(0, 0, 1, 0));
    local Frame = Instance.new("Frame");
    Frame.Size = UDim2.new(1, 0, 1, 0);
    Frame.BackgroundColor3 = Color3.new(0, 0, 0);
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.ZIndex = 10;
    Frame.Parent = ScreenGui;
    u17 = Frame;
end;

local function hideTaggedUI() -- Line: 291
    -- upvalues: Players (copy), u13 (copy), CollectionService (copy)
    local v58 = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui");

    if not v58 then
        return;
    end;

    table.clear(u13);

    for _, v in CollectionService:GetTagged("UI") do
        if v:IsA("Frame") and v:IsDescendantOf(v58) then
            u13[v] = v.Visible;
            v.Visible = false;
        end;
    end;
end;

local function restoreTaggedUI() -- Line: 303
    -- upvalues: u13 (copy)
    for i, v in pairs(u13) do
        if i and i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(u13);
end;

local function showCredits() -- Line: 312
    -- upvalues: Players (copy), TweenService (copy)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "LuckymatCredits";
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
    TextLabel.TextStrokeColor3 = Color3.new();
    TextLabel.TextStrokeTransparency = 0;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.Text = "Host - Secret_Lokii & LuckyMatg\n\nProducer - FoeCakes & Chichine\n\nScripter - FoeCakes & Lyzrinn\n\nCutscenes - Orthemia\n\nBuilder - Nextune_Dev\n\nMusic - X3LL3N\n";
    TextLabel.TextTransparency = 1;
    TextLabel.Parent = Frame;
    TweenService:Create(TextLabel, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play();
    task.wait(6.5);
    local v59 = TweenService:Create(TextLabel, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    });
    v59:Play();
    v59.Completed:Once(function() -- Line: 365
        -- upvalues: ScreenGui (copy)
        ScreenGui:Destroy();
    end);
end;

local function showKillMessage() -- Line: 368
    -- upvalues: Players (copy), TweenService (copy)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "LuckymatKillMessage";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.DisplayOrder = 100;
    ScreenGui.Parent = PlayerGui;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Size = UDim2.fromScale(0.7, 0.1);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Font = Enum.Font.FredokaOne;
    TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0);
    TextLabel.TextStrokeTransparency = 0;
    TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0);
    TextLabel.TextScaled = true;
    TextLabel.Text = "KILL THE NOOBS TO WIN";
    TextLabel.Parent = ScreenGui;
    local UIScale = Instance.new("UIScale");
    UIScale.Scale = 1;
    UIScale.Parent = TextLabel;
    TweenService:Create(UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Scale = 1.08
    }):Play();
    task.delay(5, function() -- Line: 401
        -- upvalues: ScreenGui (copy)
        if ScreenGui and ScreenGui.Parent then
            ScreenGui:Destroy();
        end;
    end);
end;

local function runCutscene(p60, p61, p62) -- Line: 410
    -- upvalues: u2 (ref), u3 (ref), u17 (ref), Players (copy), hideTaggedUI (copy), u12 (ref), RunService (copy), u10 (ref), u15 (ref), tweenBarSize (copy), u16 (ref), u11 (ref), loadAllTracks (copy), connectFadeMarkers (copy), u4 (ref), FakeAdminMessageUtil (copy), u13 (copy)
    if u2 then
        return;
    end;

    u2 = true;
    u3 = u3 + 1;
    local v63 = u3;

    if u17 then
        u17.BackgroundTransparency = 1;
    end;

    local v64 = Players.LocalPlayer.Character and v64:FindFirstChildOfClass("Humanoid");

    if v64 then
        v64.WalkSpeed = 0;
        v64.JumpPower = 0;
    end;

    hideTaggedUI();
    local CurrentCamera = workspace.CurrentCamera;
    CurrentCamera.CameraType = Enum.CameraType.Scriptable;

    if u12 then
        u12:Disconnect();
    end;

    local CurrentCamera2 = workspace.CurrentCamera;
    u12 = RunService.RenderStepped:Connect(function() -- Line: 117
        -- upvalues: u10 (ref), CurrentCamera2 (copy)
        if u10 and u10.Parent then
            local v65 = u10;
            CurrentCamera2.CFrame = CFrame.lookAt(v65.Position - v65.CFrame.LookVector * (v65.Size.Z * 0.5), v65.Position);
        end;
    end);

    if u15 then
        tweenBarSize(u15, UDim2.new(1, 0, 0.12, 0), 0.5);
    end;

    if u16 then
        tweenBarSize(u16, UDim2.new(1, 0, 0.12, 0), 0.5);
    end;

    if u3 ~= v63 then
        return;
    end;

    for _, v in ipairs(p60) do
        print(u11);
        local v66 = u11[v];

        if v66 then
            for _, v2 in ipairs(v66) do
                v2.Transparency = 0;
            end;
        end;
    end;

    local v67 = loadAllTracks(p61);

    if u3 ~= v63 then
        return;
    end;

    local v68 = 0;

    for _, v in ipairs(v67) do
        connectFadeMarkers(v.track);

        if v.spec.rig == u4 then
            v.track:GetMarkerReachedSignal("Dialogue"):Connect(function() -- Line: 213
                -- upvalues: FakeAdminMessageUtil (ref)
                FakeAdminMessageUtil.show({
                    message = "Finally, next week...",
                    senderName = "chichine",
                    senderUserId = 18298071
                });
            end);
        end;

        if v68 < v.length then
            v68 = v.length;
        end;
    end;

    for _, v in ipairs(v67) do
        local track = v.track;
        track.Priority = Enum.AnimationPriority.Action;
        track.Looped = false;
        track:Play(0);
        track.Stopped:Connect(function() -- Line: 192
            -- upvalues: track (copy)
            track:AdjustSpeed(0);
        end);
    end;

    local v69 = math.max(0, v68 + (p62 or 0));

    if v69 > 0 then
        task.wait(v69);
    end;

    if u3 ~= v63 then
        return;
    end;

    if u15 then
        tweenBarSize(u15, UDim2.new(1, 0, 0, 0), 0.5);
    end;

    if u16 then
        tweenBarSize(u16, UDim2.new(1, 0, 0, 0), 0.5);
    end;

    task.wait(0.5);

    if u17 then
        u17.BackgroundTransparency = 1;
    end;

    for _, v in ipairs(p60) do
        print(u11);
        local v70 = u11[v];

        if v70 then
            for _, v2 in ipairs(v70) do
                v2.Transparency = 1;
            end;
        end;
    end;

    if u12 then
        u12:Disconnect();
        u12 = nil;
    end;

    CurrentCamera.CameraType = Enum.CameraType.Custom;

    if v64 and v64.Parent then
        v64.WalkSpeed = 16;
        v64.JumpPower = 50;
    end;

    for i, v in pairs(u13) do
        if i and i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(u13);
    u2 = false;
end;

return {
    init = function(p71) -- Line: 487, Name: init
        -- upvalues: u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u11 (ref), getRigParts (copy), u10 (ref), u18 (ref), LuckymatAnimIds (copy), u19 (ref), buildGui (copy)
        local u72 = p71:FindFirstChild("Scriptables") and u72:FindFirstChild("CutsceneObjects");

        if not u72 then
            warn("[LuckymatCutscenes] CutsceneObjects not found under mapClone.Scriptables");

            return;
        end;

        local function waitRig(p73) -- Line: 495
            -- upvalues: u72 (copy)
            local v74 = u72:WaitForChild(p73, 10);

            if not v74 then
                warn(("[LuckymatCutscenes] Rig \'%s\' not found"):format(p73));
            end;

            return v74;
        end;

        local HumanoidCameraRig = u72:WaitForChild("HumanoidCameraRig", 10);

        if not HumanoidCameraRig then
            warn(("[LuckymatCutscenes] Rig \'%s\' not found"):format("HumanoidCameraRig"));
        end;

        u4 = HumanoidCameraRig;
        local LuckyMatg = u72:WaitForChild("LuckyMatg", 10);

        if not LuckyMatg then
            warn(("[LuckymatCutscenes] Rig \'%s\' not found"):format("LuckyMatg"));
        end;

        u5 = LuckyMatg;
        local LeftWall = u72:WaitForChild("LeftWall", 10);

        if not LeftWall then
            warn(("[LuckymatCutscenes] Rig \'%s\' not found"):format("LeftWall"));
        end;

        u6 = LeftWall;
        local RightWall = u72:WaitForChild("RightWall", 10);

        if not RightWall then
            warn(("[LuckymatCutscenes] Rig \'%s\' not found"):format("RightWall"));
        end;

        u7 = RightWall;
        local TreadmillAdminAbuse = u72:WaitForChild("TreadmillAdminAbuse", 10);

        if not TreadmillAdminAbuse then
            warn(("[LuckymatCutscenes] Rig \'%s\' not found"):format("TreadmillAdminAbuse"));
        end;

        u8 = TreadmillAdminAbuse;
        local chichine = u72:WaitForChild("chichine", 10);

        if not chichine then
            warn(("[LuckymatCutscenes] Rig \'%s\' not found"):format("chichine"));
        end;

        u9 = chichine;
        u11 = {};

        for _, v in ipairs({
            u4,
            u5,
            u6,
            u7,
            u8,
            u9
        }) do
            if v then
                u11[v] = getRigParts(v);
            end;
        end;

        u10 = u4 and u4:FindFirstChild("Torso") or nil;

        if u5 and (u4 and (u6 and (u7 and u8))) then
            u18 = {
                {
                    rig = u5,
                    animId = LuckymatAnimIds.OPENING.player
                },
                {
                    rig = u4,
                    animId = LuckymatAnimIds.OPENING.camera
                },
                {
                    rig = u6,
                    animId = LuckymatAnimIds.OPENING.doorL
                },
                {
                    rig = u7,
                    animId = LuckymatAnimIds.OPENING.doorR
                },
                {
                    rig = u8,
                    animId = LuckymatAnimIds.OPENING.treadmill
                }
            };
        end;

        if u5 and (u4 and u9) then
            u19 = {
                {
                    rig = u5,
                    animId = LuckymatAnimIds.ENDING.player
                },
                {
                    rig = u4,
                    animId = LuckymatAnimIds.ENDING.camera
                },
                {
                    rig = u9,
                    animId = LuckymatAnimIds.ENDING.chichine
                }
            };
        end;

        for i in pairs(u11) do
            print(u11);
            local v75 = u11[i];

            if v75 then
                for _, v in ipairs(v75) do
                    v.Transparency = 1;
                end;
            end;
        end;

        buildGui();
    end,

    playOpening = function() -- Line: 540, Name: playOpening
        -- upvalues: u18 (ref), u5 (ref), u4 (ref), u6 (ref), u7 (ref), u8 (ref), u3 (ref), runCutscene (copy), u11 (ref), showKillMessage (copy), loadTrack (copy), LuckymatAnimIds (copy), u20 (ref)
        if not u18 then
            return;
        end;

        local u76 = {};

        for _, v in ipairs({
            u5,
            u4,
            u6,
            u7,
            u8
        }) do
            if v then
                table.insert(u76, v);
            end;
        end;

        local u77 = u3;
        task.spawn(function() -- Line: 547
            -- upvalues: runCutscene (ref), u76 (copy), u18 (ref), u8 (ref), u11 (ref), u3 (ref), u77 (copy), showKillMessage (ref), u5 (ref), loadTrack (ref), LuckymatAnimIds (ref), u20 (ref)
            runCutscene(u76, u18, -1.25);

            if u8 and u8.Parent then
                u11[u8] = nil;
                u8:Destroy();
                u8 = nil;
            end;

            if u3 == u77 + 1 then
                showKillMessage();

                if u5 then
                    print(u11);
                    local v78 = u11[u5];

                    if v78 then
                        for _, v in ipairs(v78) do
                            v.Transparency = 0;
                        end;
                    end;

                    local v79 = loadTrack(u5, LuckymatAnimIds.idle.player);

                    if v79 then
                        v79.Priority = Enum.AnimationPriority.Idle;
                        v79.Looped = true;
                        v79:Play(0.3);
                        u20 = v79;
                    end;
                end;

                if u76._treadmill then
                    u76._treadmill:Destroy();
                end;
            end;
        end);
    end,

    playEnding = function() -- Line: 566, Name: playEnding
        -- upvalues: u19 (ref), u1 (ref), u5 (ref), u4 (ref), u9 (ref), SoundService (copy), runCutscene (copy), showCredits (copy)
        if not u19 then
            return;
        end;

        if not u1 then
            warn("[LuckymatCutscenes.playEnding] - PlayerGui is nil. Was this called on the server? ");

            return;
        end;

        local u80 = {};

        for _, v in ipairs({ u5, u4, u9 }) do
            if v then
                table.insert(u80, v);
            end;
        end;

        local LuckymatBossRoomHUD = u1:FindFirstChild("LuckymatBossRoomHUD");

        if LuckymatBossRoomHUD then
            LuckymatBossRoomHUD.Enabled = false;
        end;

        task.spawn(function() -- Line: 584
            -- upvalues: SoundService (ref), u5 (ref), runCutscene (ref), u80 (copy), u19 (ref), showCredits (ref)
            local Sound = Instance.new("Sound");
            Sound.Volume = 1.5;
            Sound.SoundId = "rbxassetid://79348298352567";
            Sound.Parent = SoundService;
            task.delay(4, function() -- Line: 592
                -- upvalues: Sound (copy), u5 (ref)
                Sound:Play();
                Sound.Ended:Once(function(p81) -- Line: 594
                    -- upvalues: Sound (ref)
                    Sound:Destroy();
                end);

                if u5 then
                    local Torso = u5:FindFirstChild("Torso");
                    local v82 = Torso and u5:FindFirstChildOfClass("Humanoid");

                    if v82 then
                        v82.RequiresNeck = false;
                        local Neck = Torso:FindFirstChild("Neck");

                        if Neck then
                            Neck:Destroy();
                        end;
                    end;
                end;
            end);
            runCutscene(u80, u19, 0);
            showCredits();
        end);
    end,

    stopAll = function() -- Line: 620, Name: stopAll
        -- upvalues: u3 (ref), u2 (ref), u13 (copy), u12 (ref), u17 (ref), u15 (ref), u16 (ref), u11 (ref), u20 (ref), u5 (ref), Players (copy)
        u3 = u3 + 1;
        u2 = false;

        for i, v in pairs(u13) do
            if i and i.Parent then
                i.Visible = v;
            end;
        end;

        table.clear(u13);

        if u12 then
            u12:Disconnect();
            u12 = nil;
        end;

        local CurrentCamera = workspace.CurrentCamera;

        if CurrentCamera then
            CurrentCamera.CameraType = Enum.CameraType.Custom;
        end;

        if u17 then
            u17.BackgroundTransparency = 1;
        end;

        if u15 then
            u15.Size = UDim2.new(1, 0, 0, 0);
        end;

        if u16 then
            u16.Size = UDim2.new(1, 0, 0, 0);
        end;

        for i in pairs(u11) do
            print(u11);
            local v83 = u11[i];

            if v83 then
                for _, v in ipairs(v83) do
                    v.Transparency = 1;
                end;
            end;
        end;

        if u20 then
            u20:Stop(0.3);
            u20 = nil;
        end;

        if u5 then
            print(u11);
            local v84 = u11[u5];

            if v84 then
                for _, v in ipairs(v84) do
                    v.Transparency = 1;
                end;
            end;
        end;

        local v85 = Players.LocalPlayer and Players.LocalPlayer.Character;
        local v86 = v85 and v85:FindFirstChildOfClass("Humanoid");

        if v86 then
            v86.WalkSpeed = 16;
            v86.JumpPower = 50;
        end;
    end,

    stopBossIdle = function() -- Line: 647, Name: stopBossIdle
        -- upvalues: u20 (ref), u5 (ref), u11 (ref)
        if u20 then
            u20:Stop(0.3);
            u20 = nil;
        end;

        if u5 then
            print(u11);
            local v87 = u11[u5];

            if not v87 then
                return;
            end;

            for _, v in ipairs(v87) do
                v.Transparency = 1;
            end;
        end;
    end
};