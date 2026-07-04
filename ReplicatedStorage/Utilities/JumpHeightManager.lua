-- Ruta Original: ReplicatedStorage.Utilities.JumpHeightManager
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = nil;
local u3 = 7.2;

local function apply() -- Line: 13
    -- upvalues: u2 (ref), u1 (ref), u3 (ref)
    if not (u2 and u2.Parent) then
        return;
    end;

    local v4 = nil;

    for _, v in u1 do
        if not v4 or v.priority > v4.priority then
            v4 = v;
        end;
    end;

    local v5;

    if v4 then
        v5 = v4.value;
    else
        v5 = u3;
    end;

    u2.JumpHeight = v5;
end;

return {
    setHumanoid = function(p6) -- Line: 26, Name: setHumanoid
        -- upvalues: u2 (ref), u3 (ref), u1 (ref), apply (copy)
        u2 = p6;
        u3 = p6.JumpHeight;
        u1 = {};
        apply();
    end,

    set = function(p7, p8, p9) -- Line: 33, Name: set
        -- upvalues: u1 (ref), apply (copy)
        u1[p7] = {
            value = p8,
            priority = p9
        };
        apply();
    end,

    release = function(p10) -- Line: 38, Name: release
        -- upvalues: u1 (ref), apply (copy)
        u1[p10] = nil;
        apply();
    end
};