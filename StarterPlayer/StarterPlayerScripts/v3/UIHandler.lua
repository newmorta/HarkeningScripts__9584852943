-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.UIHandler
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Config = require(ReplicatedStorage:WaitForChild("Config"));
local TrailConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("TrailConfig"));
local AuraConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("AuraConfig"));
local Items = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("Items"));
local Numbers = require(ReplicatedStorage.Utilities.Numbers);
local BoostSystemConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("BoostSystemConfig"));
local EventsConfig = require(ReplicatedStorage:WaitForChild("EventsConfig"));
local NotificationSystem = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local TrailUISystem = require(ReplicatedStorage:WaitForChild("TrailUISystem"));
local AuraUISystem = require(ReplicatedStorage:WaitForChild("UISystems"):WaitForChild("AuraUISystem"));
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local UpdateUI = Remotes:WaitForChild("UpdateUI");
local ShowWin = Remotes:WaitForChild("ShowWin");
local FunnelShop = Remotes:WaitForChild("FunnelShop", 5);
local u1 = {};
require(game:GetService("ReplicatedStorage"):WaitForChild("SoundPackUISystem"));
require(ReplicatedStorage:WaitForChild("UISystems"):WaitForChild("NewBadgeSystem"));

local function getUI(p2) -- Line: 39
    -- upvalues: u1 (ref), CollectionService (copy), PlayerGui (copy)
    if u1[p2] and u1[p2].Parent then
        return u1[p2];
    end;

    local v3 = CollectionService:GetTagged(p2);

    for _, v in ipairs(v3) do
        if v:IsDescendantOf(PlayerGui) then
            u1[p2] = v;

            return v;
        end;
    end;

    return nil;
end;

local function updateBaseUI() -- Line: 59
    -- upvalues: ClientState (copy), getUI (copy), Config (copy), LocalPlayer (copy), Numbers (copy), TrailConfig (copy), AuraConfig (copy), EventsConfig (copy), Items (copy), TweenService (copy)
    local v4 = ClientState:Get();
    local v5 = getUI("WinsLabel");
    local v6 = getUI("SpeedValue");
    local v7 = getUI("LevelText");
    local v8 = getUI("XPText");
    local v9 = getUI("XPBarFill");
    local v10 = getUI("GamepassMultiplierLabel");
    local v11 = getUI("RebirthMultiplierLabel");
    local v12 = getUI("TrailMultiplierLabel");
    local v13 = getUI("ItemsMultiplierLabel");
    local v14 = getUI("ItemsMultiplierLabel2");
    local v15 = getUI("BoomboxMultiplierLabel");
    local v16 = getUI("CustomSpeedNow");
    local v17 = getUI("MaxCustomSpeed");
    local v18 = getUI("TextboxCustomSpeed");

    if v17 then
        local v19 = Config.CalculateMaxSpeed(v4.Level);
        v17.Text = "Your Max Speed: " .. math.floor(v19);
    end;

    if v18 then
        local v20 = Config.CalculateMaxSpeed(v4.Level);
        v18.PlaceholderText = math.floor(v20);
    end;

    if v16 then
        local v21 = LocalPlayer.Character and v21:FindFirstChild("Humanoid");
        v16.Text = "Current speed: " .. math.floor(v21 and v21.WalkSpeed or (v4.CustomWalkSpeed or Config.DEFAULT_WALKSPEED));
    end;

    if v5 then
        v5.Text = Numbers.formatNumber(v4.Wins);
    end;

    if v6 then
        v6.Text = Numbers.formatNumber(v4.TotalXP) .. " Speed";
    end;

    if v7 then
        v7.Text = "Level " .. v4.Level;
    end;

    local v22 = v4.XP or 0;
    local v23 = v4.XPRequired or 100;

    if v8 then
        v8.Text = Numbers.formatNumber(v22) .. " / " .. Numbers.formatNumber(v23);
    end;

    if v10 then
        v10.Text = "Multiplier x" .. Numbers.formatMultiplier(v4.SpeedBoostMultiplier or 1) .. " (Gamepass)";
    end;

    if v11 then
        v11.Text = "Multiplier x" .. Numbers.formatMultiplier(v4.Multiplier or 1) .. " (Rebirth)";
    end;

    if v12 then
        local v24 = v4.EquippedTrail or "None";
        local v25 = TrailConfig.TRAILS[v24];
        local v26 = AuraConfig.AURAS[v4.EquippedAura or "None"];

        if not v25 then
            for _, v in ipairs(EventsConfig.Trails or {}) do
                if v.Key == v24 then
                    v25 = v;
                    break;
                end;
            end;
        end;

        v12.Text = "Multiplier x" .. Numbers.formatMultiplier((v25 and v25.Multiplier or 1) * (v26 and v26.multiplier or 1)) .. " (Trail & Aura)";
    end;

    local v27 = Items.GetTotalBonusPercent(v4.EquippedItems or {});

    if v13 then
        v13.Text = "+" .. v27 .. "% Speed (Items)";
    end;

    if v14 then
        v14.Text = "+" .. v27 .. "% Speed";
    end;

    if v15 then
        local v28 = LocalPlayer:GetAttribute("RELICSxyz_OwnsBoombox") and 2 or 1;
        v15.Text = "Multiplier x" .. Numbers.formatMultiplier(v28) .. " (Boombox)";
    end;

    if v9 then
        local v29 = math.clamp(v22 / v23, 0, 1);
        TweenService:Create(v9, TweenInfo.new(0.15), {
            Size = UDim2.new(v29, 0, 1, 0)
        }):Play();
    end;
