-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.Concert
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LaserSweep = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("Events"):WaitForChild("LaserSweep"));
local StageLights = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("Events"):WaitForChild("StageLights"));
local SpeakerShockwaves = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("Events"):WaitForChild("SpeakerShockwaves"));
local ConcertDirector = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("Events"):WaitForChild("ConcertDirector"));
local DJAnimationController = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("Events"):WaitForChild("DJAnimationController"));
local LightCubeController = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("Events"):WaitForChild("LightCubeController"));
local MusicNameDiffuserController = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("Events"):WaitForChild("MusicNameDiffuserController"));
local ConcertZoneController = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("Events"):WaitForChild("ConcertZoneController"));
local ConcertOrbController = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("Events"):WaitForChild("ConcertOrbController"));
local ConcertAnnouncementController = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("Events"):WaitForChild("ConcertAnnouncementController"));
local NeonPulseController = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("Events"):WaitForChild("NeonPulseController"));
local ConcertSharedConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ConcertSharedConfig"));
local v1 = {
    NeedsDuration = false,
    SkipDoorTransition = false,
    RequiresRespawnRefire = true,
    IsAdminAbuse = true
};
local u2 = false;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = 0;
local u17 = nil;
local u18 = nil;

local function cacheSceneRefs() -- Line: 50
    -- upvalues: Workspace (copy), u17 (ref), u18 (ref)
    local AAX3LL3N_Live = Workspace:FindFirstChild("AAX3LL3N_Live");

    if AAX3LL3N_Live then
        u17 = AAX3LL3N_Live:FindFirstChild("X3ll3nScene");
        local v19 = u17 and u17:FindFirstChild("ConcertAudio");

        if v19 then
            u18 = v19:FindFirstChild("AudioAnalyzer");
        end;
    end;
end;

