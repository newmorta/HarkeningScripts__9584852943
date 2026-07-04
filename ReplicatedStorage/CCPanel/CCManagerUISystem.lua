-- Ruta Original: ReplicatedStorage.CCPanel.CCManagerUISystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GiftTreadmillConfig = require(ReplicatedStorage.CCPanel.GiftTreadmillConfig);

local function resolveNameAsync(u1) -- Line: 6
    -- upvalues: Players (copy)
    local v2 = Players:GetPlayerByUserId(u1);

    if v2 then
        return v2.Name;
    end;

    local success, result = pcall(function() -- Line: 9
        -- upvalues: Players (ref), u1 (copy)
        return Players:GetNameFromUserIdAsync(u1);
    end);

    return success and result and result or tostring(u1);
end;

local Remotes = require(ReplicatedStorage.CCPanel.Remotes);
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local u3 = Color3.fromRGB(30, 30, 35);
local u4 = Color3.fromRGB(22, 22, 27);
local u5 = Color3.fromRGB(45, 45, 52);
local u6 = Color3.fromRGB(60, 60, 70);
local u7 = Color3.fromRGB(60, 180, 90);
local u8 = Color3.fromRGB(180, 60, 60);
local u9 = Color3.fromRGB(220, 220, 230);
local u10 = Color3.fromRGB(150, 150, 165);
local u11 = Color3.fromRGB(50, 120, 200);
local GothamMedium = Enum.Font.GothamMedium;
local GothamBold = Enum.Font.GothamBold;

local function makeCorner(p12, p13) -- Line: 34
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, p13 or 6);
    UICorner.Parent = p12;
end;

local function makeLabel(p14, p15, p16, p17, p18, p19, p20, p21, p22) -- Line: 40
    -- upvalues: u9 (copy), GothamMedium (copy)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = p15;
    TextLabel.Size = p17;
    TextLabel.Position = p18;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = p16;
    TextLabel.TextSize = p19 or 14;
    TextLabel.TextColor3 = p20 or u9;
    TextLabel.Font = p21 or GothamMedium;
    TextLabel.TextXAlignment = p22 or Enum.TextXAlignment.Left;
    TextLabel.Parent = p14;

    return TextLabel;
end;

local function makeButton(p23, p24, p25, p26, p27, u28, p29) -- Line: 55
    -- upvalues: u5 (copy), u9 (copy), GothamMedium (copy), u6 (copy)
    local TextButton = Instance.new("TextButton");
    TextButton.Name = p24;
    TextButton.Size = p26;
    TextButton.Position = p27;
    TextButton.BackgroundColor3 = u28 or u5;
    TextButton.TextColor3 = p29 or u9;
    TextButton.Text = p25;
    TextButton.TextSize = 13;
    TextButton.Font = GothamMedium;
    TextButton.BorderSizePixel = 0;
    TextButton.AutoButtonColor = false;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 5);
    UICorner.Parent = TextButton;
    TextButton.Parent = p23;
    TextButton.MouseEnter:Connect(function() -- Line: 70
        -- upvalues: TextButton (copy), u6 (ref)
        TextButton.BackgroundColor3 = u6;
    end);
    TextButton.MouseLeave:Connect(function() -- Line: 71
        -- upvalues: TextButton (copy), u28 (copy), u5 (ref)
        TextButton.BackgroundColor3 = u28 or u5;
    end);

    return TextButton;
end;

local v30 = {};
local u31 = {};
local u32 = nil;
local u33 = false;
local u34 = nil;

local function lockedInvoke(u35, ...) -- Line: 84
    -- upvalues: u34 (ref)
    if u34 then
        u34(true);
    end;

    local u36 = { ... };
    local success, result = pcall(function() -- Line: 87
        -- upvalues: u35 (copy), u36 (copy)
        return u35:InvokeServer(table.unpack(u36));
    end);

    if u34 then
        u34(false);
    end;

    return success and result and result or {
        success = false,
        error = tostring(result)
    };
end;

local function setStatus(u37, u38, p39) -- Line: 96
    -- upvalues: u8 (copy), u7 (copy)
    u37.Text = u38;
    u37.TextColor3 = p39 and u8 or u7;
    task.delay(3, function() -- Line: 99
        -- upvalues: u37 (copy), u38 (copy)
        if u37.Text == u38 then
            u37.Text = "";
        end;
    end);
end;

