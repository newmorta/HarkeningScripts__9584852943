-- Ruta Original: StarterPlayer.StarterPlayerScripts.UpdateCountdownClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local UpdateCountdownData = game:GetService("ReplicatedStorage"):WaitForChild("UpdateCountdownData", 15);

if not UpdateCountdownData then
    warn("[UpdateCountdownClient] UpdateCountdownData introuvable");

    return;
end;

local Value = UpdateCountdownData:WaitForChild("AA_Time").Value;
local Value2 = UpdateCountdownData:WaitForChild("Update_Time").Value;
local Value3 = UpdateCountdownData:WaitForChild("ShowThreshold").Value;
local Value4 = UpdateCountdownData:WaitForChild("ShowAA").Value;
local Value5 = UpdateCountdownData:WaitForChild("ShowUpdate").Value;

if Value == 0 and Value2 == 0 then
    return;
end;

local function formatTime(p1) -- Line: 31
    if p1 <= 0 then
        return "00:00:00";
    end;

    local v2 = math.floor(p1 / 3600);
    local v3 = math.floor(p1 % 3600 / 60);

    return string.format("%02d:%02d:%02d", v2, v3, p1 % 60);
end;

CollectionService:GetInstanceAddedSignal("MysteryCountdownAAClient"):Connect(function(p4) -- Line: 77
    -- upvalues: Value (copy), Value3 (copy)
    if p4:IsA("TextLabel") then
        local v5 = Value - os.time();

        if v5 > 0 and v5 <= Value3 then
            local v6;

            if v5 <= 0 then
                v6 = "00:00:00";
            else
                local v7 = math.floor(v5 / 3600);
                local v8 = math.floor(v5 % 3600 / 60);
                v6 = string.format("%02d:%02d:%02d", v7, v8, v5 % 60);
            end;

            p4.Text = "ADMIN ABUSE : " .. v6;

            return;
        end;

        p4.Text = "";
    end;
end);
CollectionService:GetInstanceAddedSignal("MysteryCountdownUpClient"):Connect(function(p9) -- Line: 88
    -- upvalues: Value2 (copy), Value4 (copy), Value (copy), Value3 (copy)
    if p9:IsA("TextLabel") then
        local v10 = os.time();
        local v11 = Value2 - v10;
        local v12;

        if Value4 then
            if Value <= v10 then
                v12 = v11 > 0;
            else
                v12 = false;
            end;
        elseif v11 > 0 then
            v12 = v11 <= Value3;
        else
            v12 = false;
        end;

        if v12 then
            local v13;

            if v11 <= 0 then
                v13 = "00:00:00";
            else
                local v14 = math.floor(v11 / 3600);
                local v15 = math.floor(v11 % 3600 / 60);
                v13 = string.format("%02d:%02d:%02d", v14, v15, v11 % 60);
            end;

            p9.Text = "UPDATE : " .. v13;

            return;
        end;

        p9.Text = "";
    end;
end);
local v16 = math.max(Value, Value2);

local function updateTagAA(p17) -- Line: 39
    -- upvalues: Value (copy), CollectionService (copy), Value3 (copy)
    local v18 = Value - os.time();

    for _, v in ipairs(CollectionService:GetTagged(p17)) do
        if v:IsA("TextLabel") then
            if v18 > 0 and v18 <= Value3 then
                local v19;

                if v18 <= 0 then
                    v19 = "00:00:00";
                else
                    local v20 = math.floor(v18 / 3600);
                    local v21 = math.floor(v18 % 3600 / 60);
                    v19 = string.format("%02d:%02d:%02d", v20, v21, v18 % 60);
                end;

                v.Text = "ADMIN ABUSE : " .. v19;
            else
                v.Text = "";
            end;
        end;
    end;
end;

local function updateTagUp(p22) -- Line: 52
    -- upvalues: Value2 (copy), Value4 (copy), Value (copy), Value3 (copy), CollectionService (copy)
    local v23 = os.time();
    local v24 = Value2 - v23;
    local v25;

    if Value4 then
        if Value <= v23 then
            v25 = v24 > 0;
        else
            v25 = false;
        end;
    elseif v24 > 0 then
        v25 = v24 <= Value3;
    else
        v25 = false;
    end;

    for _, v in ipairs(CollectionService:GetTagged(p22)) do
        if v:IsA("TextLabel") then
            if v25 then
                local v26;

                if v24 <= 0 then
                    v26 = "00:00:00";
                else
                    local v27 = math.floor(v24 / 3600);
                    local v28 = math.floor(v24 % 3600 / 60);
                    v26 = string.format("%02d:%02d:%02d", v27, v28, v24 % 60);
                end;

                v.Text = "UPDATE : " .. v26;
            elseif not CollectionService:HasTag(v, "MysteryCountdownAAClient") then
                v.Text = "";
            end;
        end;
    end;
end;

while true do
    if Value4 then
        updateTagAA("MysteryCountdownAAClient");
    end;

    if Value5 then
        updateTagUp("MysteryCountdownUpClient");
    end;

    if v16 <= os.time() then
        if Value4 then
            updateTagAA("MysteryCountdownAAClient");
        end;

        if not Value5 then
            return;
        end;

        updateTagUp("MysteryCountdownUpClient");

        return;
    end;

    task.wait(1);
end;