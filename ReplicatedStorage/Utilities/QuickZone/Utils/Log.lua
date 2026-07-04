-- Ruta Original: ReplicatedStorage.Utilities.QuickZone.Utils.Log
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local v1 = {};

local function formatLog(p2, p3, ...) -- Line: 5
    local v4 = `[QuickZone] {string.format(p2, ...)}`;
    local v5 = p3 or debug.traceback("", 3);

    if v5 ~= "" then
        v4 = v4 .. ` \n---- Stack trace ----\n{v5}`;
    end;

    return v4:gsub("\n", "\n    ");
end;

function v1.info(p6, p7, ...) -- Line: 19
    -- upvalues: formatLog (copy)
    print(formatLog(p6, p7, ...));
end;

function v1.warn(p8, p9, ...) -- Line: 23
    -- upvalues: formatLog (copy)
    warn(formatLog(p8, p9, ...));
end;

function v1.fatal(p10, p11, ...) -- Line: 27
    -- upvalues: formatLog (copy)
    error(formatLog(p10, p11, ...), 0);
end;

function v1.nonFatal(p12, p13, ...) -- Line: 31
    -- upvalues: formatLog (copy)
    local v14 = formatLog(p12, p13, ...);
    task.spawn(error, v14, 0);
end;

return v1;