local function renderPermsList(u40, p41, u42, u43) -- Line: 110
    -- upvalues: u5 (copy), u9 (copy), GothamMedium (copy), GothamBold (copy), u7 (copy), u8 (copy), lockedInvoke (copy), Remotes (copy), u10 (copy), GiftTreadmillConfig (copy), u11 (copy), u6 (copy), u33 (ref)
    for _, child in u40:GetChildren() do
        if not child:IsA("UIListLayout") then
            child:Destroy();
        end;
    end;

    if type(p41) ~= "table" or type(p41.permissions) ~= "table" then
        return;
    end;

    local v44 = 0;

    for i, v in p41.permissions do
        local Frame = Instance.new("Frame");
        Frame.Name = i;
        v44 = v44 + 10;
        Frame.LayoutOrder = v44;
        Frame.Size = UDim2.new(1, -8, 0, 36);
        Frame.BackgroundColor3 = u5;
        Frame.BorderSizePixel = 0;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0, 4);
        UICorner.Parent = Frame;
        Frame.Parent = u40;
        local v45 = UDim2.new(1, -70, 1, 0);
        local v46 = UDim2.new(0, 8, 0, 0);
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "Key";
        TextLabel.Size = v45;
        TextLabel.Position = v46;
        TextLabel.BackgroundTransparency = 1;
        TextLabel.Text = i;
        TextLabel.TextSize = 13;
        TextLabel.TextColor3 = u9 or u9;
        TextLabel.Font = GothamMedium or GothamMedium;
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel.Parent = Frame;
        local TextButton = Instance.new("TextButton");
        TextButton.Name = "Toggle";
        TextButton.Size = UDim2.new(0, 56, 0, 24);
        TextButton.Position = UDim2.new(1, -62, 0.5, -12);
        TextButton.Text = v and "ON" or "OFF";
        TextButton.TextSize = 12;
        TextButton.Font = GothamBold;
        TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
        TextButton.BackgroundColor3 = v and u7 or u8;
        TextButton.BorderSizePixel = 0;
        TextButton.AutoButtonColor = false;
        local UICorner2 = Instance.new("UICorner");
        UICorner2.CornerRadius = UDim.new(0, 4);
        UICorner2.Parent = TextButton;
        TextButton.Parent = Frame;
        local u47 = v;
        TextButton.MouseButton1Click:Connect(function() -- Line: 148
            -- upvalues: u47 (ref), TextButton (copy), u7 (ref), u8 (ref), lockedInvoke (ref), Remotes (ref), u42 (copy), i (copy), u43 (copy)
            u47 = not u47;
            TextButton.Text = u47 and "ON" or "OFF";
            TextButton.BackgroundColor3 = u47 and u7 or u8;
            local v48 = lockedInvoke(Remotes.Functions.updateCC, {
                userId = u42,
                permissions = {
                    [i] = u47
                }
            });

            if v48 and v48.success then
                local u49 = u43;
                local u50 = "Permission \'" .. i .. "\' updated";
                u49.Text = u50;
                u49.TextColor3 = u7;
                task.delay(3, function() -- Line: 99
                    -- upvalues: u49 (copy), u50 (copy)
                    if u49.Text == u50 then
                        u49.Text = "";
                    end;
                end);

                return;
            end;

            u47 = not u47;
            TextButton.Text = u47 and "ON" or "OFF";
            TextButton.BackgroundColor3 = u47 and u7 or u8;
            local u51 = u43;
            local u52 = v48 and v48.error or "Unknown error";
            u51.Text = u52;
            u51.TextColor3 = u8 or u7;
            task.delay(3, function() -- Line: 99
                -- upvalues: u51 (copy), u52 (copy)
                if u51.Text == u52 then
                    u51.Text = "";
                end;
            end);
        end);
    end;

    local v53 = type(p41.treadmill_gifts) == "table" and (p41.treadmill_gifts or {}) or {};
    local v54 = type(v53.treadmill_quotas) == "table" and (v53.treadmill_quotas or {}) or {};
    local v55 = type(v53.given) == "table" and (v53.given or {}) or {};
    local v56 = type(v53.periodStarts) == "table" and (v53.periodStarts or {}) or {};
    local v57 = type(v53.period_overrides) == "table" and (v53.period_overrides or {}) or {};

    local function parsePeriod(p58) -- Line: 181
        if p58 % 2592000 == 0 then
            local v59 = math.floor(p58 / 2592000);

            return "M", math.max(1, v59);
        end;

        local v60 = math.round(p58 / 604800);

        return "W", math.max(1, v60);
    end;

    local function formatPeriod(p61, p62) -- Line: 188
        if p61 == 0 then
            return "No activity";
        end;

        local v63 = os.time() - p61;

        if p62 <= v63 then
            return "Expired";
        end;

        local v64 = math.ceil((p62 - v63) / 86400);

        return math.floor(v63 / 86400) .. "d  (" .. v64 .. "d left)";
    end;

    local Frame = Instance.new("Frame");
    Frame.Name = "_QuotaDivider";
    Frame.LayoutOrder = 100;
    Frame.Size = UDim2.new(1, -8, 0, 24);
    Frame.BackgroundTransparency = 1;
    Frame.Parent = u40;
    local v65 = UDim2.new(1, 0, 1, 0);
    local v66 = UDim2.new(0, 0, 0, 0);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Lbl";
    TextLabel.Size = v65;
    TextLabel.Position = v66;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = "── Treadmill Quotas";
    TextLabel.TextSize = 12;
    TextLabel.TextColor3 = u10 or u9;
    TextLabel.Font = GothamMedium or GothamMedium;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame;
    local v67 = 0;

    for _, v in GiftTreadmillConfig.TREADMILLS do
        v67 = v67 + 1;
        local tag = v.tag;
        local v68 = v54[tag];
        local v69 = v68 or 0;
        local u70 = v55[tag] or 0;
        local v71 = math.max(0, v69 - u70);
        local u72 = v56[tag] or 0;
        local v73 = v68 == nil and "" or (tostring(v68) or "");
        local u74 = v69;
        local v75 = v57[tag] or v.periodSeconds;
        local v76, v77;

        if v75 % 2592000 == 0 then
            local v78 = math.floor(v75 / 2592000);
            v76 = math.max(1, v78);
            v77 = "M";
        else
            local v79 = math.round(v75 / 604800);
            v76 = math.max(1, v79);
            v77 = "W";
        end;

        local Frame2 = Instance.new("Frame");
        Frame2.Name = "Quota_" .. tag;
        Frame2.LayoutOrder = (v67 - 1) * 10 + 110;
        Frame2.Size = UDim2.new(1, -8, 0, 86);
        Frame2.BackgroundColor3 = u5;
        Frame2.BorderSizePixel = 0;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0, 4);
        UICorner.Parent = Frame2;
        Frame2.Parent = u40;
        local label = v.label;
        local v80 = UDim2.new(1, -100, 0, 20);
        local v81 = UDim2.new(0, 8, 0, 5);
        local TextLabel2 = Instance.new("TextLabel");
        TextLabel2.Name = "Lbl";
        TextLabel2.Size = v80;
        TextLabel2.Position = v81;
        TextLabel2.BackgroundTransparency = 1;
        TextLabel2.Text = label;
        TextLabel2.TextSize = 13;
        TextLabel2.TextColor3 = u9 or u9;
        TextLabel2.Font = GothamBold or GothamMedium;
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel2.Parent = Frame2;
        local v82 = UDim2.new(0, 42, 0, 20);
        local v83 = UDim2.new(1, -98, 0, 5);
        local TextLabel3 = Instance.new("TextLabel");
        TextLabel3.Name = "QuotaLbl";
        TextLabel3.Size = v82;
        TextLabel3.Position = v83;
        TextLabel3.BackgroundTransparency = 1;
        TextLabel3.Text = "Quota:";
        TextLabel3.TextSize = 12;
        TextLabel3.TextColor3 = u10 or u9;
        TextLabel3.Font = GothamMedium or GothamMedium;
        TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel3.Parent = Frame2;
        local TextBox = Instance.new("TextBox");
        TextBox.Name = "QuotaBox";
        TextBox.Size = UDim2.new(0, 44, 0, 20);
        TextBox.Position = UDim2.new(1, -50, 0, 5);
        TextBox.BackgroundColor3 = Color3.fromRGB(55, 55, 65);
        TextBox.TextColor3 = u9;
        TextBox.PlaceholderText = "0";
        TextBox.PlaceholderColor3 = u10;
        TextBox.Text = v73;
        TextBox.TextSize = 13;
        TextBox.Font = GothamMedium;
        TextBox.BorderSizePixel = 0;
        TextBox.TextXAlignment = Enum.TextXAlignment.Center;
        local UICorner2 = Instance.new("UICorner");
        UICorner2.CornerRadius = UDim.new(0, 3);
        UICorner2.Parent = TextBox;
        TextBox.Parent = Frame2;
        local v84;

        if u72 == 0 then
            v84 = "No activity";
        else
            local v85 = os.time() - u72;

            if v75 <= v85 then
                v84 = "Expired";
            else
                local v86 = math.ceil((v75 - v85) / 86400);
                v84 = math.floor(v85 / 86400) .. "d  (" .. v86 .. "d left)";
            end;
        end;

        local v87 = UDim2.new(1, -70, 0, 16);
        local v88 = UDim2.new(0, 8, 0, 32);
        local TextLabel4 = Instance.new("TextLabel");
        TextLabel4.Name = "Stats";
        TextLabel4.Size = v87;
        TextLabel4.Position = v88;
        TextLabel4.BackgroundTransparency = 1;
        TextLabel4.Text = "Given: " .. u70 .. "  Rem: " .. v71 .. "  " .. v84;
        TextLabel4.TextSize = 11;
        TextLabel4.TextColor3 = v71 > 0 and u7 or u10 or u9;
        TextLabel4.Font = GothamMedium or GothamMedium;
        TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel4.Parent = Frame2;
        local u89 = TextLabel4;
        local TextButton = Instance.new("TextButton");
        TextButton.Name = "ResetBtn";
        TextButton.Size = UDim2.new(0, 58, 0, 17);
        TextButton.Position = UDim2.new(1, -63, 0, 31);
        TextButton.BackgroundColor3 = u11;
        TextButton.TextColor3 = Color3.new(1, 1, 1);
        TextButton.Text = "↺ Reset";
        TextButton.TextSize = 11;
        TextButton.Font = GothamMedium;
        TextButton.BorderSizePixel = 0;
        TextButton.AutoButtonColor = false;
        local UICorner3 = Instance.new("UICorner");
        UICorner3.CornerRadius = UDim.new(0, 3);
        UICorner3.Parent = TextButton;
        TextButton.Parent = Frame2;
        TextButton.MouseEnter:Connect(function() -- Line: 273
            -- upvalues: TextButton (copy), u6 (ref)
            TextButton.BackgroundColor3 = u6;
        end);
        TextButton.MouseLeave:Connect(function() -- Line: 274
            -- upvalues: TextButton (copy), u11 (ref)
            TextButton.BackgroundColor3 = u11;
        end);
        local v90 = UDim2.new(0, 52, 0, 18);
        local v91 = UDim2.new(0, 8, 0, 56);
        local TextLabel5 = Instance.new("TextLabel");
        TextLabel5.Name = "PeriodLbl";
        TextLabel5.Size = v90;
        TextLabel5.Position = v91;
        TextLabel5.BackgroundTransparency = 1;
        TextLabel5.Text = "Period:";
        TextLabel5.TextSize = 11;
        TextLabel5.TextColor3 = u10 or u9;
        TextLabel5.Font = GothamMedium or GothamMedium;
        TextLabel5.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel5.Parent = Frame2;
        local TextButton2 = Instance.new("TextButton");
        TextButton2.Name = "ModeBtn";
        TextButton2.Size = UDim2.new(0, 64, 0, 18);
        TextButton2.Position = UDim2.new(0, 62, 0, 56);
        TextButton2.BackgroundColor3 = u5;
        TextButton2.TextColor3 = u9;
        TextButton2.Text = v77 == "W" and "Weeks" or "Months";
        TextButton2.TextSize = 11;
        TextButton2.Font = GothamBold;
        TextButton2.BorderSizePixel = 0;
        TextButton2.AutoButtonColor = false;
        local UICorner4 = Instance.new("UICorner");
        UICorner4.CornerRadius = UDim.new(0, 3);
        UICorner4.Parent = TextButton2;
        TextButton2.Parent = Frame2;
        TextButton2.MouseEnter:Connect(function() -- Line: 293
            -- upvalues: TextButton2 (copy), u6 (ref)
            TextButton2.BackgroundColor3 = u6;
        end);
        TextButton2.MouseLeave:Connect(function() -- Line: 294
            -- upvalues: TextButton2 (copy), u5 (ref)
            TextButton2.BackgroundColor3 = u5;
        end);
        local TextBox2 = Instance.new("TextBox");
        TextBox2.Name = "CountBox";
        TextBox2.Size = UDim2.new(0, 30, 0, 18);
        TextBox2.Position = UDim2.new(0, 130, 0, 56);
        TextBox2.BackgroundColor3 = Color3.fromRGB(55, 55, 65);
        TextBox2.TextColor3 = u9;
        TextBox2.Text = tostring(v76);
        TextBox2.TextSize = 12;
        TextBox2.Font = GothamMedium;
        TextBox2.BorderSizePixel = 0;
        TextBox2.TextXAlignment = Enum.TextXAlignment.Center;
        local UICorner5 = Instance.new("UICorner");
        UICorner5.CornerRadius = UDim.new(0, 3);
        UICorner5.Parent = TextBox2;
        TextBox2.Parent = Frame2;
        local v92 = "= " .. math.floor(v75 / 86400) .. "d";
        local v93 = UDim2.new(1, -170, 0, 18);
        local v94 = UDim2.new(0, 164, 0, 56);
        local TextLabel6 = Instance.new("TextLabel");
        TextLabel6.Name = "PeriodDisp";
        TextLabel6.Size = v93;
        TextLabel6.Position = v94;
        TextLabel6.BackgroundTransparency = 1;
        TextLabel6.Text = v92;
        TextLabel6.TextSize = 11;
        TextLabel6.TextColor3 = u10 or u9;
        TextLabel6.Font = GothamMedium or GothamMedium;
        TextLabel6.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel6.Parent = Frame2;
        local u95 = v77;
        local u96 = v76;
        local u97 = v73;

        local function computeSeconds() -- Line: 319
            -- upvalues: u96 (ref), u95 (ref)
            return u96 * (u95 == "W" and 604800 or 2592000);
        end;

        local function savePeriod() -- Line: 323
            -- upvalues: u96 (ref), u95 (ref), lockedInvoke (ref), Remotes (ref), u42 (copy), tag (copy), TextLabel6 (copy), u43 (copy), v (copy), u7 (ref), u8 (ref)
            local v98 = u96 * (u95 == "W" and 604800 or 2592000);
            local v99 = lockedInvoke(Remotes.Functions.updateCC, {
                userId = u42,
                treadmill_periods = {
                    [tag] = v98
                }
            });

            if v99 and v99.success then
                TextLabel6.Text = "= " .. math.floor(v98 / 86400) .. "d";
                local u100 = u43;
                local u101 = v.label .. " period → " .. math.floor(v98 / 86400) .. "d";
                u100.Text = u101;
                u100.TextColor3 = u7;
                task.delay(3, function() -- Line: 99
                    -- upvalues: u100 (copy), u101 (copy)
                    if u100.Text == u101 then
                        u100.Text = "";
                    end;
                end);

                return;
            end;

            TextLabel6.Text = "= " .. math.floor(u96 * (u95 == "W" and 604800 or 2592000) / 86400) .. "d";
            local u102 = u43;
            local u103 = v99 and v99.error or "Period error";
            u102.Text = u103;
            u102.TextColor3 = u8 or u7;
            task.delay(3, function() -- Line: 99
                -- upvalues: u102 (copy), u103 (copy)
                if u102.Text == u103 then
                    u102.Text = "";
                end;
            end);
        end;

        TextButton2.MouseButton1Click:Connect(function() -- Line: 339
            -- upvalues: u95 (ref), TextButton2 (copy), TextLabel6 (copy), u96 (ref), savePeriod (copy)
            u95 = u95 == "W" and "M" or "W";
            TextButton2.Text = u95 == "W" and "Weeks" or "Months";
            TextLabel6.Text = "= " .. math.floor(u96 * (u95 == "W" and 604800 or 2592000) / 86400) .. "d";
            savePeriod();
        end);
        TextBox2.FocusLost:Connect(function() -- Line: 346
            -- upvalues: u33 (ref), TextBox2 (copy), lockedInvoke (ref), Remotes (ref), u42 (copy), tag (copy), v (copy), u95 (ref), u96 (ref), TextButton2 (copy), TextLabel6 (copy), u43 (copy), u7 (ref), u8 (ref), savePeriod (copy)
            if u33 then
                return;
            end;

            local v104 = TextBox2.Text:match("^%s*(.-)%s*$");

            if v104 ~= "" then
                local v105 = tonumber(v104);

                if v105 and (v105 >= 1 and v105 == math.floor(v105)) then
                    u96 = v105;
                    savePeriod();

                    return;
                end;

                TextBox2.Text = tostring(u96);
                local u106 = u43;
                u106.Text = "Invalid count (integer ≥ 1)";
                u106.TextColor3 = u8 or u7;
                local u107 = "Invalid count (integer ≥ 1)";
                task.delay(3, function() -- Line: 99
                    -- upvalues: u106 (copy), u107 (copy)
                    if u106.Text == u107 then
                        u106.Text = "";
                    end;
                end);

                return;
            end;

            local v108 = lockedInvoke(Remotes.Functions.updateCC, {
                userId = u42,
                treadmill_periods = {
                    [tag] = -1
                }
            });

            if not (v108 and v108.success) then
                TextBox2.Text = tostring(u96);
                local u109 = u43;
                local u110 = v108 and v108.error or "Error";
                u109.Text = u110;
                u109.TextColor3 = u8 or u7;
                task.delay(3, function() -- Line: 99
                    -- upvalues: u109 (copy), u110 (copy)
                    if u109.Text == u110 then
                        u109.Text = "";
                    end;
                end);

                return;
            end;

            local periodSeconds = v.periodSeconds;
            local v111, v112;

            if periodSeconds % 2592000 == 0 then
                local v113 = math.floor(periodSeconds / 2592000);
                v111 = math.max(1, v113);
                v112 = "M";
            else
                local v114 = math.round(periodSeconds / 604800);
                v111 = math.max(1, v114);
                v112 = "W";
            end;

            u95 = v112;
            u96 = v111;
            TextButton2.Text = u95 == "W" and "Weeks" or "Months";
            TextBox2.Text = tostring(u96);
            TextLabel6.Text = "= " .. math.floor(v.periodSeconds / 86400) .. "d";
            local u115 = u43;
            local u116 = v.label .. " period → default";
            u115.Text = u116;
            u115.TextColor3 = u7;
            task.delay(3, function() -- Line: 99
                -- upvalues: u115 (copy), u116 (copy)
                if u115.Text == u116 then
                    u115.Text = "";
                end;
            end);
        end);
        TextBox.FocusLost:Connect(function() -- Line: 381
            -- upvalues: u33 (ref), TextBox (copy), lockedInvoke (ref), Remotes (ref), u42 (copy), tag (copy), u97 (ref), u89 (copy), u70 (copy), u72 (copy), u96 (ref), u95 (ref), u10 (ref), u43 (copy), v (copy), u7 (ref), u8 (ref), u74 (ref)
            if u33 then
                return;
            end;

            local v117 = TextBox.Text:match("^%s*(.-)%s*$");

            if v117 == "" then
                local v118 = lockedInvoke(Remotes.Functions.updateCC, {
                    userId = u42,
                    treadmill_quotas = {
                        [tag] = -1
                    }
                });

                if not (v118 and v118.success) then
                    TextBox.Text = u97;
                    local u119 = u43;
                    local u120 = v118 and v118.error or "Error";
                    u119.Text = u120;
                    u119.TextColor3 = u8 or u7;
                    task.delay(3, function() -- Line: 99
                        -- upvalues: u119 (copy), u120 (copy)
                        if u119.Text == u120 then
                            u119.Text = "";
                        end;
                    end);

                    return;
                end;

                u97 = "";
                local v121 = u72;
                local v122 = u96 * (u95 == "W" and 604800 or 2592000);
                local v123;

                if v121 == 0 then
                    v123 = "No activity";
                else
                    local v124 = os.time() - v121;

                    if v122 <= v124 then
                        v123 = "Expired";
                    else
                        local v125 = math.ceil((v122 - v124) / 86400);
                        v123 = math.floor(v124 / 86400) .. "d  (" .. v125 .. "d left)";
                    end;
                end;

                u89.Text = "Given: " .. u70 .. "  Rem: 0  " .. v123;
                u89.TextColor3 = u10;
                local u126 = u43;
                local u127 = v.label .. " quota removed";
                u126.Text = u127;
                u126.TextColor3 = u7;
                task.delay(3, function() -- Line: 99
                    -- upvalues: u126 (copy), u127 (copy)
                    if u126.Text == u127 then
                        u126.Text = "";
                    end;
                end);

                return;
            end;

            local v128 = tonumber(v117);

            if not v128 or (v128 < 0 or v128 ~= math.floor(v128)) then
                TextBox.Text = u97;
                local u129 = u43;
                u129.Text = "Invalid quota (integer ≥ 0)";
                u129.TextColor3 = u8 or u7;
                local u130 = "Invalid quota (integer ≥ 0)";
                task.delay(3, function() -- Line: 99
                    -- upvalues: u129 (copy), u130 (copy)
                    if u129.Text == u130 then
                        u129.Text = "";
                    end;
                end);

                return;
            end;

            local v131 = lockedInvoke(Remotes.Functions.updateCC, {
                userId = u42,
                treadmill_quotas = {
                    [tag] = v128
                }
            });

            if not (v131 and v131.success) then
                TextBox.Text = u97;
                local u132 = u43;
                local u133 = v131 and v131.error or "Error";
                u132.Text = u133;
                u132.TextColor3 = u8 or u7;
                task.delay(3, function() -- Line: 99
                    -- upvalues: u132 (copy), u133 (copy)
                    if u132.Text == u133 then
                        u132.Text = "";
                    end;
                end);

                return;
            end;

            u97 = v117;
            u74 = v128;
            local v134 = math.max(0, v128 - u70);
            local v135 = u72;
            local v136 = u96 * (u95 == "W" and 604800 or 2592000);
            local v137;

            if v135 == 0 then
                v137 = "No activity";
            else
                local v138 = os.time() - v135;

                if v136 <= v138 then
                    v137 = "Expired";
                else
                    local v139 = math.ceil((v136 - v138) / 86400);
                    v137 = math.floor(v138 / 86400) .. "d  (" .. v139 .. "d left)";
                end;
            end;

            u89.Text = "Given: " .. u70 .. "  Rem: " .. v134 .. "  " .. v137;
            u89.TextColor3 = v134 > 0 and u7 or u10;
            local u140 = u43;
            local u141 = v.label .. " quota → " .. v128;
            u140.Text = u141;
            u140.TextColor3 = u7;
            task.delay(3, function() -- Line: 99
                -- upvalues: u140 (copy), u141 (copy)
                if u140.Text == u141 then
                    u140.Text = "";
                end;
            end);
        end);
        TextButton.MouseButton1Click:Connect(function() -- Line: 424
            -- upvalues: lockedInvoke (ref), Remotes (ref), u42 (copy), tag (copy), u89 (copy), u74 (ref), u7 (ref), u10 (ref), u43 (copy), v (copy), u8 (ref)
            local v142 = lockedInvoke(Remotes.Functions.resetTreadmillPeriod, u42, tag);

            if not (v142 and v142.success) then
                local u143 = u43;
                local u144 = v142 and v142.error or "Reset error";
                u143.Text = u144;
                u143.TextColor3 = u8 or u7;
                task.delay(3, function() -- Line: 99
                    -- upvalues: u143 (copy), u144 (copy)
                    if u143.Text == u144 then
                        u143.Text = "";
                    end;
                end);

                return;
            end;

            u89.Text = "Given: 0  Rem: " .. u74 .. "  No activity";
            u89.TextColor3 = u74 > 0 and u7 or u10;
            local u145 = u43;
            local u146 = v.label .. " period reset";
            u145.Text = u146;
            u145.TextColor3 = u7;
            task.delay(3, function() -- Line: 99
                -- upvalues: u145 (copy), u146 (copy)
                if u145.Text == u146 then
                    u145.Text = "";
                end;
            end);
        end);
    end;

    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Padding = UDim.new(0, 4);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = u40;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.PaddingTop = UDim.new(0, 4);
    UIPadding.PaddingLeft = UDim.new(0, 4);
    UIPadding.PaddingRight = UDim.new(0, 4);
    UIPadding.Parent = u40;
    u40.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 12);
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 448
        -- upvalues: u40 (copy), UIListLayout (copy)
        u40.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 12);
    end);
