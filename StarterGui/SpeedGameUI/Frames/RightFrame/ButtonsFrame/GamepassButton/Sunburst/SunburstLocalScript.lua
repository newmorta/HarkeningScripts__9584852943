-- Ruta Original: StarterGui.SpeedGameUI.Frames.RightFrame.ButtonsFrame.GamepassButton.Sunburst.SunburstLocalScript
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Parent = script.Parent;
local u1 = 0;
RunService.RenderStepped:Connect(function(p2) -- Line: 13
    -- upvalues: u1 (ref), Parent (copy)
    u1 = u1 + 20 * p2;
    Parent.Rotation = u1 % 360;
end);