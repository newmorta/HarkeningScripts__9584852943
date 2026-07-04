-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.OverdriveBossRoom.OverdriveOrbController
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = ReplicatedStorage:WaitForChild("AdminAbuse"):WaitForChild("OverdriveBossRoom"):WaitForChild("Assets");
local OverdriveRemotes = require(ReplicatedStorage.AdminAbuse.Modules.OverdriveBossRoom.OverdriveRemotes);
local OverdriveConfig = require(ReplicatedStorage.AdminAbuse.Modules.OverdriveBossRoom.OverdriveConfig);
local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 18
    -- upvalues: u1 (copy), Players (copy), OverdriveRemotes (copy)
    local v2 = setmetatable({}, u1);
    v2._winsSpawnZone = nil;
    v2._player = Players.LocalPlayer;
    v2._activeOrbs = {};
    v2._orbCollectedRemote = OverdriveRemotes.OverdriveOrbCollected;

    return v2;
end;

function u1.isScanned(p3) -- Line: 28
    return p3._winsSpawnZone ~= nil;
end;

function u1.scan(p4, p5) -- Line: 32
    local v6 = p5:FindFirstChild("Scriptables") and v6:FindFirstChild("Zones") and v6:FindFirstChild("WinsSpawnZone");

    if not (v6 and v6:IsA("BasePart")) then
        warn("[OverdriveOrbController] Missing BasePart \'WinsSpawnZone\' in mapClone.Scriptables.Zones");

        return;
    end;

    p4._winsSpawnZone = v6;
    print("[TixOrb] scan() OK — WinsSpawnZone found at", v6.Position);
end;

function u1.spawnOrbs(u7, p8) -- Line: 46
    -- upvalues: Assets (copy), OverdriveRemotes (copy), OverdriveConfig (copy)
    if not u7._winsSpawnZone or p8 <= 0 then
        return;
    end;

    local TixCollectibleOrb = Assets:FindFirstChild("TixCollectibleOrb");

    if not (TixCollectibleOrb and TixCollectibleOrb:IsA("Model")) then
        warn("[OverdriveOrbController] TixCollectibleOrb not found in ReplicatedStorage.AdminAbuse.OverdriveBossRoom.Assets");

        return;
    end;

    local _winsSpawnZone = u7._winsSpawnZone;
    local CFrame2 = _winsSpawnZone.CFrame;
    local v9 = _winsSpawnZone.Size / 2;
    print(string.format("[TixOrb] spawnOrbs(%d) called. Zone=%s", p8, _winsSpawnZone.Name));

    for _ = 1, p8 do
        local u10 = TixCollectibleOrb:Clone();
        local PrimaryPart = u10.PrimaryPart;

        if PrimaryPart then
            u10:PivotTo(CFrame2 * CFrame.new((math.random() * 2 - 1) * v9.X, (math.random() * 2 - 1) * v9.Y, (math.random() * 2 - 1) * v9.Z));

            for _, descendant in u10:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = false;
                    descendant.CanCollide = false;
                end;
            end;

            PrimaryPart.CanCollide = true;
            u10.Parent = workspace;
            table.insert(u7._activeOrbs, u10);
            local u11 = false;
            local u12 = nil;
            u12 = PrimaryPart.Touched:Connect(function(p13) -- Line: 89
                -- upvalues: u7 (copy), u11 (ref), u12 (ref), u10 (copy), OverdriveRemotes (ref)
                local Character = u7._player.Character;

                if not (Character and p13:IsDescendantOf(Character)) then
                    return;
                end;

                if u11 then
                    return;
                end;

                u11 = true;
                u12:Disconnect();
                local v14 = table.find(u7._activeOrbs, u10);

                if v14 then
                    table.remove(u7._activeOrbs, v14);
                end;

                u10:Destroy();
                OverdriveRemotes.OverdriveOrbCollected:fire();
            end);
            task.delay(OverdriveConfig.TixOrbDespawnSec, function() -- Line: 104
                -- upvalues: u11 (ref), u12 (ref), u7 (copy), u10 (copy)
                if u11 then
                    return;
                end;

                u11 = true;
                u12:Disconnect();
                local v15 = table.find(u7._activeOrbs, u10);

                if v15 then
                    table.remove(u7._activeOrbs, v15);
                end;

                if u10 and u10.Parent then
                    u10:Destroy();
                end;
            end);
        else
            warn("[OverdriveOrbController] TixCollectibleOrb has no PrimaryPart");
            u10:Destroy();
        end;
    end;
end;

function u1.destroy(p16) -- Line: 116
    for _, v in p16._activeOrbs do
        if v and v.Parent then
            v:Destroy();
        end;
    end;

    table.clear(p16._activeOrbs);
    p16._winsSpawnZone = nil;
end;

return u1;