end;

local function updateBoostButtonLabels() -- Line: 186
    -- upvalues: BoostSystemConfig (copy), ClientState (copy), Config (copy), CollectionService (copy), PlayerGui (copy)
    if not BoostSystemConfig.USE_PERCENTAGE_BOOSTS then
        return;
    end;

    local v30 = ClientState:Get().TotalXP or 0;
    local v31 = {};

    for _, v in ipairs(Config.PERCENTAGE_SPEED_BOOSTS or {}) do
        local v32 = BoostSystemConfig.calculSpeed(v, v30);
        v31[v.Key] = "+" .. BoostSystemConfig.niceFormatNumber(v32, 2) .. " Speed";
    end;

    for _, v in ipairs(CollectionService:GetTagged("UIActionBtn")) do
        if v:IsDescendantOf(PlayerGui) then
            local v33 = v31[v:GetAttribute("Action")];

            if v33 then
                local v34 = v:FindFirstChildWhichIsA("TextLabel", true);

                if v34 then
                    v34.Text = v33;
                end;
            end;
        end;
    end;
end;

local function updateSpeedBoostButton() -- Line: 211
    -- upvalues: ClientState (copy), Config (copy), getUI (copy)
    local v35 = (ClientState:Get().CurrentSpeedTier or 0) + 1;
    local v36 = Config.SPEED_UPGRADES[v35];
    local v37 = getUI("SpeedTierLabel");
    local v38 = getUI("SpeedPriceButton");

    if v36 then
        if v37 then
            v37.Text = v36.Multiplier .. "x Speed";
        end;

        if v38 then
            v38.Text = "ONLY " .. v36.Price;
        end;
    else
        if v37 then
            v37.Text = "MAX SPEED";
        end;

        if v38 then
            v38.Text = "OWNED";
            v38.Active = false;
        end;
    end;
end;

