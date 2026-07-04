-- Ruta Original: StarterPlayer.StarterPlayerScripts.ItemsShopPanelHandler
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;

if LocalPlayer.UserId ~= 3845375404 then
    return;
end;

local ItemsShopPanelAction = ReplicatedStorage:WaitForChild("ItemsShopPanelAction");
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local u1 = { {
        Action = "restock",
        Scope = "server"
    }, {
        Action = "restock",
        Scope = "global"
    }, {
        Action = "restockmythic",
        Scope = "server"
    }, {
        Action = "restockmythic",
        Scope = "global"
    }, {
        Action = "giveitem"
    }, {
        Action = "removeitem"
    }, {
        Action = "listitems"
    }, {
        Action = "clearitems"
    } };

local function wirePanel(u2) -- Line: 26
    -- upvalues: u1 (copy), ItemsShopPanelAction (copy)
    local Background = u2:WaitForChild("Background");
    local Panel = Background:WaitForChild("Panel");
    local PlayerInput = Panel:WaitForChild("InputFrame"):WaitForChild("PlayerInput");
    local ItemInput = Panel:WaitForChild("ItemFrame"):WaitForChild("ItemInput");
    local QtyInput = Panel:WaitForChild("QtyFrame"):WaitForChild("QtyInput");
    local CloseBtn = Panel:WaitForChild("CloseBtn");
    local ButtonScroll = Panel:WaitForChild("ButtonScroll");
    CloseBtn.MouseButton1Click:Connect(function() -- Line: 36
        -- upvalues: u2 (copy)
        u2:Destroy();
    end);
    Background.InputBegan:Connect(function(p3) -- Line: 41
        -- upvalues: Panel (copy), u2 (copy)
        if p3.UserInputType == Enum.UserInputType.MouseButton1 or p3.UserInputType == Enum.UserInputType.Touch then
            local AbsolutePosition = Panel.AbsolutePosition;
            local AbsoluteSize = Panel.AbsoluteSize;
            local Position = p3.Position;

            if Position.X < AbsolutePosition.X or (Position.X > AbsolutePosition.X + AbsoluteSize.X or (Position.Y < AbsolutePosition.Y or Position.Y > AbsolutePosition.Y + AbsoluteSize.Y)) then
                u2:Destroy();
            end;
        end;
    end);

    for _, child in ipairs(ButtonScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child.MouseButton1Click:Connect(function() -- Line: 57
                -- upvalues: child (copy), u1 (ref), PlayerInput (copy), ItemInput (copy), QtyInput (copy), ItemsShopPanelAction (ref)
                local v4 = tonumber(string.match(child.Name, "%d+"));

                if not v4 then
                    return;
                end;

                local v5 = u1[v4];

                if not v5 then
                    return;
                end;

                ItemsShopPanelAction:FireServer({
                    Action = v5.Action,
                    Scope = v5.Scope,
                    PlayerName = PlayerInput.Text,
                    ItemKey = ItemInput.Text,
                    Quantity = QtyInput.Text
                });
            end);
        end;
    end;
end;

PlayerGui.ChildAdded:Connect(function(p6) -- Line: 79
    -- upvalues: wirePanel (copy)
    if p6.Name == "ItemsShopPanel" and p6:IsA("ScreenGui") then
        task.defer(wirePanel, p6);
    end;
end);
local ItemsShopPanel = PlayerGui:FindFirstChild("ItemsShopPanel");

if ItemsShopPanel then
    wirePanel(ItemsShopPanel);
end;