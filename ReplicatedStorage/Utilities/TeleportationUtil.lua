-- Ruta Original: ReplicatedStorage.Utilities.TeleportationUtil
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TeleportService = game:GetService("TeleportService");
local Promise = require(script.Parent.Promise);
local u16 = {
    TeleportPlayersInBox = function(p1, p2) -- Line: 10, Name: TeleportPlayersInBox
        -- upvalues: Players (copy)
        if not p1 then
            return;
        end;

        if not p2 then
            return;
        end;

        local v3, v4 = p1:GetBoundingBox();
        local v5 = workspace:GetPartBoundsInBox(v3, v4);

        for _, v in ipairs(v5) do
            local v6 = Players:GetPlayerFromCharacter(v.Parent);

            if v6 then
                local Character = v6.Character;

                if Character then
                    Character:MoveTo(p2);
                end;
            end;
        end;
    end,

    ResetPlayersInBoxBackToLobby = function(p7) -- Line: 37, Name: ResetPlayersInBoxBackToLobby
        -- upvalues: Players (copy)
        if not p7 then
            return;
        end;

        local v8, v9 = p7:GetBoundingBox();
        local v10 = workspace:GetPartBoundsInBox(v8, v9);

        for _, v in ipairs(v10) do
            local v11 = Players:GetPlayerFromCharacter(v.Parent);

            if v11 then
                v11:LoadCharacterAsync();
            end;
        end;
    end,

    TeleportPlayersInServer = function(p12, u13, u14) -- Line: 55, Name: TeleportPlayersInServer
        -- upvalues: Promise (copy), TeleportService (copy)
        return Promise.new(function(p15) -- Line: 56
            -- upvalues: TeleportService (ref), u14 (copy), u13 (copy)
            p15((TeleportService:TeleportAsync(u14, u13)));
        end);
    end
};

function u16.TeleportPlayerInServer(p17, p18, p19) -- Line: 62
    -- upvalues: u16 (copy)
    return u16:TeleportPlayersInServer({ p18 }, p19);
end;

return u16;