-- Ruta Original: ReplicatedStorage.Utilities.Events.ConcertOrbController
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ConcertSharedConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ConcertSharedConfig"));
local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 8
    -- upvalues: u1 (copy), Players (copy), ReplicatedStorage (copy)
    local u2 = setmetatable({}, u1);
    u2._winsSpawnPart = nil;
    u2._player = Players.LocalPlayer;
    u2._activeOrbs = {};
    task.spawn(function() -- Line: 14
        -- upvalues: ReplicatedStorage (ref), u2 (copy)
        u2._orbCollectedRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ConcertOrbCollected", 10);

        if not u2._orbCollectedRemote then
            warn("[ConcertOrbController] RemoteEvent \'ConcertOrbCollected\' not found in Remotes!");
        end;
    end);

    return u2;
end;

function u1.scan(p3, p4) -- Line: 25
    if not p4 then
        return;
    end;

    if p4.Parent and p4.Parent:IsA("Model") then
        p4 = p4.Parent;
    end;

    local v5 = nil;

    for _, descendant in ipairs(p4:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Name == "WinsSpawn" then
            v5 = descendant;
            break;
        end;
    end;

    if v5 then
        p3._winsSpawnPart = v5;

        return;
    end;

    warn("[ConcertOrbController] Missing part \'WinsSpawn\' in scene.");
end;

function u1.spawnOrbs(u6, p7) -- Line: 49
    -- upvalues: ReplicatedStorage (copy), ConcertSharedConfig (copy)
    if not u6._winsSpawnPart then
        return;
    end;

    if not p7 or p7 <= 0 then
        return;
    end;

    local CollectibleOrb = ReplicatedStorage:WaitForChild("AdminAbuse"):WaitForChild("CollectibleOrb", 5);

    if not CollectibleOrb then
        warn("[ConcertOrbController] CollectibleOrb template not found in ReplicatedStorage.AdminAbuse");

        return;
    end;

    local CFrame2 = u6._winsSpawnPart.CFrame;
    local v8 = u6._winsSpawnPart.Size / 2;

    for _ = 1, p7 do
        local u9 = CollectibleOrb:Clone();
        local v10 = (math.random() * 2 - 1) * v8.X;
        local v11 = (math.random() * 2 - 1) * v8.Y;
        local v12 = (math.random() * 2 - 1) * v8.Z;
        local v13 = Vector3.new(v10, v11, v12);
        u9.CFrame = CFrame2 * CFrame.new(v13);
        u9.Anchored = false;
        u9.CanCollide = true;
        local CurrentPhysicalProperties = u9.CurrentPhysicalProperties;
        u9.CustomPhysicalProperties = PhysicalProperties.new((not CurrentPhysicalProperties and 0.7 or CurrentPhysicalProperties.Density) * (ConcertSharedConfig.OrbMassMultiplier or 1), CurrentPhysicalProperties and (CurrentPhysicalProperties.Friction or 0.3) or 0.3, CurrentPhysicalProperties and (CurrentPhysicalProperties.Elasticity or 0.5) or 0.5, CurrentPhysicalProperties and (CurrentPhysicalProperties.FrictionWeight or 1) or 1, CurrentPhysicalProperties and CurrentPhysicalProperties.ElasticityWeight or 1);
        u9.Parent = game:GetService("Workspace");
        table.insert(u6._activeOrbs, u9);
        local u14 = false;
        local u15 = nil;
        u15 = u9.Touched:Connect(function(p16) -- Line: 100
            -- upvalues: u6 (copy), u14 (ref), u15 (ref), u9 (copy)
            local Character = u6._player.Character;

            if not Character then
                return;
            end;

            if p16:IsDescendantOf(Character) then
                if u14 then
                    return;
                end;

                u14 = true;
                u15:Disconnect();
                u9:Destroy();

                if u6._orbCollectedRemote then
                    u6._orbCollectedRemote:FireServer();
                end;
            end;
        end);
    end;
end;

function u1.destroy(p17) -- Line: 120
    for _, v in ipairs(p17._activeOrbs) do
        if v and v.Parent then
            v:Destroy();
        end;
    end;

    table.clear(p17._activeOrbs);
    p17._winsSpawnPart = nil;
end;

return u1;