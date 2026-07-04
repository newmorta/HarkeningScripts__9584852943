-- Ruta Original: ReplicatedStorage.TikfinityModules.Invisible
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

    if not Character:FindFirstChild("HumanoidRootPart") then
        return;
    end;

    task.spawn(function() -- Line: 21
        -- upvalues: SoundService (ref), Debris (ref), Character (copy)
        local Sound = Instance.new("Sound");
        Sound.SoundId = "rbxassetid://136774133309136";
        Sound.Volume = 0.4;
        Sound.PlaybackSpeed = 0.5;
        Sound.Parent = SoundService;
        Sound:Play();
        Debris:AddItem(Sound, 5);
        local v3 = {};

        for _, descendant in ipairs(Character:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
                v3[descendant] = descendant.Transparency;
                descendant.Transparency = 1;
            elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
                v3[descendant] = descendant.Transparency;
                descendant.Transparency = 1;
            end;
        end;

        task.wait(4);

        if Character.Parent then
            for i, v in pairs(v3) do
                if i.Parent then
                    i.Transparency = v;
                end;
            end;
        end;
    end);
end;

return v1;