local u39 = nil;
local u40 = nil;
UpdateUI.OnClientEvent:Connect(function(p41) -- Line: 238
    -- upvalues: ClientState (copy), TrailUISystem (copy), AuraUISystem (copy), LocalPlayer (copy), Config (copy), updateBaseUI (copy), updateBoostButtonLabels (copy), u40 (ref), NotificationSystem (copy), u39 (ref), updateSpeedBoostButton (copy)
    if not p41 then
        return;
    end;

    local v42 = ClientState:Get();
    local _ = v42.Rebirths or 0;
    local _ = v42.Level;
    ClientState:Update(p41);

    if p41.OwnedTrails or p41.EquippedTrail then
        TrailUISystem:UpdateDisplay();
    end;

    if p41.OwnedAuras or p41.EquippedAura then
        AuraUISystem:UpdateDisplay();
    end;

    local v43 = ClientState:Get();
    local v44 = LocalPlayer.Character and v44:FindFirstChild("Humanoid");

    if v44 and (v43.CustomWalkSpeed == nil or v43.CustomWalkSpeed == 0) then
        v44.WalkSpeed = Config.CalculateMaxSpeed(v43.Level);
    end;

    updateBaseUI();
    updateBoostButtonLabels();

    if p41.StepBonus ~= nil or p41.Wins ~= nil then
        task.defer(function() -- Line: 266
            if _G.RefreshAwardVisuals then
                _G.RefreshAwardVisuals();
            end;
        end);
    end;

    if p41.Rebirths then
        local Rebirths = p41.Rebirths;

        if u40 == nil then
            u40 = Rebirths;
        elseif u40 < Rebirths then
            task.wait(0.5);
            NotificationSystem:ShowRebirth(Rebirths);
            u40 = Rebirths;
        end;
    end;

    if p41.Level then
        local Level = p41.Level;

        if u39 == nil or Level < u39 then
            u39 = Level;
        elseif u39 < Level then
            NotificationSystem:ShowLevelUp(u39, Level);
            u39 = Level;
        end;
    end;

    if p41.CurrentSpeedTier ~= nil then
        updateSpeedBoostButton();
    end;
end);
local u55 = {
    SpeedBoost = function() -- Line: 324
        -- upvalues: Remotes (copy)
        Remotes.PromptSpeedBoost:FireServer();
    end,

    WinsBoost = function() -- Line: 325
        -- upvalues: Remotes (copy)
        Remotes.PromptWinsBoost:FireServer();
    end,

    Boost150K = function() -- Line: 326
        -- upvalues: Remotes (copy)
        Remotes.Prompt150KSpeed:FireServer();
    end,

    Boost1M = function() -- Line: 327
        -- upvalues: Remotes (copy)
        Remotes.Prompt1MSpeed:FireServer();
    end,

    Boost10M = function() -- Line: 328
        -- upvalues: Remotes (copy)
        Remotes.Prompt10MSpeed:FireServer();
    end,

    Boost50M = function() -- Line: 329
        -- upvalues: Remotes (copy)
        Remotes.Prompt50MSpeed:FireServer();
    end,

    Boost500M = function() -- Line: 330
        -- upvalues: Remotes (copy)
        Remotes.Prompt500MSpeed:FireServer();
    end,

    Boost1B = function() -- Line: 331
        -- upvalues: Remotes (copy)
        Remotes.Prompt1BSpeed:FireServer();
    end,

    Rebirth = function() -- Line: 332
        -- upvalues: ReplicatedStorage (copy), ClientState (copy), getUI (copy)
        require(ReplicatedStorage.RebirthUISystem):InitLogic();
        ClientState:ToggleModal(getUI("RebirthModal"), require(ReplicatedStorage.RebirthUISystem));
    end,

    Gift = function() -- Line: 333
        -- upvalues: ReplicatedStorage (copy), ClientState (copy), getUI (copy)
        require(ReplicatedStorage.GiftUISystem):InitLogic();
        ClientState:ToggleModal(getUI("GiftModal"), require(ReplicatedStorage.GiftUISystem));
    end,

    SoundPack = function() -- Line: 334
        -- upvalues: ReplicatedStorage (copy), ClientState (copy), getUI (copy)
        local SoundPackUISystem = require(ReplicatedStorage.SoundPackUISystem);
        SoundPackUISystem:InitLogic();
        ClientState:ToggleModal(getUI("SoundPackModal"), SoundPackUISystem);
    end,

    TrailsModal = function() -- Line: 340
        -- upvalues: TrailUISystem (copy), getUI (copy), ClientState (copy), FunnelShop (copy)
        TrailUISystem:InitLogic();
        local v45 = getUI("TrailsModal");

        if ClientState.ActiveModal ~= v45 and FunnelShop then
            FunnelShop:FireServer("open");
        end;

        ClientState:ToggleModal(v45, TrailUISystem);
        TrailUISystem:UpdateDisplay();
    end,

    AurasModal = function() -- Line: 347
        -- upvalues: AuraUISystem (copy), getUI (copy), ClientState (copy), FunnelShop (copy)
        AuraUISystem:InitLogic();
        local v46 = getUI("AurasModal");

        if ClientState.ActiveModal ~= v46 and FunnelShop then
            FunnelShop:FireServer("open");
        end;

        ClientState:ToggleModal(v46, AuraUISystem);
        AuraUISystem:UpdateDisplay();
    end,

    RobuxShopModal = function() -- Line: 355
        -- upvalues: ReplicatedStorage (copy), getUI (copy), ClientState (copy)
        local RobuxShopUISystem = require(ReplicatedStorage:WaitForChild("UISystems"):WaitForChild("RobuxShopUISystem"));
        RobuxShopUISystem:InitLogic();
        ClientState:ToggleModal(getUI("RobuxShopModal"), RobuxShopUISystem);
        RobuxShopUISystem:UpdateDisplay();
    end,

    MedalQuestModal = function() -- Line: 363
        -- upvalues: ReplicatedStorage (copy), getUI (copy), ClientState (copy)
        local MedalUISystem = require(ReplicatedStorage:WaitForChild("UISystems"):WaitForChild("MedalUISystem"));
        MedalUISystem:InitLogic();
        local v47 = getUI("MedalQuestModal");
        local v48 = ClientState.ActiveModal ~= v47;
        ClientState:ToggleModal(v47, MedalUISystem);

        if v48 and ClientState.ActiveModal == v47 then
            MedalUISystem:Open();
        end;
    end,

    Checkpoint = function() -- Line: 374
        -- upvalues: getUI (copy), ClientState (copy), FunnelShop (copy)
        local v49 = getUI("CheckpointModal");

        if ClientState.ActiveModal ~= v49 and FunnelShop then
            FunnelShop:FireServer("open");
        end;

        ClientState:ToggleModal(v49);
    end,

    Shop = function() -- Line: 379
        -- upvalues: getUI (copy), ClientState (copy), FunnelShop (copy)
        local v50 = getUI("ShopModal");

        if ClientState.ActiveModal ~= v50 and FunnelShop then
            FunnelShop:FireServer("open");
        end;

        ClientState:ToggleModal(v50);
    end,

    EventShop = function() -- Line: 384
        -- upvalues: getUI (copy), ClientState (copy), FunnelShop (copy)
        local v51 = getUI("EventShopModal");

        if ClientState.ActiveModal ~= v51 and FunnelShop then
            FunnelShop:FireServer("open");
        end;

        ClientState:ToggleModal(v51);
    end,

    EventCurrency = function() -- Line: 389
        -- upvalues: getUI (copy), ClientState (copy), FunnelShop (copy)
        local v52 = getUI("EventCurrencyModal");

        if ClientState.ActiveModal ~= v52 and FunnelShop then
            FunnelShop:FireServer("open");
        end;

        ClientState:ToggleModal(v52);
    end,

    InventoryModal = function() -- Line: 395
        -- upvalues: getUI (copy), TrailUISystem (copy), AuraUISystem (copy), ClientState (copy)
        local v53 = getUI("InventoryModal");
        TrailUISystem:InitLogic();
        AuraUISystem:InitLogic();
        ClientState:ToggleModal(v53);
        TrailUISystem:UpdateDisplay();
        AuraUISystem:UpdateDisplay();
    end,

    ItemShopModal = function() -- Line: 404
        -- upvalues: getUI (copy), ClientState (copy)
        ClientState:ToggleModal((getUI("ItemsShopModal")));
    end,

    PersonalTreadmill = function() -- Line: 409
        -- upvalues: Remotes (copy), NotificationSystem (copy)
        local v54 = Remotes.PlacePersonalTreadmill:InvokeServer();

        if type(v54) == "table" and not v54.ok then
            NotificationSystem:ShowMessage(v54.err or "Couldn\'t place your treadmill here.", Color3.fromRGB(255, 100, 100));
        end;
    end
};

