-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.LuckymatBossRoom
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Debris = game:GetService("Debris");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = nil;
local u2 = nil;
local u3 = nil;
local LuckymatConfig = require(script.LuckymatConfig);
local LuckymatCutscenes = require(script.LuckymatCutscenes);
local SoundManager = require(ReplicatedStorage:WaitForChild("SoundManager"));
local BossClientBase = require(ReplicatedStorage.AdminAbuse.Modules.Shared:WaitForChild("BossClientBase"));
local FakeAdminMessageUtil = require(ReplicatedStorage.Utilities.FakeAdminMessageUtil);
local LuckymatBossRoom = ReplicatedStorage.AdminAbuse.LuckymatBossRoom;
local Assets = LuckymatBossRoom.Assets;
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = nil;
local u8 = nil;
local u9 = 1;
local u10 = 0;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;

local function posKey(p20, p21, p22) -- Line: 61
    return string.format("%.1f_%.1f_%.1f", p20, p21, p22);
end;

local function ensureNotificationSystem() -- Line: 65
    -- upvalues: u1 (ref), ReplicatedStorage (copy)
    if not u1 then
        u1 = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
    end;
end;

local function ensureClientState() -- Line: 71
    -- upvalues: u2 (ref), ReplicatedStorage (copy)
    if not u2 then
        u2 = require(ReplicatedStorage:WaitForChild("ClientState"));
    end;
end;

local function ensureConfig() -- Line: 77
    -- upvalues: u3 (ref), ReplicatedStorage (copy)
    if not u3 then
        u3 = require(ReplicatedStorage:WaitForChild("Config"));
    end;
end;

local function getPlayerBaseSpeed() -- Line: 83
    -- upvalues: u2 (ref), ReplicatedStorage (copy), u3 (ref)
    if not u2 then
        u2 = require(ReplicatedStorage:WaitForChild("ClientState"));
    end;

    if not u3 then
        u3 = require(ReplicatedStorage:WaitForChild("Config"));
    end;

    local v23 = u2:Get();

    if v23.CustomWalkSpeed and v23.CustomWalkSpeed > 0 then
        return v23.CustomWalkSpeed;
    end;

    return u3.CalculateMaxSpeed(v23.Level or 1);
end;

local function stopKingSlowEnforcer() -- Line: 93
    -- upvalues: u11 (ref), u9 (ref), u10 (ref)
    if u11 then
        u11:Disconnect();
        u11 = nil;
    end;

    u9 = 1;
    u10 = 0;
end;

local function ensureKingSlowEnforcer() -- Line: 102
    -- upvalues: u11 (ref), RunService (copy), u10 (ref), u9 (ref), Players (copy), u2 (ref), ReplicatedStorage (copy), u3 (ref)
    if u11 then
        return;
    end;

    u11 = RunService.RenderStepped:Connect(function() -- Line: 104
        -- upvalues: u10 (ref), u9 (ref), Players (ref), u2 (ref), ReplicatedStorage (ref), u3 (ref)
        if u10 <= os.clock() then
            u9 = 1;

            return;
        end;

        if u9 >= 1 then
            return;
        end;

        local LocalPlayer = Players.LocalPlayer;
        local v24 = LocalPlayer:GetAttribute("LuckymatKingSlowMult");
        local v25 = LocalPlayer:GetAttribute("LuckymatKingSlowUntil");

        if type(v24) ~= "number" or (type(v25) ~= "number" or v25 <= os.clock()) then
            u9 = 1;

            return;
        end;

        u9 = v24;
        local v26 = LocalPlayer.Character and v26:FindFirstChildOfClass("Humanoid");

        if v26 then
            if not u2 then
                u2 = require(ReplicatedStorage:WaitForChild("ClientState"));
            end;

            if not u3 then
                u3 = require(ReplicatedStorage:WaitForChild("Config"));
            end;

            local v27 = u2:Get();
            local v28;

            if v27.CustomWalkSpeed and v27.CustomWalkSpeed > 0 then
                v28 = v27.CustomWalkSpeed;
            else
                v28 = u3.CalculateMaxSpeed(v27.Level or 1);
            end;

            v26.WalkSpeed = v28 * u9;
        end;
    end);
end;

local function applyKingSlowDebuff(p29, p30) -- Line: 128
    -- upvalues: u9 (ref), u10 (ref), u11 (ref), RunService (copy), Players (copy), u2 (ref), ReplicatedStorage (copy), u3 (ref)
    u9 = 1 - (p29 or 0.45);
    u10 = os.clock() + (p30 or 3.5);

    if not u11 then
        u11 = RunService.RenderStepped:Connect(function() -- Line: 104
            -- upvalues: u10 (ref), u9 (ref), Players (ref), u2 (ref), ReplicatedStorage (ref), u3 (ref)
            if u10 <= os.clock() then
                u9 = 1;

                return;
            end;

            if u9 >= 1 then
                return;
            end;

            local LocalPlayer = Players.LocalPlayer;
            local v31 = LocalPlayer:GetAttribute("LuckymatKingSlowMult");
            local v32 = LocalPlayer:GetAttribute("LuckymatKingSlowUntil");

            if type(v31) ~= "number" or (type(v32) ~= "number" or v32 <= os.clock()) then
                u9 = 1;

                return;
            end;

            u9 = v31;
            local v33 = LocalPlayer.Character and v33:FindFirstChildOfClass("Humanoid");

            if v33 then
                if not u2 then
                    u2 = require(ReplicatedStorage:WaitForChild("ClientState"));
                end;

                if not u3 then
                    u3 = require(ReplicatedStorage:WaitForChild("Config"));
                end;

                local v34 = u2:Get();
                local v35;

                if v34.CustomWalkSpeed and v34.CustomWalkSpeed > 0 then
                    v35 = v34.CustomWalkSpeed;
                else
                    v35 = u3.CalculateMaxSpeed(v34.Level or 1);
                end;

                v33.WalkSpeed = v35 * u9;
            end;
        end);
    end;

    local v36 = Players.LocalPlayer.Character and v36:FindFirstChildOfClass("Humanoid");

    if v36 then
        if not u2 then
            u2 = require(ReplicatedStorage:WaitForChild("ClientState"));
        end;

        if not u3 then
            u3 = require(ReplicatedStorage:WaitForChild("Config"));
        end;

        local v37 = u2:Get();
        local v38;

        if v37.CustomWalkSpeed and v37.CustomWalkSpeed > 0 then
            v38 = v37.CustomWalkSpeed;
        else
            v38 = u3.CalculateMaxSpeed(v37.Level or 1);
        end;

        v36.WalkSpeed = v38 * u9;
    end;
end;

local function screenShakeNearby(p39, p40, p41, p42) -- Line: 141
    -- upvalues: Players (copy), RunService (copy)
    local Character = Players.LocalPlayer.Character;

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local Magnitude = (HumanoidRootPart.Position - Vector3.new(p39, p40, p41)).Magnitude;

    if p42 * 3 < Magnitude then
        return;
    end;

    local u43 = math.clamp(1 - Magnitude / (p42 * 3), 0.1, 1) * 0.6;
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local u44 = 0;
    local u45 = nil;
    u45 = RunService.RenderStepped:Connect(function(p46) -- Line: 156
        -- upvalues: u44 (ref), u45 (ref), u43 (copy), CurrentCamera (copy)
        u44 = u44 + p46;

        if u44 >= 0.4 then
            u45:Disconnect();

            return;
        end;

        local v47 = u43 * (1 - u44 / 0.4);
        CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new((math.random() * 2 - 1) * v47, (math.random() * 2 - 1) * v47, 0);
    end);
end;

local function _(p48, p49, p50) -- Line: 172
    return string.format("%.1f_%.1f_%.1f", p48, p49, p50);
end;

local function setLaserBetween(p51, p52, p53, p54, p55) -- Line: 176
    local v56 = p53 - p52;
    local Magnitude = v56.Magnitude;

    if Magnitude < 0.05 then
        p51.Transparency = 1;

        return;
    end;

    p51.Transparency = 0;
    p51.Size = Vector3.new(p54, p54, Magnitude);
    p51.Color = p55;
    p51.CFrame = CFrame.lookAt(p52 + v56 * 0.5, p53);
end;

local function findNpcModel(p57) -- Line: 189
    -- upvalues: CollectionService (copy)
    if not p57 then
        return nil;
    end;

    for _, v in CollectionService:GetTagged("AABossNpc") do
        if v.Name == p57 then
            return v;
        end;
    end;

    return nil;
end;

local function findNpcRoot(p58) -- Line: 199
    -- upvalues: CollectionService (copy)
    if p58 then
        for _, v in CollectionService:GetTagged("AABossNpc") do
            if v.Name == p58 then
                break;
            end;
        end;
    else
        local v = nil;
    end;

    if v then
        return v:FindFirstChild("HumanoidRootPart");
    end;

    return nil;
end;

local function fxPlaySound(p59) -- Line: 207
    -- upvalues: Players (copy), Debris (copy)
    local id = p59.id;

    if type(id) ~= "string" or id == "" then
        return;
    end;

    local v60 = p59.vol or 1;
    local v61 = p59.pitch or 1;
    local v62 = p59.global == true;
    local Sound = Instance.new("Sound");
    Sound.SoundId = id;
    Sound.Volume = v60;
    Sound.PlaybackSpeed = v61;

    if v62 then
        Sound.Parent = Players.LocalPlayer or workspace;
    else
        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.Transparency = 1;
        Part.Position = Vector3.new(p59.x or 0, p59.y or 0, p59.z or 0);
        Part.Parent = workspace;

        if p59.minDist then
            Sound.RollOffMinDistance = p59.minDist;
        end;

        if p59.maxDist then
            Sound.RollOffMaxDistance = p59.maxDist;
        end;

        Sound.Parent = Part;
        Sound.Ended:Once(function() -- Line: 233
            -- upvalues: Part (copy)
            pcall(function() -- Line: 234
                -- upvalues: Part (ref)
                Part:Destroy();
            end);
        end);
        Debris:AddItem(Part, 12);
    end;

    Sound:Play();
    Debris:AddItem(Sound, 12);
end;

local function playSpatialSound(p63, p64, p65, p66, p67, p68) -- Line: 243
    -- upvalues: fxPlaySound (copy)
    fxPlaySound({
        id = p64,
        x = p63.X,
        y = p63.Y,
        z = p63.Z,
        vol = p65 or 1,
        minDist = p66 or 20,
        maxDist = p67 or 700,
        pitch = p68 or 1
    });
end;

local function fxNpcHitBlink(p69, p70) -- Line: 263
    -- upvalues: CollectionService (copy), fxPlaySound (copy), TweenService (copy)
    local npcId = p69.npcId;

    if npcId then
        for _, v in CollectionService:GetTagged("AABossNpc") do
            if v.Name == npcId then
                break;
            end;
        end;
    else
        local v = nil;
    end;

    if not (v and v.Parent) then
        return;
    end;

    local HumanoidRootPart = v:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        if p70 then
            local Position = HumanoidRootPart.Position;
            fxPlaySound({
                id = "rbxassetid://139520673393967",
                vol = 1,
                minDist = 20,
                maxDist = 700,
                pitch = 1,
                x = Position.X,
                y = Position.Y,
                z = Position.Z
            });
        else
            local Position = HumanoidRootPart.Position;
            fxPlaySound({
                id = "rbxassetid://136811265205147",
                vol = 0.75,
                minDist = 20,
                maxDist = 700,
                pitch = 1,
                x = Position.X,
                y = Position.Y,
                z = Position.Z
            });
        end;
    end;

    local LuckymatHitFlash = v:FindFirstChild("LuckymatHitFlash");

    if not (LuckymatHitFlash and LuckymatHitFlash:IsA("Highlight")) then
        LuckymatHitFlash = Instance.new("Highlight");
        LuckymatHitFlash.Name = "LuckymatHitFlash";
        LuckymatHitFlash.FillColor = Color3.fromRGB(255, 75, 75);
        LuckymatHitFlash.OutlineTransparency = 1;
        LuckymatHitFlash.Parent = v;
    end;

    LuckymatHitFlash.FillTransparency = 0.5;
    TweenService:Create(LuckymatHitFlash, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        FillTransparency = 1
    }):Play();
end;

local function fxSniperAim(u71) -- Line: 294
    -- upvalues: CollectionService (copy), fxPlaySound (copy), RunService (copy), Players (copy), TweenService (copy)
    task.spawn(function() -- Line: 295
        -- upvalues: u71 (copy), CollectionService (ref), fxPlaySound (ref), RunService (ref), Players (ref), TweenService (ref)
        local npcId = u71.npcId;
        local userId = u71.userId;
        local v72 = u71.trackSec or 1;
        local v73 = u71.lockSec or 0.2;

        if npcId then
            for _, v in CollectionService:GetTagged("AABossNpc") do
                if v.Name == npcId then
                    break;
                end;
            end;
        else
            local v = nil;
        end;

        local v74;

        if v then
            v74 = v:FindFirstChild("HumanoidRootPart");
        else
            v74 = nil;
        end;

        if v74 then
            local Position = v74.Position;
            fxPlaySound({
                id = "rbxassetid://100381484858434",
                vol = 1,
                minDist = 20,
                maxDist = 700,
                pitch = 1,
                x = Position.X,
                y = Position.Y,
                z = Position.Z
            });
        end;

        local Part = Instance.new("Part");
        Part.Name = "SniperAimLaser";
        Part.Material = Enum.Material.Neon;
        Part.Color = Color3.fromRGB(255, 50, 50);
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CastShadow = false;
        Part.Parent = workspace;
        local v75 = 0;
        local v76 = nil;

        while true do
            if v75 >= v72 or not Part.Parent then
                if not (Part.Parent and v76) then
                    pcall(function() -- Line: 335
                        -- upvalues: Part (copy)
                        Part:Destroy();
                    end);

                    return;
                end;

                local v77 = 0;

                while true do
                    if v77 >= v73 or not Part.Parent then
                        TweenService:Create(Part, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {
                            Transparency = 1
                        }):Play();
                        task.delay(0.1, function() -- Line: 358
                            -- upvalues: Part (copy)
                            pcall(function() -- Line: 359
                                -- upvalues: Part (ref)
                                Part:Destroy();
                            end);
                        end);

                        return;
                    end;

                    v77 = v77 + RunService.Heartbeat:Wait();

                    if npcId then
                        for _, v in CollectionService:GetTagged("AABossNpc") do
                            if v.Name == npcId then
                                break;
                            end;
                        end;
                    else
                        local v = nil;
                    end;

                    local v78;

                    if v then
                        v78 = v:FindFirstChild("HumanoidRootPart");
                    else
                        v78 = nil;
                    end;

                    if v78 then
                        local v79 = math.sin(v77 * 40) * 0.06 + 0.22;
                        local Position = v78.Position;
                        local v80 = Color3.fromRGB(255, 164, 164);
                        local v81 = v76 - Position;
                        local Magnitude = v81.Magnitude;

                        if Magnitude < 0.05 then
                            Part.Transparency = 1;
                        else
                            Part.Transparency = 0;
                            Part.Size = Vector3.new(v79, v79, Magnitude);
                            Part.Color = v80;
                            Part.CFrame = CFrame.lookAt(Position + v81 * 0.5, v76);
                        end;
                    end;
                end;
            end;

            v75 = v75 + RunService.Heartbeat:Wait();

            if npcId then
                for _, v in CollectionService:GetTagged("AABossNpc") do
                    if v.Name == npcId then
                        break;
                    end;
                end;
            else
                local v = nil;
            end;

            local v82;

            if v then
                v82 = v:FindFirstChild("HumanoidRootPart");
            else
                v82 = nil;
            end;

            local v83 = Players:GetPlayerByUserId(userId);
            local v84 = v83 and v83.Character and v83.Character:FindFirstChild("HumanoidRootPart");

            if v82 and v84 then
                v76 = v84.Position;
                local Position = v82.Position;
                local v85 = Color3.fromRGB(255, 60, 60);
                local v86 = v76 - Position;
                local Magnitude = v86.Magnitude;

                if Magnitude < 0.05 then
                    Part.Transparency = 1;
                else
                    Part.Transparency = 0;
                    Part.Size = Vector3.new(0.22, 0.22, Magnitude);
                    Part.Color = v85;
                    Part.CFrame = CFrame.lookAt(Position + v86 * 0.5, v76);
                end;
            end;
        end;
    end);
