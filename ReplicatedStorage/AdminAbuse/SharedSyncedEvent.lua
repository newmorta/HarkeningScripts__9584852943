-- Ruta Original: ReplicatedStorage.AdminAbuse.SharedSyncedEvent
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = { "AdminAbuse", "Remotes", "SSE" };

local function getOrCreateSseFolder() -- Line: 35
    -- upvalues: ReplicatedStorage (copy), u1 (copy)
    local v2 = ReplicatedStorage;

    for _, v in u1 do
        local v3 = v2:FindFirstChild(v);

        if not v3 then
            v3 = Instance.new("Folder");
            v3.Name = v;
            v3.Parent = v2;
        end;

        v2 = v3;
    end;

    return v2;
end;

local function waitForSseFolder() -- Line: 50
    -- upvalues: ReplicatedStorage (copy), u1 (copy)
    local v4 = ReplicatedStorage;

    for _, v in u1 do
        v4 = v4:WaitForChild(v, 15);

        if not v4 then
            warn("[SharedSyncedEvent] Dossier SSE introuvable dans le chemin:", v);

            return nil;
        end;
    end;

    return v4;
end;

local function createRemote(p5) -- Line: 63
    -- upvalues: getOrCreateSseFolder (copy)
    local v6 = getOrCreateSseFolder();
    local v7 = v6:FindFirstChild(p5);

    if v7 and v7:IsA("RemoteEvent") then
        return v7;
    end;

    local RemoteEvent = Instance.new("RemoteEvent");
    RemoteEvent.Name = p5;
    RemoteEvent.Parent = v6;

    return RemoteEvent;
end;

local function waitForRemote(p8) -- Line: 75
    -- upvalues: waitForSseFolder (copy)
    local v9 = waitForSseFolder();

    if not v9 then
        return nil;
    end;

    local v10 = v9:WaitForChild(p8, 15);

    if v10 and v10:IsA("RemoteEvent") then
        return v10;
    end;

    warn("[SharedSyncedEvent] Remote \'", p8, "\' introuvable après", 15, "s");

    return nil;
end;

local u11 = {};
u11.__index = u11;

function u11.set(p12, p13, p14) -- Line: 92
    p12._snapshot[p13] = p14;
    p12._dirty[p13] = true;
    p12._hasDirty = true;
end;

function u11.fire(p15, p16, p17) -- Line: 99
    local v18 = p15._eventQueue[p16];

    if not v18 then
        v18 = {};
        p15._eventQueue[p16] = v18;
    end;

    table.insert(v18, p17);
    p15._hasEvents = true;
end;

function u11.get(p19, p20) -- Line: 110
    return p19._snapshot[p20];
end;

function u11.syncTo(u21, u22) -- Line: 115
    if not next(u21._snapshot) then
        return;
    end;

    local _remote = u21._remote;

    if not _remote then
        return;
    end;

    pcall(function() -- Line: 119
        -- upvalues: _remote (copy), u22 (copy), u21 (copy)
        _remote:FireClient(u22, {
            d = u21._snapshot
        });
    end);
end;

function u11._flush(p23) -- Line: 124
    if not (p23._hasDirty or p23._hasEvents) then
        return;
    end;

    local v24 = {};

    if p23._hasDirty then
        p23._hasDirty = false;
        local v25 = {};

        for i, _ in pairs(p23._dirty) do
            v25[i] = p23._snapshot[i];
        end;

        p23._dirty = {};

        if next(v25) then
            v24.d = v25;
        end;
    end;

    if p23._hasEvents then
        p23._hasEvents = false;
        v24.e = p23._eventQueue;
        p23._eventQueue = {};
    end;

    local _remote = p23._remote;

    if _remote and next(v24) then
        _remote:FireAllClients(v24);
    end;
end;

function u11.onChange(p26, p27, p28) -- Line: 152
    if not p26._onChange[p27] then
        p26._onChange[p27] = {};
    end;

    table.insert(p26._onChange[p27], p28);
