-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.NextuneBossRoom
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Debris = game:GetService("Debris");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local ContentProvider = game:GetService("ContentProvider");
local Remotes = ReplicatedStorage:WaitForChild("AdminAbuse"):WaitForChild("Remotes");
local NextuneBossRoomAnimIds = require(script:WaitForChild("NextuneBossRoomAnimIds"));
local AdminAbuseBossFx = Remotes:WaitForChild("AdminAbuseBossFx");
local camerashaker = require(ReplicatedStorage.Packages.camerashaker);
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = false;
local u10 = nil;
local identity = CFrame.identity;
local identity2 = CFrame.identity;
local u11 = 0;
local u12 = 1;
local u13 = false;
local u14 = nil;
local u15 = false;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = nil;
local u26 = 0;
local u27 = 0;
local u28 = nil;
local u29 = 0;
local u30 = 1;
local u31 = {};

local function hideTaggedUI() -- Line: 69
    -- upvalues: Players (copy), u31 (copy), CollectionService (copy)
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return;
    end;

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not PlayerGui then
        return;
    end;

    table.clear(u31);

    for _, v in CollectionService:GetTagged("UI") do
        if v:IsA("Frame") and v:IsDescendantOf(PlayerGui) then
            u31[v] = v.Visible;
            v.Visible = false;
        end;
    end;
end;

local function restoreTaggedUI() -- Line: 84
    -- upvalues: u31 (copy)
    for i, v in u31 do
        if i and i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(u31);
end;

local function beginCinematic() -- Line: 93
    -- upvalues: u26 (ref), u9 (ref), hideTaggedUI (copy)
    u26 = u26 + 1;

    if not u9 then
        hideTaggedUI();
    end;

    u9 = true;

    return u26;
end;

local function endCinematicIfToken(p32) -- Line: 102
    -- upvalues: u26 (ref), u9 (ref), u31 (copy)
    if p32 ~= u26 then
        return false;
    end;

    u26 = u26 + 1;
    u9 = false;

    for i, v in u31 do
        if i and i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(u31);

    return true;
end;

local function forceEndCinematic() -- Line: 112
    -- upvalues: u26 (ref), u9 (ref), u31 (copy)
    u26 = u26 + 1;
    u9 = false;

    for i, v in u31 do
        if i and i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(u31);
end;

local u33 = {
    Hidden = true,
    NeedsDuration = false,
    SkipDoorTransition = false,
    RequiresRespawnRefire = false,
    IsAdminAbuse = true,
    PhaseMusic = { "rbxassetid://85133275269470", "rbxassetid://132744646373593", "rbxassetid://115060825765034", "rbxassetid://115060825765034" },
    SFX = {
        Roar = "rbxassetid://140076040328382",
        Laugh = "rbxassetid://4810729995",
        Glitch = "rbxassetid://135159133360974",
        Death = "rbxassetid://XXXXXXX",
        Explosion = "rbxassetid://121250496298953"
    },
    BossAnimations = {
        IdlePhase1 = NextuneBossRoomAnimIds.IdlePhase1,
        IdlePhase2 = NextuneBossRoomAnimIds.IdlePhase2,
        IdlePhase3 = NextuneBossRoomAnimIds.IdlePhase3,
        PrepareJump = NextuneBossRoomAnimIds.PrepareJump,
        Jump = NextuneBossRoomAnimIds.Jump,
        Fall = NextuneBossRoomAnimIds.Fall,
        Roar = NextuneBossRoomAnimIds.Roar,
        Laugh = NextuneBossRoomAnimIds.Laugh
    }
};

local function playSfxWithAutoFade(u34) -- Line: 157
    -- upvalues: TweenService (copy)
    local _ = u34.Volume;
    u34:Play();
    task.spawn(function() -- Line: 160
        -- upvalues: u34 (copy), TweenService (ref)
        local TimeLength = u34.TimeLength;
        local v35 = 0;

        while TimeLength <= 0 and v35 < 30 do
            task.wait(0.1);

            if not (u34 and u34.Parent) then
                return;
            end;

            TimeLength = u34.TimeLength;
            v35 = v35 + 1;
        end;

        if TimeLength < 1 then
            return;
        end;

        local v36 = TimeLength - 0.5;

        while u34 and (u34.Parent and u34.IsPlaying) do
            if v36 <= u34.TimePosition then
                local v37 = math.max(0.05, TimeLength - u34.TimePosition);
                TweenService:Create(u34, TweenInfo.new(v37, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Volume = 0
                }):Play();

                return;
            end;

            task.wait(0.05);
        end;
    end);
end;

local function playPhaseMusic(p38) -- Line: 184
    -- upvalues: u33 (copy), u28 (ref), TweenService (copy), Players (copy), u29 (ref)
    local v39 = u33.PhaseMusic[p38];

    if not v39 or v39 == "rbxassetid://XXXXXXX" then
        return;
    end;

    if u28 and u28.Parent then
        local u40 = u28;
        local u41 = TweenService:Create(u40, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Volume = 0
        });
        u41:Play();
        u41.Completed:Once(function() -- Line: 193
            -- upvalues: u40 (copy), u41 (copy)
            u40:Stop();
            u40:Destroy();
            u41:Destroy();
        end);
    end;

    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return;
    end;

    local Sound = Instance.new("Sound");
    Sound.Name = "NextuneMusicPhase" .. tostring(p38);
    Sound.SoundId = v39;
    Sound.Looped = true;
    Sound.Volume = 0;
    Sound.Parent = LocalPlayer;
    u28 = Sound;
    u29 = p38;
    task.spawn(function() -- Line: 212
        -- upvalues: Sound (copy), TweenService (ref)
        if not Sound.IsLoaded then
            Sound.Loaded:Wait();
        end;

        if not (Sound and Sound.Parent) then
            return;
        end;

        Sound:Play();
        local u42 = TweenService:Create(Sound, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Volume = 0.5
        });
        u42:Play();
        u42.Completed:Once(function() -- Line: 223
            -- upvalues: u42 (copy)
            u42:Destroy();
        end);
    end);
end;

local function stopPhaseMusic() -- Line: 227
    -- upvalues: u28 (ref), TweenService (copy), u29 (ref)
    if u28 and u28.Parent then
        local u43 = u28;
        local u44 = TweenService:Create(u43, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Volume = 0
        });
        u44:Play();
        u44.Completed:Once(function() -- Line: 232
            -- upvalues: u43 (copy), u44 (copy)
            u43:Stop();
            u43:Destroy();
            u44:Destroy();
        end);
    end;

    u28 = nil;
    u29 = 0;
end;

