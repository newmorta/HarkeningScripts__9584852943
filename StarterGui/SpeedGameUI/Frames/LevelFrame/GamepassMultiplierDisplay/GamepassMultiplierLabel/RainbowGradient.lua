-- Ruta Original: StarterGui.SpeedGameUI.Frames.LevelFrame.GamepassMultiplierDisplay.GamepassMultiplierLabel.RainbowGradient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UIGradient = script.Parent:WaitForChild("UIGradient");
local u1 = 0;
RunService.RenderStepped:Connect(function(p2) -- Line: 10
    -- upvalues: u1 (ref), UIGradient (copy)
    u1 = u1 + p2 * 0.1;
    local v3 = Color3.fromHSV(u1 % 1, 0.8, 1);
    local v4 = Color3.fromHSV((u1 + 0.05) % 1, 0.8, 1);
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, v3), ColorSequenceKeypoint.new(1, v4) });
end);