-- Ruta Original: ReplicatedStorage.EggRainClient
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local ContentProvider = game:GetService("ContentProvider");
local RunService = game:GetService("RunService");
local Lighting = game:GetService("Lighting");
local Debris = game:GetService("Debris");
local SoundService = game:GetService("SoundService");
local EventsConfig = require(ReplicatedStorage:WaitForChild("EventsConfig"));
local LightingSnapshot = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("Events"):WaitForChild("LightingSnapshot"));
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local v1 = {};
local EggRain = EventsConfig.EggRain;

if not EggRain then
    return v1;
end;

local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local Templates = ReplicatedStorage:WaitForChild("Templates");
local u2 = false;
local u3 = {};
local u4 = nil;

local function setPartsTransparency(p5, p6) -- Line: 37
    if p5:IsA("BasePart") then
        p5.Transparency = p6;
        p5.CanCollide = false;
    end;

    for _, descendant in ipairs(p5:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Transparency = p6;
            descendant.CanCollide = false;
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            descendant.Transparency = p6;
        end;
    end;
end;

local function playSpawnSound(p7) -- Line: 56
    -- upvalues: EggRain (copy)
    local Sound = Instance.new("Sound");
    Sound.SoundId = EggRain.SpawnSound;
    Sound.Volume = EggRain.SpawnSoundVolume or 1;
    Sound.RollOffMaxDistance = 150;
    Sound.RollOffMinDistance = 10;
    local Part = Instance.new("Part");
    Part.Size = Vector3.new(1, 1, 1);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CFrame = CFrame.new(p7);
    Part.Parent = workspace;
    Sound.Parent = Part;
    Sound:Play();
    game:GetService("Debris"):AddItem(Part, 5);
end;

local function hideEgg(p8) -- Line: 78
    -- upvalues: u3 (copy), CollectionService (copy), setPartsTransparency (copy), EggRain (copy), PlayerGui (copy), Debris (copy)
    u3[p8] = true;

    for _, v in ipairs(CollectionService:GetTagged("EggRainEgg")) do
        if v:GetAttribute("EggId") == p8 then
            setPartsTransparency(v, 1);
            break;
        end;
    end;

    if EggRain.CollectSound then
        local Sound = Instance.new("Sound");
        Sound.SoundId = EggRain.CollectSound;
        Sound.Volume = EggRain.CollectSoundVol or 1;
        Sound.Parent = PlayerGui;
        Sound:Play();
        Debris:AddItem(Sound, 3);
    end;
end;

local u9 = EggRain.AnnounceDuration or 10;
local u10 = EggRain.AnnounceFadeIn or 0.4;
local u11 = EggRain.AnnounceFadeOut or 0.5;
local NotificationFrame = ReplicatedStorage:WaitForChild("NotificationFrame");

local function getGradients(p12) -- Line: 110
    local v13 = {};

    for _, descendant in ipairs(p12:GetDescendants()) do
        if descendant:IsA("UIGradient") then
            table.insert(v13, {
                obj = descendant,
                original = descendant.Transparency
            });
        end;
    end;

    return v13;
end;

local function getAllVisuals(p14) -- Line: 120
    local v15 = {};

    for _, descendant in ipairs(p14:GetDescendants()) do
        if descendant:IsA("UIStroke") then
            table.insert(v15, {
                prop = "Transparency",
                obj = descendant
            });
        elseif descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            table.insert(v15, {
                prop = "TextTransparency",
                obj = descendant
            });

            if descendant.BackgroundTransparency < 1 then
                table.insert(v15, {
                    prop = "BackgroundTransparency",
                    obj = descendant
                });
            end;
        elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
            table.insert(v15, {
                prop = "ImageTransparency",
                obj = descendant
            });

            if descendant.BackgroundTransparency < 1 then
                table.insert(v15, {
                    prop = "BackgroundTransparency",
                    obj = descendant
                });
            end;
        elseif descendant:IsA("Frame") and descendant.BackgroundTransparency < 1 then
            table.insert(v15, {
                prop = "BackgroundTransparency",
                obj = descendant
            });
        end;
    end;

    if p14:IsA("Frame") and p14.BackgroundTransparency < 1 then
        table.insert(v15, {
            prop = "BackgroundTransparency",
            obj = p14
        });
    end;

    return v15;
end;

local function showAnnouncement(p16) -- Line: 145
    -- upvalues: PlayerGui (copy), NotificationFrame (copy), EggRain (copy), getAllVisuals (copy), getGradients (copy), u10 (copy), TweenService (copy), u9 (copy), u11 (copy)
    local v17 = PlayerGui:FindFirstChild("AdminAnnounce") and v17:FindFirstChild("MainFrame");

    if not v17 then
        warn("[EggRainClient] AdminAnnounce/MainFrame introuvable dans PlayerGui");

        return;
    end;

    local u18 = NotificationFrame:Clone();
    u18.ZIndex = 100;
    local Text = u18:FindFirstChild("Text");

    if Text then
        Text.ZIndex = 101;
        Text.RichText = true;
        Text.Text = "<font color=\"rgb(85,170,255)\"><b>" .. (EggRain.AdminUsername or "Admin") .. "</b></font> : " .. p16;
    end;

    local Avatar = u18:FindFirstChild("Avatar");

    if Avatar and Avatar:IsA("ImageLabel") then
        Avatar.ZIndex = 101;
    end;

    local u19 = getAllVisuals(u18);
    local u20 = getGradients(u18);
    local v21 = {};

    for i, v in ipairs(u19) do
        v21[i] = v.obj[v.prop];
        v.obj[v.prop] = 1;
    end;

    local u22 = NumberSequence.new(1);

    for _, v in ipairs(u20) do
        v.obj.Transparency = u22;
    end;

    u18.Parent = v17;

    if EggRain.AnnounceSound then
        local Sound = Instance.new("Sound");
        Sound.SoundId = EggRain.AnnounceSound;
        Sound.Volume = EggRain.AnnounceSoundVol or 0.8;
        Sound.Parent = PlayerGui;
        Sound:Play();
        game:GetService("Debris"):AddItem(Sound, 5);
    end;

    local v23 = TweenInfo.new(u10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

    for i, v in ipairs(u19) do
        TweenService:Create(v.obj, v23, {
            [v.prop] = v21[i]
        }):Play();
    end;

    for _, v in ipairs(u20) do
        v.obj.Transparency = v.original;
    end;

    task.delay(u9, function() -- Line: 204
        -- upvalues: u11 (ref), u19 (copy), TweenService (ref), u20 (copy), u22 (copy), u18 (copy)
        local v24 = TweenInfo.new(u11, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

        for _, v in ipairs(u19) do
            TweenService:Create(v.obj, v24, {
                [v.prop] = 1
            }):Play();
        end;

        for _, v in ipairs(u20) do
            v.obj.Transparency = u22;
        end;

        task.delay(u11, function() -- Line: 213
            -- upvalues: u18 (ref)
            if u18 and u18.Parent then
                u18:Destroy();
            end;
        end);
    end);
end;

local GoldenEggNotifFrame = Templates:WaitForChild("GoldenEggNotifFrame");

local function showGoldenNotif() -- Line: 225
    -- upvalues: PlayerGui (copy), GoldenEggNotifFrame (copy), getAllVisuals (copy), getGradients (copy), EggRain (copy), Debris (copy), TweenService (copy)
    local v25 = PlayerGui:FindFirstChild("SpecialNotif") and v25:FindFirstChild("MainFrame");

    if not v25 then
        warn("[EggRainClient] SpecialNotif/MainFrame introuvable dans PlayerGui");

        return;
    end;

    local u26 = GoldenEggNotifFrame:Clone();
    local u27 = getAllVisuals(u26);
    local u28 = getGradients(u26);
    local v29 = {};

    for i, v in ipairs(u27) do
        v29[i] = v.obj[v.prop];
        v.obj[v.prop] = 1;
    end;

    local u30 = NumberSequence.new(1);

    for _, v in ipairs(u28) do
        v.obj.Transparency = u30;
    end;

    u26.Parent = v25;

    if EggRain.GoldenNotifSound then
        local Sound = Instance.new("Sound");
        Sound.SoundId = EggRain.GoldenNotifSound;
        Sound.Volume = EggRain.GoldenNotifSVol or 1;
        Sound.Parent = PlayerGui;
        Sound:Play();
        Debris:AddItem(Sound, 5);
    end;

    local v31 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

    for i, v in ipairs(u27) do
        TweenService:Create(v.obj, v31, {
            [v.prop] = v29[i]
        }):Play();
    end;

    for _, v in ipairs(u28) do
        v.obj.Transparency = v.original;
    end;

    task.delay(EggRain.GoldenNotifDuration or 3, function() -- Line: 270
        -- upvalues: u27 (copy), TweenService (ref), u28 (copy), u30 (copy), u26 (copy)
        local v32 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

        for _, v in ipairs(u27) do
            TweenService:Create(v.obj, v32, {
                [v.prop] = 1
            }):Play();
        end;

        for _, v in ipairs(u28) do
            v.obj.Transparency = u30;
        end;

        task.delay(0.6, function() -- Line: 278
            -- upvalues: u26 (ref)
            if u26 and u26.Parent then
                u26:Destroy();
            end;
        end);
    end);
end;

local u33 = false;

local function saveOriginalSky() -- Line: 290
    -- upvalues: u33 (ref), LightingSnapshot (copy), Lighting (copy)
    if u33 then
        return;
    end;

    u33 = true;
    LightingSnapshot.acquireShared();

    if not Lighting:FindFirstChild("EggRainCC") then
        local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
        ColorCorrectionEffect.Name = "EggRainCC";
        ColorCorrectionEffect.Parent = Lighting;
    end;
end;

local function rgbTable(p34) -- Line: 302
    if type(p34) == "table" and #p34 >= 3 then
        return Color3.fromRGB(p34[1], p34[2], p34[3]);
    end;

    return Color3.fromRGB(255, 255, 255);
end;

local function applySky(p35, p36) -- Line: 309
    -- upvalues: u33 (ref), LightingSnapshot (copy), Lighting (copy), TweenService (copy)
    if not p35 then
        return;
    end;

    if not u33 then
        u33 = true;
        LightingSnapshot.acquireShared();

        if not Lighting:FindFirstChild("EggRainCC") then
            local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
            ColorCorrectionEffect.Name = "EggRainCC";
            ColorCorrectionEffect.Parent = Lighting;
        end;
    end;

    if p36 then
        if p35.Brightness then
            Lighting.Brightness = p35.Brightness;
        end;

        if p35.Ambient then
            local Ambient = p35.Ambient;
            local v37;

            if type(Ambient) == "table" and #Ambient >= 3 then
                v37 = Color3.fromRGB(Ambient[1], Ambient[2], Ambient[3]);
            else
                v37 = Color3.fromRGB(255, 255, 255);
            end;

            Lighting.Ambient = v37;
        end;

        if p35.OutdoorAmbient then
            local OutdoorAmbient = p35.OutdoorAmbient;
            local v38;

            if type(OutdoorAmbient) == "table" and #OutdoorAmbient >= 3 then
                v38 = Color3.fromRGB(OutdoorAmbient[1], OutdoorAmbient[2], OutdoorAmbient[3]);
            else
                v38 = Color3.fromRGB(255, 255, 255);
            end;

            Lighting.OutdoorAmbient = v38;
        end;

        if p35.FogEnd then
            Lighting.FogEnd = p35.FogEnd;
        end;

        if p35.FogColor then
            local FogColor = p35.FogColor;
            local v39;

            if type(FogColor) == "table" and #FogColor >= 3 then
                v39 = Color3.fromRGB(FogColor[1], FogColor[2], FogColor[3]);
            else
                v39 = Color3.fromRGB(255, 255, 255);
            end;

            Lighting.FogColor = v39;
        end;

        local EggRainCC = Lighting:FindFirstChild("EggRainCC");

        if EggRainCC then
            if p35.Saturation then
                EggRainCC.Saturation = p35.Saturation;
            end;

            if p35.ColorTint then
                local ColorTint = p35.ColorTint;
                local v40;

                if type(ColorTint) == "table" and #ColorTint >= 3 then
                    v40 = Color3.fromRGB(ColorTint[1], ColorTint[2], ColorTint[3]);
                else
                    v40 = Color3.fromRGB(255, 255, 255);
                end;

                EggRainCC.TintColor = v40;
            end;
        end;

        return;
    end;

    local v41 = TweenInfo.new(p35.SkyTween or 2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
    local v42 = {};

    if p35.Brightness then
        v42.Brightness = p35.Brightness;
    end;

    if p35.Ambient then
        local Ambient = p35.Ambient;
        local v43;

        if type(Ambient) == "table" and #Ambient >= 3 then
            v43 = Color3.fromRGB(Ambient[1], Ambient[2], Ambient[3]);
        else
            v43 = Color3.fromRGB(255, 255, 255);
        end;

        v42.Ambient = v43;
    end;

    if p35.OutdoorAmbient then
        local OutdoorAmbient = p35.OutdoorAmbient;
        local v44;

        if type(OutdoorAmbient) == "table" and #OutdoorAmbient >= 3 then
            v44 = Color3.fromRGB(OutdoorAmbient[1], OutdoorAmbient[2], OutdoorAmbient[3]);
        else
            v44 = Color3.fromRGB(255, 255, 255);
        end;

        v42.OutdoorAmbient = v44;
    end;

    if p35.FogEnd then
        v42.FogEnd = p35.FogEnd;
    end;

    if p35.FogColor then
        local FogColor = p35.FogColor;
        local v45;

        if type(FogColor) == "table" and #FogColor >= 3 then
            v45 = Color3.fromRGB(FogColor[1], FogColor[2], FogColor[3]);
        else
            v45 = Color3.fromRGB(255, 255, 255);
        end;

        v42.FogColor = v45;
    end;

    if next(v42) then
        TweenService:Create(Lighting, v41, v42):Play();
    end;

    local EggRainCC = Lighting:FindFirstChild("EggRainCC");

    if EggRainCC then
        local v46 = {};

        if p35.Saturation then
            v46.Saturation = p35.Saturation;
        end;

        if p35.ColorTint then
            local ColorTint = p35.ColorTint;
            local v47;

            if type(ColorTint) == "table" and #ColorTint >= 3 then
                v47 = Color3.fromRGB(ColorTint[1], ColorTint[2], ColorTint[3]);
            else
                v47 = Color3.fromRGB(255, 255, 255);
            end;

            v46.TintColor = v47;
        end;

        if next(v46) then
            TweenService:Create(EggRainCC, v41, v46):Play();
        end;
    end;
end;

local function restoreSky() -- Line: 354
    -- upvalues: u33 (ref), EggRain (copy), LightingSnapshot (copy), Lighting (copy), TweenService (copy)
    if not u33 then
        return;
    end;

    u33 = false;
    local v48 = EggRain.SkyRestoreDuration or 3;
    LightingSnapshot.releaseShared(v48);
    local v49 = TweenInfo.new(v48, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
    local EggRainCC = Lighting:FindFirstChild("EggRainCC");

    if EggRainCC then
        TweenService:Create(EggRainCC, v49, {
            Saturation = 0,
            TintColor = Color3.fromRGB(255, 255, 255)
        }):Play();
        task.delay(v48 + 0.5, function() -- Line: 367
            -- upvalues: EggRainCC (copy)
            if EggRainCC and EggRainCC.Parent then
                EggRainCC:Destroy();
            end;
        end);
    end;
end;

local u50 = nil;
local u51 = 0;
local u52 = 0;
local u53 = nil;

local function startShake(p54) -- Line: 383
    -- upvalues: u52 (ref), u53 (ref), EggRain (copy), u51 (ref), u50 (ref), RunService (copy), LocalPlayer (copy)
    u52 = p54 or 0;

    if u52 <= 0 then
        return;
    end;

    if u53 then
        task.cancel(u53);
        u53 = nil;
    end;

    local u55 = EggRain.ShakeFadeIn or 0.5;
    task.spawn(function() -- Line: 395
        -- upvalues: u51 (ref), u52 (ref), u55 (copy)
        local v56 = tick();

        while u51 < u52 and tick() - v56 < u55 do
            local v57 = (tick() - v56) / u55;
            u51 = u52 * math.min(1, v57);
            task.wait();
        end;

        u51 = u52;
    end);

    if u50 then
        return;
    end;

    u50 = RunService.RenderStepped:Connect(function() -- Line: 407
        -- upvalues: LocalPlayer (ref), u51 (ref)
        local v58 = LocalPlayer.Character and v58:FindFirstChildOfClass("Humanoid");

        if v58 and u51 > 0 then
            local v59 = (math.random() - 0.5) * 2 * u51;
            local v60 = (math.random() - 0.5) * 2 * u51;
            local v61 = (math.random() - 0.5) * 2 * u51;
            v58.CameraOffset = Vector3.new(v59, v60, v61);
        end;
    end);
end;

local function stopShake() -- Line: 419
    -- upvalues: u52 (ref), EggRain (copy), u53 (ref), u51 (ref), u50 (ref), LocalPlayer (copy)
    u52 = 0;
    local u62 = EggRain.ShakeFadeOut or 0.3;
    u53 = task.spawn(function() -- Line: 423
        -- upvalues: u51 (ref), u62 (copy), u53 (ref), u50 (ref), LocalPlayer (ref)
        local v63 = u51;
        local v64 = tick();

        while u51 > 0 and tick() - v64 < u62 do
            local v65 = (tick() - v64) / u62;
            u51 = v63 * (1 - math.min(1, v65));
            task.wait();
        end;

        u51 = 0;
        u53 = nil;

        if u50 then
            u50:Disconnect();
            u50 = nil;
        end;

        local v66 = LocalPlayer.Character and v66:FindFirstChildOfClass("Humanoid");

        if v66 then
            v66.CameraOffset = Vector3.new(0, 0, 0);
        end;
    end);
end;

local function showCountdown(p67) -- Line: 451
    -- upvalues: PlayerGui (copy), EggRain (copy), Debris (copy), TweenService (copy)
    local number = p67.number;
    local v68 = p67.text or tostring(number);
    local v69 = number == 0;
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "EggRainCountdown";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.DisplayOrder = 110;
    ScreenGui.Parent = PlayerGui;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Size = UDim2.new(0.6, 0, 0.2, 0);
    TextLabel.Position = UDim2.new(0.5, 0, 0.2, 0);
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = v68;
    TextLabel.TextScaled = false;
    TextLabel.TextSize = EggRain.CountdownTextSize or 120;
    TextLabel.Font = Enum.Font.GothamBlack;
    local CountdownColor = EggRain.CountdownColor;

    if CountdownColor and type(CountdownColor) == "table" then
        TextLabel.TextColor3 = Color3.fromRGB(CountdownColor[1], CountdownColor[2], CountdownColor[3]);
    else
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
    end;

    TextLabel.TextStrokeTransparency = 0;
    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
    TextLabel.TextTransparency = 1;
    TextLabel.Parent = ScreenGui;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Thickness = 4;
    UIStroke.Color = Color3.fromRGB(0, 0, 0);
    UIStroke.Transparency = 1;
    UIStroke.Parent = TextLabel;

    if EggRain.CountdownSound then
        local Sound = Instance.new("Sound");
        Sound.SoundId = EggRain.CountdownSound;
        Sound.Volume = EggRain.CountdownSoundVol or 1;
        Sound.Parent = PlayerGui;
        Sound:Play();
        Debris:AddItem(Sound, 3);
    end;

    local v70 = EggRain.CountdownTextSize or 120;

    if v69 then
        v70 = v70 * 1.5 or v70;
    end;

    TextLabel.TextTransparency = 0;
    TextLabel.TextStrokeTransparency = 0;
    UIStroke.Transparency = 0;
    TextLabel.TextSize = 1;
    TweenService:Create(TextLabel, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        TextSize = v70
    }):Play();
    task.delay(v69 and 0.7 or 0.55, function() -- Line: 521
        -- upvalues: TweenService (ref), TextLabel (copy), UIStroke (copy), ScreenGui (copy)
        local v71 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
        TweenService:Create(TextLabel, v71, {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }):Play();
        TweenService:Create(UIStroke, v71, {
            Transparency = 1
        }):Play();
        task.delay(0.4, function() -- Line: 528
            -- upvalues: ScreenGui (ref)
            if ScreenGui and ScreenGui.Parent then
                ScreenGui:Destroy();
            end;
        end);
    end);
end;

local u72 = ReplicatedStorage:FindFirstChild(EggRain.LightningFolder or "Ligtning");
local _ = workspace.CurrentCamera;

local function onLightningEvent(p73) -- Line: 541
    -- upvalues: u72 (copy), Debris (copy), EggRain (copy), PlayerGui (copy)
    if type(p73) ~= "table" or not p73.position then
        return;
    end;

    local position = p73.position;
    local v74 = u72 and u72:FindFirstChild("HitParticles");

    if v74 then
        local u75 = v74:Clone();
        u75.Position = position;
        u75.Parent = workspace;
        Debris:AddItem(u75, 3);
        task.delay(0.3, function() -- Line: 555
            -- upvalues: u75 (copy)
            if u75 and u75.Parent then
                for _, descendant in ipairs(u75:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") or descendant:IsA("PointLight") then
                        descendant.Enabled = false;
                    end;
                end;
            end;
        end);
    end;

    local v76 = u72 and u72:FindFirstChild("LightningSound");

    if v76 then
        local v77 = v76:Clone();
        v77.Volume = EggRain.LightningSoundVolume or 2;
        v77.Parent = PlayerGui;
        v77:Play();
        Debris:AddItem(v77, 5);
    end;
end;

local function onWaveEvent(p78) -- Line: 584
    -- upvalues: applySky (copy), startShake (copy), u52 (ref), EggRain (copy), u53 (ref), u51 (ref), u50 (ref), LocalPlayer (copy), restoreSky (copy)
    if type(p78) ~= "table" then
        return;
    end;

    local action = p78.action;

    if action == "start" then
        local wave = p78.wave;

        if wave then
            if wave.Sky then
                applySky(wave.Sky, p78.instant);
            end;

            if wave.Shake and wave.Shake > 0 then
                startShake(wave.Shake);
            end;
        end;
    else
        if action == "stop" then
            u52 = 0;
            local u79 = EggRain.ShakeFadeOut or 0.3;
            u53 = task.spawn(function() -- Line: 423
                -- upvalues: u51 (ref), u79 (copy), u53 (ref), u50 (ref), LocalPlayer (ref)
                local v80 = u51;
                local v81 = tick();

                while u51 > 0 and tick() - v81 < u79 do
                    local v82 = (tick() - v81) / u79;
                    u51 = v80 * (1 - math.min(1, v82));
                    task.wait();
                end;

                u51 = 0;
                u53 = nil;

                if u50 then
                    u50:Disconnect();
                    u50 = nil;
                end;

                local v83 = LocalPlayer.Character and v83:FindFirstChildOfClass("Humanoid");

                if v83 then
                    v83.CameraOffset = Vector3.new(0, 0, 0);
                end;
            end);

            return;
        end;

        if action == "end" then
            u52 = 0;
            local u84 = EggRain.ShakeFadeOut or 0.3;
            u53 = task.spawn(function() -- Line: 423
                -- upvalues: u51 (ref), u84 (copy), u53 (ref), u50 (ref), LocalPlayer (ref)
                local v85 = u51;
                local v86 = tick();

                while u51 > 0 and tick() - v86 < u84 do
                    local v87 = (tick() - v86) / u84;
                    u51 = v85 * (1 - math.min(1, v87));
                    task.wait();
                end;

                u51 = 0;
                u53 = nil;

                if u50 then
                    u50:Disconnect();
                    u50 = nil;
                end;

                local v88 = LocalPlayer.Character and v88:FindFirstChildOfClass("Humanoid");

                if v88 then
                    v88.CameraOffset = Vector3.new(0, 0, 0);
                end;
            end);
            restoreSky();
        end;
    end;
end;

local u89 = false;
local u90 = nil;

local function getPlaylist() -- Line: 619
    -- upvalues: EggRain (copy)
    return (not EggRain.MusicPlaylist or #EggRain.MusicPlaylist <= 0) and (EggRain.Music and EggRain.Music ~= "" and { EggRain.Music } or {}) or EggRain.MusicPlaylist;
end;

local function playTrack(u91, u92) -- Line: 629
    -- upvalues: u89 (ref), u4 (ref), u90 (ref), playTrack (copy)
    if not u89 then
        return;
    end;

    local u93 = u4;

    if not (u93 and u93.Parent) then
        return;
    end;

    u93.SoundId = u91[u92];
    u93.Looped = false;
    u93.TimePosition = 0;

    if u90 then
        u90:Disconnect();
        u90 = nil;
    end;

    u90 = u93.Ended:Connect(function() -- Line: 645
        -- upvalues: u89 (ref), u92 (copy), u91 (copy), playTrack (ref)
        if not u89 then
            return;
        end;

        playTrack(u91, u92 % #u91 + 1);
    end);
    task.spawn(function() -- Line: 651
        -- upvalues: u93 (copy), u89 (ref)
        if not u93.IsLoaded then
            u93.Loaded:Wait();
        end;

        if u89 then
            u93:Play();
        end;
    end);
end;

local function handleMusicEvent(p94) -- Line: 661
    -- upvalues: u4 (ref), getPlaylist (copy), EggRain (copy), SoundService (copy), u89 (ref), playTrack (copy), u90 (ref)
    if type(p94) ~= "table" then
        return;
    end;

    if p94.action ~= "start" then
        if p94.action == "stop" then
            u89 = false;

            if u90 then
                u90:Disconnect();
                u90 = nil;
            end;

            if u4 then
                u4:Stop();
                u4:Destroy();
                u4 = nil;
            end;
        end;

        return;
    end;

    if u4 then
        return;
    end;

    local v95 = getPlaylist();

    if #v95 == 0 then
        return;
    end;

    local Sound = Instance.new("Sound");
    Sound.Name = "EggRainMusic";
    Sound.Volume = EggRain.MusicVolume or 0.5;
    Sound.Looped = false;
    Sound:SetAttribute("IsEventSound", true);
    Sound.Parent = SoundService;
    u4 = Sound;
    u89 = true;
    playTrack(v95, 1);
end;

local function handleSyncEvent(p96) -- Line: 699
    -- upvalues: handleMusicEvent (copy), EggRain (copy), u33 (ref), LightingSnapshot (copy), Lighting (copy), startShake (copy)
    if type(p96) ~= "table" then
        return;
    end;

    if p96.musicStartTime and p96.musicStartTime > 0 then
        handleMusicEvent({
            action = "start",
            musicStartTime = p96.musicStartTime
        });
    end;

    if p96.skyWaveIndex and p96.skyWaveIndex > 0 then
        local Waves = EggRain.Waves;

        if Waves and Waves[p96.skyWaveIndex] then
            local v97 = Waves[p96.skyWaveIndex];
            local v98 = v97.Sky and v97.Sky;

            if v98 then
                if not u33 then
                    u33 = true;
                    LightingSnapshot.acquireShared();

                    if not Lighting:FindFirstChild("EggRainCC") then
                        local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
                        ColorCorrectionEffect.Name = "EggRainCC";
                        ColorCorrectionEffect.Parent = Lighting;
                    end;
                end;

                if v98.Brightness then
                    Lighting.Brightness = v98.Brightness;
                end;

                if v98.Ambient then
                    local Ambient = v98.Ambient;
                    local v99;

                    if type(Ambient) == "table" and #Ambient >= 3 then
                        v99 = Color3.fromRGB(Ambient[1], Ambient[2], Ambient[3]);
                    else
                        v99 = Color3.fromRGB(255, 255, 255);
                    end;

                    Lighting.Ambient = v99;
                end;

                if v98.OutdoorAmbient then
                    local OutdoorAmbient = v98.OutdoorAmbient;
                    local v100;

                    if type(OutdoorAmbient) == "table" and #OutdoorAmbient >= 3 then
                        v100 = Color3.fromRGB(OutdoorAmbient[1], OutdoorAmbient[2], OutdoorAmbient[3]);
                    else
                        v100 = Color3.fromRGB(255, 255, 255);
                    end;

                    Lighting.OutdoorAmbient = v100;
                end;

                if v98.FogEnd then
                    Lighting.FogEnd = v98.FogEnd;
                end;

                if v98.FogColor then
                    local FogColor = v98.FogColor;
                    local v101;

                    if type(FogColor) == "table" and #FogColor >= 3 then
                        v101 = Color3.fromRGB(FogColor[1], FogColor[2], FogColor[3]);
                    else
                        v101 = Color3.fromRGB(255, 255, 255);
                    end;

                    Lighting.FogColor = v101;
                end;

                local EggRainCC = Lighting:FindFirstChild("EggRainCC");

                if EggRainCC then
                    if v98.Saturation then
                        EggRainCC.Saturation = v98.Saturation;
                    end;

                    if v98.ColorTint then
                        local ColorTint = v98.ColorTint;
                        local v102;

                        if type(ColorTint) == "table" and #ColorTint >= 3 then
                            v102 = Color3.fromRGB(ColorTint[1], ColorTint[2], ColorTint[3]);
                        else
                            v102 = Color3.fromRGB(255, 255, 255);
                        end;

                        EggRainCC.TintColor = v102;
                    end;
                end;
            end;
        end;
    end;

    if p96.shakeIntensity and p96.shakeIntensity > 0 then
        startShake(p96.shakeIntensity);
    end;
end;

local u103 = EggRain.AdminUserId or 0;
local u104 = nil;
local u105 = false;
local u106 = {};
local u107 = nil;

local function fireAdmin(p108, p109) -- Line: 735
    -- upvalues: u107 (ref), u105 (ref)
    if not u107 then
        return;
    end;

    u107:FireServer({
        action = p108,
        args = p109,
        allServers = u105
    });
end;

local function createAdminPanel() -- Line: 744
    -- upvalues: LocalPlayer (copy), u103 (copy), PlayerGui (copy), u104 (ref), u106 (copy), u105 (ref), u107 (ref), EggRain (copy)
    if LocalPlayer.UserId ~= u103 then
        return;
    end;

    local v110 = Color3.fromRGB(30, 30, 35);
    local u111 = Color3.fromRGB(40, 40, 48);
    local v112 = Color3.fromRGB(40, 160, 70);
    local v113 = Color3.fromRGB(180, 50, 50);
    local v114 = Color3.fromRGB(200, 130, 30);
    local u115 = Color3.fromRGB(50, 110, 190);
    local u116 = Color3.fromRGB(130, 60, 180);
    local u117 = Color3.fromRGB(230, 230, 235);
    local u118 = Color3.fromRGB(160, 160, 170);
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "EggRainAdminPanel";
    ScreenGui.DisplayOrder = 200;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.Enabled = false;
    ScreenGui.Parent = PlayerGui;
    u104 = ScreenGui;
    local Frame = Instance.new("Frame");
    Frame.Name = "Main";
    Frame.Size = UDim2.new(0, 360, 0, 620);
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = v110;
    Frame.BackgroundTransparency = 0.02;
    Frame.BorderSizePixel = 0;
    Frame.Parent = ScreenGui;
    local u119 = false;
    local u120 = nil;
    local u121 = nil;
    local UserInputService = game:GetService("UserInputService");
    Frame.InputBegan:Connect(function(p122) -- Line: 783
        -- upvalues: Frame (copy), u119 (ref), u120 (ref), u121 (ref)
        if (p122.UserInputType == Enum.UserInputType.MouseButton1 or p122.UserInputType == Enum.UserInputType.Touch) and p122.Position.Y - Frame.AbsolutePosition.Y <= 38 then
            u119 = true;
            u120 = p122.Position;
            u121 = Frame.Position;
        end;
    end);
    UserInputService.InputChanged:Connect(function(p123) -- Line: 795
        -- upvalues: u119 (ref), u120 (ref), Frame (copy), u121 (ref)
        if u119 and (p123.UserInputType == Enum.UserInputType.MouseMovement or p123.UserInputType == Enum.UserInputType.Touch) then
            local v124 = p123.Position - u120;
            Frame.Position = UDim2.new(u121.X.Scale, u121.X.Offset + v124.X, u121.Y.Scale, u121.Y.Offset + v124.Y);
        end;
    end);
    UserInputService.InputEnded:Connect(function(p125) -- Line: 805
        -- upvalues: u119 (ref)
        if p125.UserInputType == Enum.UserInputType.MouseButton1 or p125.UserInputType == Enum.UserInputType.Touch then
            u119 = false;
        end;
    end);
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 10);
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.fromRGB(80, 80, 100);
    UIStroke.Thickness = 1.5;
    UIStroke.Parent = Frame;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "Scroll";
    ScrollingFrame.Size = UDim2.new(1, -16, 1, -50);
    ScrollingFrame.Position = UDim2.new(0, 8, 0, 42);
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.ScrollBarThickness = 4;
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120);
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0);
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame.Parent = Frame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Padding = UDim.new(0, 6);
    UIListLayout.Parent = ScrollingFrame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.PaddingLeft = UDim.new(0, 4);
    UIPadding.PaddingRight = UDim.new(0, 4);
    UIPadding.PaddingTop = UDim.new(0, 4);
    UIPadding.Parent = ScrollingFrame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.Size = UDim2.new(1, 0, 0, 38);
    TextLabel.Position = UDim2.new(0, 0, 0, 0);
    TextLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 60);
    TextLabel.BackgroundTransparency = 0.1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.Text = "EGG RAIN CONTROL";
    TextLabel.TextColor3 = u117;
    TextLabel.TextSize = 16;
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.Parent = Frame;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(0, 10);
    UICorner2.Parent = TextLabel;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Close";
    TextButton.Size = UDim2.new(0, 30, 0, 30);
    TextButton.Position = UDim2.new(1, -34, 0, 4);
    TextButton.BackgroundColor3 = v113;
    TextButton.BackgroundTransparency = 0.3;
    TextButton.Text = "X";
    TextButton.TextColor3 = u117;
    TextButton.TextSize = 14;
    TextButton.Font = Enum.Font.GothamBold;
    TextButton.BorderSizePixel = 0;
    TextButton.Parent = Frame;
    Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6);
    TextButton.MouseButton1Click:Connect(function() -- Line: 875
        -- upvalues: ScreenGui (copy)
        ScreenGui.Enabled = false;
    end);
    local u126 = 0;

    local function sectionHeader(p127) -- Line: 881
        -- upvalues: u126 (ref), u118 (copy), ScrollingFrame (copy)
        u126 = u126 + 1;
        local TextLabel2 = Instance.new("TextLabel");
        TextLabel2.Size = UDim2.new(1, 0, 0, 22);
        TextLabel2.BackgroundTransparency = 1;
        TextLabel2.Text = p127;
        TextLabel2.TextColor3 = u118;
        TextLabel2.TextSize = 11;
        TextLabel2.Font = Enum.Font.GothamBold;
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel2.LayoutOrder = u126;
        TextLabel2.Parent = ScrollingFrame;

        return TextLabel2;
    end;

    local function makeBtn(p128, p129, p130, p131) -- Line: 897
        -- upvalues: u117 (copy)
        local TextButton2 = Instance.new("TextButton");
        TextButton2.Size = p131 or UDim2.new(0, 100, 0, 30);
        TextButton2.BackgroundColor3 = p129;
        TextButton2.Text = p128;
        TextButton2.TextColor3 = u117;
        TextButton2.TextSize = 12;
        TextButton2.Font = Enum.Font.GothamBold;
        TextButton2.BorderSizePixel = 0;
        TextButton2.AutoButtonColor = true;
        TextButton2.Parent = p130;
        Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 6);

        return TextButton2;
    end;

    local function rowFrame(p132) -- Line: 913
        -- upvalues: u126 (ref), ScrollingFrame (copy)
        u126 = u126 + 1;
        local Frame2 = Instance.new("Frame");
        Frame2.Size = UDim2.new(1, 0, 0, p132 or 34);
        Frame2.BackgroundTransparency = 1;
        Frame2.LayoutOrder = u126;
        Frame2.Parent = ScrollingFrame;

        return Frame2;
    end;

    sectionHeader("STATUS");
    u126 = u126 + 1;
    local Frame2 = Instance.new("Frame");
    Frame2.Size = UDim2.new(1, 0, 0, 42);
    Frame2.BackgroundTransparency = 1;
    Frame2.LayoutOrder = u126;
    Frame2.Parent = ScrollingFrame;
    Frame2.BackgroundColor3 = u111;
    Frame2.BackgroundTransparency = 0.3;
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 6);
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Size = UDim2.new(1, -12, 1, 0);
    TextLabel2.Position = UDim2.new(0, 6, 0, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.Text = "Wave: None | Music: OFF\nEggs: 0 | Lightning: OFF";
    TextLabel2.TextColor3 = Color3.fromRGB(120, 220, 160);
    TextLabel2.TextSize = 11;
    TextLabel2.Font = Enum.Font.GothamMedium;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.TextWrapped = true;
    TextLabel2.Parent = Frame2;
    u106.main = TextLabel2;
    sectionHeader("SCOPE");
    u126 = u126 + 1;
    local Frame3 = Instance.new("Frame");
    Frame3.Size = UDim2.new(1, 0, 0, 30);
    Frame3.BackgroundTransparency = 1;
    Frame3.LayoutOrder = u126;
    Frame3.Parent = ScrollingFrame;
    local u133 = makeBtn("This Server", u115, Frame3, UDim2.new(0.48, 0, 1, 0));
    u133.Position = UDim2.new(0, 0, 0, 0);
    u133.BackgroundTransparency = 0;
    local u134 = makeBtn("All Servers", u111, Frame3, UDim2.new(0.48, 0, 1, 0));
    u134.Position = UDim2.new(0.52, 0, 0, 0);
    u134.BackgroundTransparency = 0.3;

    local function updateScopeVisual() -- Line: 959
        -- upvalues: u105 (ref), u133 (copy), u111 (copy), u134 (copy), u116 (copy), u115 (copy)
        if u105 then
            u133.BackgroundColor3 = u111;
            u133.BackgroundTransparency = 0.3;
            u134.BackgroundColor3 = u116;
            u134.BackgroundTransparency = 0;

            return;
        end;

        u133.BackgroundColor3 = u115;
        u133.BackgroundTransparency = 0;
        u134.BackgroundColor3 = u111;
        u134.BackgroundTransparency = 0.3;
    end;

    u133.MouseButton1Click:Connect(function() -- Line: 973
        -- upvalues: u105 (ref), u133 (copy), u111 (copy), u134 (copy), u116 (copy), u115 (copy)
        u105 = false;

        if u105 then
            u133.BackgroundColor3 = u111;
            u133.BackgroundTransparency = 0.3;
            u134.BackgroundColor3 = u116;
            u134.BackgroundTransparency = 0;

            return;
        end;

        u133.BackgroundColor3 = u115;
        u133.BackgroundTransparency = 0;
        u134.BackgroundColor3 = u111;
        u134.BackgroundTransparency = 0.3;
    end);
    u134.MouseButton1Click:Connect(function() -- Line: 977
        -- upvalues: u105 (ref), u133 (copy), u111 (copy), u134 (copy), u116 (copy), u115 (copy)
        u105 = true;

        if u105 then
            u133.BackgroundColor3 = u111;
            u133.BackgroundTransparency = 0.3;
            u134.BackgroundColor3 = u116;
            u134.BackgroundTransparency = 0;

            return;
        end;

        u133.BackgroundColor3 = u115;
        u133.BackgroundTransparency = 0;
        u134.BackgroundColor3 = u111;
        u134.BackgroundTransparency = 0.3;
    end);
    sectionHeader("EVENT");
    u126 = u126 + 1;
    local Frame4 = Instance.new("Frame");
    Frame4.Size = UDim2.new(1, 0, 0, 34);
    Frame4.BackgroundTransparency = 1;
    Frame4.LayoutOrder = u126;
    Frame4.Parent = ScrollingFrame;
    local v135 = makeBtn("Full Auto", v112, Frame4, UDim2.new(0.32, -2, 1, 0));
    v135.Position = UDim2.new(0, 0, 0, 0);
    v135.MouseButton1Click:Connect(function() -- Line: 990
        -- upvalues: u107 (ref), u105 (ref)
        if not u107 then
            return;
        end;

        u107:FireServer({
            action = "fullAuto",
            args = nil,
            allServers = u105
        });
    end);
    local v136 = makeBtn("Stop All", v113, Frame4, UDim2.new(0.32, -2, 1, 0));
    v136.Position = UDim2.new(0.34, 0, 0, 0);
    v136.MouseButton1Click:Connect(function() -- Line: 994
        -- upvalues: u107 (ref), u105 (ref)
        if not u107 then
            return;
        end;

        u107:FireServer({
            action = "stopAll",
            args = nil,
            allServers = u105
        });
    end);
    local v137 = makeBtn("Cleanup", v114, Frame4, UDim2.new(0.32, -2, 1, 0));
    v137.Position = UDim2.new(0.68, 0, 0, 0);
    v137.MouseButton1Click:Connect(function() -- Line: 998
        -- upvalues: u107 (ref), u105 (ref)
        if not u107 then
            return;
        end;

        u107:FireServer({
            action = "cleanup",
            args = nil,
            allServers = u105
        });
    end);
    sectionHeader("WAVES");
    u126 = u126 + 1;
    local Frame5 = Instance.new("Frame");
    Frame5.Size = UDim2.new(1, 0, 0, 34);
    Frame5.BackgroundTransparency = 1;
    Frame5.LayoutOrder = u126;
    Frame5.Parent = ScrollingFrame;
    local v138 = Frame5;
    local u139 = 1;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Size = UDim2.new(0.36, -2, 1, 0);
    TextButton2.Position = UDim2.new(0, 0, 0, 0);
    TextButton2.BackgroundColor3 = u111;
    TextButton2.Text = "Wave 1";
    TextButton2.TextColor3 = u117;
    TextButton2.TextSize = 12;
    TextButton2.Font = Enum.Font.GothamBold;
    TextButton2.BorderSizePixel = 0;
    TextButton2.Parent = v138;
    Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 6);
    TextButton2.MouseButton1Click:Connect(function() -- Line: 1019
        -- upvalues: EggRain (ref), u139 (ref), TextButton2 (copy)
        local v140 = EggRain.Waves or {};
        u139 = u139 % #v140 + 1;
        local v141 = v140[u139];
        TextButton2.Text = "Wave " .. u139 .. (v141 and " - " .. v141.Name or "");
    end);
    local v142 = makeBtn("Start", v112, v138, UDim2.new(0.3, -2, 1, 0));
    v142.Position = UDim2.new(0.38, 0, 0, 0);
    v142.MouseButton1Click:Connect(function() -- Line: 1028
        -- upvalues: u139 (ref), u107 (ref), u105 (ref)
        local v143 = {
            waveIndex = u139
        };

        if not u107 then
            return;
        end;

        u107:FireServer({
            action = "startWave",
            args = v143,
            allServers = u105
        });
    end);
    local v144 = makeBtn("Stop", v113, v138, UDim2.new(0.3, -2, 1, 0));
    v144.Position = UDim2.new(0.7, 0, 0, 0);
    v144.MouseButton1Click:Connect(function() -- Line: 1034
        -- upvalues: u107 (ref), u105 (ref)
        if not u107 then
            return;
        end;

        u107:FireServer({
            action = "stopWave",
            args = nil,
            allServers = u105
        });
    end);
    sectionHeader("MANUAL SPAWN");
    u126 = u126 + 1;
    local Frame6 = Instance.new("Frame");
    Frame6.Size = UDim2.new(1, 0, 0, 34);
    Frame6.BackgroundTransparency = 1;
    Frame6.LayoutOrder = u126;
    Frame6.Parent = ScrollingFrame;
    local TextBox = Instance.new("TextBox");
    TextBox.Size = UDim2.new(0.25, -2, 1, 0);
    TextBox.Position = UDim2.new(0, 0, 0, 0);
    TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60);
    TextBox.Text = "10";
    TextBox.PlaceholderText = "Qty";
    TextBox.TextColor3 = u117;
    TextBox.TextSize = 13;
    TextBox.Font = Enum.Font.GothamMedium;
    TextBox.BorderSizePixel = 0;
    TextBox.ClearTextOnFocus = false;
    TextBox.Parent = Frame6;
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6);
    local v145 = makeBtn("Normal", u115, Frame6, UDim2.new(0.36, -2, 1, 0));
    v145.Position = UDim2.new(0.27, 0, 0, 0);
    v145.MouseButton1Click:Connect(function() -- Line: 1060
        -- upvalues: TextBox (copy), u107 (ref), u105 (ref)
        local v146 = {
            golden = false,
            count = tonumber(TextBox.Text) or 10
        };

        if not u107 then
            return;
        end;

        u107:FireServer({
            action = "spawnEggs",
            args = v146,
            allServers = u105
        });
    end);
    local v147 = makeBtn("Golden", Color3.fromRGB(200, 170, 30), Frame6, UDim2.new(0.36, -2, 1, 0));
    v147.Position = UDim2.new(0.64, 0, 0, 0);
    v147.MouseButton1Click:Connect(function() -- Line: 1067
        -- upvalues: TextBox (copy), u107 (ref), u105 (ref)
        local v148 = {
            golden = true,
            count = tonumber(TextBox.Text) or 10
        };

        if not u107 then
            return;
        end;

        u107:FireServer({
            action = "spawnEggs",
            args = v148,
            allServers = u105
        });
    end);
    sectionHeader("MESSAGES");
    u126 = u126 + 1;
    local Frame7 = Instance.new("Frame");
    Frame7.Size = UDim2.new(1, 0, 0, 34);
    Frame7.BackgroundTransparency = 1;
    Frame7.LayoutOrder = u126;
    Frame7.Parent = ScrollingFrame;
    local TextBox2 = Instance.new("TextBox");
    TextBox2.Size = UDim2.new(0.72, -2, 1, 0);
    TextBox2.Position = UDim2.new(0, 0, 0, 0);
    TextBox2.BackgroundColor3 = Color3.fromRGB(50, 50, 60);
    TextBox2.Text = "";
    TextBox2.PlaceholderText = "Admin message...";
    TextBox2.TextColor3 = u117;
    TextBox2.TextSize = 12;
    TextBox2.Font = Enum.Font.GothamMedium;
    TextBox2.BorderSizePixel = 0;
    TextBox2.ClearTextOnFocus = false;
    TextBox2.Parent = Frame7;
    Instance.new("UICorner", TextBox2).CornerRadius = UDim.new(0, 6);
    local v149 = makeBtn("Send", v112, Frame7, UDim2.new(0.26, -2, 1, 0));
    v149.Position = UDim2.new(0.74, 0, 0, 0);
    v149.MouseButton1Click:Connect(function() -- Line: 1094
        -- upvalues: TextBox2 (copy), u107 (ref), u105 (ref)
        if TextBox2.Text ~= "" then
            local v150 = {
                text = TextBox2.Text
            };

            if u107 then
                u107:FireServer({
                    action = "announce",
                    args = v150,
                    allServers = u105
                });
            end;

            TextBox2.Text = "";
        end;
    end);
    local v151 = {};

    if EggRain.Announcements then
        for i, v in ipairs(EggRain.Announcements) do
            table.insert(v151, {
                label = "Intro " .. i,
                text = v.Text
            });
        end;
    end;

    if EggRain.Waves then
        for i, v in ipairs(EggRain.Waves) do
            if v.Announce then
                table.insert(v151, {
                    label = "W" .. i,
                    text = v.Announce
                });
            end;
        end;
    end;

    if EggRain.EndAnnounce then
        table.insert(v151, {
            label = "End",
            text = EggRain.EndAnnounce
        });
    end;

    if EggRain.EndSequence and EggRain.EndSequence.Messages then
        for i, v in ipairs(EggRain.EndSequence.Messages) do
            table.insert(v151, {
                label = "End " .. i + 1,
                text = v.Text
            });
        end;
    end;

    if #v151 > 0 then
        sectionHeader("PRESET ANNOUNCEMENTS");

        for i = 1, #v151, 3 do
            u126 = u126 + 1;
            local Frame8 = Instance.new("Frame");
            Frame8.Size = UDim2.new(1, 0, 0, 28);
            Frame8.BackgroundTransparency = 1;
            Frame8.LayoutOrder = u126;
            Frame8.Parent = ScrollingFrame;

            for i2 = 0, 2 do
                local v152 = i + i2;

                if #v151 < v152 then
                    break;
                end;

                local u153 = v151[v152];
                local v154 = 1 / math.min(3, #v151 - i + 1);
                local v155 = makeBtn(u153.label, Color3.fromRGB(70, 70, 85), Frame8, UDim2.new(v154, -3, 1, 0));
                v155.Position = UDim2.new(v154 * i2, 0, 0, 0);
                v155.TextSize = 10;
                v155.MouseButton1Click:Connect(function() -- Line: 1138
                    -- upvalues: u153 (copy), u107 (ref), u105 (ref)
                    local v156 = {
                        text = u153.text
                    };

                    if not u107 then
                        return;
                    end;

                    u107:FireServer({
                        action = "announce",
                        args = v156,
                        allServers = u105
                    });
                end);
            end;
        end;
    end;

    sectionHeader("AMBIANCE / SKY");
    u126 = u126 + 1;
    local Frame8 = Instance.new("Frame");
    Frame8.Size = UDim2.new(1, 0, 0, 34);
    Frame8.BackgroundTransparency = 1;
    Frame8.LayoutOrder = u126;
    Frame8.Parent = ScrollingFrame;
    local v157 = Frame8;
    local u158 = 0;
    local TextButton3 = Instance.new("TextButton");
    TextButton3.Size = UDim2.new(0.55, -2, 1, 0);
    TextButton3.Position = UDim2.new(0, 0, 0, 0);
    TextButton3.BackgroundColor3 = u111;
    TextButton3.Text = "Normal";
    TextButton3.TextColor3 = u117;
    TextButton3.TextSize = 12;
    TextButton3.Font = Enum.Font.GothamBold;
    TextButton3.BorderSizePixel = 0;
    TextButton3.Parent = v157;
    Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 6);
    TextButton3.MouseButton1Click:Connect(function() -- Line: 1164
        -- upvalues: EggRain (ref), u158 (ref), TextButton3 (copy)
        local v159 = EggRain.Waves or {};
        u158 = (u158 + 1) % (#v159 + 1);

        if u158 == 0 then
            TextButton3.Text = "Normal";

            return;
        end;

        local v160 = v159[u158];
        TextButton3.Text = "Wave " .. u158 .. (v160 and " - " .. v160.Name or "");
    end);
    local v161 = makeBtn("Apply", u115, v157, UDim2.new(0.43, -2, 1, 0));
    v161.Position = UDim2.new(0.57, 0, 0, 0);
    v161.MouseButton1Click:Connect(function() -- Line: 1177
        -- upvalues: u158 (ref), u107 (ref), u105 (ref)
        if u158 == 0 then
            if not u107 then
                return;
            end;

            u107:FireServer({
                action = "restoreSky",
                args = nil,
                allServers = u105
            });

            return;
        end;

        local v162 = {
            waveIndex = u158
        };

        if not u107 then
            return;
        end;

        u107:FireServer({
            action = "applySky",
            args = v162,
            allServers = u105
        });
    end);
    sectionHeader("MUSIC");
    u126 = u126 + 1;
    local Frame9 = Instance.new("Frame");
    Frame9.Size = UDim2.new(1, 0, 0, 34);
    Frame9.BackgroundTransparency = 1;
    Frame9.LayoutOrder = u126;
    Frame9.Parent = ScrollingFrame;
    local v163 = makeBtn("Play", v112, Frame9, UDim2.new(0.48, -2, 1, 0));
    v163.Position = UDim2.new(0, 0, 0, 0);
    v163.MouseButton1Click:Connect(function() -- Line: 1193
        -- upvalues: u107 (ref), u105 (ref)
        if not u107 then
            return;
        end;

        u107:FireServer({
            action = "startMusic",
            args = nil,
            allServers = u105
        });
    end);
    local v164 = makeBtn("Stop", v113, Frame9, UDim2.new(0.48, -2, 1, 0));
    v164.Position = UDim2.new(0.52, 0, 0, 0);
    v164.MouseButton1Click:Connect(function() -- Line: 1197
        -- upvalues: u107 (ref), u105 (ref)
        if not u107 then
            return;
        end;

        u107:FireServer({
            action = "stopMusic",
            args = nil,
            allServers = u105
        });
    end);
    sectionHeader("END SEQUENCE");
    u126 = u126 + 1;
    local Frame10 = Instance.new("Frame");
    Frame10.Size = UDim2.new(1, 0, 0, 34);
    Frame10.BackgroundTransparency = 1;
    Frame10.LayoutOrder = u126;
    Frame10.Parent = ScrollingFrame;
    local v165 = makeBtn("Run End Sequence", v114, Frame10, UDim2.new(1, 0, 1, 0));
    v165.Position = UDim2.new(0, 0, 0, 0);
    v165.MouseButton1Click:Connect(function() -- Line: 1207
        -- upvalues: u107 (ref), u105 (ref)
        if not u107 then
            return;
        end;

        u107:FireServer({
            action = "endSequence",
            args = nil,
            allServers = u105
        });
    end);
end;

local function updateAdminStatus(p166) -- Line: 1211
    -- upvalues: u106 (copy)
    if not u106.main then
        return;
    end;

    if type(p166) ~= "table" then
        return;
    end;

    u106.main.Text = "Wave: " .. (p166.wave or "None") .. " | Music: " .. (p166.music and "ON" or "OFF") .. (p166.fullAuto and " | AUTO" or "") .. "\nEggs: " .. (p166.eggsActive or 0) .. " | Lightning: " .. (p166.lightning and "ON" or "OFF");
end;

local function hookAdminButton() -- Line: 1224
    -- upvalues: LocalPlayer (copy), u103 (copy), PlayerGui (copy), u104 (ref)
    if LocalPlayer.UserId ~= u103 then
        return;
    end;

    task.spawn(function() -- Line: 1227
        -- upvalues: PlayerGui (ref), u104 (ref)
        local AdminMenuGUI_v2 = PlayerGui:WaitForChild("AdminMenuGUI_v2", 30);

        if not AdminMenuGUI_v2 then
            return;
        end;

        local Panel = AdminMenuGUI_v2:WaitForChild("Panel", 10);

        if not Panel then
            return;
        end;

        local EggRainButton = Panel:WaitForChild("EggRainButton", 10);

        if not EggRainButton then
            warn("[EggRainClient] AdminMenuGUI_v2/Panel/EggRainButton introuvable");

            return;
        end;

        EggRainButton.MouseButton1Click:Connect(function() -- Line: 1238
            -- upvalues: u104 (ref)
            if u104 then
                u104.Enabled = not u104.Enabled;
            end;
        end);
        print("[EggRainClient] Admin button hooked.");
    end);
end;

function v1.Init(p167) -- Line: 1252
    -- upvalues: u2 (ref), EggRain (copy), ContentProvider (copy), Remotes (copy), showAnnouncement (copy), onWaveEvent (copy), showCountdown (copy), playSpawnSound (copy), showGoldenNotif (copy), hideEgg (copy), onLightningEvent (copy), handleMusicEvent (copy), handleSyncEvent (copy), LocalPlayer (copy), u103 (copy), u107 (ref), updateAdminStatus (copy), createAdminPanel (copy), PlayerGui (copy), u104 (ref)
    if u2 then
        return;
    end;

    u2 = true;
    task.spawn(function() -- Line: 1257
        -- upvalues: EggRain (ref), ContentProvider (ref)
        local v168 = { EggRain.SpawnSound };

        if EggRain.AnnounceSound then
            table.insert(v168, EggRain.AnnounceSound);
        end;

        if EggRain.GoldenNotifSound then
            table.insert(v168, EggRain.GoldenNotifSound);
        end;

        if EggRain.CountdownSound then
            table.insert(v168, EggRain.CountdownSound);
        end;

        if EggRain.CollectSound then
            table.insert(v168, EggRain.CollectSound);
        end;

        ContentProvider:PreloadAsync(v168);
    end);
    Remotes:WaitForChild("EggRainAnnounce").OnClientEvent:Connect(function(p169) -- Line: 1268
        -- upvalues: showAnnouncement (ref)
        if type(p169) ~= "table" or not p169.text then
            return;
        end;

        showAnnouncement(p169.text);
    end);
    Remotes:WaitForChild("EggRainWave").OnClientEvent:Connect(onWaveEvent);
    Remotes:WaitForChild("EggRainCountdown").OnClientEvent:Connect(function(p170) -- Line: 1279
        -- upvalues: showCountdown (ref)
        if type(p170) ~= "table" then
            return;
        end;

        showCountdown(p170);
    end);
    Remotes:WaitForChild("EggRainPre").OnClientEvent:Connect(function(p171) -- Line: 1286
        -- upvalues: playSpawnSound (ref), showGoldenNotif (ref)
        if type(p171) ~= "table" then
            return;
        end;

        local position = p171.position;

        if not position then
            return;
        end;

        playSpawnSound(position);

        if p171.eggType == 1 then
            showGoldenNotif();
        end;
    end);
    Remotes:WaitForChild("EggRainHide").OnClientEvent:Connect(function(p172) -- Line: 1301
        -- upvalues: hideEgg (ref)
        if type(p172) ~= "table" or type(p172.eggId) ~= "number" then
            return;
        end;

        hideEgg(p172.eggId);
    end);
    Remotes:WaitForChild("EggRainLightning").OnClientEvent:Connect(onLightningEvent);
    Remotes:WaitForChild("EggRainMusic").OnClientEvent:Connect(handleMusicEvent);
    Remotes:WaitForChild("EggRainSync").OnClientEvent:Connect(handleSyncEvent);

    if LocalPlayer.UserId == u103 then
        u107 = Remotes:WaitForChild("EggRainAdmin");
        Remotes:WaitForChild("EggRainStatus").OnClientEvent:Connect(updateAdminStatus);
        createAdminPanel();

        if LocalPlayer.UserId ~= u103 then
            return;
        end;

        task.spawn(function() -- Line: 1227
            -- upvalues: PlayerGui (ref), u104 (ref)
            local AdminMenuGUI_v2 = PlayerGui:WaitForChild("AdminMenuGUI_v2", 30);

            if not AdminMenuGUI_v2 then
                return;
            end;

            local Panel = AdminMenuGUI_v2:WaitForChild("Panel", 10);

            if not Panel then
                return;
            end;

            local EggRainButton = Panel:WaitForChild("EggRainButton", 10);

            if not EggRainButton then
                warn("[EggRainClient] AdminMenuGUI_v2/Panel/EggRainButton introuvable");

                return;
            end;

            EggRainButton.MouseButton1Click:Connect(function() -- Line: 1238
                -- upvalues: u104 (ref)
                if u104 then
                    u104.Enabled = not u104.Enabled;
                end;
            end);
            print("[EggRainClient] Admin button hooked.");
        end);
    end;
end;

return v1;