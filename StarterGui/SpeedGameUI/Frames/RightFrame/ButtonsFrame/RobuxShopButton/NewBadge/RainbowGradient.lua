-- Ruta Original: StarterGui.SpeedGameUI.Frames.RightFrame.ButtonsFrame.RobuxShopButton.NewBadge.RainbowGradient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UIGradient = script.Parent:WaitForChild("UIGradient");
local u1 = 0;
local Size = script.Parent.Size;
local Rotation = script.Parent.Rotation;
RunService.RenderStepped:Connect(function(p2) -- Line: 13
    -- upvalues: u1 (ref), UIGradient (copy), Size (copy), Rotation (copy)
    u1 = u1 + p2 * 0.5;
    local v3 = Color3.fromHSV(u1 % 1, 0.8, 1);
    local v4 = Color3.fromHSV((u1 + 0.25) % 1, 0.8, 1);
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, v3), ColorSequenceKeypoint.new(1, v4) });
    local v5 = math.sin(u1 * 3.141592653589793 * 2 * 1.5) * 0.2 + 1;
    script.Parent.Size = UDim2.new(Size.X.Scale * v5, Size.X.Offset * v5, Size.Y.Scale * v5, Size.Y.Offset * v5);
    script.Parent.Rotation = Rotation + math.cos(u1 * 3.141592653589793 * 2 * 1.5 * 0.85) * 10;
end);