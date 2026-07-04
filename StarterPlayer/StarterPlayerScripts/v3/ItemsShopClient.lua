-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.ItemsShopClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Items = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("Items"));
local ItemsShopConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("ItemsShopConfig"));
local SoundManager = require(ReplicatedStorage:WaitForChild("SoundManager"));
local NotificationSystem = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local ItemsShopRemotes = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("ItemsShopRemotes"));
local u1 = nil;
local u2 = false;

local function getShopElement(p3, p4) -- Line: 33
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged("ItemsShop")) do
        if v:IsDescendantOf(PlayerGui) and (v:GetAttribute("Rarity") == p3 and v:GetAttribute("Type") == p4) then
            return v;
        end;
    end;

    return nil;
end;

local function getShopElementByType(p5) -- Line: 44
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged("ItemsShop")) do
        if v:IsDescendantOf(PlayerGui) and v:GetAttribute("Type") == p5 then
            return v;
        end;
    end;

    return nil;
end;

local function formatNumber(p6) -- Line: 55
    if p6 >= 1000000000 then
        return string.format("%.1fB", p6 / 1000000000);
    end;

    if p6 >= 1000000 then
        return string.format("%.1fM", p6 / 1000000);
    end;

    if p6 >= 1000 then
        return string.format("%.1fK", p6 / 1000);
    end;

    return tostring(p6);
end;

local function updateSlotUI(p7, p8, p9, p10) -- Line: 70
    -- upvalues: Items (copy), getShopElement (copy), getShopElementByType (copy)
    if not p8 then
        return;
    end;

    local v11 = Items.ITEMS[p8];

    if not v11 then
        return;
    end;

    local v12 = math.max(0, p9 - p10);
    local v13 = getShopElement(p7, "Stock");

    if v13 then
        if v12 <= 0 then
            v13.Text = "Sold out";
        else
            v13.Text = v12 .. "/" .. p9;
        end;
    end;

    local v14 = getShopElement(p7, "Icon");

    if v14 then
        v14.Image = v11.icon;
    end;

    local v15 = getShopElement(p7, "Name");

    if v15 then
        v15.Text = v11.name;
    end;

    local v16 = getShopElementByType("Bonus" .. p7);

    if v16 then
        v16.Text = "+" .. math.floor(v11.multiplier * 100) .. "% Speed";
    end;
end;

