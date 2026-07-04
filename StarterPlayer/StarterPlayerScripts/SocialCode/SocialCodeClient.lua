-- Ruta Original: StarterPlayer.StarterPlayerScripts.SocialCode.SocialCodeClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = Color3.fromRGB(120, 220, 140);
local u2 = Color3.fromRGB(255, 120, 120);
local u3 = Color3.fromRGB(180, 180, 190);
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local SubmitDiscordVerifyCode = ReplicatedStorage:WaitForChild("SubmitDiscordVerifyCode");
local DiscordVerifyResult = ReplicatedStorage:WaitForChild("DiscordVerifyResult");
local SocialVerifyGui = PlayerGui:WaitForChild("SocialVerifyGui");
local Panel = SocialVerifyGui:FindFirstChild("Panel");

if Panel then
    if not Panel:IsA("ImageLabel") then
        Panel = SocialVerifyGui;
    end;
else
    Panel = SocialVerifyGui;
end;

local u4 = Panel:FindFirstChildWhichIsA("TextBox", true);

if not u4 then
    error("[DiscordVerify] TextBox \'CodeTextBox\' missing");
end;

local Status = Panel:FindFirstChild("Status");
local Submit = Panel:FindFirstChild("Submit");

if not (Status and (Status:IsA("TextLabel") and (Submit and Submit:IsA("TextButton")))) then
    error("[DiscordVerify] TextLabel \'Status\' or TextButton \'Submit\' missing");
end;

local u5 = false;

local function errorMessage(p6) -- Line: 42
    return p6 == "invalid_or_expired_code" and "INVALID OR EXPIRED CODE. ONLY USE CODES YOU GENERATED YOURSELF ON THE OFFICIAL DISCORD." or (p6 == "code_not_for_this_roblox_account" and "THIS CODE WAS GENERATED FOR A DIFFERENT ROBLOX ACCOUNT. THE DISCORD WHO GAVE IT TO YOU IS NOT THE OFFICIAL ONE — GENERATE YOUR OWN CODE ON THE REAL OFFICIAL DISCORD." or (p6 == "discord_already_linked" and "THE DISCORD ACCOUNT THAT GENERATED THIS CODE IS ALREADY LINKED TO ANOTHER ROBLOX. ASK STAFF TO UNLINK IT FIRST." or (p6 == "roblox_already_linked" and "THIS ROBLOX ACCOUNT IS ALREADY LINKED TO A DISCORD. IF IT IS NOT YOURS, OPEN A TICKET ON THE OFFICIAL DISCORD." or (p6 == "discord_not_in_guild" and "THIS DISCORD ACCOUNT IS NOT (OR NO LONGER) ON THE GAME SERVER. JOIN THE DISCORD AND THEN REQUEST A NEW CODE." or (p6 == "already_claimed" and "REWARD ALREADY CLAIMED ON THIS ACCOUNT." or (p6 == "roblox_account_reset_pending" and "THIS ACCOUNT IS BEING RESET BY AN ADMIN. REJOIN THE GAME IN A FEW MINUTES AND TRY AGAIN." or (p6 == "invalid_roblox_user_id" and "INVALID PLAYER ID. REJOIN AND TRY AGAIN OR CONTACT AN ADMIN." or (p6 == "unauthorized" and "SERVER ERROR (AUTH). CONTACT AN ADMIN." or ((p6 == "invalid_code" or p6 == "invalid_body") and "REQUEST REJECTED. TRY AGAIN." or (p6 == "network" and "NO RESPONSE FROM THE SERVER. TRY AGAIN LATER." or (p6 == "rate_limited" and "TOO MANY ATTEMPTS. WAIT BEFORE TRYING AGAIN." or (p6 == "bad_gateway" and "THE VERIFICATION API IS UNAVAILABLE (SERVER). TRY AGAIN LATER OR CONTACT AN ADMIN." or ((p6 == "invalid_response" or p6 == "internal") and "TECHNICAL ERROR. TRY AGAIN LATER." or "FAILURE: " .. p6)))))))))))));
end;

local function sanitizeCode(p7) -- Line: 75
    local v8 = string.upper(p7);

    return string.gsub(v8, "[^A-Z0-9]", "");
end;

local function setStatus(p9, p10) -- Line: 80
    -- upvalues: Status (copy)
    Status.Text = p9;
    Status.TextColor3 = p10;
end;

DiscordVerifyResult.OnClientEvent:Connect(function(p11, p12) -- Line: 85
    -- upvalues: u5 (ref), Submit (copy), u1 (copy), Status (copy), errorMessage (copy), u2 (copy)
    u5 = false;
    Submit.Active = true;

    if typeof(p11) ~= "boolean" then
        return;
    end;

    if p11 then
        Status.Text = "SUCCESSFULLY VERIFIED";
        Status.TextColor3 = u1;

        return;
    end;

    Status.Text = errorMessage(typeof(p12) ~= "string" and "" or p12);
    Status.TextColor3 = u2;
end);
u4:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 102
    -- upvalues: u4 (copy)
    local v13 = string.upper(u4.Text);
    local v14 = string.gsub(v13, "[^A-Z0-9]", "");
    local v15 = string.sub(v14, 1, 32);

    if u4.Text ~= v15 then
        u4.Text = v15;
    end;
end);

local function trySubmit() -- Line: 110
    -- upvalues: u5 (ref), u4 (copy), u2 (copy), Status (copy), Submit (copy), u3 (copy), SubmitDiscordVerifyCode (copy)
    if u5 then
        return;
    end;

    local v16 = string.upper(u4.Text);
    local v17 = string.gsub(v16, "[^A-Z0-9]", "");

    if #v17 < 4 or #v17 > 32 then
        Status.Text = "INVALID CODE LENGTH (MUST BE BETWEEN 4 AND 32 CHARACTERS).";
        Status.TextColor3 = u2;

        return;
    end;

    u5 = true;
    Submit.Active = false;
    Status.Text = "SENDING...";
    Status.TextColor3 = u3;
    SubmitDiscordVerifyCode:FireServer(v17);
end;

u4.FocusLost:Connect(function(p18) -- Line: 125
    -- upvalues: trySubmit (copy)
    if p18 then
        trySubmit();
    end;
end);
Submit.MouseButton1Click:Connect(trySubmit);