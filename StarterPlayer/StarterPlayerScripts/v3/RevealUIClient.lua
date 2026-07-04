-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.RevealUIClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local RevealUI = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RevealUI");
local u1 = {};

local function setUIVisible(p2, p3) -- Line: 25
    if p2:IsA("GuiObject") then
        p2.Visible = p3;

        return;
    end;

    if p2:IsA("ScreenGui") or (p2:IsA("SurfaceGui") or p2:IsA("BillboardGui")) then
        p2.Enabled = p3;
    end;
end;

local function getUIElementsByName(p4) -- Line: 33
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    local v5 = {};

    for _, v in ipairs(CollectionService:GetTagged("RevealUI")) do
        if v:GetAttribute("Name") == p4 and v:IsDescendantOf(PlayerGui) then
            table.insert(v5, v);
        end;
    end;

    return v5;
end;

local function applyRevealUI(p6) -- Line: 43
    -- upvalues: getUIElementsByName (copy)
    for _, v in ipairs((getUIElementsByName(p6))) do
        if v:IsA("GuiObject") then
            v.Visible = true;
        elseif v:IsA("ScreenGui") or (v:IsA("SurfaceGui") or v:IsA("BillboardGui")) then
            v.Enabled = true;
        end;
    end;
end;

local function applyUnrevealUI(p7) -- Line: 49
    -- upvalues: getUIElementsByName (copy)
    for _, v in ipairs((getUIElementsByName(p7))) do
        if v:IsA("GuiObject") then
            v.Visible = false;
        elseif v:IsA("ScreenGui") or (v:IsA("SurfaceGui") or v:IsA("BillboardGui")) then
            v.Enabled = false;
        end;
    end;
end;

local function applyAllStates() -- Line: 55
    -- upvalues: CollectionService (copy), PlayerGui (copy), u1 (ref)
    for _, v in ipairs(CollectionService:GetTagged("RevealUI")) do
        if v:IsDescendantOf(PlayerGui) then
            local v8 = v:GetAttribute("Name");

            if v8 then
                local v9 = u1[v8] == true;

                if v:IsA("GuiObject") then
                    v.Visible = v9;
                elseif v:IsA("ScreenGui") or (v:IsA("SurfaceGui") or v:IsA("BillboardGui")) then
                    v.Enabled = v9;
                end;
            end;
        end;
    end;
end;

RevealUI.OnClientEvent:Connect(function(p10, p11) -- Line: 71
    -- upvalues: u1 (ref), applyAllStates (copy), getUIElementsByName (copy)
    if p10 ~= "init" then
        if p10 == "reveal" then
            if type(p11) == "string" then
                u1[p11] = true;

                for _, v in ipairs((getUIElementsByName(p11))) do
                    if v:IsA("GuiObject") then
                        v.Visible = true;
                    elseif v:IsA("ScreenGui") or (v:IsA("SurfaceGui") or v:IsA("BillboardGui")) then
                        v.Enabled = true;
                    end;
                end;

                return;
            end;
        elseif p10 == "unreveal" and type(p11) == "string" then
            u1[p11] = nil;

            for _, v in ipairs((getUIElementsByName(p11))) do
                if v:IsA("GuiObject") then
                    v.Visible = false;
                elseif v:IsA("ScreenGui") or (v:IsA("SurfaceGui") or v:IsA("BillboardGui")) then
                    v.Enabled = false;
                end;
            end;
        end;

        return;
    end;

    if type(p11) == "table" then
        u1 = p11;
    end;

    applyAllStates();
end);
CollectionService:GetInstanceAddedSignal("RevealUI"):Connect(function(u12) -- Line: 99
    -- upvalues: PlayerGui (copy), u1 (ref)
    task.defer(function() -- Line: 100
        -- upvalues: u12 (copy), PlayerGui (ref), u1 (ref)
        if not u12:IsDescendantOf(PlayerGui) then
            return;
        end;

        local v13 = u12:GetAttribute("Name");

        if not v13 then
            return;
        end;

        local v14 = u12;
        local v15 = u1[v13] == true;

        if v14:IsA("GuiObject") then
            v14.Visible = v15;

            return;
        end;

        if v14:IsA("ScreenGui") or (v14:IsA("SurfaceGui") or v14:IsA("BillboardGui")) then
            v14.Enabled = v15;
        end;
    end);
end);