local function updateMysteriousUI(p17, p18, p19, p20) -- Line: 107
    -- upvalues: Items (copy), getShopElement (copy), getShopElementByType (copy), ItemsShopConfig (copy), RunService (copy)
    if not (p17 and p18) then
        return;
    end;

    local v21 = Items.ITEMS[p17];

    if not v21 then
        return;
    end;

    local v22 = math.max(0, p19 - p20);
    local v23 = getShopElement("Mysterious", "Stock");

    if v23 then
        if v22 <= 0 then
            v23.Text = "Sold out";
        else
            v23.Text = v22 .. "/" .. p19;
        end;
    end;

    local v24 = getShopElement("Mysterious", "Icon");

    if v24 then
        v24.Image = v21.icon;
    end;

    local v25 = getShopElement("Mysterious", "Name");

    if v25 then
        v25.Text = v21.name;
    end;

    local u26 = getShopElementByType("MysteriousFrame");

    if u26 then
        local v27 = ItemsShopConfig.MYSTERIOUS_FRAME_COLORS[p18];

        if v27 then
            u26.BackgroundColor3 = v27;
        end;

        local v28 = p18 == "Mythic";
        local v29 = p18 == "Secret";
        local UIGradientMythic = u26:FindFirstChild("UIGradientMythic");
        local UIGradientBase = u26:FindFirstChild("UIGradientBase");

        if UIGradientMythic then
            UIGradientMythic.Enabled = v28;
        end;

        if UIGradientBase then
            UIGradientBase.Enabled = not v28 and not v29;
        end;

        local UIGradientSecret = u26:FindFirstChild("UIGradientSecret");

        if v29 then
            if not UIGradientSecret then
                UIGradientSecret = Instance.new("UIGradient");
                UIGradientSecret.Name = "UIGradientSecret";
                UIGradientSecret.Parent = u26;
            end;

            UIGradientSecret.Enabled = true;

            if not u26:GetAttribute("_secretAnimRunning") then
                u26:SetAttribute("_secretAnimRunning", true);
                task.spawn(function() -- Line: 167
                    -- upvalues: UIGradientSecret (ref), RunService (ref), u26 (copy)
                    local v30 = 0;

                    while UIGradientSecret and (UIGradientSecret.Parent and UIGradientSecret.Enabled) do
                        v30 = v30 + RunService.Heartbeat:Wait() * 0.4;
                        local v31 = math.cos(v30 * 3.141592653589793 * 2) * 0.4 + 0.6;
                        local v32 = math.cos((v30 + 0.15) * 3.141592653589793 * 2) * 0.4 + 0.6;
                        local v33 = math.cos((v30 + 0.3) * 3.141592653589793 * 2) * 0.4 + 0.6;
                        UIGradientSecret.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(v31 * 255, v31 * 255, v31 * 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(v32 * 255, v32 * 255, v32 * 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(v33 * 255, v33 * 255, v33 * 255)) });
                    end;

                    if u26 and u26.Parent then
                        u26:SetAttribute("_secretAnimRunning", nil);
                    end;
                end);
            end;
        elseif UIGradientSecret then
            UIGradientSecret.Enabled = false;
            u26:SetAttribute("_secretAnimRunning", nil);
        end;
    end;

    local v34 = getShopElementByType("MysteriousRarity");

    if v34 then
        v34.Text = p18;
        local v35 = ItemsShopConfig.MYSTERIOUS_RARITY_COLORS[p18];

        if v35 then
            v34.TextColor3 = v35;
        end;
    end;

    local v36 = getShopElementByType("BonusMysterious");

    if v36 then
        v36.Text = "+" .. math.floor(v21.multiplier * 100) .. "% Speed";
        local v37 = ItemsShopConfig.MYSTERIOUS_RARITY_COLORS[p18];

        if v37 then
            v36.TextColor3 = v37;
        end;
    end;

    local v38 = getShopElement("Mysterious", "BuyRobux");
    local v39 = v38 and v38:FindFirstChild("Price");

    if v39 then
        v39.Text = ItemsShopConfig.MYSTERIOUS_ROBUX_PRICES[p18] or "???";
    end;

    local v40 = getShopElement("Mysterious", "BuyWins");
    local v41 = v40 and v40:FindFirstChild("Price");

    if v41 then
        v41.Text = ItemsShopConfig.MYSTERIOUS_WINS_DISPLAY[p18] or "???";
    end;
end;

local function setBuyButtonsVisible(p42) -- Line: 233
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged("ItemsShop")) do
        if v:IsDescendantOf(PlayerGui) then
            local v43 = v:GetAttribute("Type");

            if v43 == "BuyWins" or v43 == "BuyRobux" then
                v.Visible = p42;
            end;
        end;
    end;

    for _, v in ipairs(CollectionService:GetTagged("GiftItem")) do
        if v:IsDescendantOf(PlayerGui) then
            v.Visible = p42;
        end;
    end;
end;

local function updateGiftItemButtons(p44) -- Line: 250
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged("GiftItem")) do
        if v:IsDescendantOf(PlayerGui) then
            local v45 = v:GetAttribute("Slot");

            if v45 and p44[v45] then
                v:SetAttribute("ItemKey", p44[v45]);
            else
                v:SetAttribute("ItemKey", "");
            end;
        end;
    end;
end;

local function refreshShopUI() -- Line: 263
    -- upvalues: u1 (ref), setBuyButtonsVisible (copy), updateSlotUI (copy), updateMysteriousUI (copy), updateGiftItemButtons (copy)
    if not u1 then
        return;
    end;

    if not u1.active then
        setBuyButtonsVisible(false);

        return;
    end;

    setBuyButtonsVisible(true);
    local items = u1.items;
    local stocks = u1.stocks;
    local v46 = u1.purchases or {};

    if not (items and stocks) then
        return;
    end;

    updateSlotUI("Common", items.Common, stocks.Common or 0, v46.Common or 0);
    updateSlotUI("Uncommon", items.Uncommon, stocks.Uncommon or 0, v46.Uncommon or 0);
    updateSlotUI("Rare", items.Rare, stocks.Rare or 0, v46.Rare or 0);
    updateMysteriousUI(items.Mysterious, u1.mysteriousRarity, stocks.Mysterious or 0, v46.Mysterious or 0);
    updateGiftItemButtons(items);
end;

local u47 = nil;