local function setupButton(p56) -- Line: 422
    -- upvalues: Config (copy), u55 (copy)
    local v57 = p56:GetAttribute("Action");

    if v57 == "Checkpoint" and not Config.FEATURES.CHECKPOINTS then
        if p56:IsA("GuiObject") then
            p56.Visible = false;
        end;

        return;
    end;

    if v57 and u55[v57] then
        p56.MouseButton1Click:Connect(u55[v57]);
    end;
end;

for _, v in ipairs(CollectionService:GetTagged("UIActionBtn")) do
    local v58 = v:GetAttribute("Action");

    if v58 == "Checkpoint" and not Config.FEATURES.CHECKPOINTS then
        if v:IsA("GuiObject") then
            v.Visible = false;
        end;
    elseif v58 and u55[v58] then
        v.MouseButton1Click:Connect(u55[v58]);
    end;
end;

CollectionService:GetInstanceAddedSignal("UIActionBtn"):Connect(setupButton);

local function setupInventoryClose(p59) -- Line: 439
    -- upvalues: PlayerGui (copy), ClientState (copy)
    if p59:IsDescendantOf(PlayerGui) then
        p59.MouseButton1Click:Connect(function() -- Line: 441
            -- upvalues: ClientState (ref)
            ClientState:CloseCurrentModal();
        end);
    end;