end;

local function tweenFireballArc(u87, u88, u89, u90) -- Line: 365
    -- upvalues: RunService (copy)
    local v91 = math.clamp((u88 - u89).Magnitude * 0.42, 14, 48);
    local u92 = (u88 + u89) * 0.5 + Vector3.new(0, v91, 0);
    local u93 = 0;
    local u94 = nil;
    u94 = RunService.RenderStepped:Connect(function(p95) -- Line: 375
        -- upvalues: u93 (ref), u90 (copy), u88 (copy), u92 (copy), u89 (copy), u87 (copy), u94 (ref)
        u93 = u93 + p95;
        local v96 = math.clamp(u93 / u90, 0, 1);
        local v97 = 1 - v96;
        u87.CFrame = CFrame.new(v97 * v97 * u88 + v97 * 2 * v96 * u92 + v96 * v96 * u89);

        if v96 >= 1 then
            u94:Disconnect();
        end;
    end);
end;

local function fxKingFireballArc(u98) -- Line: 387
    -- upvalues: u6 (copy), fxPlaySound (copy), RunService (copy)
    task.spawn(function() -- Line: 388
        -- upvalues: u98 (copy), u6 (ref), fxPlaySound (ref), RunService (ref)
        local u99 = Vector3.new(u98.px or 0, u98.py or 0, u98.pz or 0);
        local u100 = Vector3.new(u98.gx or 0, u98.gy or 0, u98.gz or 0);
        local u101 = u98.travelSec or 1;
        local Part = Instance.new("Part");
        Part.Shape = Enum.PartType.Ball;
        Part.Size = Vector3.new(9.6, 9.6, 9.6);
        Part.CFrame = CFrame.new(u99);
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CastShadow = false;
        Part.Material = Enum.Material.Neon;
        Part.Color = Color3.fromRGB(255, 100, 20);
        Part.Transparency = 0;
        Part.Parent = workspace;
        table.insert(u6, Part);
        local PointLight = Instance.new("PointLight", Part);
        PointLight.Brightness = 8;
        PointLight.Color = Color3.fromRGB(255, 120, 40);
        PointLight.Range = 44;
        local Fire = Instance.new("Fire");
        Fire.Size = 14;
        Fire.Parent = Part;
        fxPlaySound({
            id = "rbxassetid://80624479410185",
            vol = 0.85,
            minDist = 20,
            maxDist = 700,
            pitch = 1,
            x = u99.X,
            y = u99.Y,
            z = u99.Z
        });
        local v102 = math.clamp((u99 - u100).Magnitude * 0.42, 14, 48);
        local u103 = (u99 + u100) * 0.5 + Vector3.new(0, v102, 0);
        local u104 = 0;
        local u105 = nil;
        u105 = RunService.RenderStepped:Connect(function(p106) -- Line: 375
            -- upvalues: u104 (ref), u101 (copy), u99 (copy), u103 (copy), u100 (copy), Part (copy), u105 (ref)
            u104 = u104 + p106;
            local v107 = math.clamp(u104 / u101, 0, 1);
            local v108 = 1 - v107;
            Part.CFrame = CFrame.new(v108 * v108 * u99 + v108 * 2 * v107 * u103 + v107 * v107 * u100);

            if v107 >= 1 then
                u105:Disconnect();
            end;
        end);
        task.wait(u101);
        local v109 = table.find(u6, Part);

        if v109 then
            table.remove(u6, v109);
        end;

        pcall(function() -- Line: 421
            -- upvalues: Part (copy)
            Part:Destroy();
        end);
    end);
end;

local function fxKingThunderStormStart(p110) -- Line: 425
    -- upvalues: Lighting (copy), TweenService (copy)
    local v111 = p110.duration or 1.5;
    local KingThunderCC = Lighting:FindFirstChild("KingThunderCC");

    if not KingThunderCC then
        KingThunderCC = Instance.new("ColorCorrectionEffect");
        KingThunderCC.Name = "KingThunderCC";
        KingThunderCC.Parent = Lighting;
    end;

    TweenService:Create(KingThunderCC, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Saturation = -0.35,
        Contrast = 0.22,
        Brightness = 0.05,
        TintColor = Color3.fromRGB(175, 195, 255)
    }):Play();
    task.delay(v111, function() -- Line: 445
        -- upvalues: KingThunderCC (ref), TweenService (ref)
        if KingThunderCC.Parent then
            TweenService:Create(KingThunderCC, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Saturation = 0,
                Contrast = 0,
                Brightness = 0,
                TintColor = Color3.fromRGB(255, 255, 255)
            }):Play();
            task.delay(0.8, function() -- Line: 457
                -- upvalues: KingThunderCC (ref)
                pcall(function() -- Line: 458
                    -- upvalues: KingThunderCC (ref)
                    KingThunderCC:Destroy();
                end);
            end);
        end;
    end);
end;

local function fxSniperShot(p112) -- Line: 464
    -- upvalues: fxPlaySound (copy), TweenService (copy)
    local from = p112.from;
    local to = p112.to;

    if typeof(from) ~= "Vector3" or typeof(to) ~= "Vector3" then
        return;
    end;

    local v113 = to - from;
    local Magnitude = v113.Magnitude;

    if Magnitude < 0.1 then
        return;
    end;

    local v114 = p112.hit == true;
    fxPlaySound({
        id = "rbxassetid://124583632306554",
        vol = 1,
        minDist = 20,
        maxDist = 700,
        pitch = 1,
        x = from.X,
        y = from.Y,
        z = from.Z
    });
    local Part = Instance.new("Part");
    Part.Name = "SniperTracer";
    Part.Size = Vector3.new(v114 and 0.8 or 0.6, v114 and 0.8 or 0.6, Magnitude);
    Part.CFrame = CFrame.lookAt(from + v113 * 0.5, to);
    local v115;

    if v114 then
        v115 = Color3.fromRGB(255, 220, 80);
    else
        v115 = Color3.fromRGB(255, 140, 50);
    end;

    Part.Color = v115;
    Part.Material = Enum.Material.Neon;
    Part.Transparency = 0;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CastShadow = false;
    Part.Parent = workspace;
    local Part2 = Instance.new("Part");
    Part2.Shape = Enum.PartType.Ball;
    Part2.Size = Vector3.new(v114 and 3.5 or 2, v114 and 3.5 or 2, v114 and 3.5 or 2);
    Part2.CFrame = CFrame.new(to);
    Part2.Color = Part.Color;
    Part2.Material = Enum.Material.Neon;
    Part2.Transparency = v114 and 0.1 or 0.45;
    Part2.Anchored = true;
    Part2.CanCollide = false;
    Part2.CastShadow = false;
    Part2.Parent = workspace;
    TweenService:Create(Part, TweenInfo.new(0.45, Enum.EasingStyle.Quad), {
        Transparency = 1
    }):Play();
    TweenService:Create(Part2, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
        Transparency = 1,
        Size = Part2.Size * (v114 and 2.5 or 1.5)
    }):Play();
    game:GetService("Debris"):AddItem(Part, 0.5);
    game:GetService("Debris"):AddItem(Part2, 0.4);
end;

local function fxMageCast(p116) -- Line: 511
    -- upvalues: TweenService (copy)
    local origin = p116.origin;
    local radius = p116.radius;

    if typeof(origin) ~= "Vector3" or type(radius) ~= "number" then
        return;
    end;

    local Part = Instance.new("Part");
    Part.Name = "MageCastIndicator";
    Part.Shape = Enum.PartType.Cylinder;
    Part.Size = Vector3.new(0.3, radius * 2, radius * 2);
    Part.CFrame = CFrame.new(origin.X, origin.Y - 0.5, origin.Z) * CFrame.Angles(0, 0, 1.5707963267948966);
    Part.Color = Color3.fromRGB(160, 0, 220);
    Part.Material = Enum.Material.Neon;
    Part.Transparency = 0.35;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CastShadow = false;
    Part.Parent = workspace;
    TweenService:Create(Part, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 1
    }):Play();
    game:GetService("Debris"):AddItem(Part, 1.6);
end;

local function fxCrateOpen(p117) -- Line: 533
    -- upvalues: Players (copy), SoundManager (copy), u1 (ref), ReplicatedStorage (copy)
    if p117.userId ~= Players.LocalPlayer.UserId then
        return;
    end;

    SoundManager:Play("WIN");
    local v118 = p117.weaponName or "Weapon";

    if not u1 then
        u1 = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
    end;

    u1:ShowGeneralNotification("Picked up " .. v118 .. "!", Color3.fromRGB(255, 215, 0), 2);
end;

local function fxHealCrateOpen(p119) -- Line: 549
    -- upvalues: Players (copy), SoundManager (copy), u1 (ref), ReplicatedStorage (copy)
    if p119.userId ~= Players.LocalPlayer.UserId then
        return;
    end;

    SoundManager:Play("WIN");

    if not u1 then
        u1 = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
    end;

    u1:ShowGeneralNotification("Healed to full HP!", Color3.fromRGB(100, 255, 120), 2);
end;

local function playBurstBall(p120, p121, p122, p123, p124) -- Line: 564
    -- upvalues: TweenService (copy)
    local Part = Instance.new("Part");
    Part.Shape = Enum.PartType.Ball;
    Part.Size = Vector3.new(2, 2, 2);
    Part.CFrame = CFrame.new(p120, p121, p122);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.Material = Enum.Material.Neon;
    Part.Color = p124 or Color3.fromRGB(255, 80, 30);
    Part.Transparency = 0.2;
    Part.Parent = workspace;
    TweenService:Create(Part, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 1,
        Size = Vector3.new(p123 * 2, p123 * 2, p123 * 2)
    }):Play();
    task.delay(0.4, function() -- Line: 587
        -- upvalues: Part (copy)
        pcall(function() -- Line: 588
            -- upvalues: Part (ref)
            Part:Destroy();
        end);
    end);
end;

local function playExplosionAt(p125, p126, p127, p128) -- Line: 592
    -- upvalues: playBurstBall (copy)
    playBurstBall(p125, p126, p127, p128, Color3.fromRGB(255, 80, 30));
end;

local function spawnGroundWarnDisk(p129, p130, p131, p132, p133, p134) -- Line: 596
    -- upvalues: TweenService (copy)
    local Part = Instance.new("Part");
    Part.Shape = Enum.PartType.Cylinder;
    Part.Size = Vector3.new(0.35, p132 * 2, p132 * 2);
    Part.CFrame = CFrame.new(p129, p130, p131) * CFrame.Angles(0, 0, 1.5707963267948966);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CastShadow = false;
    Part.Material = Enum.Material.Neon;
    Part.Color = p134;
    Part.Transparency = 0.45;
    Part.Parent = workspace;
    task.delay(p133, function() -- Line: 614
        -- upvalues: Part (copy), TweenService (ref)
        if Part.Parent then
            TweenService:Create(Part, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Transparency = 1
            }):Play();
            task.delay(0.3, function() -- Line: 621
                -- upvalues: Part (ref)
                pcall(function() -- Line: 622
                    -- upvalues: Part (ref)
                    Part:Destroy();
                end);
            end);
        end;
    end);
end;

local function spawnHeadAimHint(p135, p136, p137, p138, p139) -- Line: 628
    -- upvalues: TweenService (copy)
    local Part = Instance.new("Part");
    Part.Shape = Enum.PartType.Cylinder;
    Part.Size = Vector3.new(0.1, p138 * 1.5, p138 * 1.5);
    Part.CFrame = CFrame.new(p135, p136 + 0.05, p137) * CFrame.Angles(0, 0, 1.5707963267948966);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CastShadow = false;
    Part.Material = Enum.Material.Neon;
    Part.Color = Color3.fromRGB(255, 175, 95);
    Part.Transparency = 0.78;
    Part.Parent = workspace;
    task.delay(p139, function() -- Line: 645
        -- upvalues: Part (copy), TweenService (ref)
        if Part.Parent then
            TweenService:Create(Part, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Transparency = 1
            }):Play();
            task.delay(0.15, function() -- Line: 652
                -- upvalues: Part (ref)
                pcall(function() -- Line: 653
                    -- upvalues: Part (ref)
                    Part:Destroy();
                end);
            end);
        end;
    end);
end;

local function cloneThunderHitAt(p140) -- Line: 659
    -- upvalues: LuckymatBossRoom (copy), ReplicatedStorage (copy), Debris (copy)
    local v141 = LuckymatBossRoom:FindFirstChild("VFX") and (v141:FindFirstChild("ThunderHit") or (v141:FindFirstChild("HitParticles") or v141:FindFirstChild("Thunder")));

    if not v141 then
        local Storm = require(ReplicatedStorage:WaitForChild("EventsConfig")).Storm;
        v141 = ReplicatedStorage:FindFirstChild(Storm and Storm.LightningFolder or "Ligtning") and v141:FindFirstChild("HitParticles");
    end;

    if v141 then
        local u142 = v141:Clone();

        if u142:IsA("BasePart") then
            u142.CFrame = CFrame.new(p140);
        elseif u142:IsA("Model") then
            u142:PivotTo(CFrame.new(p140));
        elseif u142:IsA("Attachment") then
            local Part = Instance.new("Part");
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.Transparency = 1;
            Part.Size = Vector3.new(1, 1, 1);
            Part.CFrame = CFrame.new(p140);
            Part.Parent = workspace;
            u142:Clone().Parent = Part;
            u142 = Part;
        end;

        u142.Parent = workspace;
        Debris:AddItem(u142, 3);
        task.delay(0.35, function() -- Line: 694
            -- upvalues: u142 (ref)
            if u142 and u142.Parent then
                for _, descendant in u142:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") or descendant:IsA("PointLight") then
                        descendant.Enabled = false;
                    end;
                end;
            end;
        end);
    end;
