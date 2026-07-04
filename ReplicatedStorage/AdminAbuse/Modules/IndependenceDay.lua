-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.IndependenceDay
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local IndependenceDayConfig = require(script.IndependenceDayConfig);
local IndependenceDayCutscenes = require(script.IndependenceDayCutscenes);
local FireworksController = require(script.FireworksController);
local ShowController = require(script.ShowController);
local IndependenceDayLightsDirector = require(script.IndependenceDayLightsDirector);
local IndependenceDayCommandPanel = require(script.IndependenceDayCommandPanel);
local NPCDanceController = require(script.NPCDanceController);
local LaserSweep = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("Events"):WaitForChild("LaserSweep"));
local StageLights = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("Events"):WaitForChild("StageLights"));
local SharedSyncedEvent = require(ReplicatedStorage:WaitForChild("AdminAbuse"):WaitForChild("SharedSyncedEvent"));
local u1 = false;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;

return {
    DisplayName = IndependenceDayConfig.DisplayName,
    NeedsDuration = IndependenceDayConfig.NeedsDuration,
    SkipDoorTransition = IndependenceDayConfig.SkipDoorTransition,
    IsAdminAbuse = IndependenceDayConfig.IsAdminAbuse,
    RequiresRespawnRefire = IndependenceDayConfig.RequiresRespawnRefire,
    HasPrioritySoundtrack = IndependenceDayConfig.HasPrioritySoundtrack,

    Fire = function(p10) -- Line: 46, Name: Fire
        -- upvalues: u1 (ref), u5 (ref), SharedSyncedEvent (copy), IndependenceDayConfig (copy), IndependenceDayCutscenes (copy), u4 (ref), FireworksController (copy), ReplicatedStorage (copy), IndependenceDayCommandPanel (copy), u3 (ref), Workspace (copy), ShowController (copy), NPCDanceController (copy), u6 (ref), StageLights (copy), u7 (ref), LaserSweep (copy), u8 (ref), IndependenceDayLightsDirector (copy), u9 (ref), u2 (ref), RunService (copy), Players (copy)
        if u1 then
            warn("[IndependenceDay] Fire() ignoré — déjà en cours");

            return;
        end;

        u1 = true;
        warn("[IndependenceDay] Client démarré");
        u5 = SharedSyncedEvent.new(IndependenceDayConfig.SSE_CHANNEL);
        u5:onChange("phase", function(p11) -- Line: 60
            warn("[IndependenceDay] Phase →", p11);
        end);
        u5:onChange("OpeningCutscene", function(p12) -- Line: 65
            -- upvalues: IndependenceDayCutscenes (ref)
            IndependenceDayCutscenes.playOpening(p12);
        end);
        u5:onChange("EndingCutscene", function(p13) -- Line: 69
            -- upvalues: IndependenceDayCutscenes (ref)
            IndependenceDayCutscenes.playEnding(p13);
        end);
        u5:onChange("CleanupDone", function() -- Line: 75
            -- upvalues: IndependenceDayCutscenes (ref)
            IndependenceDayCutscenes.notifyCleanupDone();
        end);
        u5:onFire("firework", function(p14) -- Line: 80
            -- upvalues: u4 (ref), FireworksController (ref)
            if not u4 then
                return;
            end;

            for _ = 1, p14 and p14.count or 1 do
                FireworksController.FireRandom(u4);
            end;
        end);
        local Remotes = ReplicatedStorage:WaitForChild("AdminAbuse"):WaitForChild("Remotes");
        local IndependenceDayCommand = Remotes:WaitForChild("IndependenceDayCommand", 15);
        local IndependenceDayWinOrbCollected = Remotes:WaitForChild("IndependenceDayWinOrbCollected", 15);

        if IndependenceDayCommand and IndependenceDayCommand:IsA("RemoteEvent") then
            IndependenceDayCommandPanel.init(u5, IndependenceDayCommand, IndependenceDayWinOrbCollected);
        else
            warn("[IndependenceDay] IndependenceDayCommand remote introuvable — panel de commande désactivé");
        end;

        u3 = task.spawn(function() -- Line: 100
            -- upvalues: u1 (ref), u4 (ref), Workspace (ref), IndependenceDayConfig (ref), ShowController (ref), NPCDanceController (ref), u6 (ref), StageLights (ref), u7 (ref), LaserSweep (ref), u8 (ref), IndependenceDayLightsDirector (ref), u9 (ref), u2 (ref), RunService (ref), Players (ref)
            local v15 = 0;

            while u1 and (not u4 and v15 < 150) do
                u4 = Workspace.AdminAbuse.Map:FindFirstChild(IndependenceDayConfig.MAP_LIVE_NAME);

                if not u4 then
                    task.wait(0.1);
                    v15 = v15 + 1;
                end;
            end;

            if not u1 then
                return;
            end;

            if not u4 then
                warn("[IndependenceDay] Map \'" .. IndependenceDayConfig.MAP_LIVE_NAME .. "\' introuvable après timeout");

                return;
            end;

            warn("[IndependenceDay] Map trouvée — boucle de rendu démarrée");
            ShowController.RunSequential(u4);
            NPCDanceController.Start(u4);
            local Scriptables = u4:FindFirstChild("Scriptables");
            local v16;

            if Scriptables then
                v16 = Scriptables:FindFirstChild("Spotlights");
            else
                v16 = Scriptables;
            end;

            if Scriptables then
                Scriptables = Scriptables:FindFirstChild("LaserSpots");
            end;

            if v16 and Scriptables then
                u6 = StageLights.new({
                    colorCycle = true,
                    pattern = IndependenceDayConfig.STAGE_LIGHT_PATTERNS[1],
                    colorPalette = IndependenceDayConfig.LIGHT_COLOR_PALETTE,
                    colorCycleMinSec = IndependenceDayConfig.LIGHT_COLOR_CYCLE_MIN_SEC,
                    colorCycleMaxSec = IndependenceDayConfig.LIGHT_COLOR_CYCLE_MAX_SEC
                });
                u7 = LaserSweep.new({
                    colorCycle = true,
                    pattern = IndependenceDayConfig.LASER_PATTERN,
                    colorPalette = IndependenceDayConfig.LIGHT_COLOR_PALETTE,
                    colorCycleMinSec = IndependenceDayConfig.LIGHT_COLOR_CYCLE_MIN_SEC,
                    colorCycleMaxSec = IndependenceDayConfig.LIGHT_COLOR_CYCLE_MAX_SEC
                });
                u6:scan(v16);
                u7:scan(Scriptables);
                u8 = IndependenceDayLightsDirector.new(u6, u7);
            else
                warn("[IndependenceDay] Scriptables/Spotlights ou Scriptables/LaserSpots introuvable — lights/lasers désactivés");
            end;

            local IndependenceDayAudio = u4:FindFirstChild("IndependenceDayAudio");
            local v17;

            if IndependenceDayAudio then
                v17 = IndependenceDayAudio:FindFirstChild("AudioAnalyzer");
            else
                v17 = IndependenceDayAudio;
            end;

            u9 = v17;
            u2 = RunService.Heartbeat:Connect(function(p18) -- Line: 155
                -- upvalues: u1 (ref), u9 (ref), u8 (ref), IndependenceDayAudio (copy), Players (ref)
                if not u1 then
                    return;
                end;

                local v19 = u9 and (u9.Parent and u9.PeakLevel) or 0;

                if u8 then
                    u8:update(p18, v19);
                end;

                if IndependenceDayAudio then
                    local v20 = Players.LocalPlayer:GetAttribute("AdminAbuseMuted") == true;

                    for _, child in ipairs(IndependenceDayAudio:GetChildren()) do
                        if child:IsA("AudioPlayer") then
                            if v20 then
                                if child.Volume ~= 0 then
                                    child.Volume = 0;
                                end;

                                child:SetAttribute("IndependenceDayAudioMuted", true);
                            elseif child:GetAttribute("IndependenceDayAudioMuted") == true then
                                child.Volume = 1;
                                child:SetAttribute("IndependenceDayAudioMuted", false);
                            end;
                        end;
                    end;
                end;
            end);
        end);
    end,

    Stop = function(p21) -- Line: 189, Name: Stop
        -- upvalues: u1 (ref), IndependenceDayCutscenes (copy), ShowController (copy), IndependenceDayCommandPanel (copy), NPCDanceController (copy), u3 (ref), u2 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u4 (ref)
        warn("[IndependenceDay] Client arrêté");
        u1 = false;
        IndependenceDayCutscenes.stop();
        ShowController.Stop();
        IndependenceDayCommandPanel.Stop();
        NPCDanceController.Stop();

        if u3 then
            task.cancel(u3);
            u3 = nil;
        end;

        if u2 then
            u2:Disconnect();
            u2 = nil;
        end;

        if u5 then
            u5:destroy();
            u5 = nil;
        end;

        if u6 then
            u6:destroy();
            u6 = nil;
        end;

        if u7 then
            u7:destroy();
            u7 = nil;
        end;

        u8 = nil;
        u9 = nil;
        u4 = nil;
    end
};