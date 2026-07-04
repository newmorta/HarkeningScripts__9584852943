-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.GiftClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local MarketplaceService = game:GetService("MarketplaceService");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local TrailConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("TrailConfig"));
local GiftConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("GiftConfig"));
local CosmeticInventoryUI = require(ReplicatedStorage:WaitForChild("UISystems"):WaitForChild("CosmeticInventoryUI"));
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local NotificationSystem = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
local SoundManager = require(ReplicatedStorage:WaitForChild("SoundManager"));
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local u1 = nil;

local function getGiftAction() -- Line: 23
    -- upvalues: u1 (ref), Remotes (copy)
    if not u1 then
        u1 = Remotes:FindFirstChild("GiftAction");
    end;

    return u1;
end;

local function getGiftModalElement(p2) -- Line: 34
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged("GiftToPlayer")) do
        if v:IsDescendantOf(PlayerGui) and v:GetAttribute("Type") == p2 then
            return v;
        end;
    end;

    return nil;
end;

local function getGiftModal() -- Line: 43
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged("GiftToPlayerModal")) do
        if v:IsDescendantOf(PlayerGui) then
            return v;
        end;
    end;

    return nil;
end;

local u3 = nil;
local u4 = nil;
local u5 = false;

local function clearPlayerPreview() -- Line: 64
    -- upvalues: u3 (ref), u4 (ref), getGiftModalElement (copy)
    u3 = nil;
    u4 = nil;
    local v6 = getGiftModalElement("AvatarImage");

    if v6 then
        v6.Image = "";
    end;

    local v7 = getGiftModalElement("PlayerNameLabel");

    if v7 then
        v7.Text = "";
    end;
end;

local function resolveUsername(u8) -- Line: 75
    -- upvalues: u5 (ref), u3 (ref), u4 (ref), getGiftModalElement (copy), Players (copy)
    if u5 then
        return;
    end;

    if not u8 or u8 == "" then
        u3 = nil;
        u4 = nil;
        local v9 = getGiftModalElement("AvatarImage");

        if v9 then
            v9.Image = "";
        end;

        local v10 = getGiftModalElement("PlayerNameLabel");

        if v10 then
            v10.Text = "";
        end;

        return;
    end;

    u5 = true;
    local success, result = pcall(function() -- Line: 84
        -- upvalues: Players (ref), u8 (copy)
        return Players:GetUserIdFromNameAsync(u8);
    end);
    u5 = false;

    if success and result then
        u3 = result;
        u4 = u8;
        local v11 = getGiftModalElement("AvatarImage");

        if v11 then
            local success2, result2 = pcall(function() -- Line: 103
                -- upvalues: Players (ref), result (copy)
                return Players:GetUserThumbnailAsync(result, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150);
            end);

            if success2 and result2 then
                v11.Image = result2;
            end;
        end;

        local v12 = getGiftModalElement("PlayerNameLabel");

        if v12 then
            v12.Text = u8;
        end;

        return;
    end;

    u3 = nil;
    u4 = nil;
    local v13 = getGiftModalElement("AvatarImage");

    if v13 then
        v13.Image = "";
    end;

    local v14 = getGiftModalElement("PlayerNameLabel");

    if v14 then
        v14.Text = "";
    end;

    local v15 = getGiftModalElement("PlayerNameLabel");

    if v15 then
        v15.Text = "Player not found";
    end;
end;

local function openGiftModal(p16) -- Line: 122
    -- upvalues: CosmeticInventoryUI (copy), u3 (ref), u4 (ref)
    CosmeticInventoryUI.openGiftModal(p16);
    u3 = nil;
    u4 = nil;
end;

local function closeGiftModal() -- Line: 128
    -- upvalues: getGiftModal (copy), u3 (ref), u4 (ref), ClientState (copy)
    local v17 = getGiftModal();

    if v17 then
        v17:SetAttribute("GiftType", nil);
    end;

    u3 = nil;
    u4 = nil;

    if v17 and ClientState.ActiveModal == v17 then
        ClientState:CloseCurrentModal();
    end;
end;

