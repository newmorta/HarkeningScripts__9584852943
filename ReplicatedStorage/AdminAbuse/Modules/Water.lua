-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.Water
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PartyEvent = require(script.Parent.Parent.PartyEvent);
local GravityManager = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("GravityManager"));
local ParticleZone = require(ReplicatedStorage.Utilities.Events.ParticleZone);
local LightingSnapshot = require(ReplicatedStorage.Utilities.Events.LightingSnapshot);
local v1 = PartyEvent.new({
    Sounds = { "rbxassetid://124895160162220" }
});

function v1.OnStart(p2, u3, p4, p5, p6) -- Line: 41
    -- upvalues: GravityManager (copy), LightingSnapshot (copy), Lighting (copy), ParticleZone (copy), ReplicatedStorage (copy), Players (copy)
    local janitor = u3.janitor;
    GravityManager.set("Water", 40, 10);
    LightingSnapshot.acquireShared();
    LightingSnapshot.capture({ "ClockTime", "Ambient", "OutdoorAmbient" }):apply({
        ClockTime = 14,
        Ambient = Color3.fromRGB(200, 220, 255),
        OutdoorAmbient = Color3.fromRGB(180, 210, 255)
    });
    local v7 = janitor:Add(Instance.new("ColorCorrectionEffect"));
    v7.Name = "WaterColorCorrection";
    v7.Brightness = 0.02;
    v7.Contrast = 0.05;
    v7.Saturation = 0.15;
    v7.TintColor = Color3.fromRGB(140, 200, 255);
    v7.Parent = Lighting;
    local v8 = ParticleZone.new({
        diameter = 40
    });
    v8:setup(janitor, CFrame.new(p6.CFrame.Position));
    u3.zonePart = v8;
    local ParticleEmitter = Instance.new("ParticleEmitter");
    ParticleEmitter.Texture = "rbxassetid://137027945265090";
    ParticleEmitter.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 230, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 180, 255)) });
    ParticleEmitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(0.7, 0.5), NumberSequenceKeypoint.new(1, 1) });
    ParticleEmitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(0.5, 1.6), NumberSequenceKeypoint.new(1, 0.3) });
    ParticleEmitter.LockedToPart = true;
    ParticleEmitter.LightEmission = 0.5;
    ParticleEmitter.LightInfluence = 0.5;
    ParticleEmitter.Speed = NumberRange.new(2, 8);
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180);
    ParticleEmitter.Lifetime = NumberRange.new(2.5, 5);
    ParticleEmitter.Rate = 50;
    ParticleEmitter.RotSpeed = NumberRange.new(-30, 30);
    ParticleEmitter.Rotation = NumberRange.new(0, 360);
    ParticleEmitter.Parent = v8.part;
    local ParticleEmitter2 = Instance.new("ParticleEmitter");
    ParticleEmitter2.Texture = "rbxassetid://120860976556927";
    ParticleEmitter2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 190, 80)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 50)) });
    ParticleEmitter2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.8, 0.2), NumberSequenceKeypoint.new(1, 1) });
    ParticleEmitter2.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(0.5, 1), NumberSequenceKeypoint.new(1, 0.3) });
    ParticleEmitter2.LightEmission = 0.2;
    ParticleEmitter2.LightInfluence = 0.8;
    ParticleEmitter2.Speed = NumberRange.new(1, 5);
    ParticleEmitter2.SpreadAngle = Vector2.new(180, 180);
    ParticleEmitter2.Lifetime = NumberRange.new(2, 4);
    ParticleEmitter2.Rate = 18;
    ParticleEmitter2.LockedToPart = true;
    ParticleEmitter2.RotSpeed = NumberRange.new(-20, 20);
    ParticleEmitter2.Rotation = NumberRange.new(0, 360);
    ParticleEmitter2.Parent = v8.part;
    local Crab = ReplicatedStorage.Assets.Events:FindFirstChild("Crab");
    u3.playerCrabs = {};

    local function spawnCrabsForPlayer(p9) -- Line: 123
        -- upvalues: u3 (copy), Crab (copy), janitor (copy)
        local UserId = p9.UserId;

        if u3.playerCrabs[UserId] then
            return;
        end;

        if not (Crab and Crab:IsA("Model")) then
            return;
        end;

        local v10 = {};

        for i = 1, 8 do
            local v11 = (i - 1) / 8 * 3.141592653589793 * 2;
            local v12 = janitor:Add(Crab:Clone());

            for _, descendant in v12:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true;
                    descendant.CanCollide = false;
                    descendant.CanQuery = false;
                    descendant.Massless = true;
                end;
            end;

            v12.Parent = workspace;
            table.insert(v10, {
                model = v12,
                baseAngle = v11,
                phaseOffset = v11
            });
        end;

        u3.playerCrabs[UserId] = v10;
    end;

    for _, v in Players:GetPlayers() do
        spawnCrabsForPlayer(v);
    end;

    janitor:Add(Players.PlayerAdded:Connect(function(p13) -- Line: 149
        -- upvalues: spawnCrabsForPlayer (copy)
        spawnCrabsForPlayer(p13);
    end));
    janitor:Add(Players.PlayerRemoving:Connect(function(p14) -- Line: 153
        -- upvalues: u3 (copy)
        local v15 = u3.playerCrabs[p14.UserId];

        if v15 then
            for _, v in v15 do
                if v.model and v.model.Parent then
                    v.model:Destroy();
                end;
            end;

            u3.playerCrabs[p14.UserId] = nil;
        end;
    end));

    if not Crab then
        warn("[Water] Modèle \"Crab\" introuvable dans Assets/Events");
    end;

    local v16 = {};
    local Events = ReplicatedStorage.Assets.Events;
    local Fish = Events:FindFirstChild("Fish");
    local v17 = Events:FindFirstChild("Water") and v17:FindFirstChild("FishBox");

    if Fish and v17 then
        for _ = 1, 8 do
            local v18 = janitor:Add(Fish:Clone());

            for _, descendant in v18:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true;
                    descendant.CanCollide = false;
                    descendant.CanQuery = false;
                    descendant.CastShadow = false;
                    descendant.Massless = true;
                end;
            end;

            v18.Parent = workspace;
            local Y = v17.Position.Y;
            local Z = v17.Position.Z;
            local v19 = v17.Size.X * 0.4;
            local v20 = v17.Size.Y * 0.4;
            local v21 = v17.Size.Z * 0.4;
            local v22 = {
                model = v18
            };
            local v23 = v17.Position.X + (math.random() - 0.5) * 2 * v19;
            local v24 = Y + (math.random() - 0.5) * 2 * v20;
            local v25 = Z + (math.random() - 0.5) * 2 * v21;
            v22.pos = Vector3.new(v23, v24, v25);
            local v26 = (math.random() - 0.5) * 7;
            local v27 = (math.random() - 0.5) * 7 * 0.3;
            local v28 = (math.random() - 0.5) * 7;
            v22.vel = Vector3.new(v26, v27, v28);
            v22.noiseOffset = math.random() * 100;
            table.insert(v16, v22);
        end;
    else
        if not Fish then
            warn("[Water] Modèle \"Fish\" introuvable dans Assets/Events");
        end;

        if not v17 then
            warn("[Water] Part \"FishBox\" introuvable dans Assets/Events/Water");
        end;
    end;

    u3.fishData = v16;
    u3.fishBox = v17;
