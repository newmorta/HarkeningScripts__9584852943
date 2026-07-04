-- Ruta Original: StarterPlayer.StarterPlayerScripts.CCPanel.CCClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Icon = require(ReplicatedStorage:WaitForChild("TopbarPlus"):WaitForChild("Icon"));
local CCManagerUISystem = require(ReplicatedStorage:WaitForChild("CCPanel"):WaitForChild("CCManagerUISystem"));
local CCPanelUISystem = require(ReplicatedStorage:WaitForChild("CCPanel"):WaitForChild("CCPanelUISystem"));
local Remotes = require(ReplicatedStorage:WaitForChild("CCPanel"):WaitForChild("Remotes"));
local u1 = Remotes.Functions.checkRole:InvokeServer();

if u1.isManager then
    local u2 = nil;
    local u3 = Icon.new():setName("CCManager"):setLabel("CC Manager");
    u3.selected:Connect(function() -- Line: 19
        -- upvalues: u2 (ref), CCManagerUISystem (copy), u3 (copy)
        if u2 == nil then
            u2 = CCManagerUISystem.createPanel(function() -- Line: 21
                -- upvalues: u3 (ref)
                u3:deselect();
            end);
        end;

        if not u2.Enabled then
            CCManagerUISystem.toggle(u2);
        end;
    end);
    u3.deselected:Connect(function() -- Line: 30
        -- upvalues: u2 (ref)
        if u2 then
            u2.Enabled = false;
        end;
    end);
end;

local u4 = nil;
local u5 = nil;

local function destroyCCIcon() -- Line: 42
    -- upvalues: u4 (ref), u5 (ref)
    if u4 then
        u4:destroy();
        u4 = nil;
    end;

    if u5 then
        u5.Enabled = false;
    end;
end;

local function ensureCCIcon() -- Line: 52
    -- upvalues: u4 (ref), Icon (copy), u5 (ref), CCPanelUISystem (copy)
    if u4 then
        return;
    end;

    u4 = Icon.new():setName("CCPanel"):setLabel("CC Panel");
    u4.selected:Connect(function() -- Line: 58
        -- upvalues: u5 (ref), CCPanelUISystem (ref), u4 (ref)
        if u5 == nil then
            u5 = CCPanelUISystem.createPanel(function() -- Line: 60
                -- upvalues: u4 (ref)
                u4:deselect();
            end);
        end;

        if not u5.Enabled then
            CCPanelUISystem.toggle(u5);
        end;
    end);
    u4.deselected:Connect(function() -- Line: 69
        -- upvalues: u5 (ref)
        if u5 then
            u5.Enabled = false;
        end;
    end);
end;

if u1.isCC or u1.isManager then
    ensureCCIcon();
end;

Remotes.Events.syncCCPermissions.OnClientEvent:Connect(function(p6) -- Line: 81
    -- upvalues: u1 (copy), ensureCCIcon (copy), u4 (ref), u5 (ref), CCPanelUISystem (copy)
    if type(p6) ~= "table" then
        return;
    end;

    if p6.access == true or u1.isManager then
        ensureCCIcon();
    else
        if u4 then
            u4:destroy();
            u4 = nil;
        end;

        if u5 then
            u5.Enabled = false;
        end;
    end;

    if u5 and u5.Enabled then
        CCPanelUISystem.refreshGiftState();
    end;
end);