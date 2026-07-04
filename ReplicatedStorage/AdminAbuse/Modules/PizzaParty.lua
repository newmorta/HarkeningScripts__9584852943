-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.PizzaParty
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Lighting = game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local DanceSpawner = require(ReplicatedStorage.Utilities.Events.DanceSpawner);
local ParticleZone = require(ReplicatedStorage.Utilities.Events.ParticleZone);
local PartyEvent = require(script.Parent.Parent.PartyEvent);
local LocalPlayer = Players.LocalPlayer;
local u1 = nil;

local function getNotificationSystem() -- Line: 19
    -- upvalues: u1 (ref), ReplicatedStorage (copy)
    if not u1 then
        u1 = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
    end;

    return u1;
end;

local u2 = Color3.fromRGB(255, 225, 180);
local u3 = DanceSpawner.new({
    spinSpeed = 10,
    jumpFreq = 5,
    jumpHeight = 2
});

local function makeVFXPizza() -- Line: 56
    -- upvalues: ReplicatedStorage (copy)
    local v4 = ReplicatedStorage.Assets.Events:WaitForChild("Pizza"):Clone();
    v4.Name = "PizzaVFX";
    v4.Size = Vector3.new(5, 0.5, 5);
    v4.Anchored = true;
    v4.CanCollide = false;
    v4.CastShadow = false;
    v4.Parent = workspace;

    return v4;
end;

local function getVFXPizza() -- Line: 69
    -- upvalues: ReplicatedStorage (copy)
    local v5 = ReplicatedStorage:FindFirstChild("Templates") and v5:FindFirstChild("Pizzas");

    if v5 then
        local v6 = v5:GetChildren();

        if #v6 > 0 then
            local v7 = v6[math.random(1, #v6)]:Clone();

            local function forceVFX(p8) -- Line: 76
                p8.Anchored = true;
                p8.CanCollide = false;
            end;

            if v7:IsA("BasePart") then
                v7.Anchored = true;
                v7.CanCollide = false;
            else
                for _, descendant in ipairs(v7:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        descendant.Anchored = true;
                        descendant.CanCollide = false;
                    end;
                end;
            end;

            v7.Parent = workspace;

            return v7;
        end;
    end;

    local v9 = ReplicatedStorage.Assets.Events:WaitForChild("Pizza"):Clone();
    v9.Name = "PizzaVFX";
    v9.Size = Vector3.new(5, 0.5, 5);
    v9.Anchored = true;
    v9.CanCollide = false;
    v9.CastShadow = false;
    v9.Parent = workspace;

    return v9;
end;

local function setPizzaCF(p10, p11) -- Line: 94
    if p10:IsA("BasePart") then
        p10.CFrame = p11;

        return;
    end;

    p10:PivotTo(p11);
end;

local v12 = PartyEvent.new({
    IsAdminAbuse = false,
    NeedsDuration = true,
    MaxDurationSeconds = 1200,
    DefaultDurationSeconds = 600,
    RequiresRespawnRefire = true,
    SkipDoorTransition = true,
    Sounds = { "rbxassetid://126430501965399" }
});

function v12.OnStart(p13, u14, p15, p16, p17) -- Line: 117
    -- upvalues: Lighting (copy), TweenService (copy), u2 (copy), u1 (ref), ReplicatedStorage (copy), LocalPlayer (copy), ParticleZone (copy), u3 (copy)
    u14._vfx = nil;
    u14._nextVfx = os.clock();
    u14._lastNow = nil;
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.TintColor = Color3.new(1, 1, 1);
    ColorCorrectionEffect.Brightness = 0;
    ColorCorrectionEffect.Contrast = 0;
    ColorCorrectionEffect.Saturation = 0;
    ColorCorrectionEffect.Parent = Lighting;
    u14._orangeFilter = ColorCorrectionEffect;
    TweenService:Create(ColorCorrectionEffect, TweenInfo.new(1.5), {
        Brightness = 0.01,
        Contrast = 0.02,
        Saturation = 0.04,
        TintColor = u2
    }):Play();

    local function connectTool(p18) -- Line: 137
        -- upvalues: u14 (copy), u1 (ref), ReplicatedStorage (ref)
        if p18.Name ~= "PizzaSlice" then
            return;
        end;

        u14.janitor:Add(p18.Activated:Connect(function() -- Line: 139
            -- upvalues: u1 (ref), ReplicatedStorage (ref)
            if not u1 then
                u1 = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
            end;

            u1:ShowGeneralNotification("PIZZA TIME X2 SPEED!", Color3.fromRGB(255, 200, 50));
        end));
    end;

    local Backpack = LocalPlayer:FindFirstChild("Backpack");

    if Backpack then
        for _, child in ipairs(Backpack:GetChildren()) do
            if child.Name == "PizzaSlice" then
                u14.janitor:Add(child.Activated:Connect(function() -- Line: 139
                    -- upvalues: u1 (ref), ReplicatedStorage (ref)
                    if not u1 then
                        u1 = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
                    end;

                    u1:ShowGeneralNotification("PIZZA TIME X2 SPEED!", Color3.fromRGB(255, 200, 50));
                end));
            end;
        end;

        u14.janitor:Add(Backpack.ChildAdded:Connect(connectTool));
    end;

    local v19 = ParticleZone.new({
        diameter = 40
    });
    v19:setup(u14.janitor, CFrame.new(p17.CFrame.Position));
    u14.particleZone = v19;
    local ParticleEmitter = Instance.new("ParticleEmitter");
    ParticleEmitter.Texture = "rbxassetid://88867975870506";
    ParticleEmitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.2), NumberSequenceKeypoint.new(0.5, 1.5), NumberSequenceKeypoint.new(1, 0.4) });
    ParticleEmitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.7, 0.3), NumberSequenceKeypoint.new(1, 1) });
    ParticleEmitter.Speed = NumberRange.new(2, 6);
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180);
    ParticleEmitter.Lifetime = NumberRange.new(3, 6);
    ParticleEmitter.Rate = 20;
    ParticleEmitter.RotSpeed = NumberRange.new(-45, 45);
    ParticleEmitter.Rotation = NumberRange.new(0, 360);
    ParticleEmitter.LockedToPart = true;
    ParticleEmitter.Parent = v19.part;
    local Chickens = ReplicatedStorage.Assets.Events:FindFirstChild("Chickens");
    local PizzaSlice = ReplicatedStorage.Assets.Events:FindFirstChild("PizzaSlice");

    if not Chickens then
        warn("[MiguelParty] Folder \"Chickens\" introuvable dans ReplicatedStorage");

        return;
    end;

    if PizzaSlice then
        u3:setup(u14.janitor, Chickens, PizzaSlice);

        return;
    end;

    warn("[MiguelParty] Modèle \"PizzaSlice\" introuvable dans ReplicatedStorage");