end;

function u11.onFire(p29, p30, p31) -- Line: 158
    if not p29._onFire[p30] then
        p29._onFire[p30] = {};
    end;

    table.insert(p29._onFire[p30], p31);
end;

function u11.off(p32, p33) -- Line: 164
    p32._onChange[p33] = nil;
    p32._onFire[p33] = nil;
end;

function u11._applyPacket(p34, p35) -- Line: 169
    if type(p35) ~= "table" then
        return;
    end;

    if type(p35.d) == "table" then
        for i, v in pairs(p35.d) do
            p34._snapshot[i] = v;
            local v36 = p34._onChange[i];

            if v36 then
                for _, v2 in ipairs(v36) do
                    v2(v);
                end;
            end;
        end;
    end;

    if type(p35.e) == "table" then
        for i, v in pairs(p35.e) do
            local v37 = p34._onFire[i];

            if v37 then
                for _, v2 in ipairs(v) do
                    for _, v3 in ipairs(v37) do
                        v3(v2);
                    end;
                end;
            end;
        end;
    end;
end;

function u11.destroy(p38) -- Line: 195
    local _flushConn = p38._flushConn;
    local _clientConn = p38._clientConn;
    p38._flushConn = nil;
    p38._clientConn = nil;

    if _flushConn then
        _flushConn:Disconnect();
    end;

    if _clientConn then
        _clientConn:Disconnect();
    end;

    local v39 = p38._isServer and p38._remote;

    if v39 then
        v39:Destroy();
    end;

    p38._remote = nil;
    p38._snapshot = {};
    p38._dirty = {};
    p38._eventQueue = {};
    p38._onChange = {};
    p38._onFire = {};
end;

function u11.new(p40, p41) -- Line: 220
    -- upvalues: RunService (copy), getOrCreateSseFolder (copy), waitForSseFolder (copy), u11 (copy)
    local v42 = RunService:IsServer();
    local v43 = (type(p41) ~= "number" or p41 <= 0) and 0.05 or 1 / p41;
    local v44;

    if v42 then
        local v45 = getOrCreateSseFolder();
        v44 = v45:FindFirstChild(p40);

        if not (v44 and v44:IsA("RemoteEvent")) then
            v44 = Instance.new("RemoteEvent");
            v44.Name = p40;
            v44.Parent = v45;
        end;
    else
        local v46 = waitForSseFolder();

        if v46 then
            v44 = v46:WaitForChild(p40, 15);

            if not (v44 and v44:IsA("RemoteEvent")) then
                warn("[SharedSyncedEvent] Remote \'", p40, "\' introuvable après", 15, "s");
                v44 = nil;
            end;
        else
            v44 = nil;
        end;
    end;

    if not v44 then
        error("[SharedSyncedEvent] Impossible d\'obtenir la remote \'" .. p40 .. "\'");
    end;

    local u47 = setmetatable({
        _flushAccum = 0,
        _hasDirty = false,
        _hasEvents = false,
        _flushConn = nil,
        _clientConn = nil,
        _remote = v44,
        _isServer = v42,
        _flushRate = v43,
        _snapshot = {},
        _dirty = {},
        _eventQueue = {},
        _onChange = {},
        _onFire = {}
    }, u11);

    if v42 then
        u47._flushConn = RunService.Heartbeat:Connect(function(p48) -- Line: 252
            -- upvalues: u47 (copy)
            local v49 = u47;
            v49._flushAccum = v49._flushAccum + p48;

            if u47._flushAccum < u47._flushRate then
                return;
            end;

            local v50 = u47;
            v50._flushAccum = v50._flushAccum - u47._flushRate;
            u47:_flush();
        end);

        return u47;
    end;

    u47._clientConn = v44.OnClientEvent:Connect(function(p51) -- Line: 260
        -- upvalues: u47 (copy)
        u47:_applyPacket(p51);
    end);

    return u47;
end;

return u11;