local function startCountdown() -- Line: 295
    -- upvalues: u47 (ref), RunService (copy), u1 (ref), getShopElementByType (copy)
    if u47 then
        u47:Disconnect();
    end;

    u47 = RunService.Heartbeat:Connect(function() -- Line: 300
        -- upvalues: u1 (ref), getShopElementByType (ref)
        if not u1 then
            return;
        end;

        local v48 = (u1.nextRestockTime or 0) - os.time();
        local v49 = math.max(0, v48);
        local v50 = math.floor(v49 / 60);
        local v51 = v49 % 60;
        local v52 = getShopElementByType("NewItemsText");

        if v52 then
            v52.Text = string.format("New items in %dm %02ds", v50, v51);
        end;

        if not u1.active then
            local v53 = string.format("%dm %02ds", v50, v51);

            for _, v in ipairs({ "BonusCommon", "BonusUncommon", "BonusRare", "BonusMysterious" }) do
                local v54 = getShopElementByType(v);

                if v54 then
                    v54.Text = v53;
                end;
            end;
        end;
    end);
end;

local u55 = {};

local function connectBuyButton(u56) -- Line: 334
    -- upvalues: u55 (copy), PlayerGui (copy), u2 (ref), u1 (ref), ItemsShopRemotes (copy)
    if u55[u56] then
        return;
    end;

    if not u56:IsDescendantOf(PlayerGui) then
        return;
    end;

    local u57 = u56:GetAttribute("Rarity");
    local u58 = u56:GetAttribute("Type");

    if not (u57 and u58) then
        return;
    end;

    if u58 ~= "BuyWins" and u58 ~= "BuyRobux" then
        return;
    end;

    u55[u56] = true;
    u56.Activated:Connect(function() -- Line: 347
        -- upvalues: u2 (ref), u1 (ref), u57 (copy), u58 (copy), ItemsShopRemotes (ref)
        if u2 then
            return;
        end;

        if not (u1 and u1.active) then
            return;
        end;

        local v59 = u57;
        local v60 = ((u1.stocks or {})[v59] or 0) - ((u1.purchases or {})[v59] or 0);

        if u58 == "BuyWins" then
            if v60 <= 0 then
                return;
            end;

            u2 = true;
            ItemsShopRemotes.BuyWins:fire(v59);
        elseif u58 == "BuyRobux" then
            u2 = true;
            ItemsShopRemotes.BuyRobux:fire(v59);
        end;

        task.delay(0.3, function() -- Line: 367
            -- upvalues: u2 (ref)
            u2 = false;
        end);
    end);
    u56.Destroying:Connect(function() -- Line: 372
        -- upvalues: u55 (ref), u56 (copy)
        u55[u56] = nil;
    end);
end;

local function connectRestockButton(u61) -- Line: 377
    -- upvalues: u55 (copy), PlayerGui (copy), u2 (ref), ItemsShopRemotes (copy)
    if u55[u61] then
        return;
    end;

    if not u61:IsDescendantOf(PlayerGui) then
        return;
    end;

    u55[u61] = true;
    u61.Activated:Connect(function() -- Line: 383
        -- upvalues: u2 (ref), ItemsShopRemotes (ref)
        if u2 then
            return;
        end;

        u2 = true;
        ItemsShopRemotes.PromptRestock:fire();
        task.delay(0.3, function() -- Line: 387
            -- upvalues: u2 (ref)
            u2 = false;
        end);
    end);
    u61.Destroying:Connect(function() -- Line: 392
        -- upvalues: u55 (ref), u61 (copy)
        u55[u61] = nil;
    end);
end;

local u62 = { "CommonFrame", "UncommonFrame", "RareFrame", "MysteriousFrame" };

local function getShopFrames() -- Line: 416
    -- upvalues: u62 (copy), getShopElementByType (copy)
    local v63 = {};

    for _, v in ipairs(u62) do
        local v64 = getShopElementByType(v);

        if v64 then
            table.insert(v63, v64);
        end;
    end;

    return v63;
end;

