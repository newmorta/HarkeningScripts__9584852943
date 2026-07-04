-- Ruta Original: StarterPlayer.StarterPlayerScripts.AdminMenuHandler
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;

if LocalPlayer.UserId ~= 3845375404 then
    return;
end;

local AdminMenuAction = ReplicatedStorage:WaitForChild("AdminMenuAction");
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");

local function wireMenu(u1) -- Line: 15
    -- upvalues: AdminMenuAction (copy)
    local Background = u1:WaitForChild("Background");
    local Panel = Background:WaitForChild("Panel");
    local PlayerInput = Panel:WaitForChild("InputFrame"):WaitForChild("PlayerInput");
    local CloseBtn = Panel:WaitForChild("CloseBtn");
    local ButtonScroll = Panel:WaitForChild("ButtonScroll");
    CloseBtn.MouseButton1Click:Connect(function() -- Line: 22
        -- upvalues: u1 (copy)
        u1:Destroy();
    end);
    Background.InputBegan:Connect(function(p2) -- Line: 26
        -- upvalues: Panel (copy), u1 (copy)
        if p2.UserInputType == Enum.UserInputType.MouseButton1 or p2.UserInputType == Enum.UserInputType.Touch then
            local AbsolutePosition = Panel.AbsolutePosition;
            local AbsoluteSize = Panel.AbsoluteSize;
            local Position = p2.Position;

            if Position.X < AbsolutePosition.X or (Position.X > AbsolutePosition.X + AbsoluteSize.X or (Position.Y < AbsolutePosition.Y or Position.Y > AbsolutePosition.Y + AbsoluteSize.Y)) then
                u1:Destroy();
            end;
        end;
    end);

    for _, child in ipairs(ButtonScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child.MouseButton1Click:Connect(function() -- Line: 41
                -- upvalues: child (copy), AdminMenuAction (ref), PlayerInput (copy)
                local v3 = tonumber(string.match(child.Name, "%d+"));

                if v3 then
                    AdminMenuAction:FireServer({
                        Index = v3,
                        PlayerName = PlayerInput.Text
                    });
                end;
            end);
        end;
    end;
end;

PlayerGui.ChildAdded:Connect(function(p4) -- Line: 55
    -- upvalues: wireMenu (copy)
    if p4.Name == "AdminCmdMenu" and p4:IsA("ScreenGui") then
        task.defer(wireMenu, p4);
    end;
end);
local AdminCmdMenu = PlayerGui:FindFirstChild("AdminCmdMenu");

if AdminCmdMenu then
    wireMenu(AdminCmdMenu);
end;