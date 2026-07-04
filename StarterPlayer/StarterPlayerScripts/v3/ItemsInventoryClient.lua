-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.ItemsInventoryClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local MarketplaceService = game:GetService("MarketplaceService");
local RunService = game:GetService("RunService");
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local Items = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("Items"));
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local ItemAction = Remotes:WaitForChild("ItemAction");
local UpdateUI = Remotes:WaitForChild("UpdateUI");
local TemplateItemButton = ReplicatedStorage:WaitForChild("Templates"):WaitForChild("TemplateItemButton");
local u1 = {
    Secret = 1,
    Mythic = 5,
    Legendary = 10,
    Epic = 15,
    Rare = 20,
    Uncommon = 25,
    Common = 30
};
local u2 = false;
local MAX_EQUIPPED_DEFAULT = Items.MAX_EQUIPPED_DEFAULT;
local u3 = {};
local u4 = false;
task.spawn(function() -- Line: 48
    -- upvalues: Items (copy), MarketplaceService (copy), LocalPlayer (copy), MAX_EQUIPPED_DEFAULT (ref), CollectionService (copy), PlayerGui (copy), u3 (ref), u4 (ref)
    if Items.EXTRA_SLOTS_GAMEPASS_ID ~= 0 then
        local EXTRA_SLOTS_GAMEPASS_ID = Items.EXTRA_SLOTS_GAMEPASS_ID;
        local success, result = pcall(MarketplaceService.UserOwnsGamePassAsync, MarketplaceService, LocalPlayer.UserId, EXTRA_SLOTS_GAMEPASS_ID);

        if success and result then
            MAX_EQUIPPED_DEFAULT = Items.MAX_EQUIPPED_GAMEPASS;

            for _, v in ipairs(CollectionService:GetTagged("MoreItemsGamepass")) do
                if v:IsDescendantOf(PlayerGui) then
                    v.Visible = false;
                end;
            end;
        elseif u3[tostring(EXTRA_SLOTS_GAMEPASS_ID)] then
            MAX_EQUIPPED_DEFAULT = Items.MAX_EQUIPPED_GAMEPASS;

            for _, v in ipairs(CollectionService:GetTagged("MoreItemsGamepass")) do
                if v:IsDescendantOf(PlayerGui) then
                    v.Visible = false;
                end;
            end;
        end;
    end;

    u4 = true;
end);
UpdateUI.OnClientEvent:Connect(function(p5) -- Line: 72
    -- upvalues: u3 (ref), Items (copy), MAX_EQUIPPED_DEFAULT (ref), CollectionService (copy), PlayerGui (copy)
    if p5 and p5.GamepassReceived then
        u3 = p5.GamepassReceived;

        if Items.EXTRA_SLOTS_GAMEPASS_ID ~= 0 and (u3[tostring(Items.EXTRA_SLOTS_GAMEPASS_ID)] and MAX_EQUIPPED_DEFAULT ~= Items.MAX_EQUIPPED_GAMEPASS) then
            MAX_EQUIPPED_DEFAULT = Items.MAX_EQUIPPED_GAMEPASS;

            for _, v in ipairs(CollectionService:GetTagged("MoreItemsGamepass")) do
                if v:IsDescendantOf(PlayerGui) then
                    v.Visible = false;
                end;
            end;
        end;
    end;
end);

local function getFrameByTag(p6) -- Line: 94
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged(p6)) do
        if v:IsDescendantOf(PlayerGui) then
            return v;
        end;
    end;

    return nil;
end;

local function createItemButton(p7, p8) -- Line: 103
    -- upvalues: Items (copy), TemplateItemButton (copy), u1 (copy), RunService (copy)
    local v9 = Items.ITEMS[p7];

    if not v9 then
        return nil;
    end;

    local v10 = TemplateItemButton:Clone();
    v10.Name = "Item_" .. p7;
    local Icon = v10:FindFirstChild("Icon");

    if Icon then
        Icon.Image = v9.icon;
    end;

    local Multiplier = v10:FindFirstChild("Multiplier");

    if Multiplier then
        Multiplier.Text = "+" .. math.floor(v9.multiplier * 100 + 0.5) .. "%";
    end;

    local Name = v10:FindFirstChild("Name");

    if Name then
        Name.Text = v9.name;
    end;

    v10.LayoutOrder = u1[v9.rarity] or 30;
    local v11 = Items.RARITY_COLORS[v9.rarity];

    if v9.rarity == "Secret" then
        v10.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
        local v12 = v10:FindFirstChildWhichIsA("UIGradient");

        if v12 then
            v12.Enabled = false;
        end;

        local UIGradient = Instance.new("UIGradient");
        UIGradient.Name = "UIGradientSecret";
        UIGradient.Parent = v10;
        task.spawn(function() -- Line: 145
            -- upvalues: UIGradient (copy), RunService (ref)
            local v13 = 0;

            while UIGradient and UIGradient.Parent do
                v13 = v13 + RunService.Heartbeat:Wait() * 0.4;
                local v14 = math.cos(v13 * 3.141592653589793 * 2) * 0.4 + 0.6;
                local v15 = math.cos((v13 + 0.15) * 3.141592653589793 * 2) * 0.4 + 0.6;
                local v16 = math.cos((v13 + 0.3) * 3.141592653589793 * 2) * 0.4 + 0.6;
                UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(v14 * 255, v14 * 255, v14 * 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(v15 * 255, v15 * 255, v15 * 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(v16 * 255, v16 * 255, v16 * 255)) });
            end;
        end);
    elseif v9.rarity == "Mythic" then
        v10.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        local v17 = v10:FindFirstChildWhichIsA("UIGradient");

        if v17 then
            v17.Enabled = true;
        end;
    elseif v11 then
        v10.BackgroundColor3 = v11;
        local v18 = v10:FindFirstChildWhichIsA("UIGradient");

        if v18 then
            v18.Enabled = false;
        end;
    end;

    v10.Parent = p8;

    return v10;
