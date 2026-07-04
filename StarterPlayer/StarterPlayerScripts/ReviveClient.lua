-- Ruta Original: StarterPlayer.StarterPlayerScripts.ReviveClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local MarketplaceService = game:GetService("MarketplaceService");
local SoundService = game:GetService("SoundService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
local Config = require(ReplicatedStorage:WaitForChild("Config"));
local Ads = require(ReplicatedStorage:WaitForChild("Monetization"):WaitForChild("Ads"));
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local RevivePrompt = Remotes:WaitForChild("RevivePrompt");
local RequestRevive = Remotes:WaitForChild("RequestRevive");
local RequestAdRevive = Remotes:WaitForChild("RequestAdRevive");
local ReviveSuccess = Remotes:WaitForChild("ReviveSuccess");
local REVIVE = Config.DEV_PRODUCTS.REVIVE;

local function getTaggedInGui(p1) -- Line: 28
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged(p1)) do
        if v:IsDescendantOf(PlayerGui) then
            return v;
        end;
    end;

    return nil;
end;

local function hideFrame() -- Line: 35
    -- upvalues: getTaggedInGui (copy)
    local v2 = getTaggedInGui("ReviveFrame");

    if v2 and v2:IsA("GuiObject") then
        v2.Visible = false;
    end;
end;

local u3 = false;
local u4 = {};
local u5 = false;

local function maximizeZIndex(p6) -- Line: 50
    -- upvalues: u5 (ref)
    if u5 then
        return;
    end;

    u5 = true;
    p6.ZIndex = p6.ZIndex + 99999;

    for _, descendant in ipairs(p6:GetDescendants()) do
        if descendant:IsA("GuiObject") then
            descendant.ZIndex = descendant.ZIndex + 99999;
        end;
    end;

    local v7 = p6:FindFirstAncestorOfClass("ScreenGui");

    if v7 then
        v7.DisplayOrder = 99999;
    end;
end;

local function disconnectButtons() -- Line: 67
    -- upvalues: u4 (copy)
    for _, v in u4 do
        if v.Connected then
            v:Disconnect();
        end;
    end;
end;

RevivePrompt.OnClientEvent:Connect(function(p8) -- Line: 73
    -- upvalues: u3 (ref), getTaggedInGui (copy), maximizeZIndex (copy), RequestRevive (copy), u4 (copy), Ads (copy), RequestAdRevive (copy)
    if u3 then
        return;
    end;

    u3 = true;
    local v9 = getTaggedInGui("ReviveFrame");

    if not (v9 and v9:IsA("GuiObject")) then
        u3 = false;

        return;
    end;

    maximizeZIndex(v9);
    local v10 = getTaggedInGui("ReviveText");

    if v10 and v10:IsA("TextLabel") then
        v10.Text = "Revive to level " .. tostring(p8) .. " ?";
    end;

    v9.Visible = true;
    local u11 = false;
    local v12 = getTaggedInGui("ReviveButton");

    if v12 and v12:IsA("GuiButton") then
        local v13 = v12.MouseButton1Click:Connect(function() -- Line: 95
            -- upvalues: u11 (ref), RequestRevive (ref)
            if u11 then
                return;
            end;

            u11 = true;
            RequestRevive:FireServer();
        end);
        table.insert(u4, v13);
    end;

    local v14 = getTaggedInGui("AdReviveButton");

    if v14 and v14:IsA("GuiButton") then
        v14.Visible = false;

        if Ads.checkForAds() then
            v14.Visible = true;
            local v15 = v14.MouseButton1Click:Connect(function() -- Line: 114
                -- upvalues: u11 (ref), RequestAdRevive (ref)
                if u11 then
                    return;
                end;

                u11 = true;
                RequestAdRevive:FireServer();
            end);
            table.insert(u4, v15);
        else
            v14.Visible = false;
        end;
    end;

    task.delay(5, function() -- Line: 127
        -- upvalues: u4 (ref), getTaggedInGui (ref), u3 (ref)
        for _, v in u4 do
            if v.Connected then
                v:Disconnect();
            end;
        end;

        table.clear(u4);
        local v16 = getTaggedInGui("ReviveFrame");

        if v16 and v16:IsA("GuiObject") then
            v16.Visible = false;
        end;

        u3 = false;
    end);
end);
MarketplaceService.PromptProductPurchaseFinished:Connect(function(p17, p18, p19) -- Line: 141
    -- upvalues: LocalPlayer (copy), REVIVE (copy), getTaggedInGui (copy), u3 (ref)
    if p17 ~= LocalPlayer.UserId then
        return;
    end;

    if p18 ~= REVIVE then
        return;
    end;

    if not p19 then
        local v20 = getTaggedInGui("ReviveFrame");

        if v20 and v20:IsA("GuiObject") then
            v20.Visible = false;
        end;

        u3 = false;
    end;
end);
ReviveSuccess.OnClientEvent:Connect(function() -- Line: 154
    -- upvalues: u4 (copy), getTaggedInGui (copy), u3 (ref), Config (copy), SoundService (copy), Debris (copy)
    for _, v in u4 do
        if v.Connected then
            v:Disconnect();
        end;
    end;

    local v21 = getTaggedInGui("ReviveFrame");

    if v21 and v21:IsA("GuiObject") then
        v21.Visible = false;
    end;

    u3 = false;
    local BUY = Config.SOUNDS.BUY;
    local Sound = Instance.new("Sound");
    Sound.SoundId = BUY.ID;
    Sound.Volume = BUY.Volume;
    Sound.Parent = SoundService;
    Sound:Play();
    Debris:AddItem(Sound, 5);
end);