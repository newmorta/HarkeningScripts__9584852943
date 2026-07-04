-- Ruta Original: ReplicatedStorage.TikfinityModules.Blur
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local v1 = {};
local Lighting = game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");

function v1.Run(p2) -- Line: 20
    -- upvalues: SoundService (copy), Debris (copy), Lighting (copy), TweenService (copy)
    task.spawn(function() -- Line: 21
        -- upvalues: SoundService (ref), Debris (ref), Lighting (ref), TweenService (ref)
        local Sound = Instance.new("Sound");
        Sound.SoundId = "rbxassetid://135541330012995";
        Sound.Volume = 0.4;
        Sound.Parent = SoundService;
        Sound:Play();
        Debris:AddItem(Sound, 4);
        local BlurEffect = Instance.new("BlurEffect");
        BlurEffect.Name = "TikfinityBlur";
        BlurEffect.Size = 0;
        BlurEffect.Parent = Lighting;
        TweenService:Create(BlurEffect, TweenInfo.new(0.3), {
            Size = 40
        }):Play();
        task.wait(3);
        local v3 = TweenService:Create(BlurEffect, TweenInfo.new(0.5), {
            Size = 0
        });
        v3:Play();
        v3.Completed:Wait();
        BlurEffect:Destroy();
    end);
end;

return v1;