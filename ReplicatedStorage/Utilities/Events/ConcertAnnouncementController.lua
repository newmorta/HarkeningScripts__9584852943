-- Ruta Original: ReplicatedStorage.Utilities.Events.ConcertAnnouncementController
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = {};
u1.__index = u1;
local u2 = {};

function u1.new() -- Line: 17
    -- upvalues: u1 (copy), ReplicatedStorage (copy)
    local u3 = setmetatable({}, u1);
    u3._activeNotifications = {};
    task.spawn(function() -- Line: 20
        -- upvalues: u3 (copy), ReplicatedStorage (ref)
        u3._notifTemplate = ReplicatedStorage:WaitForChild("NotificationFrame", 5);
    end);

    return u3;
end;

function u1.showText(p4, p5) -- Line: 26
    p4:_showAnnouncement("X3ll3n", p5, "rgb(85,170,255)", nil, 32468810);
end;

function u1.showFlyText(p6, p7) -- Line: 30
    p6:_showAnnouncement("Fly", p7, "rgb(85,170,255)", "rbxassetid://1566392131");
end;

function u1.showLuckyText(p8, p9) -- Line: 34
    p8:_showAnnouncement("LuckyMatg", p9, "rgb(85,170,255)", nil, 175193570);
end;

function u1.showLokiText(p10, p11) -- Line: 38
    p10:_showAnnouncement("Secret_Lokii", p11, "rgb(85,170,255)", nil, 3845375404);
end;

