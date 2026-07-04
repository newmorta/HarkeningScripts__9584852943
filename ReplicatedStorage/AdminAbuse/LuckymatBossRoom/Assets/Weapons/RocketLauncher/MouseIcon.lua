-- Ruta Original: ReplicatedStorage.AdminAbuse.LuckymatBossRoom.Assets.Weapons.RocketLauncher.MouseIcon
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Parent = script.Parent;
local u1 = nil;

local function UpdateIcon() -- Line: 8
    -- upvalues: u1 (ref), Parent (copy)
    if u1 then
        u1.Icon = Parent.Enabled and "rbxasset://textures/GunCursor.png" or "rbxasset://textures/GunWaitCursor.png";
    end;
end;

local function OnChanged(p2) -- Line: 19
    -- upvalues: u1 (ref), Parent (copy)
    if p2 == "Enabled" and u1 then
        u1.Icon = Parent.Enabled and "rbxasset://textures/GunCursor.png" or "rbxasset://textures/GunWaitCursor.png";
    end;
end;

Parent.Equipped:Connect(function(p3) -- Line: 14, Name: OnEquipped
    -- upvalues: u1 (ref), Parent (copy)
    u1 = p3;

    if u1 then
        u1.Icon = Parent.Enabled and "rbxasset://textures/GunCursor.png" or "rbxasset://textures/GunWaitCursor.png";
    end;
end);
Parent.Changed:Connect(OnChanged);