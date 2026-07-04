-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.GiftReceivedClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local GiftConfig = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("GiftConfig"));
local SoundManager = require(ReplicatedStorage:WaitForChild("SoundManager"));
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local Templates = ReplicatedStorage:WaitForChild("Templates");
local GiftReceivedFrame = Templates:WaitForChild("GiftReceivedFrame");
local GiftTemplate = Templates:WaitForChild("GiftTemplate");
local SpeedGameUI = PlayerGui:WaitForChild("SpeedGameUI");

local function getElementInFrame(p1, p2) -- Line: 25
    -- upvalues: CollectionService (copy)
    for _, descendant in ipairs(p1:GetDescendants()) do
        if CollectionService:HasTag(descendant, "GiftReceived") and descendant:GetAttribute("Type") == p2 then
            return descendant;
        end;
    end;

    return nil;
end;

local function buildGiftReceivedFrame(p3, u4, u5) -- Line: 38
    -- upvalues: GiftReceivedFrame (copy), SpeedGameUI (copy), getElementInFrame (copy), Players (copy), GiftTemplate (copy), GiftConfig (copy), Remotes (copy)
    local u6 = GiftReceivedFrame:Clone();
    u6.Parent = SpeedGameUI;
    local v7 = getElementInFrame(u6, "SenderName");

    if v7 then
        v7.Text = p3;
    end;

    local u8 = getElementInFrame(u6, "SenderImage");

    if u8 then
        task.spawn(function() -- Line: 51
            -- upvalues: Players (ref), u4 (copy), u8 (copy)
            local success, result = pcall(function() -- Line: 52
                -- upvalues: Players (ref), u4 (ref)
                return Players:GetUserThumbnailAsync(u4, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150);
            end);

            if success and result then
                u8.Image = result;
            end;
        end);
    end;

    local v9 = getElementInFrame(u6, "FrameAllGift");

    if v9 then
        for _, v in ipairs(u5) do
            local v10 = GiftTemplate:Clone();
            local v11 = getElementInFrame(v10, "GiftName");

            if v11 then
                v11.Text = v.GiftName or (v.Gift or "Gift");
            end;

            local v12 = getElementInFrame(v10, "GiftImage");
            local v13 = v12 and GiftConfig.ALL_GIFTS[v.Gift];

            if v13 then
                v12.Image = v13.Image;
            end;

            v10.Parent = v9;
        end;
    end;

    local v14 = getElementInFrame(u6, "Close");

    if v14 and v14:IsA("GuiButton") then
        v14.Activated:Connect(function() -- Line: 89
            -- upvalues: u5 (copy), Remotes (ref), u6 (copy)
            local u15 = {};

            for _, v in ipairs(u5) do
                if v.Timestamp then
                    table.insert(u15, v.Timestamp);
                end;
            end;

            local GiftAction = Remotes:FindFirstChild("GiftAction");

            if GiftAction and #u15 > 0 then
                task.spawn(function() -- Line: 101
                    -- upvalues: GiftAction (copy), u15 (copy)
                    pcall(function() -- Line: 102
                        -- upvalues: GiftAction (ref), u15 (ref)
                        GiftAction:InvokeServer("ClaimGifts", {
                            Timestamps = u15
                        });
                    end);
                end);
            end;

            u6:Destroy();
        end);
    end;

    return u6;
end;

task.delay(3, function() -- Line: 120, Name: showUnclaimedGifts
    -- upvalues: Remotes (copy), buildGiftReceivedFrame (copy), SoundManager (copy)
    local GiftAction = Remotes:WaitForChild("GiftAction", 15);

    if not GiftAction then
        return;
    end;

    local success, result = pcall(function() -- Line: 125
        -- upvalues: GiftAction (copy)
        return GiftAction:InvokeServer("GetUnclaimedGifts", {});
    end);

    if not (success and (result and result.Success)) then
        return;
    end;

    local Gifts = result.Gifts;

    if not Gifts or #Gifts == 0 then
        return;
    end;

    local v16 = {};
    local v17 = {};

    for _, v in ipairs(Gifts) do
        local SenderUserId = v.SenderUserId;

        if SenderUserId then
            if not v16[SenderUserId] then
                v16[SenderUserId] = {
                    senderName = v.SenderName or "Unknown",
                    senderUserId = SenderUserId,
                    gifts = {}
                };
                table.insert(v17, SenderUserId);
            end;

            table.insert(v16[SenderUserId].gifts, v);
        end;
    end;

    for _, v in ipairs(v17) do
        local v18 = v16[v];
        buildGiftReceivedFrame(v18.senderName, v18.senderUserId, v18.gifts);
    end;

    if #v17 > 0 then
        SoundManager:Play("SUCCESS");
    end;
end);
local GiftReceivedNotify = Remotes:WaitForChild("GiftReceivedNotify", 15);

if GiftReceivedNotify then
    GiftReceivedNotify.OnClientEvent:Connect(function(p19) -- Line: 174
        -- upvalues: buildGiftReceivedFrame (copy), SoundManager (copy)
        if not p19 or typeof(p19) ~= "table" then
            return;
        end;

        buildGiftReceivedFrame(p19.SenderName or "Unknown", p19.SenderUserId, { p19 });
        SoundManager:Play("SUCCESS");
    end);
end;