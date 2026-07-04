-- Ruta Original: ReplicatedStorage.UISystems.FriendBoostUISystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local SocialService = game:GetService("SocialService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Icon = require(ReplicatedStorage.TopbarPlus.Icon);
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local FriendBoost = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("FriendBoost"));
local v1 = {};
local u2 = false;
local u3 = false;
local LocalPlayer = Players.LocalPlayer;
local u4 = Icon.new();
u4:setLabel("Invite");
u4.selected:Connect(function() -- Line: 21
    -- upvalues: u4 (copy), SocialService (copy), LocalPlayer (copy)
    u4:deselect();
    local success, result = pcall(function() -- Line: 23
        -- upvalues: SocialService (ref), LocalPlayer (ref)
        SocialService:PromptGameInvite(LocalPlayer);
    end);

    if not success then
        warn("FriendInviteIcon: PromptGameInvite failed —", result);
    end;
end);
local PERCENT_PER_FRIEND = FriendBoost.PERCENT_PER_FRIEND;
local MAX_BOOST_PERCENT = FriendBoost.MAX_BOOST_PERCENT;

local function countFriendsInServer() -- Line: 38
    -- upvalues: Players (copy), LocalPlayer (copy), FriendBoost (copy)
    local v5 = 0;

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            local success, result = pcall(LocalPlayer.IsFriendsWithAsync, LocalPlayer, v.UserId);

            if success and result then
                v5 = v5 + 1;

                if FriendBoost.MAX_FRIENDS <= v5 then
                    break;
                end;
            end;
        end;
    end;

    return v5;
end;

local function updateLabel(p6, p7) -- Line: 52
    -- upvalues: MAX_BOOST_PERCENT (copy)
    p6.RichText = true;

    if not p7 or p7 <= 0 then
        p6.Visible = false;

        return;
    end;

    if MAX_BOOST_PERCENT <= p7 then
        p6.Text = string.format("<font color=\"#FFD700\">⚡ MAX FRIEND BOOST</font> <font color=\"#00FF00\">+%d%%</font>", p7);
    else
        p6.Text = string.format("<font color=\"#00FF00\">Multiplier</font> +%d%% <font color=\"#00FF00\">(Friends)</font>", p7);
    end;

    p6.Visible = true;
end;

function v1.RefreshFriendCount(p8) -- Line: 70
    -- upvalues: u3 (ref), countFriendsInServer (copy), FriendBoost (copy), PERCENT_PER_FRIEND (copy), MAX_BOOST_PERCENT (copy), ClientState (copy)
    if u3 then
        return;
    end;

    local v9 = countFriendsInServer();
    local v10 = math.min(v9, FriendBoost.MAX_FRIENDS) * PERCENT_PER_FRIEND;
    ClientState:Update({
        FriendBoostPercent = math.min(v10, MAX_BOOST_PERCENT)
    });
    p8:UpdateDisplay();
end;

function v1.ApplyOverride(p11, p12) -- Line: 78
    -- upvalues: u3 (ref), MAX_BOOST_PERCENT (copy), ClientState (copy)
    u3 = MAX_BOOST_PERCENT <= p12;
    ClientState:Update({
        FriendBoostPercent = p12
    });
    p11:UpdateDisplay();
end;

function v1.UpdateDisplay(p13) -- Line: 84
    -- upvalues: ClientState (copy), CollectionService (copy), MAX_BOOST_PERCENT (copy)
    local v14 = ClientState:Get().FriendBoostPercent or 0;

    for _, v in ipairs(CollectionService:GetTagged("FriendBoostTextLabel")) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            v.RichText = true;

            if v14 and v14 > 0 then
                if MAX_BOOST_PERCENT <= v14 then
                    v.Text = string.format("<font color=\"#FFD700\">⚡ MAX FRIEND BOOST</font> <font color=\"#00FF00\">+%d%%</font>", v14);
                else
                    v.Text = string.format("<font color=\"#00FF00\">Multiplier</font> +%d%% <font color=\"#00FF00\">(Friends)</font>", v14);
                end;

                v.Visible = true;
            else
                v.Visible = false;
            end;
        end;
    end;
end;

function v1.InitLogic(p15) -- Line: 95
    -- upvalues: u2 (ref)
    if u2 then
        return;
    end;

    u2 = true;
    p15:UpdateDisplay();
end;

function v1.OnClose(p16) -- Line: 102
end;

return v1;