end;

local function playThunderBolt(p143, p144, p145) -- Line: 706
    -- upvalues: TweenService (copy)
    local v146 = p145 or 0.35;
    local Magnitude = (p144 - p143).Magnitude;

    if Magnitude < 0.1 then
        return;
    end;

    local v147 = Random.new();
    local v148 = Magnitude * 0.12;
    local Unit = (p144 - p143).Unit;
    local v149 = Unit:Dot(Vector3.new(1, 0, 0));
    local v150;

    if math.abs(v149) < 0.99 then
        v150 = Unit:Cross(Vector3.new(1, 0, 0)).Unit;
    else
        v150 = Unit:Cross(Vector3.new(0, 0, 1)).Unit;
    end;

    local Unit2 = Unit:Cross(v150).Unit;
    local v151 = { p143 };

    for i = 1, 5 do
        local v152 = i / 6;
        local v153 = p143:Lerp(p144, v152);
        local v154 = math.sin(v152 * 3.141592653589793);
        local v155 = v147:NextNumber(-v148, v148) * v154;
        local v156 = v147:NextNumber(-v148 * 0.5, v148 * 0.5) * v154;
        table.insert(v151, v153 + v150 * v155 + Unit2 * v156);
    end;

    table.insert(v151, p144);
    local v157 = {};

    for i = 1, #v151 - 1 do
        local v158 = v151[i];
        local v159 = v151[i + 1];
        local Magnitude2 = (v159 - v158).Magnitude;

        if Magnitude2 >= 0.01 then
            local Part = Instance.new("Part");
            Part.Name = "KingThunderBolt";
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.CanQuery = false;
            Part.CastShadow = false;
            Part.Material = Enum.Material.Neon;
            Part.Color = Color3.fromRGB(180, 220, 255);
            Part.Transparency = 0.15;
            Part.Size = Vector3.new(v146, v146, Magnitude2);
            Part.CFrame = CFrame.lookAt(v158 + (v159 - v158) * 0.5, v159);
            Part.Parent = workspace;
            table.insert(v157, Part);
        end;
    end;

    for _, v in v157 do
        TweenService:Create(v, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Transparency = 1
        }):Play();
        task.delay(0.22, function() -- Line: 759
            -- upvalues: v (copy)
            pcall(function() -- Line: 760
                -- upvalues: v (ref)
                v:Destroy();
            end);
        end);
    end;
end;

local function fxKingThunderStrike(p160) -- Line: 765
    -- upvalues: playThunderBolt (copy), cloneThunderHitAt (copy), fxPlaySound (copy), playBurstBall (copy), screenShakeNearby (copy), Lighting (copy), TweenService (copy)
    local v161 = Vector3.new(p160.fx or 0, p160.fy or 0, p160.fz or 0);
    local v162 = Vector3.new(p160.tx or 0, p160.ty or 0, p160.tz or 0);
    playThunderBolt(v161, v162);
    cloneThunderHitAt(v162);
    fxPlaySound({
        id = "rbxassetid://128859265290061",
        vol = 1.1,
        minDist = 20,
        maxDist = 700,
        pitch = 1,
        x = v162.X,
        y = v162.Y,
        z = v162.Z
    });
    playBurstBall(v162.X, v162.Y, v162.Z, p160.r or 10, Color3.fromRGB(140, 200, 255));
    screenShakeNearby(v162.X, v162.Y, v162.Z, (p160.r or 10) * 2.5);
    local KingThunderCC = Lighting:FindFirstChild("KingThunderCC");

    if KingThunderCC and KingThunderCC:IsA("ColorCorrectionEffect") then
        TweenService:Create(KingThunderCC, TweenInfo.new(0.04, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Brightness = 0.35,
            Contrast = 0.35,
            Saturation = -0.5
        }):Play();
        task.delay(0.06, function() -- Line: 781
            -- upvalues: KingThunderCC (copy), TweenService (ref)
            if KingThunderCC.Parent then
                TweenService:Create(KingThunderCC, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Brightness = 0.05,
                    Contrast = 0.22,
                    Saturation = -0.35
                }):Play();
            end;
        end);
    end;
end;

local function fxKingElectricAim(u163) -- Line: 797
    -- upvalues: CollectionService (copy), fxPlaySound (copy), RunService (copy), Players (copy), spawnGroundWarnDisk (copy), TweenService (copy)
    task.spawn(function() -- Line: 798
        -- upvalues: u163 (copy), CollectionService (ref), fxPlaySound (ref), RunService (ref), Players (ref), spawnGroundWarnDisk (ref), TweenService (ref)
        local npcId = u163.npcId;
        local userId = u163.userId;
        local v164 = u163.trackSec or 0.85;
        local v165 = u163.lockSec or 0.5;

        if npcId then
            for _, v in CollectionService:GetTagged("AABossNpc") do
                if v.Name == npcId then
                    break;
                end;
            end;
        else
            local v = nil;
        end;

        local v166;

        if v then
            v166 = v:FindFirstChild("HumanoidRootPart");
        else
            v166 = nil;
        end;

        if v166 then
            local Position = v166.Position;
            fxPlaySound({
                id = "rbxassetid://118901970008718",
                vol = 0.55,
                minDist = 20,
                maxDist = 700,
                pitch = 1,
                x = Position.X,
                y = Position.Y,
                z = Position.Z
            });
        end;

        local Part = Instance.new("Part");
        Part.Name = "KingElectricAimLaser";
        Part.Material = Enum.Material.Neon;
        Part.Color = Color3.fromRGB(120, 200, 255);
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CastShadow = false;
        Part.Parent = workspace;
        local v167 = 0;
        local v168 = nil;

        while true do
            if v167 >= v164 or not Part.Parent then
                if not (Part.Parent and v168) then
                    pcall(function() -- Line: 838
                        -- upvalues: Part (copy)
                        Part:Destroy();
                    end);

                    return;
                end;

                spawnGroundWarnDisk(v168.X, v168.Y, v168.Z, u163.r or 6, v165, Color3.fromRGB(90, 170, 255));
                local v169 = 0;

                while true do
                    if v169 >= v165 or not Part.Parent then
                        TweenService:Create(Part, TweenInfo.new(0.06, Enum.EasingStyle.Quad), {
                            Transparency = 1
                        }):Play();
                        task.delay(0.08, function() -- Line: 867
                            -- upvalues: Part (copy)
                            pcall(function() -- Line: 868
                                -- upvalues: Part (ref)
                                Part:Destroy();
                            end);
                        end);

                        return;
                    end;

                    v169 = v169 + RunService.Heartbeat:Wait();

                    if npcId then
                        for _, v in CollectionService:GetTagged("AABossNpc") do
                            if v.Name == npcId then
                                break;
                            end;
                        end;
                    else
                        local v = nil;
                    end;

                    local v170;

                    if v then
                        v170 = v:FindFirstChild("HumanoidRootPart");
                    else
                        v170 = nil;
                    end;

                    if v170 then
                        local v171 = math.sin(v169 * 50) * 0.18 + 1;
                        local v172 = v170.Position + Vector3.new(0, 4, 0);
                        local v173 = Color3.fromRGB(180, 230, 255);
                        local v174 = v168 - v172;
                        local Magnitude = v174.Magnitude;

                        if Magnitude < 0.05 then
                            Part.Transparency = 1;
                        else
                            Part.Transparency = 0;
                            Part.Size = Vector3.new(v171, v171, Magnitude);
                            Part.Color = v173;
                            Part.CFrame = CFrame.lookAt(v172 + v174 * 0.5, v168);
                        end;
                    end;
                end;
            end;

            v167 = v167 + RunService.Heartbeat:Wait();

            if npcId then
                for _, v in CollectionService:GetTagged("AABossNpc") do
                    if v.Name == npcId then
                        break;
                    end;
                end;
            else
                local v = nil;
            end;

            local v175;

            if v then
                v175 = v:FindFirstChild("HumanoidRootPart");
            else
                v175 = nil;
            end;

            local v176 = Players:GetPlayerByUserId(userId);
            local v177 = v176 and v176.Character and v176.Character:FindFirstChild("HumanoidRootPart");

            if v175 and v177 then
                v168 = v177.Position;
                local v178 = v175.Position + Vector3.new(0, 4, 0);
                local v179 = Color3.fromRGB(100, 190, 255);
                local v180 = v168 - v178;
                local Magnitude = v180.Magnitude;

                if Magnitude < 0.05 then
                    Part.Transparency = 1;
                else
                    Part.Transparency = 0;
                    Part.Size = Vector3.new(1, 1, Magnitude);
                    Part.Color = v179;
                    Part.CFrame = CFrame.lookAt(v178 + v180 * 0.5, v168);
                end;
            end;
        end;
    end);
end;

local function fxKingElectricBurst(p181) -- Line: 874
    -- upvalues: fxPlaySound (copy), screenShakeNearby (copy), TweenService (copy), cloneThunderHitAt (copy)
    local v182 = p181.x or 0;
    local v183 = p181.y or 0;
    local v184 = p181.z or 0;
    local v185 = p181.r or 22;
    local v186 = Vector3.new(v182, v183, v184);
    fxPlaySound({
        id = "rbxassetid://118901970008718",
        vol = 1.15,
        minDist = 20,
        maxDist = 700,
        pitch = 1,
        x = v186.X,
        y = v186.Y,
        z = v186.Z
    });
    screenShakeNearby(v182, v183, v184, v185 * 1.5);
    local Part = Instance.new("Part");
    Part.Shape = Enum.PartType.Cylinder;
    Part.Size = Vector3.new(0.2, v185 * 1.2, v185 * 1.2);
    Part.CFrame = CFrame.new(v182, v183, v184) * CFrame.Angles(0, 0, 1.5707963267948966);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Material = Enum.Material.Neon;
    Part.Color = Color3.fromRGB(100, 170, 255);
    Part.Transparency = 0.35;
    Part.Parent = workspace;
    TweenService:Create(Part, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 1,
        Size = Vector3.new(0.2, v185 * 2.4, v185 * 2.4)
    }):Play();
    task.delay(0.4, function() -- Line: 898
        -- upvalues: Part (copy)
        pcall(function() -- Line: 899
            -- upvalues: Part (ref)
            Part:Destroy();
        end);
    end);
    cloneThunderHitAt((Vector3.new(v182, v183 + 2, v184)));
end;

local function fxKingSlowCast(p187) -- Line: 905
    -- upvalues: fxPlaySound (copy), playBurstBall (copy), TweenService (copy), Debris (copy)
    local u188 = p187.x or 0;
    local u189 = p187.y or 0;
    local u190 = p187.z or 0;
    local u191 = p187.r or 110;
    local v192 = Vector3.new(u188, u189, u190);
    fxPlaySound({
        id = "rbxassetid://118901970008718",
        vol = 0.85,
        minDist = 20,
        maxDist = 700,
        pitch = 1,
        x = v192.X,
        y = v192.Y,
        z = v192.Z
    });
    playBurstBall(u188, u189, u190, math.min(u191 * 0.25, 18), Color3.fromRGB(80, 130, 255));

    for i = 1, 3 do
        task.delay((i - 1) * 0.12, function() -- Line: 916
            -- upvalues: u188 (copy), u189 (copy), u190 (copy), u191 (copy), TweenService (ref), Debris (ref)
            local Part = Instance.new("Part");
            Part.Shape = Enum.PartType.Cylinder;
            Part.Size = Vector3.new(0.25, 8, 8);
            Part.CFrame = CFrame.new(u188, u189 + 0.2, u190) * CFrame.Angles(0, 0, 1.5707963267948966);
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.CastShadow = false;
            Part.Material = Enum.Material.Neon;
            Part.Color = Color3.fromRGB(90, 150, 255);
            Part.Transparency = 0.35;
            Part.Parent = workspace;
            local v193 = Vector3.new(0.25, u191 * 2, u191 * 2);
            TweenService:Create(Part, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Transparency = 1,
                Size = v193
            }):Play();
            Debris:AddItem(Part, 0.7);
        end);
    end;
end;

local function fxKingSlow(p194) -- Line: 940
    -- upvalues: Players (copy), u9 (ref), u10 (ref), u11 (ref), RunService (copy), u2 (ref), ReplicatedStorage (copy), u3 (ref), u1 (ref)
    local userIds = p194.userIds;

    if type(userIds) ~= "table" then
        return;
    end;

    local UserId = Players.LocalPlayer.UserId;
    local v195 = false;

    for _, v in userIds do
        if v == UserId then
            v195 = true;
            break;
        end;
    end;

    if v195 then
        local v196 = p194.duration or 3.5;
        u9 = 1 - (p194.percent or 0.45 or 0.45);
        u10 = os.clock() + (v196 or 3.5);

        if not u11 then
            u11 = RunService.RenderStepped:Connect(function() -- Line: 104
                -- upvalues: u10 (ref), u9 (ref), Players (ref), u2 (ref), ReplicatedStorage (ref), u3 (ref)
                if u10 <= os.clock() then
                    u9 = 1;

                    return;
                end;

                if u9 >= 1 then
                    return;
                end;

                local LocalPlayer = Players.LocalPlayer;
                local v197 = LocalPlayer:GetAttribute("LuckymatKingSlowMult");
                local v198 = LocalPlayer:GetAttribute("LuckymatKingSlowUntil");

                if type(v197) ~= "number" or (type(v198) ~= "number" or v198 <= os.clock()) then
                    u9 = 1;

                    return;
                end;

                u9 = v197;
                local v199 = LocalPlayer.Character and v199:FindFirstChildOfClass("Humanoid");

                if v199 then
                    if not u2 then
                        u2 = require(ReplicatedStorage:WaitForChild("ClientState"));
                    end;

                    if not u3 then
                        u3 = require(ReplicatedStorage:WaitForChild("Config"));
                    end;

                    local v200 = u2:Get();
                    local v201;

                    if v200.CustomWalkSpeed and v200.CustomWalkSpeed > 0 then
                        v201 = v200.CustomWalkSpeed;
                    else
                        v201 = u3.CalculateMaxSpeed(v200.Level or 1);
                    end;

                    v199.WalkSpeed = v201 * u9;
                end;
            end);
        end;

        local v202 = Players.LocalPlayer.Character and v202:FindFirstChildOfClass("Humanoid");

        if v202 then
            if not u2 then
                u2 = require(ReplicatedStorage:WaitForChild("ClientState"));
            end;

            if not u3 then
                u3 = require(ReplicatedStorage:WaitForChild("Config"));
            end;

            local v203 = u2:Get();
            local v204;

            if v203.CustomWalkSpeed and v203.CustomWalkSpeed > 0 then
                v204 = v203.CustomWalkSpeed;
            else
                v204 = u3.CalculateMaxSpeed(v203.Level or 1);
            end;

            v202.WalkSpeed = v204 * u9;
        end;

        if not u1 then
            u1 = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
        end;

        u1:ShowMessage(string.format("Slowed by %.0f%%!", (p194.percent or 0.45) * 100), Color3.fromRGB(120, 180, 255));
    end;

    for _, v in userIds do
        if v == UserId then
            local u205 = Players.LocalPlayer.Character and u205:FindFirstChild("HumanoidRootPart");

            if u205 then
                local Part = Instance.new("Part");
                Part.Shape = Enum.PartType.Ball;
                Part.Size = Vector3.new(4, 4, 4);
                Part.CFrame = u205.CFrame;
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.Material = Enum.Material.Neon;
                Part.Color = Color3.fromRGB(90, 140, 255);
                Part.Transparency = 0.65;
                Part.Parent = workspace;
                local u206 = p194.duration or 3.5;
                local u207 = 0;
                local u208 = nil;
                u208 = RunService.RenderStepped:Connect(function(p209) -- Line: 981
                    -- upvalues: u207 (ref), u206 (copy), u205 (copy), u208 (ref), Part (copy)
                    u207 = u207 + p209;

                    if u206 > u207 and u205.Parent then
                        Part.CFrame = u205.CFrame;

                        return;
                    end;

                    u208:Disconnect();
                    pcall(function() -- Line: 985
                        -- upvalues: Part (ref)
                        Part:Destroy();
                    end);
                end);

                return;
            end;

            break;
        end;
    end;
