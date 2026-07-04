-- Ruta Original: ReplicatedStorage.Config.PlaceRegistry
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u1 = {
    ProdGroup = "Prod",
    Groups = {
        Prod = { { 95082159892680, 122256965926456, 111678427706543 }, { 118941584817777, 96482048415123, 98382274944853, 72332128343708 }, { 93411036959889 } },
        Test = { { 82659363268176 }, { 118283647543447 }, { 118595156473600 } },
        Sano = { { 128290329179894 }, { 114452296004057 }, {} },
        FoeCakes = { { 113315188437529 }, { 113315188437529 }, {} },
        Lyzrinn = { { 75225381217080 }, { 130568239357796 }, { 92516083343635 } }
    },
    GroupOrder = { "Prod", "Test", "Sano", "FoeCakes", "Lyzrinn" }
};

local function resolvePlaceId(p2) -- Line: 45
    return p2 or game.PlaceId;
end;

function u1.locate(p3) -- Line: 50
    -- upvalues: u1 (copy)
    local v4 = p3 or game.PlaceId;

    for _, v in ipairs(u1.GroupOrder) do
        for i, v2 in ipairs(u1.Groups[v]) do
            if table.find(v2, v4) then
                return v, i;
            end;
        end;
    end;

    return nil, nil;
end;

function u1.getWorldIndex(p5) -- Line: 64
    -- upvalues: u1 (copy)
    local _, v6 = u1.locate(p5);

    return v6 or 1;
end;

function u1.getWorldStatus(p7) -- Line: 70
    -- upvalues: u1 (copy)
    local _, v8 = u1.locate(p7);

    return v8 or -1;
end;

function u1.getGroupName(p9) -- Line: 75
    -- upvalues: u1 (copy)
    return u1.locate(p9);
end;

function u1.getPrimaryPlaceId(p10, p11) -- Line: 81
    -- upvalues: u1 (copy)
    local v12 = u1.Groups[p10] and v12[p11];

    return v12 and v12[1] or nil;
end;

function u1.getGroupPrimaries(p13) -- Line: 88
    -- upvalues: u1 (copy)
    local v14 = {};
    local v15 = u1.Groups[p13];

    if v15 then
        for i, v in ipairs(v15) do
            v14[i] = v[1];
        end;
    end;

    return v14;
end;

function u1.getWorlds(p16) -- Line: 101
    -- upvalues: u1 (copy), RunService (copy)
    local v17 = p16 or game.PlaceId;
    local v18 = u1.getGroupName(v17);

    if v18 then
        return u1.getGroupPrimaries(v18);
    end;

    if RunService:IsStudio() or v17 == 108879839306227 then
        return { v17, v17 };
    end;

    error("[PlaceRegistry] Aucun groupe de monde trouvé pour la place " .. tostring(v17));
end;

function u1.isTestPlace(p19) -- Line: 116
    -- upvalues: u1 (copy)
    local v20 = u1.getGroupName(p19);
    local v21;

    if v20 == nil then
        v21 = false;
    else
        v21 = v20 ~= u1.ProdGroup;
    end;

    return v21;
end;

function u1.getWorldCount() -- Line: 123
    -- upvalues: u1 (copy)
    return #u1.Groups[u1.ProdGroup];
end;

return u1;