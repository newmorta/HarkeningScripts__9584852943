-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.ChickenParty
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PartyEvent = require(script.Parent.Parent.PartyEvent);
local CCPulse = require(ReplicatedStorage.Utilities.Events.CCPulse);
local DanceSpawner = require(ReplicatedStorage.Utilities.Events.DanceSpawner);
local u1 = CCPulse.new({
    name = "ChickenParty"
});
local u2 = DanceSpawner.new({
    spinSpeed = 10,
    jumpFreq = 5,
    jumpHeight = 2
});
local v3 = PartyEvent.new({
    Sounds = { "rbxassetid://125594614959452" }
});

function v3.OnStart(p4, p5, p6, p7, p8) -- Line: 22
    -- upvalues: u1 (copy), ReplicatedStorage (copy), u2 (copy)
    u1:setup(p5.janitor);
    local Chickens = ReplicatedStorage.Assets.Events:FindFirstChild("Chickens");

    if not Chickens then
        warn("[ChickenParty] Folder \"Chickens\" introuvable dans ReplicatedStorage");
    end;

    u2:setup(p5.janitor, Chickens);
end;

function v3.OnRender(p9, p10, p11, p12, p13, p14) -- Line: 32
    -- upvalues: u1 (copy), u2 (copy)
    u1:update(p11);
    u2:update(p11);
end;

function v3.OnStop(p15, p16) -- Line: 37
end;

return v3;