end;

local function clearFrame(p19) -- Line: 185
    if not p19 then
        return;
    end;

    for _, child in ipairs(p19:GetChildren()) do
        if child:IsA("GuiButton") then
            child:Destroy();
        end;
    end;
end;

local function refreshUI() -- Line: 194
    -- upvalues: getFrameByTag (copy), clearFrame (copy), ClientState (copy), createItemButton (copy), u2 (ref), ItemAction (copy), MAX_EQUIPPED_DEFAULT (ref), Items (copy)
    local v20 = getFrameByTag("OwnedItemsFrame");
    local v21 = getFrameByTag("EquippedItemsFrame");

    if not (v20 and v21) then
        return;
    end;

    clearFrame(v20);
    clearFrame(v21);
    local v22 = ClientState:Get();
    local v23 = v22.Items or {};
    local v24 = v22.EquippedItems or {};

    for _, v in ipairs(v23) do
        local v25 = createItemButton(v, v20);

        if v25 then
            v25.Activated:Connect(function() -- Line: 211
                -- upvalues: u2 (ref), ItemAction (ref), v (copy)
                if u2 then
                    return;
                end;

                u2 = true;
                ItemAction:FireServer("Equip", v);
                task.delay(0.4, function() -- Line: 215
                    -- upvalues: u2 (ref)
                    u2 = false;
                end);
            end);
        end;
    end;

    for _, v in ipairs(v24) do
        local v26 = createItemButton(v, v21);

        if v26 then
            v26.Activated:Connect(function() -- Line: 226
                -- upvalues: u2 (ref), ItemAction (ref), v (copy)
                if u2 then
                    return;
                end;

                u2 = true;
                ItemAction:FireServer("Unequip", v);
                task.delay(0.4, function() -- Line: 230
                    -- upvalues: u2 (ref)
                    u2 = false;
                end);
            end);
        end;
    end;

    local v27 = getFrameByTag("EquippedItemsText");

    if v27 and v27:IsA("TextLabel") then
        v27.Text = "Equipped (" .. #v24 .. "/" .. MAX_EQUIPPED_DEFAULT .. ")";
    end;

    local v28 = getFrameByTag("OwnedItemsText");

    if v28 and v28:IsA("TextLabel") then
        v28.Text = "Owned (" .. #v23 .. ")";
    end;

    local v29 = Items.GetTotalBonusPercent(v24);
    local v30 = getFrameByTag("ItemsMultiplierLabel");

    if v30 then
        v30.Text = "+" .. v29 .. "% Speed (Items)";
    end;

    local v31 = getFrameByTag("ItemsMultiplierLabel2");

    if v31 then
        v31.Text = "+" .. v29 .. "% Speed";
    end;
end;

ItemAction.OnClientEvent:Connect(function(p32, p33) -- Line: 265
    -- upvalues: ClientState (copy), refreshUI (copy)
    if p32 ~= "Update" then
        if p32 == "Error" then
            warn("[ItemsInventory] Erreur:", p33);
        end;

        return;
    end;

    ClientState:Update({
        Items = p33.Items,
        EquippedItems = p33.EquippedItems
    });
    refreshUI();
end);
local u34 = false;
UpdateUI.OnClientEvent:Connect(function(p35) -- Line: 283
    -- upvalues: ClientState (copy), getFrameByTag (copy), refreshUI (copy), u34 (ref)
    if p35.Items ~= nil or p35.EquippedItems ~= nil then
        if p35.Items then
            ClientState:Update({
                Items = p35.Items
            });
        end;

        if p35.EquippedItems then
            ClientState:Update({
                EquippedItems = p35.EquippedItems
            });
        end;

        task.defer(function() -- Line: 294
            -- upvalues: getFrameByTag (ref), refreshUI (ref), u34 (ref)
            if getFrameByTag("OwnedItemsFrame") and getFrameByTag("EquippedItemsFrame") then
                refreshUI();

                return;
            end;

            u34 = true;
        end);
    end;
end);

