-- Ruta Original: ReplicatedStorage.Utilities.Events.ConcertDirector
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local Debris = game:GetService("Debris");
local SoundService = game:GetService("SoundService");

local function ema(p2, p3, p4, p5) -- Line: 22
    return p2 + (1 - math.exp(-p4 * p5)) * (p3 - p2);
end;

local u6 = { "NoGravity", "Spinning", "ChickenParty", "FastDay" };

local function updateStateValue(p7, p8) -- Line: 29
    local ConcertState = game:GetService("Workspace"):FindFirstChild("ConcertState");

    if not ConcertState then
        ConcertState = Instance.new("Folder");
        ConcertState.Name = "ConcertState";
        ConcertState.Parent = game:GetService("Workspace");
    end;

    local v9 = ConcertState:FindFirstChild(p7);

    if not v9 then
        v9 = Instance.new("BoolValue");
        v9.Name = p7;
        v9.Parent = ConcertState;
    end;

    v9.Value = p8;
    warn(string.format("[ConcertDirector StateDbg] %s défini à %s", p7, (tostring(p8))));
end;

local function getCurrentStateValue(p10) -- Line: 46
    local ConcertState = game:GetService("Workspace"):FindFirstChild("ConcertState");

    if ConcertState then
        local v11 = ConcertState:FindFirstChild(p10);

        if v11 and v11:IsA("BoolValue") then
            return v11.Value;
        end;
    end;

    return false;
end;

local u12 = {
    Low = { "SkyRise", "AudienceSweep", "Wave" },
    Medium = { "AudienceSweep", "Fan", "Mirror", "ConcertScan" },
    High = { "Cross", "Wave", "Alternating", "ConcertScan" },
    Drop = { "Fan", "Cross", "AudienceSweep", "Alternating" }
};

function u1.new(p13, p14, p15, p16, p17, p18, p19, p20, p21) -- Line: 79
    -- upvalues: u1 (copy)
    local v22 = setmetatable({}, u1);
    v22._stageLights = p13;
    v22._laserSweep = p14;
    v22._speakerShockwaves = p15;
    v22._djController = p16;
    v22._lightCubeController = p17;
    v22._musicNameDiffuserController = p18;
    v22._concertOrbController = p19;
    v22._concertAnnouncementController = p20;
    v22._energySlow = 0;
    v22._energyFast = 0;
    v22._currentPattern = "ConcertScan";
    v22._timeSinceLastChange = 0;
    v22._nextChangeDuration = math.random(8, 15);
    v22._currentAudioPlayer = nil;
    v22._currentAssetId = nil;
    v22._localTimePosition = nil;
    v22._lastServerTimePosition = nil;
    v22._executedCues = {};
    v22._joinTimePosition = 0;
    v22._trackCues = nil;
    v22._currentCueIndex = 1;
    v22._manualModeActive = false;
    v22._isFirstTrackLoaded = false;
    v22._isLateJoiner = p21 == true;

    return v22;
end;

