-- Ruta Original: ReplicatedStorage.UISystems.CosmeticInventoryUI
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local MarketplaceService = game:GetService("MarketplaceService");
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local GiftConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("GiftConfig"));
local Numbers = require(script.Parent.Parent.Utilities.Numbers);
local u1 = {};
local u2 = Color3.fromHex("3cff00");
local u3 = Color3.fromHex("ffffff");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");

local function getModalsFrame() -- Line: 21
    -- upvalues: PlayerGui (copy)
    local v4 = PlayerGui:FindFirstChild("SpeedGameUI") and v4:FindFirstChild("Modals") and v4:FindFirstChild("InventoryModal") and v4:FindFirstChild("ModalsFrame");

    return v4;
end;

function u1.getInventoryTab(p5) -- Line: 28
    -- upvalues: PlayerGui (copy)
    local v6 = PlayerGui:FindFirstChild("SpeedGameUI") and v6:FindFirstChild("Modals") and v6:FindFirstChild("InventoryModal") and v6:FindFirstChild("ModalsFrame") and v6:FindFirstChild(p5);

    return v6;
end;

function u1.whenInventoryTabReady(u7, u8) -- Line: 33
    -- upvalues: PlayerGui (copy)
    task.spawn(function() -- Line: 34
        -- upvalues: PlayerGui (ref), u7 (copy), u8 (copy)
        u8((PlayerGui:WaitForChild("SpeedGameUI"):WaitForChild("Modals"):WaitForChild("InventoryModal"):WaitForChild("ModalsFrame"):WaitForChild(u7)));
    end);
end;

local function getGiftModalElement(p9) -- Line: 45
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged("GiftToPlayer")) do
        if v:IsDescendantOf(PlayerGui) and v:GetAttribute("Type") == p9 then
            return v;
        end;
    end;

    return nil;
end;

local function getGiftModal() -- Line: 54
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged("GiftToPlayerModal")) do
        if v:IsDescendantOf(PlayerGui) then
            return v;
        end;
    end;

    return nil;
end;

local u10 = false;

function u1.openGiftModal(p11) -- Line: 65
    -- upvalues: u10 (ref), GiftConfig (copy), getGiftModal (copy), getGiftModalElement (copy), PlayerGui (copy), ClientState (copy)
    if u10 then
        return;
    end;

    u10 = true;
    task.delay(0.5, function() -- Line: 68
        -- upvalues: u10 (ref)
        u10 = false;
    end);
    local v12 = GiftConfig.ALL_GIFTS[p11];

    if not v12 then
        return;
    end;

    local v13 = getGiftModal();

    if not v13 then
        return;
    end;

    v13:SetAttribute("GiftType", p11);
    local v14 = getGiftModalElement("ItemNameLabel");

    if v14 then
        v14.Text = v12.Name;
    end;

    local v15 = getGiftModalElement("ItemImage");

    if v15 then
        v15.Image = v12.Image;
    end;

    local v16 = getGiftModalElement("UsernameInput");

    if v16 then
        v16.Text = "";
    end;

    local v17 = getGiftModalElement("AvatarImage");

    if v17 then
        v17.Image = "";
    end;

    local v18 = getGiftModalElement("PlayerNameLabel");

    if v18 then
        v18.Text = "";
    end;

    if v13.Parent and (v13.Parent.Name == "InventoryModal" or v13.Parent.Name == "ModalsFrame") then
        local v19 = PlayerGui:FindFirstChild("SpeedGameUI") and v19:FindFirstChild("Modals");

        if v19 then
            v13.Parent = v19;
        end;
    end;

    ClientState:ToggleModal(v13);
end;

function u1.getRowTemplate(p20, p21) -- Line: 112
    local v22 = p20:FindFirstChild(p21);

    if v22 and not v22:GetAttribute("CosmeticKey") then
        return v22;
    end;

    return nil;
end;

function u1.getScrollingFrame(p23) -- Line: 120
    local ScrollingFrame = p23:FindFirstChild("ScrollingFrame");

    if ScrollingFrame and ScrollingFrame:IsA("ScrollingFrame") then
        return ScrollingFrame;
    end;

    return p23:FindFirstChildWhichIsA("ScrollingFrame");
end;

function u1.isEventActive(p24) -- Line: 128
    -- upvalues: ReplicatedStorage (copy)
    local v25 = os.time();

    for _, v in ipairs(require(ReplicatedStorage:WaitForChild("EventsConfig")).Events or {}) do
        if v.Name == p24 and (v.Start <= v25 and v25 < v.End) then
            return true;
        end;
    end;

    return false;
end;

function u1.isTrailEventLive(p26) -- Line: 138
    -- upvalues: u1 (copy)
    for _, v in ipairs(p26.Events or {}) do
        if u1.isEventActive(v) then
            return true;
        end;
    end;

    return false;
