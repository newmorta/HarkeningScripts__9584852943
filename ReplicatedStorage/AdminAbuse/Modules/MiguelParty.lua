-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.MiguelParty
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PartyEvent = require(script.Parent.Parent.PartyEvent);
local CCPulse = require(ReplicatedStorage.Utilities.Events.CCPulse);
local DanceSpawner = require(ReplicatedStorage.Utilities.Events.DanceSpawner);
local u1 = CCPulse.new({
    name = "MiguelParty"
});
local u2 = DanceSpawner.new({
    spinSpeed = 10,
    jumpFreq = 5,
    jumpHeight = 2
});
local v3 = PartyEvent.new({
    Sounds = { "rbxassetid://85271194133590" }
});

function v3.OnStart(p4, p5, p6, p7, p8) -- Line: 23
    -- upvalues: u1 (copy), ReplicatedStorage (copy), u2 (copy)
    u1:setup(p5.janitor);
    local Chickens = ReplicatedStorage.Assets.Events:FindFirstChild("Chickens");
    local Miguel = ReplicatedStorage.Assets.Events:FindFirstChild("Miguel");

    if not Chickens then
        warn("[MiguelParty] Folder \"Chickens\" introuvable dans ReplicatedStorage");

        return;
    end;

    if Miguel then
        u2:setup(p5.janitor, Chickens, Miguel);

        return;
    end;

    warn("[MiguelParty] Modèle \"Miguel\" introuvable dans ReplicatedStorage");
end;

function v3.OnRender(p9, p10, p11, p12, p13, p14) -- Line: 38
    -- upvalues: u1 (copy), u2 (copy)
    u1:update(p11);
    u2:update(p11);
end;

function v3.OnStop(p15, p16) -- Line: 43
end;

return v3;