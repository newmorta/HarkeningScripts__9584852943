-- Ruta Original: ReplicatedStorage.AdminAbuse.PartyEvent
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local SoundService = game:GetService("SoundService");
local Janitor = require(script.Parent.Parent.Utilities.Janitor);
local SoundFade = require(script.Parent.Parent.Utilities.Events.SoundFade);
local u1 = {
    MaxDurationSeconds = 1200,
    DefaultDurationSeconds = 600,
    NeedsDuration = true,
    RequiresRespawnRefire = true,
    SkipDoorTransition = true,
    IsAdminAbuse = false,
    Sounds = {}
};
local u2 = {};
u2.__index = u2;

function u2.new(p3) -- Line: 31
    -- upvalues: u2 (copy), u1 (copy)
    local v4 = setmetatable({}, u2);

    for i, v in u1 do
        v4[i] = v;
    end;

    if p3 then
        for i, v in p3 do
            v4[i] = v;
        end;
    end;

    v4._activeSession = nil;
    v4._sound = nil;
    v4._soundFader = nil;
    v4._soundEndedConn = nil;
    v4._priorityLocked = false;

    return v4;
end;

function u2._ensureSound(u5) -- Line: 60
    -- upvalues: SoundService (copy), SoundFade (copy)
    if u5._sound then
        return;
    end;

    local u6 = type(u5.Sounds) ~= "table" and {} or u5.Sounds;

    if #u6 == 0 then
        return;
    end;

    local Sound = Instance.new("Sound");
    Sound.Volume = 0;
    Sound.Looped = false;
    Sound:SetAttribute("IsEventSound", true);
    Sound.Parent = SoundService;
    local u7 = nil;

    local function pickNext() -- Line: 74
        -- upvalues: u6 (copy), u7 (ref)
        if #u6 == 1 then
            return u6[1];
        end;

        local v8;

        repeat
            v8 = u6[math.random(1, #u6)];
        until v8 ~= u7;

        return v8;
    end;

    local function playNext() -- Line: 82
        -- upvalues: pickNext (copy), u7 (ref), Sound (copy)
        local v9 = pickNext();
        u7 = v9;
        Sound.SoundId = v9;
        Sound.TimePosition = 0;
        Sound:Play();
    end;

    u5._soundEndedConn = Sound.Ended:Connect(function() -- Line: 91
        -- upvalues: u5 (copy), pickNext (copy), u7 (ref), Sound (copy)
        if u5._activeSession then
            local v10 = pickNext();
            u7 = v10;
            Sound.SoundId = v10;
            Sound.TimePosition = 0;
            Sound:Play();
        end;
    end);
    u5._soundFader = SoundFade.new(Sound, {
        fadeIn = 0.5,
        fadeOut = 1,
        volume = 0.8
    });
    u5._sound = Sound;
    u5._playNextSound = playNext;
end;

function u2.Stop(p11) -- Line: 102
    local _activeSession = p11._activeSession;

    if not _activeSession then
        return;
    end;

    if _activeSession.connection then
        _activeSession.connection:Disconnect();
        _activeSession.connection = nil;
    end;

    if p11._soundFader and p11._sound then
        local _sound = p11._sound;
        p11._soundFader:fadeOut(function() -- Line: 117
            -- upvalues: _sound (copy)
            if _sound.Parent then
                _sound:Stop();
            end;
        end);
    end;

    if p11.OnStop then
        p11:OnStop(_activeSession);
    end;

    _activeSession.janitor:Cleanup();
    p11._activeSession = nil;
end;

function u2.Fire(u12) -- Line: 133
    -- upvalues: Players (copy), Janitor (copy), RunService (copy)
    u12:Stop();
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return;
    end;

    local u13 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
    local HumanoidRootPart = u13:WaitForChild("HumanoidRootPart", 30);

    if not HumanoidRootPart then
        return;
    end;

    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        workspace:GetPropertyChangedSignal("CurrentCamera"):Wait();
        CurrentCamera = workspace.CurrentCamera;
    end;

    if not CurrentCamera then
        return;
    end;

    local u14 = {
        connection = nil,
        janitor = Janitor.new()
    };
    u12._activeSession = u14;
    u12:_ensureSound();

    if u12._sound then
        if not u12._sound.IsPlaying then
            u12._playNextSound();
        end;

        if not u12._priorityLocked then
            u12._soundFader:fadeIn();
        end;
    end;

    if u12.OnStart then
        u12:OnStart(u14, u13, HumanoidRootPart, CurrentCamera);
    end;

    u14.connection = RunService.RenderStepped:Connect(function() -- Line: 174
        -- upvalues: u12 (copy), u14 (copy), u13 (copy), HumanoidRootPart (copy)
        if u12._activeSession ~= u14 then
            if u14.connection then
                u14.connection:Disconnect();
            end;

            return;
        end;

        if not (u13.Parent and HumanoidRootPart.Parent) then
            u12:Stop();

            return;
        end;

        local CurrentCamera2 = workspace.CurrentCamera;

        if not CurrentCamera2 then
            return;
        end;

        if u12.OnRender then
            u12:OnRender(u14, os.clock(), u13, HumanoidRootPart, CurrentCamera2);
        end;
    end);
end;

function u2.SetPriorityLocked(p15, p16) -- Line: 200
    if p15._priorityLocked == p16 then
        return;
    end;

    p15._priorityLocked = p16;

    if not (p15._activeSession and p15._sound) then
        return;
    end;

    if p16 then
        p15._soundFader:fadeOut();

        return;
    end;

    p15._soundFader:fadeIn();
end;

function u2.Destroy(p17) -- Line: 215
    p17:Stop();

    if p17._soundEndedConn then
        p17._soundEndedConn:Disconnect();
        p17._soundEndedConn = nil;
    end;

    if p17._sound then
        p17._sound:Destroy();
        p17._sound = nil;
        p17._soundFader = nil;
    end;
end;

return u2;