end;

local function selectCC(u147, u148, p149, u150) -- Line: 457
    -- upvalues: u33 (ref), Remotes (copy), u8 (copy), u7 (copy), lockedInvoke (copy), u32 (ref), renderPermsList (copy)
    local CCName = p149:FindFirstChild("CCName");
    local AccessBtn = p149:FindFirstChild("AccessBtn");
    local PermsList = p149:FindFirstChild("PermsList");

    if CCName then
        CCName.Text = u148 .. "  [" .. u147 .. "]";
    end;

    if AccessBtn then
        AccessBtn.Text = "Access: ...";
    end;

    u33 = true;

    if PermsList then
        for _, child in PermsList:GetChildren() do
            if not (child:IsA("UIListLayout") or child:IsA("UIPadding")) then
                child:Destroy();
            end;
        end;
    end;

    local v151 = Remotes.Functions.getCCPermissions:InvokeServer(u147);

    if not (v151 and v151.success) then
        u33 = false;
        local u152 = v151 and v151.error or "Failed to get permissions";
        u150.Text = u152;
        u150.TextColor3 = u8 or u7;
        task.delay(3, function() -- Line: 99
            -- upvalues: u150 (copy), u152 (copy)
            if u150.Text == u152 then
                u150.Text = "";
            end;
        end);

        return;
    end;

    local data = v151.data;
    local u153;

    if type(data) == "table" then
        u153 = data.access == true;
    else
        u153 = false;
    end;

    if AccessBtn then
        AccessBtn.Text = "Access: " .. (u153 and "ON" or "OFF");
        AccessBtn.BackgroundColor3 = u153 and u7 or u8;
        local u154 = AccessBtn:Clone();
        AccessBtn:Destroy();
        u154.Parent = p149;
        u154.MouseButton1Click:Connect(function() -- Line: 491
            -- upvalues: u153 (ref), lockedInvoke (ref), Remotes (ref), u147 (copy), u154 (copy), u7 (ref), u8 (ref), u150 (copy)
            local v155 = not u153;
            local v156 = lockedInvoke(Remotes.Functions.updateCC, {
                userId = u147,
                access = v155
            });

            if not (v156 and v156.success) then
                local u157 = u150;
                local u158 = v156 and v156.error or "Error";
                u157.Text = u158;
                u157.TextColor3 = u8 or u7;
                task.delay(3, function() -- Line: 99
                    -- upvalues: u157 (copy), u158 (copy)
                    if u157.Text == u158 then
                        u157.Text = "";
                    end;
                end);

                return;
            end;

            u153 = v155;
            u154.Text = "Access: " .. (u153 and "ON" or "OFF");
            u154.BackgroundColor3 = u153 and u7 or u8;
            local u159 = u150;
            u159.Text = "Access updated";
            u159.TextColor3 = u7;
            local u160 = "Access updated";
            task.delay(3, function() -- Line: 99
                -- upvalues: u159 (copy), u160 (copy)
                if u159.Text == u160 then
                    u159.Text = "";
                end;
            end);
        end);
    end;

    local RemoveBtn = p149:FindFirstChild("RemoveBtn");

    if RemoveBtn then
        RemoveBtn.Active = true;
        local v161 = RemoveBtn:Clone();
        RemoveBtn:Destroy();
        v161.Parent = p149;
        v161.MouseButton1Click:Connect(function() -- Line: 514
            -- upvalues: lockedInvoke (ref), Remotes (ref), u147 (copy), u150 (copy), u148 (copy), u7 (ref), u32 (ref), u8 (ref)
            local v162 = lockedInvoke(Remotes.Functions.removeCC, u147);

            if v162 and v162.success then
                local u163 = u150;
                local u164 = u148 .. " removed from panel";
                u163.Text = u164;
                u163.TextColor3 = u7;
                task.delay(3, function() -- Line: 99
                    -- upvalues: u163 (copy), u164 (copy)
                    if u163.Text == u164 then
                        u163.Text = "";
                    end;
                end);

                if u32 then
                    task.delay(0.3, u32);
                end;
            else
                local u165 = u150;
                local u166 = v162 and v162.error or "Error";
                u165.Text = u166;
                u165.TextColor3 = u8 or u7;
                task.delay(3, function() -- Line: 99
                    -- upvalues: u165 (copy), u166 (copy)
                    if u165.Text == u166 then
                        u165.Text = "";
                    end;
                end);
            end;
        end);
    end;

    if PermsList then
        renderPermsList(PermsList, data, u147, u150);
    end;

    u33 = false;
