-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.RainingTacos
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PartyEvent = require(script.Parent.Parent.PartyEvent);
local Spotlight = require(ReplicatedStorage.Utilities.Events.Spotlight);
local ParticleZone = require(ReplicatedStorage.Utilities.Events.ParticleZone);
local u1 = Spotlight.new({
    colorSpeed = 0.18,
    range = 30,
    speed = 1.5,
    ccSpeed = 0.072,
    cameraOffset = CFrame.new(0, 20, -50)
});
local v2 = PartyEvent.new({
    Sounds = { "rbxassetid://142376088" }
});

function v2.OnStart(p3, p4, p5, p6, p7) -- Line: 27
    -- upvalues: Lighting (copy), u1 (copy), ParticleZone (copy)
    local janitor = p4.janitor;
    local v8 = janitor:Add(Instance.new("ColorCorrectionEffect"));
    v8.Name = "RainingTacosCC";
    v8.Brightness = 0.04;
    v8.Contrast = 0.12;
    v8.Saturation = 0.35;
    v8.TintColor = Color3.fromRGB(255, 255, 255);
    v8.Parent = Lighting;
    p4._cc = v8;
    local v9 = janitor:Add(Instance.new("BloomEffect"));
    v9.Name = "RainingTacosBloom";
    v9.Intensity = 0.55;
    v9.Size = 20;
    v9.Threshold = 0.88;
    v9.Parent = Lighting;
    u1:setup(p4, p7, janitor);
    local v10 = ParticleZone.new({
        diameter = 50
    });
    v10:setup(janitor, CFrame.new(p7.CFrame.Position));
    p4._tacoZone = v10;
    local ParticleEmitter = Instance.new("ParticleEmitter");
    ParticleEmitter.Texture = "rbxassetid://99411353334255";
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255));
    ParticleEmitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.85, 0), NumberSequenceKeypoint.new(1, 1) });
    ParticleEmitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.8), NumberSequenceKeypoint.new(1, 1.8) });
    ParticleEmitter.LightEmission = 0.1;
    ParticleEmitter.LightInfluence = 0.9;
    ParticleEmitter.Speed = NumberRange.new(8, 16);
    ParticleEmitter.SpreadAngle = Vector2.new(30, 30);
    ParticleEmitter.EmissionDirection = Enum.NormalId.Bottom;
    ParticleEmitter.Acceleration = Vector3.new(0, -20, 0);
    ParticleEmitter.Lifetime = NumberRange.new(2, 3.5);
    ParticleEmitter.Rate = 25;
    ParticleEmitter.LockedToPart = true;
    ParticleEmitter.RotSpeed = NumberRange.new(-200, 200);
    ParticleEmitter.Rotation = NumberRange.new(0, 360);
    ParticleEmitter.Parent = v10.part;
end;

function v2.OnRender(p11, p12, p13, p14, p15, p16) -- Line: 79
    -- upvalues: u1 (copy)
    u1:update(p12, p13, p16);

    if p12._tacoZone then
        p12._tacoZone:update(p16.CFrame.Position);
    end;
end;

function v2.OnStop(p17, p18) -- Line: 86
end;

return v2;