end;

for _, v in ipairs(CollectionService:GetTagged("InventoryCloseModal")) do
    if v:IsDescendantOf(PlayerGui) then
        v.MouseButton1Click:Connect(function() -- Line: 441
            -- upvalues: ClientState (copy)
            ClientState:CloseCurrentModal();
        end);
    end;
end;

CollectionService:GetInstanceAddedSignal("InventoryCloseModal"):Connect(function(u60) -- Line: 447
    -- upvalues: PlayerGui (copy), ClientState (copy)
    task.defer(function() -- Line: 448
        -- upvalues: u60 (copy), PlayerGui (ref), ClientState (ref)
        local v61 = u60;

        if v61:IsDescendantOf(PlayerGui) then
            v61.MouseButton1Click:Connect(function() -- Line: 441
                -- upvalues: ClientState (ref)
                ClientState:CloseCurrentModal();
            end);
        end;
    end);
end);

local function setupItemsShopClose(p62) -- Line: 452
    -- upvalues: PlayerGui (copy), ClientState (copy)
    if p62:IsDescendantOf(PlayerGui) then
        p62.MouseButton1Click:Connect(function() -- Line: 454
            -- upvalues: ClientState (ref)
            ClientState:CloseCurrentModal();
        end);
    end;
end;

for _, v in ipairs(CollectionService:GetTagged("ItemsShopCloseModal")) do
    if v:IsDescendantOf(PlayerGui) then
        v.MouseButton1Click:Connect(function() -- Line: 454
            -- upvalues: ClientState (copy)
            ClientState:CloseCurrentModal();
        end);
    end;
end;

CollectionService:GetInstanceAddedSignal("ItemsShopCloseModal"):Connect(function(u63) -- Line: 460
    -- upvalues: PlayerGui (copy), ClientState (copy)
    task.defer(function() -- Line: 461
        -- upvalues: u63 (copy), PlayerGui (ref), ClientState (ref)
        local v64 = u63;

        if v64:IsDescendantOf(PlayerGui) then
            v64.MouseButton1Click:Connect(function() -- Line: 454
                -- upvalues: ClientState (ref)
                ClientState:CloseCurrentModal();
            end);
        end;
    end);
end);
local u65 = Color3.fromHex("#4710be");
local u66 = Color3.fromHex("#6f0ebe");
local u67 = Color3.fromRGB(255, 255, 255);
local u68 = Color3.fromRGB(0, 0, 0);
local u69 = nil;
local u70 = false;

local function getAllButtons() -- Line: 477
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    local v71 = {};

    for _, v in ipairs(CollectionService:GetTagged("InventoryButtons")) do
        if v:IsDescendantOf(PlayerGui) then
            table.insert(v71, v);
        end;
    end;

    return v71;
end;

local function getAllWindows() -- Line: 487
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    local v72 = {};

    for _, v in ipairs(CollectionService:GetTagged("InventoryWindow")) do
        if v:IsDescendantOf(PlayerGui) then
            table.insert(v72, v);
        end;
    end;

    return v72;
end;