end;

local function renderFiltered(u167, u168, u169, p170) -- Line: 535
    -- upvalues: u31 (ref), u10 (copy), GothamMedium (copy), u9 (copy), u5 (copy), GothamBold (copy), u6 (copy), selectCC (copy), Players (copy)
    for _, child in u167:GetChildren() do
        if not (child:IsA("UIListLayout") or child:IsA("UIPadding")) then
            child:Destroy();
        end;
    end;

    local v171 = (p170 or ""):lower():match("^%s*(.-)%s*$");
    local v172 = {};

    for _, v in u31 do
        local v173 = v.name and v.name:lower():find(v171, 1, true);
        local v174 = tostring(v.userId):find(v171, 1, true);

        if v171 == "" or (v173 or v174) then
            table.insert(v172, v);
        end;
    end;

    if #v172 == 0 then
        local v175 = UDim2.new(1, 0, 0, 36);
        local v176 = UDim2.new(0, 0, 0, 0);
        local Center = Enum.TextXAlignment.Center;
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "Empty";
        TextLabel.Size = v175;
        TextLabel.Position = v176;
        TextLabel.BackgroundTransparency = 1;
        TextLabel.Text = v171 == "" and "No CCs registered" or ("No results for \"" .. p170 .. "\"" or "No CCs registered");
        TextLabel.TextSize = 13;
        TextLabel.TextColor3 = u10 or u9;
        TextLabel.Font = GothamMedium or GothamMedium;
        TextLabel.TextXAlignment = Center or Enum.TextXAlignment.Left;
        TextLabel.Parent = u167;
    end;

    for _, v in v172 do
        local TextButton = Instance.new("TextButton");
        TextButton.Name = tostring(v.userId);
        TextButton.Size = UDim2.new(1, -8, 0, 52);
        TextButton.BackgroundColor3 = u5;
        TextButton.Text = "";
        TextButton.BorderSizePixel = 0;
        TextButton.AutoButtonColor = false;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0, 6);
        UICorner.Parent = TextButton;
        TextButton.Parent = u167;
        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Name = "Avatar";
        ImageLabel.Size = UDim2.new(0, 38, 0, 38);
        ImageLabel.Position = UDim2.new(0, 7, 0.5, -19);
        ImageLabel.BackgroundColor3 = Color3.fromRGB(55, 55, 65);
        ImageLabel.BorderSizePixel = 0;
        ImageLabel.ScaleType = Enum.ScaleType.Crop;
        local UICorner2 = Instance.new("UICorner");
        UICorner2.CornerRadius = UDim.new(0, 19);
        UICorner2.Parent = ImageLabel;
        ImageLabel.Parent = TextButton;
        local Frame = Instance.new("Frame");
        Frame.Name = "Dot";
        Frame.Size = UDim2.new(0, 12, 0, 12);
        Frame.Position = UDim2.new(0, 34, 0.5, 9);
        Frame.BackgroundColor3 = v.online and Color3.fromRGB(80, 220, 100) or Color3.fromRGB(90, 90, 105);
        Frame.BorderSizePixel = 0;
        local UICorner3 = Instance.new("UICorner");
        UICorner3.CornerRadius = UDim.new(0, 6);
        UICorner3.Parent = Frame;
        Frame.ZIndex = 3;
        Frame.Parent = TextButton;
        local v177 = v.name or tostring(v.userId);
        local v178 = UDim2.new(1, -110, 0, 18);
        local v179 = UDim2.new(0, 52, 0, 8);
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "Name";
        TextLabel.Size = v178;
        TextLabel.Position = v179;
        TextLabel.BackgroundTransparency = 1;
        TextLabel.Text = v177;
        TextLabel.TextSize = 14;
        TextLabel.TextColor3 = u9 or u9;
        TextLabel.Font = GothamBold or GothamMedium;
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel.Parent = TextButton;
        TextLabel.TextTruncate = Enum.TextTruncate.AtEnd;
        local v180 = tostring(v.userId);
        local v181 = UDim2.new(1, -110, 0, 14);
        local v182 = UDim2.new(0, 52, 0, 28);
        local TextLabel2 = Instance.new("TextLabel");
        TextLabel2.Name = "UserId";
        TextLabel2.Size = v181;
        TextLabel2.Position = v182;
        TextLabel2.BackgroundTransparency = 1;
        TextLabel2.Text = v180;
        TextLabel2.TextSize = 11;
        TextLabel2.TextColor3 = u10 or u9;
        TextLabel2.Font = GothamMedium or GothamMedium;
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel2.Parent = TextButton;
        TextButton.MouseEnter:Connect(function() -- Line: 600
            -- upvalues: TextButton (copy), u6 (ref)
            TextButton.BackgroundColor3 = u6;
        end);
        TextButton.MouseLeave:Connect(function() -- Line: 601
            -- upvalues: TextButton (copy), u5 (ref)
            TextButton.BackgroundColor3 = u5;
        end);
        TextButton.MouseButton1Click:Connect(function() -- Line: 603
            -- upvalues: selectCC (ref), v (copy), u168 (copy), u169 (copy)
            selectCC(v.userId, v.name or tostring(v.userId), u168, u169);
        end);
        task.spawn(function() -- Line: 607
            -- upvalues: Players (ref), v (copy), ImageLabel (copy)
            local success, result = pcall(function() -- Line: 608
                -- upvalues: Players (ref), v (ref)
                return Players:GetUserThumbnailAsync(v.userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48);
            end);

            if success and (result and (result ~= "" and ImageLabel.Parent)) then
                ImageLabel.Image = result;
            end;
        end);
    end;

    local u183 = u167:FindFirstChildWhichIsA("UIListLayout");

    if u183 then
        u167.CanvasSize = UDim2.new(0, 0, 0, u183.AbsoluteContentSize.Y + 12);
        u183:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 624
            -- upvalues: u167 (copy), u183 (copy)
            u167.CanvasSize = UDim2.new(0, 0, 0, u183.AbsoluteContentSize.Y + 12);
        end);
    end;
