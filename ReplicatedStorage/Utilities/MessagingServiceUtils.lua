-- Ruta Original: ReplicatedStorage.Utilities.MessagingServiceUtils
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {};
local MessagingService = game:GetService("MessagingService");

function u1.YieldSubscribeWithTimeout(u2, u3, p4) -- Line: 5
    -- upvalues: MessagingService (copy)
    local function AttemptSubscription(u5) -- Line: 10
        -- upvalues: MessagingService (ref), u2 (copy), u3 (copy)
        task.spawn(function() -- Line: 11
            -- upvalues: MessagingService (ref), u2 (ref), u3 (ref), u5 (copy)
            local success, result = pcall(function() -- Line: 12
                -- upvalues: MessagingService (ref), u2 (ref), u3 (ref)
                return MessagingService:SubscribeAsync(u2, u3);
            end);
            u5(success, result);
        end);
    end;

    local u6 = nil;
    local v7 = p4 or 10;

    while u6 == nil do
        local function u10(p8, p9) -- Line: 26
            -- upvalues: u6 (ref)
            if p8 then
                if not u6 then
                    u6 = p9;

                    return;
                end;

                p9:Disconnect();
            end;
        end;

        task.spawn(function() -- Line: 11
            -- upvalues: MessagingService (ref), u2 (copy), u3 (copy), u10 (copy)
            local success, result = pcall(function() -- Line: 12
                -- upvalues: MessagingService (ref), u2 (ref), u3 (ref)
                return MessagingService:SubscribeAsync(u2, u3);
            end);
            u10(success, result);
        end);
        local v11 = v7;

        while v7 > 0 and u6 == nil do
            v7 = v7 - task.wait();
        end;

        v7 = v11;
    end;

    return u6;
end;

function u1.SubscribeWithTimeoutAsync(u12, u13, u14, u15) -- Line: 58
    -- upvalues: u1 (copy)
    task.spawn(function() -- Line: 64
        -- upvalues: u1 (ref), u12 (copy), u13 (copy), u15 (copy), u14 (copy)
        local v16 = u1.YieldSubscribeWithTimeout(u12, u13, u15);

        if u14 then
            u14(v16);
        end;
    end);
end;

return u1;