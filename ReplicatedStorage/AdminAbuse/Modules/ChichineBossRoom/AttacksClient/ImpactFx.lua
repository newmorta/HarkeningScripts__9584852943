-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.ChichineBossRoom.AttacksClient.ImpactFx
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ClientDebris = require(script.Parent.ClientDebris);
local u1 = nil;

local function getThunderHitTemplate() -- Line: 15
    -- upvalues: u1 (ref), ReplicatedStorage (copy)
    if u1 and u1.Parent then
        return u1;
    end;

    local v2 = ReplicatedStorage:FindFirstChild("AdminAbuse") and v2:FindFirstChild("LuckymatBossRoom") and v2:FindFirstChild("VFX") and (v2:FindFirstChild("ThunderHit") or (v2:FindFirstChild("HitParticles") or v2:FindFirstChild("Thunder")));

    if not v2 then
        local success, result = pcall(function() -- Line: 28
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage:WaitForChild("EventsConfig"));
        end);

        if success and result then
            local Storm = result.Storm;
            v2 = ReplicatedStorage:FindFirstChild(Storm and Storm.LightningFolder or "Ligtning") and v2:FindFirstChild("HitParticles");
        end;
    end;

    u1 = v2;

    return v2;
end;

local function thunderHitAt(p3, p4) -- Line: 42
    -- upvalues: getThunderHitTemplate (copy), Debris (copy)
    local v5 = getThunderHitTemplate();

    if not v5 then
        return;
    end;

    local v6 = p4 or 1;
    local u7 = v5:Clone();

    if u7:IsA("BasePart") then
        u7.Size = u7.Size * v6;
        u7.CFrame = CFrame.new(p3);
    elseif u7:IsA("Model") then
        u7:ScaleTo(v6);
        u7:PivotTo(CFrame.new(p3));
    elseif u7:IsA("Attachment") then
        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.Transparency = 1;
        Part.Size = Vector3.new(1, 1, 1);
        Part.CFrame = CFrame.new(p3);
        Part.Parent = workspace;
        u7.Parent = Part;
        u7 = Part;
    end;

    u7.Parent = workspace;
    Debris:AddItem(u7, 3);
    task.delay(0.35, function() -- Line: 68
        -- upvalues: u7 (ref)
        if u7 and u7.Parent then
            for _, descendant in u7:GetDescendants() do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("PointLight") then
                    descendant.Enabled = false;
                end;
            end;
        end;
    end);
end;

local function playSpatialSound(p8, p9, p10) -- Line: 79
    -- upvalues: Debris (copy)
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.Transparency = 1;
    Part.Size = Vector3.new(1, 1, 1);
    Part.CFrame = CFrame.new(p8);
    Part.Parent = workspace;
    local Sound = Instance.new("Sound");
    Sound.SoundId = p9;
    Sound.Volume = p10;
    Sound.RollOffMinDistance = 20;
    Sound.RollOffMaxDistance = 700;
    Sound.Parent = Part;
    Sound:Play();
    Sound.Ended:Once(function() -- Line: 96
        -- upvalues: Part (copy)
        pcall(function() -- Line: 97
            -- upvalues: Part (ref)
            Part:Destroy();
        end);
    end);
    Debris:AddItem(Part, 12);
end;

local function screenShakeNearby(p11, p12, p13, p14) -- Line: 102
    -- upvalues: Players (copy), RunService (copy)
    local Character = Players.LocalPlayer.Character;

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local Magnitude = (HumanoidRootPart.Position - Vector3.new(p11, p12, p13)).Magnitude;

    if p14 * 3 < Magnitude then
        return;
    end;

    local u15 = math.clamp(1 - Magnitude / (p14 * 3), 0.1, 1) * 0.6;
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local u16 = 0;
    local u17 = nil;
    u17 = RunService.RenderStepped:Connect(function(p18) -- Line: 117
        -- upvalues: u16 (ref), u17 (ref), u15 (copy), CurrentCamera (copy)
        u16 = u16 + p18;

        if u16 >= 0.4 then
            u17:Disconnect();

            return;
        end;

        local v19 = u15 * (1 - u16 / 0.4);
        CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new((math.random() * 2 - 1) * v19, (math.random() * 2 - 1) * v19, 0);
    end);
end;

return {
    sounds = function(p20, p21, p22) -- Line: 136, Name: sounds
        -- upvalues: playSpatialSound (copy)
        local v23 = Vector3.new(p20, p21, p22);
        playSpatialSound(v23, "rbxassetid://135676461695962", 1);
        playSpatialSound(v23, "rbxassetid://139520673393967", 0.65);
    end,

    explosion = function(p24, p25, p26, p27) -- Line: 144, Name: explosion
        -- upvalues: ClientDebris (copy), TweenService (copy), thunderHitAt (copy), playSpatialSound (copy), screenShakeNearby (copy)
        local v28 = Vector3.new(p24, p25, p26);
        local v29 = p27 * 1.3;
        local Part = Instance.new("Part");
        Part.Shape = Enum.PartType.Ball;
        Part.Size = Vector3.new(2, 2, 2);
        Part.CFrame = CFrame.new(p24, p25, p26);
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CastShadow = false;
        Part.Material = Enum.Material.Neon;
        Part.Color = Color3.fromRGB(255, 80, 30);
        Part.Transparency = 0;
        Part.Parent = ClientDebris();
        TweenService:Create(Part, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(v29, v29, v29)
        }):Play();
        task.delay(0.2, function() -- Line: 167
            -- upvalues: Part (copy), TweenService (ref)
            if not Part.Parent then
                return;
            end;

            local u30 = TweenService:Create(Part, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Transparency = 1
            });
            u30.Completed:Once(function() -- Line: 172
                -- upvalues: u30 (copy), Part (ref)
                u30:Destroy();
                pcall(function() -- Line: 174
                    -- upvalues: Part (ref)
                    Part:Destroy();
                end);
            end);
            u30:Play();
        end);
        thunderHitAt(v28, 5);
        playSpatialSound(v28, "rbxassetid://135676461695962", 1);
        playSpatialSound(v28, "rbxassetid://139520673393967", 0.65);
        screenShakeNearby(p24, p25, p26, p27 * 2.5);
    end
};