local function preloadAssets() -- Line: 244
    -- upvalues: u33 (copy), ContentProvider (copy)
    local u45 = {};

    for _, v in pairs(u33.PhaseMusic) do
        if type(v) == "string" and (v:match("rbxassetid://") and not v:match("XXXXXXX")) then
            table.insert(u45, v);
        end;
    end;

    for _, v in pairs(u33.SFX) do
        if type(v) == "string" and (v:match("rbxassetid://") and not v:match("XXXXXXX")) then
            table.insert(u45, v);
        end;
    end;

    for _, v in pairs(u33.BossAnimations) do
        if type(v) == "string" and (v:match("rbxassetid://") and not v:match("XXXXXXX")) then
            local Animation = Instance.new("Animation");
            Animation.AnimationId = v;
            table.insert(u45, Animation);
        end;
    end;

    print("[NextuneBossRoom] Preloading " .. #u45 .. " assets...");
    task.spawn(function() -- Line: 271
        -- upvalues: ContentProvider (ref), u45 (copy)
        local v46 = os.clock();
        pcall(function() -- Line: 273
            -- upvalues: ContentProvider (ref), u45 (ref)
            ContentProvider:PreloadAsync(u45);
        end);
        print(string.format("[NextuneBossRoom] Preloading finished in %.2fs", os.clock() - v46));
    end);
end;

local function showCredits() -- Line: 282
    -- upvalues: Players (copy), TweenService (copy)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "NextuneCredits";
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
    TextLabel.Text = " Brought to you by:\n    \nHosts - Secret_Lokii & LuckyMatg\nProducer - Chichine\nScripter - FoeCakes\nMusic - X3LL3N\nBuilder - NEXTUNE_DEV";
    TextLabel.TextTransparency = 1;
    TextLabel.Parent = Frame;
    TweenService:Create(TextLabel, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play();
    task.wait(6.5);
    local v47 = TweenService:Create(TextLabel, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    });
    v47:Play();
    v47.Completed:Connect(function() -- Line: 323
        -- upvalues: ScreenGui (copy)
        ScreenGui:Destroy();
    end);
end;

local function showFakeAnnouncement(p48) -- Line: 331
    -- upvalues: Players (copy), ReplicatedStorage (copy), TweenService (copy)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
    local NotificationFrame = ReplicatedStorage:FindFirstChild("NotificationFrame");

    if not NotificationFrame then
        warn("[NextuneBossRoom] FakeAnnounce: NotificationFrame template missing");

        return;
    end;

    local u49 = NotificationFrame:Clone();
    local Avatar = u49:FindFirstChild("Avatar");

    if Avatar and Avatar:IsA("ImageLabel") then
        local success, result = pcall(function() -- Line: 353
            -- upvalues: Players (ref)
            return Players:GetUserThumbnailAsync(156, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100);
        end);

        if success and result then
            Avatar.Image = result;
        end;

        Avatar.ImageColor3 = Color3.new(0, 0, 0);
    end;

    local Text = u49:FindFirstChild("Text");

    if Text and Text:IsA("TextLabel") then
        Text.RichText = true;
        Text.Text = "<font color=\"rgb(225,20,255)\"><b>???</b></font> : " .. (p48 or "Everything is going as planned.");
    end;

    local u50 = {};
    local u51 = {};

    for _, descendant in u49:GetDescendants() do
        if descendant:IsA("UIStroke") then
            table.insert(u50, {
                prop = "Transparency",
                obj = descendant
            });
        elseif descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            table.insert(u50, {
                prop = "TextTransparency",
                obj = descendant
            });

            if descendant.BackgroundTransparency < 1 then
                table.insert(u50, {
                    prop = "BackgroundTransparency",
                    obj = descendant
                });
            end;
        elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
            table.insert(u50, {
                prop = "ImageTransparency",
                obj = descendant
            });

            if descendant.BackgroundTransparency < 1 then
                table.insert(u50, {
                    prop = "BackgroundTransparency",
                    obj = descendant
                });
            end;
        elseif descendant:IsA("Frame") and descendant.BackgroundTransparency < 1 then
            table.insert(u50, {
                prop = "BackgroundTransparency",
                obj = descendant
            });
        end;

        if descendant:IsA("UIGradient") then
            table.insert(u51, {
                obj = descendant,
                original = descendant.Transparency
            });
        end;
    end;

    if u49:IsA("Frame") and u49.BackgroundTransparency < 1 then
        table.insert(u50, {
            prop = "BackgroundTransparency",
            obj = u49
        });
    end;

    local v52 = {};

    for i, v in ipairs(u50) do
        v52[i] = v.obj[v.prop];
        v.obj[v.prop] = 1;
    end;

    local u53 = NumberSequence.new(1);

    for _, v in ipairs(u51) do
        v.obj.Transparency = u53;
    end;

    local v54 = PlayerGui:FindFirstChild("AdminAnnounce") and v54:FindFirstChild("MainFrame");
    local u55 = nil;

    if v54 then
        u49.Parent = v54;
    else
        u55 = Instance.new("ScreenGui");
        u55.Name = "FakeAnnounce";
        u55.IgnoreGuiInset = true;
        u55.DisplayOrder = 110;
        u55.Parent = PlayerGui;
        u49.Parent = u55;
    end;

    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://98797174600699";
    Sound.Volume = 0.4;
    Sound.Parent = PlayerGui;
    local _ = Sound.Volume;
    Sound:Play();
    task.spawn(function() -- Line: 160
        -- upvalues: Sound (copy), TweenService (ref)
        local TimeLength = Sound.TimeLength;
        local v56 = 0;

        while TimeLength <= 0 and v56 < 30 do
            task.wait(0.1);

            if not (Sound and Sound.Parent) then
                return;
            end;

            TimeLength = Sound.TimeLength;
            v56 = v56 + 1;
        end;

        if TimeLength < 1 then
            return;
        end;

        local v57 = TimeLength - 0.5;

        while Sound and (Sound.Parent and Sound.IsPlaying) do
            if v57 <= Sound.TimePosition then
                local v58 = math.max(0.05, TimeLength - Sound.TimePosition);
                TweenService:Create(Sound, TweenInfo.new(v58, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Volume = 0
                }):Play();

                return;
            end;

            task.wait(0.05);
        end;
    end);
    game:GetService("Debris"):AddItem(Sound, 5);
    local v59 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

    for i, v in ipairs(u50) do
        TweenService:Create(v.obj, v59, {
            [v.prop] = v52[i]
        }):Play();
    end;

    for _, v in ipairs(u51) do
        v.obj.Transparency = v.original;
    end;

    task.delay(3.5, function() -- Line: 440
        -- upvalues: u50 (copy), TweenService (ref), u51 (copy), u53 (copy), u49 (copy), u55 (ref)
        local v60 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

        for _, v in ipairs(u50) do
            TweenService:Create(v.obj, v60, {
                [v.prop] = 1
            }):Play();
        end;

        for _, v in ipairs(u51) do
            v.obj.Transparency = u53;
        end;

        task.delay(0.5, function() -- Line: 448
            -- upvalues: u49 (ref), u55 (ref)
            if u49 and u49.Parent then
                u49:Destroy();
            end;

            if u55 and u55.Parent then
                u55:Destroy();
            end;
        end);
    end);
end;

local function getBossRig() -- Line: 456
    local v61 = workspace:FindFirstChild("AdminAbuse") and v61:FindFirstChild("Map") and v61:FindFirstChild("BossRig", true);

    return v61;
end;

local function setVfxEnabled(p62) -- Line: 462
    local v63 = workspace:FindFirstChild("AdminAbuse") and v63:FindFirstChild("Map") and v63:FindFirstChild("BossRig", true) and v63:FindFirstChild("TornadoVFX") and v63:FindFirstChild("Main");

    if not v63 then
        return;
    end;

    for _, descendant in v63:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = p62;
        end;
    end;
end;

local function refreshBar() -- Line: 474
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u12 (ref), u24 (ref), u25 (ref)
    local v64 = u2;
    local v65 = u3;
    local v66 = u5;

    if not v66 or (not v64 or u12 <= 0) then
        return;
    end;

    local v67 = math.clamp(v66.Value, 0, u12);
    v64.Size = UDim2.new(math.clamp(v67 / u12, 0, 1), 0, 1, 0);

    if v65 then
        if u12 >= 1000000 then
            v65.Text = string.format("%.3fM / %.1fM", v67 / 1000000, u12 / 1000000);
        else
            v65.Text = string.format("%d / %d", math.floor(v67 + 0.5), (math.floor(u12 + 0.5)));
        end;
    end;

    if u24 then
        local v68 = v67 / u12 >= 0.999;
        local v69;

        if v68 then
            v69 = Color3.fromRGB(255, 30, 80);
        else
            v69 = Color3.fromRGB(95, 95, 105);
        end;

        u24.BackgroundColor3 = v69;
        u24.BackgroundTransparency = v68 and 0.05 or 0.35;

        if u25 then
            local v70;

            if v68 then
                v70 = Color3.fromRGB(255, 200, 210);
            else
                v70 = Color3.fromRGB(190, 190, 200);
            end;

            u25.TextColor3 = v70;
        end;
    end;
end;

local function applyPhaseMarkerStyle(p71) -- Line: 501
    -- upvalues: u20 (ref), u22 (ref), u21 (ref), u23 (ref), u24 (ref), u25 (ref)
    local v72 = u20;

    if v72 then
        local v73 = p71 >= 2;
        local v74;

        if v73 then
            v74 = Color3.fromRGB(185, 110, 255);
        else
            v74 = Color3.fromRGB(95, 95, 105);
        end;

        v72.BackgroundColor3 = v74;
        v72.BackgroundTransparency = v73 and 0.05 or 0.35;
    end;

    local v75 = u22;

    if v75 then
        local v76;

        if p71 >= 2 then
            v76 = Color3.fromRGB(235, 205, 255);
        else
            v76 = Color3.fromRGB(190, 190, 200);
        end;

        v75.TextColor3 = v76;
    end;

    local v77 = u21;

    if v77 then
        local v78 = p71 >= 3;
        local v79;

        if v78 then
            v79 = Color3.fromRGB(220, 25, 255);
        else
            v79 = Color3.fromRGB(95, 95, 105);
        end;

        v77.BackgroundColor3 = v79;
        v77.BackgroundTransparency = v78 and 0.05 or 0.35;
    end;

    local v80 = u23;

    if v80 then
        local v81;

        if p71 >= 3 then
            v81 = Color3.fromRGB(235, 205, 255);
        else
            v81 = Color3.fromRGB(190, 190, 200);
        end;

        v80.TextColor3 = v81;
    end;

    local v82 = u24;

    if v82 then
        v82.BackgroundColor3 = Color3.fromRGB(95, 95, 105);
        v82.BackgroundTransparency = 0.35;
    end;

    local v83 = u25;

    if v83 then
        v83.TextColor3 = Color3.fromRGB(190, 190, 200);
    end;
end;

local function applyPhase3BossBarStyle() -- Line: 536
    -- upvalues: u2 (ref), TweenService (copy), u19 (ref), u18 (ref), RunService (copy)
    if not u2 then
        return;
    end;

    local u84 = TweenService:Create(u2, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(155, 0, 190)
    });
    u84:Play();
    u84.Completed:Once(function() -- Line: 544
        -- upvalues: u84 (copy)
        u84:Destroy();
    end);

    if u19 then
        u19:Disconnect();
        u19 = nil;
    end;

    if u18 then
        u18:Destroy();
    end;

    local UIGradient = Instance.new("UIGradient");
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 30, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(20, 8, 30)),
        ColorSequenceKeypoint.new(0.68, Color3.fromRGB(195, 16, 240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 0, 12))
    });
    UIGradient.Rotation = 0;
    UIGradient.Parent = u2;
    u18 = UIGradient;
    u19 = RunService.Heartbeat:Connect(function() -- Line: 559
        -- upvalues: u18 (ref), u19 (ref)
        local v85 = u18;

        if not (v85 and v85.Parent) then
            if u19 then
                u19:Disconnect();
                u19 = nil;
            end;

            return;
        end;

        local new = Vector2.new;
        local v86 = os.clock() * 0.85;
        v85.Offset = new(math.sin(v86) * 0.65, 0);
    end);
end;

local function onBossHpSync(p87, p88, p89) -- Line: 569
    -- upvalues: u11 (ref), u12 (ref), u6 (ref), u13 (ref), u5 (ref), refreshBar (copy), TweenService (copy), u30 (ref), playPhaseMusic (copy)
    if type(p87) ~= "number" then
        return;
    end;

    local v90;

    if type(p88) == "number" then
        v90 = p88;
    else
        v90 = p87;
    end;

    if v90 <= 0 then
        return;
    end;

    if type(p89) == "number" and p89 < u11 then
        return;
    end;

    if type(p89) == "number" then
        u11 = p89;
    end;

    u12 = v90;

    if u6 then
        u6:Cancel();
        u6 = nil;
    end;

    local v91 = math.clamp(p87, 0, v90);

    if not u13 then
        u13 = true;

        if u5 then
            u5.Value = v91;
        end;

        refreshBar();

        return;
    end;

    local v92 = u5;

    if not v92 then
        return;
    end;

    local v93 = TweenService:Create(v92, TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Value = v91
    });
    u6 = v93;
    v93:Play();

    if u30 == 3 and p87 / p88 <= 0.1 then
        u30 = 4;
        playPhaseMusic(4);
    end;
end;