end;

local function fxStatueSpawnBeam(u210, u211, u212) -- Line: 1000
    -- upvalues: TweenService (copy), Debris (copy), fxPlaySound (copy)
    local v213 = Color3.fromRGB(255, 235, 160);
    local v214 = Color3.fromRGB(255, 255, 220);

    local function spawnBeamLayer(u215, p216, u217, p218, p219) -- Line: 1004
        -- upvalues: u210 (copy), u211 (copy), u212 (copy), TweenService (ref)
        local Part = Instance.new("Part");
        Part.Name = "StatueSpawnBeam";
        Part.Shape = Enum.PartType.Cylinder;
        Part.Size = Vector3.new(u217, u215 * 2, u215 * 2);
        Part.CFrame = CFrame.new(u210, u211, u212) * CFrame.Angles(0, 0, 1.5707963267948966);
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CastShadow = false;
        Part.Material = Enum.Material.Neon;
        Part.Color = p219;
        Part.Transparency = p218;
        Part.Parent = workspace;
        TweenService:Create(Part, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(u217, p216 * 2, p216 * 2)
        }):Play();
        task.delay(0.55, function() -- Line: 1025
            -- upvalues: Part (copy), TweenService (ref), u217 (copy), u215 (copy)
            if Part.Parent then
                TweenService:Create(Part, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Transparency = 1,
                    Size = Vector3.new(u217, u215 * 2, u215 * 2)
                }):Play();
                task.delay(0.4, function() -- Line: 1035
                    -- upvalues: Part (ref)
                    pcall(function() -- Line: 1036
                        -- upvalues: Part (ref)
                        Part:Destroy();
                    end);
                end);
            end;
        end);
    end;

    spawnBeamLayer(0.15, 4.5, 200, 0.35, v213);
    spawnBeamLayer(0.09, 2.025, 200, 0.15, v214);
    local Part = Instance.new("Part");
    Part.Size = Vector3.new(0.1, 0.1, 0.1);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CFrame = CFrame.new(u210, u211, u212);
    Part.Parent = workspace;
    local PointLight = Instance.new("PointLight");
    PointLight.Brightness = 3;
    PointLight.Range = 120;
    PointLight.Color = v213;
    PointLight.Parent = Part;
    TweenService:Create(PointLight, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Brightness = 0
    }):Play();
    Debris:AddItem(Part, 1);
    local v220 = Vector3.new(u210, u211, u212);
    fxPlaySound({
        id = "rbxassetid://119573908217733",
        vol = 0.85,
        minDist = 40,
        maxDist = 700,
        pitch = 1,
        x = v220.X,
        y = v220.Y,
        z = v220.Z
    });
end;

local function fxNpcSummon(p221) -- Line: 1069
    -- upvalues: fxStatueSpawnBeam (copy), playBurstBall (copy), fxPlaySound (copy)
    local v222 = p221.x or 0;
    local v223 = p221.y or 0;
    local v224 = p221.z or 0;

    if p221.archetypeId == "Statue" then
        fxStatueSpawnBeam(v222, v223, v224);

        return;
    end;

    playBurstBall(v222, v223, v224, 5, Color3.fromRGB(150, 110, 255));
    local v225 = Vector3.new(v222, v223, v224);
    fxPlaySound({
        id = "rbxassetid://136081560081353",
        vol = 1.2,
        minDist = 20,
        maxDist = 700,
        pitch = 1,
        x = v225.X,
        y = v225.Y,
        z = v225.Z
    });
end;

local function fxMageTeleport(u226) -- Line: 1081
    -- upvalues: playBurstBall (copy), fxPlaySound (copy), TweenService (copy)
    task.spawn(function() -- Line: 1082
        -- upvalues: u226 (copy), playBurstBall (ref), fxPlaySound (ref), TweenService (ref)
        local v227 = Vector3.new(u226.fx or 0, u226.fy or 0, u226.fz or 0);
        local v228 = Vector3.new(u226.tx or 0, u226.ty or 0, u226.tz or 0);
        local v229 = Color3.fromRGB(150, 110, 255);
        local v230 = 1 + ((u226.index or 1) - 1) * 0.07;
        playBurstBall(v227.X, v227.Y, v227.Z, 5, v229);
        fxPlaySound({
            id = "rbxassetid://135640489101126",
            vol = 1,
            minDist = 20,
            maxDist = 700,
            x = v227.X,
            y = v227.Y,
            z = v227.Z,
            pitch = v230 or 1
        });
        task.wait(0.08);
        playBurstBall(v228.X, v228.Y, v228.Z, 5, v229);
        fxPlaySound({
            id = "rbxassetid://136223034485147",
            vol = 1,
            minDist = 20,
            maxDist = 700,
            x = v228.X,
            y = v228.Y,
            z = v228.Z,
            pitch = v230 or 1
        });
        local Part = Instance.new("Part");
        Part.Name = "MageTeleportTrail";
        Part.Material = Enum.Material.Neon;
        Part.Color = v229;
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CastShadow = false;
        Part.Transparency = 0.25;
        Part.Parent = workspace;
        local v231 = v228 - v227;
        local Magnitude = v231.Magnitude;

        if Magnitude < 0.05 then
            Part.Transparency = 1;
        else
            Part.Transparency = 0;
            Part.Size = Vector3.new(0.55, 0.55, Magnitude);
            Part.Color = v229;
            Part.CFrame = CFrame.lookAt(v227 + v231 * 0.5, v228);
        end;

        TweenService:Create(Part, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Transparency = 1
        }):Play();
        task.delay(0.4, function() -- Line: 1114
            -- upvalues: Part (copy)
            pcall(function() -- Line: 1115
                -- upvalues: Part (ref)
                Part:Destroy();
            end);
        end);
    end);
end;

local function portalCFrameAt(p232, p233) -- Line: 1121
    if p233 and (p233 - p232).Magnitude > 0.05 then
        return CFrame.lookAt(p232, p233);
    end;

    return CFrame.new(p232);
end;

local function spawnPortalCosmetic(p234, p235) -- Line: 1128
    -- upvalues: LuckymatBossRoom (copy)
    local VFX = LuckymatBossRoom:FindFirstChild("VFX");

    if not VFX then
        warn("[LuckymatClient] Assets.VFX folder missing");

        return nil;
    end;

    local PortalVFX = VFX:FindFirstChild("PortalVFX");

    if not PortalVFX then
        warn("[LuckymatClient] No PortalVFX found inside Assets.VFX");

        return nil;
    end;

    local v236 = PortalVFX:Clone();
    local v237;

    if p235 and (p235 - p234).Magnitude > 0.05 then
        v237 = CFrame.lookAt(p234, p235);
    else
        v237 = CFrame.new(p234);
    end;

    v236.CFrame = v237;
    v236.CanCollide = false;
    v236.CanQuery = false;
    v236.Anchored = true;
    v236.Parent = workspace;

    return v236;
end;

local function orientPortalToward(p238, p239, p240) -- Line: 1148
    if (p240 - p239).Magnitude > 0.05 then
        local Position = p238.Position;
        local v241;

        if p240 and (p240 - Position).Magnitude > 0.05 then
            v241 = CFrame.lookAt(Position, p240);
        else
            v241 = CFrame.new(Position);
        end;

        p238.CFrame = v241;
    end;
end;

local function closePortalByKey(p242) -- Line: 1154
    -- upvalues: u5 (copy)
    local u243 = u5[p242];

    if u243 and u243.Parent then
        pcall(function() -- Line: 1157
            -- upvalues: u243 (copy)
            u243:Destroy();
        end);
    end;

    u5[p242] = nil;
end;

local function attachHeadTrail(p244) -- Line: 1162
    local Attachment = Instance.new("Attachment");
    Attachment.Position = Vector3.new(0, 0.15, 0);
    Attachment.Parent = p244;
    local Attachment2 = Instance.new("Attachment");
    Attachment2.Position = Vector3.new(0, -0.35, 0);
    Attachment2.Parent = p244;
    local Trail = Instance.new("Trail");
    Trail.Attachment0 = Attachment;
    Trail.Attachment1 = Attachment2;
    Trail.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 170, 70)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 70, 25)) });
    Trail.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.15), NumberSequenceKeypoint.new(1, 1) });
    Trail.Lifetime = 0.28;
    Trail.MinLength = 0.05;
    Trail.LightEmission = 0.6;
    Trail.Parent = p244;
end;

local function fxKingElectricZap(p245) -- Line: 1188
    -- upvalues: playThunderBolt (copy), cloneThunderHitAt (copy), fxPlaySound (copy), playBurstBall (copy)
    local v246 = Vector3.new(p245.fx or 0, p245.fy or 0, p245.fz or 0);
    local v247 = Vector3.new(p245.tx or 0, p245.ty or 0, p245.tz or 0);
    playThunderBolt(v246, v247, 1.75);
    cloneThunderHitAt(v247);
    fxPlaySound({
        id = "rbxassetid://118901970008718",
        vol = 1,
        minDist = 20,
        maxDist = 700,
        pitch = 1,
        x = v247.X,
        y = v247.Y,
        z = v247.Z
    });
    playBurstBall(v247.X, v247.Y, v247.Z, 7, Color3.fromRGB(140, 210, 255));
end;

local function spawnHeadCosmetic(u248, u249, p250, p251, p252, u253, u254, u255, p256, u257, p258) -- Line: 1197
    -- upvalues: Assets (copy), u4 (copy), attachHeadTrail (copy), fxPlaySound (copy), TweenService (copy), playBurstBall (copy), screenShakeNearby (copy), u5 (copy)
    local NoobExplosiveHead = Assets:FindFirstChild("NoobExplosiveHead");

    if not (NoobExplosiveHead and NoobExplosiveHead:IsA("BasePart")) then
        warn("[LuckymatClient] Assets.NoobExplosiveHead BasePart missing");

        return;
    end;

    local v259 = Vector3.new(u253, u254, u255);
    local u260 = NoobExplosiveHead:Clone();

    if p258 and p258 ~= 1 then
        u260.Size = NoobExplosiveHead.Size * p258;
    end;

    u260.CFrame = CFrame.new(p250, p251, p252);
    u260.CanCollide = false;
    u260.CanQuery = false;
    u260.Anchored = true;
    u260.Parent = workspace;
    u4[u248] = u260;
    attachHeadTrail(u260);
    local v261 = Vector3.new(p250, p251, p252);
    fxPlaySound({
        id = "rbxassetid://119573908217733",
        vol = 1.2,
        minDist = 20,
        maxDist = 700,
        pitch = 1,
        x = v261.X,
        y = v261.Y,
        z = v261.Z
    });
    local v262 = TweenService:Create(u260, TweenInfo.new(p256, Enum.EasingStyle.Linear), {
        CFrame = CFrame.new(v259)
    });
    v262.Completed:Connect(function() -- Line: 1230
        -- upvalues: u4 (ref), u248 (copy), u260 (copy), u253 (copy), u254 (copy), u255 (copy), u257 (copy), playBurstBall (ref), screenShakeNearby (ref), u249 (copy), u5 (ref)
        u4[u248] = nil;
        pcall(function() -- Line: 1232
            -- upvalues: u260 (ref)
            u260:Destroy();
        end);
        playBurstBall(u253, u254, u255, u257, Color3.fromRGB(255, 80, 30));
        screenShakeNearby(u253, u254, u255, u257);

        if u249 then
            local v263 = u249;
            local u264 = u5[v263];

            if u264 and u264.Parent then
                pcall(function() -- Line: 1157
                    -- upvalues: u264 (copy)
                    u264:Destroy();
                end);
            end;

            u5[v263] = nil;
        end;
    end);
    v262:Play();
end;

local function getBoostFrame() -- Line: 1242
    -- upvalues: Players (copy)
    local v265 = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui") and v265:FindFirstChild("SpeedGameUI") and v265:FindFirstChild("Frames") and v265:FindFirstChild("BoostFrame");

    if not (v265 and (v265:IsA("Frame") and v265)) then
        v265 = nil;
    end;

    return v265;
end;

local function hideBoostFrame() -- Line: 1250
    -- upvalues: getBoostFrame (copy), u14 (ref)
    local v266 = getBoostFrame();

    if v266 then
        u14 = v266.Visible;
        v266.Visible = false;
    end;
end;

local function restoreBoostFrame() -- Line: 1258
    -- upvalues: getBoostFrame (copy), u14 (ref)
    local v267 = getBoostFrame();

    if v267 and u14 ~= nil then
        v267.Visible = u14;
    end;

    u14 = nil;
end;

