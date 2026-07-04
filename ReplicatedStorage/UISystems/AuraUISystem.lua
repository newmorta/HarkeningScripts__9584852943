-- Ruta Original: ReplicatedStorage.UISystems.AuraUISystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local MarketplaceService = game:GetService("MarketplaceService");
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local AuraConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("AuraConfig"));
local GiftConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("GiftConfig"));
local CosmeticInventoryUI = require(ReplicatedStorage:WaitForChild("UISystems"):WaitForChild("CosmeticInventoryUI"));
local Numbers = require(ReplicatedStorage.Utilities.Numbers);
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local v1 = {};
local u2 = false;
local u3 = {};
local u4 = false;
local LocalPlayer = Players.LocalPlayer;

local function getAuraIcon(p5, p6) -- Line: 21
    -- upvalues: GiftConfig (copy)
    if p6.icon then
        return p6.icon;
    end;

    local v7 = GiftConfig.AURA_GIFTS[p5];

    if v7 then
        return v7.Image;
    end;

    return nil;
end;

local function collectAuraEntries() -- Line: 32
    -- upvalues: AuraConfig (copy)
    local v8 = {};

    for i, v in pairs(AuraConfig.AURAS) do
        table.insert(v8, {
            key = i,
            data = v,
            useMedalTemplate = i == "MedalAura"
        });
    end;

    table.sort(v8, function(p9, p10) -- Line: 43
        if p9.data.multiplier == p10.data.multiplier then
            return p9.key < p10.key;
        end;

        return p9.data.multiplier < p10.data.multiplier;
    end);

    return v8;
end;

local function buildRowOptions(u11, p12) -- Line: 53
    -- upvalues: GiftConfig (copy), Numbers (copy), Remotes (copy), MarketplaceService (copy), LocalPlayer (copy), CosmeticInventoryUI (copy)
    local v13 = p12.price or 0;
    local u14 = p12.gamepass or 0;
    local v15 = GiftConfig.ALL_GIFTS[u11] ~= nil;
    local v16 = {
        showBuyWins = v13 > 0
    };
    local v17;

    if v13 > 0 then
        v17 = Numbers.formatNumber(v13) or nil;
    else
        v17 = nil;
    end;

    v16.winsPriceText = v17;
    v16.onBuyWins = v13 > 0 and (function() -- Line: 61
        -- upvalues: Remotes (ref), u11 (copy)
        local v18, v19 = Remotes.BuyAura:InvokeServer(u11, "Wins");

        if not v18 then
            warn("[AuraSystem] " .. tostring(v19));
        end;
    end or nil) or nil;
    v16.showBuyGamepass = u14 > 0;
    v16.gamepassId = u14;
    v16.onBuyGamepass = u14 > 0 and function() -- Line: 67
        -- upvalues: MarketplaceService (ref), LocalPlayer (ref), u14 (copy)
        MarketplaceService:PromptGamePassPurchase(LocalPlayer, u14);
    end or nil;
    v16.showBuyGift = v15;
    v16.onBuyGift = v15 and (function() -- Line: 71
        -- upvalues: CosmeticInventoryUI (ref), u11 (copy)
        CosmeticInventoryUI.openGiftModal(u11);
    end or nil) or nil;

    function v16.onEquip() -- Line: 74
        -- upvalues: Remotes (ref), u11 (copy)
        Remotes.EquipAura:FireServer(u11);
    end;

    return v16;
end;

