-- Ruta Original: ReplicatedStorage.UISystems.MedalUISystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local MedalQuest = require(ReplicatedStorage:WaitForChild("FeatureConfigs"):WaitForChild("MedalQuest"));
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local v1 = {};
local u2 = false;
local u3 = Color3.fromRGB(60, 200, 80);
local u4 = Color3.fromRGB(100, 100, 100);

local function getTagged(p5) -- Line: 22
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged(p5)) do
        if v:IsDescendantOf(PlayerGui) then
            return v;
        end;
    end;

    return nil;
end;

local function sanitizeName(p6) -- Line: 31
    if type(p6) ~= "string" then
        return tostring(p6 or "");
    end;

    local v7 = p6:gsub("https?://[^%s<>&\"]+", ""):gsub("[Mm]edal%.tv", "Medal");

    return v7:match("^%s*(.-)%s*$") or v7;
end;

local function buildRequirementsText(p8) -- Line: 39
    -- upvalues: MedalQuest (copy)
    print(p8);

    if not p8 or #p8 == 0 then
        return "<font color=\'#aaaaaa\'>No active Medal quest.</font>";
    end;

    local v9 = p8[1];
    local v10 = {};

    if v9.requirements then
        for i, v in ipairs(v9.requirements) do
            local v11 = v.completed and "#00c850" or "#ff4444";
            local v12 = v.completed and "✓" or "✗";
            local v13 = MedalQuest.REQUIREMENTS and MedalQuest.REQUIREMENTS[i];

            if not v13 then
                local name = v.name;

                if type(name) == "string" then
                    local v14 = name:gsub("https?://[^%s<>&\"]+", ""):gsub("[Mm]edal%.tv", "Medal");
                    v13 = v14:match("^%s*(.-)%s*$") or v14;
                else
                    v13 = tostring(name or "");
                end;
            end;

            local v15 = (v.completed or v.requiredCount <= 1) and "" or string.format(" <font color=\'#aaaaaa\'>(%d/%d)</font>", v.completedCount, v.requiredCount);
            table.insert(v10, string.format("<font color=\'%s\'><b>%s</b> %s</font>%s", v11, v12, v13, v15));
        end;
    else
        local v16 = v9.completed and "#00c850" or "#ff4444";
        local v17 = v9.completed and "✓" or "✗";
        local format = string.format;
        local name = v9.name;
        local v18;

        if type(name) == "string" then
            local v19 = name:gsub("https?://[^%s<>&\"]+", ""):gsub("[Mm]edal%.tv", "Medal");
            v18 = v19:match("^%s*(.-)%s*$") or v19;
        else
            v18 = tostring(name or "");
        end;

        table.insert(v10, format("<font color=\'%s\'><b>%s</b> %s</font>", v16, v17, v18));
    end;

    return table.concat(v10, "\n");
end;

local function setClaimButton(p20, p21) -- Line: 69
    -- upvalues: u3 (copy), u4 (copy)
    if not p20 then
        return;
    end;

    p20.BackgroundColor3 = p21 and u3 or u4;
    p20.Active = p21;
end;

local function refreshUI() -- Line: 75
    -- upvalues: getTagged (copy), ClientState (copy), u4 (copy), Remotes (copy), buildRequirementsText (copy), u3 (copy)
    local v22 = getTagged("MedalRequirements");
    local v23 = getTagged("MedalQuestClaimButton");
    local v24 = ClientState:Get().OwnedAuras or {};

    if table.find(v24, "MedalAura") then
        if v22 then
            v22.Text = "<font color=\'#00c850\'><b>✓ Medal Aura already obtained!</b></font>";
        end;

        if not v23 then
            return;
        end;

        v23.BackgroundColor3 = u4;
        v23.Active = false;

        return;
    end;

    if v22 then
        v22.Text = "<font color=\'#aaaaaa\'>Loading...</font>";
    end;

    if v23 then
        v23.BackgroundColor3 = u4;
        v23.Active = false;
    end;

    local v25 = Remotes.GetMedalQuestData:InvokeServer();

    if not v25 then
        if v22 then
            v22.Text = "<font color=\'#ff4444\'>Unable to contact Medal.\nEnable HTTP in Game Settings &gt; Security.</font>";
        end;

        return;
    end;

    if not v25.hasMedalUser then
        if v22 then
            v22.Text = "<font color=\'#ffaa00\'>Medal account not linked.\nVisit Medal to connect your Roblox account.</font>";
        end;

        return;
    end;

    local v26 = v25.quests and v25.quests[1];

    if not v26 then
        if v22 then
            v22.Text = "<font color=\'#aaaaaa\'>No Medal quest found.</font>";
        end;

        return;
    end;

    if v22 then
        v22.Text = buildRequirementsText(v25.quests);
    end;

    local completed = v26.completed;

    if not v23 then
        return;
    end;

    v23.BackgroundColor3 = completed and u3 or u4;
    v23.Active = completed;
