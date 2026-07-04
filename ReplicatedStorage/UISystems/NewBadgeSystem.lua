-- Ruta Original: ReplicatedStorage.UISystems.NewBadgeSystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local UpdateUI = Remotes:WaitForChild("UpdateUI");
local MarkNewBadgeGroupSeen = Remotes:WaitForChild("MarkNewBadgeGroupSeen");
local v1 = {
    Mode = table.freeze({
        Leaf = "Leaf",
        Summary = "Summary"
    }),
    Trigger = table.freeze({
        ScrollIntoView = "ScrollIntoView",
        OnOpen = "OnOpen",
        OnClick = "OnClick"
    })
};
local Mode = v1.Mode;
local Trigger = v1.Trigger;
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = nil;

local function isEffectivelyVisible(p7) -- Line: 99
    -- upvalues: PlayerGui (copy)
    while p7 and p7 ~= PlayerGui do
        if p7:IsA("GuiObject") and not p7.Visible then
            return false;
        end;

        p7 = p7.Parent;
    end;

    return p7 == PlayerGui;
end;

local function findAncestorOfType(p8, p9) -- Line: 110
    -- upvalues: PlayerGui (copy)
    local Parent = p8.Parent;

    while Parent and Parent ~= PlayerGui do
        if Parent:IsA(p9) then
            return Parent;
        end;

        Parent = Parent.Parent;
    end;

    return nil;
end;

local function overlaps(p10, p11, p12, p13) -- Line: 121
    local v14;

    if p10.X + p11.X > p12.X then
        v14 = p10.X < p12.X + p13.X;
    else
        v14 = false;
    end;

    local v15;

    if p10.Y + p11.Y > p12.Y then
        v15 = p10.Y < p12.Y + p13.Y;
    else
        v15 = false;
    end;

    return v14 and v15;
end;

local function markSeen(p16) -- Line: 127
    -- upvalues: u2 (copy)
    u2[p16] = true;
end;

local u25 = {
    [Trigger.OnOpen] = {
        Poll = function(p17) -- Line: 139, Name: Poll
            -- upvalues: isEffectivelyVisible (copy)
            return isEffectivelyVisible(p17.instance);
        end
    },
    [Trigger.ScrollIntoView] = {
        Setup = function(p18) -- Line: 145, Name: Setup
            -- upvalues: findAncestorOfType (copy)
            p18.scrollingFrame = findAncestorOfType(p18.instance, "ScrollingFrame");

            if not p18.scrollingFrame then
                warn("[NewBadgeSystem] ScrollIntoView badge has no ancestor ScrollingFrame: " .. p18.instance:GetFullName());
            end;
        end,

        Poll = function(p19) -- Line: 151, Name: Poll
            -- upvalues: isEffectivelyVisible (copy)
            local v20;

            if p19.scrollingFrame == nil then
                v20 = false;
            else
                v20 = isEffectivelyVisible(p19.instance);

                if v20 then
                    local AbsolutePosition = p19.instance.AbsolutePosition;
                    local AbsoluteSize = p19.instance.AbsoluteSize;
                    local AbsolutePosition2 = p19.scrollingFrame.AbsolutePosition;
                    local AbsoluteSize2 = p19.scrollingFrame.AbsoluteSize;
                    local v21;

                    if AbsolutePosition.X + AbsoluteSize.X > AbsolutePosition2.X then
                        v21 = AbsolutePosition.X < AbsolutePosition2.X + AbsoluteSize2.X;
                    else
                        v21 = false;
                    end;

                    local v22;

                    if AbsolutePosition.Y + AbsoluteSize.Y > AbsolutePosition2.Y then
                        v22 = AbsolutePosition.Y < AbsolutePosition2.Y + AbsoluteSize2.Y;
                    else
                        v22 = false;
                    end;

                    v20 = v21 and v22;
                end;
            end;

            return v20;
        end
    },
    [Trigger.OnClick] = {
        Setup = function(u23) -- Line: 160, Name: Setup
            -- upvalues: findAncestorOfType (copy), u2 (copy)
            local v24 = u23.instance:IsA("GuiButton") and u23.instance or findAncestorOfType(u23.instance, "GuiButton");

            if v24 then
                v24.Activated:Connect(function() -- Line: 163
                    -- upvalues: u23 (copy), u2 (ref)
                    u2[u23.instance] = true;
                end);

                return;
            end;

            warn("[NewBadgeSystem] OnClick badge has no ancestor GuiButton: " .. u23.instance:GetFullName());
        end
    }
};

local function hideGroupImmediately(p26) -- Line: 178
    -- upvalues: u3 (copy), u2 (copy), u4 (copy)
    for _, v in u3 do
        if v.group == p26 then
            u2[v.instance] = true;
            v.instance.Visible = false;
        end;
    end;

    for _, v in u4 do
        if v.group == p26 then
            v.instance.Visible = false;
        end;
    end;
end;