local function switchTab(p73) -- Line: 497
    -- upvalues: u70 (ref), u69 (ref), getAllWindows (copy), getAllButtons (copy), u65 (copy), u66 (copy), u67 (copy), u68 (copy)
    if u70 then
        return;
    end;

    local v74 = string.lower(p73);

    if u69 == v74 then
        return;
    end;

    u70 = true;
    u69 = v74;

    for _, v in ipairs((getAllWindows())) do
        v.Visible = string.lower(v:GetAttribute("Window") or "") == v74;
    end;

    for _, v in ipairs((getAllButtons())) do
        local v75 = string.lower(v:GetAttribute("Action") or "") == v74;
        v.BackgroundColor3 = v75 and u65 or u66;
        local v76 = v:FindFirstChildWhichIsA("UIStroke");

        if v76 then
            v76.Color = v75 and u67 or u68;
        end;
    end;

    u70 = false;
end;

local function setupTabButton(p77) -- Line: 524
    -- upvalues: PlayerGui (copy), switchTab (copy)
    if not p77:IsDescendantOf(PlayerGui) then
        return;
    end;

    local u78 = p77:GetAttribute("Action");

    if not u78 then
        return;
    end;

    p77.MouseButton1Click:Connect(function() -- Line: 529
        -- upvalues: switchTab (ref), u78 (copy)
        switchTab(u78);
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("InventoryButtons")) do
    setupTabButton(v);
end;

CollectionService:GetInstanceAddedSignal("InventoryButtons"):Connect(function(u79) -- Line: 540
    -- upvalues: setupTabButton (copy), u69 (ref), PlayerGui (copy), u65 (copy), u66 (copy), u67 (copy), u68 (copy)
    task.defer(function() -- Line: 541
        -- upvalues: setupTabButton (ref), u79 (copy), u69 (ref), PlayerGui (ref), u65 (ref), u66 (ref), u67 (ref), u68 (ref)
        setupTabButton(u79);

        if u69 then
            local v80 = u79:GetAttribute("Action");

            if v80 and u79:IsDescendantOf(PlayerGui) then
                local v81 = string.lower(v80) == u69;
                u79.BackgroundColor3 = v81 and u65 or u66;
                local v82 = u79:FindFirstChildWhichIsA("UIStroke");

                if v82 then
                    v82.Color = v81 and u67 or u68;
                end;
            end;
        end;
    end);
end);
CollectionService:GetInstanceAddedSignal("InventoryWindow"):Connect(function(u83) -- Line: 559
    -- upvalues: PlayerGui (copy), u69 (ref)
    task.defer(function() -- Line: 560
        -- upvalues: u83 (copy), PlayerGui (ref), u69 (ref)
        if u83:IsDescendantOf(PlayerGui) and u69 then
            u83.Visible = string.lower(u83:GetAttribute("Window") or "") == u69;
        end;
    end);
end);
task.defer(function() -- Line: 568
    -- upvalues: switchTab (copy)
    switchTab("Trails");
end);
updateBoostButtonLabels();
LocalPlayer:GetAttributeChangedSignal("RELICSxyz_OwnsBoombox"):Connect(updateBaseUI);
local u84 = false;
local u85 = false;
local u86 = false;
LocalPlayer.CharacterAdded:Connect(function() -- Line: 585
    -- upvalues: u84 (ref), u85 (ref), u86 (ref), u1 (ref), ClientState (copy)
    u84 = false;
    u85 = false;
    u86 = false;
    u1 = {};
    ClientState:ForceResetModal();
end);

