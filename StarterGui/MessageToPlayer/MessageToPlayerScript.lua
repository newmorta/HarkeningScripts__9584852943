-- Ruta Original: StarterGui.MessageToPlayer.MessageToPlayerScript
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local _ = Players.LocalPlayer;
local Parent = script.Parent;
local GetMessageToPlayer = ReplicatedStorage:WaitForChild("GetMessageToPlayer");
local PushMessageToPlayer = ReplicatedStorage:WaitForChild("PushMessageToPlayer");
local ClearMessageToPlayer = ReplicatedStorage:WaitForChild("ClearMessageToPlayer");
local ReplyMessageToAdmin = ReplicatedStorage:WaitForChild("ReplyMessageToAdmin");
local MainFrame = Parent:WaitForChild("MainFrame");
local TextLabel = MainFrame:WaitForChild("Frame"):WaitForChild("ListFrame"):WaitForChild("TextFrame"):WaitForChild("TextLabel");
local Frame = MainFrame:WaitForChild("FrameRepondre"):WaitForChild("Frame"):WaitForChild("Frame");
local TextBox = Frame:WaitForChild("TextBox");
local SendButton = Frame:WaitForChild("SendButton");
Parent.Enabled = false;
MainFrame.Visible = false;

local function showMessage(p1) -- Line: 30
    -- upvalues: TextLabel (copy), TextBox (copy), Parent (copy), MainFrame (copy)
    if typeof(p1) ~= "string" or p1 == "" then
        return;
    end;

    TextLabel.Text = p1;
    TextBox.Text = "";
    Parent.Enabled = true;
    MainFrame.Visible = true;
end;

local function closeAndClear() -- Line: 39
    -- upvalues: ClearMessageToPlayer (copy), Parent (copy)
    ClearMessageToPlayer:FireServer();
    Parent.Enabled = false;
end;

local u2 = false;
SendButton.MouseButton1Click:Connect(function() -- Line: 51
    -- upvalues: u2 (ref), TextBox (copy), SendButton (copy), ReplyMessageToAdmin (copy), ClearMessageToPlayer (copy), Parent (copy)
    if u2 then
        return;
    end;

    local Text = TextBox.Text;

    if Text:gsub(" ", "") == "" then
        TextBox.PlaceholderText = "Écrivez un message...";

        return;
    end;

    u2 = true;
    SendButton.Text = "Envoi...";
    ReplyMessageToAdmin:FireServer(Text);
    task.wait(0.5);
    ClearMessageToPlayer:FireServer();
    Parent.Enabled = false;
    SendButton.Text = "Send";
    TextBox.Text = "";
    u2 = false;
end);
task.wait(5);
local success, result = pcall(function() -- Line: 85
    -- upvalues: GetMessageToPlayer (copy)
    return GetMessageToPlayer:InvokeServer();
end);

if success and (type(result) == "string" and (result ~= "" and (typeof(result) == "string" and result ~= ""))) then
    TextLabel.Text = result;
    TextBox.Text = "";
    Parent.Enabled = true;
    MainFrame.Visible = true;
end;

PushMessageToPlayer.OnClientEvent:Connect(function(p3) -- Line: 93
    -- upvalues: TextLabel (copy), TextBox (copy), Parent (copy), MainFrame (copy)
    if typeof(p3) == "string" then
        if p3 == "" then
            return;
        end;

        TextLabel.Text = p3;
        TextBox.Text = "";
        Parent.Enabled = true;
        MainFrame.Visible = true;
    end;
end);