end;

local function fetchAndRender(p184, p185, u186, p187) -- Line: 630
    -- upvalues: Remotes (copy), u8 (copy), u7 (copy), Players (copy), u31 (ref), renderFiltered (copy)
    local v188 = Remotes.Functions.fetchCC:InvokeServer();

    if v188 and v188.success then
        local v189 = v188.data or {};

        for _, v in v189 do
            local userId = v.userId;
            local v190 = Players:GetPlayerByUserId(userId);
            local v191;

            if v190 then
                v191 = v190.Name;
            else
                local success, result = pcall(function() -- Line: 9
                    -- upvalues: Players (ref), userId (copy)
                    return Players:GetNameFromUserIdAsync(userId);
                end);
                v191 = success and result and result or tostring(userId);
            end;

            v.name = v191;
            v.online = Players:GetPlayerByUserId(v.userId) ~= nil;
        end;

        u31 = v189;
        renderFiltered(p184, p185, u186, p187 and p187.Text or "");

        return;
    end;

    local u192 = v188 and v188.error or "Failed to fetch CCs";
    u186.Text = u192;
    u186.TextColor3 = u8 or u7;
    task.delay(3, function() -- Line: 99
        -- upvalues: u186 (copy), u192 (copy)
        if u186.Text == u192 then
            u186.Text = "";
        end;
    end);