local function cleanupCosmetics() -- Line: 1266
    -- upvalues: u5 (copy), u4 (copy), u6 (copy), u7 (ref), u8 (ref), u17 (ref), u16 (ref), u15 (ref), u18 (ref), u19 (ref), u12 (ref), u13 (ref), Lighting (copy), u11 (ref), u9 (ref), u10 (ref), LuckymatCutscenes (copy)
    for i, v in u5 do
        pcall(function() -- Line: 1268
            -- upvalues: v (copy)
            v:Destroy();
        end);
        u5[i] = nil;
    end;

    for i, v in u4 do
        pcall(function() -- Line: 1272
            -- upvalues: v (copy)
            v:Destroy();
        end);
        u4[i] = nil;
    end;

    for i = #u6, 1, -1 do
        pcall(function() -- Line: 1276
            -- upvalues: u6 (ref), i (copy)
            u6[i]:Destroy();
        end);
        u6[i] = nil;
    end;

    if u7 then
        u7:Stop();
        u7 = nil;
    end;

    if u8 then
        u8:Stop();
        u8 = nil;
    end;

    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;

    if u16 then
        pcall(function() -- Line: 1288
            -- upvalues: u16 (ref)
            u16:Destroy();
        end);
        u16 = nil;
    end;

    if u15 then
        pcall(function() -- Line: 1289
            -- upvalues: u15 (ref)
            u15:Destroy();
        end);
        u15 = nil;
    end;

    if u18 then
        u18:Stop();
        u18 = nil;
    end;

    if u19 then
        u19:Stop();
        u19 = nil;
    end;

    if u12 then
        pcall(function() -- Line: 1292
            -- upvalues: u12 (ref)
            u12:Destroy();
        end);
        u12 = nil;
    end;

    if u13 then
        pcall(function() -- Line: 1293
            -- upvalues: u13 (ref)
            u13:Destroy();
        end);
        u13 = nil;
    end;

    local KingThunderCC = Lighting:FindFirstChild("KingThunderCC");

    if KingThunderCC then
        pcall(function() -- Line: 1296
            -- upvalues: KingThunderCC (copy)
            KingThunderCC:Destroy();
        end);
    end;

    if u11 then
        u11:Disconnect();
        u11 = nil;
    end;

    u9 = 1;
    u10 = 0;
    LuckymatCutscenes.stopAll();
end;

local function preloadSenderThumbs() -- Line: 1302
    -- upvalues: LuckymatConfig (copy), FakeAdminMessageUtil (copy)
    local u268 = {};
    local u269 = {};

    local function add(p270) -- Line: 1305
        -- upvalues: u269 (copy), u268 (copy)
        if type(p270) == "number" and not u269[p270] then
            u269[p270] = true;
            table.insert(u268, p270);
        end;
    end;

    local DefaultSenderId = LuckymatConfig.DefaultSenderId;

    if type(DefaultSenderId) == "number" and not u269[DefaultSenderId] then
        u269[DefaultSenderId] = true;
        table.insert(u268, DefaultSenderId);
    end;

    if LuckymatConfig.MessageConfigByPhase then
        for _, v in LuckymatConfig.MessageConfigByPhase do
            local SenderId = v.SenderId;

            if type(SenderId) == "number" and not u269[SenderId] then
                u269[SenderId] = true;
                table.insert(u268, SenderId);
            end;
        end;
    end;

    if LuckymatConfig.TimelineCues then
        for _, v in LuckymatConfig.TimelineCues do
            local SenderId = v.SenderId;

            if type(SenderId) == "number" and not u269[SenderId] then
                u269[SenderId] = true;
                table.insert(u268, SenderId);
            end;
        end;
    end;

    if #u268 > 0 then
        FakeAdminMessageUtil.preload(u268);
    end;
end;

