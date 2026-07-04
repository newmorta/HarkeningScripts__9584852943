-- Ruta Original: StarterPlayer.StarterPlayerScripts.TagsCmds
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local TextChatService = game:GetService("TextChatService");
local AdminTagToggle = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("AdminTagToggle", 10);

local function makeCmd(p1, p2, u3) -- Line: 11
    -- upvalues: TextChatService (copy), AdminTagToggle (copy)
    local TextChatCommand = Instance.new("TextChatCommand");
    TextChatCommand.Name = p1;
    TextChatCommand.PrimaryAlias = p2;
    TextChatCommand.AutocompleteVisible = false;
    TextChatCommand.Enabled = true;
    TextChatCommand.Parent = TextChatService;
    TextChatCommand.Triggered:Connect(function() -- Line: 18
        -- upvalues: AdminTagToggle (ref), u3 (copy)
        if AdminTagToggle then
            AdminTagToggle:FireServer(u3);
        end;
    end);
end;

local TextChatCommand = Instance.new("TextChatCommand");
TextChatCommand.Name = "HeadTagCommand";
TextChatCommand.PrimaryAlias = "/headtag";
TextChatCommand.AutocompleteVisible = false;
TextChatCommand.Enabled = true;
TextChatCommand.Parent = TextChatService;
local u4 = "Head";
TextChatCommand.Triggered:Connect(function() -- Line: 18
    -- upvalues: AdminTagToggle (copy), u4 (copy)
    if AdminTagToggle then
        AdminTagToggle:FireServer(u4);
    end;
end);
local TextChatCommand2 = Instance.new("TextChatCommand");
TextChatCommand2.Name = "ChatTagCommand";
TextChatCommand2.PrimaryAlias = "/chattag";
TextChatCommand2.AutocompleteVisible = false;
TextChatCommand2.Enabled = true;
TextChatCommand2.Parent = TextChatService;
local u5 = "Chat";
TextChatCommand2.Triggered:Connect(function() -- Line: 18
    -- upvalues: AdminTagToggle (copy), u5 (copy)
    if AdminTagToggle then
        AdminTagToggle:FireServer(u5);
    end;
end);