-- Ruta Original: ReplicatedStorage.RebirthUISystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
game:GetService("RunService");
local Players = game:GetService("Players");
local MarketplaceService = game:GetService("MarketplaceService");
local Config = require(ReplicatedStorage:WaitForChild("Config"));
local SoundManager = require(ReplicatedStorage:WaitForChild("SoundManager"));
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local Rebirth = Remotes:WaitForChild("Rebirth");
local UpdateUI = Remotes:WaitForChild("UpdateUI");
local u1 = { { 1e63, "Vg" }, { 1e60, "Nd" }, { 1e57, "Od" }, { 1e54, "Spd" }, { 1e51, "Sxd" }, { 1e48, "Qid" }, { 1e45, "Qad" }, { 1e42, "Td" }, { 1e39, "Dd" }, { 1e36, "Ud" }, { 1e33, "Dc" }, { 1e30, "No" }, { 1e27, "Oc" }, { 1e24, "Sp" }, { 1e21, "Sx" }, { 1e18, "Qi" }, { 1000000000000000, "Qa" }, { 1000000000000, "T" }, { 1000000000, "B" }, { 1000000, "M" }, { 1000, "K" } };

local function formatNumber(p2) -- Line: 25
    -- upvalues: u1 (copy)
    local v3 = tonumber(p2) or 0;

    for _, v in ipairs(u1) do
        local v4 = v[1];
        local v5 = v[2];

        if v4 <= v3 then
            return string.format("%.2f", v3 / v4):gsub("%.?0+$", "") .. v5;
        end;
    end;

    local v6 = math.floor(v3);

    return tostring(v6);
end;

local function formatMultiplier(p7) -- Line: 36
    -- upvalues: u1 (copy)
    local v8 = tonumber(p7) or 1;

    for _, v in ipairs(u1) do
        local v9 = v[1];
        local v10 = v[2];

        if v9 <= v8 then
            return string.format("%.2f", v8 / v9):gsub("%.?0+$", "") .. v10;
        end;
    end;

    if v8 ~= math.floor(v8) then
        return string.format("%.2f", v8):gsub("0+$", ""):gsub("%.$", "");
    end;

    local v11 = math.floor(v8);

    return tostring(v11);
end;

local v12 = {};
local u13 = false;
local u14 = nil;
local u15 = false;
local u16 = {
    modal = nil,
    closeBtn = nil,
    rebirthBtn = nil,
    currentMultText = nil,
    nextMultText = nil,
    reqLevelText = nil,
    progressFill = nil,
    progressText = nil,
    rebirthDevBtn = nil,
    RebirthFrame = nil
};

local function findElements() -- Line: 65
    -- upvalues: Players (copy), CollectionService (copy), u16 (copy)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");

    local function getOne(p17) -- Line: 67
        -- upvalues: CollectionService (ref), PlayerGui (copy)
        local v18 = CollectionService:GetTagged(p17);

        for _, v in ipairs(v18) do
            if v:IsDescendantOf(PlayerGui) then
                return v;
            end;
        end;

        return nil;
    end;

    u16.modal = getOne("RebirthModal");
    u16.closeBtn = getOne("RebirthCloseBtn");
    u16.rebirthBtn = getOne("RebirthConfirmBtn");
    u16.currentMultText = getOne("RebirthCurrentMultText");
    u16.nextMultText = getOne("RebirthNextMultText");
    u16.reqLevelText = getOne("RebirthReqLevelText");
    u16.progressFill = getOne("RebirthBarFill");
    u16.progressText = getOne("RebirthBarText");
    u16.rebirthframe = getOne("RebirthFrame");
    u16.rebirthDevBtn = getOne("RebirthDevProduct");
end;