local function handleFx(p271, u272) -- Line: 1321
    -- upvalues: CollectionService (copy), fxPlaySound (copy), RunService (copy), Players (copy), TweenService (copy), fxSniperShot (copy), fxMageCast (copy), fxCrateOpen (copy), SoundManager (copy), u1 (ref), ReplicatedStorage (copy), u5 (copy), spawnPortalCosmetic (copy), spawnHeadAimHint (copy), fxNpcSummon (copy), playBurstBall (copy), spawnHeadCosmetic (copy), fxNpcHitBlink (copy), spawnGroundWarnDisk (copy), u6 (copy), screenShakeNearby (copy), u7 (ref), u8 (ref), fxKingElectricZap (copy), fxKingThunderStormStart (copy), fxKingThunderStrike (copy), fxKingElectricBurst (copy), fxKingSlowCast (copy), fxKingSlow (copy), u17 (ref), u16 (ref), u15 (ref), u18 (ref), u19 (ref), Assets (copy), u12 (ref), LuckymatCutscenes (copy), cloneThunderHitAt (copy), u13 (ref), LuckymatConfig (copy), FakeAdminMessageUtil (copy)
    if p271 == "SniperAim" then
        task.spawn(function() -- Line: 295
            -- upvalues: u272 (copy), CollectionService (ref), fxPlaySound (ref), RunService (ref), Players (ref), TweenService (ref)
            local npcId = u272.npcId;
            local userId = u272.userId;
            local v273 = u272.trackSec or 1;
            local v274 = u272.lockSec or 0.2;

            if npcId then
                for _, v in CollectionService:GetTagged("AABossNpc") do
                    if v.Name == npcId then
                        break;
                    end;
                end;
            else
                local v = nil;
            end;

            local v275;

            if v then
                v275 = v:FindFirstChild("HumanoidRootPart");
            else
                v275 = nil;
            end;

            if v275 then
                local Position = v275.Position;
                fxPlaySound({
                    id = "rbxassetid://100381484858434",
                    vol = 1,
                    minDist = 20,
                    maxDist = 700,
                    pitch = 1,
                    x = Position.X,
                    y = Position.Y,
                    z = Position.Z
                });
            end;

            local Part = Instance.new("Part");
            Part.Name = "SniperAimLaser";
            Part.Material = Enum.Material.Neon;
            Part.Color = Color3.fromRGB(255, 50, 50);
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.CanQuery = false;
            Part.CastShadow = false;
            Part.Parent = workspace;
            local v276 = 0;
            local v277 = nil;

            while true do
                if v276 >= v273 or not Part.Parent then
                    if not (Part.Parent and v277) then
                        pcall(function() -- Line: 335
                            -- upvalues: Part (copy)
                            Part:Destroy();
                        end);

                        return;
                    end;

                    local v278 = 0;

                    while true do
                        if v278 >= v274 or not Part.Parent then
                            TweenService:Create(Part, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {
                                Transparency = 1
                            }):Play();
                            task.delay(0.1, function() -- Line: 358
                                -- upvalues: Part (copy)
                                pcall(function() -- Line: 359
                                    -- upvalues: Part (ref)
                                    Part:Destroy();
                                end);
                            end);

                            return;
                        end;

                        v278 = v278 + RunService.Heartbeat:Wait();

                        if npcId then
                            for _, v in CollectionService:GetTagged("AABossNpc") do
                                if v.Name == npcId then
                                    break;
                                end;
                            end;
                        else
                            local v = nil;
                        end;

                        local v279;

                        if v then
                            v279 = v:FindFirstChild("HumanoidRootPart");
                        else
                            v279 = nil;
                        end;

                        if v279 then
                            local v280 = math.sin(v278 * 40) * 0.06 + 0.22;
                            local Position = v279.Position;
                            local v281 = Color3.fromRGB(255, 164, 164);
                            local v282 = v277 - Position;
                            local Magnitude = v282.Magnitude;

                            if Magnitude < 0.05 then
                                Part.Transparency = 1;
                            else
                                Part.Transparency = 0;
                                Part.Size = Vector3.new(v280, v280, Magnitude);
                                Part.Color = v281;
                                Part.CFrame = CFrame.lookAt(Position + v282 * 0.5, v277);
                            end;
                        end;
                    end;
                end;

                v276 = v276 + RunService.Heartbeat:Wait();

                if npcId then
                    for _, v in CollectionService:GetTagged("AABossNpc") do
                        if v.Name == npcId then
                            break;
                        end;
                    end;
                else
                    local v = nil;
                end;

                local v283;

                if v then
                    v283 = v:FindFirstChild("HumanoidRootPart");
                else
                    v283 = nil;
                end;

                local v284 = Players:GetPlayerByUserId(userId);
                local v285 = v284 and v284.Character and v284.Character:FindFirstChild("HumanoidRootPart");

                if v283 and v285 then
                    v277 = v285.Position;
                    local Position = v283.Position;
                    local v286 = Color3.fromRGB(255, 60, 60);
                    local v287 = v277 - Position;
                    local Magnitude = v287.Magnitude;

                    if Magnitude < 0.05 then
                        Part.Transparency = 1;
                    else
                        Part.Transparency = 0;
                        Part.Size = Vector3.new(0.22, 0.22, Magnitude);
                        Part.Color = v286;
                        Part.CFrame = CFrame.lookAt(Position + v287 * 0.5, v277);
                    end;
                end;
            end;
        end);

        return;
    end;

    if p271 == "SniperShot" then
        fxSniperShot(u272);

        return;
    end;

    if p271 == "MageCast" then
        fxMageCast(u272);

        return;
    end;

    if p271 == "CrateOpen" then
        fxCrateOpen(u272);

        return;
    end;

    if p271 ~= "HealCrateOpen" then
        if p271 == "MagePortalOpen" then
            local v288 = u272.portalId or u272.npcId;

            if v288 and not (u5[v288] and u5[v288].Parent) then
                local v289 = Vector3.new(u272.mx, u272.my, u272.mz);
                local v290;

                if u272.tx then
                    v290 = Vector3.new(u272.tx, u272.ty, u272.tz);
                else
                    v290 = nil;
                end;

                local v291 = spawnPortalCosmetic(v289, v290);

                if v291 then
                    u5[v288] = v291;
                    fxPlaySound({
                        id = "rbxassetid://111878775341423",
                        vol = 1,
                        minDist = 20,
                        maxDist = 700,
                        pitch = 1,
                        x = v289.X,
                        y = v289.Y,
                        z = v289.Z
                    });
                end;
            end;

            if u272.t and u272.tx then
                task.spawn(function() -- Line: 1344
                    -- upvalues: spawnHeadAimHint (ref), u272 (copy)
                    spawnHeadAimHint(u272.tx, u272.ty, u272.tz, u272.r or 12, u272.t);
                end);

                return;
            end;
        else
            if p271 == "NpcSummonFx" then
                fxNpcSummon(u272);

                return;
            end;

            if p271 == "MageTeleport" then
                task.spawn(function() -- Line: 1082
                    -- upvalues: u272 (copy), playBurstBall (ref), fxPlaySound (ref), TweenService (ref)
                    local v292 = Vector3.new(u272.fx or 0, u272.fy or 0, u272.fz or 0);
                    local v293 = Vector3.new(u272.tx or 0, u272.ty or 0, u272.tz or 0);
                    local v294 = Color3.fromRGB(150, 110, 255);
                    local v295 = 1 + ((u272.index or 1) - 1) * 0.07;
                    playBurstBall(v292.X, v292.Y, v292.Z, 5, v294);
                    fxPlaySound({
                        id = "rbxassetid://135640489101126",
                        vol = 1,
                        minDist = 20,
                        maxDist = 700,
                        x = v292.X,
                        y = v292.Y,
                        z = v292.Z,
                        pitch = v295 or 1
                    });
                    task.wait(0.08);
                    playBurstBall(v293.X, v293.Y, v293.Z, 5, v294);
                    fxPlaySound({
                        id = "rbxassetid://136223034485147",
                        vol = 1,
                        minDist = 20,
                        maxDist = 700,
                        x = v293.X,
                        y = v293.Y,
                        z = v293.Z,
                        pitch = v295 or 1
                    });
                    local Part = Instance.new("Part");
                    Part.Name = "MageTeleportTrail";
                    Part.Material = Enum.Material.Neon;
                    Part.Color = v294;
                    Part.Anchored = true;
                    Part.CanCollide = false;
                    Part.CanQuery = false;
                    Part.CastShadow = false;
                    Part.Transparency = 0.25;
                    Part.Parent = workspace;
                    local v296 = v293 - v292;
                    local Magnitude = v296.Magnitude;

                    if Magnitude < 0.05 then
                        Part.Transparency = 1;
                    else
                        Part.Transparency = 0;
                        Part.Size = Vector3.new(0.55, 0.55, Magnitude);
                        Part.Color = v294;
                        Part.CFrame = CFrame.lookAt(v292 + v296 * 0.5, v293);
                    end;

                    TweenService:Create(Part, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Transparency = 1
                    }):Play();
                    task.delay(0.4, function() -- Line: 1114
                        -- upvalues: Part (copy)
                        pcall(function() -- Line: 1115
                            -- upvalues: Part (ref)
                            Part:Destroy();
                        end);
                    end);
                end);

                return;
            end;

            if p271 == "NoobHeadSpawn" then
                local v297 = Vector3.new(u272.hx, u272.hy, u272.hz);
                local v298 = Vector3.new(u272.tx, u272.ty, u272.tz);

                if u272.portalId then
                    local v299 = u5[u272.portalId];

                    if v299 and (v299.Parent and (v298 - v297).Magnitude > 0.05) then
                        local Position = v299.Position;
                        local v300;

                        if v298 and (v298 - Position).Magnitude > 0.05 then
                            v300 = CFrame.lookAt(Position, v298);
                        else
                            v300 = CFrame.new(Position);
                        end;

                        v299.CFrame = v300;
                    end;
                end;

                spawnHeadCosmetic(u272.hid, u272.portalId, u272.hx, u272.hy, u272.hz, u272.tx, u272.ty, u272.tz, u272.travelSec, u272.r, u272.scale);

                return;
            end;

            if p271 == "PlaySound" then
                fxPlaySound(u272);

                return;
            end;

            if p271 == "NpcHitBlink" then
                fxNpcHitBlink(u272, false);

                return;
            end;

            if p271 == "NpcDied" then
                fxNpcHitBlink(u272, true);

                return;
            end;

            if p271 == "PFWarn" then
                task.spawn(function() -- Line: 1381
                    -- upvalues: u272 (copy), u5 (ref), spawnPortalCosmetic (ref), fxPlaySound (ref), spawnGroundWarnDisk (ref)
                    local px = u272.px;
                    local py = u272.py;
                    local pz = u272.pz;
                    local gx = u272.gx;
                    local gy = u272.gy;
                    local gz = u272.gz;
                    local v301 = u272.t or 2.5;
                    local v302 = u272.r or 14;
                    local v303 = Vector3.new(px, py, pz);
                    local v304;

                    if u272.tx then
                        v304 = Vector3.new(u272.tx, u272.ty, u272.tz);
                    else
                        v304 = Vector3.new(gx, gy, gz);
                    end;

                    local v305 = string.format("%.1f_%.1f_%.1f", px, py, pz);
                    local v306 = false;

                    if u5[v305] and u5[v305].Parent then
                        if u5[v305] and not u272.rx then
                            local v307 = u5[v305];

                            if (v304 - v303).Magnitude > 0.05 then
                                local Position = v307.Position;
                                local v308;

                                if v304 and (v304 - Position).Magnitude > 0.05 then
                                    v308 = CFrame.lookAt(Position, v304);
                                else
                                    v308 = CFrame.new(Position);
                                end;

                                v307.CFrame = v308;
                            end;
                        end;
                    else
                        local v309 = spawnPortalCosmetic(v303, v304);

                        if v309 then
                            if u272.rx then
                                v309.CFrame = CFrame.new(px, py, pz) * CFrame.fromEulerAnglesXYZ(u272.rx or 0, u272.ry or 0, u272.rz or 0);
                            else
                                v309.CFrame = CFrame.new(px, py, pz) * CFrame.Angles(1.5707963267948966, u272.ry or 0, 0);
                            end;

                            u5[v305] = v309;
                            v306 = true;
                        end;
                    end;

                    if v306 then
                        fxPlaySound({
                            id = "rbxassetid://111878775341423",
                            vol = 1,
                            minDist = 20,
                            maxDist = 700,
                            pitch = 1,
                            x = v303.X,
                            y = v303.Y,
                            z = v303.Z
                        });
                        fxPlaySound({
                            id = "rbxassetid://80624479410185",
                            vol = 1,
                            minDist = 20,
                            maxDist = 700,
                            pitch = 1,
                            x = v303.X,
                            y = v303.Y,
                            z = v303.Z
                        });
                    end;

                    spawnGroundWarnDisk(gx, gy, gz, v302, v301, Color3.fromRGB(255, 80, 30));
                end);

                return;
            end;

            if p271 == "PFDrop" then
                task.spawn(function() -- Line: 1418
                    -- upvalues: u272 (copy), u6 (ref), TweenService (ref)
                    local px = u272.px;
                    local py = u272.py;
                    local pz = u272.pz;
                    local gx = u272.gx;
                    local gy = u272.gy;
                    local gz = u272.gz;
                    local v310 = u272.fallSec or 1.2;
                    local Part = Instance.new("Part");
                    Part.Shape = Enum.PartType.Ball;
                    Part.Size = Vector3.new(9.6, 9.6, 9.6);
                    Part.CFrame = CFrame.new(px, py, pz);
                    Part.Anchored = true;
                    Part.CanCollide = false;
                    Part.CastShadow = false;
                    Part.Material = Enum.Material.Neon;
                    Part.Color = Color3.fromRGB(255, 100, 20);
                    Part.Transparency = 0;
                    Part.Parent = workspace;
                    table.insert(u6, Part);
                    local PointLight = Instance.new("PointLight", Part);
                    PointLight.Brightness = 8;
                    PointLight.Color = Color3.fromRGB(255, 120, 40);
                    PointLight.Range = 44;
                    local Fire = Instance.new("Fire");
                    Fire.Size = 14;
                    Fire.Parent = Part;
                    TweenService:Create(Part, TweenInfo.new(v310, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        CFrame = CFrame.new(gx, gy, gz)
                    }):Play();
                    task.wait(v310);
                    local v311 = table.find(u6, Part);

                    if v311 then
                        table.remove(u6, v311);
                    end;

                    pcall(function() -- Line: 1453
                        -- upvalues: Part (copy)
                        Part:Destroy();
                    end);
                end);

                return;
            end;

            if p271 == "PFImpact" then
                task.spawn(function() -- Line: 1456
                    -- upvalues: u272 (copy), playBurstBall (ref), fxPlaySound (ref), screenShakeNearby (ref), u5 (ref)
                    local px = u272.px;
                    local py = u272.py;
                    local pz = u272.pz;
                    local gx = u272.gx;
                    local gy = u272.gy;
                    local gz = u272.gz;
                    local v312 = u272.r or 14;
                    playBurstBall(gx, gy, gz, v312 * 2, Color3.fromRGB(255, 80, 30));
                    local v313 = Vector3.new(gx, gy, gz);
                    fxPlaySound({
                        id = "rbxassetid://135676461695962",
                        vol = 1,
                        minDist = 20,
                        maxDist = 700,
                        pitch = 1,
                        x = v313.X,
                        y = v313.Y,
                        z = v313.Z
                    });
                    screenShakeNearby(gx, gy, gz, v312 * 2);

                    if u272.closePortal then
                        local v314 = string.format("%.1f_%.1f_%.1f", px, py, pz);
                        local u315 = u5[v314];

                        if u315 and u315.Parent then
                            pcall(function() -- Line: 1469
                                -- upvalues: u315 (copy)
                                u315:Destroy();
                            end);
                        end;

                        u5[v314] = nil;
                    end;
                end);

                return;
            end;

            if p271 == "SuperSpinWarn" then
                task.spawn(function() -- Line: 1475
                    -- upvalues: u272 (copy), TweenService (ref), CollectionService (ref), u7 (ref)
                    local x = u272.x;
                    local y = u272.y;
                    local z = u272.z;
                    local v316 = u272.r or 20;
                    local v317 = u272.t or 2.5;
                    local v318 = u272.animId or "rbxassetid://TODO";
                    local Part = Instance.new("Part");
                    Part.Shape = Enum.PartType.Cylinder;
                    Part.Size = Vector3.new(0.35, v316 * 2, v316 * 2) * 2;
                    Part.CFrame = CFrame.new(x, y - 28, z) * CFrame.Angles(0, 0, 1.5707963267948966);
                    Part.Anchored = true;
                    Part.CanCollide = false;
                    Part.CastShadow = false;
                    Part.Material = Enum.Material.Neon;
                    Part.Color = Color3.fromRGB(255, 20, 20);
                    Part.Transparency = 0.3;
                    Part.Parent = workspace;
                    local v319 = 0;
                    local v320 = false;

                    while v319 < v317 and Part.Parent do
                        task.wait(0.2);
                        v319 = v319 + 0.2;
                        v320 = not v320;
                        Part.Transparency = v320 and 0.65 or 0.1;
                    end;

                    TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Transparency = 1
                    }):Play();
                    task.wait(0.25);
                    pcall(function() -- Line: 1507
                        -- upvalues: Part (copy)
                        Part:Destroy();
                    end);
                    local v321 = v318:match("rbxassetid://(%d+)") and CollectionService:GetTagged("LuckymatBossNPC")[1];

                    if v321 then
                        local v322 = v321:FindFirstChildOfClass("Humanoid") and v322:FindFirstChildOfClass("Animator");

                        if v322 then
                            local Animation = Instance.new("Animation");
                            Animation.AnimationId = v318;
                            local v323 = v322:LoadAnimation(Animation);
                            v323.Looped = true;
                            v323:Play(0.2);
                            u7 = v323;
                        end;
                    end;
                end);

                return;
            end;

            if p271 == "SuperSpinEnd" then
                if u7 then
                    u7:Stop(0.3);
                    u7 = nil;

                    return;
                end;
            else
                if p271 == "StompWarn" then
                    task.spawn(function() -- Line: 1533
                        -- upvalues: u272 (copy), TweenService (ref)
                        local x = u272.x;
                        local y = u272.y;
                        local z = u272.z;
                        local v324 = u272.r or 18;
                        local v325 = u272.t or 2;
                        local Part = Instance.new("Part");
                        Part.Shape = Enum.PartType.Cylinder;
                        Part.Size = Vector3.new(0.4, v324 * 2, v324 * 2);
                        Part.CFrame = CFrame.new(x, y - 3, z) * CFrame.Angles(0, 0, 1.5707963267948966);
                        Part.Anchored = true;
                        Part.CanCollide = false;
                        Part.CastShadow = false;
                        Part.Material = Enum.Material.Neon;
                        Part.Color = Color3.fromRGB(255, 140, 0);
                        Part.Transparency = 0.35;
                        Part.Parent = workspace;
                        local v326 = 0;
                        local v327 = false;

                        while v326 < v325 and Part.Parent do
                            task.wait(0.2);
                            v326 = v326 + 0.2;
                            v327 = not v327;
                            Part.Transparency = v327 and 0.7 or 0.1;
                        end;

                        TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Transparency = 1
                        }):Play();
                        task.wait(0.25);
                        pcall(function() -- Line: 1564
                            -- upvalues: Part (copy)
                            Part:Destroy();
                        end);
                    end);
                    task.spawn(function() -- Line: 1567
                        -- upvalues: u272 (copy), CollectionService (ref), u8 (ref)
                        local v328 = u272.animId or "rbxassetid://TODO";

                        if not v328:match("rbxassetid://(%d+)") then
                            return;
                        end;

                        local v329 = CollectionService:GetTagged("LuckymatBossNPC")[1];

                        if not v329 then
                            return;
                        end;

                        local v330 = v329:FindFirstChildOfClass("Humanoid") and v330:FindFirstChildOfClass("Animator");

                        if not v330 then
                            return;
                        end;

                        local Animation = Instance.new("Animation");
                        Animation.AnimationId = v328;
                        local v331 = v330:LoadAnimation(Animation);
                        v331.Looped = false;
                        v331:Play(0.15);
                        u8 = v331;
                    end);

                    return;
                end;

                if p271 == "StompImpact" then
                    task.spawn(function() -- Line: 1585
                        -- upvalues: u272 (copy), playBurstBall (ref), screenShakeNearby (ref), u8 (ref)
                        local x = u272.x;
                        local y = u272.y;
                        local z = u272.z;
                        local v332 = u272.r or 18;
                        playBurstBall(x, y - 3, z, v332 * 1.5, Color3.fromRGB(255, 80, 30));
                        screenShakeNearby(x, y, z, v332 * 2.5);

                        if u8 then
                            u8:Stop(0.2);
                            u8 = nil;
                        end;
                    end);

                    return;
                end;

                if p271 == "KingThunderWarn" then
                    task.spawn(function() -- Line: 1596
                        -- upvalues: spawnGroundWarnDisk (ref), u272 (copy)
                        spawnGroundWarnDisk(u272.x or 0, u272.y or 0, u272.z or 0, u272.r or 10, u272.t or 1.1, Color3.fromRGB(120, 180, 255));
                    end);

                    return;
                end;

                if p271 == "KingElectricAim" then
                    task.spawn(function() -- Line: 798
                        -- upvalues: u272 (copy), CollectionService (ref), fxPlaySound (ref), RunService (ref), Players (ref), spawnGroundWarnDisk (ref), TweenService (ref)
                        local npcId = u272.npcId;
                        local userId = u272.userId;
                        local v333 = u272.trackSec or 0.85;
                        local v334 = u272.lockSec or 0.5;

                        if npcId then
                            for _, v in CollectionService:GetTagged("AABossNpc") do
                                if v.Name == npcId then
                                    break;
                                end;
                            end;
                        else
                            local v = nil;
                        end;

                        local v335;

                        if v then
                            v335 = v:FindFirstChild("HumanoidRootPart");
                        else
                            v335 = nil;
                        end;

                        if v335 then
                            local Position = v335.Position;
                            fxPlaySound({
                                id = "rbxassetid://118901970008718",
                                vol = 0.55,
                                minDist = 20,
                                maxDist = 700,
                                pitch = 1,
                                x = Position.X,
                                y = Position.Y,
                                z = Position.Z
                            });
                        end;

                        local Part = Instance.new("Part");
                        Part.Name = "KingElectricAimLaser";
                        Part.Material = Enum.Material.Neon;
                        Part.Color = Color3.fromRGB(120, 200, 255);
                        Part.Anchored = true;
                        Part.CanCollide = false;
                        Part.CanQuery = false;
                        Part.CastShadow = false;
                        Part.Parent = workspace;
                        local v336 = 0;
                        local v337 = nil;

                        while true do
                            if v336 >= v333 or not Part.Parent then
                                if not (Part.Parent and v337) then
                                    pcall(function() -- Line: 838
                                        -- upvalues: Part (copy)
                                        Part:Destroy();
                                    end);

                                    return;
                                end;

                                spawnGroundWarnDisk(v337.X, v337.Y, v337.Z, u272.r or 6, v334, Color3.fromRGB(90, 170, 255));
                                local v338 = 0;

                                while true do
                                    if v338 >= v334 or not Part.Parent then
                                        TweenService:Create(Part, TweenInfo.new(0.06, Enum.EasingStyle.Quad), {
                                            Transparency = 1
                                        }):Play();
                                        task.delay(0.08, function() -- Line: 867
                                            -- upvalues: Part (copy)
                                            pcall(function() -- Line: 868
                                                -- upvalues: Part (ref)
                                                Part:Destroy();
                                            end);
                                        end);

                                        return;
                                    end;

                                    v338 = v338 + RunService.Heartbeat:Wait();

                                    if npcId then
                                        for _, v in CollectionService:GetTagged("AABossNpc") do
                                            if v.Name == npcId then
                                                break;
                                            end;
                                        end;
                                    else
                                        local v = nil;
                                    end;

                                    local v339;

                                    if v then
                                        v339 = v:FindFirstChild("HumanoidRootPart");
                                    else
                                        v339 = nil;
                                    end;

                                    if v339 then
                                        local v340 = math.sin(v338 * 50) * 0.18 + 1;
                                        local v341 = v339.Position + Vector3.new(0, 4, 0);
                                        local v342 = Color3.fromRGB(180, 230, 255);
                                        local v343 = v337 - v341;
                                        local Magnitude = v343.Magnitude;

                                        if Magnitude < 0.05 then
                                            Part.Transparency = 1;
                                        else
                                            Part.Transparency = 0;
                                            Part.Size = Vector3.new(v340, v340, Magnitude);
                                            Part.Color = v342;
                                            Part.CFrame = CFrame.lookAt(v341 + v343 * 0.5, v337);
                                        end;
                                    end;
                                end;
                            end;

                            v336 = v336 + RunService.Heartbeat:Wait();

                            if npcId then
                                for _, v in CollectionService:GetTagged("AABossNpc") do
                                    if v.Name == npcId then
                                        break;
                                    end;
                                end;
                            else
                                local v = nil;
                            end;

                            local v344;

                            if v then
                                v344 = v:FindFirstChild("HumanoidRootPart");
                            else
                                v344 = nil;
                            end;

                            local v345 = Players:GetPlayerByUserId(userId);
                            local v346 = v345 and v345.Character and v345.Character:FindFirstChild("HumanoidRootPart");

                            if v344 and v346 then
                                v337 = v346.Position;
                                local v347 = v344.Position + Vector3.new(0, 4, 0);
                                local v348 = Color3.fromRGB(100, 190, 255);
                                local v349 = v337 - v347;
                                local Magnitude = v349.Magnitude;

                                if Magnitude < 0.05 then
                                    Part.Transparency = 1;
                                else
                                    Part.Transparency = 0;
                                    Part.Size = Vector3.new(1, 1, Magnitude);
                                    Part.Color = v348;
                                    Part.CFrame = CFrame.lookAt(v347 + v349 * 0.5, v337);
                                end;
                            end;
                        end;
                    end);

                    return;
                end;

                if p271 == "KingElectricZap" then
                    fxKingElectricZap(u272);

                    return;
                end;

                if p271 == "KingFireballArc" then
                    task.spawn(function() -- Line: 388
                        -- upvalues: u272 (copy), u6 (ref), fxPlaySound (ref), RunService (ref)
                        local u350 = Vector3.new(u272.px or 0, u272.py or 0, u272.pz or 0);
                        local u351 = Vector3.new(u272.gx or 0, u272.gy or 0, u272.gz or 0);
                        local u352 = u272.travelSec or 1;
                        local Part = Instance.new("Part");
                        Part.Shape = Enum.PartType.Ball;
                        Part.Size = Vector3.new(9.6, 9.6, 9.6);
                        Part.CFrame = CFrame.new(u350);
                        Part.Anchored = true;
                        Part.CanCollide = false;
                        Part.CastShadow = false;
                        Part.Material = Enum.Material.Neon;
                        Part.Color = Color3.fromRGB(255, 100, 20);
                        Part.Transparency = 0;
                        Part.Parent = workspace;
                        table.insert(u6, Part);
                        local PointLight = Instance.new("PointLight", Part);
                        PointLight.Brightness = 8;
                        PointLight.Color = Color3.fromRGB(255, 120, 40);
                        PointLight.Range = 44;
                        local Fire = Instance.new("Fire");
                        Fire.Size = 14;
                        Fire.Parent = Part;
                        fxPlaySound({
                            id = "rbxassetid://80624479410185",
                            vol = 0.85,
                            minDist = 20,
                            maxDist = 700,
                            pitch = 1,
                            x = u350.X,
                            y = u350.Y,
                            z = u350.Z
                        });
                        local v353 = math.clamp((u350 - u351).Magnitude * 0.42, 14, 48);
                        local u354 = (u350 + u351) * 0.5 + Vector3.new(0, v353, 0);
                        local u355 = 0;
                        local u356 = nil;
                        u356 = RunService.RenderStepped:Connect(function(p357) -- Line: 375
                            -- upvalues: u355 (ref), u352 (copy), u350 (copy), u354 (copy), u351 (copy), Part (copy), u356 (ref)
                            u355 = u355 + p357;
                            local v358 = math.clamp(u355 / u352, 0, 1);
                            local v359 = 1 - v358;
                            Part.CFrame = CFrame.new(v359 * v359 * u350 + v359 * 2 * v358 * u354 + v358 * v358 * u351);

                            if v358 >= 1 then
                                u356:Disconnect();
                            end;
                        end);
                        task.wait(u352);
                        local v360 = table.find(u6, Part);

                        if v360 then
                            table.remove(u6, v360);
                        end;

                        pcall(function() -- Line: 421
                            -- upvalues: Part (copy)
                            Part:Destroy();
                        end);
                    end);

                    return;
                end;

                if p271 == "KingThunderStormStart" then
                    fxKingThunderStormStart(u272);

                    return;
                end;

                if p271 == "KingThunderStrike" then
                    fxKingThunderStrike(u272);

                    return;
                end;

                if p271 == "KingElectricBurst" then
                    fxKingElectricBurst(u272);

                    return;
                end;

                if p271 == "KingSlowCast" then
                    fxKingSlowCast(u272);

                    return;
                end;

                if p271 == "KingSlow" then
                    fxKingSlow(u272);

                    return;
                end;

                if p271 == "PillarCarry" then
                    task.spawn(function() -- Line: 1622
                        -- upvalues: u17 (ref), u16 (ref), u15 (ref), u18 (ref), u19 (ref), u272 (copy), CollectionService (ref), Assets (ref)
                        if u17 then
                            u17:Disconnect();
                            u17 = nil;
                        end;

                        if u16 then
                            pcall(function() -- Line: 1625
                                -- upvalues: u16 (ref)
                                u16:Destroy();
                            end);
                            u16 = nil;
                        end;

                        if u15 then
                            pcall(function() -- Line: 1626
                                -- upvalues: u15 (ref)
                                u15:Destroy();
                            end);
                            u15 = nil;
                        end;

                        if u18 then
                            u18:Stop(0);
                            u18 = nil;
                        end;

                        if u19 then
                            u19:Stop(0);
                            u19 = nil;
                        end;

                        local v361 = u272.animId or "rbxassetid://TODO";
                        local v362 = CollectionService:GetTagged("LuckymatBossNPC")[1];

                        if not v362 then
                            return;
                        end;

                        local HumanoidRootPart = v362:FindFirstChild("HumanoidRootPart");

                        if not HumanoidRootPart then
                            return;
                        end;

                        local Pillar = Assets:FindFirstChild("Pillar");

                        if not Pillar then
                            warn("[LuckymatClient] Assets.Pillar not found in RSAAAssetsLuckymat");

                            return;
                        end;

                        local u363 = Pillar:Clone();
                        local v364 = nil;

                        if u363:IsA("BasePart") then
                            v364 = u363;
                        elseif u363:IsA("Model") then
                            v364 = u363.PrimaryPart;

                            if not v364 then
                                for _, descendant in u363:GetDescendants() do
                                    if descendant:IsA("BasePart") then
                                        v364 = descendant;
                                        break;
                                    end;
                                end;
                            end;
                        end;

                        if not v364 then
                            warn("[LuckymatClient] Pillar has no usable BasePart root");
                            pcall(function() -- Line: 1666
                                -- upvalues: u363 (copy)
                                u363:Destroy();
                            end);

                            return;
                        end;

                        if u363:IsA("Model") then
                            for _, descendant in u363:GetDescendants() do
                                if descendant:IsA("BasePart") then
                                    descendant.CanCollide = false;
                                    descendant.CanQuery = false;
                                    descendant.CastShadow = false;
                                    descendant.Anchored = descendant ~= v364;
                                end;
                            end;
                        end;

                        v364.CanCollide = false;
                        v364.CanQuery = false;
                        v364.CastShadow = false;
                        v364.Anchored = false;

                        if u363:IsA("Model") then
                            for _, descendant in u363:GetDescendants() do
                                if descendant:IsA("BasePart") and descendant ~= v364 then
                                    descendant.Anchored = false;
                                    local WeldConstraint = Instance.new("WeldConstraint");
                                    WeldConstraint.Part0 = v364;
                                    WeldConstraint.Part1 = descendant;
                                    WeldConstraint.Parent = v364;
                                end;
                            end;
                        end;

                        u363.Parent = workspace;
                        u15 = u363;
                        local v365 = CFrame.new(2, 1, -1);
                        local Motor6D = Instance.new("Motor6D");
                        Motor6D.Name = "PillarJoint";
                        Motor6D.Part0 = HumanoidRootPart;
                        Motor6D.Part1 = v364;
                        Motor6D.C0 = v365;
                        Motor6D.C1 = CFrame.identity;
                        Motor6D.Parent = HumanoidRootPart;
                        u16 = Motor6D;

                        if v361:match("rbxassetid://(%d+)") then
                            local v366 = v362:FindFirstChildOfClass("Humanoid") and v366:FindFirstChildOfClass("Animator");

                            if v366 then
                                local Animation = Instance.new("Animation");
                                Animation.AnimationId = v361;
                                local v367 = v366:LoadAnimation(Animation);
                                v367.Looped = true;
                                v367:Play(0.2);
                                u18 = v367;
                            end;
                        end;
                    end);

                    return;
                end;

                if p271 == "PillarThrowWarn" then
                    task.spawn(function() -- Line: 1732
                        -- upvalues: u272 (copy), TweenService (ref)
                        local tx = u272.tx;
                        local ty = u272.ty;
                        local tz = u272.tz;
                        local v368 = u272.r or 14;
                        local v369 = u272.t or 2.5;
                        local Part = Instance.new("Part");
                        Part.Shape = Enum.PartType.Cylinder;
                        Part.Size = Vector3.new(0.35, v368 * 2, v368 * 2);
                        Part.CFrame = CFrame.new(tx, ty, tz) * CFrame.Angles(0, 0, 1.5707963267948966);
                        Part.Anchored = true;
                        Part.CanCollide = false;
                        Part.CastShadow = false;
                        Part.Material = Enum.Material.Neon;
                        Part.Color = Color3.fromRGB(160, 100, 60);
                        Part.Transparency = 0.35;
                        Part.Parent = workspace;
                        local v370 = 0;
                        local v371 = false;

                        while v370 < v369 and Part.Parent do
                            task.wait(0.2);
                            v370 = v370 + 0.2;
                            v371 = not v371;
                            Part.Transparency = v371 and 0.7 or 0.1;
                        end;

                        TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Transparency = 1
                        }):Play();
                        task.wait(0.25);
                        pcall(function() -- Line: 1763
                            -- upvalues: Part (copy)
                            Part:Destroy();
                        end);
                    end);

                    return;
                end;

                if p271 == "PillarThrowLaunch" then
                    task.spawn(function() -- Line: 1767
                        -- upvalues: u18 (ref), u16 (ref), u272 (copy), CollectionService (ref), u19 (ref), u15 (ref), u17 (ref), RunService (ref)
                        if u18 then
                            u18:Stop(0.1);
                            u18 = nil;
                        end;

                        if u16 then
                            pcall(function() -- Line: 1771
                                -- upvalues: u16 (ref)
                                u16:Destroy();
                            end);
                            u16 = nil;
                        end;

                        local v372 = u272.throwAnimId or "rbxassetid://TODO";
                        local v373 = v372:match("rbxassetid://(%d+)") and CollectionService:GetTagged("LuckymatBossNPC")[1];

                        if v373 then
                            local v374 = v373:FindFirstChildOfClass("Humanoid") and v374:FindFirstChildOfClass("Animator");

                            if v374 then
                                local Animation = Instance.new("Animation");
                                Animation.AnimationId = v372;
                                local v375 = v374:LoadAnimation(Animation);
                                v375.Looped = false;
                                v375:Play(0.15);
                                u19 = v375;
                            end;
                        end;

                        local u376 = u15;

                        if not (u376 and u376.Parent) then
                            return;
                        end;

                        if u376:IsA("Model") then
                            for _, descendant in u376:GetDescendants() do
                                if descendant:IsA("BasePart") then
                                    descendant.Anchored = true;
                                end;
                            end;
                        elseif u376:IsA("BasePart") then
                            u376.Anchored = true;
                        end;

                        local u377 = Vector3.new(u272.bx, u272.by, u272.bz);
                        local u378 = Vector3.new(u272.tx, u272.ty, u272.tz);
                        local u379 = u272.travelSec or 1.8;
                        local v380 = (u377 + u378) * 0.5;
                        local X = v380.X;
                        local v381 = math.max(u377.Y, u378.Y) + 28;
                        local u382 = Vector3.new(X, v381, v380.Z);
                        local u383 = 0;

                        if u17 then
                            u17:Disconnect();
                            u17 = nil;
                        end;

                        u17 = RunService.Heartbeat:Connect(function(p384) -- Line: 1825
                            -- upvalues: u376 (copy), u17 (ref), u383 (ref), u379 (copy), u377 (copy), u382 (copy), u378 (copy), u15 (ref)
                            if not (u376 and u376.Parent) then
                                if u17 then
                                    u17:Disconnect();
                                    u17 = nil;
                                end;

                                return;
                            end;

                            u383 = u383 + p384;
                            local v385 = math.min(u383 / u379, 1);
                            local v386 = 1 - v385;
                            local v387 = CFrame.new(v386 * v386 * u377 + v386 * 2 * v385 * u382 + v385 * v385 * u378) * CFrame.Angles(v385 * 3.141592653589793 * 2, v385 * 3.141592653589793 * 0.4, 0);

                            if u376:IsA("Model") then
                                u376:PivotTo(v387);
                            else
                                u376.CFrame = v387;
                            end;

                            if v385 >= 1 then
                                if u17 then
                                    u17:Disconnect();
                                    u17 = nil;
                                end;

                                pcall(function() -- Line: 1852
                                    -- upvalues: u376 (ref)
                                    u376:Destroy();
                                end);

                                if u15 == u376 then
                                    u15 = nil;
                                end;
                            end;
                        end);
                    end);

                    return;
                end;

                if p271 == "PillarThrowImpact" then
                    task.spawn(function() -- Line: 1859
                        -- upvalues: u272 (copy), u17 (ref), u15 (ref), u19 (ref), playBurstBall (ref), screenShakeNearby (ref)
                        local x = u272.x;
                        local y = u272.y;
                        local z = u272.z;
                        local v388 = u272.r or 16;

                        if u17 then
                            u17:Disconnect();
                            u17 = nil;
                        end;

                        if u15 and u15.Parent then
                            pcall(function() -- Line: 1866
                                -- upvalues: u15 (ref)
                                u15:Destroy();
                            end);
                            u15 = nil;
                        end;

                        if u19 then
                            u19:Stop(0.2);
                            u19 = nil;
                        end;

                        playBurstBall(x, y, z, v388 * 1.5, Color3.fromRGB(255, 80, 30));
                        screenShakeNearby(x, y, z, v388 * 2);
                    end);

                    return;
                end;

                if p271 == "FirePillarSurgeWarn" then
                    task.spawn(function() -- Line: 1876
                        -- upvalues: u272 (copy), TweenService (ref)
                        local x = u272.x;
                        local y = u272.y;
                        local z = u272.z;
                        local v389 = u272.r or 8;
                        local v390 = u272.t or 2;
                        local Part = Instance.new("Part");
                        Part.Shape = Enum.PartType.Cylinder;
                        Part.Size = Vector3.new(0.35, v389 * 2, v389 * 2);
                        Part.CFrame = CFrame.new(x, y, z) * CFrame.Angles(0, 0, 1.5707963267948966);
                        Part.Anchored = true;
                        Part.CanCollide = false;
                        Part.CastShadow = false;
                        Part.Material = Enum.Material.Neon;
                        Part.Color = Color3.fromRGB(255, 40, 0);
                        Part.Transparency = 0.35;
                        Part.Parent = workspace;
                        local v391 = 0;
                        local v392 = false;

                        while v391 < v390 and Part.Parent do
                            task.wait(0.2);
                            v391 = v391 + 0.2;
                            v392 = not v392;
                            Part.Transparency = v392 and 0.7 or 0.1;
                        end;

                        TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Transparency = 1
                        }):Play();
                        task.wait(0.25);
                        pcall(function() -- Line: 1907
                            -- upvalues: Part (copy)
                            Part:Destroy();
                        end);
                    end);

                    return;
                end;

                if p271 == "FirePillarSurgeImpact" then
                    task.spawn(function() -- Line: 1911
                        -- upvalues: u272 (copy), u12 (ref), Assets (ref), screenShakeNearby (ref), RunService (ref), TweenService (ref)
                        local x = u272.x;
                        local y = u272.y;
                        local z = u272.z;
                        local v393 = u272.r or 8;
                        local u394 = u272.riseSec or 0.35;

                        if u12 and u12.Parent then
                            pcall(function() -- Line: 1918
                                -- upvalues: u12 (ref)
                                u12:Destroy();
                            end);
                        end;

                        u12 = nil;
                        local FirePillar = Assets:FindFirstChild("FirePillar");

                        if not FirePillar then
                            warn("[LuckymatClient] Assets.FirePillar not found in RSAAAssetsLuckymat");
                            screenShakeNearby(x, y, z, v393 * 2.5);

                            return;
                        end;

                        local u395 = FirePillar:Clone();
                        local u396 = nil;

                        if u395:IsA("BasePart") then
                            u396 = u395;
                        elseif u395:IsA("Model") then
                            u396 = u395.PrimaryPart;

                            if not u396 then
                                for _, descendant in u395:GetDescendants() do
                                    if descendant:IsA("BasePart") then
                                        u396 = descendant;
                                        break;
                                    end;
                                end;
                            end;
                        end;

                        if not u396 then
                            warn("[LuckymatClient] FirePillar has no usable BasePart root");
                            pcall(function() -- Line: 1947
                                -- upvalues: u395 (copy)
                                u395:Destroy();
                            end);
                            screenShakeNearby(x, y, z, v393 * 2.5);

                            return;
                        end;

                        local function setPillarPart(p397) -- Line: 1953
                            p397.Anchored = true;
                            p397.CanCollide = false;
                            p397.CanQuery = false;
                            p397.CastShadow = false;
                        end;

                        u396.Anchored = true;
                        u396.CanCollide = false;
                        u396.CanQuery = false;
                        u396.CastShadow = false;

                        if u395:IsA("Model") then
                            for _, descendant in u395:GetDescendants() do
                                if descendant:IsA("BasePart") then
                                    descendant.Anchored = true;
                                    descendant.CanCollide = false;
                                    descendant.CanQuery = false;
                                    descendant.CastShadow = false;
                                end;
                            end;
                        end;

                        local u398 = y - u396.Size.Y / 2 - 2;
                        local u399 = y + 4;

                        if u395:IsA("Model") then
                            u395:PivotTo(CFrame.new(x, u398, z));
                        else
                            u396.CFrame = CFrame.new(x, u398, z);
                        end;

                        u395.Parent = workspace;
                        u12 = u395;
                        local u400 = 0;
                        local u401 = nil;
                        u401 = RunService.Heartbeat:Connect(function(p402) -- Line: 1983
                            -- upvalues: u395 (copy), u401 (ref), u400 (ref), u394 (copy), u398 (copy), u399 (copy), x (copy), z (copy), u396 (ref)
                            if not (u395 and u395.Parent) then
                                u401:Disconnect();

                                return;
                            end;

                            u400 = u400 + p402;
                            local v403 = math.min(u400 / u394, 1);
                            local v404 = v403 - 1;
                            local v405 = u398 + (u399 - u398) * (v404 * v404 * (v404 * 2.70158 + 1.70158) + 1);

                            if u395:IsA("Model") then
                                u395:PivotTo(CFrame.new(x, v405, z));
                            else
                                u396.CFrame = CFrame.new(x, v405, z);
                            end;

                            if v403 >= 1 then
                                u401:Disconnect();
                            end;
                        end);
                        screenShakeNearby(x, y, z, v393 * 2.5);
                        task.wait(u394 + 0.8);

                        if u395 and u395.Parent then
                            local v406 = {};

                            if u395:IsA("BasePart") then
                                table.insert(v406, u395);
                            elseif u395:IsA("Model") then
                                for _, descendant in u395:GetDescendants() do
                                    if descendant:IsA("BasePart") then
                                        table.insert(v406, descendant);
                                    end;
                                end;
                            end;

                            for _, v in v406 do
                                TweenService:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                    Transparency = 1
                                }):Play();
                            end;

                            task.wait(0.45);
                            pcall(function() -- Line: 2022
                                -- upvalues: u395 (copy)
                                u395:Destroy();
                            end);

                            if u12 == u395 then
                                u12 = nil;
                            end;
                        end;
                    end);

                    return;
                end;

                if p271 == "GravitySmashLift" then
                    task.spawn(function() -- Line: 2028
                        -- upvalues: u272 (copy), TweenService (ref)
                        local v407 = u272.liftSec or 0.7;
                        local v408 = v407 + (u272.holdSec or 1);
                        local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
                        ColorCorrectionEffect.TintColor = Color3.fromRGB(255, 255, 255);
                        ColorCorrectionEffect.Brightness = 0;
                        ColorCorrectionEffect.Saturation = 0;
                        ColorCorrectionEffect.Parent = game:GetService("Lighting");
                        TweenService:Create(ColorCorrectionEffect, TweenInfo.new(v407 * 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Brightness = -0.06,
                            Saturation = 0.25,
                            TintColor = Color3.fromRGB(140, 70, 220)
                        }):Play();
                        task.wait(v408 - 0.35);
                        TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Brightness = 0,
                            Saturation = 0,
                            TintColor = Color3.fromRGB(255, 255, 255)
                        }):Play();
                        task.wait(0.55);
                        pcall(function() -- Line: 2053
                            -- upvalues: ColorCorrectionEffect (copy)
                            ColorCorrectionEffect:Destroy();
                        end);
                    end);

                    return;
                end;

                if p271 == "GravitySmashCrash" then
                    task.spawn(function() -- Line: 2057
                        -- upvalues: Players (ref), playBurstBall (ref), screenShakeNearby (ref)
                        local Character = Players.LocalPlayer.Character;

                        if not Character then
                            return;
                        end;

                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if not HumanoidRootPart then
                            return;
                        end;

                        local Position = HumanoidRootPart.Position;
                        playBurstBall(Position.X, Position.Y - 3, Position.Z, 12, Color3.fromRGB(255, 80, 30));
                        screenShakeNearby(Position.X, Position.Y, Position.Z, 60);
                    end);

                    return;
                end;

                if p271 == "OpeningCutscene" then
                    task.spawn(function() -- Line: 2068
                        -- upvalues: u272 (copy), LuckymatCutscenes (ref)
                        local v409 = workspace:FindFirstChild(u272.mapName, true);

                        if v409 then
                            LuckymatCutscenes.init(v409);
                            LuckymatCutscenes.playOpening();
                        end;
                    end);

                    return;
                end;

                if p271 == "EndingCutscene" then
                    task.spawn(function() -- Line: 2077
                        -- upvalues: u272 (copy), LuckymatCutscenes (ref)
                        if workspace:FindFirstChild(u272.mapName, true) then
                            LuckymatCutscenes.playEnding();
                        end;
                    end);

                    return;
                end;

                if p271 == "PhaseRoar" then
                    task.spawn(function() -- Line: 2085
                        -- upvalues: u272 (copy), fxPlaySound (ref), screenShakeNearby (ref)
                        local v410 = u272.x or 0;
                        local v411 = u272.y or 0;
                        local v412 = u272.z or 0;
                        local v413 = Vector3.new(v410, v411, v412);
                        fxPlaySound({
                            id = "rbxassetid://140076040328382",
                            vol = 1.2,
                            minDist = 40,
                            maxDist = 1200,
                            pitch = 1,
                            x = v413.X,
                            y = v413.Y,
                            z = v413.Z
                        });
                        screenShakeNearby(v410, v411, v412, 100);
                    end);

                    return;
                end;

                if p271 == "PhaseMobExplode" then
                    task.spawn(function() -- Line: 2094
                        -- upvalues: u272 (copy), cloneThunderHitAt (ref), playBurstBall (ref), fxPlaySound (ref), screenShakeNearby (ref)
                        local v414 = u272.x or 0;
                        local v415 = u272.y or 0;
                        local v416 = u272.z or 0;
                        local v417 = u272.r or 14;
                        local v418 = Vector3.new(v414, v415, v416);
                        cloneThunderHitAt(v418);
                        playBurstBall(v414, v415, v416, v417 * 1.75, Color3.fromRGB(255, 80, 30));
                        fxPlaySound({
                            id = "rbxassetid://135676461695962",
                            vol = 1,
                            minDist = 20,
                            maxDist = 700,
                            pitch = 1,
                            x = v418.X,
                            y = v418.Y,
                            z = v418.Z
                        });
                        fxPlaySound({
                            id = "rbxassetid://139520673393967",
                            vol = 0.65,
                            minDist = 20,
                            maxDist = 700,
                            pitch = 1,
                            x = v418.X,
                            y = v418.Y,
                            z = v418.Z
                        });
                        screenShakeNearby(v414, v415, v416, v417 * 2.5);
                    end);

                    return;
                end;

                if p271 == "PhaseChange" then
                    local v419 = u272.phase or 0;

                    if v419 >= 4 then
                        LuckymatCutscenes.stopBossIdle();
                    end;

                    if v419 == 5 and not u13 then
                        local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
                        ColorCorrectionEffect.TintColor = Color3.fromRGB(255, 255, 255);
                        ColorCorrectionEffect.Brightness = 0;
                        ColorCorrectionEffect.Saturation = 0;
                        ColorCorrectionEffect.Parent = game:GetService("Lighting");
                        TweenService:Create(ColorCorrectionEffect, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Brightness = -0.04,
                            Saturation = 0.12,
                            TintColor = Color3.fromRGB(255, 200, 200)
                        }):Play();
                        u13 = ColorCorrectionEffect;

                        return;
                    end;
                elseif p271 == "ShowBossMessage" then
                    local message = u272.message;

                    if type(message) ~= "string" or message == "" then
                        return;
                    end;

                    local u420 = u272.senderId or LuckymatConfig.DefaultSenderId;
                    local voiceline = u272.voiceline;
                    local u421 = u272.duration or 8;
                    task.spawn(function() -- Line: 2133
                        -- upvalues: Players (ref), u420 (copy), FakeAdminMessageUtil (ref), message (copy), u421 (copy)
                        local success, result = pcall(function() -- Line: 2134
                            -- upvalues: Players (ref), u420 (ref)
                            return Players:GetNameFromUserIdAsync(u420);
                        end);
                        FakeAdminMessageUtil.show({
                            message = message,
                            senderName = success and result and result or "User" .. u420,
                            senderUserId = u420,
                            preloadedThumb = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(u420),
                            duration = u421
                        });
                    end);

                    if voiceline and LuckymatConfig.VoicelineSoundIds then
                        local v422 = LuckymatConfig.VoicelineSoundIds[voiceline];

                        if type(v422) == "string" and v422 ~= "" then
                            fxPlaySound({
                                global = true,
                                vol = 1,
                                id = v422
                            });
                        end;
                    end;
                end;
            end;
        end;

        return;
    end;

    if u272.userId ~= Players.LocalPlayer.UserId then
        return;
    end;

    SoundManager:Play("WIN");

    if not u1 then
        u1 = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
    end;

    u1:ShowGeneralNotification("Healed to full HP!", Color3.fromRGB(100, 255, 120), 2);