end;

function v30.createPanel(u193) -- Line: 654
    -- upvalues: PlayerGui (copy), u3 (copy), u4 (copy), u9 (copy), GothamBold (copy), GothamMedium (copy), u5 (copy), u10 (copy), makeButton (copy), u11 (copy), u34 (ref), u8 (copy), u7 (copy), renderFiltered (copy), Remotes (copy), Players (copy), fetchAndRender (copy), u32 (ref)
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "CCManagerGui";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.DisplayOrder = 300;
    ScreenGui.Enabled = false;
    ScreenGui.Parent = PlayerGui;
    local Frame = Instance.new("Frame");
    Frame.Name = "Panel";
    Frame.Size = UDim2.new(0, 700, 0, 500);
    Frame.Position = UDim2.new(0.5, -350, 0.5, -250);
    Frame.BackgroundColor3 = u3;
    Frame.BorderSizePixel = 0;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 8);
    UICorner.Parent = Frame;
    Frame.Parent = ScreenGui;
    local UIDragDetector = Instance.new("UIDragDetector");
    UIDragDetector.DragStyle = Enum.UIDragDetectorDragStyle.TranslatePlane;
    UIDragDetector.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Header";
    Frame2.Size = UDim2.new(1, 0, 0, 44);
    Frame2.BackgroundColor3 = u4;
    Frame2.BorderSizePixel = 0;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(0, 8);
    UICorner2.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Size = UDim2.new(1, 0, 0.5, 0);
    Frame3.Position = UDim2.new(0, 0, 0.5, 0);
    Frame3.BackgroundColor3 = u4;
    Frame3.BorderSizePixel = 0;
    Frame3.Parent = Frame2;
    local v194 = UDim2.new(1, -50, 1, 0);
    local v195 = UDim2.new(0, 14, 0, 0);
    local Left = Enum.TextXAlignment.Left;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.Size = v194;
    TextLabel.Position = v195;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = "CC Manager";
    TextLabel.TextSize = 16;
    TextLabel.TextColor3 = u9 or u9;
    TextLabel.Font = GothamBold or GothamMedium;
    TextLabel.TextXAlignment = Left or Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame2;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "CloseBtn";
    TextButton.Size = UDim2.new(0, 32, 0, 32);
    TextButton.Position = UDim2.new(1, -38, 0.5, -16);
    TextButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60);
    TextButton.Text = "✕";
    TextButton.TextSize = 16;
    TextButton.Font = GothamBold;
    TextButton.TextColor3 = Color3.new(1, 1, 1);
    TextButton.BorderSizePixel = 0;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.CornerRadius = UDim.new(0, 5);
    UICorner3.Parent = TextButton;
    TextButton.Parent = Frame2;
    TextButton.MouseButton1Click:Connect(function() -- Line: 708
        -- upvalues: ScreenGui (copy), u193 (copy)
        ScreenGui.Enabled = false;

        if u193 then
            u193();
        end;
    end);
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Body";
    Frame4.Size = UDim2.new(1, 0, 1, -74);
    Frame4.Position = UDim2.new(0, 0, 0, 44);
    Frame4.BackgroundTransparency = 1;
    Frame4.Parent = Frame;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "LeftCol";
    Frame5.Size = UDim2.new(0.4, -6, 1, -8);
    Frame5.Position = UDim2.new(0, 6, 0, 6);
    Frame5.BackgroundTransparency = 1;
    Frame5.Parent = Frame4;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "AddRow";
    Frame6.Size = UDim2.new(1, 0, 0, 30);
    Frame6.Position = UDim2.new(0, 0, 0, 0);
    Frame6.BackgroundTransparency = 1;
    Frame6.Parent = Frame5;
    local TextBox = Instance.new("TextBox");
    TextBox.Name = "UsernameBox";
    TextBox.Size = UDim2.new(1, -66, 1, 0);
    TextBox.Position = UDim2.new(0, 0, 0, 0);
    TextBox.BackgroundColor3 = u5;
    TextBox.TextColor3 = u9;
    TextBox.PlaceholderText = "Username or User ID...";
    TextBox.PlaceholderColor3 = u10;
    TextBox.Text = "";
    TextBox.TextSize = 13;
    TextBox.Font = GothamMedium;
    TextBox.BorderSizePixel = 0;
    TextBox.ClearTextOnFocus = false;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.CornerRadius = UDim.new(0, 5);
    UICorner4.Parent = TextBox;
    TextBox.Parent = Frame6;
    local u196 = makeButton(Frame6, "AddBtn", "+ Add", UDim2.new(0, 60, 1, 0), UDim2.new(1, -60, 0, 0), Color3.fromRGB(50, 160, 80), Color3.new(1, 1, 1));
    local TextBox2 = Instance.new("TextBox");
    TextBox2.Name = "SearchBox";
    TextBox2.Size = UDim2.new(1, 0, 0, 30);
    TextBox2.Position = UDim2.new(0, 0, 0, 36);
    TextBox2.BackgroundColor3 = u5;
    TextBox2.TextColor3 = u9;
    TextBox2.PlaceholderText = "🔍  Search...";
    TextBox2.PlaceholderColor3 = u10;
    TextBox2.Text = "";
    TextBox2.TextSize = 13;
    TextBox2.Font = GothamMedium;
    TextBox2.BorderSizePixel = 0;
    TextBox2.ClearTextOnFocus = false;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.CornerRadius = UDim.new(0, 5);
    UICorner5.Parent = TextBox2;
    TextBox2.Parent = Frame5;
    local v197 = makeButton(Frame5, "RefreshBtn", "↺  Refresh", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 72), u11, Color3.new(1, 1, 1));
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "CCList";
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -106);
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 106);
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BorderSizePixel = 0;
    ScrollingFrame.ScrollBarThickness = 4;
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120);
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0);
    ScrollingFrame.Parent = Frame5;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Padding = UDim.new(0, 4);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = ScrollingFrame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.PaddingTop = UDim.new(0, 4);
    UIPadding.PaddingLeft = UDim.new(0, 4);
    UIPadding.PaddingRight = UDim.new(0, 4);
    UIPadding.Parent = ScrollingFrame;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "RightCol";
    Frame7.Size = UDim2.new(0.6, -8, 1, -8);
    Frame7.Position = UDim2.new(0.4, 2, 0, 6);
    Frame7.BackgroundColor3 = Color3.fromRGB(38, 38, 45);
    Frame7.BorderSizePixel = 0;
    local UICorner6 = Instance.new("UICorner");
    UICorner6.CornerRadius = UDim.new(0, 6);
    UICorner6.Parent = Frame7;
    Frame7.Parent = Frame4;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "PendingOverlay";
    Frame8.Size = UDim2.new(1, 0, 1, 0);
    Frame8.BackgroundColor3 = u3;
    Frame8.BackgroundTransparency = 0.5;
    Frame8.BorderSizePixel = 0;
    Frame8.ZIndex = 50;
    Frame8.Visible = false;
    local UICorner7 = Instance.new("UICorner");
    UICorner7.CornerRadius = UDim.new(0, 6);
    UICorner7.Parent = Frame8;
    Frame8.Parent = Frame7;
    local v198 = UDim2.new(1, 0, 1, 0);
    local v199 = UDim2.new(0, 0, 0, 0);
    local Center = Enum.TextXAlignment.Center;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Lbl";
    TextLabel2.Size = v198;
    TextLabel2.Position = v199;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.Text = "Loading...";
    TextLabel2.TextSize = 13;
    TextLabel2.TextColor3 = u10 or u9;
    TextLabel2.Font = GothamBold or GothamMedium;
    TextLabel2.TextXAlignment = Center or Enum.TextXAlignment.Left;
    TextLabel2.Parent = Frame8;

    u34 = function(p200) -- Line: 823
        -- upvalues: Frame8 (copy), Frame7 (copy)
        Frame8.Visible = p200;
        Frame7.Interactable = not p200;
    end;

    local v201 = UDim2.new(1, -12, 0, 28);
    local v202 = UDim2.new(0, 10, 0, 8);
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "CCName";
    TextLabel3.Size = v201;
    TextLabel3.Position = v202;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.Text = "Select a CC";
    TextLabel3.TextSize = 14;
    TextLabel3.TextColor3 = u10 or u9;
    TextLabel3.Font = GothamMedium or GothamMedium;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.Parent = Frame7;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "AccessBtn";
    TextButton2.Size = UDim2.new(1, -122, 0, 32);
    TextButton2.Position = UDim2.new(0, 10, 0, 42);
    TextButton2.Text = "Access: —";
    TextButton2.TextSize = 14;
    TextButton2.Font = GothamBold;
    TextButton2.TextColor3 = Color3.new(1, 1, 1);
    TextButton2.BackgroundColor3 = u5;
    TextButton2.BorderSizePixel = 0;
    TextButton2.AutoButtonColor = false;
    local UICorner8 = Instance.new("UICorner");
    UICorner8.CornerRadius = UDim.new(0, 5);
    UICorner8.Parent = TextButton2;
    TextButton2.Parent = Frame7;
    makeButton(Frame7, "RemoveBtn", "× Remove", UDim2.new(0, 106, 0, 32), UDim2.new(1, -112, 0, 42), u8, Color3.new(1, 1, 1)).Active = false;
    local v203 = UDim2.new(1, -12, 0, 20);
    local v204 = UDim2.new(0, 10, 0, 82);
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "PermsTitle";
    TextLabel4.Size = v203;
    TextLabel4.Position = v204;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.Text = "Permissions";
    TextLabel4.TextSize = 13;
    TextLabel4.TextColor3 = u10 or u9;
    TextLabel4.Font = GothamMedium or GothamMedium;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.Parent = Frame7;
    local ScrollingFrame2 = Instance.new("ScrollingFrame");
    ScrollingFrame2.Name = "PermsList";
    ScrollingFrame2.Size = UDim2.new(1, -10, 1, -110);
    ScrollingFrame2.Position = UDim2.new(0, 5, 0, 106);
    ScrollingFrame2.BackgroundTransparency = 1;
    ScrollingFrame2.BorderSizePixel = 0;
    ScrollingFrame2.ScrollBarThickness = 4;
    ScrollingFrame2.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120);
    ScrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0);
    ScrollingFrame2.Parent = Frame7;
    local v205 = UDim2.new(1, -20, 0, 24);
    local v206 = UDim2.new(0, 10, 1, -28);
    local Left2 = Enum.TextXAlignment.Left;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "StatusBar";
    TextLabel5.Size = v205;
    TextLabel5.Position = v206;
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.Text = "";
    TextLabel5.TextSize = 13;
    TextLabel5.TextColor3 = u7 or u9;
    TextLabel5.Font = GothamMedium or GothamMedium;
    TextLabel5.TextXAlignment = Left2 or Enum.TextXAlignment.Left;
    TextLabel5.Parent = Frame;
    TextBox2:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 870
        -- upvalues: renderFiltered (ref), ScrollingFrame (copy), Frame7 (copy), TextLabel5 (copy), TextBox2 (copy)
        renderFiltered(ScrollingFrame, Frame7, TextLabel5, TextBox2.Text);
    end);

    local function doAddCC() -- Line: 875
        -- upvalues: TextBox (copy), TextLabel5 (copy), u7 (ref), u196 (copy), Remotes (ref), Players (ref), fetchAndRender (ref), ScrollingFrame (copy), Frame7 (copy), TextBox2 (copy), u8 (ref)
        local v207 = TextBox.Text:match("^%s*(.-)%s*$");

        if #v207 == 0 then
            return;
        end;

        local v208 = tonumber(v207) or v207;
        local u209 = TextLabel5;
        local u210 = "Registering " .. v207 .. "...";
        u209.Text = u210;
        u209.TextColor3 = u7;
        task.delay(3, function() -- Line: 99
            -- upvalues: u209 (copy), u210 (copy)
            if u209.Text == u210 then
                u209.Text = "";
            end;
        end);
        u196.Active = false;
        local v211 = Remotes.Functions.registerCC:InvokeServer(v208);
        u196.Active = true;

        if not (v211 and v211.success) then
            local u212 = TextLabel5;
            local u213 = v211 and v211.error or "Error";
            u212.Text = u213;
            u212.TextColor3 = u8 or u7;
            task.delay(3, function() -- Line: 99
                -- upvalues: u212 (copy), u213 (copy)
                if u212.Text == u213 then
                    u212.Text = "";
                end;
            end);

            return;
        end;

        TextBox.Text = "";

        if v211.userId then
            local userId = v211.userId;
            local v214 = Players:GetPlayerByUserId(userId);
            local v215;

            if v214 then
                v215 = v214.Name;
            else
                local success, result = pcall(function() -- Line: 9
                    -- upvalues: Players (ref), userId (copy)
                    return Players:GetNameFromUserIdAsync(userId);
                end);
                v215 = success and result and result or tostring(userId);
            end;

            v207 = v215 or v207;
        end;

        local u216 = TextLabel5;
        local u217 = v207 .. " registered as CC";
        u216.Text = u217;
        u216.TextColor3 = u7;
        task.delay(3, function() -- Line: 99
            -- upvalues: u216 (copy), u217 (copy)
            if u216.Text == u217 then
                u216.Text = "";
            end;
        end);
        fetchAndRender(ScrollingFrame, Frame7, TextLabel5, TextBox2);
    end;

    u196.MouseButton1Click:Connect(doAddCC);
    TextBox.FocusLost:Connect(function(p218) -- Line: 899
        -- upvalues: doAddCC (copy)
        if p218 then
            doAddCC();
        end;
    end);
    v197.MouseButton1Click:Connect(function() -- Line: 904
        -- upvalues: fetchAndRender (ref), ScrollingFrame (copy), Frame7 (copy), TextLabel5 (copy), TextBox2 (copy)
        fetchAndRender(ScrollingFrame, Frame7, TextLabel5, TextBox2);
    end);

    u32 = function() -- Line: 908
        -- upvalues: fetchAndRender (ref), ScrollingFrame (copy), Frame7 (copy), TextLabel5 (copy), TextBox2 (copy)
        fetchAndRender(ScrollingFrame, Frame7, TextLabel5, TextBox2);
    end;

    return ScreenGui;
end;

function v30.toggle(p219) -- Line: 915
    -- upvalues: fetchAndRender (copy)
    p219.Enabled = not p219.Enabled;
    local v220 = p219.Enabled and p219:FindFirstChild("Panel");

    if v220 then
        local Body = v220:FindFirstChild("Body");
        local StatusBar = v220:FindFirstChild("StatusBar");

        if Body and StatusBar then
            local LeftCol = Body:FindFirstChild("LeftCol");
            local RightCol = Body:FindFirstChild("RightCol");

            if LeftCol and RightCol then
                local CCList = LeftCol:FindFirstChild("CCList");
                local SearchBox = LeftCol:FindFirstChild("SearchBox");

                if CCList then
                    fetchAndRender(CCList, RightCol, StatusBar, SearchBox);
                end;
            end;
        end;
    end;
end;

return v30;