end;

function v12.OnRender(p20, p21, p22, p23, p24, p25) -- Line: 194
    -- upvalues: u3 (copy), Players (copy), getVFXPizza (copy), LocalPlayer (copy)
    if p21.particleZone then
        p21.particleZone:update(p25.CFrame.Position);
    end;

    u3:update(p22);
    local v26 = p22 - (p21._lastNow or p22);
    p21._lastNow = p22;

    if v26 <= 0 then
        return;
    end;

    if p21._nextVfx <= p22 then
        if p21._vfx and p21._vfx.part.Parent then
            p21._vfx.part:Destroy();
        end;

        local v27 = Players:GetPlayers();

        if #v27 > 0 then
            local v28 = v27[math.random(1, #v27)];

            if v28.Character then
                local v29 = getVFXPizza();
                p21.janitor:Add(v29);
                p21._vfx = {
                    angle = 0,
                    part = v29,
                    endTime = p22 + 10,
                    userId = v28.UserId
                };
            end;
        end;

        p21._nextVfx = p22 + 8;
    end;

    local _vfx = p21._vfx;

    if not _vfx then
        return;
    end;

    if _vfx.endTime <= p22 or not _vfx.part.Parent then
        if _vfx.part.Parent then
            _vfx.part:Destroy();
        end;

        p21._vfx = nil;

        return;
    end;

    local v30 = Players:GetPlayerByUserId(_vfx.userId);
    local v31 = v30 and v30.Character and v30.Character:FindFirstChild("HumanoidRootPart");

    if not v31 then
        return;
    end;

    _vfx.angle = _vfx.angle + 3.141592653589793 * v26;
    local part = _vfx.part;
    local v32 = CFrame.new(v31.Position + Vector3.new(0, -3, 0)) * CFrame.Angles(0, _vfx.angle, 0);

    if part:IsA("BasePart") then
        part.CFrame = v32;
    else
        part:PivotTo(v32);
    end;

    if v30 == LocalPlayer and (p24 and p24.Parent) then
        p24.CFrame = p24.CFrame * CFrame.Angles(0, 1.3962634015954636 * v26, 0);
    end;
end;

function v12.OnStop(p33, p34) -- Line: 250
    -- upvalues: TweenService (copy)
    if p34._vfx and p34._vfx.part.Parent then
        p34._vfx.part:Destroy();
    end;

    p34._vfx = nil;
    local _orangeFilter = p34._orangeFilter;

    if _orangeFilter and _orangeFilter.Parent then
        local v35 = TweenService:Create(_orangeFilter, TweenInfo.new(1.5), {
            Brightness = 0,
            Contrast = 0,
            Saturation = 0,
            TintColor = Color3.new(1, 1, 1)
        });
        v35.Completed:Once(function() -- Line: 264
            -- upvalues: _orangeFilter (copy)
            _orangeFilter:Destroy();
        end);
        v35:Play();
    end;

    p34._orangeFilter = nil;
end;

return v12;