-- Ruta Original: ReplicatedStorage.Utilities.ItemsShopRemotes
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local remo = require(ReplicatedStorage.Packages.remo);

local function isString(p1) -- Line: 9
    return type(p1) == "string";
end;

return remo.createRemotes({
    BuyWins = remo.remote(isString).middleware(remo.throttleMiddleware(0.3)),
    BuyRobux = remo.remote(isString).middleware(remo.throttleMiddleware(0.3)),
    PromptRestock = remo.remote().middleware(remo.throttleMiddleware(0.3)),
    RequestState = remo.remote(),
    ShopUpdate = remo.remote(function(p2) -- Line: 13, Name: isTable
        return type(p2) == "table";
    end)
});