-- Ruta Original: ReplicatedStorage.Utilities.Events.SoundFade
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local u1 = {};
u1.__index = u1;

function u1.new(u2, p3) -- Line: 7
    -- upvalues: u1 (copy)
    local u4 = setmetatable({}, u1);
    u4._sound = u2;
    u4._fadeIn = p3 and (p3.fadeIn or 0.5) or 0.5;
    u4._fadeOut = p3 and (p3.fadeOut or 1) or 1;
    u4._volume = p3 and p3.volume or 0.8;
    u4._tween = nil;
    u2:GetAttributeChangedSignal("AdminAbuseMuted"):Connect(function() -- Line: 16
        -- upvalues: u2 (copy), u4 (copy)
        if u2:GetAttribute("AdminAbuseMuted") == true and u4._tween then
            u4._tween:Cancel();
            u4._tween = nil;
        end;
    end);

    return u4;
end;

function u1.fadeIn(p5) -- Line: 26
    -- upvalues: TweenService (copy)
    if p5._tween then
        p5._tween:Cancel();
    end;

    if p5._sound:GetAttribute("AdminAbuseMuted") == true then
        p5._sound:SetAttribute("AdminAbusePrevVolume", p5._volume);

        return;
    end;

    local v6 = TweenInfo.new(p5._fadeIn, Enum.EasingStyle.Linear);
    p5._tween = TweenService:Create(p5._sound, v6, {
        Volume = p5._volume
    });
    p5._tween:Play();
end;

function u1.fadeOut(p7, u8) -- Line: 39
    -- upvalues: TweenService (copy)
    if p7._tween then
        p7._tween:Cancel();
    end;

    local v9 = TweenInfo.new(p7._fadeOut, Enum.EasingStyle.Linear);
    p7._tween = TweenService:Create(p7._sound, v9, {
        Volume = 0
    });
    p7._tween:Play();

    if u8 then
        p7._tween.Completed:Once(function(p10) -- Line: 45
            -- upvalues: u8 (copy)
            if p10 == Enum.PlaybackState.Completed then
                u8();
            end;
        end);
    end;
end;

function u1.cancel(p11) -- Line: 53
    if p11._tween then
        p11._tween:Cancel();
        p11._tween = nil;
    end;
end;

return u1;