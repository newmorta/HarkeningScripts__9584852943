-- Ruta Original: StarterPlayer.StarterPlayerScripts.ConcertMusicPreload
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local ContentProvider = game:GetService("ContentProvider");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ConcertSharedConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ConcertSharedConfig"));
(function() -- Line: 8, Name: startPreload
    -- upvalues: ConcertSharedConfig (copy), ContentProvider (copy)
    local Folder = Instance.new("Folder");
    Folder.Name = "ConcertPreloadSounds";
    local u1 = {};

    for _, v in ipairs(ConcertSharedConfig.ConcertMusic) do
        if v.AssetId and v.AssetId ~= "" then
            local Sound = Instance.new("Sound");
            Sound.SoundId = v.AssetId;
            Sound.Parent = Folder;
            table.insert(u1, Sound);
        end;
    end;

    if #u1 > 0 then
        task.spawn(function() -- Line: 23
            -- upvalues: u1 (copy), ContentProvider (ref), Folder (copy)
            local v2 = os.clock();
            warn(string.format("[ConcertPreload] Démarrage du préchargement de %d pistes audio...", #u1));
            local success, result = pcall(function() -- Line: 27
                -- upvalues: ContentProvider (ref), u1 (ref)
                ContentProvider:PreloadAsync(u1);
            end);

            if success then
                warn(string.format("[ConcertPreload] Préchargement de toutes les musiques terminé en %.2f secondes.", os.clock() - v2));
            else
                warn("[ConcertPreload] Échec du préchargement :", result);
            end;

            Folder:Destroy();
        end);
    end;
end)();