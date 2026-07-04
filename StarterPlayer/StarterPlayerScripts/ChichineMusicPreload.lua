-- Ruta Original: StarterPlayer.StarterPlayerScripts.ChichineMusicPreload
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local ContentProvider = game:GetService("ContentProvider");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ChichineConfig = require(ReplicatedStorage:WaitForChild("AdminAbuse"):WaitForChild("Modules"):WaitForChild("ChichineBossRoom"):WaitForChild("ChichineConfig"));
(function() -- Line: 14, Name: startPreload
    -- upvalues: ChichineConfig (copy), ContentProvider (copy)
    local Folder = Instance.new("Folder");
    Folder.Name = "ChichinePreloadSounds";
    local u1 = {};

    for _, v in ChichineConfig.Soundtracks do
        local ID = v.ID;

        if ID and (ID ~= "" and ID ~= "rbxassetid://0") then
            local Sound = Instance.new("Sound");
            Sound.SoundId = ID;
            Sound.Parent = Folder;
            table.insert(u1, Sound);
        end;
    end;

    if #u1 > 0 then
        task.spawn(function() -- Line: 30
            -- upvalues: u1 (copy), ContentProvider (ref), Folder (copy)
            local v2 = os.clock();
            warn(string.format("[ChichinePreload] Démarrage du préchargement de %d piste(s)...", #u1));
            local success, result = pcall(ContentProvider.PreloadAsync, ContentProvider, u1);

            if success then
                warn(string.format("[ChichinePreload] Terminé en %.2f secondes.", os.clock() - v2));
            else
                warn("[ChichinePreload] Échec :", result);
            end;

            Folder:Destroy();
        end);
    end;
end)();