-- Ruta Original: ReplicatedStorage.Utilities.DeferredMapLoader
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {};

local function YieldLoadWithBudget(p2, p3, u4, p5) -- Line: 3
    local u6 = p2:GetChildren();
    local u7, u8 = next(u6, nil);
    local u9 = p5 or {};
    local u10 = 0;

    local function ResetTimer() -- Line: 14
        -- upvalues: u10 (ref), u4 (copy)
        u10 = tick() + u4;
    end;

    local function MaybeYield() -- Line: 17
        -- upvalues: u10 (ref), u4 (copy)
        if u10 <= tick() then
            task.wait();
            u10 = tick() + u4;
        end;
    end;

    local function LoadAsset(p11, p12, p13) -- Line: 23
        -- upvalues: u9 (copy)
        local v14 = p11:Clone();
        v14.Parent = p12;
        table.insert(u9, v14);
        p13();
    end;

    u10 = tick() + u4;
    local v15 = false;

    while not v15 do
        if u8 then
            local function _() -- Line: 34
                -- upvalues: u7 (ref), u8 (ref), u6 (copy)
                local v16, v17 = next(u6, u7);
                u7 = v16;
                u8 = v17;
            end;

            local v18 = u8:Clone();
            v18.Parent = p3;
            table.insert(u9, v18);
            local v19, v20 = next(u6, u7);
            u7 = v19;
            u8 = v20;

            if u10 <= tick() then
                task.wait();
                u10 = tick() + u4;
            end;
        else
            v15 = true;
        end;
    end;

    if u10 <= tick() then
        task.wait();
        u10 = tick() + u4;
    end;

    return u9;
end;

function u1.new(p21) -- Line: 46
    -- upvalues: u1 (copy)
    local v22 = setmetatable({}, {
        __index = u1
    });
    v22.map = p21;
    v22.keycaps = p21:FindFirstChild("Keycaps");

    return v22;
end;

function u1.Load(p23, p24, p25) -- Line: 54
    -- upvalues: YieldLoadWithBudget (copy)
    return not (p23.keycaps and p24) and {} or YieldLoadWithBudget(p23.keycaps, p24, p25);
end;

function u1.Asynchload(u26, u27, u28, u29) -- Line: 61
    -- upvalues: YieldLoadWithBudget (copy)
    u26:CancelAsynch();

    if not (u26.keycaps and u27) then
        if u29 then
            u29({});
        end;

        return;
    end;

    u26._loadedAssets = {};
    u26.task = task.spawn(function() -- Line: 70
        -- upvalues: YieldLoadWithBudget (ref), u26 (copy), u27 (copy), u28 (copy), u29 (copy)
        local v30 = YieldLoadWithBudget(u26.keycaps, u27, u28, u26._loadedAssets);
        u26.task = nil;
        u26._loadedAssets = nil;
        u29(v30);
    end);
end;

function u1.CancelAsynch(p31) -- Line: 78
    if p31.task then
        task.cancel(p31.task);
        p31.task = nil;
    end;

    local _loadedAssets = p31._loadedAssets;

    if _loadedAssets then
        for _, v in _loadedAssets do
            if v.Parent then
                v:Destroy();
            end;
        end;

        table.clear(_loadedAssets);
        p31._loadedAssets = nil;
    end;
end;

function u1.Destroy(p32) -- Line: 95
    p32:CancelAsynch();
    table.clear(p32);
    setmetatable(p32, {
        __mode = "kv"
    });
    table.freeze(p32);
end;

return u1;