local function playRestockAnimation() -- Line: 427
    -- upvalues: getShopFrames (copy), TweenService (copy), refreshShopUI (copy)
    local v65 = getShopFrames();

    if #v65 == 0 then
        return;
    end;

    local v66 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In);
    local v67 = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
    local v68 = {};

    for _, v in ipairs(v65) do
        v68[v] = v.Size;
    end;

    for _, v in ipairs(v65) do
        TweenService:Create(v, v66, {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play();
    end;

    task.wait(0.25);
    refreshShopUI();

    for _, v in ipairs(v65) do
        v.Size = UDim2.new(0, 0, 0, 0);
        TweenService:Create(v, v67, {
            Size = v68[v]
        }):Play();
    end;
end;

local u69 = Color3.fromRGB(255, 70, 70);
local u70 = {
    NotEnoughWins = "Not enough wins",
    OutOfStock = "Out of stock",
    ShopNotActive = "Shop not active"
};
local u71 = nil;
ItemsShopRemotes.ShopUpdate:connect(function(p72) -- Line: 471
    -- upvalues: SoundManager (copy), u70 (copy), NotificationSystem (copy), u69 (copy), u71 (ref), u1 (ref), playRestockAnimation (copy), refreshShopUI (copy)
    if p72.sound then
        SoundManager:Play(p72.sound);
    end;

    if p72.message then
        NotificationSystem:ShowGeneralNotification(u70[p72.message] or p72.message, u69);
    end;

    if p72.active ~= nil then
        local v73 = u71;
        u71 = p72.active;
        u1 = p72;

        if p72.restock then
            if v73 then
                NotificationSystem:ShowGeneralNotification("Items Shop restocked!", Color3.fromRGB(100, 255, 100));
                SoundManager:Play("NOTIF1");
                playRestockAnimation();

                return;
            end;

            NotificationSystem:ShowGeneralNotification("Items Shop is now open!", Color3.fromRGB(100, 255, 100));
            SoundManager:Play("NOTIF1");
            refreshShopUI();

            return;
        end;

        refreshShopUI();
    end;
end);
(function() -- Line: 397, Name: setupAllButtons
    -- upvalues: CollectionService (copy), PlayerGui (copy), connectBuyButton (copy), connectRestockButton (copy)
    for _, v in ipairs(CollectionService:GetTagged("ItemsShop")) do
        if v:IsDescendantOf(PlayerGui) then
            local v74 = v:GetAttribute("Type");

            if v74 == "BuyWins" or v74 == "BuyRobux" then
                connectBuyButton(v);
            elseif v74 == "RestockButton" then
                connectRestockButton(v);
            end;
        end;
    end;
end)();
CollectionService:GetInstanceAddedSignal("ItemsShop"):Connect(function(u75) -- Line: 515
    -- upvalues: PlayerGui (copy), connectBuyButton (copy), u1 (ref), connectRestockButton (copy), refreshShopUI (copy)
    task.defer(function() -- Line: 516
        -- upvalues: u75 (copy), PlayerGui (ref), connectBuyButton (ref), u1 (ref), connectRestockButton (ref), refreshShopUI (ref)
        if not u75:IsDescendantOf(PlayerGui) then
            return;
        end;

        local v76 = u75:GetAttribute("Type");

        if v76 == "BuyWins" or v76 == "BuyRobux" then
            connectBuyButton(u75);

            if not (u1 and u1.active) then
                u75.Visible = false;
            end;
        elseif v76 == "RestockButton" then
            connectRestockButton(u75);
        end;

        if u1 and u1.active then
            refreshShopUI();
        end;
    end);
end);
CollectionService:GetInstanceAddedSignal("GiftItem"):Connect(function(u77) -- Line: 536
    -- upvalues: PlayerGui (copy), u1 (ref)
    task.defer(function() -- Line: 537
        -- upvalues: u77 (copy), PlayerGui (ref), u1 (ref)
        if not u77:IsDescendantOf(PlayerGui) then
            return;
        end;

        if not (u1 and u1.active) then
            u77.Visible = false;
        end;
    end);
end);

if u47 then
    u47:Disconnect();
end;

u47 = RunService.Heartbeat:Connect(function() -- Line: 300
    -- upvalues: u1 (ref), getShopElementByType (copy)
    if not u1 then
        return;
    end;

    local v78 = (u1.nextRestockTime or 0) - os.time();
    local v79 = math.max(0, v78);
    local v80 = math.floor(v79 / 60);
    local v81 = v79 % 60;
    local v82 = getShopElementByType("NewItemsText");

    if v82 then
        v82.Text = string.format("New items in %dm %02ds", v80, v81);
    end;

    if not u1.active then
        local v83 = string.format("%dm %02ds", v80, v81);

        for _, v in ipairs({ "BonusCommon", "BonusUncommon", "BonusRare", "BonusMysterious" }) do
            local v84 = getShopElementByType(v);

            if v84 then
                v84.Text = v83;
            end;
        end;
    end;
end);
task.defer(function() -- Line: 549
    -- upvalues: ItemsShopRemotes (copy)
    ItemsShopRemotes.RequestState:fire();
end);