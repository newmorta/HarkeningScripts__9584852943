-- Ruta Original: ReplicatedStorage.Utilities.GravityManager
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {};

local function apply() -- Line: 11
    -- upvalues: u1 (copy)
    local v2 = nil;

    for _, v in u1 do
        if not v2 or v.priority > v2.priority then
            v2 = v;
        end;
    end;

    workspace.Gravity = not v2 and 196.2 or v2.value;
end;

return {
    set = function(p3, p4, p5) -- Line: 23, Name: set
        -- upvalues: u1 (copy)
        u1[p3] = {
            value = p4,
            priority = p5
        };
        local v6 = nil;

        for _, v in u1 do
            if not v6 or v.priority > v6.priority then
                v6 = v;
            end;
        end;

        workspace.Gravity = not v6 and 196.2 or v6.value;
    end,

    release = function(p7) -- Line: 28, Name: release
        -- upvalues: u1 (copy)
        u1[p7] = nil;
        local v8 = nil;

        for _, v in u1 do
            if not v8 or v.priority > v8.priority then
                v8 = v;
            end;
        end;

        workspace.Gravity = not v8 and 196.2 or v8.value;
    end
};