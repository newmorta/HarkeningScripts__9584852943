-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.SpecialKeyClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local LocalPlayer = Players.LocalPlayer;
local NotificationSystem = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
local SoundManager = require(ReplicatedStorage:WaitForChild("SoundManager"));
local SpecialKeyEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SpecialKeyEvent");
local u1 = 0;
local u2 = 0;
local Ligtning = ReplicatedStorage:FindFirstChild("Ligtning");
LocalPlayer:WaitForChild("PlayerGui");

local function createLightningHit(p3) -- Line: 30
    -- upvalues: Ligtning (copy), Debris (copy)
    if not Ligtning then
        return;
    end;

    local HitParticles = Ligtning:FindFirstChild("HitParticles");

    if HitParticles then
        local u4 = HitParticles:Clone();
        u4.Position = p3;
        u4.Parent = workspace;
        Debris:AddItem(u4, 3);
        task.delay(0.3, function() -- Line: 41
            -- upvalues: u4 (copy)
            if u4 and u4.Parent then
                for _, descendant in ipairs(u4:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") or descendant:IsA("PointLight") then
                        descendant.Enabled = false;
                    end;
                end;
            end;
        end);
    end;

    local LightningSound = Ligtning:FindFirstChild("LightningSound");

    if LightningSound then
        local Part = Instance.new("Part");
        Part.Size = Vector3.new(1, 1, 1);
        Part.Position = p3;
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanTouch = false;
        Part.CanQuery = false;
        Part.Transparency = 1;
        Part.Parent = workspace.Terrain;
        local v5 = LightningSound:Clone();
        v5.Volume = 0.5;
        v5.RollOffMode = Enum.RollOffMode.Linear;
        v5.RollOffMinDistance = 10;
        v5.RollOffMaxDistance = 200;
        v5.Parent = Part;
        v5:Play();
        Debris:AddItem(Part, 5);
    end;
end;

local function createCollectEffect(p6, p7) -- Line: 80
    -- upvalues: TweenService (copy), Debris (copy)
    local Part = Instance.new("Part");
    Part.Size = Vector3.new(1, 1, 1);
    Part.Position = p6;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Transparency = 1;
    Part.Parent = workspace.Terrain;
    local ParticleEmitter = Instance.new("ParticleEmitter");

    if p7 then
        ParticleEmitter.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 10)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) });
    else
        ParticleEmitter.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 50)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 150, 0)) });
    end;

    ParticleEmitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.5), NumberSequenceKeypoint.new(1, 0) });
    ParticleEmitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.8, 0.3), NumberSequenceKeypoint.new(1, 1) });
    ParticleEmitter.Lifetime = NumberRange.new(0.8, 1.5);
    ParticleEmitter.Speed = NumberRange.new(10, 25);
    ParticleEmitter.SpreadAngle = Vector2.new(360, 360);
    ParticleEmitter.Rate = 0;
    ParticleEmitter.LightEmission = p7 and 0 or 1;
    ParticleEmitter.Parent = Part;
    ParticleEmitter:Emit(30);
    local PointLight = Instance.new("PointLight");
    local v8;

    if p7 then
        v8 = Color3.fromRGB(50, 50, 50);
    else
        v8 = Color3.fromRGB(255, 255, 100);
    end;

    PointLight.Color = v8;
    PointLight.Brightness = p7 and 2 or 6;
    PointLight.Range = p7 and 20 or 30;
    PointLight.Parent = Part;
    task.delay(0.2, function() -- Line: 129
        -- upvalues: TweenService (ref), PointLight (copy)
        TweenService:Create(PointLight, TweenInfo.new(0.5), {
            Brightness = 0,
            Range = 0
        }):Play();
    end);
    Debris:AddItem(Part, 2);
end;

SpecialKeyEvent.OnClientEvent:Connect(function(p9) -- Line: 140
    -- upvalues: u1 (ref), createLightningHit (copy), u2 (ref), createCollectEffect (copy), NotificationSystem (copy), SoundManager (copy)
    if type(p9) ~= "table" then
        return;
    end;

    local action = p9.action;
    local position = p9.position;

    if position and typeof(position) ~= "Vector3" then
        return;
    end;

    local v10 = tick();

    if action == "spawn" then
        if position and v10 - u1 >= 0.5 then
            u1 = v10;
            createLightningHit(position);
        end;
    elseif action == "collect" then
        if position and v10 - u2 >= 0.3 then
            u2 = v10;
            createCollectEffect(position, p9.isSecret);
        end;
    else
        if action == "notification" and (p9.text and p9.color) then
            local color = p9.color;
            NotificationSystem:ShowGeneralNotification(p9.text, Color3.fromRGB(color[1], color[2], color[3]), p9.duration);
            SoundManager:Play("SPECIAL_KEY_NOTIF");

            return;
        end;

        local _ = action == "despawn";
    end;
end);