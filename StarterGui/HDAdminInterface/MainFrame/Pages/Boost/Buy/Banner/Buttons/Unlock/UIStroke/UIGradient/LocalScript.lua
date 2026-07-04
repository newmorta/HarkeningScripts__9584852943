-- Ruta Original: StarterGui.HDAdminInterface.MainFrame.Pages.Boost.Buy.Banner.Buttons.Unlock.UIStroke.UIGradient.LocalScript
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Parent = script.Parent;

while true do
    Parent.Rotation = Parent.Rotation + 1;

    if Parent.Rotation == 180 then
        Parent.Rotation = -180;
    end;

    task.wait(0.005);
end;