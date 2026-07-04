-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.AuraRenderer
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AuraConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("AuraConfig"));
local LocalPlayer = Players.LocalPlayer;

local function setAuraEnabled(p1, p2) -- Line: 8
    for _, descendant in p1:GetDescendants() do
        if descendant.Name == "AuraFX_Att" then
            for _, descendant2 in descendant:GetDescendants() do
                if descendant2:IsA("ParticleEmitter") then
                    descendant2.Enabled = p2;
                end;
            end;
        end;
    end;
end;

local function attachEmitter(p3, p4) -- Line: 20
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "AuraFX_Att";
    Attachment.Position = Vector3.new(0, 0, 0);
    Attachment.Parent = p3;

    if p4.instance then
        local v5 = p4.instance:Clone();
        v5.Name = "AuraFX_Emitter";
        v5.Parent = Attachment;

        return;
    end;

    local particles = p4.particles;
    local ParticleEmitter = Instance.new("ParticleEmitter");
    ParticleEmitter.Name = "AuraFX_Emitter";
    ParticleEmitter.Texture = particles.texture;
    ParticleEmitter.Rate = particles.rate;
    ParticleEmitter.Lifetime = particles.lifetime;
    ParticleEmitter.Speed = particles.speed;
    ParticleEmitter.SpreadAngle = particles.spreadAngle;
    ParticleEmitter.Color = particles.color;
    ParticleEmitter.Size = particles.size;
    ParticleEmitter.Transparency = particles.transparency;
    ParticleEmitter.LightEmission = particles.lightEmission;
    ParticleEmitter.LightInfluence = 0;
    ParticleEmitter.LockedToPart = true;
    ParticleEmitter.Enabled = true;

    if particles.acceleration then
        ParticleEmitter.Acceleration = particles.acceleration;
    end;

    if particles.rotation then
        ParticleEmitter.Rotation = particles.rotation;
    end;

    if particles.rotSpeed then
        ParticleEmitter.RotSpeed = particles.rotSpeed;
    end;

    ParticleEmitter.Parent = Attachment;
end;

local function createAura(p6, p7) -- Line: 55
    -- upvalues: AuraConfig (copy), attachEmitter (copy), LocalPlayer (copy), setAuraEnabled (copy)
    for _, descendant in ipairs(p6:GetDescendants()) do
        if descendant.Name:find("AuraFX") then
            descendant:Destroy();
        end;
    end;

    if p7 == "None" or not p7 then
        return;
    end;

    local v8 = AuraConfig.AURAS[p7];

    if not (v8 and (v8.instance or v8.particles)) then
        return;
    end;

    local HumanoidRootPart = p6:WaitForChild("HumanoidRootPart", 5);

    if not HumanoidRootPart then
        return;
    end;

    local v9 = p6:FindFirstChild("UpperTorso") or (p6:FindFirstChild("Torso") or HumanoidRootPart);

    if not v9 then
        return;
    end;

    attachEmitter(v9, v8);

    if LocalPlayer:GetAttribute("AuraHidden") then
        setAuraEnabled(p6, false);
    end;
end;

local function onCharacterAdded(u10) -- Line: 80
    -- upvalues: createAura (copy)
    u10:GetAttributeChangedSignal("EquippedAura"):Connect(function() -- Line: 81
        -- upvalues: createAura (ref), u10 (copy)
        createAura(u10, u10:GetAttribute("EquippedAura"));
    end);
    local v11 = u10:GetAttribute("EquippedAura");

    if v11 then
        createAura(u10, v11);

        return;
    end;

    task.delay(1.5, function() -- Line: 89
        -- upvalues: u10 (copy), createAura (ref)
        if not u10.Parent then
            return;
        end;

        local v12 = u10:GetAttribute("EquippedAura");

        if v12 then
            createAura(u10, v12);
        end;
    end);
end;

LocalPlayer:GetAttributeChangedSignal("AuraHidden"):Connect(function() -- Line: 97
    -- upvalues: LocalPlayer (copy), setAuraEnabled (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    setAuraEnabled(Character, not LocalPlayer:GetAttribute("AuraHidden"));
end);
Players.PlayerAdded:Connect(function(p13) -- Line: 103
    -- upvalues: onCharacterAdded (copy)
    p13.CharacterAdded:Connect(onCharacterAdded);
end);

for _, v in ipairs(Players:GetPlayers()) do
    if v.Character then
        onCharacterAdded(v.Character);
    end;

    v.CharacterAdded:Connect(onCharacterAdded);
end;