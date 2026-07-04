-- Ruta Original: StarterPlayer.StarterPlayerScripts.AdminChatTagClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local TextChatService = game:GetService("TextChatService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GroupTags = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("GroupTags"));
local u1 = {
    Creator = {
        Color = "#ff0000",
        Prefix = "👑 [CREATOR]"
    },
    HeadManager = {
        Color = "#a855f7",
        Prefix = "[COO]"
    },
    Admin = {
        Color = "#1de5ff",
        Prefix = "[ADMIN]"
    },
    MarketingLead = {
        Color = "#ff8c00",
        Prefix = "[MARKETING LEAD]"
    },
    Scripter = {
        Color = "#3b82f6",
        Prefix = "[SCRIPTER]"
    },
    Builder = {
        Color = "#dd994b",
        Prefix = "[BUILDER]"
    },
    QAManager = {
        Color = "#ffa500",
        Prefix = "[QA MANAGER]"
    },
    AssistantBoard = {
        Color = "#ffffff",
        Prefix = "[ASSISTANT BOARD]"
    },
    Moderator = {
        Color = "#1de5ff",
        Prefix = "[ADMIN]"
    }
};

function TextChatService.OnIncomingMessage(p2) -- Line: 23
    -- upvalues: Players (copy), u1 (copy), GroupTags (copy)
    local TextChatMessageProperties = Instance.new("TextChatMessageProperties");
    local TextSource = p2.TextSource;

    if not TextSource then
        return TextChatMessageProperties;
    end;

    local v3 = Players:GetPlayerByUserId(TextSource.UserId);

    if not v3 then
        return TextChatMessageProperties;
    end;

    local v4 = {};
    local v5 = nil;

    if v3:GetAttribute("AdminChatTagEnabled") == true then
        local v6 = v3:GetAttribute("AdminRole") and u1[v6];

        if v6 then
            table.insert(v4, string.format("<font color=\'%s\'>%s</font>", v6.Color, v6.Prefix));
            v5 = v6.Color;
        end;
    end;

    local v7 = v3:GetAttribute("GroupTagKey");

    if v7 then
        local v8 = GroupTags[v7];

        if v8 and (v8.chatColor and v8.chatPrefix) then
            table.insert(v4, string.format("<font color=\'%s\'>%s</font>", v8.chatColor, v8.chatPrefix));
        end;
    end;

    if #v4 == 0 then
        return TextChatMessageProperties;
    end;

    local v9 = v5 and string.format("<font color=\'%s\'>%s</font>", v5, v3.Name) or v3.Name;
    TextChatMessageProperties.PrefixText = string.format("<b>%s %s</b>:", table.concat(v4, " "), v9);

    return TextChatMessageProperties;
end;