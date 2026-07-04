-- Ruta Original: ReplicatedStorage.UISystems.WorldTeleportUISystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local WorldTeleportCatalog = require(ReplicatedStorage.Config:WaitForChild("WorldTeleportCatalog"));
local RequestWorldTeleport = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestWorldTeleport");
local u1 = {};
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local u2 = {};

local function getTagged(p3) -- Line: 21
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged(p3)) do
        if v:IsDescendantOf(PlayerGui) then
            return v;
        end;
    end;

    return nil;
end;

local function clearRows(p4) -- Line: 30
    -- upvalues: u2 (copy)
    for i, v in pairs(u2) do
        if v and (v.Parent and v ~= p4) then
            v:Destroy();
        end;

        u2[i] = nil;
    end;

    for _, child in ipairs(p4.Parent:GetChildren()) do
        if child:IsA("GuiObject") and (child ~= p4 and child:GetAttribute("WorldTeleportRow")) then
            child:Destroy();
        end;
    end;
end;

local function applyRowState(p5, p6, p7) -- Line: 44
    p5.Title.Text = ("World %d - Lvl %d"):format(p6.index, p6.entryLevel);
    p5.BackgroundColor3 = p6.color;

    if p6.icon then
        p5.Icon.Image = p6.icon;
    end;

    if p6.isCurrent then
        p5.Current.Visible = true;
        p5.Teleport.Visible = false;
        p5.Locked.Visible = false;

        return;
    end;

    if p6.hasPlace and p6.entryLevel <= p7 then
        p5.Current.Visible = false;
        p5.Teleport.Visible = true;
        p5.Locked.Visible = false;

        return;
    end;

    p5.Current.Visible = false;
    p5.Teleport.Visible = false;
    p5.Locked.Visible = true;
end;

local function buildWorldRows(p8, p9) -- Line: 71
    -- upvalues: clearRows (copy), ClientState (copy), WorldTeleportCatalog (copy), CollectionService (copy), applyRowState (copy), RequestWorldTeleport (copy), u2 (copy)
    p9.Visible = false;
    clearRows(p9);
    local v10 = ClientState:Get().Level or 1;
    local v11 = 0;

    for _, v in ipairs(WorldTeleportCatalog.getEntries()) do
        local v12 = p9:Clone();
        v12.Name = "WorldRow_" .. v.index;
        v12:SetAttribute("WorldTeleportRow", true);
        v12.Visible = true;

        if v.index == 3 then
            CollectionService:AddTag(v12, "RevealUI");
            v12:SetAttribute("Name", "World3TP");
            v12.Visible = false;
        end;

        v11 = v11 + 1;
        v12.LayoutOrder = v11;
        v12.Parent = p8;
        applyRowState(v12, v, v10);

        if v.hasPlace and (not v.isCurrent and v.entryLevel <= v10) then
            local index = v.index;
            v12.Teleport.MouseButton1Click:Connect(function() -- Line: 98
                -- upvalues: RequestWorldTeleport (ref), index (copy), ClientState (ref)
                RequestWorldTeleport:FireServer(index);
                ClientState:CloseCurrentModal();
            end);
        end;

        u2[v.index] = v12;
    end;
end;

function u1.Populate(p13) -- Line: 108
    -- upvalues: getTagged (copy), buildWorldRows (copy)
    local v14 = getTagged("WorldTeleportModal");

    if v14 then
        buildWorldRows(v14.ScrollingFrame, v14.WorldTemplate);
    end;
end;

function u1.Open(p15) -- Line: 115
    -- upvalues: getTagged (copy), ClientState (copy), u1 (copy)
    local v16 = getTagged("WorldTeleportModal");

    if v16 then
        p15:Populate();
        ClientState:ToggleModal(v16, u1);
    end;
end;

function u1.Refresh(p17) -- Line: 123
    -- upvalues: getTagged (copy), ClientState (copy)
    local v18 = getTagged("WorldTeleportModal");

    if ClientState.ActiveModal and ClientState.ActiveModal == v18 then
        p17:Populate();
    end;
end;

return u1;