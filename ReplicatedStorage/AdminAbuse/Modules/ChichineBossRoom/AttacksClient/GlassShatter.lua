-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.ChichineBossRoom.AttacksClient.GlassShatter
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local OrbController = require(ReplicatedStorage.AdminAbuse.Modules.Shared.OrbController);
local ClientDebris = require(script.Parent.ClientDebris);
local u1 = {};
local u2 = nil;
local u3 = nil;

local function getPortalTemplate() -- Line: 16
    -- upvalues: u3 (ref), ReplicatedStorage (copy)
    if u3 and u3.Parent then
        return u3;
    end;

    local v4 = ReplicatedStorage:FindFirstChild("AdminAbuse") and v4:FindFirstChild("ChichineBossRoom") and v4:FindFirstChild("VFX");

    if not v4 then
        warn("[GlassShatterClient] ReplicatedStorage.AdminAbuse.ChichineBossRoom.VFX not found");

        return nil;
    end;

    local Portal = v4:FindFirstChild("Portal");

    if not Portal then
        local v5 = v4:GetChildren();

        if #v5 == 0 then
            warn("[GlassShatterClient] ChichineBossRoom.VFX is empty — no portal asset");

            return nil;
        end;

        Portal = v5[1];
    end;

    u3 = Portal;

    return Portal;
end;

local function getPartsOf(p6) -- Line: 41
    local v7 = {};

    if p6:IsA("Model") then
        for _, descendant in p6:GetDescendants() do
            if descendant:IsA("BasePart") then
                table.insert(v7, descendant);
            end;
        end;

        return v7;
    end;

    if p6:IsA("BasePart") then
        table.insert(v7, p6);
    end;

    return v7;
end;

local function getOrbController() -- Line: 55
    -- upvalues: u2 (ref), ReplicatedStorage (copy), OrbController (copy), ClientDebris (copy)
    if u2 then
        return u2;
    end;

    local AdminAbuse = ReplicatedStorage:WaitForChild("AdminAbuse", 10);

    if not AdminAbuse then
        return nil;
    end;

    local Remotes = AdminAbuse:WaitForChild("Remotes", 10);

    if not Remotes then
        return nil;
    end;

    local ChichineOrbCollected = Remotes:FindFirstChild("ChichineOrbCollected");

    if not (ChichineOrbCollected and ChichineOrbCollected:IsA("RemoteEvent")) then
        warn("[GlassShatterClient] ChichineOrbCollected remote not found");

        return nil;
    end;

    local ChichineGiantOrbCollected = Remotes:FindFirstChild("ChichineGiantOrbCollected");
    local new = OrbController.new;
    local v8 = {};

    if not (ChichineGiantOrbCollected and (ChichineGiantOrbCollected:IsA("RemoteEvent") and ChichineGiantOrbCollected)) then
        ChichineGiantOrbCollected = nil;
    end;

    v8.giantOrbRemote = ChichineGiantOrbCollected;
    v8.parent = ClientDebris();
    u2 = new(ChichineOrbCollected, v8);

    return u2;
end;

local function closeSingle(p9) -- Line: 80
    -- upvalues: u1 (copy)
    local u10 = u1[p9];

    if not u10 then
        return;
    end;

    u1[p9] = nil;
    pcall(function() -- Line: 84
        -- upvalues: u10 (copy)
        u10:Destroy();
    end);
end;