local function destroyUi() -- Line: 598
    -- upvalues: stopPhaseMusic (copy), u19 (ref), u18 (ref), u16 (ref), u6 (ref), u7 (ref), u1 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u25 (ref), u2 (ref), u3 (ref), u4 (ref), u5 (ref), u11 (ref), u12 (ref), u13 (ref), u30 (ref)
    stopPhaseMusic();

    if u19 then
        u19:Disconnect();
        u19 = nil;
    end;

    if u18 then
        u18:Destroy();
        u18 = nil;
    end;

    if u16 then
        u16:Destroy();
        u16 = nil;
    end;

    if u6 then
        u6:Cancel();
        u6 = nil;
    end;

    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    if u1 then
        u1:Destroy();
        u1 = nil;
    end;

    u20 = nil;
    u21 = nil;
    u22 = nil;
    u23 = nil;
    u24 = nil;
    u25 = nil;
    u2 = nil;
    u3 = nil;
    u4 = nil;
    u5 = nil;
    u11 = 0;
    u12 = 1;
    u13 = false;
    u30 = 1;
end;

local function teardownCutsceneListener() -- Line: 619
    -- upvalues: u8 (ref), u14 (ref), u26 (ref), u9 (ref), u31 (copy), u27 (ref), u10 (ref), identity (ref), identity2 (ref), RunService (copy)
    if u8 then
        u8:Disconnect();
        u8 = nil;
    end;

    if u14 then
        u14:Stop();
        u14 = nil;
    end;

    u26 = u26 + 1;
    u9 = false;

    for i, v in u31 do
        if i and i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(u31);
    u27 = 0;
    u10 = nil;
    identity = CFrame.identity;
    identity2 = CFrame.identity;
    RunService:UnbindFromRenderStep("NextuneCinematicLock");
end;

local function buildUi() -- Line: 633
    -- upvalues: destroyUi (copy), Players (copy), u1 (ref), ReplicatedStorage (copy), u16 (ref), u17 (ref), u2 (ref), u20 (ref), u22 (ref), u21 (ref), u23 (ref), u24 (ref), u25 (ref), applyPhaseMarkerStyle (copy), u3 (ref), refreshBar (copy), u5 (ref), u4 (ref)
    destroyUi();
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return;
    end;

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "NextuneBossHud";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.DisplayOrder = 80;
    ScreenGui.Parent = PlayerGui;
    u1 = ScreenGui;
    local PulseBoss = ReplicatedStorage:FindFirstChild("PulseBoss");

    if PulseBoss and PulseBoss:IsA("ScreenGui") then
        u16 = PulseBoss:Clone();
        u16.Parent = PlayerGui;
        local Frame = u16:FindFirstChild("Frame");

        if Frame then
            u17 = Frame.BackgroundColor3;
            task.spawn(function() -- Line: 655
                -- upvalues: u16 (ref), Frame (copy)
                while u16 and u16.Parent do
                    local v94 = os.clock() * 3;
                    Frame.BackgroundTransparency = (math.sin(v94) + 1) / 2 * 0.3 + 0.6;
                    task.wait();
                end;
            end);
        end;
    end;

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
    ImageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=563212204&w=150&h=150";
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
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Phase2Marker";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.Position = UDim2.new(0.33, 0, 0.5, 0);
    Frame4.Size = UDim2.new(0, 6, 1, 0);
    Frame4.BorderSizePixel = 0;
    Frame4.ZIndex = Frame3.ZIndex + 2;
    Frame4.Parent = Frame2;
    Instance.new("UIStroke", Frame4).Thickness = 1;
    u20 = Frame4;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Phase2Text";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Position = UDim2.new(0.33, 0, 0.5, 16);
    TextLabel.Size = UDim2.new(0, 64, 0, 22);
    TextLabel.ZIndex = Frame3.ZIndex + 3;
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.Text = "P2";
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeTransparency = 0.55;
    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
    TextLabel.TextColor3 = Color3.fromRGB(190, 190, 200);
    TextLabel.Parent = Frame2;
    u22 = TextLabel;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Phase3Marker";
    Frame5.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame5.Position = UDim2.new(0.67, 0, 0.5, 0);
    Frame5.Size = UDim2.new(0, 6, 1, 0);
    Frame5.BorderSizePixel = 0;
    Frame5.ZIndex = Frame3.ZIndex + 2;
    Frame5.Parent = Frame2;
    Instance.new("UIStroke", Frame5).Thickness = 1;
    u21 = Frame5;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Phase3Text";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.Position = UDim2.new(0.67, 0, 0.5, 16);
    TextLabel2.Size = UDim2.new(0, 64, 0, 22);
    TextLabel2.ZIndex = Frame3.ZIndex + 3;
    TextLabel2.Font = Enum.Font.GothamBold;
    TextLabel2.Text = "P3";
    TextLabel2.TextScaled = true;
    TextLabel2.TextStrokeTransparency = 0.55;
    TextLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
    TextLabel2.TextColor3 = Color3.fromRGB(190, 190, 200);
    TextLabel2.Parent = Frame2;
    u23 = TextLabel2;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "EndMarker";
    Frame6.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame6.Position = UDim2.new(1, 0, 0.5, 0);
    Frame6.Size = UDim2.new(0, 6, 1, 0);
    Frame6.BorderSizePixel = 0;
    Frame6.ZIndex = Frame3.ZIndex + 2;
    Frame6.Parent = Frame2;
    Instance.new("UIStroke", Frame6).Thickness = 1;
    u24 = Frame6;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "EndText";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.Position = UDim2.new(1, 0, 0.5, 16);
    TextLabel3.Size = UDim2.new(0, 64, 0, 22);
    TextLabel3.ZIndex = Frame3.ZIndex + 3;
    TextLabel3.Font = Enum.Font.GothamBold;
    TextLabel3.Text = "???";
    TextLabel3.TextScaled = true;
    TextLabel3.TextStrokeTransparency = 0.55;
    TextLabel3.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
    TextLabel3.TextColor3 = Color3.fromRGB(190, 190, 200);
    TextLabel3.Parent = Frame2;
    u25 = TextLabel3;
    applyPhaseMarkerStyle(1);
    local TextLabel4 = Instance.new("TextLabel", Frame2);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.Size = UDim2.new(0.45, 0, 1, 0);
    TextLabel4.Font = Enum.Font.GothamBold;
    TextLabel4.Text = ("Nextune"):upper() .. " BOSS EVENT";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    Instance.new("UIPadding", TextLabel4).PaddingLeft = UDim.new(0.04, 0);
    local TextLabel5 = Instance.new("TextLabel", Frame2);
    TextLabel5.AnchorPoint = Vector2.new(1, 0);
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.Position = UDim2.new(1, 0, 0, 0);
    TextLabel5.Size = UDim2.new(0.4, 0, 1, 0);
    TextLabel5.Font = Enum.Font.GothamBold;
    TextLabel5.Text = "0 / 0";
    TextLabel5.TextColor3 = Color3.new(1, 1, 1);
    TextLabel5.TextScaled = true;
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Right;
    Instance.new("UIPadding", TextLabel5).PaddingRight = UDim.new(0.04, 0);
    u3 = TextLabel5;
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = 0;
    NumberValue.Changed:Connect(refreshBar);
    u5 = NumberValue;
    local TextLabel6 = Instance.new("TextLabel", ScreenGui);
    TextLabel6.Name = "PhaseLabel";
    TextLabel6.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.Position = UDim2.new(0.5, 0, 0.08, 52);
    TextLabel6.Size = UDim2.new(0.12, 0, 0, 20);
    TextLabel6.Font = Enum.Font.GothamBold;
    TextLabel6.Text = "PHASE 1";
    TextLabel6.TextColor3 = Color3.new(1, 1, 1);
    TextLabel6.TextScaled = true;
    TextLabel6.TextStrokeTransparency = 0.5;
    TextLabel6.TextStrokeColor3 = Color3.new(0, 0, 0);
    u4 = TextLabel6;
end;

local function getClientDebrisFolder() -- Line: 832
    local v95 = workspace:FindFirstChild("AdminAbuse") and v95:FindFirstChild("Map") and v95:FindFirstChild("Debris", true);

    return v95 or workspace;
end;

