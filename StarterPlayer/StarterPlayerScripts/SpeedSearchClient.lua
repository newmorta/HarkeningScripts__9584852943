-- Ruta Original: StarterPlayer.StarterPlayerScripts.SpeedSearchClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local SpeedSearchAction = ReplicatedStorage:WaitForChild("SpeedSearchAction");
local u1 = 1e27;
local u2 = false;

local function getPanel() -- Line: 15
    -- upvalues: PlayerGui (copy)
    local SpeedSearchPanel = PlayerGui:FindFirstChild("SpeedSearchPanel");

    if not SpeedSearchPanel then
        return nil;
    end;

    local Background = SpeedSearchPanel:FindFirstChild("Background");

    if Background then
        return Background:FindFirstChild("Panel"), SpeedSearchPanel, Background;
    end;

    return nil;
end;

local function updateSuffixHighlight(p3) -- Line: 23
    -- upvalues: u1 (ref)
    for _, descendant in ipairs(p3:GetDescendants()) do
        if descendant:IsA("TextButton") then
            local v4 = descendant:GetAttribute("Mult");

            if v4 ~= nil then
                if v4 == u1 then
                    descendant.BackgroundColor3 = Color3.fromRGB(100, 200, 255);
                    descendant.TextColor3 = Color3.fromRGB(0, 0, 0);
                else
                    descendant.BackgroundColor3 = Color3.fromRGB(50, 50, 70);
                    descendant.TextColor3 = Color3.fromRGB(255, 255, 255);
                end;
            end;
        end;
    end;
end;

local function clearResults(p5) -- Line: 40
    local ResultsScroll = p5:FindFirstChild("ResultsScroll");

    if not ResultsScroll then
        return;
    end;

    for _, child in ipairs(ResultsScroll:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy();
        end;
    end;
end;

local function setStatus(p6, p7, p8) -- Line: 50
    local StatusLabel = p6:FindFirstChild("StatusLabel");

    if StatusLabel then
        StatusLabel.Text = p7;
        StatusLabel.TextColor3 = p8 or Color3.fromRGB(180, 180, 180);
    end;
end;

local function populateResults(p9, p10, p11, p12) -- Line: 58
    -- upvalues: clearResults (copy)
    local ResultsScroll = p9:FindFirstChild("ResultsScroll");

    if not ResultsScroll then
        return;
    end;

    clearResults(p9);
    local v13 = p11 .. " joueur(s) trouvés | Range: " .. p12;
    local v14 = Color3.fromRGB(100, 255, 100);
    local StatusLabel = p9:FindFirstChild("StatusLabel");

    if StatusLabel then
        StatusLabel.Text = v13;
        StatusLabel.TextColor3 = v14 or Color3.fromRGB(180, 180, 180);
    end;

    for _, v in ipairs(p10) do
        local TextLabel = Instance.new("TextLabel", ResultsScroll);
        TextLabel.Name = "Result_" .. v.Index;
        TextLabel.Size = UDim2.new(1, -10, 0, 28);
        TextLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 45);
        TextLabel.BackgroundTransparency = 0.3;
        TextLabel.BorderSizePixel = 0;
        TextLabel.Text = string.format("  #%d | UserId: %s | Speed: %s", v.Index, tostring(v.UserId), v.SpeedFormatted);
        TextLabel.TextColor3 = Color3.fromRGB(230, 230, 230);
        TextLabel.TextScaled = true;
        TextLabel.Font = Enum.Font.GothamMedium;
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
        Instance.new("UICorner", TextLabel).CornerRadius = UDim.new(0, 6);
        Instance.new("UITextSizeConstraint", TextLabel).MaxTextSize = 12;
    end;

    if p11 == 0 then
        local TextLabel = Instance.new("TextLabel", ResultsScroll);
        TextLabel.Name = "NoResult";
        TextLabel.Size = UDim2.new(1, -10, 0, 40);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.Text = "Aucun joueur trouvé dans ce range.";
        TextLabel.TextColor3 = Color3.fromRGB(150, 150, 150);
        TextLabel.TextScaled = true;
        TextLabel.Font = Enum.Font.GothamMedium;
        Instance.new("UITextSizeConstraint", TextLabel).MaxTextSize = 13;
    end;
end;