local function setupCheckpointPortal(u87) -- Line: 593
    -- upvalues: Config (copy), u84 (ref), LocalPlayer (copy), FunnelShop (copy), ClientState (copy), getUI (copy)
    if not Config.FEATURES.CHECKPOINTS then
        return;
    end;

    if not u87:IsA("BasePart") then
        return;
    end;

    u87.Touched:Connect(function(p88) -- Line: 596
        -- upvalues: u84 (ref), LocalPlayer (ref), FunnelShop (ref), ClientState (ref), getUI (ref)
        if u84 then
            return;
        end;

        local Character = LocalPlayer.Character;

        if Character and p88:IsDescendantOf(Character) then
            u84 = true;

            if FunnelShop then
                FunnelShop:FireServer("open");
            end;

            ClientState:ToggleModal((getUI("CheckpointModal")));
        end;
    end);
    u87.TouchEnded:Connect(function(p89) -- Line: 605
        -- upvalues: LocalPlayer (ref), u87 (copy), u84 (ref), ClientState (ref), getUI (ref)
        local Character = LocalPlayer.Character;

        if not (Character and p89:IsDescendantOf(Character)) then
            return;
        end;

        task.delay(0.15, function() -- Line: 608
            -- upvalues: Character (copy), u87 (ref), u84 (ref), ClientState (ref), getUI (ref)
            local v90 = OverlapParams.new();
            v90.FilterDescendantsInstances = { Character };
            v90.FilterType = Enum.RaycastFilterType.Include;

            if #workspace:GetPartsInPart(u87, v90) == 0 then
                u84 = false;

                if ClientState.ActiveModal == getUI("CheckpointModal") then
                    ClientState:CloseCurrentModal();
                end;
            end;
        end);
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("OpenCheckpointModal")) do
    setupCheckpointPortal(v);
end;

CollectionService:GetInstanceAddedSignal("OpenCheckpointModal"):Connect(setupCheckpointPortal);

local function isAnyEventActive() -- Line: 632
    -- upvalues: EventsConfig (copy)
    local v91 = os.time();

    for _, v in ipairs(EventsConfig.Events) do
        if v.Start <= v91 and v91 < v.End then
            return true;
        end;
    end;

    return false;
end;

local function setupEventShopPortal(u92) -- Line: 642
    -- upvalues: u85 (ref), isAnyEventActive (copy), LocalPlayer (copy), FunnelShop (copy), ClientState (copy), getUI (copy)
    if not u92:IsA("BasePart") then
        return;
    end;

    u92.Touched:Connect(function(p93) -- Line: 644
        -- upvalues: u85 (ref), isAnyEventActive (ref), LocalPlayer (ref), FunnelShop (ref), ClientState (ref), getUI (ref)
        if u85 then
            return;
        end;

        if not isAnyEventActive() then
            return;
        end;

        local Character = LocalPlayer.Character;

        if Character and p93:IsDescendantOf(Character) then
            u85 = true;

            if FunnelShop then
                FunnelShop:FireServer("open");
            end;

            ClientState:ToggleModal((getUI("EventShopModal")));
        end;
    end);
    u92.TouchEnded:Connect(function(p94) -- Line: 654
        -- upvalues: LocalPlayer (ref), u92 (copy), u85 (ref), ClientState (ref), getUI (ref)
        local Character = LocalPlayer.Character;

        if not (Character and p94:IsDescendantOf(Character)) then
            return;
        end;

        task.delay(0.15, function() -- Line: 657
            -- upvalues: Character (copy), u92 (ref), u85 (ref), ClientState (ref), getUI (ref)
            local v95 = OverlapParams.new();
            v95.FilterDescendantsInstances = { Character };
            v95.FilterType = Enum.RaycastFilterType.Include;

            if #workspace:GetPartsInPart(u92, v95) == 0 then
                u85 = false;

                if ClientState.ActiveModal == getUI("EventShopModal") then
                    ClientState:CloseCurrentModal();
                end;
            end;
        end);
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("OpenEventShopModal")) do
    setupEventShopPortal(v);
end;

CollectionService:GetInstanceAddedSignal("OpenEventShopModal"):Connect(setupEventShopPortal);

