-- Ruta Original: ReplicatedStorage.AdminAbuse.LuckymatBossRoom.Assets.NPCs.StatueNoob.Sword.MouseIcon
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

Mouse_Icon = "rbxasset://textures/GunCursor.png";
Reloading_Icon = "rbxasset://textures/GunWaitCursor.png";
Tool = script.Parent;
Mouse = nil;

function UpdateIcon()
    if Mouse then
        Mouse.Icon = Tool.Enabled and Mouse_Icon or Reloading_Icon;
    end;
end;

function OnEquipped(p1)
    Mouse = p1;
    UpdateIcon();
end;

function OnChanged(p2)
    if p2 == "Enabled" then
        UpdateIcon();
    end;
end;

Tool.Equipped:Connect(OnEquipped);
Tool.Changed:Connect(OnChanged);