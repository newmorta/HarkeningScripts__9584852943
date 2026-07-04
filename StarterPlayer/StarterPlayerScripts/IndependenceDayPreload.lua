-- Ruta Original: StarterPlayer.StarterPlayerScripts.IndependenceDayPreload
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local ContentProvider = game:GetService("ContentProvider");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local IndependenceDayConfig = require(ReplicatedStorage:WaitForChild("AdminAbuse"):WaitForChild("Modules"):WaitForChild("IndependenceDay"):WaitForChild("IndependenceDayConfig"));
(function() -- Line: 21, Name: startPreload
    -- upvalues: IndependenceDayConfig (copy), ContentProvider (copy)
    local u1 = {};

    for _, v in IndependenceDayConfig.ANIM_IDS.Opening do
        if v and (v ~= "" and v ~= "rbxassetid://0") then
            local Animation = Instance.new("Animation");
            Animation.AnimationId = v;
            table.insert(u1, Animation);
        end;
    end;

    for _, v in IndependenceDayConfig.ANIM_IDS.NPCDances do
        if v and (v ~= "" and v ~= "rbxassetid://0") then
            local Animation = Instance.new("Animation");
            Animation.AnimationId = v;
            table.insert(u1, Animation);
        end;
    end;

    for _, v in IndependenceDayConfig.SOUNDTRACKS do
        local AssetId = v.AssetId;

        if AssetId and (AssetId ~= "" and AssetId ~= "rbxassetid://0") then
            local Sound = Instance.new("Sound");
            Sound.SoundId = AssetId;
            table.insert(u1, Sound);
        end;
    end;

    if #u1 > 0 then
        task.spawn(function() -- Line: 50
            -- upvalues: u1 (copy), ContentProvider (ref)
            local v2 = os.clock();
            warn(string.format("[IndependenceDayPreload] Démarrage du préchargement de %d asset(s)...", #u1));
            local success, result = pcall(ContentProvider.PreloadAsync, ContentProvider, u1);

            if success then
                warn(string.format("[IndependenceDayPreload] Terminé en %.2f secondes.", os.clock() - v2));
            else
                warn("[IndependenceDayPreload] Échec :", result);
            end;

            for _, v in u1 do
                v:Destroy();
            end;
        end);
    end;
end)();