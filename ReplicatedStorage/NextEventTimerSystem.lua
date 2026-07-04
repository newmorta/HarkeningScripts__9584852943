-- Ruta Original: ReplicatedStorage.NextEventTimerSystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local EventsConfig = require(ReplicatedStorage:WaitForChild("EventsConfig"));
local v1 = {};
local u2 = false;
local u3 = false;
local u4 = false;

local function getActiveEvent() -- Line: 31
    -- upvalues: EventsConfig (copy)
    local v5 = os.time();
    local v6 = nil;

    for _, v in ipairs(EventsConfig.Events) do
        if v.Start <= v5 and (v5 < v.End and (not v6 or v.Start > v6.Start)) then
            v6 = v;
        end;
    end;

    return v6;
end;

local function getNextEvent() -- Line: 44
    -- upvalues: EventsConfig (copy)
    local v7 = os.time();
    local v8 = nil;

    for _, v in ipairs(EventsConfig.Events) do
        if v7 < v.Start and (not v8 or v.Start < v8.Start) then
            v8 = v;
        end;
    end;

    return v8;
end;

local function getState() -- Line: 57
    -- upvalues: getNextEvent (copy)
    local v9 = os.time();
    local v10 = getNextEvent();
    local v11 = v10 and (v10.Start - v9 or (1 / 0)) or (1 / 0);
    local v12;

    if v11 > 0 then
        v12 = v11 <= 172800;
    else
        v12 = false;
    end;

    return v12, v11, v10;
end;

local function formatCountdown(p13) -- Line: 65
    local v14 = math.floor(p13);
    local v15 = math.max(0, v14);
    local v16 = math.floor(v15 / 3600);
    local v17 = math.floor(v15 % 3600 / 60);

    return string.format("%02dh %02dm %02ds", v16, v17, v15 % 60);
end;

local function initInstance(p18, p19) -- Line: 74
    -- upvalues: getActiveEvent (copy), getNextEvent (copy)
    if p18 == "EventWall" then
        local v20 = getActiveEvent() ~= nil;
        p19.Transparency = v20 and 1 or 0;
        p19.CanCollide = not v20;

        return;
    end;

    local v21 = os.time();
    local v22 = getNextEvent();
    local v23 = v22 and v22.Start - v21 or (1 / 0);
    local v24;

    if v23 > 0 then
        v24 = v23 <= 172800;
    else
        v24 = false;
    end;

    if p19:IsA("BasePart") then
        p19.Transparency = v24 and 0 or 1;

        return;
    end;

    if p19:IsA("TextLabel") or p19:IsA("TextButton") then
        p19.Visible = v24;
    end;
end;

local function doFadeOut() -- Line: 89
    -- upvalues: u2 (ref), CollectionService (copy), TweenService (copy)
    u2 = true;

    for _, v in ipairs(CollectionService:GetTagged("NextEventTimer")) do
        v.Visible = false;
    end;

    for _, v in ipairs(CollectionService:GetTagged("NextEventTimer2")) do
        v.Visible = false;
    end;

    local v25 = CollectionService:GetTagged("NextEventPart");

    if #v25 == 0 then
        u2 = false;

        return;
    end;

    local v26 = TweenInfo.new(1.5, Enum.EasingStyle.Sine);
    local u27 = #v25;

    for _, v in ipairs(v25) do
        local v28 = TweenService:Create(v, v26, {
            Transparency = 1
        });
        v28.Completed:Connect(function() -- Line: 110
            -- upvalues: u27 (ref), u2 (ref)
            u27 = u27 - 1;

            if u27 <= 0 then
                u2 = false;
            end;
        end);
        v28:Play();
    end;
end;

