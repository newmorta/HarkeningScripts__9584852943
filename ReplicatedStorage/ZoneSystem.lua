-- Ruta Original: ReplicatedStorage.ZoneSystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local Signal = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("Signal"));
local u1 = {
    TAG = "Zone",
    ID_ATTRIBUTE = "ZoneId"
};

function u1.GetZoneId(p2) -- Line: 53
    -- upvalues: u1 (copy)
    return p2:GetAttribute(u1.ID_ATTRIBUTE);
end;

function u1.GetZonesById(p3, p4) -- Line: 58
    -- upvalues: u1 (copy)
    local v5 = {};

    for _, v in ipairs(u1.GetZones()) do
        if v:GetAttribute(p4 or u1.ID_ATTRIBUTE) == p3 then
            table.insert(v5, v);
        end;
    end;

    return v5;
end;

function u1.GetSafeZonesById(p6) -- Line: 68
    -- upvalues: u1 (copy)
    local v7 = {};

    for _, v in ipairs(u1.GetZones()) do
        if v:GetAttribute(u1.ID_ATTRIBUTE) == p6 and v:GetAttribute("SafeZone") == true then
            table.insert(v7, v);
        end;
    end;

    return v7;
end;

function u1.GetSafeZones() -- Line: 79
    -- upvalues: u1 (copy)
    return u1.GetZonesById(true, "SafeZone");
end;

function u1.GetSASZones() -- Line: 83
    -- upvalues: u1 (copy)
    local v8 = {};

    for _, v in ipairs(u1.GetZones()) do
        if v:GetAttribute(u1.ID_ATTRIBUTE) == "SAS" and typeof(v:GetAttribute("SAS")) == "number" then
            table.insert(v8, v);
        end;
    end;

    return v8;
end;

function u1.GetSASZoneById(p9) -- Line: 93
    -- upvalues: u1 (copy)
    for _, v in ipairs(u1.GetZones()) do
        if v:GetAttribute(u1.ID_ATTRIBUTE) == "SAS" and v:GetAttribute("SAS") == p9 then
            return v;
        end;
    end;

    return nil;
end;

function u1.GetTaggedParts(p10) -- Line: 109
    -- upvalues: CollectionService (copy)
    local v11 = {};

    for _, v in ipairs(CollectionService:GetTagged(p10)) do
        if v:IsA("BasePart") then
            table.insert(v11, v);
        end;
    end;

    return v11;
end;

function u1.GetZones() -- Line: 120
    -- upvalues: u1 (copy)
    return u1.GetTaggedParts(u1.TAG);
end;

local function pointInZone(p12, p13) -- Line: 125
    local v14 = p12.CFrame:PointToObjectSpace(p13);
    local v15 = p12.Size * 0.5;
    local v16;

    if math.abs(v14.X) <= v15.X and math.abs(v14.Y) <= v15.Y then
        v16 = math.abs(v14.Z) <= v15.Z;
    else
        v16 = false;
    end;

    return v16;
end;

function u1.GetZoneAt(p17, p18) -- Line: 136
    -- upvalues: u1 (copy)
    local v19 = p18 or u1.GetZones();
    local Position = p17.Position;

    for _, v in ipairs(v19) do
        local v20 = v.CFrame:PointToObjectSpace(Position);
        local v21 = v.Size * 0.5;
        local v22;

        if math.abs(v20.X) <= v21.X and math.abs(v20.Y) <= v21.Y then
            v22 = math.abs(v20.Z) <= v21.Z;
        else
            v22 = false;
        end;

        if v22 then
            return v;
        end;
    end;

    return nil;
end;