function u1._showAnnouncement(u12, p13, p14, p15, p16, p17) -- Line: 42
    -- upvalues: Players (copy), ReplicatedStorage (copy), u2 (copy), TweenService (copy)
    if not p14 or p14 == "" then
        return;
    end;

    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return;
    end;

    local v18 = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 2);

    if not v18 then
        return;
    end;

    local _notifTemplate = u12._notifTemplate;

    if not _notifTemplate then
        _notifTemplate = ReplicatedStorage:FindFirstChild("NotificationFrame");

        if _notifTemplate then
            u12._notifTemplate = _notifTemplate;
        end;
    end;

    if not _notifTemplate then
        warn("[ConcertAnnouncementController] showFakeAnnouncement: NotificationFrame template missing");

        return;
    end;

    local u19 = _notifTemplate:Clone();
    u19.ZIndex = 100;
    local Avatar = u19:FindFirstChild("Avatar");

    if Avatar and Avatar:IsA("ImageLabel") then
        Avatar.ZIndex = 101;

        if p16 then
            Avatar.Image = p16;
        else
            local u20 = p17 or 32468810;
            local v21 = u2[u20];

            if v21 then
                Avatar.Image = v21;
            else
                task.spawn(function() -- Line: 84
                    -- upvalues: Players (ref), u20 (copy), u2 (ref), Avatar (copy)
                    local success, result = pcall(function() -- Line: 85
                        -- upvalues: Players (ref), u20 (ref)
                        return Players:GetUserThumbnailAsync(u20, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100);
                    end);

                    if success and result then
                        u2[u20] = result;

                        if Avatar and Avatar.Parent then
                            Avatar.Image = result;
                        end;
                    end;
                end);
            end;
        end;

        Avatar.ImageColor3 = Color3.new(1, 1, 1);
    end;

    local Text = u19:FindFirstChild("Text");

    if Text and Text:IsA("TextLabel") then
        Text.ZIndex = 101;
        Text.RichText = true;
        Text.Text = "<font color=\"" .. p15 .. "\"><b>" .. p13 .. "</b></font> : " .. p14;
    end;

    local u22 = {};
    local u23 = {};

    for _, descendant in u19:GetDescendants() do
        if descendant:IsA("UIStroke") then
            table.insert(u22, {
                prop = "Transparency",
                obj = descendant
            });
        elseif descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            table.insert(u22, {
                prop = "TextTransparency",
                obj = descendant
            });

            if descendant.BackgroundTransparency < 1 then
                table.insert(u22, {
                    prop = "BackgroundTransparency",
                    obj = descendant
                });
            end;
        elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
            table.insert(u22, {
                prop = "ImageTransparency",
                obj = descendant
            });

            if descendant.BackgroundTransparency < 1 then
                table.insert(u22, {
                    prop = "BackgroundTransparency",
                    obj = descendant
                });
            end;
        elseif descendant:IsA("Frame") and descendant.BackgroundTransparency < 1 then
            table.insert(u22, {
                prop = "BackgroundTransparency",
                obj = descendant
            });
        end;

        if descendant:IsA("UIGradient") then
            table.insert(u23, {
                obj = descendant,
                original = descendant.Transparency
            });
        end;
    end;

    if u19:IsA("Frame") and u19.BackgroundTransparency < 1 then
        table.insert(u22, {
            prop = "BackgroundTransparency",
            obj = u19
        });
    end;

    local v24 = {};

    for i, v in ipairs(u22) do
        v24[i] = v.obj[v.prop];
        v.obj[v.prop] = 1;
    end;

    local u25 = NumberSequence.new(1);

    for _, v in ipairs(u23) do
        v.obj.Transparency = u25;
    end;

    local v26 = v18:FindFirstChild("AdminAnnounce") and v26:FindFirstChild("MainFrame");
    local u27 = nil;

    if v26 then
        u19.Parent = v26;
    else
        u27 = Instance.new("ScreenGui");
        u27.Name = "FakeAnnounceConcert";
        u27.IgnoreGuiInset = true;
        u27.ResetOnSpawn = false;
        u27.DisplayOrder = 110;
        u27.Parent = v18;
        u19.Parent = u27;
    end;

    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://98797174600699";
    Sound.Volume = 0.4;
    Sound.Parent = LocalPlayer;
    Sound:Play();
    task.delay(5, function() -- Line: 166
        -- upvalues: Sound (copy)
        if Sound and Sound.Parent then
            Sound:Destroy();
        end;
    end);
    local v28 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

    for i, v in ipairs(u22) do
        TweenService:Create(v.obj, v28, {
            [v.prop] = v24[i]
        }):Play();
    end;

    for _, v in ipairs(u23) do
        v.obj.Transparency = v.original;
    end;

    table.insert(u12._activeNotifications, {
        FADE_OUT_TIME = 0.5,
        notif = u19,
        fallbackSg = u27,
        visuals = u22,
        gradients = u23,
        HIDDEN_SEQ = u25
    });
    task.delay(3.5, function() -- Line: 186
        -- upvalues: u19 (copy), u22 (copy), TweenService (ref), u23 (copy), u25 (copy), u27 (ref), u12 (copy)
        if not u19.Parent then
            return;
        end;

        local v29 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

        for _, v in ipairs(u22) do
            if v.obj and v.obj.Parent then
                TweenService:Create(v.obj, v29, {
                    [v.prop] = 1
                }):Play();
            end;
        end;

        for _, v in ipairs(u23) do
            if v.obj and v.obj.Parent then
                v.obj.Transparency = u25;
            end;
        end;

        task.delay(0.5, function() -- Line: 199
            -- upvalues: u19 (ref), u27 (ref), u12 (ref)
            if u19 and u19.Parent then
                u19:Destroy();
            end;

            if u27 and u27.Parent then
                u27:Destroy();
            end;

            for i, v in ipairs(u12._activeNotifications) do
                if v.notif == u19 then
                    table.remove(u12._activeNotifications, i);

                    return;
                end;
            end;
        end);
    end);
end;

function u1.destroy(p30) -- Line: 212
    for _, v in ipairs(p30._activeNotifications) do
        if v.notif and v.notif.Parent then
            v.notif:Destroy();
        end;

        if v.fallbackSg and v.fallbackSg.Parent then
            v.fallbackSg:Destroy();
        end;
    end;

    table.clear(p30._activeNotifications);
end;

return u1;