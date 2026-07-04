-- Ruta Original: ReplicatedStorage.TikfinityModules.Earthquake
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");

function v1.Run(p2) -- Line: 12
    -- upvalues: RunService (copy)
    local Character = p2.Character;

    if not Character then
        return;
    end;

    local u3 = Character:FindFirstChildOfClass("Humanoid");

    if not u3 then
        return;
    end;

    task.spawn(function() -- Line: 19
        -- upvalues: RunService (ref), u3 (copy)
        local u4 = os.clock();
        local u5 = nil;
        u5 = RunService.RenderStepped:Connect(function() -- Line: 23
            -- upvalues: u4 (copy), u3 (ref), u5 (ref)
            local v6 = os.clock() - u4;

            if v6 >= 2.5 then
                u3.CameraOffset = Vector3.new(0, 0, 0);
                u5:Disconnect();

                return;
            end;

            local v7 = 1.5 * (1 - v6 / 2.5);
            local v8 = (math.random() - 0.5) * 2 * v7;
            local v9 = (math.random() - 0.5) * 2 * v7;
            local v10 = (math.random() - 0.5) * 2 * v7 * 0.3;
            u3.CameraOffset = Vector3.new(v8, v9, v10);
        end);
    end);
end;

return v1;