end;

function v1.InitLogic(p27) -- Line: 130
    -- upvalues: u2 (ref), getTagged (copy), ClientState (copy), CollectionService (copy), u4 (copy), Remotes (copy), refreshUI (copy)
    if u2 then
        return;
    end;

    u2 = true;

    local function connectClose(p28) -- Line: 134
        -- upvalues: getTagged (ref), ClientState (ref)
        if p28:GetAttribute("_MedalCloseConnected") then
            return;
        end;

        p28:SetAttribute("_MedalCloseConnected", true);
        p28.MouseButton1Click:Connect(function() -- Line: 137
            -- upvalues: getTagged (ref), ClientState (ref)
            local v29 = getTagged("MedalQuestModal");

            if v29 and ClientState.ActiveModal ~= v29 then
                v29.Visible = false;

                return;
            end;

            ClientState:CloseCurrentModal();
        end);
    end;

    for _, v in ipairs(CollectionService:GetTagged("MedalQuestCloseButton")) do
        if not v:GetAttribute("_MedalCloseConnected") then
            v:SetAttribute("_MedalCloseConnected", true);
            v.MouseButton1Click:Connect(function() -- Line: 137
                -- upvalues: getTagged (ref), ClientState (ref)
                local v30 = getTagged("MedalQuestModal");

                if v30 and ClientState.ActiveModal ~= v30 then
                    v30.Visible = false;

                    return;
                end;

                ClientState:CloseCurrentModal();
            end);
        end;
    end;

    CollectionService:GetInstanceAddedSignal("MedalQuestCloseButton"):Connect(connectClose);

    local function connectClaim(u31) -- Line: 153
        -- upvalues: u4 (ref), Remotes (ref), ClientState (ref), getTagged (ref), refreshUI (ref)
        if u31:GetAttribute("_MedalClaimConnected") then
            return;
        end;

        u31:SetAttribute("_MedalClaimConnected", true);

        if u31 then
            u31.BackgroundColor3 = u4;
            u31.Active = false;
        end;

        u31.MouseButton1Click:Connect(function() -- Line: 157
            -- upvalues: u31 (copy), u4 (ref), Remotes (ref), ClientState (ref), getTagged (ref), refreshUI (ref)
            if not u31.Active then
                return;
            end;

            local v32 = u31;

            if v32 then
                v32.BackgroundColor3 = u4;
                v32.Active = false;
            end;

            local v33, v34 = Remotes.BuyAura:InvokeServer("MedalAura", "Medal");

            if v33 then
                local v35 = ClientState:Get().OwnedAuras or {};

                if not table.find(v35, "MedalAura") then
                    table.insert(v35, "MedalAura");
                    ClientState:Update({
                        OwnedAuras = v35
                    });
                end;
            else
                warn("[MedalUISystem] Claim failed:", (tostring(v34)));
                local v36 = getTagged("MedalRequirements");

                if v36 then
                    v36.Text = string.format("<font color=\'#ff4444\'>Claim failed: %s</font>", (tostring(v34)));
                end;
            end;

            refreshUI();
        end);
    end;

    for _, v in ipairs(CollectionService:GetTagged("MedalQuestClaimButton")) do
        connectClaim(v);
    end;

    CollectionService:GetInstanceAddedSignal("MedalQuestClaimButton"):Connect(connectClaim);
end;

function v1.Open(p37) -- Line: 189
    -- upvalues: refreshUI (copy)
    task.spawn(refreshUI);
end;

function v1.OnClose(p38) -- Line: 193
end;

return v1;