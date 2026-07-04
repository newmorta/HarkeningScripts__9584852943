-- Ruta Original: StarterPlayer.StarterPlayerScripts.WinSearchClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local WinSearchAction = ReplicatedStorage:WaitForChild("WinSearchAction");
local u1 = 1000000000;
local u2 = false;

local function getPanel() -- Line: 15
    -- upvalues: PlayerGui (copy)
    local WinSearchPanel = PlayerGui:FindFirstChild("WinSearchPanel");

    if not WinSearchPanel then
        return nil;
    end;

    local Background = WinSearchPanel:FindFirstChild("Background");

    if Background then
        return Background:FindFirstChild("Panel"), WinSearchPanel, Background;
    end;

    return nil;
end;

local function updateSuffixHighlight(p3) -- Line: 23
    -- upvalues: u1 (ref)
    local SuffixFrame = p3:FindFirstChild("SuffixFrame");

    if not SuffixFrame then
        return;
    end;

    for _, child in ipairs(SuffixFrame:GetChildren()) do
        if child:IsA("TextButton") then
            if child:GetAttribute("Mult") == u1 then
                child.BackgroundColor3 = Color3.fromRGB(255, 215, 0);
                child.TextColor3 = Color3.fromRGB(0, 0, 0);
            else
                child.BackgroundColor3 = Color3.fromRGB(50, 50, 70);
                child.TextColor3 = Color3.fromRGB(255, 255, 255);
            end;
        end;
    end;
end;

local function clearResults(p4) -- Line: 40
    local ResultsScroll = p4:FindFirstChild("ResultsScroll");

    if not ResultsScroll then
        return;
    end;

    for _, child in ipairs(ResultsScroll:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy();
        end;
    end;
end;

local function setStatus(p5, p6, p7) -- Line: 50
    local StatusLabel = p5:FindFirstChild("StatusLabel");

    if StatusLabel then
        StatusLabel.Text = p6;
        StatusLabel.TextColor3 = p7 or Color3.fromRGB(180, 180, 180);
    end;
end;

local function populateResults(p8, p9, p10, p11) -- Line: 58
    -- upvalues: clearResults (copy)
    local ResultsScroll = p8:FindFirstChild("ResultsScroll");

    if not ResultsScroll then
        return;
    end;

    clearResults(p8);
    local v12 = p10 .. " joueur(s) trouves | Range: " .. p11;
    local v13 = Color3.fromRGB(100, 255, 100);
    local StatusLabel = p8:FindFirstChild("StatusLabel");

    if StatusLabel then
        StatusLabel.Text = v12;
        StatusLabel.TextColor3 = v13 or Color3.fromRGB(180, 180, 180);
    end;

    for _, v in ipairs(p9) do
        local TextLabel = Instance.new("TextLabel", ResultsScroll);
        TextLabel.Name = "Result_" .. v.Index;
        TextLabel.Size = UDim2.new(1, -10, 0, 28);
        TextLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 45);
        TextLabel.BackgroundTransparency = 0.3;
        TextLabel.BorderSizePixel = 0;
        TextLabel.Text = string.format("  #%d | UserId: %s | Wins: %s", v.Index, tostring(v.UserId), v.WinsFormatted);
        TextLabel.TextColor3 = Color3.fromRGB(230, 230, 230);
        TextLabel.TextScaled = true;
        TextLabel.Font = Enum.Font.GothamMedium;
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
        Instance.new("UICorner", TextLabel).CornerRadius = UDim.new(0, 6);
        Instance.new("UITextSizeConstraint", TextLabel).MaxTextSize = 12;
    end;

    if p10 == 0 then
        local TextLabel = Instance.new("TextLabel", ResultsScroll);
        TextLabel.Name = "NoResult";
        TextLabel.Size = UDim2.new(1, -10, 0, 40);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.Text = "Aucun joueur trouve dans ce range.";
        TextLabel.TextColor3 = Color3.fromRGB(150, 150, 150);
        TextLabel.TextScaled = true;
        TextLabel.Font = Enum.Font.GothamMedium;
        Instance.new("UITextSizeConstraint", TextLabel).MaxTextSize = 13;
    end;
end;

