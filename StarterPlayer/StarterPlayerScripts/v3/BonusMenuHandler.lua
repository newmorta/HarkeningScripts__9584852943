-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.BonusMenuHandler
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;

if LocalPlayer.UserId ~= 3845375404 then
    return;
end;

local BonusMenuAction = ReplicatedStorage:WaitForChild("BonusMenuAction");
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");

local function wireMenu(u1) -- Line: 15
    -- upvalues: BonusMenuAction (copy)
    local Background = u1:WaitForChild("Background");
    local Panel = Background:WaitForChild("Panel");
    local CloseBtn = Panel:WaitForChild("CloseBtn");
    local ScopeFrame = Panel:WaitForChild("ScopeFrame");
    local PlayerFrame = Panel:WaitForChild("PlayerFrame");
    local PlayerInput = PlayerFrame:WaitForChild("PlayerInput");
    local TypeFrame = Panel:WaitForChild("TypeFrame");
    local MultInput = Panel:WaitForChild("MultInput");
    local DurInput = Panel:WaitForChild("DurInput");
    local ActivateBtn = Panel:WaitForChild("ActivateBtn");
    local StopAllBtn = Panel:WaitForChild("StopAllBtn");
    local u2 = "server";
    local u3 = "Wins";
    local u4 = Color3.fromRGB(40, 40, 55);

    local function updateScopeVisual() -- Line: 35
        -- upvalues: ScopeFrame (copy), u2 (ref), u4 (copy), PlayerFrame (copy)
        for _, child in ipairs(ScopeFrame:GetChildren()) do
            if child:IsA("TextButton") then
                if child:GetAttribute("ScopeValue") == u2 then
                    local v5 = child:GetAttribute("ActiveColor");

                    if v5 then
                        local v6 = string.split(v5, ",");
                        child.BackgroundColor3 = Color3.fromRGB(tonumber(v6[1]) or 40, tonumber(v6[2]) or 40, tonumber(v6[3]) or 55);
                    end;
                else
                    child.BackgroundColor3 = u4;
                end;
            end;
        end;

        PlayerFrame.Visible = u2 == "player";
    end;

    local function updateTypeVisual() -- Line: 58
        -- upvalues: TypeFrame (copy), u3 (ref), u4 (copy)
        for _, child in ipairs(TypeFrame:GetChildren()) do
            if child:IsA("TextButton") then
                if child:GetAttribute("TypeValue") == u3 then
                    child.BackgroundColor3 = Color3.fromRGB(50, 100, 160);
                else
                    child.BackgroundColor3 = u4;
                end;
            end;
        end;
    end;

    for _, child in ipairs(ScopeFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child.MouseButton1Click:Connect(function() -- Line: 74
                -- upvalues: u2 (ref), child (copy), updateScopeVisual (copy)
                u2 = child:GetAttribute("ScopeValue") or "server";
                updateScopeVisual();
            end);
        end;
    end;

    for _, child in ipairs(TypeFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child.MouseButton1Click:Connect(function() -- Line: 84
                -- upvalues: u3 (ref), child (copy), updateTypeVisual (copy)
                u3 = child:GetAttribute("TypeValue") or "Wins";
                updateTypeVisual();
            end);
        end;
    end;

    ActivateBtn.MouseButton1Click:Connect(function() -- Line: 92
        -- upvalues: BonusMenuAction (ref), u2 (ref), u3 (ref), MultInput (copy), DurInput (copy), PlayerInput (copy)
        BonusMenuAction:FireServer({
            action = "activate",
            scope = u2,
            bonusType = u3,
            multiplier = MultInput.Text,
            duration = DurInput.Text,
            playerName = PlayerInput.Text
        });
    end);
    StopAllBtn.MouseButton1Click:Connect(function() -- Line: 104
        -- upvalues: BonusMenuAction (ref)
        BonusMenuAction:FireServer({
            action = "stopAll"
        });
    end);
    CloseBtn.MouseButton1Click:Connect(function() -- Line: 111
        -- upvalues: u1 (copy)
        u1:Destroy();
    end);
    Background.InputBegan:Connect(function(p7) -- Line: 116
        -- upvalues: Panel (copy), u1 (copy)
        if p7.UserInputType == Enum.UserInputType.MouseButton1 or p7.UserInputType == Enum.UserInputType.Touch then
            local AbsolutePosition = Panel.AbsolutePosition;
            local AbsoluteSize = Panel.AbsoluteSize;
            local Position = p7.Position;

            if Position.X < AbsolutePosition.X or (Position.X > AbsolutePosition.X + AbsoluteSize.X or (Position.Y < AbsolutePosition.Y or Position.Y > AbsolutePosition.Y + AbsoluteSize.Y)) then
                u1:Destroy();
            end;
        end;
    end);
    updateScopeVisual();
    updateTypeVisual();
end;

PlayerGui.ChildAdded:Connect(function(p8) -- Line: 135
    -- upvalues: wireMenu (copy)
    if p8.Name == "BonusMenuGUI" and p8:IsA("ScreenGui") then
        task.defer(wireMenu, p8);
    end;
end);
local BonusMenuGUI = PlayerGui:FindFirstChild("BonusMenuGUI");

if BonusMenuGUI then
    wireMenu(BonusMenuGUI);
end;