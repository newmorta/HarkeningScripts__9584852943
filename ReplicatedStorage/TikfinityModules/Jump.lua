-- Ruta Original: ReplicatedStorage.TikfinityModules.Jump
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local v1 = {};
local Debris = game:GetService("Debris");

function v1.Run(p2) -- Line: 11
    -- upvalues: Debris (copy)
    local Character = p2.Character;
    local v3;

    if Character then
        v3 = Character:FindFirstChild("HumanoidRootPart");
    else
        v3 = Character;
    end;

    if Character then
        Character = Character:FindFirstChild("Humanoid");
    end;

    if not (v3 and Character) then
        return;
    end;

    local Sound = Instance.new("Sound", v3);
    Sound.SoundId = "rbxassetid://9111926008";
    Sound.Volume = 0.1;
    Sound:Play();
    Debris:AddItem(Sound, 2);
    local Attachment = Instance.new("Attachment", v3);
    local LinearVelocity = Instance.new("LinearVelocity", v3);
    LinearVelocity.Attachment0 = Attachment;
    LinearVelocity.MaxForce = 100000;
    LinearVelocity.VectorVelocity = Vector3.new(0, 120, 0);
    Character:ChangeState(Enum.HumanoidStateType.Jumping);
    Debris:AddItem(Attachment, 0.2);
    Debris:AddItem(LinearVelocity, 0.2);
end;

return v1;