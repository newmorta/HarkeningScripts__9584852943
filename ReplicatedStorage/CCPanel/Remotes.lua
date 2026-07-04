-- Ruta Original: ReplicatedStorage.CCPanel.Remotes
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes");
local u1 = RunService:IsServer();

local function getOrCreate(p2, p3, p4) -- Line: 7
    -- upvalues: u1 (copy)
    if not u1 then
        return p2:WaitForChild(p3, 10);
    end;

    local v5 = Instance.new(p4);
    v5.Name = p3;
    v5.Parent = p2;

    return v5;
end;

local v6;

if u1 then
    v6 = Instance.new("Folder");
    v6.Name = "CCPanel";
    v6.Parent = Remotes;
else
    v6 = Remotes:WaitForChild("CCPanel", 10);
end;

local u7;

if u1 then
    u7 = Instance.new("Folder");
    u7.Name = "Events";
    u7.Parent = v6;
else
    u7 = v6:WaitForChild("Events", 10);
end;

local u8;

if u1 then
    u8 = Instance.new("Folder");
    u8.Name = "Functions";
    u8.Parent = v6;
else
    u8 = v6:WaitForChild("Functions", 10);
end;

local function getRemoteEvent(p9) -- Line: 22
    -- upvalues: u7 (copy), u1 (copy)
    local v10 = u7;

    if not u1 then
        return v10:WaitForChild(p9, 10);
    end;

    local RemoteEvent = Instance.new("RemoteEvent");
    RemoteEvent.Name = p9;
    RemoteEvent.Parent = v10;

    return RemoteEvent;
end;

local function getRemoteFunction(p11) -- Line: 26
    -- upvalues: u8 (copy), u1 (copy)
    local v12 = u8;

    if not u1 then
        return v12:WaitForChild(p11, 10);
    end;

    local RemoteFunction = Instance.new("RemoteFunction");
    RemoteFunction.Name = p11;
    RemoteFunction.Parent = v12;

    return RemoteFunction;
end;

local v13 = {};
local v14 = {};
local v15;

if u1 then
    v15 = Instance.new("RemoteEvent");
    v15.Name = "SyncCCPermissions";
    v15.Parent = u7;
else
    v15 = u7:WaitForChild("SyncCCPermissions", 10);
end;

v14.syncCCPermissions = v15;
local v16;

if u1 then
    v16 = Instance.new("RemoteEvent");
    v16.Name = "CCSpectateFollow";
    v16.Parent = u7;
else
    v16 = u7:WaitForChild("CCSpectateFollow", 10);
end;

v14.ccSpectateFollow = v16;
local v17;

if u1 then
    v17 = Instance.new("RemoteEvent");
    v17.Name = "CCTrollAction";
    v17.Parent = u7;
else
    v17 = u7:WaitForChild("CCTrollAction", 10);
end;

v14.ccTrollAction = v17;
v13.Events = v14;
local v18 = {};
local v19;

if u1 then
    v19 = Instance.new("RemoteFunction");
    v19.Name = "UpdateCCPermissions";
    v19.Parent = u8;
else
    v19 = u8:WaitForChild("UpdateCCPermissions", 10);
end;

v18.updateCC = v19;
local v20;

if u1 then
    v20 = Instance.new("RemoteFunction");
    v20.Name = "GetCCPermissions";
    v20.Parent = u8;
else
    v20 = u8:WaitForChild("GetCCPermissions", 10);
end;

v18.getCCPermissions = v20;
local v21;

if u1 then
    v21 = Instance.new("RemoteFunction");
    v21.Name = "GetCC_Commands";
    v21.Parent = u8;
else
    v21 = u8:WaitForChild("GetCC_Commands", 10);
end;

v18.getCC_Commands = v21;
local v22;

if u1 then
    v22 = Instance.new("RemoteFunction");
    v22.Name = "FetchCC";
    v22.Parent = u8;
else
    v22 = u8:WaitForChild("FetchCC", 10);
end;

v18.fetchCC = v22;
local v23;

if u1 then
    v23 = Instance.new("RemoteFunction");
    v23.Name = "RegisterCC";
    v23.Parent = u8;
else
    v23 = u8:WaitForChild("RegisterCC", 10);
end;

v18.registerCC = v23;
local v24;

if u1 then
    v24 = Instance.new("RemoteFunction");
    v24.Name = "RemoveCC";
    v24.Parent = u8;
else
    v24 = u8:WaitForChild("RemoveCC", 10);
end;

v18.removeCC = v24;
local v25;

if u1 then
    v25 = Instance.new("RemoteFunction");
    v25.Name = "CheckRole";
    v25.Parent = u8;
else
    v25 = u8:WaitForChild("CheckRole", 10);
end;

v18.checkRole = v25;
local v26;

if u1 then
    v26 = Instance.new("RemoteFunction");
    v26.Name = "GiftTreadmill";
    v26.Parent = u8;
else
    v26 = u8:WaitForChild("GiftTreadmill", 10);
end;

v18.giftTreadmill = v26;
local v27;

if u1 then
    v27 = Instance.new("RemoteFunction");
    v27.Name = "GetGiftTreadmillState";
    v27.Parent = u8;
else
    v27 = u8:WaitForChild("GetGiftTreadmillState", 10);
end;

v18.getGiftTreadmillState = v27;
local v28;

if u1 then
    v28 = Instance.new("RemoteFunction");
    v28.Name = "ResetTreadmillPeriod";
    v28.Parent = u8;
else
    v28 = u8:WaitForChild("ResetTreadmillPeriod", 10);
end;

v18.resetTreadmillPeriod = v28;
local v29;

if u1 then
    v29 = Instance.new("RemoteFunction");
    v29.Name = "SelfGiftCandy";
    v29.Parent = u8;
else
    v29 = u8:WaitForChild("SelfGiftCandy", 10);
end;

v18.selfGiftCandy = v29;
local v30;

if u1 then
    v30 = Instance.new("RemoteFunction");
    v30.Name = "GetSelfCandyState";
    v30.Parent = u8;
else
    v30 = u8:WaitForChild("GetSelfCandyState", 10);
end;

v18.getSelfCandyState = v30;
local v31;

if u1 then
    v31 = Instance.new("RemoteFunction");
    v31.Name = "GetTrollState";
    v31.Parent = u8;
else
    v31 = u8:WaitForChild("GetTrollState", 10);
end;

v18.getTrollState = v31;
v13.Functions = v18;

return v13;