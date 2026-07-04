-- Ruta Original: ReplicatedStorage.UISystems.X2BoostUISystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local MarketplaceService = game:GetService("MarketplaceService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local X2BoostConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("X2BoostConfig"));
local Ads = require(ReplicatedStorage:WaitForChild("Monetization"):WaitForChild("Ads"));
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local X2BoostSync = Remotes:WaitForChild("X2BoostSync");
local LocalPlayer = Players.LocalPlayer;
local u1 = {};
local u2 = false;
local u3 = nil;

local function formatTime(p4) -- Line: 27
    local v5 = math.floor(p4 / 60);
    local v6 = math.floor(p4 % 60);

    return string.format("%02d:%02d", v5, v6);
end;

local function getRemaining() -- Line: 33
    -- upvalues: ClientState (copy)
    local X2BoostExpiresAt = ClientState:Get().X2BoostExpiresAt;

    if not X2BoostExpiresAt then
        return 0;
    end;

    local v7 = X2BoostExpiresAt - os.time();

    return math.max(0, v7);
end;

function u1.UpdateDisplay(p8) -- Line: 43
    -- upvalues: ClientState (copy), CollectionService (copy)
    local X2BoostExpiresAt = ClientState:Get().X2BoostExpiresAt;
    local v9;

    if X2BoostExpiresAt then
        local v10 = X2BoostExpiresAt - os.time();
        v9 = math.max(0, v10);
    else
        v9 = 0;
    end;

    local v11 = v9 > 0;

    for _, v in ipairs(CollectionService:GetTagged("X2BoostTimerLabel")) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            if v11 then
                local v12 = math.floor(v9 / 60);
                local v13 = math.floor(v9 % 60);
                v.Text = "x2 Active — " .. string.format("%02d:%02d", v12, v13);
                v.Visible = true;
            else
                v.Text = "";
                v.Visible = false;
            end;
        end;
    end;
end;

local function startTimer() -- Line: 63
    -- upvalues: u3 (ref), ClientState (copy), u1 (copy)
    if u3 then
        return;
    end;

    u3 = task.spawn(function() -- Line: 65
        -- upvalues: ClientState (ref), u1 (ref), u3 (ref)
        while true do
            local X2BoostExpiresAt = ClientState:Get().X2BoostExpiresAt;
            local v14;

            if X2BoostExpiresAt then
                local v15 = X2BoostExpiresAt - os.time();
                v14 = math.max(0, v15);
            else
                v14 = 0;
            end;

            if v14 <= 0 then
                u1:UpdateDisplay();
                u3 = nil;

                return;
            end;

            u1:UpdateDisplay();
            task.wait(1);
        end;
    end);
end;

local u16 = {
    Buy10Min = X2BoostConfig.PRODUCTS[1].ProductId,
    Buy30Min = X2BoostConfig.PRODUCTS[2].ProductId,
    Buy1Hour = X2BoostConfig.PRODUCTS[3].ProductId
};

local function handleBuyButton(p17) -- Line: 85
    -- upvalues: u16 (copy), MarketplaceService (copy), LocalPlayer (copy)
    if p17:GetAttribute("IsConnected") then
        return;
    end;

    p17:SetAttribute("IsConnected", true);
    local u18 = u16[p17:GetAttribute("Action")];
    local Price = p17:FindFirstChild("Price");

    if Price and u18 then
        task.spawn(function() -- Line: 93
            -- upvalues: MarketplaceService (ref), u18 (copy), Price (copy)
            local success, result = pcall(MarketplaceService.GetProductInfoAsync, MarketplaceService, u18, Enum.InfoType.Product);

            if success and (result and result.PriceInRobux) then
                Price.Text = tostring(result.PriceInRobux);
            end;
        end);
    end;

    p17.MouseButton1Click:Connect(function() -- Line: 101
        -- upvalues: u18 (copy), MarketplaceService (ref), LocalPlayer (ref)
        if u18 then
            MarketplaceService:PromptProductPurchase(LocalPlayer, u18);
        end;
    end);
end;

local u19 = false;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = Color3.fromRGB(128, 128, 128);

local function setAdBtnGrayed(p25) -- Line: 116
    -- upvalues: u20 (ref), u21 (ref), u22 (ref), u24 (copy)
    if not u20 then
        return;
    end;

    if not p25 then
        u20.AutoButtonColor = true;
        u20.ImageColor3 = u21 or Color3.new(1, 1, 1);
        u20.BackgroundColor3 = u22 or Color3.new(1, 1, 1);

        return;
    end;

    u21 = u21 or u20.ImageColor3;
    u22 = u22 or u20.BackgroundColor3;
    u20.AutoButtonColor = false;
    u20.ImageColor3 = u24;
    u20.BackgroundColor3 = u24;
end;

local function startAdPoll() -- Line: 131
    -- upvalues: u23 (ref), Ads (copy), u19 (ref), u20 (ref), u21 (ref), u22 (ref)
    if u23 then
        return;
    end;

    u23 = task.spawn(function() -- Line: 133
        -- upvalues: Ads (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref)
        repeat
            task.wait(30);
        until Ads.checkForAds();

        u19 = false;

        if u20 then
            u20.AutoButtonColor = true;
            u20.ImageColor3 = u21 or Color3.new(1, 1, 1);
            u20.BackgroundColor3 = u22 or Color3.new(1, 1, 1);
        end;

        u23 = nil;
    end);
end;

local function onDebounceEnd() -- Line: 147
    -- upvalues: Ads (copy), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref)
    task.spawn(function() -- Line: 148
        -- upvalues: Ads (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref)
        if not Ads.checkForAds() then
            if u23 then
                return;
            end;

            u23 = task.spawn(function() -- Line: 133
                -- upvalues: Ads (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref)
                repeat
                    task.wait(30);
                until Ads.checkForAds();

                u19 = false;

                if u20 then
                    u20.AutoButtonColor = true;
                    u20.ImageColor3 = u21 or Color3.new(1, 1, 1);
                    u20.BackgroundColor3 = u22 or Color3.new(1, 1, 1);
                end;

                u23 = nil;
            end);

            return;
        end;

        u19 = false;

        if not u20 then
            return;
        end;

        u20.AutoButtonColor = true;
        u20.ImageColor3 = u21 or Color3.new(1, 1, 1);
        u20.BackgroundColor3 = u22 or Color3.new(1, 1, 1);
    end);
