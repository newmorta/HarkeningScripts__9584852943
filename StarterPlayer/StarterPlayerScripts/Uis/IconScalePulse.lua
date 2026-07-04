-- Ruta Original: StarterPlayer.StarterPlayerScripts.Uis.IconScalePulse
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");

local function getTaggedInGui(p1) -- Line: 11
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged(p1)) do
        if v:IsDescendantOf(PlayerGui) then
            return v;
        end;
    end;

    return nil;
end;

local function startPulse(p2) -- Line: 18
    -- upvalues: TweenService (copy)
    TweenService:Create(p2, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Scale = 1.5
    }):Play();
end;

local function trySetup() -- Line: 26
    -- upvalues: getTaggedInGui (copy), startPulse (copy)
    local v3 = getTaggedInGui("IconScale");

    if not (v3 and v3:IsA("UIScale")) then
        return false;
    end;

    startPulse(v3);

    return true;
end;

local v4 = getTaggedInGui("IconScale");
local v5;

if v4 and v4:IsA("UIScale") then
    startPulse(v4);
    v5 = true;
else
    v5 = false;
end;

if not v5 then
    CollectionService:GetInstanceAddedSignal("IconScale"):Connect(function(p6) -- Line: 36
        -- upvalues: PlayerGui (copy), startPulse (copy)
        if p6:IsDescendantOf(PlayerGui) and p6:IsA("UIScale") then
            startPulse(p6);
        end;
    end);
end;