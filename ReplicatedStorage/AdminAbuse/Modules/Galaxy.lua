-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.Galaxy
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PartyEvent = require(script.Parent.Parent.PartyEvent);
local GravityManager = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("GravityManager"));
local ParticleZone = require(ReplicatedStorage.Utilities.Events.ParticleZone);
local LightingSnapshot = require(ReplicatedStorage.Utilities.Events.LightingSnapshot);
local v1 = PartyEvent.new({
    Sounds = { "rbxassetid://92493694084741" }
});

function v1.OnStart(p2, p3, p4, p5, p6) -- Line: 22
    -- upvalues: GravityManager (copy), LightingSnapshot (copy), Lighting (copy), ParticleZone (copy)
    local janitor = p3.janitor;
    GravityManager.set("Galaxy", 20, 10);
    LightingSnapshot.acquireShared();
    LightingSnapshot.capture({ "ClockTime", "Brightness", "Ambient", "OutdoorAmbient" }):apply({
        ClockTime = 0,
        Brightness = 10,
        Ambient = Color3.new(1, 1, 1),
        OutdoorAmbient = Color3.new(1, 1, 1)
    });
    local v7 = janitor:Add(Instance.new("ColorCorrectionEffect"));
    v7.Name = "GalaxyColorCorrection";
    v7.Brightness = -0.3;
    v7.Contrast = 0.12;
    v7.Saturation = 0.18;
    v7.TintColor = Color3.fromRGB(180, 150, 255);
    v7.Parent = Lighting;
    local v8 = ParticleZone.new({
        diameter = 50
    });
    v8:setup(janitor, CFrame.new(p6.CFrame.Position));
    p3.galaxyZone = v8;
    local v9 = janitor:Add(Instance.new("Attachment"));
    v9.Name = "GalaxyStars";
    v9.Parent = p5;
    local v10 = janitor:Add(Instance.new("PointLight"));
    v10.Color = Color3.fromRGB(180, 140, 255);
    v10.Brightness = 3;
    v10.Range = 54;
    v10.Parent = v9;
    local ParticleEmitter = Instance.new("ParticleEmitter");
    ParticleEmitter.Texture = "rbxassetid://91897496727346";
    ParticleEmitter.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.4, Color3.fromRGB(210, 190, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 90, 255)) });
    ParticleEmitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.05), NumberSequenceKeypoint.new(0.5, 0.35), NumberSequenceKeypoint.new(1, 1) });
    ParticleEmitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(0.5, 1.6), NumberSequenceKeypoint.new(1, 0.3) });
    ParticleEmitter.LightEmission = 1;
    ParticleEmitter.LightInfluence = 0;
    ParticleEmitter.Speed = NumberRange.new(0.5, 3);
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180);
    ParticleEmitter.Lifetime = NumberRange.new(2.5, 5);
    ParticleEmitter.Rate = 40;
    ParticleEmitter.LockedToPart = true;
    ParticleEmitter.RotSpeed = NumberRange.new(-90, 90);
    ParticleEmitter.Rotation = NumberRange.new(0, 360);
    ParticleEmitter.Parent = v8.part;
    local ParticleEmitter2 = Instance.new("ParticleEmitter");
    ParticleEmitter2.Texture = "rbxassetid://243660364";
    ParticleEmitter2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 170, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 80, 255)) });
    ParticleEmitter2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.55), NumberSequenceKeypoint.new(0.5, 0.75), NumberSequenceKeypoint.new(1, 1) });
    ParticleEmitter2.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.4), NumberSequenceKeypoint.new(1, 0.3) });
    ParticleEmitter2.LightEmission = 1;
    ParticleEmitter2.LightInfluence = 0;
    ParticleEmitter2.Speed = NumberRange.new(0.3, 2);
    ParticleEmitter2.SpreadAngle = Vector2.new(180, 180);
    ParticleEmitter2.Lifetime = NumberRange.new(2, 4);
    ParticleEmitter2.Rate = 28;
    ParticleEmitter2.LockedToPart = true;
    ParticleEmitter2.RotSpeed = NumberRange.new(-60, 60);
    ParticleEmitter2.Rotation = NumberRange.new(0, 360);
    ParticleEmitter2.Parent = v8.part;
end;

function v1.OnRender(p11, p12, p13, p14, p15, p16) -- Line: 115
    if p12.galaxyZone then
        p12.galaxyZone:update(p16.CFrame.Position);
    end;
end;

function v1.OnStop(p17, p18) -- Line: 121
    -- upvalues: GravityManager (copy), LightingSnapshot (copy)
    GravityManager.release("Galaxy");
    LightingSnapshot.releaseShared();
end;

return v1;