function u1.CreateTracker(u23, p24) -- Line: 155
    -- upvalues: Signal (copy), RunService (copy), u1 (copy), Players (copy)
    local u25 = p24 or 0.1;
    local u26 = {
        Entered = Signal.new(),
        Exited = Signal.new()
    };
    local u27 = {};
    local u28 = 0;

    local function setZone(p29, p30) -- Line: 167
        -- upvalues: u27 (copy), u26 (copy)
        local UserId = p29.UserId;
        local v31 = u27[UserId];

        if p30 == v31 then
            return;
        end;

        if v31 then
            u26.Exited:Fire(p29, v31, v31:GetAttributes());
        end;

        if p30 then
            u26.Entered:Fire(p29, p30, p30:GetAttributes());
        end;

        u27[UserId] = p30;
    end;

    local u37 = RunService.Heartbeat:Connect(function(p32) -- Line: 181
        -- upvalues: u28 (ref), u25 (ref), u1 (ref), u23 (copy), setZone (copy), u27 (copy), Players (ref), u26 (copy)
        u28 = u28 + p32;

        if u28 < u25 then
            return;
        end;

        u28 = 0;
        local v33 = u1.GetZones();
        local v34 = {};

        for _, v in ipairs(u23()) do
            local player = v.player;

            if player then
                v34[player.UserId] = true;
                local hrp = v.hrp;
                local v35;

                if hrp then
                    v35 = u1.GetZoneAt(hrp, v33) or nil;
                else
                    v35 = nil;
                end;

                setZone(player, v35);
            end;
        end;

        for i, v in pairs(u27) do
            if not v34[i] then
                local v36 = Players:GetPlayerByUserId(i);

                if v36 then
                    u26.Exited:Fire(v36, v, v:GetAttributes());
                end;

                u27[i] = nil;
            end;
        end;
    end);

    function u26.GetZone(p38, p39) -- Line: 211
        -- upvalues: u27 (copy)
        return u27[p39.UserId];
    end;

    function u26.Stop(p40) -- Line: 215
        -- upvalues: u37 (copy), u26 (copy), u27 (copy)
        u37:Disconnect();
        u26.Entered:Destroy();
        u26.Exited:Destroy();
        table.clear(u27);
    end;

    return u26;
end;

local function entryFor(p41) -- Line: 237
    local Character = p41.Character;
    local v42;

    if Character then
        v42 = Character:FindFirstChildOfClass("Humanoid");
    else
        v42 = Character;
    end;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    return Character and (v42 and v42.Health > 0) and {
        player = p41,
        hrp = Character
    } or {
        player = p41
    };
end;

local u43;

if RunService:IsClient() then
    local LocalPlayer = Players.LocalPlayer;
    u43 = u1.CreateTracker(function() -- Line: 250
        -- upvalues: entryFor (copy), LocalPlayer (copy)
        return { (entryFor(LocalPlayer)) };
    end);
else
    u43 = u1.CreateTracker(function() -- Line: 254
        -- upvalues: Players (copy), entryFor (copy)
        local v44 = {};

        for _, v in ipairs(Players:GetPlayers()) do
            local v45 = entryFor(v);
            table.insert(v44, v45);
        end;

        return v44;
    end);
end;

u1.entered = u43.Entered;
u1.exited = u43.Exited;
u1.tracker = u43;

local function filteredById(u46, u47) -- Line: 271
    -- upvalues: u1 (copy)
    local function wrap(u48) -- Line: 272
        -- upvalues: u46 (copy), u1 (ref), u47 (copy)
        return function(p49, u50) -- Line: 273
            -- upvalues: u46 (ref), u48 (copy), u1 (ref), u47 (ref)
            return u46[u48](u46, function(p51, p52, p53) -- Line: 274
                -- upvalues: u1 (ref), u47 (ref), u50 (copy)
                if p53[u1.ID_ATTRIBUTE] == u47 then
                    u50(p51, p52, p53);
                end;
            end);
        end;
    end;

    local v54 = {};
    local u55 = "Connect";

    function v54.Connect(p56, u57) -- Line: 273
        -- upvalues: u46 (copy), u55 (copy), u1 (ref), u47 (copy)
        return u46[u55](u46, function(p58, p59, p60) -- Line: 274
            -- upvalues: u1 (ref), u47 (ref), u57 (copy)
            if p60[u1.ID_ATTRIBUTE] == u47 then
                u57(p58, p59, p60);
            end;
        end);
    end;

    local u61 = "Once";

    function v54.Once(p62, u63) -- Line: 273
        -- upvalues: u46 (copy), u61 (copy), u1 (ref), u47 (copy)
        return u46[u61](u46, function(p64, p65, p66) -- Line: 274
            -- upvalues: u1 (ref), u47 (ref), u63 (copy)
            if p66[u1.ID_ATTRIBUTE] == u47 then
                u63(p64, p65, p66);
            end;
        end);
    end;

    return v54;
end;

function u1.EnteredId(p67) -- Line: 285
    -- upvalues: filteredById (copy), u43 (ref)
    return filteredById(u43.Entered, p67);
end;

function u1.ExitedId(p68) -- Line: 289
    -- upvalues: filteredById (copy), u43 (ref)
    return filteredById(u43.Exited, p68);
end;

function u1.GetCurrentZone(p69) -- Line: 294
    -- upvalues: u43 (ref)
    return u43:GetZone(p69);
end;

return u1;