local function buildInventory() -- Line: 80
    -- upvalues: u4 (ref), CosmeticInventoryUI (copy), collectAuraEntries (copy), GiftConfig (copy), buildRowOptions (copy), u3 (copy)
    if u4 then
        return;
    end;

    local v20 = CosmeticInventoryUI.getInventoryTab("Auras");

    if not v20 then
        return;
    end;

    local AuraTemplate = v20:FindFirstChild("AuraTemplate", true);
    local AuraMedal = v20:FindFirstChild("AuraMedal", true);
    local v21 = CosmeticInventoryUI.getScrollingFrame(v20);

    if not (AuraTemplate and v21) then
        return;
    end;

    AuraTemplate.Visible = false;

    if AuraMedal then
        AuraMedal.Visible = false;
    end;

    CosmeticInventoryUI.clearBuiltRows(v21);

    for i, v in ipairs((collectAuraEntries())) do
        local v22;

        if v.useMedalTemplate then
            v22 = AuraMedal or AuraTemplate;
        else
            v22 = AuraTemplate;
        end;

        local v23 = v22:Clone();
        v23.Name = v.key;
        v23.LayoutOrder = i;
        v23:SetAttribute("CosmeticKey", v.key);
        local key = v.key;
        local data = v.data;
        local v24;

        if data.icon then
            v24 = data.icon;
        else
            local v25 = GiftConfig.AURA_GIFTS[key];

            if v25 then
                v24 = v25.Image;
            else
                v24 = nil;
            end;
        end;

        CosmeticInventoryUI.applyRowContent(v23, v.data.name, v24, v.data.multiplier, v.data.color);
        CosmeticInventoryUI.wireRow(v23, (buildRowOptions(v.key, v.data)));
        v23.Parent = v21;
        CosmeticInventoryUI.showRow(v23);
        u3[v.key] = v23;
    end;

    u4 = true;
end;

local function updateAuraRow(p26, p27, p28) -- Line: 125
    -- upvalues: u3 (copy), CosmeticInventoryUI (copy)
    local v29 = u3[p26];

    if not v29 then
        return;
    end;

    local v30 = table.find(p27, p26) ~= nil;
    CosmeticInventoryUI.updateRowState(v29, v30, p28 == p26);
end;

function v1.UpdateDisplay(p31) -- Line: 138
    -- upvalues: buildInventory (copy), ClientState (copy), u3 (copy), CosmeticInventoryUI (copy)
    buildInventory();
    local v32 = ClientState:Get();
    local v33 = v32.OwnedAuras or {};
    local v34 = v32.EquippedAura or "None";

    for i in pairs(u3) do
        local v35 = u3[i];

        if v35 then
            local v36 = table.find(v33, i) ~= nil;
            CosmeticInventoryUI.updateRowState(v35, v36, v34 == i);
        end;
    end;
end;

function v1.InitLogic(u37) -- Line: 150
    -- upvalues: u2 (ref), ClientState (copy), CollectionService (copy), CosmeticInventoryUI (copy), u4 (ref), u3 (copy), buildInventory (copy)
    if u2 then
        return;
    end;

    u2 = true;

    local function connectClose(p38) -- Line: 154
        -- upvalues: ClientState (ref)
        if p38:GetAttribute("IsConnectedClose") then
            return;
        end;

        p38:SetAttribute("IsConnectedClose", true);
        p38.MouseButton1Click:Connect(function() -- Line: 157
            -- upvalues: ClientState (ref)
            ClientState:CloseCurrentModal();
        end);
    end;

    for _, v in ipairs(CollectionService:GetTagged("AurasCloseButton")) do
        if not v:GetAttribute("IsConnectedClose") then
            v:SetAttribute("IsConnectedClose", true);
            v.MouseButton1Click:Connect(function() -- Line: 157
                -- upvalues: ClientState (ref)
                ClientState:CloseCurrentModal();
            end);
        end;
    end;

    CollectionService:GetInstanceAddedSignal("AurasCloseButton"):Connect(connectClose);
    CosmeticInventoryUI.whenInventoryTabReady("Auras", function() -- Line: 167
        -- upvalues: u4 (ref), u3 (ref), buildInventory (ref), u37 (copy)
        u4 = false;
        table.clear(u3);
        buildInventory();
        u37:UpdateDisplay();
    end);
    buildInventory();
    u37:UpdateDisplay();
end;

function v1.OnClose(p39) -- Line: 178
end;

return v1;