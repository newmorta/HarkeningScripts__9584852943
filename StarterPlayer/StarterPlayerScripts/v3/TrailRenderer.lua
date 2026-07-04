-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.TrailRenderer
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TrailConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("TrailConfig"));
local EventsConfig = require(ReplicatedStorage:WaitForChild("EventsConfig"));

local function createTrail(p1, p2) -- Line: 7
    -- upvalues: TrailConfig (copy), EventsConfig (copy)
    for _, descendant in ipairs(p1:GetDescendants()) do
        if descendant:IsA("Trail") or (descendant.Name:find("TrailAtt") or descendant.Name:find("TrailFX")) then
            descendant:Destroy();
        end;
    end;

    local v3 = TrailConfig.TRAILS[p2];

    if not v3 then
        for _, v in ipairs(EventsConfig.Trails or {}) do
            if v.Key == p2 then
                v3 = v;
                break;
            end;
        end;
    end;

    if p2 == "None" or not v3 then
        return;
    end;

    local HumanoidRootPart = p1:WaitForChild("HumanoidRootPart", 5);
    local Humanoid = p1:WaitForChild("Humanoid", 5);

    if not (HumanoidRootPart and Humanoid) then
        return;
    end;

    local Attachment = Instance.new("Attachment", HumanoidRootPart);
    Attachment.Name = "TrailAtt0";
    Attachment.Position = Vector3.new(0, 1.5, 0);
    local Attachment2 = Instance.new("Attachment", HumanoidRootPart);
    Attachment2.Name = "TrailAtt1";
    Attachment2.Position = Vector3.new(0, -1.5, 0);
    local Trail = Instance.new("Trail");
    Trail.Attachment0 = Attachment;
    Trail.Attachment1 = Attachment2;
    Trail.Lifetime = 0.5;
    Trail.FaceCamera = true;
    Trail.Transparency = NumberSequence.new(0);
    Trail.WidthScale = NumberSequence.new(1, 0);
    Trail.LightInfluence = 0;
    Trail.LightEmission = 0.3;
    Trail.Color = v3.Color;
    Trail.Parent = p1;

    if p2 == "EasterTrail" then
        Trail.Texture = "rbxassetid://102982173039667";
        Trail.TextureMode = Enum.TextureMode.Wrap;
        Trail.TextureLength = 3;
        Trail.Lifetime = 0.6;
        Trail.LightEmission = 0.1;
        local Attachment3 = Instance.new("Attachment", HumanoidRootPart);
        Attachment3.Name = "TrailFX_DropAtt";
        Attachment3.Position = Vector3.new(0, -1, 0);
        local ParticleEmitter = Instance.new("ParticleEmitter");
        ParticleEmitter.Name = "TrailFX_Drops";
        ParticleEmitter.Texture = "rbxassetid://102982173039667";
        ParticleEmitter.Rate = 120;
        ParticleEmitter.Lifetime = NumberRange.new(0.5, 1.2);
        ParticleEmitter.Speed = NumberRange.new(2, 6);
        ParticleEmitter.SpreadAngle = Vector2.new(55, 55);
        ParticleEmitter.Rotation = NumberRange.new(0, 360);
        ParticleEmitter.RotSpeed = NumberRange.new(-200, 200);
        ParticleEmitter.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 130, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 50, 10)) });
        ParticleEmitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.55), NumberSequenceKeypoint.new(0.6, 0.35), NumberSequenceKeypoint.new(1, 0) });
        ParticleEmitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.75, 0.1), NumberSequenceKeypoint.new(1, 1) });
        ParticleEmitter.LightEmission = 0;
        ParticleEmitter.Acceleration = Vector3.new(0, -20, 0);
        ParticleEmitter.LockedToPart = false;
        ParticleEmitter.Enabled = false;
        ParticleEmitter.Parent = Attachment3;
        local Attachment4 = Instance.new("Attachment", HumanoidRootPart);
        Attachment4.Name = "TrailFX_SplashAtt";
        Attachment4.Position = Vector3.new(0, -1.5, 0);
        local ParticleEmitter2 = Instance.new("ParticleEmitter");
        ParticleEmitter2.Name = "TrailFX_Splash";
        ParticleEmitter2.Texture = "rbxassetid://102982173039667";
        ParticleEmitter2.Rate = 25;
        ParticleEmitter2.Lifetime = NumberRange.new(0.6, 1);
        ParticleEmitter2.Speed = NumberRange.new(4, 9);
        ParticleEmitter2.SpreadAngle = Vector2.new(70, 70);
        ParticleEmitter2.Rotation = NumberRange.new(0, 360);
        ParticleEmitter2.RotSpeed = NumberRange.new(-90, 90);
        ParticleEmitter2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 160, 60)), ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 70, 20)) });
        ParticleEmitter2.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.1), NumberSequenceKeypoint.new(0.5, 0.7), NumberSequenceKeypoint.new(1, 0) });
        ParticleEmitter2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(0.8, 0.4), NumberSequenceKeypoint.new(1, 1) });
        ParticleEmitter2.LightEmission = 0;
        ParticleEmitter2.Acceleration = Vector3.new(0, -25, 0);
        ParticleEmitter2.LockedToPart = false;
        ParticleEmitter2.Enabled = false;
        ParticleEmitter2.Parent = Attachment4;
        Humanoid.Running:Connect(function(p4) -- Line: 125
            -- upvalues: ParticleEmitter (copy), ParticleEmitter2 (copy)
            local v5 = p4 > 1;

            if ParticleEmitter and ParticleEmitter.Parent then
                ParticleEmitter.Enabled = v5;
            end;

            if ParticleEmitter2 and ParticleEmitter2.Parent then
                ParticleEmitter2.Enabled = v5;
            end;
        end);

        return;
    end;

    if p2 ~= "EasterGoldenTrail" then
        if p2 == "GalaxyTrail" then
            local Trail2 = Instance.new("Trail");
            Trail2.Name = "TrailFX_Overlay";
            Trail2.Attachment0 = Attachment;
            Trail2.Attachment1 = Attachment2;
            Trail2.Lifetime = 0.45;
            Trail2.Texture = "rbxassetid://12251459424";
            Trail2.TextureMode = Enum.TextureMode.Stretch;
            Trail2.Color = ColorSequence.new(Color3.fromRGB(200, 160, 255));
            Trail2.FaceCamera = true;
            Trail2.Transparency = NumberSequence.new(0);
            Trail2.WidthScale = NumberSequence.new(1, 0);
            Trail2.LightInfluence = 0;
            Trail2.LightEmission = 1;
            Trail2.Parent = p1;
            local Attachment3 = Instance.new("Attachment", HumanoidRootPart);
            Attachment3.Name = "TrailFX_PartAtt";
            local ParticleEmitter = Instance.new("ParticleEmitter");
            ParticleEmitter.Name = "TrailFX_Particles";
            ParticleEmitter.Texture = "rbxassetid://12598279413";
            ParticleEmitter.Rate = 250;
            ParticleEmitter.Lifetime = NumberRange.new(0.6, 1.2);
            ParticleEmitter.Speed = NumberRange.new(0);
            ParticleEmitter.LockedToPart = false;
            ParticleEmitter.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 100, 255)) });
            ParticleEmitter.Size = NumberSequence.new(1.2, 0);
            ParticleEmitter.Transparency = NumberSequence.new(0, 1);
            ParticleEmitter.LightEmission = 1;
            ParticleEmitter.Enabled = false;
            ParticleEmitter.Parent = Attachment3;
            Humanoid.Running:Connect(function(p6) -- Line: 292
                -- upvalues: ParticleEmitter (copy)
                if ParticleEmitter and ParticleEmitter.Parent then
                    ParticleEmitter.Enabled = p6 > 1;
                end;
            end);
        end;

        return;
    end;

    Trail.Texture = "rbxassetid://71019043397814";
    Trail.TextureMode = Enum.TextureMode.Wrap;
    Trail.TextureLength = 2;
    Trail.Transparency = NumberSequence.new(0);
    Trail.Lifetime = 0.9;
    Trail.LightEmission = 0.1;
    Trail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1.5),
        NumberSequenceKeypoint.new(0.3, 1.1),
        NumberSequenceKeypoint.new(0.7, 0.5),
        NumberSequenceKeypoint.new(1, 0)
    });
    local Trail2 = Instance.new("Trail");
    Trail2.Name = "TrailFX_Overlay";
    Trail2.Attachment0 = Attachment;
    Trail2.Attachment1 = Attachment2;
    Trail2.Lifetime = 0.5;
    Trail2.Texture = "rbxassetid://12251459424";
    Trail2.TextureMode = Enum.TextureMode.Stretch;
    Trail2.Color = ColorSequence.new(Color3.fromRGB(255, 140, 0));
    Trail2.FaceCamera = true;
    Trail2.Transparency = NumberSequence.new(0);
    Trail2.WidthScale = NumberSequence.new(1, 0);
    Trail2.LightInfluence = 0;
    Trail2.LightEmission = 1;
    Trail2.Parent = p1;
    local Trail3 = Instance.new("Trail");
    Trail3.Name = "TrailFX_Glow";
    Trail3.Attachment0 = Attachment;
    Trail3.Attachment1 = Attachment2;
    Trail3.Lifetime = 0.25;
    Trail3.Texture = "rbxassetid://12598279413";
    Trail3.TextureMode = Enum.TextureMode.Stretch;
    Trail3.Color = ColorSequence.new(Color3.fromRGB(255, 180, 50));
    Trail3.FaceCamera = true;
    Trail3.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1) });
    Trail3.WidthScale = NumberSequence.new(1, 0);
    Trail3.LightInfluence = 0;
    Trail3.LightEmission = 1;
    Trail3.Parent = p1;
    local Attachment3 = Instance.new("Attachment", HumanoidRootPart);
    Attachment3.Name = "TrailFX_StarAtt";
    Attachment3.Position = Vector3.new(0, -1, 0);
    local ParticleEmitter = Instance.new("ParticleEmitter");
    ParticleEmitter.Name = "TrailFX_Stars";
    ParticleEmitter.Texture = "rbxassetid://10598374841";
    ParticleEmitter.Rate = 120;
    ParticleEmitter.Lifetime = NumberRange.new(0.6, 1.2);
    ParticleEmitter.Speed = NumberRange.new(2, 6);
    ParticleEmitter.SpreadAngle = Vector2.new(80, 80);
    ParticleEmitter.Rotation = NumberRange.new(0, 360);
    ParticleEmitter.RotSpeed = NumberRange.new(-180, 180);
    ParticleEmitter.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 160, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(230, 100, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 50, 0)) });
    ParticleEmitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 2), NumberSequenceKeypoint.new(0.5, 1.4), NumberSequenceKeypoint.new(1, 0) });
    ParticleEmitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.85, 0), NumberSequenceKeypoint.new(1, 1) });
    ParticleEmitter.LightEmission = 1;
    ParticleEmitter.Acceleration = Vector3.new(0, 4, 0);
    ParticleEmitter.LockedToPart = false;
    ParticleEmitter.Enabled = false;
    ParticleEmitter.Parent = Attachment3;
    local Attachment4 = Instance.new("Attachment", HumanoidRootPart);
    Attachment4.Name = "TrailFX_SparkAtt";
    Attachment4.Position = Vector3.new(0, -0.5, 0);
    local ParticleEmitter2 = Instance.new("ParticleEmitter");
    ParticleEmitter2.Name = "TrailFX_Sparks";
    ParticleEmitter2.Texture = "rbxassetid://12598279413";
    ParticleEmitter2.Rate = 180;
    ParticleEmitter2.Lifetime = NumberRange.new(0.3, 0.6);
    ParticleEmitter2.Speed = NumberRange.new(3, 8);
    ParticleEmitter2.SpreadAngle = Vector2.new(60, 60);
    ParticleEmitter2.Rotation = NumberRange.new(0, 360);
    ParticleEmitter2.RotSpeed = NumberRange.new(-360, 360);
    ParticleEmitter2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(251, 255, 234)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 200, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(144, 108, 0)) });
    ParticleEmitter2.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.4, 0.7), NumberSequenceKeypoint.new(1, 0) });
    ParticleEmitter2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.7, 0), NumberSequenceKeypoint.new(1, 1) });
    ParticleEmitter2.LightEmission = 1;
    ParticleEmitter2.Acceleration = Vector3.new(0, 8, 0);
    ParticleEmitter2.LockedToPart = false;
    ParticleEmitter2.Enabled = false;
    ParticleEmitter2.Parent = Attachment4;
    Humanoid.Running:Connect(function(p7) -- Line: 249
        -- upvalues: ParticleEmitter (copy), ParticleEmitter2 (copy)
        local v8 = p7 > 1;

        if ParticleEmitter and ParticleEmitter.Parent then
            ParticleEmitter.Enabled = v8;
        end;

        if ParticleEmitter2 and ParticleEmitter2.Parent then
            ParticleEmitter2.Enabled = v8;
        end;
    end);
end;

local function onCharacterAdded(u9) -- Line: 302
    -- upvalues: createTrail (copy)
    u9:GetAttributeChangedSignal("EquippedTrail"):Connect(function() -- Line: 303
        -- upvalues: createTrail (ref), u9 (copy)
        createTrail(u9, u9:GetAttribute("EquippedTrail"));
    end);
    local v10 = u9:GetAttribute("EquippedTrail");

    if v10 then
        createTrail(u9, v10);

        return;
    end;

    task.delay(1.5, function() -- Line: 311
        -- upvalues: u9 (copy), createTrail (ref)
        if not u9.Parent then
            return;
        end;

        local v11 = u9:GetAttribute("EquippedTrail");

        if v11 then
            createTrail(u9, v11);
        end;
    end);
end;

Players.PlayerAdded:Connect(function(p12) -- Line: 319
    -- upvalues: onCharacterAdded (copy)
    p12.CharacterAdded:Connect(onCharacterAdded);
end);

for _, v in ipairs(Players:GetPlayers()) do
    if v.Character then
        onCharacterAdded(v.Character);
    end;

    v.CharacterAdded:Connect(onCharacterAdded);
end;