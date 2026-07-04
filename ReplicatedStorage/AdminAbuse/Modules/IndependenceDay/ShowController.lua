-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.IndependenceDay.ShowController
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local IndependenceDayConfig = require(script.Parent.IndependenceDayConfig);
local u1 = {};
local u2 = nil;

local function getSortedBeams(p3) -- Line: 30
    local v4 = p3:FindFirstChild("Scriptables") and v4:FindFirstChild("Beams");

    if not v4 then
        warn("[ShowController.getSortedBeams - Scriptables/Beams not found]");

        return {};
    end;

    local v5 = {};

    for _, child in v4:GetChildren() do
        local v6 = child:FindFirstChildWhichIsA("Beam", true);

        if v6 then
            local v7 = child:GetAttribute("Order");

            if v7 == nil then
                warn("[ShowController - missing Order attribute on]", child:GetFullName());
            end;

            table.insert(v5, {
                beam = v6,
                order = v7 or (1 / 0)
            });
        else
            warn("[ShowController - no Beam instance found under]", child:GetFullName());
        end;
    end;

    table.sort(v5, function(p8, p9) -- Line: 54
        return p8.order < p9.order;
    end);
    local v10 = {};

    for _, v in v5 do
        table.insert(v10, v.beam);
    end;

    return v10;
end;

function u1.RunSequential(p11) -- Line: 67
    -- upvalues: u1 (copy), getSortedBeams (copy), u2 (ref), IndependenceDayConfig (copy)
    if not p11 then
        warn("[ShowController.RunSequential - Missing mapClone arg]");

        return;
    end;

    u1.Stop();
    local u12 = getSortedBeams(p11);

    if #u12 == 0 then
        warn("[ShowController.RunSequential - No beams found]");

        return;
    end;

    for _, v in u12 do
        v.Enabled = false;
    end;

    u2 = task.spawn(function() -- Line: 85
        -- upvalues: u12 (copy), IndependenceDayConfig (ref), u2 (ref)
        while true do
            for _, v in u12 do
                v.Enabled = true;
                task.wait(IndependenceDayConfig.BEAM_STEP_INTERVAL);
            end;

            task.wait(IndependenceDayConfig.BEAM_HOLD_SEC);

            if IndependenceDayConfig.BEAM_LOOP then
                for i = #u12, 1, -1 do
                    u12[i].Enabled = false;
                    task.wait(IndependenceDayConfig.BEAM_STEP_INTERVAL);
                end;
            end;

            if not IndependenceDayConfig.BEAM_LOOP then
                u2 = nil;

                return;
            end;
        end;
    end);
end;

function u1.Stop() -- Line: 106
    -- upvalues: u2 (ref)
    if u2 then
        task.cancel(u2);
        u2 = nil;
    end;
end;

return u1;