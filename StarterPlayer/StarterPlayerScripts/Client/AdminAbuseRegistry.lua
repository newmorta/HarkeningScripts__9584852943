-- Ruta Original: StarterPlayer.StarterPlayerScripts.Client.AdminAbuseRegistry
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local function loadModules(p1) -- Line: 10
    local v2 = {};

    for _, child in ipairs(p1:GetChildren()) do
        if child:IsA("ModuleScript") then
            local success, result = pcall(require, child);

            if success and type(result) == "table" then
                v2[child.Name] = result;
            else
                warn((`[AdminAbuse] require "{child.Name}" échoue`));
            end;
        end;
    end;

    return v2;
end;

local function readMeta(p3, p4) -- Line: 25
    local v5 = false;
    local v6 = nil;
    local v7 = nil;
    local v8 = true;
    local v9;

    if type(p4) == "table" then
        if type(p4.DisplayName) == "string" and p4.DisplayName ~= "" then
            v9 = p4.DisplayName;
        else
            v9 = p3;
        end;

        v5 = p4.NeedsDuration == true and true or v5;

        if type(p4.MaxDurationSeconds) == "number" and p4.MaxDurationSeconds > 0 then
            v6 = p4.MaxDurationSeconds;
        end;

        if type(p4.DefaultDurationSeconds) == "number" and p4.DefaultDurationSeconds > 0 then
            v7 = p4.DefaultDurationSeconds;
        end;

        if p4.IsAdminAbuse == false then
            v8 = false;
        end;
    else
        v9 = p3;
    end;

    return {
        name = p3,
        displayName = v9,
        needsDuration = v5,
        maxDurationSeconds = v6,
        defaultDurationSeconds = v7,
        isAdminAbuse = v8
    };
end;

return {
    listModuleNames = function(p10) -- Line: 60, Name: listModuleNames
        local v11 = {};

        for _, child in ipairs(p10:GetChildren()) do
            if child:IsA("ModuleScript") then
                table.insert(v11, child.Name);
            end;
        end;

        table.sort(v11);

        return v11;
    end,

    listModuleMetas = function(p12) -- Line: 71, Name: listModuleMetas
        -- upvalues: readMeta (copy)
        local v13 = {};

        for _, child in ipairs(p12:GetChildren()) do
            if child:IsA("ModuleScript") then
                local success, result = pcall(require, child);

                if not success or (type(result) ~= "table" or result.Hidden ~= true) then
                    if success then
                        local v14 = readMeta(child.Name, result);
                        table.insert(v13, v14);
                    else
                        table.insert(v13, {
                            needsDuration = false,
                            maxDurationSeconds = nil,
                            defaultDurationSeconds = nil,
                            name = child.Name,
                            displayName = child.Name
                        });
                    end;
                end;
            end;
        end;

        table.sort(v13, function(p15, p16) -- Line: 92
            return p15.displayName < p16.displayName;
        end);

        return v13;
    end,

    buildAdminAbuseTable = function(p17) -- Line: 98, Name: buildAdminAbuseTable
        -- upvalues: loadModules (copy)
        local u18 = loadModules(p17);

        return setmetatable({}, {
            __index = function(p19, p20) -- Line: 101, Name: __index
                -- upvalues: u18 (copy)
                return u18[p20];
            end
        });
    end,

    loadRegistry = function(p21) -- Line: 107, Name: loadRegistry
        -- upvalues: loadModules (copy)
        return loadModules(p21);
    end
};