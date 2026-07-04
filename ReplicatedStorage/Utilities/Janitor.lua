-- Ruta Original: ReplicatedStorage.Utilities.Janitor
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 13
    -- upvalues: u1 (copy)
    return setmetatable({
        _tasks = {}
    }, u1);
end;

function u1.Add(p2, p3, p4) -- Line: 19
    if p3 == nil then
        return p3;
    end;

    table.insert(p2._tasks, {
        obj = p3,
        method = p4
    });

    return p3;
end;

function u1.Cleanup(p5) -- Line: 28
    local _tasks = p5._tasks;

    for i = #_tasks, 1, -1 do
        local v6 = _tasks[i];
        local obj = v6.obj;
        local method = v6.method;

        if method == nil then
            local v7 = typeof(obj);

            if v7 == "function" then
                obj();
            elseif v7 == "RBXScriptConnection" then
                obj:Disconnect();
            elseif v7 == "Instance" then
                obj:Destroy();
            elseif type(obj) == "table" and type(obj.Destroy) == "function" then
                obj:Destroy();
            end;
        elseif type(obj) == "table" and type(obj[method]) == "function" then
            obj[method](obj);
        end;

        _tasks[i] = nil;
    end;
end;

return u1;