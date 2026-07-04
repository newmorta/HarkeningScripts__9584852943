-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.TrailUIHandler
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TrailUISystem = require(ReplicatedStorage:WaitForChild("TrailUISystem"));
local AuraUISystem = require(ReplicatedStorage:WaitForChild("UISystems"):WaitForChild("AuraUISystem"));
local RobuxShopUISystem = require(ReplicatedStorage:WaitForChild("UISystems"):WaitForChild("RobuxShopUISystem"));
local EventUISystem = require(ReplicatedStorage:WaitForChild("EventUISystem"));
local NextEventTimerSystem = require(ReplicatedStorage:WaitForChild("NextEventTimerSystem"));
local RadarSystem = require(ReplicatedStorage:WaitForChild("RadarSystem"));
local EggRainClient = require(ReplicatedStorage:WaitForChild("EggRainClient"));
local StormClient = require(ReplicatedStorage:WaitForChild("StormClient"));
local NotificationSystem = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
TrailUISystem:InitLogic();
AuraUISystem:InitLogic();
RobuxShopUISystem:InitLogic();
EventUISystem:Init();
NextEventTimerSystem:Init();
RadarSystem:Init();
EggRainClient:Init();
StormClient:Init();
Remotes:WaitForChild("CurrencyCollect").OnClientEvent:Connect(function(p1) -- Line: 25
    -- upvalues: NotificationSystem (copy)
    NotificationSystem:ShowCurrencyCollect(p1.icon, p1.label, p1.amount, p1.rarity);
end);