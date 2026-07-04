-- Ruta Original: StarterPlayer.StarterPlayerScripts.Uis.MouseIconPulse
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");

local function getTaggedInGui(p1) -- Line: 9
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged(p1)) do
        if v:IsDescendantOf(PlayerGui) then
            return v;
        end;
    end;

    return nil;
end;

local function startPulse(p2) -- Line: 16
    -- upvalues: TweenService (copy)
    TweenService:Create(p2, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Size = p2.Size + UDim2.fromScale(0.07, 0.07)
    }):Play();
end;

local function trySetup() -- Line: 24
    -- upvalues: getTaggedInGui (copy), startPulse (copy)
    local v3 = getTaggedInGui("MouseIcon");

    if not (v3 and v3:IsA("GuiObject")) then
        return false;
    end;

    startPulse(v3);

    return true;
end;

local v4 = getTaggedInGui("MouseIcon");
local v5;

if v4 and v4:IsA("GuiObject") then
    startPulse(v4);
    v5 = true;
else
    v5 = false;
end;

if not v5 then
    CollectionService:GetInstanceAddedSignal("MouseIcon"):Connect(function(p6) -- Line: 34
        -- upvalues: PlayerGui (copy), startPulse (copy)
        if p6:IsDescendantOf(PlayerGui) and p6:IsA("GuiObject") then
            startPulse(p6);
        end;
    end);
end;