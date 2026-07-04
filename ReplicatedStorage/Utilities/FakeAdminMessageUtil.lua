-- Ruta Original: ReplicatedStorage.Utilities.FakeAdminMessageUtil
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local u1 = {};

return {
    preload = function(p2) -- Line: 33, Name: preload
        -- upvalues: u1 (copy), Players (copy)
        for _, v in p2 do
            if not u1[v] then
                task.spawn(function() -- Line: 36
                    -- upvalues: Players (ref), v (copy), u1 (ref)
                    local success, result = pcall(function() -- Line: 37
                        -- upvalues: Players (ref), v (ref)
                        return Players:GetUserThumbnailAsync(v, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100);
                    end);

                    if success and result then
                        u1[v] = result;
                    end;
                end);
            end;
        end;
    end,

    show = function(p3) -- Line: 47, Name: show
        -- upvalues: Players (copy), ReplicatedStorage (copy), u1 (copy), TweenService (copy)
        local PlayerGui = Players.LocalPlayer.PlayerGui;
        local v4 = p3.duration or 10;
        local v5 = p3.fadeIn or 0.4;
        local u6 = p3.fadeOut or 0.5;
        local v7 = p3.displayOrder or 999999999999999;
        local v8 = p3.nameColor or "rgb(85,170,255)";
        local v9 = p3.tintColor or Color3.new(0, 0, 0);
        local NotificationFrame = ReplicatedStorage:FindFirstChild("NotificationFrame");

        if not NotificationFrame then
            warn("[FakeAdminMessageUtil] NotificationFrame template missing in ReplicatedStorage");

            return;
        end;

        local u10 = NotificationFrame:Clone();
        local Avatar = u10:FindFirstChild("Avatar");

        if Avatar and Avatar:IsA("ImageLabel") then
            if p3.preloadedThumb then
                Avatar.Image = p3.preloadedThumb;
            elseif u1[p3.senderUserId] then
                Avatar.Image = u1[p3.senderUserId];
            else
                local senderUserId = p3.senderUserId;
                task.spawn(function() -- Line: 74
                    -- upvalues: Players (ref), senderUserId (copy), u1 (ref), Avatar (copy)
                    local success, result = pcall(function() -- Line: 75
                        -- upvalues: Players (ref), senderUserId (ref)
                        return Players:GetUserThumbnailAsync(senderUserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100);
                    end);

                    if success and result then
                        u1[senderUserId] = result;

                        if Avatar.Parent then
                            Avatar.Image = result;
                        end;
                    end;
                end);
            end;

            if p3.tintAvatar then
                Avatar.ImageColor3 = v9;
            end;
        end;

        local Text = u10:FindFirstChild("Text");

        if Text and Text:IsA("TextLabel") then
            Text.RichText = true;
            Text.Text = "<font color=\"" .. v8 .. "\"><b>" .. p3.senderName .. "</b></font> : " .. p3.message;
        end;

        local u11 = {};
        local u12 = {};

        for _, descendant in u10:GetDescendants() do
            if descendant:IsA("UIStroke") then
                table.insert(u11, {
                    prop = "Transparency",
                    obj = descendant
                });
            elseif descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                table.insert(u11, {
                    prop = "TextTransparency",
                    obj = descendant
                });

                if descendant.BackgroundTransparency < 1 then
                    table.insert(u11, {
                        prop = "BackgroundTransparency",
                        obj = descendant
                    });
                end;
            elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
                table.insert(u11, {
                    prop = "ImageTransparency",
                    obj = descendant
                });

                if descendant.BackgroundTransparency < 1 then
                    table.insert(u11, {
                        prop = "BackgroundTransparency",
                        obj = descendant
                    });
                end;
            elseif descendant:IsA("Frame") and descendant.BackgroundTransparency < 1 then
                table.insert(u11, {
                    prop = "BackgroundTransparency",
                    obj = descendant
                });
            end;

            if descendant:IsA("UIGradient") then
                table.insert(u12, {
                    obj = descendant,
                    original = descendant.Transparency
                });
            end;
        end;

        if u10:IsA("Frame") and u10.BackgroundTransparency < 1 then
            table.insert(u11, {
                prop = "BackgroundTransparency",
                obj = u10
            });
        end;

        local v13 = {};

        for i, v in ipairs(u11) do
            v13[i] = v.obj[v.prop];
            v.obj[v.prop] = 1;
        end;

        local u14 = NumberSequence.new(1);

        for _, v in ipairs(u12) do
            v.obj.Transparency = u14;
        end;

        local v15 = PlayerGui:FindFirstChild("AdminAnnounce") and v15:FindFirstChild("MainFrame");
        local u16 = nil;

        if v15 then
            u10.Parent = v15;
        else
            u16 = Instance.new("ScreenGui");
            u16.Name = "SecondAnnounce";
            u16.IgnoreGuiInset = true;
            u16.DisplayOrder = v7;
            u16.Parent = PlayerGui;
            u10.Parent = u16;
        end;

        local Sound = Instance.new("Sound");
        Sound.SoundId = "rbxassetid://98797174600699";
        Sound.Volume = 0.4;
        Sound.Parent = PlayerGui;
        Sound:Play();
        game:GetService("Debris"):AddItem(Sound, 5);
        local v17 = TweenInfo.new(v5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

        for i, v in ipairs(u11) do
            TweenService:Create(v.obj, v17, {
                [v.prop] = v13[i]
            }):Play();
        end;

        for _, v in ipairs(u12) do
            v.obj.Transparency = v.original;
        end;

        task.delay(v4, function() -- Line: 173
            -- upvalues: u6 (copy), u11 (copy), TweenService (ref), u12 (copy), u14 (copy), u10 (copy), u16 (ref)
            local v18 = TweenInfo.new(u6, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

            for _, v in ipairs(u11) do
                TweenService:Create(v.obj, v18, {
                    [v.prop] = 1
                }):Play();
            end;

            for _, v in ipairs(u12) do
                v.obj.Transparency = u14;
            end;

            task.delay(u6, function() -- Line: 181
                -- upvalues: u10 (ref), u16 (ref)
                if u10 and u10.Parent then
                    u10:Destroy();
                end;

                if u16 and u16.Parent then
                    u16:Destroy();
                end;
            end);
        end);
    end
};