-- Ruta Original: StarterPlayer.StarterPlayerScripts.SpecialKeyPanelHandler
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local SpecialKeyPanelAction = ReplicatedStorage:WaitForChild("SpecialKeyPanelAction");
local u1 = "server";

local function wirePanel(u2) -- Line: 14
    -- upvalues: u1 (ref), SpecialKeyPanelAction (copy)
    local Background = u2:WaitForChild("Background");
    local Panel = Background:WaitForChild("Panel");
    local CloseBtn = Panel:WaitForChild("CloseBtn");
    local ButtonScroll = Panel:WaitForChild("ButtonScroll");
    local ScopeFrame = Panel:WaitForChild("ScopeFrame");
    local ScopeServer = ScopeFrame:WaitForChild("ScopeServer");
    local ScopeGlobal = ScopeFrame:WaitForChild("ScopeGlobal");

    local function updateScopeVisual() -- Line: 25
        -- upvalues: u1 (ref), ScopeServer (copy), ScopeGlobal (copy)
        if u1 == "server" then
            ScopeServer.BackgroundColor3 = Color3.fromRGB(50, 130, 50);
            ScopeServer.TextColor3 = Color3.fromRGB(255, 255, 255);
            ScopeGlobal.BackgroundColor3 = Color3.fromRGB(60, 60, 80);
            ScopeGlobal.TextColor3 = Color3.fromRGB(180, 180, 180);

            return;
        end;

        ScopeServer.BackgroundColor3 = Color3.fromRGB(60, 60, 80);
        ScopeServer.TextColor3 = Color3.fromRGB(180, 180, 180);
        ScopeGlobal.BackgroundColor3 = Color3.fromRGB(170, 80, 30);
        ScopeGlobal.TextColor3 = Color3.fromRGB(255, 255, 255);
    end;

    ScopeServer.MouseButton1Click:Connect(function() -- Line: 39
        -- upvalues: u1 (ref), updateScopeVisual (copy)
        u1 = "server";
        updateScopeVisual();
    end);
    ScopeGlobal.MouseButton1Click:Connect(function() -- Line: 44
        -- upvalues: u1 (ref), updateScopeVisual (copy)
        u1 = "global";
        updateScopeVisual();
    end);
    updateScopeVisual();
    CloseBtn.MouseButton1Click:Connect(function() -- Line: 52
        -- upvalues: u2 (copy)
        u2:Destroy();
    end);
    Background.InputBegan:Connect(function(p3) -- Line: 56
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

    for i, v in pairs({
        NormalOn = function() -- Line: 71, Name: NormalOn
            -- upvalues: u1 (ref)
            return {
                Action = "normalOn",
                Scope = u1
            };
        end,

        NormalOff = function() -- Line: 72, Name: NormalOff
            -- upvalues: u1 (ref)
            return {
                Action = "normalOff",
                Scope = u1
            };
        end,

        EventOn = function() -- Line: 73, Name: EventOn
            -- upvalues: u1 (ref)
            return {
                Action = "eventOn",
                Scope = u1
            };
        end,

        EventOff = function() -- Line: 74, Name: EventOff
            -- upvalues: u1 (ref)
            return {
                Action = "eventOff",
                Scope = u1
            };
        end,

        ForceNormal = function() -- Line: 75, Name: ForceNormal
            -- upvalues: u1 (ref)
            return {
                Action = "forceNormal",
                Scope = u1
            };
        end,

        ForceEvent = function() -- Line: 76, Name: ForceEvent
            -- upvalues: u1 (ref)
            return {
                Action = "forceEvent",
                Scope = u1
            };
        end,

        ClearAll = function() -- Line: 77, Name: ClearAll
            -- upvalues: u1 (ref)
            return {
                Action = "clearAll",
                Scope = u1
            };
        end
    }) do
        local v4 = ButtonScroll:WaitForChild(i, 5);

        if v4 then
            v4.MouseButton1Click:Connect(function() -- Line: 84
                -- upvalues: SpecialKeyPanelAction (ref), v (copy)
                SpecialKeyPanelAction:FireServer(v());
            end);
        end;
    end;

    local NormalInterval_Row = ButtonScroll:WaitForChild("NormalInterval_Row", 5);

    if NormalInterval_Row then
        local NormalInterval_Input = NormalInterval_Row:WaitForChild("NormalInterval_Input", 5);
        local NormalInterval_Set = NormalInterval_Row:WaitForChild("NormalInterval_Set", 5);

        if NormalInterval_Input and NormalInterval_Set then
            NormalInterval_Set.MouseButton1Click:Connect(function() -- Line: 96
                -- upvalues: SpecialKeyPanelAction (ref), u1 (ref), NormalInterval_Input (copy)
                SpecialKeyPanelAction:FireServer({
                    Action = "setNormalInterval",
                    Scope = u1,
                    Interval = NormalInterval_Input.Text
                });
            end);
        end;
    end;

    local EventInterval_Row = ButtonScroll:WaitForChild("EventInterval_Row", 5);

    if EventInterval_Row then
        local EventInterval_Input = EventInterval_Row:WaitForChild("EventInterval_Input", 5);
        local EventInterval_Set = EventInterval_Row:WaitForChild("EventInterval_Set", 5);

        if EventInterval_Input and EventInterval_Set then
            EventInterval_Set.MouseButton1Click:Connect(function() -- Line: 111
                -- upvalues: SpecialKeyPanelAction (ref), u1 (ref), EventInterval_Input (copy)
                SpecialKeyPanelAction:FireServer({
                    Action = "setEventInterval",
                    Scope = u1,
                    Interval = EventInterval_Input.Text
                });
            end);
        end;
    end;
end;

PlayerGui.ChildAdded:Connect(function(p5) -- Line: 123
    -- upvalues: wirePanel (copy)
    if p5.Name == "SpecialKeyPanel" and p5:IsA("ScreenGui") then
        task.defer(wirePanel, p5);
    end;
end);
local SpecialKeyPanel = PlayerGui:FindFirstChild("SpecialKeyPanel");

if SpecialKeyPanel then
    wirePanel(SpecialKeyPanel);
end;