local function setupCutsceneListener() -- Line: 842
    -- upvalues: u8 (ref), u14 (ref), u26 (ref), u9 (ref), u31 (copy), u27 (ref), u10 (ref), identity (ref), identity2 (ref), RunService (copy), AdminAbuseBossFx (copy), Players (copy), hideTaggedUI (copy), TweenService (copy), u1 (ref), u33 (copy), setVfxEnabled (copy), u30 (ref), u4 (ref), applyPhaseMarkerStyle (copy), applyPhase3BossBarStyle (copy), playPhaseMusic (copy), Debris (copy), u16 (ref), u17 (ref), u15 (ref), NextuneBossRoomAnimIds (copy), stopPhaseMusic (copy), showFakeAnnouncement (copy), destroyUi (copy), showCredits (copy), camerashaker (copy)
    if u8 then
        u8:Disconnect();
        u8 = nil;
    end;

    if u14 then
        u14:Stop();
        u14 = nil;
    end;

    u26 = u26 + 1;
    u9 = false;

    for i, v in u31 do
        if i and i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(u31);
    u27 = 0;
    u10 = nil;
    identity = CFrame.identity;
    identity2 = CFrame.identity;
    RunService:UnbindFromRenderStep("NextuneCinematicLock");
    u8 = AdminAbuseBossFx.OnClientEvent:Connect(function(p96, u97) -- Line: 845
        -- upvalues: u26 (ref), u9 (ref), u31 (ref), u27 (ref), Players (ref), hideTaggedUI (ref), TweenService (ref), u1 (ref), u10 (ref), u33 (ref), setVfxEnabled (ref), identity2 (ref), u30 (ref), u4 (ref), applyPhaseMarkerStyle (ref), applyPhase3BossBarStyle (ref), playPhaseMusic (ref), u14 (ref), Debris (ref), u16 (ref), u17 (ref), u15 (ref), NextuneBossRoomAnimIds (ref), stopPhaseMusic (ref), showFakeAnnouncement (ref), destroyUi (ref), showCredits (ref)
        if type(p96) ~= "string" then
            warn("[NextuneBossRoom] fxRemote: expected string cmd, got:", (type(p96)));

            return;
        end;

        local CurrentCamera = workspace.CurrentCamera;

        if not CurrentCamera then
            return;
        end;

        if p96 == "SetCamera" then
            if type(u97) ~= "table" then
                warn("[NextuneBossRoom] SetCamera: expected table data, got:", (type(u97)));

                return;
            end;

            local type2 = u97.type;

            if type2 == "Reset" then
                u26 = u26 + 1;
                u9 = false;

                for i, v in u31 do
                    if i and i.Parent then
                        i.Visible = v;
                    end;
                end;

                table.clear(u31);
                u27 = 0;
                CurrentCamera.CameraType = Enum.CameraType.Custom;
                local Character = Players.LocalPlayer.Character;
                local v98 = Character and Character:FindFirstChildOfClass("Humanoid");

                if v98 then
                    CurrentCamera.CameraSubject = v98;
                end;

                return;
            end;

            local cf = u97.cf;

            if typeof(cf) ~= "CFrame" then
                warn("[NextuneBossRoom] SetCamera: cf is not a CFrame, got:", (typeof(cf)));

                return;
            end;

            u26 = u26 + 1;

            if not u9 then
                hideTaggedUI();
            end;

            u9 = true;
            u27 = 0;
            CurrentCamera.CameraSubject = nil;
            CurrentCamera.CameraType = Enum.CameraType.Scriptable;

            if type2 == "Fixed" then
                CurrentCamera.CFrame = cf;

                return;
            end;

            if type2 == "Tween" then
                TweenService:Create(CurrentCamera, TweenInfo.new(u97.dur or 2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    CFrame = cf
                }):Play();
            end;
        else
            if p96 == "Presentation" then
                print("[NextuneBossRoom] Presentation handler entered");
                u26 = u26 + 1;

                if not u9 then
                    hideTaggedUI();
                end;

                u9 = true;
                local u99 = u26;
                u27 = 0;
                CurrentCamera.CameraType = Enum.CameraType.Scriptable;
                CurrentCamera.CameraSubject = nil;
                task.spawn(function() -- Line: 907
                    -- upvalues: u1 (ref), u99 (copy), u26 (ref), u9 (ref), u31 (ref), Players (ref), u97 (copy), u10 (ref), u33 (ref), setVfxEnabled (ref), TweenService (ref), identity2 (ref)
                    if u1 then
                        u1.Enabled = false;
                    end;

                    local CurrentCamera2 = workspace.CurrentCamera;

                    if not CurrentCamera2 then
                        warn("[NextuneBossRoom] Presentation: CurrentCamera is nil");

                        return;
                    end;

                    local function restoreCamera() -- Line: 922
                        -- upvalues: u99 (ref), u26 (ref), u9 (ref), u31 (ref), CurrentCamera2 (copy), Players (ref)
                        local v100;

                        if u99 == u26 then
                            u26 = u26 + 1;
                            u9 = false;

                            for i, v in u31 do
                                if i and i.Parent then
                                    i.Visible = v;
                                end;
                            end;

                            table.clear(u31);
                            v100 = true;
                        else
                            v100 = false;
                        end;

                        if not v100 then
                            return;
                        end;

                        print("[NextuneBossRoom] Presentation: restoring camera");
                        CurrentCamera2.CameraType = Enum.CameraType.Custom;
                        local v101 = Players.LocalPlayer.Character and v101:FindFirstChildOfClass("Humanoid");

                        if v101 then
                            CurrentCamera2.CameraSubject = v101;
                        end;
                    end;

                    local v102 = type(u97) == "table" and type(u97.cframes) == "table" and (u97.cframes or {}) or {};
                    print("[NextuneBossRoom] Presentation: received", #v102, "camera CFrames from server");

                    if #v102 == 0 then
                        warn("[NextuneBossRoom] Presentation: No camera CFrames received — check workspace.AdminAbuse.Map.Cameras on the server");
                        local v103;

                        if u99 == u26 then
                            u26 = u26 + 1;
                            u9 = false;

                            for i, v in u31 do
                                if i and i.Parent then
                                    i.Visible = v;
                                end;
                            end;

                            table.clear(u31);
                            v103 = true;
                        else
                            v103 = false;
                        end;

                        if not v103 then
                            return;
                        end;

                        print("[NextuneBossRoom] Presentation: restoring camera");
                        CurrentCamera2.CameraType = Enum.CameraType.Custom;
                        local v104 = Players.LocalPlayer.Character and v104:FindFirstChildOfClass("Humanoid");

                        if v104 then
                            CurrentCamera2.CameraSubject = v104;
                        end;

                        return;
                    end;

                    local u105 = workspace:FindFirstChild("AdminAbuse") and u105:FindFirstChild("Map") and u105:FindFirstChild("BossRig", true);
                    local v106;

                    if u105 then
                        v106 = u105:FindFirstChildOfClass("Humanoid");
                    else
                        v106 = u105;
                    end;

                    local v107 = v106 and v106:FindFirstChildOfClass("Animator");

                    if not v107 then
                        if u105 then
                            v107 = u105:FindFirstChildOfClass("Animator");
                        else
                            v107 = u105;
                        end;
                    end;

                    print("[NextuneBossRoom] Presentation: bossRig=", u105, "| animator=", v107);
                    print("[NextuneBossRoom] Presentation: sweeping to farthest cam over", 2.5, "sec");
                    local v108 = v102[1];
                    local CFrame2 = CurrentCamera2.CFrame;
                    local v109 = tick();

                    repeat
                        local v110 = (tick() - v109) / 2.5;
                        local v111 = math.clamp(v110, 0, 1);
                        u10 = CFrame2:Lerp(v108, v111 * v111 * (3 - v111 * 2));
                        task.wait();
                    until tick() - v109 >= 2.5;

                    u10 = v108;
                    local v112;

                    if v107 and u33.BossAnimations.Roar ~= "rbxassetid://XXXXXXX" then
                        local Animation = Instance.new("Animation");
                        Animation.AnimationId = u33.BossAnimations.Roar;
                        v112 = v107:LoadAnimation(Animation);
                        local u113 = nil;
                        u113 = v112:GetMarkerReachedSignal("Roar"):Connect(function() -- Line: 978
                            -- upvalues: u113 (ref), setVfxEnabled (ref), u33 (ref), u105 (copy), TweenService (ref), u9 (ref), u99 (ref), u26 (ref), identity2 (ref)
                            if u113 then
                                u113:Disconnect();
                                u113 = nil;
                            end;

                            print("[NextuneBossRoom] Presentation: \'Roar\' marker reached — starting effects");
                            setVfxEnabled(true);

                            if u33.SFX.Roar ~= "rbxassetid://XXXXXXX" then
                                local Sound = Instance.new("Sound");
                                Sound.SoundId = u33.SFX.Roar;
                                Sound.Volume = 2;
                                Sound.Parent = u105 and u105.PrimaryPart or workspace;
                                local _ = Sound.Volume;
                                Sound:Play();
                                task.spawn(function() -- Line: 160
                                    -- upvalues: Sound (copy), TweenService (ref)
                                    local TimeLength = Sound.TimeLength;
                                    local v114 = 0;

                                    while TimeLength <= 0 and v114 < 30 do
                                        task.wait(0.1);

                                        if not (Sound and Sound.Parent) then
                                            return;
                                        end;

                                        TimeLength = Sound.TimeLength;
                                        v114 = v114 + 1;
                                    end;

                                    if TimeLength < 1 then
                                        return;
                                    end;

                                    local v115 = TimeLength - 0.5;

                                    while Sound and (Sound.Parent and Sound.IsPlaying) do
                                        if v115 <= Sound.TimePosition then
                                            local v116 = math.max(0.05, TimeLength - Sound.TimePosition);
                                            TweenService:Create(Sound, TweenInfo.new(v116, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                                Volume = 0
                                            }):Play();

                                            return;
                                        end;

                                        task.wait(0.05);
                                    end;
                                end);
                                game:GetService("Debris"):AddItem(Sound, 7);
                            end;

                            task.spawn(function() -- Line: 994
                                -- upvalues: u9 (ref), u99 (ref), u26 (ref), identity2 (ref)
                                local v117 = Random.new();
                                local v118 = tick();

                                while tick() < v118 + 5 and (u9 and u99 == u26) do
                                    local v119 = (tick() - v118 - 3.75) / 1.25;
                                    local v120 = (1 - math.clamp(v119, 0, 1)) * 0.72;
                                    local v121 = CFrame.Angles(v117:NextNumber(-0.024, 0.024) * v120 * 3.5, v117:NextNumber(-0.028, 0.028) * v120 * 3.5, v117:NextNumber(-0.016, 0.016) * v120 * 3.5);
                                    identity2 = CFrame.new(v117:NextNumber(-1, 1) * v120 * 0.44, v117:NextNumber(-1, 1) * v120 * 0.36, v117:NextNumber(-1, 1) * v120 * 0.44) * v121;
                                    task.wait();
                                end;

                                identity2 = CFrame.identity;
                            end);
                        end);
                        v112:Play(0.5, 1, 1);
                        print("[NextuneBossRoom] Presentation: roar animation playing — waiting for \'Roar\' marker...");
                    else
                        v112 = nil;
                    end;

                    print("[NextuneBossRoom] Presentation: holding for", 5, "sec");
                    task.wait(5);
                    identity2 = CFrame.identity;

                    if v112 then
                        v112:Stop();
                    end;

                    setVfxEnabled(false);
                    u10 = nil;

                    for i = 2, #v102 do
                        print("[NextuneBossRoom] Presentation: tweening to cam index:", i);
                        local v122 = v102[i];
                        local v123 = TweenService:Create(CurrentCamera2, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                            CFrame = v122
                        });
                        v123:Play();
                        v123.Completed:Wait();
                    end;

                    local v124;

                    if u99 == u26 then
                        u26 = u26 + 1;
                        u9 = false;

                        for i, v in u31 do
                            if i and i.Parent then
                                i.Visible = v;
                            end;
                        end;

                        table.clear(u31);
                        v124 = true;
                    else
                        v124 = false;
                    end;

                    if v124 then
                        print("[NextuneBossRoom] Presentation: restoring camera");
                        CurrentCamera2.CameraType = Enum.CameraType.Custom;
                        local v125 = Players.LocalPlayer.Character and v125:FindFirstChildOfClass("Humanoid");

                        if v125 then
                            CurrentCamera2.CameraSubject = v125;
                        end;
                    end;

                    if u1 then
                        u1.Enabled = true;
                    end;
                end);

                return;
            end;

            if p96 == "PhaseChange" then
                local v126 = type(u97) == "table" and tonumber(u97.phase) or 1;
                u30 = v126;

                if u4 then
                    u4.Text = "PHASE " .. tostring(v126);
                end;

                local v127 = math.clamp(v126, 1, 3);
                applyPhaseMarkerStyle((math.floor(v127)));

                if v126 >= 3 then
                    applyPhase3BossBarStyle();
                end;

                playPhaseMusic(v126);
                local v128 = ({ 500, 2500, 10000 })[v126];

                if v128 then
                    local v129 = workspace:FindFirstChild("AdminAbuse") and v129:FindFirstChild("Map");
                    local v130;

                    if v129 then
                        v130 = v129:FindFirstChild("Scriptables", true);
                    else
                        v130 = v129;
                    end;

                    if v130 then
                        v130 = v130:FindFirstChild("GlitchFX");
                    end;

                    if v129 then
                        v129 = v129:FindFirstChild("BossRig", true);
                    end;

                    if v129 then
                        v129 = v129:FindFirstChild("GlitchFX");
                    end;

                    if v129 then
                        for _, descendant in v129:GetDescendants() do
                            if descendant:IsA("ParticleEmitter") then
                                descendant.Rate = v128;
                            end;
                        end;
                    end;

                    if v130 then
                        for _, descendant in v130:GetDescendants() do
                            if descendant:IsA("ParticleEmitter") then
                                descendant.Rate = v128;
                            end;
                        end;
                    end;
                end;
            else
                if p96 == "PhaseCutscene" then
                    local u131 = type(u97) == "table" and (tonumber(u97.phase) or 2) or 2;
                    local _ = type(u97) == "table" and tonumber(u97.duration);
                    local u132;

                    if type(u97) == "table" then
                        u132 = u97.shots;
                    else
                        u132 = false;
                    end;

                    task.spawn(function() -- Line: 1106
                        -- upvalues: u132 (copy), u131 (copy), u26 (ref), u9 (ref), hideTaggedUI (ref), u27 (ref), TweenService (ref), u10 (ref), identity2 (ref), u31 (ref), Players (ref)
                        if type(u132) ~= "table" or #u132 == 0 then
                            warn("[NextuneBossRoom] PhaseCutscene: no shot data received for Phase" .. tostring(u131));

                            return;
                        end;

                        local CurrentCamera2 = workspace.CurrentCamera;

                        if not CurrentCamera2 then
                            return;
                        end;

                        u26 = u26 + 1;

                        if not u9 then
                            hideTaggedUI();
                        end;

                        u9 = true;
                        local u133 = u26;
                        u27 = 0;
                        CurrentCamera2.CameraType = Enum.CameraType.Scriptable;
                        CurrentCamera2.CameraSubject = nil;

                        for _, v in ipairs(u132) do
                            local cf = v.cf;
                            local holdDuration = v.holdDuration;
                            local v134 = TweenService:Create(CurrentCamera2, TweenInfo.new(v.tweenDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                CFrame = cf
                            });
                            v134:Play();
                            v134.Completed:Wait();
                            u10 = cf;
                            local u135 = os.clock() + holdDuration;
                            local u136 = os.clock();
                            task.spawn(function() -- Line: 1138
                                -- upvalues: holdDuration (copy), u135 (copy), u9 (ref), u133 (copy), u26 (ref), u136 (copy), identity2 (ref)
                                local v137 = Random.new();
                                local v138 = math.max(holdDuration, 0.001);

                                while os.clock() < u135 and (u9 and u133 == u26) do
                                    local v139 = (os.clock() - u136 - v138 * 0.75) / (v138 * 0.25);
                                    local v140 = (1 - math.clamp(v139, 0, 1)) * 0.18;
                                    local v141 = CFrame.Angles(v137:NextNumber(-0.024, 0.024) * v140 * 3.5, v137:NextNumber(-0.028, 0.028) * v140 * 3.5, v137:NextNumber(-0.016, 0.016) * v140 * 3.5);
                                    identity2 = CFrame.new(v137:NextNumber(-1, 1) * v140 * 0.44, v137:NextNumber(-1, 1) * v140 * 0.36, v137:NextNumber(-1, 1) * v140 * 0.44) * v141;
                                    task.wait();
                                end;

                                identity2 = CFrame.identity;
                            end);
                            task.wait((math.max(0, holdDuration)));
                            u10 = nil;
                        end;

                        local v142;

                        if u133 == u26 then
                            u26 = u26 + 1;
                            u9 = false;

                            for i, v in u31 do
                                if i and i.Parent then
                                    i.Visible = v;
                                end;
                            end;

                            table.clear(u31);
                            v142 = true;
                        else
                            v142 = false;
                        end;

                        if v142 then
                            CurrentCamera2.CameraType = Enum.CameraType.Custom;
                            local v143 = Players.LocalPlayer.Character and v143:FindFirstChildOfClass("Humanoid");

                            if v143 then
                                CurrentCamera2.CameraSubject = v143;
                            end;
                        end;
                    end);

                    return;
                end;

                if p96 == "ScreenShake" then
                    if type(u97) ~= "table" then
                        return;
                    end;

                    local v144 = tonumber(u97.intensity) or 0.3;
                    local v145 = tonumber(u97.duration) or 0.5;

                    if u14 then
                        u14:ShakeOnce(v144, 8, 0.05, v145 * 0.85);
                    end;
                else
                    if p96 == "ZoneWarn" then
                        if type(u97) ~= "table" then
                            return;
                        end;

                        local function num(p146, p147) -- Line: 1189
                            -- upvalues: u97 (copy)
                            local v148 = u97[p146];

                            if type(v148) == "number" then
                                return v148;
                            end;

                            return p147;
                        end;

                        local x = u97.x;
                        local v149 = type(x) ~= "number" and 0 or x;
                        local y = u97.y;
                        local v150 = type(y) ~= "number" and 0 or y;
                        local z = u97.z;
                        local v151 = type(z) ~= "number" and 0 or z;
                        local v152 = Vector3.new(v149, v150, v151);
                        local hx = u97.hx;
                        local u153 = type(hx) ~= "number" and 9 or hx;
                        local hz = u97.hz;
                        local u154 = type(hz) ~= "number" and 9 or hz;
                        local t = u97.t;
                        local v155 = type(t) ~= "number" and 1.4 or t;
                        local v156 = ({ Color3.fromRGB(255, 152, 220), Color3.fromRGB(106, 57, 9) })[math.random(1, 2)];
                        local Part = Instance.new("Part");
                        Part.Name = "NexZoneWarnFx";
                        Part.Shape = Enum.PartType.Cylinder;
                        Part.Anchored = true;
                        Part.CanCollide = false;
                        Part.CanQuery = false;
                        Part.Material = Enum.Material.Neon;
                        Part.Color = v156;
                        Part.Transparency = 0.3;
                        Part.Size = Vector3.new(0.05, u153 * 2, u154 * 2);
                        Part.CFrame = CFrame.fromMatrix(v152 + Vector3.new(0, 2.5, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, -1));
                        local v157 = workspace:FindFirstChild("AdminAbuse") and v157:FindFirstChild("Map") and v157:FindFirstChild("Debris", true);
                        Part.Parent = v157 or workspace;
                        local u158 = TweenService:Create(Part, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                            Size = Vector3.new(3, u153 * 2, u154 * 2)
                        });
                        u158:Play();
                        u158.Completed:Connect(function() -- Line: 1226
                            -- upvalues: u158 (copy)
                            u158:Destroy();
                        end);
                        local u159 = TweenService:Create(Part, TweenInfo.new(0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                            Transparency = 0.72
                        });
                        task.delay(0.2, function() -- Line: 1233
                            -- upvalues: Part (copy), u159 (copy)
                            if Part.Parent then
                                u159:Play();
                            end;
                        end);
                        task.delay(math.max(0, v155 - 0.2), function() -- Line: 1238
                            -- upvalues: Part (copy), u159 (copy), TweenService (ref), u153 (copy), u154 (copy)
                            if not Part.Parent then
                                u159:Destroy();

                                return;
                            end;

                            u159:Cancel();
                            u159:Destroy();
                            local u160 = TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                Transparency = 1,
                                Size = Vector3.new(0.05, u153 * 2, u154 * 2)
                            });
                            local u161 = nil;
                            u161 = u160.Completed:Connect(function() -- Line: 1250
                                -- upvalues: u161 (ref), u160 (copy), Part (ref)
                                u161:Disconnect();
                                u160:Destroy();

                                if Part.Parent then
                                    Part:Destroy();
                                end;
                            end);
                            u160:Play();
                        end);

                        return;
                    end;

                    if p96 == "ZoneHit" then
                        if type(u97) ~= "table" then
                            return;
                        end;

                        local function _(p162, p163) -- Line: 1262
                            -- upvalues: u97 (copy)
                            local v164 = u97[p162];

                            if type(v164) == "number" then
                                return v164;
                            end;

                            return p163;
                        end;

                        local x = u97.x;
                        local v165 = type(x) ~= "number" and 0 or x;
                        local y = u97.y;
                        local v166 = type(y) ~= "number" and 0 or y;
                        local z = u97.z;
                        local v167 = type(z) ~= "number" and 0 or z;
                        local v168 = Vector3.new(v165, v166, v167);
                        local hx = u97.hx;
                        local v169 = type(hx) ~= "number" and 9 or hx;
                        local hz = u97.hz;
                        local v170 = type(hz) ~= "number" and 9 or hz;
                        local v171 = ({ Color3.fromRGB(255, 152, 220), Color3.fromRGB(106, 57, 9) })[math.random(1, 2)];
                        local Part = Instance.new("Part");
                        Part.Name = "NexZoneJetFx";
                        Part.Shape = Enum.PartType.Cylinder;
                        Part.Anchored = true;
                        Part.CanCollide = false;
                        Part.CanQuery = false;
                        Part.Material = Enum.Material.Neon;
                        Part.Color = v171;
                        Part.Transparency = 0.15;
                        Part.Size = Vector3.new(2, v169 * 1.6, v170 * 1.6);
                        Part.CFrame = CFrame.fromMatrix(v168 - Vector3.new(0, 4, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, -1));
                        local Sound = Instance.new("Sound");
                        Sound.SoundId = "rbxassetid://109344802985233";
                        Sound.Parent = Part;
                        local v172 = workspace:FindFirstChild("AdminAbuse") and v172:FindFirstChild("Map") and v172:FindFirstChild("Debris", true);
                        Part.Parent = v172 or workspace;
                        Sound:Play();
                        local u173 = TweenService:Create(Part, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = Vector3.new(160, v169 * 1.9, v170 * 1.9),
                            CFrame = CFrame.fromMatrix(v168 + Vector3.new(0, 76, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, -1))
                        });
                        u173:Play();
                        task.delay(0.35, function() -- Line: 1309
                            -- upvalues: u173 (copy), Part (copy), TweenService (ref)
                            u173:Destroy();

                            if not Part.Parent then
                                return;
                            end;

                            local u174 = TweenService:Create(Part, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                                Transparency = 1,
                                Size = Vector3.new(160, 0.1, 0.1)
                            });
                            local u175 = nil;
                            u175 = u174.Completed:Connect(function() -- Line: 1317
                                -- upvalues: u175 (ref), u174 (copy), Part (ref)
                                u175:Disconnect();
                                u174:Destroy();

                                if Part.Parent then
                                    Part:Destroy();
                                end;
                            end);
                            u174:Play();
                        end);
                        local Part2 = Instance.new("Part");
                        Part2.Name = "NexZonePopFx";
                        Part2.Anchored = true;
                        Part2.CanCollide = false;
                        Part2.CanQuery = false;
                        Part2.Material = Enum.Material.Neon;
                        Part2.Color = Color3.fromRGB(255, 152, 220);
                        Part2.Transparency = 0.4;
                        Part2.Size = Vector3.new(1, 0.5, 1);
                        Part2.CFrame = CFrame.new(v168 + Vector3.new(0, 0.25, 0));
                        local AdminAbuse = workspace:FindFirstChild("AdminAbuse");
                        local v176 = AdminAbuse and AdminAbuse:FindFirstChild("Map") and v176:FindFirstChild("Debris", true);
                        Part2.Parent = v176 or workspace;
                        local u177 = TweenService:Create(Part2, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Transparency = 1,
                            Size = Vector3.new(v169 * 2.8, 0.5, v170 * 2.8)
                        });
                        local u178 = nil;
                        u178 = u177.Completed:Connect(function() -- Line: 1342
                            -- upvalues: u178 (ref), u177 (copy), Part2 (copy)
                            u178:Disconnect();
                            u177:Destroy();

                            if Part2.Parent then
                                Part2:Destroy();
                            end;
                        end);
                        u177:Play();

                        return;
                    end;

                    if p96 == "Phase3Cutscene" then
                        local u179 = type(u97) == "table" and u97.shots or {};
                        local v180 = workspace:FindFirstChild("AdminAbuse") and v180:FindFirstChild("Map") and v180:FindFirstChild("BossRig", true);

                        if v180 and u33.SFX.Glitch ~= "rbxassetid://XXXXX" then
                            local Sound = Instance.new("Sound");
                            Sound.SoundId = u33.SFX.Glitch;
                            Sound.Volume = 10;
                            Sound.Parent = v180.PrimaryPart or v180;
                            local _ = Sound.Volume;
                            Sound:Play();
                            task.spawn(function() -- Line: 160
                                -- upvalues: Sound (copy), TweenService (ref)
                                local TimeLength = Sound.TimeLength;
                                local v181 = 0;

                                while TimeLength <= 0 and v181 < 30 do
                                    task.wait(0.1);

                                    if not (Sound and Sound.Parent) then
                                        return;
                                    end;

                                    TimeLength = Sound.TimeLength;
                                    v181 = v181 + 1;
                                end;

                                if TimeLength < 1 then
                                    return;
                                end;

                                local v182 = TimeLength - 0.5;

                                while Sound and (Sound.Parent and Sound.IsPlaying) do
                                    if v182 <= Sound.TimePosition then
                                        local v183 = math.max(0.05, TimeLength - Sound.TimePosition);
                                        TweenService:Create(Sound, TweenInfo.new(v183, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                            Volume = 0
                                        }):Play();

                                        return;
                                    end;

                                    task.wait(0.05);
                                end;
                            end);
                            Debris:AddItem(Sound, 10);
                        end;

                        task.spawn(function() -- Line: 1369
                            -- upvalues: u179 (copy), u26 (ref), u9 (ref), hideTaggedUI (ref), u27 (ref), u1 (ref), identity2 (ref), TweenService (ref), u10 (ref)
                            if type(u179) ~= "table" or #u179 == 0 then
                                warn("[NextuneBossRoom] Phase3Cutscene: no shot data received");

                                return;
                            end;

                            local CurrentCamera2 = workspace.CurrentCamera;

                            if not CurrentCamera2 then
                                return;
                            end;

                            u26 = u26 + 1;

                            if not u9 then
                                hideTaggedUI();
                            end;

                            u9 = true;
                            local u184 = u26;
                            u27 = u184;
                            CurrentCamera2.CameraType = Enum.CameraType.Scriptable;
                            CurrentCamera2.CameraSubject = nil;

                            if u1 then
                                u1.Enabled = false;
                            end;

                            task.spawn(function() -- Line: 1385
                                -- upvalues: u9 (ref), u184 (copy), u26 (ref), identity2 (ref)
                                local v185 = Random.new();

                                while u9 and u184 == u26 do
                                    identity2 = CFrame.new(v185:NextNumber(-1, 1) * 0.45 * 0.44, v185:NextNumber(-1, 1) * 0.45 * 0.36, v185:NextNumber(-1, 1) * 0.45 * 0.44) * CFrame.Angles(v185:NextNumber(-0.024, 0.024) * 0.45 * 3.5, v185:NextNumber(-0.028, 0.028) * 0.45 * 3.5, v185:NextNumber(-0.016, 0.016) * 0.45 * 3.5);
                                    task.wait();
                                end;

                                identity2 = CFrame.identity;
                            end);

                            for i, v in ipairs(u179) do
                                if not u9 or u184 ~= u26 then
                                    break;
                                end;

                                local cf = v.cf;
                                local holdDuration = v.holdDuration;
                                local u186 = i == #u179;
                                local v187 = TweenService:Create(CurrentCamera2, TweenInfo.new(v.tweenDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                    CFrame = cf
                                });
                                v187:Play();
                                v187.Completed:Wait();
                                v187:Destroy();
                                u10 = cf;
                                local u188 = os.clock() + holdDuration;
                                local u189 = os.clock();
                                task.spawn(function() -- Line: 1426
                                    -- upvalues: holdDuration (copy), u9 (ref), u184 (copy), u26 (ref), u186 (copy), u188 (copy), u189 (copy), identity2 (ref)
                                    local v190 = Random.new();
                                    local v191 = math.max(holdDuration, 0.001);

                                    while u9 and (u184 == u26 and (u186 or os.clock() < u188)) do
                                        local v192 = os.clock() - u189;
                                        local v193 = (u186 and 1 or 1 - math.clamp((v192 - v191 * 0.75) / (v191 * 0.25), 0, 1)) * 0.18;
                                        identity2 = CFrame.new(v190:NextNumber(-1, 1) * v193 * 0.44, v190:NextNumber(-1, 1) * v193 * 0.36, v190:NextNumber(-1, 1) * v193 * 0.44) * CFrame.Angles(v190:NextNumber(-0.024, 0.024) * v193 * 3.5, v190:NextNumber(-0.028, 0.028) * v193 * 3.5, v190:NextNumber(-0.016, 0.016) * v193 * 3.5);
                                        task.wait();
                                    end;

                                    identity2 = CFrame.identity;
                                end);

                                if u186 then
                                    while u9 and u184 == u26 do
                                        task.wait(0.1);
                                    end;
                                else
                                    task.wait((math.max(0, holdDuration)));
                                    u10 = nil;
                                end;
                            end;

                            if u184 == u26 then
                            end;
                        end);

                        return;
                    end;

                    if p96 == "Phase3CutsceneEnd" then
                        if u27 <= 0 then
                            return;
                        end;

                        if u27 > 0 then
                            local v194;

                            if u27 == u26 then
                                u26 = u26 + 1;
                                u9 = false;

                                for i, v in u31 do
                                    if i and i.Parent then
                                        i.Visible = v;
                                    end;
                                end;

                                table.clear(u31);
                                v194 = true;
                            else
                                v194 = false;
                            end;

                            if not v194 then
                                return;
                            end;
                        end;

                        u27 = 0;
                        u10 = nil;
                        identity2 = CFrame.identity;
                        local CurrentCamera2 = workspace.CurrentCamera;

                        if CurrentCamera2 then
                            CurrentCamera2.CameraType = Enum.CameraType.Custom;
                            local v195 = Players.LocalPlayer.Character and v195:FindFirstChildOfClass("Humanoid");

                            if v195 then
                                CurrentCamera2.CameraSubject = v195;
                            end;
                        end;

                        if u1 then
                            u1.Enabled = true;
                        end;
                    elseif p96 == "BossPulse" then
                        local u196 = u16 and u16:FindFirstChild("Frame");

                        if u196 then
                            if u97 then
                                u97 = u97.purple == true;
                            end;

                            local v197;

                            if u97 then
                                v197 = Color3.fromRGB(225, 20, 255);
                            else
                                v197 = u17 or u196.BackgroundColor3;
                            end;

                            local u198 = u17 or u196.BackgroundColor3;
                            local u199 = TweenService:Create(u196, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                BackgroundTransparency = 0.1,
                                BackgroundColor3 = v197
                            });
                            u199:Play();
                            u199.Completed:Once(function() -- Line: 1502
                                -- upvalues: u199 (copy), TweenService (ref), u196 (copy), u198 (copy)
                                u199:Destroy();
                                local u200 = TweenService:Create(u196, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                    BackgroundTransparency = 0.85,
                                    BackgroundColor3 = u198
                                });
                                u200:Play();
                                u200.Completed:Once(function() -- Line: 1509
                                    -- upvalues: u200 (copy)
                                    u200:Destroy();
                                end);
                            end);
                        end;
                    else
                        if p96 == "FinalCutscene" then
                            task.spawn(function() -- Line: 1514
                                -- upvalues: u1 (ref), u16 (ref), u15 (ref), Players (ref), TweenService (ref), u26 (ref), u9 (ref), hideTaggedUI (ref), u10 (ref), identity2 (ref), NextuneBossRoomAnimIds (ref), u33 (ref), Debris (ref), stopPhaseMusic (ref), showFakeAnnouncement (ref), u31 (ref), destroyUi (ref), showCredits (ref)
                                local CurrentCamera2 = workspace.CurrentCamera;

                                if not CurrentCamera2 then
                                    return;
                                end;

                                if u1 then
                                    u1.Enabled = false;
                                end;

                                if u16 then
                                    u16.Enabled = false;
                                end;

                                u15 = false;
                                local LocalPlayer = Players.LocalPlayer;
                                local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
                                local ScreenGui = Instance.new("ScreenGui");
                                ScreenGui.Name = "NextuneBossEndTransition";
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
                                TweenService:Create(Frame, TweenInfo.new(1.5), {
                                    BackgroundTransparency = 0
                                }):Play();
                                task.wait(1.5);
                                local u201 = workspace:FindFirstChild("AdminAbuse") and u201:FindFirstChild("Map") and u201:FindFirstChild("Scriptables", true);
                                local v202;

                                if u201 then
                                    v202 = u201:FindFirstChild("Cameras");
                                else
                                    v202 = u201;
                                end;

                                if v202 then
                                    v202 = v202:FindFirstChild("PhaseEnd");
                                end;

                                if u201 then
                                    u201 = u201:FindFirstChild("PhaseEnd");
                                end;

                                local v203;

                                if v202 then
                                    v203 = v202:FindFirstChild("1");
                                else
                                    v203 = v202;
                                end;

                                if v203 then
                                    u26 = u26 + 1;

                                    if not u9 then
                                        hideTaggedUI();
                                    end;

                                    u9 = true;
                                    CurrentCamera2.CameraType = Enum.CameraType.Scriptable;
                                    CurrentCamera2.CFrame = v203.CFrame;
                                    u10 = v203.CFrame;
                                end;

                                TweenService:Create(Frame, TweenInfo.new(1.5), {
                                    BackgroundTransparency = 1
                                }):Play();
                                task.wait(1.5);
                                local u204 = workspace:FindFirstChild("AdminAbuse") and u204:FindFirstChild("Map") and u204:FindFirstChild("BossRig", true);
                                local v205;

                                if u204 then
                                    v205 = u204:FindFirstChildOfClass("Humanoid");
                                else
                                    v205 = u204;
                                end;

                                local u206 = v205 and v205:FindFirstChildOfClass("Animator");

                                if not u206 then
                                    if u204 then
                                        u206 = u204:FindFirstChildOfClass("Animator");
                                    else
                                        u206 = u204;
                                    end;
                                end;

                                local v207;

                                if v202 then
                                    v207 = v202:FindFirstChild("2");
                                else
                                    v207 = v202;
                                end;

                                local v208;

                                if v202 then
                                    v208 = v202:FindFirstChild("3");
                                else
                                    v208 = v202;
                                end;

                                local u209 = os.clock();
                                local u210 = true;

                                if u201 then
                                    u201 = u201:FindFirstChild("VFX");
                                end;

                                if u201 then
                                    task.spawn(function() -- Line: 1587
                                        -- upvalues: u201 (copy)
                                        for _, child in u201:GetChildren() do
                                            if child:IsA("Model") then
                                                for _, descendant in child:GetDescendants() do
                                                    if descendant:IsA("ParticleEmitter") then
                                                        descendant.Enabled = true;
                                                    end;
                                                end;
                                            end;

                                            task.wait(0.1);
                                        end;
                                    end);
                                end;

                                task.spawn(function() -- Line: 1602
                                    -- upvalues: u210 (ref), u209 (copy), identity2 (ref)
                                    local v211 = Random.new();

                                    while u210 do
                                        local v212 = os.clock() - u209;
                                        local v213;

                                        if v212 < 10 then
                                            v213 = math.clamp(v212 / 10, 0, 1) * 0.5 + 0.1;
                                        else
                                            v213 = math.clamp((v212 - 10) / 2, 0, 1) * 0.4 + 0.6;
                                        end;

                                        identity2 = CFrame.new(v211:NextNumber(-1, 1) * v213 * 0.3, v211:NextNumber(-1, 1) * v213 * 0.25, v211:NextNumber(-1, 1) * v213 * 0.3) * CFrame.Angles(v211:NextNumber(-0.02, 0.02) * v213 * 2, v211:NextNumber(-0.02, 0.02) * v213 * 2, v211:NextNumber(-0.015, 0.015) * v213 * 2);
                                        task.wait();
                                    end;

                                    identity2 = CFrame.identity;
                                end);
                                task.spawn(function() -- Line: 1629
                                    -- upvalues: u206 (copy), NextuneBossRoomAnimIds (ref), u204 (copy), u33 (ref), u210 (ref), u209 (copy)
                                    local v214;

                                    if u206 then
                                        local Animation = Instance.new("Animation");
                                        Animation.AnimationId = NextuneBossRoomAnimIds.Glitch;
                                        v214 = u206:LoadAnimation(Animation);

                                        if v214 then
                                            v214.Priority = Enum.AnimationPriority.Action4;
                                            v214.Looped = true;
                                            v214:Play(0.2);
                                        end;
                                    else
                                        v214 = nil;
                                    end;

                                    local v215;

                                    if u204 and u33.SFX.Glitch ~= "rbxassetid://XXXXX" then
                                        v215 = Instance.new("Sound");
                                        v215.SoundId = u33.SFX.Glitch;
                                        v215.Volume = 10;
                                        v215.Looped = true;
                                        v215.Parent = u204.PrimaryPart or u204;
                                        v215:Play();
                                    else
                                        v215 = nil;
                                    end;

                                    while u210 do
                                        local v216 = (os.clock() - u209) / 12;
                                        local v217 = math.clamp(v216, 0, 1) * 3 + 1;

                                        if v214 then
                                            v214:AdjustSpeed(v217);
                                        end;

                                        if v215 then
                                            v215.PlaybackSpeed = v217;
                                        end;

                                        task.wait(0.05);
                                    end;

                                    if v214 then
                                        v214:Stop(0);
                                    end;

                                    if v215 then
                                        v215:Stop();
                                        v215:Destroy();
                                    end;
                                end);
                                task.wait(5);

                                if v207 then
                                    u10 = v207.CFrame;
                                    CurrentCamera2.CFrame = v207.CFrame;
                                end;

                                if v208 then
                                    u10 = nil;
                                    local v218 = TweenService:Create(CurrentCamera2, TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                                        CFrame = v208.CFrame
                                    });
                                    v218:Play();
                                    v218.Completed:Wait();
                                    v218:Destroy();
                                    u10 = v208.CFrame;
                                else
                                    task.wait(4);
                                end;

                                task.wait(2);

                                if u204 then
                                    local HumanoidRootPart = u204:FindFirstChild("HumanoidRootPart");
                                    local Sound = Instance.new("Sound");
                                    Sound.SoundId = u33.SFX.Explosion;
                                    Sound.Volume = 4;
                                    Sound.Parent = HumanoidRootPart or (u204.PrimaryPart or u204);
                                    Sound:Play();
                                    Debris:AddItem(Sound, 6);
                                end;

                                task.wait(1);
                                u210 = false;
                                stopPhaseMusic();
                                local v219 = workspace:FindFirstChild("AdminAbuse") and v219:FindFirstChild("Map") and v219:FindFirstChild("Scriptables", true) and v219:FindFirstChild("GlitchFX");

                                if v219 then
                                    v219:Destroy();
                                end;

                                task.wait(7);
                                TweenService:Create(Frame, TweenInfo.new(0.5), {
                                    BackgroundTransparency = 0
                                }):Play();
                                task.wait(0.5);
                                local v220;

                                if v202 then
                                    v220 = v202:FindFirstChild("4");
                                else
                                    v220 = v202;
                                end;

                                if v220 then
                                    CurrentCamera2.CFrame = v220.CFrame;
                                    u10 = v220.CFrame;
                                end;

                                TweenService:Create(Frame, TweenInfo.new(0.5), {
                                    BackgroundTransparency = 1
                                }):Play();
                                task.wait(0.5);
                                showFakeAnnouncement();
                                task.wait(2.5);

                                if v202 then
                                    v202 = v202:FindFirstChild("5");
                                end;

                                if v202 then
                                    u10 = nil;
                                    local v221 = TweenService:Create(CurrentCamera2, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                                        CFrame = v202.CFrame
                                    });
                                    v221:Play();
                                    v221.Completed:Wait();
                                    v221:Destroy();
                                    u10 = v202.CFrame;
                                    task.delay(0.5, function() -- Line: 1768
                                        -- upvalues: showFakeAnnouncement (ref)
                                        showFakeAnnouncement("It\'s your turn now.");
                                    end);
                                end;

                                task.wait(1.5);
                                TweenService:Create(Frame, TweenInfo.new(0.5), {
                                    BackgroundTransparency = 0
                                }):Play();
                                task.wait(10);

                                if ScreenGui then
                                    ScreenGui:Destroy();
                                end;

                                u26 = u26 + 1;
                                u9 = false;

                                for i, v in u31 do
                                    if i and i.Parent then
                                        i.Visible = v;
                                    end;
                                end;

                                table.clear(u31);
                                destroyUi();
                                CurrentCamera2.CameraType = Enum.CameraType.Custom;
                                local v222 = LocalPlayer.Character and v222:FindFirstChildOfClass("Humanoid");

                                if v222 then
                                    CurrentCamera2.CameraSubject = v222;
                                end;

                                showCredits();
                            end);

                            return;
                        end;

                        print("[NextuneBossRoom] fxRemote: unhandled cmd:", p96);
                    end;
                end;
            end;
        end;
    end);
    RunService:BindToRenderStep("NextuneCinematicLock", Enum.RenderPriority.Camera.Value + 2, function() -- Line: 1799
        -- upvalues: u9 (ref), u10 (ref), identity2 (ref), identity (ref)
        if not u9 then
            return;
        end;

        local CurrentCamera = workspace.CurrentCamera;

        if not CurrentCamera then
            return;
        end;

        if CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
            CurrentCamera.CameraType = Enum.CameraType.Scriptable;
        end;

        if u10 then
            CurrentCamera.CFrame = u10 * identity2 * identity;
        end;
    end);

    if u14 then
        u14:Stop();
    end;

    u14 = camerashaker.new(Enum.RenderPriority.Camera.Value + 1, function(p223) -- Line: 1819
        -- upvalues: identity (ref)
        identity = p223;
    end);
    u14:Start();