local function setupBuyTreadmillButton(p18) -- Line: 145
    -- upvalues: PlayerGui (copy), GiftConfig (copy), MarketplaceService (copy), LocalPlayer (copy), CosmeticInventoryUI (copy), u3 (ref), u4 (ref)
    if not p18:IsDescendantOf(PlayerGui) then
        return;
    end;

    if not p18:IsA("GuiButton") then
        return;
    end;

    local u19 = p18:GetAttribute("Action");
    local u20 = p18:GetAttribute("Type");

    if not (u19 and u20) then
        return;
    end;

    p18.Activated:Connect(function() -- Line: 154
        -- upvalues: u19 (copy), GiftConfig (ref), u20 (copy), MarketplaceService (ref), LocalPlayer (ref), CosmeticInventoryUI (ref), u3 (ref), u4 (ref)
        if u19 == "Buy" then
            local v21 = GiftConfig.TREADMILL_GIFTS[u20];

            if v21 then
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, v21.GamepassId);
            end;
        elseif u19 == "Gift" then
            CosmeticInventoryUI.openGiftModal(u20);
            u3 = nil;
            u4 = nil;
        end;
    end);
end;

local v22 = CollectionService:GetTagged("BuyTreadmill");

for _, v in ipairs(v22) do
    task.defer(function() -- Line: 171
        -- upvalues: setupBuyTreadmillButton (copy), v (copy)
        setupBuyTreadmillButton(v);
    end);
end;

CollectionService:GetInstanceAddedSignal("BuyTreadmill"):Connect(function(u23) -- Line: 173
    -- upvalues: setupBuyTreadmillButton (copy)
    task.defer(function() -- Line: 174
        -- upvalues: setupBuyTreadmillButton (ref), u23 (copy)
        setupBuyTreadmillButton(u23);
    end);
end);

local function setupBuyTrailButton(p24) -- Line: 181
    -- upvalues: PlayerGui (copy), TrailConfig (copy), MarketplaceService (copy), LocalPlayer (copy), CosmeticInventoryUI (copy), u3 (ref), u4 (ref)
    if not p24:IsDescendantOf(PlayerGui) then
        return;
    end;

    if not p24:IsA("GuiButton") then
        return;
    end;

    local u25 = p24:GetAttribute("Action");
    local u26 = p24:GetAttribute("Type");

    if not (u25 and u26) then
        return;
    end;

    p24.Activated:Connect(function() -- Line: 190
        -- upvalues: u25 (copy), TrailConfig (ref), u26 (copy), MarketplaceService (ref), LocalPlayer (ref), CosmeticInventoryUI (ref), u3 (ref), u4 (ref)
        if u25 == "Buy" then
            local v27 = TrailConfig.TRAILS and TrailConfig.TRAILS[u26];

            if v27 and v27.Gamepass then
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, v27.Gamepass);
            end;
        elseif u25 == "Gift" then
            CosmeticInventoryUI.openGiftModal(u26);
            u3 = nil;
            u4 = nil;
        end;
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("BuyTrail")) do
    task.defer(function() -- Line: 203
        -- upvalues: setupBuyTrailButton (copy), v (copy)
        setupBuyTrailButton(v);
    end);
end;

CollectionService:GetInstanceAddedSignal("BuyTrail"):Connect(function(u28) -- Line: 205
    -- upvalues: setupBuyTrailButton (copy)
    task.defer(function() -- Line: 206
        -- upvalues: setupBuyTrailButton (ref), u28 (copy)
        setupBuyTrailButton(u28);
    end);
end);

local function setupBuyAuraButton(p29) -- Line: 213
    -- upvalues: PlayerGui (copy), ReplicatedStorage (copy), MarketplaceService (copy), LocalPlayer (copy), CosmeticInventoryUI (copy), u3 (ref), u4 (ref)
    if not p29:IsDescendantOf(PlayerGui) then
        return;
    end;

    if not p29:IsA("GuiButton") then
        return;
    end;

    local u30 = p29:GetAttribute("Action");
    local u31 = p29:GetAttribute("Type");

    if not (u30 and u31) then
        return;
    end;

    p29.Activated:Connect(function() -- Line: 222
        -- upvalues: u30 (copy), ReplicatedStorage (ref), u31 (copy), MarketplaceService (ref), LocalPlayer (ref), CosmeticInventoryUI (ref), u3 (ref), u4 (ref)
        if u30 == "Buy" then
            local AuraConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("AuraConfig"));
            local v32 = AuraConfig.AURAS and AuraConfig.AURAS[u31];

            if v32 and v32.gamepass then
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, v32.gamepass);
            end;
        elseif u30 == "Gift" then
            CosmeticInventoryUI.openGiftModal(u31);
            u3 = nil;
            u4 = nil;
        end;
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("BuyAura")) do
    task.defer(function() -- Line: 236
        -- upvalues: setupBuyAuraButton (copy), v (copy)
        setupBuyAuraButton(v);
    end);
