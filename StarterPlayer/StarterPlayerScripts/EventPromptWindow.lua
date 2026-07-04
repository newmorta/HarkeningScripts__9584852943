-- Ruta Original: StarterPlayer.StarterPlayerScripts.EventPromptWindow
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local SocialService = game:GetService("SocialService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local EventRsvpId = ReplicatedStorage:WaitForChild("EventRsvpId", 10);

if not EventRsvpId or EventRsvpId.Value == "" then
    warn("[EventRsvpPrompt] No event_id available, script disabled");

    return;
end;

local Value = EventRsvpId.Value;
local ClaimRsvpBoost = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ClaimRsvpBoost", 10);
local LocalPlayer = Players.LocalPlayer;
local u1 = false;
local u2 = false;
local u3 = false;

local function tryClaimBoost() -- Line: 22
    -- upvalues: u3 (ref), ClaimRsvpBoost (copy)
    if u3 or not ClaimRsvpBoost then
        return;
    end;

    u3 = true;
    ClaimRsvpBoost:FireServer();
end;

local function promptRSVP() -- Line: 28
    -- upvalues: u2 (ref), SocialService (copy), Value (copy), u3 (ref), ClaimRsvpBoost (copy)
    if u2 then
        return;
    end;

    u2 = true;
    local success, result = pcall(function() -- Line: 32
        -- upvalues: SocialService (ref), Value (ref)
        return SocialService:GetEventRsvpStatusAsync(Value);
    end);

    if not success then
        warn("[EventRsvpPrompt] Failed to get RSVP status:", result);
        u2 = false;

        return;
    end;

    if result == Enum.RsvpStatus.Going then
        if not u3 and ClaimRsvpBoost then
            u3 = true;
            ClaimRsvpBoost:FireServer();
        end;

        u2 = false;

        return;
    end;

    local success2, result2 = pcall(function() -- Line: 48
        -- upvalues: SocialService (ref), Value (ref)
        return SocialService:PromptRsvpToEventAsync(Value);
    end);

    if not success2 then
        warn("[EventRsvpPrompt] RSVP prompt failed:", result2);
        u2 = false;

        return;
    end;

    local success3, result3 = pcall(function() -- Line: 59
        -- upvalues: SocialService (ref), Value (ref)
        return SocialService:GetEventRsvpStatusAsync(Value);
    end);

    if success3 and (result3 == Enum.RsvpStatus.Going and (not u3 and ClaimRsvpBoost)) then
        u3 = true;
        ClaimRsvpBoost:FireServer();
    end;

    u2 = false;
end;

task.spawn(function() -- Line: 71
    -- upvalues: SocialService (copy), Value (copy), u3 (ref), ClaimRsvpBoost (copy)
    task.wait(3);
    local success, result = pcall(function() -- Line: 73
        -- upvalues: SocialService (ref), Value (ref)
        return SocialService:GetEventRsvpStatusAsync(Value);
    end);

    if success and (result == Enum.RsvpStatus.Going and not u3) then
        if not ClaimRsvpBoost then
            return;
        end;

        u3 = true;
        ClaimRsvpBoost:FireServer();
    end;
end);

local function onZoneTouched(p4) -- Line: 81
    -- upvalues: u1 (ref), LocalPlayer (copy), promptRSVP (copy)
    if u1 then
        return;
    end;

    local Character = LocalPlayer.Character;

    if not (Character and p4:IsDescendantOf(Character)) then
        return;
    end;

    u1 = true;
    task.spawn(promptRSVP);
end;

local function connectZone(p5) -- Line: 89
    -- upvalues: onZoneTouched (copy)
    p5.Touched:Connect(onZoneTouched);
end;

for _, v in ipairs(CollectionService:GetTagged("EventRSVPzone")) do
    v.Touched:Connect(onZoneTouched);
end;

CollectionService:GetInstanceAddedSignal("EventRSVPzone"):Connect(connectZone);

local function connectPrompt(p6) -- Line: 98
    -- upvalues: LocalPlayer (copy), promptRSVP (copy)
    if not p6:IsA("ProximityPrompt") then
        return;
    end;

    p6.Triggered:Connect(function(p7) -- Line: 100
        -- upvalues: LocalPlayer (ref), promptRSVP (ref)
        if p7 ~= LocalPlayer then
            return;
        end;

        task.spawn(promptRSVP);
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("EventRSVPbutton")) do
    if v:IsA("ProximityPrompt") then
        v.Triggered:Connect(function(p8) -- Line: 100
            -- upvalues: LocalPlayer (copy), promptRSVP (copy)
            if p8 ~= LocalPlayer then
                return;
            end;

            task.spawn(promptRSVP);
        end);
    end;
end;

CollectionService:GetInstanceAddedSignal("EventRSVPbutton"):Connect(connectPrompt);
task.delay(600, function() -- Line: 111
    -- upvalues: u1 (ref), promptRSVP (copy)
    if not u1 then
        u1 = true;
        promptRSVP();
    end;
end);