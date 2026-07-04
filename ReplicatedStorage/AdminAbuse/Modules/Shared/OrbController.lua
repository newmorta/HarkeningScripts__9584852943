-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.Shared.OrbController
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = {};
u1.__index = u1;

function u1.new(p2, p3) -- Line: 62
    -- upvalues: u1 (copy), Players (copy)
    local v4 = p3 or {};
    local v5 = setmetatable({}, u1);
    v5._remote = p2;
    v5._giantOrbRemote = v4.giantOrbRemote or nil;
    v5._activeOrbs = {};
    v5._player = Players.LocalPlayer;
    v5._despawnSec = v4.despawnSec or 60;
    v5._parent = v4.parent or workspace;
    v5._orbSpawnZone = nil;
    v5._amountByPhase = v4.amountByPhase or {};
    v5._timelineCues = v4.timelineCues or {};

    return v5;
end;

function u1.scan(p6, p7) -- Line: 79
    local v8 = p7:FindFirstChild("Scriptables") and v8:FindFirstChild("Zones") and v8:FindFirstChild("OrbsSpawn");

    if v8 and v8:IsA("BasePart") then
        p6._orbSpawnZone = v8;

        return;
    end;

    warn("[OrbController] OrbsSpawn BasePart not found at mapClone.Scriptables.Zones.OrbsSpawn");
end;

function u1.isScanned(p9) -- Line: 91
    return p9._orbSpawnZone ~= nil;
end;

function u1.getAmountForPhase(p10, p11) -- Line: 97
    return p10._amountByPhase[p11] or 0;
end;

function u1.getAmountForTimeline(p12, p13) -- Line: 101
    local v14 = 0;

    for _, v in p12._timelineCues do
        if v.Time > p13 then
            break;
        end;

        v14 = v.Amount;
    end;

    return v14;
end;

function u1._spawnOne(u15, p16, p17, p18) -- Line: 117
    local v19 = p17:Clone();
    local v20 = nil;
    local u21;

    if v19:IsA("Model") then
        v19:PivotTo(CFrame.new(p16));

        for _, descendant in v19:GetDescendants() do
            if descendant:IsA("BasePart") then
                if p18 then
                    descendant.Size = descendant.Size * 5;
                end;

                descendant.Anchored = false;
                descendant.CanCollide = false;
            end;
        end;

        local PrimaryPart = v19.PrimaryPart;

        if PrimaryPart then
            PrimaryPart.CanCollide = true;
            u21 = v19;
            v19 = PrimaryPart;
        else
            u21 = v19;
            v19 = PrimaryPart;
        end;
    elseif v19:IsA("BasePart") then
        if p18 then
            v19.Size = v19.Size * 5;
        end;

        v19.CFrame = CFrame.new(p16);
        v19.Anchored = false;
        v19.CanCollide = true;
        u21 = v19;
    else
        u21 = v19;
        v19 = v20;
    end;

    if not v19 then
        u21:Destroy();

        return;
    end;

    u21.Parent = u15._parent;
    table.insert(u15._activeOrbs, u21);
    local u22 = false;
    local _remote = u15._remote;
    local u23;

    if p18 then
        u23 = u15._giantOrbRemote or nil;
    else
        u23 = nil;
    end;

    local _player = u15._player;
    local _despawnSec = u15._despawnSec;
    local u24 = nil;
    u24 = v19.Touched:Connect(function(p25) -- Line: 161
        -- upvalues: _player (copy), u22 (ref), u24 (ref), u15 (copy), u21 (copy), u23 (copy), _remote (copy)
        local Character = _player.Character;

        if not (Character and p25:IsDescendantOf(Character)) then
            return;
        end;

        if u22 then
            return;
        end;

        u22 = true;
        u24:Disconnect();
        local v26 = table.find(u15._activeOrbs, u21);

        if v26 then
            table.remove(u15._activeOrbs, v26);
        end;

        u21:Destroy();

        if u23 then
            u23:FireServer();

            return;
        end;

        _remote:FireServer();
    end);
    task.delay(_despawnSec, function() -- Line: 179
        -- upvalues: u22 (ref), u24 (ref), u15 (copy), u21 (copy)
        if u22 then
            return;
        end;

        u22 = true;
        u24:Disconnect();
        local v27 = table.find(u15._activeOrbs, u21);

        if v27 then
            table.remove(u15._activeOrbs, v27);
        end;

        if u21 and u21.Parent then
            u21:Destroy();
        end;
    end);
