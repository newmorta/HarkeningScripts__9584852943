-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.InterfaceEffects
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local SoundManager = require(ReplicatedStorage:WaitForChild("SoundManager"));
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");

local function isInsideMainGui(p1) -- Line: 13
    -- upvalues: CollectionService (copy)
    local v2 = p1:FindFirstAncestorOfClass("ScreenGui");

    return v2 and CollectionService:HasTag(v2, "MainGUI") and true or false;
end;

local function handleButton(u3) -- Line: 21
    -- upvalues: CollectionService (copy), SoundManager (copy)
    if not u3:IsA("GuiButton") then
        return;
    end;

    local v4 = u3:FindFirstAncestorOfClass("ScreenGui");

    if not (v4 and CollectionService:HasTag(v4, "MainGUI")) then
        return;
    end;

    u3.MouseEnter:Connect(function() -- Line: 31
        -- upvalues: u3 (copy), CollectionService (ref), SoundManager (ref)
        if u3.Visible and (u3.Active and not CollectionService:HasTag(u3, "SoundButton")) then
            SoundManager:Play("HOVER");
        end;
    end);
    u3.MouseButton1Click:Connect(function() -- Line: 38
        -- upvalues: u3 (copy), SoundManager (ref)
        if u3.Visible and u3.Active then
            SoundManager:Play("CLICK");
        end;
    end);
end;

for _, descendant in ipairs(PlayerGui:GetDescendants()) do
    handleButton(descendant);
end;

PlayerGui.DescendantAdded:Connect(function(p5) -- Line: 52
    -- upvalues: handleButton (copy)
    handleButton(p5);
end);