-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.Party
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PartyEvent = require(script.Parent.Parent.PartyEvent);
local u1 = require(ReplicatedStorage.Utilities.Events.Spotlight).new({
    colorSpeed = 0.12,
    range = 30,
    speed = 1.5,
    ccSpeed = 0.06,
    cameraOffset = CFrame.new(0, 20, -50)
});
local v2 = PartyEvent.new({
    MaxDurationSeconds = 1200,
    DefaultDurationSeconds = 600,
    NeedsDuration = true,
    RequiresRespawnRefire = true,
    SkipDoorTransition = true,
    IsAdminAbuse = false,
    Sounds = { "rbxassetid://140074993424765", "rbxassetid://5410080857", "rbxassetid://127447678350704", "rbxassetid://7024280102", "rbxassetid://7024245182" }
});

function v2.OnStart(p3, p4, p5, p6, p7) -- Line: 31
    -- upvalues: Lighting (copy), u1 (copy)
    local v8 = p4.janitor:Add(Instance.new("ColorCorrectionEffect"));
    v8.Name = "ConcertColorCorrection";
    v8.Brightness = 0.05;
    v8.Contrast = 0.25;
    v8.Saturation = 0.35;
    v8.TintColor = Color3.fromRGB(255, 255, 255);
    v8.Parent = Lighting;
    p4._cc = v8;
    u1:setup(p4, p7, p4.janitor);
    p4._particles = {};
    local _spotlight = p4._spotlight;

    if _spotlight and _spotlight.model then
        local v9 = _spotlight.model:GetPivot();

        for _, descendant in _spotlight.model:GetDescendants() do
            if descendant:IsA("BasePart") and descendant.Name == "Particle" then
                local _particles = p4._particles;
                local v10 = {
                    part = descendant,
                    partOffset = v9:ToObjectSpace(descendant.CFrame)
                };
                table.insert(_particles, v10);
            end;
        end;
    end;
end;

function v2.OnRender(p11, p12, p13, p14, p15, p16) -- Line: 59
    -- upvalues: u1 (copy)
    u1:update(p12, p13, p16);
    local v17 = CFrame.new(p15.Position);

    for _, v in p12._particles do
        v.part.CFrame = v17 * v.partOffset;
    end;
end;

return v2;