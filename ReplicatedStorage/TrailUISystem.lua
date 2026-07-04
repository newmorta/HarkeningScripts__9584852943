-- Ruta Original: ReplicatedStorage.TrailUISystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local MarketplaceService = game:GetService("MarketplaceService");
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local TrailConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("TrailConfig"));
local EventsConfig = require(ReplicatedStorage:WaitForChild("EventsConfig"));
local GiftConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("GiftConfig"));
local CosmeticInventoryUI = require(ReplicatedStorage:WaitForChild("UISystems"):WaitForChild("CosmeticInventoryUI"));
local Numbers = require(ReplicatedStorage.Utilities.Numbers);
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local v1 = {};
local u2 = false;
local u3 = {};
local u4 = {};
local u5 = false;
local LocalPlayer = Players.LocalPlayer;

local function getEventTrailData(p6) -- Line: 23
    -- upvalues: u4 (copy), EventsConfig (copy)
    if u4[p6] then
        return u4[p6];
    end;

    for _, v in ipairs(EventsConfig.Trails or {}) do
        if v.Key == p6 then
            u4[p6] = v;

            return v;
        end;
    end;

    return nil;
end;

local function collectTrailEntries() -- Line: 36
    -- upvalues: TrailConfig (copy), EventsConfig (copy)
    local v7 = {};
    local v8 = {};

    for i, v in pairs(TrailConfig.TRAILS) do
        table.insert(v7, {
            isEvent = false,
            key = i,
            data = v
        });
    end;

    for _, v in ipairs(EventsConfig.Trails or {}) do
        table.insert(v8, {
            isEvent = true,
            key = v.Key,
            data = v
        });
    end;

    local function sortByMultiplier(p9, p10) -- Line: 56
        local v11 = p9.data.Multiplier or 0;
        local v12 = p10.data.Multiplier or 0;

        if v11 == v12 then
            return p9.key < p10.key;
        end;

        return v11 < v12;
    end;

    table.sort(v7, sortByMultiplier);
    table.sort(v8, sortByMultiplier);
    local v13 = {};

    for _, v in ipairs(v7) do
        table.insert(v13, v);
    end;

    for _, v in ipairs(v8) do
        table.insert(v13, v);
    end;

    return v13;
end;

local function buildRowOptions(u14, p15, p16) -- Line: 79
    -- upvalues: GiftConfig (copy), Numbers (copy), Remotes (copy), MarketplaceService (copy), LocalPlayer (copy), CosmeticInventoryUI (copy)
    local v17 = p15.Price or 0;
    local CurrencyPrice = p15.CurrencyPrice;
    local u18 = p15.Gamepass or 0;
    local v19 = GiftConfig.ALL_GIFTS[u14] ~= nil;
    local v20 = false;
    local v21 = nil;
    local v22 = nil;

    if p16 and (CurrencyPrice and (CurrencyPrice.Amount and CurrencyPrice.Amount > 0)) then
        v21 = Numbers.formatNumber(CurrencyPrice.Amount) .. " " .. (CurrencyPrice.Key or "");

        v22 = function() -- Line: 92
            -- upvalues: Remotes (ref), u14 (copy)
            local v23, v24 = Remotes.BuyTrail:InvokeServer(u14, "Currency");

            if not v23 then
                warn("[TrailSystem] " .. tostring(v24));
            end;
        end;

        v20 = true;
    elseif v17 > 0 then
        v21 = Numbers.formatNumber(v17);

        v22 = function() -- Line: 99
            -- upvalues: Remotes (ref), u14 (copy)
            local v25, v26 = Remotes.BuyTrail:InvokeServer(u14, "Wins");

            if not v25 then
                warn("[TrailSystem] " .. tostring(v26));
            end;
        end;

        v20 = true;
    end;

    return {
        showBuyWins = v20,
        winsPriceText = v21,
        onBuyWins = v22,
        showBuyGamepass = u18 > 0,
        gamepassId = u18,
        onBuyGamepass = u18 > 0 and function() -- Line: 111
            -- upvalues: MarketplaceService (ref), LocalPlayer (ref), u18 (copy)
            MarketplaceService:PromptGamePassPurchase(LocalPlayer, u18);
        end or nil,
        showBuyGift = v19,
        onBuyGift = v19 and (function() -- Line: 115
            -- upvalues: CosmeticInventoryUI (ref), u14 (copy)
            CosmeticInventoryUI.openGiftModal(u14);
        end or nil) or nil,

        onEquip = function() -- Line: 118, Name: onEquip
            -- upvalues: Remotes (ref), u14 (copy)
            Remotes.EquipTrail:FireServer(u14);
        end
    };
