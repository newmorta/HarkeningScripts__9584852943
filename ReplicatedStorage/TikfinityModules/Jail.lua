-- Ruta Original: ReplicatedStorage.TikfinityModules.Jail
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");

function v1.Run(u2) -- Line: 14
    -- upvalues: ReplicatedStorage (copy), Debris (copy)
    local u3 = u2.Character and u3:FindFirstChild("HumanoidRootPart");

    if not u3 then
        return;
    end;

    task.spawn(function() -- Line: 19
        -- upvalues: ReplicatedStorage (ref), u3 (copy), u2 (copy), Debris (ref)
        local PrisonCage = ReplicatedStorage:FindFirstChild("PrisonCage");

        if not PrisonCage then
            warn("[Tikfinity] Modèle \'PrisonCage\' introuvable dans ReplicatedStorage");

            return;
        end;

        u3.Anchored = true;
        local v4 = PrisonCage:Clone();
        v4.Name = "LocalCage_" .. u2.Name;
        v4:PivotTo(u3.CFrame);
        v4.Parent = workspace;
        u3.Anchored = false;
        local Sound = Instance.new("Sound", u3);
        Sound.SoundId = "rbxassetid://102841351704442";
        Sound.Volume = 0.2;
        Sound:Play();
        Debris:AddItem(Sound, 2);
        task.wait(2.8);

        if v4 then
            v4:Destroy();
        end;
    end);
end;

return v1;