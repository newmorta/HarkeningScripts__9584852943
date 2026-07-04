-- Ruta Original: ReplicatedStorage.UISystems.RelicsPlayerClient
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RelicsXYZ = game:GetService("ReplicatedStorage"):WaitForChild("RelicsXYZ");
local v1 = require(RelicsXYZ);
local RelicsPlayer = require((RelicsXYZ:WaitForChild("RelicsPlayer")));
local Boombox = v1.Boombox;
local v2 = {};
local u3 = nil;

function v2.Get() -- Line: 13
    -- upvalues: u3 (ref)
    return u3;
end;

function v2.ToggleEquipWheel() -- Line: 17
    -- upvalues: u3 (ref)
    if not u3 then
        return;
    end;

    u3:SetEquipWheelOpen(not u3:GetEquipWheelOpen());
end;

function v2.ToggleWindowState() -- Line: 25
    -- upvalues: u3 (ref)
    if not u3 then
        return;
    end;

    if u3:GetWindowState() == "Hidden" then
        u3:SetWindowState("Full");

        return;
    end;

    u3:SetWindowState("Hidden");
    u3:SetPlaying(false);
end;

local function onBoomboxOwnershipChanged() -- Line: 37
    -- upvalues: u3 (ref)
    if u3 and u3:UserHasBoombox() then
        u3:SetWindowState("Full");
    end;
end;

function v2.Init() -- Line: 44
    -- upvalues: u3 (ref), Players (copy), RelicsPlayer (copy), Boombox (copy), onBoomboxOwnershipChanged (copy)
    if u3 then
        return u3;
    end;

    local LocalPlayer = Players.LocalPlayer;
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "RelicsPlayerGUI";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.Enabled = true;
    ScreenGui.IgnoreGuiInset = false;
    ScreenGui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.FullscreenExtension;
    ScreenGui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets;
    ScreenGui.DisplayOrder = 100;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    ScreenGui.Parent = PlayerGui;
    u3 = RelicsPlayer.new(ScreenGui);
    u3:SetWindowState("Hidden");
    u3:SetPlaying(false);
    u3:SetEnabled(true);
    u3:SetPlaying(false);
    task.spawn(function() -- Line: 68
        -- upvalues: Boombox (ref), LocalPlayer (copy), u3 (ref), onBoomboxOwnershipChanged (ref)
        if Boombox.PlayerOwnsBoomboxAsync(LocalPlayer) then
            if u3 and u3:UserHasBoombox() then
                u3:SetWindowState("Full");
            end;
        else
            Boombox.GetBoomboxOwnershipChangedSignal(LocalPlayer):Once(onBoomboxOwnershipChanged);
        end;
    end);

    return u3;
end;

return v2;