end;

function u33.Fire(p224, p225) -- Line: 1827
    -- upvalues: u15 (ref), destroyUi (copy), u8 (ref), u14 (ref), u26 (ref), u9 (ref), u31 (copy), u27 (ref), u10 (ref), identity (ref), identity2 (ref), RunService (copy), buildUi (copy), setupCutsceneListener (copy), Remotes (copy), u7 (ref), onBossHpSync (copy), preloadAssets (copy), u30 (ref), playPhaseMusic (copy), u33 (copy), TweenService (copy), setVfxEnabled (copy), NextuneBossRoomAnimIds (copy)
    u15 = false;
    destroyUi();

    if u8 then
        u8:Disconnect();
        u8 = nil;
    end;

    if u14 then
        u14:Stop();
        u14 = nil;
    end;

    u26 = u26 + 1;
    u9 = false;

    for i, v in u31 do
        if i and i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(u31);
    u27 = 0;
    u10 = nil;
    identity = CFrame.identity;
    identity2 = CFrame.identity;
    RunService:UnbindFromRenderStep("NextuneCinematicLock");
    buildUi();
    setupCutsceneListener();
    local AdminAbuseBossSync = Remotes:FindFirstChild("AdminAbuseBossSync");

    if AdminAbuseBossSync and AdminAbuseBossSync:IsA("RemoteEvent") then
        u7 = AdminAbuseBossSync.OnClientEvent:Connect(function(p226, p227, p228) -- Line: 1837
            -- upvalues: onBossHpSync (ref)
            onBossHpSync(p226, p227, p228);
        end);
    end;

    preloadAssets();
    u30 = 1;
    playPhaseMusic(1);
    u15 = true;
    task.spawn(function() -- Line: 1852
        -- upvalues: u15 (ref), u9 (ref), u30 (ref), u33 (ref), TweenService (ref), setVfxEnabled (ref), NextuneBossRoomAnimIds (ref)
        local v229 = Random.new();

        while u15 do
            task.wait(v229:NextNumber(15, 35));

            if u15 and not u9 then
                local v230 = workspace:FindFirstChild("AdminAbuse") and v230:FindFirstChild("Map") and v230:FindFirstChild("BossRig", true);

                if v230 then
                    local v231 = v230:FindFirstChildOfClass("Humanoid");
                    local v232 = v231 and v231:FindFirstChildOfClass("Animator") or v230:FindFirstChildOfClass("Animator");

                    if v232 then
                        local v233 = v229:NextNumber();
                        local v234;

                        if u30 >= 2 then
                            v234 = v233 < 0.3 and "Roar" or (v233 < 0.7 and "Laugh" or "Glitch");
                        else
                            v234 = v233 < 0.4 and "Roar" or "Laugh";
                        end;

                        if v234 == "Roar" then
                            local Animation = Instance.new("Animation");
                            Animation.AnimationId = u33.BossAnimations.Roar;
                            local v235 = v232:LoadAnimation(Animation);
                            v235.Priority = Enum.AnimationPriority.Action;
                            local v236;

                            if u33.SFX.Roar == "rbxassetid://XXXXXXX" then
                                v236 = nil;
                            else
                                v236 = Instance.new("Sound");
                                v236.SoundId = u33.SFX.Roar;
                                v236.Volume = 2.2;
                                v236.Parent = v230.PrimaryPart or v230;
                                local u237 = v236;
                                local _ = u237.Volume;
                                u237:Play();
                                task.spawn(function() -- Line: 160
                                    -- upvalues: u237 (copy), TweenService (ref)
                                    local TimeLength = u237.TimeLength;
                                    local v238 = 0;

                                    while TimeLength <= 0 and v238 < 30 do
                                        task.wait(0.1);

                                        if not (u237 and u237.Parent) then
                                            return;
                                        end;

                                        TimeLength = u237.TimeLength;
                                        v238 = v238 + 1;
                                    end;

                                    if TimeLength < 1 then
                                        return;
                                    end;

                                    local v239 = TimeLength - 0.5;

                                    while u237 and (u237.Parent and u237.IsPlaying) do
                                        if v239 <= u237.TimePosition then
                                            local v240 = math.max(0.05, TimeLength - u237.TimePosition);
                                            TweenService:Create(u237, TweenInfo.new(v240, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                                Volume = 0
                                            }):Play();

                                            return;
                                        end;

                                        task.wait(0.05);
                                    end;
                                end);
                                game:GetService("Debris"):AddItem(v236, 8);
                            end;

                            setVfxEnabled(true);
                            v235:Play(0.5);
                            local v241 = 0;
                            local v242;

                            if v236 then
                                v242 = 4.5;
                            else
                                v242 = 3;
                            end;

                            repeat
                                v241 = v241 + task.wait(0.1);
                            until v242 <= v241 or (not u15 or u9);

                            v235:Stop(0.6);
                            setVfxEnabled(false);
                        elseif v234 == "Glitch" then
                            local Animation = Instance.new("Animation");
                            Animation.AnimationId = NextuneBossRoomAnimIds.Glitch;
                            local v243 = v232:LoadAnimation(Animation);
                            v243.Priority = Enum.AnimationPriority.Action;
                            v243:Play(0.3);

                            if u33.SFX.Glitch ~= "rbxassetid://XXXXX" then
                                local Sound = Instance.new("Sound");
                                Sound.SoundId = u33.SFX.Glitch;
                                Sound.Volume = 1.5;
                                Sound.Parent = v230.PrimaryPart or v230;
                                local u244 = Sound;
                                local _ = u244.Volume;
                                u244:Play();
                                task.spawn(function() -- Line: 160
                                    -- upvalues: u244 (copy), TweenService (ref)
                                    local TimeLength = u244.TimeLength;
                                    local v245 = 0;

                                    while TimeLength <= 0 and v245 < 30 do
                                        task.wait(0.1);

                                        if not (u244 and u244.Parent) then
                                            return;
                                        end;

                                        TimeLength = u244.TimeLength;
                                        v245 = v245 + 1;
                                    end;

                                    if TimeLength < 1 then
                                        return;
                                    end;

                                    local v246 = TimeLength - 0.5;

                                    while u244 and (u244.Parent and u244.IsPlaying) do
                                        if v246 <= u244.TimePosition then
                                            local v247 = math.max(0.05, TimeLength - u244.TimePosition);
                                            TweenService:Create(u244, TweenInfo.new(v247, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                                Volume = 0
                                            }):Play();

                                            return;
                                        end;

                                        task.wait(0.05);
                                    end;
                                end);
                                game:GetService("Debris"):AddItem(Sound, 8);
                            end;

                            local v248 = 0;
                            local v249;

                            if v243.Length > 0 then
                                v249 = v243.Length;
                            else
                                v249 = 3;
                            end;

                            repeat
                                v248 = v248 + task.wait(0.1);
                            until v249 <= v248 or (not u15 or u9);

                            v243:Stop(0.4);
                        else
                            local Animation = Instance.new("Animation");
                            Animation.AnimationId = u33.BossAnimations.Laugh;
                            local v250 = v232:LoadAnimation(Animation);
                            v250.Looped = true;
                            v250.Priority = Enum.AnimationPriority.Action;
                            v250:Play(0.5);

                            if u33.SFX.Laugh == "rbxassetid://XXXXXXX" then
                                local v251 = 0;

                                repeat
                                    v251 = v251 + task.wait(0.1);
                                until (v250.Length <= 0 and 4 or v250.Length) <= v251 or (not u15 or u9);
                            else
                                local Sound = Instance.new("Sound");
                                Sound.SoundId = u33.SFX.Laugh;
                                Sound.Volume = 1.5;
                                Sound.Parent = v230.PrimaryPart or v230;
                                local _ = Sound.Volume;
                                Sound:Play();
                                task.spawn(function() -- Line: 160
                                    -- upvalues: Sound (copy), TweenService (ref)
                                    local TimeLength = Sound.TimeLength;
                                    local v252 = 0;

                                    while TimeLength <= 0 and v252 < 30 do
                                        task.wait(0.1);

                                        if not (Sound and Sound.Parent) then
                                            return;
                                        end;

                                        TimeLength = Sound.TimeLength;
                                        v252 = v252 + 1;
                                    end;

                                    if TimeLength < 1 then
                                        return;
                                    end;

                                    local v253 = TimeLength - 0.5;

                                    while Sound and (Sound.Parent and Sound.IsPlaying) do
                                        if v253 <= Sound.TimePosition then
                                            local v254 = math.max(0.05, TimeLength - Sound.TimePosition);
                                            TweenService:Create(Sound, TweenInfo.new(v254, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                                Volume = 0
                                            }):Play();

                                            return;
                                        end;

                                        task.wait(0.05);
                                    end;
                                end);
                                local u255 = false;
                                local v256 = Sound.Ended:Connect(function() -- Line: 1958
                                    -- upvalues: u255 (ref)
                                    u255 = true;
                                end);
                                local v257 = 0;

                                repeat
                                    v257 = v257 + task.wait(0.1);
                                until u255 or (not u15 or (u9 or v257 > 15));

                                v256:Disconnect();
                                Sound:Stop();
                                game:GetService("Debris"):AddItem(Sound, 1);
                            end;

                            v250:Stop(0.5);
                        end;
                    end;
                end;
            end;
        end;
    end);
end;

function u33.Stop(p258) -- Line: 1980
    -- upvalues: u15 (ref), destroyUi (copy), u8 (ref), u14 (ref), u26 (ref), u9 (ref), u31 (copy), u27 (ref), u10 (ref), identity (ref), identity2 (ref), RunService (copy)
    u15 = false;
    destroyUi();

    if u8 then
        u8:Disconnect();
        u8 = nil;
    end;

    if u14 then
        u14:Stop();
        u14 = nil;
    end;

    u26 = u26 + 1;
    u9 = false;

    for i, v in u31 do
        if i and i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(u31);
    u27 = 0;
    u10 = nil;
    identity = CFrame.identity;
    identity2 = CFrame.identity;
    RunService:UnbindFromRenderStep("NextuneCinematicLock");
end;

function u33.SyncBossBarToPlayer(p259, p260) -- Line: 1986
end;

return u33;