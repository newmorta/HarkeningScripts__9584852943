-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.MedalTopbar
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");

if not require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("MedalQuest")).ENABLED then
    return;
end;

local Icon = require(ReplicatedStorage:WaitForChild("TopbarPlus"):WaitForChild("Icon"));
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");

local function getModal() -- Line: 24
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged("MedalQuestModal")) do
        if v:IsDescendantOf(PlayerGui) then
            return v;
        end;
    end;

    return nil;
end;

local function isAuraOwned() -- Line: 31
    -- upvalues: ClientState (copy)
    local v1 = ClientState:Get().OwnedAuras or {};

    return table.find(v1, "MedalAura") ~= nil;
end;

local u2 = Icon.new():setName("MedalQuest"):setLabel("Medal Quest"):setImage("rbxassetid://6023426952");
u2:setEnabled(false);

local function openModal() -- Line: 52
    -- upvalues: ReplicatedStorage (copy), getModal (copy), ClientState (copy)
    local MedalUISystem = require(ReplicatedStorage:WaitForChild("UISystems"):WaitForChild("MedalUISystem"));
    MedalUISystem:InitLogic();
    local v3 = getModal();

    if not v3 then
        return;
    end;

    local v4 = ClientState.ActiveModal ~= v3;
    ClientState:ToggleModal(v3, MedalUISystem);

    if v4 and ClientState.ActiveModal == v3 then
        MedalUISystem:Open();
    end;
end;

u2.selected:Connect(function() -- Line: 64
    -- upvalues: openModal (copy)
    openModal();
end);
u2.deselected:Connect(function() -- Line: 68
    -- upvalues: getModal (copy), ClientState (copy)
    local v5 = getModal();

    if v5 and ClientState.ActiveModal == v5 then
        ClientState:CloseCurrentModal();
    end;
end);
ClientState:RegisterModalListener(function(p6) -- Line: 76
    -- upvalues: u2 (copy)
    if not p6 then
        u2:deselect();
    end;
end);

local function refreshIconVisibility() -- Line: 86
    -- upvalues: ClientState (copy), u2 (copy)
    local v7 = ClientState:Get().OwnedAuras or {};

    if table.find(v7, "MedalAura") ~= nil then
        u2:setEnabled(false);

        return;
    end;

    u2:setEnabled(true);
end;

Remotes:WaitForChild("UpdateUI").OnClientEvent:Connect(function(p8) -- Line: 95
    -- upvalues: ClientState (copy), u2 (copy)
    if p8 and p8.OwnedAuras then
        local v9 = ClientState:Get().OwnedAuras or {};

        if table.find(v9, "MedalAura") ~= nil then
            u2:setEnabled(false);

            return;
        end;

        u2:setEnabled(true);
    end;
end);
task.wait(2);
local v10 = ClientState:Get().OwnedAuras or {};

if table.find(v10, "MedalAura") ~= nil then
    u2:setEnabled(false);

    return;
end;

u2:setEnabled(true);