end;

function u1.spawnOrbs(p28, p29, p30) -- Line: 191
    -- upvalues: ReplicatedStorage (copy)
    local v31 = ReplicatedStorage:FindFirstChild("AdminAbuse") and v31:FindFirstChild("CollectibleOrb");

    if v31 then
        for _, v in p29 do
            for _ = 1, p30 do
                local v32 = (math.random() * 2 - 1) * 3;
                local v33 = math.random() * 1.5 + 0.5;
                local v34 = (math.random() * 2 - 1) * 3;
                p28:_spawnOne(v + Vector3.new(v32, v33, v34), v31);
            end;
        end;

        return;
    end;

    warn("[OrbController] CollectibleOrb not found in ReplicatedStorage.AdminAbuse");
end;

function u1.spawnFromZone(p35, p36) -- Line: 212
    -- upvalues: ReplicatedStorage (copy)
    if not p35._orbSpawnZone then
        warn("[OrbController] spawnFromZone called before scan() — no OrbsSpawn zone");

        return;
    end;

    if p36 <= 0 then
        return;
    end;

    local v37 = ReplicatedStorage:FindFirstChild("AdminAbuse") and v37:FindFirstChild("CollectibleOrb");

    if not v37 then
        warn("[OrbController] CollectibleOrb not found in ReplicatedStorage.AdminAbuse");

        return;
    end;

    local _orbSpawnZone = p35._orbSpawnZone;
    local v38 = _orbSpawnZone.Size.X * 0.5;
    local v39 = _orbSpawnZone.Size.Y * 0.5;
    local v40 = _orbSpawnZone.Size.Z * 0.5;

    for _ = 1, p36 do
        local v41 = (math.random() * 2 - 1) * v38;
        local v42 = (math.random() * 2 - 1) * v39;
        local v43 = (math.random() * 2 - 1) * v40;
        p35:_spawnOne(_orbSpawnZone.CFrame:PointToWorldSpace((Vector3.new(v41, v42, v43))), v37);
    end;
end;

function u1.spawnForPhase(p44, p45) -- Line: 241
    local v46 = p44:getAmountForPhase(p45);

    if v46 <= 0 then
        return;
    end;

    p44:spawnFromZone(v46);
end;

function u1.spawnGiantOrbs(p47, p48, p49) -- Line: 248
    -- upvalues: ReplicatedStorage (copy)
    local v50 = ReplicatedStorage:FindFirstChild("AdminAbuse") and v50:FindFirstChild("BigCollectibleOrb");

    if v50 then
        for _, v in p48 do
            for _ = 1, p49 do
                local v51 = (math.random() * 2 - 1) * 3;
                local v52 = math.random() * 1.5 + 0.5;
                local v53 = (math.random() * 2 - 1) * 3;
                p47:_spawnOne(v + Vector3.new(v51, v52, v53), v50, true);
            end;
        end;

        return;
    end;

    warn("[OrbController] CollectibleOrb not found in ReplicatedStorage.AdminAbuse");
end;

function u1.spawnGiantFromZone(p54, p55) -- Line: 269
    -- upvalues: ReplicatedStorage (copy)
    if not p54._orbSpawnZone then
        warn("[OrbController] spawnGiantFromZone called before scan() — no OrbsSpawn zone");

        return;
    end;

    if p55 <= 0 then
        return;
    end;

    local v56 = ReplicatedStorage:FindFirstChild("AdminAbuse") and v56:FindFirstChild("CollectibleOrb");

    if not v56 then
        warn("[OrbController] CollectibleOrb not found in ReplicatedStorage.AdminAbuse");

        return;
    end;

    local _orbSpawnZone = p54._orbSpawnZone;

    for _ = 1, p55 do
        local v57 = math.random() * 2 - 1;
        local v58 = math.random() * 2 - 1;
        local v59 = math.random() * 2 - 1;
        p54:_spawnOne(_orbSpawnZone.CFrame:PointToWorldSpace((Vector3.new(v57, v58, v59))), v56, true);
    end;
end;

function u1.destroy(p60) -- Line: 299
    for _, v in p60._activeOrbs do
        if v and v.Parent then
            pcall(function() -- Line: 302
                -- upvalues: v (copy)
                v:Destroy();
            end);
        end;
    end;

    table.clear(p60._activeOrbs);
    p60._orbSpawnZone = nil;
end;

return u1;