-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.GoldenRain
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PartyEvent = require(script.Parent.Parent.PartyEvent);
local GoldenRain = require(ReplicatedStorage:WaitForChild("EventsConfig")).GoldenRain;

return PartyEvent.new({
    RequiresRespawnRefire = true,
    DisplayName = GoldenRain.DisplayName,
    MaxDurationSeconds = GoldenRain.MaxDurationSeconds,
    DefaultDurationSeconds = GoldenRain.DefaultDurationSeconds,
    NeedsDuration = GoldenRain.NeedsDuration,
    SkipDoorTransition = GoldenRain.SkipDoorTransition,
    IsAdminAbuse = GoldenRain.IsAdminAbuse,
    Sounds = GoldenRain.Sounds
});