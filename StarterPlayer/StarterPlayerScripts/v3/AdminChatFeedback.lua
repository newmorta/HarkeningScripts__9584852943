-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.AdminChatFeedback
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TextChatService = game:GetService("TextChatService");
ReplicatedStorage:WaitForChild("AdminFeedback").OnClientEvent:Connect(function(p1, p2) -- Line: 7
    -- upvalues: TextChatService (copy)
    local RBXGeneral = TextChatService:FindFirstChild("RBXGeneral", true);

    if RBXGeneral then
        RBXGeneral:DisplaySystemMessage("<font color=\'" .. p2 .. "\'><b>[SYSTEM]</b> " .. p1 .. "</font>");
    end;
end);