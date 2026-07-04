-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.TestSync
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local PartyEvent = require(script.Parent.Parent.PartyEvent);
local SharedSyncedEvent = require(script.Parent.Parent.SharedSyncedEvent);
local v1 = PartyEvent.new({
    NeedsDuration = false,
    SkipDoorTransition = true,
    IsAdminAbuse = false,
    RequiresRespawnRefire = false
});

function v1.OnStart(p2, u3, p4, p5, p6) -- Line: 17
    -- upvalues: SharedSyncedEvent (copy), Lighting (copy)
    local SyncTest = SharedSyncedEvent.new("SyncTest");
    u3._sse = SyncTest;
    u3._color = Color3.new(1, 1, 1);
    u3._pings = 0;
    local v7 = u3.janitor:Add(Instance.new("ColorCorrectionEffect"));
    v7.Name = "SyncTestCC";
    v7.Saturation = 0.4;
    v7.Parent = Lighting;
    u3._cc = v7;
    SyncTest:onChange("State", function(p8) -- Line: 29
        -- upvalues: u3 (copy)
        if type(p8) ~= "table" then
            return;
        end;

        local color = p8.color;

        if color then
            u3._color = Color3.new(color.r or 1, color.g or 1, color.b or 1);
        end;

        print(string.format("[SyncTest] State tick=%s  color=(%.2f %.2f %.2f)", tostring(p8.tick), color and (color.r or 0) or 0, color and (color.g or 0) or 0, color and color.b or 0));
    end);
    SyncTest:onFire("Ping", function(p9) -- Line: 39
        -- upvalues: u3 (copy)
        local v10 = u3;
        v10._pings = v10._pings + 1;

        if p9 then
            p9 = p9.t;
        end;

        print(string.format("[SyncTest] Ping t=%s  total reçus=%d", tostring(p9), u3._pings));
    end);
end;

function v1.OnRender(p11, p12, p13, p14, p15, p16) -- Line: 45
    local _cc = p12._cc;

    if _cc and _cc.Parent then
        _cc.TintColor = p12._color;
    end;
end;

function v1.OnStop(p17, p18) -- Line: 52
    local _sse = p18._sse;

    if _sse then
        _sse:destroy();
        p18._sse = nil;
    end;
end;

return v1;