function u1.loadTrack(p23, p24, p25, p26) -- Line: 117
    -- upvalues: u6 (copy), updateStateValue (copy)
    if p23._musicNameDiffuserController and p25 then
        p23._musicNameDiffuserController:setSongName(p25);
    end;

    local v27 = p26 or 0;

    if not p24 or (not p24.Cues or #p24.Cues <= 0) then
        p23._trackCues = nil;
        p23._localTimePosition = nil;
        p23._lastServerTimePosition = nil;
        p23._manualModeActive = false;

        if p23._djController then
            p23._djController:setMode("Automatic");
        end;

        return;
    end;

    p23._trackCues = {};

    for _, v in ipairs(p24.Cues) do
        table.insert(p23._trackCues, v);
    end;

    table.sort(p23._trackCues, function(p28, p29) -- Line: 129
        return p28.Time < p29.Time;
    end);
    warn(string.format("[ConcertDirector LoadTrack] Cues de la track chargées : %d cues.", #p23._trackCues));

    for i, v in ipairs(p23._trackCues) do
        warn(string.format("  - Cue %d: Time=%.1fs, Action=%s, NoGravity=%s, Text=%s, SpawnOrbs=%s", i, v.Time, tostring(v.Action), tostring(v.NoGravity), tostring(v.Text), (tostring(v.SpawnOrbs))));
    end;

    local v30 = {};

    for _, v in ipairs(u6) do
        local ConcertState = game:GetService("Workspace"):FindFirstChild("ConcertState");
        local v31;

        if ConcertState then
            local v32 = ConcertState:FindFirstChild(v);

            if v32 and v32:IsA("BoolValue") then
                v31 = v32.Value;
            else
                v31 = false;
            end;
        else
            v31 = false;
        end;

        v30[v] = v31;
    end;

    local v33 = nil;
    local v34 = false;

    if not p23._isFirstTrackLoaded then
        p23._isFirstTrackLoaded = true;
        v34 = p23._isLateJoiner and v27 > 2 and true or v34;
    end;

    if v34 then
        warn(string.format("[ConcertDirector LoadTrack] Premier chargement (Late-Join) à %.2f s. Recherche des cues antérieures...", v27));
        local v35 = 1;

        for i, v in ipairs(p23._trackCues) do
            if v.Time > v27 then
                break;
            end;

            for _, v2 in ipairs(u6) do
                if v[v2] ~= nil then
                    v30[v2] = v[v2];
                end;
            end;

            if v.Action ~= nil then
                v33 = v.Action;
            end;

            v35 = i + 1;
        end;

        p23._currentCueIndex = v35;
        p23._localTimePosition = v27;
        p23._lastServerTimePosition = v27;
        p23._executedCues = {};
        p23._joinTimePosition = v27;

        for i, v in ipairs(p23._trackCues) do
            if v.Time < v27 then
                p23._executedCues[i] = true;
            end;
        end;

        warn("[ConcertDirector] Chargement de " .. #p23._trackCues .. " cues (commence à la cue " .. v35 .. " au temps " .. v27 .. "s).");

        if v33 then
            if v33 == "Automatic" then
                if p23._djController then
                    p23._djController:setMode("Automatic");
                end;
            else
                if p23._stageLights then
                    p23._stageLights:setPattern(v33);
                end;

                if p23._laserSweep then
                    p23._laserSweep:setPattern(v33);
                end;

                if p23._lightCubeController then
                    p23._lightCubeController:setPattern(v33);
                end;

                if p23._djController then
                    if v33 == "SkyRise" or (v33 == "AudienceSweep" or (v33 == "Mirror" or (v33 == "Blackout" or v33 == "Fan"))) then
                        p23._djController:setMode("ForcedIdle");
                    else
                        p23._djController:setMode("ForcedVibe");
                    end;
                end;
            end;
        end;
    else
        warn(string.format("[ConcertDirector LoadTrack] Chargement normal de la piste. Lecture depuis le début (0.0s). Temps serveur actuel: %.2f s", v27));
        p23._currentCueIndex = 1;
        p23._localTimePosition = 0;
        p23._lastServerTimePosition = 0;
        p23._executedCues = {};
        p23._joinTimePosition = 0;
        warn("[ConcertDirector] Chargement de " .. #p23._trackCues .. " cues (lecture depuis le début).");
    end;

    warn(string.format("[ConcertDirector LoadTrack] Analyse de départ terminée. startIndex=%d", p23._currentCueIndex));

    for _, v in ipairs(u6) do
        updateStateValue(v, v30[v]);
    end;

    if v33 == "Automatic" then
        p23._manualModeActive = false;

        return;
    end;

    p23._manualModeActive = true;
end;

function u1._executeCue(p36, p37) -- Line: 234
    -- upvalues: u6 (copy), updateStateValue (copy), SoundService (copy), Debris (copy)
    warn(string.format("[ConcertDirector] Exécution de la Cue: %s à %.1fs", tostring(p37.Action), p37.Time));

    for _, v in ipairs(u6) do
        if p37[v] ~= nil then
            updateStateValue(v, p37[v]);
        end;
    end;

    if p37.SpawnOrbs ~= nil and p36._concertOrbController then
        p36._concertOrbController:spawnOrbs(p37.SpawnOrbs);
    end;

    if p37.PlayHorn ~= nil and p37.PlayHorn ~= false then
        local v38;

        if p37.PlayHorn == 1 then
            v38 = "rbxassetid://5671650124";
        elseif p37.PlayHorn == 2 then
            v38 = "rbxassetid://121104033043165";
        elseif type(p37.PlayHorn) == "string" then
            v38 = string.find(p37.PlayHorn, "121104033043165") and "rbxassetid://121104033043165" or (string.find(p37.PlayHorn, "5671650124") and "rbxassetid://5671650124" or p37.PlayHorn);
        else
            local v39 = { "rbxassetid://5671650124", "rbxassetid://121104033043165" };
            v38 = v39[math.random(1, #v39)];
        end;

        local Sound = Instance.new("Sound");
        Sound.SoundId = v38;
        Sound.Volume = 0.5;
        Sound.Looped = false;
        Sound.Parent = SoundService;
        Sound:Play();
        Debris:AddItem(Sound, 10);
        warn(string.format("[ConcertDirector] Joue le son de corne : %s", v38));
    end;

    if p37.Text ~= nil and p36._concertAnnouncementController then
        p36._concertAnnouncementController:showText(p37.Text);
    end;

    if p37.FlyText ~= nil and p36._concertAnnouncementController then
        p36._concertAnnouncementController:showFlyText(p37.FlyText);
    end;

    if p37.LuckyText ~= nil and p36._concertAnnouncementController then
        p36._concertAnnouncementController:showLuckyText(p37.LuckyText);
    end;

    if p37.LokiText ~= nil and p36._concertAnnouncementController then
        p36._concertAnnouncementController:showLokiText(p37.LokiText);
    end;

    local Action = p37.Action;

    if not Action then
        return;
    end;

    if Action == "Automatic" then
        p36._manualModeActive = false;

        if p36._djController then
            p36._djController:setMode("Automatic");
        end;

        return;
    end;

    if p36._stageLights then
        p36._stageLights:setPattern(Action);
    end;

    if p36._laserSweep then
        p36._laserSweep:setPattern(Action);
    end;

    if p36._lightCubeController then
        p36._lightCubeController:setPattern(Action);
    end;

    if p36._djController then
        if Action == "SkyRise" or (Action == "AudienceSweep" or (Action == "Mirror" or (Action == "Blackout" or Action == "Fan"))) then
            p36._djController:setMode("ForcedIdle");

            return;
        end;

        p36._djController:setMode("ForcedVibe");
    end;
end;

function u1._pickRandomPattern(p40, p41) -- Line: 323
    -- upvalues: u12 (copy)
    local v42 = u12[p41] or u12.Medium;
    local v43 = v42[math.random(1, #v42)];

    if v43 == p40._currentPattern and #v42 > 1 then
        for _, v in ipairs(v42) do
            if v ~= p40._currentPattern then
                return v;
            end;
        end;
    end;

    return v43;
end;

function u1.update(p44, p45, p46, p47) -- Line: 340
    -- upvalues: u6 (copy), updateStateValue (copy)
    local v48 = p46 or 0;
    local v49 = p47 or 0;

    if p44._manualModeActive and p44._trackCues then
        local v50;

        if p44._lastServerTimePosition and math.abs(v49 - p44._lastServerTimePosition) <= 0.001 then
            v50 = false;
        else
            p44._lastServerTimePosition = v49;
            v50 = true;
        end;

        if v50 then
            local v51 = p44._localTimePosition and (v49 - p44._localTimePosition or 0) or 0;

            if math.abs(v51) > 0.5 then
                local _localTimePosition = p44._localTimePosition;
                local _currentCueIndex = p44._currentCueIndex;
                warn(string.format("[ConcertDirector Resync] Jump détecté ! Ancien temps local: %s s, Nouveau temps serveur: %.2f s, Dérive: %.2f s", tostring(_localTimePosition), v49, v51));

                if v51 < -0.5 then
                    warn("[ConcertDirector Resync] Retour en arrière détecté. Conservation des flags d\'exécution (ne jamais rejouer les mêmes cues).");
                elseif v51 > 0.5 then
                    warn(string.format("[ConcertDirector Resync] Saut en avant détecté. Rattrapage des cues entre %s s et %.2f s...", tostring(_localTimePosition), v49));

                    for i = p44._currentCueIndex, #p44._trackCues do
                        local v52 = p44._trackCues[i];

                        if not v52 or v52.Time > v49 then
                            break;
                        end;

                        if not p44._executedCues[i] then
                            if v49 - v52.Time <= 5 then
                                warn(string.format("[ConcertDirector Resync] Rattrapage de la Cue %d (%s) à %.1f s", i, tostring(v52.Action), v52.Time));
                                p44:_executeCue(v52);
                            else
                                warn(string.format("[ConcertDirector Resync] Cue %d (%s) trop ancienne (retard de %.1fs), ignorée pour éviter le flood.", i, tostring(v52.Action), v49 - v52.Time));
                            end;

                            p44._executedCues[i] = true;
                        end;
                    end;
                end;

                local v53 = {};

                for _, v in ipairs(u6) do
                    local ConcertState = game:GetService("Workspace"):FindFirstChild("ConcertState");
                    local v54;

                    if ConcertState then
                        local v55 = ConcertState:FindFirstChild(v);

                        if v55 and v55:IsA("BoolValue") then
                            v54 = v55.Value;
                        else
                            v54 = false;
                        end;
                    else
                        v54 = false;
                    end;

                    v53[v] = v54;
                end;

                local v56 = nil;
                local v57 = 1;

                if v49 > 2 then
                    for i, v in ipairs(p44._trackCues) do
                        if v.Time > v49 then
                            break;
                        end;

                        for _, v2 in ipairs(u6) do
                            if v[v2] ~= nil then
                                v53[v2] = v[v2];
                            end;
                        end;

                        if v.Action ~= nil then
                            v56 = v.Action;
                        end;

                        v57 = i + 1;
                    end;
                end;

                p44._currentCueIndex = v57;
                warn(string.format("[ConcertDirector Resync] Index de cue mis à jour: %d -> %d (startIndex=%d)", _currentCueIndex, p44._currentCueIndex, v57));

                for _, v in ipairs(u6) do
                    updateStateValue(v, v53[v]);
                end;

                if v56 then
                    if v56 == "Automatic" then
                        p44._manualModeActive = false;

                        if p44._djController then
                            p44._djController:setMode("Automatic");
                        end;
                    else
                        p44._manualModeActive = true;

                        if p44._stageLights then
                            p44._stageLights:setPattern(v56);
                        end;

                        if p44._laserSweep then
                            p44._laserSweep:setPattern(v56);
                        end;

                        if p44._lightCubeController then
                            p44._lightCubeController:setPattern(v56);
                        end;

                        if p44._djController then
                            if v56 == "SkyRise" or (v56 == "AudienceSweep" or (v56 == "Mirror" or (v56 == "Blackout" or v56 == "Fan"))) then
                                p44._djController:setMode("ForcedIdle");
                            else
                                p44._djController:setMode("ForcedVibe");
                            end;
                        end;
                    end;
                end;
            end;

            p44._localTimePosition = v49;
        elseif p44._localTimePosition then
            p44._localTimePosition = p44._localTimePosition + p45;
        else
            p44._localTimePosition = v49;
        end;

        local v58 = p44._trackCues[p44._currentCueIndex];

        while v58 and v58.Time <= p44._localTimePosition do
            local _currentCueIndex = p44._currentCueIndex;

            if not p44._executedCues[_currentCueIndex] then
                p44._executedCues[_currentCueIndex] = true;
                p44:_executeCue(v58);
            end;

            p44._currentCueIndex = p44._currentCueIndex + 1;
            v58 = p44._trackCues[p44._currentCueIndex];
        end;
    end;

    local _energySlow = p44._energySlow;
    p44._energySlow = _energySlow + (1 - math.exp(p45 * -0.5)) * (v48 - _energySlow);
    local _energyFast = p44._energyFast;
    p44._energyFast = _energyFast + (1 - math.exp(p45 * -5)) * (v48 - _energyFast);
    local v59 = p44._energyFast > 0.85 and p44._energySlow > 0.4 and "Drop" or (p44._energySlow > 0.65 and "High" or (p44._energySlow > 0.35 and "Medium" or "Low"));

    if not p44._manualModeActive then
        p44._timeSinceLastChange = p44._timeSinceLastChange + p45;

        if p44._timeSinceLastChange >= p44._nextChangeDuration or v59 == "Drop" and (p44._energyFast > 0.9 and (p44._timeSinceLastChange > 3 and (p44._currentPattern == "SkyRise" or p44._currentPattern == "Wave"))) then
            p44._timeSinceLastChange = 0;

            if v59 == "Low" then
                p44._nextChangeDuration = math.random(10, 20);
            elseif v59 == "Medium" then
                p44._nextChangeDuration = math.random(8, 15);
            elseif v59 == "High" then
                p44._nextChangeDuration = math.random(6, 12);
            elseif v59 == "Drop" then
                p44._nextChangeDuration = math.random(4, 8);
            end;

            local v60 = p44:_pickRandomPattern(v59);
            p44._currentPattern = v60;

            if p44._stageLights then
                p44._stageLights:setPattern(v60);
            end;

            if p44._laserSweep then
                p44._laserSweep:setPattern(v60);
            end;

            if p44._lightCubeController then
                p44._lightCubeController:setPattern(v60);
            end;
        end;
    end;

    if p44._stageLights then
        p44._stageLights:update(p45, v48);
    end;

    if p44._laserSweep then
        p44._laserSweep:update(p45, v48);
    end;

    if p44._speakerShockwaves then
        p44._speakerShockwaves:update(p45, v48);
    end;

    if p44._djController then
        p44._djController:update(p45, v48);
    end;

    if p44._lightCubeController then
        p44._lightCubeController:update(p45);
    end;
end;

function u1.destroy(p61) -- Line: 536
    local ConcertState = game:GetService("Workspace"):FindFirstChild("ConcertState");

    if ConcertState then
        ConcertState:Destroy();
    end;
end;

return u1;