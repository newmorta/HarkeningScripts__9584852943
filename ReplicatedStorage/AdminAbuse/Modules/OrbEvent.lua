-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.OrbEvent
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PartyEvent = require(script.Parent.Parent.PartyEvent);
local OrbEvent = require(ReplicatedStorage:WaitForChild("EventsConfig")).OrbEvent;
local v1 = PartyEvent.new({
    RequiresRespawnRefire = true,
    DisplayName = OrbEvent.DisplayName,
    MaxDurationSeconds = OrbEvent.MaxDurationSeconds,
    DefaultDurationSeconds = OrbEvent.DefaultDurationSeconds,
    NeedsDuration = OrbEvent.NeedsDuration,
    SkipDoorTransition = OrbEvent.SkipDoorTransition,
    IsAdminAbuse = OrbEvent.IsAdminAbuse,
    Sounds = OrbEvent.Sounds
});

function v1.OnStart(p2, p3, p4, p5, p6) -- Line: 19
    -- upvalues: OrbEvent (copy), Lighting (copy)
    local ClientColorCorrection = OrbEvent.ClientColorCorrection;
    local v7 = p3.janitor:Add(Instance.new("ColorCorrectionEffect"));
    v7.Name = "OrbEventColorCorrection";
    v7.Brightness = ClientColorCorrection.Brightness;
    v7.Contrast = ClientColorCorrection.Contrast;
    v7.Saturation = ClientColorCorrection.Saturation;
    local TintColor = ClientColorCorrection.TintColor;
    v7.TintColor = Color3.fromRGB(TintColor[1], TintColor[2], TintColor[3]);
    v7.Parent = Lighting;
end;

return v1;