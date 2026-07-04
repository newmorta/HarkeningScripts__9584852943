-- Ruta Original: StarterPlayer.StarterPlayerScripts.AdminAnnounceClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local AdminAnnounce = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("AdminAnnounce");
local NotificationFrame = ReplicatedStorage:WaitForChild("NotificationFrame");
local u1 = {
    Creator = {
        Color = "#ff0000",
        Prefix = "[CREATOR]"
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

local function getGradients(p2) -- Line: 46
    local v3 = {};

    for _, descendant in ipairs(p2:GetDescendants()) do
        if descendant:IsA("UIGradient") then
            table.insert(v3, {
                obj = descendant,
                original = descendant.Transparency
            });
        end;
    end;

    return v3;
end;

local function getAllVisuals(p4) -- Line: 56
    local v5 = {};

    for _, descendant in ipairs(p4:GetDescendants()) do
        if descendant:IsA("UIStroke") then
            table.insert(v5, {
                prop = "Transparency",
                obj = descendant
            });
        elseif descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            table.insert(v5, {
                prop = "TextTransparency",
                obj = descendant
            });

            if descendant.BackgroundTransparency < 1 then
                table.insert(v5, {
                    prop = "BackgroundTransparency",
                    obj = descendant
                });
            end;
        elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
            table.insert(v5, {
                prop = "ImageTransparency",
                obj = descendant
            });

            if descendant.BackgroundTransparency < 1 then
                table.insert(v5, {
                    prop = "BackgroundTransparency",
                    obj = descendant
                });
            end;
        elseif descendant:IsA("Frame") and descendant.BackgroundTransparency < 1 then
            table.insert(v5, {
                prop = "BackgroundTransparency",
                obj = descendant
            });
        end;
    end;

    if p4:IsA("Frame") and p4.BackgroundTransparency < 1 then
        table.insert(v5, {
            prop = "BackgroundTransparency",
            obj = p4
        });
    end;

    return v5;
end;

local function showAnnouncement(p6, p7, u8, p9, p10) -- Line: 85
    -- upvalues: PlayerGui (copy), NotificationFrame (copy), Players (copy), u1 (copy), getAllVisuals (copy), getGradients (copy), Debris (copy), TweenService (copy)
    local v11 = PlayerGui:FindFirstChild("AdminAnnounce") and v11:FindFirstChild("MainFrame");

    if not v11 then
        warn("[AdminAnnounce] AdminAnnounce/MainFrame introuvable dans PlayerGui");

        return;
    end;

    local u12 = NotificationFrame:Clone();
    u12.ZIndex = 100;
    local Avatar = u12:FindFirstChild("Avatar");

    if Avatar and Avatar:IsA("ImageLabel") then
        Avatar.ZIndex = 101;

        if u8 then
            local success, result = pcall(function() -- Line: 101
                -- upvalues: Players (ref), u8 (copy)
                return Players:GetUserThumbnailAsync(u8, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100);
            end);

            if success and result then
                Avatar.Image = result;
            end;
        end;
    end;

    local Text = u12:FindFirstChild("Text");

    if Text then
        Text.ZIndex = 101;
        Text.RichText = true;
        local v13 = p7 or "Admin";

        if p9 then
            v13 = v13 .. "" or v13;
        end;

        if p10 then
            p10 = u1[p10];
        end;

        if p10 then
            Text.Text = string.format("<font color=\"%s\">%s</font> <font color=\"rgb(85,170,255)\"><b>%s</b></font> : %s", p10.Color, p10.Prefix, v13, p6);
        else
            Text.Text = "<font color=\"rgb(85,170,255)\"><b>" .. v13 .. "</b></font> : " .. p6;
        end;
    end;

    local u14 = getAllVisuals(u12);
    local u15 = getGradients(u12);
    local v16 = {};

    for i, v in ipairs(u14) do
        v16[i] = v.obj[v.prop];
        v.obj[v.prop] = 1;
    end;

    local u17 = NumberSequence.new(1);

    for _, v in ipairs(u15) do
        v.obj.Transparency = u17;
    end;

    u12.Parent = v11;
    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://98797174600699";
    Sound.Volume = 0.4;
    Sound.Parent = PlayerGui;
    Sound:Play();
    Debris:AddItem(Sound, 5);
    local v18 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

    for i, v in ipairs(u14) do
        TweenService:Create(v.obj, v18, {
            [v.prop] = v16[i]
        }):Play();
    end;

    for _, v in ipairs(u15) do
        v.obj.Transparency = v.original;
    end;

    task.delay(10, function() -- Line: 169
        -- upvalues: u14 (copy), TweenService (ref), u15 (copy), u17 (copy), u12 (copy)
        local v19 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

        for _, v in ipairs(u14) do
            TweenService:Create(v.obj, v19, {
                [v.prop] = 1
            }):Play();
        end;

        for _, v in ipairs(u15) do
            v.obj.Transparency = u17;
        end;

        task.delay(0.5, function() -- Line: 177
            -- upvalues: u12 (ref)
            if u12 and u12.Parent then
                u12:Destroy();
            end;
        end);
    end);
end;

AdminAnnounce.OnClientEvent:Connect(function(p20) -- Line: 187
    -- upvalues: showAnnouncement (copy)
    if type(p20) ~= "table" or not p20.text then
        return;
    end;

    showAnnouncement(p20.text, p20.senderName, p20.senderUserId, p20.isOwner, p20.adminRole);
end);