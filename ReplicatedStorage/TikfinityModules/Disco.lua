-- Ruta Original: ReplicatedStorage.TikfinityModules.Disco
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local v1 = {};
local Lighting = game:GetService("Lighting");
game:GetService("Debris");
local u2 = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 100, 255),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(255, 0, 255),
    Color3.fromRGB(0, 255, 255),
    Color3.fromRGB(255, 128, 0)
};

function v1.Run(p3) -- Line: 22
    -- upvalues: Lighting (copy), u2 (copy)
    task.spawn(function() -- Line: 23
        -- upvalues: Lighting (ref), u2 (ref)
        local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
        ColorCorrectionEffect.Name = "TikfinityDisco";
        ColorCorrectionEffect.Parent = Lighting;
        local v4 = os.clock();
        local v5 = 1;

        while os.clock() - v4 < 3 do
            ColorCorrectionEffect.TintColor = u2[v5];
            v5 = v5 % #u2 + 1;
            task.wait(0.15);
        end;

        ColorCorrectionEffect:Destroy();
    end);
end;

return v1;