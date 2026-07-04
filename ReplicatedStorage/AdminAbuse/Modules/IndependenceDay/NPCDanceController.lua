-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.IndependenceDay.NPCDanceController
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local IndependenceDayConfig = require(script.Parent.IndependenceDayConfig);
local IndependenceDayCutscenes = require(script.Parent.IndependenceDayCutscenes);
local u1 = {};
local u2 = {};
local u3 = nil;

local function buildState(p4) -- Line: 39
    -- upvalues: IndependenceDayConfig (copy), IndependenceDayCutscenes (copy)
    local v5 = {};

    for _, v in IndependenceDayConfig.ANIM_IDS.NPCDances do
        local v6 = IndependenceDayCutscenes.loadTrack(p4, v);

        if v6 then
            v6.Looped = true;
            table.insert(v5, v6);
        end;
    end;

    if #v5 ~= 0 then
        return {
            currentIndex = nil,
            timeSinceLastChange = 0,
            rig = p4,
            tracks = v5,
            nextChangeDuration = math.random(IndependenceDayConfig.NPC_DANCE_SWITCH_MIN_SEC, IndependenceDayConfig.NPC_DANCE_SWITCH_MAX_SEC)
        };
    end;

    warn("[NPCDanceController] No dance tracks loaded for", p4:GetFullName());

    return nil;
end;

local function pickNextIndex(p7, p8) -- Line: 66
    local v9 = math.random(1, #p7);

    if v9 == p8 and #p7 > 1 then
        if v9 == #p7 then
            return v9 - 1;
        end;

        v9 = v9 + 1;
    end;

    return v9;
end;

local function playIndex(p10, p11) -- Line: 77
    if p10.currentIndex then
        local v12 = p10.tracks[p10.currentIndex];

        if v12.IsPlaying then
            v12:Stop(0.25);
        end;
    end;

    p10.tracks[p11]:Play(0.25);
    p10.currentIndex = p11;
end;

function u1.Start(p13) -- Line: 88
    -- upvalues: u1 (copy), buildState (copy), u2 (copy), u3 (ref), RunService (copy), IndependenceDayConfig (copy)
    if not p13 then
        warn("[NPCDanceController.Start - Missing mapClone arg]");

        return;
    end;

    u1.Stop();
    local v14 = p13:FindFirstChild("Scriptables") and v14:FindFirstChild("NPCs");

    if not v14 then
        warn("[NPCDanceController.Start - Scriptables/NPCs not found]");

        return;
    end;

    for _, child in v14:GetChildren() do
        if child:IsA("Model") then
            local v15 = buildState(child);

            if v15 then
                local v16 = math.random(1, #v15.tracks);

                if v15.currentIndex then
                    local v17 = v15.tracks[v15.currentIndex];

                    if v17.IsPlaying then
                        v17:Stop(0.25);
                    end;
                end;

                v15.tracks[v16]:Play(0.25);
                v15.currentIndex = v16;
                table.insert(u2, v15);
            end;
        end;
    end;

    if #u2 == 0 then
        warn("[NPCDanceController.Start - No NPC rigs found under Scriptables/NPCs]");

        return;
    end;

    u3 = RunService.Heartbeat:Connect(function(p18) -- Line: 119
        -- upvalues: u2 (ref), IndependenceDayConfig (ref)
        for _, v in u2 do
            v.timeSinceLastChange = v.timeSinceLastChange + p18;

            if v.timeSinceLastChange >= v.nextChangeDuration then
                v.timeSinceLastChange = 0;
                v.nextChangeDuration = math.random(IndependenceDayConfig.NPC_DANCE_SWITCH_MIN_SEC, IndependenceDayConfig.NPC_DANCE_SWITCH_MAX_SEC);
                local tracks = v.tracks;
                local currentIndex = v.currentIndex;
                local v19 = math.random(1, #tracks);

                if v19 == currentIndex and #tracks > 1 then
                    if v19 == #tracks then
                        v19 = v19 - 1;
                    else
                        v19 = v19 + 1;
                    end;
                end;

                if v.currentIndex then
                    local v20 = v.tracks[v.currentIndex];

                    if v20.IsPlaying then
                        v20:Stop(0.25);
                    end;
                end;

                v.tracks[v19]:Play(0.25);
                v.currentIndex = v19;
            end;
        end;
    end);
end;

function u1.Stop() -- Line: 136
    -- upvalues: u3 (ref), u2 (copy)
    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    for _, v in u2 do
        for _, v2 in v.tracks do
            if v2.IsPlaying then
                v2:Stop(0);
            end;
        end;
    end;

    table.clear(u2);
end;

return u1;