local function setupItemsShopZone(u96) -- Line: 681
    -- upvalues: u86 (ref), LocalPlayer (copy), ClientState (copy), getUI (copy)
    if not u96:IsA("BasePart") then
        return;
    end;

    u96.Touched:Connect(function(p97) -- Line: 683
        -- upvalues: u86 (ref), LocalPlayer (ref), ClientState (ref), getUI (ref)
        if u86 then
            return;
        end;

        local Character = LocalPlayer.Character;

        if Character and p97:IsDescendantOf(Character) then
            u86 = true;
            ClientState:ToggleModal((getUI("ItemsShopModal")));
        end;
    end);
    u96.TouchEnded:Connect(function(p98) -- Line: 691
        -- upvalues: LocalPlayer (ref), u96 (copy), u86 (ref), ClientState (ref), getUI (ref)
        local Character = LocalPlayer.Character;

        if not (Character and p98:IsDescendantOf(Character)) then
            return;
        end;

        task.delay(0.15, function() -- Line: 694
            -- upvalues: Character (copy), u96 (ref), u86 (ref), ClientState (ref), getUI (ref)
            local v99 = OverlapParams.new();
            v99.FilterDescendantsInstances = { Character };
            v99.FilterType = Enum.RaycastFilterType.Include;

            if #workspace:GetPartsInPart(u96, v99) == 0 then
                u86 = false;

                if ClientState.ActiveModal == getUI("ItemsShopModal") then
                    ClientState:CloseCurrentModal();
                end;
            end;
        end);
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("OpenItemsShopZone")) do
    setupItemsShopZone(v);
end;

CollectionService:GetInstanceAddedSignal("OpenItemsShopZone"):Connect(setupItemsShopZone);
task.spawn(function() -- Line: 715
    -- upvalues: isAnyEventActive (copy), getUI (copy), ClientState (copy), u85 (ref)
    while true do
        repeat
            task.wait(5);
        until not isAnyEventActive();

        local v100 = getUI("EventShopModal");

        if v100 and ClientState.ActiveModal == v100 then
            u85 = false;
            ClientState:CloseCurrentModal();
        end;
    end;
end);
ShowWin.OnClientEvent:Connect(function(p101) -- Line: 728
    -- upvalues: NotificationSystem (copy)
    NotificationSystem:ShowWinNotification(p101);
end);
local BossHit = Remotes:WaitForChild("BossHit", 10);

if BossHit then
    BossHit.OnClientEvent:Connect(function() -- Line: 734
    end);
end;

task.wait(1);
Remotes.RequestInitialData:FireServer();
local u102 = {};

local function connectSpeedLogic() -- Line: 750
    -- upvalues: getUI (copy), u102 (copy), ClientState (copy), NotificationSystem (copy), Config (copy), Remotes (copy), LocalPlayer (copy), updateBaseUI (copy)
    local u103 = getUI("TextboxCustomSpeed");
    local v104 = getUI("ButtonCustomSpeed");

    if not (u103 and v104) then
        return;
    end;

    if u102[v104] then
        return;
    end;

    u102[v104] = v104.MouseButton1Click:Connect(function() -- Line: 760, Name: applyCustomSpeed
        -- upvalues: ClientState (ref), u103 (copy), NotificationSystem (ref), Config (ref), Remotes (ref), LocalPlayer (ref), updateBaseUI (ref)
        local v105 = ClientState:Get();
        local v106 = tonumber(u103.Text);

        if not v106 then
            NotificationSystem:ShowMessage("Enter a valid number!", Color3.fromRGB(255, 100, 100));

            return;
        end;

        local v107 = Config.CalculateMaxSpeed(v105.Level);
        local v108 = math.clamp(v106, Config.DEFAULT_WALKSPEED, v107);
        Remotes.SetCustomSpeed:FireServer(v108);
        ClientState:Update({
            CustomWalkSpeed = v108
        });
        local Character = LocalPlayer.Character;

        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.WalkSpeed = v108;
        end;

        updateBaseUI();
        u103.Text = "";
        NotificationSystem:ShowMessage("Speed updated!", Color3.fromRGB(200, 255, 200));
    end);
end;

CollectionService:GetInstanceAddedSignal("TextboxCustomSpeed"):Connect(connectSpeedLogic);
CollectionService:GetInstanceAddedSignal("ButtonCustomSpeed"):Connect(connectSpeedLogic);
task.spawn(connectSpeedLogic);
LocalPlayer.CharacterAdded:Connect(function(p109) -- Line: 802
    -- upvalues: ClientState (copy), Config (copy)
    local Humanoid = p109:WaitForChild("Humanoid");
    local v110 = ClientState:Get();
    task.wait(0.1);
    Humanoid.WalkSpeed = v110.CustomWalkSpeed and v110.CustomWalkSpeed > 0 and v110.CustomWalkSpeed or Config.CalculateMaxSpeed(v110.Level);
end);