local function wirePanel(u14, u15, p16) -- Line: 94
    -- upvalues: u1 (ref), updateSuffixHighlight (copy), u2 (ref), clearResults (copy), WinSearchAction (copy)
    local CloseBtn = u14:FindFirstChild("CloseBtn");

    if CloseBtn then
        CloseBtn.MouseButton1Click:Connect(function() -- Line: 98
            -- upvalues: u15 (copy)
            u15:Destroy();
        end);
    end;

    p16.InputBegan:Connect(function(p17) -- Line: 104
        -- upvalues: u14 (copy), u15 (copy)
        if p17.UserInputType == Enum.UserInputType.MouseButton1 or p17.UserInputType == Enum.UserInputType.Touch then
            local AbsolutePosition = u14.AbsolutePosition;
            local AbsoluteSize = u14.AbsoluteSize;
            local Position = p17.Position;

            if Position.X < AbsolutePosition.X or (Position.X > AbsolutePosition.X + AbsoluteSize.X or (Position.Y < AbsolutePosition.Y or Position.Y > AbsolutePosition.Y + AbsoluteSize.Y)) then
                u15:Destroy();
            end;
        end;
    end);
    local SuffixFrame = u14:FindFirstChild("SuffixFrame");

    if SuffixFrame then
        for _, child in ipairs(SuffixFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child.MouseButton1Click:Connect(function() -- Line: 122
                    -- upvalues: child (copy), u1 (ref), updateSuffixHighlight (ref), u14 (copy)
                    local v18 = child:GetAttribute("Mult");

                    if v18 then
                        u1 = v18;
                        updateSuffixHighlight(u14);
                    end;
                end);
            end;
        end;
    end;

    updateSuffixHighlight(u14);
    local OkBtn = u14:FindFirstChild("OkBtn");

    if OkBtn then
        OkBtn.MouseButton1Click:Connect(function() -- Line: 139
            -- upvalues: u2 (ref), u14 (copy), u1 (ref), clearResults (ref), OkBtn (copy), WinSearchAction (ref)
            if u2 then
                return;
            end;

            local MinInputFrame = u14:FindFirstChild("MinInputFrame");
            local MaxInputFrame = u14:FindFirstChild("MaxInputFrame");

            if not (MinInputFrame and MaxInputFrame) then
                return;
            end;

            local MinInput = MinInputFrame:FindFirstChild("MinInput");
            local MaxInput = MaxInputFrame:FindFirstChild("MaxInput");

            if not (MinInput and MaxInput) then
                return;
            end;

            local v19 = tonumber(MinInput.Text);
            local v20 = tonumber(MaxInput.Text);

            if not (v19 and v20) then
                local v21 = Color3.fromRGB(255, 80, 80);
                local StatusLabel = u14:FindFirstChild("StatusLabel");

                if StatusLabel then
                    StatusLabel.Text = "Entrez des nombres valides dans Min et Max";
                    StatusLabel.TextColor3 = v21 or Color3.fromRGB(180, 180, 180);
                end;

                return;
            end;

            local v22 = v19 * u1;
            local v23 = v20 * u1;

            if v23 <= v22 then
                local v24 = Color3.fromRGB(255, 80, 80);
                local StatusLabel = u14:FindFirstChild("StatusLabel");

                if StatusLabel then
                    StatusLabel.Text = "Max doit etre superieur a Min";
                    StatusLabel.TextColor3 = v24 or Color3.fromRGB(180, 180, 180);
                end;

                return;
            end;

            u2 = true;
            clearResults(u14);
            local v25 = Color3.fromRGB(255, 215, 0);
            local StatusLabel = u14:FindFirstChild("StatusLabel");

            if StatusLabel then
                StatusLabel.Text = "Recherche en cours...";
                StatusLabel.TextColor3 = v25 or Color3.fromRGB(180, 180, 180);
            end;

            OkBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60);
            WinSearchAction:FireServer({
                Action = "search",
                Min = v22,
                Max = v23
            });
            task.delay(15, function() -- Line: 178
                -- upvalues: u2 (ref), OkBtn (ref)
                if u2 then
                    u2 = false;
                    OkBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 60);
                end;
            end);
        end);
    end;
end;

WinSearchAction.OnClientEvent:Connect(function(p26) -- Line: 189
    -- upvalues: PlayerGui (copy), u2 (ref), populateResults (copy)
    if type(p26) ~= "table" then
        return;
    end;

    local WinSearchPanel = PlayerGui:FindFirstChild("WinSearchPanel");
    local v27;

    if WinSearchPanel then
        local Background = WinSearchPanel:FindFirstChild("Background");

        if Background then
            v27 = Background:FindFirstChild("Panel");
        else
            v27 = nil;
        end;
    else
        v27 = nil;
    end;

    if not v27 then
        return;
    end;

    if p26.Action ~= "results" then
        if p26.Action == "error" then
            u2 = false;
            local OkBtn = v27:FindFirstChild("OkBtn");

            if OkBtn then
                OkBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 60);
            end;

            local Message = p26.Message;
            local v28 = Color3.fromRGB(255, 80, 80);
            local StatusLabel = v27:FindFirstChild("StatusLabel");

            if StatusLabel then
                StatusLabel.Text = Message;
                StatusLabel.TextColor3 = v28 or Color3.fromRGB(180, 180, 180);

                return;
            end;
        elseif p26.Action == "status" then
            local Message = p26.Message;
            local v29 = Color3.fromRGB(255, 215, 0);
            local StatusLabel = v27:FindFirstChild("StatusLabel");

            if StatusLabel then
                StatusLabel.Text = Message;
                StatusLabel.TextColor3 = v29 or Color3.fromRGB(180, 180, 180);
            end;
        end;

        return;
    end;

    u2 = false;
    local OkBtn = v27:FindFirstChild("OkBtn");

    if OkBtn then
        OkBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 60);
    end;

    populateResults(v27, p26.Results, p26.Count, p26.Range);
end);
PlayerGui.ChildAdded:Connect(function(u30) -- Line: 212
    -- upvalues: u2 (ref), wirePanel (copy)
    if u30.Name == "WinSearchPanel" then
        task.spawn(function() -- Line: 214
            -- upvalues: u2 (ref), u30 (copy), wirePanel (ref)
            u2 = false;
            local Background = u30:WaitForChild("Background", 5);

            if not Background then
                return;
            end;

            local Panel = Background:WaitForChild("Panel", 5);

            if not Panel then
                return;
            end;

            Panel:WaitForChild("OkBtn", 5);
            local SuffixFrame = Panel:WaitForChild("SuffixFrame", 5);

            if SuffixFrame then
                SuffixFrame:WaitForChild("Suffix_K", 5);
            end;

            wirePanel(Panel, u30, Background);
        end);
    end;
end);