function v1.Init(p29) -- Line: 124
    -- upvalues: CollectionService (copy), getNextEvent (copy), getActiveEvent (copy), u3 (ref), u2 (ref), doFadeOut (copy), u4 (ref)
    CollectionService:GetInstanceAddedSignal("NextEventPart"):Connect(function(p30) -- Line: 126
        -- upvalues: getNextEvent (ref)
        local v31 = os.time();
        local v32 = getNextEvent();
        local v33 = v32 and v32.Start - v31 or (1 / 0);
        local v34;

        if v33 > 0 then
            v34 = v33 <= 172800;
        else
            v34 = false;
        end;

        if p30:IsA("BasePart") then
            p30.Transparency = v34 and 0 or 1;

            return;
        end;

        if p30:IsA("TextLabel") or p30:IsA("TextButton") then
            p30.Visible = v34;
        end;
    end);
    CollectionService:GetInstanceAddedSignal("NextEventTimer"):Connect(function(p35) -- Line: 127
        -- upvalues: getNextEvent (ref)
        local v36 = os.time();
        local v37 = getNextEvent();
        local v38 = v37 and v37.Start - v36 or (1 / 0);
        local v39;

        if v38 > 0 then
            v39 = v38 <= 172800;
        else
            v39 = false;
        end;

        if p35:IsA("BasePart") then
            p35.Transparency = v39 and 0 or 1;

            return;
        end;

        if p35:IsA("TextLabel") or p35:IsA("TextButton") then
            p35.Visible = v39;
        end;
    end);
    CollectionService:GetInstanceAddedSignal("NextEventTimer2"):Connect(function(p40) -- Line: 128
        -- upvalues: getNextEvent (ref)
        local v41 = os.time();
        local v42 = getNextEvent();
        local v43 = v42 and v42.Start - v41 or (1 / 0);
        local v44;

        if v43 > 0 then
            v44 = v43 <= 172800;
        else
            v44 = false;
        end;

        if p40:IsA("BasePart") then
            p40.Transparency = v44 and 0 or 1;

            return;
        end;

        if p40:IsA("TextLabel") or p40:IsA("TextButton") then
            p40.Visible = v44;
        end;
    end);
    CollectionService:GetInstanceAddedSignal("EventWall"):Connect(function(p45) -- Line: 129
        -- upvalues: getActiveEvent (ref)
        local v46 = getActiveEvent() ~= nil;
        p45.Transparency = v46 and 1 or 0;
        p45.CanCollide = not v46;
    end);
    task.spawn(function() -- Line: 131
        -- upvalues: getNextEvent (ref), u3 (ref), u2 (ref), doFadeOut (ref), CollectionService (ref), getActiveEvent (ref), u4 (ref)
        while true do
            local v47 = os.time();
            local v48 = getNextEvent();
            local v49 = v48 and (v48.Start - v47 or (1 / 0)) or (1 / 0);
            local v50;

            if v49 > 0 then
                v50 = v49 <= 172800;
            else
                v50 = false;
            end;

            if u3 and not (v50 or u2) then
                doFadeOut();
            elseif not u2 then
                for _, v in ipairs(CollectionService:GetTagged("NextEventPart")) do
                    local v51 = v50 and 0 or 1;

                    if v.Transparency ~= v51 then
                        v.Transparency = v51;
                    end;
                end;

                local v52 = getActiveEvent();

                for _, v in ipairs(CollectionService:GetTagged("NextEventTimer")) do
                    if v50 then
                        v.Visible = true;
                        local v53 = v48 and (v48.Label or (v48.Name or "")) or "";
                        local v54 = math.floor(v49);
                        local v55 = math.max(0, v54);
                        local v56 = math.floor(v55 / 3600);
                        local v57 = math.floor(v55 % 3600 / 60);
                        v.Text = v53 .. "\n" .. string.format("%02dh %02dm %02ds", v56, v57, v55 % 60);
                    elseif v52 then
                        v.Visible = true;
                        v.Text = "Happy " .. (v52.Label or v52.Name);
                    elseif v.Visible then
                        v.Visible = false;
                    end;
                end;

                for _, v in ipairs(CollectionService:GetTagged("NextEventTimer2")) do
                    if v50 then
                        v.Visible = true;
                        local v58 = math.floor(v49);
                        local v59 = math.max(0, v58);
                        local v60 = math.floor(v59 / 3600);
                        local v61 = math.floor(v59 % 3600 / 60);
                        v.Text = string.format("%02dh %02dm %02ds", v60, v61, v59 % 60);
                    elseif v.Visible then
                        v.Visible = false;
                    end;
                end;
            end;

            local v62 = getActiveEvent() ~= nil;

            if v62 ~= u4 then
                u4 = v62;

                for _, v in ipairs(CollectionService:GetTagged("EventWall")) do
                    v.Transparency = v62 and 1 or 0;
                    v.CanCollide = not v62;
                end;
            end;

            u3 = v50;
            task.wait(1);
        end;
    end);
end;

return v1;