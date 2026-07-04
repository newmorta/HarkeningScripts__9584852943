-- Ruta Original: StarterGui.CheatWarningGui.Frame.WarningGuiWinButton
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
game:GetService("TweenService");
local Parent = script.Parent;
local TextLabel = Parent:WaitForChild("TextLabel");
local CheatWarningEvent = ReplicatedStorage:WaitForChild("CheatWarningEvent");
local AnnouncementSound = SoundService:WaitForChild("AnnouncementSound");
local u1 = false;
Parent.Visible = false;
TextLabel.Text = "You must complete the entire obby!";
CheatWarningEvent.OnClientEvent:Connect(function() -- Line: 18
    -- upvalues: u1 (ref), AnnouncementSound (copy), Parent (copy), TextLabel (copy)
    if u1 then
        return;
    end;

    u1 = true;
    AnnouncementSound:Play();
    Parent.Visible = true;
    TextLabel.TextTransparency = 0;
    Parent.BackgroundTransparency = 0.3;
    task.wait(3);

    for i = 0, 1, 0.1 do
        TextLabel.TextTransparency = i;
        Parent.BackgroundTransparency = i * 0.7 + 0.3;
        task.wait(0.05);
    end;

    Parent.Visible = false;
    u1 = false;
end);