end;

function v1.OnRender(p29, p30, p31, p32, p33, p34) -- Line: 224
    -- upvalues: Players (copy)
    if p30.zonePart then
        p30.zonePart:update(p34.CFrame.Position);
    end;

    if p30.fishBox and p30.fishData then
        local fishBox = p30.fishBox;
        local X = fishBox.Position.X;
        local Y = fishBox.Position.Y;
        local Z = fishBox.Position.Z;
        local v35 = fishBox.Size.X * 0.45;
        local v36 = fishBox.Size.Y * 0.45;
        local v37 = fishBox.Size.Z * 0.45;
        local v38 = math.min(p31 - (p30.fishLastTime or p31), 0.1);
        p30.fishLastTime = p31;

        for _, v in p30.fishData do
            if v.model and v.model.Parent then
                local noiseOffset = v.noiseOffset;
                local v39 = p31 * 0.35;
                local v40 = math.noise(v39, 0, noiseOffset) * 10;
                local v41 = math.noise(0, v39, noiseOffset + 10) * 10 * 0.25;
                local v42 = math.noise(0, 0, v39 + noiseOffset * 0.7) * 10;
                local v43 = v.pos.X - X;
                local v44 = v.pos.Y - Y;
                local v45 = v.pos.Z - Z;

                if math.abs(v43) > v35 * 0.75 then
                    v40 = v40 - math.sign(v43) * 10;
                end;

                if math.abs(v44) > v36 * 0.75 then
                    v41 = v41 - math.sign(v44) * 10;
                end;

                if math.abs(v45) > v37 * 0.75 then
                    v42 = v42 - math.sign(v45) * 10;
                end;

                local v46 = v.vel + Vector3.new(v40, v41, v42) * v38;

                if v46.Magnitude > 7 then
                    v46 = v46.Unit * 7;
                end;

                v.vel = v46;
                local v47 = v.pos + v46 * v38;
                local v48 = math.clamp(v47.X, X - v35, X + v35);
                local v49 = math.clamp(v47.Y, Y - v36, Y + v36);
                local v50 = math.clamp(v47.Z, Z - v37, Z + v37);
                v.pos = Vector3.new(v48, v49, v50);

                if v46.Magnitude > 0.1 then
                    local v51 = v46.Unit:Dot(Vector3.new(0, 1, 0));
                    local v52 = math.abs(v51) > 0.98 and Vector3.new(0, 0, 1) or Vector3.new(0, 1, 0);
                    v.model:PivotTo(CFrame.lookAt(v.pos, v.pos + v46.Unit, v52));
                end;
            end;
        end;
    end;

    local Position = p34.CFrame.Position;
    local v53 = {};

    for _, v in Players:GetPlayers() do
        local v54 = p30.playerCrabs[v.UserId];

        if v54 then
            local v55 = v.Character and v55:FindFirstChild("HumanoidRootPart");

            if v55 and (v55.Position - Position).Magnitude <= 150 then
                table.insert(v53, {
                    crabs = v54,
                    root = v55,
                    dist = (v55.Position - Position).Magnitude
                });
            else
                for _, v2 in v54 do
                    if v2.model and v2.model.Parent then
                        v2.model:PivotTo(CFrame.new(0, -10000, 0));
                    end;
                end;
            end;
        end;
    end;

    table.sort(v53, function(p56, p57) -- Line: 300
        return p56.dist < p57.dist;
    end);
    local v58 = 0;

    for _, v in v53 do
        if v58 + 8 > 50 then
            for _, v2 in v.crabs do
                if v2.model and v2.model.Parent then
                    v2.model:PivotTo(CFrame.new(0, -10000, 0));
                end;
            end;
        else
            v58 = v58 + 8;
            local Position2 = v.root.Position;

            for _, v2 in v.crabs do
                if v2.model and v2.model.Parent then
                    local v59 = v2.baseAngle + p31 * 0.3;
                    local v60 = math.sin(p31 * 14.66 + v2.phaseOffset);
                    local v61 = math.abs(v60) * 1;
                    local v62 = math.sin(p31 * 14.66 * 0.5 + v2.phaseOffset) * 0.12;
                    local v63 = Position2.X + math.cos(v59) * 10;
                    local v64 = Position2.Z + math.sin(v59) * 10;
                    v2.model:PivotTo(CFrame.new(v63, Position2.Y + v61, v64) * CFrame.Angles(0, v59 + 3.141592653589793, 0) * CFrame.Angles(v62, 0, v62 * 0.5));
                end;
            end;
        end;
    end;
end;

function v1.OnStop(p65, p66) -- Line: 332
    -- upvalues: GravityManager (copy), LightingSnapshot (copy)
    GravityManager.release("Water");
    LightingSnapshot.releaseShared();
end;

return v1;