local function applyPersistedGroup(p27) -- Line: 192
    -- upvalues: u5 (copy), hideGroupImmediately (copy)
    if not u5[p27] then
        u5[p27] = true;
        hideGroupImmediately(p27);
    end;
end;

local function persistSeenGroup(p28) -- Line: 201
    -- upvalues: u5 (copy), MarkNewBadgeGroupSeen (copy)
    if not u5[p28] then
        u5[p28] = true;
        MarkNewBadgeGroupSeen:FireServer(p28);
    end;
end;

UpdateUI.OnClientEvent:Connect(function(p29) -- Line: 208
    -- upvalues: u5 (copy), hideGroupImmediately (copy)
    if p29 and p29.SeenNewBadgeGroups then
        for _, v in p29.SeenNewBadgeGroups do
            if not u5[v] then
                u5[v] = true;
                hideGroupImmediately(v);
            end;
        end;
    end;
end);

local function isGroupFullySeen(p30) -- Line: 223
    -- upvalues: u3 (copy), u2 (copy)
    local v31 = true;
    local v32 = false;

    for _, v in u3 do
        if v.group == p30 then
            v32 = true;

            if not u2[v.instance] then
                v31 = false;
            end;
        end;
    end;

    return v31 and v32, v32;
end;

local function pollLeafBadges() -- Line: 254
    -- upvalues: u3 (copy), u2 (copy), u25 (copy)
    for _, v in u3 do
        if not u2[v.instance] then
            local Poll = u25[v.trigger].Poll;

            if Poll and Poll(v) then
                u2[v.instance] = true;
            end;
        end;
    end;
end;

local function startPolling() -- Line: 265
    -- upvalues: u6 (ref), RunService (copy), pollLeafBadges (copy)
    if not u6 then
        u6 = RunService.Heartbeat:Connect(pollLeafBadges);
    end;
end;

local function stopPolling() -- Line: 271
    -- upvalues: u6 (ref)
    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;
end;

local function registerLeafBadge(p33, p34) -- Line: 282
    -- upvalues: Trigger (copy), u25 (copy), u3 (copy), ClientState (copy), u2 (copy)
    local v35 = p33:GetAttribute("NewBadgeTrigger") or Trigger.OnOpen;
    local v36 = u25[v35];

    if not v36 then
        warn(("[NewBadgeSystem] Unknown NewBadgeTrigger \'%s\': %s"):format(tostring(v35), p33:GetFullName()));

        return;
    end;

    local v37 = {
        scrollingFrame = nil,
        instance = p33,
        group = p34,
        trigger = v35
    };
    table.insert(u3, v37);

    if v36.Setup then
        v36.Setup(v37);
    end;

    if ClientState.ActiveModal and (v36.Poll and v36.Poll(v37)) then
        u2[p33] = true;
    end;
end;

local function registerBadge(p38) -- Line: 303
    -- upvalues: PlayerGui (copy), Mode (copy), u4 (copy), registerLeafBadge (copy), u5 (copy), u2 (copy)
    if not p38:IsDescendantOf(PlayerGui) then
        return;
    end;

    local v39 = p38:GetAttribute("NewBadgeGroup");

    if not v39 then
        warn("[NewBadgeSystem] NewBadge is missing NewBadgeGroup: " .. p38:GetFullName());

        return;
    end;

    if p38:GetAttribute("NewBadgeMode") == Mode.Summary then
        table.insert(u4, {
            instance = p38,
            group = v39
        });
    else
        registerLeafBadge(p38, v39);
    end;

    if u5[v39] then
        u2[p38] = true;
        p38.Visible = false;
    end;
end;

local function commitSeenBadges() -- Line: 237
    -- upvalues: u3 (copy), u2 (copy), u4 (copy), isGroupFullySeen (copy), u5 (copy), MarkNewBadgeGroupSeen (copy)
    for _, v in u3 do
        if u2[v.instance] then
            v.instance.Visible = false;
        end;
    end;

    for _, v in u4 do
        local v40, v41 = isGroupFullySeen(v.group);

        if v41 then
            if v40 then
                v.instance.Visible = false;
                local group = v.group;

                if not u5[group] then
                    u5[group] = true;
                    MarkNewBadgeGroupSeen:FireServer(group);
                end;
            end;
        else
            warn(("[NewBadgeSystem] Summary badge\'s NewBadgeGroup \'%s\' matches no Leaf badge - check for a typo/case mismatch: %s"):format(tostring(v.group), v.instance:GetFullName()));
        end;
    end;
end;

for _, v in CollectionService:GetTagged("NewBadge") do
    registerBadge(v);
end;

CollectionService:GetInstanceAddedSignal("NewBadge"):Connect(registerBadge);
ClientState:RegisterModalListener(function(p42) -- Line: 331
    -- upvalues: u6 (ref), RunService (copy), pollLeafBadges (copy), commitSeenBadges (copy)
    if p42 then
        if not u6 then
            u6 = RunService.Heartbeat:Connect(pollLeafBadges);
        end;

        pollLeafBadges();

        return;
    end;

    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;

    commitSeenBadges();
end);

return v1;