-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.PurchaseAnnouncer
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TextChatService = game:GetService("TextChatService");

local function getGeneralChannel() -- Line: 8
    -- upvalues: TextChatService (copy)
    local TextChannels = TextChatService:FindFirstChild("TextChannels");

    if TextChannels then
        return TextChannels:FindFirstChild("RBXGeneral");
    end;

    return nil;
end;

ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PurchaseAnnounce").OnClientEvent:Connect(function(p1) -- Line: 16
    -- upvalues: TextChatService (copy)
    local TextChannels = TextChatService:FindFirstChild("TextChannels");
    local v2;

    if TextChannels then
        v2 = TextChannels:FindFirstChild("RBXGeneral");
    else
        v2 = nil;
    end;

    if v2 then
        v2:DisplaySystemMessage("<font size=\"17\"><b>" .. p1 .. "</b></font>");
    end;
end);