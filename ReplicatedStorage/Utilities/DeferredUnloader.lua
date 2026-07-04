-- Ruta Original: ReplicatedStorage.Utilities.DeferredUnloader
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {};

local function normalizeRoots(p2) -- Line: 3
    return typeof(p2) == "Instance" and { p2 } or p2;
end;

local function collectBaseParts(p3) -- Line: 10
    local v4 = {};
    local v5 = {};

    for _, v in p3 do
        if v:IsA("BasePart") and not v4[v] then
            v4[v] = true;
            table.insert(v5, v);
        end;

        for _, descendant in v:GetDescendants() do
            if descendant:IsA("BasePart") and not v4[descendant] then
                v4[descendant] = true;
                table.insert(v5, descendant);
            end;
        end;
    end;

    return v5;
end;

local function yieldDestroyParts(p6, u7) -- Line: 36
    local u8 = 0;

    local function resetTimer() -- Line: 41
        -- upvalues: u8 (ref), u7 (copy)
        u8 = tick() + u7;
    end;

    local function maybeYield() -- Line: 44
        -- upvalues: u8 (ref), u7 (copy)
        if u8 <= tick() then
            task.wait();
            u8 = tick() + u7;
        end;
    end;

    u8 = tick() + u7;

    for i = #p6, 1, -1 do
        local v9 = p6[i];

        if v9.Parent then
            v9:Destroy();
        end;

        if u8 <= tick() then
            task.wait();
            u8 = tick() + u7;
        end;
    end;

    if u8 <= tick() then
        task.wait();
        u8 = tick() + u7;
    end;
end;

local function destroyRoots(p10) -- Line: 62
    for _, v in p10 do
        if v.Parent then
            v:Destroy();
        end;
    end;
end;

function u1.new(p11) -- Line: 70
    -- upvalues: u1 (copy)
    local v12 = setmetatable({}, {
        __index = u1
    });
    v12.roots = typeof(p11) == "Instance" and { p11 } or p11;
    v12.task = nil;

    return v12;
end;

function u1.CancelAsync(p13) -- Line: 79
    if p13.task then
        task.cancel(p13.task);
        p13.task = nil;
    end;
end;

function u1.Unload(p14, p15) -- Line: 86
    -- upvalues: yieldDestroyParts (copy), collectBaseParts (copy)
    p14:CancelAsync();
    yieldDestroyParts(collectBaseParts(p14.roots), p15);

    for _, v in p14.roots do
        if v.Parent then
            v:Destroy();
        end;
    end;
end;

function u1.AsynchUnload(u16, u17, u18) -- Line: 93
    -- upvalues: yieldDestroyParts (copy), collectBaseParts (copy)
    u16:CancelAsync();
    u16.task = task.spawn(function() -- Line: 96
        -- upvalues: yieldDestroyParts (ref), collectBaseParts (ref), u16 (copy), u17 (copy), u18 (copy)
        yieldDestroyParts(collectBaseParts(u16.roots), u17);

        for _, v in u16.roots do
            if v.Parent then
                v:Destroy();
            end;
        end;

        u16.task = nil;

        if u18 then
            u18();
        end;
    end);
end;

function u1.Destroy(p19) -- Line: 107
    p19:CancelAsync();
    table.clear(p19.roots);
    setmetatable(p19, nil);
end;

return u1;