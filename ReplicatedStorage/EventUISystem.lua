-- Ruta Original: ReplicatedStorage.EventUISystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local MarketplaceService = game:GetService("MarketplaceService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local EventsConfig = require(ReplicatedStorage:WaitForChild("EventsConfig"));
local NotificationSystem = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
local Config = require(ReplicatedStorage:WaitForChild("Config"));
local v1 = {};
local u2 = false;

local function playSound(p3) -- Line: 23
    -- upvalues: SoundService (copy)
    if not p3 then
        return;
    end;

    local Sound = Instance.new("Sound");
    Sound.SoundId = p3.ID;
    Sound.Volume = p3.Volume or 0.5;
    Sound.RollOffMaxDistance = 0;
    Sound:SetAttribute("IsEventSound", true);
    Sound.Parent = SoundService;
    Sound:Play();
    Sound.Ended:Connect(function() -- Line: 32
        -- upvalues: Sound (copy)
        Sound:Destroy();
    end);
end;

local function getModalByTag(p4) -- Line: 35
    -- upvalues: Players (copy), CollectionService (copy)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");

    for _, v in ipairs(CollectionService:GetTagged(p4)) do
        if v:IsDescendantOf(PlayerGui) then
            return v;
        end;
    end;
end;

local function formatCountdown(p5) -- Line: 46
    if p5 <= 0 then
        return "0j 00h 00m 00s";
    end;

    local v6 = math.floor(p5 / 86400);
    local v7 = math.floor(p5 % 86400 / 3600);
    local v8 = math.floor(p5 % 3600 / 60);

    return string.format("%dj %02dh %02dm %02ds", v6, v7, v8, p5 % 60);
end;

function v1.Init(p9) -- Line: 59
    -- upvalues: u2 (ref), MarketplaceService (copy), Players (copy), EventsConfig (copy), CollectionService (copy), ReplicatedStorage (copy), playSound (copy), Config (copy), NotificationSystem (copy), getModalByTag (copy), ClientState (copy)
    if u2 then
        return;
    end;

    u2 = true;
    local u10 = {};

    local function applyButton(p11, u12) -- Line: 69
        -- upvalues: MarketplaceService (ref), Players (ref), u10 (copy)
        p11.Activated:Connect(function() -- Line: 70
            -- upvalues: MarketplaceService (ref), Players (ref), u12 (copy)
            MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, u12);
        end);

        if u10[u12] ~= nil then
            p11.Visible = not u10[u12];
        end;
    end;

    local u13 = {};
    local u14 = {};

    for _, v in ipairs(EventsConfig.GamepassButtons or {}) do
        for _, v2 in ipairs(CollectionService:GetTagged(v.Tag)) do
            local Gamepass = v.Gamepass;
            v2.Activated:Connect(function() -- Line: 70
                -- upvalues: MarketplaceService (ref), Players (ref), Gamepass (copy)
                MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, Gamepass);
            end);

            if u10[Gamepass] ~= nil then
                v2.Visible = not u10[Gamepass];
            end;
        end;

        CollectionService:GetInstanceAddedSignal(v.Tag):Connect(function(p15) -- Line: 83
            -- upvalues: v (copy), MarketplaceService (ref), Players (ref), u10 (copy)
            local Gamepass = v.Gamepass;
            p15.Activated:Connect(function() -- Line: 70
                -- upvalues: MarketplaceService (ref), Players (ref), Gamepass (copy)
                MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, Gamepass);
            end);

            if u10[Gamepass] ~= nil then
                p15.Visible = not u10[Gamepass];
            end;
        end);
    end;

    task.spawn(function() -- Line: 89
        -- upvalues: Players (ref), EventsConfig (ref), MarketplaceService (ref), u10 (copy), CollectionService (ref)
        local UserId = Players.LocalPlayer.UserId;

        for _, v in ipairs(EventsConfig.GamepassButtons or {}) do
            local Gamepass = v.Gamepass;
            local success, result = pcall(function() -- Line: 93
                -- upvalues: MarketplaceService (ref), UserId (copy), Gamepass (copy)
                return MarketplaceService:UserOwnsGamePassAsync(UserId, Gamepass);
            end);
            u10[Gamepass] = success and result;

            for _, v2 in ipairs(CollectionService:GetTagged(v.Tag)) do
                v2.Visible = not u10[Gamepass];
            end;
        end;
    end);
    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p16, p17, p18) -- Line: 104
        -- upvalues: u10 (copy), EventsConfig (ref), CollectionService (ref)
        if not p18 then
            return;
        end;

        u10[p17] = true;

        for _, v in ipairs(EventsConfig.GamepassButtons or {}) do
            if v.Gamepass == p17 then
                for _, v2 in ipairs(CollectionService:GetTagged(v.Tag)) do
                    v2.Visible = false;
                end;
            end;
        end;
    end);
    local BuyEventReward = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BuyEventReward", 10);

    if BuyEventReward then
        for _, v in ipairs(EventsConfig.ShopRewards or {}) do
            local Tag = v.Tag;

            local function applyShopBtn(p19) -- Line: 123
                -- upvalues: BuyEventReward (copy), Tag (copy), v (copy), playSound (ref), Config (ref), NotificationSystem (ref), getModalByTag (ref), ClientState (ref)
                p19.Activated:Connect(function() -- Line: 124
                    -- upvalues: BuyEventReward (ref), Tag (ref), v (ref), playSound (ref), Config (ref), NotificationSystem (ref), getModalByTag (ref), ClientState (ref)
                    local v20, v21 = BuyEventReward:InvokeServer(Tag);

                    if v20 then
                        local v22 = v.Reward.Type == "Wins" and "Wins" or "XP";
                        playSound(Config.SOUNDS.BUY);
                        NotificationSystem:ShowMessage("+" .. v21 .. " " .. v22 .. "!", Color3.fromRGB(100, 255, 140));

                        return;
                    end;

                    playSound(Config.SOUNDS.ERROR);
                    local v23 = getModalByTag("EventCurrencyModal");

                    if v23 then
                        ClientState:ToggleModal(v23);

                        return;
                    end;

                    NotificationSystem:ShowMessage("Not enough " .. v.Currency.Key .. "!", Color3.fromRGB(255, 100, 100));
                end);
            end;

            for _, v2 in ipairs(CollectionService:GetTagged(Tag)) do
                v2.Activated:Connect(function() -- Line: 124
                    -- upvalues: BuyEventReward (copy), Tag (copy), v (copy), playSound (ref), Config (ref), NotificationSystem (ref), getModalByTag (ref), ClientState (ref)
                    local v24, v25 = BuyEventReward:InvokeServer(Tag);

                    if v24 then
                        local v26 = v.Reward.Type == "Wins" and "Wins" or "XP";
                        playSound(Config.SOUNDS.BUY);
                        NotificationSystem:ShowMessage("+" .. v25 .. " " .. v26 .. "!", Color3.fromRGB(100, 255, 140));

                        return;
                    end;

                    playSound(Config.SOUNDS.ERROR);
                    local v27 = getModalByTag("EventCurrencyModal");

                    if v27 then
                        ClientState:ToggleModal(v27);

                        return;
                    end;

                    NotificationSystem:ShowMessage("Not enough " .. v.Currency.Key .. "!", Color3.fromRGB(255, 100, 100));
                end);
            end;

            CollectionService:GetInstanceAddedSignal(Tag):Connect(applyShopBtn);
        end;
    end;

    for _, v in ipairs(EventsConfig.CurrencyDevProducts or {}) do
        local Id = v.Id;

        local function applyDevBtn(p28) -- Line: 151
            -- upvalues: MarketplaceService (ref), Players (ref), Id (copy)
            p28.Activated:Connect(function() -- Line: 152
                -- upvalues: MarketplaceService (ref), Players (ref), Id (ref)
                MarketplaceService:PromptProductPurchase(Players.LocalPlayer, Id);
            end);
        end;

        for _, v2 in ipairs(CollectionService:GetTagged(v.Tag)) do
            v2.Activated:Connect(function() -- Line: 152
                -- upvalues: MarketplaceService (ref), Players (ref), Id (copy)
                MarketplaceService:PromptProductPurchase(Players.LocalPlayer, Id);
            end);
        end;

        CollectionService:GetInstanceAddedSignal(v.Tag):Connect(applyDevBtn);
    end;

    local u29 = {};

    for _, v in ipairs(EventsConfig.CurrencyDevProducts or {}) do
        u29[v.Id] = true;
    end;

    MarketplaceService.PromptProductPurchaseFinished:Connect(function(p30, p31, p32) -- Line: 167
        -- upvalues: u29 (copy), playSound (ref), Config (ref)
        if not u29[p31] then
            return;
        end;

        playSound(p32 and Config.SOUNDS.BUY or Config.SOUNDS.ERROR);
    end);
    local u33 = {};

    for _, v in ipairs(EventsConfig.GamepassButtons or {}) do
        u33[v.Gamepass] = true;
    end;

    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p34, p35, p36) -- Line: 177
        -- upvalues: u33 (copy), playSound (ref), Config (ref)
        if not u33[p35] then
            return;
        end;

        playSound(p36 and Config.SOUNDS.BUY or Config.SOUNDS.ERROR);
    end);
    local v37 = os.time();
    local v38 = false;

    for _, v in ipairs(EventsConfig.Events) do
        if v.Start <= v37 and v37 < v.End then
            v38 = true;
            break;
        end;
    end;

    for _, v in ipairs(CollectionService:GetTagged("UIActionBtn")) do
        if v:GetAttribute("Action") == "EventShop" then
            v.Visible = v38;
        end;
    end;

    for i, v in ipairs(EventsConfig.Events) do
        u13[i] = false;
        u14[i] = false;

        if v.FrameTag and v.FrameTag ~= "" then
            for _, v2 in ipairs(CollectionService:GetTagged(v.FrameTag)) do
                v2.Visible = false;
            end;
        end;

        for _, v2 in ipairs(v.ExtraFrameTags or {}) do
            for _, v3 in ipairs(CollectionService:GetTagged(v2)) do
                v3.Visible = false;
            end;
        end;

        if v.TimerTag then
            for _, v2 in ipairs(CollectionService:GetTagged(v.TimerTag)) do
                v2.Visible = false;
            end;
        end;

        if v.FrameTag and v.FrameTag ~= "" then
            CollectionService:GetInstanceAddedSignal(v.FrameTag):Connect(function(p39) -- Line: 219
                -- upvalues: EventsConfig (ref), i (copy), ClientState (ref)
                local v40 = EventsConfig.Events[i];
                local v41 = os.time();
                local v42 = v40.FrameTag:gsub("Frame$", "");
                local v43 = table.find(ClientState:Get().OwnedTrails or {}, v42) ~= nil;

                if not v43 then
                    if v40.Start <= v41 then
                        v43 = v41 < v40.End;
                    else
                        v43 = false;
                    end;
                end;

                p39.Visible = v43;
            end);
        end;

        for _, v2 in ipairs(v.ExtraFrameTags or {}) do
            CollectionService:GetInstanceAddedSignal(v2):Connect(function(p44) -- Line: 228
                -- upvalues: EventsConfig (ref), i (copy), v2 (copy), ClientState (ref)
                local v45 = EventsConfig.Events[i];
                local v46 = os.time();
                local v47 = v2:gsub("Frame$", "");
                local v48 = table.find(ClientState:Get().OwnedTrails or {}, v47) ~= nil;

                if not v48 then
                    if v45.Start <= v46 then
                        v48 = v46 < v45.End;
                    else
                        v48 = false;
                    end;
                end;

                p44.Visible = v48;
            end);
        end;
    end;

    task.spawn(function() -- Line: 239
        -- upvalues: Players (ref), EventsConfig (ref), MarketplaceService (ref), u13 (copy), u14 (copy), ClientState (ref), CollectionService (ref)
        local UserId = Players.LocalPlayer.UserId;

        for i, v in ipairs(EventsConfig.Events) do
            task.spawn(function() -- Line: 244
                -- upvalues: v (copy), MarketplaceService (ref), UserId (copy), u13 (ref), i (copy), u14 (ref)
                if v.Gamepass and v.Gamepass > 0 then
                    local success, result = pcall(function() -- Line: 246
                        -- upvalues: MarketplaceService (ref), UserId (ref), v (ref)
                        return MarketplaceService:UserOwnsGamePassAsync(UserId, v.Gamepass);
                    end);

                    if success then
                        u13[i] = result;
                    end;
                end;

                u14[i] = true;
            end);
            local v49 = os.time();

            if v49 < v.Start then
                task.delay(v.Start - v49, function() -- Line: 257
                    -- upvalues: ClientState (ref), v (copy), CollectionService (ref)
                    local _ = ClientState:Get().OwnedTrails;

                    if v.FrameTag and v.FrameTag ~= "" then
                        for _, v2 in ipairs(CollectionService:GetTagged(v.FrameTag)) do
                            v2.Visible = true;
                        end;
                    end;

                    for _, v2 in ipairs(v.ExtraFrameTags or {}) do
                        for _, v3 in ipairs(CollectionService:GetTagged(v2)) do
                            v3.Visible = true;
                        end;
                    end;
                end);
            end;
        end;

        while true do
            local v50 = os.time();
            local v51 = ClientState:Get().OwnedTrails or {};
            local v52 = {};
            local v53 = {};
            local v54 = nil;

            for _, v in ipairs(EventsConfig.Events) do
                local v55;

                if v.Start <= v50 then
                    v55 = v50 < v.End;
                else
                    v55 = false;
                end;

                if v55 then
                    v54 = v.Name;
                end;

                if v.FrameTag and v.FrameTag ~= "" then
                    local v56 = v.FrameTag:gsub("Frame$", "");
                    local v57 = table.find(v51, v56) ~= nil;
                    v53[v.FrameTag] = v53[v.FrameTag] or (v57 or v55);
                end;

                for _, v2 in ipairs(v.ExtraFrameTags or {}) do
                    local v58 = v2:gsub("Frame$", "");
                    local v59 = table.find(v51, v58) ~= nil;
                    v53[v2] = v53[v2] or (v59 or v55);
                end;

                if v.TimerTag then
                    if not v52[v.TimerTag] then
                        v52[v.TimerTag] = {
                            visible = false,
                            text = nil
                        };
                    end;

                    if v55 then
                        v52[v.TimerTag].visible = true;
                        local v60 = v52[v.TimerTag];
                        local v61 = v.End - v50;
                        local v62;

                        if v61 <= 0 then
                            v62 = "0j 00h 00m 00s";
                        else
                            local v63 = math.floor(v61 / 86400);
                            local v64 = math.floor(v61 % 86400 / 3600);
                            local v65 = math.floor(v61 % 3600 / 60);
                            v62 = string.format("%dj %02dh %02dm %02ds", v63, v64, v65, v61 % 60);
                        end;

                        v60.text = v62;
                    end;
                end;
            end;

            for i, v in pairs(v53) do
                for _, v2 in ipairs(CollectionService:GetTagged(i)) do
                    v2.Visible = v;
                end;
            end;

            for i, v in pairs(v52) do
                for _, v2 in ipairs(CollectionService:GetTagged(i)) do
                    v2.Visible = v.visible;

                    if v.visible and v.text then
                        v2.Text = v.text;
                    end;
                end;
            end;

            local v66 = v54 ~= nil;

            for _, v in ipairs(CollectionService:GetTagged("UIActionBtn")) do
                if v:GetAttribute("Action") == "EventShop" then
                    v.Visible = v66;
                end;
            end;

            local v67 = {};
            local v68 = {};
            local v69 = {};

            for _, v in ipairs(EventsConfig.Currencies) do
                if v.Events then
                    for _, v2 in ipairs(v.Events) do
                        if v2 == v54 then
                            table.insert(v67, v.Key);

                            if (v.Rarity or 0) == 0 then
                                table.insert(v69, v.Key);
                            elseif v.Rarity == 1 then
                                table.insert(v68, v.Key);
                            end;
                        end;
                    end;
                end;
            end;

            local v70 = #v67 > 0;
            local v71 = #v68 > 0;
            local v72 = ClientState:Get();

            for _, v in ipairs(CollectionService:GetTagged("EventCurrencyFrame")) do
                v.Visible = v70;
            end;

            for _, v in ipairs(CollectionService:GetTagged("EventCurrency")) do
                local v73 = v:GetAttribute("CurrencyKey");

                if v73 then
                    v.Text = tostring(v72[v73] or 0);
                else
                    v.Text = tostring(v69[1] and (v72[v69[1]] or 0) or 0);
                end;
            end;

            for _, v in ipairs(CollectionService:GetTagged("EventCurrency2")) do
                v.Visible = v71;

                if v71 then
                    local v74 = v:GetAttribute("CurrencyKey");

                    if v74 then
                        v.Text = tostring(v72[v74] or 0);
                    else
                        v.Text = tostring(v68[1] and (v72[v68[1]] or 0) or 0);
                    end;
                end;
            end;

            local v75 = {};

            for _, v in ipairs(EventsConfig.Currencies) do
                if v.Icon and v.Icon ~= 0 then
                    v75[v.Key] = "rbxassetid://" .. v.Icon;
                end;
            end;

            for _, v in ipairs(CollectionService:GetTagged("EventCurrencyIcon")) do
                local v76 = v:GetAttribute("CurrencyKey");
                local v77;

                if v76 then
                    v77 = v75[v76];
                else
                    v77 = v69[1] and v75[v69[1]];
                end;

                if v77 then
                    v.Image = v77;
                end;
            end;

            for _, v in ipairs(CollectionService:GetTagged("EventCurrencyIcon2")) do
                v.Visible = v71;

                if v71 then
                    local v78 = v:GetAttribute("CurrencyKey");
                    local v79;

                    if v78 then
                        v79 = v75[v78];
                    else
                        v79 = v68[1] and v75[v68[1]];
                    end;

                    if v79 then
                        v.Image = v79;
                    end;
                end;
            end;

            task.wait(1);
        end;
    end);
end;

return v1;