end;

function u1.shouldHideEventTrail(p27, p28, p29) -- Line: 147
    -- upvalues: u1 (copy)
    if table.find(p28, p29) == nil then
        return not u1.isTrailEventLive(p27);
    end;

    return false;
end;

function u1.showRow(p30) -- Line: 154
    p30.Visible = true;
end;

function u1.formatBoostText(p31) -- Line: 158
    -- upvalues: Numbers (copy)
    return "👟 x" .. Numbers.formatMultiplier(p31) .. " Speed Boost";
end;

function u1.applyRowColor(p32, p33) -- Line: 162
    if not p33 then
        return;
    end;

    if typeof(p33) == "Color3" then
        p32.BackgroundColor3 = p33;
        local v34 = p32:FindFirstChildWhichIsA("UIGradient");

        if v34 then
            v34.Enabled = false;
        end;
    elseif typeof(p33) == "ColorSequence" then
        p32.BackgroundColor3 = Color3.new(1, 1, 1);
        local v35 = p32:FindFirstChildWhichIsA("UIGradient");

        if not v35 then
            v35 = Instance.new("UIGradient");
            v35.Parent = p32;
        end;

        v35.Enabled = true;
        v35.Color = p33;
    end;
end;

function u1.applyRowContent(p36, p37, p38, p39, p40) -- Line: 183
    -- upvalues: u1 (copy)
    local Icon = p36:FindFirstChild("Icon", true);

    if Icon and (Icon:IsA("ImageLabel") or Icon:IsA("ImageButton")) and p38 then
        Icon.Image = p38;
    end;

    local Title = p36:FindFirstChild("Title", true);

    if Title and Title:IsA("TextLabel") then
        Title.Text = p37;
    end;

    local Multiplier = p36:FindFirstChild("Multiplier", true);

    if Multiplier and Multiplier:IsA("TextLabel") then
        Multiplier.Text = u1.formatBoostText(p39);
    end;

    u1.applyRowColor(p36, p40);
end;

function u1.clearBuiltRows(p41) -- Line: 202
    if not p41 then
        return;
    end;

    for _, child in ipairs(p41:GetChildren()) do
        if child:GetAttribute("CosmeticKey") then
            child:Destroy();
        end;
    end;
end;

local function setPriceLabel(p42, p43) -- Line: 211
    if not p42 then
        return;
    end;

    local Price = p42:FindFirstChild("Price");

    if Price and Price:IsA("TextLabel") then
        Price.Text = p43;
    end;
end;

local function connectButton(p44, p45) -- Line: 219
    if not (p44 and p44:IsA("GuiButton")) then
        return;
    end;

    if p44:GetAttribute("IsConnected") then
        return;
    end;

    p44:SetAttribute("IsConnected", true);
    p44.MouseButton1Click:Connect(p45);
end;

local function setGamepassPrice(u46, u47) -- Line: 226
    -- upvalues: MarketplaceService (copy)
    if not u46 or (not u47 or u47 <= 0) then
        return;
    end;

    task.spawn(function() -- Line: 228
        -- upvalues: MarketplaceService (ref), u47 (copy), u46 (copy)
        local success, result = pcall(MarketplaceService.GetProductInfo, MarketplaceService, u47, Enum.InfoType.GamePass);

        if success and (result and result.PriceInRobux) then
            local v48 = u46;
            local v49 = tostring(result.PriceInRobux);

            if not v48 then
                return;
            end;

            local Price = v48:FindFirstChild("Price");

            if Price and Price:IsA("TextLabel") then
                Price.Text = v49;
            end;
        end;
    end);
end;

local u50 = UDim2.new(0.9, 0, 0.5, 0);

local function applySoloBuyButtonLayout(p51, p52, p53, p54) -- Line: 238
    -- upvalues: u50 (copy)
    local v55 = p51 and p53;
    local v56 = p52 and p54;

    if v55 and not v56 then
        p51.Position = u50;

        return;
    end;

    if v56 and not v55 then
        p52.Position = u50;
    end;
end;

