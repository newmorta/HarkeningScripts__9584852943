-- Ruta Original: ReplicatedStorage.TikfinityModules.Turtle
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local v1 = {};
local Debris = game:GetService("Debris");
local SoundService = game:GetService("SoundService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Config = require(ReplicatedStorage:WaitForChild("Config"));
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));

function v1.Run(p2) -- Line: 18
    -- upvalues: SoundService (copy), Debris (copy), ClientState (copy), Config (copy)
    local Character = p2.Character;

    if not Character then
        return;
    end;

    local Humanoid = Character:FindFirstChild("Humanoid");

    if not (Humanoid and Character:FindFirstChild("HumanoidRootPart")) then
        return;
    end;

    local Sound = Instance.new("Sound");
    Sound.Name = "TurtleSound";
    Sound.SoundId = "rbxassetid://128475171868078";
    Sound.Volume = 0.4;
    Sound.PlaybackSpeed = 0.6;
    Sound.Parent = SoundService;
    Sound:Play();
    Debris:AddItem(Sound, 4);
    local u3 = os.clock() + 3;
    Humanoid:SetAttribute("TurtleResetTime", u3);
    Humanoid.WalkSpeed = 4;
    task.delay(3, function() -- Line: 44
        -- upvalues: Humanoid (copy), u3 (copy), ClientState (ref), Config (ref)
        if Humanoid and Humanoid.Parent then
            local v4 = Humanoid:GetAttribute("TurtleResetTime");

            if v4 and v4 <= u3 + 0.05 then
                local v5 = ClientState:Get();
                Humanoid.WalkSpeed = v5.CustomWalkSpeed and v5.CustomWalkSpeed > 0 and v5.CustomWalkSpeed or Config.CalculateMaxSpeed(v5.Level);
            end;
        end;
    end);
end;

return v1;