-- Ruta Original: ReplicatedStorage.UISystems.RobuxShopUISystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local MarketplaceService = game:GetService("MarketplaceService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ClientState = require(ReplicatedStorage.ClientState);
local RobuxShopConfig = require(ReplicatedStorage.FeatureConfigs.RobuxShopConfig);
local X2BoostUISystem = require(ReplicatedStorage.UISystems.X2BoostUISystem);
local BoomboxShopPreview = require(ReplicatedStorage.UISystems.BoomboxShopPreview);
local v1 = {};
local u2 = false;
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");

local function setAssetPrice(u3, u4) -- Line: 17
    -- upvalues: MarketplaceService (copy)
    task.spawn(function() -- Line: 18
        -- upvalues: MarketplaceService (ref), u4 (copy), u3 (copy)
        local success, result = pcall(MarketplaceService.GetProductInfo, MarketplaceService, u4, Enum.InfoType.Asset);

        if success and (result and result.PriceInRobux) then
            u3.Price.Text = tostring(result.PriceInRobux);
        end;
    end);
end;

local function wireAssetBuy(u5, u6) -- Line: 26
    -- upvalues: MarketplaceService (copy), LocalPlayer (copy)
    if u5:GetAttribute("IsConnected") then
        return;
    end;

    u5:SetAttribute("IsConnected", true);
    task.spawn(function() -- Line: 18
        -- upvalues: MarketplaceService (ref), u6 (copy), u5 (copy)
        local success, result = pcall(MarketplaceService.GetProductInfo, MarketplaceService, u6, Enum.InfoType.Asset);

        if success and (result and result.PriceInRobux) then
            u5.Price.Text = tostring(result.PriceInRobux);
        end;
    end);
    u5.Activated:Connect(function() -- Line: 30
        -- upvalues: MarketplaceService (ref), LocalPlayer (ref), u6 (copy)
        MarketplaceService:PromptPurchase(LocalPlayer, u6);
    end);
end;

local function wireBoombox(p7) -- Line: 35
    -- upvalues: RobuxShopConfig (copy), wireAssetBuy (copy)
    wireAssetBuy(p7.Buy, RobuxShopConfig.Boombox.AssetId);
end;

local function wireEmotePack(p8, p9) -- Line: 40
    -- upvalues: wireAssetBuy (copy)
    local AssetId = p9.AssetId;
    p8.Icon.Image = ("rbxthumb://type=Asset&id=%d&w=420&h=420"):format(AssetId);
    wireAssetBuy(p8.Buy, AssetId);
end;

function v1.UpdateDisplay(p10) -- Line: 46
    -- upvalues: X2BoostUISystem (copy)
    X2BoostUISystem:UpdateDisplay();
end;

function v1.InitLogic(p11) -- Line: 50
    -- upvalues: u2 (ref), X2BoostUISystem (copy), BoomboxShopPreview (copy), RobuxShopConfig (copy), wireAssetBuy (copy), PlayerGui (copy), CollectionService (copy), ClientState (copy)
    if u2 then
        return;
    end;

    u2 = true;
    X2BoostUISystem:InitLogic();

    local function mountModal(p12) -- Line: 58
        -- upvalues: BoomboxShopPreview (ref), RobuxShopConfig (ref), wireAssetBuy (ref)
        local ScrollingFrame = p12.ScrollingFrame;
        local MainFrame = ScrollingFrame.Boombox.MainFrame;
        BoomboxShopPreview.mount(MainFrame.ViewportFrame);
        wireAssetBuy(MainFrame.Buy, RobuxShopConfig.Boombox.AssetId);
        local MainFrame2 = ScrollingFrame.Emotes.MainFrame;

        for i, v in RobuxShopConfig.Emotes do
            local v13 = MainFrame2[i];
            local AssetId = v.AssetId;
            v13.Icon.Image = ("rbxthumb://type=Asset&id=%d&w=420&h=420"):format(AssetId);
            wireAssetBuy(v13.Buy, AssetId);
        end;
    end;

    local function setupModal(u14) -- Line: 71
        -- upvalues: PlayerGui (ref), mountModal (copy)
        if u14:IsDescendantOf(PlayerGui) then
            mountModal(u14);

            return;
        end;

        u14.AncestryChanged:Connect(function() -- Line: 75
            -- upvalues: u14 (copy), PlayerGui (ref), mountModal (ref)
            if u14:IsDescendantOf(PlayerGui) then
                mountModal(u14);
            end;
        end);
    end;

    for _, v in CollectionService:GetTagged("RobuxShopModal") do
        if v:IsDescendantOf(PlayerGui) then
            mountModal(v);
        else
            v.AncestryChanged:Connect(function() -- Line: 75
                -- upvalues: v (copy), PlayerGui (ref), mountModal (copy)
                if v:IsDescendantOf(PlayerGui) then
                    mountModal(v);
                end;
            end);
        end;
    end;

    CollectionService:GetInstanceAddedSignal("RobuxShopModal"):Connect(setupModal);

    local function connectCloseBtn(p15) -- Line: 88
        -- upvalues: ClientState (ref)
        if not p15:IsA("GuiButton") then
            return;
        end;

        if p15:GetAttribute("IsConnected") then
            return;
        end;

        p15:SetAttribute("IsConnected", true);
        p15.MouseButton1Click:Connect(function() -- Line: 92
            -- upvalues: ClientState (ref)
            ClientState:CloseCurrentModal();
        end);
    end;

    for _, v in CollectionService:GetTagged("RobuxShopModalCloseButton") do
        connectCloseBtn(v);
    end;

    CollectionService:GetInstanceAddedSignal("RobuxShopModalCloseButton"):Connect(connectCloseBtn);
end;

return v1;