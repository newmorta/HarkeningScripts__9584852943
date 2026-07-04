-- Ruta Original: ReplicatedStorage.FeatureConfigs.PersonalTreadmill.Skins
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Parent = require(script.Parent);

return {
    SKINS = (function() -- Line: 17, Name: getSkins
        -- upvalues: Parent (copy)
        local v1 = {};
        local Assets = script:FindFirstChild("Assets");

        if not Assets then
            return v1;
        end;

        for _, child in ipairs(Assets:GetChildren()) do
            if child:IsA("Model") and not Parent.TIER_MULT[child.Name] then
                v1[child.Name] = {
                    name = child.Name,
                    price = child:GetAttribute("Price"),
                    gamepass = child:GetAttribute("Gamepass")
                };
            end;
        end;

        return v1;
    end)()
};