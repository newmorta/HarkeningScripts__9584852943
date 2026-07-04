-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.WorldTeleportClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local WorldTeleportUISystem = require(ReplicatedStorage:WaitForChild("UISystems"):WaitForChild("WorldTeleportUISystem"));
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local OpenWorldTeleportModal = Remotes:WaitForChild("OpenWorldTeleportModal");

local function setupCloseButton(p1) -- Line: 17
    -- upvalues: PlayerGui (copy), ClientState (copy)
    if p1:IsDescendantOf(PlayerGui) then
        p1.MouseButton1Click:Connect(function() -- Line: 19
            -- upvalues: ClientState (ref)
            ClientState:CloseCurrentModal();
        end);
    end;
end;

for _, v in ipairs(CollectionService:GetTagged("WorldTeleportCloseBtn")) do
    if v:IsDescendantOf(PlayerGui) then
        v.MouseButton1Click:Connect(function() -- Line: 19
            -- upvalues: ClientState (copy)
            ClientState:CloseCurrentModal();
        end);
    end;
end;

CollectionService:GetInstanceAddedSignal("WorldTeleportCloseBtn"):Connect(function(u2) -- Line: 28
    -- upvalues: PlayerGui (copy), ClientState (copy)
    task.defer(function() -- Line: 29
        -- upvalues: u2 (copy), PlayerGui (ref), ClientState (ref)
        local v3 = u2;

        if v3:IsDescendantOf(PlayerGui) then
            v3.MouseButton1Click:Connect(function() -- Line: 19
                -- upvalues: ClientState (ref)
                ClientState:CloseCurrentModal();
            end);
        end;
    end);
end);
OpenWorldTeleportModal.OnClientEvent:Connect(function() -- Line: 32
    -- upvalues: WorldTeleportUISystem (copy)
    WorldTeleportUISystem:Open();
end);
ClientState:RegisterModalListener(function(p4) -- Line: 36
    -- upvalues: WorldTeleportUISystem (copy)
    if p4 then
        WorldTeleportUISystem:Refresh();
    end;
end);
Remotes:WaitForChild("UpdateUI").OnClientEvent:Connect(function() -- Line: 42
    -- upvalues: WorldTeleportUISystem (copy)
    WorldTeleportUISystem:Refresh();
end);