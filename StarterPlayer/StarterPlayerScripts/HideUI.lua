-- Ruta Original: StarterPlayer.StarterPlayerScripts.HideUI
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Icon = require(ReplicatedStorage:WaitForChild("TopbarPlus"):WaitForChild("Icon"));
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local u1 = true;

local function setUIVisible(p2) -- Line: 14
    -- upvalues: u1 (ref), CollectionService (copy), PlayerGui (copy)
    u1 = p2;

    for _, v in ipairs(CollectionService:GetTagged("UI")) do
        if v:IsA("Frame") and v:IsDescendantOf(PlayerGui) then
            v.Visible = p2;
        end;
    end;
end;

CollectionService:GetInstanceAddedSignal("UI"):Connect(function(p3) -- Line: 24
    -- upvalues: PlayerGui (copy), u1 (ref)
    if p3:IsA("Frame") and p3:IsDescendantOf(PlayerGui) then
        p3.Visible = u1;
    end;
end);
local v4 = Icon.new():setName("UIToggle"):setImage("rbxassetid://94652404380463", "Selected"):setImage("rbxassetid://106788007315711", "Deselected"):setLabel("");
v4.selected:Connect(function() -- Line: 37
    -- upvalues: setUIVisible (copy)
    setUIVisible(false);
end);
v4.deselected:Connect(function() -- Line: 41
    -- upvalues: setUIVisible (copy)
    setUIVisible(true);
end);