function v12.UpdateDisplay(p19) -- Line: 91
    -- upvalues: u16 (copy), findElements (copy), ClientState (copy), Config (copy), formatMultiplier (copy), u15 (ref)
    if not u16.modal then
        findElements();
    end;

    if not u16.modal then
        return;
    end;

    local v20 = ClientState:Get();
    local REBIRTH_TIERS = Config.REBIRTH_TIERS;
    local v21 = (v20.Rebirths or 0) + 1;
    local v22 = v20.Multiplier or 1;

    if #REBIRTH_TIERS < v21 then
        if u16.currentMultText then
            u16.currentMultText.Text = "x" .. formatMultiplier(v22) .. " Speed";
        end;

        if u16.nextMultText and u16.nextMultText.Text ~= "MAX!" then
            u16.nextMultText.Text = "MAX!";

            if u16.progressFill then
                u16.progressFill.Size = UDim2.new(1, 0, 1, 0);
            end;

            if u16.rebirthBtn then
                u16.rebirthBtn.Text = "MAX";
                u16.rebirthBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0);

                if u16.rebirthframe then
                    u16.rebirthframe.BackgroundColor3 = Color3.fromRGB(255, 215, 0);
                end;
            end;
        end;

        if u16.rebirthDevBtn then
            u16.rebirthDevBtn.Visible = false;
        end;

        return;
    end;

    if u16.rebirthDevBtn then
        u16.rebirthDevBtn.Visible = true;
    end;

    local v23 = REBIRTH_TIERS[v21];
    local level = v23.level;
    local multiplier = v23.multiplier;

    if u16.currentMultText then
        u16.currentMultText.Text = "x" .. formatMultiplier(v22) .. " Speed";
    end;

    if u16.nextMultText then
        u16.nextMultText.Text = "x" .. formatMultiplier(multiplier) .. " Speed";
    end;

    if u16.reqLevelText then
        u16.reqLevelText.Text = "Level " .. level;
    end;

    local v24 = math.clamp(v20.Level / level, 0, 1);

    if u16.progressFill then
        u16.progressFill.Size = UDim2.new(v24, 0, 1, 0);
    end;

    if u16.progressText then
        u16.progressText.Text = "Level " .. v20.Level .. " / " .. level;
    end;

    if u16.rebirthBtn then
        if level <= v20.Level then
            u16.rebirthBtn.Text = u15 and "WAIT..." or "Rebirth!";
            u16.rebirthBtn.BackgroundColor3 = Color3.fromRGB(200, 18, 21);
            u16.rebirthframe.BackgroundColor3 = Color3.fromRGB(200, 18, 21);

            return;
        end;

        u16.rebirthBtn.Text = "Need level " .. level;
        u16.rebirthBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
        u16.rebirthframe.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
    end;
end;

local function initialize() -- Line: 157
    -- upvalues: u13 (ref), u16 (copy), findElements (copy), ClientState (copy), Config (copy), MarketplaceService (copy), Players (copy), SoundManager (copy), u15 (ref), Rebirth (copy)
    if u13 then
        return;
    end;

    if not u16.modal then
        findElements();
    end;

    if u16.closeBtn then
        u16.closeBtn.MouseButton1Click:Connect(function() -- Line: 162
            -- upvalues: ClientState (ref)
            ClientState:CloseCurrentModal();
        end);
    end;

    if u16.rebirthDevBtn then
        u16.rebirthDevBtn.MouseButton1Click:Connect(function() -- Line: 168
            -- upvalues: ClientState (ref), Config (ref), MarketplaceService (ref), Players (ref)
            local v25 = ClientState:Get().Rebirths or 0;

            if #Config.REBIRTH_TIERS <= v25 then
                return;
            end;

            local v26 = Config.GetRebirthProductId(v25);
            MarketplaceService:PromptProductPurchase(Players.LocalPlayer, v26);
        end);
    end;

    local u27 = {
        [Config.DEV_PRODUCTS.INSTANT_REBIRTH_T1] = true,
        [Config.DEV_PRODUCTS.INSTANT_REBIRTH_T2] = true,
        [Config.DEV_PRODUCTS.INSTANT_REBIRTH_T3] = true,
        [Config.DEV_PRODUCTS.INSTANT_REBIRTH_T4] = true
    };
    MarketplaceService.PromptProductPurchaseFinished:Connect(function(p28, p29, p30) -- Line: 185
        -- upvalues: u27 (copy), SoundManager (ref), ClientState (ref)
        if p30 and u27[p29] then
            SoundManager:Play("BUY");
            ClientState:CloseCurrentModal();
        end;
    end);

    if u16.rebirthBtn then
        u16.rebirthBtn.MouseButton1Click:Connect(function() -- Line: 193
            -- upvalues: u15 (ref), ClientState (ref), Config (ref), Rebirth (ref)
            if u15 then
                return;
            end;

            local v31 = ClientState:Get();
            local v32 = Config.REBIRTH_TIERS[v31.Rebirths + 1];

            if v32 and v31.Level >= v32.level then
                u15 = true;
                Rebirth:FireServer();
                task.wait(0.2);
                ClientState:CloseCurrentModal();
                u15 = false;
            end;
        end);
    end;

    u13 = true;
end;

function v12.OnClose(p33) -- Line: 216
    -- upvalues: u14 (ref), u15 (ref)
    if u14 then
        u14:Disconnect();
        u14 = nil;
    end;

    u15 = false;
end;

function v12.InitLogic(u34) -- Line: 228
    -- upvalues: u16 (copy), findElements (copy), initialize (copy), u14 (ref), UpdateUI (copy)
    if not u16.modal then
        findElements();
    end;

    initialize();
    u34:UpdateDisplay();

    if not u14 then
        u14 = UpdateUI.OnClientEvent:Connect(function(p35) -- Line: 234
            -- upvalues: u34 (copy)
            if p35.Level or (p35.Rebirths or p35.Multiplier) then
                u34:UpdateDisplay();
            end;
        end);
    end;
end;

return v12;