end;

CollectionService:GetInstanceAddedSignal("BuyAura"):Connect(function(u33) -- Line: 238
    -- upvalues: setupBuyAuraButton (copy)
    task.defer(function() -- Line: 239
        -- upvalues: setupBuyAuraButton (ref), u33 (copy)
        setupBuyAuraButton(u33);
    end);
end);

local function setupGiftItemButton(u34) -- Line: 247
    -- upvalues: PlayerGui (copy), CosmeticInventoryUI (copy), u3 (ref), u4 (ref)
    if not u34:IsDescendantOf(PlayerGui) then
        return;
    end;

    if not u34:IsA("GuiButton") then
        return;
    end;

    u34.Activated:Connect(function() -- Line: 251
        -- upvalues: u34 (copy), CosmeticInventoryUI (ref), u3 (ref), u4 (ref)
        local v35 = u34:GetAttribute("ItemKey");

        if not v35 or v35 == "" then
            return;
        end;

        CosmeticInventoryUI.openGiftModal(v35);
        u3 = nil;
        u4 = nil;
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("GiftItem")) do
    task.defer(function() -- Line: 259
        -- upvalues: setupGiftItemButton (copy), v (copy)
        setupGiftItemButton(v);
    end);
end;

CollectionService:GetInstanceAddedSignal("GiftItem"):Connect(function(u36) -- Line: 261
    -- upvalues: setupGiftItemButton (copy)
    task.defer(function() -- Line: 262
        -- upvalues: setupGiftItemButton (ref), u36 (copy)
        setupGiftItemButton(u36);
    end);
end);

local function setupUsernameInput(u37) -- Line: 269
    -- upvalues: PlayerGui (copy), resolveUsername (copy), u3 (ref), u4 (ref), getGiftModalElement (copy)
    if not u37:IsDescendantOf(PlayerGui) then
        return;
    end;

    if not u37:IsA("TextBox") then
        return;
    end;

    if u37:GetAttribute("Type") ~= "UsernameInput" then
        return;
    end;

    u37.FocusLost:Connect(function(p38) -- Line: 274
        -- upvalues: u37 (copy), resolveUsername (ref), u3 (ref), u4 (ref), getGiftModalElement (ref)
        local Text = u37.Text;

        if Text and #Text > 0 then
            task.spawn(function() -- Line: 277
                -- upvalues: resolveUsername (ref), Text (copy)
                resolveUsername(Text);
            end);

            return;
        end;

        u3 = nil;
        u4 = nil;
        local v39 = getGiftModalElement("AvatarImage");

        if v39 then
            v39.Image = "";
        end;

        local v40 = getGiftModalElement("PlayerNameLabel");

        if v40 then
            v40.Text = "";
        end;
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("GiftToPlayer")) do
    task.defer(function() -- Line: 287
        -- upvalues: setupUsernameInput (copy), v (copy)
        setupUsernameInput(v);
    end);
end;

CollectionService:GetInstanceAddedSignal("GiftToPlayer"):Connect(function(u41) -- Line: 289
    -- upvalues: setupUsernameInput (copy)
    task.defer(function() -- Line: 290
        -- upvalues: setupUsernameInput (ref), u41 (copy)
        setupUsernameInput(u41);
    end);
end);
local u42 = false;

