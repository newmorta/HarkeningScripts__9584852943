-- Ruta Original: ReplicatedStorage.AdminAbuse.LuckymatBossRoom.Assets.Weapons.RocketLauncher.Client
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local MouseLoc = script.Parent:WaitForChild("MouseLoc");
local u1 = game.Players.LocalPlayer:GetMouse();

function MouseLoc.OnClientInvoke() -- Line: 7
    -- upvalues: u1 (copy)
    return u1.Hit.p;
end;