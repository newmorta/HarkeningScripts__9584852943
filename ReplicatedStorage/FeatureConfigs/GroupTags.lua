-- Ruta Original: ReplicatedStorage.FeatureConfigs.GroupTags
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local v1 = {};

for _, child in ipairs(script.Configs:GetChildren()) do
    if child:IsA("ModuleScript") then
        local success, result = pcall(require, child);

        if success and (result and result.available ~= false) then
            v1[result.key] = result;
        end;
    end;
end;

return v1;