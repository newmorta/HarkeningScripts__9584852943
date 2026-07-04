-- Ruta Original: ReplicatedStorage.Services.MedalClipper
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");

function base64Encode(p1)
    local v2 = #p1;
    local v3 = 1;
    local v4 = {};

    while v3 <= v2 do
        local v5 = p1:byte(v3) or 0;
        local v6 = p1:byte(v3 + 1) or 0;
        local v7 = p1:byte(v3 + 2) or 0;
        local v8 = v5 * 65536 + v6 * 256 + v7;
        local v9 = math.floor(v8 / 262144) % 64 + 1;
        local v10 = math.floor(v8 / 4096) % 64 + 1;
        local v11 = math.floor(v8 / 64) % 64 + 1;
        local v12 = v8 % 64 + 1;
        v4[#v4 + 1] = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(v9, v9);
        v4[#v4 + 1] = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(v10, v10);

        if v2 < v3 + 1 then
            v4[#v4 + 1] = "==";
            break;
        end;

        if v2 < v3 + 2 then
            v4[#v4 + 1] = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(v11, v11) .. "=";
            break;
        end;

        v4[#v4 + 1] = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(v11, v11) .. ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(v12, v12);
        v3 = v3 + 3;
    end;

    return table.concat(v4);
end;

return {
    TriggerClip = function(p13, p14, p15, p16) -- Line: 11, Name: TriggerClip
        -- upvalues: HttpService (copy)
        local v17 = p16 or {};
        local v18 = {
            eventId = p14,
            eventName = p15,
            triggerActions = { "SaveClip" },
            clipOptions = {
                duration = v17.duration or 30,
                captureDelayMs = v17.captureDelayMs
            }
        };

        if v17.contextTags and next(v17.contextTags) then
            v18.contextTags = v17.contextTags;
        end;

        print("[_MAPIEvent][v1/event/invoke]", base64Encode(HttpService:JSONEncode({
            gameEvent = v18,
            universeId = game.GameId
        })));
    end
};