end;

local function setupAdRewardButton(u26) -- Line: 159
    -- upvalues: u20 (ref), Ads (copy), u19 (ref), u21 (ref), u22 (ref), u24 (copy), u23 (ref), Remotes (copy), onDebounceEnd (copy)
    if u26:GetAttribute("IsConnected") then
        return;
    end;

    u26:SetAttribute("IsConnected", true);
    u20 = u26;
    task.spawn(function() -- Line: 165
        -- upvalues: Ads (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u24 (ref), u23 (ref), u26 (copy), Remotes (ref), onDebounceEnd (ref)
        if not Ads.checkForAds() then
            u19 = true;

            if u20 then
                u21 = u21 or u20.ImageColor3;
                u22 = u22 or u20.BackgroundColor3;
                u20.AutoButtonColor = false;
                u20.ImageColor3 = u24;
                u20.BackgroundColor3 = u24;
            end;

            if not u23 then
                u23 = task.spawn(function() -- Line: 133
                    -- upvalues: Ads (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref)
                    repeat
                        task.wait(30);
                    until Ads.checkForAds();

                    u19 = false;

                    if u20 then
                        u20.AutoButtonColor = true;
                        u20.ImageColor3 = u21 or Color3.new(1, 1, 1);
                        u20.BackgroundColor3 = u22 or Color3.new(1, 1, 1);
                    end;

                    u23 = nil;
                end);
            end;
        end;

        u26.MouseButton1Click:Connect(function() -- Line: 173
            -- upvalues: u19 (ref), u20 (ref), u21 (ref), u22 (ref), u24 (ref), Remotes (ref), onDebounceEnd (ref)
            if u19 then
                return;
            end;

            u19 = true;

            if u20 then
                u21 = u21 or u20.ImageColor3;
                u22 = u22 or u20.BackgroundColor3;
                u20.AutoButtonColor = false;
                u20.ImageColor3 = u24;
                u20.BackgroundColor3 = u24;
            end;

            local RequestAdX2Boost = Remotes:FindFirstChild("RequestAdX2Boost");

            if RequestAdX2Boost then
                RequestAdX2Boost:FireServer();
            end;

            task.delay(30, onDebounceEnd);
        end);
    end);
end;

local function handleButton(p27) -- Line: 186
    -- upvalues: setupAdRewardButton (copy), handleBuyButton (copy)
    if p27:GetAttribute("Action") == "AdReward10Min" then
        setupAdRewardButton(p27);

        return;
    end;

    handleBuyButton(p27);
end;

function u1.InitLogic(u28) -- Line: 198
    -- upvalues: u2 (ref), X2BoostSync (copy), ClientState (copy), u3 (ref), u1 (copy), CollectionService (copy), setupAdRewardButton (copy), handleBuyButton (copy)
    if u2 then
        return;
    end;

    u2 = true;
    X2BoostSync.OnClientEvent:Connect(function(p29) -- Line: 202
        -- upvalues: ClientState (ref), u3 (ref), u1 (ref), u28 (copy)
        if type(p29) == "table" and p29.expiresAt then
            ClientState:Update({
                X2BoostExpiresAt = p29.expiresAt
            });

            if not u3 then
                u3 = task.spawn(function() -- Line: 65
                    -- upvalues: ClientState (ref), u1 (ref), u3 (ref)
                    while true do
                        local X2BoostExpiresAt = ClientState:Get().X2BoostExpiresAt;
                        local v30;

                        if X2BoostExpiresAt then
                            local v31 = X2BoostExpiresAt - os.time();
                            v30 = math.max(0, v31);
                        else
                            v30 = 0;
                        end;

                        if v30 <= 0 then
                            u1:UpdateDisplay();
                            u3 = nil;

                            return;
                        end;

                        u1:UpdateDisplay();
                        task.wait(1);
                    end;
                end);
            end;
        else
            ClientState:Update({
                X2BoostExpiresAt = nil
            });
        end;

        u28:UpdateDisplay();
    end);

    for _, v in ipairs(CollectionService:GetTagged("x2BoostButton")) do
        if v:IsA("GuiButton") then
            if v:GetAttribute("Action") == "AdReward10Min" then
                setupAdRewardButton(v);
            else
                handleBuyButton(v);
            end;
        end;
    end;

    CollectionService:GetInstanceAddedSignal("x2BoostButton"):Connect(function(p32) -- Line: 215
        -- upvalues: setupAdRewardButton (ref), handleBuyButton (ref)
        if p32:IsA("GuiButton") then
            if p32:GetAttribute("Action") == "AdReward10Min" then
                setupAdRewardButton(p32);

                return;
            end;

            handleBuyButton(p32);
        end;
    end);
    u28:UpdateDisplay();
end;

return u1;