local function onFrameTagAdded(p36) -- Line: 307
    -- upvalues: PlayerGui (copy), u34 (ref), refreshUI (copy)
    if p36:IsDescendantOf(PlayerGui) then
        task.defer(function() -- Line: 310
            -- upvalues: u34 (ref), refreshUI (ref)
            u34 = false;
            refreshUI();
        end);
    end;
end;

CollectionService:GetInstanceAddedSignal("OwnedItemsFrame"):Connect(onFrameTagAdded);
CollectionService:GetInstanceAddedSignal("EquippedItemsFrame"):Connect(onFrameTagAdded);

local function connectBulkButton(u37, u38) -- Line: 323
    -- upvalues: PlayerGui (copy), u2 (ref), ItemAction (copy), CollectionService (copy)
    local u39 = {};

    local function tryConnect(u40) -- Line: 326
        -- upvalues: u39 (copy), PlayerGui (ref), u37 (copy), u38 (copy), u2 (ref), ItemAction (ref)
        if u39[u40] then
            return;
        end;

        if not u40:IsDescendantOf(PlayerGui) then
            return;
        end;

        if not (u40:IsA("GuiButton") or (u40:IsA("TextButton") or u40:IsA("ImageButton"))) then
            return;
        end;

        u39[u40] = true;
        print("[Items] Bouton connecté:", u37, "→", u38);
        u40.Activated:Connect(function() -- Line: 334
            -- upvalues: u2 (ref), u38 (ref), ItemAction (ref)
            if u2 then
                return;
            end;

            u2 = true;
            print("[Items] Clic:", u38);
            ItemAction:FireServer(u38);
            task.delay(0.4, function() -- Line: 339
                -- upvalues: u2 (ref)
                u2 = false;
            end);
        end);
        u40.Destroying:Connect(function() -- Line: 344
            -- upvalues: u39 (ref), u40 (copy)
            u39[u40] = nil;
        end);
    end;

    for _, v in ipairs(CollectionService:GetTagged(u37)) do
        tryConnect(v);
    end;

    CollectionService:GetInstanceAddedSignal(u37):Connect(function(u41) -- Line: 355
        -- upvalues: tryConnect (copy)
        task.defer(function() -- Line: 357
            -- upvalues: tryConnect (ref), u41 (copy)
            tryConnect(u41);
        end);
    end);
end;

connectBulkButton("EquipBestItems", "EquipBest");
connectBulkButton("UnequipAllItems", "UnequipAll");

local function setupMoreItemsButton(p42) -- Line: 370
    -- upvalues: PlayerGui (copy), MAX_EQUIPPED_DEFAULT (ref), Items (copy), MarketplaceService (copy), LocalPlayer (copy)
    if not p42:IsDescendantOf(PlayerGui) then
        return;
    end;

    if not (p42:IsA("GuiButton") or (p42:IsA("TextButton") or p42:IsA("ImageButton"))) then
        return;
    end;

    if MAX_EQUIPPED_DEFAULT == Items.MAX_EQUIPPED_GAMEPASS then
        p42.Visible = false;

        return;
    end;

    p42.Activated:Connect(function() -- Line: 380
        -- upvalues: MarketplaceService (ref), LocalPlayer (ref), Items (ref)
        MarketplaceService:PromptGamePassPurchase(LocalPlayer, Items.EXTRA_SLOTS_GAMEPASS_ID);
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("MoreItemsGamepass")) do
    setupMoreItemsButton(v);
end;

CollectionService:GetInstanceAddedSignal("MoreItemsGamepass"):Connect(function(u43) -- Line: 388
    -- upvalues: setupMoreItemsButton (copy)
    task.defer(function() -- Line: 389
        -- upvalues: setupMoreItemsButton (ref), u43 (copy)
        setupMoreItemsButton(u43);
    end);
end);
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p44, p45, p46) -- Line: 394
    -- upvalues: LocalPlayer (copy), Items (copy), MAX_EQUIPPED_DEFAULT (ref), CollectionService (copy), PlayerGui (copy), refreshUI (copy)
    if p44 ~= LocalPlayer then
        return;
    end;

    if p45 ~= Items.EXTRA_SLOTS_GAMEPASS_ID then
        return;
    end;

    if p46 then
        MAX_EQUIPPED_DEFAULT = Items.MAX_EQUIPPED_GAMEPASS;

        for _, v in ipairs(CollectionService:GetTagged("MoreItemsGamepass")) do
            if v:IsDescendantOf(PlayerGui) then
                v.Visible = false;
            end;
        end;

        refreshUI();
    end;
end);
task.spawn(function() -- Line: 414
    -- upvalues: getFrameByTag (copy), refreshUI (copy)
    local v47 = 0;

    while v47 < 10 do
        if getFrameByTag("OwnedItemsFrame") and getFrameByTag("EquippedItemsFrame") then
            refreshUI();

            return;
        end;

        task.wait(0.5);
        v47 = v47 + 0.5;
    end;
end);