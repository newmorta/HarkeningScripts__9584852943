-- Ruta Original: ReplicatedStorage.TikfinityModules.Ragdoll
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local v1 = {};
local Debris = game:GetService("Debris");

function v1.Run(p2) -- Line: 13
    -- upvalues: Debris (copy)
    local Character = p2.Character;
    local u3;

    if Character then
        u3 = Character:FindFirstChild("HumanoidRootPart");
    else
        u3 = Character;
    end;

    local u4;

    if Character then
        u4 = Character:FindFirstChild("Humanoid");
    else
        u4 = Character;
    end;

    if not u3 or (not u4 or u4.Health <= 0) then
        return;
    end;

    local Sound = Instance.new("Sound", u3);
    Sound.SoundId = "rbxassetid://129432532096499";
    Sound:Play();
    Debris:AddItem(Sound, 3);
    u4:ChangeState(Enum.HumanoidStateType.Physics);
    u4.PlatformStand = true;
    u3.CFrame = u3.CFrame * CFrame.Angles(1.2217304763960306, 0, 0);
    local v5 = -u3.CFrame.LookVector;
    u3.AssemblyLinearVelocity = Vector3.new(v5.X * 30, 35, v5.Z * 30);
    task.delay(2, function() -- Line: 35
        -- upvalues: Character (copy), u4 (copy), u3 (copy)
        if Character.Parent and u4 then
            u4.PlatformStand = false;
            u4:ChangeState(Enum.HumanoidStateType.GettingUp);
            u3.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        end;
    end);
end;

return v1;