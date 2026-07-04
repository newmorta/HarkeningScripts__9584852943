-- Ruta Original: ReplicatedStorage.SoundManager
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local SoundService = game:GetService("SoundService");
local ContentProvider = game:GetService("ContentProvider");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Config = require(ReplicatedStorage:WaitForChild("Config"));
local u1 = SoundService:FindFirstChild("GameSounds") or Instance.new("Folder");
u1.Name = "GameSounds";
u1.Parent = SoundService;
local u2 = {};
local u3 = {};
local v4 = {};

for i, v in pairs(Config.SOUNDS) do
    local Sound = Instance.new("Sound");
    Sound.Name = i;
    Sound.SoundId = v.ID;
    Sound.Volume = v.Volume or 0.5;
    Sound.Parent = u1;
    u2[i] = Sound;
    table.insert(u3, Sound);
end;

task.spawn(function() -- Line: 33
    -- upvalues: ContentProvider (copy), u3 (copy)
    pcall(function() -- Line: 34
        -- upvalues: ContentProvider (ref), u3 (ref)
        ContentProvider:PreloadAsync(u3);
    end);
end);

function v4.Play(p5, p6) -- Line: 44
    -- upvalues: u2 (copy), u1 (copy)
    local v7 = u2[p6];

    if not v7 then
        warn("[SoundManager] Son inexistant : " .. tostring(p6));

        return;
    end;

    local u8 = v7:Clone();
    u8.Parent = u1;
    u8.PlaybackSpeed = v7.PlaybackSpeed * (math.random(95, 105) / 100);
    u8:Play();
    u8.Ended:Connect(function() -- Line: 60
        -- upvalues: u8 (copy)
        u8:Destroy();
    end);
end;

function v4.PlayLevelUp(p9) -- Line: 69
    p9:Play("LEVEL_UP");
end;

function v4.PlayRebirth(p10) -- Line: 70
    p10:Play("REBIRTH");
end;

function v4.PlayCollect(p11) -- Line: 71
    p11:Play("COLLECT");
end;

function v4.PlayWin(p12) -- Line: 72
    p12:Play("WIN");
end;

return v4;