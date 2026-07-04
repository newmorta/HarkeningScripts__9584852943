-- Ruta Original: ReplicatedStorage.TikfinityModules.Tiny
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local v1 = {};
local Debris = game:GetService("Debris");
local SoundService = game:GetService("SoundService");

function v1.Run(p2) -- Line: 14
    -- upvalues: SoundService (copy), Debris (copy)
    local Character = p2.Character;

    if not Character then
        return;
    end;

    local u3 = Character:FindFirstChildOfClass("Humanoid");

    if not (u3 and Character:FindFirstChild("HumanoidRootPart")) then
        return;
    end;

    task.spawn(function() -- Line: 22
        -- upvalues: SoundService (ref), Debris (ref), Character (copy), u3 (copy)
        local Sound = Instance.new("Sound");
        Sound.SoundId = "rbxassetid://122501020672503";
        Sound.Volume = 0.4;
        Sound.PlaybackSpeed = 1.8;
        Sound.Parent = SoundService;
        Sound:Play();
        Debris:AddItem(Sound, 5);
        local v4 = Character:GetScale();
        local WalkSpeed = u3.WalkSpeed;
        local JumpPower = u3.JumpPower;
        local JumpHeight = u3.JumpHeight;
        Character:ScaleTo(0.2);
        u3.WalkSpeed = WalkSpeed;
        u3.JumpPower = JumpPower;
        u3.JumpHeight = JumpHeight;
        task.wait(4);

        if Character.Parent and u3.Parent then
            Character:ScaleTo(v4);
            u3.WalkSpeed = WalkSpeed;
            u3.JumpPower = JumpPower;
            u3.JumpHeight = JumpHeight;
        end;
    end);
end;

return v1;