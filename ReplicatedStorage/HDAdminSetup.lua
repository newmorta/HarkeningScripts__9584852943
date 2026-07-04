-- Ruta Original: ReplicatedStorage.HDAdminSetup
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local u2 = {
    GetClientFolder = function(p1) -- Line: 3, Name: GetClientFolder
        return game:GetService("ReplicatedStorage"):WaitForChild("HDAdminHDClient", 30);
    end
};

function u2.GetMain(p3, p4) -- Line: 7
    -- upvalues: u2 (copy)
    local MainFramework = require(u2:GetClientFolder():WaitForChild("SharedModules", 30).MainFramework);

    if p4 ~= true then
        MainFramework = MainFramework:CheckInitialized();
    end;

    return MainFramework;
end;

return u2;