local function setupSendGiftButton(p43) -- Line: 299
    -- upvalues: PlayerGui (copy), u42 (ref), u5 (ref), getGiftModal (copy), u3 (ref), u4 (ref), LocalPlayer (copy), getGiftModalElement (copy), u1 (ref), Remotes (copy), MarketplaceService (copy), SoundManager (copy), NotificationSystem (copy), ClientState (copy)
    if not p43:IsDescendantOf(PlayerGui) then
        return;
    end;

    if not p43:IsA("GuiButton") then
        return;
    end;

    if p43:GetAttribute("Type") ~= "SendGiftButton" then
        return;
    end;

    p43.Activated:Connect(function() -- Line: 304
        -- upvalues: u42 (ref), u5 (ref), getGiftModal (ref), u3 (ref), u4 (ref), LocalPlayer (ref), getGiftModalElement (ref), u1 (ref), Remotes (ref), MarketplaceService (ref), SoundManager (ref), NotificationSystem (ref), ClientState (ref)
        if u42 then
            return;
        end;

        while u5 do
            task.wait(0.1);
        end;

        local u44 = getGiftModal() and u44:GetAttribute("GiftType");

        if not u44 then
            return;
        end;

        if not (u3 and u4) then
            return;
        end;

        if u3 == LocalPlayer.UserId then
            local v45 = getGiftModalElement("PlayerNameLabel");

            if v45 then
                v45.Text = "Can\'t gift yourself!";
            end;

            return;
        end;

        u42 = true;

        if not u1 then
            u1 = Remotes:FindFirstChild("GiftAction");
        end;

        local u46 = u1;

        if not u46 then
            u42 = false;

            return;
        end;

        local success, result = pcall(function() -- Line: 333
            -- upvalues: u46 (copy), u3 (ref), u4 (ref), u44 (copy)
            return u46:InvokeServer("RegisterGift", {
                TargetUserId = u3,
                TargetName = u4,
                GiftType = u44
            });
        end);

        if not (success and (result and result.Success)) then
            SoundManager:Play("ERROR");
            NotificationSystem:ShowGeneralNotification(result and result.Error or "Error", Color3.fromRGB(255, 85, 85));
            u42 = false;

            return;
        end;

        local u47 = u4;
        local DevProductId = result.DevProductId;
        local u48 = nil;
        local u49 = false;
        u48 = MarketplaceService.PromptProductPurchaseFinished:Connect(function(p50, p51, p52) -- Line: 348
            -- upvalues: LocalPlayer (ref), DevProductId (copy), u49 (ref), u48 (ref), SoundManager (ref), NotificationSystem (ref), u47 (copy), getGiftModal (ref), u3 (ref), u4 (ref), ClientState (ref), u42 (ref)
            if p50 ~= LocalPlayer.UserId then
                return;
            end;

            if p51 ~= DevProductId then
                return;
            end;

            if u49 then
                return;
            end;

            u49 = true;
            u48:Disconnect();

            if p52 then
                SoundManager:Play("BUY");
                NotificationSystem:ShowGeneralNotification("Gift sent to " .. u47 .. "!", Color3.fromRGB(85, 255, 127));
                local v53 = getGiftModal();

                if v53 then
                    v53:SetAttribute("GiftType", nil);
                end;

                u3 = nil;
                u4 = nil;

                if v53 and ClientState.ActiveModal == v53 then
                    ClientState:CloseCurrentModal();
                end;
            else
                SoundManager:Play("ERROR");
                NotificationSystem:ShowGeneralNotification("Gift cancelled.", Color3.fromRGB(255, 85, 85));
            end;

            u42 = false;
        end);
        task.delay(120, function() -- Line: 373
            -- upvalues: u49 (ref), u48 (ref), u42 (ref)
            if not u49 then
                u49 = true;
                u48:Disconnect();
                u42 = false;
            end;
        end);
        MarketplaceService:PromptProductPurchase(LocalPlayer, DevProductId);
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("GiftToPlayer")) do
    task.defer(function() -- Line: 393
        -- upvalues: setupSendGiftButton (copy), v (copy)
        setupSendGiftButton(v);
    end);
end;

CollectionService:GetInstanceAddedSignal("GiftToPlayer"):Connect(function(u54) -- Line: 395
    -- upvalues: setupSendGiftButton (copy)
    task.defer(function() -- Line: 396
        -- upvalues: setupSendGiftButton (ref), u54 (copy)
        setupSendGiftButton(u54);
    end);
end);

local function setupCloseButton(p55) -- Line: 403
    -- upvalues: PlayerGui (copy), getGiftModal (copy), u3 (ref), u4 (ref), ClientState (copy)
    if not p55:IsDescendantOf(PlayerGui) then
        return;
    end;

    if not p55:IsA("GuiButton") then
        return;
    end;

    p55.Activated:Connect(function() -- Line: 407
        -- upvalues: getGiftModal (ref), u3 (ref), u4 (ref), ClientState (ref)
        local v56 = getGiftModal();

        if v56 then
            v56:SetAttribute("GiftType", nil);
        end;

        u3 = nil;
        u4 = nil;

        if v56 and ClientState.ActiveModal == v56 then
            ClientState:CloseCurrentModal();
        end;
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("GiftToPlayerClose")) do
    task.defer(function() -- Line: 413
        -- upvalues: setupCloseButton (copy), v (copy)
        setupCloseButton(v);
    end);
end;

CollectionService:GetInstanceAddedSignal("GiftToPlayerClose"):Connect(function(u57) -- Line: 415
    -- upvalues: setupCloseButton (copy)
    task.defer(function() -- Line: 416
        -- upvalues: setupCloseButton (ref), u57 (copy)
        setupCloseButton(u57);
    end);
end);