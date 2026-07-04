-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.BonusDisplay
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local BonusUpdate = ReplicatedStorage:WaitForChild("BonusUpdate");
local u1 = { "XP", "Wins" };
local u2 = {
    XP = {
        icon = "⚡",
        label = "XP",
        color = Color3.fromRGB(100, 200, 255)
    },
    Wins = {
        icon = "🏆",
        label = "Wins",
        color = Color3.fromRGB(255, 215, 0)
    }
};
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "BonusDisplayGUI";
ScreenGui.ResetOnSpawn = false;
ScreenGui.DisplayOrder = 50;
ScreenGui.Parent = PlayerGui;
local Frame = Instance.new("Frame", ScreenGui);
Frame.Name = "BonusContainer";
Frame.Size = UDim2.new(0.15, 0, 0.12, 0);
Frame.Position = UDim2.new(1, -15, 1, -15);
Frame.AnchorPoint = Vector2.new(1, 1);
Frame.BackgroundTransparency = 1;
Frame.BorderSizePixel = 0;
local UIListLayout = Instance.new("UIListLayout", Frame);
UIListLayout.Padding = UDim.new(0, 6);
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom;
UIListLayout.SortOrder = Enum.SortOrder.Name;
local u3 = {};
local u4 = {};
local u5 = false;

local function formatTime(p6) -- Line: 61
    if p6 <= 0 then
        return "0:00";
    end;

    local v7 = math.floor(p6 / 3600);
    local v8 = math.floor(p6 % 3600 / 60);
    local v9 = p6 % 60;

    if v7 > 0 then
        return string.format("%d:%02d:%02d", v7, v8, v9);
    end;

    return string.format("%d:%02d", v8, v9);
end;

local function createBonusLabel(p10) -- Line: 72
    -- upvalues: u2 (copy), Frame (copy), TweenService (copy)
    local v11 = u2[p10];

    if not v11 then
        return nil;
    end;

    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Bonus_" .. p10;
    Frame2.Size = UDim2.new(1, 0, 0.45, 0);
    Frame2.BackgroundTransparency = 1;
    Frame2.BorderSizePixel = 0;
    Frame2.Parent = Frame;
    local TextLabel = Instance.new("TextLabel", Frame2);
    TextLabel.Name = "BonusText";
    TextLabel.Size = UDim2.new(1, -16, 1, 0);
    TextLabel.Position = UDim2.new(0, 8, 0, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = "";
    TextLabel.TextColor3 = v11.color;
    TextLabel.TextScaled = true;
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    Instance.new("UITextSizeConstraint", TextLabel).MaxTextSize = 20;
    local UIStroke = Instance.new("UIStroke", TextLabel);
    UIStroke.Thickness = 2;
    UIStroke.Color = Color3.fromRGB(0, 0, 0);
    local UIScale = Instance.new("UIScale", Frame2);
    UIScale.Scale = 0;
    TweenService:Create(UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play();

    return Frame2;
end;

local function removeBonusLabel(p12) -- Line: 109
    -- upvalues: u4 (copy), TweenService (copy)
    local u13 = u4[p12];

    if not u13 then
        return;
    end;

    local v14 = u13:FindFirstChildOfClass("UIScale");

    if v14 then
        TweenService:Create(v14, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Scale = 0
        }):Play();
        task.delay(0.35, function() -- Line: 116
            -- upvalues: u13 (copy)
            if u13 and u13.Parent then
                u13:Destroy();
            end;
        end);
    else
        u13:Destroy();
    end;

    u4[p12] = nil;
end;

local function hasAnyActive() -- Line: 125
    -- upvalues: u3 (copy)
    local v15 = os.time();

    for _, v in pairs(u3) do
        if v15 < v.endTime then
            return true;
        end;
    end;

    return false;
end;

local function updateDisplay() -- Line: 137
    -- upvalues: u1 (copy), u3 (copy), u2 (copy), u4 (copy), createBonusLabel (copy), formatTime (copy), removeBonusLabel (copy)
    local v16 = os.time();

    for _, v in ipairs(u1) do
        local v17 = u3[v];
        local v18 = u2[v];

        if v17 and v16 < v17.endTime then
            if not (u4[v] and u4[v].Parent) then
                u4[v] = createBonusLabel(v);
            end;

            local v19 = v17.endTime - v16;
            local v20 = u4[v];

            if v20 then
                local BonusText = v20:FindFirstChild("BonusText");

                if BonusText then
                    BonusText.Text = v18.icon .. " " .. v18.label .. " x" .. v17.mult .. "  " .. formatTime(v19);
                end;
            end;
        else
            if u4[v] then
                removeBonusLabel(v);
            end;

            u3[v] = nil;
        end;
    end;
end;

local function syncClientState() -- Line: 165
    -- upvalues: u3 (copy), ClientState (copy)
    local v21 = os.time();
    local XP = u3.XP;
    local Wins = u3.Wins;
    ClientState:Update({
        BonusXPMultiplier = XP and v21 < XP.endTime and (XP.mult or 1) or 1,
        BonusWinsMultiplier = Wins and (v21 < Wins.endTime and Wins.mult) or 1
    });
end;

local function ensureTimerRunning() -- Line: 176
    -- upvalues: u5 (ref), u3 (copy), updateDisplay (copy), syncClientState (copy)
    if u5 then
        return;
    end;

    u5 = true;
    task.spawn(function() -- Line: 179
        -- upvalues: u3 (ref), updateDisplay (ref), syncClientState (ref), u5 (ref)
        local v22, v23, v24, v25;

        while true do
            local v26 = os.time();
            v22, v23, v24 = pairs(u3);

            if v26 < v25.endTime then
                if not true then
                    updateDisplay();
                    syncClientState();
                    u5 = false;

                    return;
                end;

                updateDisplay();
                syncClientState();
                task.wait(1);
                continue;
            end;

            break;
        end;

        local v27;

        if type(v22) == "function" then
            v27, v25 = v22(v23, v24);
        else
            v27, v25 = next(v22, v24);
        end;

        v24 = v27;
    end);
end;

BonusUpdate.OnClientEvent:Connect(function(p28) -- Line: 196
    -- upvalues: u1 (copy), u3 (copy), removeBonusLabel (copy), syncClientState (copy), updateDisplay (copy), u5 (ref)
    if type(p28) ~= "table" then
        return;
    end;

    for _, v in ipairs(u1) do
        if p28[v] then
            local v29 = p28[v];
            u3[v] = {
                mult = v29.mult,
                endTime = os.time() + (v29.remaining or 0)
            };
        elseif u3[v] then
            u3[v] = nil;
            removeBonusLabel(v);
        end;
    end;

    syncClientState();
    updateDisplay();

    if u5 then
        return;
    end;

    u5 = true;
    task.spawn(function() -- Line: 179
        -- upvalues: u3 (ref), updateDisplay (ref), syncClientState (ref), u5 (ref)
        local v30, v31, v32, v33;

        while true do
            local v34 = os.time();
            v30, v31, v32 = pairs(u3);

            if v34 < v33.endTime then
                if not true then
                    updateDisplay();
                    syncClientState();
                    u5 = false;

                    return;
                end;

                updateDisplay();
                syncClientState();
                task.wait(1);
                continue;
            end;

            break;
        end;

        local v35;

        if type(v30) == "function" then
            v35, v33 = v30(v31, v32);
        else
            v35, v33 = next(v30, v32);
        end;

        v32 = v35;
    end);
end);