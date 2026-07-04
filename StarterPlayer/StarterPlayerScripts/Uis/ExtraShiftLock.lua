-- Ruta Original: StarterPlayer.StarterPlayerScripts.Uis.ExtraShiftLock
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Icon = require(ReplicatedStorage:WaitForChild("TopbarPlus"):WaitForChild("Icon"));
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local u1 = Icon.new():setName("ShiftLock"):setLabel("🔓"):autoDeselect(false);
local u2 = false;
local u3 = nil;
local u4 = nil;

local function applyToHumanoid(p5, p6) -- Line: 27
    if p5 then
        p5.AutoRotate = not p6;
    end;
end;

local function setActive(p7) -- Line: 33
    -- upvalues: u2 (ref), u4 (ref)
    u2 = p7;
    local v8 = u4;
    local v9 = u2;

    if v8 then
        v8.AutoRotate = not v9;
    end;
end;

u1.selected:Connect(function() -- Line: 38
    -- upvalues: u2 (ref), u4 (ref), u1 (copy)
    u2 = true;
    local v10 = u4;
    local v11 = u2;

    if v10 then
        v10.AutoRotate = not v11;
    end;

    u1:setLabel("🔒");
end);
u1.deselected:Connect(function() -- Line: 43
    -- upvalues: u2 (ref), u4 (ref), u1 (copy)
    u2 = false;
    local v12 = u4;
    local v13 = u2;

    if v12 then
        v12.AutoRotate = not v13;
    end;

    u1:setLabel("🔓");
end);

if UserInputService.KeyboardEnabled and UserInputService.MouseEnabled and not UserInputService.TouchEnabled then
    u1:setEnabled(false);
end;

LocalPlayer.CharacterAdded:Connect(function(p14) -- Line: 58, Name: onCharacterAdded
    -- upvalues: u3 (ref), u4 (ref), u2 (ref)
    u3 = p14:WaitForChild("HumanoidRootPart");
    u4 = p14:WaitForChild("Humanoid");
    local v15 = u4;
    local v16 = u2;

    if v15 then
        v15.AutoRotate = not v16;
    end;
end);

if LocalPlayer.Character then
    local Character = LocalPlayer.Character;
    u3 = Character:WaitForChild("HumanoidRootPart");
    u4 = Character:WaitForChild("Humanoid");
    local v17 = u4;
    local v18 = u2;

    if v17 then
        v17.AutoRotate = not v18;
    end;
end;

RunService.RenderStepped:Connect(function() -- Line: 74
    -- upvalues: u2 (ref), u3 (ref), CurrentCamera (copy)
    if not u2 then
        return;
    end;

    if not (u3 and u3.Parent) then
        return;
    end;

    local _, v19, _ = CurrentCamera.CFrame:ToEulerAnglesYXZ();
    u3.CFrame = CFrame.new(u3.Position) * CFrame.Angles(0, v19, 0);
end);