function u1.wireRow(p57, p58) -- Line: 249
    -- upvalues: MarketplaceService (copy), u50 (copy)
    local BuyWins = p57:FindFirstChild("BuyWins");
    local BuyGamepass = p57:FindFirstChild("BuyGamepass");
    local BuyGift = p57:FindFirstChild("BuyGift");
    local Equip = p57:FindFirstChild("Equip");
    local v59 = p57:GetAttribute("CosmeticKey");
    local v60 = p58.showBuyWins == true;
    local v61 = p58.showBuyGamepass == true;
    local v62 = p58.showBuyGift == true;
    p57:SetAttribute("ShowBuyWins", v60);
    p57:SetAttribute("ShowBuyGamepass", v61);
    p57:SetAttribute("ShowBuyGift", v62);

    if BuyWins then
        if v59 then
            BuyWins:SetAttribute("Type", v59);
        end;

        BuyWins.Visible = v60;

        if v60 and p58.winsPriceText then
            local winsPriceText = p58.winsPriceText;

            if BuyWins then
                local Price = BuyWins:FindFirstChild("Price");

                if Price and Price:IsA("TextLabel") then
                    Price.Text = winsPriceText;
                end;
            end;
        end;

        if p58.onBuyWins then
            local onBuyWins = p58.onBuyWins;

            if BuyWins and (BuyWins:IsA("GuiButton") and not BuyWins:GetAttribute("IsConnected")) then
                BuyWins:SetAttribute("IsConnected", true);
                BuyWins.MouseButton1Click:Connect(onBuyWins);
            end;
        end;
    end;

    if BuyGamepass then
        if v59 then
            BuyGamepass:SetAttribute("Type", v59);
        end;

        BuyGamepass.Visible = v61;

        if v61 and p58.gamepassId then
            local gamepassId = p58.gamepassId;

            if BuyGamepass and (gamepassId and gamepassId > 0) then
                task.spawn(function() -- Line: 228
                    -- upvalues: MarketplaceService (ref), gamepassId (copy), BuyGamepass (copy)
                    local success, result = pcall(MarketplaceService.GetProductInfo, MarketplaceService, gamepassId, Enum.InfoType.GamePass);

                    if success and (result and result.PriceInRobux) then
                        local v63 = BuyGamepass;
                        local v64 = tostring(result.PriceInRobux);

                        if not v63 then
                            return;
                        end;

                        local Price = v63:FindFirstChild("Price");

                        if Price and Price:IsA("TextLabel") then
                            Price.Text = v64;
                        end;
                    end;
                end);
            end;
        end;

        if p58.onBuyGamepass then
            local onBuyGamepass = p58.onBuyGamepass;

            if BuyGamepass and (BuyGamepass:IsA("GuiButton") and not BuyGamepass:GetAttribute("IsConnected")) then
                BuyGamepass:SetAttribute("IsConnected", true);
                BuyGamepass.MouseButton1Click:Connect(onBuyGamepass);
            end;
        end;
    end;

    if BuyGift then
        if v59 then
            BuyGift:SetAttribute("Type", v59);
        end;

        BuyGift.Visible = v62;

        if p58.onBuyGift then
            local onBuyGift = p58.onBuyGift;

            if BuyGift and (BuyGift:IsA("GuiButton") and not BuyGift:GetAttribute("IsConnected")) then
                BuyGift:SetAttribute("IsConnected", true);
                BuyGift.MouseButton1Click:Connect(onBuyGift);
            end;
        end;
    end;

    if Equip and p58.onEquip then
        if v59 then
            Equip:SetAttribute("Type", v59);
        end;

        local onEquip = p58.onEquip;

        if Equip and (Equip:IsA("GuiButton") and not Equip:GetAttribute("IsConnected")) then
            Equip:SetAttribute("IsConnected", true);
            Equip.MouseButton1Click:Connect(onEquip);
        end;
    end;

    local v65 = BuyWins and v60;
    local v66 = BuyGamepass and v61;

    if v65 and not v66 then
        BuyWins.Position = u50;

        return;
    end;

    if v66 and not v65 then
        BuyGamepass.Position = u50;
    end;
end;

function u1.updateRowState(p67, p68, p69) -- Line: 302
    -- upvalues: u1 (copy), u2 (copy), u3 (copy)
    if p67:GetAttribute("Hidden") == true then
        p67.Visible = false;

        return;
    end;

    u1.showRow(p67);
    local BuyWins = p67:FindFirstChild("BuyWins");
    local BuyGamepass = p67:FindFirstChild("BuyGamepass");
    local BuyGift = p67:FindFirstChild("BuyGift");
    local Equip = p67:FindFirstChild("Equip");

    if BuyWins then
        local v70 = not p68 and p67:GetAttribute("ShowBuyWins") == true;
        BuyWins.Visible = v70;
    end;

    if BuyGamepass then
        local v71 = not p68 and p67:GetAttribute("ShowBuyGamepass") == true;
        BuyGamepass.Visible = v71;
    end;

    if BuyGift then
        BuyGift.Visible = p67:GetAttribute("ShowBuyGift") == true;
    end;

    if Equip then
        Equip.Visible = p68;
        Equip.BackgroundColor3 = p69 and u2 or u3;
        local v72 = Equip:FindFirstChildWhichIsA("TextLabel");

        if v72 then
            v72.Text = p69 and "Equipped" or "Equip";
            v72.TextColor3 = p69 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200);
        end;
    end;
end;

return u1;