end;

local function buildInventory() -- Line: 124
    -- upvalues: u5 (ref), CosmeticInventoryUI (copy), collectTrailEntries (copy), buildRowOptions (copy), u3 (copy)
    if u5 then
        return;
    end;

    local v27 = CosmeticInventoryUI.getInventoryTab("Trails");

    if not v27 then
        return;
    end;

    local v28 = CosmeticInventoryUI.getRowTemplate(v27, "TrailTemplate");
    local v29 = CosmeticInventoryUI.getScrollingFrame(v27);

    if not (v28 and v29) then
        return;
    end;

    v28.Visible = false;
    CosmeticInventoryUI.clearBuiltRows(v29);

    for i, v in ipairs((collectTrailEntries())) do
        local v30 = v28:Clone();
        v30.Name = v.key;
        v30.LayoutOrder = i;
        v30:SetAttribute("CosmeticKey", v.key);

        if v.isEvent then
            v30:SetAttribute("IsEventTrail", true);
        end;

        CosmeticInventoryUI.applyRowContent(v30, v.key, v.data.Icon, v.data.Multiplier, v.data.Color);
        CosmeticInventoryUI.wireRow(v30, (buildRowOptions(v.key, v.data, v.isEvent)));
        v30.Parent = v29;
        CosmeticInventoryUI.showRow(v30);
        u3[v.key] = v30;
    end;

    u5 = true;
end;

local function updateTrailRow(p31, p32, p33) -- Line: 163
    -- upvalues: u3 (copy), getEventTrailData (copy), CosmeticInventoryUI (copy)
    local v34 = u3[p31];

    if not v34 then
        return;
    end;

    local v35 = table.find(p32, p31) ~= nil;

    if v34:GetAttribute("IsEventTrail") then
        local v36 = getEventTrailData(p31) and CosmeticInventoryUI.shouldHideEventTrail(v36, p32, p31);
        v34:SetAttribute("Hidden", v36 == true);
    end;

    CosmeticInventoryUI.updateRowState(v34, v35, p33 == p31);
end;

function v1.UpdateDisplay(p37) -- Line: 183
    -- upvalues: buildInventory (copy), ClientState (copy), u3 (copy), updateTrailRow (copy)
    buildInventory();
    local v38 = ClientState:Get();
    local v39 = v38.OwnedTrails or {};
    local v40 = v38.EquippedTrail or "None";

    for i in pairs(u3) do
        updateTrailRow(i, v39, v40);
    end;
end;

function v1.InitLogic(u41) -- Line: 195
    -- upvalues: u2 (ref), ClientState (copy), CollectionService (copy), CosmeticInventoryUI (copy), u5 (ref), u3 (copy), u4 (copy), buildInventory (copy)
    if u2 then
        return;
    end;

    u2 = true;

    local function connectClose(p42) -- Line: 199
        -- upvalues: ClientState (ref)
        if p42:GetAttribute("IsConnectedClose") then
            return;
        end;

        p42:SetAttribute("IsConnectedClose", true);
        p42.MouseButton1Click:Connect(function() -- Line: 202
            -- upvalues: ClientState (ref)
            ClientState:CloseCurrentModal();
        end);
    end;

    for _, v in ipairs(CollectionService:GetTagged("TrailsCloseBtn")) do
        if not v:GetAttribute("IsConnectedClose") then
            v:SetAttribute("IsConnectedClose", true);
            v.MouseButton1Click:Connect(function() -- Line: 202
                -- upvalues: ClientState (ref)
                ClientState:CloseCurrentModal();
            end);
        end;
    end;

    CollectionService:GetInstanceAddedSignal("TrailsCloseBtn"):Connect(connectClose);
    CosmeticInventoryUI.whenInventoryTabReady("Trails", function() -- Line: 212
        -- upvalues: u5 (ref), u3 (ref), u4 (ref), buildInventory (ref), u41 (copy)
        u5 = false;
        table.clear(u3);
        table.clear(u4);
        buildInventory();
        u41:UpdateDisplay();
    end);
    buildInventory();
    u41:UpdateDisplay();
end;

function v1.OnClose(p43) -- Line: 224
end;

return v1;