end;

local u423 = nil;

return {
    IsAdminAbuse = true,
    NeedsDuration = false,
    SkipDoorTransition = LuckymatConfig.SkipDoorTransition,
    SkipDoorCamera = LuckymatConfig.SkipDoorCamera,

    Fire = function(p424) -- Line: 2163, Name: Fire
        -- upvalues: u423 (ref), cleanupCosmetics (copy), getBoostFrame (copy), u14 (ref), u11 (ref), RunService (copy), u10 (ref), u9 (ref), Players (copy), u2 (ref), ReplicatedStorage (copy), u3 (ref), preloadSenderThumbs (copy), BossClientBase (copy), LuckymatConfig (copy), handleFx (copy), LuckymatCutscenes (copy)
        if u423 then
            u423:stop();
        end;

        cleanupCosmetics();
        local v425 = getBoostFrame();

        if v425 then
            u14 = v425.Visible;
            v425.Visible = false;
        end;

        if not u11 then
            u11 = RunService.RenderStepped:Connect(function() -- Line: 104
                -- upvalues: u10 (ref), u9 (ref), Players (ref), u2 (ref), ReplicatedStorage (ref), u3 (ref)
                if u10 <= os.clock() then
                    u9 = 1;

                    return;
                end;

                if u9 >= 1 then
                    return;
                end;

                local LocalPlayer = Players.LocalPlayer;
                local v426 = LocalPlayer:GetAttribute("LuckymatKingSlowMult");
                local v427 = LocalPlayer:GetAttribute("LuckymatKingSlowUntil");

                if type(v426) ~= "number" or (type(v427) ~= "number" or v427 <= os.clock()) then
                    u9 = 1;

                    return;
                end;

                u9 = v426;
                local v428 = LocalPlayer.Character and v428:FindFirstChildOfClass("Humanoid");

                if v428 then
                    if not u2 then
                        u2 = require(ReplicatedStorage:WaitForChild("ClientState"));
                    end;

                    if not u3 then
                        u3 = require(ReplicatedStorage:WaitForChild("Config"));
                    end;

                    local v429 = u2:Get();
                    local v430;

                    if v429.CustomWalkSpeed and v429.CustomWalkSpeed > 0 then
                        v430 = v429.CustomWalkSpeed;
                    else
                        v430 = u3.CalculateMaxSpeed(v429.Level or 1);
                    end;

                    v428.WalkSpeed = v430 * u9;
                end;
            end);
        end;

        preloadSenderThumbs();
        local u431 = false;
        local u432 = false;
        u423 = BossClientBase.new({
            sseChannelName = "LuckymatBossRoom",
            bossDisplayName = "LuckyMat",
            bossIcon = LuckymatConfig.bossIcon,
            phaseThresholds = LuckymatConfig.PHASE_THRESHOLDS,

            onFx = function(p433, p434) -- Line: 2179, Name: onFx
                -- upvalues: u431 (ref), u432 (ref), handleFx (ref)
                if p433 == "OpeningCutscene" then
                    if u431 then
                        return;
                    end;

                    u431 = true;
                elseif p433 == "EndingCutscene" then
                    if u432 then
                        return;
                    end;

                    u432 = true;
                end;

                handleFx(p433, p434);
            end
        });
        u423:fire();
        local _sse = u423._sse;

        if _sse then
            _sse:onChange("OpeningCutscene", function(p435) -- Line: 2195
                -- upvalues: u431 (ref), LuckymatCutscenes (ref)
                if type(p435) == "table" and (p435.mapName and not u431) then
                    local mapName = p435.mapName;
                    task.delay(5, function() -- Line: 2198
                        -- upvalues: u431 (ref), mapName (copy), LuckymatCutscenes (ref)
                        if not u431 then
                            u431 = true;
                            local u436 = {
                                mapName = mapName
                            };
                            task.spawn(function() -- Line: 2068
                                -- upvalues: u436 (copy), LuckymatCutscenes (ref)
                                local v437 = workspace:FindFirstChild(u436.mapName, true);

                                if v437 then
                                    LuckymatCutscenes.init(v437);
                                    LuckymatCutscenes.playOpening();
                                end;
                            end);
                        end;
                    end);
                end;
            end);
        end;
    end,

    Stop = function() -- Line: 2209, Name: Stop
        -- upvalues: u423 (ref), cleanupCosmetics (copy), getBoostFrame (copy), u14 (ref)
        if u423 then
            u423:stop();
            u423 = nil;
        end;

        cleanupCosmetics();
        local v438 = getBoostFrame();

        if v438 and u14 ~= nil then
            v438.Visible = u14;
        end;

        u14 = nil;
    end
};