local function wirePanel(u15, u16, p17) -- Line: 94
    -- upvalues: u1 (ref), updateSuffixHighlight (copy), u2 (ref), clearResults (copy), SpeedSearchAction (copy)
    local CloseBtn = u15:FindFirstChild("CloseBtn");

    if CloseBtn then
        CloseBtn.MouseButton1Click:Connect(function() -- Line: 97
            -- upvalues: u16 (copy)
            u16:Destroy();
        end);
    end;

    p17.InputBegan:Connect(function(p18) -- Line: 102
        -- upvalues: u15 (copy), u16 (copy)
        if p18.UserInputType == Enum.UserInputType.MouseButton1 or p18.UserInputType == Enum.UserInputType.Touch then
            local AbsolutePosition = u15.AbsolutePosition;
            local AbsoluteSize = u15.AbsoluteSize;
            local Position = p18.Position;

            if Position.X < AbsolutePosition.X or (Position.X > AbsolutePosition.X + AbsoluteSize.X or (Position.Y < AbsolutePosition.Y or Position.Y > AbsolutePosition.Y + AbsoluteSize.Y)) then
                u16:Destroy();
            end;
        end;
    end);

    for _, descendant in ipairs(u15:GetDescendants()) do
        if descendant:IsA("TextButton") then
            local u19 = descendant:GetAttribute("Mult");

            if u19 ~= nil then
                descendant.MouseButton1Click:Connect(function() -- Line: 120
                    -- upvalues: u1 (ref), u19 (copy), updateSuffixHighlight (ref), u15 (copy)
                    u1 = u19;
                    updateSuffixHighlight(u15);
                end);
            end;
        end;
    end;

    updateSuffixHighlight(u15);
    local OkBtn = u15:FindFirstChild("OkBtn");

    if OkBtn then
        OkBtn.MouseButton1Click:Connect(function() -- Line: 132
            -- upvalues: u2 (ref), u15 (copy), u1 (ref), clearResults (ref), OkBtn (copy), SpeedSearchAction (ref)
            if u2 then
                return;
            end;

            local MinInputFrame = u15:FindFirstChild("MinInputFrame");
            local MaxInputFrame = u15:FindFirstChild("MaxInputFrame");

            if not (MinInputFrame and MaxInputFrame) then
                return;
            end;

            local MinInput = MinInputFrame:FindFirstChild("MinInput");
            local MaxInput = MaxInputFrame:FindFirstChild("MaxInput");

            if not (MinInput and MaxInput) then
                return;
            end;

            local v20 = tonumber(MinInput.Text);
            local v21 = tonumber(MaxInput.Text);

            if not (v20 and v21) then
                local v22 = Color3.fromRGB(255, 80, 80);
                local StatusLabel = u15:FindFirstChild("StatusLabel");

                if StatusLabel then
                    StatusLabel.Text = "Entrez des nombres valides dans Min et Max";
                    StatusLabel.TextColor3 = v22 or Color3.fromRGB(180, 180, 180);
                end;

                return;
            end;

            local v23 = v20 * u1;
            local v24 = v21 * u1;

            if v24 <= v23 then
                local v25 = Color3.fromRGB(255, 80, 80);
                local StatusLabel = u15:FindFirstChild("StatusLabel");

                if StatusLabel then
                    StatusLabel.Text = "Max doit être supérieur à Min";
                    StatusLabel.TextColor3 = v25 or Color3.fromRGB(180, 180, 180);
                end;

                return;
            end;

            u2 = true;
            clearResults(u15);
            local v26 = Color3.fromRGB(255, 215, 0);
            local StatusLabel = u15:FindFirstChild("StatusLabel");

            if StatusLabel then
                StatusLabel.Text = "Recherche en cours...";
                StatusLabel.TextColor3 = v26 or Color3.fromRGB(180, 180, 180);
            end;

            OkBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60);
            SpeedSearchAction:FireServer({
                Action = "search",
                Min = v23,
                Max = v24
            });
            task.delay(15, function() -- Line: 170
                -- upvalues: u2 (ref), OkBtn (ref)
                if u2 then
                    u2 = false;
                    OkBtn.BackgroundColor3 = Color3.fromRGB(20, 100, 180);
                end;
            end);
        end);
    end;
end;

SpeedSearchAction.OnClientEvent:Connect(function(p27) -- Line: 180
    -- upvalues: PlayerGui (copy), u2 (ref), populateResults (copy)
    if type(p27) ~= "table" then
        return;
    end;

    local SpeedSearchPanel = PlayerGui:FindFirstChild("SpeedSearchPanel");
    local v28;

    if SpeedSearchPanel then
        local Background = SpeedSearchPanel:FindFirstChild("Background");

        if Background then
            v28 = Background:FindFirstChild("Panel");
        else
            v28 = nil;
        end;
    else
        v28 = nil;
    end;

    if not v28 then
        return;
    end;

    if p27.Action ~= "results" then
        if p27.Action == "error" then
            u2 = false;
            local OkBtn = v28:FindFirstChild("OkBtn");

            if OkBtn then
                OkBtn.BackgroundColor3 = Color3.fromRGB(20, 100, 180);
            end;

            local Message = p27.Message;
            local v29 = Color3.fromRGB(255, 80, 80);
            local StatusLabel = v28:FindFirstChild("StatusLabel");

            if StatusLabel then
                StatusLabel.Text = Message;
                StatusLabel.TextColor3 = v29 or Color3.fromRGB(180, 180, 180);

                return;
            end;
        elseif p27.Action == "status" then
            local Message = p27.Message;
            local v30 = Color3.fromRGB(255, 215, 0);
            local StatusLabel = v28:FindFirstChild("StatusLabel");

            if StatusLabel then
                StatusLabel.Text = Message;
                StatusLabel.TextColor3 = v30 or Color3.fromRGB(180, 180, 180);
            end;
        end;

        return;
    end;

    u2 = false;
    local OkBtn = v28:FindFirstChild("OkBtn");

    if OkBtn then
        OkBtn.BackgroundColor3 = Color3.fromRGB(20, 100, 180);
    end;

    populateResults(v28, p27.Results, p27.Count, p27.Range);
end);
PlayerGui.ChildAdded:Connect(function(u31) -- Line: 202
    -- upvalues: u2 (ref), wirePanel (copy)
    if u31.Name == "SpeedSearchPanel" then
        task.spawn(function() -- Line: 204
            -- upvalues: u2 (ref), u31 (copy), wirePanel (ref)
            u2 = false;
            local Background = u31:WaitForChild("Background", 5);

            if not Background then
                return;
            end;

            local Panel = Background:WaitForChild("Panel", 5);

            if not Panel then
                return;
            end;

            Panel:WaitForChild("OkBtn", 5);
            local SuffixRow1 = Panel:WaitForChild("SuffixRow1", 5);

            if SuffixRow1 then
                SuffixRow1:WaitForChild("Suffix_K", 5);
            end;

            wirePanel(Panel, u31, Background);
        end);
    end;
end);