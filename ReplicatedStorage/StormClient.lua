-- Ruta Original: ReplicatedStorage.StormClient
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local Debris = game:GetService("Debris");
local LightingSnapshot = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("Events"):WaitForChild("LightingSnapshot"));
local EventsConfig = require(ReplicatedStorage:WaitForChild("EventsConfig"));
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local v1 = {};
local Storm = EventsConfig.Storm;

if not Storm then
    return v1;
end;

local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local u2 = false;
local u3 = ReplicatedStorage:FindFirstChild(Storm.LightningFolder or "Ligtning");

local function onLightningEvent(p4) -- Line: 32
    -- upvalues: u3 (copy), Debris (copy), Storm (copy), PlayerGui (copy)
    if type(p4) ~= "table" or not p4.position then
        return;
    end;

    local position = p4.position;
    local v5 = u3 and u3:FindFirstChild("HitParticles");

    if v5 then
        local u6 = v5:Clone();
        u6.Position = position;
        u6.Parent = workspace;
        Debris:AddItem(u6, 3);
        task.delay(0.3, function() -- Line: 45
            -- upvalues: u6 (copy)
            if u6 and u6.Parent then
                for _, descendant in ipairs(u6:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") or descendant:IsA("PointLight") then
                        descendant.Enabled = false;
                    end;
                end;
            end;
        end);
    end;

    local v7 = u3 and u3:FindFirstChild("LightningSound");

    if v7 then
        local v8 = v7:Clone();
        v8.Volume = Storm.LightningSoundVolume or 2;
        v8.Parent = PlayerGui;
        v8:Play();
        Debris:AddItem(v8, 5);
    end;
end;

local u9 = false;

local function saveOriginalSky() -- Line: 76
    -- upvalues: u9 (ref), LightingSnapshot (copy), Lighting (copy)
    if u9 then
        return;
    end;

    u9 = true;
    LightingSnapshot.acquireShared();

    if not Lighting:FindFirstChild("StormCC") then
        local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
        ColorCorrectionEffect.Name = "StormCC";
        ColorCorrectionEffect.Parent = Lighting;
    end;
end;

local function rgbTable(p10) -- Line: 88
    if type(p10) == "table" and #p10 >= 3 then
        return Color3.fromRGB(p10[1], p10[2], p10[3]);
    end;

    return Color3.fromRGB(255, 255, 255);
end;

local function applySky(p11, p12) -- Line: 95
    -- upvalues: u9 (ref), LightingSnapshot (copy), Lighting (copy), TweenService (copy)
    if not p11 then
        return;
    end;

    if not u9 then
        u9 = true;
        LightingSnapshot.acquireShared();

        if not Lighting:FindFirstChild("StormCC") then
            local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
            ColorCorrectionEffect.Name = "StormCC";
            ColorCorrectionEffect.Parent = Lighting;
        end;
    end;

    if p12 then
        if p11.Brightness then
            Lighting.Brightness = p11.Brightness;
        end;

        if p11.Ambient then
            local Ambient = p11.Ambient;
            local v13;

            if type(Ambient) == "table" and #Ambient >= 3 then
                v13 = Color3.fromRGB(Ambient[1], Ambient[2], Ambient[3]);
            else
                v13 = Color3.fromRGB(255, 255, 255);
            end;

            Lighting.Ambient = v13;
        end;

        if p11.OutdoorAmbient then
            local OutdoorAmbient = p11.OutdoorAmbient;
            local v14;

            if type(OutdoorAmbient) == "table" and #OutdoorAmbient >= 3 then
                v14 = Color3.fromRGB(OutdoorAmbient[1], OutdoorAmbient[2], OutdoorAmbient[3]);
            else
                v14 = Color3.fromRGB(255, 255, 255);
            end;

            Lighting.OutdoorAmbient = v14;
        end;

        if p11.FogEnd then
            Lighting.FogEnd = p11.FogEnd;
        end;

        if p11.FogColor then
            local FogColor = p11.FogColor;
            local v15;

            if type(FogColor) == "table" and #FogColor >= 3 then
                v15 = Color3.fromRGB(FogColor[1], FogColor[2], FogColor[3]);
            else
                v15 = Color3.fromRGB(255, 255, 255);
            end;

            Lighting.FogColor = v15;
        end;

        local StormCC = Lighting:FindFirstChild("StormCC");

        if StormCC then
            if p11.Saturation then
                StormCC.Saturation = p11.Saturation;
            end;

            if p11.ColorTint then
                local ColorTint = p11.ColorTint;
                local v16;

                if type(ColorTint) == "table" and #ColorTint >= 3 then
                    v16 = Color3.fromRGB(ColorTint[1], ColorTint[2], ColorTint[3]);
                else
                    v16 = Color3.fromRGB(255, 255, 255);
                end;

                StormCC.TintColor = v16;
            end;
        end;

        return;
    end;

    local v17 = TweenInfo.new(p11.SkyTween or 2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
    local v18 = {};

    if p11.Brightness then
        v18.Brightness = p11.Brightness;
    end;

    if p11.Ambient then
        local Ambient = p11.Ambient;
        local v19;

        if type(Ambient) == "table" and #Ambient >= 3 then
            v19 = Color3.fromRGB(Ambient[1], Ambient[2], Ambient[3]);
        else
            v19 = Color3.fromRGB(255, 255, 255);
        end;

        v18.Ambient = v19;
    end;

    if p11.OutdoorAmbient then
        local OutdoorAmbient = p11.OutdoorAmbient;
        local v20;

        if type(OutdoorAmbient) == "table" and #OutdoorAmbient >= 3 then
            v20 = Color3.fromRGB(OutdoorAmbient[1], OutdoorAmbient[2], OutdoorAmbient[3]);
        else
            v20 = Color3.fromRGB(255, 255, 255);
        end;

        v18.OutdoorAmbient = v20;
    end;

    if p11.FogEnd then
        v18.FogEnd = p11.FogEnd;
    end;

    if p11.FogColor then
        local FogColor = p11.FogColor;
        local v21;

        if type(FogColor) == "table" and #FogColor >= 3 then
            v21 = Color3.fromRGB(FogColor[1], FogColor[2], FogColor[3]);
        else
            v21 = Color3.fromRGB(255, 255, 255);
        end;

        v18.FogColor = v21;
    end;

    if next(v18) then
        TweenService:Create(Lighting, v17, v18):Play();
    end;

    local StormCC = Lighting:FindFirstChild("StormCC");

    if StormCC then
        local v22 = {};

        if p11.Saturation then
            v22.Saturation = p11.Saturation;
        end;

        if p11.ColorTint then
            local ColorTint = p11.ColorTint;
            local v23;

            if type(ColorTint) == "table" and #ColorTint >= 3 then
                v23 = Color3.fromRGB(ColorTint[1], ColorTint[2], ColorTint[3]);
            else
                v23 = Color3.fromRGB(255, 255, 255);
            end;

            v22.TintColor = v23;
        end;

        if next(v22) then
            TweenService:Create(StormCC, v17, v22):Play();
        end;
    end;
end;

local function restoreSky() -- Line: 138
    -- upvalues: u9 (ref), Storm (copy), LightingSnapshot (copy), Lighting (copy), TweenService (copy)
    if not u9 then
        return;
    end;

    u9 = false;
    local v24 = Storm.SkyRestoreDuration or 3;
    LightingSnapshot.releaseShared(v24);
    local v25 = TweenInfo.new(v24, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
    local StormCC = Lighting:FindFirstChild("StormCC");

    if StormCC then
        TweenService:Create(StormCC, v25, {
            Saturation = 0,
            TintColor = Color3.fromRGB(255, 255, 255)
        }):Play();
        task.delay(v24 + 0.5, function() -- Line: 151
            -- upvalues: StormCC (copy)
            if StormCC and StormCC.Parent then
                StormCC:Destroy();
            end;
        end);
    end;
end;

local function onWaveEvent(p26) -- Line: 161
    -- upvalues: applySky (copy), restoreSky (copy)
    if type(p26) ~= "table" then
        return;
    end;

    local action = p26.action;

    if action == "start" then
        local wave = p26.wave;

        if wave and wave.Sky then
            applySky(wave.Sky, p26.instant);
        end;
    else
        if action == "stop" then
            return;
        end;

        if action == "end" then
            restoreSky();
        end;
    end;
end;

local function handleSyncEvent(p27) -- Line: 181
    -- upvalues: Storm (copy), u9 (ref), LightingSnapshot (copy), Lighting (copy)
    if type(p27) ~= "table" then
        return;
    end;

    if p27.skyWaveIndex and p27.skyWaveIndex > 0 then
        local Waves = Storm.Waves;

        if Waves and Waves[p27.skyWaveIndex] then
            local v28 = Waves[p27.skyWaveIndex];

            if v28.Sky then
                local Sky = v28.Sky;

                if not Sky then
                    return;
                end;

                if not u9 then
                    u9 = true;
                    LightingSnapshot.acquireShared();

                    if not Lighting:FindFirstChild("StormCC") then
                        local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
                        ColorCorrectionEffect.Name = "StormCC";
                        ColorCorrectionEffect.Parent = Lighting;
                    end;
                end;

                if Sky.Brightness then
                    Lighting.Brightness = Sky.Brightness;
                end;

                if Sky.Ambient then
                    local Ambient = Sky.Ambient;
                    local v29;

                    if type(Ambient) == "table" and #Ambient >= 3 then
                        v29 = Color3.fromRGB(Ambient[1], Ambient[2], Ambient[3]);
                    else
                        v29 = Color3.fromRGB(255, 255, 255);
                    end;

                    Lighting.Ambient = v29;
                end;

                if Sky.OutdoorAmbient then
                    local OutdoorAmbient = Sky.OutdoorAmbient;
                    local v30;

                    if type(OutdoorAmbient) == "table" and #OutdoorAmbient >= 3 then
                        v30 = Color3.fromRGB(OutdoorAmbient[1], OutdoorAmbient[2], OutdoorAmbient[3]);
                    else
                        v30 = Color3.fromRGB(255, 255, 255);
                    end;

                    Lighting.OutdoorAmbient = v30;
                end;

                if Sky.FogEnd then
                    Lighting.FogEnd = Sky.FogEnd;
                end;

                if Sky.FogColor then
                    local FogColor = Sky.FogColor;
                    local v31;

                    if type(FogColor) == "table" and #FogColor >= 3 then
                        v31 = Color3.fromRGB(FogColor[1], FogColor[2], FogColor[3]);
                    else
                        v31 = Color3.fromRGB(255, 255, 255);
                    end;

                    Lighting.FogColor = v31;
                end;

                local StormCC = Lighting:FindFirstChild("StormCC");

                if StormCC then
                    if Sky.Saturation then
                        StormCC.Saturation = Sky.Saturation;
                    end;

                    if Sky.ColorTint then
                        local ColorTint = Sky.ColorTint;
                        local v32;

                        if type(ColorTint) == "table" and #ColorTint >= 3 then
                            v32 = Color3.fromRGB(ColorTint[1], ColorTint[2], ColorTint[3]);
                        else
                            v32 = Color3.fromRGB(255, 255, 255);
                        end;

                        StormCC.TintColor = v32;
                    end;
                end;
            end;
        end;
    end;
end;

local u33 = Storm.AdminUserId or 0;
local u34 = nil;
local u35 = false;
local u36 = {};
local u37 = nil;

local function fireAdmin(p38, p39) -- Line: 203
    -- upvalues: u37 (ref), u35 (ref)
    if not u37 then
        return;
    end;

    u37:FireServer({
        action = p38,
        args = p39,
        allServers = u35
    });
end;

local function createAdminPanel() -- Line: 212
    -- upvalues: LocalPlayer (copy), u33 (copy), PlayerGui (copy), u34 (ref), u36 (copy), u35 (ref), u37 (ref), Storm (copy)
    if LocalPlayer.UserId ~= u33 then
        return;
    end;

    local v40 = Color3.fromRGB(30, 30, 35);
    local u41 = Color3.fromRGB(40, 40, 48);
    local v42 = Color3.fromRGB(40, 160, 70);
    local v43 = Color3.fromRGB(180, 50, 50);
    local u44 = Color3.fromRGB(50, 110, 190);
    local u45 = Color3.fromRGB(130, 60, 180);
    local u46 = Color3.fromRGB(230, 230, 235);
    local u47 = Color3.fromRGB(160, 160, 170);
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "StormAdminPanel";
    ScreenGui.DisplayOrder = 200;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.Enabled = false;
    ScreenGui.Parent = PlayerGui;
    u34 = ScreenGui;
    local Frame = Instance.new("Frame");
    Frame.Name = "Main";
    Frame.Size = UDim2.new(0, 340, 0, 400);
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = v40;
    Frame.BackgroundTransparency = 0.02;
    Frame.BorderSizePixel = 0;
    Frame.Parent = ScreenGui;
    local u48 = false;
    local u49 = nil;
    local u50 = nil;
    local UserInputService = game:GetService("UserInputService");
    Frame.InputBegan:Connect(function(p51) -- Line: 246
        -- upvalues: Frame (copy), u48 (ref), u49 (ref), u50 (ref)
        if (p51.UserInputType == Enum.UserInputType.MouseButton1 or p51.UserInputType == Enum.UserInputType.Touch) and p51.Position.Y - Frame.AbsolutePosition.Y <= 38 then
            u48 = true;
            u49 = p51.Position;
            u50 = Frame.Position;
        end;
    end);
    UserInputService.InputChanged:Connect(function(p52) -- Line: 256
        -- upvalues: u48 (ref), u49 (ref), Frame (copy), u50 (ref)
        if u48 and (p52.UserInputType == Enum.UserInputType.MouseMovement or p52.UserInputType == Enum.UserInputType.Touch) then
            local v53 = p52.Position - u49;
            Frame.Position = UDim2.new(u50.X.Scale, u50.X.Offset + v53.X, u50.Y.Scale, u50.Y.Offset + v53.Y);
        end;
    end);
    UserInputService.InputEnded:Connect(function(p54) -- Line: 262
        -- upvalues: u48 (ref)
        if p54.UserInputType == Enum.UserInputType.MouseButton1 or p54.UserInputType == Enum.UserInputType.Touch then
            u48 = false;
        end;
    end);
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10);
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.fromRGB(80, 80, 100);
    UIStroke.Thickness = 1.5;
    UIStroke.Parent = Frame;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Size = UDim2.new(1, -16, 1, -50);
    ScrollingFrame.Position = UDim2.new(0, 8, 0, 42);
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.ScrollBarThickness = 4;
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
    TextLabel.Size = UDim2.new(1, 0, 0, 38);
    TextLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 60);
    TextLabel.BackgroundTransparency = 0.1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.Text = "STORM CONTROL";
    TextLabel.TextColor3 = u46;
    TextLabel.TextSize = 16;
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.Parent = Frame;
    Instance.new("UICorner", TextLabel).CornerRadius = UDim.new(0, 10);
    local TextButton = Instance.new("TextButton");
    TextButton.Size = UDim2.new(0, 30, 0, 30);
    TextButton.Position = UDim2.new(1, -34, 0, 4);
    TextButton.BackgroundColor3 = v43;
    TextButton.BackgroundTransparency = 0.3;
    TextButton.Text = "X";
    TextButton.TextColor3 = u46;
    TextButton.TextSize = 14;
    TextButton.Font = Enum.Font.GothamBold;
    TextButton.BorderSizePixel = 0;
    TextButton.Parent = Frame;
    Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6);
    TextButton.MouseButton1Click:Connect(function() -- Line: 320
        -- upvalues: ScreenGui (copy)
        ScreenGui.Enabled = false;
    end);
    local u55 = 0;

    local function sectionHeader(p56) -- Line: 323
        -- upvalues: u55 (ref), u47 (copy), ScrollingFrame (copy)
        u55 = u55 + 1;
        local TextLabel2 = Instance.new("TextLabel");
        TextLabel2.Size = UDim2.new(1, 0, 0, 22);
        TextLabel2.BackgroundTransparency = 1;
        TextLabel2.Text = p56;
        TextLabel2.TextColor3 = u47;
        TextLabel2.TextSize = 11;
        TextLabel2.Font = Enum.Font.GothamBold;
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel2.LayoutOrder = u55;
        TextLabel2.Parent = ScrollingFrame;
    end;

    local function makeBtn(p57, p58, p59, p60) -- Line: 337
        -- upvalues: u46 (copy)
        local TextButton2 = Instance.new("TextButton");
        TextButton2.Size = p60 or UDim2.new(0, 100, 0, 30);
        TextButton2.BackgroundColor3 = p58;
        TextButton2.Text = p57;
        TextButton2.TextColor3 = u46;
        TextButton2.TextSize = 12;
        TextButton2.Font = Enum.Font.GothamBold;
        TextButton2.BorderSizePixel = 0;
        TextButton2.AutoButtonColor = true;
        TextButton2.Parent = p59;
        Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 6);

        return TextButton2;
    end;

    local function rowFrame(p61) -- Line: 352
        -- upvalues: u55 (ref), ScrollingFrame (copy)
        u55 = u55 + 1;
        local Frame2 = Instance.new("Frame");
        Frame2.Size = UDim2.new(1, 0, 0, p61 or 34);
        Frame2.BackgroundTransparency = 1;
        Frame2.LayoutOrder = u55;
        Frame2.Parent = ScrollingFrame;

        return Frame2;
    end;

    sectionHeader("STATUS");
    u55 = u55 + 1;
    local Frame2 = Instance.new("Frame");
    Frame2.Size = UDim2.new(1, 0, 0, 34);
    Frame2.BackgroundTransparency = 1;
    Frame2.LayoutOrder = u55;
    Frame2.Parent = ScrollingFrame;
    Frame2.BackgroundColor3 = u41;
    Frame2.BackgroundTransparency = 0.3;
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 6);
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Size = UDim2.new(1, -12, 1, 0);
    TextLabel2.Position = UDim2.new(0, 6, 0, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.Text = "Wave: None | Lightning: OFF";
    TextLabel2.TextColor3 = Color3.fromRGB(120, 220, 160);
    TextLabel2.TextSize = 11;
    TextLabel2.Font = Enum.Font.GothamMedium;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.TextWrapped = true;
    TextLabel2.Parent = Frame2;
    u36.main = TextLabel2;
    sectionHeader("SCOPE");
    u55 = u55 + 1;
    local Frame3 = Instance.new("Frame");
    Frame3.Size = UDim2.new(1, 0, 0, 30);
    Frame3.BackgroundTransparency = 1;
    Frame3.LayoutOrder = u55;
    Frame3.Parent = ScrollingFrame;
    local u62 = makeBtn("This Server", u44, Frame3, UDim2.new(0.48, 0, 1, 0));
    u62.Position = UDim2.new(0, 0, 0, 0);
    local u63 = makeBtn("All Servers", u41, Frame3, UDim2.new(0.48, 0, 1, 0));
    u63.Position = UDim2.new(0.52, 0, 0, 0);
    u63.BackgroundTransparency = 0.3;

    local function updateScopeVisual() -- Line: 393
        -- upvalues: u35 (ref), u62 (copy), u41 (copy), u63 (copy), u45 (copy), u44 (copy)
        if u35 then
            u62.BackgroundColor3 = u41;
            u62.BackgroundTransparency = 0.3;
            u63.BackgroundColor3 = u45;
            u63.BackgroundTransparency = 0;

            return;
        end;

        u62.BackgroundColor3 = u44;
        u62.BackgroundTransparency = 0;
        u63.BackgroundColor3 = u41;
        u63.BackgroundTransparency = 0.3;
    end;

    u62.MouseButton1Click:Connect(function() -- Line: 407
        -- upvalues: u35 (ref), u62 (copy), u41 (copy), u63 (copy), u45 (copy), u44 (copy)
        u35 = false;

        if u35 then
            u62.BackgroundColor3 = u41;
            u62.BackgroundTransparency = 0.3;
            u63.BackgroundColor3 = u45;
            u63.BackgroundTransparency = 0;

            return;
        end;

        u62.BackgroundColor3 = u44;
        u62.BackgroundTransparency = 0;
        u63.BackgroundColor3 = u41;
        u63.BackgroundTransparency = 0.3;
    end);
    u63.MouseButton1Click:Connect(function() -- Line: 408
        -- upvalues: u35 (ref), u62 (copy), u41 (copy), u63 (copy), u45 (copy), u44 (copy)
        u35 = true;

        if u35 then
            u62.BackgroundColor3 = u41;
            u62.BackgroundTransparency = 0.3;
            u63.BackgroundColor3 = u45;
            u63.BackgroundTransparency = 0;

            return;
        end;

        u62.BackgroundColor3 = u44;
        u62.BackgroundTransparency = 0;
        u63.BackgroundColor3 = u41;
        u63.BackgroundTransparency = 0.3;
    end);
    sectionHeader("EVENT");
    u55 = u55 + 1;
    local Frame4 = Instance.new("Frame");
    Frame4.Size = UDim2.new(1, 0, 0, 34);
    Frame4.BackgroundTransparency = 1;
    Frame4.LayoutOrder = u55;
    Frame4.Parent = ScrollingFrame;
    local v64 = makeBtn("Full Auto", v42, Frame4, UDim2.new(0.48, -2, 1, 0));
    v64.Position = UDim2.new(0, 0, 0, 0);
    v64.MouseButton1Click:Connect(function() -- Line: 416
        -- upvalues: u37 (ref), u35 (ref)
        if not u37 then
            return;
        end;

        u37:FireServer({
            action = "fullAuto",
            args = nil,
            allServers = u35
        });
    end);
    local v65 = makeBtn("Stop All", v43, Frame4, UDim2.new(0.48, -2, 1, 0));
    v65.Position = UDim2.new(0.52, 0, 0, 0);
    v65.MouseButton1Click:Connect(function() -- Line: 420
        -- upvalues: u37 (ref), u35 (ref)
        if not u37 then
            return;
        end;

        u37:FireServer({
            action = "stopAll",
            args = nil,
            allServers = u35
        });
    end);
    sectionHeader("WAVES");
    u55 = u55 + 1;
    local Frame5 = Instance.new("Frame");
    Frame5.Size = UDim2.new(1, 0, 0, 34);
    Frame5.BackgroundTransparency = 1;
    Frame5.LayoutOrder = u55;
    Frame5.Parent = ScrollingFrame;
    local v66 = Frame5;
    local u67 = 1;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Size = UDim2.new(0.36, -2, 1, 0);
    TextButton2.Position = UDim2.new(0, 0, 0, 0);
    TextButton2.BackgroundColor3 = u41;
    TextButton2.Text = "Wave 1";
    TextButton2.TextColor3 = u46;
    TextButton2.TextSize = 12;
    TextButton2.Font = Enum.Font.GothamBold;
    TextButton2.BorderSizePixel = 0;
    TextButton2.Parent = v66;
    Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 6);
    TextButton2.MouseButton1Click:Connect(function() -- Line: 439
        -- upvalues: Storm (ref), u67 (ref), TextButton2 (copy)
        local v68 = Storm.Waves or {};
        u67 = u67 % #v68 + 1;
        local v69 = v68[u67];
        TextButton2.Text = "Wave " .. u67 .. (v69 and " - " .. v69.Name or "");
    end);
    local v70 = makeBtn("Start", v42, v66, UDim2.new(0.3, -2, 1, 0));
    v70.Position = UDim2.new(0.38, 0, 0, 0);
    v70.MouseButton1Click:Connect(function() -- Line: 448
        -- upvalues: u67 (ref), u37 (ref), u35 (ref)
        local v71 = {
            waveIndex = u67
        };

        if not u37 then
            return;
        end;

        u37:FireServer({
            action = "startWave",
            args = v71,
            allServers = u35
        });
    end);
    local v72 = makeBtn("Stop", v43, v66, UDim2.new(0.3, -2, 1, 0));
    v72.Position = UDim2.new(0.7, 0, 0, 0);
    v72.MouseButton1Click:Connect(function() -- Line: 452
        -- upvalues: u37 (ref), u35 (ref)
        if not u37 then
            return;
        end;

        u37:FireServer({
            action = "stopWave",
            args = nil,
            allServers = u35
        });
    end);
    sectionHeader("AMBIANCE / SKY");
    u55 = u55 + 1;
    local Frame6 = Instance.new("Frame");
    Frame6.Size = UDim2.new(1, 0, 0, 34);
    Frame6.BackgroundTransparency = 1;
    Frame6.LayoutOrder = u55;
    Frame6.Parent = ScrollingFrame;
    local v73 = Frame6;
    local u74 = 0;
    local TextButton3 = Instance.new("TextButton");
    TextButton3.Size = UDim2.new(0.55, -2, 1, 0);
    TextButton3.Position = UDim2.new(0, 0, 0, 0);
    TextButton3.BackgroundColor3 = u41;
    TextButton3.Text = "Normal";
    TextButton3.TextColor3 = u46;
    TextButton3.TextSize = 12;
    TextButton3.Font = Enum.Font.GothamBold;
    TextButton3.BorderSizePixel = 0;
    TextButton3.Parent = v73;
    Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 6);
    TextButton3.MouseButton1Click:Connect(function() -- Line: 471
        -- upvalues: Storm (ref), u74 (ref), TextButton3 (copy)
        local v75 = Storm.Waves or {};
        u74 = (u74 + 1) % (#v75 + 1);

        if u74 == 0 then
            TextButton3.Text = "Normal";

            return;
        end;

        local v76 = v75[u74];
        TextButton3.Text = "Wave " .. u74 .. (v76 and " - " .. v76.Name or "");
    end);
    local v77 = makeBtn("Apply", u44, v73, UDim2.new(0.43, -2, 1, 0));
    v77.Position = UDim2.new(0.57, 0, 0, 0);
    v77.MouseButton1Click:Connect(function() -- Line: 484
        -- upvalues: u74 (ref), u37 (ref), u35 (ref)
        if u74 == 0 then
            if not u37 then
                return;
            end;

            u37:FireServer({
                action = "restoreSky",
                args = nil,
                allServers = u35
            });

            return;
        end;

        local v78 = {
            waveIndex = u74
        };

        if not u37 then
            return;
        end;

        u37:FireServer({
            action = "applySky",
            args = v78,
            allServers = u35
        });
    end);
end;

local function updateAdminStatus(p79) -- Line: 494
    -- upvalues: u36 (copy)
    if not u36.main then
        return;
    end;

    if type(p79) ~= "table" then
        return;
    end;

    u36.main.Text = "Wave: " .. (p79.wave or "None") .. " | Lightning: " .. (p79.lightning and "ON" or "OFF") .. (p79.fullAuto and " | AUTO" or "");
end;

local function hookAdminButton() -- Line: 504
    -- upvalues: LocalPlayer (copy), u33 (copy), PlayerGui (copy), u34 (ref)
    if LocalPlayer.UserId ~= u33 then
        return;
    end;

    task.spawn(function() -- Line: 507
        -- upvalues: PlayerGui (ref), u34 (ref)
        local AdminMenuGUI_v2 = PlayerGui:WaitForChild("AdminMenuGUI_v2", 30);

        if not AdminMenuGUI_v2 then
            return;
        end;

        local Panel = AdminMenuGUI_v2:WaitForChild("Panel", 10);

        if not Panel then
            return;
        end;

        local StormButton = Panel:WaitForChild("StormButton", 10);

        if not StormButton then
            return;
        end;

        StormButton.MouseButton1Click:Connect(function() -- Line: 515
            -- upvalues: u34 (ref)
            if u34 then
                u34.Enabled = not u34.Enabled;
            end;
        end);
    end);
end;

function v1.Init(p80) -- Line: 527
    -- upvalues: u2 (ref), Remotes (copy), onLightningEvent (copy), onWaveEvent (copy), handleSyncEvent (copy), LocalPlayer (copy), u33 (copy), u37 (ref), updateAdminStatus (copy), createAdminPanel (copy), PlayerGui (copy), u34 (ref)
    if u2 then
        return;
    end;

    u2 = true;
    Remotes:WaitForChild("StormLightning").OnClientEvent:Connect(onLightningEvent);
    Remotes:WaitForChild("StormWave").OnClientEvent:Connect(onWaveEvent);
    Remotes:WaitForChild("StormSync").OnClientEvent:Connect(handleSyncEvent);

    if LocalPlayer.UserId == u33 then
        u37 = Remotes:WaitForChild("StormAdmin");
        Remotes:WaitForChild("StormStatus").OnClientEvent:Connect(updateAdminStatus);
        createAdminPanel();

        if LocalPlayer.UserId ~= u33 then
            return;
        end;

        task.spawn(function() -- Line: 507
            -- upvalues: PlayerGui (ref), u34 (ref)
            local AdminMenuGUI_v2 = PlayerGui:WaitForChild("AdminMenuGUI_v2", 30);

            if not AdminMenuGUI_v2 then
                return;
            end;

            local Panel = AdminMenuGUI_v2:WaitForChild("Panel", 10);

            if not Panel then
                return;
            end;

            local StormButton = Panel:WaitForChild("StormButton", 10);

            if not StormButton then
                return;
            end;

            StormButton.MouseButton1Click:Connect(function() -- Line: 515
                -- upvalues: u34 (ref)
                if u34 then
                    u34.Enabled = not u34.Enabled;
                end;
            end);
        end);
    end;
end;

return v1;