return {
    open = function(p11) -- Line: 91, Name: open
        -- upvalues: getPortalTemplate (copy), getPartsOf (copy), ClientDebris (copy), u1 (copy), TweenService (copy), getOrbController (copy)
        local u12 = p11.id or 1;
        local u13 = p11.x or 0;
        local u14 = p11.y or 0;
        local u15 = p11.z or 0;
        local u16 = p11.orbCount or 1;
        local v17 = print;
        local v18 = tostring(u12);
        local v19 = math.round(u13);
        local v20 = tostring(v19);
        local v21 = math.round(u14);
        local v22 = tostring(v21);
        local v23 = math.round(u15);
        v17("[GlassShatterClient] open id=" .. v18 .. " pos=(" .. v20 .. "," .. v22 .. "," .. tostring(v23) .. ")");
        local u24 = getPortalTemplate();

        if not u24 then
            print("[GlassShatterClient] open: no template found, aborting");

            return;
        end;

        local success, result = pcall(function() -- Line: 105
            -- upvalues: u24 (copy)
            return u24:Clone();
        end);

        if not (success and result) then
            print("[GlassShatterClient] open: clone failed: " .. tostring(result));

            return;
        end;

        local v25 = getPartsOf(result);
        local v26 = table.create(#v25);

        for i, v in v25 do
            v26[i] = v.Transparency;
            v.Transparency = 1;
            v.Anchored = true;
            v.CanCollide = false;
            v.CanQuery = false;
            v.CanTouch = false;
        end;

        if result:IsA("Model") then
            result:PivotTo(CFrame.new(u13, u14, u15));
        elseif result:IsA("BasePart") then
            result.CFrame = CFrame.new(u13, u14, u15) * CFrame.Angles(math.random(90, 300), math.random(90, 300), 0);
        end;

        result.Parent = ClientDebris();
        u1[u12] = result;

        for i, v in v25 do
            TweenService:Create(v, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Transparency = v26[i]
            }):Play();
        end;

        local lifetime = p11.lifetime;

        if lifetime and lifetime > 0 then
            task.delay(lifetime, function() -- Line: 144
                -- upvalues: u12 (copy), u1 (ref)
                local v27 = u12;
                local u28 = u1[v27];

                if not u28 then
                    return;
                end;

                u1[v27] = nil;
                pcall(function() -- Line: 84
                    -- upvalues: u28 (copy)
                    u28:Destroy();
                end);
            end);
        end;

        task.delay(0.5, function() -- Line: 150
            -- upvalues: result (copy), getOrbController (ref), u13 (copy), u14 (copy), u15 (copy), u16 (copy)
            if not (result and result.Parent) then
                return;
            end;

            local v29 = getOrbController();

            if v29 then
                v29:spawnOrbs({ (Vector3.new(u13, u14 + 1, u15)) }, u16);
            end;
        end);
    end,

    closeAll = function() -- Line: 159, Name: closeAll
        -- upvalues: u1 (copy), getPartsOf (copy), TweenService (copy)
        for i, v in u1 do
            u1[i] = nil;

            if v and v.Parent then
                for _, v2 in getPartsOf(v) do
                    TweenService:Create(v2, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Transparency = 1
                    }):Play();
                end;

                task.delay(0.5, function() -- Line: 170
                    -- upvalues: v (copy)
                    pcall(function() -- Line: 171
                        -- upvalues: v (ref)
                        v:Destroy();
                    end);
                end);
            end;
        end;

        table.clear(u1);
    end,

    cleanup = function() -- Line: 179, Name: cleanup
        -- upvalues: u1 (copy), u2 (ref)
        for _, v in u1 do
            pcall(function() -- Line: 181
                -- upvalues: v (copy)
                v:Destroy();
            end);
        end;

        table.clear(u1);

        if u2 then
            u2:destroy();
            u2 = nil;
        end;
    end,

    scan = function(p30) -- Line: 192, Name: scan
        -- upvalues: getOrbController (copy)
        local v31 = getOrbController();

        if v31 then
            v31:scan(p30);
        end;
    end,

    spawnFromZone = function(p32) -- Line: 198, Name: spawnFromZone
        -- upvalues: getOrbController (copy)
        local v33 = getOrbController();

        if v33 then
            v33:spawnFromZone(p32);
        end;
    end,

    spawnGiantFromZone = function(p34) -- Line: 204, Name: spawnGiantFromZone
        -- upvalues: getOrbController (copy)
        local v35 = getOrbController();

        if v35 then
            v35:spawnGiantFromZone(p34);
        end;
    end
};