function v1.Fire(p20, p21, p22) -- Line: 63
    -- upvalues: u2 (ref), u5 (ref), LaserSweep (copy), u6 (ref), StageLights (copy), u7 (ref), SpeakerShockwaves (copy), u8 (ref), DJAnimationController (copy), u9 (ref), LightCubeController (copy), u11 (ref), MusicNameDiffuserController (copy), u12 (ref), ConcertZoneController (copy), u13 (ref), ConcertOrbController (copy), u14 (ref), ConcertAnnouncementController (copy), u15 (ref), NeonPulseController (copy), u10 (ref), ConcertDirector (copy), u4 (ref), u17 (ref), Workspace (copy), u18 (ref), u3 (ref), RunService (copy), ConcertSharedConfig (copy), u16 (ref)
    if u2 then
        warn("[Concert] Session Concert déjà en cours, ignorer Fire()");

        return;
    end;

    u2 = true;
    warn("[Concert] Session Concert démarrée sur le client. isLateJoiner = " .. tostring(p22));
    u5 = LaserSweep.new({
        pattern = "Sweep"
    });
    u6 = StageLights.new({
        pattern = "ConcertScan",
        activeZone = "PublicZone"
    });
    u7 = SpeakerShockwaves.new();
    u8 = DJAnimationController.new();
    u9 = LightCubeController.new();
    u11 = MusicNameDiffuserController.new();
    u12 = ConcertZoneController.new();
    u13 = ConcertOrbController.new();
    u14 = ConcertAnnouncementController.new();
    u15 = NeonPulseController.new();
    u10 = ConcertDirector.new(u6, u5, u7, u8, u9, u11, u13, u14, p22);
    u4 = task.spawn(function() -- Line: 94
        -- upvalues: u2 (ref), u17 (ref), Workspace (ref), u18 (ref), u5 (ref), u6 (ref), u9 (ref), u11 (ref), u12 (ref), u13 (ref), u3 (ref), RunService (ref), u10 (ref), ConcertSharedConfig (ref), u15 (ref), u16 (ref)
        local v23 = 0;

        while u2 and (not u17 and v23 < 150) do
            local AAX3LL3N_Live = Workspace:FindFirstChild("AAX3LL3N_Live");

            if AAX3LL3N_Live then
                u17 = AAX3LL3N_Live:FindFirstChild("X3ll3nScene");
                local v24 = u17 and u17:FindFirstChild("ConcertAudio");

                if v24 then
                    u18 = v24:FindFirstChild("AudioAnalyzer");
                end;
            end;

            if not u17 then
                task.wait(0.1);
                v23 = v23 + 1;
            end;
        end;

        if not (u2 and u17) then
            warn("[Concert] Scène introuvable après timeout, laser/lights désactivés");

            return;
        end;

        u5:scan(u17);
        u6:scan(u17);
        u9:scan(u17);
        u11:scan(u17);
        u12:scan(u17);
        u13:scan(u17);
        u3 = RunService.Heartbeat:Connect(function(p25) -- Line: 118
            -- upvalues: u2 (ref), u18 (ref), u17 (ref), u10 (ref), ConcertSharedConfig (ref), u11 (ref), u12 (ref), u15 (ref), u16 (ref)
            if not u2 then
                return;
            end;

            local v26 = 0;
            local v27 = not (u18 and u18.Parent) and 0 or u18.PeakLevel;

            if u17 then
                local ConcertAudio = u17:FindFirstChild("ConcertAudio");

                if ConcertAudio then
                    local AudioPlayer = ConcertAudio:FindFirstChild("AudioPlayer");

                    if AudioPlayer then
                        local AssetId = AudioPlayer.AssetId;

                        if u10 and AssetId ~= "" then
                            if u10._currentAssetId == AssetId then
                                if u10._currentAudioPlayer ~= AudioPlayer then
                                    u10._currentAudioPlayer = AudioPlayer;
                                    warn("[Concert] Instance AudioPlayer mise à jour (même AssetId)");
                                end;
                            else
                                u10._currentAudioPlayer = AudioPlayer;
                                u10._currentAssetId = AssetId;

                                for _, v in ipairs(ConcertSharedConfig.ConcertMusic) do
                                    if v.AssetId == AssetId then
                                        u10:loadTrack(v.Metadata, v.Name, AudioPlayer.TimePosition);
                                        break;
                                    end;
                                end;
                            end;
                        end;

                        if AudioPlayer.IsReady then
                            v26 = AudioPlayer.TimePosition;
                            local LocalPlayer = game:GetService("Players").LocalPlayer;

                            if LocalPlayer then
                                if LocalPlayer:GetAttribute("AdminAbuseMuted") == true then
                                    if AudioPlayer.Volume ~= 0 then
                                        AudioPlayer.Volume = 0;
                                    end;
                                elseif AudioPlayer.Volume ~= 1 and v26 > 0.2 then
                                    AudioPlayer.Volume = 1;
                                end;
                            end;
                        end;
                    end;
                end;
            end;

            if u10 then
                u10:update(p25, v27, v26);
            end;

            if u11 then
                u11:update(p25);
            end;

            if u12 then
                u12:update(p25);
            end;

            if u15 then
                u15:update(p25);
            end;

            if v26 > 0 then
                u16 = u16 + p25;

                if u16 >= 0.5 then
                    u16 = 0;
                    print(string.format("[Concert Timeline] Temps de la piste en cours : %.1f s", v26));
                end;
            end;
        end);
    end);
end;

function v1.Stop(p28) -- Line: 207
    -- upvalues: u2 (ref), u4 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref), u10 (ref), u17 (ref), u18 (ref)
    warn("[Concert] Session Concert arrêtée sur le client");
    u2 = false;

    if u4 then
        task.cancel(u4);
        u4 = nil;
    end;

    if u3 then
        u3:Disconnect();
        u3 = nil;
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

    if u8 then
        u8:destroy();
        u8 = nil;
    end;

    if u9 then
        u9:destroy();
        u9 = nil;
    end;

    if u11 then
        u11:destroy();
        u11 = nil;
    end;

    if u12 then
        u12:destroy();
        u12 = nil;
    end;

    if u13 then
        u13:destroy();
        u13 = nil;
    end;

    if u14 then
        u14:destroy();
        u14 = nil;
    end;

    if u15 then
        u15:destroy();
        u15 = nil;
    end;

    if u10 then
        u10:destroy();
        u10 = nil;
    end;

    u17 = nil;
    u18 = nil;
end;

return v1;